Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.ropestart

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.ropestart
Public

' Classes:
Class RopeEnd Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= RopeStart.COLLISION_WIDTH
		Const COLLISION_HEIGHT:= RopeStart.COLLISION_HEIGHT
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method doWhileRail:Void(player:PlayerObject, direction:Int) ' player:PlayerObject
			If (Not player.outOfControl) Then
				Return
			EndIf
			
			' Dynamic cast; potential point of optimization.
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
			collisionRect.setRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT) ' width, height
		End
End