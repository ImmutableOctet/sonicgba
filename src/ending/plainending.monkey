Strict

Public

' Imports:
Import ending.baseending

' Classes:

' Another custom/extended base-class for "ending types".
' In particular, this class is for shared code between 'NormalEnding' and 'SpecialEnding'.
Class PlainEnding Extends BaseEnding Abstract
	Protected
		' Constant variable(s):
		Global CHARACTER_ANIMATION_NAME:String[] = ["/sonic_ed", "/tails_ed", "/knuckles_ed", "/amy_ed"] ' Const
		Global ANIMATION_LOOP:Bool[] = [True, False, True, False, True, True, False, True] ' Const
		
		Const PLAYER_OFFSET_TO_PLANE_X:Int = 10 ' 11
		Const PLAYER_OFFSET_TO_PLANE_Y:Int = 34
		
		Global PLANE_START_X:Int = (SCREEN_WIDTH + 70) ' Const
		
		' Fields:
		Field characterID:Int
		Field playerActionID:Int
		
		Field characterDrawer:AnimationDrawer
		
		Field pilotSmile:Bool
End