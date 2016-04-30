Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.basicrollplatformspeed
Public

' Classes:
Class RollPlatformSpeedA Extends BasicRollPlatformSpeed
	Public
		' Constant variable(s):
		Const DEGREE_VELOCITY:Int = 230
		
		' Global variable(s):
		Global degree:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
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