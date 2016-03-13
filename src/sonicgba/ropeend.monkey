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
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method doWhileRail:Void(p:PlayerObject, var2:Int) ' player:PlayerObject
			If (Not p.outOfControl) Then
				Return
			EndIf
			
			' Dynamic cast potential point of optimization.
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
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			collisionRect.setRect(x, y, 1024, 2560)
		End
End