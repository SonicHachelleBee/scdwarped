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
gameRegion = 2
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

	BINCLUDE_ISO 0,$13FD800

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
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

	org	$13FE800

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Remaining parts of ISO file
;
; Work here is done directly by editing the bytes in hexadecimal with an hex editor.
;
; -----------------------------------------------------------------------------
; Make the warp time shorter:
;
; The warp time functions with a counter going up at $FFFFF786 when the stars first surrounds Sonic.
; At specific times, an action is taken.
; You have to modify each of these times to influence the time required to warp.
; Search for the following occurences. 73 occurences to replace each time (70 acts + 3 demo).
;
; 0C41005A6412: Time required ($5A) for the time sign to start blinking.
; 0C4100D2654E: Time required ($D2) for the camera to stop moving.
; 0C7800D2F786: Time required ($D2) for Sonic to disappear, leaving only the stars.
; 0C4100E6650C: Time required ($E6) for ending the current level and begining the warp.
;
; Proposed values for the hack are: $5A, $74, $74 and $88.

    if gameRegion=0
	BINCLUDE_ISO $13FE800,$6B52800
    endif
    if gameRegion=1
	BINCLUDE_ISO $13FE800,$7409800
    endif
    if gameRegion=2
	BINCLUDE_ISO $13FE800,$6B9C824
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
