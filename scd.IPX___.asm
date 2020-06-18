; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Start of IPX___.MMD file
; This is the original and bit-perfect IPX___.MMD file disassembly for all regions.

IPX_Header:
	dc.l	$000000FF, $000003FF, IPX_RAM_Start, 0, 0, 0, 0, 0
	dc.l	0, 0, 0, 0, 0, 0, 0, 0
	dc.l	0, 0, 0, 0, 0, 0, 0, 0
	dc.l	0, 0, 0, 0, 0, 0, 0, 0
	dc.l	0, 0, 0, 0, 0, 0, 0, 0
	dc.l	0, 0, 0, 0, 0, 0, 0, 0
	dc.l	0, 0, 0, 0, 0, 0, 0, 0
	dc.l	0, 0, 0, 0, 0, 0, 0, 0
; -----------------------------------------------------------------------------

IPX_Start:
	move.l	#IPX_int_BE4-IPX_Start+IPX_RAM_Start,(V_Int_addr).w
	bsr.w	IPX_loc_D1C

	; Erases $1100 bytes starting at $0F00.
	; $0F00 -> $2000
	lea	(IPX_unk_0F00).l,a0
	move.w	#$0440-1,d7
.loop:	move.l	#0,(a0)+
	dbf	d7,.loop

	moveq	#unk_file_5,d0
	bsr.w	IPX_LoadAndRunFile
	move.w	#unk_file_89,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	d0
	beq.s	.skip
	bset	#0,(IPX_unk_0F1F).l
.skip:	bsr.w	IPX_LoadSavedData

IPX_MainLoop:
	move.w	#unk_file_86,d0
	bsr.w	IPX_loc_CE0

	moveq	#0,d0
	move.l	d0,(IPX_unk_1518).l
	move.b	d0,(IPX_unk_0F01).l
	move.b	d0,(IPX_unk_156E).l
	move.b	d0,(IPX_unk_158E).l
	move.w	d0,(IPX_unk_1512).l
	move.l	d0,(IPX_unk_1514).l
	move.b	d0,(IPX_GoodFuture_ActFlag).l
	move.b	d0,(IPX_unk_156D).l
	move.b	#present,(IPX_CurrentTimeZone).l

	moveq	#title_screen_file,d0
	bsr.w	IPX_LoadAndRunFile
	ext.w	d1
	add.w	d1,d1
	move.w	IPX_off_TitleSelection(pc,d1.w),d1
	jsr	IPX_off_TitleSelection(pc,d1.w)
	bra.s	IPX_MainLoop
; -----------------------------------------------------------------------------
;IPX_off_94:
IPX_off_TitleSelection:	offsetTable
			offsetTableEntry.w IPX_StartDemo
			offsetTableEntry.w IPX_NewGame
			offsetTableEntry.w IPX_Continue
			offsetTableEntry.w IPX_TimeAttack
			offsetTableEntry.w IPX_RamData
			offsetTableEntry.w IPX_DAGarden
			offsetTableEntry.w IPX_VisualMode
			offsetTableEntry.w IPX_SoundTest
			offsetTableEntry.w IPX_LevelSelect
			offsetTableEntry.w IPX_TeamRecords
; -----------------------------------------------------------------------------
;IPX_loc_A8:
IPX_TeamRecords:
	move.w	#team_records_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_B0:
IPX_RamData:
	move.w	#ram_data_file,d0
	bsr.w	IPX_LoadAndRunFile
	bsr.w	IPX_LoadSavedData
	rts
; -----------------------------------------------------------------------------
;IPX_loc_BE:
IPX_SS1_Start:
	move.b	#0,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#0,(IO_SpecialStage_Flags).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------
;IPX_loc_DE:
IPX_SS6_Start:
	move.b	#5,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#0,(IO_SpecialStage_Flags).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------
;IPX_loc_FE:
IPX_Continue:
	bsr.w	IPX_LoadSavedData
	move.w	(IPX_CurrentZoneInSave).l,(IPX_CurrentZoneAndAct).l
	move.b	#3,(IPX_unk_1508).l
	move.b	#0,(IPX_unk_151C).l

	cmpi.b	#palmtree_panic_zone,(IPX_CurrentZoneAndAct).l
	beq.w	IPX_NewGame
	cmpi.b	#collision_chaos_zone,(IPX_CurrentZoneAndAct).l
	bls.w	IPX_Continue_R3
	cmpi.b	#tidal_tempest_zone,(IPX_CurrentZoneAndAct).l
	bls.w	IPX_Continue_R4
	cmpi.b	#quartz_quadrant_zone,(IPX_CurrentZoneAndAct).l
	bls.w	IPX_Continue_R5
	cmpi.b	#wacky_workbench_zone,(IPX_CurrentZoneAndAct).l
	bls.w	IPX_Continue_R6
	cmpi.b	#stardust_speedway_zone,(IPX_CurrentZoneAndAct).l
	bls.w	IPX_Continue_R7
	cmpi.b	#metallic_madness_zone,(IPX_CurrentZoneAndAct).l
	bls.w	IPX_Continue_R8

;IPX_loc_170:
IPX_NewGame:
	moveq	#0,d0
	move.b	d0,(IPX_unk_151C).l
	move.w	d0,(IPX_CurrentZoneAndAct).l
	move.w	d0,(IPX_CurrentZoneInSave).l
	move.b	d0,(IPX_GoodFuture_Array).l
	move.b	d0,(IPX_unk_0F21).l
	move.b	d0,(IPX_TimeStones_Array).l

	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R11
	bsr.w	IPX_LoadAndRun_R12
	bsr.w	IPX_LoadAndRun_R13

	moveq	#3,d0
	bsr.w	IPX_loc_5F8

	bset	#6,(IPX_unk_0F1D).l
	bset	#5,(IPX_unk_0F1D).l
	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l ; Good future in act 3?
	beq.s	IPX_Continue_R3
	bset	#0,(IPX_GoodFuture_Array).l

;IPX_loc_1DE:
IPX_Continue_R3:
	bsr.w	IPX_SaveData
	move.b	#0,(IPX_unk_1577).l
	bsr.w	IPX_LoadAndRun_R31
	move.b	#0,(IPX_unk_1577).l
	bsr.w	IPX_LoadAndRun_R32
	bsr.w	IPX_LoadAndRun_R33

	moveq	#6,d0
	bsr.w	IPX_loc_5F8

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l ; Good future in act 3?
	beq.s	IPX_Continue_R4
	bset	#1,(IPX_GoodFuture_Array).l

;IPX_loc_226:
IPX_Continue_R4:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R41
	bsr.w	IPX_LoadAndRun_R42
	bsr.w	IPX_LoadAndRun_R43

	moveq	#9,d0
	bsr.w	IPX_loc_5F8

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l ; Good future in act 3?
	beq.s	IPX_Continue_R5
	bset	#2,(IPX_GoodFuture_Array).l

;IPX_loc_25E:
IPX_Continue_R5:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R51
	bsr.w	IPX_LoadAndRun_R52
	bsr.w	IPX_LoadAndRun_R53

	moveq	#12,d0
	bsr.w	IPX_loc_5F8

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l ; Good future in act 3?
	beq.s	IPX_Continue_R6
	bset	#3,(IPX_GoodFuture_Array).l

;IPX_loc_296:
IPX_Continue_R6:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R61
	bsr.w	IPX_LoadAndRun_R62
	bsr.w	IPX_LoadAndRun_R63

	moveq	#15,d0
	bsr.w	IPX_loc_5F8

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l ; Good future in act 3?
	beq.s	IPX_Continue_R7
	bset	#4,(IPX_GoodFuture_Array).l

;IPX_loc_2CE:
IPX_Continue_R7:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R71
	bsr.w	IPX_LoadAndRun_R72
	bsr.w	IPX_LoadAndRun_R73

	moveq	#18,d0
	bsr.w	IPX_loc_5F8

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l ; Good future in act 3?
	beq.s	IPX_Continue_R8
	bset	#5,(IPX_GoodFuture_Array).l

;IPX_loc_306:
IPX_Continue_R8:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R81
	bsr.w	IPX_LoadAndRun_R82
	bsr.w	IPX_LoadAndRun_R83

	moveq	#21,d0
	bsr.w	IPX_loc_5F8

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l ; Good future in act 3?
	beq.s	IPX_EndOfGame
	bset	#6,(IPX_GoodFuture_Array).l

;IPX_loc_33E:
IPX_EndOfGame:
	move.b	(IPX_GoodFuture_Array).l,(IPX_static_GoodFuture_Array).l
	move.b	(IPX_TimeStones_Array).l,(IPX_static_TimeStones_Array).l
	bsr.w	IPX_SaveData

	cmpi.b	#$7F,(IPX_static_GoodFuture_Array).l
	beq.s	IPX_GoodEnding
	cmpi.b	#$7F,(IPX_static_TimeStones_Array).l
	beq.s	IPX_GoodEnding

;IPX_loc_36A:
IPX_BadEnding:
	move.b	#0,(IPX_unk_0F24).l
	move.w	#bad_ending_file,d0
	bsr.w	IPX_LoadAndRunFile
	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_BadEnding
	rts
; -----------------------------------------------------------------------------
;IPX_loc_384:
IPX_GoodEnding:
	move.b	#$7F,(IPX_unk_0F24).l
	move.w	#$94,d0
	bsr.w	IPX_LoadAndRunFile
	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_GoodEnding
	rts
; -----------------------------------------------------------------------------

IPX_loc_39E:
	move.b	#0,(IPX_Act).l
	move.w	(IPX_CurrentZoneAndAct).l,(IPX_CurrentZoneInSave).l

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	bclr	#0,(IPX_GoodFuture_ActFlag).l
	rts
; -----------------------------------------------------------------------------
; RAM variables inside executed code
IPX_RAM_03CA:	dc.b	0
IPX_RAM_03CB:	dc.b	0
; -----------------------------------------------------------------------------
;IPX_loc_3CC:
IPX_LoadAndRun_R11:
	lea	IPX_byte_608(pc),a0
	move.w	#palmtree_panic_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_3DC:
IPX_LoadAndRun_R12:
	lea	IPX_byte_608+4(pc),a0
	move.w	#palmtree_panic_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_3EC:
IPX_LoadAndRun_R13:
	lea	IPX_byte_608+8(pc),a0
	move.w	#palmtree_panic_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_5B4
; -----------------------------------------------------------------------------
;IPX_loc_3FC:
IPX_LoadAndRun_R31:
	lea	IPX_byte_612(pc),a0
	move.w	#collision_chaos_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_40C:
IPX_LoadAndRun_R32:
	lea	IPX_byte_612+4(pc),a0
	move.w	#collision_chaos_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_41C:
IPX_LoadAndRun_R33:
	lea	IPX_byte_612+8(pc),a0
	move.w	#collision_chaos_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_5B4
; -----------------------------------------------------------------------------
;IPX_loc_42C:
IPX_LoadAndRun_R41:
	lea	IPX_byte_61C(pc),a0
	move.w	#tidal_tempest_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_43C:
IPX_LoadAndRun_R42:
	lea	IPX_byte_61C+4(pc),a0
	move.w	#tidal_tempest_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_44C:
IPX_LoadAndRun_R43:
	lea	IPX_byte_61C+8(pc),a0
	move.w	#tidal_tempest_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_5B4
; -----------------------------------------------------------------------------
;IPX_loc_45C:
IPX_LoadAndRun_R51:
	lea	IPX_byte_626(pc),a0
	move.w	#quartz_quadrant_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_46C:
IPX_LoadAndRun_R52:
	lea	IPX_byte_626+4(pc),a0
	move.w	#quartz_quadrant_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_47C:
IPX_LoadAndRun_R53:
	lea	IPX_byte_626+8(pc),a0
	move.w	#quartz_quadrant_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_5B4
; -----------------------------------------------------------------------------
;IPX_loc_48C:
IPX_LoadAndRun_R61:
	lea	IPX_byte_630(pc),a0
	move.w	#wacky_workbench_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_49A:
IPX_LoadAndRun_R62:
	lea	IPX_byte_630+4(pc),a0
	move.w	#wacky_workbench_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_4A8:
IPX_LoadAndRun_R63:
	lea	IPX_byte_630+8(pc),a0
	move.w	#wacky_workbench_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_5B4
; -----------------------------------------------------------------------------
;IPX_loc_4B8:
IPX_LoadAndRun_R71:
	lea	IPX_byte_63A(pc),a0
	move.w	#stardust_speedway_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_4C6:
IPX_LoadAndRun_R72:
	lea	IPX_byte_63A+4(pc),a0
	move.w	#stardust_speedway_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_4D4:
IPX_LoadAndRun_R73:
	lea	IPX_byte_63A+8(pc),a0
	move.w	#stardust_speedway_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_5B4
; -----------------------------------------------------------------------------
;IPX_loc_4E4:
IPX_LoadAndRun_R81:
	lea	IPX_byte_644(pc),a0
	move.w	#metallic_madness_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_4F2:
IPX_LoadAndRun_R82:
	lea	IPX_byte_644+4(pc),a0
	move.w	#metallic_madness_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_loc_510
; -----------------------------------------------------------------------------
;IPX_loc_500:
IPX_LoadAndRun_R83:
	lea	IPX_byte_644+8(pc),a0
	move.w	#metallic_madness_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_loc_5B4
; -----------------------------------------------------------------------------

IPX_loc_510:
	moveq	#0,d0
	_move.b	0(a0),d0

IPX_loc_516:
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_unk_1508).l
	beq.s	IPX_loc_55E
	btst	#7,(IPX_CurrentTimeZone).l
	beq.s	IPX_loc_55E

	moveq	#$C,d0
	bsr.w	IPX_LoadAndRunFile
	move.b	(IPX_CurrentTimeZone).l,d1

	moveq	#0,d0
	move.b	1(a0),d0
	andi.b	#$7F,d1
	beq.s	IPX_loc_516

	_move.b	0(a0),d0
	subq.b	#1,d1
	beq.s	IPX_loc_516

	move.b	3(a0),d0
	tst.b	(IPX_GoodFuture_ActFlag).l
	beq.s	IPX_loc_516

	move.b	2(a0),d0
	bra.s	IPX_loc_516
; -----------------------------------------------------------------------------

IPX_loc_55E:
	tst.b	(IPX_unk_1508).l
	bne.s	IPX_loc_56C
	move.l	(sp)+,d0
	bra.w	IPX_loc_39E
; -----------------------------------------------------------------------------

IPX_loc_56C:
	tst.b	(IPX_unk_156E).l
	bne.s	IPX_loc_576
	rts
; -----------------------------------------------------------------------------

IPX_loc_576:
	move.b	(IPX_unk_0F21).l,(IO_SpecialStageToLoad).l
	move.b	(IPX_TimeStones_Array).l,(IO_TimeStones_Array).l
	bclr	#0,(IO_SpecialStage_Flags).l

	moveq	#$75,d0
	bsr.w	IPX_LoadAndRunFile

	move.b	#1,(IPX_unk_0F22).l
	cmpi.b	#$7F,(IPX_TimeStones_Array).l
	bne.s	IPX_loc_5B2
	move.b	#good_future,(IPX_GoodFuture_ActFlag).l

IPX_loc_5B2:
	rts
; -----------------------------------------------------------------------------

IPX_loc_5B4:
	moveq	#0,d0

	_move.b	0(a0),d0
	tst.b	(IPX_GoodFuture_ActFlag).l
	bne.s	IPX_loc_5C6
	move.b	1(a0),d0

IPX_loc_5C6:
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_unk_1508).l
	bne.s	IPX_loc_5D8

	move.l	(sp)+,d0
	bra.w	IPX_loc_39E
; -----------------------------------------------------------------------------

IPX_loc_5D8:
	addq.b	#1,(IPX_CurrentZoneInSave).l
	cmpi.b	#7,(IPX_CurrentZoneInSave).l
	bcs.s	IPX_loc_5EE
	subq.b	#1,(IPX_CurrentZoneInSave).l

IPX_loc_5EE:
	move.b	#0,(IPX_unk_158E).l
	rts
; -----------------------------------------------------------------------------

IPX_loc_5F8:
	cmp.b	(IPX_unk_0F18).l,d0
	bls.s	IPX_byte_606
	move.b	d0,(IPX_unk_0F18).l

IPX_byte_606:
	rts
; -----------------------------------------------------------------------------

ipx_608_macro	macro	act1A,act1B,act1C,act1D,act2A,act2B,act2C,act2D,act3C,act3D
	dc.b	act1A, act1B, act1C, act1D
	dc.b	act2A, act2B, act2C, act2D
	dc.b	act3C, act3D
	endm

IPX_byte_608:
	ipx_608_macro	  1,   2,   3,   4,     7,   8,   9,  $A,   $32, $33
IPX_byte_612:
	ipx_608_macro	$28, $29, $2A, $2B,   $2C, $2D, $2E, $2F,   $30, $31
IPX_byte_61C:
	ipx_608_macro	$34, $35, $36, $37,   $38, $39, $3A, $3B,   $3C, $3D
IPX_byte_626:
	ipx_608_macro	$3E, $3F, $40, $41,   $42, $43, $44, $45,   $46, $47
IPX_byte_630:
	ipx_608_macro	$48, $49, $4A, $4B,   $4C, $4D, $4E, $4F,   $50, $51
IPX_byte_63A:
	ipx_608_macro	$52, $53, $54, $55,   $56, $57, $58, $59,   $5A, $5B
IPX_byte_644:
	ipx_608_macro	$5C, $5D, $5E, $5F,   $60, $61, $62, $63,   $64, $65
; -----------------------------------------------------------------------------
;IPX_loc_64E:
IPX_LevelSelect:
	moveq	#6,d0
	bsr.w	IPX_LoadAndRunFile

	mulu.w	#6,d0
	move.w	IPX_byte_68A+2(pc,d0.w),(IPX_CurrentZoneAndAct).l
	move.b	IPX_byte_68A+4(pc,d0.w),(IPX_CurrentTimeZone).l
	move.b	IPX_byte_68A+5(pc,d0.w),(IPX_GoodFuture_ActFlag).l
	move.w	IPX_byte_68A(pc,d0.w),d0
	move.b	#0,(IPX_unk_156D).l

	cmpi.w	#$75,d0
	beq.w	IPX_SS1_Start
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------

ipx_68A_macro	macro	word1,word2,byte1,byte2
	dc.w	word1
	dc.w	word2
	dc.b	byte1
	dc.b	byte2
	endm

IPX_byte_68A:
	ipx_68A_macro	    1,    palmtree_panic_zone_act_1, present,  bad_future
	ipx_68A_macro	    2,    palmtree_panic_zone_act_1,    past,  bad_future
	ipx_68A_macro	    3,    palmtree_panic_zone_act_1,  future, good_future
	ipx_68A_macro	    4,    palmtree_panic_zone_act_1,  future,  bad_future
	ipx_68A_macro	    7,    palmtree_panic_zone_act_2, present,  bad_future
	ipx_68A_macro	    8,    palmtree_panic_zone_act_2,    past,  bad_future
	ipx_68A_macro	    9,    palmtree_panic_zone_act_2,  future, good_future
	ipx_68A_macro	   $A,    palmtree_panic_zone_act_2,  future,  bad_future
	ipx_68A_macro	   $C,                            0,       0,           0
	ipx_68A_macro	  $D7,                            0,       0,           0
	ipx_68A_macro	  $D8,                            0,       0,           0
	ipx_68A_macro	  $28,   collision_chaos_zone_act_1, present,  bad_future
	ipx_68A_macro	  $29,   collision_chaos_zone_act_1,    past,  bad_future
	ipx_68A_macro	  $2A,   collision_chaos_zone_act_1,  future, good_future
	ipx_68A_macro	  $2B,   collision_chaos_zone_act_1,  future,  bad_future
	ipx_68A_macro	  $2C,   collision_chaos_zone_act_2, present,  bad_future
	ipx_68A_macro	  $2D,   collision_chaos_zone_act_2,    past,  bad_future
	ipx_68A_macro	  $2E,   collision_chaos_zone_act_2,  future, good_future
	ipx_68A_macro	  $2F,   collision_chaos_zone_act_2,  future,  bad_future
	ipx_68A_macro	  $30,   collision_chaos_zone_act_3,  future, good_future
	ipx_68A_macro	  $31,   collision_chaos_zone_act_3,  future,  bad_future
	ipx_68A_macro	  $32,    palmtree_panic_zone_act_3,  future, good_future
	ipx_68A_macro	  $33,    palmtree_panic_zone_act_3,  future,  bad_future
	ipx_68A_macro	  $34,     tidal_tempest_zone_act_1, present,  bad_future
	ipx_68A_macro	  $35,     tidal_tempest_zone_act_1,    past,  bad_future
	ipx_68A_macro	  $36,     tidal_tempest_zone_act_1,  future, good_future
	ipx_68A_macro	  $37,     tidal_tempest_zone_act_1,  future,  bad_future
	ipx_68A_macro	  $38,     tidal_tempest_zone_act_2, present,  bad_future
	ipx_68A_macro	  $39,     tidal_tempest_zone_act_2,    past,  bad_future
	ipx_68A_macro	  $3A,     tidal_tempest_zone_act_2,  future, good_future
	ipx_68A_macro	  $3B,     tidal_tempest_zone_act_2,  future,  bad_future
	ipx_68A_macro	  $3C,     tidal_tempest_zone_act_3,  future, good_future
	ipx_68A_macro	  $3D,     tidal_tempest_zone_act_3,  future,  bad_future
	ipx_68A_macro	  $3E,   quartz_quadrant_zone_act_1, present,  bad_future
	ipx_68A_macro	  $3F,   quartz_quadrant_zone_act_1,    past,  bad_future
	ipx_68A_macro	  $40,   quartz_quadrant_zone_act_1,  future, good_future
	ipx_68A_macro	  $41,   quartz_quadrant_zone_act_1,  future,  bad_future
	ipx_68A_macro	  $42,   quartz_quadrant_zone_act_2, present,  bad_future
	ipx_68A_macro	  $43,   quartz_quadrant_zone_act_2,    past,  bad_future
	ipx_68A_macro	  $44,   quartz_quadrant_zone_act_2,  future, good_future
	ipx_68A_macro	  $45,   quartz_quadrant_zone_act_2,  future,  bad_future
	ipx_68A_macro	  $46,   quartz_quadrant_zone_act_3,  future, good_future
	ipx_68A_macro	  $47,   quartz_quadrant_zone_act_3,  future,  bad_future
	ipx_68A_macro	  $48,   wacky_workbench_zone_act_1, present,  bad_future
	ipx_68A_macro	  $49,   wacky_workbench_zone_act_1,    past,  bad_future
	ipx_68A_macro	  $4A,   wacky_workbench_zone_act_1,  future, good_future
	ipx_68A_macro	  $4B,   wacky_workbench_zone_act_1,  future,  bad_future
	ipx_68A_macro	  $4C,   wacky_workbench_zone_act_2, present,  bad_future
	ipx_68A_macro	  $4D,   wacky_workbench_zone_act_2,    past,  bad_future
	ipx_68A_macro	  $4E,   wacky_workbench_zone_act_2,  future, good_future
	ipx_68A_macro	  $4F,   wacky_workbench_zone_act_2,  future,  bad_future
	ipx_68A_macro	  $50,   wacky_workbench_zone_act_3,  future, good_future
	ipx_68A_macro	  $51,   wacky_workbench_zone_act_3,  future,  bad_future
	ipx_68A_macro	  $52, stardust_speedway_zone_act_1, present,  bad_future
	ipx_68A_macro	  $53, stardust_speedway_zone_act_1,    past,  bad_future
	ipx_68A_macro	  $54, stardust_speedway_zone_act_1,  future, good_future
	ipx_68A_macro	  $55, stardust_speedway_zone_act_1,  future,  bad_future
	ipx_68A_macro	  $56, stardust_speedway_zone_act_2, present,  bad_future
	ipx_68A_macro	  $57, stardust_speedway_zone_act_2,    past,  bad_future
	ipx_68A_macro	  $58, stardust_speedway_zone_act_2,  future, good_future
	ipx_68A_macro	  $59, stardust_speedway_zone_act_2,  future,  bad_future
	ipx_68A_macro	  $5A, stardust_speedway_zone_act_3,  future, good_future
	ipx_68A_macro	  $5B, stardust_speedway_zone_act_3,  future,  bad_future
	ipx_68A_macro	  $5C,  metallic_madness_zone_act_1, present,  bad_future
	ipx_68A_macro	  $5D,  metallic_madness_zone_act_1,    past,  bad_future
	ipx_68A_macro	  $5E,  metallic_madness_zone_act_1,  future, good_future
	ipx_68A_macro	  $5F,  metallic_madness_zone_act_1,  future,  bad_future
	ipx_68A_macro	  $60,  metallic_madness_zone_act_2, present,  bad_future
	ipx_68A_macro	  $61,  metallic_madness_zone_act_2,    past,  bad_future
	ipx_68A_macro	  $62,  metallic_madness_zone_act_2,  future, good_future
	ipx_68A_macro	  $63,  metallic_madness_zone_act_2,  future,  bad_future
	ipx_68A_macro	  $64,  metallic_madness_zone_act_3,  future, good_future
	ipx_68A_macro	  $65,  metallic_madness_zone_act_3,  future,  bad_future
	ipx_68A_macro	  $75,                            0,       0,           0
	ipx_68A_macro	    1,                            0,       1,           0
	ipx_68A_macro	    1,                            0,       1,           0
	ipx_68A_macro	    1,                            0,       1,           0
	ipx_68A_macro	    1,                            0,       1,           0
; -----------------------------------------------------------------------------
;IPX_loc_85E:
IPX_StartDemo:
	moveq	#5,d1
	lea	(IPX_unk_0F1C).l,a6
	moveq	#0,d0
	move.b	(a6),d0
	addq.b	#1,(a6)
	cmp.b	(a6),d1
	bcc.s	IPX_loc_874
	move.b	#0,(a6)

IPX_loc_874:
	add.w	d0,d0
	move.w	IPX_off_87E(pc,d0.w),d0
	jmp	IPX_off_87E(pc,d0.w)
; -----------------------------------------------------------------------------

IPX_off_87E:	offsetTable
		offsetTableEntry.w IPX_loc_938
		offsetTableEntry.w IPX_loc_88A
		offsetTableEntry.w IPX_loc_920
		offsetTableEntry.w IPX_loc_8BC
		offsetTableEntry.w IPX_loc_92C
		offsetTableEntry.w IPX_loc_8EE
; -----------------------------------------------------------------------------

IPX_loc_88A:
	move.b	#0,(IPX_unk_151C).l
	move.w	#palmtree_panic_zone_act_1,(IPX_CurrentZoneAndAct).l
	move.b	#present,(IPX_CurrentTimeZone).l
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l

	move.w	#$84,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	#0,(IPX_unk_1580).l
	rts
; -----------------------------------------------------------------------------

IPX_loc_8BC:
	move.b	#0,(IPX_unk_151C).l
	move.w	#tidal_tempest_zone_act_3,(IPX_CurrentZoneAndAct).l
	move.b	#future,(IPX_CurrentTimeZone).l
	move.b	#good_future,(IPX_GoodFuture_ActFlag).l

	move.w	#$24,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	#0,(IPX_unk_1580).l
	rts
; -----------------------------------------------------------------------------

IPX_loc_8EE:
	move.b	#0,(IPX_unk_151C).l
	move.w	#metallic_madness_zone_act_2,(IPX_CurrentZoneAndAct).l
	move.b	#present,(IPX_CurrentTimeZone).l
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l

	move.w	#$25,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	#0,(IPX_unk_1580).l
	rts
; -----------------------------------------------------------------------------

IPX_loc_920:
	move.w	#$8A,d0
	bsr.w	IPX_loc_CE0
	bra.w	IPX_SS1_Start
; -----------------------------------------------------------------------------

IPX_loc_92C:
	move.w	#$8A,d0
	bsr.w	IPX_loc_CE0
	bra.w	IPX_SS6_Start
; -----------------------------------------------------------------------------

IPX_loc_938:
	move.w	#$D7,d0
	bsr.w	IPX_LoadAndRunFile
	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_938
	rts
; -----------------------------------------------------------------------------
;IPX_loc_94A:
IPX_SoundTest:
	moveq	#$26,d0
	bsr.w	IPX_LoadAndRunFile

	add.w	d0,d0
	move.w	IPX_off_95A(pc,d0.w),d0
	jmp	IPX_off_95A(pc,d0.w)
; -----------------------------------------------------------------------------

IPX_off_95A:	offsetTable
		offsetTableEntry.w IPX_loc_968
		offsetTableEntry.w IPX_loc_96A
		offsetTableEntry.w IPX_loc_9A2
		offsetTableEntry.w IPX_loc_9AA
		offsetTableEntry.w IPX_loc_9B2
		offsetTableEntry.w IPX_loc_9BA
		offsetTableEntry.w IPX_loc_9C2
; -----------------------------------------------------------------------------

IPX_loc_968:
	rts
; -----------------------------------------------------------------------------

IPX_loc_96A:
	move.b	#7,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#0,(IO_SpecialStage_Flags).l
	bset	#2,(IO_SpecialStage_Flags).l

	moveq	#$75,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_unk_0F25).l
	bne.s	IPX_loc_9A0

	move.w	#$C9,d0
	bsr.w	IPX_LoadAndRunFile

IPX_loc_9A0:
	rts
; -----------------------------------------------------------------------------

IPX_loc_9A2:
	move.w	#$C8,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------

IPX_loc_9AA:
	move.w	#$CA,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------

IPX_loc_9B2:
	move.w	#$CB,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------

IPX_loc_9BA:
	move.w	#$CC,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------

IPX_loc_9C2:
	move.w	#$CD,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_9CA:
IPX_VisualMode:
	move.w	#$85,d0
	bsr.w	IPX_LoadAndRunFile

	add.w	d0,d0
	move.w	IPX_off_9DC(pc,d0.w),d0
	jmp	IPX_off_9DC(pc,d0.w)
; -----------------------------------------------------------------------------

IPX_off_9DC:	offsetTable
		offsetTableEntry.w IPX_loc_9F8
		offsetTableEntry.w IPX_loc_9E6
		offsetTableEntry.w IPX_loc_A0C
		offsetTableEntry.w IPX_loc_A2E
		offsetTableEntry.w IPX_loc_9FA
; -----------------------------------------------------------------------------

IPX_loc_9E6:
	move.w	#$D7,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_9E6
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------

IPX_loc_9F8:
	rts
; -----------------------------------------------------------------------------

IPX_loc_9FA:
	move.w	#$D4,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_9FA
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------

IPX_loc_A0C:
	move.b	#$7F,(IPX_unk_0F24).l
	move.w	#$94,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_A0C

	move.w	#$8D,d0
	bsr.w	IPX_LoadAndRunFile
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------

IPX_loc_A2E:
	move.b	#0,(IPX_unk_0F24).l
	move.w	#$93,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_A2E
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------
;IPX_loc_A48:
IPX_DAGarden:
	move.w	#$81,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_A50:
IPX_TimeAttack:
	moveq	#$D,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	d0,(IPX_unk_0F14).l
	beq.w	IPX_loc_AB2

	move.b	IPX_byte_AB4(pc,d0.w),d0
	bmi.s	IPX_loc_AD2

	mulu.w	#6,d0
	lea	IPX_byte_68A(pc),a6
	move.w	2(a6,d0.w),(IPX_CurrentZoneAndAct).l
	move.b	4(a6,d0.w),(IPX_CurrentTimeZone).l
	move.b	5(a6,d0.w),(IPX_GoodFuture_ActFlag).l
	move.w	(a6,d0.w),d0

	move.b	#1,(IPX_unk_0F01).l
	move.b	#0,(IPX_unk_156D).l
	bsr.w	IPX_LoadAndRunFile

	move.b	#0,(IPX_unk_158E).l
	move.l	(IPX_unk_1514).l,(IPX_unk_0F10).l
	bra.s	IPX_TimeAttack
; -----------------------------------------------------------------------------

IPX_loc_AB2:
	rts
; -----------------------------------------------------------------------------

IPX_byte_AB4:
	dc.b	  0,   0,   4, $16,  $B,  $F, $14, $17
	dc.b	$1B, $20, $21, $25, $2A, $2B, $2F, $34
	dc.b	$35, $39, $3E, $3F, $43, $48, $FF, $FE
	dc.b	$FD, $FC, $FB, $FA, $F9, $00
; -----------------------------------------------------------------------------

IPX_loc_AD2:
	neg.b	d0
	ext.w	d0
	subq.w	#1,d0
	move.b	d0,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#1,(IO_SpecialStage_Flags).l

	moveq	#$75,d0
	bsr.w	IPX_LoadAndRunFile
	bra.w	IPX_TimeAttack
; -----------------------------------------------------------------------------
;IPX_loc_AF8:
IPX_LoadAndRunFile:
	move.l	a0,-(sp)
	move.w	d0,(IO_unk_A12010).l

	; Erases $36C0 bytes starting at $2000.
	; $2000 -> $56C0
	lea	(IPX_unk_2000).l,a1
	moveq	#0,d0
	move.w	#$0DB0-1,d7
.loop1	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	dbf	d7,.loop1
	bsr.w	IPX_loc_D10

	move.l	(MMD_unk_200008).l,d0
	beq.w	IPX_loc_BDE
	movea.l	d0,a0

	move.l	(MMD_unk_200002).l,d0
	beq.s	IPX_loc_B44
	movea.l	d0,a2

	lea	(MMD_unk_200100).l,a1
	move.w	(MMD_unk_200006).l,d7
.loop2	move.l	(a1)+,(a2)+
	dbf	d7,.loop2

IPX_loc_B44:
	move.w	sr,-(sp)
	move.l	(MMD_unk_20000C).l,d0
	beq.s	IPX_loc_B52
	move.l	d0,(H_Int_addr).w

IPX_loc_B52:
	move.l	(MMD_unk_200010).l,d0
	beq.s	IPX_loc_B5E
	move.l	d0,(V_Int_addr).w

IPX_loc_B5E:
	btst	#6,(MMD_unk_200000).l
	beq.s	IPX_loc_B6C
	bsr.w	IPX_loc_D1C

IPX_loc_B6C:
	move.w	(sp)+,sr

IPX_loc_B6E:
	move.w	(IO_unk_A12020).l,d0
	beq.s	IPX_loc_B6E
	cmp.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_B6E

	move.w	#0,(IO_unk_A12010).l

IPX_loc_B86:
	move.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_B86
	move.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_B86

	jsr	(a0)

	move.b	d0,(IPX_static_unk_0BE3).l
	bsr.w	IPX_loc_D30

	move.b	#$E0,(IO_unk_A01C0A).l
	bsr.w	IPX_loc_D4E

	move.b	#0,(IPX_unk_0F00).l
	move.l	#IPX_int_C06-IPX_Start+IPX_RAM_Start,(H_Int_addr).w
	move.l	#IPX_int_BE4-IPX_Start+IPX_RAM_Start,(V_Int_addr).w
	move.w	#$8134,(IPX_unk_0F16).l
	bset	#0,(IPX_unk_0BE2).l
	bsr.w	IPX_loc_D5E
	bsr.w	IPX_loc_D1C

IPX_loc_BDE:
	movea.l	(sp)+,a0
	rts
; -----------------------------------------------------------------------------
; RAM variables inside executed code
IPX_RAM_0BE2:	dc.b	0
IPX_RAM_0BE3:	dc.b	0
; -----------------------------------------------------------------------------

IPX_int_BE4:
	bset	#0,(IO_unk_A12000).l
	bclr	#0,(IPX_unk_0F00).l
	bclr	#0,(IPX_unk_0BE2).l
	beq.s	IPX_int_C06
	move.w	#$8134,(VDP_control_port).l

IPX_int_C06:
	rte
; -----------------------------------------------------------------------------
;IPX_loc_C08:
IPX_LoadSavedData:
	bsr.w	IPX_loc_C58

	move.w	(MMD_unk_2002A4).l,(IPX_CurrentZoneInSave).l
	move.b	(MMD_unk_2002A7).l,(IPX_GoodFuture_Array).l
	move.b	(MMD_unk_2002A8).l,(IPX_unk_0F1D).l
	move.b	(MMD_unk_2002A5).l,(IPX_unk_0F18).l
	move.b	(MMD_unk_2002A6).l,(IPX_unk_0F19).l
	move.b	(MMD_unk_2002AC).l,(IPX_unk_0F21).l
	move.b	(MMD_unk_2002AD).l,(IPX_TimeStones_Array).l
	bsr.w	IPX_loc_D1C
	rts
; -----------------------------------------------------------------------------

IPX_loc_C58:
	bsr.w	IPX_loc_D1C

	move.w	#$8B,d0
	btst	#0,(IPX_unk_0F1F).l
	bne.s	IPX_loc_C6E
	move.w	#$87,d0

IPX_loc_C6E:
	bsr.w	IPX_loc_CE0
	bra.w	IPX_loc_D10
; -----------------------------------------------------------------------------
;IPX_loc_C76:
IPX_SaveData:
	bsr.s	IPX_loc_C58

	move.w	(IPX_CurrentZoneInSave).l,(MMD_unk_2002A4).l
	move.b	(IPX_GoodFuture_Array).l,(MMD_unk_2002A7).l
	move.b	(IPX_unk_0F1D).l,(MMD_unk_2002A8).l
	move.b	(IPX_unk_0F18).l,(MMD_unk_2002A5).l
	move.b	(IPX_unk_0F19).l,(MMD_unk_2002A6).l
	move.b	(IPX_unk_0F21).l,(MMD_unk_2002AC).l
	move.b	(IPX_TimeStones_Array).l,(MMD_unk_2002AD).l
	bsr.w	IPX_loc_D1C

	move.w	#$8C,d0
	btst	#0,(IPX_unk_0F1F).l
	bne.s	IPX_loc_CD4
	move.w	#$88,d0

IPX_loc_CD4:
	bsr.w	IPX_loc_CE0
	bsr.w	IPX_loc_D10
	bra.w	IPX_loc_D1C
; -----------------------------------------------------------------------------

IPX_loc_CE0:
	move.w	d0,(IO_unk_A12010).l

IPX_loc_CE6:
	move.w	(IO_unk_A12020).l,d0
	beq.s	IPX_loc_CE6
	cmp.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_CE6

	move.w	#0,(IO_unk_A12010).l

IPX_loc_CFE:
	move.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_CFE
	move.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_CFE
	rts
; -----------------------------------------------------------------------------

IPX_loc_D10:
	btst	#0,(IO_unk_A12003).l
	beq.s	IPX_loc_D10
	rts
; -----------------------------------------------------------------------------

IPX_loc_D1C:
	bset	#1,(IO_unk_A12003).l
	btst	#1,(IO_unk_A12003).l
	beq.s	IPX_loc_D1C
	rts
; -----------------------------------------------------------------------------

IPX_loc_D30:
	move.w	sr,(IPX_unk_0DA6).l
	move.w	#$2700,sr
	move.w	#$0100,(IO_unk_A11100).l

IPX_loc_D42:
	btst	#0,(IO_unk_A11100).l
	bne.s	IPX_loc_D42
	rts
; -----------------------------------------------------------------------------

IPX_loc_D4E:
	move.w	#0,(IO_unk_A11100).l
	move.w	(IPX_unk_0DA6).l,sr
	rts
; -----------------------------------------------------------------------------

IPX_loc_D5E:
	bset	#0,(IPX_unk_0F00).l
	move.w	#$2500,sr

IPX_loc_D6A:
	btst	#0,(IPX_unk_0F00).l
	bne.s	IPX_loc_D6A
	rts
; -----------------------------------------------------------------------------
; Dead code?
;IPX_loc_D76:
	move.w	d0,(IO_unk_A12010).l

IPX_loc_D7C:
	move.w	(IO_unk_A12020).l,d0
	beq.s	IPX_loc_D7C
	cmp.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_D7C

	move.w	#0,(IO_unk_A12010).l

IPX_loc_D94:
	move.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_D94
	move.w	(IO_unk_A12020).l,d0
	bne.s	IPX_loc_D94
	rts
; -----------------------------------------------------------------------------
; RAM variable inside executed code
IPX_RAM_0DA6:	dc.w	0
; -----------------------------------------------------------------------------
; Dead code?
;IPX_loc_DA8:
	jmp	(0).w

; ===========================================================================
; end of IPX___.MMD file
IPX_End:
	if IPX_End-IPX_Start > $F00	; Maximum code size allowed for this file.
		fatal "IPX___.MMD maximum code size reached! (> $F00)"
	endif
