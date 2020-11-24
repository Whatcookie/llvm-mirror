; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+f,+d < %s | FileCheck %s

; Check the GHC call convention works (rv64)

@base  = external global i64 ; assigned to register: s1
@sp    = external global i64 ; assigned to register: s2
@hp    = external global i64 ; assigned to register: s3
@r1    = external global i64 ; assigned to register: s4
@r2    = external global i64 ; assigned to register: s5
@r3    = external global i64 ; assigned to register: s6
@r4    = external global i64 ; assigned to register: s7
@r5    = external global i64 ; assigned to register: s8
@r6    = external global i64 ; assigned to register: s9
@r7    = external global i64 ; assigned to register: s10
@splim = external global i64 ; assigned to register: s11

@f1 = external global float  ; assigned to register: fs0
@f2 = external global float  ; assigned to register: fs1
@f3 = external global float  ; assigned to register: fs2
@f4 = external global float  ; assigned to register: fs3
@f5 = external global float  ; assigned to register: fs4
@f6 = external global float  ; assigned to register: fs5

@d1 = external global double ; assigned to register: fs6
@d2 = external global double ; assigned to register: fs7
@d3 = external global double ; assigned to register: fs8
@d4 = external global double ; assigned to register: fs9
@d5 = external global double ; assigned to register: fs10
@d6 = external global double ; assigned to register: fs11

define ghccc void @foo() nounwind {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    lui a0, %hi(d6)
; CHECK-NEXT:    fld fs11, %lo(d6)(a0)
; CHECK-NEXT:    lui a0, %hi(d5)
; CHECK-NEXT:    fld fs10, %lo(d5)(a0)
; CHECK-NEXT:    lui a0, %hi(d4)
; CHECK-NEXT:    fld fs9, %lo(d4)(a0)
; CHECK-NEXT:    lui a0, %hi(d3)
; CHECK-NEXT:    fld fs8, %lo(d3)(a0)
; CHECK-NEXT:    lui a0, %hi(d2)
; CHECK-NEXT:    fld fs7, %lo(d2)(a0)
; CHECK-NEXT:    lui a0, %hi(d1)
; CHECK-NEXT:    fld fs6, %lo(d1)(a0)
; CHECK-NEXT:    lui a0, %hi(f6)
; CHECK-NEXT:    flw fs5, %lo(f6)(a0)
; CHECK-NEXT:    lui a0, %hi(f5)
; CHECK-NEXT:    flw fs4, %lo(f5)(a0)
; CHECK-NEXT:    lui a0, %hi(f4)
; CHECK-NEXT:    flw fs3, %lo(f4)(a0)
; CHECK-NEXT:    lui a0, %hi(f3)
; CHECK-NEXT:    flw fs2, %lo(f3)(a0)
; CHECK-NEXT:    lui a0, %hi(f2)
; CHECK-NEXT:    flw fs1, %lo(f2)(a0)
; CHECK-NEXT:    lui a0, %hi(f1)
; CHECK-NEXT:    flw fs0, %lo(f1)(a0)
; CHECK-NEXT:    lui a0, %hi(splim)
; CHECK-NEXT:    ld s11, %lo(splim)(a0)
; CHECK-NEXT:    lui a0, %hi(r7)
; CHECK-NEXT:    ld s10, %lo(r7)(a0)
; CHECK-NEXT:    lui a0, %hi(r6)
; CHECK-NEXT:    ld s9, %lo(r6)(a0)
; CHECK-NEXT:    lui a0, %hi(r5)
; CHECK-NEXT:    ld s8, %lo(r5)(a0)
; CHECK-NEXT:    lui a0, %hi(r4)
; CHECK-NEXT:    ld s7, %lo(r4)(a0)
; CHECK-NEXT:    lui a0, %hi(r3)
; CHECK-NEXT:    ld s6, %lo(r3)(a0)
; CHECK-NEXT:    lui a0, %hi(r2)
; CHECK-NEXT:    ld s5, %lo(r2)(a0)
; CHECK-NEXT:    lui a0, %hi(r1)
; CHECK-NEXT:    ld s4, %lo(r1)(a0)
; CHECK-NEXT:    lui a0, %hi(hp)
; CHECK-NEXT:    ld s3, %lo(hp)(a0)
; CHECK-NEXT:    lui a0, %hi(sp)
; CHECK-NEXT:    ld s2, %lo(sp)(a0)
; CHECK-NEXT:    lui a0, %hi(base)
; CHECK-NEXT:    ld s1, %lo(base)(a0)
; CHECK-NEXT:    tail bar
entry:
  %0  = load double, double* @d6
  %1  = load double, double* @d5
  %2  = load double, double* @d4
  %3  = load double, double* @d3
  %4  = load double, double* @d2
  %5  = load double, double* @d1
  %6  = load float, float* @f6
  %7  = load float, float* @f5
  %8  = load float, float* @f4
  %9  = load float, float* @f3
  %10 = load float, float* @f2
  %11 = load float, float* @f1
  %12 = load i64, i64* @splim
  %13 = load i64, i64* @r7
  %14 = load i64, i64* @r6
  %15 = load i64, i64* @r5
  %16 = load i64, i64* @r4
  %17 = load i64, i64* @r3
  %18 = load i64, i64* @r2
  %19 = load i64, i64* @r1
  %20 = load i64, i64* @hp
  %21 = load i64, i64* @sp
  %22 = load i64, i64* @base
  tail call ghccc void @bar(i64 %22, i64 %21, i64 %20, i64 %19, i64 %18, i64 %17, i64 %16, i64 %15, i64 %14, i64 %13, i64 %12,
                            float %11, float %10, float %9, float %8, float %7, float %6,
                            double %5, double %4, double %3, double %2, double %1, double %0) nounwind
  ret void
}

declare ghccc void @bar(i64, i64, i64, i64, i64, i64, i64, i64, i64, i64, i64,
                        float, float, float, float, float, float,
                        double, double, double, double, double, double)
