Strict

Public

' Imports:
Import lib.animation
Import lib.animationdrawer
Import lib.myrandom
Import lib.soundsystem
Import lib.constutil

Import sonicgba.sonicdef

Import state.state

Import com.sega.mobile.framework.device.mfgraphics
Import com.sega.mobile.framework.device.mfimage

Import regal.typetool

' Classes:

' Custom/extended base-class for all "ending types".
' This is in contrast to 'PlainEnding', which has shared code specifically for 'NormalEnding' and 'SpecialEnding'.
Class BaseEnding Extends State Implements SonicDef Abstract
	Protected
		' Constant variable(s):
		Const ENDING_ANIMATION_PATH:String = "/animation/ending"
		
		' These may end up being moved to 'PlainEnding'.
		Const PILOT_SONIC:Int = 0
		Const PILOT_TAILS:Int = 2
		
		' States:
		Const STATE_INIT:Int = 0
		
		' Functions:
		Function getPilot:Int(characterID:Int)
			Return PickValue((characterID = CHARACTER_SONIC), PILOT_TAILS, PILOT_SONIC)
		End
		
		' Fields:
		Field state:Int
		
		Field count:Int
		
		Field pilotHeadID:Int
		
		Field planeX:Int
		Field planeY:Int
End