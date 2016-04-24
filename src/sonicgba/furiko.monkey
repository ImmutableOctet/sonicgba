Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import lib.myapi
	
	Import sonicgba.sonicdef
	
	Import sonicgba.arm
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Furiko Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		Const COLLISION_OFFSET_Y:Int = 960
		
		Const DRAW_WIDTH:Int = 16
		Const DRAW_HEIGHT:Int = 24
		
		Const RING_NUM:Int = 3
		Const LEAVE_COUNT:Int = 10
		
		Const RADIUS:Int = 4928
		Const RING_SPACE:Int = 960
		
		' Global variable(s):
		Global degree:Int = 2240
		Global lineVelocity:Int = 0
		
		' Fields:
		Field centerX:Int
		Field centerY:Int
		
		Field leaveCount:Int
		Field thisDegree:Int
		
		Field touching:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.touching = False
			Self.leaveCount = 0
			
			If (Arm.baseImage = Null) Then
				Arm.baseImage = MFImage.createImage("/gimmick/part_1_2.png")
			EndIf
			
			If (hookImage = Null) Then
				hookImage = MFImage.createImage("/gimmick/hook.png")
			EndIf
			
			Self.centerX = Self.posX
			Self.centerY = Self.posY
		End
	Public
		' Functions:
		Function staticLogic:Void()
			lineVelocity += ((GRAVITY - 60) * Sin((degree Shr 6) - 90)) / 100
			
			degree -= ((((lineVelocity Shl 6) / RADIUS) Shl 6) * 180) / sonicdef.PI
		End
		
		Function releaseAllResource:Void()
			' Empty implementation.
		End
		
		' Methods:
		Method logic:Void()
			If (Self.leaveCount > 0) Then
				Self.leaveCount -= 1
			EndIf
			
			Self.thisDegree = (degree Shr 6)
			
			If (Self.iLeft <> 0) Then
				Self.thisDegree = (180 - Self.thisDegree)
			EndIf
			
			Self.posX = (Self.centerX + ((MyAPI.dCos(Self.thisDegree) * RADIUS) / 100))
			Self.posY = (Self.centerY + ((MyAPI.dSin(Self.thisDegree) * RADIUS) / 100))
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (Self.touching) Then
				player.doPullMotion(Self.posX, Self.posY)
				
				If (Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
					player.outOfControl = False
					
					Self.touching = False
					
					player.doJump()
					
					player.setFurikoOutVelX(Self.thisDegree)
					
					Self.leaveCount = LEAVE_COUNT
				EndIf
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			For Local i:= 0 Until RING_NUM
				drawInMap(g, Arm.baseImage, 8, 0, 8, 8, 0, Self.centerX + ((((i + 1) * RING_SPACE) * MyAPI.dCos(Self.thisDegree)) / 100), Self.centerY + ((((i + 1) * RING_SPACE) * MyAPI.dSin(Self.thisDegree)) / 100), RING_NUM)
			Next
			
			g.saveCanvas()
			
			g.translateCanvas((Self.posX Shr 6) - camera.x, (Self.posY Shr 6) - camera.y)
			g.rotateCanvas(Float(Self.thisDegree - 90))
			
			MyAPI.drawRegion(g, hookImage, DRAW_WIDTH, 0, DRAW_WIDTH, DRAW_HEIGHT, 0, 0, -22, 17)
			
			g.restoreCanvas()
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.touching And Self.firstTouch And Self.leaveCount = 0) Then
				Self.touching = True
				
				player.setOutOfControl(Self)
			EndIf
		End
		
		Method close:Void()
			' Empty implementation.
		End
End