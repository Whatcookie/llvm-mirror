//===-- X86.h - Top-level interface for X86 representation ------*- C++ -*-===//
//
// This file contains the entry points for global functions defined in the x86
// target library, as used by the LLVM JIT.
//
//===----------------------------------------------------------------------===//

#ifndef TARGET_X86_H
#define TARGET_X86_H

#include <iosfwd>
class TargetMachine;
class Pass;

/// createX86SimpleInstructionSelector - This pass converts an LLVM function
/// into a machine code representation in a very simple peep-hole fashion.  The
/// generated code sucks but the implementation is nice and simple.
///
Pass *createX86SimpleInstructionSelector(TargetMachine &TM);

/// createX86PatternInstructionSelector - This pass converts an LLVM function
/// into a machine code representation using pattern matching and a machine
/// description file.
///
Pass *createX86PatternInstructionSelector(TargetMachine &TM);

/// createX86PeepholeOptimizer - Create a pass to perform X86 specific peephole
/// optimizations.
///
Pass *createX86PeepholeOptimizerPass();

/// createX86FloatingPointStackifierPass - This function returns a pass which
/// converts floating point register references and pseudo instructions into
/// floating point stack references and physical instructions.
///
Pass *createX86FloatingPointStackifierPass();

/// createX86CodePrinterPass - Returns a pass that prints the X86
/// assembly code for a MachineFunction to the given output stream,
/// using the given target machine description.  This should work
/// regardless of whether the function is in SSA form.
///
Pass *createX86CodePrinterPass(std::ostream &o, TargetMachine &tm);

/// X86EmitCodeToMemory - This function converts a register allocated function
/// into raw machine code in a dynamically allocated chunk of memory.  A pointer
/// to the start of the function is returned.
///
Pass *createEmitX86CodeToMemory();

// Defines symbolic names for X86 registers.  This defines a mapping from
// register name to register number.
//
#include "X86GenRegisterNames.inc"

// Defines symbolic names for the X86 instructions.
//
#include "X86GenInstrNames.inc"

#endif
