Strict

Public

' Imports:
Import lib.animation
Import com.sega.mobile.framework.device.mfgraphics

Import sonicgba.bulletobject

' Classes:
Class BeeBullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 512
		Const COLLISION_HEIGHT:= 512
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY, False)
			
			If (beebulletAnimation = Null) Then
				beebulletAnimation = new Animation("/animation/mira_bullet")
			Endif
			
			Self.drawer = beebulletAnimation.getDrawer(0, True, 0)
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
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method chkDestroy:Bool()
			Return (Not isInCamera() Or isFarAwayCamera())
		End
End