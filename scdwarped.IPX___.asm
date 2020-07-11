; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Start of IPX___.MMD file
; This is the hacked version for Sonic CD Warped.

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
	move.b	d0,(IPX_SpecialStageFlag).l
	move.b	d0,(IPX_unk_158E).l
	move.w	d0,(IPX_unk_1512).l
	move.l	d0,(IPX_unk_1514).l
	move.b	d0,(IPX_GoodFuture_ActFlag).l
	move.b	d0,(IPX_unk_156D).l
	move.b	d0,(IPX_PreviousGameMode).l
	move.b	#present,(IPX_CurrentTimeZone).l

	moveq	#title_screen_file,d0
	bsr.w	IPX_LoadAndRunFile
	ext.w	d1
	add.w	d1,d1
	move.w	IPX_off_TitleSelection(pc,d1.w),d1
	jsr	IPX_off_TitleSelection(pc,d1.w)
	bra.s	IPX_MainLoop
; -----------------------------------------------------------------------------

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
; IPX_loc_A8:
IPX_TeamRecords:
	move.w	#team_records_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
; IPX_loc_B0:
IPX_RamData:
	move.w	#ram_data_file,d0
	bsr.w	IPX_LoadAndRunFile
	bsr.w	IPX_LoadSavedData
	rts
; -----------------------------------------------------------------------------
; IPX_loc_BE:
IPX_SS1_Start:
	move.b	#0,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#0,(IO_SpecialStageLockouts).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------
; IPX_loc_DE:
IPX_SS6_Start:
	move.b	#5,(IO_SpecialStageToLoad).l
	move.b	#0,(IO_TimeStones_Array).l
	bset	#0,(IO_SpecialStageLockouts).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	rts
; -----------------------------------------------------------------------------
; IPX_loc_FE:
IPX_Continue:
	bset	#0,(IPX_PreviousGameMode).l

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

; IPX_loc_170:
IPX_NewGame:
	bset	#0,(IPX_PreviousGameMode).l

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
	bsr.w	IPX_ZoneCleanup
	bne.s	.skip
	bset	#0,(IPX_GoodFuture_Array).l
.skip:	bset	#6,(IPX_unk_0F1D).l
	bset	#5,(IPX_unk_0F1D).l

; IPX_loc_1DE:
IPX_Continue_R3:
	bsr.w	IPX_SaveData
	move.b	#0,(IPX_unk_1577).l
	bsr.w	IPX_LoadAndRun_R31
	move.b	#0,(IPX_unk_1577).l
	bsr.w	IPX_LoadAndRun_R32
	bsr.w	IPX_LoadAndRun_R33

	moveq	#6,d0
	bsr.w	IPX_ZoneCleanup
	bne.s	IPX_Continue_R4
	bset	#1,(IPX_GoodFuture_Array).l

; IPX_loc_226:
IPX_Continue_R4:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R41
	bsr.w	IPX_LoadAndRun_R42
	bsr.w	IPX_LoadAndRun_R43

	moveq	#9,d0
	bsr.w	IPX_ZoneCleanup
	bne.s	IPX_Continue_R5
	bset	#2,(IPX_GoodFuture_Array).l

; IPX_loc_25E:
IPX_Continue_R5:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R51
	bsr.w	IPX_LoadAndRun_R52
	bsr.w	IPX_LoadAndRun_R53

	moveq	#12,d0
	bsr.w	IPX_ZoneCleanup
	bne.s	IPX_Continue_R6
	bset	#3,(IPX_GoodFuture_Array).l

; IPX_loc_296:
IPX_Continue_R6:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R61
	bsr.w	IPX_LoadAndRun_R62
	bsr.w	IPX_LoadAndRun_R63

	moveq	#15,d0
	bsr.w	IPX_ZoneCleanup
	bne.s	IPX_Continue_R7
	bset	#4,(IPX_GoodFuture_Array).l

; IPX_loc_2CE:
IPX_Continue_R7:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R71
	bsr.w	IPX_LoadAndRun_R72
	bsr.w	IPX_LoadAndRun_R73

	moveq	#18,d0
	bsr.w	IPX_ZoneCleanup
	bne.s	IPX_Continue_R8
	bset	#5,(IPX_GoodFuture_Array).l

; IPX_loc_306:
IPX_Continue_R8:
	bsr.w	IPX_SaveData
	bsr.w	IPX_LoadAndRun_R81
	bsr.w	IPX_LoadAndRun_R82
	bsr.w	IPX_LoadAndRun_R83

	moveq	#21,d0
	bsr.w	IPX_ZoneCleanup
	bne.s	IPX_EndOfGame
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
	move.w	#good_ending_file,d0
	bsr.w	IPX_LoadAndRunFile
	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_GoodEnding
	rts
; -----------------------------------------------------------------------------
; Because of space limitations, functions of the Sonic CD Warped hack are scattered
; everywhere where they fit... As such, we desperately need some free bytes.
; This function alone free a lot of bytes as its code was originally copy/pasted 7 times.
IPX_ZoneCleanup:
	bsr.w	IPX_loc_5F8
	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l

	; In Sonic CD Warped, a good ending is not granted when all the good future flags are set.
	; Instead, the good ending is based on the Eggman machine flags, when all Eggman machines
	; are actually destroyed. The good future flag only purpose is now to display the bad and
	; good future time zones properly.
	cmpi.b	#3,(IPX_EggMachine_ZoneFlags).l ; Eggman machine destroyed in act 1 and act 2?
	rts
; -----------------------------------------------------------------------------
; Actions to perform when we are going to load a level in good or bad future.
; This can be at start of a level, or when warping to future.
IPX_RandomTimeZone_Future:
	move.b	#future,(IPX_CurrentTimeZone).l

	; d1 carries the flag to test for good or bad future.
	; It can be chosen randomly.
	btst	#0,d1
	beq.s	IPX_RandomTimeZone_GoodFuture

IPX_RandomTimeZone_BadFuture:
	; Set the Eggman machine destroyed flag if all the time stones are already collected.
	; As such, this displays a good future at the score tally even if we are in a bad future.
	bsr.s	IPX_CheckTimeStonesCollected

	; When all time stones are collected, the bad future badniks acts as if we are in
	; a good future (flowers spawning everywhere). Also, the music playing is the good future one.
	; To avoid that, a workaround is to set the last unused bit of the byte array, so that
	; its value is not $7F anymore (but $FF). This way, tests are invalidated in the level MMD file.
	; Then, the badniks displayed and the music are the bad future ones.
	bset	#7,(IPX_TimeStones_Array).l

	; Reset the good future flag in case we were in a good future time zone before.
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l
	rts
; -----------------------------------------------------------------------------

IPX_RandomTimeZone_GoodFuture:
	; Set the Eggman machine destroyed flag if all the time stones are already collected.
	; As such, this displays a good future at the score tally. However, if the time stones
	; are not all collected, and if the Eggman machine is not destroyed, the score tally
	; will not display a good future even if we are in the good future time zone.
	bsr.s	IPX_CheckTimeStonesCollected

	; Set the good future flag so that badniks are displayed as flowers. The music playing
	; is also the good future one.
	move.b	#good_future,(IPX_GoodFuture_ActFlag).l
	rts
; -----------------------------------------------------------------------------
; Set the Eggman machine destroyed flag if all the time stones are already collected.
; This allows to display a good future at the score tally, no matter the time zone you are in.
IPX_CheckTimeStonesCollected:
	cmpi.b	#$7F,(IPX_TimeStones_Array).l
	bne.s	.ret
	move.b	#1,(IPX_EggMachine_ActFlag).l
.ret:	rts
; -----------------------------------------------------------------------------
; When act 1 or act 2 ends, there are some things to check before we can continue.
IPX_CheckEndLevel_Acts_1_2:
	; Remove the workaround on the time stones array by clearing the last unused bit of the byte
	; array. This workaround is used in the bad future time zone to display bad future badniks and
	; play the bad future music even if all the time stones are already collected.
	bclr	#7,(IPX_TimeStones_Array).l

	; In case we destroy the Eggman machine and finish the level in the past time zone without
	; warping, the Eggman machine flag will not be set properly. We need to set the Eggman machine
	; flag in this case so that a good ending can be achieved.
	tst.b	(IPX_PreviousTimeZone).l
	bne.s	IPX_CheckTimeStonesCollected.ret ; A lazy way to gain 2 bytes of data...

	; Executed only when the level ended on the past time zone.
	; We are going to set the Eggman machine flag following the good future flag (automatically
	; set when destroying the Eggman machine object) and the current act we were in.
	move.b	(IPX_GoodFuture_ZoneFlags).l,d0

	; bit = 0, from act 1 to act 2 (b00 -> b01)
	; bit = 1, from act 2 to act 3 (b01 -> b10)
	btst	#0,(IPX_CurrentAct).l
	bne.w	IPX_TestMachineFlag ; Act 1
	lsr.b	#1,d0 ; Select bit assigned for act 2
	bra.w	IPX_TestMachineFlag ; Act 2
; -----------------------------------------------------------------------------
; Actions to perform when act 3 begins.
IPX_RandomTimeZone_BeginLevel_Act_3:
	; We test the Eggman machine flag for both acts 1 and 2, and set the flag for act 3 accordingly.
	; As such, when the Eggman machine was destroyed in each act, this displays a good future
	; at the score tally.
	cmpi.b	#3,(IPX_EggMachine_ZoneFlags).l
	bne.s	.skip
	move.b	#1,(IPX_EggMachine_ActFlag).l

	; Select a random time zone among good future or bad future.
	; d1 contains the last frames counter value from the previous level.
.skip:	lsr.w	#4,d1
	andi.w	#1,d1
	move.b	(a0,d1.w),d0
	bra.w	IPX_RandomTimeZone_Future
; -----------------------------------------------------------------------------
; RAM variables in between executed code. Looks like some static variables...
; They shall stay at their exact address because they are referenced by other MMD files which
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
; This function is heavily modified to implement the random time zones feature.
; IPX_loc_510:
IPX_RunAct_1_2:
	; Before starting the level, pick a random time zone.
	bsr.w	IPX_RandomTimeZone_Pick
	; Save the picked-up time zone for future use if we are warping.
	move.b	(IPX_CurrentTimeZone).l,(IPX_PreviousTimeZone).l
	andi.b	#3,(IPX_PreviousTimeZone).l

	; Load and run the current level in the picked-up time zone.
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

	; Loop to pick another time zone (following the past/future logic) and run the level.
	bset	#2,(IPX_PreviousGameMode).l
	bra.s	IPX_RunAct_1_2
; -----------------------------------------------------------------------------
;IPX_loc_55E:
IPX_EndOfAct_1_2:
	; Is the lives counter reached 0?
	tst.b	(IPX_LifeCount).l
	bne.s	IPX_CheckSpecialStage

	; Game over
	bra.s	IPX_GameOver ; Small space optimization
; -----------------------------------------------------------------------------
;IPX_loc_56C:
IPX_CheckSpecialStage:
	; Is the Special Stage entered?
	tst.b	(IPX_SpecialStageFlag).l
	bne.s	IPX_RunSpecialStage

	; End of act
	; Perform checks at end of the act. Then continue with the next act.
	bset	#1,(IPX_PreviousGameMode).l
	bra.w	IPX_CheckEndLevel_Acts_1_2
; -----------------------------------------------------------------------------
;IPX_loc_576:
IPX_RunSpecialStage:
	; Perform checks at end of the act.
	bset	#1,(IPX_PreviousGameMode).l
	bsr.w	IPX_CheckEndLevel_Acts_1_2

	; Are all time stones collected?
	; Yes, this can happen in one particular case even if we are about to enter a Special Stage.
	; When all time stones are collected and you enter randomly in the bad future time zone, the bit 7
	; of the time stones array is used as a workaround to display the bad future badniks and play the
	; bad future music. This bit is cleared by subroutine IPX_CheckEndLevel_Acts_1_2 above.
	; However in the level, because the time stones array is equal to $FF and not equal to $7F, this
	; triggers the spawn of the big ring at the end of the act. And eventually, you can enter in...
	; As a little easter egg, instead of fixing this small issue, why not enter the 8th secret
	; Special Stage in that case? :)
	cmpi.b	#$7F,(IPX_TimeStones_Array).l
	beq.w	IPX_RunSpecialStage_Secret

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
; This function is heavily modified to implement the random time zones feature.
; IPX_loc_5B4:
IPX_RunAct_3:
	; Before starting the level, pick a random time zone.
	bsr.w	IPX_RandomTimeZone_Pick
	; Load and run the current level in the picked-up time zone.
	bsr.w	IPX_LoadAndRunFile

	; The current level was unloaded.
	; Is it because the lives counter reached 0?
	tst.b	(IPX_LifeCount).l
	bne.s	IPX_EndOfAct_3

IPX_GameOver:
	; Game over
	move.l	(sp)+,d0
	bra.w	IPX_CleanupOnGameOver
; -----------------------------------------------------------------------------
;IPX_loc_5D8:
IPX_EndOfAct_3:
	bset	#1,(IPX_PreviousGameMode).l

	; Remove the workaround on the time stones array by clearing the last unused bit of the byte
	; array. This workaround is used in the bad future time zone to display bad future badniks and
	; play the bad future music even if all the time stones are already collected.
	bclr	#7,(IPX_TimeStones_Array).l

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
; Cleanup some variables on Game Over before returning to the title screen.
;IPX_loc_39E:
IPX_CleanupOnGameOver:
	move.b	#0,(IPX_CurrentAct).l
	move.w	(IPX_CurrentZoneAndAct).l,(IPX_CurrentZoneInSave).l

	move.b	#0,(IPX_unk_158E).l
	move.b	#0,(IPX_unk_156D).l
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l
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
; Probably the most important function of Sonic CD Warped.
; Before starting a new level, a call to this function randomly pick-up a time zone.
; The time zone can be past, present, bad future or good future, regardless of
; the good future flag IPX_GoodFuture_ActFlag that is set when you destroy an Eggman machine.
;
; To avoid serious issues and keep the gameplay clean, a number of countermeasures are implemented.
; For a start, IPX_EggMachine_ActFlag replaces IPX_GoodFuture_ActFlag when necessary. This new flag
; actually is the reference to tell if the Eggman machine was destroyed or not. The decision to
; grant the good ending at the end of the game is based on this new flag. IPX_GoodFuture_ActFlag is
; now used only to display the bad future and good future time zones properly.
;
; However, IPX_EggMachine_ActFlag is not set when you actually destroy the Eggman machine (because this
; would require to edit in hex a lot of files of Sonic CD, and I don't want to do that too often).
; The flag is set based on IPX_GoodFuture_ActFlag when you quit the past time zone, either by ending
; the level, or by warping to another time zone.
;
; As side effects to this, you can make a good future at the end of the bad future time zone, and you
; can make a bad future at the end of the good future time zone. It is already implemented in the
; original game, probably due to copy/paste of the score tally object.
; Now, you make a good future only if the IPX_EggMachine_ActFlag is set.
;
; Another thing, even if the time zones are picked-up randomly, this continues to follow the past/future
; logic. This means:
; - If you are in the past, you can warp to present, bad future or good future (yes, directly!).
; - If you are in the future (bad or good), you can warp to present or to past (again, yes, directly!).
; - If you are in the present with a past signpost activated, you can only warp to past.
; - If you are in the present with a future signpost activated, you can warp to bad future or good future.
IPX_RandomTimeZone_Pick:
	; Test the game mode we were in before starting the level.
	moveq	#0,d0
	move.b	(IPX_PreviousGameMode).l,d0
	move.b	#0,(IPX_PreviousGameMode).l ; Reset the previous game mode value

	; Were we already in a level and warping to another time zone?
	btst	#2,d0
	bne.w	IPX_RandomTimeZone_PickAfterWarp

	; If not, this is the start of a new level.
	; Reset the Eggman machine flag.
	move.b	#0,(IPX_EggMachine_ActFlag).l
	; Were we in another level or special stage?
	btst	#1,d0
	bne.s	IPX_RandomTimeZone_PickAfterLevel

	; If not, the only other option is that we were in the title screen.
	; Pick the frames counter value used during the title screen.
	move.w	(FramesCounter).w,d1
	bra.s	IPX_RandomTimeZone_PickAfterTitleScreen
; -----------------------------------------------------------------------------

IPX_RandomTimeZone_PickAfterLevel:
	; Pick the frames counter value used during the previous level.
	move.w	(IPX_FramesCounter_Level).l,d1
	; Are we starting act 3?
	; There is a dedicated function for act 3 to handle only the bad future
	; and the good future time zones.
	btst	#1,(IPX_CurrentAct).l
	bne.w	IPX_RandomTimeZone_BeginLevel_Act_3

	; Now that the frames counter value is picked-up, the same function applies
	; if we are coming from another level or from the title screen.
	; Note that this function only covers act 1 and act 2.
IPX_RandomTimeZone_PickAfterTitleScreen:
	; Shift the flag to the left in case we are starting act 2.
	; No effect at the beginning of act 1 (shift of value 0).
	lsl.w	(IPX_EggMachine_ZoneFlags).l

	; Pick-up a random time zone based on the frames counter value.
	lsr.w	#4,d1
	andi.w	#3,d1 ; Can be 0, 1, 2 or 3
	move.b	(a0,d1.w),d0 ; Load the corresponding time zone.

	; Jump to dedicated functions.
	cmpi.b	#1,d1
	blt.s	IPX_RandomTimeZone_Present ; 0
	beq.s	IPX_RandomTimeZone_Past    ; 1
	bra.w	IPX_RandomTimeZone_Future  ; 2 or 3
; -----------------------------------------------------------------------------
; Actions to perform when we are going to load a level in the present time zone.
IPX_RandomTimeZone_Present:
	move.b	#present,(IPX_CurrentTimeZone).l
	rts
; -----------------------------------------------------------------------------
; Actions to perform when we are going to load a level in the past time zone.
IPX_RandomTimeZone_Past:
	move.b	#past,(IPX_CurrentTimeZone).l
	rts
; -----------------------------------------------------------------------------
; IPX_loc_64E:
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
;-----------------------------------------------------------------------------
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
; IPX_loc_85E:
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
; IPX_off_87E:
IPX_off_Demo:	offsetTable
		offsetTableEntry.w IPX_IntroVideo
		offsetTableEntry.w IPX_R1_Demo
		offsetTableEntry.w IPX_SS1_Demo
		offsetTableEntry.w IPX_R4_Demo
		offsetTableEntry.w IPX_SS6_Demo
		offsetTableEntry.w IPX_R8_Demo
; -----------------------------------------------------------------------------
; IPX_loc_88A:
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
; IPX_loc_8BC:
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
; IPX_loc_8EE:
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
; IPX_loc_920:
IPX_SS1_Demo:
	move.w	#unk_file_8A,d0
	bsr.w	IPX_loc_CE0
	bra.w	IPX_SS1_Start
; -----------------------------------------------------------------------------
; IPX_loc_92C:
IPX_SS6_Demo:
	move.w	#unk_file_8A,d0
	bsr.w	IPX_loc_CE0
	bra.w	IPX_SS6_Start
; -----------------------------------------------------------------------------
; IPX_loc_938:
IPX_IntroVideo:
	move.w	#intro_video_file,d0
	bsr.w	IPX_LoadAndRunFile
	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_IntroVideo
	rts
; -----------------------------------------------------------------------------
; IPX_loc_94A:
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
; IPX_loc_9CA:
IPX_VisualMode:
	move.w	#visual_mode_file,d0
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
	move.w	#intro_video_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_9E6
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------

IPX_loc_9F8:
	rts
; -----------------------------------------------------------------------------

IPX_loc_9FA:
	move.w	#pencil_test_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_9FA
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------

IPX_loc_A0C:
	move.b	#$7F,(IPX_unk_0F24).l
	move.w	#good_ending_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_A0C

	move.w	#player_name_file,d0
	bsr.w	IPX_LoadAndRunFile
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------

IPX_loc_A2E:
	move.b	#0,(IPX_unk_0F24).l
	move.w	#bad_ending_file,d0
	bsr.w	IPX_LoadAndRunFile

	tst.b	(IPX_static_unk_0BE3).l
	bmi.s	IPX_loc_A2E
	bra.s	IPX_VisualMode
; -----------------------------------------------------------------------------
; IPX_loc_A48:
IPX_DAGarden:
	move.w	#d_a_garden_file,d0
	bra.w	IPX_LoadAndRunFile
; -----------------------------------------------------------------------------
; IPX_loc_A50:
IPX_TimeAttack:
	moveq	#time_attack_file,d0
	bsr.w	IPX_LoadAndRunFile

	move.w	d0,(IPX_unk_0F14).l
	beq.w	IPX_loc_AB2

	move.b	IPX_byte_AB4(pc,d0.w),d0
	bmi.s	IPX_loc_AD2

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
	bset	#1,(IO_SpecialStageLockouts).l

	moveq	#special_stage_file,d0
	bsr.w	IPX_LoadAndRunFile
	bra.w	IPX_TimeAttack
; -----------------------------------------------------------------------------

IPX_loc_D1C:
	bset	#1,(IO_unk_A12003).l
	btst	#1,(IO_unk_A12003).l
	beq.s	IPX_loc_D1C
	rts
; -----------------------------------------------------------------------------

IPX_TestMachineFlag:
	btst	#0,d0
	beq.s	.skip
	bset	#0,(IPX_EggMachine_ZoneFlags).l
	move.b	#1,(IPX_EggMachine_ActFlag).l
.skip:	rts
; -----------------------------------------------------------------------------

IPX_TestMachineFlag_Warp:
	move.b	(IPX_GoodFuture_ActFlag).l,d0
	bra.w	IPX_TestMachineFlag
; -----------------------------------------------------------------------------
; RAM variables inside executed code
	dephase
	if * > $16F6032
		fatal "IPX___.MMD RAM variables in $0BE2-$0BE3 are erased! $\{*} > $16F6032"
	else
		message "IPX___.MMD RAM variables in $0BE2-$0BE3: $\{*} <= $16F6032"
	endif
	org	$16F6032
	phase	$16F6032-$130

IPX_RAM_0BE2:	dc.b	0
IPX_RAM_0BE3:	dc.b	0
; -----------------------------------------------------------------------------

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

IPX_int_BE4:
	bset	#0,(IO_unk_A12000).l
	bclr	#0,(IPX_unk_0F00).l
	bclr	#0,(IPX_unk_0BE2).l
	beq.s	IPX_int_C06
	move.w	#$8134,(VDP_control_port).l

IPX_int_C06:
	rte
; -----------------------------------------------------------------------------

; IPX_loc_C08:
IPX_LoadSavedData:
	bsr.w	IPX_loc_C58

	move.w	(BRAM_unk_2002A4).l,(IPX_CurrentZoneInSave).l
	move.b	(BRAM_GoodFuture_Array).l,(IPX_GoodFuture_Array).l
	move.b	(BRAM_unk_2002A8).l,(IPX_unk_0F1D).l
	move.b	(BRAM_unk_2002A5).l,(IPX_unk_0F18).l
	move.b	(BRAM_unk_2002A6).l,(IPX_unk_0F19).l
	move.b	(BRAM_unk_2002AC).l,(IPX_NextSpecialStage).l
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

IPX_RandomTimeZone_Warp_FromFuture:
	bclr	#1,d1
	move.b	(a0,d1.w),d0
	bchg	#0,d1
	move.b	d1,(IPX_CurrentTimeZone).l

	bclr	#7,(IPX_TimeStones_Array).l
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l
	btst	#0,(IPX_EggMachine_ZoneFlags).l
	bne.w	IPX_RandomTimeZone_GoodFuture
	rts
; -----------------------------------------------------------------------------

IPX_RunSpecialStage_Secret:
	bsr.w	IPX_loc_96A
	move.b	#1,(IPX_unk_0F22).l
	move.b	#0,(IPX_SpecialStageFlag).l
	rts
; -----------------------------------------------------------------------------
; RAM variable inside executed code
	dephase
	if * > $16F61F6
		fatal "IPX___.MMD RAM variable in $0DA6 is erased! $\{*} > $16F61F6"
	else
		message "IPX___.MMD RAM variable in $0DA6: $\{*} <= $16F61F6"
	endif
	org	$16F61F6
	phase	$16F61F6-$130

IPX_RAM_0DA6:	dc.w	0
; -----------------------------------------------------------------------------

; IPX_loc_C76:
IPX_SaveData:
	move.b	#bad_future,(IPX_GoodFuture_ActFlag).l
	move.b	#0,(IPX_EggMachine_ZoneFlags).l
	bsr.s	IPX_loc_C58 

	move.w	(IPX_CurrentZoneInSave).l,(BRAM_unk_2002A4).l
	move.b	(IPX_GoodFuture_Array).l,(BRAM_GoodFuture_Array).l
	move.b	(IPX_unk_0F1D).l,(BRAM_unk_2002A8).l
	move.b	(IPX_unk_0F18).l,(BRAM_unk_2002A5).l
	move.b	(IPX_unk_0F19).l,(BRAM_unk_2002A6).l
	move.b	(IPX_NextSpecialStage).l,(BRAM_unk_2002AC).l
	move.b	(IPX_TimeStones_Array).l,(BRAM_TimeStones_Array).l 
	bsr.w	IPX_loc_D1C

	move.w	#unk_file_8C,d0
	btst	#0,(IPX_unk_0F1F).l
	bne.s	IPX_loc_CD4
	move.w	#unk_file_88,d0

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

IPX_loc_D30:
	move.w	sr,(IPX_unk_0DA6).l
	move.w	#$2700,sr
	move.w	#$0100,(Z80_Bus_Request).l

IPX_loc_D42:
	btst	#0,(Z80_Bus_Request).l
	bne.s	IPX_loc_D42
	rts
; -----------------------------------------------------------------------------

IPX_loc_D4E:
	move.w	#0,(Z80_Bus_Request).l
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

IPX_RandomTimeZone_PickAfterWarp:
	move.w	(IPX_FramesCounter_Level).l,d1
	lsr.w	#4,d1
	andi.w	#3,d1

	cmpi.b	#1,(IPX_PreviousTimeZone).l
	blt.s	IPX_RandomTimeZone_Warp_FromPast
	bgt.w	IPX_RandomTimeZone_Warp_FromFuture

;IPX_RandomTimeZone_Warp_FromPresent:
	btst	#1,(IPX_CurrentTimeZone).l
	beq.s	IPX_RandomTimeZone_Warp_FromPresent_ToPast

	bset	#1,d1

IPX_RandomTimeZone_Warp_ToFuture:
	move.b	(a0,d1.w),d0
	bra.w	IPX_RandomTimeZone_Future
; -----------------------------------------------------------------------------

IPX_RandomTimeZone_Warp_FromPresent_ToPast:
	move.b	1(a0),d0
	rts
; -----------------------------------------------------------------------------

IPX_RandomTimeZone_Warp_FromPast:
	bsr.w	IPX_TestMachineFlag_Warp
	btst	#1,d1
	bne.s	IPX_RandomTimeZone_Warp_ToFuture

;IPX_RandomTimeZone_Warp_ToPresent:
	move.b	0(a0),d0
	rts
; -----------------------------------------------------------------------------

	dephase
	if * > $16F634A
		fatal "IPX___.MMD RAM variables in $0EFA-$0EFF are erased! $\{*} > $16F634A"
	else
		message "IPX___.MMD RAM variables in $0EFA-$0EFF: $\{*} <= $16F634A"
	endif
	org	$16F634A
	phase	$16F634A-$130

IPX_RAM_0EFA:	dc.w	0
IPX_RAM_0EFC:	dc.b	0
		dc.b	0 ; Free byte
IPX_RAM_0EFE:	dc.b	0
IPX_RAM_0EFF:	dc.b	0

	dephase

; ===========================================================================
; end of IPX___.MMD file
IPX_End:
	if * > $16F6350 ; Maximum code size allowed for this file
		fatal "IPX___.MMD maximum code size reached! $\{*} > $16F6350"
	endif
