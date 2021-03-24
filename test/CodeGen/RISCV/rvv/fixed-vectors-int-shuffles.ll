; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv32 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefix=CHECK
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v -verify-machineinstrs -riscv-v-vector-bits-min=128 -verify-machineinstrs < %s | FileCheck %s --check-prefix=CHECK

define <4 x i16> @shuffle_v4i16(<4 x i16> %x, <4 x i16> %y) {
; CHECK-LABEL: shuffle_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 11
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    vsetivli a0, 4, e16,m1,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v9, v8, v0
; CHECK-NEXT:    ret
  %s = shufflevector <4 x i16> %x, <4 x i16> %y, <4 x i32> <i32 0, i32 1, i32 6, i32 3>
  ret <4 x i16> %s
}

define <8 x i32> @shuffle_v8i32(<8 x i32> %x, <8 x i32> %y) {
; CHECK-LABEL: shuffle_v8i32:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 203
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    vsetivli a0, 8, e32,m2,ta,mu
; CHECK-NEXT:    vmerge.vvm v8, v10, v8, v0
; CHECK-NEXT:    ret
  %s = shufflevector <8 x i32> %x, <8 x i32> %y, <8 x i32> <i32 0, i32 1, i32 10, i32 3, i32 12, i32 13, i32 6, i32 7>
  ret <8 x i32> %s
}

define <4 x i16> @shuffle_xv_v4i16(<4 x i16> %x) {
; CHECK-LABEL: shuffle_xv_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 9
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    vsetivli a0, 4, e16,m1,ta,mu
; CHECK-NEXT:    vmerge.vim v8, v8, 5, v0
; CHECK-NEXT:    ret
  %s = shufflevector <4 x i16> <i16 5, i16 5, i16 5, i16 5>, <4 x i16> %x, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
  ret <4 x i16> %s
}

define <4 x i16> @shuffle_vx_v4i16(<4 x i16> %x) {
; CHECK-LABEL: shuffle_vx_v4i16:
; CHECK:       # %bb.0:
; CHECK-NEXT:    addi a0, zero, 6
; CHECK-NEXT:    vsetivli a1, 1, e8,m1,ta,mu
; CHECK-NEXT:    vmv.s.x v0, a0
; CHECK-NEXT:    vsetivli a0, 4, e16,m1,ta,mu
; CHECK-NEXT:    vmerge.vim v8, v8, 5, v0
; CHECK-NEXT:    ret
  %s = shufflevector <4 x i16> %x, <4 x i16> <i16 5, i16 5, i16 5, i16 5>, <4 x i32> <i32 0, i32 5, i32 6, i32 3>
  ret <4 x i16> %s
}
