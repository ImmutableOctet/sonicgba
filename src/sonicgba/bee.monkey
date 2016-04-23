Strict

Public

' Imports:
Private
	'Import gameengine.def
	
	Import lib.animation
	Import lib.myapi
	Import lib.crlfp32
	Import lib.constutil
	
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Bee Extends EnemyObject
	Private
		' Constant variable(s):
		Const BEE_BULLET_SPEED_ABS:Int = 432
		
		Const COLLISION_WIDTH:Int = 1536
		Const COLLISION_HEIGHT:Int = 1536
		
		Const HEIGHT_OFFSET:Int = 16
		
		Const STATE_MOVE:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Global variable(s):
		Global beeAnimation:Animation
		
		' Fields:
		Field ALERT_HEIGHT:Int
		Field ALERT_WIDTH:Int
		
		Field ATTACK_MIN_SCALE:Int
		Field ATTACK_MAX_SCALE:Int
		
		Field state:Int = STATE_MOVE
		Field alert_state:Int
		
		Field enemyid:Int
		
		Field velocity:Int
		
		Field attack_base_range:Int
		
		Field attack_cnt:Int
		Field attack_cnt_max:Int
		
		Field bullset_v_x:Int
		Field bullset_v_y:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field attack_flag:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y - HEIGHT_OFFSET, left, top, width, height)
			
			Self.velocity = 192
			
			Self.ALERT_WIDTH = 128 ' (COLLISION_WIDTH / 12)
			Self.ALERT_HEIGHT = 108 ' (BEE_BULLET_SPEED_ABS / 4)
			
			Self.ATTACK_MIN_SCALE = 36
			Self.ATTACK_MAX_SCALE = 373
			
			Self.bullset_v_x = 0
			Self.bullset_v_y = 0
			
			Self.attack_cnt_max = 35
			
			Self.attack_flag = False
			
			Self.attack_base_range = -960
			
			Self.limitLeftX = Self.posX
			
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			If (beeAnimation = Null) Then
				beeAnimation = New Animation("/animation/bee")
			EndIf
			
			Self.drawer = beeAnimation.getDrawer(1, True, 0)
			
			Self.enemyid = id
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(beeAnimation)
			
			beeAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), Self.ALERT_WIDTH, Self.ALERT_HEIGHT)
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_MOVE
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_MIRROR)
							Self.drawer.setLoop(True)
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(False)
								
								Self.attack_flag = False
							EndIf
						Else
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_NONE)
							Self.drawer.setLoop(True)
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(False)
								
								Self.attack_flag = False
							EndIf
						EndIf
						
						If (Self.alert_state = STATE_MOVE And (Self.posY + COLLISION_WIDTH) < player.getCheckPositionY() And Not Self.attack_flag And checkPlayerInEnemyAlertRangeScale((Self.posX Shr 6), (Self.posY Shr 6), Self.ATTACK_MIN_SCALE, Self.ATTACK_MAX_SCALE) And IsFacePlayer()) Then
							If (Self.posX < player.getCheckPositionX()) Then
								If (Self.velocity > 0) Then
									Self.drawer.setActionId(2)
									Self.drawer.setTrans(TRANS_MIRROR)
									Self.drawer.setLoop(False)
									
									Self.state = STATE_ATTACK
									
									Self.attack_cnt = 0
									
									Self.bullset_v_x = beeBulletVx(player.getCheckPositionX() - Self.posX, player.getCheckPositionY() - Self.posY)
									Self.bullset_v_y = beeBulletVy(player.getCheckPositionX() - Self.posX, player.getCheckPositionY() - Self.posY)
								EndIf
							ElseIf (Self.posX > player.getCheckPositionX() And Self.velocity < 0) Then
								Self.drawer.setActionId(2)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(False)
								
								Self.state = STATE_ATTACK
								
								Self.attack_cnt = 0
								
								Self.bullset_v_x = beeBulletVx(player.getCheckPositionX() - Self.posX, player.getCheckPositionY() - Self.posY)
								Self.bullset_v_y = beeBulletVy(player.getCheckPositionX() - Self.posX, player.getCheckPositionY() - Self.posY)
							EndIf
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.drawer.checkEnd()) Then
							BulletObject.addBullet(Self.enemyid, Self.posX, Self.posY + (COLLISION_HEIGHT / 2), Self.bullset_v_x, Self.bullset_v_y)
							
							Self.state = STATE_MOVE
							
							Self.attack_flag = True
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
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
	Private
		' Methods:
		
		' Extensions:
		Method IsFacePlayer:Bool(player:PlayerObject)
			If ((Self.posX <= player.getFootPositionX() Or Self.velocity >= 0) And (Self.posX >= player.getFootPositionX() Or Self.velocity <= 0)) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method beeBulletVx:Int(distanceX:Int, distanceY:Int)
			Return (((DSgn(distanceX > 0) * BEE_BULLET_SPEED_ABS) * MyAPI.dSin(crlFP32.actTanDegree(Abs(distanceX), Abs(distanceY)))) / 100)
		End
		
		Method beeBulletVy:Int(distanceX:Int, distanceY:Int)
			Return (((DSgn(distanceY > 0) * BEE_BULLET_SPEED_ABS) * MyAPI.dCos(crlFP32.actTanDegree(Abs(distanceX), Abs(distanceY)))) / 100)
		End
		
		Method IsFacePlayer:Bool()
			IsFacePlayer(player)
		End
End