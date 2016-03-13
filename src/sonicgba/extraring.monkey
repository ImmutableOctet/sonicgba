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
			Super.New(var1, var2, var3, var4, var5, var6, var7)
		End
	Public
		' Methods:
		Method GetGravity:Int()
			Return (GRAVITY Shr 2)
		End
End