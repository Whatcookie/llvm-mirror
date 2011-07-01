//=====-- AlphaSubtarget.h - Define Subtarget for the Alpha --*- C++ -*--====//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file declares the Alpha specific subclass of TargetSubtargetInfo.
//
//===----------------------------------------------------------------------===//

#ifndef ALPHASUBTARGET_H
#define ALPHASUBTARGET_H

#include "llvm/Target/TargetSubtargetInfo.h"
#include "llvm/MC/MCInstrItineraries.h"
#include <string>

#define GET_SUBTARGETINFO_HEADER
#include "AlphaGenSubtargetInfo.inc"

namespace llvm {

class AlphaSubtarget : public AlphaGenSubtargetInfo {
protected:

  bool HasCT;

  InstrItineraryData InstrItins;

public:
  /// This constructor initializes the data members to match that
  /// of the specified triple.
  ///
  AlphaSubtarget(const std::string &TT, const std::string &CPU,
                 const std::string &FS);
  
  /// ParseSubtargetFeatures - Parses features string setting specified 
  /// subtarget options.  Definition of function is auto generated by tblgen.
  void ParseSubtargetFeatures(const std::string &FS, const std::string &CPU);

  bool hasCT() const { return HasCT; }
};
} // End llvm namespace

#endif
