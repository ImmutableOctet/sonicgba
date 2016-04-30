Strict

Public

' Friends:
Friend sonicgba.bulletobject
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.bossf3

' Imports:
Private
	Import lib.animation
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.bulletobject
Public

' Classes:
Class BossF3Bomb Extends BulletObject
	Private
		' Constant variable(s):
		Const BOOM_V1:Int = 720
		Const BOOM_V2:Int = 360
		
		Const BOOM_MAX:= (BOOM_V1 + BOOM_V2)
		
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		' Fields:
		Field vel_x:Int
		Field vel_y:Int
		Field velorg_y:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, type:Int, direct:Int)
			Super.New(x, y, 0, 0, False)
			
			If (bossf3bombAnimation = Null) Then
				bossf3bombAnimation = New Animation("/animation/bossf3_bullet")
			EndIf
			
			Self.drawer = bossf3bombAnimation.getDrawer(0, True, 0)
			
			If (direct = 1) Then
				If (type = 0) Then
					Self.vel_x = BOOM_V1
					Self.vel_y = -BOOM_V1
					Self.velorg_y = -BOOM_V1
				ElseIf (type = 1) Then
					Self.vel_x = BOOM_V2
					Self.vel_y = -BOOM_MAX
					Self.velorg_y = -BOOM_MAX
				EndIf
			ElseIf (direct = 0) Then
				If (type = 0) Then
					Self.vel_x = -BOOM_V1
					Self.vel_y = -BOOM_V1
					Self.velorg_y = -BOOM_V1
				ElseIf (type = 1) Then
					Self.vel_x = -BOOM_V2
					Self.vel_y = -BOOM_MAX
					Self.velorg_y = -BOOM_MAX
				EndIf
			EndIf
			
			Self.posX = x
			Self.posY = y
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			Self.posX += Self.vel_x
			
			If (Self.posY + Self.vel_y >= getGroundY(Self.posX, Self.posY + Self.vel_y)) Then
				Self.posY = getGroundY(Self.posX, Self.posY + Self.vel_y)
				
				Self.velorg_y = ((Self.velorg_y * 7) / 8)
				Self.vel_y = Self.velorg_y
			Else
				Self.vel_y += GRAVITY
				Self.posY += Self.vel_y
			End
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_HEIGHT/2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT) ' (y - (COLLISION_HEIGHT/2))
		End
		
		Method chkDestroy:Bool()
			Return (Not isInCamera() Or isFarAwayCamera())
		End
End
