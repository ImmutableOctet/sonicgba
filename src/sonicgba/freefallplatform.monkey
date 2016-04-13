Strict

Public

' Imports:
Private
	Import lib.coordinate
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.freefallsystem
Public

' Classes:
Class FreeFallPlatform Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 28
		Const COLLISION_HEIGHT:Int = 28
		
		Const DRAW_WIDTH:Int = 96
		Const DRAW_HEIGHT:Int = 40
		
		' Global variable(s):
		Global image:MFImage
		
		' Fields:
		Field posXorg:Int
		Field posYorg:Int
		Field rollCount:Int
		
		Field system:FreeFallSystem
	Protected
		' Constructor(s):
		Method New(system:FreeFallSystem, x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Self.system = system
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/freefall_platform.png")
			EndIf
			
			Local co:= system.getBarPosition()
			
			Self.posXorg = co.x
			Self.posYorg = co.y
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method init:Void()
			Self.posX = Self.posXorg
			Self.posY = Self.posYorg
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method platformLogic:Void()
			Local co:= Self.system.getBarPosition()
			
			checkWithPlayer(Self.posX, Self.posY, co.x, co.y)
			
			Self.posX = co.x
			Self.posY = co.y
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.system.initFlag) Then
				If (Self.system.moving) Then
					drawInMap(g, image, (Int((systemClock / 5) Mod 2)) * DRAW_WIDTH, 0, DRAW_WIDTH, DRAW_HEIGHT, 0, 17)
				Else
					drawInMap(g, image, 0, 0, DRAW_WIDTH, DRAW_HEIGHT, 0, 17)
				EndIf
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - 768, y + 768, 6144, 1792)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (direction <> 0) Then
				player.beStop(0, direction, Self)
			EndIf
		End
		
		Method close:Void()
			Self.system = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End