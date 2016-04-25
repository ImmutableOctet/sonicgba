Strict

Public

' Imports:
Private
	Import lib.soundsystem
	
	Import sonicgba.effect
	Import sonicgba.gimmickobject
	Import sonicgba.mapobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Subeyuka Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 1920
		
		Const DRAW_OFFSET_Y:Int = 64
		
		' Global variable(s):
		Global frame:Int
		Global image:MFImage
		
		' Fields:
		Field dead:Bool
		Field moving:Bool
		
		Field mapObj:MapObject
		
		Field deadCount:Int
		Field flyCount:Int
		
		Field startPosX:Int
		Field startPosY:Int
		
		Field tmpSpeedX:Int
		
		Field tmpX:Int
		Field tmpY:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.flyCount = 0
			
			Self.tmpSpeedX = 0
			
			Self.tmpX = 0
			Self.tmpY = 0
			
			If (image = Null) Then
				If (StageManager.getCurrentZoneId() <> 4) Then
					image = MFImage.createImage("/gimmick/subeyuka_5.png")
				Else
					image = MFImage.createImage("/gimmick/subeyuka_4.png")
				EndIf
			EndIf
			
			Self.startPosX = Self.posX
			Self.startPosY = Self.posY
			
			Self.moving = False
			
			Self.mapObj = New MapObject(Self.startPosX, Self.startPosY, 0, 0, Self, Self.iLeft)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, image, Self.posX, (Self.posY + DRAW_OFFSET_Y), BOTTOM|HCENTER)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.dead) Then
				Select (direction)
					Case DIRECTION_DOWN
						If (Not Self.moving) Then
							Self.moving = True
							
							Self.mapObj.setPosition(Self.posX, Self.posY, 0, 0, Self)
							
							#Rem
								If (StageManager.getCurrentZoneId() <> 4) Then
									Self.mapObj.setCrashCount(2)
								Else
									Self.mapObj.setCrashCount(2)
								EndIf
							#End
							
							Self.mapObj.setCrashCount(2)
							
							If (Not (StageManager.getCurrentZoneId() = 4 Or StageManager.getCurrentZoneId() = 5)) Then
								soundInstance.playSe(SoundSystem.SE_198_01)
							EndIf
							
							isGotRings = False
							
							frame = 1
						EndIf
						
						player.beStop(0, direction, Self)
					Case DIRECTION_NONE
						If (player.getMoveDistance().y > 0 And player.getCollisionRect().y1 < Self.collisionRect.y1) Then
							If (Not Self.moving) Then
								Self.moving = True
								
								Self.mapObj.setPosition(Self.posX, Self.posY, 0, 0, Self)
								Self.mapObj.setCrashCount(2)
								
								If (Not (StageManager.getCurrentZoneId() = 4 Or StageManager.getCurrentZoneId() = 5)) Then
									soundInstance.playSe(SoundSystem.SE_198_01)
								EndIf
								
								isGotRings = False
								
								frame = 1
							EndIf
							
							player.beStop(0, DIRECTION_DOWN, Self)
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method logic:Void()
			If (Self.moving And Not Self.dead) Then
				If ((StageManager.getCurrentZoneId() = 4 Or StageManager.getCurrentZoneId() = 5) And Self.iLeft = 1 And Self.mapObj.getCurrentCrashCount() < 2) Then
					Self.flyCount += 1
					
					' Magic number: 4
					If (Self.flyCount < 4) Then
						' Magic number: 2
						If (Self.flyCount = 2) Then
							soundInstance.playSe(SoundSystem.SE_198_01)
						EndIf
						
						If (StageManager.getCurrentZoneId() <> 5) Then
							' Magic number: 6
							Self.velX = ((Self.flyCount * 6) Shl 6)
							
							Self.mapObj.setVel(Self.velX, Self.velY)
						EndIf
					EndIf
				EndIf
				
				' Magic number: 4
				If (Not (frame <> 4 Or StageManager.getCurrentZoneId() = 4 Or StageManager.getCurrentZoneId() = 5)) Then
					soundInstance.playLoopSe(SoundSystem.SE_198_02)
				EndIf
				
				frame += 1
				
				Self.mapObj.logic()
				
				Self.posX = Self.mapObj.getPosX()
				Self.posY = Self.mapObj.getPosY()
				
				If (Self.mapObj.getCurrentCrashCount() <> 0) Then
					Self.tmpSpeedX = Self.mapObj.getVelX()
					
					checkWithPlayer(Self.posX, Self.posY, Self.mapObj.getPosX(), Self.mapObj.getPosY())
					
					Self.tmpX = Self.mapObj.getPosX()
					Self.tmpY = Self.mapObj.getPosY()
				Else
					Self.mapObj.setPosition(Self.tmpX, Self.tmpY)
					
					Self.posX = Self.tmpX
					Self.posY = Self.tmpY
				EndIf
				
				Print("mapObj.getCurrentCrashCount()=" + Self.mapObj.getCurrentCrashCount())
				
				If (Self.mapObj.chkCrash()) Then
					Self.dead = True
					
					If (player.isFootOnObject(Self)) Then
						player.setVelX(Self.tmpSpeedX)
						
						player.doJump()
					EndIf
					
					If (StageManager.getCurrentZoneId() = 4) Then
						Effect.showEffect(iceBreakAnimation, 0, (Self.posX Shr 6), (Self.posY Shr 6), 0)
					ElseIf (StageManager.getCurrentZoneId() = 5) Then
						Effect.showEffect(platformBreakAnimation, 0, (Self.posX Shr 6), (Self.posY Shr 6), 0)
					Else
						Effect.showEffect(rockBreakAnimation, 0, (Self.posX Shr 6), (Self.posY Shr 6), 0)
					EndIf
					
					soundInstance.playSe(SoundSystem.SE_143)
				EndIf
			EndIf
			
			If (StageManager.getCurrentZoneId() <> 4 And Self.dead And soundInstance.getPlayingLoopSeIndex() = SoundSystem.SE_198_02) Then
				soundInstance.stopLoopSe()
			EndIf
		End
		
		Method checkInit:Bool()
			Return False
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((x - (COLLISION_WIDTH / 2)), (y - COLLISION_HEIGHT), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End