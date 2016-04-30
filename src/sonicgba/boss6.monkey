Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	
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
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 4096
		
		' States:
		Const STATE_INIT:Int = 0
		Const STATE_ENTER_SHOW:Int = 1
		Const STATE_PRO:Int = 2
		Const STATE_BROKEN:Int = 3
		Const STATE_FALL:Int = 4
		Const STATE_ESCAPE:Int = 5
		
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
		Field direct:Bool
		Field isRash:Bool
		Field machineUp:Bool
		Field startFlag:Bool
		
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
			
			Self.machineUp = DEBUG_BOSS6_WUDI
			Self.wait_cnt_max = 10
			Self.escape_v = TURN_OFFFSET_Y
			Self.fly_top_range = COLLISION_HEIGHT
			Self.posX -= Self.iLeft * 8
			Self.posY -= Self.iTop * 8
			Self.initPosY = Self.posY - PlayerObject.DETECT_HEIGHT
			Self.blockArray = New Boss6BlockArray(Self.posX, Self.posY)
			Self.posX += Self.iLeft * 8
			Self.machineUp = DEBUG_BOSS6_WUDI
			Self.isRash = DEBUG_BOSS6_WUDI
			
			If (machineAni = Null) Then
				machineAni = New Animation("/animation/boss6_machine")
			EndIf
			
			Self.machineDrawer = machineAni.getDrawer(STATE_INIT, True, STATE_INIT)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss4_face")
			EndIf
			
			Self.faceDrawer = faceAni.getDrawer(STATE_INIT, True, STATE_INIT)
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(STATE_INIT, True, STATE_INIT)
			
			If (escapefaceAni = Null) Then
				escapefaceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.escapefacedrawer = escapefaceAni.getDrawer(STATE_PRO, DEBUG_BOSS6_WUDI, STATE_INIT)
			
			Self.state = STATE_INIT
			
			setBossHP()
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
		Public Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			
			If (Self.dead Or object <> player) Then
				Return
			EndIf
			
			If (player.isAttackingEnemy()) Then
				Select (direction)
					Case STATE_ENTER_SHOW
						
						If (Self.state = STATE_PRO And Self.attack_step <> STATE_PRO And Self.machineUp And player.getVelY() >= 0) Then
							Self.HP -= STATE_ENTER_SHOW
							player.doBossAttackPose(Self, direction)
							
							If (Self.HP > 0) Then
								Self.last_attack_step = Self.attack_step
								Self.attack_step = STATE_PRO
								setAniState(Self.machineDrawer, (Int) STATE_PRO)
								Self.machineDrawer.setLoop(True)
								setAniState(Self.faceDrawer, (Int) STATE_PRO)
								Self.hurt_cn = STATE_INIT
							EndIf
							
							If (Self.HP <= STATE_PRO) Then
								Self.isRash = True
								Self.rash_distance = STATE_INIT
							EndIf
							
							If (Self.HP = 0) Then
								Self.state = STATE_BROKEN
								Self.bossbroken = New BossBroken(27, Self.posX Shr MACHINE_FIRE_DOWN, Self.posY Shr MACHINE_FIRE_DOWN, STATE_INIT, STATE_INIT, STATE_INIT, STATE_INIT)
								MapManager.setCameraLeftLimit(MapManager.getCamera().x)
								MapManager.setCameraRightLimit(MapManager.getCamera().x + MapManager.CAMERA_WIDTH)
								MapManager.setCameraDownLimit(SIDE_END)
								GameObject.addGameObject(Self.bossbroken, Self.posX Shr MACHINE_FIRE_DOWN, Self.posY Shr MACHINE_FIRE_DOWN)
							EndIf
							
							If (Self.HP = 0) Then
								SoundSystem.getInstance().playSe(35)
							Else
								SoundSystem.getInstance().playSe(34)
							EndIf
						EndIf
						
					Default
				End Select
			ElseIf (Self.state <> STATE_ESCAPE And Self.state <> STATE_BROKEN And Self.state <> STATE_FALL And Self.attack_step <> STATE_PRO And Self.state = STATE_PRO) Then
				player.beHurt()
			EndIf
			
		End
		
		Public Method doWhileBeAttack:Void(object:PlayerObject, direction:Int, animationID:Int)
			Select (direction)
				Case STATE_ENTER_SHOW
					
					If (Self.state = STATE_PRO And Self.attack_step <> STATE_PRO And Self.machineUp) Then
						Self.HP -= STATE_ENTER_SHOW
						player.doBossAttackPose(Self, direction)
						
						If (Self.HP > 0) Then
							Self.last_attack_step = Self.attack_step
							Self.attack_step = STATE_PRO
							setAniState(Self.machineDrawer, (Int) STATE_PRO)
							Self.machineDrawer.setLoop(True)
							setAniState(Self.faceDrawer, (Int) STATE_PRO)
							Self.hurt_cn = STATE_INIT
						EndIf
						
						If (Self.HP <= STATE_PRO) Then
							Self.isRash = True
							Self.rash_distance = STATE_INIT
						EndIf
						
						If (Self.HP = 0) Then
							Self.state = STATE_BROKEN
							Self.bossbroken = New BossBroken(27, Self.posX Shr MACHINE_FIRE_DOWN, Self.posY Shr MACHINE_FIRE_DOWN, STATE_INIT, STATE_INIT, STATE_INIT, STATE_INIT)
							MapManager.setCameraLeftLimit(MapManager.getCamera().x)
							MapManager.setCameraRightLimit(MapManager.getCamera().x + MapManager.CAMERA_WIDTH)
							MapManager.setCameraDownLimit(SIDE_END)
							GameObject.addGameObject(Self.bossbroken, Self.posX Shr MACHINE_FIRE_DOWN, Self.posY Shr MACHINE_FIRE_DOWN)
						EndIf
						
						If (Self.HP = 0) Then
							SoundSystem.getInstance().playSe(35)
						Else
							SoundSystem.getInstance().playSe(34)
						EndIf
					EndIf
					
				Default
			EndIf
		End
		
		Private Method setAniState:Void(aniDrawer:AnimationDrawer, state:Int)
			
			If (aniDrawer = Self.faceDrawer) Then
				Self.face_state = state
			EndIf
			
			If (aniDrawer = Self.machineDrawer) Then
				Self.machine_state = state
			EndIf
			
			aniDrawer.setActionId(state)
		End
		
		Private Method setAniState:Void(machine_state:Int, face_state:Int)
			Self.machineDrawer.setActionId(machine_state)
			Self.machineDrawer.setLoop(True)
			Self.faceDrawer.setActionId(face_state)
			Self.faceDrawer.setLoop(True)
			Self.face_state = face_state
		End
		
		Private Method machineSpeed:Int()
			
			If (Self.startFlag) Then
				If (Self.speedCount > 17) Then
					Self.speed -= 25
				Else
					Self.speed += 25
				EndIf
				
				Self.speedCount -= STATE_ENTER_SHOW
				
				If (Self.speedCount = 0) Then
					Self.speed = STATE_INIT
					Self.startFlag = DEBUG_BOSS6_WUDI
					Self.direct = True
				EndIf
				
			Else
				
				If (Self.speedCount > 35) Then
					Self.speed -= NORMAL_SPEED_ACCELE
				Else
					Self.speed += NORMAL_SPEED_ACCELE
				EndIf
				
				If (Self.direct) Then
					Self.speedCount += STATE_ENTER_SHOW
					
					If (Self.speedCount = 70) Then
						Self.speed = STATE_INIT
						Self.direct = DEBUG_BOSS6_WUDI
					EndIf
					
				Else
					Self.speedCount -= STATE_ENTER_SHOW
					
					If (Self.speedCount = 0) Then
						Self.speed = STATE_INIT
						Self.direct = True
					EndIf
				EndIf
			EndIf
			
			Return Self.speed
		End
		
		Private Method attackSet:Void()
			Select (Self.HP)
				Case STATE_ENTER_SHOW
					Self.attack_cn_max = 120
					break
				Case STATE_PRO
					Self.attack_cn_max = 140
					break
				Case STATE_BROKEN
					Self.attack_cn_max = 154
					break
				Case STATE_FALL
					Self.attack_cn_max = 173
					break
				Default
					Self.attack_cn_max = 200
					break
			EndIf
			If (Self.attack_cn < Self.attack_cn_max) Then
				Self.attack_cn += STATE_ENTER_SHOW
				Return
			EndIf
			
			Self.attack_cn = STATE_INIT
			Self.attack_step = STATE_ENTER_SHOW
			Self.fire_time = STATE_INIT
			Self.fire_cn = STATE_INIT
		End
		
		Private Method turnHead:Void()
			
			If (Self.machine_state = STATE_ENTER_SHOW Or Self.machine_state = STATE_FALL Or Self.machine_state = MACHINE_FIRE_DOWN) Then
				If ((Self.posY - Self.initPosY) - PlayerObject.DETECT_HEIGHT >= TURN_OFFFSET_Y) Then
					setAniState(Self.machineDrawer, (Int) STATE_BROKEN)
					Self.machineDrawer.setLoop(DEBUG_BOSS6_WUDI)
					Self.machineUp = True
					Self.holdheadup_cn = STATE_INIT
					Int rnd = MyRandom.nextInt(STATE_INIT, 100)
					
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
				
			ElseIf (Self.machine_state = STATE_BROKEN And Self.machineDrawer.checkEnd()) Then
				setAniState(Self.machineDrawer, (Int) STATE_INIT)
				Self.machineDrawer.setLoop(True)
			EndIf
			
		End
		
		Public Method logic:Void()
			
			If (Not Self.dead) Then
				Self.blockArray.logic()
				Int preX = Self.posX
				Int preY = Self.posY
				
				If (Not (Self.state = STATE_ESCAPE Or Self.state = STATE_BROKEN Or Self.state = STATE_FALL)) Then
					Self.posY = Self.blockArray.getBossY(Self.posX)
				EndIf
				
				If (Self.state > 0) Then
					isBossEnter = True
				EndIf
				
				Select (Self.state)
					Case STATE_INIT
						
						If (player.getFootPositionX() >= 637952) Then
							MapManager.setCameraRightLimit(SIDE_RIGHT)
						EndIf
						
						If (player.getFootPositionY() >= Self.initPosY And player.getFootPositionX() >= 637952) Then
							Self.state = STATE_ENTER_SHOW
							player.setFootPositionY(Self.initPosY)
							player.setVelY(STATE_INIT)
							MapManager.setCameraUpLimit(SIDE_UP)
							MapManager.setCameraDownLimit(SIDE_DOWN)
							MapManager.setCameraLeftLimit(SIDE_LEFT)
							MapManager.setCameraRightLimit(SIDE_RIGHT)
							
							If (Not Self.IsPlayBossBattleBGM) Then
								bossFighting = True
								bossID = 27
								SoundSystem.getInstance().playBgm(25, True)
								Self.IsPlayBossBattleBGM = True
							EndIf
							
							Self.show_step = STATE_INIT
							setAniState(Self.machineDrawer, (Int) STATE_ENTER_SHOW)
							break
						EndIf
						
					Case STATE_ENTER_SHOW
						Select (Self.show_step)
							Case STATE_INIT
								
								If (Self.posX <= INIT_STOP_POSX) Then
									Self.posX = INIT_STOP_POSX
									Self.show_step = STATE_ENTER_SHOW
									setAniState(Self.faceDrawer, (Int) STATE_ENTER_SHOW)
									Self.laugh_cn = STATE_INIT
									break
								EndIf
								
								Self.posX -= OFFSET_Y
								break
							Case STATE_ENTER_SHOW
								
								If (Self.laugh_cn >= INIT_LAUGH_MAX) Then
									Self.show_step = STATE_PRO
									Self.laugh_cn = STATE_INIT
									setAniState(Self.faceDrawer, (Int) STATE_INIT)
									break
								EndIf
								
								Self.laugh_cn += STATE_ENTER_SHOW
								break
							Case STATE_PRO
								Self.show_step = STATE_BROKEN
								break
							Case STATE_BROKEN
								Self.state = STATE_PRO
								Self.direct = DEBUG_BOSS6_WUDI
								Self.speedCount = 35
								Self.speed = STATE_INIT
								Self.startFlag = True
								break
							Default
								break
						EndIf
					Case STATE_PRO
						attackSet()
						Select (Self.attack_step)
							Case STATE_INIT
								turnHead()
								break
							Case STATE_ENTER_SHOW
								turnHead()
								
								If (Self.machine_state <> STATE_BROKEN) Then
									If (Self.fire_time < FIRE_INTERVAL) Then
										Self.fire_time += STATE_ENTER_SHOW
									Else
										Self.fire_time = STATE_INIT
										setAniState(Self.machineDrawer, Self.machineUp ? STATE_ESCAPE : MACHINE_FIRE_DOWN)
										Self.machineDrawer.setLoop(DEBUG_BOSS6_WUDI)
										BulletObject.addBullet(FIRE_INTERVAL, Self.posX, Self.posY, player.getFootPositionX(), player.getFootPositionY())
										Self.fire_cn += STATE_ENTER_SHOW
									EndIf
									
									If (Self.machineDrawer.checkEnd()) Then
										Int i
										AnimationDrawer animationDrawer = Self.machineDrawer
										
										If (Self.machineUp) Then
											i = STATE_INIT
										Else
											i = STATE_ENTER_SHOW
										EndIf
										
										setAniState(animationDrawer, i)
										Self.machineDrawer.setLoop(True)
									EndIf
									
									If (Self.fire_cn >= STATE_BROKEN) Then
										Self.fire_cn = STATE_INIT
										Self.attack_step = STATE_INIT
										break
									EndIf
								EndIf
								
								break
						EndIf
						If (Self.face_state = STATE_PRO) Then
							If (Self.hurt_cn < MACHINE_FIRE_DOWN) Then
								Self.hurt_cn += STATE_ENTER_SHOW
							Else
								Self.hurt_cn = STATE_INIT
								setAniState(Self.machineDrawer, (Int) STATE_FALL)
								Self.machineDrawer.setLoop(DEBUG_BOSS6_WUDI)
								Self.face_state = STATE_INIT
								Self.attack_step = Self.last_attack_step
								Self.holdheadup_cn = Self.holdheadup_cn_max - STATE_PRO
							EndIf
						EndIf
						
						If (Self.machineUp) Then
							If (Self.holdheadup_cn < Self.holdheadup_cn_max) Then
								Self.holdheadup_cn += STATE_ENTER_SHOW
							Else
								Self.holdheadup_cn = STATE_INIT
								setAniState(Self.machineDrawer, (Int) STATE_FALL)
								Self.machineDrawer.setLoop(DEBUG_BOSS6_WUDI)
								Self.machineUp = DEBUG_BOSS6_WUDI
							EndIf
						EndIf
						
						If (Self.machine_state = STATE_FALL And Self.machineDrawer.checkEnd()) Then
							setAniState(Self.machineDrawer, (Int) STATE_ENTER_SHOW)
							Self.machineDrawer.setLoop(True)
						EndIf
						
						If (Self.attack_step <> STATE_PRO) Then
							Int speed = STATE_INIT
							Bool i2 = DEBUG_BOSS6_WUDI
							While (True) {
								Bool z = Not Self.isRash ? True : Self.HP = STATE_PRO ? STATE_BROKEN : STATE_FALL
								
								If (i2 >= z) Then
									Self.posX += speed
									
									If (Self.posX <= MOVE_LIMIT_LEFT) Then
										Self.posX = MOVE_LIMIT_LEFT
									EndIf
									
									If (Self.posX >= MOVE_LIMIT_RIGHT) Then
										Self.posX = MOVE_LIMIT_RIGHT
									EndIf
									
									If (Self.isRash) Then
										Self.rash_distance += speed > 0 ? speed : -speed
										
										If (Self.rash_distance >= (Self.HP = STATE_PRO ? RASH_DISTANCE_MAX_1 : RASH_DISTANCE_MAX_2)) Then
											Self.rash_distance = Self.HP = STATE_PRO ? RASH_DISTANCE_MAX_1 : RASH_DISTANCE_MAX_2
											Self.isRash = DEBUG_BOSS6_WUDI
											break
										EndIf
									EndIf
								EndIf
								
								speed += machineSpeed()
								i2 += STATE_ENTER_SHOW
							EndIf
						EndIf
						
						break
					Case STATE_BROKEN
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
						
						If (Self.posY + Self.velY < getGroundY(Self.posX, Self.posY) - 1280) Then
							Self.velY += 10
							Self.posY += Self.velY
							break
						EndIf
						
						Self.state = STATE_FALL
						Self.escapefacedrawer.setActionId(STATE_FALL)
						Self.escapefacedrawer.setLoop(True)
						Self.boatdrawer.setActionId(STATE_ENTER_SHOW)
						Self.boatdrawer.setLoop(True)
						Self.posY = getGroundY(Self.posX, Self.posY) - 1280
						bossFighting = DEBUG_BOSS6_WUDI
						MapManager.setCameraDownLimit(2372)
						MapManager.calCameraImmidiately()
						Self.blockArray.setDisplayState()
						break
					Case STATE_FALL
						player.velY = 1280
						
						If (player.getFootPositionY() = getGroundY(player.footPointX, player.footPointY)) Then
							If (player.posX < Self.posX) Then
								player.faceDirection = True
							Else
								player.faceDirection = DEBUG_BOSS6_WUDI
							EndIf
							
							Self.state = STATE_ESCAPE
							Self.WaitCnt = STATE_INIT
							Self.wait_cnt = STATE_INIT
							Self.fly_top = ESCAPE_END_Y
							Self.fly_end = ESCAPE_END_X
							player.getBossScore()
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
							player.setAnimationId(STATE_INIT)
							player.setOutOfControl(Null)
							player.totalVelocity = STATE_INIT
							break
						EndIf
						
						break
					Case STATE_ESCAPE
						Self.wait_cnt += STATE_ENTER_SHOW
						
						If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= Self.fly_top - Self.fly_top_range) Then
							Self.posY -= Self.escape_v
						EndIf
						
						If (Self.posY <= Self.fly_top - Self.fly_top_range And Self.WaitCnt = 0) Then
							Self.posY = Self.fly_top - Self.fly_top_range
							Self.escapefacedrawer.setActionId(STATE_INIT)
							Self.boatdrawer.setActionId(STATE_ENTER_SHOW)
							Self.boatdrawer.setLoop(DEBUG_BOSS6_WUDI)
							Self.WaitCnt = STATE_ENTER_SHOW
						EndIf
						
						If (Self.WaitCnt = STATE_ENTER_SHOW And Self.boatdrawer.checkEnd()) Then
							Self.escapefacedrawer.setActionId(STATE_INIT)
							Self.escapefacedrawer.setTrans(STATE_PRO)
							Self.escapefacedrawer.setLoop(True)
							Self.boatdrawer.setActionId(STATE_ENTER_SHOW)
							Self.boatdrawer.setTrans(STATE_PRO)
							Self.boatdrawer.setLoop(DEBUG_BOSS6_WUDI)
							Self.WaitCnt = STATE_PRO
						EndIf
						
						If (Self.WaitCnt = STATE_PRO And Self.boatdrawer.checkEnd()) Then
							Self.boatdrawer.setActionId(STATE_INIT)
							Self.boatdrawer.setTrans(STATE_PRO)
							Self.boatdrawer.setLoop(True)
							Self.WaitCnt = STATE_BROKEN
						EndIf
						
						If (Self.WaitCnt = STATE_BROKEN Or Self.WaitCnt = STATE_FALL) Then
							Self.posX += Self.escape_v
							
							If (Self.posX - Self.fly_end > Self.fly_top_range) Then
								Self.posY -= Self.fly_top_range
							EndIf
						EndIf
						
						If (Self.posX > Self.fly_end And Self.WaitCnt = STATE_BROKEN) Then
							player.releaseOutOfControl()
							player.setTerminal(STATE_PRO)
							player.collisionState = (Byte) 0
							MapManager.releaseCamera()
							MapManager.setFocusObj(Null)
							Self.WaitCnt = STATE_FALL
							break
						EndIf
				EndIf
				refreshCollisionRect(Self.posX, Self.posY)
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
			
		End
		
		Public Method draw:Void(g:MFGraphics)
			
			If (Not Self.dead) Then
				If (Not (Self.state = STATE_ESCAPE Or Self.state = STATE_FALL)) Then
					Self.blockArray.draw(g)
					drawInMap(g, Self.machineDrawer, Self.posX, Self.posY)
					
					If (Self.face_state <> 0) Then
						If (Self.machine_state = STATE_ENTER_SHOW) Then
							Self.faceDrawer.setTrans(STATE_ENTER_SHOW)
							drawInMap(g, Self.faceDrawer, Self.posX, (Self.posY + FACE_OFFSET) + 128)
						Else
							
							If (Self.machineUp) Then
								Self.faceDrawer.setTrans(STATE_INIT)
							Else
								Self.faceDrawer.setTrans(STATE_ENTER_SHOW)
							EndIf
							
							If (Not (Self.machine_state = STATE_FALL Or Self.machine_state = STATE_BROKEN Or Self.machine_state = STATE_ENTER_SHOW)) Then
								drawInMap(g, Self.faceDrawer, Self.posX, Self.posY - FACE_OFFSET)
							EndIf
						EndIf
					EndIf
				EndIf
				
				If (Self.state = STATE_ESCAPE Or Self.state = STATE_FALL) Then
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY + MDPhone.SCREEN_HEIGHT)
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - FACE_OFFSET)
				EndIf
				
				If (Self.bossbroken <> Null And Self.state = STATE_BROKEN) Then
					Self.bossbroken.draw(g)
				EndIf
				
				drawCollisionRect(g)
			EndIf
			
		End
		
		Public Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - PlayerObject.HEIGHT, y - PlayerObject.DETECT_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Public Method close:Void()
			Self.machineDrawer = Null
			Self.faceDrawer = Null
			Self.blockArray = Null
			Self.bossbroken = Null
			Self.boatdrawer = Null
			Self.escapefacedrawer = Null
		End
End