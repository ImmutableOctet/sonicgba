Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.boss5flydefence
	Import sonicgba.bossbroken
	Import sonicgba.bossobject
	Import sonicgba.bulletobject
	Import sonicgba.cage
	Import sonicgba.globalresource
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:

' This acts as the implementation of Mecha Knuckles, AKA Fake Knuckles, or simply "Knuckle".
' This single boss class covers both the first and second phase forms of Mecha Knuckles.
Class Boss5 Extends BossObject
	Private
		' Constant variable(s):
		Const STATE_FRESH_WAIT_0:Int = 0
		Const STATE_FRESH_WAIT_1:Int = 1
		Const STATE_FRESH_WAKE:Int = 2
		Const STATE_FRESH_ATTACK_TRANS:Int = 3
		Const STATE_FRESH_READY:Int = 4
		Const STATE_FRESH_BALL_HORIZON_ATTACK_READY:Int = 5
		Const STATE_FRESH_BALL_HORIZON_ATTACK_FIGHT:Int = 6
		Const STATE_FRESH_BALL_UP:Int = 7
		Const STATE_FRESH_FLY:Int = 8
		Const STATE_FRESH_FLY_DRIP_READY:Int = 9
		Const STATE_FRESH_FLY_DRIPPING:Int = 10
		Const STATE_FRESH_FLY_DRIP_LAND:Int = 11
		Const STATE_FRESH_FIGHT:Int = 12
		Const STATE_FRESH_HURT_KNOCK:Int = 13
		Const STATE_FRESH_HURT_AIR:Int = 14
		Const STATE_FRESH_HURT_LAND:Int = 15
		Const STATE_FRESH_DEFENCE_READY:Int = 16
		Const STATE_FRESH_DEFENCING:Int = 17
		Const STATE_FRESH_DEFENCE_BACK:Int = 18
		Const STATE_MACHINE_READY:Int = 19
		Const STATE_MACHINE_ATTACK_TRANS:Int = 20
		Const STATE_MACHINE_BALL_HORIZON_ATTACK_READY:Int = 21
		Const STATE_MACHINE_BALL_HORIZON_ATTACK_FIGHT:Int = 22
		Const STATE_MACHINE_BALL_UP:Int = 23
		Const STATE_MACHINE_FLY:Int = 24
		Const STATE_MACHINE_FLY_DRIP_READY:Int = 25
		Const STATE_MACHINE_FLY_DRIPPING:Int = 26
		Const STATE_MACHINE_FLY_DRIP_LAND:Int = 27
		Const STATE_MACHINE_MISSILE_READY:Int = 28
		Const STATE_MACHINE_MISSILE_ATTACK:Int = 29
		Const STATE_MACHINE_HURT_KNOCK:Int = 30
		Const STATE_MACHINE_HURT_AIR:Int = 31
		Const STATE_MACHINE_HURT_LAND:Int = 32
		Const STATE_MACHINE_DEFENCE_READY:Int = 33
		Const STATE_MACHINE_DEFENCING:Int = 34
		Const STATE_MACHINE_DEFENCE_BACK:Int = 35
		Const STATE_MACHINE_KO_AIR:Int = 36
		Const STATE_MACHINE_KO_LAND:Int = 37
		Const STATE_MACHINE_BROKEN:Int = 38
		Const STATE_MACHINE_PIECES:Int = 39
		Const STATE_ESCAPE:Int = 40
		
		Const F_READY:Int = 0
		Const F_WAIT:Int = 1
		Const F_WAIT_HURT:Int = 2
		Const F_BALL_A:Int = 3
		Const F_BALL_B:Int = 4
		Const F_HURT_KNOCK:Int = 5
		Const F_HURT_AIR:Int = 6
		Const F_HURT_LAND:Int = 7
		Const F_BALL_A_HURT:Int = 8
		Const F_BALL_B_HURT:Int = 9
		Const F_DRIP_READY:Int = 10
		Const F_DRIP_AIR:Int = 11
		Const F_DRIP_LAND:Int = 12
		Const F_DEFENCE_READY:Int = 13
		Const F_DEFENCING:Int = 14
		Const F_DEFENCE_BACK:Int = 15
		Const F_FLY_A:Int = 16
		Const F_FLY_B:Int = 17
		Const F_FIGHT:Int = 18
		
		Const M_WAIT:Int = 19
		Const M_WAIT_HURT:Int = 20
		Const M_BALL_A:Int = 21
		Const M_BALL_B:Int = 22
		Const M_HURT_KNOCK:Int = 23
		Const M_HURT_AIR:Int = 24
		Const M_HURT_LAND:Int = 25
		Const M_BALL_A_HURT:Int = 26
		Const M_BALL_B_HURT:Int = 27
		Const M_DRIP_READY:Int = 28
		Const M_DRIP_AIR:Int = 29
		Const M_DRIP_LAND:Int = 30
		Const M_DEFENCE_READY:Int = 31
		Const M_DEFENCING:Int = 32
		Const M_DEFENCE_BACK:Int = 33
		Const M_FLY_A:Int = 34
		Const M_FLY_B:Int = 35
		Const M_MISSILE_READY:Int = 36
		Const M_MISSILE_LAUNCH:Int = 37
		Const M_MISSILE_READY_HURT:Int = 38
		Const M_KO_AIR:Int = 39
		Const M_KO_LAND:Int = 40
		Const M_PARTS_HEAD:Int = 41
		Const M_PARTS_BODY:Int = 42
		Const M_PARTS_HAND_R:Int = 43
		Const M_PARTS_HAND_L:Int = 44
		Const M_PARTS_LEG_R:Int = 45
		Const M_PARTS_LEG_L:Int = 46
		
		Const CAGE_DRIP_Y:Int = 1020
		
		Const EGG_POS_X:Int = 609792
		Const EGG_POS_Y:Int = 69120
		Const EGG_SIDE_LEFT:Int = 9360
		
		Global EGG_SIDE_RIGHT:Int = (SCREEN_WIDTH + EGG_SIDE_LEFT) ' Const

		Global BEFORE_MEET_LINE:Int = ((SIDE_LEFT - 232) Shl 6) ' Const
		
		Global MEET_SONIC_LINE:Int = ((SIDE_LEFT + 24) Shl 6) ' Const
		
		Global MIDDLE_SCREEN:Int = (((SIDE_LEFT + SIDE_RIGHT) / 2) Shl 6) ' Shr 1 ' Const
		
		Const SIDE_DOWN_MIDDLE:Int = 1128
		
		Global SIDE_LEFT:Int = (SIDE_RIGHT - SCREEN_WIDTH) ' Const
		
		Const SIDE_RIGHT:Int = 9496
		
		Const START_POS_X:Int = 605696
		
		Const defence_cnt_max:Int = 15
		Const first_jump_cnt_max:Int = 3
		Const ready_cnt_max:Int = 24
		Const talk_cnt_max:Int = 9
		
		' Global variable(s):
		Global boatAni:Animation = Null
		Global escapefaceAni:Animation = Null
		Global knucklesAni:Animation = Null
		
		Global damageframe:Int = 0
		
		' Fields:
		Field ALERT_RANGE:Int
		
		Field BOSS5_WIDTH:Int
		
		Field COLLISION_WIDTH:Int
		Field COLLISION_HEIGHT:Int
		
		Field AttackStartDirection:Int
		
		Field WaitCnt:Int
		
		Field state:Int
		Field prestate:Int
		Field alert_state:Int
		
		Field randomAttackState:Int
		
		Field missile_alert_state:Int
		Field missile_alert_range:Int
		
		Field Vix:Int[]
		Field Viy:Int[]
		
		Field pos:Int[][]
		
		Field IsConner:Bool
		Field IsHurt:Bool
		Field IsPlayerRunaway:Bool
		
		Field KOWaitCnt:Int
		Field KOWaitCntMax:Int
		
		Field boatdrawer:AnimationDrawer
		Field boomdrawer:AnimationDrawer
		Field escapefacedrawer:AnimationDrawer
		Field knuckdrawer:AnimationDrawer
		
		Field bossbroken:BossBroken
		Field flydefence:Boss5FlyDefence
		
		Field boomX:Int
		Field boomY:Int
		
		Field boom_offset:Int
		
		Field defence_cnt:Int
		
		Field escape_cnt:Int
		Field escape_cnt_max:Int
		
		Field enemyDirct:Int
		
		Field escape_v:Int
		
		Field fight_alert_range:Int
		Field first_jump_cnt:Int
		Field fly_attack_site:Int
		Field fly_drip_offset:Int
		Field fly_end:Int
		Field fly_move_x_speed1:Int
		Field fly_move_y_speed1:Int
		Field fly_range:Int
		Field fly_top:Int
		Field fly_top_offset:Int
		Field fly_up_speed1:Int
		
		Field horizonAttackReady_cnt:Int
		Field horizonAttackReady_cnt_max:Int
		Field horizon_move_speed:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field pieces_drip_cnt:Int
		
		Field ready_cnt:Int
		Field talk_cnt:Int
		
		Field velX:Int
		Field velY:Int
		
		Field velocity:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.COLLISION_WIDTH = 1024
			Self.COLLISION_HEIGHT = 1664
			
			Self.BOSS5_WIDTH = 1536
			Self.ALERT_RANGE = 11520
			
			Self.fly_top_offset = 5632
			Self.fly_up_speed1 = 704
			Self.fly_move_x_speed1 = -772
			Self.fly_move_y_speed1 = 140
			Self.fly_drip_offset = 2304
			
			Self.fight_alert_range = 1536
			Self.missile_alert_range = 5120
			
			Self.talk_cnt = 0
			Self.ready_cnt = 0
			
			Self.velocity = -768
			
			Self.horizon_move_speed = 1080
			
			Self.horizonAttackReady_cnt_max = 16
			
			Self.IsConner = False
			Self.IsPlayerRunaway = False
			
			Self.defence_cnt = 0
			Self.first_jump_cnt = 0
			
			Self.boom_offset = 640
			
			Self.KOWaitCntMax = 10
			
			Self.IsHurt = False
			
			Self.Viy = [-1200, -1050, -900, -750, -600]
			Self.Vix = [750, -300, -150, 150, 450, -750, 600, 300, -450]
			
			Self.escape_v = 512
			
			Self.fly_range = 4096
			
			Self.escape_cnt = 0
			Self.escape_cnt_max = 60
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			Self.posY -= 960
			
			Self.posX = START_POS_X
			
			Self.posY = getGroundY(Self.posX, Self.posY)
			
			Self.limitRightX = 606720
			Self.limitLeftX = ((SIDE_LEFT + 16) Shl 6)
			
			Self.fly_top = (Self.posY - Self.fly_top_offset)
			
			refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
			
			If (knucklesAni = Null) Then
				knucklesAni = New Animation("/animation/boss5")
			EndIf
			
			Self.knuckdrawer = knucklesAni.getDrawer(0, True, 0)
			
			If (BoomAni = Null) Then
				BoomAni = New Animation("/animation/boom")
			EndIf
			
			Self.boomdrawer = BoomAni.getDrawer(0, True, 0)
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(0, True, 0)
			
			If (escapefaceAni = Null) Then
				escapefaceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.escapefacedrawer = escapefaceAni.getDrawer(STATE_FRESH_WAKE, False, 0)
			
			Self.flydefence = New Boss5FlyDefence(ENEMY_BOSS5_FLYDEFENCE, x, y, 0, 0, 0, 0)
			
			GameObject.addGameObject(Self.flydefence, x, y)
			
			setBossHP()
		End
		
		' Methods:
		
		' Extensions:
		
		' This method's behavior may change in the future:
		Method pickRandomState:Int()
			Select (Self.prestate)
				Case STATE_FRESH_READY
					If (Not CanFreshFight()) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random >= 45) Then ' random < 0 Or ...
							If (random >= 55) Then
								soundInstance.playSe(SoundSystem.SE_109)
								
								Return STATE_FRESH_BALL_HORIZON_ATTACK_READY
							EndIf
							
							Return STATE_FRESH_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_FRESH_BALL_UP
					EndIf
					
					Return STATE_FRESH_FIGHT
				Case STATE_FRESH_BALL_HORIZON_ATTACK_FIGHT
					If (CanFreshFight()) Then
						Return STATE_FRESH_FIGHT
					EndIf
					
					Return STATE_FRESH_READY
				Case STATE_FRESH_FLY_DRIP_LAND, STATE_FRESH_FIGHT
					If (Not CanFreshFight()) Then
						random = MyRandom.nextInt(0, 15)
						
						If (random >= 5) Then ' random < 0 Or ...
							If (random >= 10) Then
								soundInstance.playSe(SoundSystem.SE_109)
								
								Return STATE_FRESH_BALL_HORIZON_ATTACK_READY
							EndIf
							
							Return STATE_FRESH_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_FRESH_BALL_UP
					EndIf
					
					Return STATE_FRESH_FIGHT
				Case STATE_FRESH_HURT_LAND
					If (Not CanFreshFight()) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random >= 50) Then
							soundInstance.playSe(SoundSystem.SE_109)
							
							Return STATE_FRESH_BALL_HORIZON_ATTACK_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_FRESH_BALL_UP
					EndIf
					
					Return STATE_FRESH_FIGHT
				Case STATE_FRESH_DEFENCE_BACK
					If (Not CanFreshFight()) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random >= 30) Then
							soundInstance.playSe(SoundSystem.SE_109)
							
							Return STATE_FRESH_BALL_HORIZON_ATTACK_READY
						ElseIf (random >= 25) Then
							Return STATE_FRESH_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_FRESH_BALL_UP
					EndIf
					
					Return STATE_FRESH_FIGHT
				Case STATE_MACHINE_READY
					If (Self.missile_alert_state <> IN_ALERT_RANGE) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random >= 12) Then ' random < 0 Or ...
							If (random >= 25) Then
								Return STATE_MACHINE_MISSILE_READY
							EndIf
							
							soundInstance.playSe(SoundSystem.SE_109)
							
							Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_MACHINE_BALL_UP
					Else
						random = MyRandom.nextInt(0, 100)
						
						If (random >= 45) Then ' random < 0 Or ...
							If (random >= 55) Then
								soundInstance.playSe(SoundSystem.SE_109)
								
								Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
							EndIf
							
							Return STATE_MACHINE_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_MACHINE_BALL_UP
					EndIf
				Case STATE_MACHINE_BALL_HORIZON_ATTACK_FIGHT
					Return STATE_MACHINE_READY
				Case STATE_MACHINE_FLY_DRIP_LAND
					If (Self.missile_alert_state <> IN_ALERT_RANGE) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random < 0 Or random >= 15) Then
							If (random < 15 Or random >= 17) Then
								If (random >= 25) Then
									Return STATE_MACHINE_MISSILE_READY
								EndIf
								
								soundInstance.playSe(SoundSystem.SE_109)
								
								Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
							EndIf
							
							Return STATE_MACHINE_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_MACHINE_BALL_UP
					Else
						random = MyRandom.nextInt(0, defence_cnt_max)
						
						If (random < 0 Or random >= 5) Then
							If (random >= 10) Then
								soundInstance.playSe(SoundSystem.SE_109)
								
								Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
							EndIf
							
							Return STATE_MACHINE_READY
						Else
							soundInstance.playSe(SoundSystem.SE_116)
							
							Return STATE_MACHINE_BALL_UP
						EndIf
					EndIf
				Case STATE_MACHINE_MISSILE_ATTACK
					If (Self.missile_alert_state <> IN_ALERT_RANGE) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random < 0 Or random >= 10) Then
							If (random >= 20) Then
								Return STATE_MACHINE_MISSILE_READY
							EndIf
							
							soundInstance.playSe(SoundSystem.SE_109)
							
							Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
						Else
							soundInstance.playSe(SoundSystem.SE_116)
							
							Return STATE_MACHINE_BALL_UP
						EndIf
					Else
						random = MyRandom.nextInt(0, 100)
						
						If (random < 0 Or random >= 45) Then
							If (random >= 55) Then
								soundInstance.playSe(SoundSystem.SE_109)
								
								Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
							EndIf
							
							Return STATE_MACHINE_READY
						Else
							soundInstance.playSe(SoundSystem.SE_116)
							
							Return STATE_MACHINE_BALL_UP
						EndIf
					EndIf
				Case STATE_MACHINE_HURT_LAND
					If (Self.missile_alert_state <> IN_ALERT_RANGE) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random < 0 Or random >= 25) Then
							If (random >= 50) Then
								Return STATE_MACHINE_MISSILE_READY
							EndIf
							
							soundInstance.playSe(SoundSystem.SE_109)
							
							Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_MACHINE_BALL_UP
					Else
						random = MyRandom.nextInt(0, 100)
						
						If (random >= 50) Then ' random < 0 Or ...
							soundInstance.playSe(SoundSystem.SE_109)
							
							Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_MACHINE_BALL_UP
					EndIf
				Case STATE_MACHINE_DEFENCE_BACK
					If (Self.missile_alert_state <> IN_ALERT_RANGE) Then
						random = MyRandom.nextInt(0, 100)
						
						If (random < 0 Or random >= 12) Then
							If (random >= 25) Then
								Return STATE_MACHINE_MISSILE_READY
							EndIf
							
							soundInstance.playSe(SoundSystem.SE_109)
							
							Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_MACHINE_BALL_UP
					Else
						random = MyRandom.nextInt(0, 100)
						
						If (random < 0 Or random >= 25) Then
							If (random >= 30) Then
								soundInstance.playSe(SoundSystem.SE_109)
								
								Return STATE_MACHINE_BALL_HORIZON_ATTACK_READY
							EndIf
							
							Return STATE_MACHINE_READY
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return STATE_MACHINE_BALL_UP
					EndIf
			End Select
			
			Return STATE_FRESH_WAIT_0 ' 0
		End
	Private
		' Methods:
		Method halfLife:Int()
			Return PickValue((GlobalResource.isEasyMode() And stageModeState = STATE_NORMAL_MODE), (EASY_HP / 2), (DEFAULT_HP / 2))
		End
		
		Method halfLifeNum:Int()
			Return halfLife()
		End
		
		Method CanFreshFight:Bool()
			If (Abs(Self.posX - player.getFootPositionX()) > Self.fight_alert_range Or Not player.isOnGound()) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method hurt_side_cotrol:Void()
			If ((Self.posX + Self.velX) + Self.BOSS5_WIDTH >= ((MapManager.getCamera().x + MapManager.CAMERA_WIDTH) Shl 6)) Then
				'Self.posX += 0
			ElseIf ((Self.posX + Self.velX) - Self.BOSS5_WIDTH <= (MapManager.getCamera().x Shl 6)) Then
				'Self.posX += 0
			Else
				Self.posX += Self.velX
			EndIf
		End
		
		Method hurt_air_control:Void()
			hurt_side_cotrol()
			
			Self.velY += GRAVITY
			Self.posY += Self.velY
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(knucklesAni)
			Animation.closeAnimation(BoomAni)
			Animation.closeAnimation(boatAni)
			Animation.closeAnimation(escapefaceAni)
			
			knucklesAni = Null
			BoomAni = Null
			boatAni = Null
			escapefaceAni = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.dead Or p <> player) Then
				Return
			EndIf
			
			If (p.isAttackingEnemy()) Then
				Select (Self.state)
					Case STATE_FRESH_ATTACK_TRANS, STATE_FRESH_HURT_KNOCK, STATE_FRESH_HURT_AIR, STATE_FRESH_HURT_LAND, STATE_MACHINE_ATTACK_TRANS, STATE_MACHINE_HURT_KNOCK, STATE_MACHINE_HURT_AIR, STATE_MACHINE_HURT_LAND, STATE_MACHINE_KO_AIR, STATE_MACHINE_KO_LAND, STATE_MACHINE_BROKEN, STATE_MACHINE_PIECES, STATE_ESCAPE
						' Nothing so far.
					Case STATE_FRESH_BALL_HORIZON_ATTACK_READY, STATE_FRESH_BALL_HORIZON_ATTACK_FIGHT, STATE_FRESH_BALL_UP, STATE_FRESH_FLY, STATE_MACHINE_BALL_HORIZON_ATTACK_READY, STATE_MACHINE_BALL_HORIZON_ATTACK_FIGHT, STATE_MACHINE_BALL_UP, STATE_MACHINE_FLY
						p.beHurt()
					Case STATE_FRESH_DEFENCE_READY, STATE_FRESH_DEFENCING, STATE_FRESH_DEFENCE_BACK, STATE_MACHINE_DEFENCE_READY, STATE_MACHINE_DEFENCING, STATE_MACHINE_DEFENCE_BACK
						PlayerHurtBall(p, direction)
					Default
						Self.enemyDirct = direction
						
						HurtLogic()
				End Select
			Else
				Select (Self.state)
					Case STATE_FRESH_READY, STATE_FRESH_FLY_DRIP_READY, STATE_FRESH_FLY_DRIPPING, STATE_FRESH_FLY_DRIP_LAND, STATE_FRESH_HURT_KNOCK, STATE_FRESH_HURT_AIR, STATE_FRESH_HURT_LAND, STATE_MACHINE_READY, STATE_MACHINE_ATTACK_TRANS, STATE_MACHINE_FLY_DRIP_READY, STATE_MACHINE_FLY_DRIPPING, STATE_MACHINE_FLY_DRIP_LAND, STATE_MACHINE_HURT_KNOCK, STATE_MACHINE_HURT_AIR, STATE_MACHINE_HURT_LAND, STATE_MACHINE_KO_AIR, STATE_MACHINE_KO_LAND, STATE_MACHINE_BROKEN, STATE_MACHINE_PIECES, STATE_ESCAPE
						' Nothing so far.
					Default
						p.beHurt()
				End Select
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			Select (Self.state)
				Case STATE_FRESH_ATTACK_TRANS, STATE_FRESH_HURT_KNOCK, STATE_FRESH_HURT_AIR, STATE_FRESH_HURT_LAND, STATE_MACHINE_ATTACK_TRANS, STATE_MACHINE_HURT_KNOCK, STATE_MACHINE_HURT_AIR, STATE_MACHINE_HURT_LAND, STATE_MACHINE_KO_AIR, STATE_MACHINE_KO_LAND, STATE_MACHINE_BROKEN, STATE_MACHINE_PIECES, STATE_ESCAPE, STATE_FRESH_DEFENCE_READY, STATE_FRESH_DEFENCING, STATE_FRESH_DEFENCE_BACK, STATE_MACHINE_DEFENCE_READY, STATE_MACHINE_DEFENCING, STATE_MACHINE_DEFENCE_BACK
					PlayerHurtBall(p, direction)
				Default
					Self.enemyDirct = direction
					
					HurtLogic()
			End Select
		End
		
		Method HurtLogic:Void()
			If (Not Self.IsHurt) Then
				player.doAttackPose(Self, Self.enemyDirct)
				
				Self.HP -= 1
				
				Self.velY = -Abs(Self.velocity)
				
				If (player.getVelX() > 0) Then
					Self.velX = (Abs(Self.velocity) / 2) ' Shr 1
				Else
					Self.velX = ((-Abs(Self.velocity)) / 2) ' Shr 1
				EndIf
				
				hurt_side_cotrol()
				
				Self.IsHurt = True
				
				If (Self.HP >= halfLifeNum()) Then
					changeAniState(Self.knuckdrawer, F_HURT_KNOCK, False) ' STATE_FRESH_BALL_HORIZON_ATTACK_READY ' 5
					
					Self.state = STATE_FRESH_HURT_KNOCK
					
					If (Self.HP = halfLifeNum()) Then
						isBossHalf = True
						
						SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_03, True)
					Else
						isBossHalf = False
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_143, False)
					EndIf
				ElseIf (Self.HP = 0) Then
					changeAniState(Self.knuckdrawer, M_KO_AIR, True)
					
					Self.state = STATE_MACHINE_KO_AIR
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_144, False)
				Else
					changeAniState(Self.knuckdrawer, M_HURT_KNOCK, False)
					
					Self.state = STATE_MACHINE_HURT_KNOCK
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_143, False)
				EndIf
				
				Self.COLLISION_WIDTH = 64
				Self.COLLISION_HEIGHT = 64
			EndIf
		End
		
		Method PlayerHurtBall:Void(player:PlayerObject, direction:Int)
			Local playerVelX:= Abs(player.getVelX())
			Local preAnimationId:= player.getAnimationId()
			
			Select (direction)
				Case DIRECTION_UP
					player.beStop(Self.collisionRect.y1, direction, Self)
				Case DIRECTION_DOWN, DIRECTION_NONE
					player.beStop(Self.collisionRect.y0, direction, Self)
				Case DIRECTION_LEFT
					player.beStop(Self.collisionRect.x1, direction, Self)
					
					player.setVelX(playerVelX)
				Case DIRECTION_RIGHT
					player.beStop(Self.collisionRect.x0, direction, Self)
					
					player.setVelX(-playerVelX)
			End Select
			
			player.setAnimationId(preAnimationId)
			
			If (Self.defence_cnt < defence_cnt_max) Then
				Self.defence_cnt += 1
			Else
				Self.IsPlayerRunaway = True
			EndIf
			
			If (player.getCharacterID() = DIRECTION_RIGHT) Then
				soundInstance.playSe(SoundSystem.SE_132)
			EndIf
		End
		
		Method IsNeedforDefence:Bool(state:Int)
			Return (state = STATE_FRESH_WAIT_0 And player.isAttackingEnemy() And player.isOnGound())
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Self.boomX = preX
				Self.boomY = preY
				
				Local boomGroundY:= Self.getGroundY(Self.boomX, Self.boomY)
				
				' Magic number: 1024
				If ((1024 + Self.boomY + Self.velY) > boomGroundY) Then
					Self.boomY = (boomGroundY - 1024)
				EndIf
	
				If (Self.state > 0) Then
					isBossEnter = True
				EndIf
	
				Select (Self.state)
					Case STATE_FRESH_WAIT_0
						If (player.getFootPositionX() >= BEFORE_MEET_LINE) Then
							Self.state = STATE_FRESH_WAIT_1
							
							MapManager.setCameraUpLimit(1128 - (3 * MapManager.CAMERA_HEIGHT) / 4)
							MapManager.setCameraDownLimit(1128 + (MapManager.CAMERA_HEIGHT) / 4) ' 1 * MapManager.CAMERA_HEIGHT
						EndIf
					Case STATE_FRESH_WAIT_1
						If (player.getFootPositionX() >= MEET_SONIC_LINE) Then
							player.setMeetingBoss(False)
							
							MapManager.setCameraLeftLimit(SIDE_LEFT)
							MapManager.setCameraRightLimit(9496)
						Else
							MapManager.setCameraLeftLimit(MapManager.getCamera().x)
						EndIf
						
						' Magic number: 30
						If (Self.posX < ((MapManager.getCamera().x + MapManager.CAMERA_WIDTH - 30) Shl 6)) Then
							Self.changeAniState(Self.knuckdrawer, F_READY, False)
							
							' Magic numbers: 1024, 1664
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1664
							
							Self.state = STATE_FRESH_WAKE
							
							bossFighting = True
							bossID = ENEMY_BOSS5
							
							SoundSystem.getInstance().playBgm(23)
						EndIf
					Case STATE_FRESH_WAKE
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniState(Self.knuckdrawer, F_WAIT, True)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1664
							Self.talk_cnt = 1
						}
						
						If (Self.talk_cnt >= 1) Then
							Self.talk_cnt += 1
							
							If (Self.talk_cnt = talk_cnt_max) Then
								player.setMeetingBoss(True)
								player.setOutOfControl(Self)
								
								player.setAnimationId(PlayerObject.ANI_VS_FAKE_KNUCKLE)
							ElseIf (Self.talk_cnt >= 19 And player.getAnimationId() = PlayerObject.ANI_STAND) Then
								Self.state = STATE_FRESH_READY
								
								player.releaseOutOfControl()
							EndIf
						EndIf
					Case 3:
						Self.state = Self.randomSetState()
						break
					Case 4:
						Self.alert_state = Self.checkPlayerInEnemyAlertRange(Self.posX Shr 6, Self.posY Shr 6, 2 * Self.fight_alert_range)
						If (Self.IsNeedforDefence(Self.alert_state)) {
							Self.changeAniState(Self.knuckdrawer, F_DEFENCE_READY, False)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1024
							Self.state = 16
							soundInstance.playSe(SoundSystem.SE_132)
							Self.IsPlayerRunaway = False
							Self.defence_cnt = 0
						} else If (Self.ready_cnt < 24) {
							++Self.ready_cnt
						} else {
							Self.ready_cnt = 0
							Self.state = 3
							Self.prestate = 4
						}
						break
					Case 5:
						If (Self.horizonAttackReady_cnt < Self.horizonAttackReady_cnt_max) {
							++Self.horizonAttackReady_cnt
						} else {
							byte var12
							If (Self.IsHurt) {
								var12 = F_BALL_A_HURT
							} else {
								var12 = F_BALL_A
							}
		
							Self.changeAniState(Self.knuckdrawer, var12, True)
							Self.COLLISION_WIDTH = 1536
							Self.COLLISION_HEIGHT = 1536
							Self.horizonAttackReady_cnt = 0
							Self.state = 6
							soundInstance.playSe(SoundSystem.SE_110)
						}
						break
					Case 6:
						Self.IsHurt = False
						If (Self.AttackStartDirection > 0) {
							If (Self.posX <= Self.limitLeftX) {
								Self.posX = Self.limitLeftX
								Self.IsConner = True
							} else {
								Self.posX += Self.horizon_move_speed
							}
						} else If (Self.posX >= Self.limitRightX) {
							Self.posX = Self.limitRightX
							Self.IsConner = True
						} else {
							Self.posX += Self.horizon_move_speed
						}
		
						If (Self.IsConner) {
							Self.horizonAttackReady_cnt = 0
							Self.IsConner = False
							Self.state = 3
							Self.prestate = 6
						}
						break
					Case 7:
						If (Self.posY <= Self.fly_top) {
							Self.posY = Self.fly_top
							Self.changeAniState(Self.knuckdrawer, F_FLY_A, True)
							Self.AttackStartDirection = Self.posX - player.getFootPositionX()
							Self.COLLISION_WIDTH = 960
							Self.COLLISION_HEIGHT = 1472
							Self.state = 8
						} else {
							Self.posY -= Self.fly_up_speed1
						}
						break
					Case 8:
						Self.IsHurt = False
						If (Self.AttackStartDirection > 0) {
							If (player.getFootPositionX() - Self.fly_drip_offset > Self.limitLeftX) {
								Self.fly_attack_site = player.getFootPositionX() - Self.fly_drip_offset
							} else {
								Self.fly_attack_site = Self.limitLeftX
							}
		
							If (Self.posX + Self.fly_move_x_speed1 <= Self.fly_attack_site) {
								Self.posX = Self.fly_attack_site
								Self.changeAniStateNoTrans(Self.knuckdrawer, 10, False)
								Self.COLLISION_WIDTH = 1920
								Self.COLLISION_HEIGHT = 2432
								Self.state = 9
							} else {
								Self.posX += Self.fly_move_x_speed1
								Self.posY += Self.fly_move_y_speed1
							}
						} else {
							If (player.getFootPositionX() + Self.fly_drip_offset < Self.limitRightX) {
								Self.fly_attack_site = player.getFootPositionX() + Self.fly_drip_offset
							} else {
								Self.fly_attack_site = Self.limitRightX
							}
		
							If (Self.posX + Self.fly_move_x_speed1 >= Self.fly_attack_site) {
								Self.posX = Self.fly_attack_site
								Self.changeAniStateNoTrans(Self.knuckdrawer, 10, False)
								Self.COLLISION_WIDTH = 1408
								Self.COLLISION_HEIGHT = 2432
								Self.state = 9
							} else {
								Self.posX += Self.fly_move_x_speed1
								Self.posY += Self.fly_move_y_speed1
							}
						}
						break
					Case 9:
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniStateNoTrans(Self.knuckdrawer, 11, True)
							Self.COLLISION_WIDTH = 1536
							Self.COLLISION_HEIGHT = 2432
							Self.state = 10
							Self.velY = 0
						}
						break
					Case 10:
						If (Self.posY + Self.velY >= Self.getGroundY(Self.posX, Self.posY)) {
							Self.posY = Self.getGroundY(Self.posX, Self.posY)
							Self.changeAniStateNoTrans(Self.knuckdrawer, 12, False)
							Self.COLLISION_WIDTH = 1408
							Self.COLLISION_HEIGHT = 1920
							Self.state = 11
						} else {
							Self.velY += GRAVITY
							Self.posY += Self.velY
						}
						break
					Case 11:
						If (Self.knuckdrawer.checkEnd()) {
							Self.state = 3
							Self.prestate = 11
						}
						break
					Case 12:
						If (Self.knuckdrawer.checkEnd()) {
							Self.state = 3
							Self.prestate = 12
						} else {
							If (Self.knuckdrawer.getCurrentFrame() <> 3 And Self.knuckdrawer.getCurrentFrame() <> 4 And Self.knuckdrawer.getCurrentFrame() <> 5 And Self.knuckdrawer.getCurrentFrame() <> 6 And Self.knuckdrawer.getCurrentFrame() <> 11 And Self.knuckdrawer.getCurrentFrame() <> 12) {
								Self.COLLISION_WIDTH = 1536
								Self.COLLISION_HEIGHT = 1920
							} else {
								Self.COLLISION_WIDTH = 3584
								Self.COLLISION_HEIGHT = 2176
							}
		
							If (Self.knuckdrawer.getCurrentFrame() = 1 Or Self.knuckdrawer.getCurrentFrame() = 5) {
								soundInstance.playSe(SoundSystem.SE_126)
							}
						}
						break
					Case 13:
						Self.flydefence.setHurtState(False)
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniStateNoTrans(Self.knuckdrawer, 6, True)
							Self.state = 14
						} else {
							Self.hurt_air_control()
							If (isBossHalf) {
								++damageframe
								damageframe Mod= 11
								If (damageframe Mod 2 = 0) {
									SoundSystem.getInstance().playSe(SoundSystem.SE_144)
								}
							}
						}
						break
					Case 14:
						Self.flydefence.setHurtState(False)
						If (Self.posY + Self.velY >= Self.getGroundY(Self.posX, Self.posY)) {
							Self.posY = Self.getGroundY(Self.posX, Self.posY)
							Self.changeAniStateNoTrans(Self.knuckdrawer, 7, False)
							Self.state = 15
						} else {
							Self.hurt_air_control()
							If (isBossHalf) {
								damageframe += 1
								damageframe Mod= 11
								
								If (damageframe Mod 2 = 0) {
									SoundSystem.getInstance().playSe(SoundSystem.SE_144)
								}
							}
						}
						break
					Case 15:
						Self.flydefence.setHurtState(False)
						If (Self.knuckdrawer.checkEnd()) {
							If (Self.HP = Self.halfLifeNum()) {
								Self.state = 20
								Self.prestate = 32
							} else {
								Self.state = 3
								Self.prestate = 15
							}
						}
						break
					Case 16:
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniState(Self.knuckdrawer, F_DEFENCING, True)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1024
							Self.state = 17
						}
						break
					Case 17:
						If (Self.IsPlayerRunaway Or Not player.isAttackingEnemy() Or Not player.isOnGound()) {
							Self.changeAniState(Self.knuckdrawer, F_DEFENCE_BACK, False)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1024
							Self.state = 18
						}
						break
					Case 18:
						If (Self.knuckdrawer.checkEnd()) {
							Self.state = 3
							Self.prestate = 18
							Self.IsPlayerRunaway = False
						}
						break
					Case 19:
						Self.alert_state = Self.checkPlayerInEnemyAlertRange(Self.posX Shr 6, Self.posY Shr 6, 2 * Self.fight_alert_range)
						If (Self.IsNeedforDefence(Self.alert_state)) {
							Self.changeAniState(Self.knuckdrawer, M_DEFENCE_READY, False)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1024
							Self.state = 33
							Self.IsPlayerRunaway = False
							Self.defence_cnt = 0
						} else If (Self.ready_cnt < 24) {
							++Self.ready_cnt
						} else {
							Self.ready_cnt = 0
							Self.state = 20
							Self.prestate = 19
						}
						break
					Case 20:
						Self.state = Self.randomSetState()
						break
					Case 21:
						If (Self.horizonAttackReady_cnt < Self.horizonAttackReady_cnt_max) {
							++Self.horizonAttackReady_cnt
						} else {
							byte var11
							If (Self.IsHurt) {
								var11 = M_BALL_A_HURT
							} else {
								var11 = M_BALL_A
							}
		
							Self.changeAniState(Self.knuckdrawer, var11, True)
							Self.COLLISION_WIDTH = 1536
							Self.COLLISION_HEIGHT = 1536
							Self.horizonAttackReady_cnt = 0
							Self.state = 22
							soundInstance.playSe(SoundSystem.SE_110)
						}
						break
					Case 22:
						Self.IsHurt = False
						If (Self.AttackStartDirection > 0) {
							If (Self.posX <= Self.limitLeftX) {
								Self.posX = Self.limitLeftX
								Self.IsConner = True
							} else {
								Self.posX += Self.horizon_move_speed
							}
						} else If (Self.posX >= Self.limitRightX) {
							Self.posX = Self.limitRightX
							Self.IsConner = True
						} else {
							Self.posX += Self.horizon_move_speed
						}
		
						If (Self.IsConner) {
							Self.horizonAttackReady_cnt = 0
							Self.IsConner = False
							Self.state = 20
							Self.prestate = 22
						}
						break
					Case 23:
						If (Self.posY <= Self.fly_top) {
							Self.posY = Self.fly_top
							Self.changeAniState(Self.knuckdrawer, M_FLY_A, True)
							Self.AttackStartDirection = Self.posX - player.getFootPositionX()
							Self.COLLISION_WIDTH = 960
							Self.COLLISION_HEIGHT = 1472
							Self.state = 24
						} else {
							Self.posY -= Math.abs(Self.velocity)
						}
						break
					Case 24:
						Self.IsHurt = False
						If (Self.AttackStartDirection > 0) {
							If (player.getFootPositionX() - Self.fly_drip_offset > Self.limitLeftX) {
								Self.fly_attack_site = player.getFootPositionX() - Self.fly_drip_offset
							} else {
								Self.fly_attack_site = Self.limitLeftX
							}
		
							If (Self.posX + Self.fly_move_x_speed1 <= Self.fly_attack_site) {
								Self.posX = Self.fly_attack_site
								Self.changeAniStateNoTrans(Self.knuckdrawer, 28, False)
								Self.COLLISION_WIDTH = 1920
								Self.COLLISION_HEIGHT = 2432
								Self.state = 25
							} else {
								Self.posX += Self.fly_move_x_speed1
								Self.posY += Self.fly_move_y_speed1
							}
						} else {
							If (player.getFootPositionX() + Self.fly_drip_offset < Self.limitRightX) {
								Self.fly_attack_site = player.getFootPositionX() + Self.fly_drip_offset
							} else {
								Self.fly_attack_site = Self.limitRightX
							}
		
							If (Self.posX + Self.fly_move_x_speed1 >= Self.fly_attack_site) {
								Self.posX = Self.fly_attack_site
								Self.changeAniStateNoTrans(Self.knuckdrawer, 28, False)
								Self.COLLISION_WIDTH = 1408
								Self.COLLISION_HEIGHT = 2432
								Self.state = 25
							} else {
								Self.posX += Self.fly_move_x_speed1
								Self.posY += Self.fly_move_y_speed1
							}
						}
						break
					Case 25:
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniStateNoTrans(Self.knuckdrawer, 29, True)
							Self.COLLISION_WIDTH = 1536
							Self.COLLISION_HEIGHT = 2432
							Self.state = 26
							Self.velY = 0
						}
						break
					Case 26:
						If (Self.posY + Self.velY >= Self.getGroundY(Self.posX, Self.posY)) {
							Self.posY = Self.getGroundY(Self.posX, Self.posY)
							Self.changeAniStateNoTrans(Self.knuckdrawer, 30, False)
							Self.COLLISION_WIDTH = 1408
							Self.COLLISION_HEIGHT = 1920
							Self.state = 27
						} else {
							Self.velY += GRAVITY
							Self.posY += Self.velY
						}
						break
					Case 27:
						If (Self.knuckdrawer.checkEnd()) {
							Self.state = 20
							Self.prestate = 27
						}
						break
					Case 28:
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniState(Self.knuckdrawer, M_MISSILE_LAUNCH, False)
							Self.COLLISION_WIDTH = 1408
							Self.COLLISION_HEIGHT = 2176
							Self.state = 29
							If (Self.posX - player.getFootPositionX() > 0) {
								BulletObject.addBullet(16, Self.posX - 1280, Self.posY - 1280, -320, 0)
							} else {
								BulletObject.addBullet(16, 1280 + Self.posX, Self.posY - 1280, 320, 0)
							}
		
							MapManager.setShake(10)
						}
						break
					Case 29:
						Self.IsHurt = False
						If (Self.knuckdrawer.checkEnd()) {
							Self.state = 20
							Self.prestate = 29
						}
						break
					Case 30:
						Self.flydefence.setHurtState(False)
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniStateNoTrans(Self.knuckdrawer, 24, True)
							Self.state = 31
						} else {
							Self.hurt_air_control()
						}
						break
					Case 31:
						Self.flydefence.setHurtState(False)
						If (Self.posY + Self.velY >= Self.getGroundY(Self.posX, Self.posY)) {
							Self.posY = Self.getGroundY(Self.posX, Self.posY)
							Self.changeAniStateNoTrans(Self.knuckdrawer, 25, False)
							Self.state = 32
						} else {
							Self.hurt_air_control()
						}
						break
					Case 32:
						Self.flydefence.setHurtState(False)
						If (Self.knuckdrawer.checkEnd()) {
							Self.state = 20
							Self.prestate = 32
						}
						break
					Case 33:
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniState(Self.knuckdrawer, M_DEFENCING, True)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1024
							Self.state = 34
						}
						break
					Case 34:
						If (Self.IsPlayerRunaway Or Not player.isAttackingEnemy() Or Not player.isOnGound()) {
							Self.changeAniState(Self.knuckdrawer, M_DEFENCE_BACK, False)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1024
							Self.state = 35
						}
						break
					Case 35:
						If (Self.knuckdrawer.checkEnd()) {
							Self.changeAniState(Self.knuckdrawer, M_WAIT, False)
							Self.COLLISION_WIDTH = 1024
							Self.COLLISION_HEIGHT = 1664
							Self.state = 20
							Self.prestate = 35
							Self.IsPlayerRunaway = False
						}
						break
					Case 36:
						If (Self.posY + Self.velY >= Self.getGroundY(Self.posX, Self.posY)) {
							Self.posY = Self.getGroundY(Self.posX, Self.posY)
							Self.changeAniState(Self.knuckdrawer, M_KO_LAND, True)
							Self.state = 37
						} else {
							Self.hurt_air_control()
						}
						break
					Case 37:
						If (Self.KOWaitCnt < Self.KOWaitCntMax) {
							++Self.KOWaitCnt
						} else {
							Self.state = 38
							Self.bossbroken = new BossBroken(ENEMY_BOSS5, Self.posX Shr 6, Self.posY Shr 6, 0, 0, 0, 0)
							addGameObject(Self.bossbroken, Self.posX Shr 6, Self.posY Shr 6)
							Self.bossbroken.setTotalCntMax(6)
							Self.bossbroken.setJumpTime(9)
						}
						break
					Case 38:
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
						If (Self.bossbroken.getEndState()) {
							Self.state = 39
							int[] var9 = new int[]{6, 4}
							Self.pos = (int[][])Array.newInstance(Integer.TYPE, var9)
		
							for(int var10 = 0 var10 < Self.pos.length ++var10) {
								Self.pos[var10][0] = Self.posX
								Self.pos[var10][1] = Self.posY - Self.boom_offset
								Self.pos[var10][2] = Self.Vix[MyRandom.nextInt(Self.Vix.length)]
								Self.pos[var10][3] = Self.Viy[MyRandom.nextInt(Self.Viy.length)]
							}
						}
						break
					Case 39:
						for(int var5 = 0 var5 < Self.pos.length ++var5) {
							int[] var6 = Self.pos[var5]
							var6[0] += Self.pos[var5][2]
							int[] var7 = Self.pos[var5]
							var7[3] += (GRAVITY / 2) ' Shr 1
							int[] var8 = Self.pos[var5]
							var8[1] += Self.pos[var5][3]
							If (Self.pos[var5][1] >= Self.posY) {
								++Self.pieces_drip_cnt
							}
						}
		
						If (Self.pieces_drip_cnt >= Self.pos.length) {
							Self.posX = 609792
							Self.posY = 69120
							Self.fly_end = 607744
							Self.escapefacedrawer.setActionId(0)
							Self.escapefacedrawer.setLoop(True)
							Self.WaitCnt = 0
							Self.state = 40
							MapManager.setCameraLeftLimit(9360)
							MapManager.setCameraRightLimit(EGG_SIDE_RIGHT)
							bossFighting = False
							player.getBossScore()
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
						}
						break
					Case 40:
						If (Self.posX <= MapManager.getCamera().x + MapManager.CAMERA_WIDTH - 30 Shl 6 And Self.WaitCnt = 0) {
							Self.escapefacedrawer.setActionId(2)
							Self.escapefacedrawer.setLoop(False)
							Self.WaitCnt = 1
							int var3 = MapManager.getCamera().x
							int var4 = var3 + MapManager.CAMERA_WIDTH
							MapManager.setCameraLeftLimit(var3)
							MapManager.setCameraRightLimit(var4)
						}
		
						If (Self.escapefacedrawer.checkEnd() And Self.WaitCnt = 1) {
							Self.escapefacedrawer.setActionId(0)
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setLoop(False)
							Self.WaitCnt = 2
						}
		
						If (Self.WaitCnt = 2 And Self.boatdrawer.checkEnd()) {
							Self.escapefacedrawer.setActionId(0)
							Self.escapefacedrawer.setTrans(2)
							Self.escapefacedrawer.setLoop(True)
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setTrans(2)
							Self.boatdrawer.setLoop(False)
							Self.WaitCnt = 3
						}
		
						If (Self.WaitCnt = 3 And Self.boatdrawer.checkEnd()) {
							Self.boatdrawer.setActionId(0)
							Self.boatdrawer.setTrans(2)
							Self.boatdrawer.setLoop(True)
							Self.WaitCnt = 4
						}
		
						If (Self.WaitCnt = 4 Or Self.WaitCnt = 5) {
							Self.posX += Self.escape_v
						}
		
						If (Self.posX - Self.fly_end > Self.fly_range And Self.WaitCnt = 4) {
							Self.WaitCnt = 5
						}
		
						If (Self.WaitCnt = 5) {
							If (Self.escape_cnt < Self.escape_cnt_max) {
								++Self.escape_cnt
							} else {
								Self.WaitCnt = 6
							}
						}
		
						If (Self.WaitCnt = 6) {
							addGameObject(new Cage(MapManager.getCamera().x + (MapManager.CAMERA_WIDTH / 2) Shl 6, 65280)) ' Shr 1
							
							Self.WaitCnt = 7
						}
		
						Self.checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
	
				Self.flydefence.logic(Self.posX, Self.posY, Self.AttackStartDirection)
				
				If (Self.state <> 8 And Self.state <> 24) {
					Self.flydefence.setCollAvailable(False)
				Else
					Self.flydefence.setCollAvailable(True)
					
					If (Self.flydefence.getHurtState()) {
						Self.HurtLogic()
						Self.flydefence.setHurtState(False)
					EndIf
				EndIf
	
				Self.refreshCollisionRect(Self.posX Shr 6, Self.posY Shr 6)
				Self.checkWithPlayer(preX, preY, Self.posX, Self.posY)
			}
		End
		
		' This method's behavior may change in the future:
		Method randomSetState:Int()
			Self.missile_alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), Self.missile_alert_range)
			
			Local newState:= STATE_FRESH_WAIT_0
			
			If (Self.first_jump_cnt >= first_jump_cnt_max) Then
				newState = pickRandomState()
			Else
				Self.first_jump_cnt += 1
				
				If (CanFreshFight()) Then
					newState = STATE_FRESH_FIGHT
				Else
					newState = STATE_FRESH_BALL_UP
					
					soundInstance.playSe(SoundSystem.SE_116)
				EndIf
			EndIf
			
			Local drawState:Int
			
			Select (newState)
				Case STATE_FRESH_READY
					If (Self.IsHurt) Then
						drawState = F_WAIT_HURT
					Else
						drawState = F_WAIT
					EndIf
					
					changeAniState(Self.knuckdrawer, drawState, True)
					
					' Magic numbers: 1024, 1664
					Self.COLLISION_WIDTH = 1024
					Self.COLLISION_HEIGHT = 1664
				Case STATE_FRESH_BALL_HORIZON_ATTACK_READY
					Self.AttackStartDirection = (Self.posX - MIDDLE_SCREEN)
					
					If (MIDDLE_SCREEN > Self.posX) Then
						If (Self.horizon_move_speed < 0) Then
							Self.horizon_move_speed = -Self.horizon_move_speed
						EndIf
					ElseIf (Self.horizon_move_speed > 0) Then
						Self.horizon_move_speed = -Self.horizon_move_speed
					EndIf
					
					If (Self.IsHurt) Then
						drawState = F_BALL_B_HURT
					Else
						drawState = F_BALL_B
					EndIf
					
					changeAniState(Self.knuckdrawer, drawState, True, Self.AttackStartDirection)
					
					' Magic number: 1536
					Self.COLLISION_WIDTH = 1536
					Self.COLLISION_HEIGHT = 1536
				Case STATE_FRESH_BALL_UP
					If (Self.IsHurt) Then
						drawState = F_BALL_A_HURT
					Else
						drawState = F_BALL_A
					EndIf
					
					changeAniState(Self.knuckdrawer, drawState, True)
					
					' Magic number: 1536
					Self.COLLISION_WIDTH = 1536
					Self.COLLISION_HEIGHT = 1536
					
					Self.flydefence.setHurtState(False)
				Case STATE_FRESH_FIGHT
					changeAniState(Self.knuckdrawer, F_FIGHT, False)
					
					' Magic number: 1536
					Self.COLLISION_WIDTH = 1536
					Self.COLLISION_HEIGHT = 1920
				Case STATE_MACHINE_READY
					If (Self.IsHurt) Then
						drawState = M_WAIT_HURT
					Else
						drawState = M_WAIT
					EndIf
					
					changeAniState(Self.knuckdrawer, drawState, True)
					
					' Magic numbers: 1024, 1664
					Self.COLLISION_WIDTH = 1024
					Self.COLLISION_HEIGHT = 1664
				Case STATE_MACHINE_BALL_HORIZON_ATTACK_READY
					Self.AttackStartDirection = (Self.posX - MIDDLE_SCREEN)
					
					If (MIDDLE_SCREEN > Self.posX) Then
						If (Self.horizon_move_speed < 0) Then
							Self.horizon_move_speed = -Self.horizon_move_speed
						EndIf
					ElseIf (Self.horizon_move_speed > 0) Then
						Self.horizon_move_speed = -Self.horizon_move_speed
					EndIf
					
					If (Self.IsHurt) Then
						drawState = M_BALL_B_HURT
					Else
						drawState = M_BALL_B
					EndIf
					
					changeAniState(Self.knuckdrawer, drawState, True, Self.AttackStartDirection)
					
					' Magic number: 1536
					Self.COLLISION_WIDTH = 1536
					Self.COLLISION_HEIGHT = 1536
				Case STATE_MACHINE_BALL_UP
					If (Self.IsHurt) Then
						drawState = M_BALL_A_HURT
					Else
						drawState = M_BALL_A
					EndIf
					
					changeAniState(Self.knuckdrawer, drawState, True)
					
					' Magic number: 1536
					Self.COLLISION_WIDTH = 1536
					Self.COLLISION_HEIGHT = 1536
					
					Self.flydefence.setHurtState(False)
				Case STATE_MACHINE_MISSILE_READY
					If (Self.IsHurt) Then
						drawState = M_MISSILE_READY_HURT
					Else
						drawState = M_MISSILE_READY
					EndIf
					
					changeAniState(Self.knuckdrawer, drawState, False)
					
					' Magic numbers: 1024, 1664
					Self.COLLISION_WIDTH = 1024
					Self.COLLISION_HEIGHT = 1664
			End Select
			
			' Return the state we chose.
			Return newState
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				If (Self.state < STATE_MACHINE_PIECES) Then
					drawInMap(g, Self.knuckdrawer, Self.posX, Self.posY)
				EndIf
				
				If ((Self.HP = halfLifeNum() And Self.state >= STATE_FRESH_HURT_KNOCK And Self.state <= STATE_FRESH_HURT_LAND) Or (Self.HP = 0 And Self.state >= STATE_MACHINE_KO_AIR And Self.state <= STATE_MACHINE_KO_LAND)) Then
					drawInMap(g, Self.boomdrawer, Self.boomX, Self.boomY)
				EndIf
				
				If (Self.bossbroken <> Null) Then
					Self.bossbroken.draw(g)
				EndIf
				
				If (Self.state = STATE_MACHINE_PIECES) Then
					For Local i:= 0 Until Self.pos.Length
						Self.knuckdrawer.setActionId(i + M_PARTS_HEAD)
						
						drawInMap(g, Self.knuckdrawer, Self.pos[i][0], Self.pos[i][1])
					Next
				EndIf
				
				If (Self.state = STATE_ESCAPE) Then
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY)
					
					' Magic number: 1664
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - 1664)
				EndIf
				
				Self.flydefence.draw(g)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method changeAniState:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool)
			If (player.getFootPositionX() > Self.posX) Then
				AniDrawer.setActionId(state)
				AniDrawer.setTrans(TRANS_MIRROR)
				AniDrawer.setLoop(isloop)
				
				If (Self.velocity < 0) Then
					Self.velocity = -Self.velocity
				EndIf
				
				If (Self.fly_move_x_speed1 < 0) Then
					Self.fly_move_x_speed1 = -Self.fly_move_x_speed1
				EndIf
			Else
				AniDrawer.setActionId(state)
				AniDrawer.setTrans(TRANS_NONE)
				AniDrawer.setLoop(isloop)
				
				If (Self.velocity > 0) Then
					Self.velocity = -Self.velocity
				EndIf
				
				If (Self.fly_move_x_speed1 > 0) Then
					Self.fly_move_x_speed1 = -Self.fly_move_x_speed1
				EndIf
			EndIf
		End
		
		Method changeAniState:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool, direct:Int)
			If (direct < 0) Then
				AniDrawer.setActionId(state)
				AniDrawer.setTrans(TRANS_MIRROR)
				AniDrawer.setLoop(isloop)
				
				If (Self.velocity < 0) Then
					Self.velocity = -Self.velocity
				EndIf
				
				If (Self.fly_move_x_speed1 < 0) Then
					Self.fly_move_x_speed1 = -Self.fly_move_x_speed1
				EndIf
			Else
				AniDrawer.setActionId(state)
				AniDrawer.setTrans(TRANS_NONE)
				AniDrawer.setLoop(isloop)
				
				If (Self.velocity > 0) Then
					Self.velocity = -Self.velocity
				EndIf
				
				If (Self.fly_move_x_speed1 > 0) Then
					Self.fly_move_x_speed1 = -Self.fly_move_x_speed1
				EndIf
			EndIf
		End
		
		Method changeAniStateNoTrans:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool)
			AniDrawer.setActionId(state)
			AniDrawer.setLoop(isloop)
			
			If (player.getFootPositionX() > Self.posX) Then
				If (Self.velocity < 0) Then
					Self.velocity = -Self.velocity
				EndIf
				
				If (Self.fly_move_x_speed1 < 0) Then
					Self.fly_move_x_speed1 = -Self.fly_move_x_speed1
				EndIf
			Else
				If (Self.velocity > 0) Then
					Self.velocity = -Self.velocity
				EndIf
				
				If (Self.fly_move_x_speed1 > 0) Then
					Self.fly_move_x_speed1 = -Self.fly_move_x_speed1
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.state <> STATE_FRESH_FLY And Self.state <> STATE_MACHINE_FLY) Then
				Self.collisionRect.setRect(x - (Self.COLLISION_WIDTH / 2), y - Self.COLLISION_HEIGHT, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT) ' Shr 1
			ElseIf (Self.AttackStartDirection > 0) Then
				' Magic number: 1408
				Self.collisionRect.setRect(x - 1408, y - Self.COLLISION_HEIGHT, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT)
			Else
				' Magic number: 448
				Self.collisionRect.setRect(x + 448, y - Self.COLLISION_HEIGHT, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT)
			EndIf
		End
		
		Method close:Void()
			Self.knuckdrawer = Null
			Self.boomdrawer = Null
			Self.boatdrawer = Null
			Self.escapefacedrawer = Null
			Self.bossbroken = Null
			Self.flydefence = Null
		End
End