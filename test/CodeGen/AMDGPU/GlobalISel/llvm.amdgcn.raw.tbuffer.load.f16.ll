; NOTE: Assertions have been autogenerated by utils/update_mir_test_checks.py
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=fiji -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck -check-prefix=UNPACKED %s
; RUN: llc -global-isel -mtriple=amdgcn-mesa-mesa3d -mcpu=gfx810 -stop-after=instruction-select -verify-machineinstrs -o - %s | FileCheck -check-prefix=PACKED %s

define amdgpu_ps half @raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; PACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.raw.tbuffer.load.f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret half %val
}

define amdgpu_ps <2 x half> @raw_tbuffer_load_v2f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_v2f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_XY_gfx80_OFFEN:%[0-9]+]]:vreg_64 = TBUFFER_LOAD_FORMAT_D16_XY_gfx80_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XY_gfx80_OFFEN]].sub0
  ; UNPACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XY_gfx80_OFFEN]].sub1
  ; UNPACKED:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; UNPACKED:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY6]], [[COPY8]], implicit $exec
  ; UNPACKED:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_1:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY7]], [[COPY9]], implicit $exec
  ; UNPACKED:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; UNPACKED:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY10]], [[V_AND_B32_e64_1]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_]], [[V_LSHLREV_B32_e64_]], implicit $exec
  ; UNPACKED:   $vgpr0 = COPY [[V_OR_B32_e64_]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; PACKED-LABEL: name: raw_tbuffer_load_v2f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_XY_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_XY_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 4 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_XY_OFFEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call <2 x half> @llvm.amdgcn.raw.tbuffer.load.v2f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <2 x half> %val
}

; FIXME: Crashes
; define amdgpu_ps <3 x half> @raw_tbuffer_load_v3f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
;   %val = call <3 x half> @llvm.amdgcn.raw.tbuffer.load.v3f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
;   ret <3 x half> %val
; }

define amdgpu_ps <4 x half> @raw_tbuffer_load_v4f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_v4f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_OFFEN:%[0-9]+]]:vreg_128 = TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 8 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_OFFEN]].sub0
  ; UNPACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_OFFEN]].sub1
  ; UNPACKED:   [[COPY8:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_OFFEN]].sub2
  ; UNPACKED:   [[COPY9:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_gfx80_OFFEN]].sub3
  ; UNPACKED:   [[S_MOV_B32_:%[0-9]+]]:sreg_32 = S_MOV_B32 65535
  ; UNPACKED:   [[COPY10:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY6]], [[COPY10]], implicit $exec
  ; UNPACKED:   [[COPY11:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_1:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY7]], [[COPY11]], implicit $exec
  ; UNPACKED:   [[S_MOV_B32_1:%[0-9]+]]:sreg_32 = S_MOV_B32 16
  ; UNPACKED:   [[COPY12:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY12]], [[V_AND_B32_e64_1]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_]], [[V_LSHLREV_B32_e64_]], implicit $exec
  ; UNPACKED:   [[COPY13:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_2:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY8]], [[COPY13]], implicit $exec
  ; UNPACKED:   [[COPY14:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_]]
  ; UNPACKED:   [[V_AND_B32_e64_3:%[0-9]+]]:vgpr_32 = V_AND_B32_e64 [[COPY9]], [[COPY14]], implicit $exec
  ; UNPACKED:   [[COPY15:%[0-9]+]]:vgpr_32 = COPY [[S_MOV_B32_1]]
  ; UNPACKED:   [[V_LSHLREV_B32_e64_1:%[0-9]+]]:vgpr_32 = V_LSHLREV_B32_e64 [[COPY15]], [[V_AND_B32_e64_3]], implicit $exec
  ; UNPACKED:   [[V_OR_B32_e64_1:%[0-9]+]]:vgpr_32 = V_OR_B32_e64 [[V_AND_B32_e64_2]], [[V_LSHLREV_B32_e64_1]], implicit $exec
  ; UNPACKED:   $vgpr0 = COPY [[V_OR_B32_e64_]]
  ; UNPACKED:   $vgpr1 = COPY [[V_OR_B32_e64_1]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  ; PACKED-LABEL: name: raw_tbuffer_load_v4f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_XYZW_OFFEN:%[0-9]+]]:vreg_64 = TBUFFER_LOAD_FORMAT_D16_XYZW_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 8 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_OFFEN]].sub0
  ; PACKED:   [[COPY7:%[0-9]+]]:vgpr_32 = COPY [[TBUFFER_LOAD_FORMAT_D16_XYZW_OFFEN]].sub1
  ; PACKED:   $vgpr0 = COPY [[COPY6]]
  ; PACKED:   $vgpr1 = COPY [[COPY7]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0, implicit $vgpr1
  %val = call <4 x half> @llvm.amdgcn.raw.tbuffer.load.v4f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret <4 x half> %val
}

define amdgpu_ps half @raw_tbuffer_load_f16__vgpr_rsrc__sgpr_voffset__vgpr_soffset(<4 x i32> %rsrc, i32 inreg %voffset, i32 %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_f16__vgpr_rsrc__sgpr_voffset__vgpr_soffset
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   successors: %bb.2(0x80000000)
  ; UNPACKED:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; UNPACKED:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; UNPACKED:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; UNPACKED:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; UNPACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; UNPACKED:   [[COPY7:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; UNPACKED:   [[COPY8:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; UNPACKED:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; UNPACKED: bb.2:
  ; UNPACKED:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; UNPACKED:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub0, implicit $exec
  ; UNPACKED:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub1, implicit $exec
  ; UNPACKED:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; UNPACKED:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY7]], implicit $exec
  ; UNPACKED:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub0, implicit $exec
  ; UNPACKED:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub1, implicit $exec
  ; UNPACKED:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; UNPACKED:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY8]], implicit $exec
  ; UNPACKED:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; UNPACKED:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; UNPACKED:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; UNPACKED:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY5]], implicit $exec
  ; UNPACKED:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN [[COPY6]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; UNPACKED:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; UNPACKED:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; UNPACKED: bb.3:
  ; UNPACKED:   successors: %bb.4(0x80000000)
  ; UNPACKED:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; UNPACKED: bb.4:
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; PACKED-LABEL: name: raw_tbuffer_load_f16__vgpr_rsrc__sgpr_voffset__vgpr_soffset
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   successors: %bb.2(0x80000000)
  ; PACKED:   liveins: $sgpr2, $vgpr0, $vgpr1, $vgpr2, $vgpr3, $vgpr4
  ; PACKED:   [[COPY:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY1:%[0-9]+]]:vgpr_32 = COPY $vgpr1
  ; PACKED:   [[COPY2:%[0-9]+]]:vgpr_32 = COPY $vgpr2
  ; PACKED:   [[COPY3:%[0-9]+]]:vgpr_32 = COPY $vgpr3
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:vreg_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY5:%[0-9]+]]:vgpr_32 = COPY $vgpr4
  ; PACKED:   [[COPY6:%[0-9]+]]:vgpr_32 = COPY [[COPY4]]
  ; PACKED:   [[COPY7:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub0_sub1
  ; PACKED:   [[COPY8:%[0-9]+]]:vreg_64 = COPY [[REG_SEQUENCE]].sub2_sub3
  ; PACKED:   [[S_MOV_B64_term:%[0-9]+]]:sreg_64_xexec = S_MOV_B64_term $exec
  ; PACKED: bb.2:
  ; PACKED:   successors: %bb.3(0x40000000), %bb.2(0x40000000)
  ; PACKED:   [[V_READFIRSTLANE_B32_:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub0, implicit $exec
  ; PACKED:   [[V_READFIRSTLANE_B32_1:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY7]].sub1, implicit $exec
  ; PACKED:   [[REG_SEQUENCE1:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1
  ; PACKED:   [[V_CMP_EQ_U64_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE1]], [[COPY7]], implicit $exec
  ; PACKED:   [[V_READFIRSTLANE_B32_2:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub0, implicit $exec
  ; PACKED:   [[V_READFIRSTLANE_B32_3:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY8]].sub1, implicit $exec
  ; PACKED:   [[REG_SEQUENCE2:%[0-9]+]]:sreg_64_xexec = REG_SEQUENCE [[V_READFIRSTLANE_B32_2]], %subreg.sub0, [[V_READFIRSTLANE_B32_3]], %subreg.sub1
  ; PACKED:   [[V_CMP_EQ_U64_e64_1:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U64_e64 [[REG_SEQUENCE2]], [[COPY8]], implicit $exec
  ; PACKED:   [[S_AND_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U64_e64_1]], [[V_CMP_EQ_U64_e64_]], implicit-def $scc
  ; PACKED:   [[REG_SEQUENCE3:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[V_READFIRSTLANE_B32_]], %subreg.sub0, [[V_READFIRSTLANE_B32_1]], %subreg.sub1, [[V_READFIRSTLANE_B32_2]], %subreg.sub2, [[V_READFIRSTLANE_B32_3]], %subreg.sub3
  ; PACKED:   [[V_READFIRSTLANE_B32_4:%[0-9]+]]:sreg_32_xm0 = V_READFIRSTLANE_B32 [[COPY5]], implicit $exec
  ; PACKED:   [[V_CMP_EQ_U32_e64_:%[0-9]+]]:sreg_64_xexec = V_CMP_EQ_U32_e64 [[V_READFIRSTLANE_B32_4]], [[COPY5]], implicit $exec
  ; PACKED:   [[S_AND_B64_1:%[0-9]+]]:sreg_64_xexec = S_AND_B64 [[V_CMP_EQ_U32_e64_]], [[S_AND_B64_]], implicit-def $scc
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_OFFEN [[COPY6]], [[REG_SEQUENCE3]], [[V_READFIRSTLANE_B32_4]], 0, 78, 0, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   [[S_AND_SAVEEXEC_B64_:%[0-9]+]]:sreg_64_xexec = S_AND_SAVEEXEC_B64 killed [[S_AND_B64_1]], implicit-def $exec, implicit-def $scc, implicit $exec
  ; PACKED:   $exec = S_XOR_B64_term $exec, [[S_AND_SAVEEXEC_B64_]], implicit-def $scc
  ; PACKED:   S_CBRANCH_EXECNZ %bb.2, implicit $exec
  ; PACKED: bb.3:
  ; PACKED:   successors: %bb.4(0x80000000)
  ; PACKED:   $exec = S_MOV_B64_term [[S_MOV_B64_term]]
  ; PACKED: bb.4:
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.raw.tbuffer.load.f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 0)
  ret half %val
}

define amdgpu_ps half @raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_glc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_glc
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 1, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; PACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_glc
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 1, 0, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.raw.tbuffer.load.f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 1)
  ret half %val
}

define amdgpu_ps half @raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 1, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; PACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 1, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.raw.tbuffer.load.f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 2)
  ret half %val
}

define amdgpu_ps half @raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc_glc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc_glc
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 1, 1, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; PACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_slc_glc
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 1, 1, 0, 0, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.raw.tbuffer.load.f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 3)
  ret half %val
}

define amdgpu_ps half @raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_dlc(<4 x i32> inreg %rsrc, i32 %voffset, i32 inreg %soffset) {
  ; UNPACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_dlc
  ; UNPACKED: bb.1 (%ir-block.0):
  ; UNPACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; UNPACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; UNPACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; UNPACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; UNPACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; UNPACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; UNPACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; UNPACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; UNPACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 1, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; UNPACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_gfx80_OFFEN]]
  ; UNPACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  ; PACKED-LABEL: name: raw_tbuffer_load_f16__sgpr_rsrc__vgpr_voffset__sgpr_soffset_dlc
  ; PACKED: bb.1 (%ir-block.0):
  ; PACKED:   liveins: $sgpr2, $sgpr3, $sgpr4, $sgpr5, $sgpr6, $vgpr0
  ; PACKED:   [[COPY:%[0-9]+]]:sreg_32 = COPY $sgpr2
  ; PACKED:   [[COPY1:%[0-9]+]]:sreg_32 = COPY $sgpr3
  ; PACKED:   [[COPY2:%[0-9]+]]:sreg_32 = COPY $sgpr4
  ; PACKED:   [[COPY3:%[0-9]+]]:sreg_32 = COPY $sgpr5
  ; PACKED:   [[REG_SEQUENCE:%[0-9]+]]:sgpr_128 = REG_SEQUENCE [[COPY]], %subreg.sub0, [[COPY1]], %subreg.sub1, [[COPY2]], %subreg.sub2, [[COPY3]], %subreg.sub3
  ; PACKED:   [[COPY4:%[0-9]+]]:vgpr_32 = COPY $vgpr0
  ; PACKED:   [[COPY5:%[0-9]+]]:sreg_32 = COPY $sgpr6
  ; PACKED:   [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN:%[0-9]+]]:vgpr_32 = TBUFFER_LOAD_FORMAT_D16_X_OFFEN [[COPY4]], [[REG_SEQUENCE]], [[COPY5]], 0, 78, 0, 0, 0, 1, 0, 0, implicit $exec :: (dereferenceable load 2 from custom "BufferResource", align 1, addrspace 4)
  ; PACKED:   $vgpr0 = COPY [[TBUFFER_LOAD_FORMAT_D16_X_OFFEN]]
  ; PACKED:   SI_RETURN_TO_EPILOG implicit $vgpr0
  %val = call half @llvm.amdgcn.raw.tbuffer.load.f16(<4 x i32> %rsrc, i32 %voffset, i32 %soffset, i32 78, i32 4)
  ret half %val
}

declare half @llvm.amdgcn.raw.tbuffer.load.f16(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0
declare <2 x half> @llvm.amdgcn.raw.tbuffer.load.v2f16(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0
declare <3 x half> @llvm.amdgcn.raw.tbuffer.load.v3f16(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0
declare <4 x half> @llvm.amdgcn.raw.tbuffer.load.v4f16(<4 x i32>, i32, i32, i32 immarg, i32 immarg) #0

attributes #0 = { nounwind readonly }
