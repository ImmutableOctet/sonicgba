Strict

Public

' Imports:
Import sonicgba.gimmickobject
Import sonicgba.playerobject
Import sonicgba.ropestart

' Classes:
Class RopeEnd Extends GimmickObject
	Protected
		' Constructor(s):
		Method New(var1:Int, var2:Int, var3:Int, var4:Int, var5:Int, var6:Int, var7:Int)
			Super.New(var1, var2, var3, var4, var5, var6, var7)
		End
	Public
		' Methods:
		Method doWhileRail:Void(p:PlayerObject, var2:Int) ' player:PlayerObject
			If (Not p.outOfControl) Then
				Return
			EndIf
			
			' Dynamic cast; potential point of optimization.
			Local start:= RopeStart(p.outOfControlObject)
			
			' If 'start' is available, mark the start point:
			If (start <> Null) Then
				start.posX = Self.posX
				start.posY = Self.posY
			EndIf
			
			' This could probably be optimized, but it works well enough:
			If (p.getFootPositionX() < Self.posX) Then
				p.setFootPositionX(Self.posX)
			EndIf
			
			p.setFootPositionY(Self.collisionRect.y1)
			
			p.outOfControl = False
			p.setCollisionState(1)
			p.stopMove()
			p.collisionChkBreak = True
			p.railing = False
		End
		
		Method refreshCollisionRect:Void(var1:Int, var2:Int)
			collisionRect.setRect(var1, var2, 1024, 2560)
		End
End