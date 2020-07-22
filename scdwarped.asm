; Sonic CD Warped disassembled binary

; Sonic Hachelle-Bee, 2020 (templated from the Sonic 2 disassembly)
; ---------------------------------------------------------------------------
; NOTES:
;
; Set your editor's tab width to 8 characters wide for viewing this file.
;
; It is highly suggested that you read the AS User's Manual before diving too
; far into this disassembly. At least read the section on nameless temporary
; symbols. Your brain may melt if you don't know how those work.

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; ASSEMBLY OPTIONS:
;
gameRegion = 0
;	| If 0, compile the japanese version
;	| If 1, compile the US version
;	| If 2, compile the european version
;
randomTimeZones = 1
;	| If 1, time zones are random at start of every level, and random when warping from a time zone
;	| to another (note that warping still keep the past/future logic).
;	| If 0, this compiles the original scd.IPX___.asm file and removes this feature.
;
removeWarpCutscene = 1
;	| If 1, remove the warp cutscene entirely. This makes the warp between time zones
;	| almost instantaneous.
;
reduceWarpTime = 1
;	| If 1, the time required to run at full speed for the warp to activate is reduced.
;	| To edit the time values, edit the warp_time_macro below.
;
padToPowerOfTwo = 0
;	| If 1, pads the end of the ISO file to the next power of two bytes
; 
zeroOffsetOptimization = 0
;	| If 1, makes a handful of zero-offset instructions smaller
;
addsubOptimize = 1
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 1
;	| If 1, makes some instructions use pc-relative addressing, instead of absolute long
;

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; AS-specific macros and assembler settings
	CPU 68000
	include "scdwarped.macrosetup.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
	include "scdwarped.constants.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simplifying macros and functions
	include "scdwarped.macros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; start of ISO file

; Level files are not disassembled yet (a lot of work to do here).
; For the Sonic CD Warped hack, some parts of each level file are modified.
; Special macros are called to edit precisely the parts to modify.

; ---------------------------------------------------------------------------
; This macro defines a specific BINCLUDE which take the current game region into account.
BINCLUDE_ISO macro startaddr,endaddr
    if gameRegion=0
	BINCLUDE "Sonic CD (J)/Sonic CD (J).iso",startaddr,endaddr-(startaddr)
    endif
    if gameRegion=1
	BINCLUDE "Sonic CD (U)/Sonic CD (U).iso",startaddr,endaddr-(startaddr)
    endif
    if gameRegion=2
	BINCLUDE "Sonic CD (E)/Sonic CD (E).iso",startaddr,endaddr-(startaddr)
    endif
    endm

; ---------------------------------------------------------------------------
; This macro edits the score tally object at address specified.
; To display a good future, instead of testing the IPX_GoodFuture_ActFlag which is no
; longer accurate in the bad future and the good future time zones, the
; IPX_EggMachine_ActFlag is tested instead.
score_tally_macro macro addressJE, addressU
	; Jump to the right address depending of the region
    if gameRegion=1
	BINCLUDE_ISO *,addressU
    else
	BINCLUDE_ISO *,addressJE
    endif
	; Edit the score tally object
    if randomTimeZones=1
	tst.b	(IPX_EggMachine_ActFlag).l
    else
	tst.b	(IPX_GoodFuture_ActFlag).l
    endif
    endm

; ---------------------------------------------------------------------------
; This macro edits the time needed to run at full speed before the warping activates.
; The warp time works with a counter going up at $FFFFF786 when the stars first surrounds Sonic.
; At specific times, an action is taken:
; - Time required for the time sign to start blinking.
; - Time required for the camera to stop moving.
; - Time required for Sonic to disappear, leaving only the stars.
; - Time required for ending the current level and begining the warp.
warp_time_macro macro addressJE, addressU
	; Jump to the right address depending of the region
    if gameRegion=1
	BINCLUDE_ISO *,addressU
    else
	BINCLUDE_ISO *,addressJE
    endif
	; Edit the warp time
    if reduceWarpTime=1
	; Sonic CD Warped time values.
	; Time required for Sonic to disappear, leaving only the stars.
	cmpi.w	#$74,(WarpTimeCounter).w
	BINCLUDE_ISO *,*+$2C4
	; Time required for ending the current level and begining the warp.
	cmpi.w	#$88,d1
	BINCLUDE_ISO *,*+$E
	; Time required for the camera to stop moving.
	cmpi.w	#$74,d1
	BINCLUDE_ISO *,*+$50
	; Time required for the time sign to start blinking.
	cmpi.w	#$5A,d1
    else
	; Original time values.
	; Time required for Sonic to disappear, leaving only the stars.
	cmpi.w	#$D2,(WarpTimeCounter).w
	BINCLUDE_ISO *,*+$2C4
	; Time required for ending the current level and begining the warp.
	cmpi.w	#$E6,d1
	BINCLUDE_ISO *,*+$E
	; Time required for the camera to stop moving.
	cmpi.w	#$D2,d1
	BINCLUDE_ISO *,*+$50
	; Time required for the time sign to start blinking.
	cmpi.w	#$5A,d1
    endif
    endm

; ===========================================================================
; Following the game region, the addresses to edit are not the same.
	;                  JP EU      US
	; PPZ1 present
	warp_time_macro   $1E023A, $1E023E
	; PPZ1 past
	warp_time_macro   $22003E, $220042
	; PPZ1 good future
	warp_time_macro   $25FF92, $25FF96
	score_tally_macro $269BD8, $269BCA
	; PPZ1 bad future
	warp_time_macro   $29FFA8, $29FFAC
	score_tally_macro $2A9BCA, $2A9BBC
	; PPZ2 present
	warp_time_macro   $2E00CE, $2E00D2
	; PPZ2 past
	warp_time_macro   $320050, $320054
	; PPZ2 good future
	warp_time_macro   $35FF96, $35FF9A
	score_tally_macro $369C24, $369C16
	; PPZ2 bad future
	warp_time_macro   $39FFA6, $39FFAA
	score_tally_macro $3A9C1C, $3A9C0E
	; PPZ3 good future
	warp_time_macro   $3DFF88, $3DFF8C
	score_tally_macro $3E9CB8, $3E9CAA
	; PPZ3 bad future
	warp_time_macro   $41FFA0, $41FFA4
	score_tally_macro $429CD0, $429CC2
	; CCZ1 present
	warp_time_macro   $4601AA, $4601AE
	; CCZ1 past
	warp_time_macro   $4A0080, $4A0084
	; CCZ1 good future
	warp_time_macro   $4E01A4, $4E01A8
	score_tally_macro $4EAC42, $4EAC34
	score_tally_macro $4EB4E2, $4EB4D4 ; ???
	; CCZ1 bad future
	warp_time_macro   $52016C, $520170
	score_tally_macro $52ABF2, $52ABE4
	score_tally_macro $52B4E2, $52B4D4 ; ???
	; CCZ2 present
	warp_time_macro   $56019C, $5601A0
	; CCZ2 past
	warp_time_macro   $5A0066, $5A006A
	; CCZ2 good future
	warp_time_macro   $5E01A0, $5E01A4
	score_tally_macro $5EAA46, $5EAA38
	score_tally_macro $5EB4E2, $5EB4D4 ; ???
	; CCZ2 bad future
	warp_time_macro   $620170, $620174
	score_tally_macro $62AA16, $62AA08
	score_tally_macro $62B4E2, $62B4D4 ; ???
	; CCZ3 good future
	warp_time_macro   $660190, $660194
	score_tally_macro $66956E, $669560
	; CCZ3 bad future
	warp_time_macro   $6A0158, $6A015C
	score_tally_macro $6A9536, $6A9528
	; TTZ1 present
	warp_time_macro   $6E0312, $6E0316
	; TTZ1 past
	warp_time_macro   $72022C, $720230
	; TTZ1 good future
	warp_time_macro   $760258, $76025C
	score_tally_macro $76775E, $767758
	; TTZ1 bad future
	warp_time_macro   $7A0246, $7A024A
	score_tally_macro $7A774C, $7A7746
	; TTZ2 present
	warp_time_macro   $7E02DA, $7E02DE
	; TTZ2 past
	warp_time_macro   $820220, $820224
	; TTZ2 good future
	warp_time_macro   $860244, $860248
	score_tally_macro $867756, $867750
	; TTZ2 bad future
	warp_time_macro   $8A0232, $8A0236
	score_tally_macro $8A7744, $8A773E
	; TTZ3 good future
	warp_time_macro   $8E021E, $8E0222
	score_tally_macro $8E6B4C, $8E6B46
	; TTZ3 bad future
	warp_time_macro   $920232, $920236
	score_tally_macro $926B60, $926B5A
	; QQZ1 present
	warp_time_macro   $9602E4, $96029C
	; QQZ1 past
	warp_time_macro   $9A01F0, $9A017A
	; QQZ1 good future
	warp_time_macro   $9E0110, $9E009A
	score_tally_macro $9E7D42, $9E7CB2
	; QQZ1 bad future
	warp_time_macro   $A20208, $A20192
	score_tally_macro $A27E3A, $A27DAA
	; QQZ2 present
	warp_time_macro   $A602FA, $A60272
	; QQZ2 past
	warp_time_macro   $AA01F0, $AA0174
	; QQZ2 good future
	warp_time_macro   $AE0110, $AE0094
	score_tally_macro $AE7B32, $AE7AA4
	; QQZ2 bad future
	warp_time_macro   $B20208, $B2018C
	score_tally_macro $B27C2A, $B27B9C
	; QQZ3 good future
	warp_time_macro   $B5FF52, $B5FF56
	score_tally_macro $B66D2C, $B66D1E
	; QQZ3 bad future
	warp_time_macro   $BA002E, $BA0032
	score_tally_macro $BA6E08, $BA6DFA
	; WWZ1 present
	warp_time_macro   $BE03AA, $BE03AE
	; WWZ1 past
	warp_time_macro   $C203D4, $C20358
	; WWZ1 good future
	warp_time_macro   $C603F2, $C60376
	score_tally_macro $C68480, $C683FA
	; WWZ1 bad future
	warp_time_macro   $CA039A, $CA039E
	score_tally_macro $CA8428, $CA8422
	; WWZ2 present
	warp_time_macro   $CE0352, $CE0356
	; WWZ2 past
	warp_time_macro   $D20338, $D2033C
	; WWZ2 good future
	warp_time_macro   $D6031A, $D6031E
	score_tally_macro $D68070, $D6806A
	; WWZ2 bad future
	warp_time_macro   $DA0342, $DA0346
	score_tally_macro $DA8098, $DA8092
	; WWZ3 good future
	warp_time_macro   $DE0402, $DE0386
	score_tally_macro $DE693C, $DE68B6
	; WWZ3 bad future
	warp_time_macro   $E203AA, $E203AE
	score_tally_macro $E268E4, $E268DE
	; SSZ1 present
	warp_time_macro   $E5FFD6, $E5FF5A
	; SSZ1 past
	warp_time_macro   $E9FF8C, $E9FF90
	; SSZ1 good future
	warp_time_macro   $EE0098, $EE001C
	score_tally_macro $EE88EA, $EE885C
	; SSZ1 bad future
	warp_time_macro   $F20008, $F2000C
	score_tally_macro $F2885A, $F2884C
	; SSZ2 present
	warp_time_macro   $F5FF56, $F5FF5A
	; SSZ2 past
	warp_time_macro   $F9FF8C, $F9FF90
	; SSZ2 good future
	warp_time_macro   $FE0018, $FE001C
	score_tally_macro $FE8E1A, $FE8E0C
	; SSZ2 bad future
	warp_time_macro   $1020008, $102000C
	score_tally_macro $1028E0A, $1028DFC
	; SSZ3 good future
	warp_time_macro   $1060088, $106000C
	score_tally_macro $10675F6, $1067568
	; SSZ3 bad future
	warp_time_macro   $10A0016, $10A001A
	score_tally_macro $10A7584, $10A7576
	; MMZ1 present
	warp_time_macro   $10DFDC4, $10DFDC8
	; MMZ1 past
	warp_time_macro   $111FD66, $111FD6A
	; MMZ1 good future
	warp_time_macro   $115FE7E, $115FE82
	score_tally_macro $1166C3C, $1166C2E
	; MMZ1 bad future
	warp_time_macro   $119FFC6, $119FFCA
	score_tally_macro $11A6D84, $11A6D76
	; MMZ2 present
	warp_time_macro   $11DFDB8, $11DFDBC
	; MMZ2 past
	warp_time_macro   $1220048, $122004C
	; MMZ2 good future
	warp_time_macro   $126010E, $1260112
	score_tally_macro $1268192, $1268184
	; MMZ2 bad future
	warp_time_macro   $129FFE0, $129FFE4
	score_tally_macro $12A8064, $12A8056
	; MMZ3 good future
	warp_time_macro   $12DFE76, $12DFE7A
	score_tally_macro $12E6C06, $12E6BF8
	; MMZ3 bad future
	warp_time_macro   $131FEFE, $131FF02
	score_tally_macro $132708E, $1327080

; Jump to the beginning of the IPX___.MMD file
	BINCLUDE_ISO *,$13FD800

; ===========================================================================
; IPX___.MMD file
; This file is loaded into 68K RAM at the beginning of the game.
; The code is loaded and executed at offset $FFFF0000 and is never erased.
; It is executed to make the link between levels, menus of Sonic CD.
; It has a file loader. It is able to load other files in 68K RAM and run their code.
; Other files are loaded at $FFFF2000.

    if randomTimeZones=1
	include "scdwarped.IPX___.asm"
    else
	include "scd.IPX___.asm"
    endif

; ===========================================================================
; Include the rest of the ISO file.
    if gameRegion=0
	BINCLUDE_ISO *,$6B52800
    endif
    if gameRegion=1
	BINCLUDE_ISO *,$7409800
    endif
    if gameRegion=2
	BINCLUDE_ISO *,$6B9C824
    endif

; ===========================================================================
; end of ISO file
	if padToPowerOfTwo && (*)&(*-1)
		cnop	-1,2<<lastbit(*-1)
		dc.b	0
paddingSoFar	:= paddingSoFar+1
	else
		even
	endif
	if MOMPASS=2
		; "About" because I may have missed a small amount of internal padding somewhere
		message "ISO size is $\{*} bytes (\{*/1024.0} kb). About $\{paddingSoFar} bytes are padding."
	endif

ISO_End:
	END	   
