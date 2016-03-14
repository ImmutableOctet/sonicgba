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
		Method doWhileRail:Void(player:PlayerObject, value:Int) ' player:PlayerObject
			If (Not player.outOfControl) Then
				Return
			EndIf
			
			' Dynamic cast potential point of optimization.
			Local start:= RopeStart(player.outOfControlObject)
			
			' If 'start' is available, mark the start point:
			If (start <> Null) Then
				start.posX = Self.posX
				start.posY = Self.posY
			EndIf
			
			' This could probably be optimized, but it works well enough:
			If (player.getFootPositionX() < Self.posX) Then
				player.setFootPositionX(Self.posX)
			EndIf
			
			player.setFootPositionY(Self.collisionRect.y1)
			
			player.outOfControl = False
			player.setCollisionState(1)
			player.stopMove()
			player.collisionChkBreak = True
			player.railing = False
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			collisionRect.setRect(x, y, 1024, 2560)
		End
End