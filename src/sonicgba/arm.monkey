Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class Arm Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2048
		Const COLLISION_HEIGHT:Int = 1024
		Const COLLISION_OFFSET_Y:Int = 2304
		
		Const ARM_DRAW_WIDTH:Int = 36
		
		Const ARM_DRAW_HEIGHT_1:Int = 31
		Const ARM_DRAW_HEIGHT_2:Int = 36
		
		Const BACK_WAIT_COUNT:Int = 4
		
		Const BAR_WIDTH:Int = 384
		Const BAR_LENGTH:Int = 1536
		
		Const PULL_POINT_OFFSET:Int = -192
		
		Const UP_DISTANCE:Int = 3328
		
		Const VELOCITY:Int = 300
		
		Const STATE_WAIT:Byte = 0
		Const STATE_UP:Byte = 1
		Const STATE_PULLING:Byte = 2
		Const STATE_BACK:Byte = 3
		Const STATE_DOWN:Byte = 4
		Const STATE_BACK_WAIT:Byte = 5
		
		' Global variable(s):
		Global frame:Int
		
		Field state:Byte ' Int
		
		Field count:Int
		
		Field posXOriginal:Int
		Field posYOriginal:Int
	Public
		' Global variable(s):
		Global armImage:MFImage
		Global armplusImage:MFImage
		Global barImage:MFImage
		Global baseImage:MFImage
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.posXOriginal = Self.posX
			Self.posYOriginal = Self.posY
			
			Self.posY = (Self.posYOriginal + UP_DISTANCE)
			
			Self.state = STATE_WAIT
			
			If (armImage = Null) Then
				armImage = MFImage.createImage("/gimmick/arm.png")
			EndIf
			
			If (barImage = Null) Then
				barImage = MFImage.createImage("/gimmick/arm_bar.png")
			EndIf
			
			If (armplusImage = Null) Then
				armplusImage = MFImage.createImage("/gimmick/arm_plus.png")
			EndIf
			
			If (baseImage = Null) Then
				baseImage = MFImage.createImage("/gimmick/part_1_2.png")
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			' Empty implementation.
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' This behavior may change in the future:
			Select (Self.state)
				Case STATE_WAIT
					SoundSystem.getInstance().playSe(SoundSystem.SE_181_01)
					
					Self.state = STATE_UP
					
					player.setOutOfControl(Self)
					player.doWalkPoseInAir()
					
					player.degreeForDraw = player.faceDegree
					
					isGotRings = False
					
					frame = 1
				Default
					' Nothing so far.
			End Select
		End
		
		Method logic:Void()
			If (Self.count > 0) Then
				Self.count -= 1
			EndIf
			
			Select (Self.state)
				Case STATE_UP
					Self.posY -= VELOCITY
					
					If (Self.posY <= Self.posYOriginal) Then
						Self.posY = Self.posYOriginal
						
						Self.state = STATE_PULLING
					EndIf
					
					frame += 1
					
					If (frame = 5) Then
						soundInstance.playLoopSe(SoundSystem.SE_181_02)
					EndIf
				Case STATE_PULLING
					Self.posX += VELOCITY
					
					frame += 1
					
					If (Self.posX >= (Self.posXOriginal + Self.mWidth)) Then
						Self.posX = (Self.posXOriginal + Self.mWidth)
						
						player.outOfControl = False
						
						player.collisionState = PlayerObject.COLLISION_STATE_JUMP
						
						player.velY = 0
						
						player.doWalkPoseInAir()
						
						Self.count = BACK_WAIT_COUNT
						
						Self.state = STATE_BACK_WAIT
						
						soundInstance.stopLoopSe()
					EndIf
				Case STATE_BACK
					Self.posX -= VELOCITY
					
					If (Self.posX <= Self.posXOriginal) Then
						Self.posX = Self.posXOriginal
						
						Self.state = STATE_DOWN
					EndIf
				Case STATE_DOWN
					Self.posY += VELOCITY
					
					If (Self.posY >= (Self.posYOriginal + UP_DISTANCE)) Then
						Self.posY = (Self.posYOriginal + UP_DISTANCE)
						
						Self.state = STATE_WAIT
					EndIf
				Case STATE_BACK_WAIT
					If (Self.count = 0) Then
						Self.state = STATE_BACK
					EndIf
			End Select
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (player.outOfControl And player.outOfControlObject = Self) Then
				Local preX:= player.getFootPositionX()
				Local preY:= player.getFootPositionY()
				
				player.doPullMotion(Self.posX, (Self.posY + COLLISION_OFFSET_Y) + PULL_POINT_OFFSET)
				player.checkWithObject(preX, preY, player.getFootPositionX(), player.getFootPositionY())
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, baseImage, 0, 0, 8, 8, 0, TOP|HCENTER)
			
			For Local i:= 0 Until ((Self.posY - Self.posYOriginal) - BAR_LENGTH) Step BAR_LENGTH
				drawInMap(g, barImage, Self.posX, Self.posYOriginal + i, TOP|HCENTER)
			Next
			
			drawInMap(g, barImage, 0, 0, 6, ((Self.posY - Self.posYOriginal) - i) Shr 6, 0, Self.posX, Self.posYOriginal + i, TOP|HCENTER)
			drawInMap(g, armplusImage, 0, 0, 8, 8, 1, Self.posX, Self.posYOriginal - 256, TOP|HCENTER)
			drawInMap(g, armImage, 0, PickValue(catching(), 0, ARM_DRAW_HEIGHT_1), ARM_DRAW_WIDTH, PickValue(catching(), ARM_DRAW_HEIGHT_1, ARM_DRAW_WIDTH), 0, TOP|HCENTER)
			
			drawCollisionRect(g)
		End
		
		Method catching:Bool()
			Return (Self.state = STATE_UP Or Self.state = STATE_PULLING)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - COLLISION_HEIGHT, (y + COLLISION_OFFSET_Y) - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			' Empty implementation.
		End
End