; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=aarch64-unknown-unknown < %s | FileCheck %s

define float @trunc_unsigned_f32(float %x) #0 {
; CHECK-LABEL: trunc_unsigned_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frintz s0, s0
; CHECK-NEXT:    ret
  %i = fptoui float %x to i32
  %r = uitofp i32 %i to float
  ret float %r
}

define double @trunc_unsigned_f64(double %x) #0 {
; CHECK-LABEL: trunc_unsigned_f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frintz d0, d0
; CHECK-NEXT:    ret
  %i = fptoui double %x to i64
  %r = uitofp i64 %i to double
  ret double %r
}

define float @trunc_signed_f32(float %x) #0 {
; CHECK-LABEL: trunc_signed_f32:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frintz s0, s0
; CHECK-NEXT:    ret
  %i = fptosi float %x to i32
  %r = sitofp i32 %i to float
  ret float %r
}

define double @trunc_signed_f64(double %x) #0 {
; CHECK-LABEL: trunc_signed_f64:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frintz d0, d0
; CHECK-NEXT:    ret
  %i = fptosi double %x to i64
  %r = sitofp i64 %i to double
  ret double %r
}

attributes #0 = { "no-signed-zeros-fp-math" }

