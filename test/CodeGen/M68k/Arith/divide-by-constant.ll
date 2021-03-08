; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=m68k-linux -verify-machineinstrs | FileCheck %s

; TODO fold the shifts
define zeroext i16 @test1(i16 zeroext %x) nounwind {
; CHECK-LABEL: test1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    move.w (6,%sp), %d0
; CHECK-NEXT:    mulu #-1985, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.w #5, %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    rts
entry:
	%div = udiv i16 %x, 33
	ret i16 %div
}

define zeroext i16 @test2(i8 signext %x, i16 zeroext %c) {
; CHECK-LABEL: test2:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.w (10,%sp), %d0
; CHECK-NEXT:    mulu #-21845, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.w #1, %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    rts
entry:
  %div = udiv i16 %c, 3
  ret i16 %div
}

define zeroext i8 @test3(i8 zeroext %x, i8 zeroext %c) {
; CHECK-LABEL: test3:
; CHECK:         .cfi_startproc
; CHECK-NEXT:  ; %bb.0: ; %entry
; CHECK-NEXT:    move.b (11,%sp), %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    mulu #-21845, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.w #1, %d0
; CHECK-NEXT:    and.l #65535, %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    rts
entry:
  %div = udiv i8 %c, 3
  ret i8 %div
}

define signext i16 @test4(i16 signext %x) nounwind {
; CHECK-LABEL: test4:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    movem.l %d2, (0,%sp) ; 8-byte Folded Spill
; CHECK-NEXT:    move.w (10,%sp), %d0
; CHECK-NEXT:    muls #1986, %d0
; CHECK-NEXT:    asr.l #8, %d0
; CHECK-NEXT:    asr.l #8, %d0
; CHECK-NEXT:    move.w #15, %d1
; CHECK-NEXT:    move.w %d0, %d2
; CHECK-NEXT:    lsr.w %d1, %d2
; CHECK-NEXT:    add.w %d0, %d2
; CHECK-NEXT:    move.l %d2, %d0
; CHECK-NEXT:    ext.l %d0
; CHECK-NEXT:    movem.l (0,%sp), %d2 ; 8-byte Folded Reload
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
	%div = sdiv i16 %x, 33		; <i32> [#uses=1]
	ret i16 %div
}

define i32 @test5(i32 %A) nounwind {
; CHECK-LABEL: test5:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub.l #12, %sp
; CHECK-NEXT:    move.l #1577682821, (4,%sp)
; CHECK-NEXT:    move.l (16,%sp), (%sp)
; CHECK-NEXT:    jsr __udivsi3
; CHECK-NEXT:    add.l #12, %sp
; CHECK-NEXT:    rts
  %tmp1 = udiv i32 %A, 1577682821         ; <i32> [#uses=1]
  ret i32 %tmp1
}

; TODO fold shift
define signext i16 @test6(i16 signext %x) nounwind {
; CHECK-LABEL: test6:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    movem.l %d2, (0,%sp) ; 8-byte Folded Spill
; CHECK-NEXT:    move.w (10,%sp), %d0
; CHECK-NEXT:    muls #26215, %d0
; CHECK-NEXT:    asr.l #8, %d0
; CHECK-NEXT:    asr.l #8, %d0
; CHECK-NEXT:    move.w #15, %d1
; CHECK-NEXT:    move.w %d0, %d2
; CHECK-NEXT:    lsr.w %d1, %d2
; CHECK-NEXT:    asr.w #2, %d0
; CHECK-NEXT:    add.w %d2, %d0
; CHECK-NEXT:    ext.l %d0
; CHECK-NEXT:    movem.l (0,%sp), %d2 ; 8-byte Folded Reload
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
  %div = sdiv i16 %x, 10
  ret i16 %div
}

define i32 @test7(i32 %x) nounwind {
; CHECK-LABEL: test7:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    sub.l #12, %sp
; CHECK-NEXT:    move.l #28, (4,%sp)
; CHECK-NEXT:    move.l (16,%sp), (%sp)
; CHECK-NEXT:    jsr __udivsi3
; CHECK-NEXT:    add.l #12, %sp
; CHECK-NEXT:    rts
  %div = udiv i32 %x, 28
  ret i32 %div
}

define i8 @test8(i8 %x) nounwind {
; CHECK-LABEL: test8:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.b (7,%sp), %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    lsr.w #1, %d0
; CHECK-NEXT:    mulu #26887, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.w #4, %d0
; CHECK-NEXT:    ; kill: def $bd0 killed $bd0 killed $d0
; CHECK-NEXT:    rts
  %div = udiv i8 %x, 78
  ret i8 %div
}

define i8 @test9(i8 %x) nounwind {
; CHECK-LABEL: test9:
; CHECK:       ; %bb.0:
; CHECK-NEXT:    move.b (7,%sp), %d0
; CHECK-NEXT:    and.l #255, %d0
; CHECK-NEXT:    mulu #18079, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.l #8, %d0
; CHECK-NEXT:    lsr.w #5, %d0
; CHECK-NEXT:    ; kill: def $bd0 killed $bd0 killed $d0
; CHECK-NEXT:    rts
  %div = udiv i8 %x, 116
  ret i8 %div
}

define i32 @testsize1(i32 %x) minsize nounwind {
; CHECK-LABEL: testsize1:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #4, %sp
; CHECK-NEXT:    movem.l %d2, (0,%sp) ; 8-byte Folded Spill
; CHECK-NEXT:    move.l #31, %d1
; CHECK-NEXT:    move.l (8,%sp), %d2
; CHECK-NEXT:    move.l %d2, %d0
; CHECK-NEXT:    asr.l %d1, %d0
; CHECK-NEXT:    move.l #27, %d1
; CHECK-NEXT:    lsr.l %d1, %d0
; CHECK-NEXT:    add.l %d2, %d0
; CHECK-NEXT:    asr.l #5, %d0
; CHECK-NEXT:    movem.l (0,%sp), %d2 ; 8-byte Folded Reload
; CHECK-NEXT:    add.l #4, %sp
; CHECK-NEXT:    rts
entry:
	%div = sdiv i32 %x, 32
	ret i32 %div
}

define i32 @testsize2(i32 %x) minsize nounwind {
; CHECK-LABEL: testsize2:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #12, %sp
; CHECK-NEXT:    move.l #33, (4,%sp)
; CHECK-NEXT:    move.l (16,%sp), (%sp)
; CHECK-NEXT:    jsr __divsi3
; CHECK-NEXT:    add.l #12, %sp
; CHECK-NEXT:    rts
entry:
	%div = sdiv i32 %x, 33
	ret i32 %div
}

define i32 @testsize3(i32 %x) minsize nounwind {
; CHECK-LABEL: testsize3:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    move.l (4,%sp), %d0
; CHECK-NEXT:    lsr.l #5, %d0
; CHECK-NEXT:    rts
entry:
	%div = udiv i32 %x, 32
	ret i32 %div
}

define i32 @testsize4(i32 %x) minsize nounwind {
; CHECK-LABEL: testsize4:
; CHECK:       ; %bb.0: ; %entry
; CHECK-NEXT:    sub.l #12, %sp
; CHECK-NEXT:    move.l #33, (4,%sp)
; CHECK-NEXT:    move.l (16,%sp), (%sp)
; CHECK-NEXT:    jsr __udivsi3
; CHECK-NEXT:    add.l #12, %sp
; CHECK-NEXT:    rts
entry:
	%div = udiv i32 %x, 33
	ret i32 %div
}
