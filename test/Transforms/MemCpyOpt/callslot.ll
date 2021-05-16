; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -memcpyopt < %s -enable-memcpyopt-memoryssa=0 | FileCheck %s --check-prefixes=CHECK,NO_MSSA
; RUN: opt -S -memcpyopt < %s -enable-memcpyopt-memoryssa=1 -verify-memoryssa | FileCheck %s --check-prefixes=CHECK,MSSA

define i8 @read_dest_between_call_and_memcpy() {
; CHECK-LABEL: @read_dest_between_call_and_memcpy(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    store i8 1, i8* [[DEST_I8]], align 1
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[SRC_I8]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    [[X:%.*]] = load i8, i8* [[DEST_I8]], align 1
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[DEST_I8]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    ret i8 [[X]]
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  store i8 1, i8* %dest.i8
  call void @llvm.memset.p0i8.i64(i8* %src.i8, i8 0, i64 16, i1 false)
  %x = load i8, i8* %dest.i8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret i8 %x
}

define i8 @read_src_between_call_and_memcpy() {
; NO_MSSA-LABEL: @read_src_between_call_and_memcpy(
; NO_MSSA-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; NO_MSSA-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; NO_MSSA-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; NO_MSSA-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; NO_MSSA-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[SRC_I8]], i8 0, i64 16, i1 false)
; NO_MSSA-NEXT:    [[X:%.*]] = load i8, i8* [[SRC_I8]], align 1
; NO_MSSA-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DEST_I8]], i8* [[SRC_I8]], i64 16, i1 false)
; NO_MSSA-NEXT:    ret i8 [[X]]
;
; MSSA-LABEL: @read_src_between_call_and_memcpy(
; MSSA-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; MSSA-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; MSSA-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; MSSA-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; MSSA-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[SRC_I8]], i8 0, i64 16, i1 false)
; MSSA-NEXT:    [[X:%.*]] = load i8, i8* [[SRC_I8]], align 1
; MSSA-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[DEST_I8]], i8 0, i64 16, i1 false)
; MSSA-NEXT:    ret i8 [[X]]
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  call void @llvm.memset.p0i8.i64(i8* %src.i8, i8 0, i64 16, i1 false)
  %x = load i8, i8* %src.i8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret i8 %x
}

define void @write_dest_between_call_and_memcpy() {
; CHECK-LABEL: @write_dest_between_call_and_memcpy(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[SRC_I8]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    store i8 1, i8* [[DEST_I8]], align 1
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[DEST_I8]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  call void @llvm.memset.p0i8.i64(i8* %src.i8, i8 0, i64 16, i1 false)
  store i8 1, i8* %dest.i8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret void
}

define void @write_src_between_call_and_memcpy() {
; CHECK-LABEL: @write_src_between_call_and_memcpy(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[SRC_I8]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    store i8 1, i8* [[SRC_I8]], align 1
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DEST_I8]], i8* [[SRC_I8]], i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  call void @llvm.memset.p0i8.i64(i8* %src.i8, i8 0, i64 16, i1 false)
  store i8 1, i8* %src.i8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret void
}

define void @throw_between_call_and_mempy(i8* dereferenceable(16) %dest.i8) {
; CHECK-LABEL: @throw_between_call_and_mempy(
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[SRC_I8]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    call void @may_throw() #[[ATTR2:[0-9]+]]
; CHECK-NEXT:    call void @llvm.memset.p0i8.i64(i8* [[DEST_I8:%.*]], i8 0, i64 16, i1 false)
; CHECK-NEXT:    ret void
;
  %src = alloca [16 x i8]
  %src.i8 = bitcast [16 x i8]* %src to i8*
  call void @llvm.memset.p0i8.i64(i8* %src.i8, i8 0, i64 16, i1 false)
  call void @may_throw() readnone
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret void
}

define void @dest_is_gep_nounwind_call() {
; CHECK-LABEL: @dest_is_gep_nounwind_call(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [8 x i8], align 1
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [8 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    [[DEST_I8:%.*]] = getelementptr [16 x i8], [16 x i8]* [[DEST]], i64 0, i64 8
; CHECK-NEXT:    [[DEST_I81:%.*]] = bitcast i8* [[DEST_I8]] to [8 x i8]*
; CHECK-NEXT:    [[DEST_I812:%.*]] = bitcast [8 x i8]* [[DEST_I81]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST_I812]]) #[[ATTR3:[0-9]+]]
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [8 x i8]
  %src.i8 = bitcast [8 x i8]* %src to i8*
  %dest.i8 = getelementptr [16 x i8], [16 x i8]* %dest, i64 0, i64 8
  call void @accept_ptr(i8* %src.i8) nounwind
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 8, i1 false)
  ret void
}

define void @dest_is_gep_may_throw_call() {
; CHECK-LABEL: @dest_is_gep_may_throw_call(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [8 x i8], align 1
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [8 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    [[DEST_I8:%.*]] = getelementptr [16 x i8], [16 x i8]* [[DEST]], i64 0, i64 8
; CHECK-NEXT:    [[DEST_I81:%.*]] = bitcast i8* [[DEST_I8]] to [8 x i8]*
; CHECK-NEXT:    [[DEST_I812:%.*]] = bitcast [8 x i8]* [[DEST_I81]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST_I812]])
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [8 x i8]
  %src.i8 = bitcast [8 x i8]* %src to i8*
  %dest.i8 = getelementptr [16 x i8], [16 x i8]* %dest, i64 0, i64 8
  call void @accept_ptr(i8* %src.i8)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 8, i1 false)
  ret void
}

define void @dest_is_gep_requires_movement() {
; CHECK-LABEL: @dest_is_gep_requires_movement(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [8 x i8], align 1
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [8 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    [[DEST_I8:%.*]] = getelementptr [16 x i8], [16 x i8]* [[DEST]], i64 0, i64 8
; CHECK-NEXT:    [[DEST_I81:%.*]] = bitcast i8* [[DEST_I8]] to [8 x i8]*
; CHECK-NEXT:    [[DEST_I812:%.*]] = bitcast [8 x i8]* [[DEST_I81]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST_I812]]) #[[ATTR3]]
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [8 x i8]
  %src.i8 = bitcast [8 x i8]* %src to i8*
  call void @accept_ptr(i8* %src.i8) nounwind
  %dest.i8 = getelementptr [16 x i8], [16 x i8]* %dest, i64 0, i64 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 8, i1 false)
  ret void
}

define void @capture_before_call_argmemonly() {
; CHECK-LABEL: @capture_before_call_argmemonly(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST_I8]])
; CHECK-NEXT:    [[DEST1:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST1]]) #[[ATTR4:[0-9]+]]
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  call void @accept_ptr(i8* %dest.i8) ; capture
  call void @accept_ptr(i8* %src.i8) argmemonly
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret void
}

define void @capture_before_call_argmemonly_nounwind() {
; CHECK-LABEL: @capture_before_call_argmemonly_nounwind(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST_I8]])
; CHECK-NEXT:    [[DEST1:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST1]]) #[[ATTR5:[0-9]+]]
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  call void @accept_ptr(i8* %dest.i8) ; capture
  ; NB: argmemonly currently implies willreturn.
  call void @accept_ptr(i8* %src.i8) argmemonly nounwind
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret void
}

define void @capture_before_call_argmemonly_nounwind_willreturn() {
; CHECK-LABEL: @capture_before_call_argmemonly_nounwind_willreturn(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST_I8]])
; CHECK-NEXT:    [[DEST1:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST1]]) #[[ATTR6:[0-9]+]]
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  call void @accept_ptr(i8* %dest.i8) ; capture
  call void @accept_ptr(i8* %src.i8) argmemonly nounwind willreturn
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret void
}

; There is no path from the capture back to the memcpy.
; So we are allowed to perform the call slot optimization.
define void @capture_nopath_call(i1 %cond) {
; CHECK-LABEL: @capture_nopath_call(
; CHECK-NEXT:    [[DEST:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[SRC:%.*]] = alloca [16 x i8], align 1
; CHECK-NEXT:    [[DEST_I8:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    [[SRC_I8:%.*]] = bitcast [16 x i8]* [[SRC]] to i8*
; CHECK-NEXT:    br i1 [[COND:%.*]], label [[CAPTURES:%.*]], label [[NOCAPTURES:%.*]]
; CHECK:       captures:
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST_I8]])
; CHECK-NEXT:    ret void
; CHECK:       nocaptures:
; CHECK-NEXT:    [[DEST1:%.*]] = bitcast [16 x i8]* [[DEST]] to i8*
; CHECK-NEXT:    call void @accept_ptr(i8* [[DEST1]]) #[[ATTR3]]
; CHECK-NEXT:    ret void
;
  %dest = alloca [16 x i8]
  %src = alloca [16 x i8]
  %dest.i8 = bitcast [16 x i8]* %dest to i8*
  %src.i8 = bitcast [16 x i8]* %src to i8*
  br i1 %cond, label %captures, label %nocaptures

captures:
  call void @accept_ptr(i8* %dest.i8) ; capture
  ret void

nocaptures:
  call void @accept_ptr(i8* %src.i8) nounwind
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dest.i8, i8* %src.i8, i64 16, i1 false)
  ret void
}

declare void @may_throw()
declare void @accept_ptr(i8*)
declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)
