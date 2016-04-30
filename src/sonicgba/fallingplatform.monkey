Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.platform
	Import sonicgba.playerobject
	Import sonicgba.gimmickobject
	Import sonicgba.collisionrect
	Import sonicgba.mapmanager
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class FallingPlatform Extends Platform
	Private
		' Constant variable(s):
		Const FALLING_COUNT:Int = 20
		
		' Fields:
		Field fallingCount:Int
		
		Field posOriginalX:Int
		Field posOriginalY:Int
		
		Field velocity:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 0
			
			Self.fallingCount = FALLING_COUNT
			
			Self.posOriginalX = Self.posX
			Self.posOriginalY = Self.posY
			
			Self.velocity = 0
		End
	Public
		' Methods:
		Method logic:Void()
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (Self.fallingCount > 0 And Self.used) Then
				Self.fallingCount -= 1
			EndIf
			
			If (Self.fallingCount = 0) Then
				Self.velocity += GRAVITY
			EndIf
			
			If (player.isFootOnObject(Self)) Then
				Self.offsetY = STAND_OFFSET
			Else
				Self.offsetY = 0
			EndIf
			
			If (StageManager.getCurrentZoneId() >= 3 And StageManager.getCurrentZoneId() <= 6) Then
				Self.offsetY2 = GimmickObject.PLATFORM_OFFSET_Y
			EndIf
			
			checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY + Self.velocity)
			
			Self.posY += Self.velocity
		End
		
		Method doInitWhileInCamera:Void()
			' Empty implementation.
		End
		
		Method checkInit:Bool()
			If ((Abs(player.getFootPositionX() - Self.posOriginalX) Shr 6) < (MapManager.CAMERA_WIDTH / 2) Or (Abs(player.getFootPositionY() - Self.posOriginalY) Shr 6) < (MapManager.CAMERA_HEIGHT / 2)) Then ' Shr 1
				Return False
			EndIf
			
			Self.posY = Self.posOriginalY
			Self.used = False
			
			Self.fallingCount = FALLING_COUNT
			
			Self.velocity = 0
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			Return False
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - PlayerObject.HEIGHT, (((COLLISION_OFFSET_Y + y) - DRAW_OFFSET_Y) + Self.offsetY) + Self.offsetY2, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method collisionChkWithObject:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			rectV.setRect((objectRect.x0 + STAND_OFFSET), objectRect.y0 + Self.offsetY2, objectRect.getWidth() - (DRAW_OFFSET_Y / 2), objectRect.getHeight()) ' 384
			
			Return thisRect.collisionChk(rectV)
		End
		
		#Rem
			Method draw:Void(g:MFGraphics)
				Super.draw(g)
			End
		#End
End