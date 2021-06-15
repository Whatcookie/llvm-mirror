; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc -verify-machineinstrs -mtriple=powerpc64le-unknown-linux-gnu -O3 \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s | FileCheck %s
; RUN: llc -verify-machineinstrs -mtriple=powerpc64-unknown-linux-gnu -O3 \
; RUN:   -mcpu=pwr10 -ppc-asm-full-reg-names -ppc-vsr-nums-as-vr \
; RUN:   < %s | FileCheck %s --check-prefix=CHECK-BE
define dso_local void @test(<256 x i1>* %vpp, <256 x i1>* %vp2) local_unnamed_addr #0 {
; CHECK-LABEL: test:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    stdu r1, -400(r1)
; CHECK-NEXT:    stfd f14, 256(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f15, 264(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v20, 64(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stxv v21, 80(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f16, 272(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f17, 280(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v22, 96(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stxv v23, 112(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f18, 288(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f19, 296(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v24, 128(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f20, 304(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f21, 312(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v25, 144(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stxv v26, 160(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f22, 320(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f23, 328(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v27, 176(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f24, 336(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f25, 344(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v28, 192(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stxv v29, 208(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f26, 352(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f27, 360(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v30, 224(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f28, 368(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f29, 376(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stxv v31, 240(r1) # 16-byte Folded Spill
; CHECK-NEXT:    stfd f30, 384(r1) # 8-byte Folded Spill
; CHECK-NEXT:    stfd f31, 392(r1) # 8-byte Folded Spill
; CHECK-NEXT:    lxvp vsp0, 0(r3)
; CHECK-NEXT:    stxvp vsp0, 32(r1) # 32-byte Folded Spill
; CHECK-NEXT:    #APP
; CHECK-NEXT:    nop
; CHECK-NEXT:    #NO_APP
; CHECK-NEXT:    lxvp vsp0, 32(r1) # 32-byte Folded Reload
; CHECK-NEXT:    stxvp vsp0, 0(r4)
; CHECK-NEXT:    lxv v31, 240(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v30, 224(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v29, 208(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v28, 192(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v27, 176(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v26, 160(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v25, 144(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v24, 128(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v23, 112(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v22, 96(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v21, 80(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lxv v20, 64(r1) # 16-byte Folded Reload
; CHECK-NEXT:    lfd f31, 392(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f30, 384(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f29, 376(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f28, 368(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f27, 360(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f26, 352(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f25, 344(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f24, 336(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f23, 328(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f22, 320(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f21, 312(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f20, 304(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f19, 296(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f18, 288(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f17, 280(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f16, 272(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f15, 264(r1) # 8-byte Folded Reload
; CHECK-NEXT:    lfd f14, 256(r1) # 8-byte Folded Reload
; CHECK-NEXT:    addi r1, r1, 400
; CHECK-NEXT:    blr
;
; CHECK-BE-LABEL: test:
; CHECK-BE:       # %bb.0: # %entry
; CHECK-BE-NEXT:    stdu r1, -416(r1)
; CHECK-BE-NEXT:    stfd f14, 272(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f15, 280(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v20, 80(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stxv v21, 96(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f16, 288(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f17, 296(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v22, 112(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stxv v23, 128(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f18, 304(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f19, 312(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v24, 144(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f20, 320(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f21, 328(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v25, 160(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stxv v26, 176(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f22, 336(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f23, 344(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v27, 192(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f24, 352(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f25, 360(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v28, 208(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stxv v29, 224(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f26, 368(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f27, 376(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v30, 240(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f28, 384(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f29, 392(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stxv v31, 256(r1) # 16-byte Folded Spill
; CHECK-BE-NEXT:    stfd f30, 400(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    stfd f31, 408(r1) # 8-byte Folded Spill
; CHECK-BE-NEXT:    lxvp vsp0, 0(r3)
; CHECK-BE-NEXT:    stxvp vsp0, 48(r1) # 32-byte Folded Spill
; CHECK-BE-NEXT:    #APP
; CHECK-BE-NEXT:    nop
; CHECK-BE-NEXT:    #NO_APP
; CHECK-BE-NEXT:    lxvp vsp0, 48(r1) # 32-byte Folded Reload
; CHECK-BE-NEXT:    stxvp vsp0, 0(r4)
; CHECK-BE-NEXT:    lxv v31, 256(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v30, 240(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v29, 224(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v28, 208(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v27, 192(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v26, 176(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v25, 160(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v24, 144(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v23, 128(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v22, 112(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v21, 96(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lxv v20, 80(r1) # 16-byte Folded Reload
; CHECK-BE-NEXT:    lfd f31, 408(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f30, 400(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f29, 392(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f28, 384(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f27, 376(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f26, 368(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f25, 360(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f24, 352(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f23, 344(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f22, 336(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f21, 328(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f20, 320(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f19, 312(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f18, 304(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f17, 296(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f16, 288(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f15, 280(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    lfd f14, 272(r1) # 8-byte Folded Reload
; CHECK-BE-NEXT:    addi r1, r1, 416
; CHECK-BE-NEXT:    blr
entry:
  %0 = bitcast <256 x i1>* %vpp to i8*
  %1 = tail call <256 x i1> @llvm.ppc.vsx.lxvp(i8* %0)
  tail call void asm sideeffect "nop", "~{memory},~{vs0},~{vs1},~{vs2},~{vs3},~{vs4},~{vs5},~{vs6},~{vs7},~{vs8},~{vs9},~{vs10},~{vs11},~{vs12},~{vs13},~{vs14},~{vs15},~{vs16},~{vs17},~{vs18},~{vs19},~{vs20},~{vs21},~{vs22},~{vs23},~{vs24},~{vs25},~{vs26},~{vs27},~{vs28},~{vs29},~{vs30},~{vs31},~{vs32},~{vs33},~{vs34},~{vs35},~{vs36},~{vs37},~{vs38},~{vs39},~{vs40},~{vs41},~{vs42},~{vs43},~{vs44},~{vs45},~{vs46},~{vs47},~{vs48},~{vs49},~{vs50},~{vs51},~{vs52},~{vs53},~{vs54},~{vs55},~{vs56},~{vs57},~{vs58},~{vs59},~{vs60},~{vs61},~{vs62},~{vs63}"()
  %2 = bitcast <256 x i1>* %vp2 to i8*
  tail call void @llvm.ppc.vsx.stxvp(<256 x i1> %1, i8* %2)
  ret void
}

declare <256 x i1> @llvm.ppc.vsx.lxvp(i8*) #1

declare void @llvm.ppc.vsx.stxvp(<256 x i1>, i8*) #2

attributes #0 = { nounwind }
