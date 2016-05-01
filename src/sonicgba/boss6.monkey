Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject

Friend sonicgba.boss6block
Friend sonicgba.boss6blockarray
Friend sonicgba.boss6bullet

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.boss6blockarray
	Import sonicgba.bossbroken
	Import sonicgba.bossobject
	Import sonicgba.bulletobject
	Import sonicgba.focusable
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss6 Extends BossObject
	Protected
		' Constant variable(s):
		
		' States:
		Const STATE_INIT:Int = 0
		Const STATE_ENTER_SHOW:Int = 1
		Const STATE_PRO:Int = 2
		Const STATE_BROKEN:Int = 3
		Const STATE_FALL:Int = 4
		Const STATE_ESCAPE:Int = 5
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 4096
		
		Const MACHINE_NORMAL_UP:Int = 0
		Const MACHINE_NORMAL_DOWN:Int = 1
		Const MACHINE_HURT:Int = 2
		Const MACHINE_TURN_UP:Int = 3
		Const MACHINE_TURN_DOWN:Int = 4
		Const MACHINE_FIRE_UP:Int = 5
		Const MACHINE_FIRE_DOWN:Int = 6
		
		Const ATTACK_MOVE:Int = 0
		Const ATTACK_FIRE:Int = 1
		Const ATTACK_HURT:Int = 2
		
		Const FACE_NORMAL:Int = 0
		Const FACE_SMILE:Int = 1
		Const FACE_HURT:Int = 2
		
		Const SHOW_BOSS_ENTER:Int = 0
		Const SHOW_BOSS_LAUGH:Int = 1
		Const SHOW_BOSS_END:Int = 2
		Const SHOW_BOSS_GOTO_PRO:Int = 3
		
		Const FACE_OFFSET:Int = 1024
		
		Const BROKEN_X:Int = 652032
		Const BROKEN_Y:Int = 145920
		
		Const DEBUG_BOSS6_1BLOOD:Bool = False
		Const DEBUG_BOSS6_WUDI:Bool = False
		
		Const ESCAPE_END_X:Int = 656000
		Const ESCAPE_END_Y:Int = 150400
		
		Const FIRE_CN_MAX:Int = 3
		Const HURT_CN_MAX:Int = 6
		
		Const FIRE_INTERVAL:Int = 19
		
		Const INIT_LAUGH_MAX:Int = 60
		
		Const INIT_STOP_POSX:Int = 648192
		
		Const MOVE_LIMIT_LEFT:Int = 640512
		Const MOVE_LIMIT_RIGHT:Int = 655872
		
		Const MOVE_SPEED:Int = 256
		
		Const NORMAL_SPEED_ACCELE:Int = 12
		
		Const OFFSET_Y:Int = 256
		
		Const RASH_DISTANCE_MAX_1:Int = 20480
		Const RASH_DISTANCE_MAX_2:Int = 30720
		
		Const SIDE_UP:Int = 1792
		Const SIDE_DOWN:Int = 1952
		Const SIDE_LEFT:Int = 9968
		Const SIDE_RIGHT:Int = 10288
		Const SIDE_END:Int = 2490
		
		Const TOP_SPEED:Int = 384
		
		Const TURN_OFFFSET_Y:Int = 512
		
		' Global variable(s):
		Global boatAni:Animation
		Global escapefaceAni:Animation
		Global faceAni:Animation
		Global machineAni:Animation
		
		' Fields:
		Field startFlag:Bool
		Field direct:Bool
		
		' From what I understand, this is for the last "phase" of the boss.
		Field isRash:Bool
		
		' Presumably, this is used to check if Eggman's face is visible.
		Field machineUp:Bool
		
		Field bossbroken:BossBroken
		Field blockArray:Boss6BlockArray
		
		Field boatdrawer:AnimationDrawer
		Field escapefacedrawer:AnimationDrawer
		Field faceDrawer:AnimationDrawer
		Field machineDrawer:AnimationDrawer
		
		Field WaitCnt:Int
		
		Field state:Int
		Field face_state:Int
		Field machine_state:Int
		
		Field last_attack_step:Int
		Field show_step:Int
		Field attack_step:Int
		
		Field attack_cn:Int
		Field attack_cn_max:Int
		
		Field escape_v:Int
		
		Field hurt_cn:Int
		Field laugh_cn:Int
		Field fire_cn:Int
		
		Field fire_time:Int
		
		Field fly_end:Int
		Field fly_top:Int
		Field fly_top_range:Int
		
		Field holdheadup_cn:Int
		Field holdheadup_cn_max:Int
		
		Field initPosY:Int
		
		Field rash_distance:Int
		
		Field speed:Int
		
		Field speedCount:Int
		
		Field wait_cnt:Int
		Field wait_cnt_max:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.machineUp = False
			
			Self.wait_cnt_max = 10
			
			Self.escape_v = TURN_OFFFSET_Y ' 512
			
			Self.fly_top_range = COLLISION_HEIGHT ' 4096
			
			Self.posY -= (Self.iTop * 8)
			
			Self.initPosY = (Self.posY - PlayerObject.DETECT_HEIGHT)
			
			Self.blockArray = New Boss6BlockArray((Self.posX - (Self.iLeft * 8)), Self.posY)
			
			Self.posX += (Self.iLeft * 8)
			
			Self.machineUp = False
			Self.isRash = False
			
			If (machineAni = Null) Then
				machineAni = New Animation("/animation/boss6_machine")
			EndIf
			
			Self.machineDrawer = machineAni.getDrawer(0, True, 0)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss4_face")
			EndIf
			
			Self.faceDrawer = faceAni.getDrawer(0, True, 0)
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(0, True, 0)
			
			If (escapefaceAni = Null) Then
				escapefaceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.escapefacedrawer = escapefaceAni.getDrawer(2, False, 0)
			
			Self.state = STATE_INIT
			
			setBossHP()
		End
		
		' Methods:
		
		' Extensions:
		Method onPlayerAttack:Void(p:PlayerObject, direction:Int) ' animationID:Int
			Self.HP -= 1
			
			p.doBossAttackPose(Self, direction)
			
			If (Self.HP > 0) Then
				Self.last_attack_step = Self.attack_step
				Self.attack_step = ATTACK_HURT
				
				setAniState(Self.machineDrawer, MACHINE_HURT)
				
				Self.machineDrawer.setLoop(True)
				
				setAniState(Self.faceDrawer, FACE_HURT)
				
				Self.hurt_cn = 0
			EndIf
			
			If (Self.HP <= 2) Then
				' Start the second "phase".
				Self.isRash = True
				
				Self.rash_distance = 0
			EndIf
			
			If (Self.HP = 0) Then
				Self.state = STATE_BROKEN
				
				Local x:= (Self.posX Shr 6)
				Local y:= (Self.posY Shr 6)
				
				Self.bossbroken = New BossBroken(ENEMY_BOSS6, x, y, 0, 0, 0, 0)
				
				MapManager.setCameraLeftLimit(MapManager.getCamera().x)
				MapManager.setCameraRightLimit(MapManager.getCamera().x + MapManager.CAMERA_WIDTH)
				MapManager.setCameraDownLimit(SIDE_END)
				
				GameObject.addGameObject(Self.bossbroken, x, y)
			EndIf
			
			playHitSound()
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(machineAni)
			Animation.closeAnimation(faceAni)
			Animation.closeAnimation(boatAni)
			Animation.closeAnimation(escapefaceAni)
			
			machineAni = Null
			faceAni = Null
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
				Select (direction)
					Case DIRECTION_DOWN
						If (Self.state = STATE_PRO And Self.attack_step <> ATTACK_HURT And Self.machineUp And p.getVelY() >= 0) Then
							onPlayerAttack(p, direction)
						EndIf
					Default
						' Nothing so far.
				End Select
			ElseIf (Self.state <> STATE_ESCAPE And Self.state <> STATE_BROKEN And Self.state <> STATE_FALL And Self.attack_step <> ATTACK_HURT And Self.state = STATE_PRO) Then
				p.beHurt()
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			Select (direction)
				Case DIRECTION_DOWN
					If (Self.state = STATE_PRO And Self.attack_step <> ATTACK_HURT And Self.machineUp) Then
						onPlayerAttack(p, direction)
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Self.blockArray.logic()
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				If (Not (Self.state = STATE_ESCAPE Or Self.state = STATE_BROKEN Or Self.state = STATE_FALL)) Then
					Self.posY = Self.blockArray.getBossY(Self.posX)
				EndIf
				
				If (Self.state > 0) Then
					isBossEnter = True
				EndIf
				
				Select (Self.state)
					Case STATE_INIT
						' Magic number: 637952
						
						If (player.getFootPositionX() >= 637952) Then
							MapManager.setCameraRightLimit(SIDE_RIGHT)
						EndIf
						
						If (player.getFootPositionY() >= Self.initPosY And player.getFootPositionX() >= 637952) Then
							Self.state = STATE_ENTER_SHOW
							
							player.setFootPositionY(Self.initPosY)
							player.setVelY(0)
							
							MapManager.setCameraUpLimit(SIDE_UP)
							MapManager.setCameraDownLimit(SIDE_DOWN)
							MapManager.setCameraLeftLimit(SIDE_LEFT)
							MapManager.setCameraRightLimit(SIDE_RIGHT)
							
							If (Not Self.IsPlayBossBattleBGM) Then
								bossFighting = True
								
								bossID = ENEMY_BOSS6
								
								SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_04, True)
								
								Self.IsPlayBossBattleBGM = True
							EndIf
							
							Self.show_step = SHOW_BOSS_ENTER
							
							setAniState(Self.machineDrawer, MACHINE_NORMAL_DOWN)
						EndIf
					Case STATE_ENTER_SHOW
						Select (Self.show_step)
							Case SHOW_BOSS_ENTER
								If (Self.posX <= INIT_STOP_POSX) Then
									Self.posX = INIT_STOP_POSX
									
									Self.show_step = SHOW_BOSS_LAUGH
									
									setAniState(Self.faceDrawer, FACE_SMILE)
									
									Self.laugh_cn = 0
								Else
									Self.posX -= OFFSET_Y
								EndIf
							Case SHOW_BOSS_LAUGH
								If (Self.laugh_cn >= INIT_LAUGH_MAX) Then
									Self.show_step = SHOW_BOSS_END
									
									Self.laugh_cn = 0
									
									setAniState(Self.faceDrawer, FACE_NORMAL)
								Else
									Self.laugh_cn += 1
								EndIf
							Case SHOW_BOSS_END
								Self.show_step = SHOW_BOSS_GOTO_PRO
							Case SHOW_BOSS_GOTO_PRO
								Self.state = STATE_PRO
								
								Self.direct = False
								
								' Magic number: 35
								Self.speedCount = 35
								
								Self.speed = 0
								
								Self.startFlag = True
						End Select
					Case STATE_PRO
						attackSet()
						
						Select (Self.attack_step)
							Case ATTACK_MOVE
								turnHead()
							Case ATTACK_FIRE
								turnHead()
								
								If (Self.machine_state <> MACHINE_TURN_UP) Then
									If (Self.fire_time < FIRE_INTERVAL) Then
										Self.fire_time += 1
									Else
										Self.fire_time = 0
										
										setAniState(Self.machineDrawer, PickValue(Self.machineUp, MACHINE_FIRE_UP, MACHINE_FIRE_DOWN))
										
										Self.machineDrawer.setLoop(False)
										
										BulletObject.addBullet(BulletObject.BULLET_BOSS6, Self.posX, Self.posY, player.getFootPositionX(), player.getFootPositionY())
										
										Self.fire_cn += 1
									EndIf
									
									If (Self.machineDrawer.checkEnd()) Then
										setAniState(Self.machineDrawer, PickValue(Self.machineUp, MACHINE_NORMAL_UP, MACHINE_NORMAL_DOWN))
										
										Self.machineDrawer.setLoop(True)
									EndIf
									
									If (Self.fire_cn >= 3) Then
										Self.fire_cn = 0
										
										Self.attack_step = ATTACK_MOVE
									EndIf
								EndIf
						End Select
						
						If (Self.face_state = FACE_HURT) Then
							If (Self.hurt_cn < MACHINE_FIRE_DOWN) Then
								Self.hurt_cn += 1
							Else
								Self.hurt_cn = 0
								
								setAniState(Self.machineDrawer, MACHINE_TURN_DOWN)
								
								Self.machineDrawer.setLoop(False)
								
								Self.face_state = FACE_NORMAL
								
								Self.attack_step = Self.last_attack_step
								
								Self.holdheadup_cn = (Self.holdheadup_cn_max - 2)
							EndIf
						EndIf
						
						If (Self.machineUp) Then
							If (Self.holdheadup_cn < Self.holdheadup_cn_max) Then
								Self.holdheadup_cn += 1
							Else
								Self.holdheadup_cn = 0
								
								setAniState(Self.machineDrawer, MACHINE_TURN_DOWN)
								
								Self.machineDrawer.setLoop(False)
								
								Self.machineUp = False
							EndIf
						EndIf
						
						If (Self.machine_state = MACHINE_TURN_DOWN And Self.machineDrawer.checkEnd()) Then
							setAniState(Self.machineDrawer, MACHINE_NORMAL_DOWN)
							
							Self.machineDrawer.setLoop(True)
						EndIf
						
						If (Self.attack_step <> ATTACK_HURT) Then
							Local speed:= 0
							
							Local i2:= 0
							
							Repeat
								Local z:= PickValue((Not Self.isRash), 1, PickValue((Self.HP = 2), 3, 4))
								
								If (i2 >= z) Then
									Self.posX += speed
									
									If (Self.posX <= MOVE_LIMIT_LEFT) Then
										Self.posX = MOVE_LIMIT_LEFT
									EndIf
									
									If (Self.posX >= MOVE_LIMIT_RIGHT) Then
										Self.posX = MOVE_LIMIT_RIGHT
									EndIf
									
									If (Self.isRash) Then
										Self.rash_distance += PickValue((speed > 0), speed, -speed)
										
										Local distance:= PickValue((Self.HP = 2), RASH_DISTANCE_MAX_1, RASH_DISTANCE_MAX_2)
										
										If (Self.rash_distance >= distance) Then
											Self.rash_distance = distance
											
											Self.isRash = False
											
											Exit
										EndIf
									EndIf
								EndIf
								
								speed += machineSpeed()
								
								i2 += 1
							Forever
						EndIf
					Case STATE_BROKEN
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
						
						' Magic number: 1280
						Local groundY:= (getGroundY(Self.posX, Self.posY) - 1280)
						
						If (Self.posY + Self.velY < groundY) Then
							Self.velY += 10
							
							Self.posY += Self.velY
							
						Else
							Self.state = STATE_FALL
							
							Self.escapefacedrawer.setActionId(4)
							Self.escapefacedrawer.setLoop(True)
							
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setLoop(True)
							
							Self.posY = groundY
							
							bossFighting = False
							
							' Magic number: 2372
							MapManager.setCameraDownLimit(2372)
							MapManager.calCameraImmidiately()
							
							Self.blockArray.setDisplayState()
						EndIf
					Case STATE_FALL
						' Magic number: 1280
						player.velY = 1280
						
						If (player.getFootPositionY() = getGroundY(player.footPointX, player.footPointY)) Then
							player.faceDirection = (player.posX < Self.posX)
							
							Self.state = STATE_ESCAPE
							
							Self.WaitCnt = 0
							
							Self.wait_cnt = 0
							
							Self.fly_top = ESCAPE_END_Y
							Self.fly_end = ESCAPE_END_X
							
							player.getBossScore()
							
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
							
							player.setAnimationId(PlayerObject.ANI_STAND)
							
							player.setOutOfControl(Null)
							
							player.totalVelocity = 0
						EndIf
					Case STATE_ESCAPE
						Self.wait_cnt += 1
						
						If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= Self.fly_top - Self.fly_top_range) Then
							Self.posY -= Self.escape_v
						EndIf
						
						If (Self.posY <= (Self.fly_top - Self.fly_top_range) And Self.WaitCnt = 0) Then
							Self.posY = (Self.fly_top - Self.fly_top_range)
							
							Self.escapefacedrawer.setActionId(0)
							
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setLoop(False)
							
							Self.WaitCnt = 1
						EndIf
						
						If (Self.WaitCnt = 1 And Self.boatdrawer.checkEnd()) Then
							Self.escapefacedrawer.setActionId(0)
							Self.escapefacedrawer.setTrans(TRANS_MIRROR)
							Self.escapefacedrawer.setLoop(True)
							
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setTrans(TRANS_MIRROR)
							Self.boatdrawer.setLoop(False)
							
							Self.WaitCnt = 2
						EndIf
						
						If (Self.WaitCnt = 2 And Self.boatdrawer.checkEnd()) Then
							Self.boatdrawer.setActionId(0)
							Self.boatdrawer.setTrans(TRANS_MIRROR)
							Self.boatdrawer.setLoop(True)
							Self.WaitCnt = 3
						EndIf
						
						If (Self.WaitCnt = 3 Or Self.WaitCnt = 4) Then
							Self.posX += Self.escape_v
							
							If (Self.posX - Self.fly_end > Self.fly_top_range) Then
								Self.posY -= Self.fly_top_range
							EndIf
						EndIf
						
						If (Self.posX > Self.fly_end And Self.WaitCnt = 3) Then
							player.releaseOutOfControl()
							
							player.setTerminal(PlayerObject.TER_STATE_LOOK_MOON) ' 2
							
							player.collisionState = PlayerObject.COLLISION_STATE_WALK
							
							MapManager.releaseCamera()
							MapManager.setFocusObj(Null)
							
							Self.WaitCnt = 4
						EndIf
				End Select
				
				refreshCollisionRect(Self.posX, Self.posY)
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				If (Not (Self.state = STATE_ESCAPE Or Self.state = STATE_FALL)) Then
					Self.blockArray.draw(g)
					
					drawInMap(g, Self.machineDrawer, Self.posX, Self.posY)
					
					If (Self.face_state <> 0) Then
						If (Self.machine_state = MACHINE_NORMAL_DOWN) Then
							Self.faceDrawer.setTrans(TRANS_MIRROR_ROT180)
							
							' Magic number: 128
							drawInMap(g, Self.faceDrawer, Self.posX, (Self.posY + FACE_OFFSET) + 128)
						Else
							
							If (Self.machineUp) Then
								Self.faceDrawer.setTrans(TRANS_NONE)
							Else
								Self.faceDrawer.setTrans(TRANS_MIRROR_ROT180)
							EndIf
							
							If (Not (Self.machine_state = MACHINE_TURN_DOWN Or Self.machine_state = MACHINE_TURN_UP Or Self.machine_state = MACHINE_NORMAL_DOWN)) Then
								drawInMap(g, Self.faceDrawer, Self.posX, Self.posY - FACE_OFFSET)
							EndIf
						EndIf
					EndIf
				EndIf
				
				If (Self.state = STATE_ESCAPE Or Self.state = STATE_FALL) Then
					' Magic number: 640
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY + 640)
					
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - (FACE_OFFSET))
				EndIf
				
				If (Self.bossbroken <> Null And Self.state = STATE_BROKEN) Then
					Self.bossbroken.draw(g)
				EndIf
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.machineDrawer = Null
			Self.faceDrawer = Null
			Self.blockArray = Null
			Self.bossbroken = Null
			Self.boatdrawer = Null
			Self.escapefacedrawer = Null
		End
	Private
		' Methods:
		Method setAniState:Void(aniDrawer:AnimationDrawer, state:Int)
			If (aniDrawer = Self.faceDrawer) Then
				Self.face_state = state
			EndIf
			
			If (aniDrawer = Self.machineDrawer) Then
				Self.machine_state = state
			EndIf
			
			aniDrawer.setActionId(state)
		End
		
		Method setAniState:Void(machine_state:Int, face_state:Int)
			Self.machineDrawer.setActionId(machine_state)
			Self.machineDrawer.setLoop(True)
			
			Self.faceDrawer.setActionId(face_state)
			Self.faceDrawer.setLoop(True)
			
			Self.face_state = face_state
		End
		
		Method machineSpeed:Int()
			If (Self.startFlag) Then
				' Magic numbers: 17, 25
				If (Self.speedCount > 17) Then
					Self.speed -= 25
				Else
					Self.speed += 25
				EndIf
				
				Self.speedCount -= 1
				
				If (Self.speedCount = 0) Then
					Self.speed = 0
					
					Self.startFlag = False
					Self.direct = True
				EndIf
			Else
				' Magic number: 35
				If (Self.speedCount > 35) Then
					Self.speed -= NORMAL_SPEED_ACCELE
				Else
					Self.speed += NORMAL_SPEED_ACCELE
				EndIf
				
				If (Self.direct) Then
					Self.speedCount += 1
					
					If (Self.speedCount = 70) Then
						Self.speed = 0
						
						Self.direct = False
					EndIf
				Else
					Self.speedCount -= 1
					
					If (Self.speedCount = 0) Then
						Self.speed = 0
						
						Self.direct = True
					EndIf
				EndIf
			EndIf
			
			Return Self.speed
		End
		
		Method attackSet:Void()
			Select (Self.HP)
				Case 1
					Self.attack_cn_max = 120
				Case 2
					Self.attack_cn_max = 140
				Case 3
					Self.attack_cn_max = 154
				Case 4
					Self.attack_cn_max = 173
				Default
					Self.attack_cn_max = 200
			End Select
			
			If (Self.attack_cn < Self.attack_cn_max) Then
				Self.attack_cn += 1
			Else
				Self.attack_cn = 0
				
				Self.attack_step = ATTACK_FIRE
				
				Self.fire_time = 0
				
				Self.fire_cn = 0
			EndIf
		End
		
		Method turnHead:Void()
			If (Self.machine_state = MACHINE_NORMAL_DOWN Or Self.machine_state = MACHINE_TURN_DOWN Or Self.machine_state = MACHINE_FIRE_DOWN) Then
				If ((Self.posY - Self.initPosY) - PlayerObject.DETECT_HEIGHT >= TURN_OFFFSET_Y) Then
					setAniState(Self.machineDrawer, MACHINE_TURN_UP)
					
					Self.machineDrawer.setLoop(False)
					
					Self.machineUp = True
					
					Self.holdheadup_cn = 0
					
					Local rnd:= MyRandom.nextInt(0, 100)
					
					If (rnd < 10) Then
						Self.holdheadup_cn_max = 24
					ElseIf (rnd < 50) Then
						Self.holdheadup_cn_max = 48
					ElseIf (rnd < 80) Then
						Self.holdheadup_cn_max = 80
					Else
						Self.holdheadup_cn_max = 128
					EndIf
				EndIf
			ElseIf (Self.machine_state = MACHINE_TURN_UP And Self.machineDrawer.checkEnd()) Then
				setAniState(Self.machineDrawer, MACHINE_NORMAL_UP)
				
				Self.machineDrawer.setLoop(True)
			EndIf
		End
End