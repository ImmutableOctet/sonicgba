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
			Self.side_left = STATE_INIT
			Self.side_right = STATE_INIT
			Self.pipe_vel = 128
			Self.pipe_vel_v = 512
			Self.pipe_vel_h = 256
			Self.boss_v = 320
			Self.release_cnt = STATE_INIT
			Self.wait_cnt_max = 10
			Self.escape_v = 512
			Self.fly_top_range = 4096
			Self.show_pipe_cnt = STATE_INIT
			Self.IsStartAttack = False
			Self.IsPipeOut = False
			Self.IsInPipeCollision = False
			Self.posX -= Self.iLeft * cnt_max
			Self.posY -= Self.iTop * cnt_max
			Self.StartPosX = 475136
			Self.compartPosX = 481536
			Self.pipepos = (Int[][]) Array.newInstance(Integer.TYPE, New Int[]{cnt_max, STATE_PRO})
			Self.pipepos[STATE_INIT][STATE_INIT] = 494592
			Self.pipepos[STATE_INIT][STATE_ENTER_SHOW] = 136384
			Self.pipepos[STATE_ENTER_SHOW][STATE_INIT] = 494592
			Self.pipepos[STATE_ENTER_SHOW][STATE_ENTER_SHOW] = 141632
			Self.pipepos[STATE_PRO][STATE_INIT] = 468480
			Self.pipepos[STATE_PRO][STATE_ENTER_SHOW] = 136384
			Self.pipepos[STATE_BROKEN][STATE_INIT] = 468480
			Self.pipepos[STATE_BROKEN][STATE_ENTER_SHOW] = 141632
			Self.pipepos[STATE_ESCAPE][STATE_INIT] = 478016
			Self.pipepos[STATE_ESCAPE][STATE_ENTER_SHOW] = 124544
			Self.pipepos[5][STATE_INIT] = 485056
			Self.pipepos[5][STATE_ENTER_SHOW] = 124544
			Self.pipepos[6][STATE_INIT] = 478016
			Self.pipepos[6][STATE_ENTER_SHOW] = 153600
			Self.pipepos[7][STATE_INIT] = 485056
			Self.pipepos[7][STATE_ENTER_SHOW] = 153600
			Self.boss_show_top = 139264
			Self.pipeposend = New Int[STATE_ESCAPE]
			Self.pipeposend[STATE_INIT] = 491264
			Self.pipeposend[STATE_ENTER_SHOW] = 471808
			Self.pipeposend[STATE_PRO] = 131200
			Self.pipeposend[STATE_BROKEN] = 148224
			refreshCollisionRect(Self.posX Shr 6, Self.posY Shr 6)
			
			If (realAni = Null) Then
				realAni = New Animation("/animation/boss3_real")
			EndIf
			
			Self.realdrawer = realAni.getDrawer(STATE_INIT, True, STATE_INIT)
			
			If (shadowAni = Null) Then
				shadowAni = New Animation("/animation/boss3_shadow")
			EndIf
			
			Self.shadowdrawer = shadowAni.getDrawer(STATE_INIT, True, STATE_INIT)
			
			If (pipeAni = Null) Then
				pipeAni = New Animation("/animation/boss3_pipe")
			EndIf
			
			Self.pipedrawer = pipeAni.getDrawer()
			Self.pipedrawer.setPause(True)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss3_face")
			EndIf
			
			Self.facedrawer = faceAni.getDrawer(STATE_INIT, True, STATE_INIT)
			Self.state = STATE_INIT
			Self.pipe = New Boss3Pipe[cnt_max]
			Self.pipe[STATE_INIT] = New Boss3Pipe(24, Self.pipepos[STATE_INIT][STATE_INIT] Shr 6, Self.pipepos[STATE_INIT][STATE_ENTER_SHOW] Shr 6, False, STATE_BROKEN, STATE_INIT)
			Self.pipe[STATE_ENTER_SHOW] = New Boss3Pipe(24, Self.pipepos[STATE_ENTER_SHOW][STATE_INIT] Shr 6, Self.pipepos[STATE_ENTER_SHOW][STATE_ENTER_SHOW] Shr 6, False, STATE_BROKEN, STATE_INIT)
			Self.pipe[STATE_PRO] = New Boss3Pipe(24, Self.pipepos[STATE_PRO][STATE_INIT] Shr 6, Self.pipepos[STATE_PRO][STATE_ENTER_SHOW] Shr 6, False, STATE_PRO, STATE_INIT)
			Self.pipe[STATE_BROKEN] = New Boss3Pipe(24, Self.pipepos[STATE_BROKEN][STATE_INIT] Shr 6, Self.pipepos[STATE_BROKEN][STATE_ENTER_SHOW] Shr 6, False, STATE_PRO, STATE_INIT)
			Self.pipe[STATE_ESCAPE] = New Boss3Pipe(24, Self.pipepos[STATE_ESCAPE][STATE_INIT] Shr 6, Self.pipepos[STATE_ESCAPE][STATE_ENTER_SHOW] Shr 6, False, STATE_INIT, STATE_ENTER_SHOW)
			Self.pipe[5] = New Boss3Pipe(24, Self.pipepos[5][STATE_INIT] Shr 6, Self.pipepos[5][STATE_ENTER_SHOW] Shr 6, False, STATE_INIT, STATE_ENTER_SHOW)
			Self.pipe[6] = New Boss3Pipe(24, Self.pipepos[6][STATE_INIT] Shr 6, Self.pipepos[6][STATE_ENTER_SHOW] Shr 6, True, STATE_ENTER_SHOW, STATE_INIT)
			Self.pipe[7] = New Boss3Pipe(24, Self.pipepos[7][STATE_INIT] Shr 6, Self.pipepos[7][STATE_ENTER_SHOW] Shr 6, True, STATE_ENTER_SHOW, STATE_INIT)
			For (Int i = STATE_INIT; i < Self.pipe.Length; i += STATE_ENTER_SHOW)
				GameObject.addGameObject(Self.pipe[i])
				Self.pipe[i].setisDraw(False)
			EndIf
			Self.platform = New Platform(PLATFORM_ID, PLATFORM_X, PLATFORM_Y, PLATFORM_LEFT, PLATFORM_TOP, STATE_INIT, STATE_INIT)
			GameObject.addGameObject(Self.platform)
			Self.IsStartAttack = False
			Self.IsPipeOut = False
			Self.IsInPipeCollision = False
			setBossHP()
		End
	Public
		' Methods:
		Public Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			
			If (Self.dead Or Self.state <= STATE_ENTER_SHOW Or Self.IsInPipeCollision Or object <> player) Then
				Return
			EndIf
			
			If (player.isAttackingEnemy()) Then
				If (Self.IsStartAttack And Self.HP > 0 And Self.state = STATE_PRO And Self.pro_step = STATE_ENTER_SHOW And Self.face_state <> STATE_PRO) Then
					Self.HP -= STATE_ENTER_SHOW
					player.doBossAttackPose(Self, direction)
					Self.face_state = STATE_PRO
					Self.boat_state = STATE_ENTER_SHOW
					
					If (Self.HP = 0) Then
						Self.state = STATE_BROKEN
						Self.side_left = MapManager.getCamera().x
						Self.side_right = Self.side_left + MapManager.CAMERA_WIDTH
						MapManager.setCameraLeftLimit(Self.side_left)
						MapManager.setCameraRightLimit(Self.side_right)
						Self.bossbroken = New BossBroken(24, Self.posX Shr 6, Self.posY Shr 6, STATE_INIT, STATE_INIT, STATE_INIT, STATE_INIT)
						GameObject.addGameObject(Self.bossbroken, Self.posX Shr 6, Self.posY Shr 6)
						Self.pipe_offset = STATE_INIT
						
						If (Self.compartPosX < Self.posX) Then
							Self.BossVX = GimmickObject.PLATFORM_OFFSET_Y
						Else
							Self.BossVX = 256
						EndIf
						
						Self.BossVY = STATE_INIT
						
						If (Self.compartPosX < Self.ShadowPosX) Then
							Self.ShadowVX = -1024
						Else
							Self.ShadowVX = 1024
						EndIf
						
						Self.ShadowVY = -512
						Self.boss_drip_cnt = STATE_INIT
						Self.shadow_drip_cnt = STATE_INIT
						Self.facedrawer.setActionId(STATE_INIT)
						SoundSystem.getInstance().playSe(35, False)
						Return
					EndIf
					
					SoundSystem.getInstance().playSe(34, False)
				EndIf
				
			ElseIf (Self.state = STATE_PRO And Self.pro_step = STATE_ENTER_SHOW And Self.boat_state <> STATE_ENTER_SHOW And Self.IsStartAttack And player.canBeHurt()) Then
				player.beHurt()
				Self.face_state = STATE_ENTER_SHOW
			EndIf
			
		End
		
		Public Method doWhileBeAttack:Void(object:PlayerObject, direction:Int, animationID:Int)
			
			If (Self.state > STATE_ENTER_SHOW And Not Self.IsInPipeCollision And Self.IsStartAttack And Self.HP > 0 And Self.state = STATE_PRO And Self.pro_step = STATE_ENTER_SHOW And Self.face_state <> STATE_PRO) Then
				Self.HP -= STATE_ENTER_SHOW
				player.doBossAttackPose(Self, direction)
				Self.face_state = STATE_PRO
				Self.boat_state = STATE_ENTER_SHOW
				
				If (Self.HP = 0) Then
					Self.state = STATE_BROKEN
					Self.side_left = MapManager.getCamera().x
					Self.side_right = Self.side_left + MapManager.CAMERA_WIDTH
					MapManager.setCameraLeftLimit(Self.side_left)
					MapManager.setCameraRightLimit(Self.side_right)
					Self.bossbroken = New BossBroken(24, Self.posX Shr 6, Self.posY Shr 6, STATE_INIT, STATE_INIT, STATE_INIT, STATE_INIT)
					GameObject.addGameObject(Self.bossbroken, Self.posX Shr 6, Self.posY Shr 6)
					Self.pipe_offset = STATE_INIT
					
					If (Self.compartPosX < Self.posX) Then
						Self.BossVX = GimmickObject.PLATFORM_OFFSET_Y
					Else
						Self.BossVX = 256
					EndIf
					
					Self.BossVY = STATE_INIT
					
					If (Self.compartPosX < Self.ShadowPosX) Then
						Self.ShadowVX = -1024
					Else
						Self.ShadowVX = 1024
					EndIf
					
					Self.ShadowVY = -512
					Self.boss_drip_cnt = STATE_INIT
					Self.shadow_drip_cnt = STATE_INIT
					Self.facedrawer.setActionId(STATE_INIT)
					SoundSystem.getInstance().playSe(35, False)
					Return
				EndIf
				
				SoundSystem.getInstance().playSe(34, False)
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
					Case STATE_INIT
						
						If (player.getFootPositionX() >= Self.StartPosX) Then
							MapManager.setCameraRightLimit(SIDE_RIGHT)
						EndIf
						
						If (player.getFootPositionX() >= Self.StartPosX And player.getFootPositionY() >= SIDE_CHECK_UP) Then
							Self.state = STATE_ENTER_SHOW
							Self.show_step = STATE_INIT
							Self.pipe_offset = STATE_INIT
							MapManager.setCameraLeftLimit(SIDE_LEFT)
							MapManager.setCameraRightLimit(SIDE_RIGHT)
							MapManager.setCameraUpLimit(SIDE_UP)
							MapManager.setCameraDownLimit(((MapManager.CAMERA_HEIGHT * STATE_ENTER_SHOW) / STATE_ESCAPE) + SIDE_DOWN_MIDDLE)
							
							If (Not Self.IsPlayBossBattleBGM) Then
								bossFighting = True
								bossID = 24
								SoundSystem.getInstance().playBgm(22, True)
								Self.IsPlayBossBattleBGM = True
								break
							EndIf
						EndIf
						
						break
					Case STATE_ENTER_SHOW
						Select (Self.show_step)
							Case STATE_INIT
								
								If (Self.show_pipe_cnt >= show_pipe_cnt_max) Then
									If (Self.pipe_offset >= pipe_offset_max) Then
										Self.show_step = STATE_ENTER_SHOW
										Self.pipepos[STATE_INIT][STATE_INIT] = 490496
										Self.pipepos[STATE_INIT][STATE_ENTER_SHOW] = 136384
										Self.pipepos[STATE_ENTER_SHOW][STATE_INIT] = 490496
										Self.pipepos[STATE_ENTER_SHOW][STATE_ENTER_SHOW] = 141632
										Self.pipepos[STATE_PRO][STATE_INIT] = 472576
										Self.pipepos[STATE_PRO][STATE_ENTER_SHOW] = 136384
										Self.pipepos[STATE_BROKEN][STATE_INIT] = 472576
										Self.pipepos[STATE_BROKEN][STATE_ENTER_SHOW] = 141632
										Self.pipepos[STATE_ESCAPE][STATE_INIT] = 478016
										Self.pipepos[STATE_ESCAPE][STATE_ENTER_SHOW] = 132736
										Self.pipepos[5][STATE_INIT] = 485056
										Self.pipepos[5][STATE_ENTER_SHOW] = 132736
										Self.pipepos[6][STATE_INIT] = 478016
										Self.pipepos[6][STATE_ENTER_SHOW] = 145408
										Self.pipepos[7][STATE_INIT] = 485056
										Self.pipepos[7][STATE_ENTER_SHOW] = 145408
										Self.posX = Self.pipepos[7][STATE_INIT]
										Self.posY = Self.pipepos[7][STATE_ENTER_SHOW]
										break
									EndIf
									
									Self.pipe_offset += STATE_ENTER_SHOW
									iArr = Self.pipepos[STATE_INIT]
									iArr[STATE_INIT] = iArr[STATE_INIT] - Self.pipe_vel_h
									iArr = Self.pipepos[STATE_ENTER_SHOW]
									iArr[STATE_INIT] = iArr[STATE_INIT] - Self.pipe_vel_h
									iArr = Self.pipepos[STATE_PRO]
									iArr[STATE_INIT] = iArr[STATE_INIT] + Self.pipe_vel_h
									iArr = Self.pipepos[STATE_BROKEN]
									iArr[STATE_INIT] = iArr[STATE_INIT] + Self.pipe_vel_h
									iArr = Self.pipepos[STATE_ESCAPE]
									iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] + Self.pipe_vel_v
									iArr = Self.pipepos[5]
									iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] + Self.pipe_vel_v
									iArr = Self.pipepos[6]
									iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] - Self.pipe_vel_v
									iArr = Self.pipepos[7]
									iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] - Self.pipe_vel_v
									break
								EndIf
								
								Self.show_pipe_cnt += STATE_ENTER_SHOW
								break
							Case STATE_ENTER_SHOW
								
								If (Self.posY <= Self.boss_show_top) Then
									Self.posY = Self.boss_show_top
									Self.show_step = STATE_PRO
									break
								EndIf
								
								Self.posY -= Self.boss_v
								break
							Case STATE_PRO
								
								If (Self.boss_wait_cnt >= pipe_offset_max) Then
									If (Self.boss_wait_cnt <> pipe_offset_max) Then
										If (Self.boss_wait_cnt <= pipe_offset_max Or Self.boss_wait_cnt >= 26) Then
											If (Self.boss_wait_cnt <> 26) Then
												If (Self.boss_wait_cnt <= 26 Or Self.boss_wait_cnt >= 42) Then
													If (Self.boss_wait_cnt = 42) Then
														Self.show_step = STATE_BROKEN
														break
													EndIf
												EndIf
												
												Self.boss_wait_cnt += STATE_ENTER_SHOW
												break
											EndIf
											
											Self.boss_wait_cnt += STATE_ENTER_SHOW
											Self.facedrawer.setActionId(STATE_INIT)
											Self.facedrawer.setLoop(True)
											break
										EndIf
										
										Self.boss_wait_cnt += STATE_ENTER_SHOW
										break
									EndIf
									
									Self.boss_wait_cnt += STATE_ENTER_SHOW
									Self.facedrawer.setActionId(STATE_ENTER_SHOW)
									Self.facedrawer.setLoop(True)
									break
								EndIf
								
								Self.boss_wait_cnt += STATE_ENTER_SHOW
								break
								break
							Case STATE_BROKEN
								
								If (Self.posY <= Self.pipepos[5][STATE_ENTER_SHOW]) Then
									Self.posY = Self.pipepos[5][STATE_ENTER_SHOW]
									Self.state = STATE_PRO
									Self.pro_step = STATE_INIT
									Self.shadow = New Boss3Shadow(34, Self.posX, Self.posY, STATE_INIT, STATE_INIT, STATE_INIT, STATE_INIT)
									Self.boss_drip_cnt = STATE_INIT
									break
								EndIf
								
								Self.posY -= Self.boss_v
								break
							Default
								break
						EndIf
					Case STATE_PRO
						
						If (Self.face_state = 0) Then
							Self.face_state = Self.shadow.getShadowHurt()
						EndIf
						
						If (Self.face_state <> 0) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += STATE_ENTER_SHOW
							Else
								Self.face_state = STATE_INIT
								Self.shadow.setShadowHurt(STATE_INIT)
								Self.face_cnt = STATE_INIT
							EndIf
						EndIf
						
						If (Self.boat_state = STATE_ENTER_SHOW) Then
							If (Self.boat_cnt < cnt_max) Then
								Self.boat_cnt += STATE_ENTER_SHOW
							Else
								Self.boat_state = STATE_INIT
								Self.boat_cnt = STATE_INIT
							EndIf
						EndIf
						
						Select (Self.pro_step)
							Case STATE_INIT
								Self.IsStartAttack = False
								
								If (Self.release_cnt >= release_cnt_max) Then
									If (Self.HP >= 6) Then
										Self.BossV_x = 458
										Self.BossV_y = 330
									ElseIf (Self.HP = 5) Then
										Self.BossV_x = 549
										Self.BossV_y = 396
									ElseIf (Self.HP = STATE_ESCAPE) Then
										Self.BossV_x = 549
										Self.BossV_y = TitleState.RETURN_PRESSED
									ElseIf (Self.HP = STATE_BROKEN Or Self.HP = STATE_PRO) Then
										Self.BossV_x = MDPhone.SCREEN_HEIGHT
										Self.BossV_y = 462
									ElseIf (Self.HP = STATE_ENTER_SHOW) Then
										Self.BossV_x = 733
										Self.BossV_y = 528
									EndIf
									
									Int rand1 = MyRandom.nextInt(STATE_INIT, 7)
									Int rand2 = MyRandom.nextInt(STATE_INIT, 7)
									Select (rand1)
										Case STATE_INIT
										Case STATE_PRO
											
											If (rand2 = 0 Or rand2 = STATE_PRO) Then
												rand2 = MyRandom.nextInt(STATE_BROKEN, 7)
												break
											EndIf
											
										Case STATE_ENTER_SHOW
										Case STATE_BROKEN
											
											If (rand2 = STATE_ENTER_SHOW Or rand2 = STATE_BROKEN) Then
												rand2 = MyRandom.nextInt(STATE_ESCAPE, 7)
												break
											EndIf
											
										Case STATE_ESCAPE
										Case SSdef.SSOBJ_BNLD_ID
											
											If (rand2 = STATE_ESCAPE Or rand2 = 6) Then
												rand2 = MyRandom.nextInt(STATE_INIT, STATE_BROKEN)
												break
											EndIf
											
										Case SSdef.SSOBJ_BNRU_ID
										Case SSdef.SSOBJ_BNRD_ID
											
											If (rand2 = 5 Or rand2 = 7) Then
												rand2 = MyRandom.nextInt(STATE_INIT, STATE_ESCAPE)
												break
											EndIf
									EndIf
									Self.posX = Self.pipepos[rand1][STATE_INIT]
									Self.posY = Self.pipepos[rand1][STATE_ENTER_SHOW]
									Self.ShadowPosX = Self.pipepos[rand2][STATE_INIT]
									Self.ShadowPosY = Self.pipepos[rand2][STATE_ENTER_SHOW]
									Select (rand1)
										Case STATE_INIT
										Case STATE_ENTER_SHOW
											Self.BossVX = -Abs(Self.BossV_x)
											Self.BossVY = STATE_INIT
											Self.realdrawer.setTrans(STATE_INIT)
											Self.facedrawer.setTrans(STATE_INIT)
											Self.FACE_OFFSET_X = 576
											break
										Case STATE_PRO
										Case STATE_BROKEN
											Self.BossVX = Abs(Self.BossV_x)
											Self.BossVY = STATE_INIT
											Self.realdrawer.setTrans(STATE_PRO)
											Self.facedrawer.setTrans(STATE_PRO)
											Self.FACE_OFFSET_X = -448
											break
										Case STATE_ESCAPE
										Case SSdef.SSOBJ_BNRU_ID
											Self.BossVX = STATE_INIT
											Self.BossVY = Abs(Self.BossV_y)
											
											If (rand1 <> STATE_ESCAPE) Then
												Self.realdrawer.setTrans(STATE_INIT)
												Self.facedrawer.setTrans(STATE_INIT)
												Self.FACE_OFFSET_X = 576
												break
											EndIf
											
											Self.realdrawer.setTrans(STATE_PRO)
											Self.facedrawer.setTrans(STATE_PRO)
											Self.FACE_OFFSET_X = -448
											break
										Case SSdef.SSOBJ_BNLD_ID
										Case SSdef.SSOBJ_BNRD_ID
											Self.BossVX = STATE_INIT
											Self.BossVY = -Abs(Self.BossV_y)
											
											If (rand1 <> 6) Then
												Self.realdrawer.setTrans(STATE_INIT)
												Self.facedrawer.setTrans(STATE_INIT)
												Self.FACE_OFFSET_X = 576
												break
											EndIf
											
											Self.realdrawer.setTrans(STATE_PRO)
											Self.facedrawer.setTrans(STATE_PRO)
											Self.FACE_OFFSET_X = -448
											break
									EndIf
									Select (rand2)
										Case STATE_INIT
										Case STATE_ENTER_SHOW
											Self.ShadowVX = -Abs(Self.BossV_x)
											Self.ShadowVY = STATE_INIT
											Self.shadowdrawer.setTrans(STATE_INIT)
											break
										Case STATE_PRO
										Case STATE_BROKEN
											Self.ShadowVX = Abs(Self.BossV_x)
											Self.ShadowVY = STATE_INIT
											Self.shadowdrawer.setTrans(STATE_PRO)
											break
										Case STATE_ESCAPE
										Case SSdef.SSOBJ_BNRU_ID
											Self.ShadowVX = STATE_INIT
											Self.ShadowVY = Abs(Self.BossV_y)
											
											If (rand2 <> STATE_ESCAPE) Then
												Self.shadowdrawer.setTrans(STATE_INIT)
												break
											Else
												Self.shadowdrawer.setTrans(STATE_PRO)
												break
											EndIf
											
										Case SSdef.SSOBJ_BNLD_ID
										Case SSdef.SSOBJ_BNRD_ID
											Self.ShadowVX = STATE_INIT
											Self.ShadowVY = -Abs(Self.BossV_y)
											
											If (rand2 <> 6) Then
												Self.shadowdrawer.setTrans(STATE_INIT)
												break
											Else
												Self.shadowdrawer.setTrans(STATE_PRO)
												break
											EndIf
									EndIf
									Self.pro_step = STATE_ENTER_SHOW
									Self.release_cnt = STATE_INIT
									break
								EndIf
								
								Self.release_cnt += STATE_ENTER_SHOW
								break
								break
							Case STATE_ENTER_SHOW
								Self.IsStartAttack = True
								
								If (Self.posX + Self.BossVX < Self.pipeposend[STATE_ENTER_SHOW] + 1280 Or Self.posX + Self.BossVX > Self.pipeposend[STATE_INIT] - 1280) Then
									Self.IsInPipeCollision = True
								Else
									Self.IsInPipeCollision = False
								EndIf
								
								If (Self.ShadowPosX + Self.ShadowVX < Self.pipeposend[STATE_ENTER_SHOW] + 1280 Or Self.ShadowPosX + Self.ShadowVX > Self.pipeposend[STATE_INIT] - 1280) Then
									Self.shadow.IsInPipeCollision = True
								Else
									Self.shadow.IsInPipeCollision = False
								EndIf
								
								If (Self.posX + Self.BossVX >= Self.pipeposend[STATE_ENTER_SHOW] And Self.posX + Self.BossVX <= Self.pipeposend[STATE_INIT] And Self.ShadowPosX + Self.ShadowVX >= Self.pipeposend[STATE_ENTER_SHOW] And Self.ShadowPosX + Self.ShadowVX <= Self.pipeposend[STATE_INIT] And Self.posY + Self.BossVY >= Self.pipeposend[STATE_PRO] And Self.posY + Self.BossVY <= Self.pipeposend[STATE_BROKEN] And Self.ShadowPosY + Self.ShadowVY >= Self.pipeposend[STATE_PRO] And Self.ShadowPosY + Self.ShadowVY <= Self.pipeposend[STATE_BROKEN]) Then
									Self.posX += Self.BossVX
									Self.posY += Self.BossVY
									Self.ShadowPosX += Self.ShadowVX
									Self.ShadowPosY += Self.ShadowVY
									break
								EndIf
								
								Self.pro_step = STATE_INIT
								break
						EndIf
						Self.shadow.logic(Self.ShadowPosX, Self.ShadowPosY)
						Self.facedrawer.setActionId(Self.face_state)
						Self.realdrawer.setActionId(Self.boat_state)
						break
					Case STATE_BROKEN
						Self.platform.setDisplay(False)
						Self.shadow.IsOver = True
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
						
						If (Self.pipe_offset < pipe_offset_max) Then
							Self.pipe_offset += STATE_ENTER_SHOW
							iArr = Self.pipepos[STATE_INIT]
							iArr[STATE_INIT] = iArr[STATE_INIT] + Self.pipe_vel_h
							iArr = Self.pipepos[STATE_ENTER_SHOW]
							iArr[STATE_INIT] = iArr[STATE_INIT] + Self.pipe_vel_h
							iArr = Self.pipepos[STATE_PRO]
							iArr[STATE_INIT] = iArr[STATE_INIT] - Self.pipe_vel_h
							iArr = Self.pipepos[STATE_BROKEN]
							iArr[STATE_INIT] = iArr[STATE_INIT] - Self.pipe_vel_h
							iArr = Self.pipepos[STATE_ESCAPE]
							iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] - Self.pipe_vel_v
							iArr = Self.pipepos[5]
							iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] - Self.pipe_vel_v
							iArr = Self.pipepos[6]
							iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] + Self.pipe_vel_v
							iArr = Self.pipepos[7]
							iArr[STATE_ENTER_SHOW] = iArr[STATE_ENTER_SHOW] + Self.pipe_vel_v
						Else
							Self.IsPipeOut = True
						EndIf
						
						If ((Self.posY + Self.BossVY) + 1600 > getGroundY(Self.posX, Self.posY) And Self.boss_drip_cnt = 0) Then
							Self.posY = getGroundY(Self.posX, Self.posY) - 1600
							Self.BossVY = -1280
							Self.boss_drip_cnt = STATE_ENTER_SHOW
						ElseIf ((Self.posY + Self.BossVY) + 1600 > getGroundY(Self.posX, Self.posY) And Self.boss_drip_cnt = STATE_ENTER_SHOW) Then
							Self.posY = getGroundY(Self.posX, Self.posY) - 1600
							Self.BossVY = -640
							Self.boss_drip_cnt = STATE_PRO
						ElseIf ((Self.posY + Self.BossVY) + 1600 <= getGroundY(Self.posX, Self.posY) Or Self.boss_drip_cnt <> STATE_PRO) Then
							Self.posX += Self.BossVX
							Self.BossVY += GRAVITY
							Self.posY += Self.BossVY
						Else
							Self.posY = getGroundY(Self.posX, Self.posY) - 1600
							
							If (partAni = Null) Then
								partAni = New Animation("/animation/boss3_part")
							EndIf
							
							Self.partdrawer = partAni.getDrawer(STATE_INIT, True, STATE_INIT)
							
							If (boatAni = Null) Then
								boatAni = New Animation("/animation/pod_boat")
							EndIf
							
							Self.boatdrawer = boatAni.getDrawer(STATE_INIT, True, STATE_INIT)
							
							If (escapefaceAni = Null) Then
								escapefaceAni = New Animation("/animation/pod_face")
							EndIf
							
							Self.escapefacedrawer = escapefaceAni.getDrawer(STATE_ESCAPE, True, STATE_INIT)
							Self.partx = Self.posX
							Self.party = Self.posY
							Self.partvx = -1600
							Self.partvy = -320
						EndIf
						
						If ((Self.ShadowPosY + Self.ShadowVY) + 1600 > getGroundY(Self.ShadowPosX, Self.ShadowPosY) And Self.shadow_drip_cnt = 0) Then
							Self.ShadowPosY = getGroundY(Self.ShadowPosX, Self.ShadowPosY) - 1600
							Self.ShadowVY = -1280
							Self.shadow_drip_cnt = STATE_ENTER_SHOW
						ElseIf ((Self.ShadowPosY + Self.ShadowVY) + 1600 > getGroundY(Self.ShadowPosX, Self.ShadowPosY) And Self.shadow_drip_cnt = STATE_ENTER_SHOW) Then
							Self.ShadowPosY = getGroundY(Self.ShadowPosX, Self.ShadowPosY) - 1600
							Self.ShadowVY = -640
							Self.shadow_drip_cnt = STATE_PRO
						ElseIf ((Self.ShadowPosY + Self.ShadowVY) + 1600 <= getGroundY(Self.ShadowPosX, Self.ShadowPosY) Or Self.shadow_drip_cnt <> STATE_PRO) Then
							Self.ShadowPosX += Self.BossVX * STATE_BROKEN
							Self.ShadowVY += GRAVITY
							Self.ShadowPosY += Self.ShadowVY
						Else
							Self.ShadowPosY = getGroundY(Self.ShadowPosX, Self.ShadowPosY) - 1600
						EndIf
						
						If (Self.bossbroken.getEndState()) Then
							Self.state = STATE_ESCAPE
							Self.StartEscape = False
							Self.WaitCnt = STATE_INIT
							Self.wait_cnt = STATE_INIT
							Self.fly_top = Self.posY - 3072
							Self.fly_end = Self.side_right
							bossFighting = False
							player.getBossScore()
							SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
							break
						EndIf
						
						break
					Case STATE_ESCAPE
						
						If (Self.party + Self.partvy > getGroundY(Self.partx, Self.party)) Then
							Self.party = getGroundY(Self.partx, Self.party)
							Self.StartEscape = True
						Else
							Self.partx += Self.partvx
							Self.partvy += GRAVITY
							Self.party += Self.partvy
						EndIf
						
						If (Self.StartEscape) Then
							Self.wait_cnt += STATE_ENTER_SHOW
							
							If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= Self.fly_top - Self.fly_top_range) Then
								Self.posY -= Self.escape_v
							EndIf
							
							If (Self.posY <= Self.fly_top - Self.fly_top_range And Self.WaitCnt = 0) Then
								Self.posY = Self.fly_top - Self.fly_top_range
								Self.escapefacedrawer.setActionId(STATE_INIT)
								Self.boatdrawer.setActionId(STATE_ENTER_SHOW)
								Self.boatdrawer.setLoop(False)
								Self.WaitCnt = STATE_ENTER_SHOW
							EndIf
							
							If (Self.WaitCnt = STATE_ENTER_SHOW And Self.boatdrawer.checkEnd()) Then
								Self.escapefacedrawer.setActionId(STATE_INIT)
								Self.escapefacedrawer.setTrans(STATE_PRO)
								Self.escapefacedrawer.setLoop(True)
								Self.boatdrawer.setActionId(STATE_ENTER_SHOW)
								Self.boatdrawer.setTrans(STATE_PRO)
								Self.boatdrawer.setLoop(False)
								Self.WaitCnt = STATE_PRO
							EndIf
							
							If (Self.WaitCnt = STATE_PRO And Self.boatdrawer.checkEnd()) Then
								Self.boatdrawer.setActionId(STATE_INIT)
								Self.boatdrawer.setTrans(STATE_PRO)
								Self.boatdrawer.setLoop(True)
								Self.WaitCnt = STATE_BROKEN
							EndIf
							
							If (Self.WaitCnt = STATE_BROKEN Or Self.WaitCnt = STATE_ESCAPE) Then
								Self.posX += Self.escape_v
							EndIf
							
							If (Self.posX - Self.fly_end > Self.fly_top_range And Self.WaitCnt = STATE_BROKEN) Then
								GameObject.addGameObject(New Cage((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH Shr STATE_ENTER_SHOW)) Shl 6, MapManager.getCamera().y Shl 6))
								MapManager.setCameraUpLimit(SIDE_DOWN_MIDDLE - ((MapManager.CAMERA_HEIGHT * STATE_BROKEN) / STATE_ESCAPE))
								MapManager.setCameraDownLimit(((MapManager.CAMERA_HEIGHT * STATE_ENTER_SHOW) / STATE_ESCAPE) + SIDE_DOWN_MIDDLE)
								Self.WaitCnt = STATE_ESCAPE
								break
							EndIf
						EndIf
						
						break
				EndIf
				For (Int i = STATE_INIT; i < Self.pipe.Length; i += STATE_ENTER_SHOW)
					Self.pipe[i].logic(Self.pipepos[i][STATE_INIT], Self.pipepos[i][STATE_ENTER_SHOW])
				EndIf
				refreshCollisionRect(Self.posX Shr 6, Self.posY Shr 6)
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
			
		End
		
		Public Method draw:Void(g:MFGraphics)
			
			If (Self.state >= STATE_PRO) Then
				drawInMap(g, Self.shadowdrawer, Self.ShadowPosX, Self.ShadowPosY)
			EndIf
			
			If (Self.state >= STATE_ENTER_SHOW And Self.show_step > 0 And Not Self.StartEscape) Then
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
				For (i = STATE_INIT; i < Self.pipe.Length; i += STATE_ENTER_SHOW)
					Self.pipe[i].setisDraw(False)
				EndIf
				Return
			EndIf
			
			For (i = STATE_INIT; i < Self.pipe.Length; i += STATE_ENTER_SHOW)
				Self.pipe[i].setisDraw(True)
			EndIf
		End
		
		Public Method drawpipes:Void(g:MFGraphics)
			For (Int i = STATE_INIT; i < Self.pipe.Length; i += STATE_ENTER_SHOW)
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
			Return STATE_BROKEN
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