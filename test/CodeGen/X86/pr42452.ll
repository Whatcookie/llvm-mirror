; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -O0 | FileCheck %s

@b = external global i64, align 8

define void @foo(i1 %c, <2 x i64> %x) {
; CHECK-LABEL: foo:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    # kill: def $dil killed $dil killed $edi
; CHECK-NEXT:    movq %xmm0, %rax
; CHECK-NEXT:    pshufd {{.*#+}} xmm0 = xmm0[2,3,2,3]
; CHECK-NEXT:    movq %xmm0, %rcx
; CHECK-NEXT:    movb %dil, {{[-0-9]+}}(%r{{[sb]}}p) # 1-byte Spill
; CHECK-NEXT:    movq %rcx, {{[-0-9]+}}(%r{{[sb]}}p) # 8-byte Spill
; CHECK-NEXT:  .LBB0_1: # %for.body
; CHECK-NEXT:    # =>This Inner Loop Header: Depth=1
; CHECK-NEXT:    movb {{[-0-9]+}}(%r{{[sb]}}p), %al # 1-byte Reload
; CHECK-NEXT:    testb $1, %al
; CHECK-NEXT:    jne .LBB0_1
; CHECK-NEXT:    jmp .LBB0_2
; CHECK-NEXT:  .LBB0_2: # %for.end
; CHECK-NEXT:    movq {{[-0-9]+}}(%r{{[sb]}}p), %rax # 8-byte Reload
; CHECK-NEXT:    movq %rax, b
; CHECK-NEXT:    retq
entry:
  %0 = bitcast <2 x i64> %x to i128
  br label %for.body

for.body:                                         ; preds = %for.body, %entry
  br i1 %c, label %for.body, label %for.end

for.end:                                          ; preds = %for.body
  %1 = lshr i128 %0, 64
  %2 = trunc i128 %1 to i64
  store i64 %2, i64* @b, align 8
  ret void
}
