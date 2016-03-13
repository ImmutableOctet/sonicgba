Strict

Public

' Imports:
Import sonicgba.gimmickobject
Import sonicgba.playerobject
Import sonicgba.ropestart

' Classes:
Class RopeTurn Extends GimmickObject
	Protected
		' Constructor(s):
		Method New(var1:Int, var2:Int, var3:Int, var4:Int, var5:Int, var6:Int, var7:Int)
			Super.New(var1, var2, var3, var4, var5, var6, var7)
		End
	Public
		' Methods:
		Method doWhileNoCollision:Void()
			Self.used = False
		End
		
		Method doWhileRail:Void(var1:PlayerObject, var2:Int)
			' Likely a dynamic cast; potential performance hit.
			' (Potentially unsafe usage if that's true)
			Local var3:= RopeStart(var1.outOfControlObject)
			
			If (var3.degree > 90) Then
				var3.posX = Self.posX
				var3.posY = Self.posY
				
				var3.turn()
				
				Self.used = True
				
				Return
			EndIf
		End
		
		' The 'var1' and 'var2' arguments are likely the position of this object.
		Method refreshCollisionRect:Void(var1:Int, var2:Int)
			' Most likely centered with a width of 1024, and a height of 2560.
			' Not completely sure, but it seems like a safe bet.
			collisionRect.setRect(var1 - 512, var2, 1024, 2560)
			
			Return
		End
End