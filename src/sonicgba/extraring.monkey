Strict

Public

' Imports:
Private
	Import regal.typetool
	
	Import sonicgba.moveringobject
Public

' Classes:
Class ExtraRing Extends MoveRingObject
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, vx:Int, vy:Int, layer:Int, appearTime:Long, unTouchCount:Int)
			Super.New(x, y, vx, vy, layer, appearTime, unTouchCount)
		End
	Public
		' Methods:
		Method GetGravity:Int()
			Return (GRAVITY / 4)
		End
End