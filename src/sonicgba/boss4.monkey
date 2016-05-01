Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject

Friend sonicgba.boss4ice

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.boss4ice
	Import sonicgba.bossbroken
	Import sonicgba.bossobject
	
	Import sonicgba.cage
	
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	
	Import sonicgba.playerobject
	Import sonicgba.playertails
	Import sonicgba.playerknuckles
	
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Boss4 Extends BossObject
	Private
		' Constant variable(s):
		Const ATTACK_INIT:Int = 0
		Const ATTACK_MOVE:Int = 1
		Const ATTACK_WAIT:Int = 2
		Const ATTACK_FIRE:Int = 3
		
		Const FACE_NORMAL:Int = 0
		Const FACE_SMILE:Int = 1
		Const FACE_HURT:Int = 2
		
		Const SHOW_BOSS_ENTER:Int = 0
		Const SHOW_BOSS_LAUGH:Int = 1
		Const SHOW_BOSS_END:Int = 2
		
		Const MACHINE_MOVE:Int = 0
		Const MACHINE_MOVE_HURT:Int = 1
		Const MACHINE_ATTACK:Int = 2
		Const MACHINE_ATTACK_HURT:Int = 3
		Const MACHINE_WAIT:Int = 4
		Const MACHINE_WAIT_HURT:Int = 5
		
		' States:
		Const STATE_INIT:Int = 0
		Const STATE_ENTER_SHOW:Int = 1
		Const STATE_PRO:Int = 2
		Const STATE_BROKEN:Int = 3
		Const STATE_ESCAPE:Int = 4
		
		Const MACHINE_BASE_HALF_HEIGHT:Int = 1280
		Const BOSS_SHOW_END_POSX:Int = 556544
		
		Const FLY_TOP_OFFSETY:Int = 9600
		Const ICE_INTERVAL:Int = 1280
		
		Const MOVE_SPEED:Int = 256
		Const MOVE_INTERVAL:Int = 2048
		
		Const SIDE_UP:Int = 1616
		
		Const SIDE_DOWN1:Int = 1758
		Const SIDE_DOWN2:Int = 1808
		
		Const SIDE_LEFT:Int = 8496
		Const SIDE_MIDDLE:Int = 553984
		Const SIDE_RIGHT:Int = 8816
		
		Const StartPosX:Int = 548992
		
		Const ATTACK_TIME_MAX:Int = 32
		Const BOSS_LAUGH_MAX:Int = 16
		Const TOUCH_BOTTOM_CNT_MAX:Int = 20
		Const WAIT_TIME_MAX:Int = 8
		
		Const cnt_max:Int = 30
		
		Const WATER_LEVEL_DROP_SPEED:Int = 2
		
		Const limitLeftIceX:Int = 544384
		
		Const limitLeftX:Int = 545792
		Const limitRightX:Int = 562176
		
		' Global variable(s):
		Global boatAni:Animation = Null
		Global escapefaceAni:Animation = Null
		Global faceAni:Animation = Null
		Global machineAni:Animation = Null
		Global machinePartsAni:Animation = Null
		
		Global machineBase:MFImage
		
		' Fields:
		Field COLLISION_HEIGHT:Int
		Field COLLISION_WIDTH:Int
		
		Field bossbroken:BossBroken
		
		Field boatdrawer:AnimationDrawer
		Field escapefacedrawer:AnimationDrawer
		Field faceDrawer:AnimationDrawer
		Field machineDrawer:AnimationDrawer
		Field machinePartsdrawer:AnimationDrawer
		
		Field parts_pos:Int[][]
		Field parts_v:Int[][]
		
		Field WaitCnt:Int
		
		Field attack_cn:Int
		Field attack_distance:Int
		Field attack_step:Int
		
		Field pro_machine_state:Int
		Field pro_machine_state2:Int
		
		Field state:Int
		Field show_step:Int
		Field face_state:Int
		Field machine_state:Int
		
		Field wait_cn:Int
		Field wait_cnt:Int
		Field wait_cnt_max:Int
		
		Field face_cnt:Int
		Field laugh_cn:Int
		Field machine_cnt:Int
		
		Field touch_bottom_cnt:Int
		
		Field escape_v:Int
		
		Field fly_top:Int
		Field fly_top_range:Int
		Field fly_end:Int
		
		Field move_velX:Int
		Field move_distance:Int
		
		Field posStartX:Int
		
		Field water_level:Int
		
		Field direct:Bool
	Public
		' Fields:
		Field isNoneIce:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.COLLISION_WIDTH = 704
			Self.COLLISION_HEIGHT = 3648
			
			Self.direct = False
			Self.isNoneIce = False
			
			Self.wait_cnt_max = 10
			
			Self.escape_v = 512
			
			Self.fly_top_range = 3840
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			' Magic number: 1024
			Self.posY += 1024
			
			If (machineAni = Null) Then
				machineAni = New Animation("/animation/boss4_machine")
			EndIf
			
			Self.machineDrawer = machineAni.getDrawer(0, True, 0)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/boss4_face")
			EndIf
			
			Self.faceDrawer = faceAni.getDrawer(0, True, 0)
			
			machineBase = MFImage.createImage("/animation/boss4_base.png")
			
			If (machinePartsAni = Null) Then
				machinePartsAni = New Animation("/animation/boss4_parts")
			EndIf
			
			Self.machinePartsdrawer = machinePartsAni.getDrawer(0, True, 0)
			
			Self.parts_pos = New Int[3][]
			
			For Local i:= 0 Until Self.parts_pos.Length
				Self.parts_pos[i] = New Int[2]
			Next
			
			Self.parts_v = New Int[3][]
			
			For Local i:= 0 Until Self.parts_v.Length
				Self.parts_v[i] = New Int[2]
			Next
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(0, True, 0)
			
			If (escapefaceAni = Null) Then
				escapefaceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.escapefacedrawer = escapefaceAni.getDrawer(4, True, 0)
			
			Self.state = STATE_INIT
			
			Self.wait_cn = 0
			Self.attack_cn = 0
			
			Self.isNoneIce = False
			
			setBossHP()
		End
		
		' Methods:
		
		' Extensions:
		Method onPlayerAttack:Void(p:PlayerObject, direction:Int) ' animationID:Int
			Self.HP -= 1
			
			p.doBossAttackPose(Self, direction)
			
			setAniState(Self.faceDrawer, FACE_HURT)
			
			Self.pro_machine_state = Self.machine_state
			Self.machine_state = (Self.pro_machine_state + 1)
			
			setAniState(Self.machineDrawer, Self.machine_state)
			
			If (Self.HP = 0) Then
				Self.state = STATE_BROKEN
				
				Self.isNoneIce = True
				
				Self.fly_top = (Self.posY + FLY_TOP_OFFSETY)
				
				' Magic number: 564224
				Self.fly_end = 564224
				
				For Local i:= 0 Until 3 ' Self.parts_pos.Length
					Self.parts_pos[i][0] = Self.posX
					Self.parts_pos[i][1] = Self.posY
					
					' Magic numbers: -640, 640, -320, -512
					Self.parts_v[i][0] = PickValue(MyRandom.nextInt(0, 10) > 5, -640, 640)
					Self.parts_v[i][1] = PickValue(MyRandom.nextInt(0, 10) > 5, -320, -512)
				Next
				
				setAniState(Self.faceDrawer, FACE_SMILE)
				
				Local x:= (Self.posX Shr 6)
				Local y:= (Self.posY Shr 6)
				
				Self.bossbroken = New BossBroken(ENEMY_BOSS4, x, y, 0, 0, 0, 0)
				
				GameObject.addGameObject(Self.bossbroken, x, y)
			EndIf
			
			playHitSound()
		End
	Private
		' Methods:
		Method facePosY:Int()
			Select (Self.machineDrawer.getCurrentFrame())
				Case MACHINE_MOVE, MACHINE_ATTACK
					Return 2752
				Case MACHINE_MOVE_HURT, MACHINE_ATTACK_HURT, MACHINE_WAIT
					Return 2688
				Case MACHINE_WAIT_HURT
					Return 2816
				Default
					Return 2688
			End Select
		End
		
		Method setAniState:Void(aniDrawer:AnimationDrawer, state:Int)
			If (aniDrawer = Self.faceDrawer) Then
				Self.face_state = state
			EndIf
			
			aniDrawer.setActionId(state)
			aniDrawer.setLoop(True)
		End
		
		Method setAniState:Void(machine_state:Int, face_state:Int)
			Self.machineDrawer.setActionId(machine_state)
			Self.machineDrawer.setLoop(True)
			
			Self.faceDrawer.setActionId(face_state)
			Self.faceDrawer.setLoop(True)
			
			Self.face_state = face_state
		End
		
		Method setMoveConf:Void()
			If (Self.posX > SIDE_MIDDLE) Then
				If (Self.direct) Then
					Self.move_velX = -MOVE_SPEED
				Else
					Self.move_velX = MOVE_SPEED
				EndIf
			ElseIf (Self.direct) Then
				Self.move_velX = MOVE_SPEED
			Else
				Self.move_velX = -MOVE_SPEED
			EndIf
			
			Local point:= MyRandom.nextInt(0, 100)
			
			If (point < 5) Then
				Self.move_distance = 1
			ElseIf (point < 20) Then ' TOUCH_BOTTOM_CNT_MAX
				Self.move_distance = 2
			ElseIf (point < 35) Then
				Self.move_distance = 3
			ElseIf (point < 55) Then
				Self.move_distance = 4
			ElseIf (point < 75) Then
				Self.move_distance = 4
			ElseIf (point < 90) Then
				Self.move_distance = 6
			Else
				Self.move_distance = 7
			EndIf
			
			setAniState(Self.machineDrawer, MACHINE_MOVE) ' 0
			
			If (Self.move_velX > 0) Then
				Self.machineDrawer.setTrans(TRANS_MIRROR)
			Else
				Self.machineDrawer.setTrans(TRANS_NONE)
			EndIf
			
			Self.posStartX = Self.posX
			
			Self.attack_step = ATTACK_MOVE
			
			Self.wait_cn = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(machineAni)
			Animation.closeAnimation(faceAni)
			
			machineAni = Null
			faceAni = Null
		End
		
		' Methods:
		Method close:Void()
			Self.machineDrawer = Null
			Self.faceDrawer = Null
			
			Self.bossbroken = Null
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.dead Or Self.state <> STATE_PRO Or p <> player) Then
				Return
			EndIf
			
			If ((p.getCharacterID() <> CHARACTER_TAILS) Or (p.getCharacterAnimationID() <> PlayerTails.TAILS_ANI_FLY_1 And p.getCharacterAnimationID() <> PlayerTails.TAILS_ANI_FLY_2)) Then
				If (p.isAttackingEnemy()) Then
					If (Self.HP > 0 And Self.face_state <> FACE_HURT) Then
						onPlayerAttack(p, direction)
					EndIf
				ElseIf (Self.machine_state <> MACHINE_MOVE_HURT And Self.machine_state <> MACHINE_ATTACK_HURT And Self.machine_state <> MACHINE_WAIT_HURT And p.canBeHurt()) Then
					p.beHurt()
					
					setAniState(Self.faceDrawer, FACE_SMILE)
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (Self.state = STATE_PRO And Self.HP > 0) Then
				If (((player.getCharacterID() <> CHARACTER_TAILS) Or (Not (player.getCharacterAnimationID() = PlayerTails.TAILS_ANI_FLY_1 Or player.getCharacterAnimationID() = PlayerTails.TAILS_ANI_FLY_2) Or player.getVelY() <= 0)) And Self.face_state <> FACE_HURT) Then
					onPlayerAttack(p, direction)
				EndIf
			EndIf
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				If (Self.state > STATE_INIT) Then
					isBossEnter = True
				EndIf
				
				Select (Self.state)
					Case STATE_INIT
						If (player.getFootPositionX() >= StartPosX) Then
							Self.state = STATE_ENTER_SHOW
							
							MapManager.setCameraLeftLimit(SIDE_LEFT)
							MapManager.setCameraRightLimit(SIDE_RIGHT)
							MapManager.setCameraUpLimit(SIDE_UP)
							MapManager.setCameraDownLimit(SIDE_DOWN1)
							
							If (Not Self.IsPlayBossBattleBGM) Then
								bossFighting = True
								
								bossID = ENEMY_BOSS4
								
								SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_01, True) ' SoundSystem.BGM_BOSS_04
								
								Self.IsPlayBossBattleBGM = True
							EndIf
							
							Self.show_step = SHOW_BOSS_ENTER
							
							setAniState(MACHINE_MOVE, FACE_NORMAL)
							
							player.setMeetingBoss(False)
							
							Self.water_level = StageManager.getWaterLevel()
							
							If (player.getCharacterID() = CHARACTER_KNUCKLES) Then
								player.dripDownUnderWater()
							EndIf
							
							player.isAttackBoss4 = True
						EndIf
					Case STATE_ENTER_SHOW
						If (player.getCharacterID() = CHARACTER_KNUCKLES) Then
							player.dripDownUnderWater()
						EndIf
						
						Select (Self.show_step)
							Case SHOW_BOSS_ENTER
								If (Self.posX <= BOSS_SHOW_END_POSX) Then
									Self.show_step = SHOW_BOSS_LAUGH
									
									setAniState(MACHINE_WAIT, FACE_SMILE)
									
									Self.laugh_cn = 0
								Else
									Self.posX -= MOVE_SPEED
								EndIf
							Case SHOW_BOSS_LAUGH
								If (Self.laugh_cn >= BOSS_LAUGH_MAX) Then
									Self.show_step = SHOW_BOSS_END
									
									setAniState(Self.faceDrawer, FACE_NORMAL)
								Else
									Self.laugh_cn += 1
								EndIf
							Case SHOW_BOSS_END
								Self.state = STATE_PRO
								Self.attack_step = ATTACK_INIT
								
								Self.wait_cn = 0
								
								MapManager.setCameraDownLimit(SIDE_DOWN2)
						End Select
					Case STATE_PRO
						If (MapManager.actualDownCameraLimit = MapManager.proposeDownCameraLimit) Then
							player.setMeetingBoss(True)
						EndIf
						
						If (Self.face_state <> FACE_NORMAL) Then
							If (Self.face_cnt < cnt_max) Then
								Self.face_cnt += 1
							Else
								setAniState(Self.faceDrawer, FACE_NORMAL)
								
								Self.face_cnt = 0
							EndIf
						EndIf
						
						If (Not (Self.machine_state = MACHINE_MOVE Or Self.machine_state = MACHINE_ATTACK Or Self.machine_state = MACHINE_WAIT)) Then
							Self.pro_machine_state2 = Self.machine_state
							
							If (Self.machine_cnt < cnt_max) Then
								Self.machine_cnt += 1
							Else
								Self.machine_state = (Self.pro_machine_state2 - 1)
								
								setAniState(Self.machineDrawer, Self.machine_state)
								
								Self.machine_cnt = 0
							EndIf
						EndIf
						
						Select (Self.attack_step)
							Case ATTACK_INIT
								If (Self.wait_cn >= WAIT_TIME_MAX) Then
									Self.direct = (MyRandom.nextInt(0, 100) <= 95)
									
									setMoveConf()
								Else
									Self.wait_cn += 1
								EndIf
							Case ATTACK_MOVE
								If ((Self.posStartX <= SIDE_MIDDLE Or Not Self.direct Or Self.posX < Self.posStartX - (Self.move_distance * MOVE_INTERVAL)) And ((Self.posStartX <= SIDE_MIDDLE Or Self.direct Or Self.posX > Self.posStartX + (Self.move_distance * MOVE_INTERVAL)) And ((Self.posStartX > SIDE_MIDDLE Or Not Self.direct Or Self.posX > Self.posStartX + (Self.move_distance * MOVE_INTERVAL)) And (Self.posStartX > SIDE_MIDDLE Or Self.direct Or Self.posX < Self.posStartX - (Self.move_distance * MOVE_INTERVAL))))) Then
									If (Self.posStartX > SIDE_MIDDLE) Then
										If (Self.direct) Then
											Self.posX = Self.posStartX - (Self.move_distance * MOVE_INTERVAL)
										Else
											Self.posX = Self.posStartX + (Self.move_distance * MOVE_INTERVAL)
										EndIf
									ElseIf (Self.direct) Then
										Self.posX = Self.posStartX + (Self.move_distance * MOVE_INTERVAL)
									Else
										Self.posX = Self.posStartX - (Self.move_distance * MOVE_INTERVAL)
									EndIf
									
									Self.attack_step = ATTACK_WAIT
									
									setAniState(Self.machineDrawer, MACHINE_WAIT)
								' Magic number: 560128
								ElseIf (Self.posX > 560128) Then
									Self.posX = 560128
									
									Self.attack_step = ATTACK_WAIT
									
									setAniState(Self.machineDrawer, MACHINE_WAIT)
								ElseIf (Self.posX < limitLeftX) Then
									Self.posX = limitLeftX
									
									Self.attack_step = ATTACK_WAIT
									
									setAniState(Self.machineDrawer, MACHINE_WAIT)
								Else
									Self.posX += Self.move_velX
								EndIf
								
								Self.wait_cn = 0
							Case ATTACK_WAIT
								If (Self.move_distance = 1) Then
									If (Self.wait_cn >= BOSS_LAUGH_MAX) Then
										Self.direct = (MyRandom.nextInt(0, 100) >= 50)
										
										setMoveConf()
									Else
										Self.wait_cn += 1
									EndIf
								ElseIf (Self.wait_cn >= WAIT_TIME_MAX) Then
									Self.attack_step = ATTACK_FIRE
									
									setAniState(Self.machineDrawer, MACHINE_ATTACK)
									
									Self.attack_cn = 0
									Self.wait_cn = 0
									
									MapManager.setShake(16) ' BOSS_LAUGH_MAX
								Else
									Self.wait_cn += 1
								EndIf
							Case ATTACK_FIRE
								If (Self.attack_cn >= ATTACK_TIME_MAX) Then
									Self.attack_step = ATTACK_INIT
									
									setAniState(Self.machineDrawer, MACHINE_WAIT)
									
									Self.attack_cn = 0
									Self.wait_cn = 0
								Else
									Self.attack_cn += 1
									
									If (Self.HP <= 4) Then
										If (Self.HP <= 2) Then
											Select (Self.attack_cn)
												Case 6, 13, 22, 29
													GameObject.addGameObject(New Boss4Ice(limitLeftIceX + (MyRandom.nextInt(16) * MACHINE_BASE_HALF_HEIGHT), 103424, MyRandom.nextInt(92, 148), 116352, Self)) ' BOSS_LAUGH_MAX
													
													SoundSystem.getInstance().playSe(SoundSystem.SE_145)
												Default
													' Nothing so far.
											End Select
										EndIf
										
										Select (Self.attack_cn)
											Case 6, 16, 25 ' BOSS_LAUGH_MAX
												GameObject.addGameObject(New Boss4Ice(limitLeftIceX + (MyRandom.nextInt(16) * MACHINE_BASE_HALF_HEIGHT), 103424, MyRandom.nextInt(92, 148), 116352, Self)) ' BOSS_LAUGH_MAX
												
												SoundSystem.getInstance().playSe(SoundSystem.SE_145)
											Default
												' Nothing so far.
										End Select
									EndIf
									
									Select (Self.attack_cn)
										Case 6, 22
											GameObject.addGameObject(New Boss4Ice(limitLeftIceX + (MyRandom.nextInt(BOSS_LAUGH_MAX) * MACHINE_BASE_HALF_HEIGHT), 103424, MyRandom.nextInt(92, 148), 116352, Self))
											
											SoundSystem.getInstance().playSe(SoundSystem.SE_145)
										Default
											' Nothing so far.
									End Select
								EndIf
						End Select
					Case STATE_BROKEN
						Self.water_level += 2
						
						StageManager.setWaterLevel(Self.water_level)
						
						For Local i:= 0 Until 3 ' Self.parts_pos.Length
							Self.parts_pos[i][0] += Self.parts_v[i][0]
							Self.parts_v[i][1] += GRAVITY
							Self.parts_pos[i][1] += Self.parts_v[i][1]
						Next
						
						Local posYLimit:= (getGroundY(Self.posX, Self.posY) - MACHINE_BASE_HALF_HEIGHT)
						
						If (Self.posY >= posYLimit) Then
							Self.posY = posYLimit
							
							Self.touch_bottom_cnt += 1
							
							If (Self.touch_bottom_cnt > TOUCH_BOTTOM_CNT_MAX) Then
								Self.state = STATE_ESCAPE
								
								bossFighting = False
								
								SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
							EndIf
						Else
							Self.posY = (Self.water_level Shl 6)
						EndIf
						
						Self.bossbroken.logicBoom(Self.posX, Self.posY)
					Case STATE_ESCAPE
						Self.wait_cnt += 1
						
						If (Self.wait_cnt >= Self.wait_cnt_max And Self.posY >= Self.fly_top - Self.fly_top_range) Then
							Self.posY -= Self.escape_v
						EndIf
						
						If (Self.posY <= (Self.fly_top - Self.fly_top_range) And Self.WaitCnt = 0) Then
							Self.posY = (Self.fly_top - Self.fly_top_range)
							
							Self.escapefacedrawer.setActionId(FACE_NORMAL) ' 0
							
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setLoop(False)
							
							Self.WaitCnt = 1
						EndIf
						
						If (Self.WaitCnt = 1 And Self.boatdrawer.checkEnd()) Then
							Self.escapefacedrawer.setActionId(FACE_NORMAL) ' 0
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
						EndIf
						
						If (Self.posX - Self.fly_end > Self.fly_top_range And Self.WaitCnt = 3) Then
							GameObject.addGameObject(New Cage((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH / 2)) Shl 6, (MapManager.getCamera().y + 40) Shl 6)) ' Shr 1
							
							Self.WaitCnt = 4
						EndIf
				End Select
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				If (Self.state <> STATE_BROKEN And Self.state <> STATE_ESCAPE) Then
					drawInMap(g, Self.machineDrawer)
					
					If (Self.face_state <> FACE_NORMAL) Then
						drawInMap(g, Self.faceDrawer, Self.posX, Self.posY + facePosY())
					EndIf
				ElseIf (Self.state = STATE_BROKEN) Then
					If (Self.bossbroken <> Null) Then
						Self.bossbroken.draw(g)
					EndIf
					
					Self.machinePartsdrawer.setActionId(0)
					
					drawInMap(g, Self.machinePartsdrawer, Self.parts_pos[0][0], Self.parts_pos[0][1])
					
					Self.machinePartsdrawer.setActionId(1)
					
					drawInMap(g, Self.machinePartsdrawer, Self.parts_pos[1][0], Self.parts_pos[1][1])
					drawInMap(g, Self.machinePartsdrawer, Self.parts_pos[2][0], Self.parts_pos[2][1])
					drawInMap(g, machineBase, Self.posX, Self.posY, VCENTER|HCENTER)
					drawInMap(g, Self.faceDrawer, Self.posX, Self.posY)
				ElseIf (Self.state = STATE_ESCAPE) Then
					' Magic numbers: 960, 2624
					drawInMap(g, Self.boatdrawer, Self.posX, Self.posY - 960)
					drawInMap(g, Self.escapefacedrawer, Self.posX, Self.posY - 2624)
				EndIf
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (Self.COLLISION_WIDTH / 2), y, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT) ' Shr 1
		End
End