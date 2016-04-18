Strict

Public

' Imports:
Private
	Import sonicgba.collisionrect
	Import sonicgba.gimmickobject
	Import sonicgba.platform
	Import sonicgba.playerobject
	Import sonicgba.steambase
	
	'Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class SteamPlatform Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1280
		Const COLLISION_HEIGHT:Int = 448
		
		' Global variable(s):
		Global velocity:Int
		Global endCount:Int
		
		Global image:MFImage
		
		Global moving:Bool
		
		Field originalPosY:Int
		Field sb:SteamBase
	Public
		' Global variable(s):
		Global sPosY:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, sb:SteamBase)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Self.originalPosY = Self.posY
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/steam_platform.png")
			EndIf
			
			Self.sb = sb
		End
	Public
		' Functions:
		Function staticLogic:Void()
			If (moving) Then
				velocity += GRAVITY
				sPosY += velocity
				
				If (sPosY >= 0) Then
					sPosY = 0
					
					endCount -= 1
					
					If (endCount <= 0) Then
						moving = False
					Else
						velocity = ((-velocity) / 3)
					EndIf
				EndIf
			EndIf
		End
		
		Function shot:Void()
			moving = True
			
			velocity = -1450
			endCount = 3
		End
		
		Function isShotting:Bool()
			Return (moving And endCount = 3)
		End
		
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method logic:Void()
			Local preY:= Self.posY
			
			Self.posY = (Self.originalPosY + sPosY)
			
			checkWithPlayer(Self.posX, preY, Self.posX, Self.posY)
			
			Self.sb.sh.refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method drawPlatform:Void(g:MFGraphics)
			drawInMap(g, image, BOTTOM|HCENTER)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (direction = DIRECTION_DOWN Or direction = DIRECTION_NONE) Then
				player.beStop(0, DIRECTION_DOWN, Self)
			EndIf
		End
		
		Method close:Void()
			Self.sb = Null
		End
		
		Method collisionChkWithObject:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			rectV.setRect(objectRect.x0 + Platform.STAND_OFFSET, objectRect.y0, objectRect.getWidth() - (Platform.DRAW_OFFSET_Y / 2), objectRect.getHeight()) ' 384
			
			Return thisRect.collisionChk(rectV)
		End
End