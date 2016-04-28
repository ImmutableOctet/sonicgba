Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	
	Import sonicgba.boss3pipe
	Import sonicgba.boss3shadow
	Import sonicgba.bossbroken
	Import sonicgba.bossobject
	Import sonicgba.cage
	Import sonicgba.mapmanager
	Import sonicgba.platform
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss3 Extends BossObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3200
		Const COLLISION_HEIGHT:Int = 3200
		
		Const BOAT_NORMAL:Int = 0
		Const BOAT_HURT:Int = 1
		
		Const PRO_INIT:Int = 0
		Const PRO_BOSS_MOVING:Int = 1
		
		Const SHOW_PIPE_ENTER:Int = 0
		Const SHOW_BOSS_ENTER:Int = 1
		Const SHOW_BOSS_INTO_PIPE:Int = 3
		Const SHOW_BOSS_LAUGH:Int = 2
		
		Const FACE_NORMAL:Int = 0
		Const FACE_SMILE:Int = 1
		Const FACE_HURT:Int = 2
		
		' States:
		Const STATE_INIT:Int = 0
		Const STATE_ENTER_SHOW:Int = 1
		Const STATE_PRO:Int = 2
		Const STATE_BROKEN:Int = 3
		Const STATE_ESCAPE:Int = 4
		
		Const PLATFORM_ID:Int = 21
		Const PLATFORM_LEFT:Int = 5312
		Const PLATFORM_TOP:Int = -960
		Const PLATFORM_X:Int = 481792
		Const PLATFORM_Y:Int = 138752
		
		Const SIDE_CHECK_UP:Int = 129024
		
		Const SIDE_UP:Int = 2062
		Const SIDE_DOWN_MIDDLE:Int = 2232
		Const SIDE_LEFT:Int = 7384
		Const SIDE_RIGHT:Int = 7664
		
		Const cnt_max:Int = 8
		
		Const boss_wait_cnt_max:Int = 16
		Const pipe_offset_max:Int = 16
		Const release_cnt_max:Int = 25
		Const show_pipe_cnt_max:Int = 19
		
		' Global variable(s):
		Global boatAni:Animation = Null
		Global escapefaceAni:Animation = Null
		Global faceAni:Animation = Null
		Global partAni:Animation = Null
		Global pipeAni:Animation = Null
		Global realAni:Animation = Null
		Global shadowAni:Animation = Null
		
		' Fields:
		Field IsInPipeCollision:Bool
		Field IsPipeOut:Bool
		Field IsStartAttack:Bool
		Field StartEscape:Bool
		
		Field boatdrawer:AnimationDrawer
		Field escapefacedrawer:AnimationDrawer
		Field facedrawer:AnimationDrawer
		Field partdrawer:AnimationDrawer
		Field pipedrawer:AnimationDrawer
		Field realdrawer:AnimationDrawer
		Field shadowdrawer:AnimationDrawer
		
		Field bossbroken:BossBroken
		Field shadow:Boss3Shadow
		Field platform:Platform
		
		Field pipe:Boss3Pipe[]
		
		Field pipepos:Int[][]
		Field pipeposend:Int[]
		
		Field state:Int
		Field boat_state:Int
		Field face_state:Int
		
		Field show_step:Int
		
		Field BossVX:Int
		Field BossVY:Int
		
		Field BossV_x:Int
		Field BossV_y:Int
		
		Field FACE_OFFSET_X:Int
		Field FACE_OFFSET_Y:Int
		
		Field ShadowPosX:Int
		Field ShadowPosY:Int
		
		Field ShadowVX:Int
		Field ShadowVY:Int
		
		Field StartPosX:Int
		Field WaitCnt:Int
		
		Field boat_cnt:Int
		
		Field boss_drip_cnt:Int
		Field boss_show_top:Int
		Field boss_v:Int
		Field boss_wait_cnt:Int
		
		Field compartPosX:Int
		Field escape_v:Int
		
		Field face_cnt:Int
		
		Field fly_end:Int
		Field fly_top:Int
		Field fly_top_range:Int
		
		Field partvx:Int
		Field partvy:Int
		
		Field partx:Int
		Field party:Int
		
		Field pipe_offset:Int
		
		Field pipe_vel:Int
		
		Field pipe_vel_h:Int
		Field pipe_vel_v:Int
		
		Field pro_step:Int
		
		Field release_cnt:Int
		Field shadow_drip_cnt:Int
		
		Field show_pipe_cnt:Int
		
		Field side_left:Int
		Field side_right:Int
		
		Field wait_cnt:Int
		Field wait_cnt_max:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.FACE_OFFSET_X = 576
			Self.FACE_OFFSET_Y = -768
			
			Self.side_left = 0
			Self.side_right = 0
			
			Self.pipe_vel = 128
			Self.pipe_vel_v = 512
			Self.pipe_vel_h = 256
			
			Self.boss_v = 320
			
			Self.release_cnt = 0
			Self.wait_cnt_max = 10
			
			Self.escape_v = 512
			
			Self.fly_top_range = 4096
			
			Self.show_pipe_cnt = 0
			
			Self.IsStartAttack = False
			Self.IsPipeOut = False
			Self.IsInPipeCollision = False
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			Self.StartPosX = 475136
			Self.compartPosX = 481536
			
			Self.pipepos = New Int[8][]
			
			For Local i:= 0 Until Self.pipepos.Length
				Self.pipepos[i] = New Int[2]
			Next
			
			Self.pipepos[0][0] = 494592
			Self.pipepos[0][1] = 136384
			Self.pipepos[1][0] = 494592
			Self.pipepos[1][1] = 141632
			Self.pipepos[2][0] = 468480
			Self.pipepos[2][1] = 136384
			Self.pipepos[3][0] = 468480
			Self.pipepos[3][1] = 141632
			Self.pipepos[4][0] = 478016
			Self.pipepos[4][1] = 124544
			Self.pipepos[5][0] = 485056
			Self.pipepos[5][1] = 124544
			Self.pipepos[6][0] = 478016
			Self.pipepos[6][1] = 153600
			Self.pipepos[7][0] = 485056
			Self.pipepos[7][1] = 153600
			
			Self.boss_show_top = 139264
			
			Self.pipeposend = New Int[4]
			
			Self.pipeposend[0] = 491264
			Self.pipeposend[1] = 471808
			Self.pipeposend[2] = 131200
			Self.pipeposend[3] = 148224
			
			refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
			
			If (realAni = Null) Then
				realAni = New Animation("/animation/boss3_real")
			EndIf
			
			Self.realdrawer = realAni.getDrawer(0, True, 0)
			
			If (shadowAni = Null) Then
				shadowAni = New Animation("/animation/boss3_shadow")
			EndIf
			
			Self.shadowdrawer = shadowAni.getDrawer(0, True, 0)
			
			If (pipeAni = Null) Then
				pipeAni = New Animation("/animation/boss3_pipe")
			EndIf
			
			Self.pipedrawer = pipeAni.getDrawer()
			
			Self.pipedrawer.setPause(True)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss3_face")
			EndIf
			
			Self.facedrawer = faceAni.getDrawer(0, True, 0)
			
			Self.state = STATE_INIT
			
			Self.pipe = New Boss3Pipe[8]
			
			Self.pipe[0] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[0][0] Shr 6, Self.pipepos[0][1] Shr 6, False, 3, 0)
			Self.pipe[1] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[1][0] Shr 6, Self.pipepos[1][1] Shr 6, False, 3, 0)
			Self.pipe[2] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[2][0] Shr 6, Self.pipepos[2][1] Shr 6, False, 2, 0)
			Self.pipe[3] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[3][0] Shr 6, Self.pipepos[3][1] Shr 6, False, 2, 0)
			Self.pipe[4] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[4][0] Shr 6, Self.pipepos[4][1] Shr 6, False, 0, 1)
			Self.pipe[5] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[5][0] Shr 6, Self.pipepos[5][1] Shr 6, False, 0, 1)
			Self.pipe[6] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[6][0] Shr 6, Self.pipepos[6][1] Shr 6, True, 1, 0)
			Self.pipe[7] = New Boss3Pipe(ENEMY_BOSS3, Self.pipepos[7][0] Shr 6, Self.pipepos[7][1] Shr 6, True, 1, 0)
			
			For Local i:= 0 Until Self.pipe.Length
				GameObject.addGameObject(Self.pipe[i])
				
				Self.pipe[i].setisDraw(False)
			Next
			
			Self.platform = New Platform(PLATFORM_ID, PLATFORM_X, PLATFORM_Y, PLATFORM_LEFT, PLATFORM_TOP, 0, 0)
			
			GameObject.addGameObject(Self.platform)
			
			Self.IsStartAttack = False
			Self.IsPipeOut = False
			Self.IsInPipeCollision = False
			
			setBossHP()
		End
		
		' Methods:
		
		' Extensions:
		Method onPlayerAttack:Void(p:PlayerObject, direction:Int) ' animationID:Int
			Self.HP -= 1
			
			p.doBossAttackPose(Self, direction)
			
			Self.face_state = FACE_HURT
			Self.boat_state = 1
			
			If (Self.HP = 0) Then
				Self.state = STATE_BROKEN
				
				Self.side_left = MapManager.getCamera().x
				Self.side_right = (Self.side_left + MapManager.CAMERA_WIDTH)
				
				MapManager.setCameraLeftLimit(Self.side_left)
				MapManager.setCameraRightLimit(Self.side_right)
				
				Self.bossbroken = New BossBroken(ENEMY_BOSS3, (Self.posX Shr 6), (Self.posY Shr 6), 0, 0, 0, 0)
				
				GameObject.addGameObject(Self.bossbroken, (Self.posX Shr 6), (Self.posY Shr 6))
				
				Self.pipe_offset = 0
				
				' Magic numbers: -256, 256
				If (Self.compartPosX < Self.posX) Then
					Self.BossVX = -256
				Else
					Self.BossVX = 256
				EndIf
				
				Self.BossVY = 0
				
				' Magic numbers: -1024, 1024
				If (Self.compartPosX < Self.ShadowPosX) Then
					Self.ShadowVX = -1024
				Else
					Self.ShadowVX = 1024
				EndIf
				
				Self.ShadowVY = -512
				
				Self.boss_drip_cnt = 0
				Self.shadow_drip_cnt = 0
				
				Self.facedrawer.setActionId(FACE_NORMAL) ' 0
			EndIf
			
			playHitSound()
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.dead Or Self.state <= STATE_ENTER_SHOW Or Self.IsInPipeCollision Or p <> player) Then
				Return
			EndIf
			
			If (p.isAttackingEnemy()) Then
				If (Self.IsStartAttack And Self.HP > 0 And Self.state = STATE_PRO And Self.pro_step = PRO_BOSS_MOVING And Self.face_state <> FACE_HURT) Then
					onPlayerAttack(p, direction)
				EndIf
			ElseIf (Self.state = STATE_PRO And Self.pro_step = PRO_BOSS_MOVING And Self.boat_state <> 1 And Self.IsStartAttack And p.canBeHurt()) Then
				p.beHurt()
				
				Self.face_state = FACE_SMILE
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			If (Self.state > STATE_ENTER_SHOW And Not Self.IsInPipeCollision And Self.IsStartAttack And Self.HP > 0 And Self.state = STATE_PRO And Self.pro_step = PRO_BOSS_MOVING And Self.face_state <> FACE_HURT) Then
				onPlayerAttack(p, direction) ' animationID
			EndIf
		End
		
		Public Method logic:Void()
			
			If (Not Self.dead) Then
				Int preX = Self.posX
				Int preY = Self.posY
				
				If (Self.state > 0) Then
					isBossEnter = True
				EndIf
				
				Int[] iArr
				Select (Self.state)
					Case 0
						
						If (player.getFootPositionX() >= Self.StartPosX) Then
							MapManager.setCameraRightLimit(SIDE_RIGHT)
						EndIf
						
						If (player.getFootPositionX() >= Self.StartPosX And player.getFootPositionY() >= SIDE_CHECK_UP) Then
							Self.state = STATE_ENTER_SHOW
							Self.show_step = 0
							Self.pipe_offset = 0
							MapManager.setCameraLeftLimit(SIDE_LEFT)
							MapManager.setCameraRightLimit(SIDE_RIGHT)
							MapManager.setCameraUpLimit(SIDE_UP)
							MapManager.setCameraDownLimit(((MapManager.CAMERA_HEIGHT * 1) / 4) + SIDE_DOWN_MIDDLE)
							
							If (Not Self.IsPlayBossBattleBGM) Then
								bossFighting = True
								bossID = ENEMY_BOSS3
								SoundSystem.getInstance().playBgm(22, True)
								Self.IsPlayBossBattleBGM = True
								break
							EndIf
						EndIf
						
						break
					Case 1
						Select (Self.show_step)
							Case 0
								
								If (Self.show_pipe_cnt >= show_pipe_cnt_max) Then
									If (Self.pipe_offset >= pipe_offset_max) Then
										Self.show_step = 1
										Self.pipepos[0][0] = 490496
										Self.pipepos[0][1] = 136384
										Self.pipepos[1][0] = 490496
										Self.pipepos[1][1] = 141632
										Self.pipepos[2][0] = 472576
										Self.pipepos[2][1] = 136384
										Self.pipepos[3][0] = 472576
										Self.pipepos[3][1] = 141632
										Self.pipepos[4][0] = 478016
										Self.pipepos[4][1] = 132736
										Self.pipepos[5][0] = 485056
										Self.pipepos[5][1] = 132736
										Self.pipepos[6][0] = 478016
										Self.pipepos[6][1] = 145408
										Self.pipepos[7][0] = 485056
										Self.pipepos[7][1] = 145408
										Self.posX = Self.pipepos[7][0]
										Self.posY = Self.pipepos[7][1]
										break
									EndIf
									
									Self.pipe_offset += 1
									iArr = Self.pipepos[0]
									iArr[0] = iArr[0] - Self.pipe_vel_h
									iArr = Self.pipepos[1]
									iArr[0] = iArr[0] - Self.pipe_vel_h
									iArr = Self.pipepos[2]
									iArr[0] = iArr[0] + Self.pipe_vel_h
									iArr = Self.pipepos[3]
									iArr[0] = iArr[0] + Self.pipe_vel_h
									iArr = Self.pipepos[4]
									iArr[1] = iArr[1] + Self.pipe_vel_v
									iArr = Self.pipepos[5]
									iArr[1] = iArr[1] + Self.pipe_vel_v
									iArr = Self.pipepos[6]
									iArr[1] = iArr[1] - Self.pipe_vel_v
									iArr = Self.pipepos[7]
									iArr[1] = iArr[1] - Self.pipe_vel_v
									break
								EndIf
								
								Self.show_pipe_cnt += 1
								break
							Case 1
								
								If (Self.posY <= Self.boss_show_top) Then
									Self.posY = Self.boss_show_top
									Self.show_step = 2
									break
								EndIf
								
								Self.posY -= Self.boss_v
								break
							Case 2
								
								If (Self.boss_wait_cnt >= pipe_offset_max) Then
									If (Self.boss_wait_cnt <> pipe_offset_max) Then
										If (Self.boss_wait_cnt <= pipe_offset_max Or Self.boss_wait_cnt >= 26) Then
											If (Self.boss_wait_cnt <> 26) Then
												If (Self.boss_wait_cnt <= 26 Or Self.boss_wait_cnt >= 42) Then
													If (Self.boss_wait_cnt = 42) Then
														Self.show_step = 3
														break
													EndIf
												EndIf
												
												Self.boss_wait_cnt += 1
												break
											EndIf
											
											Self.boss_wait_cnt += 1
											Self.facedrawer.setActionId(0)
											Self.facedrawer.setLoop(True)
											break
										EndIf
										
										Self.boss_wait_cnt += 1
										break
									EndIf
									
									Self.boss_wait_cnt += 1
									Self.facedrawer.setActionId(1)
									Self.facedrawer.setLoop(True)
									break
								EndIf
								
								Self.boss_wait_cnt += 1
								break
								break
							Case 3
								
								If (Self.posY <= Self.pipepos[5][1]) Then
									Self.posY = Self.pipepos[5][1]
									Self.state = STATE_PRO
									Self.pro_step = 0
									Self.shadow = New Boss3Shadow(34, Self.posX, Self.posY, 0, 0, 0, 0)
									Self.boss_drip_cnt = 0
									break
								EndIf
								
								Self.posY -= Self.boss_v
								break
							Default
								break
						EndIf
					Case 2
						
						If (Self.face_state = STATE_INIT) Then
							Self.face_state = Self.shadow.getShadowHurt()
						EndIf
						
						If (Self.face_state <> FACE_NORMAL) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								Self.face_state = STATE_INIT
								Self.shadow.setShadowHurt(0)
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Self.boat_state = 1) Then
							If (Self.boat_cnt < cnt_max) Then
								Self.boat_cnt += 1
							Else
								Self.boat_state = STATE_INIT
								Self.boat_cnt = 0
							EndIf
						EndIf
						
						Select (Self.pro_step)
							Case 0
								Self.IsStartAttack = False
								
								If (Self.release_cnt >= release_cnt_max) Then
									If (Self.HP >= 6) Then
										Self.BossV_x = 458
										Self.BossV_y = 330
									ElseIf (Self.HP = 5) Then
										Self.BossV_x = 549
										Self.BossV_y = 396
									ElseIf (Self.HP = 4) Then
										Self.BossV_x = 549
										Self.BossV_y = TitleState.RETURN_PRESSED
									ElseIf (Self.HP = 3 Or Self.HP = 2) Then
										Self.BossV_x = MDPhone.SCREEN_HEIGHT
										Self.BossV_y = 462
									ElseIf (Self.HP = 1) Then
										Self.BossV_x = 733
										Self.BossV_y = 528
									EndIf
									
									Int rand1 = MyRandom.nextInt(0, 7)
									Int rand2 = MyRandom.nextInt(0, 7)
									Select (rand1)
										Case 0
										Case 2
											
											If (rand2 = 0 Or rand2 = 2) Then
												rand2 = MyRandom.nextInt(3, 7)
												break
											EndIf
											
										Case 1
										Case 3
											
											If (rand2 = 1 Or rand2 = 3) Then
												rand2 = MyRandom.nextInt(4, 7)
												break
											EndIf
											
										Case 4
										Case SSdef.SSOBJ_BNLD_ID
											
											If (rand2 = 4 Or rand2 = 6) Then
												rand2 = MyRandom.nextInt(0, 3)
												break
											EndIf
											
										Case SSdef.SSOBJ_BNRU_ID
										Case SSdef.SSOBJ_BNRD_ID
											
											If (rand2 = 5 Or rand2 = 7) Then
												rand2 = MyRandom.nextInt(0, 4)
												break
											EndIf
									EndIf
									Self.posX = Self.pipepos[rand1][0]
									Self.posY = Self.pipepos[rand1][1]
									Self.ShadowPosX = Self.pipepos[rand2][0]
									Self.ShadowPosY = Self.pipepos[rand2][1]
									Select (rand1)
										Case 0
										Case 1
											Self.BossVX = -Abs(Self.BossV_x)
											Self.BossVY = 0
											Self.realdrawer.setTrans(0)
											Self.facedrawer.setTrans(0)
											Self.FACE_OFFSET_X = 576
											break
										Case 2
										Case 3
											Self.BossVX = Abs(Self.BossV_x)
											Self.BossVY = 0
											Self.realdrawer.setTrans(2)
											Self.facedrawer.setTrans(2)
											Self.FACE_OFFSET_X = -448
											break
										Case 4
										Case SSdef.SSOBJ_BNRU_ID
											Self.BossVX = 0
											Self.BossVY = Abs(Self.BossV_y)
											
											If (rand1 <> 4) Then
												Self.realdrawer.setTrans(0)
												Self.facedrawer.setTrans(0)
												Self.FACE_OFFSET_X = 576
												break
											EndIf
											
											Self.realdrawer.setTrans(2)
											Self.facedrawer.setTrans(2)
											Self.FACE_OFFSET_X = -448
											break
										Case SSdef.SSOBJ_BNLD_ID
										Case SSdef.SSOBJ_BNRD_ID
											Self.BossVX = 0
											Self.BossVY = -Abs(Self.BossV_y)
											
											If (rand1 <> 6) Then
												Self.realdrawer.setTrans(0)
												Self.facedrawer.setTrans(0)
												Self.FACE_OFFSET_X = 576
												break
											EndIf
											
											Self.realdrawer.setTrans(2)
											Self.facedrawer.setTrans(2)
											Self.FACE_OFFSET_X = -448
											break
									EndIf
									Select (rand2)
										Case 0
										Case 1
											Self.ShadowVX = -Abs(Self.BossV_x)
											Self.ShadowVY = 0
											Self.shadowdrawer.setTrans(0)
											break
										Case 2
										Case 3
											Self.ShadowVX = Abs(Self.BossV_x)
											Self.ShadowVY = 0
											Self.shadowdrawer.setTrans(2)
											break
										Case 4
										Case SSdef.SSOBJ_BNRU_ID
											Self.ShadowVX = 0
											Self.ShadowVY = Abs(Self.BossV_y)
											
											If (rand2 <> 4) Then
												Self.shadowdrawer.setTrans(0)
												break
											Else
												Self.shadowdrawer.setTrans(2)
												break
											EndIf
											
										Case SSdef.SSOBJ_BNLD_ID
										Case SSdef.SSOBJ_BNRD_ID
											Self.ShadowVX = 0
											Self.ShadowVY = -Abs(Self.BossV_y)
											
											If (rand2 <> 6) Then
												Self.shadowdrawer.setTrans(0)
												break
											Else
												Self.shadowdrawer.setTrans(2)
												break
											EndIf
									EndIf
									Self.pro_step = PRO_BOSS_MOVING
									Self.release_cnt = 0
									break
								EndIf
								
								Self.release_cnt += 1
								break
								break
							Case 1
								Self.IsStartAttack = True
								
								If (Self.posX + Self.BossVX < Self.pipeposend[1] + 1280 Or Self.posX + Self.BossVX > Self.pipeposend[0] - 1280) Then
									Self.IsInPipeCollision = True
								Else
									Self.IsInPipeCollision = False
								EndIf
								
								If (Self.ShadowPosX + Self.ShadowVX < Self.pipeposend[1] + 1280 Or Self.ShadowPosX + Self.ShadowVX > Self.pipeposend[0] - 1280) Then
									Self.shadow.IsInPipeCollision = True
								Else
									Self.shadow.IsInPipeCollision = False
								EndIf
								
								If (Self.posX + Self.BossVX >= Self.pipeposend[1] And Self.posX + Self.BossVX <= Self.pipeposend[0] And Self.ShadowPosX + Self.ShadowVX >= Self.pipeposend[1] And Self.ShadowPosX + Self.ShadowVX <= Self.pipeposend[0] And Self.posY + Self.BossVY >= Self.pipeposend[2] And Self.posY + Self.BossVY <= Self.pipeposend[3] And Self.ShadowPosY + Self.ShadowVY >= Self.pipeposend[2] And Self.ShadowPosY + Self.ShadowVY <= Self.pipeposend[3]) Then
									Self.posX += Self.BossVX
									Self.posY += Self.BossVY
									Self.ShadowPosX += Self.ShadowVX
									Self.ShadowPosY += Self.ShadowVY
									break
								EndIf
								
								Self.pro_step = 0
								break
						EndIf
						Self.shadow.logic(Self.ShadowPosX, Self.ShadowPosY)
						Self.facedrawer.setActionId(Self.face_state)
						Self.realdrawer.setActionId(Self.boat_state)
						break
					Case 3
						Self.platform.setDisplay(False)
						Self.shadow.IsOver = True
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
						
						If (Self.pipe_offset < pipe_offset_max) Then
							Self.pipe_offset += 1
							iArr = Self.pipepos[0]
							iArr[0] = iArr[0] + Self.pipe_vel_h
							iArr = Self.pipepos[1]
							iArr[0] = iArr[0] + Self.pipe_vel_h
							iArr = Self.pipepos[2]
							iArr[0] = iArr[0] - Self.pipe_vel_h
							iArr = Self.pipepos[3]
							iArr[0] = iArr[0] - Self.pipe_vel_h
							iArr = Self.pipepos[4]
							iArr[1] = iArr[1] - Self.pipe_vel_v
							iArr = Self.pipepos[5]
							iArr[1] = iArr[1] - Self.pipe_vel_v
							iArr = Self.pipepos[6]
							iArr[1] = iArr[1] + Self.pipe_vel_v
							iArr = Self.pipepos[7]
							iArr[1] = iArr[1] + Self.pipe_vel_v
						Else
							Self.IsPipeOut = True
						EndIf
						
						If ((Self.posY + Self.BossVY) + 1600 > getGroundY(Self.posX, Self.posY) And Self.boss_drip_cnt = 0) Then
							Self.posY = getGroundY(Self.posX, Self.posY) - 1600
							Self.BossVY = -1280
							Self.boss_drip_cnt = 1
						ElseIf ((Self.posY + Self.BossVY) + 1600 > getGroundY(Self.posX, Self.posY) And Self.boss_drip_cnt = 1) Then
							Self.posY = getGroundY(Self.posX, Self.posY) - 1600
							Self.BossVY = -640
							Self.boss_drip_cnt = 2
						ElseIf ((Self.posY + Self.BossVY) + 1600 <= getGroundY(Self.posX, Self.posY) Or Self.boss_drip_cnt <> 2) Then
							Self.posX += Self.BossVX
							Self.BossVY += GRAVITY
							Self.posY += Self.BossVY
						Else
							Self.posY = getGroundY(Self.posX, Self.posY) - 1600
							
							If (partAni = Null) Then
								partAni = New Animation("/animation/boss3_part")
							EndIf
							
							Self.partdrawer = partAni.getDrawer(0, True, 0)
							
							If (boatAni = Null) Then
								boatAni = New Animation("/animation/pod_boat")
							EndIf
							
							Self.boatdrawer = boatAni.getDrawer(0, True, 0)
							
							If (escapefaceAni = Null) Then
								escapefaceAni = New Animation("/animation/pod_face")
							EndIf
							
							Self.escapefacedrawer = escapefaceAni.getDrawer(4, True, 0)
							Self.partx = Self.posX
							Self.party = Self.posY
							Self.partvx = -1600
							Self.partvy = -320
						EndIf
						
						If ((Self.ShadowPosY + Self.ShadowVY) + 1600 > getGroundY(Self.ShadowPosX, Self.ShadowPosY) And Self.shadow_drip_cnt = 0) Then
							Self.ShadowPosY = getGroundY(Self.ShadowPosX, Self.ShadowPosY) - 1600
							Self.ShadowVY = -1280
							Self.shadow_drip_cnt = 1
						ElseIf ((Self.ShadowPosY + Self.ShadowVY) + 1600 > getGroundY(Self.ShadowPosX, Self.ShadowPosY) And Self.shadow_drip_cnt = 1) Then
							Self.ShadowPosY = getGroundY(Self.ShadowPosX, Self.ShadowPosY) - 1600
							Self.ShadowVY = -640
							Self.shadow_drip_cnt = 2
						ElseIf ((Self.ShadowPosY + Self.ShadowVY) + 1600 <= getGroundY(Self.ShadowPosX, Self.ShadowPosY) Or Self.shadow_drip_cnt <> 2) Then
							Self.ShadowPosX += Self.BossVX * 3
							Self.ShadowVY += GRAVITY
							Self.ShadowPosY += Self.ShadowVY
						Else
							Self.ShadowPosY = getGroundY(Self.ShadowPosX, Self.ShadowPosY) - 1600
						EndIf
						
						If (Self.bossbroken.getEndState()) Then
							Self.state = STATE_ESCAPE
							Self.StartEscape = False
							Self.WaitCnt = 0
							Self.wait_cnt = 0
							Self.fly_top = Self.posY - 3072
							Self.fly_end = Self.side_right
							bossFighting = False
							player.getBossScore()
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
							break
						EndIf
						
						break
					Case 4
						
						If (Self.party + Self.partvy > getGroundY(Self.partx, Self.party)) Then
							Self.party = getGroundY(Self.partx, Self.party)
							Self.StartEscape = True
						Else
							Self.partx += Self.partvx
							Self.partvy += GRAVITY
							Self.party += Self.partvy
						EndIf
						
						If (Self.StartEscape) Then
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
								Self.WaitCnt = 3
							EndIf
							
							If (Self.WaitCnt = 3 Or Self.WaitCnt = 4) Then
								Self.posX += Self.escape_v
							EndIf
							
							If (Self.posX - Self.fly_end > Self.fly_top_range And Self.WaitCnt = 3) Then
								GameObject.addGameObject(New Cage((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH Shr 1)) Shl 6, MapManager.getCamera().y Shl 6))
								MapManager.setCameraUpLimit(SIDE_DOWN_MIDDLE - ((MapManager.CAMERA_HEIGHT * 3) / 4))
								MapManager.setCameraDownLimit(((MapManager.CAMERA_HEIGHT * 1) / 4) + SIDE_DOWN_MIDDLE)
								Self.WaitCnt = 4
								break
							EndIf
						EndIf
						
						break
				EndIf
				For (Int i = 0; i < Self.pipe.Length; i += 1)
					Self.pipe[i].logic(Self.pipepos[i][0], Self.pipepos[i][1])
				EndIf
				refreshCollisionRect(Self.posX Shr 6, Self.posY Shr 6)
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
			
		End
		
		Public Method draw:Void(g:MFGraphics)
			
			If (Self.state >= 2) Then
				drawInMap(g, Self.shadowdrawer, Self.ShadowPosX, Self.ShadowPosY)
			EndIf
			
			If (Self.state >= 1 And Self.show_step > 0 And Not Self.StartEscape) Then
				drawInMap(g, Self.realdrawer)
				drawInMap(g, Self.facedrawer, Self.posX + Self.FACE_OFFSET_X, Self.posY + Self.FACE_OFFSET_Y)
			EndIf
			
			If (Self.StartEscape) Then
				drawInMap(g, Self.boatdrawer, Self.posX, Self.posY + MDPhone.SCREEN_HEIGHT)
				drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - 1024)
			EndIf
			
			If (Self.bossbroken <> Null) Then
				Self.bossbroken.draw(g)
			EndIf
			
			If (Not (Self.partdrawer = Null Or Self.state <> STATE_ESCAPE Or Self.StartEscape)) Then
				drawInMap(g, Self.partdrawer, Self.partx, Self.party)
			EndIf
			
			drawCollisionRect(g)
			Int i
			
			If (Self.state = STATE_ESCAPE Or Self.show_pipe_cnt <> show_pipe_cnt_max Or Self.IsPipeOut) Then
				For (i = 0; i < Self.pipe.Length; i += 1)
					Self.pipe[i].setisDraw(False)
				EndIf
				Return
			EndIf
			
			For (i = 0; i < Self.pipe.Length; i += 1)
				Self.pipe[i].setisDraw(True)
			EndIf
		End
		
		Public Method drawpipes:Void(g:MFGraphics)
			For (Int i = 0; i < Self.pipe.Length; i += 1)
				Self.pipe[i].draw(g)
			EndIf
		End
		
		Public Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - 1600, y - 1600, COLLISION_WIDTH, COLLISION_WIDTH)
		End
		
		Public Method close:Void()
			Self.realdrawer = Null
			Self.shadowdrawer = Null
			Self.facedrawer = Null
			Self.pipedrawer = Null
			Self.partdrawer = Null
			Self.boatdrawer = Null
			Self.escapefacedrawer = Null
			Self.shadow = Null
			Self.bossbroken = Null
		End
		
		Public Method getPaintLayer:Int()
			Return 3
		End
		
		Public Function releaseAllResource:Void()
			Animation.closeAnimation(realAni)
			Animation.closeAnimation(shadowAni)
			Animation.closeAnimation(faceAni)
			Animation.closeAnimation(pipeAni)
			Animation.closeAnimation(partAni)
			Animation.closeAnimation(boatAni)
			Animation.closeAnimation(escapefaceAni)
			realAni = Null
			shadowAni = Null
			faceAni = Null
			pipeAni = Null
			partAni = Null
			boatAni = Null
			escapefaceAni = Null
		End
End