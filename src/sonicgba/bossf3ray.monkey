Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.bulletobject
Public

' Classes:
Class BossF3Ray Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 18432
		Const COLLISION_HEIGHT:Int = 1024
		
		Const ATTACK_PLUS_HEIGHT:= (COLLISION_HEIGHT/2)
		
		' Fields:
		Field directFlag:Int
		Field fadevalue:Int
		Field frame_cn:Int
	Protected
		Method New(x:Int, y:Int, direct:Int)
			Super.New(x, y, 0, 0, False)
			
			Self.directFlag = direct
			
			Self.posX = x
			Self.posY = y
			
			Self.frame_cn = 0
			Self.fadevalue = 200
		End
	
	Public
		Method bulletLogic:Void()
			Self.frame_cn += 1
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method chkDestroy:Bool()
			Return (Self.frame_cn >= 8)
		End
		
		Method draw:Void(g:MFGraphics)
			Local camera:= MapManager.getCamera()
			
			Local cameraX:= camera.x
			Local cameraY:= camera.y
			
			If (Self.directFlag = 0) Then
				MyAPI.drawFadeRange(g, Self.fadevalue, ((Self.posX - COLLISION_WIDTH) Shr 6) - cameraX, ((Self.posY - ATTACK_PLUS_HEIGHT) Shr 6) - cameraY, Self.frame_cn)
			Else
				MyAPI.drawFadeRange(g, Self.fadevalue, (Self.posX Shr 6) - cameraX, ((Self.posY - ATTACK_PLUS_HEIGHT) Shr 6) - cameraY, Self.frame_cn)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.directFlag = 0) Then
				Self.collisionRect.setRect(x - COLLISION_WIDTH, y - COLLISION_HEIGHT, COLLISION_WIDTH, (COLLISION_WIDTH/32))
			Else
				Self.collisionRect.setRect(x, y - COLLISION_HEIGHT, COLLISION_WIDTH, (COLLISION_WIDTH/32)) ' (y - ATTACK_PLUS_HEIGHT)
			EndIf
		End
End