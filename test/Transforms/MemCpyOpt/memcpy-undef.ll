; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -basic-aa -memcpyopt -S -enable-memcpyopt-memoryssa=0 | FileCheck %s --check-prefixes=CHECK,NO-MSSA
; RUN: opt < %s -basic-aa -memcpyopt -S -enable-memcpyopt-memoryssa=1 -verify-memoryssa | FileCheck %s --check-prefixes=CHECK,MSSA

target datalayout = "e-p:64:64:64-i1:8:8-i8:8:8-i16:16:16-i32:32:32-i64:64:64-f32:32:32-f64:64:64-v64:64:64-v128:128:128-a0:0:64-s0:64:64-f80:128:128-n8:16:32:64-S128"
target triple = "x86_64-apple-macosx10.8.0"

%struct.foo = type { i8, [7 x i8], i32 }

; Check that the memcpy is removed.
define i32 @test1(%struct.foo* nocapture %foobie) nounwind noinline ssp uwtable {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    [[BLETCH_SROA_1:%.*]] = alloca [7 x i8], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = getelementptr inbounds [[STRUCT_FOO:%.*]], %struct.foo* [[FOOBIE:%.*]], i64 0, i32 0
; CHECK-NEXT:    store i8 98, i8* [[TMP1]], align 4
; CHECK-NEXT:    [[TMP2:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[FOOBIE]], i64 0, i32 1, i64 0
; CHECK-NEXT:    [[TMP3:%.*]] = getelementptr inbounds [7 x i8], [7 x i8]* [[BLETCH_SROA_1]], i64 0, i64 0
; CHECK-NEXT:    [[TMP4:%.*]] = getelementptr inbounds [[STRUCT_FOO]], %struct.foo* [[FOOBIE]], i64 0, i32 2
; CHECK-NEXT:    store i32 20, i32* [[TMP4]], align 4
; CHECK-NEXT:    ret i32 undef
;
  %bletch.sroa.1 = alloca [7 x i8], align 1
  %1 = getelementptr inbounds %struct.foo, %struct.foo* %foobie, i64 0, i32 0
  store i8 98, i8* %1, align 4
  %2 = getelementptr inbounds %struct.foo, %struct.foo* %foobie, i64 0, i32 1, i64 0
  %3 = getelementptr inbounds [7 x i8], [7 x i8]* %bletch.sroa.1, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %2, i8* %3, i64 7, i1 false)
  %4 = getelementptr inbounds %struct.foo, %struct.foo* %foobie, i64 0, i32 2
  store i32 20, i32* %4, align 4
  ret i32 undef
}

; Check that the memcpy is removed.
define void @test2(i8* sret(i8) noalias nocapture %out, i8* %in) nounwind noinline ssp uwtable {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 8, i8* [[IN:%.*]])
; CHECK-NEXT:    ret void
;
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %in)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %out, i8* %in, i64 8, i1 false)
  ret void
}

; Check that the memcpy is not removed.
define void @test3(i8* sret(i8) noalias nocapture %out, i8* %in) nounwind noinline ssp uwtable {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 4, i8* [[IN:%.*]])
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[OUT:%.*]], i8* [[IN]], i64 8, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %in)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %out, i8* %in, i64 8, i1 false)
  ret void
}

; Check that the memcpy is not removed.
define void @test_lifetime_may_alias(i8* %lifetime, i8* %src, i8* %dst) {
; CHECK-LABEL: @test_lifetime_may_alias(
; CHECK-NEXT:    call void @llvm.lifetime.start.p0i8(i64 8, i8* [[LIFETIME:%.*]])
; CHECK-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST:%.*]], i8* [[SRC:%.*]], i64 8, i1 false)
; CHECK-NEXT:    ret void
;
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %lifetime)
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %src, i64 8, i1 false)
  ret void
}

; lifetime.start on full alloca size, copy in range.
define void @test_lifetime_partial_alias_1(i8* noalias %dst) {
; NO-MSSA-LABEL: @test_lifetime_partial_alias_1(
; NO-MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; NO-MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; NO-MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* [[A_I8]])
; NO-MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; NO-MSSA-NEXT:    ret void
;
; MSSA-LABEL: @test_lifetime_partial_alias_1(
; MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* [[A_I8]])
; MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; MSSA-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST:%.*]], i8* [[GEP]], i64 8, i1 false)
; MSSA-NEXT:    ret void
;
  %a = alloca [16 x i8]
  %a.i8 = bitcast [16 x i8]* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %a.i8)
  %gep = getelementptr i8, i8* %a.i8, i64 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %gep, i64 8, i1 false)
  ret void
}

; lifetime.start on full alloca size, copy out of range.
define void @test_lifetime_partial_alias_2(i8* noalias %dst) {
; NO-MSSA-LABEL: @test_lifetime_partial_alias_2(
; NO-MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; NO-MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; NO-MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* [[A_I8]])
; NO-MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; NO-MSSA-NEXT:    ret void
;
; MSSA-LABEL: @test_lifetime_partial_alias_2(
; MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 16, i8* [[A_I8]])
; MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; MSSA-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST:%.*]], i8* [[GEP]], i64 16, i1 false)
; MSSA-NEXT:    ret void
;
  %a = alloca [16 x i8]
  %a.i8 = bitcast [16 x i8]* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 16, i8* %a.i8)
  %gep = getelementptr i8, i8* %a.i8, i64 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %gep, i64 16, i1 false)
  ret void
}

; lifetime.start on part of alloca, copy in range.
define void @test_lifetime_partial_alias_3(i8* noalias %dst) {
; NO-MSSA-LABEL: @test_lifetime_partial_alias_3(
; NO-MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; NO-MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; NO-MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 12, i8* [[A_I8]])
; NO-MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; NO-MSSA-NEXT:    ret void
;
; MSSA-LABEL: @test_lifetime_partial_alias_3(
; MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 12, i8* [[A_I8]])
; MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; MSSA-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST:%.*]], i8* [[GEP]], i64 4, i1 false)
; MSSA-NEXT:    ret void
;
  %a = alloca [16 x i8]
  %a.i8 = bitcast [16 x i8]* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 12, i8* %a.i8)
  %gep = getelementptr i8, i8* %a.i8, i64 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %gep, i64 4, i1 false)
  ret void
}

; lifetime.start on part of alloca, copy out of range.
define void @test_lifetime_partial_alias_4(i8* noalias %dst) {
; NO-MSSA-LABEL: @test_lifetime_partial_alias_4(
; NO-MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; NO-MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; NO-MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 12, i8* [[A_I8]])
; NO-MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; NO-MSSA-NEXT:    ret void
;
; MSSA-LABEL: @test_lifetime_partial_alias_4(
; MSSA-NEXT:    [[A:%.*]] = alloca [16 x i8], align 1
; MSSA-NEXT:    [[A_I8:%.*]] = bitcast [16 x i8]* [[A]] to i8*
; MSSA-NEXT:    call void @llvm.lifetime.start.p0i8(i64 12, i8* [[A_I8]])
; MSSA-NEXT:    [[GEP:%.*]] = getelementptr i8, i8* [[A_I8]], i64 8
; MSSA-NEXT:    call void @llvm.memcpy.p0i8.p0i8.i64(i8* [[DST:%.*]], i8* [[GEP]], i64 8, i1 false)
; MSSA-NEXT:    ret void
;
  %a = alloca [16 x i8]
  %a.i8 = bitcast [16 x i8]* %a to i8*
  call void @llvm.lifetime.start.p0i8(i64 12, i8* %a.i8)
  %gep = getelementptr i8, i8* %a.i8, i64 8
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst, i8* %gep, i64 8, i1 false)
  ret void
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture, i8* nocapture, i64, i1) nounwind

declare void @llvm.lifetime.start.p0i8(i64, i8* nocapture) nounwind
