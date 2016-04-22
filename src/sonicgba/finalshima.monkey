Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class FinalShima Extends GimmickObject ' Final
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1536
		
		Const DROP_STATE_READY:Int = 1
		Const DROP_STATE_START:Int = 2
		Const DROP_STATE_WAIT:Int = 0
		
		' Global variable(s):
		Global image:MFImage
		
		' Fields:
		Field currentTime:Long
		Field frameTime:Long
		Field startTime:Long
		
		Field dropState:Int
		
		Field posOriginalY:Int
		Field velY:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velY = 0
			Self.dropState = 0
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/yuka_fi.png")
			EndIf
			
			Self.posOriginalY = Self.posY
			Self.dropState = 0
		End
	Private
		' Methods:
		Method resetShima:Void()
			Self.posY = Self.posOriginalY
			
			Self.velY = 0
			Self.dropState = 0
			
			Self.used = False
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Select (direction)
				Case DIRECTION_DOWN
					player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
					
					Self.used = True
				Case DIRECTION_NONE
					If (player.getMoveDistance().y > 0 And player.getCollisionRect().y1 < Self.collisionRect.y1) Then
						player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
						
						Self.used = True
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method doWhileNoCollision:Void()
			If (player.collisionState = PlayerObject.COLLISION_STATE_JUMP Or player.collisionState = PlayerObject.COLLISION_STATE_WALK) Then
				Self.used = False
			EndIf
		End
		
		Method logic:Void()
			If (Self.dropState = DROP_STATE_START) Then
				Self.currentTime = Millisecs()
				
				If (Self.currentTime - Self.startTime >= 1000) Then
					Self.velY += GRAVITY
					Self.posY += Self.velY
				EndIf
			ElseIf (Self.used) Then
				Self.posY = MyAPI.calNextPosition(Double(Self.posY), Double(Self.posOriginalY + (COLLISION_HEIGHT / 2)), 1, 6)
				
				' Magic number: 192
				If (Self.posY > Self.posOriginalY + 192 And Self.dropState = 0) Then
					Self.dropState = DROP_STATE_READY
					
					Self.startTime = Millisecs()
				EndIf
				
				If (Self.dropState = DROP_STATE_READY) Then
					Self.dropState = DROP_STATE_START
				EndIf
			Else
				Self.posY = MyAPI.calNextPositionReverse(Self.posY, Self.posOriginalY + (COLLISION_HEIGHT / 2), Self.posOriginalY, 1, 6)
			EndIf
			
			If (isAwayFromCameraInWidth()) Then
				resetShima()
			EndIf
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, image, Self.posX, Self.posY - (COLLISION_HEIGHT / 2), TOP|HCENTER)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End