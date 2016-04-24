Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.myapi
	
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class LadyBug Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1664
		Const COLLISION_HEIGHT:Int = 1024
		
		Const ALERT_WIDTH:Int = 72
		Const ALERT_HEIGHT:Int = 64
		
		Const ALERT_RANGE:Int = 4992
		
		Const STATE_WAIT:Int = 0
		Const STATE_FLY:Int = 1
		Const STATE_ATTACK:Int = 2
		
		' Global variable(s):
		Global ladybugAnimation:Animation
		
		' Fields:
		Field state:Int
		Field alert_state:Int
		
		Field emenyid:Int
		
		Field attack_cnt:Int
		Field attack_cnt_max:Int
		
		Field fire_start_speed:Int
		
		Field circleCenterX:Int
		Field circleCenterY:Int
		
		Field dg:Int
		
		Field plus:Int
		Field plus_cnt:Int
		
		Field wait_cnt:Int
		Field wait_cnt_max:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.dg = 10
			
			Self.plus_cnt = 0
			Self.plus = 1
			
			Self.wait_cnt = 0
			Self.wait_cnt_max = 16
			
			Self.attack_cnt = 0
			Self.attack_cnt_max = 4
			
			Self.fire_start_speed = 300
			
			Self.circleCenterX = (Self.posX + (Self.mWidth / 2)) ' Shr 1
			Self.circleCenterY = Self.posY
			
			Self.plus_cnt = 0
			
			If (ladybugAnimation = Null) Then
				ladybugAnimation = New Animation("/animation/ladybug")
			EndIf
			
			Self.drawer = ladybugAnimation.getDrawer(0, False, 0)
			
			Self.emenyid = id
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(ladybugAnimation)
			
			ladybugAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), ALERT_WIDTH, ALERT_HEIGHT)
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_WAIT
						If (Self.alert_state = IN_ALERT_RANGE) Then
							Self.state = STATE_ATTACK
							
							Self.drawer.setActionId(2)
							Self.drawer.setLoop(True)
							
							Self.attack_cnt = 0
						ElseIf (Self.wait_cnt < Self.wait_cnt_max) Then
							Self.wait_cnt += 1
						Else
							Self.state = STATE_FLY
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_FLY
						Self.drawer.setActionId(1)
						Self.drawer.setLoop(True)
						
						If (Self.plus > 0) Then
							Self.plus_cnt += Self.plus
							
							If (Self.plus_cnt >= (180 / Self.dg)) Then
								Self.plus_cnt = (180 / Self.dg)
								
								Self.plus = -Self.plus
								
								Self.state = STATE_WAIT
								
								Self.drawer.setActionId(0)
								Self.drawer.setLoop(True)
								
								Self.wait_cnt = 0
							EndIf
						Else
							Self.plus_cnt += Self.plus
							
							If (Self.plus_cnt <= 0) Then
								Self.plus_cnt = 0
								
								Self.plus = -Self.plus
								
								Self.state = STATE_WAIT
								
								Self.drawer.setActionId(0)
								Self.drawer.setLoop(True)
								
								Self.wait_cnt = 0
							EndIf
						EndIf
						
						Self.posX = Self.circleCenterX - (((Self.mWidth / 2) * MyAPI.dCos(Self.dg * Self.plus_cnt)) / 100) ' Shr 1
						Self.posY = Self.circleCenterY + (((Self.mWidth / 2) * MyAPI.dSin(Self.dg * Self.plus_cnt)) / 100) ' Shr 1
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.attack_cnt < Self.attack_cnt_max) Then
							Self.attack_cnt += 1
						Else
							BulletObject.addBullet(Self.emenyid, Self.posX - (COLLISION_WIDTH / 2), Self.posY, -Self.fire_start_speed, -Self.fire_start_speed)
							BulletObject.addBullet(Self.emenyid, Self.posX + (COLLISION_WIDTH / 2), Self.posY, Self.fire_start_speed, -Self.fire_start_speed)
							
							Self.state = STATE_FLY
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - COLLISION_WIDTH, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End