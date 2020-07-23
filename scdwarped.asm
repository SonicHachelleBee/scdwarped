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
;	| To edit the time values, edit the 4 warp_time_macro below.
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

; This macro includes all bytes until the specified address is reached.
; This takes the current game region into account.
BINCLUDE_ADDR macro addressJE, addressU
    if gameRegion=1
	BINCLUDE_ISO *,addressU
    else
	BINCLUDE_ISO *,addressJE
    endif
    endm

; ---------------------------------------------------------------------------
; This macro edits the score tally object at address specified.
; To display a good future, instead of testing the IPX_GoodFuture_ActFlag which is no
; longer accurate in the bad future and the good future time zones, the
; IPX_EggMachine_ActFlag is tested instead.
score_tally_macro macro addressJE, addressU
	BINCLUDE_ADDR addressJE, addressU
    if randomTimeZones=1
	tst.b	(IPX_EggMachine_ActFlag).l
    else
	tst.b	(IPX_GoodFuture_ActFlag).l
    endif
    endm

; ---------------------------------------------------------------------------
; These macros edit the time needed to run at full speed before the warping activates.
; The warp time works with a counter going up at $FFFFF786 when the stars first surrounds Sonic.
; At specific times, an action is taken:
; - Time required for the time sign to start blinking.
; - Time required for the camera to stop moving.
; - Time required for Sonic to disappear, leaving only the stars.
; - Time required for ending the current level and begining the warp.

; Time required for the time sign to start blinking
warp_time_macro4 macro addressJE, addressU
	BINCLUDE_ADDR addressJE, addressU
    if reduceWarpTime=1
	cmpi.w	#$5A,d1
    else
	cmpi.w	#$5A,d1
    endif
    endm

; Time required for the camera to stop moving
warp_time_macro3 macro addressJE, addressU
	BINCLUDE_ADDR addressJE, addressU
    if reduceWarpTime=1
	cmpi.w	#$74,d1
    else
	cmpi.w	#$D2,d1
    endif
    endm

; Time required for Sonic to disappear, leaving only the stars
warp_time_macro1 macro addressJE, addressU
	BINCLUDE_ADDR addressJE, addressU
    if reduceWarpTime=1
	cmpi.w	#$74,(WarpTimeCounter).w
    else
	cmpi.w	#$D2,(WarpTimeCounter).w
    endif
    endm

; Time required for ending the current level and begining the warp
warp_time_macro2 macro addressJE, addressU
	BINCLUDE_ADDR addressJE, addressU
    if reduceWarpTime=1
	cmpi.w	#$88,d1
    else
	cmpi.w	#$E6,d1
    endif
    endm

; ===========================================================================
; Following the game region, the addresses to edit are not the same.
	;                  JP EU      US
	; PPZ1 present
	warp_time_macro1  $1E023A, $1E023E
	warp_time_macro2  $1E0504, $1E0508
	warp_time_macro3  $1E0516, $1E051A
	warp_time_macro4  $1E056A, $1E056E
	; PPZ1 past
	warp_time_macro1  $22003E, $220042
	warp_time_macro2  $220308, $22030C
	warp_time_macro3  $22031A, $22031E
	warp_time_macro4  $22036E, $220372
	; PPZ1 good future
	warp_time_macro1  $25FF92, $25FF96
	warp_time_macro2  $26025C, $260260
	warp_time_macro3  $26026E, $260272
	warp_time_macro4  $2602C2, $2602C6
	score_tally_macro $269BD8, $269BCA
	; PPZ1 bad future
	warp_time_macro1  $29FFA8, $29FFAC
	warp_time_macro2  $2A0272, $2A0276
	warp_time_macro3  $2A0284, $2A0288
	warp_time_macro4  $2A02D8, $2A02DC
	score_tally_macro $2A9BCA, $2A9BBC

	; PPZ2 present
	warp_time_macro1  $2E00CE, $2E00D2
	warp_time_macro2  $2E0398, $2E039C
	warp_time_macro3  $2E03AA, $2E03AE
	warp_time_macro4  $2E03FE, $2E0402
	; PPZ2 past
	warp_time_macro1  $320050, $320054
	warp_time_macro2  $32031A, $32031E
	warp_time_macro3  $32032C, $320330
	warp_time_macro4  $320380, $320384
	; PPZ2 good future
	warp_time_macro1  $35FF96, $35FF9A
	warp_time_macro2  $360260, $360264
	warp_time_macro3  $360272, $360276
	warp_time_macro4  $3602C6, $3602CA
	score_tally_macro $369C24, $369C16
	; PPZ2 bad future
	warp_time_macro1  $39FFA6, $39FFAA
	warp_time_macro2  $3A0270, $3A0274
	warp_time_macro3  $3A0282, $3A0286
	warp_time_macro4  $3A02D6, $3A02DA
	score_tally_macro $3A9C1C, $3A9C0E

	; PPZ3 good future
	warp_time_macro1  $3DFF88, $3DFF8C
	warp_time_macro2  $3E0252, $3E0256
	warp_time_macro3  $3E0264, $3E0268
	warp_time_macro4  $3E02B8, $3E02BC
	score_tally_macro $3E9CB8, $3E9CAA
	; PPZ3 bad future
	warp_time_macro1  $41FFA0, $41FFA4
	warp_time_macro2  $42026A, $42026E
	warp_time_macro3  $42027C, $420280
	warp_time_macro4  $4202D0, $4202D4
	score_tally_macro $429CD0, $429CC2

	; CCZ1 present
	warp_time_macro1  $4601AA, $4601AE
	warp_time_macro2  $460474, $460478
	warp_time_macro3  $460486, $46048A
	warp_time_macro4  $4604DA, $4604DE
	; CCZ1 past
	warp_time_macro1  $4A0080, $4A0084
	warp_time_macro2  $4A034A, $4A034E
	warp_time_macro3  $4A035C, $4A0360
	warp_time_macro4  $4A03B0, $4A03B4
	; CCZ1 good future
	warp_time_macro1  $4E01A4, $4E01A8
	warp_time_macro2  $4E046E, $4E0472
	warp_time_macro3  $4E0480, $4E0484
	warp_time_macro4  $4E04D4, $4E04D8
	score_tally_macro $4EAC42, $4EAC34
	score_tally_macro $4EB4E2, $4EB4D4 ; ???
	; CCZ1 bad future
	warp_time_macro1  $52016C, $520170
	warp_time_macro2  $520436, $52043A
	warp_time_macro3  $520448, $52044C
	warp_time_macro4  $52049C, $5204A0
	score_tally_macro $52ABF2, $52ABE4
	score_tally_macro $52B4E2, $52B4D4 ; ???

	; CCZ2 present
	warp_time_macro1  $56019C, $5601A0
	warp_time_macro2  $560466, $56046A
	warp_time_macro3  $560478, $56047C
	warp_time_macro4  $5604CC, $5604D0
	; CCZ2 past
	warp_time_macro1  $5A0066, $5A006A
	warp_time_macro2  $5A0330, $5A0334
	warp_time_macro3  $5A0342, $5A0346
	warp_time_macro4  $5A0396, $5A039A
	; CCZ2 good future
	warp_time_macro1  $5E01A0, $5E01A4
	warp_time_macro2  $5E046A, $5E046E
	warp_time_macro3  $5E047C, $5E0480
	warp_time_macro4  $5E04D0, $5E04D4
	score_tally_macro $5EAA46, $5EAA38
	score_tally_macro $5EB4E2, $5EB4D4 ; ???
	; CCZ2 bad future
	warp_time_macro1  $620170, $620174
	warp_time_macro2  $62043A, $62043E
	warp_time_macro3  $62044C, $620450
	warp_time_macro4  $6204A0, $6204A4
	score_tally_macro $62AA16, $62AA08
	score_tally_macro $62B4E2, $62B4D4 ; ???

	; CCZ3 good future
	warp_time_macro1  $660190, $660194
	warp_time_macro2  $66045A, $66045E
	warp_time_macro3  $66046C, $660470
	warp_time_macro4  $6604C0, $6604C4
	score_tally_macro $66956E, $669560
	; CCZ3 bad future
	warp_time_macro1  $6A0158, $6A015C
	warp_time_macro2  $6A0422, $6A0426
	warp_time_macro3  $6A0434, $6A0438
	warp_time_macro4  $6A0488, $6A048C
	score_tally_macro $6A9536, $6A9528

	; TTZ1 present
	warp_time_macro1  $6E0312, $6E0316
	warp_time_macro2  $6E05DC, $6E05E0
	warp_time_macro3  $6E05EE, $6E05F2
	warp_time_macro4  $6E0642, $6E0646
	; TTZ1 past
	warp_time_macro1  $72022C, $720230
	warp_time_macro2  $7204F6, $7204FA
	warp_time_macro3  $720508, $72050C
	warp_time_macro4  $72055C, $720560
	; TTZ1 good future
	warp_time_macro1  $760258, $76025C
	warp_time_macro2  $760522, $760526
	warp_time_macro3  $760534, $760538
	warp_time_macro4  $760588, $76058C
	score_tally_macro $76775E, $767758
	; TTZ1 bad future
	warp_time_macro1  $7A0246, $7A024A
	warp_time_macro2  $7A0510, $7A0514
	warp_time_macro3  $7A0522, $7A0526
	warp_time_macro4  $7A0576, $7A057A
	score_tally_macro $7A774C, $7A7746

	; TTZ2 present
	warp_time_macro1  $7E02DA, $7E02DE
	warp_time_macro2  $7E05A4, $7E05A8
	warp_time_macro3  $7E05B6, $7E05BA
	warp_time_macro4  $7E060A, $7E060E
	; TTZ2 past
	warp_time_macro1  $820220, $820224
	warp_time_macro2  $8204EA, $8204EE
	warp_time_macro3  $8204FC, $820500
	warp_time_macro4  $820550, $820554
	; TTZ2 good future
	warp_time_macro1  $860244, $860248
	warp_time_macro2  $86050E, $860512
	warp_time_macro3  $860520, $860524
	warp_time_macro4  $860574, $860578
	score_tally_macro $867756, $867750
	; TTZ2 bad future
	warp_time_macro1  $8A0232, $8A0236
	warp_time_macro2  $8A04FC, $8A0500
	warp_time_macro3  $8A050E, $8A0512
	warp_time_macro4  $8A0562, $8A0566
	score_tally_macro $8A7744, $8A773E

	; TTZ3 good future
	warp_time_macro1  $8E021E, $8E0222
	warp_time_macro2  $8E04E8, $8E04EC
	warp_time_macro3  $8E04FA, $8E04FE
	warp_time_macro4  $8E054E, $8E0552
	score_tally_macro $8E6B4C, $8E6B46
	; TTZ3 bad future
	warp_time_macro1  $920232, $920236
	warp_time_macro2  $9204FC, $920500
	warp_time_macro3  $92050E, $920512
	warp_time_macro4  $920562, $920566
	score_tally_macro $926B60, $926B5A

	; QQZ1 present
	warp_time_macro1  $9602E4, $96029C
	warp_time_macro2  $9605AE, $960566
	warp_time_macro3  $9605C0, $960578
	warp_time_macro4  $960614, $9605CC
	; QQZ1 past
	warp_time_macro1  $9A01F0, $9A017A
	warp_time_macro2  $9A04BA, $9A0444
	warp_time_macro3  $9A04CC, $9A0456
	warp_time_macro4  $9A0520, $9A04AA
	; QQZ1 good future
	warp_time_macro1  $9E0110, $9E009A
	warp_time_macro2  $9E03DA, $9E0364
	warp_time_macro3  $9E03EC, $9E0376
	warp_time_macro4  $9E0440, $9E03CA
	score_tally_macro $9E7D42, $9E7CB2
	; QQZ1 bad future
	warp_time_macro1  $A20208, $A20192
	warp_time_macro2  $A204D2, $A2045C
	warp_time_macro3  $A204E4, $A2046E
	warp_time_macro4  $A20538, $A204C2
	score_tally_macro $A27E3A, $A27DAA

	; QQZ2 present
	warp_time_macro1  $A602FA, $A60272
	warp_time_macro2  $A605C4, $A6053C
	warp_time_macro3  $A605D6, $A6054E
	warp_time_macro4  $A6062A, $A605A2
	; QQZ2 past
	warp_time_macro1  $AA01F0, $AA0174
	warp_time_macro2  $AA04BA, $AA043E
	warp_time_macro3  $AA04CC, $AA0450
	warp_time_macro4  $AA0520, $AA04A4
	; QQZ2 good future
	warp_time_macro1  $AE0110, $AE0094
	warp_time_macro2  $AE03DA, $AE035E
	warp_time_macro3  $AE03EC, $AE0370
	warp_time_macro4  $AE0440, $AE03C4
	score_tally_macro $AE7B32, $AE7AA4
	; QQZ2 bad future
	warp_time_macro1  $B20208, $B2018C
	warp_time_macro2  $B204D2, $B20456
	warp_time_macro3  $B204E4, $B20468
	warp_time_macro4  $B20538, $B204BC
	score_tally_macro $B27C2A, $B27B9C

	; QQZ3 good future
	warp_time_macro1  $B5FF52, $B5FF56
	warp_time_macro2  $B6021C, $B60220
	warp_time_macro3  $B6022E, $B60232
	warp_time_macro4  $B60282, $B60286
	score_tally_macro $B66D2C, $B66D1E
	; QQZ3 bad future
	warp_time_macro1  $BA002E, $BA0032
	warp_time_macro2  $BA02F8, $BA02FC
	warp_time_macro3  $BA030A, $BA030E
	warp_time_macro4  $BA035E, $BA0362
	score_tally_macro $BA6E08, $BA6DFA

	; WWZ1 present
	warp_time_macro1  $BE03AA, $BE03AE
	warp_time_macro2  $BE058E, $BE0592
	warp_time_macro3  $BE05A0, $BE05A4
	warp_time_macro4  $BE05F4, $BE05F8
	; WWZ1 past
	warp_time_macro1  $C203D4, $C20358
	warp_time_macro2  $C205B8, $C2053C
	warp_time_macro3  $C205CA, $C2054E
	warp_time_macro4  $C2061E, $C205A2
	; WWZ1 good future
	warp_time_macro1  $C603F2, $C60376
	warp_time_macro2  $C605D6, $C6055A
	warp_time_macro3  $C605E8, $C6056C
	warp_time_macro4  $C6063C, $C605C0
	score_tally_macro $C68480, $C683FA
	; WWZ1 bad future
	warp_time_macro1  $CA039A, $CA039E
	warp_time_macro2  $CA057E, $CA0582
	warp_time_macro3  $CA0590, $CA0594
	warp_time_macro4  $CA05E4, $CA05E8
	score_tally_macro $CA8428, $CA8422

	; WWZ2 present
	warp_time_macro1  $CE0352, $CE0356
	warp_time_macro2  $CE0536, $CE053A
	warp_time_macro3  $CE0548, $CE054C
	warp_time_macro4  $CE059C, $CE05A0
	; WWZ2 past
	warp_time_macro1  $D20338, $D2033C
	warp_time_macro2  $D2051C, $D20520
	warp_time_macro3  $D2052E, $D20532
	warp_time_macro4  $D20582, $D20586
	; WWZ2 good future
	warp_time_macro1  $D6031A, $D6031E
	warp_time_macro2  $D604FE, $D60502
	warp_time_macro3  $D60510, $D60514
	warp_time_macro4  $D60564, $D60568
	score_tally_macro $D68070, $D6806A
	; WWZ2 bad future
	warp_time_macro1  $DA0342, $DA0346
	warp_time_macro2  $DA0526, $DA052A
	warp_time_macro3  $DA0538, $DA053C
	warp_time_macro4  $DA058C, $DA0590
	score_tally_macro $DA8098, $DA8092

	; WWZ3 good future
	warp_time_macro1  $DE0402, $DE0386
	warp_time_macro2  $DE05E6, $DE056A
	warp_time_macro3  $DE05F8, $DE057C
	warp_time_macro4  $DE064C, $DE05D0
	score_tally_macro $DE693C, $DE68B6
	; WWZ3 bad future
	warp_time_macro1  $E203AA, $E203AE
	warp_time_macro2  $E2058E, $E20592
	warp_time_macro3  $E205A0, $E205A4
	warp_time_macro4  $E205F4, $E205F8
	score_tally_macro $E268E4, $E268DE

	; SSZ1 present
	warp_time_macro1  $E5FFD6, $E5FF5A
	warp_time_macro2  $E602A0, $E60224
	warp_time_macro3  $E602B2, $E60236
	warp_time_macro4  $E60306, $E6028A
	; SSZ1 past
	warp_time_macro1  $E9FF8C, $E9FF90
	warp_time_macro2  $EA0256, $EA025A
	warp_time_macro3  $EA0268, $EA026C
	warp_time_macro4  $EA02BC, $EA02C0
	; SSZ1 good future
	warp_time_macro1  $EE0098, $EE001C
	warp_time_macro2  $EE0362, $EE02E6
	warp_time_macro3  $EE0374, $EE02F8
	warp_time_macro4  $EE03C8, $EE034C
	score_tally_macro $EE88EA, $EE885C
	; SSZ1 bad future
	warp_time_macro1  $F20008, $F2000C
	warp_time_macro2  $F202D2, $F202D6
	warp_time_macro3  $F202E4, $F202E8
	warp_time_macro4  $F20338, $F2033C
	score_tally_macro $F2885A, $F2884C

	; SSZ2 present
	warp_time_macro1  $F5FF56, $F5FF5A
	warp_time_macro2  $F60220, $F60224
	warp_time_macro3  $F60232, $F60236
	warp_time_macro4  $F60286, $F6028A
	; SSZ2 past
	warp_time_macro1  $F9FF8C, $F9FF90
	warp_time_macro2  $FA0256, $FA025A
	warp_time_macro3  $FA0268, $FA026C
	warp_time_macro4  $FA02BC, $FA02C0
	; SSZ2 good future
	warp_time_macro1  $FE0018, $FE001C
	warp_time_macro2  $FE02E2, $FE02E6
	warp_time_macro3  $FE02F4, $FE02F8
	warp_time_macro4  $FE0348, $FE034C
	score_tally_macro $FE8E1A, $FE8E0C
	; SSZ2 bad future
	warp_time_macro1  $1020008, $102000C
	warp_time_macro2  $10202D2, $10202D6
	warp_time_macro3  $10202E4, $10202E8
	warp_time_macro4  $1020338, $102033C
	score_tally_macro $1028E0A, $1028DFC

	; SSZ3 good future
	warp_time_macro1  $1060088, $106000C
	warp_time_macro2  $1060352, $10602D6
	warp_time_macro3  $1060364, $10602E8
	warp_time_macro4  $10603B8, $106033C
	score_tally_macro $10675F6, $1067568
	; SSZ3 bad future
	warp_time_macro1  $10A0016, $10A001A
	warp_time_macro2  $10A02E0, $10A02E4
	warp_time_macro3  $10A02F2, $10A02F6
	warp_time_macro4  $10A0346, $10A034A
	score_tally_macro $10A7584, $10A7576

	; MMZ1 present
	warp_time_macro1  $10DFDC4, $10DFDC8
	warp_time_macro2  $10E008E, $10E0092
	warp_time_macro3  $10E00A0, $10E00A4
	warp_time_macro4  $10E00F4, $10E00F8
	; MMZ1 past
	warp_time_macro1  $111FD66, $111FD6A
	warp_time_macro2  $1120030, $1120034
	warp_time_macro3  $1120042, $1120046
	warp_time_macro4  $1120096, $112009A
	; MMZ1 good future
	warp_time_macro1  $115FE7E, $115FE82
	warp_time_macro2  $1160148, $116014C
	warp_time_macro3  $116015A, $116015E
	warp_time_macro4  $11601AE, $11601B2
	score_tally_macro $1166C3C, $1166C2E
	; MMZ1 bad future
	warp_time_macro1  $119FFC6, $119FFCA
	warp_time_macro2  $11A0290, $11A0294
	warp_time_macro3  $11A02A2, $11A02A6
	warp_time_macro4  $11A02F6, $11A02FA
	score_tally_macro $11A6D84, $11A6D76

	; MMZ2 present
	warp_time_macro1  $11DFDB8, $11DFDBC
	warp_time_macro2  $11E0082, $11E0086
	warp_time_macro3  $11E0094, $11E0098
	warp_time_macro4  $11E00E8, $11E00EC
	; MMZ2 past
	warp_time_macro1  $1220048, $122004C
	warp_time_macro2  $1220312, $1220316
	warp_time_macro3  $1220324, $1220328
	warp_time_macro4  $1220378, $122037C
	; MMZ2 good future
	warp_time_macro1  $126010E, $1260112
	warp_time_macro2  $12603D8, $12603DC
	warp_time_macro3  $12603EA, $12603EE
	warp_time_macro4  $126043E, $1260442
	score_tally_macro $1268192, $1268184
	; MMZ2 bad future
	warp_time_macro1  $129FFE0, $129FFE4
	warp_time_macro2  $12A02AA, $12A02AE
	warp_time_macro3  $12A02BC, $12A02C0
	warp_time_macro4  $12A0310, $12A0314
	score_tally_macro $12A8064, $12A8056

	; MMZ3 good future
	warp_time_macro1  $12DFE76, $12DFE7A
	warp_time_macro2  $12E0140, $12E0144
	warp_time_macro3  $12E0152, $12E0156
	warp_time_macro4  $12E01A6, $12E01AA
	score_tally_macro $12E6C06, $12E6BF8
	; MMZ3 bad future
	warp_time_macro1  $131FEFE, $131FF02
	warp_time_macro2  $13201C8, $13201CC
	warp_time_macro3  $13201DA, $13201DE
	warp_time_macro4  $132022E, $1320232
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
