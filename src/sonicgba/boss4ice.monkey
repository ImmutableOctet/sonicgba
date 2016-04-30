Strict

Public

' Friends:
Friend sonicgba.platform
Friend sonicgba.gimmickobject
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.boss4

' Imports:
Private
	Import sonicgba.sonicdef
	Import sonicgba.platform
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import sonicgba.boss4
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' A type of ice platform spawned by the 4th boss.
Class Boss4Ice Extends Platform ' Implements SonicDef...?
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1536
		Const COLLISION_HEIGHT:Int = 2112
		Const COLLISION_OFFSET_Y:Int = 192
		
		Const DRAW_OFFSET_Y:Int = 2112
		Const STAND_OFFSET:Int = 192
		
		' Global variable(s):
		Global isEnd:Bool
	Private
		' Global variable(s):
		Global iceImage:MFImage
		
		' Fields:
		Field boss4:Boss4
		
		Field iceDownCounter:Int
		Field drop_vel:Int
		Field endPos:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, vel:Int, endPosY:Int, boss:Boss4)
			Super.New(GIMMICK_BOSS4_ICE, x, y, 0, 0, 0, 0)
			
			If (iceImage = Null) Then
				iceImage = MFImage.createImage("/gimmick/boss4_ice.png")
			EndIf
			
			Self.iceDownCounter = 0
			
			Self.drop_vel = vel
			Self.endPos = endPosY
			
			Self.IsDisplay = True
			
			isEnd = False
			
			Self.boss4 = boss
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			iceImage = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Self.IsDisplay) Then
				Self.iceDownCounter += 1
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				If (player.isFootOnObject(Self)) Then
					Self.offsetY = STAND_OFFSET
				Else
					Self.offsetY = 0
				EndIf
				
				If (Self.boss4.dead Or Self.posY < (StageManager.getWaterLevel() Shl 6)) Then
					' Magic number: 6
					Self.posY += (Self.drop_vel * 6)
				Else
					Self.posY += Self.drop_vel
				EndIf
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Self.IsDisplay) Then
				drawInMap(g, iceImage, Self.posX, (Self.posY + DRAW_OFFSET_Y) + Self.offsetY, BOTTOM|HCENTER)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Self.IsDisplay And Not p.isFootOnObject(Self)) Then
				Select (direction)
					Case DIRECTION_DOWN, DIRECTION_LEFT, DIRECTION_RIGHT
						If (p.getMoveDistance().y <= 0) Then
							p.beStop(Self.collisionRect.y0, direction, Self)
						ElseIf (p.getCollisionRect().y1 < Self.collisionRect.y1) Then
							p.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
						EndIf
						
						Self.used = True
					Case DIRECTION_NONE
						If (p.getMoveDistance().y > 0 And p.getCollisionRect().y1 < Self.collisionRect.y1) Then
							p.beStop(Self.collisionRect.y0, 1, Self)
							
							Self.used = True
						EndIf
					Default ' DIRECTION_UP
						' This behavior will likely change in the future:
						If (p <> player) Then
							Return
						EndIf
						
						If (Self.boss4.isNoneIce) Then
							p.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
						Else
							p.beHurt()
						EndIf
				End Select
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((x - (COLLISION_WIDTH / 2)), (Self.offsetY + y), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method chkDestroy:Bool()
			Return (Not isInCamera() Or isFarAwayCamera() Or (Self.posY > Self.endPos) Or Self.boss4.isNoneIce)
		End
End