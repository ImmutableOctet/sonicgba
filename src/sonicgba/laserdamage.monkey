Strict

Public

' Friends:
Friend sonicgba.bulletobject

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.bulletobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class LaserDamage Extends BulletObject
	Private
		' Fields:
		Field isDead:Bool
		Field rect:Byte[]
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(x, y, 0, 0, False)
			
			If (laserAnimation = Null) Then
				laserAnimation = New Animation("/animation/boss_extra_bullet")
			EndIf
			
			Self.drawer = laserAnimation.getDrawer(0, False, 0)
			Self.drawer.setPause(True)
			
			Self.isDead = False
			
			Self.posY = getGroundY(Self.posX, Self.posY)
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			If (Self.drawer.checkEnd()) Then
				Self.isDead = True
				
				Return
			EndIf
			
			Self.drawer.moveOn()
			Self.rect = Self.drawer.getARect()
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			doWhileCollisionWrapWithPlayer()
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.rect.Length > 0) Then
				Self.collisionRect.setRect((Self.rect[0] Shl 6) + x, (Self.rect[1] Shl 6) + y, Self.rect[2] Shl 6, Self.rect[3] Shl 6)
			EndIf
		End

		Method chkDestroy:Bool()
			Return Self.isDead
		End

		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not player.isAttackingEnemy()) Then
				player.beHurt()
			EndIf
		End
End