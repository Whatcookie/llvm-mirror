; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-linux | FileCheck %s --check-prefixes=X64,SSE
; RUN: llc < %s -mtriple=x86_64-linux -mattr=avx | FileCheck %s --check-prefixes=X64,AVX,AVX1
; RUN: llc < %s -mtriple=x86_64-linux -mattr=avx2 | FileCheck %s --check-prefixes=X64,AVX,AVX2
; RUN: llc < %s -mtriple=i686 -mattr=cmov | FileCheck %s --check-prefix=X86

; The i1 parameter is not codegen-relevant right now.

declare i8 @llvm.abs.i8(i8, i1)
declare i16 @llvm.abs.i16(i16, i1)
declare i24 @llvm.abs.i24(i24, i1)
declare i32 @llvm.abs.i32(i32, i1)
declare i64 @llvm.abs.i64(i64, i1)
declare i128 @llvm.abs.i128(i128, i1)

declare <1 x i32> @llvm.abs.v1i32(<1 x i32>, i1)
declare <2 x i32> @llvm.abs.v2i32(<2 x i32>, i1)
declare <3 x i32> @llvm.abs.v3i32(<3 x i32>, i1)
declare <4 x i32> @llvm.abs.v4i32(<4 x i32>, i1)
declare <8 x i32> @llvm.abs.v8i32(<8 x i32>, i1)

declare <8 x i16> @llvm.abs.v8i16(<8 x i16>, i1)
declare <16 x i8> @llvm.abs.v16i8(<16 x i8>, i1)

define i8 @test_i8(i8 %a) nounwind {
; X64-LABEL: test_i8:
; X64:       # %bb.0:
; X64-NEXT:    # kill: def $edi killed $edi def $rdi
; X64-NEXT:    movl %edi, %ecx
; X64-NEXT:    sarb $7, %cl
; X64-NEXT:    leal (%rdi,%rcx), %eax
; X64-NEXT:    xorb %cl, %al
; X64-NEXT:    # kill: def $al killed $al killed $eax
; X64-NEXT:    retq
;
; X86-LABEL: test_i8:
; X86:       # %bb.0:
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movl %eax, %ecx
; X86-NEXT:    sarb $7, %cl
; X86-NEXT:    addb %cl, %al
; X86-NEXT:    xorb %cl, %al
; X86-NEXT:    retl
  %r = call i8 @llvm.abs.i8(i8 %a, i1 false)
  ret i8 %r
}

define i16 @test_i16(i16 %a) nounwind {
; X64-LABEL: test_i16:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negw %ax
; X64-NEXT:    cmovlw %di, %ax
; X64-NEXT:    retq
;
; X86-LABEL: test_i16:
; X86:       # %bb.0:
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    negw %ax
; X86-NEXT:    cmovlw %cx, %ax
; X86-NEXT:    retl
  %r = call i16 @llvm.abs.i16(i16 %a, i1 false)
  ret i16 %r
}

define i24 @test_i24(i24 %a) nounwind {
; X64-LABEL: test_i24:
; X64:       # %bb.0:
; X64-NEXT:    shll $8, %edi
; X64-NEXT:    sarl $8, %edi
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negl %eax
; X64-NEXT:    cmovll %edi, %eax
; X64-NEXT:    retq
;
; X86-LABEL: test_i24:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    shll $8, %ecx
; X86-NEXT:    sarl $8, %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    cmovll %ecx, %eax
; X86-NEXT:    retl
  %r = call i24 @llvm.abs.i24(i24 %a, i1 false)
  ret i24 %r
}

define i32 @test_i32(i32 %a) nounwind {
; X64-LABEL: test_i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negl %eax
; X64-NEXT:    cmovll %edi, %eax
; X64-NEXT:    retq
;
; X86-LABEL: test_i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    cmovll %ecx, %eax
; X86-NEXT:    retl
  %r = call i32 @llvm.abs.i32(i32 %a, i1 false)
  ret i32 %r
}

define i64 @test_i64(i64 %a) nounwind {
; X64-LABEL: test_i64:
; X64:       # %bb.0:
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    negq %rax
; X64-NEXT:    cmovlq %rdi, %rax
; X64-NEXT:    retq
;
; X86-LABEL: test_i64:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    sarl $31, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    addl %ecx, %eax
; X86-NEXT:    adcl %ecx, %edx
; X86-NEXT:    xorl %ecx, %edx
; X86-NEXT:    xorl %ecx, %eax
; X86-NEXT:    retl
  %r = call i64 @llvm.abs.i64(i64 %a, i1 false)
  ret i64 %r
}

define i128 @test_i128(i128 %a) nounwind {
; X64-LABEL: test_i128:
; X64:       # %bb.0:
; X64-NEXT:    movq %rsi, %rdx
; X64-NEXT:    movq %rdi, %rax
; X64-NEXT:    movq %rsi, %rcx
; X64-NEXT:    sarq $63, %rcx
; X64-NEXT:    addq %rcx, %rax
; X64-NEXT:    adcq %rcx, %rdx
; X64-NEXT:    xorq %rcx, %rax
; X64-NEXT:    xorq %rcx, %rdx
; X64-NEXT:    retq
;
; X86-LABEL: test_i128:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    sarl $31, %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    addl %edx, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    adcl %edx, %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    adcl %edx, %ebx
; X86-NEXT:    adcl %edx, %ecx
; X86-NEXT:    xorl %edx, %ecx
; X86-NEXT:    xorl %edx, %ebx
; X86-NEXT:    xorl %edx, %edi
; X86-NEXT:    xorl %edx, %esi
; X86-NEXT:    movl %esi, (%eax)
; X86-NEXT:    movl %edi, 4(%eax)
; X86-NEXT:    movl %ebx, 8(%eax)
; X86-NEXT:    movl %ecx, 12(%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    retl $4
  %r = call i128 @llvm.abs.i128(i128 %a, i1 false)
  ret i128 %r
}

define <1 x i32> @test_v1i32(<1 x i32> %a) nounwind {
; X64-LABEL: test_v1i32:
; X64:       # %bb.0:
; X64-NEXT:    movl %edi, %eax
; X64-NEXT:    negl %eax
; X64-NEXT:    cmovll %edi, %eax
; X64-NEXT:    retq
;
; X86-LABEL: test_v1i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    cmovll %ecx, %eax
; X86-NEXT:    retl
  %r = call <1 x i32> @llvm.abs.v1i32(<1 x i32> %a, i1 false)
  ret <1 x i32> %r
}

define <2 x i32> @test_v2i32(<2 x i32> %a) nounwind {
; SSE-LABEL: test_v2i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    pxor %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v2i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpabsd %xmm0, %xmm0
; AVX-NEXT:    retq
;
; X86-LABEL: test_v2i32:
; X86:       # %bb.0:
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    cmovll %edx, %eax
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    negl %edx
; X86-NEXT:    cmovll %ecx, %edx
; X86-NEXT:    retl
  %r = call <2 x i32> @llvm.abs.v2i32(<2 x i32> %a, i1 false)
  ret <2 x i32> %r
}

define <3 x i32> @test_v3i32(<3 x i32> %a) nounwind {
; SSE-LABEL: test_v3i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    pxor %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v3i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpabsd %xmm0, %xmm0
; AVX-NEXT:    retq
;
; X86-LABEL: test_v3i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    cmovll %edx, %eax
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    negl %edx
; X86-NEXT:    cmovll %ecx, %edx
; X86-NEXT:    movl %esi, %ecx
; X86-NEXT:    negl %ecx
; X86-NEXT:    cmovll %esi, %ecx
; X86-NEXT:    popl %esi
; X86-NEXT:    retl
  %r = call <3 x i32> @llvm.abs.v3i32(<3 x i32> %a, i1 false)
  ret <3 x i32> %r
}

define <4 x i32> @test_v4i32(<4 x i32> %a) nounwind {
; SSE-LABEL: test_v4i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm1
; SSE-NEXT:    psrad $31, %xmm1
; SSE-NEXT:    paddd %xmm1, %xmm0
; SSE-NEXT:    pxor %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v4i32:
; AVX:       # %bb.0:
; AVX-NEXT:    vpabsd %xmm0, %xmm0
; AVX-NEXT:    retq
;
; X86-LABEL: test_v4i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl %edi, %ebx
; X86-NEXT:    negl %ebx
; X86-NEXT:    cmovll %edi, %ebx
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    negl %edi
; X86-NEXT:    cmovll %esi, %edi
; X86-NEXT:    movl %edx, %esi
; X86-NEXT:    negl %esi
; X86-NEXT:    cmovll %edx, %esi
; X86-NEXT:    movl %ecx, %edx
; X86-NEXT:    negl %edx
; X86-NEXT:    cmovll %ecx, %edx
; X86-NEXT:    movl %edx, 12(%eax)
; X86-NEXT:    movl %esi, 8(%eax)
; X86-NEXT:    movl %edi, 4(%eax)
; X86-NEXT:    movl %ebx, (%eax)
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    retl $4
  %r = call <4 x i32> @llvm.abs.v4i32(<4 x i32> %a, i1 false)
  ret <4 x i32> %r
}

define <8 x i32> @test_v8i32(<8 x i32> %a) nounwind {
; SSE-LABEL: test_v8i32:
; SSE:       # %bb.0:
; SSE-NEXT:    movdqa %xmm0, %xmm2
; SSE-NEXT:    psrad $31, %xmm2
; SSE-NEXT:    paddd %xmm2, %xmm0
; SSE-NEXT:    pxor %xmm2, %xmm0
; SSE-NEXT:    movdqa %xmm1, %xmm2
; SSE-NEXT:    psrad $31, %xmm2
; SSE-NEXT:    paddd %xmm2, %xmm1
; SSE-NEXT:    pxor %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: test_v8i32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vpabsd %xmm0, %xmm1
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpabsd %xmm0, %xmm0
; AVX1-NEXT:    vinsertf128 $1, %xmm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX2-LABEL: test_v8i32:
; AVX2:       # %bb.0:
; AVX2-NEXT:    vpabsd %ymm0, %ymm0
; AVX2-NEXT:    retq
;
; X86-LABEL: test_v8i32:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $8, %esp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    negl %ecx
; X86-NEXT:    cmovll %edx, %ecx
; X86-NEXT:    movl %ecx, {{[-0-9]+}}(%e{{[sb]}}p) # 4-byte Spill
; X86-NEXT:    movl %ebp, %ecx
; X86-NEXT:    negl %ecx
; X86-NEXT:    cmovll %ebp, %ecx
; X86-NEXT:    movl %ecx, (%esp) # 4-byte Spill
; X86-NEXT:    movl %ebx, %ebp
; X86-NEXT:    negl %ebp
; X86-NEXT:    cmovll %ebx, %ebp
; X86-NEXT:    movl %edi, %ebx
; X86-NEXT:    negl %ebx
; X86-NEXT:    cmovll %edi, %ebx
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    negl %edi
; X86-NEXT:    cmovll %esi, %edi
; X86-NEXT:    movl %eax, %esi
; X86-NEXT:    negl %esi
; X86-NEXT:    cmovll %eax, %esi
; X86-NEXT:    movl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    negl %eax
; X86-NEXT:    cmovll %ecx, %eax
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    negl %ecx
; X86-NEXT:    cmovll %edx, %ecx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %ecx, 28(%edx)
; X86-NEXT:    movl %eax, 24(%edx)
; X86-NEXT:    movl %esi, 20(%edx)
; X86-NEXT:    movl %edi, 16(%edx)
; X86-NEXT:    movl %ebx, 12(%edx)
; X86-NEXT:    movl %ebp, 8(%edx)
; X86-NEXT:    movl (%esp), %eax # 4-byte Reload
; X86-NEXT:    movl %eax, 4(%edx)
; X86-NEXT:    movl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 4-byte Reload
; X86-NEXT:    movl %eax, (%edx)
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    addl $8, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
  %r = call <8 x i32> @llvm.abs.v8i32(<8 x i32> %a, i1 false)
  ret <8 x i32> %r
}

define <8 x i16> @test_v8i16(<8 x i16> %a) nounwind {
; SSE-LABEL: test_v8i16:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubw %xmm0, %xmm1
; SSE-NEXT:    pmaxsw %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v8i16:
; AVX:       # %bb.0:
; AVX-NEXT:    vpabsw %xmm0, %xmm0
; AVX-NEXT:    retq
;
; X86-LABEL: test_v8i16:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebp
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %edi
; X86-NEXT:    pushl %esi
; X86-NEXT:    pushl %eax
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %eax
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %edi
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ebx
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ebp
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    negw %cx
; X86-NEXT:    cmovlw %dx, %cx
; X86-NEXT:    movw %cx, {{[-0-9]+}}(%e{{[sb]}}p) # 2-byte Spill
; X86-NEXT:    movl %ebp, %ecx
; X86-NEXT:    negw %cx
; X86-NEXT:    cmovlw %bp, %cx
; X86-NEXT:    movw %cx, (%esp) # 2-byte Spill
; X86-NEXT:    movl %ebx, %ebp
; X86-NEXT:    negw %bp
; X86-NEXT:    cmovlw %bx, %bp
; X86-NEXT:    movl %edi, %ebx
; X86-NEXT:    negw %bx
; X86-NEXT:    cmovlw %di, %bx
; X86-NEXT:    movl %esi, %edi
; X86-NEXT:    negw %di
; X86-NEXT:    cmovlw %si, %di
; X86-NEXT:    movl %eax, %esi
; X86-NEXT:    negw %si
; X86-NEXT:    cmovlw %ax, %si
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %ecx
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    negw %ax
; X86-NEXT:    cmovlw %cx, %ax
; X86-NEXT:    movzwl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movl %edx, %ecx
; X86-NEXT:    negw %cx
; X86-NEXT:    cmovlw %dx, %cx
; X86-NEXT:    movl {{[0-9]+}}(%esp), %edx
; X86-NEXT:    movw %cx, 14(%edx)
; X86-NEXT:    movw %ax, 12(%edx)
; X86-NEXT:    movw %si, 10(%edx)
; X86-NEXT:    movw %di, 8(%edx)
; X86-NEXT:    movw %bx, 6(%edx)
; X86-NEXT:    movw %bp, 4(%edx)
; X86-NEXT:    movzwl (%esp), %eax # 2-byte Folded Reload
; X86-NEXT:    movw %ax, 2(%edx)
; X86-NEXT:    movzwl {{[-0-9]+}}(%e{{[sb]}}p), %eax # 2-byte Folded Reload
; X86-NEXT:    movw %ax, (%edx)
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    addl $4, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %edi
; X86-NEXT:    popl %ebx
; X86-NEXT:    popl %ebp
; X86-NEXT:    retl $4
  %r = call <8 x i16> @llvm.abs.v8i16(<8 x i16> %a, i1 false)
  ret <8 x i16> %r
}

define <16 x i8> @test_v16i8(<16 x i8> %a) nounwind {
; SSE-LABEL: test_v16i8:
; SSE:       # %bb.0:
; SSE-NEXT:    pxor %xmm1, %xmm1
; SSE-NEXT:    psubb %xmm0, %xmm1
; SSE-NEXT:    pminub %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: test_v16i8:
; AVX:       # %bb.0:
; AVX-NEXT:    vpabsb %xmm0, %xmm0
; AVX-NEXT:    retq
;
; X86-LABEL: test_v16i8:
; X86:       # %bb.0:
; X86-NEXT:    pushl %ebx
; X86-NEXT:    pushl %esi
; X86-NEXT:    subl $12, %esp
; X86-NEXT:    movb {{[0-9]+}}(%esp), %bh
; X86-NEXT:    movb {{[0-9]+}}(%esp), %bl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %dh
; X86-NEXT:    movb {{[0-9]+}}(%esp), %ch
; X86-NEXT:    movb {{[0-9]+}}(%esp), %ah
; X86-NEXT:    movb {{[0-9]+}}(%esp), %dl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movb %cl, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %cl
; X86-NEXT:    xorb %al, %cl
; X86-NEXT:    movb %cl, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb %dl, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %dl
; X86-NEXT:    xorb %al, %dl
; X86-NEXT:    movb %dl, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb %ah, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %ah
; X86-NEXT:    xorb %al, %ah
; X86-NEXT:    movb %ah, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb %ch, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %ch
; X86-NEXT:    xorb %al, %ch
; X86-NEXT:    movb %ch, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb %dh, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %dh
; X86-NEXT:    xorb %al, %dh
; X86-NEXT:    movb %dh, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movl %ebx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %bl
; X86-NEXT:    xorb %al, %bl
; X86-NEXT:    movb %bl, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb %bh, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %bh
; X86-NEXT:    xorb %al, %bh
; X86-NEXT:    movb %bh, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %cl
; X86-NEXT:    xorb %al, %cl
; X86-NEXT:    movb %cl, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %cl
; X86-NEXT:    xorb %al, %cl
; X86-NEXT:    movb %cl, {{[-0-9]+}}(%e{{[sb]}}p) # 1-byte Spill
; X86-NEXT:    movb {{[0-9]+}}(%esp), %bh
; X86-NEXT:    movb %bh, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %bh
; X86-NEXT:    xorb %al, %bh
; X86-NEXT:    movb {{[0-9]+}}(%esp), %bl
; X86-NEXT:    movl %ebx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %bl
; X86-NEXT:    xorb %al, %bl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %dh
; X86-NEXT:    movb %dh, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %dh
; X86-NEXT:    xorb %al, %dh
; X86-NEXT:    movb {{[0-9]+}}(%esp), %ch
; X86-NEXT:    movb %ch, %al
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %ch
; X86-NEXT:    xorb %al, %ch
; X86-NEXT:    movb {{[0-9]+}}(%esp), %dl
; X86-NEXT:    movl %edx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %dl
; X86-NEXT:    xorb %al, %dl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %cl
; X86-NEXT:    movl %ecx, %eax
; X86-NEXT:    sarb $7, %al
; X86-NEXT:    addb %al, %cl
; X86-NEXT:    xorb %al, %cl
; X86-NEXT:    movb {{[0-9]+}}(%esp), %al
; X86-NEXT:    movb %al, %ah
; X86-NEXT:    sarb $7, %ah
; X86-NEXT:    addb %ah, %al
; X86-NEXT:    xorb %ah, %al
; X86-NEXT:    movl {{[0-9]+}}(%esp), %esi
; X86-NEXT:    movb %al, 15(%esi)
; X86-NEXT:    movb %cl, 14(%esi)
; X86-NEXT:    movb %dl, 13(%esi)
; X86-NEXT:    movb %ch, 12(%esi)
; X86-NEXT:    movb %dh, 11(%esi)
; X86-NEXT:    movb %bl, 10(%esi)
; X86-NEXT:    movb %bh, 9(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 8(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 7(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 6(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 5(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 4(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 3(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 2(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, 1(%esi)
; X86-NEXT:    movb {{[-0-9]+}}(%e{{[sb]}}p), %al # 1-byte Reload
; X86-NEXT:    movb %al, (%esi)
; X86-NEXT:    movl %esi, %eax
; X86-NEXT:    addl $12, %esp
; X86-NEXT:    popl %esi
; X86-NEXT:    popl %ebx
; X86-NEXT:    retl $4
  %r = call <16 x i8> @llvm.abs.v16i8(<16 x i8> %a, i1 false)
  ret <16 x i8> %r
}
