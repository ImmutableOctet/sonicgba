Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
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
		
		' States:
		Const STATE_WAIT:Int = 0
		Const STATE_ATTACK_1:Int = 1
		Const STATE_READY:Int = 2
		Const STATE_ATTACK_2:Int = 3
		Const STATE_ATTACK_3:Int = 4
		Const STATE_BROKEN:Int = 5
		Const STATE_ESCAPE:Int = 6
		
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
		
		Field velX:Int
		Field velY:Int
		
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
			
			Self.con_size = BarHorbinV.HOBIN_POWER
			Self.ball_size = PlayerObject.HEIGHT
			
			Self.side_left = 0
			Self.side_right = 0
			
			Self.velX = 0
			Self.velY = 0
			
			Self.wait_cnt_max = 10
			
			Self.escape_v = 512
			
			Self.fly_top_range = COLLISION_HEIGHT
			
			Self.IsStopWait = False
			
			Self.stop_wait_cnt = 0
			
			Self.posX -= Self.iLeft * cnt_max
			Self.posY -= Self.iTop * cnt_max
			
			Self.limitRightX = BOSS_MOVE_LIMIT_RIGHT
			Self.limitLeftX = BOSS_MOVE_LIMIT_LEFT
			
			refreshCollisionRect(Self.posX Shr STATE_ESCAPE, Self.posY Shr STATE_ESCAPE)
			
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
			Self.arm = New Boss1Arm(31, x, y, left, top, width, height)
			GameObject.addGameObject(Self.arm, x, y)
			Self.IsBreaking = False
			Self.WaitCnt = 0
			Self.IsStopWait = False
			
			setBossHP()
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
		
		/* JADX WARNING: inconsistent code. */
		/* Code decompiled incorrectly, please refer to instructions dump. */
		Public Method doWhileCollision:Void(r6:SonicGBA.PlayerObject, r7:Int)
		
		End
		
		/* JADX WARNING: inconsistent code. */
		/* Code decompiled incorrectly, please refer to instructions dump. */
		Public Method doWhileBeAttack:Void(r5:SonicGBA.PlayerObject, r6:Int, r7:Int)
		
		End
		
		Public Method logic:Void()
			
			If (Not Self.dead) Then
				Int preX = Self.posX
				Int preY = Self.posY
				Int tmpX = Self.posX
				Int tmpY = Self.posY
				
				If (Self.HP = 1) Then
					If (Self.state = 1) Then
						Self.state = 4
					ElseIf (Self.arm.getArmState() = STATE_ATTACK_2 And Not Self.arm.getTurnState()) Then
						Self.state = STATE_ATTACK_2
						Self.dg_plus = 914
						Self.arm.setTurnState(True)
						Self.arm.setDegreeSpeed(Self.dg_plus)
					ElseIf (Self.arm.getArmState() = 4 And Not Self.arm.getTurnState()) Then
						Self.state = 4
					EndIf
					
				ElseIf (Self.HP = 0 And Not Self.IsBreaking) Then
					Self.state = STATE_BROKEN
					changeAniState(Self.facedrawer, 2)
					changeAniState(Self.brokencardrawer, 2)
					Self.posY -= Self.con_size
					Self.velY = -600
					
					If (player.getVelX() < 0) Then
						Self.velX = -150
					Else
						Self.velX = 150
					EndIf
					
					If (Self.velocity > 0) Then
						Self.flywheel_lx = Self.posX - 147456
						Self.flywheel_rx = Self.posX + 147456
					Else
						Self.flywheel_lx = Self.posX + 147456
						Self.flywheel_rx = Self.posX - 147456
					EndIf
					
					Self.flywheel_y = Self.posY - Self.con_size
					Self.flywheel_vx = SSdef.PLAYER_MOVE_WIDTH
					Self.flywheel_vy = SmallAnimal.FLY_VELOCITY_Y
					Self.bossbroken = New BossBroken(22, Self.posX Shr STATE_ESCAPE, Self.posY Shr STATE_ESCAPE, 0, 0, 0, 0)
					GameObject.addGameObject(Self.bossbroken, Self.posX Shr STATE_ESCAPE, Self.posY Shr STATE_ESCAPE)
					Self.IsBreaking = True
					Self.side_left = MapManager.getCamera().x
					Self.side_right = Self.side_left + MapManager.CAMERA_WIDTH
					MapManager.setCameraLeftLimit(Self.side_left)
					MapManager.setCameraRightLimit(Self.side_right)
				EndIf
				
				If (Self.state > 0) Then
					isBossEnter = True
				EndIf
				
				Select (Self.state)
					Case 0
						
						If (player.getFootPositionX() >= CAMERA_SET_POINT) Then
							MapManager.setCameraLeftLimit(CAMERA_SIDE_LEFT)
							MapManager.setCameraRightLimit(CAMERA_SIDE_RIGHT)
						EndIf
						
						If (player.getFootPositionX() >= BOSS_WAKEN_POINT) Then
							Self.IsStopWait = True
							bossFighting = True
							bossID = 22
							SoundSystem.getInstance().playBgm(22, True)
						EndIf
						
						If (Self.IsStopWait) Then
							If (Self.stop_wait_cnt >= stop_wait_cnt_max) Then
								Self.state = 1
								break
							Else
								Self.stop_wait_cnt += 1
								break
							EndIf
						EndIf
						
						break
					Case 1
					Case 2
						
						If (Self.face_state <> 0) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = 0
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Self.car_state = 1) Then
							If (Self.car_cnt < cnt_max) Then
								Self.car_cnt += 1
							Else
								Self.car_state = 0
								Self.car_cnt = 0
							EndIf
						EndIf
						
						changeAniState(Self.cardrawer, Self.car_state)
						changeAniState(Self.facedrawer, Self.face_state)
						
						If (Self.state <> 4) Then
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
						
						Self.arm.logic(Self.posX, Self.posY - Self.offsetY, Self.state, Self.velocity)
						break
					Case STATE_ATTACK_2
						
						If (Self.face_state <> 0) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = 0
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Self.car_state = 1) Then
							If (Self.car_cnt < cnt_max) Then
								Self.car_cnt += 1
							Else
								Self.car_state = 0
								Self.car_cnt = 0
							EndIf
						EndIf
						
						changeAniState(Self.cardrawer, Self.car_state)
						changeAniState(Self.facedrawer, Self.face_state)
						Self.ArmSharpPos = Self.arm.logic(Self.posX, Self.posY - Self.offsetY, Self.state, Self.velocity)
						Self.posX = Self.ArmSharpPos[0]
						Self.posY = Self.ArmSharpPos[1] + Self.offsetY
						break
					Case 4
						
						If (Self.face_state <> 0) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = 0
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Self.car_state = 1) Then
							If (Self.car_cnt < cnt_max) Then
								Self.car_cnt += 1
							Else
								Self.car_state = 0
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
						
						Self.arm.logic(Self.posX, Self.posY - Self.offsetY, Self.state, Self.velocity)
						break
					Case STATE_BROKEN
						
						If (Self.face_state <> 0) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = 0
								Self.face_cnt = 0
							EndIf
						EndIf
						
						changeAniState(Self.facedrawer, Self.face_state)
						
						If (Self.posY + Self.velY >= getGroundY(Self.posX, Self.posY)) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							Select (Self.drop_cnt)
								Case 0
									Self.velY = -450
									Self.drop_cnt = 1
									break
								Case 1
									Self.velY = SmallAnimal.FLY_VELOCITY_Y
									Self.drop_cnt = 2
									break
							EndIf
						EndIf
						
						Self.posX += Self.velX
						Self.velY += GRAVITY
						Self.posY += Self.velY
						
						If (Self.flywheel_y - Self.con_size >= getGroundY(Self.flywheel_lx, Self.flywheel_y)) Then
							Self.flywheel_y = getGroundY(Self.flywheel_lx, Self.flywheel_y) + Self.con_size
						Else
							
							If (Self.velocity > 0) Then
								Self.flywheel_lx -= Self.flywheel_vx
								Self.flywheel_rx += Self.flywheel_vx
							Else
								Self.flywheel_lx += Self.flywheel_vx
								Self.flywheel_rx -= Self.flywheel_vx
							EndIf
							
							Self.flywheel_vy += GRAVITY Shr 1
							Self.flywheel_y += Self.flywheel_vy
						EndIf
						
						Self.arm.logic(Self.posX, Self.posY, Self.state, Self.velocity)
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
						
						If (Self.bossbroken.getEndState()) Then
							Self.state = STATE_ESCAPE
							Self.fly_top = Self.posY
							Self.fly_end = Self.side_right
							bossFighting = False
							player.getBossScore()
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
							break
						EndIf
						
						break
					Case STATE_ESCAPE
						Self.wait_cnt += 1
						
						If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= Self.fly_top - Self.fly_top_range) Then
							Self.posY -= Self.escape_v
						EndIf
						
						If (Self.posY <= Self.fly_top - Self.fly_top_range And Self.WaitCnt = 0) Then
							Self.posY = Self.fly_top - Self.fly_top_range
							Self.escapefacedrawer.setActionId(0)
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setLoop(False)
							Self.WaitCnt = 1
						EndIf
						
						If (Self.WaitCnt = 1 And Self.boatdrawer.checkEnd()) Then
							Self.escapefacedrawer.setActionId(0)
							Self.escapefacedrawer.setTrans(2)
							Self.escapefacedrawer.setLoop(True)
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setTrans(2)
							Self.boatdrawer.setLoop(False)
							Self.WaitCnt = 2
						EndIf
						
						If (Self.WaitCnt = 2 And Self.boatdrawer.checkEnd()) Then
							Self.boatdrawer.setActionId(0)
							Self.boatdrawer.setTrans(2)
							Self.boatdrawer.setLoop(True)
							Self.WaitCnt = STATE_ATTACK_2
						EndIf
						
						If (Self.WaitCnt = STATE_ATTACK_2 Or Self.WaitCnt = 4) Then
							Self.posX += Self.escape_v
						EndIf
						
						If (Self.posX > (Self.side_right Shl STATE_ESCAPE) And Self.WaitCnt = STATE_ATTACK_2) Then
							GameObject.addGameObject(New Cage((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH Shr 1)) Shl STATE_ESCAPE, MapManager.getCamera().y Shl STATE_ESCAPE))
							MapManager.lockCamera(True)
							Self.WaitCnt = 4
							break
						EndIf
				EndIf
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
			
		End
		
		Public Method draw:Void(g:MFGraphics)
			
			If (Not Self.dead) Then
				Print("draw boss~Not ")
				
				If (Self.state < STATE_BROKEN) Then
					drawInMap(g, Self.cardrawer)
					drawInMap(g, Self.facedrawer, Self.posX, Self.posY - 3008)
				ElseIf (Self.state = STATE_BROKEN) Then
					changeAniState(Self.brokencardrawer, 2)
					drawInMap(g, Self.brokencardrawer)
					
					If (Self.drop_cnt < 2) Then
						changeAniState(Self.brokencardrawer, 0)
						drawInMap(g, Self.brokencardrawer, Self.flywheel_lx, Self.flywheel_y)
						changeAniState(Self.brokencardrawer, 1)
						drawInMap(g, Self.brokencardrawer, Self.flywheel_rx, Self.flywheel_y)
					EndIf
					
					drawInMap(g, Self.facedrawer, Self.posX, Self.posY - 2496)
				ElseIf (Self.state = STATE_ESCAPE) Then
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY - 960)
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - 2624)
				EndIf
				
				Self.arm.drawArm(g)
				
				If (Self.bossbroken <> Null) Then
					Self.bossbroken.draw(g)
				EndIf
				
				drawCollisionRect(g)
			EndIf
			
		End
		
		Public Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - 2304, y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Private Method changeAniState:Void(AniDrawer:AnimationDrawer, state:Int)
			
			If (Self.velocity > 0) Then
				AniDrawer.setActionId(state)
				AniDrawer.setTrans(2)
				AniDrawer.setLoop(True)
				Return
			EndIf
			
			AniDrawer.setActionId(state)
			AniDrawer.setTrans(0)
			AniDrawer.setLoop(True)
		End
		
		Public Method close:Void()
			Self.cardrawer = Null
			Self.facedrawer = Null
			Self.brokencardrawer = Null
			Self.boatdrawer = Null
			Self.escapefacedrawer = Null
			Super.close()
		End
End