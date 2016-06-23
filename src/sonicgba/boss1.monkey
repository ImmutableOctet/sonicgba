Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject

Friend sonicgba.boss1arm

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gameobject
	Import sonicgba.boss1arm
	Import sonicgba.bossbroken
	Import sonicgba.bossobject
	Import sonicgba.cage
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss1 Extends BossObject
	Protected
		' Constant variable(s):
		
		' States:
		Const STATE_WAIT:Int = 0
		Const STATE_ATTACK_1:Int = 1
		Const STATE_READY:Int = 2
		Const STATE_ATTACK_2:Int = 3
		Const STATE_ATTACK_3:Int = 4
		Const STATE_BROKEN:Int = 5
		Const STATE_ESCAPE:Int = 6
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 4608
		Const COLLISION_HEIGHT:Int = 3840
		
		Const ALERT_RANGE:Int = 6912
		
		Const BOSS_MOVE_LIMIT_LEFT:Int = 670336
		Const BOSS_MOVE_LIMIT_RIGHT:Int = 702336
		
		Const BOSS_WAKEN_POINT:Int = 686080
		
		Const CAMERA_SET_POINT:Int = 678912
		Const CAMERA_SIDE_LEFT:Int = 10544
		Const CAMERA_SIDE_RIGHT:Int = 10904
		
		' All of these degree values are shifted left by 6 bits:
		Const DEGREE_MIN:Int = 10880
		Const DEGREE_MAX:Int = 23680
		
		Const DEGREE_MIN_2:Int = 12160
		Const DEGREE_MAX_2:Int = 22400
		
		Const FACE_NORMAL:Int = 0
		Const FACE_SMILE:Int = 1
		Const FACE_HURT:Int = 2
		
		Const CAR_MOVE:Int = 0
		Const CAR_HURT:Int = 1
		
		Const cnt_max:Int = 8
		Const stop_wait_cnt_max:Int = 32
		
		Global boatAni:Animation = Null
		Global brokencarAni:Animation = Null
		Global carAni:Animation = Null
		Global escapefaceAni:Animation = Null
		Global faceAni:Animation = Null
		
		' Fields:
		Field IsBreaking:Bool
		Field IsStopWait:Bool
		
		Field boatdrawer:AnimationDrawer
		Field brokencardrawer:AnimationDrawer
		Field cardrawer:AnimationDrawer
		Field escapefacedrawer:AnimationDrawer
		Field facedrawer:AnimationDrawer
		
		Field arm:Boss1Arm
		Field bossbroken:BossBroken
		
		Field ArmSharpPos:Int[]
		
		Field state:Int
		Field alert_state:Int
		Field face_state:Int
		
		Field velocity:Int
		
		Field velX__boss1:Int
		Field velY__boss1:Int
		
		Field WaitCnt:Int
		
		Field ball_size:Int
		Field car_cnt:Int
		Field car_state:Int
		Field con_size:Int
		Field degree:Int
		Field dg_plus:Int
		Field drop_cnt:Int
		Field escape_v:Int
		Field face_cnt:Int
		
		Field fly_end:Int
		Field fly_top:Int
		
		Field fly_top_range:Int
		
		Field flywheel_lx:Int
		Field flywheel_rx:Int
		
		Field flywheel_vx:Int
		Field flywheel_vy:Int
		
		Field flywheel_y:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field offsetY:Int
		
		Field plus:Int
		Field range:Int
		
		Field side_left:Int
		Field side_right:Int
		
		Field wait_cnt:Int
		Field wait_cnt_max:Int
		
		Field stop_wait_cnt:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Magic number: -240
			Self.velocity = -240
			
			Self.range = 44800
			
			' Magic number: 2112
			Self.offsetY = 2112
			
			Self.ArmSharpPos = New Int[2]
			
			Self.dg_plus = 320
			Self.degree = 0
			
			Self.plus = 1
			
			Self.con_size = 1152
			
			Self.ball_size = PlayerObject.HEIGHT ' 1536
			
			Self.side_left = 0
			Self.side_right = 0
			
			Self.velX__boss1 = 0
			Self.velY__boss1 = 0
			
			Self.wait_cnt_max = 10
			
			Self.escape_v = 512
			
			Self.fly_top_range = COLLISION_HEIGHT
			
			Self.IsStopWait = False
			
			Self.stop_wait_cnt = 0
			
			Self.posX -= Self.iLeft * cnt_max
			Self.posY -= Self.iTop * cnt_max
			
			Self.limitRightX = BOSS_MOVE_LIMIT_RIGHT
			Self.limitLeftX = BOSS_MOVE_LIMIT_LEFT
			
			refreshCollisionRect(Self.posX Shr 6, Self.posY Shr 6)
			
			If (carAni = Null) Then
				carAni = New Animation("/animation/boss1_car")
			EndIf
			
			Self.cardrawer = carAni.getDrawer(0, True, 0)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss1_egg")
			EndIf
			
			Self.facedrawer = faceAni.getDrawer(0, True, 0)
			
			If (brokencarAni = Null) Then
				brokencarAni = New Animation("/animation/boss1_body")
			EndIf
			
			Self.brokencardrawer = brokencarAni.getDrawer(2, True, 0)
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(0, True, 0)
			
			If (escapefaceAni = Null) Then
				escapefaceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.escapefacedrawer = escapefaceAni.getDrawer(4, True, 0)
			
			Self.arm = New Boss1Arm(ENEMY_BOSS1_ARM, x, y, left, top, width, height)
			
			GameObject.addGameObject(Self.arm, x, y)
			
			Self.IsBreaking = False
			Self.WaitCnt = 0
			Self.IsStopWait = False
			
			setBossHP()
		End
		
		' Methods:
		
		' Extensions:
		Method onPlayerAttack:Void(p:PlayerObject, direction:Int) ' animationID:Int
			If (Self.face_state = FACE_HURT And Self.car_cnt = cnt_max) Then
				Local animationID:= p.getAnimationId()
				
				' This behavior will likely change in the future:
				
				'If (animationID = PlayerObject.ANI_SPIN_LV1 Or animationID = PlayerObject.ANI_SPIN_LV2) Then
				If (animationID <> PlayerObject.ANI_SPIN_LV1 And animationID <> PlayerObject.ANI_SPIN_LV2) Then
					p.beHurt()
					
					Self.face_state = FACE_SMILE
					
					Return
				EndIf
			EndIf
			
			If (Self.HP > 0 And Self.face_state <> FACE_HURT) Then
				Self.HP -= 1
				
				p.doBossAttackPose(Self, direction)
				
				Self.face_state = FACE_HURT
				Self.car_state = CAR_HURT
				
				playHitSound()
			EndIf
		End
	Private
		' Methods:
		Method changeAniState:Void(aniDrawer:AnimationDrawer, state:Int)
			If (Self.velocity > 0) Then
				aniDrawer.setActionId(state)
				aniDrawer.setTrans(TRANS_MIRROR)
				aniDrawer.setLoop(True)
			Else
				aniDrawer.setActionId(state)
				aniDrawer.setTrans(TRANS_NONE)
				aniDrawer.setLoop(True)
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(carAni)
			Animation.closeAnimation(faceAni)
			Animation.closeAnimation(brokencarAni)
			Animation.closeAnimation(BoomAni)
			Animation.closeAnimation(boatAni)
			Animation.closeAnimation(escapefaceAni)
			
			carAni = Null
			faceAni = Null
			brokencarAni = Null
			BoomAni = Null
			boatAni = Null
			escapefaceAni = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.dead And Self.state <> STATE_BROKEN And Self.state <> STATE_ESCAPE And p = player) Then
				If (p.isAttackingEnemy()) Then
					onPlayerAttack(p, direction)
				ElseIf (Self.state <> STATE_BROKEN And Self.state <> STATE_ESCAPE And p.canBeHurt()) Then
					p.beHurt()
					
					Self.face_state = FACE_SMILE
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			onPlayerAttack(p, direction)
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Local tmpX:= Self.posX
				Local tmpY:= Self.posY
				
				If (Self.HP = 1) Then
					' Magic numbers: 3, 4 (Arm states)
					If (Self.state = STATE_ATTACK_1) Then
						Self.state = STATE_BROKEN
					ElseIf (Self.arm.getArmState() = Boss1Arm.STATE_ATTACK_2 And Not Self.arm.getTurnState()) Then
						Self.state = STATE_ATTACK_2
						
						Self.dg_plus = 914 ' (14 Shl 6)
						
						Self.arm.setTurnState(True)
						Self.arm.setDegreeSpeed(Self.dg_plus)
					ElseIf (Self.arm.getArmState() = Boss1Arm.STATE_ATTACK_3 And Not Self.arm.getTurnState()) Then
						Self.state = STATE_BROKEN
					EndIf
				ElseIf (Self.HP = 0 And Not Self.IsBreaking) Then
					Self.state = STATE_BROKEN
					
					changeAniState(Self.facedrawer, FACE_HURT) ' 2
					changeAniState(Self.brokencardrawer, 2) ' CAR_HURT + 1
					
					Self.posY -= Self.con_size
					
					' Magic number: -600
					Self.velY__boss1 = -600
					
					' Magic numbers: -150, 150
					If (player.getVelX() < 0) Then
						Self.velX__boss1 = -150
					Else
						Self.velX__boss1 = 150
					EndIf
					
					Local flyWheelOffset:= ((COLLISION_WIDTH / 2) Shl 6)
					
					If (Self.velocity > 0) Then
						Self.flywheel_lx = (Self.posX - flyWheelOffset) ' 147456
						Self.flywheel_rx = (Self.posX + flyWheelOffset) ' 147456
					Else
						Self.flywheel_lx = (Self.posX + flyWheelOffset) ' 147456
						Self.flywheel_rx = (Self.posX - flyWheelOffset) ' 147456
					EndIf
					
					Self.flywheel_y = Self.posY - Self.con_size
					
					' Magic numbers: 300, -300
					Self.flywheel_vx = 300
					Self.flywheel_vy = -300
					
					Local brokenX:= (Self.posX Shr 6)
					Local brokenY:= (Self.posY Shr 6)
					
					Self.bossbroken = New BossBroken(ENEMY_BOSS1, brokenX, brokenY, 0, 0, 0, 0)
					
					GameObject.addGameObject(Self.bossbroken, brokenX, brokenY)
					
					Self.IsBreaking = True
					
					Self.side_left = MapManager.getCamera().x
					Self.side_right = (Self.side_left + MapManager.CAMERA_WIDTH)
					
					MapManager.setCameraLeftLimit(Self.side_left)
					MapManager.setCameraRightLimit(Self.side_right)
				EndIf
				
				If (Self.state > STATE_WAIT) Then
					isBossEnter = True
				EndIf
				
				Select (Self.state)
					Case STATE_WAIT
						If (player.getFootPositionX() >= CAMERA_SET_POINT) Then
							MapManager.setCameraLeftLimit(CAMERA_SIDE_LEFT)
							MapManager.setCameraRightLimit(CAMERA_SIDE_RIGHT)
						EndIf
						
						If (player.getFootPositionX() >= BOSS_WAKEN_POINT) Then
							Self.IsStopWait = True
							
							bossFighting = True
							
							bossID = ENEMY_BOSS1
							
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_01, True)
						EndIf
						
						If (Self.IsStopWait) Then
							If (Self.stop_wait_cnt >= stop_wait_cnt_max) Then
								Self.state = STATE_ATTACK_1
							Else
								Self.stop_wait_cnt += 1
							EndIf
						EndIf
					Case STATE_ATTACK_1, STATE_READY
						If (Self.face_state <> FACE_NORMAL) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = FACE_NORMAL
								
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Self.car_state = CAR_HURT) Then
							If (Self.car_cnt < cnt_max) Then
								Self.car_cnt += 1
							Else
								Self.car_state = CAR_MOVE
								
								Self.car_cnt = 0
							EndIf
						EndIf
						
						changeAniState(Self.cardrawer, Self.car_state)
						changeAniState(Self.facedrawer, Self.face_state)
						
						If (Self.state <> STATE_BROKEN) Then
							If (Self.velocity > 0) Then
								Self.posX += Self.velocity
								
								If (Self.posX >= Self.limitRightX) Then
									Self.posX = Self.limitRightX
									
									Self.velocity = -Self.velocity
								EndIf
							Else
								Self.posX += Self.velocity
								
								If (Self.posX <= Self.limitLeftX) Then
									Self.posX = Self.limitLeftX
									
									Self.velocity = -Self.velocity
								EndIf
							EndIf
						ElseIf (Self.velocity > 0) Then
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
							EndIf
						ElseIf (Self.posX <= Self.limitLeftX) Then
							Self.posX = Self.limitLeftX
							
							Self.velocity = -Self.velocity
						EndIf
						
						Self.arm.arm_logic(Self.posX, Self.posY - Self.offsetY, Self.state, Self.velocity)
					Case STATE_ATTACK_2
						If (Self.face_state <> FACE_NORMAL) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = FACE_NORMAL
								
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Self.car_state = CAR_HURT) Then
							If (Self.car_cnt < cnt_max) Then
								Self.car_cnt += 1
							Else
								Self.car_state = CAR_MOVE
								
								Self.car_cnt = 0
							EndIf
						EndIf
						
						changeAniState(Self.cardrawer, Self.car_state)
						changeAniState(Self.facedrawer, Self.face_state)
						
						Self.ArmSharpPos = Self.arm.arm_logic(Self.posX, Self.posY - Self.offsetY, Self.state, Self.velocity)
						
						Self.posX = Self.ArmSharpPos[0]
						Self.posY = (Self.ArmSharpPos[1] + Self.offsetY)
					Case STATE_ATTACK_3
						If (Self.face_state <> FACE_NORMAL) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = FACE_NORMAL
								
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Self.car_state = CAR_HURT) Then
							If (Self.car_cnt < cnt_max) Then
								Self.car_cnt += 1
							Else
								Self.car_state = CAR_MOVE
								
								Self.car_cnt = 0
							EndIf
						EndIf
						
						changeAniState(Self.cardrawer, Self.car_state)
						changeAniState(Self.facedrawer, Self.face_state)
						
						Self.posX = tmpX
						Self.posY = tmpY
						
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
							EndIf
						Else
							Self.posX += Self.velocity
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
							EndIf
						EndIf
						
						Self.arm.arm_logic(Self.posX, Self.posY - Self.offsetY, Self.state, Self.velocity)
					Case STATE_BROKEN
						If (Self.face_state <> FACE_NORMAL) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = FACE_NORMAL
								
								Self.face_cnt = 0
							EndIf
						EndIf
						
						changeAniState(Self.facedrawer, Self.face_state)
						
						Local groundY:= getGroundY(Self.posX, Self.posY)
						
						If (Self.posY + Self.velY__boss1 >= groundY) Then
							Self.posY = groundY
							
							' Magic numbers: -450, 300, etc.
							Select (Self.drop_cnt)
								Case 0
									Self.velY__boss1 = -450
									
									Self.drop_cnt = 1
								Case 1
									Self.velY__boss1 = -300
									
									Self.drop_cnt = 2
							End Select
						EndIf
						
						Self.posX += Self.velX__boss1
						Self.velY__boss1 += GRAVITY
						Self.posY += Self.velY__boss1
						
						Local fwGroundY:= getGroundY(Self.flywheel_lx, Self.flywheel_y)
						
						If ((Self.flywheel_y - Self.con_size) >= fwGroundY) Then
							Self.flywheel_y = (fwGroundY + Self.con_size)
						Else
							If (Self.velocity > 0) Then
								Self.flywheel_lx -= Self.flywheel_vx
								Self.flywheel_rx += Self.flywheel_vx
							Else
								Self.flywheel_lx += Self.flywheel_vx
								Self.flywheel_rx -= Self.flywheel_vx
							EndIf
							
							Self.flywheel_vy += (GRAVITY / 2) ' Shr 1
							Self.flywheel_y += Self.flywheel_vy
						EndIf
						
						Self.arm.arm_logic(Self.posX, Self.posY, Self.state, Self.velocity)
						
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
						
						If (Self.bossbroken.getEndState()) Then
							Self.state = STATE_ESCAPE
							
							Self.fly_top = Self.posY
							Self.fly_end = Self.side_right
							
							bossFighting = False
							
							player.getBossScore()
							
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
						EndIf
					Case STATE_ESCAPE
						Self.wait_cnt += 1
						
						If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= (Self.fly_top - Self.fly_top_range)) Then
							Self.posY -= Self.escape_v
						EndIf
						
						If (Self.posY <= Self.fly_top - Self.fly_top_range And Self.WaitCnt = 0) Then
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
						
						If (Self.WaitCnt = 3 Or Self.WaitCnt = (cnt_max / 2)) Then ' 8
							Self.posX += Self.escape_v
						EndIf
						
						If (Self.posX > (Self.side_right Shl 6) And Self.WaitCnt = 3) Then
							GameObject.addGameObject(New Cage((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH / 2)) Shl 6, MapManager.getCamera().y Shl 6)) ' Shr 1
							
							MapManager.lockCamera(True)
							
							Self.WaitCnt = (cnt_max / 2) ' 8
						EndIf
				End Select
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				'Print("draw boss~~!")
				
				If (Self.state < STATE_BROKEN) Then
					drawInMap(g, Self.cardrawer)
					
					' Magic number: 3008
					drawInMap(g, Self.facedrawer, Self.posX, Self.posY - 3008)
				ElseIf (Self.state = STATE_BROKEN) Then
					changeAniState(Self.brokencardrawer, 2) ' CAR_HURT + 1
					
					drawInMap(g, Self.brokencardrawer)
					
					If (Self.drop_cnt < 2) Then
						changeAniState(Self.brokencardrawer, 0)
						
						drawInMap(g, Self.brokencardrawer, Self.flywheel_lx, Self.flywheel_y)
						
						changeAniState(Self.brokencardrawer, 1)
						
						drawInMap(g, Self.brokencardrawer, Self.flywheel_rx, Self.flywheel_y)
					EndIf
					
					' Magic number: 2496
					drawInMap(g, Self.facedrawer, Self.posX, Self.posY - 2496)
				ElseIf (Self.state = STATE_ESCAPE) Then
					' Magic numbers: 960, 2624
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY - 960) ' (COLLISION_HEIGHT / 4)
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - 2624)
				EndIf
				
				Self.arm.drawArm(g)
				
				If (Self.bossbroken <> Null) Then
					Self.bossbroken.draw(g)
				EndIf
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.cardrawer = Null
			Self.facedrawer = Null
			Self.brokencardrawer = Null
			Self.boatdrawer = Null
			Self.escapefacedrawer = Null
			
			Super.close()
		End
End