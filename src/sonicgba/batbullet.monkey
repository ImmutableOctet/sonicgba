Strict

Public

' Friends:
Friend sonicgba.bulletobject
Friend sonicgba.bat

' Imports:
Private
	Import lib.animation
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.bulletobject
Public

' Classes:
Class BatBullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1536
		Const COLLISION_HEIGHT:Int = 1536
		
		' Fields:
		Field isboom:Bool
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY, False)
			
			If (batbulletAnimation = Null) Then
				batbulletAnimation = New Animation("/animation/bat_bullet")
			End
			
			Self.drawer = batbulletAnimation.getDrawer(0, True, 0)
			Self.isboom = False
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Self.velY += GRAVITY
			Self.posY += Self.velY
			
			Local groundY:= (getGroundY(Self.posX, Self.posY) - (COLLISION_HEIGHT / 2))
			
			If (Self.posY >= groundY) Then
				Self.posY = groundY
				
				Self.drawer.setActionId(1)
				Self.drawer.setLoop(False)
				
				Self.isboom = True
				
				Self.velY = 0
			ElseIf (IsHit()) Then
				Self.drawer.setActionId(1)
				Self.drawer.setLoop(False)
				
				Self.isboom = True
				
				Self.velY = 20
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method chkDestroy:Bool()
			Return (Super.chkDestroy() Or Self.drawer.checkEnd())
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