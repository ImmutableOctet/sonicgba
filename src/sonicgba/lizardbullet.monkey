Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.bulletobject
Public

' Classes:
Class LizardBullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 768
		Const COLLISION_HEIGHT:Int = 768
		
		' Fields:
		Field isboom:Bool
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY, True)
			
			If (lizardbulletAnimation = Null) Then
				lizardbulletAnimation = New Animation("/animation/lizard_bullet")
			End
			
			Self.drawer = lizardbulletAnimation.getDrawer(0, True, 0)
			Self.isboom = False
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.velY < 0) Then
				Self.velY += GRAVITY
				Self.posY += Self.velY
			Else
				Self.velY = 0
				Self.drawer.setActionId(1)
				Self.drawer.setLoop(False)
				Self.isboom = True
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
	
		Method chkDestroy:Bool()
			Return Self.drawer.checkEnd()
		End
	
		Method draw:Void(graphics:MFGraphics)
			If (Not Self.drawer.checkEnd()) Then
				drawInMap(graphics, Self.drawer)
			EndIf
			
			Self.collisionRect.draw(graphics, camera)
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Not Self.isboom) Then
				Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
End