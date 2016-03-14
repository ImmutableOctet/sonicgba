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
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method doWhileNoCollision:Void()
			Self.used = False
		End
		
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			' Dynamic cast; potential performance hit.
			Local start:= RopeStart(player.outOfControlObject)
			
			If (start <> Null) Then
				If (start.degree > 90) Then
					start.posX = Self.posX
					start.posY = Self.posY
					
					start.turn()
					
					Self.used = True
					
					Return
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Most likely centered with a width of 1024, and a height of 2560.
			' Not completely sure, but it seems like a safe bet.
			collisionRect.setRect(x - 512, y, 1024, 2560)
			
			Return
		End
End