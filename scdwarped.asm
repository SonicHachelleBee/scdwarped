; Sonic CD Warped disassembled binary

; Sonic Hachelle-Bee, 2020
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
padToPowerOfTwo = 0
;	| If 1, pads the end of the BIN file to the next power of two bytes
; 
zeroOffsetOptimization = 0
;	| If 1, makes a handful of zero-offset instructions smaller
;
removeJmpTos = 1 
;	| Not used in Sonic CD so far
;	| If 1, many unnecessary JmpTos are removed, improving performance
;
addsubOptimize = 1
;	| Not used in Sonic CD so far
;	| If 1, some add/sub instructions are optimized to addq/subq
;
relativeLea = 1
;	| If 1, makes some instructions use pc-relative addressing, instead of absolute long
;

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; This macro defines a special BINCLUDE which takes only a part of a binary file.
; It uses the original Sonic CD binaries from where to copy data (until a full disassembly is made)
BINCLUDE_SCD macro startaddr,endaddr
    if gameRegion=0
	BINCLUDE "Sonic The Hedgehog CD (J)/Sonic The Hedgehog CD (J).bin",startaddr,endaddr-(startaddr)
    endif
    if gameRegion=1
	BINCLUDE "Sonic The Hedgehog CD (U)/Sonic The Hedgehog CD (U).bin",startaddr,endaddr-(startaddr)
    endif
    if gameRegion=2
	BINCLUDE "Sonic The Hedgehog CD (E)/Sonic The Hedgehog CD (E).hacked.bin",startaddr,endaddr-(startaddr)
    endif
	endm

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; AS-specific macros and assembler settings
	CPU 68000
	include "scd.macrosetup.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.
	include "scd.constants.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Simplifying macros and functions
	include "scd.macros.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; start of BIN file
	BINCLUDE_SCD $0,$16F5220

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; IPX___.MMD file
	include "scd.IPX___.hacked.asm"

; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Remaining parts of BIN file
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

	org	$16F6350
	BINCLUDE_SCD $16F6350,$22C68B3F

; ===========================================================================
; end of BIN file
	if padToPowerOfTwo && (*)&(*-1)
		cnop	-1,2<<lastbit(*-1)
		dc.b	0
paddingSoFar	:= paddingSoFar+1
	else
		even
	endif
	if MOMPASS=2
		; "About" because it will be off by the same amount that Size_of_Snd_driver_guess is incorrect (if you changed it), and because I may have missed a small amount of internal padding somewhere
		message "BIN size is $\{*} bytes (\{*/1024.0} kb). About $\{paddingSoFar} bytes are padding. "
	endif

BIN_End:
	END	   
