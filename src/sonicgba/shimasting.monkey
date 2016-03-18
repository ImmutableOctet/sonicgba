Strict

Public

' Imports:
Private
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.gimmickobject
Public

' Classes:
Class ShimaSting Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 576
		
		Const ATTACK_HEIGHT:= COLLISION_HEIGHT
		Const OFFSET_HEIGHT:Int = 1024
		
		Const STATE_NONE:Int = 0
		Const STATE_TOP:Int = 1
		Const STATE_BOTTOM:Int = 2
		
		' Fields:
		Field attackState:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Self.attackState = STATE_NONE
			
			Self.posX = x
			Self.posY = y
		End
	Public	
		' Methods:
		Method logic:Void(x:Int, y:Int, frame:Int)
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Self.posX = x
			Self.posY = y
			
			If (frame = 0) Then
				Self.attackState = STATE_TOP
			ElseIf (frame = 4) Then
				Self.attackState = STATE_BOTTOM
			Else
				Self.attackState = STATE_NONE
			End
			
			refreshCollisionRect(Self.posX, Self.posY)
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawCollisionRect(graphics)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player And Self.attackState <> 0) Then
				p.beHurt() ' player
			End
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.attackState <> 0) Then
				Local rx:= (x - (COLLISION_WIDTH/2))
				Local ry:= y
				
				If (Self.attackState = STATE_TOP) Then
					ry -= -1600
				Else
					ry += OFFSET_HEIGHT
				EndIf
				
				Self.collisionRect.setRect(rx, ry, COLLISION_WIDTH, COLLISION_HEIGHT) ' ATTACK_HEIGHT
			Else
				Self.collisionRect.setRect(x, y, 1, 1)
			EndIf
		End
End