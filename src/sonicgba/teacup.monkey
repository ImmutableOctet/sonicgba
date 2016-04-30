Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.myapi
	Import lib.soundsystem
	Import lib.crlfp32
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class TeaCup Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 6144
		Const COLLISION_HEIGHT:Int = 2560
		
		Const COLLISION_OFFSET_Y:Int = -1536
		
		Const COLLISION_Y1_ORIBINAL:Int = 768
		Const COLLISION_Y1_ROLLING_2:Int = 256
		
		Const MIN_RADIUS:Int = 320
		Const MAX_RADIUS:Int = 2240
		
		Const MOVE_FRAME:Int = 37
		Const MOVE_LENGTH:Int = 7168
		Const MOVE_SPEED:Int = 192
		
		Const ROLLING_2_COUNT:Int = 16
		
		Const STATE_STAY:Byte = 0
		Const STATE_ROLLING:Byte = 1
		Const STATE_ROLLING_2:Byte = 2
		Const STATE_SHOOT:Byte = 3
		
		' Global variable(s):
		Global teacupImage:MFImage
		
		' Fields:
		Field state:Byte
		Field drawCount:Byte
		
		Field count:Int
		
		Field changeTime:Int
		Field changeTimeCount:Int
		
		Field collisionHeight:Int
		
		Field degreeSpeed:Int
		
		Field playerDegree:Int
		
		Field playerX:Int
		Field prePosY:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (teacupImage = Null) Then
				teacupImage = MFImage.createImage("/gimmick/teacup_" + StageManager.getCurrentZoneId() + ".png")
			EndIf
			
			Self.state = STATE_STAY
			
			Self.changeTime = 0
			Self.degreeSpeed = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			teacupImage = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not player.isDead) Then
				If (Self.changeTime > 0) Then
					Self.changeTimeCount += 1
					
					If (Self.changeTimeCount >= Self.changeTime) Then
						Self.drawCount = Byte((Self.drawCount + 1) Mod 2)
						
						Self.changeTimeCount = 0
					EndIf
				EndIf
				
				If (Self.count > 0) Then
					Self.count -= 1
				EndIf
				
				Select (Self.state)
					Case STATE_STAY
						Self.collisionHeight = COLLISION_Y1_ORIBINAL
					Case STATE_ROLLING
						player.setNoKey()
						
						player.setAnimationId(PlayerObject.ANI_JUMP)
						
						Self.playerDegree += Self.degreeSpeed
						Self.playerDegree Mod= 360
						
						' Magic number: 1920
						player.setFootPositionX(Self.posX + (((MAX_RADIUS - (((Self.posY - Self.prePosY) * 1920) / MOVE_LENGTH)) * MyAPI.dSin(Self.playerDegree)) / 100))
						
						checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY + MOVE_SPEED)
						
						Self.posY += MOVE_SPEED
						
						If (Self.posY >= (Self.prePosY + MOVE_LENGTH)) Then
							Self.posY = (Self.prePosY + MOVE_LENGTH)
							
							player.setFootPositionX(Self.posX)
							
							Self.state = STATE_ROLLING_2
							
							Self.count = ROLLING_2_COUNT
							
							Self.changeTime = 1
							
							Self.collisionHeight = COLLISION_Y1_ROLLING_2
						EndIf
						
						Self.degreeSpeed = (((Self.posY - Self.prePosY) * 60) / MOVE_LENGTH) ' + 0
					Case STATE_ROLLING_2
						player.setNoKey()
						
						player.setAnimationId(PlayerObject.ANI_JUMP)
						
						Self.playerDegree += Self.degreeSpeed
						Self.playerDegree Mod= 360
						
						player.setFootPositionX(Self.posX + ((MyAPI.dSin(Self.playerDegree) * MIN_RADIUS) / 100))
						
						checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY)
						
						If (Self.count = 0) Then
							player.setFootPositionX(Self.posX)
							
							Self.state = STATE_SHOOT
							
							Self.changeTime = 2
							
							player.beSpring(-PlayerObject.SHOOT_POWER, 0)
							
							player.isPowerShoot = True
							
							player.collisionState = PlayerObject.COLLISION_STATE_JUMP
							
							player.setAnimationId(PlayerObject.ANI_JUMP)
						EndIf
					Case STATE_SHOOT
						If (Self.changeTime > 0 And Self.changeTimeCount = 0) Then
							Self.changeTime += 1
							
							' Magic number: 6
							If (Self.changeTime > 6) Then
								Self.changeTime = 0
								
								SoundSystem.getInstance().stopLongSe()
							EndIf
						EndIf
				End Select
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player) Then
				Select (Self.state)
					Case STATE_STAY
						Self.playerX = (p.getFootPositionX() - Self.posX)
						
						If (Self.playerX > MAX_RADIUS) Then
							Self.playerX = MAX_RADIUS
						ElseIf (Self.playerX < -MAX_RADIUS) Then
							Self.playerX = -MAX_RADIUS
						EndIf
						
						' Magic number: 5017600
						Self.playerDegree = CrlFP32.actTanDegree(Self.playerX, CrlFP32.sqrt(5017600 - (Self.playerX * Self.playerX)) Shr 3)
						
						p.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
						
						p.setNoKey()
						
						Self.prePosY = Self.posY
						
						Self.state = STATE_ROLLING
						
						Self.changeTime = 2
						
						SoundSystem.getInstance().playLongSe(SoundSystem.SE_206)
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, teacupImage, 0, (Self.drawCount * 40), 96, 40, 0, Self.posX, (Self.posY + COLLISION_OFFSET_Y), TOP|HCENTER)
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((x - (COLLISION_WIDTH / 2)), (y - Self.collisionHeight), COLLISION_WIDTH, (COLLISION_HEIGHT + COLLISION_OFFSET_Y))
		End
		
		Method close:Void()
			' Empty implementation.
		End
End