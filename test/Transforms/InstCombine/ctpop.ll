; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -S -instcombine | FileCheck %s

declare i32 @llvm.ctpop.i32(i32)
declare i8 @llvm.ctpop.i8(i8)
declare i1 @llvm.ctpop.i1(i1)
declare <2 x i32> @llvm.ctpop.v2i32(<2 x i32>)
declare void @llvm.assume(i1)

define i1 @test1(i32 %arg) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i1 false
;
  %and = and i32 %arg, 15
  %cnt = call i32 @llvm.ctpop.i32(i32 %and)
  %res = icmp eq i32 %cnt, 9
  ret i1 %res
}

define i1 @test2(i32 %arg) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i1 false
;
  %and = and i32 %arg, 1
  %cnt = call i32 @llvm.ctpop.i32(i32 %and)
  %res = icmp eq i32 %cnt, 2
  ret i1 %res
}

define i1 @test3(i32 %arg) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    [[ASSUME:%.*]] = icmp eq i32 [[ARG:%.*]], 0
; CHECK-NEXT:    call void @llvm.assume(i1 [[ASSUME]])
; CHECK-NEXT:    ret i1 false
;
  ;; Use an assume to make all the bits known without triggering constant
  ;; folding.  This is trying to hit a corner case where we have to avoid
  ;; taking the log of 0.
  %assume = icmp eq i32 %arg, 0
  call void @llvm.assume(i1 %assume)
  %cnt = call i32 @llvm.ctpop.i32(i32 %arg)
  %res = icmp eq i32 %cnt, 2
  ret i1 %res
}

; Negative test for when we know nothing
define i1 @test4(i8 %arg) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    [[CNT:%.*]] = call i8 @llvm.ctpop.i8(i8 [[ARG:%.*]]), !range [[RNG0:![0-9]+]]
; CHECK-NEXT:    [[RES:%.*]] = icmp eq i8 [[CNT]], 2
; CHECK-NEXT:    ret i1 [[RES]]
;
  %cnt = call i8 @llvm.ctpop.i8(i8 %arg)
  %res = icmp eq i8 %cnt, 2
  ret i1 %res
}

; Test when the number of possible known bits isn't one less than a power of 2
; and the compare value is greater but less than the next power of 2.
define i1 @test5(i32 %arg) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    ret i1 false
;
  %and = and i32 %arg, 3
  %cnt = call i32 @llvm.ctpop.i32(i32 %and)
  %res = icmp eq i32 %cnt, 3
  ret i1 %res
}

; Test when the number of possible known bits isn't one less than a power of 2
; and the compare value is greater but less than the next power of 2.
; TODO: The icmp is unnecessary given the known bits of the input, but range
; metadata doesn't support vectors
define <2 x i1> @test5vec(<2 x i32> %arg) {
; CHECK-LABEL: @test5vec(
; CHECK-NEXT:    [[AND:%.*]] = and <2 x i32> [[ARG:%.*]], <i32 3, i32 3>
; CHECK-NEXT:    [[CNT:%.*]] = call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> [[AND]])
; CHECK-NEXT:    [[RES:%.*]] = icmp eq <2 x i32> [[CNT]], <i32 3, i32 3>
; CHECK-NEXT:    ret <2 x i1> [[RES]]
;
  %and = and <2 x i32> %arg, <i32 3, i32 3>
  %cnt = call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> %and)
  %res = icmp eq <2 x i32> %cnt, <i32 3, i32 3>
  ret <2 x i1> %res
}

; No intrinsic or range needed - ctpop of bool bit is the bit itself.

define i1 @test6(i1 %arg) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i1 [[ARG:%.*]]
;
  %cnt = call i1 @llvm.ctpop.i1(i1 %arg)
  ret i1 %cnt
}

define i8 @mask_one_bit(i8 %x) {
; CHECK-LABEL: @mask_one_bit(
; CHECK-NEXT:    [[A:%.*]] = lshr i8 [[X:%.*]], 4
; CHECK-NEXT:    [[R:%.*]] = and i8 [[A]], 1
; CHECK-NEXT:    ret i8 [[R]]
;
  %a = and i8 %x, 16
  %r = call i8 @llvm.ctpop.i8(i8 %a)
  ret i8 %r
}

define <2 x i32> @mask_one_bit_splat(<2 x i32> %x, <2 x i32>* %p) {
; CHECK-LABEL: @mask_one_bit_splat(
; CHECK-NEXT:    [[A:%.*]] = and <2 x i32> [[X:%.*]], <i32 2048, i32 2048>
; CHECK-NEXT:    store <2 x i32> [[A]], <2 x i32>* [[P:%.*]], align 8
; CHECK-NEXT:    [[R:%.*]] = lshr exact <2 x i32> [[A]], <i32 11, i32 11>
; CHECK-NEXT:    ret <2 x i32> [[R]]
;
  %a = and <2 x i32> %x, <i32 2048, i32 2048>
  store <2 x i32> %a, <2 x i32>* %p
  %r = call <2 x i32> @llvm.ctpop.v2i32(<2 x i32> %a)
  ret <2 x i32> %r
}
