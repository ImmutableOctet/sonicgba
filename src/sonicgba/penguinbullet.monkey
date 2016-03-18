Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.bulletobject
Public

' Classes:
Class PenguinBullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		' Fields:
		Field broken:Bool
		Field mapObj:MapObject
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY, False)
			
			If (penguinbulletAnimation = Null) Then
				penguinbulletAnimation = New Animation("/animation/pen_bullet")
			End
			
			Self.drawer = penguinbulletAnimation.getDrawer(0, True, 0)
			Self.posX = x
			Self.posY = y
			
			Self.velX = velX
			Self.velY = velY
			
			Self.mapObj = New MapObject(Self.posX, Self.posY, 0, 0, Self, 1)
			Self.mapObj.setPosition(Self.posX, Self.posY, Self.velX, 0, Self)
			Self.mapObj.setCrashCount(2)
			
			Self.broken = False
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			If (Self.drawer.checkEnd() Or IsHit() Or (Self.mapObj.getVelX() = 0 And Self.mapObj.getVelY() = 0)) Then
				Self.broken = True
			ElseIf (Self.mapObj.chkCrash()) Then
				Self.drawer.setActionId(1)
				Self.drawer.setLoop(False)
			Else
				Self.mapObj.logic()
				
				checkWithPlayer(Self.posX, Self.posY, Self.mapObj.getPosX(), Self.mapObj.getPosY())
				
				Self.posX = Self.mapObj.getPosX()
				Self.posY = Self.mapObj.getPosY()
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.drawer.checkEnd()) Then
				drawInMap(g, Self.drawer)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT) ' (y - (COLLISION_HEIGHT/2))
		End
		
		Method chkDestroy:Bool()
			Return (Self.broken Or Not isInCamera())
		End
End