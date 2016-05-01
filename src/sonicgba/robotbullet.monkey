Strict

Public

' Friends:
Friend sonicgba.bulletobject

Friend sonicgba.snowroboth
Friend sonicgba.snowrobotv

' Imports:
Private
	Import sonicgba.basicbullet
Public

' Classes:
Class RobotBullet Extends BasicBullet
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 512
		Const COLLISION_HEIGHT:= 512
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY)
			
			If (robotbulletAnimation = Null) Then
				robotbulletAnimation = New Animation("/animation/yukimal_bullet")
			EndIf
			
			Self.drawer = robotbulletAnimation.getDrawer(0, True, 0)
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			Self.velY += GRAVITY
			
			Super.bulletLogic()
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			updateBulletRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End