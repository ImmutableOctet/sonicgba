Strict

Public

' Imports:
Private
	Import lib.animation
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.bulletobject
Public

' Classes:
Class LaserDamage Extends BulletObject
	Private
		' Fields:
		Field isDead:Bool
		Field rect:Byte[]
	Protected
		Method New(x:Int, y:Int)
			Super.New(x, y, 0, 0, False)
			
			If (laserAnimation = Null) Then
				laserAnimation = New Animation("/animation/boss_extra_bullet")
			Endif
			
			Self.drawer = laserAnimation.getDrawer(0, False, 0)
			Self.drawer.setPause(True)
			
			Self.isDead = False
			Self.posY = getGroundY(Self.posX, Self.posY)
		End
	Public
		Method bulletLogic:Void()
			If (Self.drawer.checkEnd()) Then
				Self.isDead = True
				
				Return
			Endif
			
			Self.drawer.moveOn()
			Self.rect = Self.drawer.getARect()
			
			refreshCollisionRect(Self.posX, Self.posY)
			doWhileCollisionWrapWithPlayer()
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.rect <> Null) Then
				Self.collisionRect.setRect((Self.rect[0] Shl 6) + x, (Self.rect[1] Shl 6) + y, Self.rect[2] Shl 6, Self.rect[3] Shl 6)
			Endif
		End

		Method chkDestroy:Bool()
			Return Self.isDead
		End

		Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			If (Not player.isAttackingEnemy()) Then
				player.beHurt()
			Endif
		End
End