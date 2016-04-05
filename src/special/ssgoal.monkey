Strict

Public

' Imports:
Private
	Import special.ssusableobject
Public

' Classes:
Class SSGoal Extends SSUsableObject
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int)
			Super.New(SSOBJ_GOAL, x, y, z)
		End
		
		' Methods:
		Method onUse:Void(collisionObj:SpecialObject)
			player.setGoal()
		End
End