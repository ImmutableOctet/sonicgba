Strict

Public

' Imports:
Private
	'Import mflib.bpdef
	Import sonicgba.sonicdef
Public

' Constant variable(s):
Global RING_TARGET:Int[][] = [[60, 120], [70, 140], [80, 160], [80, 160], [90, 180], [90, 180], [100, 200]] ' Const

Global STAGE_ID_TO_SPECIAL_ID:Int[] = [0, 0, 1, 1, 2, 2, 3, 4, 5, 5, 6, 6] ' Const

' Interfaces:
Interface SSDef Extends SonicDef
	Public
		' Constant variable(s):
		Const PLAYER_MOVE_HEIGHT:Int = 240
		Const PLAYER_MOVE_WIDTH:Int = 300
		
		Const PLAYER_VELOCITY_DASH:Int = 6
		Const PLAYER_VELOCITY_STANDARD:Int = 4
		
		Const SPECIAL_ANIMATION_PATH:String = "/animation/special"
		Const SPECIAL_FILE_PATH:String = "/special_res"
		
		Const SSOBJ_RING_ID:Int = 0
		Const SSOBJ_TRIC_ID:Int = 1
		Const SSOBJ_BNBK_ID:Int = 2
		Const SSOBJ_BNGO_ID:Int = 3
		Const SSOBJ_BNLU_ID:Int = 4
		Const SSOBJ_BNRU_ID:Int = 5
		Const SSOBJ_BNLD_ID:Int = 6
		Const SSOBJ_BNRD_ID:Int = 7
		Const SSOBJ_CHAO_ID:Int = 8
		Const SSOBJ_BOMB_ID:Int = 9
		Const SSOBJ_CHECKPT:Int = 10
		Const SSOBJ_GOAL:Int = 11
		Const SSOBJ_NUM:Int = 12
End