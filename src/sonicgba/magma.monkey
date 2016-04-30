Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Magma Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1280
		Const COLLISION_HEIGHT:Int = 1280
		
		Const STATE_UP:Int = 0
		Const STATE_WAIT:Int = 1
		
		Const INITIAL_VELOCITY:Int = -768
		
		' Global variable(s):
		Global IsFire:Bool = False
		
		Global magmaAnimation:Animation
		Global magmaDrawer:AnimationDrawer
		
		Global state:Int
		
		Global velocity:Int = INITIAL_VELOCITY
		
		Global wait_cnt:Int = 0
		Global wait_cnt_max:Int = 64
		
		' Fields:
		Field emenyid:Int
		
		Field limitTopY:Int
		Field limitBottomY:Int
		
		Field fire_start_speed:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Magic number: 384
			Self.fire_start_speed = 384
			
			' Magic number: 1920
			Self.posY += 1920
			
			Self.limitTopY = (Self.posY - Self.mHeight)
			
			Self.limitBottomY = Self.posY
			
			Self.emenyid = id
			
			If (magmaAnimation = Null) Then
				magmaAnimation = New Animation("/animation/magma")
			EndIf
			
			magmaDrawer = magmaAnimation.getDrawer(0, False, 0)
			
			wait_cnt = 0
			
			magmaDrawer.setPause(True)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(magmaAnimation)
			
			magmaAnimation = Null
		End
		
		Function staticlogic:Void()
			magmaDrawer.moveOn()
			
			Select (state)
				Case STATE_UP
					If (magmaDrawer.getCurrentFrame() < 6) Then
						velocity = INITIAL_VELOCITY
						
						IsFire = False
					ElseIf (magmaDrawer.getCurrentFrame() = 6) Then
						velocity = 0
						
						IsFire = True
					Else
						velocity = 0
						
						IsFire = False
					EndIf
					
					If (magmaDrawer.checkEnd()) Then
						state = STATE_WAIT
						
						wait_cnt = 0
					EndIf
				Case STATE_WAIT
					If (wait_cnt < wait_cnt_max) Then
						wait_cnt += 1
					EndIf
			End Select
		End
		
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Not Self.dead And p = player And state = STATE_UP) Then
				p.beHurt()
			EndIf
		End
		
		Method doWhileBeAttack:Void(object:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (state)
					Case STATE_UP
						Self.posY += velocity
						
						If (IsFire) Then
							BulletObject.addBullet(Self.emenyid, Self.posX, Self.posY, -Self.fire_start_speed, (-Self.fire_start_speed) * 2)
							BulletObject.addBullet(Self.emenyid, Self.posX, Self.posY, Self.fire_start_speed, (-Self.fire_start_speed) * 2)
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_WAIT
						Self.posY = Self.limitBottomY
						
						If (wait_cnt = wait_cnt_max) Then
							state = 0
							
							magmaDrawer.restart()
							
							IsFire = False
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead And Not magmaDrawer.checkEnd()) Then
				drawInMap(g, magmaDrawer)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End