Strict

Public

' Imports:
Import regal.typetool

Import sonicgba.moveringobject

' Classes:
Class ExtraRing Extends MoveRingObject
	Protected
		' Constructor(s):
		Method New(var1:Int, var2:Int, var3:Int, var4:Int, var5:Int, var6:Long, var7:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method GetGravity:Int()
			Return (GRAVITY Shr 2)
		End
End