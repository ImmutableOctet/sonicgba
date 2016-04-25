Strict

Public

' Imports:
Private
	Import sonicgba.basicrollplatformspeed
	
	Import sonicgba.playerknuckles
Public

' Classes:
Class RollPlatformSpeedB Extends BasicRollPlatformSpeed
	Public
		' Constant variable(s):
		Const DEGREE_VELOCITY:Int = 102
		
		' Global variable(s):
		Global degree:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
		
		' Methods:
		Method onSetOffsetY2:Int(value:Int)
			If (player.isFootOnObject(Self) And (player.getCharacterID() = CHARACTER_KNUCKLES)) Then
				' Optimization potential; dynamic cast.
				Local knuckles:= PlayerKnuckles(player)
				
				If (knuckles <> Null) Then
					knuckles.setFloating(False)
				EndIf
			EndIf
			
			Return value
		End
	Public
		' Functions:
		Function staticLogic:Void()
			degree += DEGREE_VELOCITY
			degree Mod= MAX_DEGREE_SCALED
		End
		
		' Methods:
		Method logic:Void()
			logic_BasicRollPlatformSpeed(degree)
		End
End