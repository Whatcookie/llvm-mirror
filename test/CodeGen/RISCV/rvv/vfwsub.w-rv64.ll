; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -mtriple=riscv64 -mattr=+experimental-v,+d,+experimental-zfh -verify-machineinstrs \
; RUN:   --riscv-no-aliases < %s | FileCheck %s
declare <vscale x 1 x float> @llvm.riscv.vfwsub.w.nxv1f32.nxv1f16(
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  i64);

define <vscale x 1 x float> @intrinsic_vfwsub.w_wv_nxv1f32_nxv1f32_nxv1f16(<vscale x 1 x float> %0, <vscale x 1 x half> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv1f32_nxv1f32_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf4,ta,mu
; CHECK-NEXT:    vfwsub.wv v25, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwsub.w.nxv1f32.nxv1f16(
    <vscale x 1 x float> %0,
    <vscale x 1 x half> %1,
    i64 %2)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwsub.w.mask.nxv1f32.nxv1f16(
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  <vscale x 1 x half>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x float> @intrinsic_vfwsub.w_mask_wv_nxv1f32_nxv1f32_nxv1f16(<vscale x 1 x float> %0, <vscale x 1 x float> %1, <vscale x 1 x half> %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv1f32_nxv1f32_nxv1f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf4,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v9, v10, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwsub.w.mask.nxv1f32.nxv1f16(
    <vscale x 1 x float> %0,
    <vscale x 1 x float> %1,
    <vscale x 1 x half> %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwsub.w.nxv2f32.nxv2f16(
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  i64);

define <vscale x 2 x float> @intrinsic_vfwsub.w_wv_nxv2f32_nxv2f32_nxv2f16(<vscale x 2 x float> %0, <vscale x 2 x half> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv2f32_nxv2f32_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf2,ta,mu
; CHECK-NEXT:    vfwsub.wv v25, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwsub.w.nxv2f32.nxv2f16(
    <vscale x 2 x float> %0,
    <vscale x 2 x half> %1,
    i64 %2)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwsub.w.mask.nxv2f32.nxv2f16(
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  <vscale x 2 x half>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x float> @intrinsic_vfwsub.w_mask_wv_nxv2f32_nxv2f32_nxv2f16(<vscale x 2 x float> %0, <vscale x 2 x float> %1, <vscale x 2 x half> %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv2f32_nxv2f32_nxv2f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,mf2,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v9, v10, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwsub.w.mask.nxv2f32.nxv2f16(
    <vscale x 2 x float> %0,
    <vscale x 2 x float> %1,
    <vscale x 2 x half> %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwsub.w.nxv4f32.nxv4f16(
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  i64);

define <vscale x 4 x float> @intrinsic_vfwsub.w_wv_nxv4f32_nxv4f32_nxv4f16(<vscale x 4 x float> %0, <vscale x 4 x half> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv4f32_nxv4f32_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m1,ta,mu
; CHECK-NEXT:    vfwsub.wv v26, v8, v10
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwsub.w.nxv4f32.nxv4f16(
    <vscale x 4 x float> %0,
    <vscale x 4 x half> %1,
    i64 %2)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwsub.w.mask.nxv4f32.nxv4f16(
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  <vscale x 4 x half>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x float> @intrinsic_vfwsub.w_mask_wv_nxv4f32_nxv4f32_nxv4f16(<vscale x 4 x float> %0, <vscale x 4 x float> %1, <vscale x 4 x half> %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv4f32_nxv4f32_nxv4f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m1,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v10, v12, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwsub.w.mask.nxv4f32.nxv4f16(
    <vscale x 4 x float> %0,
    <vscale x 4 x float> %1,
    <vscale x 4 x half> %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwsub.w.nxv8f32.nxv8f16(
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  i64);

define <vscale x 8 x float> @intrinsic_vfwsub.w_wv_nxv8f32_nxv8f32_nxv8f16(<vscale x 8 x float> %0, <vscale x 8 x half> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv8f32_nxv8f32_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m2,ta,mu
; CHECK-NEXT:    vfwsub.wv v28, v8, v12
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwsub.w.nxv8f32.nxv8f16(
    <vscale x 8 x float> %0,
    <vscale x 8 x half> %1,
    i64 %2)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwsub.w.mask.nxv8f32.nxv8f16(
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  <vscale x 8 x half>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x float> @intrinsic_vfwsub.w_mask_wv_nxv8f32_nxv8f32_nxv8f16(<vscale x 8 x float> %0, <vscale x 8 x float> %1, <vscale x 8 x half> %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv8f32_nxv8f32_nxv8f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m2,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v12, v16, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwsub.w.mask.nxv8f32.nxv8f16(
    <vscale x 8 x float> %0,
    <vscale x 8 x float> %1,
    <vscale x 8 x half> %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwsub.w.nxv16f32.nxv16f16(
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  i64);

define <vscale x 16 x float> @intrinsic_vfwsub.w_wv_nxv16f32_nxv16f32_nxv16f16(<vscale x 16 x float> %0, <vscale x 16 x half> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv16f32_nxv16f32_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e16,m4,ta,mu
; CHECK-NEXT:    vfwsub.wv v24, v8, v16
; CHECK-NEXT:    vmv8r.v v8, v24
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwsub.w.nxv16f32.nxv16f16(
    <vscale x 16 x float> %0,
    <vscale x 16 x half> %1,
    i64 %2)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwsub.w.mask.nxv16f32.nxv16f16(
  <vscale x 16 x float>,
  <vscale x 16 x float>,
  <vscale x 16 x half>,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x float> @intrinsic_vfwsub.w_mask_wv_nxv16f32_nxv16f32_nxv16f16(<vscale x 16 x float> %0, <vscale x 16 x float> %1, <vscale x 16 x half> %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv16f32_nxv16f32_nxv16f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vl4re16.v v28, (a0)
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v16, v28, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwsub.w.mask.nxv16f32.nxv16f16(
    <vscale x 16 x float> %0,
    <vscale x 16 x float> %1,
    <vscale x 16 x half> %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwsub.w.nxv1f64.nxv1f32(
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  i64);

define <vscale x 1 x double> @intrinsic_vfwsub.w_wv_nxv1f64_nxv1f64_nxv1f32(<vscale x 1 x double> %0, <vscale x 1 x float> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv1f64_nxv1f64_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,mf2,ta,mu
; CHECK-NEXT:    vfwsub.wv v25, v8, v9
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwsub.w.nxv1f64.nxv1f32(
    <vscale x 1 x double> %0,
    <vscale x 1 x float> %1,
    i64 %2)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwsub.w.mask.nxv1f64.nxv1f32(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  <vscale x 1 x float>,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x double> @intrinsic_vfwsub.w_mask_wv_nxv1f64_nxv1f64_nxv1f32(<vscale x 1 x double> %0, <vscale x 1 x double> %1, <vscale x 1 x float> %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv1f64_nxv1f64_nxv1f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,mf2,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v9, v10, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwsub.w.mask.nxv1f64.nxv1f32(
    <vscale x 1 x double> %0,
    <vscale x 1 x double> %1,
    <vscale x 1 x float> %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwsub.w.nxv2f64.nxv2f32(
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  i64);

define <vscale x 2 x double> @intrinsic_vfwsub.w_wv_nxv2f64_nxv2f64_nxv2f32(<vscale x 2 x double> %0, <vscale x 2 x float> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv2f64_nxv2f64_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m1,ta,mu
; CHECK-NEXT:    vfwsub.wv v26, v8, v10
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwsub.w.nxv2f64.nxv2f32(
    <vscale x 2 x double> %0,
    <vscale x 2 x float> %1,
    i64 %2)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwsub.w.mask.nxv2f64.nxv2f32(
  <vscale x 2 x double>,
  <vscale x 2 x double>,
  <vscale x 2 x float>,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x double> @intrinsic_vfwsub.w_mask_wv_nxv2f64_nxv2f64_nxv2f32(<vscale x 2 x double> %0, <vscale x 2 x double> %1, <vscale x 2 x float> %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv2f64_nxv2f64_nxv2f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m1,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v10, v12, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwsub.w.mask.nxv2f64.nxv2f32(
    <vscale x 2 x double> %0,
    <vscale x 2 x double> %1,
    <vscale x 2 x float> %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwsub.w.nxv4f64.nxv4f32(
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  i64);

define <vscale x 4 x double> @intrinsic_vfwsub.w_wv_nxv4f64_nxv4f64_nxv4f32(<vscale x 4 x double> %0, <vscale x 4 x float> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv4f64_nxv4f64_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m2,ta,mu
; CHECK-NEXT:    vfwsub.wv v28, v8, v12
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwsub.w.nxv4f64.nxv4f32(
    <vscale x 4 x double> %0,
    <vscale x 4 x float> %1,
    i64 %2)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwsub.w.mask.nxv4f64.nxv4f32(
  <vscale x 4 x double>,
  <vscale x 4 x double>,
  <vscale x 4 x float>,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x double> @intrinsic_vfwsub.w_mask_wv_nxv4f64_nxv4f64_nxv4f32(<vscale x 4 x double> %0, <vscale x 4 x double> %1, <vscale x 4 x float> %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv4f64_nxv4f64_nxv4f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m2,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v12, v16, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwsub.w.mask.nxv4f64.nxv4f32(
    <vscale x 4 x double> %0,
    <vscale x 4 x double> %1,
    <vscale x 4 x float> %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwsub.w.nxv8f64.nxv8f32(
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  i64);

define <vscale x 8 x double> @intrinsic_vfwsub.w_wv_nxv8f64_nxv8f64_nxv8f32(<vscale x 8 x double> %0, <vscale x 8 x float> %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wv_nxv8f64_nxv8f64_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vsetvli a0, a0, e32,m4,ta,mu
; CHECK-NEXT:    vfwsub.wv v24, v8, v16
; CHECK-NEXT:    vmv8r.v v8, v24
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwsub.w.nxv8f64.nxv8f32(
    <vscale x 8 x double> %0,
    <vscale x 8 x float> %1,
    i64 %2)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwsub.w.mask.nxv8f64.nxv8f32(
  <vscale x 8 x double>,
  <vscale x 8 x double>,
  <vscale x 8 x float>,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x double> @intrinsic_vfwsub.w_mask_wv_nxv8f64_nxv8f64_nxv8f32(<vscale x 8 x double> %0, <vscale x 8 x double> %1, <vscale x 8 x float> %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wv_nxv8f64_nxv8f64_nxv8f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vl4re32.v v28, (a0)
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,tu,mu
; CHECK-NEXT:    vfwsub.wv v8, v16, v28, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwsub.w.mask.nxv8f64.nxv8f32(
    <vscale x 8 x double> %0,
    <vscale x 8 x double> %1,
    <vscale x 8 x float> %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x double> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwsub.w.nxv1f32.f16(
  <vscale x 1 x float>,
  half,
  i64);

define <vscale x 1 x float> @intrinsic_vfwsub.w_wf_nxv1f32_nxv1f32_f16(<vscale x 1 x float> %0, half %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv1f32_nxv1f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf4,ta,mu
; CHECK-NEXT:    vfwsub.wf v25, v8, ft0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwsub.w.nxv1f32.f16(
    <vscale x 1 x float> %0,
    half %1,
    i64 %2)

  ret <vscale x 1 x float> %a
}

declare <vscale x 1 x float> @llvm.riscv.vfwsub.w.mask.nxv1f32.f16(
  <vscale x 1 x float>,
  <vscale x 1 x float>,
  half,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x float> @intrinsic_vfwsub.w_mask_wf_nxv1f32_nxv1f32_f16(<vscale x 1 x float> %0, <vscale x 1 x float> %1, half %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv1f32_nxv1f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf4,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v9, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x float> @llvm.riscv.vfwsub.w.mask.nxv1f32.f16(
    <vscale x 1 x float> %0,
    <vscale x 1 x float> %1,
    half %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwsub.w.nxv2f32.f16(
  <vscale x 2 x float>,
  half,
  i64);

define <vscale x 2 x float> @intrinsic_vfwsub.w_wf_nxv2f32_nxv2f32_f16(<vscale x 2 x float> %0, half %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv2f32_nxv2f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf2,ta,mu
; CHECK-NEXT:    vfwsub.wf v25, v8, ft0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwsub.w.nxv2f32.f16(
    <vscale x 2 x float> %0,
    half %1,
    i64 %2)

  ret <vscale x 2 x float> %a
}

declare <vscale x 2 x float> @llvm.riscv.vfwsub.w.mask.nxv2f32.f16(
  <vscale x 2 x float>,
  <vscale x 2 x float>,
  half,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x float> @intrinsic_vfwsub.w_mask_wf_nxv2f32_nxv2f32_f16(<vscale x 2 x float> %0, <vscale x 2 x float> %1, half %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv2f32_nxv2f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,mf2,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v9, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x float> @llvm.riscv.vfwsub.w.mask.nxv2f32.f16(
    <vscale x 2 x float> %0,
    <vscale x 2 x float> %1,
    half %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwsub.w.nxv4f32.f16(
  <vscale x 4 x float>,
  half,
  i64);

define <vscale x 4 x float> @intrinsic_vfwsub.w_wf_nxv4f32_nxv4f32_f16(<vscale x 4 x float> %0, half %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv4f32_nxv4f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m1,ta,mu
; CHECK-NEXT:    vfwsub.wf v26, v8, ft0
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwsub.w.nxv4f32.f16(
    <vscale x 4 x float> %0,
    half %1,
    i64 %2)

  ret <vscale x 4 x float> %a
}

declare <vscale x 4 x float> @llvm.riscv.vfwsub.w.mask.nxv4f32.f16(
  <vscale x 4 x float>,
  <vscale x 4 x float>,
  half,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x float> @intrinsic_vfwsub.w_mask_wf_nxv4f32_nxv4f32_f16(<vscale x 4 x float> %0, <vscale x 4 x float> %1, half %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv4f32_nxv4f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m1,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v10, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x float> @llvm.riscv.vfwsub.w.mask.nxv4f32.f16(
    <vscale x 4 x float> %0,
    <vscale x 4 x float> %1,
    half %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwsub.w.nxv8f32.f16(
  <vscale x 8 x float>,
  half,
  i64);

define <vscale x 8 x float> @intrinsic_vfwsub.w_wf_nxv8f32_nxv8f32_f16(<vscale x 8 x float> %0, half %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv8f32_nxv8f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m2,ta,mu
; CHECK-NEXT:    vfwsub.wf v28, v8, ft0
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwsub.w.nxv8f32.f16(
    <vscale x 8 x float> %0,
    half %1,
    i64 %2)

  ret <vscale x 8 x float> %a
}

declare <vscale x 8 x float> @llvm.riscv.vfwsub.w.mask.nxv8f32.f16(
  <vscale x 8 x float>,
  <vscale x 8 x float>,
  half,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x float> @intrinsic_vfwsub.w_mask_wf_nxv8f32_nxv8f32_f16(<vscale x 8 x float> %0, <vscale x 8 x float> %1, half %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv8f32_nxv8f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m2,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v12, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x float> @llvm.riscv.vfwsub.w.mask.nxv8f32.f16(
    <vscale x 8 x float> %0,
    <vscale x 8 x float> %1,
    half %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwsub.w.nxv16f32.f16(
  <vscale x 16 x float>,
  half,
  i64);

define <vscale x 16 x float> @intrinsic_vfwsub.w_wf_nxv16f32_nxv16f32_f16(<vscale x 16 x float> %0, half %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv16f32_nxv16f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,ta,mu
; CHECK-NEXT:    vfwsub.wf v16, v8, ft0
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwsub.w.nxv16f32.f16(
    <vscale x 16 x float> %0,
    half %1,
    i64 %2)

  ret <vscale x 16 x float> %a
}

declare <vscale x 16 x float> @llvm.riscv.vfwsub.w.mask.nxv16f32.f16(
  <vscale x 16 x float>,
  <vscale x 16 x float>,
  half,
  <vscale x 16 x i1>,
  i64);

define <vscale x 16 x float> @intrinsic_vfwsub.w_mask_wf_nxv16f32_nxv16f32_f16(<vscale x 16 x float> %0, <vscale x 16 x float> %1, half %2, <vscale x 16 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv16f32_nxv16f32_f16:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.h.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e16,m4,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v16, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 16 x float> @llvm.riscv.vfwsub.w.mask.nxv16f32.f16(
    <vscale x 16 x float> %0,
    <vscale x 16 x float> %1,
    half %2,
    <vscale x 16 x i1> %3,
    i64 %4)

  ret <vscale x 16 x float> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwsub.w.nxv1f64.f32(
  <vscale x 1 x double>,
  float,
  i64);

define <vscale x 1 x double> @intrinsic_vfwsub.w_wf_nxv1f64_nxv1f64_f32(<vscale x 1 x double> %0, float %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv1f64_nxv1f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,mf2,ta,mu
; CHECK-NEXT:    vfwsub.wf v25, v8, ft0
; CHECK-NEXT:    vmv1r.v v8, v25
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwsub.w.nxv1f64.f32(
    <vscale x 1 x double> %0,
    float %1,
    i64 %2)

  ret <vscale x 1 x double> %a
}

declare <vscale x 1 x double> @llvm.riscv.vfwsub.w.mask.nxv1f64.f32(
  <vscale x 1 x double>,
  <vscale x 1 x double>,
  float,
  <vscale x 1 x i1>,
  i64);

define <vscale x 1 x double> @intrinsic_vfwsub.w_mask_wf_nxv1f64_nxv1f64_f32(<vscale x 1 x double> %0, <vscale x 1 x double> %1, float %2, <vscale x 1 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv1f64_nxv1f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,mf2,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v9, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 1 x double> @llvm.riscv.vfwsub.w.mask.nxv1f64.f32(
    <vscale x 1 x double> %0,
    <vscale x 1 x double> %1,
    float %2,
    <vscale x 1 x i1> %3,
    i64 %4)

  ret <vscale x 1 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwsub.w.nxv2f64.f32(
  <vscale x 2 x double>,
  float,
  i64);

define <vscale x 2 x double> @intrinsic_vfwsub.w_wf_nxv2f64_nxv2f64_f32(<vscale x 2 x double> %0, float %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv2f64_nxv2f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m1,ta,mu
; CHECK-NEXT:    vfwsub.wf v26, v8, ft0
; CHECK-NEXT:    vmv2r.v v8, v26
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwsub.w.nxv2f64.f32(
    <vscale x 2 x double> %0,
    float %1,
    i64 %2)

  ret <vscale x 2 x double> %a
}

declare <vscale x 2 x double> @llvm.riscv.vfwsub.w.mask.nxv2f64.f32(
  <vscale x 2 x double>,
  <vscale x 2 x double>,
  float,
  <vscale x 2 x i1>,
  i64);

define <vscale x 2 x double> @intrinsic_vfwsub.w_mask_wf_nxv2f64_nxv2f64_f32(<vscale x 2 x double> %0, <vscale x 2 x double> %1, float %2, <vscale x 2 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv2f64_nxv2f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m1,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v10, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 2 x double> @llvm.riscv.vfwsub.w.mask.nxv2f64.f32(
    <vscale x 2 x double> %0,
    <vscale x 2 x double> %1,
    float %2,
    <vscale x 2 x i1> %3,
    i64 %4)

  ret <vscale x 2 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwsub.w.nxv4f64.f32(
  <vscale x 4 x double>,
  float,
  i64);

define <vscale x 4 x double> @intrinsic_vfwsub.w_wf_nxv4f64_nxv4f64_f32(<vscale x 4 x double> %0, float %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv4f64_nxv4f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m2,ta,mu
; CHECK-NEXT:    vfwsub.wf v28, v8, ft0
; CHECK-NEXT:    vmv4r.v v8, v28
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwsub.w.nxv4f64.f32(
    <vscale x 4 x double> %0,
    float %1,
    i64 %2)

  ret <vscale x 4 x double> %a
}

declare <vscale x 4 x double> @llvm.riscv.vfwsub.w.mask.nxv4f64.f32(
  <vscale x 4 x double>,
  <vscale x 4 x double>,
  float,
  <vscale x 4 x i1>,
  i64);

define <vscale x 4 x double> @intrinsic_vfwsub.w_mask_wf_nxv4f64_nxv4f64_f32(<vscale x 4 x double> %0, <vscale x 4 x double> %1, float %2, <vscale x 4 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv4f64_nxv4f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m2,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v12, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 4 x double> @llvm.riscv.vfwsub.w.mask.nxv4f64.f32(
    <vscale x 4 x double> %0,
    <vscale x 4 x double> %1,
    float %2,
    <vscale x 4 x i1> %3,
    i64 %4)

  ret <vscale x 4 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwsub.w.nxv8f64.f32(
  <vscale x 8 x double>,
  float,
  i64);

define <vscale x 8 x double> @intrinsic_vfwsub.w_wf_nxv8f64_nxv8f64_f32(<vscale x 8 x double> %0, float %1, i64 %2) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_wf_nxv8f64_nxv8f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,ta,mu
; CHECK-NEXT:    vfwsub.wf v16, v8, ft0
; CHECK-NEXT:    vmv8r.v v8, v16
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwsub.w.nxv8f64.f32(
    <vscale x 8 x double> %0,
    float %1,
    i64 %2)

  ret <vscale x 8 x double> %a
}

declare <vscale x 8 x double> @llvm.riscv.vfwsub.w.mask.nxv8f64.f32(
  <vscale x 8 x double>,
  <vscale x 8 x double>,
  float,
  <vscale x 8 x i1>,
  i64);

define <vscale x 8 x double> @intrinsic_vfwsub.w_mask_wf_nxv8f64_nxv8f64_f32(<vscale x 8 x double> %0, <vscale x 8 x double> %1, float %2, <vscale x 8 x i1> %3, i64 %4) nounwind {
; CHECK-LABEL: intrinsic_vfwsub.w_mask_wf_nxv8f64_nxv8f64_f32:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    fmv.w.x ft0, a0
; CHECK-NEXT:    vsetvli a0, a1, e32,m4,tu,mu
; CHECK-NEXT:    vfwsub.wf v8, v16, ft0, v0.t
; CHECK-NEXT:    jalr zero, 0(ra)
entry:
  %a = call <vscale x 8 x double> @llvm.riscv.vfwsub.w.mask.nxv8f64.f32(
    <vscale x 8 x double> %0,
    <vscale x 8 x double> %1,
    float %2,
    <vscale x 8 x i1> %3,
    i64 %4)

  ret <vscale x 8 x double> %a
}
