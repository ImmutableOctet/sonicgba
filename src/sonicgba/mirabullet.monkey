Strict

Public

' Imports:
Import lib.animation
Import com.sega.mobile.framework.device.mfgraphics

Import sonicgba.bulletobject

' Classes:
Class MiraBullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 640
		Const COLLISION_HEIGHT:= 640
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY, False)
			
			If (mirabulletAnimation = Null) Then
				mirabulletAnimation = new Animation("/animation/mira_bullet")
			Endif
			
			Self.drawer = mirabulletAnimation.getDrawer(0, True, 0)
			
			Self.posX = x
			Self.posY = y
			
			Self.velX = velX
			Self.velY = velY
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			checkWithPlayer(Self.posX, Self.posY, Self.posX + Self.velX, Self.posY)
			
			Self.posX += Self.velX
			Self.posY += Self.velY
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(g, Self.drawer)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - 320, y - 320, COLLISION_WIDTH, COLLISION_WIDTH)
		End
		
		Method chkDestroy:Bool()
			Return (Not isInCamera() Or isFarAwayCamera())
		End
End