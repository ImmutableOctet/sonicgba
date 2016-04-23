Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Monkey Extends EnemyObject
	Private
		' Constant variable(s):
		Const ALERT_RANGE:Int = 9216
		
		Const COLLISION_WIDTH:Int = 1536
		Const COLLISION_HEIGHT:Int = 1280
		
		Const STATE_CLIMB:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Global variable(s):
		Global monkeyAnimation:Animation
		
		' Fields:
		Field ALERT_WIDTH:Int
		Field ALERT_HEIGHT:Int
		
		Field BOMB_MAX_SPEED_X:Int
		
		Field enemyid:Int
		
		Field state:Int
		Field alert_state:Int
		
		Field posXl:Int
		Field posXr:Int
		Field velocity:Int
		
		Field attack_cnt:Int
		
		Field limitBottomY:Int
		Field limitTopY:Int
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(monkeyAnimation)
			
			monkeyAnimation = Null
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 320
			
			Self.ALERT_WIDTH = 256
			Self.ALERT_HEIGHT = 160
			
			Self.BOMB_MAX_SPEED_X = 384
			
			Self.attack_cnt = 0
			
			Self.posY -= 1024
			
			Self.posXl = Self.posX
			Self.posXr = Self.posX - (Self.velocity * 2)
			
			Self.limitTopY = Self.posY
			Self.limitBottomY = Self.posY + Self.mHeight
			
			If (monkeyAnimation = Null) Then
				monkeyAnimation = New Animation("/animation/monkey")
			EndIf
			
			Self.drawer = monkeyAnimation.getDrawer(0, True, 0)
			
			Self.enemyid = id
		End
	Public
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), Self.ALERT_WIDTH, Self.ALERT_HEIGHT)
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				If (Self.posX < player.getCheckPositionX()) Then
					Self.posX = Self.posXr
				Else
					Self.posX = Self.posXl
				EndIf
				
				preX = Self.posX
				
				Select (Self.state)
					Case STATE_CLIMB
						If (Self.alert_state = STATE_CLIMB Or Self.alert_state = STATE_ATTACK) Then
							If (Self.posX < player.getCheckPositionX()) Then
								Self.drawer.setTrans(TRANS_MIRROR)
							Else
								Self.drawer.setTrans(TRANS_NONE)
							EndIf
						EndIf
						
						If (Self.velocity > 0) Then
							Self.posY += Self.velocity
							
							If (Self.posY >= Self.limitBottomY) Then
								Self.posY = Self.limitBottomY
								
								Self.velocity = -Self.velocity
							EndIf
						Else
							Self.posY += Self.velocity
							
							If (Self.posY <= Self.limitTopY) Then
								Self.posY = Self.limitTopY
								
								Self.velocity = -Self.velocity
							EndIf
						EndIf
						
						If (Self.posY = Self.limitTopY And Self.alert_state = STATE_CLIMB) Then
							Self.attack_cnt += 1
							
							If (Self.attack_cnt = 2) Then
								Self.state = STATE_ATTACK
								
								Self.attack_cnt = 0
							EndIf
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						Self.drawer.setActionId(STATE_ATTACK)
						Self.drawer.setLoop(False)
						
						If (Self.posX < player.getCheckPositionX()) Then
							Self.drawer.setTrans(TRANS_MIRROR)
						Else
							Self.drawer.setTrans(TRANS_NONE)
						EndIf
						
						If (Self.drawer.checkEnd()) Then
							Local bomb_speed_x:= ((-(Self.posX - player.getCheckPositionX())) / 12)
							
							If (Abs(bomb_speed_x) > Self.BOMB_MAX_SPEED_X) Then
								If (bomb_speed_x > 0) Then
									bomb_speed_x = Self.BOMB_MAX_SPEED_X
								Else
									bomb_speed_x = -Self.BOMB_MAX_SPEED_X
								EndIf
							EndIf
							
							BulletObject.addBullet(Self.enemyid, Self.posX, Self.posY, bomb_speed_x, 0)
							
							Self.state = STATE_CLIMB
							
							Self.drawer.setActionId(0)
							Self.drawer.setLoop(True)
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
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End