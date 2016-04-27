Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.boss2spring
	Import sonicgba.bossbroken
	Import sonicgba.bossobject
	Import sonicgba.cage
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss2 Extends BossObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 1280
		
		Const BOAT_NORMAL:Int = 0
		Const BOAT_HURT:Int = 1
		
		Const FACE_NORMAL:Int = 0
		Const FACE_SMILE:Int = 1
		Const FACE_HURT:Int = 2
		
		Const SPRING_FLYING:Int = 0
		Const SPRING_WAITING:Int = 1
		Const SPRING_DAMPING:Int = 2
		
		' States:
		Const STATE_WAIT:Int = -1
		Const STATE_SHOW_DROP:Int = 0
		Const STATE_SHOW_SPRING_DAMPING:Int = 1
		Const STATE_SHOW_WAITING:Int = 2
		Const STATE_SHOW_LAUGH:Int = 3
		Const STATE_SHOW_WAITING_2:Int = 4
		Const STATE_ATTACK_WAITING:Int = 5
		Const STATE_ATTACK_SPRING_DAMPING:Int = 6
		Const STATE_ATTACK_JUMPING:Int = 7
		Const STATE_RELASE_SPRING_DAMPING:Int = 8
		Const STATE_BROKEN:Int = 9
		Const STATE_ESCAPE:Int = 10
		
		Const BOSS_DRIP_X_ST2:Int = 572672
		Const BOSS_DRIP_X_ST5:Int = 603136
		
		Const SIDE_ST2:Int = 561152
		Const SIDE_DOWN_MIDDLE_ST2:Int = 1416
		Const SIDE_LEFT_ST2:Int = 8708
		Const SIDE_RIGHT_ST2:Int = 9008
		
		Const SIDE_ST5:Int = 591616
		Const SIDE_DOWN_MIDDLE_ST5:Int = 1136
		Const SIDE_LEFT_ST5:Int = 9184
		Const SIDE_RIGHT_ST5:Int = 9484
		
		Const cnt_max:Int = 8
		
		Const display_cnt_max:Int = 35
		Const display_wait_cnt_max:Int = 16
		
		Const high_jump_wait_cnt_max:Int = 34
		
		Const show_laugh_cnt_max:Int = 10
		
		' Global variable(s):
		Global BOSS_DRIP_X:Int = 0
		
		Global SIDE:Int = 0
		Global SIDE_UP:Int = 78848
		Global SIDE_DOWN_MIDDLE:Int = 0
		Global SIDE_LEFT:Int = 0
		Global SIDE_RIGHT:Int = 0
		
		' Animations:
		Global boatAni:Animation = Null
		Global escapeboatAni:Animation = Null
		Global escapefaceAni:Animation = Null
		Global faceAni:Animation = Null
		
		' Fields:
		Field IsBroken:Bool
		Field IsinHighJump:Bool
		Field start_cnt:Bool
		
		Field bossbroken:BossBroken
		Field spring:Boss2Spring
		
		Field boatdrawer:AnimationDrawer
		Field escapeboatdrawer:AnimationDrawer
		Field escapefacedrawer:AnimationDrawer
		Field facedrawer:AnimationDrawer
		
		Field state:Int
		Field boat_state:Int
		Field face_state:Int
		Field spring_state:Int
		
		Field WaitCnt:Int
		
		Field wait_cnt:Int
		Field wait_cnt_max:Int
		
		Field display_cnt:Int
		Field display_wait_cnt:Int
		
		Field face_cnt:Int
		Field drop_cnt:Int
		Field boat_cnt:Int
		
		Field show_laugh_cnt:Int
		
		Field high_jump_cnt:Int
		Field high_jump_cnt_max:Int
		Field high_jump_wait_cnt:Int
		
		Field velocity:Int
		
		Field velX:Int
		Field velY:Int
		
		Field v_x_frame:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field fly_top:Int
		Field fly_end:Int
		Field fly_top_range:Int
		
		Field range:Int
		Field min_range_x:Int
		
		Field offset_y:Int
		Field boom_offset:Int
		
		Field escape_v:Int
		
		Field normal_jump_startVerlY:Int
		Field lowerHP_jump_startVerlY:Int
		
		Field side_left:Int
		Field side_right:Int
		
		Field springH:Int
		Field springHmax:Int
		
		Field start_pos:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.offset_y = 1088
			Self.velocity = -384
			Self.range = 28800
			Self.start_pos = 16640
			Self.velX = STATE_SHOW_DROP
			Self.velY = STATE_SHOW_DROP
			Self.v_x_frame = 19
			Self.normal_jump_startVerlY = ((-GRAVITY) / STATE_SHOW_WAITING) * 19
			Self.lowerHP_jump_startVerlY = -2600
			Self.wait_cnt_max = STATE_ATTACK_WAITING
			Self.min_range_x = STATE_SHOW_DROP
			Self.boom_offset = 1088
			Self.escape_v = 512
			Self.fly_top_range = 4096
			Self.side_left = STATE_SHOW_DROP
			Self.side_right = STATE_SHOW_DROP
			Self.start_cnt = False
			Self.display_cnt = STATE_SHOW_DROP
			Self.show_laugh_cnt = STATE_SHOW_DROP
			Self.high_jump_wait_cnt = STATE_SHOW_DROP
			Self.IsinHighJump = False
			Self.high_jump_cnt = STATE_WAIT
			Self.high_jump_cnt_max = STATE_SHOW_LAUGH
			Self.posX -= Self.iLeft * cnt_max
			Self.posY -= Self.iTop * cnt_max
			
			If (StageManager.getCurrentZoneId() = STATE_ATTACK_WAITING) Then
				SIDE = SIDE_ST5
				SIDE_LEFT = SIDE_LEFT_ST5
				SIDE_RIGHT = SIDE_RIGHT_ST5
				SIDE_DOWN_MIDDLE = SIDE_DOWN_MIDDLE_ST5
				BOSS_DRIP_X = BOSS_DRIP_X_ST5
			Else
				SIDE = SIDE_ST2
				SIDE_LEFT = SIDE_LEFT_ST2
				SIDE_RIGHT = SIDE_RIGHT_ST2
				SIDE_DOWN_MIDDLE = SIDE_DOWN_MIDDLE_ST2
				BOSS_DRIP_X = BOSS_DRIP_X_ST2
			EndIf
			
			Self.limitRightX = SIDE_RIGHT Shl STATE_ATTACK_SPRING_DAMPING
			Self.limitLeftX = SIDE_LEFT Shl STATE_ATTACK_SPRING_DAMPING
			refreshCollisionRect(Self.posX Shr STATE_ATTACK_SPRING_DAMPING, Self.posY Shr STATE_ATTACK_SPRING_DAMPING)
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/boss2_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(STATE_SHOW_DROP, True, STATE_SHOW_DROP)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss2_face")
			EndIf
			
			Self.facedrawer = faceAni.getDrawer(STATE_SHOW_DROP, True, STATE_SHOW_DROP)
			
			If (escapeboatAni = Null) Then
				escapeboatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.escapeboatdrawer = escapeboatAni.getDrawer(STATE_SHOW_DROP, True, STATE_SHOW_DROP)
			
			If (escapefaceAni = Null) Then
				escapefaceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.escapefacedrawer = escapefaceAni.getDrawer(STATE_SHOW_WAITING_2, True, STATE_SHOW_DROP)
			Self.posY -= Self.start_pos
			Self.spring = New Boss2Spring(32, x, y, left, top, width, height)
			GameObject.addGameObject(Self.spring, x, y)
			Self.IsBroken = False
			Self.state = STATE_WAIT
			Self.high_jump_cnt = STATE_WAIT
			setBossHP()
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(boatAni)
			Animation.closeAnimation(faceAni)
			
			Animation.closeAnimation(escapeboatAni)
			Animation.closeAnimation(escapefaceAni)
			
			boatAni = Null
			faceAni = Null
			
			escapeboatAni = Null
			escapefaceAni = Null
		End
		
		' Methods:
		Public Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			If (Self.dead Or object <> player Or Self.state <= STATE_SHOW_WAITING_2) Then
				Return
			EndIf
			
			If (player.isAttackingEnemy()) Then
				If (Self.HP > 0 And Self.face_state <> STATE_SHOW_WAITING) Then
					Self.HP -= STATE_SHOW_SPRING_DAMPING
					
					If (Self.HP = STATE_SHOW_WAITING_2) Then
						Self.high_jump_cnt = STATE_SHOW_DROP
					EndIf
					
					player.doBossAttackPose(Self, direction)
					Self.face_state = STATE_SHOW_WAITING
					Self.boat_state = STATE_SHOW_SPRING_DAMPING
					
					If (Self.HP = 0) Then
						SoundSystem.getInstance().playSe(display_cnt_max)
					Else
						SoundSystem.getInstance().playSe(high_jump_wait_cnt_max)
					EndIf
				EndIf
				
			ElseIf (Self.state <> STATE_BROKEN And Self.state <> show_laugh_cnt_max And Self.boat_state <> STATE_SHOW_SPRING_DAMPING And player.canBeHurt()) Then
				player.beHurt()
				Self.face_state = STATE_SHOW_SPRING_DAMPING
			EndIf
			
		End
		
		Public Method doWhileBeAttack:Void(object:PlayerObject, direction:Int, animationID:Int)
			
			If (Self.state > STATE_SHOW_WAITING_2 And Self.HP > 0 And Self.face_state <> STATE_SHOW_WAITING) Then
				Self.HP -= STATE_SHOW_SPRING_DAMPING
				
				If (Self.HP = STATE_SHOW_WAITING_2) Then
					Self.high_jump_cnt = STATE_SHOW_DROP
				EndIf
				
				player.doBossAttackPose(Self, direction)
				Self.face_state = STATE_SHOW_WAITING
				Self.boat_state = STATE_SHOW_SPRING_DAMPING
				
				If (Self.HP = 0) Then
					SoundSystem.getInstance().playSe(display_cnt_max)
				Else
					SoundSystem.getInstance().playSe(high_jump_wait_cnt_max)
				EndIf
			EndIf
			
		End
		
		Public Method logic:Void()
			
			If (Not Self.dead) Then
				Self.springH = Self.spring.getSpringHeight()
				Int preX = Self.posX
				Int preY = Self.posY
				Int tmpX = Self.posX
				Int tmpY = Self.posY
				
				If (Self.HP = 0 And Not Self.IsBroken) Then
					Self.state = STATE_BROKEN
					Self.spring.setBossBrokenState(True)
					Self.posY = getGroundY(Self.posX, Self.posY) - Self.springHmax
					Self.bossbroken = New BossBroken(23, Self.posX Shr STATE_ATTACK_SPRING_DAMPING, Self.posY Shr STATE_ATTACK_SPRING_DAMPING, STATE_SHOW_DROP, STATE_SHOW_DROP, STATE_SHOW_DROP, STATE_SHOW_DROP)
					GameObject.addGameObject(Self.bossbroken, Self.posX Shr STATE_ATTACK_SPRING_DAMPING, Self.posY Shr STATE_ATTACK_SPRING_DAMPING)
					Self.IsBroken = True
					Self.velY = STATE_SHOW_DROP
					Self.side_left = MapManager.getCamera().x
					Self.side_right = Self.side_left + MapManager.CAMERA_WIDTH
					MapManager.setCameraLeftLimit(Self.side_left)
					MapManager.setCameraRightLimit(Self.side_right)
				EndIf
				
				If (Self.state > STATE_SHOW_WAITING_2) Then
					Self.spring.setAttackable(True)
				EndIf
				
				If (Self.HP >= STATE_ATTACK_WAITING) Then
					Self.wait_cnt_max = cnt_max
					Self.v_x_frame = 19
				ElseIf (Self.HP = STATE_SHOW_WAITING_2 Or Self.HP = STATE_SHOW_LAUGH) Then
					Self.wait_cnt_max = STATE_ATTACK_JUMPING
					Self.v_x_frame = display_wait_cnt_max
				ElseIf (Self.HP = STATE_SHOW_WAITING) Then
					Self.wait_cnt_max = STATE_ATTACK_SPRING_DAMPING
					Self.v_x_frame = 14
				ElseIf (Self.HP = STATE_SHOW_SPRING_DAMPING) Then
					Self.wait_cnt_max = STATE_ATTACK_WAITING
					Self.v_x_frame = 12
				EndIf
				
				Self.normal_jump_startVerlY = ((-GRAVITY) / STATE_SHOW_WAITING) * Self.v_x_frame
				
				If (Self.state > STATE_WAIT) Then
					isBossEnter = True
				EndIf
				
				Select (Self.state)
					Case STATE_WAIT
						
						If (player.getFootPositionX() >= SIDE) Then
							MapManager.setCameraRightLimit(SIDE_RIGHT)
						EndIf
						
						If (player.getFootPositionX() >= SIDE And Not Self.start_cnt And player.getFootPositionY() >= SIDE_UP) Then
							If (Not Self.IsPlayBossBattleBGM) Then
								bossFighting = True
								bossID = 23
								SoundSystem.getInstance().playBgm(22, True)
								MapManager.setCameraLeftLimit(SIDE_LEFT)
								MapManager.setCameraRightLimit(SIDE_RIGHT)
								MapManager.setCameraDownLimit(SIDE_DOWN_MIDDLE + ((MapManager.CAMERA_HEIGHT * STATE_SHOW_SPRING_DAMPING) / STATE_SHOW_WAITING_2))
								MapManager.setCameraUpLimit(SIDE_DOWN_MIDDLE - ((MapManager.CAMERA_HEIGHT * STATE_SHOW_LAUGH) / STATE_SHOW_WAITING_2))
								Self.IsPlayBossBattleBGM = True
							EndIf
							
							Self.start_cnt = True
						EndIf
						
						If (Self.start_cnt) Then
							If (Self.display_cnt < display_cnt_max) Then
								Self.display_cnt += STATE_SHOW_SPRING_DAMPING
								break
							EndIf
							
							Self.state = STATE_SHOW_DROP
							Self.posX = BOSS_DRIP_X
							break
						EndIf
						
						break
					Case STATE_SHOW_DROP
						Self.velY += GRAVITY
						Self.posY += Self.velY
						
						If (Self.posY + Self.velY >= getGroundY(Self.posX, Self.posY)) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							Self.state = STATE_SHOW_SPRING_DAMPING
							Self.spring_state = STATE_SHOW_WAITING
							Self.spring.setSpringAni(STATE_SHOW_WAITING, False)
							SoundSystem.getInstance().playSe(36)
							break
						EndIf
						
						break
					Case STATE_SHOW_SPRING_DAMPING
						
						If (Self.spring.getEndState()) Then
							Self.state = STATE_SHOW_WAITING
							Self.spring_state = STATE_SHOW_SPRING_DAMPING
							Self.spring.setSpringAni(STATE_SHOW_SPRING_DAMPING, True)
							break
						EndIf
						
						break
					Case STATE_SHOW_WAITING
						
						If (Self.display_wait_cnt >= display_wait_cnt_max) Then
							Self.state = STATE_SHOW_LAUGH
							Self.facedrawer.setActionId(STATE_SHOW_SPRING_DAMPING)
							Self.facedrawer.setTrans(STATE_SHOW_DROP)
							Self.facedrawer.setLoop(True)
							Self.display_wait_cnt = STATE_SHOW_DROP
							break
						EndIf
						
						Self.display_wait_cnt += STATE_SHOW_SPRING_DAMPING
						break
					Case STATE_SHOW_LAUGH
						
						If (Self.show_laugh_cnt >= show_laugh_cnt_max) Then
							Self.state = STATE_SHOW_WAITING_2
							changeAniState(Self.facedrawer, STATE_SHOW_DROP, True)
							break
						EndIf
						
						Self.show_laugh_cnt += STATE_SHOW_SPRING_DAMPING
						break
					Case STATE_SHOW_WAITING_2
						
						If (Self.display_wait_cnt < display_wait_cnt_max) Then
							Self.display_wait_cnt += STATE_SHOW_SPRING_DAMPING
						Else
							Self.state = STATE_ATTACK_SPRING_DAMPING
							Self.spring_state = STATE_SHOW_WAITING
							Self.spring.setSpringAni(STATE_SHOW_WAITING, False)
							Self.display_wait_cnt = STATE_SHOW_DROP
						EndIf
						
						changeAniState(Self.boatdrawer, Self.boat_state, True)
						changeAniState(Self.facedrawer, Self.face_state, True)
						break
					Case STATE_ATTACK_WAITING
						resetBossDisplayState()
						
						If (Self.wait_cnt < Self.wait_cnt_max) Then
							Self.wait_cnt += STATE_SHOW_SPRING_DAMPING
						Else
							Self.state = STATE_ATTACK_SPRING_DAMPING
							Self.spring_state = STATE_SHOW_WAITING
							Self.spring.setSpringAni(STATE_SHOW_WAITING, False)
							Self.wait_cnt = STATE_SHOW_DROP
						EndIf
						
						changeAniStateNoTran(Self.boatdrawer, Self.boat_state, True)
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
						break
					Case STATE_ATTACK_SPRING_DAMPING
						resetBossDisplayState()
						
						If (Self.spring.getEndState()) Then
							Self.state = STATE_ATTACK_JUMPING
							Self.spring_state = STATE_SHOW_DROP
							Self.spring.setSpringAni(STATE_SHOW_DROP, True)
							
							If (HighJump()) Then
								Self.velX = STATE_SHOW_DROP
								Self.velY = Self.lowerHP_jump_startVerlY
								Self.IsinHighJump = False
							Else
								
								If (player.getFootPositionX() - Self.posX > Self.min_range_x Or player.getFootPositionX() - Self.posX < (-Self.min_range_x)) Then
									Self.velX = (player.getFootPositionX() - Self.posX) / Self.v_x_frame
								ElseIf (player.getFootPositionX() - Self.posX <= Self.min_range_x And player.getFootPositionX() - Self.posX > 0) Then
									Self.velX = Self.min_range_x / Self.v_x_frame
								ElseIf (player.getFootPositionX() - Self.posX >= (-Self.min_range_x) And player.getFootPositionX() - Self.posX < 0) Then
									Self.velX = (-Self.min_range_x) / Self.v_x_frame
								EndIf
								
								Self.velY = Self.normal_jump_startVerlY
							EndIf
						EndIf
						
						changeAniState(Self.boatdrawer, Self.boat_state, True)
						changeAniState(Self.facedrawer, Self.face_state, True)
						break
					Case STATE_ATTACK_JUMPING
						resetBossDisplayState()
						
						If (Self.posY + Self.velY > getGroundY(Self.posX, Self.posY)) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							Self.state = cnt_max
							Self.spring_state = STATE_SHOW_WAITING
							Self.spring.setSpringAni(STATE_SHOW_WAITING, False)
							
							If (HighJump()) Then
								MapManager.setShake(cnt_max)
							EndIf
							
							If (HighJump() And player.getFootPositionY() = getGroundY(player.getFootPositionX(), player.getFootPositionY())) Then
								player.beHurt()
								Self.face_state = STATE_SHOW_SPRING_DAMPING
							EndIf
							
							If (Self.HP < STATE_ATTACK_WAITING) Then
								If (Self.high_jump_cnt < Self.high_jump_cnt_max) Then
									Self.high_jump_cnt += STATE_SHOW_SPRING_DAMPING
								Else
									Self.high_jump_cnt = STATE_SHOW_DROP
								EndIf
							EndIf
							
							SoundSystem.getInstance().playSe(36)
						Else
							
							If (Self.posX + Self.velX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
							ElseIf (Self.posX + Self.velX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
							Else
								Self.posX += Self.velX
							EndIf
							
							If (Not IsJumpOutScreen() Or Self.IsinHighJump) Then
								Self.velY += GRAVITY
								Self.posY += Self.velY
								Self.high_jump_wait_cnt = STATE_SHOW_DROP
							ElseIf (Self.high_jump_wait_cnt < high_jump_wait_cnt_max) Then
								Self.high_jump_wait_cnt += STATE_SHOW_SPRING_DAMPING
							Else
								Self.posX = player.getFootPositionX()
								Self.velY = STATE_SHOW_DROP
								Self.velY += GRAVITY * STATE_SHOW_WAITING
								Self.IsinHighJump = True
							EndIf
							
							Self.springHmax = Self.spring.getSpringHeight()
						EndIf
						
						changeAniStateNoTran(Self.boatdrawer, Self.boat_state, True)
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
						break
					Case cnt_max
						resetBossDisplayState()
						
						If (Self.spring.getEndState()) Then
							Self.state = STATE_ATTACK_WAITING
							Self.spring_state = STATE_SHOW_SPRING_DAMPING
							Self.spring.setSpringAni(STATE_SHOW_SPRING_DAMPING, True)
						EndIf
						
						changeAniStateNoTran(Self.boatdrawer, Self.boat_state, True)
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
						break
					Case STATE_BROKEN
						resetBossDisplayState()
						Self.bossbroken.logicBoom(Self.posX, Self.posY - Self.boom_offset)
						Self.springH = STATE_SHOW_DROP
						
						If (Self.posY + Self.velY > getGroundY(Self.posX, Self.posY) And Self.drop_cnt = 0) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							Self.velY = -640
							Self.drop_cnt = STATE_SHOW_SPRING_DAMPING
						ElseIf (Self.posY + Self.velY > getGroundY(Self.posX, Self.posY) And Self.drop_cnt = STATE_SHOW_SPRING_DAMPING) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							Self.velY = -320
							Self.drop_cnt = STATE_SHOW_WAITING
						ElseIf (Self.posY + Self.velY > getGroundY(Self.posX, Self.posY) And Self.drop_cnt = STATE_SHOW_WAITING) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							Self.drop_cnt = STATE_SHOW_LAUGH
						ElseIf (Self.drop_cnt <> STATE_SHOW_LAUGH) Then
							Self.velY += GRAVITY
							Self.posY += Self.velY
						EndIf
						
						If (Self.bossbroken.getEndState()) Then
							Self.state = show_laugh_cnt_max
							Self.fly_top = Self.posY
							Self.fly_end = Self.side_right
							Self.wait_cnt = STATE_SHOW_DROP
							bossFighting = False
							player.getBossScore()
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
						EndIf
						
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
						break
					Case show_laugh_cnt_max
						Self.springH = STATE_SHOW_DROP
						Self.wait_cnt += STATE_SHOW_SPRING_DAMPING
						
						If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= Self.fly_top - Self.fly_top_range) Then
							Self.posY -= Self.escape_v
						EndIf
						
						If (Self.posY <= Self.fly_top - Self.fly_top_range And Self.WaitCnt = 0) Then
							Self.posY = Self.fly_top - Self.fly_top_range
							Self.escapefacedrawer.setActionId(STATE_SHOW_DROP)
							Self.escapeboatdrawer.setActionId(STATE_SHOW_SPRING_DAMPING)
							Self.escapeboatdrawer.setLoop(False)
							Self.WaitCnt = STATE_SHOW_SPRING_DAMPING
						EndIf
						
						If (Self.WaitCnt = STATE_SHOW_SPRING_DAMPING And Self.escapeboatdrawer.checkEnd()) Then
							Self.escapefacedrawer.setActionId(STATE_SHOW_DROP)
							Self.escapefacedrawer.setTrans(STATE_SHOW_WAITING)
							Self.escapefacedrawer.setLoop(True)
							Self.escapeboatdrawer.setActionId(STATE_SHOW_SPRING_DAMPING)
							Self.escapeboatdrawer.setTrans(STATE_SHOW_WAITING)
							Self.escapeboatdrawer.setLoop(False)
							Self.WaitCnt = STATE_SHOW_WAITING
						EndIf
						
						If (Self.WaitCnt = STATE_SHOW_WAITING And Self.escapeboatdrawer.checkEnd()) Then
							Self.escapeboatdrawer.setActionId(STATE_SHOW_DROP)
							Self.escapeboatdrawer.setTrans(STATE_SHOW_WAITING)
							Self.escapeboatdrawer.setLoop(True)
							Self.WaitCnt = STATE_SHOW_LAUGH
						EndIf
						
						If (Self.WaitCnt = STATE_SHOW_LAUGH Or Self.WaitCnt = STATE_SHOW_WAITING_2) Then
							Self.posX += Self.escape_v
						EndIf
						
						If (Self.posX > (Self.side_right Shl STATE_ATTACK_SPRING_DAMPING) And Self.WaitCnt = STATE_SHOW_LAUGH) Then
							GameObject.addGameObject(New Cage((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH Shr STATE_SHOW_SPRING_DAMPING)) Shl STATE_ATTACK_SPRING_DAMPING, MapManager.getCamera().y Shl STATE_ATTACK_SPRING_DAMPING))
							MapManager.lockCamera(True)
							Self.WaitCnt = STATE_SHOW_WAITING_2
							break
						EndIf
				EndIf
				Self.spring.logic(Self.posX, Self.posY, Self.spring_state, Self.velocity)
				Self.spring.getIsHurt(Self.boat_state = STATE_SHOW_SPRING_DAMPING)
				refreshCollisionRect(Self.posX Shr STATE_ATTACK_SPRING_DAMPING, Self.posY Shr STATE_ATTACK_SPRING_DAMPING)
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
			
		End
		
		Public Method HighJump:Bool()
			
			If (Self.HP >= STATE_ATTACK_WAITING Or Self.high_jump_cnt <> 0) Then
				Return False
			EndIf
			
			Return True
		End
		
		Public Method IsJumpOutScreen:Bool()
			
			If (Not HighJump() Or (Self.posY Shr STATE_ATTACK_SPRING_DAMPING) >= MapManager.getCamera().y) Then
				Return False
			EndIf
			
			Return True
		End
		
		Public Method draw:Void(g:MFGraphics)
			
			If (Not Self.dead) Then
				If (Self.state = 0) Then
					If (Self.posY > ((SIDE_DOWN_MIDDLE - MapManager.CAMERA_HEIGHT) Shl STATE_ATTACK_SPRING_DAMPING)) Then
						drawInMap(g, Self.boatdrawer, Self.posX, Self.posY - Self.springH)
						drawInMap(g, Self.facedrawer, Self.posX, (Self.posY - Boss6Block.COLLISION2_HEIGHT) - Self.springH)
					EndIf
					
				ElseIf (Self.state <> show_laugh_cnt_max And Self.state <> STATE_WAIT) Then
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY - Self.springH)
					drawInMap(g, Self.facedrawer, Self.posX, (Self.posY - Boss6Block.COLLISION2_HEIGHT) - Self.springH)
				ElseIf (Self.state <> STATE_WAIT) Then
					drawInMap(g, Self.escapeboatdrawer, Self.posX, Self.posY)
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - Boss6Block.COLLISION2_HEIGHT)
				EndIf
				
				drawCollisionRect(g)
				
				If (Not (Self.state = STATE_BROKEN Or Self.state = show_laugh_cnt_max Or Self.state = STATE_WAIT)) Then
					Self.spring.draw(g)
				EndIf
				
				If (Self.bossbroken <> Null) Then
					Self.bossbroken.draw(g)
				EndIf
			EndIf
			
		End
		
		Public Method resetBossDisplayState:Void()
			
			If (Self.face_state <> 0) Then
				If (Self.face_cnt < cnt_max) Then
					Self.face_cnt += STATE_SHOW_SPRING_DAMPING
				Else
					Self.face_state = STATE_SHOW_DROP
					Self.face_cnt = STATE_SHOW_DROP
				EndIf
			EndIf
			
			If (Self.boat_state <> STATE_SHOW_SPRING_DAMPING) Then
				Return
			EndIf
			
			If (Self.boat_cnt < cnt_max) Then
				Self.boat_cnt += STATE_SHOW_SPRING_DAMPING
				Return
			EndIf
			
			Self.boat_state = STATE_SHOW_DROP
			Self.boat_cnt = STATE_SHOW_DROP
		End
		
		Public Method changeAniState:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool)
			
			If (player.getCheckPositionX() > Self.posX) Then
				AniDrawer.setActionId(state)
				AniDrawer.setTrans(STATE_SHOW_WAITING)
				AniDrawer.setLoop(isloop)
				Return
			EndIf
			
			AniDrawer.setActionId(state)
			AniDrawer.setTrans(STATE_SHOW_DROP)
			AniDrawer.setLoop(isloop)
		End
		
		Public Method changeAniStateNoTran:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool)
			AniDrawer.setActionId(state)
			AniDrawer.setLoop(isloop)
		End
		
		Public Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - PlayerObject.HEIGHT, (y - (Self.offset_y + COLLISION_HEIGHT)) - Self.springH, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Public Method close:Void()
			Self.boatdrawer = Null
			Self.facedrawer = Null
			Self.escapeboatdrawer = Null
			Self.escapefacedrawer = Null
		End
End