; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-unknown-linux-gnu -mattr=+neon,-use-reciprocal-square-root | FileCheck %s --check-prefix=FAULT
; RUN: llc < %s -mtriple=aarch64-unknown-linux-gnu -mattr=+neon,+use-reciprocal-square-root | FileCheck %s

declare float @llvm.sqrt.f32(float) #0
declare <2 x float> @llvm.sqrt.v2f32(<2 x float>) #0
declare <4 x float> @llvm.sqrt.v4f32(<4 x float>) #0
declare <8 x float> @llvm.sqrt.v8f32(<8 x float>) #0
declare double @llvm.sqrt.f64(double) #0
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>) #0
declare <4 x double> @llvm.sqrt.v4f64(<4 x double>) #0

define float @fsqrt(float %a) #0 {
; FAULT-LABEL: fsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt s0, s0
; FAULT-NEXT:    ret
;
; CHECK-LABEL: fsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte s1, s0
; CHECK-NEXT:    fmul s2, s1, s1
; CHECK-NEXT:    frsqrts s2, s0, s2
; CHECK-NEXT:    fmul s1, s1, s2
; CHECK-NEXT:    fmul s2, s1, s1
; CHECK-NEXT:    frsqrts s2, s0, s2
; CHECK-NEXT:    fmul s2, s2, s0
; CHECK-NEXT:    fmul s1, s1, s2
; CHECK-NEXT:    fcmp s0, #0.0
; CHECK-NEXT:    fcsel s0, s0, s1, eq
; CHECK-NEXT:    ret
  %1 = tail call fast float @llvm.sqrt.f32(float %a)
  ret float %1
}

define float @fsqrt_ieee_denorms(float %a) #1 {
; FAULT-LABEL: fsqrt_ieee_denorms:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt s0, s0
; FAULT-NEXT:    ret
;
; CHECK-LABEL: fsqrt_ieee_denorms:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte s1, s0
; CHECK-NEXT:    fmul s2, s1, s1
; CHECK-NEXT:    frsqrts s2, s0, s2
; CHECK-NEXT:    fmul s1, s1, s2
; CHECK-NEXT:    fmul s2, s1, s1
; CHECK-NEXT:    frsqrts s2, s0, s2
; CHECK-NEXT:    fmul s2, s2, s0
; CHECK-NEXT:    fmul s1, s1, s2
; CHECK-NEXT:    fcmp s0, #0.0
; CHECK-NEXT:    fcsel s0, s0, s1, eq
; CHECK-NEXT:    ret
  %1 = tail call fast float @llvm.sqrt.f32(float %a)
  ret float %1
}

define <2 x float> @f2sqrt(<2 x float> %a) #0 {
; FAULT-LABEL: f2sqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.2s, v0.2s
; FAULT-NEXT:    ret
;
; CHECK-LABEL: f2sqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v1.2s, v0.2s
; CHECK-NEXT:    fmul v2.2s, v1.2s, v1.2s
; CHECK-NEXT:    frsqrts v2.2s, v0.2s, v2.2s
; CHECK-NEXT:    fmul v1.2s, v1.2s, v2.2s
; CHECK-NEXT:    fmul v2.2s, v1.2s, v1.2s
; CHECK-NEXT:    frsqrts v2.2s, v0.2s, v2.2s
; CHECK-NEXT:    fmul v2.2s, v2.2s, v0.2s
; CHECK-NEXT:    fmul v1.2s, v1.2s, v2.2s
; CHECK-NEXT:    fcmeq v2.2s, v0.2s, #0.0
; CHECK-NEXT:    bif v0.8b, v1.8b, v2.8b
; CHECK-NEXT:    ret
  %1 = tail call fast <2 x float> @llvm.sqrt.v2f32(<2 x float> %a)
  ret <2 x float> %1
}

define <4 x float> @f4sqrt(<4 x float> %a) #0 {
; FAULT-LABEL: f4sqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.4s, v0.4s
; FAULT-NEXT:    ret
;
; CHECK-LABEL: f4sqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v1.4s, v0.4s
; CHECK-NEXT:    fmul v2.4s, v1.4s, v1.4s
; CHECK-NEXT:    frsqrts v2.4s, v0.4s, v2.4s
; CHECK-NEXT:    fmul v1.4s, v1.4s, v2.4s
; CHECK-NEXT:    fmul v2.4s, v1.4s, v1.4s
; CHECK-NEXT:    frsqrts v2.4s, v0.4s, v2.4s
; CHECK-NEXT:    fmul v2.4s, v2.4s, v0.4s
; CHECK-NEXT:    fmul v1.4s, v1.4s, v2.4s
; CHECK-NEXT:    fcmeq v2.4s, v0.4s, #0.0
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %1 = tail call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> %a)
  ret <4 x float> %1
}

define <8 x float> @f8sqrt(<8 x float> %a) #0 {
; FAULT-LABEL: f8sqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.4s, v0.4s
; FAULT-NEXT:    fsqrt v1.4s, v1.4s
; FAULT-NEXT:    ret
;
; CHECK-LABEL: f8sqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v2.4s, v0.4s
; CHECK-NEXT:    fmul v3.4s, v2.4s, v2.4s
; CHECK-NEXT:    frsqrts v3.4s, v0.4s, v3.4s
; CHECK-NEXT:    fmul v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    fmul v3.4s, v2.4s, v2.4s
; CHECK-NEXT:    frsqrts v3.4s, v0.4s, v3.4s
; CHECK-NEXT:    fmul v3.4s, v3.4s, v0.4s
; CHECK-NEXT:    fmul v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    fcmeq v3.4s, v0.4s, #0.0
; CHECK-NEXT:    bif v0.16b, v2.16b, v3.16b
; CHECK-NEXT:    frsqrte v2.4s, v1.4s
; CHECK-NEXT:    fmul v3.4s, v2.4s, v2.4s
; CHECK-NEXT:    frsqrts v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    fmul v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    fmul v3.4s, v2.4s, v2.4s
; CHECK-NEXT:    frsqrts v3.4s, v1.4s, v3.4s
; CHECK-NEXT:    fmul v3.4s, v3.4s, v1.4s
; CHECK-NEXT:    fmul v2.4s, v2.4s, v3.4s
; CHECK-NEXT:    fcmeq v3.4s, v1.4s, #0.0
; CHECK-NEXT:    bif v1.16b, v2.16b, v3.16b
; CHECK-NEXT:    ret
  %1 = tail call fast <8 x float> @llvm.sqrt.v8f32(<8 x float> %a)
  ret <8 x float> %1
}

define double @dsqrt(double %a) #0 {
; FAULT-LABEL: dsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    ret
;
; CHECK-LABEL: dsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d2, d2, d0
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fcmp d0, #0.0
; CHECK-NEXT:    fcsel d0, d0, d1, eq
; CHECK-NEXT:    ret
  %1 = tail call fast double @llvm.sqrt.f64(double %a)
  ret double %1
}

define double @dsqrt_ieee_denorms(double %a) #1 {
; FAULT-LABEL: dsqrt_ieee_denorms:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    ret
;
; CHECK-LABEL: dsqrt_ieee_denorms:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d2, d2, d0
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fcmp d0, #0.0
; CHECK-NEXT:    fcsel d0, d0, d1, eq
; CHECK-NEXT:    ret
  %1 = tail call fast double @llvm.sqrt.f64(double %a)
  ret double %1
}

define <2 x double> @d2sqrt(<2 x double> %a) #0 {
; FAULT-LABEL: d2sqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.2d, v0.2d
; FAULT-NEXT:    ret
;
; CHECK-LABEL: d2sqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v1.2d, v0.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v0.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fcmeq v2.2d, v0.2d, #0.0
; CHECK-NEXT:    bif v0.16b, v1.16b, v2.16b
; CHECK-NEXT:    ret
  %1 = tail call fast <2 x double> @llvm.sqrt.v2f64(<2 x double> %a)
  ret <2 x double> %1
}

define <4 x double> @d4sqrt(<4 x double> %a) #0 {
; FAULT-LABEL: d4sqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.2d, v0.2d
; FAULT-NEXT:    fsqrt v1.2d, v1.2d
; FAULT-NEXT:    ret
;
; CHECK-LABEL: d4sqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v2.2d, v0.2d
; CHECK-NEXT:    fmul v3.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v3.2d, v0.2d, v3.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v3.2d
; CHECK-NEXT:    fmul v3.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v3.2d, v0.2d, v3.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v3.2d
; CHECK-NEXT:    fmul v3.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v3.2d, v0.2d, v3.2d
; CHECK-NEXT:    fmul v3.2d, v3.2d, v0.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v3.2d
; CHECK-NEXT:    fcmeq v3.2d, v0.2d, #0.0
; CHECK-NEXT:    bif v0.16b, v2.16b, v3.16b
; CHECK-NEXT:    frsqrte v2.2d, v1.2d
; CHECK-NEXT:    fmul v3.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v3.2d, v1.2d, v3.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v3.2d
; CHECK-NEXT:    fmul v3.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v3.2d, v1.2d, v3.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v3.2d
; CHECK-NEXT:    fmul v3.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v3.2d, v1.2d, v3.2d
; CHECK-NEXT:    fmul v3.2d, v3.2d, v1.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v3.2d
; CHECK-NEXT:    fcmeq v3.2d, v1.2d, #0.0
; CHECK-NEXT:    bif v1.16b, v2.16b, v3.16b
; CHECK-NEXT:    ret
  %1 = tail call fast <4 x double> @llvm.sqrt.v4f64(<4 x double> %a)
  ret <4 x double> %1
}

define float @frsqrt(float %a) #0 {
; FAULT-LABEL: frsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt s0, s0
; FAULT-NEXT:    fmov s1, #1.00000000
; FAULT-NEXT:    fdiv s0, s1, s0
; FAULT-NEXT:    ret
;
; CHECK-LABEL: frsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte s1, s0
; CHECK-NEXT:    fmul s2, s1, s1
; CHECK-NEXT:    frsqrts s2, s0, s2
; CHECK-NEXT:    fmul s1, s1, s2
; CHECK-NEXT:    fmul s2, s1, s1
; CHECK-NEXT:    frsqrts s0, s0, s2
; CHECK-NEXT:    fmul s0, s1, s0
; CHECK-NEXT:    ret
  %1 = tail call fast float @llvm.sqrt.f32(float %a)
  %2 = fdiv fast float 1.000000e+00, %1
  ret float %2
}

define <2 x float> @f2rsqrt(<2 x float> %a) #0 {
; FAULT-LABEL: f2rsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.2s, v0.2s
; FAULT-NEXT:    fmov v1.2s, #1.00000000
; FAULT-NEXT:    fdiv v0.2s, v1.2s, v0.2s
; FAULT-NEXT:    ret
;
; CHECK-LABEL: f2rsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v1.2s, v0.2s
; CHECK-NEXT:    fmul v2.2s, v1.2s, v1.2s
; CHECK-NEXT:    frsqrts v2.2s, v0.2s, v2.2s
; CHECK-NEXT:    fmul v1.2s, v1.2s, v2.2s
; CHECK-NEXT:    fmul v2.2s, v1.2s, v1.2s
; CHECK-NEXT:    frsqrts v0.2s, v0.2s, v2.2s
; CHECK-NEXT:    fmul v0.2s, v1.2s, v0.2s
; CHECK-NEXT:    ret
  %1 = tail call fast <2 x float> @llvm.sqrt.v2f32(<2 x float> %a)
  %2 = fdiv fast <2 x float> <float 1.000000e+00, float 1.000000e+00>, %1
  ret <2 x float> %2
}

define <4 x float> @f4rsqrt(<4 x float> %a) #0 {
; FAULT-LABEL: f4rsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.4s, v0.4s
; FAULT-NEXT:    fmov v1.4s, #1.00000000
; FAULT-NEXT:    fdiv v0.4s, v1.4s, v0.4s
; FAULT-NEXT:    ret
;
; CHECK-LABEL: f4rsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v1.4s, v0.4s
; CHECK-NEXT:    fmul v2.4s, v1.4s, v1.4s
; CHECK-NEXT:    frsqrts v2.4s, v0.4s, v2.4s
; CHECK-NEXT:    fmul v1.4s, v1.4s, v2.4s
; CHECK-NEXT:    fmul v2.4s, v1.4s, v1.4s
; CHECK-NEXT:    frsqrts v0.4s, v0.4s, v2.4s
; CHECK-NEXT:    fmul v0.4s, v1.4s, v0.4s
; CHECK-NEXT:    ret
  %1 = tail call fast <4 x float> @llvm.sqrt.v4f32(<4 x float> %a)
  %2 = fdiv fast <4 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %1
  ret <4 x float> %2
}

define <8 x float> @f8rsqrt(<8 x float> %a) #0 {
; FAULT-LABEL: f8rsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v1.4s, v1.4s
; FAULT-NEXT:    fsqrt v0.4s, v0.4s
; FAULT-NEXT:    fmov v2.4s, #1.00000000
; FAULT-NEXT:    fdiv v0.4s, v2.4s, v0.4s
; FAULT-NEXT:    fdiv v1.4s, v2.4s, v1.4s
; FAULT-NEXT:    ret
;
; CHECK-LABEL: f8rsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v2.4s, v0.4s
; CHECK-NEXT:    fmul v4.4s, v2.4s, v2.4s
; CHECK-NEXT:    frsqrte v3.4s, v1.4s
; CHECK-NEXT:    frsqrts v4.4s, v0.4s, v4.4s
; CHECK-NEXT:    fmul v2.4s, v2.4s, v4.4s
; CHECK-NEXT:    fmul v4.4s, v3.4s, v3.4s
; CHECK-NEXT:    frsqrts v4.4s, v1.4s, v4.4s
; CHECK-NEXT:    fmul v3.4s, v3.4s, v4.4s
; CHECK-NEXT:    fmul v4.4s, v2.4s, v2.4s
; CHECK-NEXT:    frsqrts v0.4s, v0.4s, v4.4s
; CHECK-NEXT:    fmul v4.4s, v3.4s, v3.4s
; CHECK-NEXT:    frsqrts v1.4s, v1.4s, v4.4s
; CHECK-NEXT:    fmul v0.4s, v2.4s, v0.4s
; CHECK-NEXT:    fmul v1.4s, v3.4s, v1.4s
; CHECK-NEXT:    ret
  %1 = tail call fast <8 x float> @llvm.sqrt.v8f32(<8 x float> %a)
  %2 = fdiv fast <8 x float> <float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00, float 1.000000e+00>, %1
  ret <8 x float> %2
}

define double @drsqrt(double %a) #0 {
; FAULT-LABEL: drsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    fmov d1, #1.00000000
; FAULT-NEXT:    fdiv d0, d1, d0
; FAULT-NEXT:    ret
;
; CHECK-LABEL: drsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d0, d0, d2
; CHECK-NEXT:    fmul d0, d1, d0
; CHECK-NEXT:    ret
  %1 = tail call fast double @llvm.sqrt.f64(double %a)
  %2 = fdiv fast double 1.000000e+00, %1
  ret double %2
}

define <2 x double> @d2rsqrt(<2 x double> %a) #0 {
; FAULT-LABEL: d2rsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.2d, v0.2d
; FAULT-NEXT:    fmov v1.2d, #1.00000000
; FAULT-NEXT:    fdiv v0.2d, v1.2d, v0.2d
; FAULT-NEXT:    ret
;
; CHECK-LABEL: d2rsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v1.2d, v0.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v0.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v0.2d, v1.2d, v0.2d
; CHECK-NEXT:    ret
  %1 = tail call fast <2 x double> @llvm.sqrt.v2f64(<2 x double> %a)
  %2 = fdiv fast <2 x double> <double 1.000000e+00, double 1.000000e+00>, %1
  ret <2 x double> %2
}

define <4 x double> @d4rsqrt(<4 x double> %a) #0 {
; FAULT-LABEL: d4rsqrt:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v1.2d, v1.2d
; FAULT-NEXT:    fsqrt v0.2d, v0.2d
; FAULT-NEXT:    fmov v2.2d, #1.00000000
; FAULT-NEXT:    fdiv v0.2d, v2.2d, v0.2d
; FAULT-NEXT:    fdiv v1.2d, v2.2d, v1.2d
; FAULT-NEXT:    ret
;
; CHECK-LABEL: d4rsqrt:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v2.2d, v0.2d
; CHECK-NEXT:    fmul v4.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrte v3.2d, v1.2d
; CHECK-NEXT:    frsqrts v4.2d, v0.2d, v4.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v4.2d
; CHECK-NEXT:    fmul v4.2d, v3.2d, v3.2d
; CHECK-NEXT:    frsqrts v4.2d, v1.2d, v4.2d
; CHECK-NEXT:    fmul v3.2d, v3.2d, v4.2d
; CHECK-NEXT:    fmul v4.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v4.2d, v0.2d, v4.2d
; CHECK-NEXT:    fmul v2.2d, v2.2d, v4.2d
; CHECK-NEXT:    fmul v4.2d, v3.2d, v3.2d
; CHECK-NEXT:    frsqrts v4.2d, v1.2d, v4.2d
; CHECK-NEXT:    fmul v3.2d, v3.2d, v4.2d
; CHECK-NEXT:    fmul v4.2d, v2.2d, v2.2d
; CHECK-NEXT:    frsqrts v0.2d, v0.2d, v4.2d
; CHECK-NEXT:    fmul v4.2d, v3.2d, v3.2d
; CHECK-NEXT:    frsqrts v1.2d, v1.2d, v4.2d
; CHECK-NEXT:    fmul v0.2d, v2.2d, v0.2d
; CHECK-NEXT:    fmul v1.2d, v3.2d, v1.2d
; CHECK-NEXT:    ret
  %1 = tail call fast <4 x double> @llvm.sqrt.v4f64(<4 x double> %a)
  %2 = fdiv fast <4 x double> <double 1.000000e+00, double 1.000000e+00, double 1.000000e+00, double 1.000000e+00>, %1
  ret <4 x double> %2
}

define double @sqrt_fdiv_common_operand(double %x) nounwind {
; FAULT-LABEL: sqrt_fdiv_common_operand:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    ret
;
; CHECK-LABEL: sqrt_fdiv_common_operand:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d0, d0, d1
; CHECK-NEXT:    ret
  %sqrt = call fast double @llvm.sqrt.f64(double %x)
  %r = fdiv fast double %x, %sqrt
  ret double %r
}

define <2 x double> @sqrt_fdiv_common_operand_vec(<2 x double> %x) nounwind {
; FAULT-LABEL: sqrt_fdiv_common_operand_vec:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt v0.2d, v0.2d
; FAULT-NEXT:    ret
;
; CHECK-LABEL: sqrt_fdiv_common_operand_vec:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte v1.2d, v0.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fmul v2.2d, v1.2d, v1.2d
; CHECK-NEXT:    frsqrts v2.2d, v0.2d, v2.2d
; CHECK-NEXT:    fmul v1.2d, v1.2d, v2.2d
; CHECK-NEXT:    fmul v0.2d, v0.2d, v1.2d
; CHECK-NEXT:    ret
  %sqrt = call <2 x double> @llvm.sqrt.v2f64(<2 x double> %x)
  %r = fdiv arcp nsz reassoc <2 x double> %x, %sqrt
  ret <2 x double> %r
}

define double @sqrt_fdiv_common_operand_extra_use(double %x, double* %p) nounwind {
; FAULT-LABEL: sqrt_fdiv_common_operand_extra_use:
; FAULT:       // %bb.0:
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    str d0, [x0]
; FAULT-NEXT:    ret
;
; CHECK-LABEL: sqrt_fdiv_common_operand_extra_use:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fcmp d0, #0.0
; CHECK-NEXT:    fmul d1, d0, d1
; CHECK-NEXT:    fcsel d0, d0, d1, eq
; CHECK-NEXT:    str d0, [x0]
; CHECK-NEXT:    mov v0.16b, v1.16b
; CHECK-NEXT:    ret
  %sqrt = call fast double @llvm.sqrt.f64(double %x)
  store double %sqrt, double* %p
  %r = fdiv fast double %x, %sqrt
  ret double %r
}

define double @sqrt_simplify_before_recip_3_uses(double %x, double* %p1, double* %p2) nounwind {
; FAULT-LABEL: sqrt_simplify_before_recip_3_uses:
; FAULT:       // %bb.0:
; FAULT-NEXT:    mov x8, #4631107791820423168
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    fmov d1, #1.00000000
; FAULT-NEXT:    fmov d2, x8
; FAULT-NEXT:    fdiv d1, d1, d0
; FAULT-NEXT:    fdiv d2, d2, d0
; FAULT-NEXT:    str d1, [x0]
; FAULT-NEXT:    str d2, [x1]
; FAULT-NEXT:    ret
;
; CHECK-LABEL: sqrt_simplify_before_recip_3_uses:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmul d2, d1, d1
; CHECK-NEXT:    mov x8, #4631107791820423168
; CHECK-NEXT:    frsqrts d2, d0, d2
; CHECK-NEXT:    fmul d1, d1, d2
; CHECK-NEXT:    fmov d2, x8
; CHECK-NEXT:    fmul d2, d1, d2
; CHECK-NEXT:    fmul d0, d0, d1
; CHECK-NEXT:    str d1, [x0]
; CHECK-NEXT:    str d2, [x1]
; CHECK-NEXT:    ret
  %sqrt = tail call fast double @llvm.sqrt.f64(double %x)
  %rsqrt = fdiv fast double 1.0, %sqrt
  %r = fdiv fast double 42.0, %sqrt
  %sqrt_fast = fdiv fast double %x, %sqrt
  store double %rsqrt, double* %p1, align 8
  store double %r, double* %p2, align 8
  ret double %sqrt_fast
}

define double @sqrt_simplify_before_recip_3_uses_order(double %x, double* %p1, double* %p2) nounwind {
; FAULT-LABEL: sqrt_simplify_before_recip_3_uses_order:
; FAULT:       // %bb.0:
; FAULT-NEXT:    mov x9, #140737488355328
; FAULT-NEXT:    mov x8, #4631107791820423168
; FAULT-NEXT:    movk x9, #16453, lsl #48
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    fmov d1, x8
; FAULT-NEXT:    fmov d2, x9
; FAULT-NEXT:    fdiv d1, d1, d0
; FAULT-NEXT:    fdiv d2, d2, d0
; FAULT-NEXT:    str d1, [x0]
; FAULT-NEXT:    str d2, [x1]
; FAULT-NEXT:    ret
;
; CHECK-LABEL: sqrt_simplify_before_recip_3_uses_order:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d3, d1, d1
; CHECK-NEXT:    frsqrts d3, d0, d3
; CHECK-NEXT:    fmul d1, d1, d3
; CHECK-NEXT:    fmul d3, d1, d1
; CHECK-NEXT:    frsqrts d3, d0, d3
; CHECK-NEXT:    mov x8, #4631107791820423168
; CHECK-NEXT:    fmul d1, d1, d3
; CHECK-NEXT:    fmov d2, x8
; CHECK-NEXT:    mov x8, #140737488355328
; CHECK-NEXT:    fmul d3, d1, d1
; CHECK-NEXT:    movk x8, #16453, lsl #48
; CHECK-NEXT:    frsqrts d3, d0, d3
; CHECK-NEXT:    fmul d1, d1, d3
; CHECK-NEXT:    fmov d3, x8
; CHECK-NEXT:    fmul d0, d0, d1
; CHECK-NEXT:    fmul d2, d1, d2
; CHECK-NEXT:    fmul d1, d1, d3
; CHECK-NEXT:    str d2, [x0]
; CHECK-NEXT:    str d1, [x1]
; CHECK-NEXT:    ret
  %sqrt = tail call fast double @llvm.sqrt.f64(double %x)
  %sqrt_fast = fdiv fast double %x, %sqrt
  %r1 = fdiv fast double 42.0, %sqrt
  %r2 = fdiv fast double 43.0, %sqrt
  store double %r1, double* %p1, align 8
  store double %r2, double* %p2, align 8
  ret double %sqrt_fast
}


define double @sqrt_simplify_before_recip_4_uses(double %x, double* %p1, double* %p2, double* %p3) nounwind {
; FAULT-LABEL: sqrt_simplify_before_recip_4_uses:
; FAULT:       // %bb.0:
; FAULT-NEXT:    mov x8, #4631107791820423168
; FAULT-NEXT:    fmov d2, x8
; FAULT-NEXT:    mov x8, #140737488355328
; FAULT-NEXT:    fsqrt d0, d0
; FAULT-NEXT:    fmov d1, #1.00000000
; FAULT-NEXT:    movk x8, #16453, lsl #48
; FAULT-NEXT:    fdiv d1, d1, d0
; FAULT-NEXT:    fmov d3, x8
; FAULT-NEXT:    fmul d2, d1, d2
; FAULT-NEXT:    fmul d3, d1, d3
; FAULT-NEXT:    str d1, [x0]
; FAULT-NEXT:    str d2, [x1]
; FAULT-NEXT:    str d3, [x2]
; FAULT-NEXT:    ret
;
; CHECK-LABEL: sqrt_simplify_before_recip_4_uses:
; CHECK:       // %bb.0:
; CHECK-NEXT:    frsqrte d1, d0
; CHECK-NEXT:    fmul d3, d1, d1
; CHECK-NEXT:    frsqrts d3, d0, d3
; CHECK-NEXT:    fmul d1, d1, d3
; CHECK-NEXT:    fmul d3, d1, d1
; CHECK-NEXT:    frsqrts d3, d0, d3
; CHECK-NEXT:    fmul d1, d1, d3
; CHECK-NEXT:    mov x8, #4631107791820423168
; CHECK-NEXT:    fmul d3, d1, d1
; CHECK-NEXT:    fmov d2, x8
; CHECK-NEXT:    mov x8, #140737488355328
; CHECK-NEXT:    frsqrts d3, d0, d3
; CHECK-NEXT:    movk x8, #16453, lsl #48
; CHECK-NEXT:    fmul d1, d1, d3
; CHECK-NEXT:    fcmp d0, #0.0
; CHECK-NEXT:    fmov d4, x8
; CHECK-NEXT:    fmul d3, d0, d1
; CHECK-NEXT:    fmul d2, d1, d2
; CHECK-NEXT:    fmul d4, d1, d4
; CHECK-NEXT:    str d1, [x0]
; CHECK-NEXT:    fcsel d1, d0, d3, eq
; CHECK-NEXT:    fdiv d0, d0, d1
; CHECK-NEXT:    str d2, [x1]
; CHECK-NEXT:    str d4, [x2]
; CHECK-NEXT:    ret
  %sqrt = tail call fast double @llvm.sqrt.f64(double %x)
  %rsqrt = fdiv fast double 1.0, %sqrt
  %r1 = fdiv fast double 42.0, %sqrt
  %r2 = fdiv fast double 43.0, %sqrt
  %sqrt_fast = fdiv fast double %x, %sqrt
  store double %rsqrt, double* %p1, align 8
  store double %r1, double* %p2, align 8
  store double %r2, double* %p3, align 8
  ret double %sqrt_fast
}

attributes #0 = { "unsafe-fp-math" }
attributes #1 = { "unsafe-fp-math" "denormal-fp-math"="ieee" }
