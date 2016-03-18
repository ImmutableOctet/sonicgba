Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.bulletobject
Public

' Classes:
Class DoubleGravityFlashBullet Extends BulletObject
	Private
		' Fields:
		Field COLLISION_HEIGHT:Int
		Field COLLISION_WIDTH:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int, type:Int)
			Super.New(x, y, velX, velY, True)
			
			' This may need some work later:
			Select (type)
				Case BULLET_MONKEY
					Self.COLLISION_WIDTH = 256
					Self.COLLISION_HEIGHT = 256
					
					doublegravityflashbulletAnimation = Null
					doublegravityflashbulletAnimation = New Animation("/animation/dgfa_bullet")
				Case BULLET_NATURE
					Self.COLLISION_WIDTH = 360
					Self.COLLISION_HEIGHT = 360
					
					doublegravityflashbulletAnimation = Null
					doublegravityflashbulletAnimation = New Animation("/animation/dgfn_bullet")
				Default
					Self.COLLISION_WIDTH = 256
					Self.COLLISION_HEIGHT = 256
			End Select
			
			Self.drawer = doublegravityflashbulletAnimation.getDrawer(0, True, 0)
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Self.posX += Self.velX
			Self.velY += GRAVITY
			Self.posY += Self.velY
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
			
			Self.collisionRect.draw(graphics, camera)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (Self.COLLISION_WIDTH / 2), y - (Self.COLLISION_HEIGHT / 2), Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT)
		End
		
		Method chkDestroy:Bool()
			Return (Not isInCamera() Or isFarAwayCamera())
		End
End
