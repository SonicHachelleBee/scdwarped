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
	move.l	#IPX_V_Int-IPX_Start+IPX_RAM_Start,(V_Int_addr).w
	bsr.w	IPX_loc_D1C

	; Erases $1100 bytes starting at $FFFF0F00.
	; $FFFF0F00 -> $FFFF2000
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
	move.b	d0,(IPX_SpecialStageFlag).l
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
	bset	#0,(IO_SpecialStageLockouts).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------
;IPX_loc_DE:
IPX_SS6_Start:
	move.b	#5,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#0,(IO_SpecialStageLockouts).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------
;IPX_loc_FE:
IPX_Continue:
	bsr.w	IPX_LoadSavedData
	move.w	(IPX_CurrentZoneInSave).l,(IPX_CurrentZoneAndAct).l
	move.b	#3,(IPX_LifeCount).l
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
	move.b	d0,(IPX_NextSpecialStage).l
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
	tst.b	(IPX_static_LoopVideoFlag).l
	bmi.s	IPX_BadEnding
	rts
; -----------------------------------------------------------------------------
;IPX_loc_384:
IPX_GoodEnding:
	move.b	#$7F,(IPX_unk_0F24).l
	move.w	#good_ending_file,d0
	bsr.w	IPX_LoadAndRunFile
	tst.b	(IPX_static_LoopVideoFlag).l
	bmi.s	IPX_GoodEnding
	rts
; -----------------------------------------------------------------------------
; Cleanup some variables on Game Over before returning to the title screen.
;IPX_loc_39E:
IPX_CleanupOnGameOver:
	move.b	#0,(IPX_CurrentAct).l
	move.w	(IPX_CurrentZoneAndAct).l,(IPX_CurrentZoneInSave).l

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	; Set the flag to bad future
	bclr	#0,(IPX_GoodFuture_ActFlag).l
	rts
; -----------------------------------------------------------------------------
; RAM variables in between executed code. Looks like some static variables...
; They shall stay at their exact address because they are referenced by other files which
; are not disassembled yet!
	if * > $13FDCCA
		fatal "IPX___.MMD RAM variables at $03CA-$03CB are erased! $\{*} > $13FDCCA"
	endif
	org	$13FDCCA

IPX_RAM_03CA:	dc.b	0 ; IPX_static_GoodFuture_Array
IPX_RAM_03CB:	dc.b	0 ; IPX_static_TimeStones_Array
; -----------------------------------------------------------------------------
;IPX_loc_3CC:
IPX_LoadAndRun_R11:
	lea	IPX_FilesList_R1(pc),a0
	move.w	#palmtree_panic_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_3DC:
IPX_LoadAndRun_R12:
	lea	IPX_FilesList_R1+4(pc),a0
	move.w	#palmtree_panic_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_3EC:
IPX_LoadAndRun_R13:
	lea	IPX_FilesList_R1+8(pc),a0
	move.w	#palmtree_panic_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_3
; -----------------------------------------------------------------------------
;IPX_loc_3FC:
IPX_LoadAndRun_R31:
	lea	IPX_FilesList_R3(pc),a0
	move.w	#collision_chaos_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_40C:
IPX_LoadAndRun_R32:
	lea	IPX_FilesList_R3+4(pc),a0
	move.w	#collision_chaos_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_41C:
IPX_LoadAndRun_R33:
	lea	IPX_FilesList_R3+8(pc),a0
	move.w	#collision_chaos_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_3
; -----------------------------------------------------------------------------
;IPX_loc_42C:
IPX_LoadAndRun_R41:
	lea	IPX_FilesList_R4(pc),a0
	move.w	#tidal_tempest_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_43C:
IPX_LoadAndRun_R42:
	lea	IPX_FilesList_R4+4(pc),a0
	move.w	#tidal_tempest_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_44C:
IPX_LoadAndRun_R43:
	lea	IPX_FilesList_R4+8(pc),a0
	move.w	#tidal_tempest_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_3
; -----------------------------------------------------------------------------
;IPX_loc_45C:
IPX_LoadAndRun_R51:
	lea	IPX_FilesList_R5(pc),a0
	move.w	#quartz_quadrant_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_46C:
IPX_LoadAndRun_R52:
	lea	IPX_FilesList_R5+4(pc),a0
	move.w	#quartz_quadrant_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_47C:
IPX_LoadAndRun_R53:
	lea	IPX_FilesList_R5+8(pc),a0
	move.w	#quartz_quadrant_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_3
; -----------------------------------------------------------------------------
;IPX_loc_48C:
IPX_LoadAndRun_R61:
	lea	IPX_FilesList_R6(pc),a0
	move.w	#wacky_workbench_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_49A:
IPX_LoadAndRun_R62:
	lea	IPX_FilesList_R6+4(pc),a0
	move.w	#wacky_workbench_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_4A8:
IPX_LoadAndRun_R63:
	lea	IPX_FilesList_R6+8(pc),a0
	move.w	#wacky_workbench_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_3
; -----------------------------------------------------------------------------
;IPX_loc_4B8:
IPX_LoadAndRun_R71:
	lea	IPX_FilesList_R7(pc),a0
	move.w	#stardust_speedway_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_4C6:
IPX_LoadAndRun_R72:
	lea	IPX_FilesList_R7+4(pc),a0
	move.w	#stardust_speedway_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_4D4:
IPX_LoadAndRun_R73:
	lea	IPX_FilesList_R7+8(pc),a0
	move.w	#stardust_speedway_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_3
; -----------------------------------------------------------------------------
;IPX_loc_4E4:
IPX_LoadAndRun_R81:
	lea	IPX_FilesList_R8(pc),a0
	move.w	#metallic_madness_zone_act_1,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_4F2:
IPX_LoadAndRun_R82:
	lea	IPX_FilesList_R8+4(pc),a0
	move.w	#metallic_madness_zone_act_2,(IPX_CurrentZoneAndAct).l
	bra.s	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_500:
IPX_LoadAndRun_R83:
	lea	IPX_FilesList_R8+8(pc),a0
	move.w	#metallic_madness_zone_act_3,(IPX_CurrentZoneAndAct).l
	bra.w	IPX_RunAct_3
; -----------------------------------------------------------------------------
;IPX_loc_510:
IPX_RunAct_1_2:
	; Load the present time zone as default at the beginning.
	moveq	#0,d0
	_move.b	0(a0),d0

;IPX_loc_516:
IPX_RunAct_WarpLoop:
	; Load and run the current level in the specified time zone.
	bsr.w	IPX_LoadAndRunFile

	; The current level was unloaded.
	; Is it because the lives counter reached 0?
	tst.b	(IPX_LifeCount).l
	beq.s	IPX_EndOfAct_1_2
	; Is it because we reached the end of the act?
	; Note that setting bit 7 of IPX_CurrentTimeZone looks like a dirty workaround...
	btst	#7,(IPX_CurrentTimeZone).l
	beq.s	IPX_EndOfAct_1_2

	; If none of the above applies, this is because we are warping to another time zone.
	; The warp cutscene is nothing more than a fancy animation and a way to lose your time.
	; It is perfectly safe to remove it: this makes the warp to another time zone
	; almost instantaneous (besides loading the proper time zone).
    if removeWarpCutscene=0
	moveq	#warp_file,d0
	bsr.w	IPX_LoadAndRunFile
    endif

	; Load the proper time zone and loop to run the level.
	move.b	(IPX_CurrentTimeZone).l,d1

	; Load past time zone?
	moveq	#0,d0
	move.b	1(a0),d0
	andi.b	#$7F,d1
	beq.s	IPX_RunAct_WarpLoop

	; Load present time zone?
	_move.b	0(a0),d0
	subq.b	#1,d1
	beq.s	IPX_RunAct_WarpLoop

	; Load bad future time zone?
	move.b	3(a0),d0
	tst.b	(IPX_GoodFuture_ActFlag).l
	beq.s	IPX_RunAct_WarpLoop

	; Else, load good future time zone.
	move.b	2(a0),d0
	bra.s	IPX_RunAct_WarpLoop
; -----------------------------------------------------------------------------
;IPX_loc_55E:
IPX_EndOfAct_1_2:
	; Is the lives counter reached 0?
	tst.b	(IPX_LifeCount).l
	bne.s	IPX_CheckSpecialStage

	; Game over
	move.l	(sp)+,d0
	bra.w	IPX_CleanupOnGameOver
; -----------------------------------------------------------------------------
;IPX_loc_56C:
IPX_CheckSpecialStage:
	; Is the Special Stage entered?
	tst.b	(IPX_SpecialStageFlag).l
	bne.s	IPX_RunSpecialStage

	; End of act.
	; Return and continue with the next act.
	rts
; -----------------------------------------------------------------------------
;IPX_loc_576:
IPX_RunSpecialStage:
	move.b	(IPX_NextSpecialStage).l,(IO_SpecialStageToLoad).l
	move.b	(IPX_TimeStones_Array).l,(IO_TimeStones_Array).l
	bclr	#0,(IO_SpecialStageLockouts).l

	; Load and run the Special Stage
	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile

	move.b	#1,(IPX_unk_0F22).l

	; Are all time stones collected?
	cmpi.b	#$7F,(IPX_TimeStones_Array).l
	bne.s	.skip
	; If all time stones are collected, set a good future immediately.
	move.b	#good_future,(IPX_GoodFuture_ActFlag).l
.skip:	rts
; -----------------------------------------------------------------------------
;IPX_loc_5B4:
IPX_RunAct_3:
	; Load the good future time zone as default at the beginning.
	moveq	#0,d0
	_move.b	0(a0),d0

	; Let's explain what is going on here.
	; At the end of act 1, IPX_GoodFuture_ActFlag is copied into IPX_GoodFuture_ZoneFlags.
	; After that, the flag is erased, and act 2 begins.
	; At the end of act 2, IPX_GoodFuture_ActFlag is also copied into IPX_GoodFuture_ZoneFlags.
	; However this time, the flag is not erased. The flag is consolidated with both values
	; from act 1 and act 2 stored in IPX_GoodFuture_ZoneFlags. Then, act 3 begins.
	tst.b	(IPX_GoodFuture_ActFlag).l
	bne.s	.skip
	; Load the bad future time zone
	move.b	1(a0),d0

	; Load and run the current level in the specified time zone.
.skip:	bsr.w	IPX_LoadAndRunFile

	; The current level was unloaded.
	; Is it because the lives counter reached 0?
	tst.b	(IPX_LifeCount).l
	bne.s	IPX_EndOfAct_3

	; Game over
	move.l	(sp)+,d0
	bra.w	IPX_CleanupOnGameOver
; -----------------------------------------------------------------------------
;IPX_loc_5D8:
IPX_EndOfAct_3:
	; Add one zone completed in the saved data
	addq.b	#1,(IPX_CurrentZoneInSave).l

	; Ensure we are not over the 7th and last zone
	cmpi.b	#7,(IPX_CurrentZoneInSave).l
	bcs.s	.skip
	subq.b	#1,(IPX_CurrentZoneInSave).l

	; End of act.
	; Return and continue with the next zone and act (or end of game).
.skip:	move.b	#0,(IPX_unk_158E).l
	rts
; -----------------------------------------------------------------------------
; I don't quite understand what is going on here.
; It seems to be linked with the number of acts you have completed.
IPX_loc_5F8:
	cmp.b	(IPX_unk_0F18).l,d0
	bls.s	.ret
	move.b	d0,(IPX_unk_0F18).l
.ret:	rts
; -----------------------------------------------------------------------------
;IPX_byte_608:
IPX_FilesList_R1:
	dc.b	R11A_file, R11B_file, R11C_file, R11D_file ; Act 1
	dc.b	R12A_file, R12B_file, R12C_file, R12D_file ; Act 2
	dc.b	R13C_file, R13D_file                       ; Act 3
;IPX_byte_612:
IPX_FilesList_R3:
	dc.b	R31A_file, R31B_file, R31C_file, R31D_file ; Act 1
	dc.b	R32A_file, R32B_file, R32C_file, R32D_file ; Act 2
	dc.b	R33C_file, R33D_file                       ; Act 3
;IPX_byte_61C:
IPX_FilesList_R4:
	dc.b	R41A_file, R41B_file, R41C_file, R41D_file ; Act 1
	dc.b	R42A_file, R42B_file, R42C_file, R42D_file ; Act 2
	dc.b	R43C_file, R43D_file                       ; Act 3
;IPX_byte_626:
IPX_FilesList_R5:
	dc.b	R51A_file, R51B_file, R51C_file, R51D_file ; Act 1
	dc.b	R52A_file, R52B_file, R52C_file, R52D_file ; Act 2
	dc.b	R53C_file, R53D_file                       ; Act 3
;IPX_byte_630:
IPX_FilesList_R6:
	dc.b	R61A_file, R61B_file, R61C_file, R61D_file ; Act 1
	dc.b	R62A_file, R62B_file, R62C_file, R62D_file ; Act 2
	dc.b	R63C_file, R63D_file                       ; Act 3
;IPX_byte_63A:
IPX_FilesList_R7:
	dc.b	R71A_file, R71B_file, R71C_file, R71D_file ; Act 1
	dc.b	R72A_file, R72B_file, R72C_file, R72D_file ; Act 2
	dc.b	R73C_file, R73D_file                       ; Act 3
;IPX_byte_644:
IPX_FilesList_R8:
	dc.b	R81A_file, R81B_file, R81C_file, R81D_file ; Act 1
	dc.b	R82A_file, R82B_file, R82C_file, R82D_file ; Act 2
	dc.b	R83C_file, R83D_file                       ; Act 3
; -----------------------------------------------------------------------------
;IPX_loc_64E:
IPX_LevelSelect:
	moveq	#level_select_file,d0
	bsr.w	IPX_LoadAndRunFile

	; Load and run the selected level
	mulu.w	#6,d0
	move.w	IPX_LevelSelect_List+2(pc,d0.w),(IPX_CurrentZoneAndAct).l
	move.b	IPX_LevelSelect_List+4(pc,d0.w),(IPX_CurrentTimeZone).l
	move.b	IPX_LevelSelect_List+5(pc,d0.w),(IPX_GoodFuture_ActFlag).l
	move.w	IPX_LevelSelect_List(pc,d0.w),d0
	move.b	#0,(IPX_unk_156D).l

	cmpi.w	#special_stage_file,d0
	beq.w	IPX_SS1_Start
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------
; Macro defining a level select entry
ipx_lvlentry_macro	macro	file,zone_and_act,time_zone,good_future_flag
	dc.w	file
	dc.w	zone_and_act
	dc.b	time_zone
	dc.b	good_future_flag
	endm

;IPX_byte_68A:
IPX_LevelSelect_List:
	ipx_lvlentry_macro	  R11A_file,    palmtree_panic_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R11B_file,    palmtree_panic_zone_act_1,    past,  bad_future
	ipx_lvlentry_macro	  R11C_file,    palmtree_panic_zone_act_1,  future, good_future
	ipx_lvlentry_macro	  R11D_file,    palmtree_panic_zone_act_1,  future,  bad_future
	ipx_lvlentry_macro	  R12A_file,    palmtree_panic_zone_act_2, present,  bad_future
	ipx_lvlentry_macro	  R12B_file,    palmtree_panic_zone_act_2,    past,  bad_future
	ipx_lvlentry_macro	  R12C_file,    palmtree_panic_zone_act_2,  future, good_future
	ipx_lvlentry_macro	  R12D_file,    palmtree_panic_zone_act_2,  future,  bad_future
	ipx_lvlentry_macro	  warp_file,                            0,       0,           0
	ipx_lvlentry_macro	intro_video_file,                       0,       0,           0
	ipx_lvlentry_macro	comin_soon_file,                        0,       0,           0
	ipx_lvlentry_macro	  R31A_file,   collision_chaos_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R31B_file,   collision_chaos_zone_act_1,    past,  bad_future
	ipx_lvlentry_macro	  R31C_file,   collision_chaos_zone_act_1,  future, good_future
	ipx_lvlentry_macro	  R31D_file,   collision_chaos_zone_act_1,  future,  bad_future
	ipx_lvlentry_macro	  R32A_file,   collision_chaos_zone_act_2, present,  bad_future
	ipx_lvlentry_macro	  R32B_file,   collision_chaos_zone_act_2,    past,  bad_future
	ipx_lvlentry_macro	  R32C_file,   collision_chaos_zone_act_2,  future, good_future
	ipx_lvlentry_macro	  R32D_file,   collision_chaos_zone_act_2,  future,  bad_future
	ipx_lvlentry_macro	  R33C_file,   collision_chaos_zone_act_3,  future, good_future
	ipx_lvlentry_macro	  R33D_file,   collision_chaos_zone_act_3,  future,  bad_future
	ipx_lvlentry_macro	  R13C_file,    palmtree_panic_zone_act_3,  future, good_future
	ipx_lvlentry_macro	  R13D_file,    palmtree_panic_zone_act_3,  future,  bad_future
	ipx_lvlentry_macro	  R41A_file,     tidal_tempest_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R41B_file,     tidal_tempest_zone_act_1,    past,  bad_future
	ipx_lvlentry_macro	  R41C_file,     tidal_tempest_zone_act_1,  future, good_future
	ipx_lvlentry_macro	  R41D_file,     tidal_tempest_zone_act_1,  future,  bad_future
	ipx_lvlentry_macro	  R42A_file,     tidal_tempest_zone_act_2, present,  bad_future
	ipx_lvlentry_macro	  R42B_file,     tidal_tempest_zone_act_2,    past,  bad_future
	ipx_lvlentry_macro	  R42C_file,     tidal_tempest_zone_act_2,  future, good_future
	ipx_lvlentry_macro	  R42D_file,     tidal_tempest_zone_act_2,  future,  bad_future
	ipx_lvlentry_macro	  R43C_file,     tidal_tempest_zone_act_3,  future, good_future
	ipx_lvlentry_macro	  R43D_file,     tidal_tempest_zone_act_3,  future,  bad_future
	ipx_lvlentry_macro	  R51A_file,   quartz_quadrant_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R51B_file,   quartz_quadrant_zone_act_1,    past,  bad_future
	ipx_lvlentry_macro	  R51C_file,   quartz_quadrant_zone_act_1,  future, good_future
	ipx_lvlentry_macro	  R51D_file,   quartz_quadrant_zone_act_1,  future,  bad_future
	ipx_lvlentry_macro	  R52A_file,   quartz_quadrant_zone_act_2, present,  bad_future
	ipx_lvlentry_macro	  R52B_file,   quartz_quadrant_zone_act_2,    past,  bad_future
	ipx_lvlentry_macro	  R52C_file,   quartz_quadrant_zone_act_2,  future, good_future
	ipx_lvlentry_macro	  R52D_file,   quartz_quadrant_zone_act_2,  future,  bad_future
	ipx_lvlentry_macro	  R53C_file,   quartz_quadrant_zone_act_3,  future, good_future
	ipx_lvlentry_macro	  R53D_file,   quartz_quadrant_zone_act_3,  future,  bad_future
	ipx_lvlentry_macro	  R61A_file,   wacky_workbench_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R61B_file,   wacky_workbench_zone_act_1,    past,  bad_future
	ipx_lvlentry_macro	  R61C_file,   wacky_workbench_zone_act_1,  future, good_future
	ipx_lvlentry_macro	  R61D_file,   wacky_workbench_zone_act_1,  future,  bad_future
	ipx_lvlentry_macro	  R62A_file,   wacky_workbench_zone_act_2, present,  bad_future
	ipx_lvlentry_macro	  R62B_file,   wacky_workbench_zone_act_2,    past,  bad_future
	ipx_lvlentry_macro	  R62C_file,   wacky_workbench_zone_act_2,  future, good_future
	ipx_lvlentry_macro	  R62D_file,   wacky_workbench_zone_act_2,  future,  bad_future
	ipx_lvlentry_macro	  R63C_file,   wacky_workbench_zone_act_3,  future, good_future
	ipx_lvlentry_macro	  R63D_file,   wacky_workbench_zone_act_3,  future,  bad_future
	ipx_lvlentry_macro	  R71A_file, stardust_speedway_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R71B_file, stardust_speedway_zone_act_1,    past,  bad_future
	ipx_lvlentry_macro	  R71C_file, stardust_speedway_zone_act_1,  future, good_future
	ipx_lvlentry_macro	  R71D_file, stardust_speedway_zone_act_1,  future,  bad_future
	ipx_lvlentry_macro	  R72A_file, stardust_speedway_zone_act_2, present,  bad_future
	ipx_lvlentry_macro	  R72B_file, stardust_speedway_zone_act_2,    past,  bad_future
	ipx_lvlentry_macro	  R72C_file, stardust_speedway_zone_act_2,  future, good_future
	ipx_lvlentry_macro	  R72D_file, stardust_speedway_zone_act_2,  future,  bad_future
	ipx_lvlentry_macro	  R73C_file, stardust_speedway_zone_act_3,  future, good_future
	ipx_lvlentry_macro	  R73D_file, stardust_speedway_zone_act_3,  future,  bad_future
	ipx_lvlentry_macro	  R81A_file,  metallic_madness_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R81B_file,  metallic_madness_zone_act_1,    past,  bad_future
	ipx_lvlentry_macro	  R81C_file,  metallic_madness_zone_act_1,  future, good_future
	ipx_lvlentry_macro	  R81D_file,  metallic_madness_zone_act_1,  future,  bad_future
	ipx_lvlentry_macro	  R82A_file,  metallic_madness_zone_act_2, present,  bad_future
	ipx_lvlentry_macro	  R82B_file,  metallic_madness_zone_act_2,    past,  bad_future
	ipx_lvlentry_macro	  R82C_file,  metallic_madness_zone_act_2,  future, good_future
	ipx_lvlentry_macro	  R82D_file,  metallic_madness_zone_act_2,  future,  bad_future
	ipx_lvlentry_macro	  R83C_file,  metallic_madness_zone_act_3,  future, good_future
	ipx_lvlentry_macro	  R83D_file,  metallic_madness_zone_act_3,  future,  bad_future
	ipx_lvlentry_macro	special_stage_file,                     0,       0,           0
	ipx_lvlentry_macro	  R11A_file,    palmtree_panic_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R11A_file,    palmtree_panic_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R11A_file,    palmtree_panic_zone_act_1, present,  bad_future
	ipx_lvlentry_macro	  R11A_file,    palmtree_panic_zone_act_1, present,  bad_future
; -----------------------------------------------------------------------------
;IPX_loc_85E:
IPX_StartDemo:
	moveq	#5,d1
	lea	(IPX_unk_0F1C).l,a6
	moveq	#0,d0
	move.b	(a6),d0
	addq.b	#1,(a6)
	cmp.b	(a6),d1
	bcc.s	.skip
	move.b	#0,(a6)
.skip:	add.w	d0,d0
	move.w	IPX_off_Demo(pc,d0.w),d0
	jmp	IPX_off_Demo(pc,d0.w)
; -----------------------------------------------------------------------------
;IPX_off_87E:
IPX_off_Demo:	offsetTable
		offsetTableEntry.w IPX_IntroVideo
		offsetTableEntry.w IPX_R1_Demo
		offsetTableEntry.w IPX_SS1_Demo
		offsetTableEntry.w IPX_R4_Demo
		offsetTableEntry.w IPX_SS6_Demo
		offsetTableEntry.w IPX_R8_Demo
; -----------------------------------------------------------------------------
;IPX_loc_88A:
IPX_R1_Demo:
	move.b	#0,(IPX_unk_151C).l
	move.w	#palmtree_panic_zone_act_1,(IPX_CurrentZoneAndAct).l
	move.b	#present,(IPX_CurrentTimeZone).l
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l

	move.w	#R1_demo_file,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	#0,(IPX_unk_1580).l
	rts
; -----------------------------------------------------------------------------
;IPX_loc_8BC:
IPX_R4_Demo:
	move.b	#0,(IPX_unk_151C).l
	move.w	#tidal_tempest_zone_act_3,(IPX_CurrentZoneAndAct).l
	move.b	#future,(IPX_CurrentTimeZone).l
	move.b	#good_future,(IPX_GoodFuture_ActFlag).l

	move.w	#R4_demo_file,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	#0,(IPX_unk_1580).l
	rts
; -----------------------------------------------------------------------------
;IPX_loc_8EE:
IPX_R8_Demo:
	move.b	#0,(IPX_unk_151C).l
	move.w	#metallic_madness_zone_act_2,(IPX_CurrentZoneAndAct).l
	move.b	#present,(IPX_CurrentTimeZone).l
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l

	move.w	#R8_demo_file,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	#0,(IPX_unk_1580).l
	rts
; -----------------------------------------------------------------------------
;IPX_loc_920:
IPX_SS1_Demo:
	move.w	#unk_file_8A,d0
	bsr.w	IPX_loc_CE0
	bra.w	IPX_SS1_Start
; -----------------------------------------------------------------------------
;IPX_loc_92C:
IPX_SS6_Demo:
	move.w	#unk_file_8A,d0
	bsr.w	IPX_loc_CE0
	bra.w	IPX_SS6_Start
; -----------------------------------------------------------------------------
;IPX_loc_938:
IPX_IntroVideo:
	move.w	#intro_video_file,d0
	bsr.w	IPX_LoadAndRunFile
	tst.b	(IPX_static_LoopVideoFlag).l
	bmi.s	IPX_IntroVideo
	rts
; -----------------------------------------------------------------------------
;IPX_loc_94A:
IPX_SoundTest:
	moveq	#sound_test_file,d0
	bsr.w	IPX_LoadAndRunFile

	add.w	d0,d0
	move.w	IPX_off_Secrets(pc,d0.w),d0
	jmp	IPX_off_Secrets(pc,d0.w)
; -----------------------------------------------------------------------------
;IPX_off_95A:
IPX_off_Secrets:	offsetTable
			offsetTableEntry.w IPX_Secret_None
			offsetTableEntry.w IPX_Secret_SpecialStage
			offsetTableEntry.w IPX_Secret_1
			offsetTableEntry.w IPX_Secret_3
			offsetTableEntry.w IPX_Secret_4
			offsetTableEntry.w IPX_Secret_5
			offsetTableEntry.w IPX_Secret_6
; -----------------------------------------------------------------------------
;IPX_loc_968:
IPX_Secret_None:
	rts
; -----------------------------------------------------------------------------
;IPX_loc_96A:
IPX_Secret_SpecialStage:
	move.b	#7,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#0,(IO_SpecialStageLockouts).l
	bset	#2,(IO_SpecialStageLockouts).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_unk_0F25).l
	bne.s	.ret

	; Hidden credits displayed if you complete the Special Stage
	move.w	#secret2_file,d0
	bsr.w	IPX_LoadAndRunFile
.ret:	rts
; -----------------------------------------------------------------------------
;IPX_loc_9A2:
IPX_Secret_1:
	; Infinite fun
	move.w	#secret1_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_9AA:
IPX_Secret_3:
	; DJ scene
	move.w	#secret3_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_9B2:
IPX_Secret_4:
	; See you next game
	move.w	#secret4_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_9BA:
IPX_Secret_5:
	; Tribute to Batman
	move.w	#secret5_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_9C2:
IPX_Secret_6:
	; Chibi Sonic
	move.w	#secret6_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_9CA:
IPX_VisualMode:
	move.w	#visual_mode_file,d0
	bsr.w	IPX_LoadAndRunFile

	add.w	d0,d0
	move.w	IPX_off_Video(pc,d0.w),d0
	jmp	IPX_off_Video(pc,d0.w)
; -----------------------------------------------------------------------------
;IPX_off_9DC:
IPX_off_Video:	offsetTable
		offsetTableEntry.w IPX_Video_None
		offsetTableEntry.w IPX_Video_Intro
		offsetTableEntry.w IPX_Video_GoodEnding
		offsetTableEntry.w IPX_Video_BadEnding
		offsetTableEntry.w IPX_Video_PencilTest
; -----------------------------------------------------------------------------
;IPX_loc_9E6:
IPX_Video_Intro:
	move.w	#intro_video_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_LoopVideoFlag).l
	bmi.s	IPX_Video_Intro
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------
;IPX_loc_9F8:
IPX_Video_None:
	rts
; -----------------------------------------------------------------------------
;IPX_loc_9FA:
IPX_Video_PencilTest:
	move.w	#pencil_test_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_LoopVideoFlag).l
	bmi.s	IPX_Video_PencilTest
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------
;IPX_loc_A0C:
IPX_Video_GoodEnding:
	move.b	#$7F,(IPX_unk_0F24).l
	move.w	#good_ending_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_LoopVideoFlag).l
	bmi.s	IPX_Video_GoodEnding

	move.w	#player_name_file,d0
	bsr.w	IPX_LoadAndRunFile
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------
;IPX_loc_A2E:
IPX_Video_BadEnding:
	move.b	#0,(IPX_unk_0F24).l
	move.w	#bad_ending_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_LoopVideoFlag).l
	bmi.s	IPX_Video_BadEnding
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------
;IPX_loc_A48:
IPX_DAGarden:
	move.w	#d_a_garden_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
;IPX_loc_A50:
IPX_TimeAttack:
	moveq	#time_attack_file,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	d0,(IPX_unk_0F14).l
	beq.w	IPX_TimeAttack_Return

	move.b	IPX_TimeAttack_List(pc,d0.w),d0
	bmi.s	IPX_TimeAttack_SpecialStage

	mulu.w	#6,d0
	lea	IPX_LevelSelect_List(pc),a6
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
;IPX_loc_AB2:
IPX_TimeAttack_Return:
	rts
; -----------------------------------------------------------------------------
; Array of ID's relative to IPX_LevelSelect_List entries (except Special Stages)
;IPX_byte_AB4:
IPX_TimeAttack_List:
	dc.b	  0
	dc.b	  0,   4, $16 ; R1
	dc.b	 $B,  $F, $14 ; R3
	dc.b	$17, $1B, $20 ; R4
	dc.b	$21, $25, $2A ; R5
	dc.b	$2B, $2F, $34 ; R6
	dc.b	$35, $39, $3E ; R7
	dc.b	$3F, $43, $48 ; R8
	dc.b	$FF, $FE, $FD, $FC, $FB, $FA, $F9 ; Special Stages
	dc.b	  0
; -----------------------------------------------------------------------------
;IPX_loc_AD2:
IPX_TimeAttack_SpecialStage:
	neg.b	d0
	ext.w	d0
	subq.w	#1,d0
	move.b	d0,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#1,(IO_SpecialStageLockouts).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	bra.w	IPX_TimeAttack
; -----------------------------------------------------------------------------
; Load a file from the CD-ROM.
; Load the code into 68K RAM (at $FFFF2000), and run it.
;IPX_loc_AF8:
IPX_LoadAndRunFile:
	move.l	a0,-(sp)
	move.w	d0,(IO_unk_A12010).l

	; Erases $36C0 bytes starting at $FFFF2000.
	; $FFFF2000 -> $FFFF56C0
	lea	(IPX_unk_2000).l,a1
	moveq	#0,d0
	move.w	#$0DB0-1,d7
.loop1	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	move.l	d0,(a1)+
	dbf	d7,.loop1
	bsr.w	IPX_loc_D10

	move.l	(MMD_CodeStartAddr).l,d0
	beq.w	IPX_loc_BDE ; Jump if no code is associated to the file
	movea.l	d0,a0

	move.l	(MMD_CodeLoadAddr).l,d0
	beq.s	IPX_loc_B44 ; Jump if code doesn't need any load into memory
	movea.l	d0,a2

	; Load the code at the specified address in memory.
	lea	(MMD_CodeLocationInFile).l,a1
	move.w	(MMD_CodeSize).l,d7
.loop2	move.l	(a1)+,(a2)+
	dbf	d7,.loop2

IPX_loc_B44:
	move.w	sr,-(sp)
	move.l	(MMD_CodeHIntAddr).l,d0
	beq.s	IPX_loc_B52 ; Jump if there is no H-Int function.
	move.l	d0,(H_Int_addr).w

IPX_loc_B52:
	move.l	(MMD_CodeVIntAddr).l,d0
	beq.s	IPX_loc_B5E ; Jump if there is no V-Int function.
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

	; Dynamic call to the loaded code
	jsr	(a0)

	move.b	d0,(IPX_static_LoopVideoFlag).l
	bsr.w	IPX_loc_D30

	move.b	#$E0,(IO_unk_A01C0A).l
	bsr.w	IPX_loc_D4E

	move.b	#0,(IPX_unk_0F00).l
	move.l	#IPX_H_Int-IPX_Start+IPX_RAM_Start,(H_Int_addr).w
	move.l	#IPX_V_Int-IPX_Start+IPX_RAM_Start,(V_Int_addr).w
	move.w	#$8134,(IPX_unk_0F16).l
	bset	#0,(IPX_static_unk_0BE2).l
	bsr.w	IPX_loc_D5E
	bsr.w	IPX_loc_D1C

IPX_loc_BDE:
	movea.l	(sp)+,a0
	rts
; -----------------------------------------------------------------------------
; RAM variables in between executed code. Looks like some static variables...
; They shall stay at their exact address because they are referenced by other files which
; are not disassembled yet!
	if * > $13FE4E2
		fatal "IPX___.MMD RAM variables at $0BE2-$0BE3 are erased! $\{*} > $13FE4E2"
	endif
	org	$13FE4E2

IPX_RAM_0BE2:	dc.b	0 ; IPX_static_unk_0BE2
IPX_RAM_0BE3:	dc.b	0 ; IPX_static_LoopVideoFlag
; -----------------------------------------------------------------------------
; Vertical interrupt function.
;IPX_int_BE4:
IPX_V_Int:
	bset	#0,(IO_unk_A12000).l
	bclr	#0,(IPX_unk_0F00).l
	bclr	#0,(IPX_static_unk_0BE2).l
	beq.s	IPX_H_Int
	move.w	#$8134,(VDP_control_port).l

; Horizontal interrupt function (do nothing).
;IPX_int_C07:
IPX_H_Int:
	rte
; -----------------------------------------------------------------------------
; Load saved data from BRAM.
;IPX_loc_C08:
IPX_LoadSavedData:
	bsr.w	IPX_loc_C58

	move.w	(BRAM_CurrentZone).l,(IPX_CurrentZoneInSave).l
	move.b	(BRAM_GoodFuture_Array).l,(IPX_GoodFuture_Array).l
	move.b	(BRAM_unk_2002A8).l,(IPX_unk_0F1D).l
	move.b	(BRAM_unk_2002A5).l,(IPX_unk_0F18).l
	move.b	(BRAM_unk_2002A6).l,(IPX_unk_0F19).l
	move.b	(BRAM_NextSpecialStage).l,(IPX_NextSpecialStage).l
	move.b	(BRAM_TimeStones_Array).l,(IPX_TimeStones_Array).l
	bsr.w	IPX_loc_D1C
	rts
; -----------------------------------------------------------------------------

IPX_loc_C58:
	bsr.w	IPX_loc_D1C

	move.w	#unk_file_8B,d0
	btst	#0,(IPX_unk_0F1F).l
	bne.s	IPX_loc_C6E
	move.w	#unk_file_87,d0

IPX_loc_C6E:
	bsr.w	IPX_loc_CE0
	bra.w	IPX_loc_D10
; -----------------------------------------------------------------------------
;IPX_loc_C76:
IPX_SaveData:
	bsr.s	IPX_loc_C58

	move.w	(IPX_CurrentZoneInSave).l,(BRAM_CurrentZone).l
	move.b	(IPX_GoodFuture_Array).l,(BRAM_GoodFuture_Array).l
	move.b	(IPX_unk_0F1D).l,(BRAM_unk_2002A8).l
	move.b	(IPX_unk_0F18).l,(BRAM_unk_2002A5).l
	move.b	(IPX_unk_0F19).l,(BRAM_unk_2002A6).l
	move.b	(IPX_NextSpecialStage).l,(BRAM_NextSpecialStage).l
	move.b	(IPX_TimeStones_Array).l,(BRAM_TimeStones_Array).l
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
; RAM variable in between executed code. Looks like some static variable...
; It shall stay at its exact address because it is referenced by other files which
; are not disassembled yet!
	if * > $13FE6A6
		fatal "IPX___.MMD RAM variable at $0DA6 is erased! $\{*} > $13FE6A6"
	endif
	org	$13FE6A6

IPX_RAM_0DA6:	dc.w	0 ; IPX_static_unk_0DA6
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
