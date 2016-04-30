Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject

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
			
			Self.velX = 0
			Self.velY = 0
			
			' Magic number: 19
			Self.v_x_frame = 19 ' (display_wait_cnt_max + 3)
			
			Self.normal_jump_startVerlY = ((-GRAVITY) / 2) * 19
			Self.lowerHP_jump_startVerlY = -2600
			
			Self.wait_cnt_max = 5
			
			Self.min_range_x = 0
			
			Self.boom_offset = 1088
			
			Self.escape_v = 512
			
			Self.fly_top_range = 4096
			
			Self.side_left = 0
			Self.side_right = 0
			
			Self.start_cnt = False
			
			Self.display_cnt = 0
			Self.show_laugh_cnt = 0
			Self.high_jump_wait_cnt = 0
			
			Self.IsinHighJump = False
			
			Self.high_jump_cnt = -1
			Self.high_jump_cnt_max = 3
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			If (StageManager.getCurrentZoneId() = 5) Then
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
			
			Self.limitRightX = (SIDE_RIGHT Shl 6)
			Self.limitLeftX = (SIDE_LEFT Shl 6)
			
			refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/boss2_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(0, True, 0)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss2_face")
			EndIf
			
			Self.facedrawer = faceAni.getDrawer(0, True, 0)
			
			If (escapeboatAni = Null) Then
				escapeboatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.escapeboatdrawer = escapeboatAni.getDrawer(0, True, 0)
			
			If (escapefaceAni = Null) Then
				escapefaceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.escapefacedrawer = escapefaceAni.getDrawer(4, True, 0)
			
			Self.posY -= Self.start_pos
			
			Self.spring = New Boss2Spring(ENEMY_BOSS2_SPRING, x, y, left, top, width, height)
			
			GameObject.addGameObject(Self.spring, x, y)
			
			Self.IsBroken = False
			
			Self.state = STATE_WAIT
			
			Self.high_jump_cnt = -1
			
			setBossHP()
		End
		
		' Methods:
		
		' Extensions:
		Method onPlayerAttack:Void(p:PlayerObject, direction:Int) ' animationID:Int
			Self.HP -= 1
			
			If (Self.HP = 4) Then
				Self.high_jump_cnt = 0
			EndIf
			
			p.doBossAttackPose(Self, direction)
			
			Self.face_state = FACE_HURT
			Self.boat_state = BOAT_HURT
			
			playHitSound()
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
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Self.dead Or p <> player Or Self.state <= STATE_SHOW_WAITING_2) Then
				Return
			EndIf
			
			If (p.isAttackingEnemy()) Then
				If (Self.HP > 0 And Self.face_state <> FACE_HURT) Then
					onPlayerAttack(p, direction)
				EndIf
			ElseIf (Self.state <> STATE_BROKEN And Self.state <> STATE_ESCAPE And Self.boat_state <> BOAT_HURT And p.canBeHurt()) Then
				p.beHurt()
				
				Self.face_state = FACE_SMILE
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			If (Self.state > STATE_SHOW_WAITING_2 And Self.HP > 0 And Self.face_state <> FACE_HURT) Then
				onPlayerAttack(p, direction)
			EndIf
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Self.springH = Self.spring.getSpringHeight()
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Local tmpX:= Self.posX
				Local tmpY:= Self.posY
				
				If (Self.HP = 0 And Not Self.IsBroken) Then
					Self.state = STATE_BROKEN
					
					Self.spring.setBossBrokenState(True)
					
					Self.posY = getGroundY(Self.posX, Self.posY) - Self.springHmax
					
					Self.bossbroken = New BossBroken(ENEMY_BOSS2, Self.posX Shr 6, Self.posY Shr 6, 0, 0, 0, 0)
					
					GameObject.addGameObject(Self.bossbroken, Self.posX Shr 6, Self.posY Shr 6)
					
					Self.IsBroken = True
					
					Self.velY = 0
					
					Self.side_left = MapManager.getCamera().x
					Self.side_right = (Self.side_left + MapManager.CAMERA_WIDTH)
					
					MapManager.setCameraLeftLimit(Self.side_left)
					MapManager.setCameraRightLimit(Self.side_right)
				EndIf
				
				If (Self.state > STATE_SHOW_WAITING_2) Then
					Self.spring.setAttackable(True)
				EndIf
				
				If (Self.HP >= 5) Then
					Self.wait_cnt_max = cnt_max
					
					' Magic number: 19
					Self.v_x_frame = 19
				ElseIf (Self.HP = 4 Or Self.HP = 3) Then
					' Magic number: 7, 16
					Self.wait_cnt_max = 7 ' (cnt_max - 1)
					
					Self.v_x_frame = 16 ' display_wait_cnt_max
				ElseIf (Self.HP = 2) Then
					' Magic numbers: 6, 14
					Self.wait_cnt_max = 6 ' (cnt_max - 2)
					
					Self.v_x_frame = 14
				ElseIf (Self.HP = 1) Then
					' Magic numbers: 5, 12
					Self.wait_cnt_max = 5 ' (cnt_max - 3)
					
					Self.v_x_frame = 12
				EndIf
				
				Self.normal_jump_startVerlY = (((-GRAVITY) / 2) * Self.v_x_frame)
				
				If (Self.state > -1) Then
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
								
								bossID = ENEMY_BOSS2
								
								SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_01, True) ' SoundSystem.BGM_BOSS_02 ' 22
								
								MapManager.setCameraLeftLimit(SIDE_LEFT)
								MapManager.setCameraRightLimit(SIDE_RIGHT)
								
								MapManager.setCameraDownLimit(SIDE_DOWN_MIDDLE + ((MapManager.CAMERA_HEIGHT * 1) / 4))
								MapManager.setCameraUpLimit(SIDE_DOWN_MIDDLE - ((MapManager.CAMERA_HEIGHT * 3) / 4))
								
								Self.IsPlayBossBattleBGM = True
							EndIf
							
							Self.start_cnt = True
						EndIf
						
						If (Self.start_cnt) Then
							If (Self.display_cnt < display_cnt_max) Then
								Self.display_cnt += 1
							Else
								Self.state = STATE_SHOW_DROP
								
								Self.posX = BOSS_DRIP_X
							EndIf
						EndIf
					Case STATE_SHOW_DROP
						Self.velY += GRAVITY
						Self.posY += Self.velY
						
						Local groundY:= getGroundY(Self.posX, Self.posY)
						
						If (Self.posY + Self.velY >= groundY) Then
							Self.posY = groundY
							
							Self.state = STATE_SHOW_SPRING_DAMPING
							Self.spring_state = SPRING_DAMPING
							
							Self.spring.setSpringAni(SPRING_DAMPING, False) ' 2
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_145)
						EndIf
					Case STATE_SHOW_SPRING_DAMPING
						If (Self.spring.getEndState()) Then
							Self.state = STATE_SHOW_WAITING
							Self.spring_state = SPRING_WAITING
							
							Self.spring.setSpringAni(SPRING_WAITING, True) ' 1
						EndIf
					Case STATE_SHOW_WAITING
						If (Self.display_wait_cnt >= display_wait_cnt_max) Then
							Self.state = STATE_SHOW_LAUGH
							
							Self.facedrawer.setActionId(FACE_SMILE) ' 1
							Self.facedrawer.setTrans(TRANS_NONE)
							Self.facedrawer.setLoop(True)
							
							Self.display_wait_cnt = 0
						Else
							Self.display_wait_cnt += 1
						EndIf
					Case STATE_SHOW_LAUGH
						If (Self.show_laugh_cnt >= show_laugh_cnt_max) Then
							Self.state = STATE_SHOW_WAITING_2
							
							changeAniState(Self.facedrawer, FACE_NORMAL, True) ' 0
						Else
							Self.show_laugh_cnt += 1
						EndIf
					Case STATE_SHOW_WAITING_2
						If (Self.display_wait_cnt < display_wait_cnt_max) Then
							Self.display_wait_cnt += 1
						Else
							Self.state = STATE_ATTACK_SPRING_DAMPING
							Self.spring_state = SPRING_DAMPING
							
							Self.spring.setSpringAni(SPRING_DAMPING, False) ' 2
							
							Self.display_wait_cnt = 0
						EndIf
						
						changeAniState(Self.boatdrawer, Self.boat_state, True)
						changeAniState(Self.facedrawer, Self.face_state, True)
					Case STATE_ATTACK_WAITING
						resetBossDisplayState()
						
						If (Self.wait_cnt < Self.wait_cnt_max) Then
							Self.wait_cnt += 1
						Else
							Self.state = STATE_ATTACK_SPRING_DAMPING
							Self.spring_state = SPRING_DAMPING
							
							Self.spring.setSpringAni(SPRING_DAMPING, False) ' 2
							
							Self.wait_cnt = 0
						EndIf
						
						changeAniStateNoTran(Self.boatdrawer, Self.boat_state, True)
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
					Case STATE_ATTACK_SPRING_DAMPING
						resetBossDisplayState()
						
						If (Self.spring.getEndState()) Then
							Self.state = STATE_ATTACK_JUMPING
							Self.spring_state = SPRING_FLYING
							
							Self.spring.setSpringAni(SPRING_FLYING, True) ' 0
							
							If (HighJump()) Then
								Self.velX = 0
								Self.velY = Self.lowerHP_jump_startVerlY
								
								Self.IsinHighJump = False
							Else
								If (player.getFootPositionX() - Self.posX > Self.min_range_x Or player.getFootPositionX() - Self.posX < (-Self.min_range_x)) Then
									Self.velX = ((player.getFootPositionX() - Self.posX) / Self.v_x_frame)
								ElseIf (player.getFootPositionX() - Self.posX <= Self.min_range_x And player.getFootPositionX() - Self.posX > 0) Then
									Self.velX = (Self.min_range_x / Self.v_x_frame)
								ElseIf (player.getFootPositionX() - Self.posX >= (-Self.min_range_x) And player.getFootPositionX() - Self.posX < 0) Then
									Self.velX = ((-Self.min_range_x) / Self.v_x_frame)
								EndIf
								
								Self.velY = Self.normal_jump_startVerlY
							EndIf
						EndIf
						
						changeAniState(Self.boatdrawer, Self.boat_state, True)
						changeAniState(Self.facedrawer, Self.face_state, True)
					Case STATE_ATTACK_JUMPING
						resetBossDisplayState()
						
						If (Self.posY + Self.velY > getGroundY(Self.posX, Self.posY)) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							
							Self.state = STATE_RELASE_SPRING_DAMPING
							Self.spring_state = SPRING_DAMPING
							
							Self.spring.setSpringAni(SPRING_DAMPING, False) ' 2
							
							If (HighJump()) Then
								MapManager.setShake(cnt_max) ' 8
							EndIf
							
							If (HighJump() And player.getFootPositionY() = getGroundY(player.getFootPositionX(), player.getFootPositionY())) Then
								player.beHurt()
								
								Self.face_state = FACE_SMILE
							EndIf
							
							If (Self.HP < 5) Then
								If (Self.high_jump_cnt < Self.high_jump_cnt_max) Then
									Self.high_jump_cnt += 1
								Else
									Self.high_jump_cnt = 0
								EndIf
							EndIf
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_145)
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
								
								Self.high_jump_wait_cnt = 0
							ElseIf (Self.high_jump_wait_cnt < high_jump_wait_cnt_max) Then
								Self.high_jump_wait_cnt += 1
							Else
								Self.posX = player.getFootPositionX()
								
								Self.velY = (GRAVITY * 2)
								
								Self.IsinHighJump = True
							EndIf
							
							Self.springHmax = Self.spring.getSpringHeight()
						EndIf
						
						changeAniStateNoTran(Self.boatdrawer, Self.boat_state, True)
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
					Case STATE_RELASE_SPRING_DAMPING
						resetBossDisplayState()
						
						If (Self.spring.getEndState()) Then
							Self.state = STATE_ATTACK_WAITING
							Self.spring_state = SPRING_WAITING
							
							Self.spring.setSpringAni(SPRING_WAITING, True) ' 1
						EndIf
						
						changeAniStateNoTran(Self.boatdrawer, Self.boat_state, True)
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
					Case STATE_BROKEN
						resetBossDisplayState()
						
						Self.bossbroken.logicBoom(Self.posX, Self.posY - Self.boom_offset)
						
						Self.springH = 0
						
						Local groundY:= getGroundY(Self.posX, Self.posY)
						Local velPosY:= (Self.posY + Self.velY)
						
						Local velPosY_aboveGround:Bool = (velPosY > groundY)
						
						If (velPosY_aboveGround And Self.drop_cnt = 0) Then
							Self.posY = groundY
							
							' Magic number: -640
							Self.velY = -640
							
							Self.drop_cnt = 1
						ElseIf (velPosY_aboveGround And Self.drop_cnt = 1) Then
							Self.posY = groundY
							
							' Magic number: -320
							Self.velY = -320
							
							Self.drop_cnt = 2
						ElseIf (velPosY_aboveGround And Self.drop_cnt = 2) Then
							Self.posY = groundY
							
							Self.drop_cnt = 3
						ElseIf (Self.drop_cnt <> 3) Then
							Self.velY += GRAVITY
							Self.posY += Self.velY
						EndIf
						
						If (Self.bossbroken.getEndState()) Then
							Self.state = STATE_ESCAPE
							
							Self.fly_top = Self.posY
							Self.fly_end = Self.side_right
							
							Self.wait_cnt = 0
							
							bossFighting = False
							
							player.getBossScore()
							
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
						EndIf
						
						changeAniStateNoTran(Self.facedrawer, Self.face_state, True)
					Case STATE_ESCAPE
						Self.springH = 0
						
						Self.wait_cnt += 1
						
						If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= Self.fly_top - Self.fly_top_range) Then
							Self.posY -= Self.escape_v
						EndIf
						
						If (Self.posY <= (Self.fly_top - Self.fly_top_range) And Self.WaitCnt = 0) Then
							Self.posY = (Self.fly_top - Self.fly_top_range)
							
							Self.escapefacedrawer.setActionId(0)
							
							Self.escapeboatdrawer.setActionId(1)
							Self.escapeboatdrawer.setLoop(False)
							
							Self.WaitCnt = 1
						EndIf
						
						If (Self.WaitCnt = 1 And Self.escapeboatdrawer.checkEnd()) Then
							Self.escapefacedrawer.setActionId(0)
							Self.escapefacedrawer.setTrans(TRANS_MIRROR)
							Self.escapefacedrawer.setLoop(True)
							
							Self.escapeboatdrawer.setActionId(1)
							Self.escapeboatdrawer.setTrans(TRANS_MIRROR)
							Self.escapeboatdrawer.setLoop(False)
							
							Self.WaitCnt = 2
						EndIf
						
						If (Self.WaitCnt = 2 And Self.escapeboatdrawer.checkEnd()) Then
							Self.escapeboatdrawer.setActionId(0)
							Self.escapeboatdrawer.setTrans(TRANS_MIRROR)
							Self.escapeboatdrawer.setLoop(True)
							
							Self.WaitCnt = 3
						EndIf
						
						If (Self.WaitCnt = 3 Or Self.WaitCnt = 4) Then
							Self.posX += Self.escape_v
						EndIf
						
						If (Self.posX > (Self.side_right Shl 6) And Self.WaitCnt = 3) Then
							GameObject.addGameObject(New Cage((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH / 2)) Shl 6, MapManager.getCamera().y Shl 6)) ' Shr 1
							
							MapManager.lockCamera(True)
							
							Self.WaitCnt = 4
						EndIf
				End Select
				
				Self.spring.logic(Self.posX, Self.posY, Self.spring_state, Self.velocity)
				Self.spring.getIsHurt((Self.boat_state = BOAT_HURT))
				
				refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
			
		End
		
		Method HighJump:Bool()
			If (Self.HP >= 5 Or Self.high_jump_cnt <> 0) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method IsJumpOutScreen:Bool()
			If (Not HighJump() Or (Self.posY Shr 6) >= MapManager.getCamera().y) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method draw:Void(g:MFGraphics)
			' Magic number: 1664
			If (Not Self.dead) Then
				If (Self.state = STATE_SHOW_DROP) Then
					If (Self.posY > ((SIDE_DOWN_MIDDLE - MapManager.CAMERA_HEIGHT) Shl 6)) Then
						drawInMap(g, Self.boatdrawer, Self.posX, Self.posY - Self.springH)
						drawInMap(g, Self.facedrawer, Self.posX, (Self.posY - 1664) - Self.springH)
					EndIf
				ElseIf (Self.state <> STATE_ESCAPE And Self.state <> STATE_WAIT) Then
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY - Self.springH)
					drawInMap(g, Self.facedrawer, Self.posX, (Self.posY - 1664) - Self.springH)
				ElseIf (Self.state <> STATE_WAIT) Then
					drawInMap(g, Self.escapeboatdrawer, Self.posX, Self.posY)
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - 1664)
				EndIf
				
				drawCollisionRect(g)
				
				If (Not (Self.state = STATE_BROKEN Or Self.state = STATE_ESCAPE Or Self.state = STATE_WAIT)) Then
					Self.spring.draw(g)
				EndIf
				
				If (Self.bossbroken <> Null) Then
					Self.bossbroken.draw(g)
				EndIf
			EndIf
		End
		
		Method resetBossDisplayState:Void()
			If (Self.face_state <> FACE_NORMAL) Then
				If (Self.face_cnt < cnt_max) Then
					Self.face_cnt += 1
				Else
					Self.face_state = FACE_NORMAL
					
					Self.face_cnt = 0
				EndIf
			EndIf
			
			If (Self.boat_state = BOAT_HURT) Then
				If (Self.boat_cnt < cnt_max) Then
					Self.boat_cnt += 1
				Else
					Self.boat_state = BOAT_NORMAL
					
					Self.boat_cnt = 0
				EndIf
			EndIf
		End
		
		Method changeAniState:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool)
			AniDrawer.setActionId(state)
			
			If (player.getCheckPositionX() > Self.posX) Then
				AniDrawer.setTrans(TRANS_MIRROR)
			Else
				AniDrawer.setTrans(TRANS_NONE)
			EndIf
			
			AniDrawer.setLoop(isloop)
		End
		
		Method changeAniStateNoTran:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool)
			AniDrawer.setActionId(state)
			AniDrawer.setLoop(isloop)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), (y - (Self.offset_y + COLLISION_HEIGHT)) - Self.springH, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.boatdrawer = Null
			Self.facedrawer = Null
			
			Self.escapeboatdrawer = Null
			Self.escapefacedrawer = Null
		End
End