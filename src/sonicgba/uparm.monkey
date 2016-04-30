Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import gameengine.key
	
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.collisionrect
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class UpArm Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 896
		Const COLLISION_HEIGHT:Int = 320
		
		Const DRAW_WIDTH:Int = 1536
		Const DRAW_HEIGHT:Int = 3264
		
		Const ARM_WIDTH:Int = 24
		Const ARM_HEIGHT:Int = 19
		
		Const ARM_OFFSET:Int = 14
		
		Const ARM_PULL_OFFSET_Y:Int = 128
		
		Const ARM_X:Int = 0
		Const ARM_Y:Int = 32
		
		Const BAR_WIDTH:Int = 4
		Const BAR_HEIGHT:Int = 32
		
		Const BAR_X:Int = 10
		Const BAR_Y:Int = 0
		
		Const UPVELOCITY:Int = 480
		Const DOWNVELOCITY:Int = 960
		
		Const MOVE_DISTANCE:Int = 7680
		
		Const WAIT_COUNT_2:Int = 15
		
		Const STATE_WAIT:Byte = 0
		Const STATE_PULL:Byte = 1
		Const STATE_WAIT_2:Byte = 2
		Const STATE_RETURN:Byte = 3
		
		' Global variable(s):
		Global frame:Int
		
		Global image:MFImage
		
		' Fields:
		Field collisionRect2:CollisionRect
		Field state:Byte
		Field upLimit:Int
		Field waitCount:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.upLimit = (Self.posY - MOVE_DISTANCE)
			
			Self.posX += ARM_PULL_OFFSET_Y
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/up_arm.png")
			EndIf
		End
	Public
		' Methods:
		Method draw:Void(g:MFGraphics)
			Local y:= Self.upLimit
			
			While (y < (Self.posY - COLLISION_WIDTH) - PlayerObject.DETECT_HEIGHT)
				drawInMap(g, image, BAR_X, BAR_Y, BAR_WIDTH, BAR_HEIGHT, BAR_Y, Self.posX, y, TOP|HCENTER)
				
				y += PlayerObject.DETECT_HEIGHT
			Wend
						
			If (y < Self.posY - COLLISION_WIDTH) Then
				drawInMap(g, image, BAR_X, BAR_Y, BAR_WIDTH, (((Self.posY - COLLISION_WIDTH) - y) Shr 6), BAR_Y, Self.posX, y, TOP|HCENTER)
			EndIf
			
			drawInMap(g, image, BAR_Y, BAR_HEIGHT, ARM_WIDTH, ARM_HEIGHT, BAR_Y, Self.posX, Self.posY - COLLISION_WIDTH, TOP|HCENTER)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.collisionRect2.collisionChk(player.collisionRect)) Then
				Select (Self.state)
					Case STATE_WAIT
						Self.state = STATE_PULL
						
						player.resetPlayerDegree()
						player.setOutOfControl(Self)
						
						player.doPullMotion(Self.posX, Self.posY + ARM_PULL_OFFSET_Y)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_181_01)
						
						frame = 1
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method logic:Void()
			If (Self.waitCount > 0) Then
				Self.waitCount -= 1
			EndIf
			
			Select (Self.state)
				Case STATE_PULL
					' Magic number: 100
					frame += 1
					frame Mod= 100
					
					Self.posY -= UPVELOCITY
					
					If (Self.posY < Self.upLimit) Then
						Self.posY = Self.upLimit
						
						soundInstance.stopLoopSe()
					ElseIf (frame = BAR_WIDTH) Then
						soundInstance.playLoopSe(SoundSystem.SE_181_02)
					EndIf
					
					player.doPullMotion(Self.posX, Self.posY + ARM_PULL_OFFSET_Y)
					
					If (Self.posY = Self.upLimit And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
						player.outOfControl = False
						
						player.doJump()
						
						player.isOnlyJump = True
						
						Self.state = STATE_WAIT_2
						
						Self.waitCount = WAIT_COUNT_2
						
						soundInstance.stopLoopSe()
					EndIf
				Case STATE_WAIT_2
					If (Self.waitCount = 0) Then
						Self.state = STATE_RETURN
					EndIf
				Case STATE_RETURN
					Self.posY += DOWNVELOCITY
					
					If (Self.posY >= (Self.upLimit + MOVE_DISTANCE)) Then
						Self.posY = (Self.upLimit + MOVE_DISTANCE)
						
						Self.state = STATE_WAIT
						
						player.isOnlyJump = False
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((x - (DRAW_WIDTH / 2)), Self.upLimit, DRAW_WIDTH, (y - PickValue((Self.upLimit <= 0), 1, (y - Self.upLimit))))
			
			If (Self.collisionRect2 = Null) Then
				Self.collisionRect2 = New CollisionRect()
			EndIf
			
			Self.collisionRect2.setRect((x - (COLLISION_WIDTH / 2)), y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End