Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.enemyobject
Public

' Classes:
Class Boom Extends EnemyObject
	Private
		Const COLLISION_HEIGHT:Int = 64
		Const COLLISION_WIDTH:Int = 64
	Private
		Global boomdrawer:AnimationDrawer
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(BoomAni)
			
			BoomAni = Null
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (BoomAni = Null) Then
				BoomAni = New Animation("/animation/boom")
			Endif
			
			Self.boomdrawer = BoomAni.getDrawer(0, False, 0)
			Self.posX = x
			Self.posY = y
		End
	Public
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End

		Method logic:Void()
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (Self.boomdrawer.checkEnd()) Then
				Self.dead = True
			Endif
		End

		Method draw:Void(graphics:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(graphics, Self.boomdrawer, Self.posX, Self.posY)
			Endif
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.boomdrawer = Null
		End
End