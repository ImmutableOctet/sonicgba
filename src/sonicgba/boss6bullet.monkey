Strict

Public

' Friends:
Friend sonicgba.boss6
Friend sonicgba.bossobject
Friend sonicgba.enemyobject
Friend sonicgba.bulletobject

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.bulletobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.utility.mfmath
Public

' Classes:
Class Boss6Bullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		Const TOTAL_SPEED:Int = 240
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, playerx:Int, playery:Int)
			Super.New(x, y, playerx, playery, False)
			
			If (boss6bulletAnimation = Null) Then
				boss6bulletAnimation = New Animation("/animation/boss6_bullet")
			EndIf
			
			Self.drawer = boss6bulletAnimation.getDrawer(0, True, 0)
			
			Self.posX = x
			Self.posY = y
			
			Local root:= (MFMath.sqrt(((playerx - Self.posX) * (playerx - Self.posX)) + ((playery - Self.posY) * (playery - Self.posY))) Shr 6)
			
			Self.velX = (((playerx - Self.posX) * TOTAL_SPEED) / root)
			Self.velY = (((playery - Self.posY) * TOTAL_SPEED) / root)
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			checkWithPlayer(Self.posX, Self.posY, Self.posX + Self.velX, Self.posY + Self.velY)
			
			Self.posX += Self.velX
			Self.posY += Self.velY
		End
	
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
	
		Method chkDestroy:Bool()
			Return (Not isInCamera() Or isFarAwayCamera())
		End
End
