Strict

Public

' Imports:
Private
	Import special.usableobject
Public

' Classes:
Class SSCheckPoint Extends UsableObject
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int)
			Super.New(SSOBJ_CHECKPT, x, y, z)
		End
		
		' Methods:
		Method onUse:Void(collisionObj:SpecialObject)
			player.setCheckPoint()
		End
End