Strict

Public

' Imports:
Private
	Import sonicgba.basicbullet
Public

' Classes:
Class BeeBullet Extends BasicBullet
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 512
		Const COLLISION_HEIGHT:= 512
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY)
			
			If (beebulletAnimation = Null) Then
				beebulletAnimation = new Animation("/animation/bee_bullet")
			EndIf
			
			Self.drawer = beebulletAnimation.getDrawer(0, True, 0)
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			updateBulletRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End