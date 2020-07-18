; >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Equates section - Names for variables.

; ---------------------------------------------------------------------------
; Constants that can be used instead of hard-coded IDs for various things.
; The "id" function allows to remove elements from an array/table without having
; to change the IDs everywhere in the code.

cur_zone_id := 0 ; the zone ID currently being declared
cur_zone_str := "0" ; string representation of the above

; macro to declare a zone ID
; this macro also declares constants of the form zone_id_X, where X is the ID of the zone in stock Sonic CD
; in order to allow level offset tables to be made dynamic
zoneID macro zoneID,{INTLABEL}
__LABEL__ = zoneID
zone_id_{cur_zone_str} = zoneID
cur_zone_id := cur_zone_id+1
cur_zone_str := "\{cur_zone_id}"
    endm

; Zone IDs. These MUST be declared in the order in which their IDs are in stock Sonic CD, otherwise zone offset tables will screw up
palmtree_panic_zone zoneID	$00
collision_chaos_zone zoneID	$01
tidal_tempest_zone zoneID	$02
quartz_quadrant_zone zoneID	$03
wacky_workbench_zone zoneID	$04
stardust_speedway_zone zoneID	$05
metallic_madness_zone zoneID	$06

; set the number of zones
no_of_zones = cur_zone_id

; Zone and act IDs
palmtree_panic_zone_act_1 =	(palmtree_panic_zone<<8)|$00
palmtree_panic_zone_act_2 =	(palmtree_panic_zone<<8)|$01
palmtree_panic_zone_act_3 =	(palmtree_panic_zone<<8)|$02
collision_chaos_zone_act_1 =	(collision_chaos_zone<<8)|$00
collision_chaos_zone_act_2 =	(collision_chaos_zone<<8)|$01
collision_chaos_zone_act_3 =	(collision_chaos_zone<<8)|$02
tidal_tempest_zone_act_1 =	(tidal_tempest_zone<<8)|$00
tidal_tempest_zone_act_2 =	(tidal_tempest_zone<<8)|$01
tidal_tempest_zone_act_3 =	(tidal_tempest_zone<<8)|$02
quartz_quadrant_zone_act_1 =	(quartz_quadrant_zone<<8)|$00
quartz_quadrant_zone_act_2 =	(quartz_quadrant_zone<<8)|$01
quartz_quadrant_zone_act_3 =	(quartz_quadrant_zone<<8)|$02
wacky_workbench_zone_act_1 =	(wacky_workbench_zone<<8)|$00
wacky_workbench_zone_act_2 =	(wacky_workbench_zone<<8)|$01
wacky_workbench_zone_act_3 =	(wacky_workbench_zone<<8)|$02
stardust_speedway_zone_act_1 =	(stardust_speedway_zone<<8)|$00
stardust_speedway_zone_act_2 =	(stardust_speedway_zone<<8)|$01
stardust_speedway_zone_act_3 =	(stardust_speedway_zone<<8)|$02
metallic_madness_zone_act_1 =	(metallic_madness_zone<<8)|$00
metallic_madness_zone_act_2 =	(metallic_madness_zone<<8)|$01
metallic_madness_zone_act_3 =	(metallic_madness_zone<<8)|$02

; ---------------------------------------------------------------------------
; Time zones

past    = 0
present = 1
future  = 2

; ---------------------------------------------------------------------------
; Good future flag

bad_future  = 0
good_future = 1

; ---------------------------------------------------------------------------
; Files ID

R11A_file =		1
R11B_file =		2
R11C_file =		3
R11D_file =		4
unk_file_5 =		5
level_select_file =	6
R12A_file =		7
R12B_file =		8
R12C_file =		9
R12D_file =		$A
title_screen_file =	$B
warp_file =		$C
time_attack_file =	$D
R4_demo_file =		$24
R8_demo_file =		$25
sound_test_file =	$26
R31A_file =		$28
R31B_file =		$29
R31C_file =		$2A
R31D_file =		$2B
R32A_file =		$2C
R32B_file =		$2D
R32C_file =		$2E
R32D_file =		$2F
R33C_file =		$30
R33D_file =		$31
R13C_file =		$32
R13D_file =		$33
R41A_file =		$34
R41B_file =		$35
R41C_file =		$36
R41D_file =		$37
R42A_file =		$38
R42B_file =		$39
R42C_file =		$3A
R42D_file =		$3B
R43C_file =		$3C
R43D_file =		$3D
R51A_file =		$3E
R51B_file =		$3F
R51C_file =		$40
R51D_file =		$41
R52A_file =		$42
R52B_file =		$43
R52C_file =		$44
R52D_file =		$45
R53C_file =		$46
R53D_file =		$47
R61A_file =		$48
R61B_file =		$49
R61C_file =		$4A
R61D_file =		$4B
R62A_file =		$4C
R62B_file =		$4D
R62C_file =		$4E
R62D_file =		$4F
R63C_file =		$50
R63D_file =		$51
R71A_file =		$52
R71B_file =		$53
R71C_file =		$54
R71D_file =		$55
R72A_file =		$56
R72B_file =		$57
R72C_file =		$58
R72D_file =		$59
R73C_file =		$5A
R73D_file =		$5B
R81A_file =		$5C
R81B_file =		$5D
R81C_file =		$5E
R81D_file =		$5F
R82A_file =		$60
R82B_file =		$61
R82C_file =		$62
R82D_file =		$63
R83C_file =		$64
R83D_file =		$65
special_stage_file =	$75
d_a_garden_file =	$81
R1_demo_file =		$84
visual_mode_file =	$85
unk_file_86 =		$86
unk_file_87 =		$87
unk_file_88 =		$88
unk_file_89 =		$89
unk_file_8A =		$8A
unk_file_8B =		$8B
unk_file_8C =		$8C
player_name_file =	$8D
ram_data_file =		$8E
bad_ending_file =	$93
good_ending_file =	$94
secret1_file =		$C8 ; Infinite fun
secret2_file =		$C9 ; Hidden credits
secret3_file =		$CA ; DJ scene
secret4_file =		$CB ; See you next game
secret5_file =		$CC ; Tribute to Batman
secret6_file =		$CD ; Chibi Sonic
team_records_file =	$CE
pencil_test_file =	$D4
intro_video_file =	$D7
comin_soon_file =	$D8

; ---------------------------------------------------------------------------
; RAM variables - General

RAM_Start =			$FFFF0000
V_Int_addr =			$FFFFFD08 ; 4 bytes
H_Int_addr =			$FFFFFD0E ; 4 bytes
FramesCounter =			$FFFFFA44 ; Used in title screen, special stages, but NOT in levels

; ---------------------------------------------------------------------------
; RAM variables related to IPX___.MMD file

IPX_RAM_Start =			$00FF0000 ; Location where the executed code starts in the RAM.

; RAM variables in between executed code. Looks like some static variables...
; They shall stay at their exact address because they are referenced by other files which
; are not disassembled yet!
IPX_static_GoodFuture_Array =	$00FF03CA
IPX_static_TimeStones_Array =	$00FF03CB
IPX_static_unk_0BE2 =		$00FF0BE2
IPX_static_LoopVideoFlag =	$00FF0BE3
IPX_static_unk_0DA6 =		$00FF0DA6

; RAM variables only for Sonic CD Warped
IPX_EggMachine_ActFlag =	$00FF0EFA ; For the current act only. Bit 0 is set when the Eggman machine
				          ; was destroyed, and the player exits the past time zone
					  ; (or finish the act).
IPX_EggMachine_ZoneFlags =	$00FF0EFC ; Array of Eggman machine flags for the current zone only:
				          ; bit 0 = act 1, bit 1 = act 2
IPX_PreviousTimeZone =		$00FF0EFE ; Previous time zone saved before a warp
IPX_PreviousGameMode =		$00FF0EFF ; Bit is set following previous game mode: bit 0 = title screen
				          ; bit 1 = level / special stage, bit 2 = time zone warp

; Maximum code size of IPX___.MMD file is $F00.
; This is where global RAM variables starts.
IPX_unk_0F00 =			$00FF0F00
IPX_unk_0F01 =			$00FF0F01
IPX_CurrentZoneInSave =		$00FF0F02 ; Copy of current zone from saved game
IPX_unk_0F10 =			$00FF0F10
IPX_unk_0F14 =			$00FF0F14
IPX_unk_0F16 =			$00FF0F16
IPX_unk_0F18 =			$00FF0F18
IPX_unk_0F19 =			$00FF0F19
IPX_GoodFuture_Array =		$00FF0F1A ; 1 bit set for each 7 zones completed in good future
IPX_unk_0F1C =			$00FF0F1C
IPX_unk_0F1D =			$00FF0F1D
IPX_unk_0F1F =			$00FF0F1F
IPX_TimeStones_Array =		$00FF0F20 ; 1 bit set per obtained time stone
IPX_NextSpecialStage =		$00FF0F21 ; Next Special Stage number to load
IPX_unk_0F22 =			$00FF0F22
IPX_unk_0F24 =			$00FF0F24
IPX_unk_0F25 =			$00FF0F25
IPX_CurrentZoneAndAct =		$00FF1506 ; Current zone and act (2 bytes)
IPX_CurrentAct =		$00FF1507 ; Current act
IPX_LifeCount =			$00FF1508 ; Extra lives counter
IPX_unk_1512 =			$00FF1512
IPX_unk_1514 =			$00FF1514
IPX_unk_1518 =			$00FF1518
IPX_unk_151C =			$00FF151C
IPX_CurrentTimeZone =		$00FF152E ; Current time zone
IPX_GoodFuture_ActFlag =	$00FF156A ; For the current act only: 0 = bad future, 1 = good future
IPX_unk_156D =			$00FF156D
IPX_SpecialStageFlag =		$00FF156E ; If 1, the special stage has to be loaded at the end of the act.
IPX_unk_1577 =			$00FF1577
IPX_unk_1580 =			$00FF1580
IPX_unk_158E =			$00FF158E
IPX_GoodFuture_ZoneFlags =	$00FF1590 ; Array of good future flags for the current zone only:
				          ; bit 0 = act 1, bit 1 = act 2
IPX_FramesCounter_Level =	$00FF190C ; Used only in levels

; Variables in RAM can only be declared up to this point.
; This is where some other executed code from another loaded file starts.
IPX_unk_2000 =			$00FF2000

; ---------------------------------------------------------------------------
; Loaded file area

MMD_unk_200000 =		$00200000
MMD_CodeLoadAddr =		$00200002
MMD_CodeSize =			$00200006
MMD_CodeStartAddr =		$00200008
MMD_CodeHIntAddr =		$0020000C
MMD_CodeVIntAddr =		$00200010
MMD_CodeLocationInFile =	$00200100

; ---------------------------------------------------------------------------
; BRAM area

BRAM_CurrentZone =		$002002A4
BRAM_unk_2002A5 =		$002002A5
BRAM_unk_2002A6 =		$002002A6
BRAM_GoodFuture_Array =		$002002A7
BRAM_unk_2002A8 =		$002002A8
BRAM_NextSpecialStage =		$002002AC
BRAM_TimeStones_Array =		$002002AD

; ---------------------------------------------------------------------------
; VDP addresses

VDP_data_port =			$00C00000 ; (8=r/w, 16=r/w)
VDP_control_port =		$00C00004 ; (8=r/w, 16=r/w)
PSG_input =			$00C00011

; ---------------------------------------------------------------------------
; Z80 addresses

Z80_RAM =			$00A00000 ; start of Z80 RAM
Z80_RAM_End =			$00A02000 ; end of non-reserved Z80 RAM
Z80_Bus_Request =		$00A11100
Z80_Reset =			$00A11200

Security_Addr =			$00A14000

; ---------------------------------------------------------------------------
; I/O Area

IO_unk_A01C0A =			$00A01C0A

IO_unk_A12000 =			$00A12000
IO_unk_A12003 =			$00A12003
IO_unk_A12010 =			$00A12010
IO_SpecialStageToLoad =		$00A12013 ; Special Stage number to load
IO_TimeStones_Array =		$00A1201A ; 1 bit set per obtained time stone
IO_SpecialStageLockouts =	$00A1201B ; Array of bits that controls the way the Special Stage is working.
				          ; This controls the display of the score tally, if a time stone
					  ; is granted as a reward or not, and the pause button.
IO_unk_A12020 =			$00A12020
