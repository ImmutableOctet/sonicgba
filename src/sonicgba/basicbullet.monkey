Strict

Public

' Imports:
Import lib.animation
Import com.sega.mobile.framework.device.mfgraphics

Import sonicgba.bulletobject

' Classes:
Class BasicBullet Extends BulletObject Abstract
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int, hitDestroy:Bool=False)
			Super.New(x, y, velX, velY, hitDestroy)
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int) Abstract
		
		Method bulletLogic:Void()
			checkWithPlayer(Self.posX, Self.posY, Self.posX + Self.velX, Self.posY)
			
			Self.posX += Self.velX
			Self.posY += Self.velY
		End
		
		Method updateBulletRect:Void(x:Int, y:Int, width:Int, height:Int)
			Self.collisionRect.setRect(x - (width/2), y - (height/2), width, height)
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
		End
		
		Method chkDestroy:Bool()
			Return (Not isInCamera() Or isFarAwayCamera())
		End
End