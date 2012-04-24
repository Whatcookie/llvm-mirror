//===-- RegisterPressure.h - Dynamic Register Pressure -*- C++ -*-------===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines the RegisterPressure class which can be used to track
// MachineInstr level register pressure.
//
//===----------------------------------------------------------------------===//

#ifndef LLVM_CODEGEN_REGISTERPRESSURE_H
#define LLVM_CODEGEN_REGISTERPRESSURE_H

#include "llvm/CodeGen/SlotIndexes.h"
#include "llvm/Target/TargetRegisterInfo.h"
#include "llvm/ADT/SparseSet.h"

namespace llvm {

class LiveIntervals;
class RegisterClassInfo;

/// Base class for register pressure results.
struct RegisterPressure {
  /// Map of max reg pressure indexed by pressure set ID, not class ID.
  std::vector<unsigned> MaxSetPressure;

  /// List of live in registers.
  SmallVector<unsigned,8> LiveInRegs;
  SmallVector<unsigned,8> LiveOutRegs;

  /// Increase register pressure for each pressure set impacted by this register
  /// class. Normally called by RegPressureTracker, but may be called manually
  /// to account for live through (global liveness).
  void increase(const TargetRegisterClass *RC, const TargetRegisterInfo *TRI);

  /// Decrease register pressure for each pressure set impacted by this register
  /// class. This is only useful to account for spilling or rematerialization.
  void decrease(const TargetRegisterClass *RC, const TargetRegisterInfo *TRI);
};

/// RegisterPressure computed within a region of instructions delimited by
/// TopIdx and BottomIdx.  During pressure computation, the maximum pressure per
/// register pressure set is increased. Once pressure within a region is fully
/// computed, the live-in and live-out sets are recorded.
///
/// This is preferable to RegionPressure when LiveIntervals are available,
/// because delimiting regions by SlotIndex is more robust and convenient than
/// holding block iterators. The block contents can change without invalidating
/// the pressure result.
struct IntervalPressure : RegisterPressure {
  /// Record the boundary of the region being tracked.
  SlotIndex TopIdx;
  SlotIndex BottomIdx;

  void reset();

  void openTop(SlotIndex NextTop);

  void openBottom(SlotIndex PrevBottom);
};

/// RegisterPressure computed within a region of instructions delimited by
/// TopPos and BottomPos. This is a less precise version of IntervalPressure for
/// use when LiveIntervals are unavailable.
struct RegionPressure : RegisterPressure {
  /// Record the boundary of the region being tracked.
  MachineBasicBlock::const_iterator TopPos;
  MachineBasicBlock::const_iterator BottomPos;

  void reset();

  void openTop(MachineBasicBlock::const_iterator PrevTop);

  void openBottom(MachineBasicBlock::const_iterator PrevBottom);
};

/// Track the current register pressure at some position in the instruction
/// stream, and remember the high water mark within the region traversed. This
/// does not automatically consider live-through ranges. The client may
/// independently adjust for global liveness.
///
/// Each RegPressureTracker only works within a MachineBasicBlock. Pressure can
/// be tracked across a larger region by storing a RegisterPressure result at
/// each block boundary and explicitly adjusting pressure to account for block
/// live-in and live-out register sets.
///
/// RegPressureTracker holds a reference to a RegisterPressure result that it
/// computes incrementally. During downward tracking, P.BottomIdx or P.BottomPos
/// is invalid until it reaches the end of the block or closeRegion() is
/// explicitly called. Similarly, P.TopIdx is invalid during upward
/// tracking. Changing direction has the side effect of closing region, and
/// traversing past TopIdx or BottomIdx reopens it.
class RegPressureTracker {
  const MachineFunction     *MF;
  const TargetRegisterInfo  *TRI;
  const RegisterClassInfo   *RCI;
  const MachineRegisterInfo *MRI;
  const LiveIntervals       *LIS;

  /// We currently only allow pressure tracking within a block.
  const MachineBasicBlock *MBB;

  /// Track the max pressure within the region traversed so far.
  RegisterPressure &P;

  /// Run in two modes dependending on whether constructed with IntervalPressure
  /// or RegisterPressure. If requireIntervals is false, LIS are ignored.
  bool RequireIntervals;

  /// Register pressure corresponds to liveness before this instruction
  /// iterator. It may point to the end of the block rather than an instruction.
  MachineBasicBlock::const_iterator CurrPos;

  /// Pressure map indexed by pressure set ID, not class ID.
  std::vector<unsigned> CurrSetPressure;

  /// List of live registers.
  SparseSet<unsigned> LivePhysRegs;
  SparseSet<unsigned, VirtReg2IndexFunctor> LiveVirtRegs;

public:
  RegPressureTracker(IntervalPressure &rp) :
    MF(0), TRI(0), RCI(0), LIS(0), MBB(0), P(rp), RequireIntervals(true) {}

  RegPressureTracker(RegionPressure &rp) :
    MF(0), TRI(0), RCI(0), LIS(0), MBB(0), P(rp), RequireIntervals(false) {}

  void init(const MachineFunction *mf, const RegisterClassInfo *rci,
            const LiveIntervals *lis, const MachineBasicBlock *mbb,
            MachineBasicBlock::const_iterator pos);

  // Get the MI position corresponding to this register pressure.
  MachineBasicBlock::const_iterator getPos() const { return CurrPos; }

  /// Recede across the previous instruction.
  bool recede();

  /// Advance across the current instruction.
  bool advance();

  /// Finalize the region boundaries and recored live ins and live outs.
  void closeRegion();

  /// Get the resulting register pressure over the traversed region.
  /// This result is complete if either advance() or recede() has returned true,
  /// or if closeRegion() was explicitly invoked.
  RegisterPressure &getPressure() { return P; }

protected:
  bool isTopClosed() const;
  bool isBottomClosed() const;

  void closeTop();
  void closeBottom();

  void increasePhysRegPressure(unsigned Reg);
  void decreasePhysRegPressure(unsigned Reg);

  void increaseVirtRegPressure(unsigned Reg);
  void decreaseVirtRegPressure(unsigned Reg);

  void discoverPhysLiveIn(unsigned Reg);
  void discoverPhysLiveOut(unsigned Reg);

  void discoverVirtLiveIn(unsigned Reg);
  void discoverVirtLiveOut(unsigned Reg);
};
} // end namespace llvm

#endif
