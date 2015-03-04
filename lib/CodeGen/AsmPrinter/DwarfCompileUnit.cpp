#include "DwarfCompileUnit.h"
#include "DwarfExpression.h"
#include "llvm/CodeGen/MachineFunction.h"
#include "llvm/IR/DataLayout.h"
#include "llvm/IR/GlobalValue.h"
#include "llvm/IR/GlobalVariable.h"
#include "llvm/IR/Instruction.h"
#include "llvm/MC/MCAsmInfo.h"
#include "llvm/MC/MCStreamer.h"
#include "llvm/Target/TargetFrameLowering.h"
#include "llvm/Target/TargetLoweringObjectFile.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Target/TargetRegisterInfo.h"
#include "llvm/Target/TargetSubtargetInfo.h"

namespace llvm {

DwarfCompileUnit::DwarfCompileUnit(unsigned UID, DICompileUnit Node,
                                   AsmPrinter *A, DwarfDebug *DW,
                                   DwarfFile *DWU)
    : DwarfUnit(UID, dwarf::DW_TAG_compile_unit, Node, A, DW, DWU),
      Skeleton(nullptr), LabelBegin(nullptr), BaseAddress(nullptr) {
  insertDIE(Node, &getUnitDie());
}

/// addLabelAddress - Add a dwarf label attribute data and value using
/// DW_FORM_addr or DW_FORM_GNU_addr_index.
///
void DwarfCompileUnit::addLabelAddress(DIE &Die, dwarf::Attribute Attribute,
                                       const MCSymbol *Label) {

  // Don't use the address pool in non-fission or in the skeleton unit itself.
  // FIXME: Once GDB supports this, it's probably worthwhile using the address
  // pool from the skeleton - maybe even in non-fission (possibly fewer
  // relocations by sharing them in the pool, but we have other ideas about how
  // to reduce the number of relocations as well/instead).
  if (!DD->useSplitDwarf() || !Skeleton)
    return addLocalLabelAddress(Die, Attribute, Label);

  if (Label)
    DD->addArangeLabel(SymbolCU(this, Label));

  unsigned idx = DD->getAddressPool().getIndex(Label);
  DIEValue *Value = new (DIEValueAllocator) DIEInteger(idx);
  Die.addValue(Attribute, dwarf::DW_FORM_GNU_addr_index, Value);
}

void DwarfCompileUnit::addLocalLabelAddress(DIE &Die,
                                            dwarf::Attribute Attribute,
                                            const MCSymbol *Label) {
  if (Label)
    DD->addArangeLabel(SymbolCU(this, Label));

  Die.addValue(Attribute, dwarf::DW_FORM_addr,
               Label ? (DIEValue *)new (DIEValueAllocator) DIELabel(Label)
                     : new (DIEValueAllocator) DIEInteger(0));
}

unsigned DwarfCompileUnit::getOrCreateSourceID(StringRef FileName,
                                               StringRef DirName) {
  // If we print assembly, we can't separate .file entries according to
  // compile units. Thus all files will belong to the default compile unit.

  // FIXME: add a better feature test than hasRawTextSupport. Even better,
  // extend .file to support this.
  return Asm->OutStreamer.EmitDwarfFileDirective(
      0, DirName, FileName,
      Asm->OutStreamer.hasRawTextSupport() ? 0 : getUniqueID());
}

// Return const expression if value is a GEP to access merged global
// constant. e.g.
// i8* getelementptr ({ i8, i8, i8, i8 }* @_MergedGlobals, i32 0, i32 0)
static const ConstantExpr *getMergedGlobalExpr(const Value *V) {
  const ConstantExpr *CE = dyn_cast_or_null<ConstantExpr>(V);
  if (!CE || CE->getNumOperands() != 3 ||
      CE->getOpcode() != Instruction::GetElementPtr)
    return nullptr;

  // First operand points to a global struct.
  Value *Ptr = CE->getOperand(0);
  if (!isa<GlobalValue>(Ptr) ||
      !isa<StructType>(cast<PointerType>(Ptr->getType())->getElementType()))
    return nullptr;

  // Second operand is zero.
  const ConstantInt *CI = dyn_cast_or_null<ConstantInt>(CE->getOperand(1));
  if (!CI || !CI->isZero())
    return nullptr;

  // Third operand is offset.
  if (!isa<ConstantInt>(CE->getOperand(2)))
    return nullptr;

  return CE;
}

/// getOrCreateGlobalVariableDIE - get or create global variable DIE.
DIE *DwarfCompileUnit::getOrCreateGlobalVariableDIE(DIGlobalVariable GV) {
  // Check for pre-existence.
  if (DIE *Die = getDIE(GV))
    return Die;

  assert(GV.isGlobalVariable());

  DIScope GVContext = GV.getContext();
  DIType GTy = DD->resolve(GV.getType());

  // Construct the context before querying for the existence of the DIE in
  // case such construction creates the DIE.
  DIE *ContextDIE = getOrCreateContextDIE(GVContext);

  // Add to map.
  DIE *VariableDIE = &createAndAddDIE(GV.getTag(), *ContextDIE, GV);
  DIScope DeclContext;

  if (DIDerivedType SDMDecl = GV.getStaticDataMemberDeclaration()) {
    DeclContext = resolve(SDMDecl.getContext());
    assert(SDMDecl.isStaticMember() && "Expected static member decl");
    assert(GV.isDefinition());
    // We need the declaration DIE that is in the static member's class.
    DIE *VariableSpecDIE = getOrCreateStaticMemberDIE(SDMDecl);
    addDIEEntry(*VariableDIE, dwarf::DW_AT_specification, *VariableSpecDIE);
  } else {
    DeclContext = GV.getContext();
    // Add name and type.
    addString(*VariableDIE, dwarf::DW_AT_name, GV.getDisplayName());
    addType(*VariableDIE, GTy);

    // Add scoping info.
    if (!GV.isLocalToUnit())
      addFlag(*VariableDIE, dwarf::DW_AT_external);

    // Add line number info.
    addSourceLine(*VariableDIE, GV);
  }

  if (!GV.isDefinition())
    addFlag(*VariableDIE, dwarf::DW_AT_declaration);

  // Add location.
  bool addToAccelTable = false;
  bool isGlobalVariable = GV.getGlobal() != nullptr;
  if (isGlobalVariable) {
    addToAccelTable = true;
    DIELoc *Loc = new (DIEValueAllocator) DIELoc();
    const MCSymbol *Sym = Asm->getSymbol(GV.getGlobal());
    if (GV.getGlobal()->isThreadLocal()) {
      // FIXME: Make this work with -gsplit-dwarf.
      unsigned PointerSize = Asm->getDataLayout().getPointerSize();
      assert((PointerSize == 4 || PointerSize == 8) &&
             "Add support for other sizes if necessary");
      // Based on GCC's support for TLS:
      if (!DD->useSplitDwarf()) {
        // 1) Start with a constNu of the appropriate pointer size
        addUInt(*Loc, dwarf::DW_FORM_data1,
                PointerSize == 4 ? dwarf::DW_OP_const4u : dwarf::DW_OP_const8u);
        // 2) containing the (relocated) offset of the TLS variable
        //    within the module's TLS block.
        addExpr(*Loc, dwarf::DW_FORM_udata,
                Asm->getObjFileLowering().getDebugThreadLocalSymbol(Sym));
      } else {
        addUInt(*Loc, dwarf::DW_FORM_data1, dwarf::DW_OP_GNU_const_index);
        addUInt(*Loc, dwarf::DW_FORM_udata,
                DD->getAddressPool().getIndex(Sym, /* TLS */ true));
      }
      // 3) followed by an OP to make the debugger do a TLS lookup.
      addUInt(*Loc, dwarf::DW_FORM_data1,
              DD->useGNUTLSOpcode() ? dwarf::DW_OP_GNU_push_tls_address
                                    : dwarf::DW_OP_form_tls_address);
    } else {
      DD->addArangeLabel(SymbolCU(this, Sym));
      addOpAddress(*Loc, Sym);
    }

    addBlock(*VariableDIE, dwarf::DW_AT_location, Loc);
    // Add the linkage name.
    StringRef LinkageName = GV.getLinkageName();
    if (!LinkageName.empty())
      // From DWARF4: DIEs to which DW_AT_linkage_name may apply include:
      // TAG_common_block, TAG_constant, TAG_entry_point, TAG_subprogram and
      // TAG_variable.
      addString(*VariableDIE,
                DD->getDwarfVersion() >= 4 ? dwarf::DW_AT_linkage_name
                                           : dwarf::DW_AT_MIPS_linkage_name,
                GlobalValue::getRealLinkageName(LinkageName));
  } else if (const ConstantInt *CI =
                 dyn_cast_or_null<ConstantInt>(GV.getConstant())) {
    addConstantValue(*VariableDIE, CI, GTy);
  } else if (const ConstantExpr *CE = getMergedGlobalExpr(GV.getConstant())) {
    addToAccelTable = true;
    // GV is a merged global.
    DIELoc *Loc = new (DIEValueAllocator) DIELoc();
    Value *Ptr = CE->getOperand(0);
    MCSymbol *Sym = Asm->getSymbol(cast<GlobalValue>(Ptr));
    DD->addArangeLabel(SymbolCU(this, Sym));
    addOpAddress(*Loc, Sym);
    addUInt(*Loc, dwarf::DW_FORM_data1, dwarf::DW_OP_constu);
    SmallVector<Value *, 3> Idx(CE->op_begin() + 1, CE->op_end());
    addUInt(*Loc, dwarf::DW_FORM_udata,
            Asm->getDataLayout().getIndexedOffset(Ptr->getType(), Idx));
    addUInt(*Loc, dwarf::DW_FORM_data1, dwarf::DW_OP_plus);
    addBlock(*VariableDIE, dwarf::DW_AT_location, Loc);
  }

  if (addToAccelTable) {
    DD->addAccelName(GV.getName(), *VariableDIE);

    // If the linkage name is different than the name, go ahead and output
    // that as well into the name table.
    if (GV.getLinkageName() != "" && GV.getName() != GV.getLinkageName())
      DD->addAccelName(GV.getLinkageName(), *VariableDIE);
  }

  addGlobalName(GV.getName(), *VariableDIE, DeclContext);
  return VariableDIE;
}

void DwarfCompileUnit::addRange(RangeSpan Range) {
  bool SameAsPrevCU = this == DD->getPrevCU();
  DD->setPrevCU(this);
  // If we have no current ranges just add the range and return, otherwise,
  // check the current section and CU against the previous section and CU we
  // emitted into and the subprogram was contained within. If these are the
  // same then extend our current range, otherwise add this as a new range.
  if (CURanges.empty() || !SameAsPrevCU ||
      (&CURanges.back().getEnd()->getSection() !=
       &Range.getEnd()->getSection())) {
    CURanges.push_back(Range);
    return;
  }

  CURanges.back().setEnd(Range.getEnd());
}

void DwarfCompileUnit::addSectionLabel(DIE &Die, dwarf::Attribute Attribute,
                                       const MCSymbol *Label,
                                       const MCSymbol *Sec) {
  if (Asm->MAI->doesDwarfUseRelocationsAcrossSections())
    addLabel(Die, Attribute,
             DD->getDwarfVersion() >= 4 ? dwarf::DW_FORM_sec_offset
                                        : dwarf::DW_FORM_data4,
             Label);
  else
    addSectionDelta(Die, Attribute, Label, Sec);
}

void DwarfCompileUnit::initStmtList(MCSymbol *DwarfLineSectionSym) {
  // Define start line table label for each Compile Unit.
  MCSymbol *LineTableStartSym =
      Asm->OutStreamer.getDwarfLineTableSymbol(getUniqueID());

  stmtListIndex = UnitDie.getValues().size();

  // DW_AT_stmt_list is a offset of line number information for this
  // compile unit in debug_line section. For split dwarf this is
  // left in the skeleton CU and so not included.
  // The line table entries are not always emitted in assembly, so it
  // is not okay to use line_table_start here.
  addSectionLabel(UnitDie, dwarf::DW_AT_stmt_list, LineTableStartSym,
                  DwarfLineSectionSym);
}

void DwarfCompileUnit::applyStmtList(DIE &D) {
  D.addValue(dwarf::DW_AT_stmt_list,
             UnitDie.getAbbrev().getData()[stmtListIndex].getForm(),
             UnitDie.getValues()[stmtListIndex]);
}

void DwarfCompileUnit::attachLowHighPC(DIE &D, const MCSymbol *Begin,
                                       const MCSymbol *End) {
  assert(Begin && "Begin label should not be null!");
  assert(End && "End label should not be null!");
  assert(Begin->isDefined() && "Invalid starting label");
  assert(End->isDefined() && "Invalid end label");

  addLabelAddress(D, dwarf::DW_AT_low_pc, Begin);
  if (DD->getDwarfVersion() < 4)
    addLabelAddress(D, dwarf::DW_AT_high_pc, End);
  else
    addLabelDelta(D, dwarf::DW_AT_high_pc, End, Begin);
}

// Find DIE for the given subprogram and attach appropriate DW_AT_low_pc
// and DW_AT_high_pc attributes. If there are global variables in this
// scope then create and insert DIEs for these variables.
DIE &DwarfCompileUnit::updateSubprogramScopeDIE(DISubprogram SP) {
  DIE *SPDie = getOrCreateSubprogramDIE(SP, includeMinimalInlineScopes());

  attachLowHighPC(*SPDie, DD->getFunctionBeginSym(), DD->getFunctionEndSym());
  if (!DD->getCurrentFunction()->getTarget().Options.DisableFramePointerElim(
          *DD->getCurrentFunction()))
    addFlag(*SPDie, dwarf::DW_AT_APPLE_omit_frame_ptr);

  // Only include DW_AT_frame_base in full debug info
  if (!includeMinimalInlineScopes()) {
    const TargetRegisterInfo *RI = Asm->MF->getSubtarget().getRegisterInfo();
    MachineLocation Location(RI->getFrameRegister(*Asm->MF));
    if (RI->isPhysicalRegister(Location.getReg()))
      addAddress(*SPDie, dwarf::DW_AT_frame_base, Location);
  }

  // Add name to the name table, we do this here because we're guaranteed
  // to have concrete versions of our DW_TAG_subprogram nodes.
  DD->addSubprogramNames(SP, *SPDie);

  return *SPDie;
}

// Construct a DIE for this scope.
void DwarfCompileUnit::constructScopeDIE(
    LexicalScope *Scope, SmallVectorImpl<std::unique_ptr<DIE>> &FinalChildren) {
  if (!Scope || !Scope->getScopeNode())
    return;

  DIScope DS(Scope->getScopeNode());

  assert((Scope->getInlinedAt() || !DS.isSubprogram()) &&
         "Only handle inlined subprograms here, use "
         "constructSubprogramScopeDIE for non-inlined "
         "subprograms");

  SmallVector<std::unique_ptr<DIE>, 8> Children;

  // We try to create the scope DIE first, then the children DIEs. This will
  // avoid creating un-used children then removing them later when we find out
  // the scope DIE is null.
  std::unique_ptr<DIE> ScopeDIE;
  if (Scope->getParent() && DS.isSubprogram()) {
    ScopeDIE = constructInlinedScopeDIE(Scope);
    if (!ScopeDIE)
      return;
    // We create children when the scope DIE is not null.
    createScopeChildrenDIE(Scope, Children);
  } else {
    // Early exit when we know the scope DIE is going to be null.
    if (DD->isLexicalScopeDIENull(Scope))
      return;

    unsigned ChildScopeCount;

    // We create children here when we know the scope DIE is not going to be
    // null and the children will be added to the scope DIE.
    createScopeChildrenDIE(Scope, Children, &ChildScopeCount);

    // Skip imported directives in gmlt-like data.
    if (!includeMinimalInlineScopes()) {
      // There is no need to emit empty lexical block DIE.
      for (const auto &E : DD->findImportedEntitiesForScope(DS))
        Children.push_back(
            constructImportedEntityDIE(DIImportedEntity(E.second)));
    }

    // If there are only other scopes as children, put them directly in the
    // parent instead, as this scope would serve no purpose.
    if (Children.size() == ChildScopeCount) {
      FinalChildren.insert(FinalChildren.end(),
                           std::make_move_iterator(Children.begin()),
                           std::make_move_iterator(Children.end()));
      return;
    }
    ScopeDIE = constructLexicalScopeDIE(Scope);
    assert(ScopeDIE && "Scope DIE should not be null.");
  }

  // Add children
  for (auto &I : Children)
    ScopeDIE->addChild(std::move(I));

  FinalChildren.push_back(std::move(ScopeDIE));
}

void DwarfCompileUnit::addSectionDelta(DIE &Die, dwarf::Attribute Attribute,
                                       const MCSymbol *Hi, const MCSymbol *Lo) {
  DIEValue *Value = new (DIEValueAllocator) DIEDelta(Hi, Lo);
  Die.addValue(Attribute, DD->getDwarfVersion() >= 4 ? dwarf::DW_FORM_sec_offset
                                                     : dwarf::DW_FORM_data4,
               Value);
}

void DwarfCompileUnit::addScopeRangeList(DIE &ScopeDIE,
                                         SmallVector<RangeSpan, 2> Range) {
  // Emit offset in .debug_range as a relocatable label. emitDIE will handle
  // emitting it appropriately.
  auto *RangeSectionSym = DD->getRangeSectionSym();

  RangeSpanList List(
      Asm->GetTempSymbol("debug_ranges", DD->getNextRangeNumber()),
      std::move(Range));

  // Under fission, ranges are specified by constant offsets relative to the
  // CU's DW_AT_GNU_ranges_base.
  if (isDwoUnit())
    addSectionDelta(ScopeDIE, dwarf::DW_AT_ranges, List.getSym(),
                    RangeSectionSym);
  else
    addSectionLabel(ScopeDIE, dwarf::DW_AT_ranges, List.getSym(),
                    RangeSectionSym);

  // Add the range list to the set of ranges to be emitted.
  (Skeleton ? Skeleton : this)->CURangeLists.push_back(std::move(List));
}

void DwarfCompileUnit::attachRangesOrLowHighPC(
    DIE &Die, SmallVector<RangeSpan, 2> Ranges) {
  if (Ranges.size() == 1) {
    const auto &single = Ranges.front();
    attachLowHighPC(Die, single.getStart(), single.getEnd());
  } else
    addScopeRangeList(Die, std::move(Ranges));
}

void DwarfCompileUnit::attachRangesOrLowHighPC(
    DIE &Die, const SmallVectorImpl<InsnRange> &Ranges) {
  SmallVector<RangeSpan, 2> List;
  List.reserve(Ranges.size());
  for (const InsnRange &R : Ranges)
    List.push_back(RangeSpan(DD->getLabelBeforeInsn(R.first),
                             DD->getLabelAfterInsn(R.second)));
  attachRangesOrLowHighPC(Die, std::move(List));
}

// This scope represents inlined body of a function. Construct DIE to
// represent this concrete inlined copy of the function.
std::unique_ptr<DIE>
DwarfCompileUnit::constructInlinedScopeDIE(LexicalScope *Scope) {
  assert(Scope->getScopeNode());
  DIScope DS(Scope->getScopeNode());
  DISubprogram InlinedSP = getDISubprogram(DS);
  // Find the subprogram's DwarfCompileUnit in the SPMap in case the subprogram
  // was inlined from another compile unit.
  DIE *OriginDIE = DU->getAbstractSPDies()[InlinedSP];
  assert(OriginDIE && "Unable to find original DIE for an inlined subprogram.");

  auto ScopeDIE = make_unique<DIE>(dwarf::DW_TAG_inlined_subroutine);
  addDIEEntry(*ScopeDIE, dwarf::DW_AT_abstract_origin, *OriginDIE);

  attachRangesOrLowHighPC(*ScopeDIE, Scope->getRanges());

  // Add the call site information to the DIE.
  DILocation DL(Scope->getInlinedAt());
  addUInt(*ScopeDIE, dwarf::DW_AT_call_file, None,
          getOrCreateSourceID(DL.getFilename(), DL.getDirectory()));
  addUInt(*ScopeDIE, dwarf::DW_AT_call_line, None, DL.getLineNumber());

  // Add name to the name table, we do this here because we're guaranteed
  // to have concrete versions of our DW_TAG_inlined_subprogram nodes.
  DD->addSubprogramNames(InlinedSP, *ScopeDIE);

  return ScopeDIE;
}

// Construct new DW_TAG_lexical_block for this scope and attach
// DW_AT_low_pc/DW_AT_high_pc labels.
std::unique_ptr<DIE>
DwarfCompileUnit::constructLexicalScopeDIE(LexicalScope *Scope) {
  if (DD->isLexicalScopeDIENull(Scope))
    return nullptr;

  auto ScopeDIE = make_unique<DIE>(dwarf::DW_TAG_lexical_block);
  if (Scope->isAbstractScope())
    return ScopeDIE;

  attachRangesOrLowHighPC(*ScopeDIE, Scope->getRanges());

  return ScopeDIE;
}

/// constructVariableDIE - Construct a DIE for the given DbgVariable.
std::unique_ptr<DIE> DwarfCompileUnit::constructVariableDIE(DbgVariable &DV,
                                                            bool Abstract) {
  auto D = constructVariableDIEImpl(DV, Abstract);
  DV.setDIE(*D);
  return D;
}

std::unique_ptr<DIE>
DwarfCompileUnit::constructVariableDIEImpl(const DbgVariable &DV,
                                           bool Abstract) {
  // Define variable debug information entry.
  auto VariableDie = make_unique<DIE>(DV.getTag());

  if (Abstract) {
    applyVariableAttributes(DV, *VariableDie);
    return VariableDie;
  }

  // Add variable address.

  unsigned Offset = DV.getDotDebugLocOffset();
  if (Offset != ~0U) {
    addLocationList(*VariableDie, dwarf::DW_AT_location, Offset);
    return VariableDie;
  }

  // Check if variable is described by a DBG_VALUE instruction.
  if (const MachineInstr *DVInsn = DV.getMInsn()) {
    assert(DVInsn->getNumOperands() == 4);
    if (DVInsn->getOperand(0).isReg()) {
      const MachineOperand RegOp = DVInsn->getOperand(0);
      // If the second operand is an immediate, this is an indirect value.
      if (DVInsn->getOperand(1).isImm()) {
        MachineLocation Location(RegOp.getReg(),
                                 DVInsn->getOperand(1).getImm());
        addVariableAddress(DV, *VariableDie, Location);
      } else if (RegOp.getReg())
        addVariableAddress(DV, *VariableDie, MachineLocation(RegOp.getReg()));
    } else if (DVInsn->getOperand(0).isImm())
      addConstantValue(*VariableDie, DVInsn->getOperand(0), DV.getType());
    else if (DVInsn->getOperand(0).isFPImm())
      addConstantFPValue(*VariableDie, DVInsn->getOperand(0));
    else if (DVInsn->getOperand(0).isCImm())
      addConstantValue(*VariableDie, DVInsn->getOperand(0).getCImm(),
                       DV.getType());

    return VariableDie;
  }

  // .. else use frame index.
  if (DV.getFrameIndex().back() == ~0)
    return VariableDie;

  auto Expr = DV.getExpression().begin();
  DIELoc *Loc = new (DIEValueAllocator) DIELoc();
  DIEDwarfExpression DwarfExpr(*Asm, *this, *Loc);
  for (auto FI : DV.getFrameIndex()) {
    unsigned FrameReg = 0;
    const TargetFrameLowering *TFI = Asm->MF->getSubtarget().getFrameLowering();
    int Offset = TFI->getFrameIndexReference(*Asm->MF, FI, FrameReg);
    assert(Expr != DV.getExpression().end() &&
           "Wrong number of expressions");
    DwarfExpr.AddMachineRegIndirect(FrameReg, Offset);
    DwarfExpr.AddExpression(Expr->begin(), Expr->end());
    ++Expr;
  }
  addBlock(*VariableDie, dwarf::DW_AT_location, Loc);

  return VariableDie;
}

std::unique_ptr<DIE> DwarfCompileUnit::constructVariableDIE(
    DbgVariable &DV, const LexicalScope &Scope, DIE *&ObjectPointer) {
  auto Var = constructVariableDIE(DV, Scope.isAbstractScope());
  if (DV.isObjectPointer())
    ObjectPointer = Var.get();
  return Var;
}

DIE *DwarfCompileUnit::createScopeChildrenDIE(
    LexicalScope *Scope, SmallVectorImpl<std::unique_ptr<DIE>> &Children,
    unsigned *ChildScopeCount) {
  DIE *ObjectPointer = nullptr;

  for (DbgVariable *DV : DU->getScopeVariables().lookup(Scope))
    Children.push_back(constructVariableDIE(*DV, *Scope, ObjectPointer));

  unsigned ChildCountWithoutScopes = Children.size();

  for (LexicalScope *LS : Scope->getChildren())
    constructScopeDIE(LS, Children);

  if (ChildScopeCount)
    *ChildScopeCount = Children.size() - ChildCountWithoutScopes;

  return ObjectPointer;
}

void DwarfCompileUnit::constructSubprogramScopeDIE(LexicalScope *Scope) {
  assert(Scope && Scope->getScopeNode());
  assert(!Scope->getInlinedAt());
  assert(!Scope->isAbstractScope());
  DISubprogram Sub(Scope->getScopeNode());

  assert(Sub.isSubprogram());

  DD->getProcessedSPNodes().insert(Sub);

  DIE &ScopeDIE = updateSubprogramScopeDIE(Sub);

  // If this is a variadic function, add an unspecified parameter.
  DITypeArray FnArgs = Sub.getType().getTypeArray();

  // Collect lexical scope children first.
  // ObjectPointer might be a local (non-argument) local variable if it's a
  // block's synthetic this pointer.
  if (DIE *ObjectPointer = createAndAddScopeChildren(Scope, ScopeDIE))
    addDIEEntry(ScopeDIE, dwarf::DW_AT_object_pointer, *ObjectPointer);

  // If we have a single element of null, it is a function that returns void.
  // If we have more than one elements and the last one is null, it is a
  // variadic function.
  if (FnArgs.getNumElements() > 1 &&
      !FnArgs.getElement(FnArgs.getNumElements() - 1) &&
      !includeMinimalInlineScopes())
    ScopeDIE.addChild(make_unique<DIE>(dwarf::DW_TAG_unspecified_parameters));
}

DIE *DwarfCompileUnit::createAndAddScopeChildren(LexicalScope *Scope,
                                                 DIE &ScopeDIE) {
  // We create children when the scope DIE is not null.
  SmallVector<std::unique_ptr<DIE>, 8> Children;
  DIE *ObjectPointer = createScopeChildrenDIE(Scope, Children);

  // Add children
  for (auto &I : Children)
    ScopeDIE.addChild(std::move(I));

  return ObjectPointer;
}

void
DwarfCompileUnit::constructAbstractSubprogramScopeDIE(LexicalScope *Scope) {
  DIE *&AbsDef = DU->getAbstractSPDies()[Scope->getScopeNode()];
  if (AbsDef)
    return;

  DISubprogram SP(Scope->getScopeNode());

  DIE *ContextDIE;

  if (includeMinimalInlineScopes())
    ContextDIE = &getUnitDie();
  // Some of this is duplicated from DwarfUnit::getOrCreateSubprogramDIE, with
  // the important distinction that the DIDescriptor is not associated with the
  // DIE (since the DIDescriptor will be associated with the concrete DIE, if
  // any). It could be refactored to some common utility function.
  else if (DISubprogram SPDecl = SP.getFunctionDeclaration()) {
    ContextDIE = &getUnitDie();
    getOrCreateSubprogramDIE(SPDecl);
  } else
    ContextDIE = getOrCreateContextDIE(resolve(SP.getContext()));

  // Passing null as the associated DIDescriptor because the abstract definition
  // shouldn't be found by lookup.
  AbsDef =
      &createAndAddDIE(dwarf::DW_TAG_subprogram, *ContextDIE, DIDescriptor());
  applySubprogramAttributesToDefinition(SP, *AbsDef);

  if (!includeMinimalInlineScopes())
    addUInt(*AbsDef, dwarf::DW_AT_inline, None, dwarf::DW_INL_inlined);
  if (DIE *ObjectPointer = createAndAddScopeChildren(Scope, *AbsDef))
    addDIEEntry(*AbsDef, dwarf::DW_AT_object_pointer, *ObjectPointer);
}

std::unique_ptr<DIE>
DwarfCompileUnit::constructImportedEntityDIE(const DIImportedEntity &Module) {
  assert(Module.Verify() &&
         "Use one of the MDNode * overloads to handle invalid metadata");
  std::unique_ptr<DIE> IMDie = make_unique<DIE>((dwarf::Tag)Module.getTag());
  insertDIE(Module, IMDie.get());
  DIE *EntityDie;
  DIDescriptor Entity = resolve(Module.getEntity());
  if (Entity.isNameSpace())
    EntityDie = getOrCreateNameSpace(DINameSpace(Entity));
  else if (Entity.isSubprogram())
    EntityDie = getOrCreateSubprogramDIE(DISubprogram(Entity));
  else if (Entity.isType())
    EntityDie = getOrCreateTypeDIE(DIType(Entity));
  else if (Entity.isGlobalVariable())
    EntityDie = getOrCreateGlobalVariableDIE(DIGlobalVariable(Entity));
  else
    EntityDie = getDIE(Entity);
  assert(EntityDie);
  addSourceLine(*IMDie, Module.getLineNumber(),
                Module.getContext().getFilename(),
                Module.getContext().getDirectory());
  addDIEEntry(*IMDie, dwarf::DW_AT_import, *EntityDie);
  StringRef Name = Module.getName();
  if (!Name.empty())
    addString(*IMDie, dwarf::DW_AT_name, Name);

  return IMDie;
}

void DwarfCompileUnit::finishSubprogramDefinition(DISubprogram SP) {
  DIE *D = getDIE(SP);
  if (DIE *AbsSPDIE = DU->getAbstractSPDies().lookup(SP)) {
    if (D)
      // If this subprogram has an abstract definition, reference that
      addDIEEntry(*D, dwarf::DW_AT_abstract_origin, *AbsSPDIE);
  } else {
    if (!D && !includeMinimalInlineScopes())
      // Lazily construct the subprogram if we didn't see either concrete or
      // inlined versions during codegen. (except in -gmlt ^ where we want
      // to omit these entirely)
      D = getOrCreateSubprogramDIE(SP);
    if (D)
      // And attach the attributes
      applySubprogramAttributesToDefinition(SP, *D);
  }
}
void DwarfCompileUnit::collectDeadVariables(DISubprogram SP) {
  assert(SP.isSubprogram() && "CU's subprogram list contains a non-subprogram");
  assert(SP.isDefinition() &&
         "CU's subprogram list contains a subprogram declaration");
  DIArray Variables = SP.getVariables();
  if (Variables.getNumElements() == 0)
    return;

  DIE *SPDIE = DU->getAbstractSPDies().lookup(SP);
  if (!SPDIE)
    SPDIE = getDIE(SP);
  assert(SPDIE);
  for (unsigned vi = 0, ve = Variables.getNumElements(); vi != ve; ++vi) {
    DIVariable DV(Variables.getElement(vi));
    assert(DV.isVariable());
    DbgVariable NewVar(DV, DIExpression(), DD);
    auto VariableDie = constructVariableDIE(NewVar);
    applyVariableAttributes(NewVar, *VariableDie);
    SPDIE->addChild(std::move(VariableDie));
  }
}

void DwarfCompileUnit::emitHeader(const MCSymbol *ASectionSym) const {
  // Don't bother labeling the .dwo unit, as its offset isn't used.
  if (!Skeleton)
    Asm->OutStreamer.EmitLabel(LabelBegin);

  DwarfUnit::emitHeader(ASectionSym);
}

/// addGlobalName - Add a new global name to the compile unit.
void DwarfCompileUnit::addGlobalName(StringRef Name, DIE &Die,
                                     DIScope Context) {
  if (includeMinimalInlineScopes())
    return;
  std::string FullName = getParentContextString(Context) + Name.str();
  GlobalNames[FullName] = &Die;
}

/// Add a new global type to the unit.
void DwarfCompileUnit::addGlobalType(DIType Ty, const DIE &Die,
                                     DIScope Context) {
  if (includeMinimalInlineScopes())
    return;
  std::string FullName = getParentContextString(Context) + Ty.getName().str();
  GlobalTypes[FullName] = &Die;
}

/// addVariableAddress - Add DW_AT_location attribute for a
/// DbgVariable based on provided MachineLocation.
void DwarfCompileUnit::addVariableAddress(const DbgVariable &DV, DIE &Die,
                                          MachineLocation Location) {
  if (DV.variableHasComplexAddress())
    addComplexAddress(DV, Die, dwarf::DW_AT_location, Location);
  else if (DV.isBlockByrefVariable())
    addBlockByrefAddress(DV, Die, dwarf::DW_AT_location, Location);
  else
    addAddress(Die, dwarf::DW_AT_location, Location);
}

/// Add an address attribute to a die based on the location provided.
void DwarfCompileUnit::addAddress(DIE &Die, dwarf::Attribute Attribute,
                                  const MachineLocation &Location) {
  DIELoc *Loc = new (DIEValueAllocator) DIELoc();

  bool validReg;
  if (Location.isReg())
    validReg = addRegisterOpPiece(*Loc, Location.getReg());
  else
    validReg = addRegisterOffset(*Loc, Location.getReg(), Location.getOffset());

  if (!validReg)
    return;

  // Now attach the location information to the DIE.
  addBlock(Die, Attribute, Loc);
}

/// Start with the address based on the location provided, and generate the
/// DWARF information necessary to find the actual variable given the extra
/// address information encoded in the DbgVariable, starting from the starting
/// location.  Add the DWARF information to the die.
void DwarfCompileUnit::addComplexAddress(const DbgVariable &DV, DIE &Die,
                                         dwarf::Attribute Attribute,
                                         const MachineLocation &Location) {
  DIELoc *Loc = new (DIEValueAllocator) DIELoc();
  DIEDwarfExpression DwarfExpr(*Asm, *this, *Loc);
  assert(DV.getExpression().size() == 1);
  DIExpression Expr = DV.getExpression().back();
  bool ValidReg;
  if (Location.getOffset()) {
    ValidReg = DwarfExpr.AddMachineRegIndirect(Location.getReg(),
                                               Location.getOffset());
    if (ValidReg)
      DwarfExpr.AddExpression(Expr.begin(), Expr.end());
  } else
    ValidReg = DwarfExpr.AddMachineRegExpression(Expr, Location.getReg());

  // Now attach the location information to the DIE.
  if (ValidReg)
    addBlock(Die, Attribute, Loc);
}

/// Add a Dwarf loclistptr attribute data and value.
void DwarfCompileUnit::addLocationList(DIE &Die, dwarf::Attribute Attribute,
                                       unsigned Index) {
  DIEValue *Value = new (DIEValueAllocator) DIELocList(Index);
  dwarf::Form Form = DD->getDwarfVersion() >= 4 ? dwarf::DW_FORM_sec_offset
                                                : dwarf::DW_FORM_data4;
  Die.addValue(Attribute, Form, Value);
}

void DwarfCompileUnit::applyVariableAttributes(const DbgVariable &Var,
                                               DIE &VariableDie) {
  StringRef Name = Var.getName();
  if (!Name.empty())
    addString(VariableDie, dwarf::DW_AT_name, Name);
  addSourceLine(VariableDie, Var.getVariable());
  addType(VariableDie, Var.getType());
  if (Var.isArtificial())
    addFlag(VariableDie, dwarf::DW_AT_artificial);
}

/// Add a Dwarf expression attribute data and value.
void DwarfCompileUnit::addExpr(DIELoc &Die, dwarf::Form Form,
                               const MCExpr *Expr) {
  DIEValue *Value = new (DIEValueAllocator) DIEExpr(Expr);
  Die.addValue((dwarf::Attribute)0, Form, Value);
}

void DwarfCompileUnit::applySubprogramAttributesToDefinition(DISubprogram SP,
                                                             DIE &SPDie) {
  DISubprogram SPDecl = SP.getFunctionDeclaration();
  DIScope Context = resolve(SPDecl ? SPDecl.getContext() : SP.getContext());
  applySubprogramAttributes(SP, SPDie, includeMinimalInlineScopes());
  addGlobalName(SP.getName(), SPDie, Context);
}

bool DwarfCompileUnit::isDwoUnit() const {
  return DD->useSplitDwarf() && Skeleton;
}

bool DwarfCompileUnit::includeMinimalInlineScopes() const {
  return getCUNode().getEmissionKind() == DIBuilder::LineTablesOnly ||
         (DD->useSplitDwarf() && !Skeleton);
}
} // end llvm namespace
