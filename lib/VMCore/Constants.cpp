//===-- ConstantVals.cpp - Implement Constant nodes --------------*- C++ -*--=//
//
// This file implements the Constant* classes...
//
//===----------------------------------------------------------------------===//

#define __STDC_LIMIT_MACROS           // Get defs for INT64_MAX and friends...
#include "llvm/ConstantVals.h"
#include "llvm/DerivedTypes.h"
#include "llvm/SymbolTable.h"
#include "llvm/GlobalValue.h"
#include "llvm/Module.h"
#include "llvm/SlotCalculator.h"
#include "Support/StringExtras.h"
#include <algorithm>

using std::map;
using std::pair;
using std::make_pair;

ConstantBool *ConstantBool::True  = new ConstantBool(true);
ConstantBool *ConstantBool::False = new ConstantBool(false);


//===----------------------------------------------------------------------===//
//                              Constant Class
//===----------------------------------------------------------------------===//

// Specialize setName to take care of symbol table majik
void Constant::setName(const std::string &Name, SymbolTable *ST) {
  assert(ST && "Type::setName - Must provide symbol table argument!");

  if (Name.size()) ST->insert(Name, this);
}

// Static constructor to create a '0' constant of arbitrary type...
Constant *Constant::getNullConstant(const Type *Ty) {
  switch (Ty->getPrimitiveID()) {
  case Type::BoolTyID:   return ConstantBool::get(false);
  case Type::SByteTyID:
  case Type::ShortTyID:
  case Type::IntTyID:
  case Type::LongTyID:   return ConstantSInt::get(Ty, 0);

  case Type::UByteTyID:
  case Type::UShortTyID:
  case Type::UIntTyID:
  case Type::ULongTyID:  return ConstantUInt::get(Ty, 0);

  case Type::FloatTyID:
  case Type::DoubleTyID: return ConstantFP::get(Ty, 0);

  case Type::PointerTyID: 
    return ConstantPointerNull::get(cast<PointerType>(Ty));
  default:
    return 0;
  }
}

void Constant::destroyConstantImpl() {
  // When a Constant is destroyed, there may be lingering
  // references to the constant by other constants in the constant pool.  These
  // constants are implicitly dependant on the module that is being deleted,
  // but they don't know that.  Because we only find out when the CPV is
  // deleted, we must now notify all of our users (that should only be
  // Constants) that they are, in fact, invalid now and should be deleted.
  //
  while (!use_empty()) {
    Value *V = use_back();
#ifndef NDEBUG      // Only in -g mode...
    if (!isa<Constant>(V)) {
      std::cerr << "While deleting: ";
      dump();
      std::cerr << "\nUse still stuck around after Def is destroyed: ";
      V->dump();
      std::cerr << "\n";
    }
#endif
    assert(isa<Constant>(V) && "References remain to ConstantPointerRef!");
    Constant *CPV = cast<Constant>(V);
    CPV->destroyConstant();

    // The constant should remove itself from our use list...
    assert((use_empty() || use_back() == V) && "Constant not removed!");
  }

  // Value has no outstanding references it is safe to delete it now...
  delete this;
}

//===----------------------------------------------------------------------===//
//                            ConstantXXX Classes
//===----------------------------------------------------------------------===//

//===----------------------------------------------------------------------===//
//                             Normal Constructors

ConstantBool::ConstantBool(bool V) : Constant(Type::BoolTy) {
  Val = V;
}

ConstantInt::ConstantInt(const Type *Ty, uint64_t V) : Constant(Ty) {
  Val.Unsigned = V;
}

ConstantSInt::ConstantSInt(const Type *Ty, int64_t V) : ConstantInt(Ty, V) {
  assert(isValueValidForType(Ty, V) && "Value too large for type!");
}

ConstantUInt::ConstantUInt(const Type *Ty, uint64_t V) : ConstantInt(Ty, V) {
  assert(isValueValidForType(Ty, V) && "Value too large for type!");
}

ConstantFP::ConstantFP(const Type *Ty, double V) : Constant(Ty) {
  assert(isValueValidForType(Ty, V) && "Value too large for type!");
  Val = V;
}

ConstantArray::ConstantArray(const ArrayType *T,
                             const std::vector<Constant*> &V) : Constant(T) {
  for (unsigned i = 0; i < V.size(); i++) {
    assert(V[i]->getType() == T->getElementType());
    Operands.push_back(Use(V[i], this));
  }
}

ConstantStruct::ConstantStruct(const StructType *T,
                               const std::vector<Constant*> &V) : Constant(T) {
  const StructType::ElementTypes &ETypes = T->getElementTypes();
  
  for (unsigned i = 0; i < V.size(); i++) {
    assert(V[i]->getType() == ETypes[i]);
    Operands.push_back(Use(V[i], this));
  }
}

ConstantPointerRef::ConstantPointerRef(GlobalValue *GV)
  : ConstantPointer(GV->getType()) {
  Operands.push_back(Use(GV, this));
}



//===----------------------------------------------------------------------===//
//                          getStrValue implementations

std::string ConstantBool::getStrValue() const {
  return Val ? "true" : "false";
}

std::string ConstantSInt::getStrValue() const {
  return itostr(Val.Signed);
}

std::string ConstantUInt::getStrValue() const {
  return utostr(Val.Unsigned);
}

// ConstantFP::getStrValue - We would like to output the FP constant value in
// exponential notation, but we cannot do this if doing so will lose precision.
// Check here to make sure that we only output it in exponential format if we
// can parse the value back and get the same value.
//
std::string ConstantFP::getStrValue() const {
  std::string StrVal = ftostr(Val);

  // Check to make sure that the stringized number is not some string like "Inf"
  // or NaN, that atof will accept, but the lexer will not.  Check that the
  // string matches the "[-+]?[0-9]" regex.
  //
  if ((StrVal[0] >= '0' && StrVal[0] <= '9') ||
      ((StrVal[0] == '-' || StrVal[0] == '+') &&
       (StrVal[0] >= '0' && StrVal[0] <= '9'))) {
    double TestVal = atof(StrVal.c_str());  // Reparse stringized version!
    if (TestVal == Val)
      return StrVal;
  }

  // Otherwise we could not reparse it to exactly the same value, so we must
  // output the string in hexadecimal format!
  //
  // Behave nicely in the face of C TBAA rules... see:
  // http://www.nullstone.com/htmls/category/aliastyp.htm
  //
  char *Ptr = (char*)&Val;
  assert(sizeof(double) == sizeof(uint64_t) && sizeof(double) == 8 &&
         "assuming that double is 64 bits!");
  return "0x"+utohexstr(*(uint64_t*)Ptr);
}

std::string ConstantArray::getStrValue() const {
  std::string Result;
  
  // As a special case, print the array as a string if it is an array of
  // ubytes or an array of sbytes with positive values.
  // 
  const Type *ETy = cast<ArrayType>(getType())->getElementType();
  bool isString = (ETy == Type::SByteTy || ETy == Type::UByteTy);

  if (ETy == Type::SByteTy) {
    for (unsigned i = 0; i < Operands.size(); ++i)
      if (ETy == Type::SByteTy &&
          cast<ConstantSInt>(Operands[i])->getValue() < 0) {
        isString = false;
        break;
      }
  }

  if (isString) {
    Result = "c\"";
    for (unsigned i = 0; i < Operands.size(); ++i) {
      unsigned char C = (ETy == Type::SByteTy) ?
        (unsigned char)cast<ConstantSInt>(Operands[i])->getValue() :
        (unsigned char)cast<ConstantUInt>(Operands[i])->getValue();

      if (isprint(C)) {
        Result += C;
      } else {
        Result += '\\';
        Result += ( C/16  < 10) ? ( C/16 +'0') : ( C/16 -10+'A');
        Result += ((C&15) < 10) ? ((C&15)+'0') : ((C&15)-10+'A');
      }
    }
    Result += "\"";

  } else {
    Result = "[";
    if (Operands.size()) {
      Result += " " + Operands[0]->getType()->getDescription() + 
	        " " + cast<Constant>(Operands[0])->getStrValue();
      for (unsigned i = 1; i < Operands.size(); i++)
        Result += ", " + Operands[i]->getType()->getDescription() + 
                  " " + cast<Constant>(Operands[i])->getStrValue();
    }
    Result += " ]";
  }
  
  return Result;
}

std::string ConstantStruct::getStrValue() const {
  std::string Result = "{";
  if (Operands.size()) {
    Result += " " + Operands[0]->getType()->getDescription() + 
	      " " + cast<Constant>(Operands[0])->getStrValue();
    for (unsigned i = 1; i < Operands.size(); i++)
      Result += ", " + Operands[i]->getType()->getDescription() + 
	        " " + cast<Constant>(Operands[i])->getStrValue();
  }

  return Result + " }";
}

std::string ConstantPointerNull::getStrValue() const {
  return "null";
}

std::string ConstantPointerRef::getStrValue() const {
  const GlobalValue *V = getValue();
  if (V->hasName()) return "%" + V->getName();

  // FIXME: This is a gross hack.
  SlotCalculator *Table = new SlotCalculator(V->getParent(), true);
  int Slot = Table->getValSlot(V);
  delete Table;

  if (Slot >= 0) return std::string(" %") + itostr(Slot);
  else return "<pointer reference badref>";
}


//===----------------------------------------------------------------------===//
//                           classof implementations

bool ConstantInt::classof(const Constant *CPV) {
  return CPV->getType()->isIntegral();
}
bool ConstantSInt::classof(const Constant *CPV) {
  return CPV->getType()->isSigned();
}
bool ConstantUInt::classof(const Constant *CPV) {
  return CPV->getType()->isUnsigned();
}
bool ConstantFP::classof(const Constant *CPV) {
  const Type *Ty = CPV->getType();
  return Ty == Type::FloatTy || Ty == Type::DoubleTy;
}
bool ConstantArray::classof(const Constant *CPV) {
  return isa<ArrayType>(CPV->getType());
}
bool ConstantStruct::classof(const Constant *CPV) {
  return isa<StructType>(CPV->getType());
}
bool ConstantPointer::classof(const Constant *CPV) {
  return isa<PointerType>(CPV->getType());
}


//===----------------------------------------------------------------------===//
//                      isValueValidForType implementations

bool ConstantSInt::isValueValidForType(const Type *Ty, int64_t Val) {
  switch (Ty->getPrimitiveID()) {
  default:
    return false;         // These can't be represented as integers!!!

    // Signed types...
  case Type::SByteTyID:
    return (Val <= INT8_MAX && Val >= INT8_MIN);
  case Type::ShortTyID:
    return (Val <= INT16_MAX && Val >= INT16_MIN);
  case Type::IntTyID:
    return (Val <= INT32_MAX && Val >= INT32_MIN);
  case Type::LongTyID:
    return true;          // This is the largest type...
  }
  assert(0 && "WTF?");
  return false;
}

bool ConstantUInt::isValueValidForType(const Type *Ty, uint64_t Val) {
  switch (Ty->getPrimitiveID()) {
  default:
    return false;         // These can't be represented as integers!!!

    // Unsigned types...
  case Type::UByteTyID:
    return (Val <= UINT8_MAX);
  case Type::UShortTyID:
    return (Val <= UINT16_MAX);
  case Type::UIntTyID:
    return (Val <= UINT32_MAX);
  case Type::ULongTyID:
    return true;          // This is the largest type...
  }
  assert(0 && "WTF?");
  return false;
}

bool ConstantFP::isValueValidForType(const Type *Ty, double Val) {
  switch (Ty->getPrimitiveID()) {
  default:
    return false;         // These can't be represented as floating point!

    // TODO: Figure out how to test if a double can be cast to a float!
  case Type::FloatTyID:
    /*
    return (Val <= UINT8_MAX);
    */
  case Type::DoubleTyID:
    return true;          // This is the largest type...
  }
};

//===----------------------------------------------------------------------===//
//                      Hash Function Implementations
#if 0
unsigned ConstantSInt::hash(const Type *Ty, int64_t V) {
  return unsigned(Ty->getPrimitiveID() ^ V);
}

unsigned ConstantUInt::hash(const Type *Ty, uint64_t V) {
  return unsigned(Ty->getPrimitiveID() ^ V);
}

unsigned ConstantFP::hash(const Type *Ty, double V) {
  return Ty->getPrimitiveID() ^ unsigned(V);
}

unsigned ConstantArray::hash(const ArrayType *Ty,
                             const std::vector<Constant*> &V) {
  unsigned Result = (Ty->getUniqueID() << 5) ^ (Ty->getUniqueID() * 7);
  for (unsigned i = 0; i < V.size(); ++i)
    Result ^= V[i]->getHash() << (i & 7);
  return Result;
}

unsigned ConstantStruct::hash(const StructType *Ty,
                              const std::vector<Constant*> &V) {
  unsigned Result = (Ty->getUniqueID() << 5) ^ (Ty->getUniqueID() * 7);
  for (unsigned i = 0; i < V.size(); ++i)
    Result ^= V[i]->getHash() << (i & 7);
  return Result;
}
#endif

//===----------------------------------------------------------------------===//
//                      Factory Function Implementation

template<class ValType, class ConstantClass>
struct ValueMap {
  typedef pair<const Type*, ValType> ConstHashKey;
  map<ConstHashKey, ConstantClass *> Map;

  inline ConstantClass *get(const Type *Ty, ValType V) {
    map<ConstHashKey,ConstantClass *>::iterator I =
      Map.find(ConstHashKey(Ty, V));
    return (I != Map.end()) ? I->second : 0;
  }

  inline void add(const Type *Ty, ValType V, ConstantClass *CP) {
    Map.insert(make_pair(ConstHashKey(Ty, V), CP));
  }

  inline void remove(ConstantClass *CP) {
    for (map<ConstHashKey,ConstantClass *>::iterator I = Map.begin(),
                                                      E = Map.end(); I != E;++I)
      if (I->second == CP) {
	Map.erase(I);
	return;
      }
  }
};

//---- ConstantUInt::get() and ConstantSInt::get() implementations...
//
static ValueMap<uint64_t, ConstantInt> IntConstants;

ConstantSInt *ConstantSInt::get(const Type *Ty, int64_t V) {
  ConstantSInt *Result = (ConstantSInt*)IntConstants.get(Ty, (uint64_t)V);
  if (!Result)   // If no preexisting value, create one now...
    IntConstants.add(Ty, V, Result = new ConstantSInt(Ty, V));
  return Result;
}

ConstantUInt *ConstantUInt::get(const Type *Ty, uint64_t V) {
  ConstantUInt *Result = (ConstantUInt*)IntConstants.get(Ty, V);
  if (!Result)   // If no preexisting value, create one now...
    IntConstants.add(Ty, V, Result = new ConstantUInt(Ty, V));
  return Result;
}

ConstantInt *ConstantInt::get(const Type *Ty, unsigned char V) {
  assert(V <= 127 && "Can only be used with very small positive constants!");
  if (Ty->isSigned()) return ConstantSInt::get(Ty, V);
  return ConstantUInt::get(Ty, V);
}

//---- ConstantFP::get() implementation...
//
static ValueMap<double, ConstantFP> FPConstants;

ConstantFP *ConstantFP::get(const Type *Ty, double V) {
  ConstantFP *Result = FPConstants.get(Ty, V);
  if (!Result)   // If no preexisting value, create one now...
    FPConstants.add(Ty, V, Result = new ConstantFP(Ty, V));
  return Result;
}

//---- ConstantArray::get() implementation...
//
static ValueMap<std::vector<Constant*>, ConstantArray> ArrayConstants;

ConstantArray *ConstantArray::get(const ArrayType *Ty,
                                  const std::vector<Constant*> &V) {
  ConstantArray *Result = ArrayConstants.get(Ty, V);
  if (!Result)   // If no preexisting value, create one now...
    ArrayConstants.add(Ty, V, Result = new ConstantArray(Ty, V));
  return Result;
}

// ConstantArray::get(const string&) - Return an array that is initialized to
// contain the specified string.  A null terminator is added to the specified
// string so that it may be used in a natural way...
//
ConstantArray *ConstantArray::get(const std::string &Str) {
  std::vector<Constant*> ElementVals;

  for (unsigned i = 0; i < Str.length(); ++i)
    ElementVals.push_back(ConstantSInt::get(Type::SByteTy, Str[i]));

  // Add a null terminator to the string...
  ElementVals.push_back(ConstantSInt::get(Type::SByteTy, 0));

  ArrayType *ATy = ArrayType::get(Type::SByteTy, Str.length()+1);
  return ConstantArray::get(ATy, ElementVals);
}


// destroyConstant - Remove the constant from the constant table...
//
void ConstantArray::destroyConstant() {
  ArrayConstants.remove(this);
  destroyConstantImpl();
}

//---- ConstantStruct::get() implementation...
//
static ValueMap<std::vector<Constant*>, ConstantStruct> StructConstants;

ConstantStruct *ConstantStruct::get(const StructType *Ty,
                                    const std::vector<Constant*> &V) {
  ConstantStruct *Result = StructConstants.get(Ty, V);
  if (!Result)   // If no preexisting value, create one now...
    StructConstants.add(Ty, V, Result = new ConstantStruct(Ty, V));
  return Result;
}

// destroyConstant - Remove the constant from the constant table...
//
void ConstantStruct::destroyConstant() {
  StructConstants.remove(this);
  destroyConstantImpl();
}

//---- ConstantPointerNull::get() implementation...
//
static ValueMap<char, ConstantPointerNull> NullPtrConstants;

ConstantPointerNull *ConstantPointerNull::get(const PointerType *Ty) {
  ConstantPointerNull *Result = NullPtrConstants.get(Ty, 0);
  if (!Result)   // If no preexisting value, create one now...
    NullPtrConstants.add(Ty, 0, Result = new ConstantPointerNull(Ty));
  return Result;
}

//---- ConstantPointerRef::get() implementation...
//
ConstantPointerRef *ConstantPointerRef::get(GlobalValue *GV) {
  assert(GV->getParent() && "Global Value must be attached to a module!");

  // The Module handles the pointer reference sharing...
  return GV->getParent()->getConstantPointerRef(GV);
}


void ConstantPointerRef::mutateReference(GlobalValue *NewGV) {
  getValue()->getParent()->mutateConstantPointerRef(getValue(), NewGV);
  Operands[0] = NewGV;
}
