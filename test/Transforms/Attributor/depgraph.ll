; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --check-attributes --check-globals
; RUN: opt -passes=attributor-cgscc -S < %s 2>&1 | FileCheck %s --check-prefixes=CHECK
; RUN: opt -passes=attributor-cgscc -disable-output -attributor-print-dep < %s 2>&1 | FileCheck %s --check-prefixes=GRAPH
; RUN: opt -passes=attributor-cgscc -disable-output -attributor-dump-dep-graph -attributor-depgraph-dot-filename-prefix=%t < %s 2>/dev/null
; RUN: FileCheck %s -input-file=%t_0.dot --check-prefix=DOT

; Test 0
;
; test copied from the attributor introduction video: checkAndAdvance(), and the C code is:
; int *checkAndAdvance(int * __attribute__((aligned(16))) p) {
;   if (*p == 0)
;     return checkAndAdvance(p + 4);
;   return p;
; }
;
define i32* @checkAndAdvance(i32* align 16 %0) {
; CHECK: Function Attrs: argmemonly nofree nosync nounwind readonly
; CHECK-LABEL: define {{[^@]+}}@checkAndAdvance
; CHECK-SAME: (i32* nofree noundef nonnull readonly align 16 dereferenceable(4) [[TMP0:%.*]]) #[[ATTR0:[0-9]+]] {
; CHECK-NEXT:    [[TMP2:%.*]] = load i32, i32* [[TMP0]], align 16
; CHECK-NEXT:    [[TMP3:%.*]] = icmp eq i32 [[TMP2]], 0
; CHECK-NEXT:    br i1 [[TMP3]], label [[TMP4:%.*]], label [[TMP7:%.*]]
; CHECK:       4:
; CHECK-NEXT:    [[TMP5:%.*]] = getelementptr inbounds i32, i32* [[TMP0]], i64 4
; CHECK-NEXT:    [[TMP6:%.*]] = call nonnull align 16 i32* @checkAndAdvance(i32* nofree nonnull readonly align 16 [[TMP5]]) #[[ATTR1:[0-9]+]]
; CHECK-NEXT:    br label [[TMP8:%.*]]
; CHECK:       7:
; CHECK-NEXT:    br label [[TMP8]]
; CHECK:       8:
; CHECK-NEXT:    [[DOT0:%.*]] = phi i32* [ [[TMP6]], [[TMP4]] ], [ [[TMP0]], [[TMP7]] ]
; CHECK-NEXT:    ret i32* [[DOT0]]
;
  %2 = load i32, i32* %0, align 4
  %3 = icmp eq i32 %2, 0
  br i1 %3, label %4, label %7

4:                                                ; preds = %1
  %5 = getelementptr inbounds i32, i32* %0, i64 4
  %6 = call i32* @checkAndAdvance(i32* %5)
  br label %8

7:                                                ; preds = %1
  br label %8

8:                                                ; preds = %7, %4
  %.0 = phi i32* [ %6, %4 ], [ %0, %7 ]
  ret i32* %.0
}

;
; Check for graph
;

; GRAPH:      [AAIsDead] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state Live[#BB 4/4][#TBEP 0][#KDE 1]
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI '  %3 = icmp eq i32 %2, 0' at position {flt: [@-1]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAWillReturn] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state may-noreturn
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAUndefinedBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state undefined-behavior
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoUndef] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state may-undef-or-poison
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAReturnedValues] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state returns(#3)[#UC: 1]
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoUnwind] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state nounwind
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nounwind
; GRAPH-NEXT:   updates [AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nounwind
; GRAPH-NEXT:   updates [AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nounwind
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoSync] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state nosync
; GRAPH-NEXT:   updates [AANoSync] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nosync
; GRAPH-NEXT:   updates [AANoSync] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nosync
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  %2 = load i32, i32* %0, align 4' at position {flt: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI '  %2 = load i32, i32* %0, align 4' at position {flt: [@-1]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueConstantRange] for CtxI '  %2 = load i32, i32* %0, align 4' at position {flt: [@-1]} with state range(32)<full-set / full-set>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAPotentialValues] for CtxI '  %2 = load i32, i32* %0, align 4' at position {flt: [@-1]} with state set-state(< {full-set} >)
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  %3 = icmp eq i32 %2, 0' at position {flt: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  br i1 %3, label %4, label %7' at position {flt: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state nofree
; GRAPH-NEXT:   updates [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state nofree
; GRAPH-NEXT:   updates [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state nofree
; GRAPH-NEXT:   updates [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nofree
; GRAPH-NEXT:   updates [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nofree
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoReturn] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state may-return
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoRecurse] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state may-recurse
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state readonly
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state readonly
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state readonly
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state readonly
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument
; GRAPH-NEXT:   updates [AAMemoryLocation] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state memory:argument
; GRAPH-NEXT:   updates [AAMemoryLocation] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state memory:argument
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAHeapToStack] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state [H2S] Mallocs Good/Bad: 0/1
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAAlign] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state align<1-16>
; GRAPH-NEXT:   updates [AAAlign] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state align<1-16>
; GRAPH-NEXT:   updates [AAAlign] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state align<1-16>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state nonnull
; GRAPH-NEXT:   updates [AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state nonnull
; GRAPH-NEXT:   updates [AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state nonnull
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoAlias] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state may-alias
; GRAPH-EMPTY:
; GRAPH-NEXT: [AADereferenceable] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state unknown-dereferenceable
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoUndef] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state noundef
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state nonnull
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoAlias] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state may-alias
; GRAPH-EMPTY:
; GRAPH-NEXT: [AADereferenceable] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state dereferenceable<4-4>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AADereferenceable] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state unknown-dereferenceable
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state nonnull
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAAlign] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state align<16-16>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAAlign] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state align<16-16>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state readonly
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state nofree
; GRAPH-NEXT:   updates [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state nofree
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAPrivatizablePtr] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state [no-priv]
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nounwind
; GRAPH-NEXT:   updates [AAIsDead] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state assumed-live
; GRAPH-NEXT:   updates [AANoUnwind] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state nounwind
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state readonly
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoUndef] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state may-undef-or-poison
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoCapture] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-NEXT:   updates [AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position {arg: [@0]} with state assumed not-captured-maybe-returned
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoAlias] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state may-alias
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state readonly
; GRAPH-NEXT:   updates [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument
; GRAPH-NEXT:   updates [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument
; GRAPH-NEXT:   updates [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state nofree
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueConstantRange] for CtxI '  %3 = icmp eq i32 %2, 0' at position {flt: [@-1]} with state range(1)<full-set / full-set>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI <<null inst>> at position {flt: [@-1]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueConstantRange] for CtxI <<null inst>> at position {flt: [@-1]} with state range(32)<[0,1) / [0,1)>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAPotentialValues] for CtxI '  %3 = icmp eq i32 %2, 0' at position {flt: [@-1]} with state set-state(< {full-set} >)
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoReturn] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state may-return
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoAlias] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state may-alias
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoUndef] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state may-undef-or-poison
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAValueSimplify] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state simplified
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAAlign] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state align<16-16>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANonNull] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state nonnull
; GRAPH-NEXT:   updates [AANonNull] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state nonnull
; GRAPH-NEXT:   updates [AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_arg: [@0]} with state nonnull
; GRAPH-NEXT:   updates [AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state nonnull
; GRAPH-NEXT:   updates [AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state nonnull
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  ret i32* %.0' at position {flt: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  br label %8' at position {flt: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  br label %8' at position {flt: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAIsDead] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state assumed-live
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAWillReturn] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state may-noreturn
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoRecurse] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state may-recurse
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoSync] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nosync
; GRAPH-NEXT:   updates [AANoSync] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state nosync
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state nofree
; GRAPH-NEXT:   updates [AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state nofree
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAMemoryLocation] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs: [@-1]} with state memory:argument
; GRAPH-NEXT:   updates [AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn:checkAndAdvance [checkAndAdvance@-1]} with state memory:argument
; GRAPH-EMPTY:
; GRAPH-NEXT: [AAAlign] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state align<1-16>
; GRAPH-NEXT:   updates [AAAlign] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state align<1-16>
; GRAPH-EMPTY:
; GRAPH-NEXT: [AADereferenceable] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state unknown-dereferenceable
; GRAPH-EMPTY:
; GRAPH-NEXT: [AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position {cs_ret: [@-1]} with state nonnull
; GRAPH-NEXT:   updates [AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position {fn_ret:checkAndAdvance [checkAndAdvance@-1]} with state nonnull
; GRAPH-EMPTY:
; GRAPH-NEXT: [AADereferenceable] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position {flt: [@-1]} with state unknown-dereferenceable

; GRAPH-NOT: update

;
; Check for .dot file
;

; DOT-DAG: Node[[Node6:0x[a-z0-9]+]] [shape=record,label="{[AANoUnwind] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node34:0x[a-z0-9]+]] [shape=record,label="{[AANoCapture] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{arg: [@0]\}
; DOT-DAG: Node[[Node39:0x[a-z0-9]+]] [shape=record,label="{[AANoUnwind] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node7:0x[a-z0-9]+]] [shape=record,label="{[AANoSync] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node61:0x[a-z0-9]+]] [shape=record,label="{[AANoSync] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node13:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node36:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{arg: [@0]\}
; DOT-DAG: Node[[Node62:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node16:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node35:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{arg: [@0]\}
; DOT-DAG: Node[[Node40:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node17:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryLocation] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node63:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryLocation] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs: [@-1]\}
; DOT-DAG: Node[[Node22:0x[a-z0-9]+]] [shape=record,label="{[AAAlign] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn_ret:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node65:0x[a-z0-9]+]] [shape=record,label="{[AAAlign] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_ret: [@-1]\}
; DOT-DAG: Node[[Node23:0x[a-z0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %2 = load i32, i32* %0, align 4' at position \{fn_ret:checkAndAdvance [checkAndAdvance@-1]\}
; DOT-DAG: Node[[Node67:0x[a-z0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_ret: [@-1]\}
; DOT-DAG: Node[[Node43:0x[a-z0-9]+]] [shape=record,label="{[AANoCapture] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}
; DOT-DAG: Node[[Node45:0x[a-z0-9]+]] [shape=record,label="{[AAMemoryBehavior] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}
; DOT-DAG: Node[[Node46:0x[a-z0-9]+]] [shape=record,label="{[AANoFree] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}
; DOT-DAG: Node[[Node38:0x[a-z0-9]+]] [shape=record,label="{[AAIsDead] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_ret: [@-1]\}
; DOT-DAG: Node[[Node55:0x[a-z0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %5 = getelementptr inbounds i32, i32* %0, i64 4' at position \{flt: [@-1]\}
; DOT-DAG: Node[[Node31:0x[a-x0-9]+]] [shape=record,label="{[AANonNull] for CtxI '  %6 = call i32* @checkAndAdvance(i32* %5)' at position \{cs_arg: [@0]\}

; DOT-DAG: Node[[Node6]] -> Node[[Node34]]
; DOT-DAG: Node[[Node6]] -> Node[[Node39]]
; DOT-DAG: Node[[Node7]] -> Node[[Node61]]
; DOT-DAG: Node[[Node13]] -> Node[[Node36]]
; DOT-DAG: Node[[Node13]] -> Node[[Node62]]
; DOT-DAG: Node[[Node16]] -> Node[[Node34]]
; DOT-DAG: Node[[Node16]] -> Node[[Node35]]
; DOT-DAG: Node[[Node16]] -> Node[[Node40]]
; DOT-DAG: Node[[Node17]] -> Node[[Node63]]
; DOT-DAG: Node[[Node22]] -> Node[[Node65]]
; DOT-DAG: Node[[Node23]] -> Node[[Node67]]
; DOT-DAG: Node[[Node34]] -> Node[[Node43]]
; DOT-DAG: Node[[Node35]] -> Node[[Node45]]
; DOT-DAG: Node[[Node36]] -> Node[[Node46]]
; DOT-DAG: Node[[Node39]] -> Node[[Node38]]
; DOT-DAG: Node[[Node39]] -> Node[[Node6]]
; DOT-DAG: Node[[Node40]] -> Node[[Node16]]
; DOT-DAG: Node[[Node43]] -> Node[[Node34]]
; DOT-DAG: Node[[Node45]] -> Node[[Node17]]
; DOT-DAG: Node[[Node55]] -> Node[[Node55]]
; DOT-DAG: Node[[Node55]] -> Node[[Node31]]
; DOT-DAG: Node[[Node55]] -> Node[[Node23]]
; DOT-DAG: Node[[Node61]] -> Node[[Node7]]
; DOT-DAG: Node[[Node62]] -> Node[[Node13]]
; DOT-DAG: Node[[Node63]] -> Node[[Node17]]
; DOT-DAG: Node[[Node65]] -> Node[[Node22]]
; DOT-DAG: Node[[Node67]] -> Node[[Node23]]
;.
; CHECK: attributes #[[ATTR0]] = { argmemonly nofree nosync nounwind readonly }
; CHECK: attributes #[[ATTR1]] = { nofree nosync nounwind readonly }
;.
