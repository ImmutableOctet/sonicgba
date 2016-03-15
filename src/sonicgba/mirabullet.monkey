Strict

Public

' Imports:
Import sonicgba.basicbullet

' Classes:
Class MiraBullet Extends BasicBullet
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 640
		Const COLLISION_HEIGHT:= 640
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY)
			
			If (mirabulletAnimation = Null) Then
				mirabulletAnimation = new Animation("/animation/mira_bullet")
			Endif
			
			Self.drawer = mirabulletAnimation.getDrawer(0, True, 0)
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			updateBulletRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End