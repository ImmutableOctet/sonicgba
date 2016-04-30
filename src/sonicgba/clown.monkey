Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Clown Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1792
		Const COLLISION_HEIGHT:Int = 3072
		
		' Global variable(s):
		Global clownAnimation:Animation
		
		' Fields:
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field velocity:Int
		
		Field touching:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 192
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			If (clownAnimation = Null) Then
				clownAnimation = New Animation("/animation/clown")
			EndIf
			
			Self.drawer = clownAnimation.getDrawer(0, True, 0)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(clownAnimation)
			
			clownAnimation = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Not Self.dead And p = player And Not Self.touching) Then
				If (Not p.isAttackingEnemy()) Then
					p.beHurt()
				ElseIf (p.isOnGound()) Then
					PlayerHurtBall(p, direction)
				Else
					p.doAttackPose(Self, direction)
					
					beAttack()
				EndIf
				
				Self.touching = True
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.touching = False
		End
		
		Method PlayerHurtBall:Void(player:Playerplayer, direction:Int)
			Local playerVelX:= -player.getVelX()
			
			If (Self.velocity > 0) Then
				If (player.getVelX() < 0) Then
					Self.velocity = -Self.velocity
					
					Self.drawer.setActionId(0)
					Self.drawer.setTrans(TRANS_MIRROR)
				EndIf
			ElseIf (player.getVelX() > 0) Then
				Self.velocity = -Self.velocity
				
				Self.drawer.setActionId(0)
				Self.drawer.setTrans(TRANS_NONE)
			EndIf
			
			Local preAnimationId:= player.getAnimationId()
			
			Select (direction)
				Case DIRECTION_UP
					player.beStop(Self.collisionRect.y1, direction, Self)
				Case DIRECTION_DOWN, DIRECTION_NONE
					player.beStop(Self.collisionRect.y0, direction, Self)
				Case DIRECTION_LEFT
					player.beStop(Self.collisionRect.x1, direction, Self)
				Case DIRECTION_RIGHT
					player.beStop(Self.collisionRect.x0, direction, Self)
			End Select
			
			player.setVelX(playerVelX)
			player.setAnimationId(preAnimationId)
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				If (Self.velocity > 0) Then
					Self.posX += Self.velocity
					
					Self.drawer.setActionId(0)
					Self.drawer.setTrans(TRANS_MIRROR)
					
					If (Self.posX >= Self.limitRightX) Then
						Self.posX = Self.limitRightX
						
						Self.velocity = -Self.velocity
					EndIf
				Else
					Self.posX += Self.velocity
					
					Self.drawer.setActionId(0)
					Self.drawer.setTrans(TRANS_NONE)
					
					If (Self.posX <= Self.limitLeftX) Then
						Self.posX = Self.limitLeftX
						
						Self.velocity = -Self.velocity
					EndIf
				EndIf
				
				Self.posY = getGroundY(Self.posX, Self.posY)
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End