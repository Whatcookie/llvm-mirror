; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=i686-w64-windows-gnu | FileCheck %s

%union.c_v256.26.65.104.143.962.1248 = type { [4 x i64] }

define void @_ZN14simd_test_avx216c_imm_v256_alignILi1EEE6c_v256S1_S1_(%union.c_v256.26.65.104.143.962.1248* byval(%union.c_v256.26.65.104.143.962.1248) align 4) #0 {
; CHECK-LABEL: _ZN14simd_test_avx216c_imm_v256_alignILi1EEE6c_v256S1_S1_:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    vmovdqu {{[0-9]+}}(%esp), %xmm0
; CHECK-NEXT:    vmovd {{.*#+}} xmm1 = mem[0],zero,zero,zero
; CHECK-NEXT:    vinserti128 $1, %xmm1, %ymm0, %ymm0
; CHECK-NEXT:    vpsllq $56, %ymm0, %ymm0
; CHECK-NEXT:    vmovdqu %ymm0, (%eax)
; CHECK-NEXT:    vzeroupper
; CHECK-NEXT:    retl
entry:
  %b.sroa.0.sroa.2.0.b.sroa.0.0..sroa_cast.sroa_idx38 = getelementptr inbounds %union.c_v256.26.65.104.143.962.1248, %union.c_v256.26.65.104.143.962.1248* %0, i32 0, i32 0, i32 1
  %1 = bitcast i64* %b.sroa.0.sroa.2.0.b.sroa.0.0..sroa_cast.sroa_idx38 to <2 x i64>*
  %2 = load <2 x i64>, <2 x i64>* %1, align 4
  %b.sroa.0.sroa.4.0.copyload = load i64, i64* undef, align 4
  %3 = extractelement <2 x i64> %2, i32 0
  %4 = extractelement <2 x i64> %2, i32 1
  %5 = insertelement <4 x i64> undef, i64 %3, i32 0
  %6 = insertelement <4 x i64> %5, i64 %4, i32 1
  %7 = insertelement <4 x i64> %6, i64 %b.sroa.0.sroa.4.0.copyload, i32 2
  %8 = insertelement <4 x i64> %7, i64 undef, i32 3
  %9 = shl <4 x i64> %8, <i64 56, i64 56, i64 56, i64 56>
  %10 = or <4 x i64> %9, zeroinitializer
  store <4 x i64> %10, <4 x i64>* undef, align 8
  ret void
}

attributes #0 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "frame-pointer"="none" "min-legal-vector-width"="0" "stack-protector-buffer-size"="8" "target-cpu"="pentium4" "target-features"="+avx,+avx2,+cx8,+fxsr,+mmx,+popcnt,+sse,+sse2,+sse3,+sse4.1,+sse4.2,+ssse3,+x87,+xsave" "use-soft-float"="false" }

