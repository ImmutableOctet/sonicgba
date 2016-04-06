Strict

Public

' Imports:
Private
	Import common.barword
	Import common.numberdrawer
	Import common.whitebardrawer
	
	Import gameengine.def
	Import gameengine.key
	Import gameengine.touchdirectkey
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.constutil
	
	'Import mflib.bpdef
	
	Import sonicgba.collisionrect
	Import sonicgba.globalresource
	Import sonicgba.sonicdebug
	
	Import special.ssfollowring
	Import special.sslostring
	Import special.specialmap
	Import special.specialobject
	
	Import state.state
	Import state.stringindex
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfsensor
	Import com.sega.mobile.framework.ui.mftouchkey
	
	'Import java.lang.reflect.array
Public

' Classes:
Class SpecialPlayer Extends SpecialObject Implements BarWord
	Private
		' Constant variable(s):
		Const ACC_FAST:Int = 6
		Const ACC_NORMAL:Int = 4
		Const ACC_SLOW:Int = 2
		
		Global ANIMATION_NAME:String[] = ["/chr_sonic_sp", "/chr_tails_sp", "/chr_knuckles_sp", "/chr_amy_sp"] ' Const
		
		Global ANI_LOOP:Bool[] = [False, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, True, False, True, False, True, True, False, True, False, False] ' Const
		
		Const ANI_DAMAGE:Int = 25
		Const ANI_DASH_1:Int = 18
		Const ANI_DASH_2:Int = 19
		Const ANI_DIE_BOARD:Int = 22
		Const ANI_DIE_BODY:Int = 21
		Const ANI_FONT_WELCOME:Int = 0
		Const ANI_INTRO:Int = 0
		Const ANI_MOVE_DOWN:Int = 11
		Const ANI_MOVE_LEFT:Int = 12
		Const ANI_MOVE_LEFT_DOWN:Int = 16
		Const ANI_MOVE_LEFT_UP:Int = 14
		Const ANI_MOVE_RIGHT:Int = 13
		Const ANI_MOVE_RIGHT_DOWN:Int = 17
		Const ANI_MOVE_RIGHT_UP:Int = 15
		Const ANI_MOVE_UP:Int = 10
		Const ANI_NICE_SKILL:Int = 26
		Const ANI_SKILL:Int = 20
		Const ANI_STAND:Int = 1
		Const ANI_STAND_DOWN:Int = 3
		Const ANI_STAND_LEFT:Int = 4
		Const ANI_STAND_LEFT_DOWN:Int = 8
		Const ANI_STAND_LEFT_UP:Int = 6
		Const ANI_STAND_RIGHT:Int = 5
		Const ANI_STAND_RIGHT_DOWN:Int = 9
		Const ANI_STAND_RIGHT_UP:Int = 7
		Const ANI_STAND_UP:Int = 2
		Const ANI_VICTORY_1:Int = 23
		Const ANI_VICTORY_2:Int = 24
		Const ANI_WELCOME_1:Int = 27
		Const ANI_WELCOME_2:Int = 28
		Const ANI_WELCOME_3:Int = 29
		Const ANI_WELCOME_4:Int = 30
		Const ANI_WELCOME_5:Int = 31
		Const ANI_WELCOME_6:Int = 32
		Const ANI_WELCOME_7:Int = 33
		
		Const CENTER_ACC_X:Int = 5
		
		Const GRAVITY:Int = 172
		
		Const MAX_VELOCITY:Int = 3600
		
		Const MOVE_DOWN:Int = 4
		Const MOVE_LEFT:Int = 2
		Const MOVE_RIGHT:Int = 8
		Const MOVE_UP:Int = 1
		Const MOVE_VELOCITY:Int = 960
		
		Const RATIO:Float = 0.16
		
		Const RING_HUD_DESTINY:Int = 5
		Const RING_HUD_ORIGINAL:Int = -19
		Const RING_NUM_DESTINY:Int = 15
		Const RING_NUM_ORIGINAL:Int = -24
		
		Const SCALE_ZOOM_0:Float = -0.08
		Const SCALE_ZOOM_0_FRAME_COUNT:Int = 5
		Const SCALE_ZOOM_1:Float = -0.048
		Const SCALE_ZOOM_1_FRAME_COUNT:Int = 1
		Const SCALE_ZOOM_2:Float = -0.016
		Const SCALE_ZOOM_2_FRAME_COUNT:Int = 1
		Const SCALE_ZOOM_3:Float = 0.016
		Const SCALE_ZOOM_3_FRAME_COUNT:Int = 1
		Const SCALE_ZOOM_4:Float = 0.048
		Const SCALE_ZOOM_4_FRAME_COUNT:Int = 1
		Const SCALE_ZOOM_5:Float = 0.08
		Const SCALE_ZOOM_5_FRAME_COUNT:Int = 5
		Const SCALE_ZOOM_BASE:Float = 0.8
		Const SCALE_ZOOM_IN:Int = 9
		Const SCALE_ZOOM_OFFSET:Float = 0.0
		Const SCALE_ZOOM_OUT:Int = 9
		
		Const TOTAL_COUNT_SCALE_ZOOM:Int = 18
		
		Const SSSpringCount:Int = 15
		
		Const START_POS_X:Int = ((SCREEN_WIDTH Shl 6) Shr 1) ' / 2
		Const START_POS_Y:Int = ((SCREEN_HEIGHT Shl 6) Shr 1) ' / 2
		
		Const STATE_CHECK_POINT:Int = 5
		Const STATE_DASH:Int = 2
		Const STATE_DEAD:Int = 4
		Const STATE_GOAL:Int = 6
		Const STATE_INIT:Int = 8
		Const STATE_NORMAL:Int = 0
		Const STATE_OVER:Int = 9
		Const STATE_READY:Int = 7
		Const STATE_SKILLING:Int = 1
		Const STATE_SPRING:Int = 10
		Const STATE_TUTORIAL:Int = 11
		Const STATE_VICTORY:Int = 3
		
		Const STAY_TIME:Int = 60
		
		Global TUTORIAL_ANIMATION_ID:Int[][] = [[0, 6, 4, 1], [2, 6, 5, 3]] ' Const
		
		Const WELCOME_ANI_CHANGE_RANGE:Int = 500
		Const WELCOMT_VEL_X:Int = -240
		
		Const WHITE_BAR_HEIGHT:Int = 20
		Const WHITE_BAR_VEL_X:Int = -96
		Const WHITE_BAR_VEL_Y:Int = -36
		Const WHITE_BAR_WIDTH:Int = SCREEN_WIDTH
		Const WHITE_BAR_Y_DES:Int = ((SCREEN_HEIGHT / 2) - STAY_TIME) ' 60 ' Shr 1
		
		Const WORDS_INIT_X:Int = 14
		Const WORDS_VEL_X:Int = -8
		Const WORD_DISTANCE:Int = 224
		
		' Global variable(s):
		Global showTutorial:Bool = True ' False
	Public
		' Constant variable(s):
		Global ringVel:Int[][] = [[0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0], [0, 0]] ' Const
		
		' Global variable(s):
		Global ringDirection:Int[] = New Int[10]
		
		' Fields:
		Field checkSuccess:Bool
		Field noMoving:Bool
		
		Field hurtRect:CollisionRect
		Field rect1:Byte[]
		Field rect2:Byte[]
		Field targetRingNum:Int
		Field velX:Int
		Field velY:Int
		Field velZ:Int
	Protected
		' Fields:
		Field attackCollisionRect:CollisionRect
	Private
		' Fields:
		Field changingState:Bool
		Field debugPassStage:Bool
		Field tutorMoving:Bool
		Field triking:Bool
		Field startFlag:Bool
		Field niceTriking:Bool
		Field isGoal:Bool
		Field isNeedTouchPad:Bool
		Field isPause:Bool
		
		Field acc_value:Int
		Field actionID:Int
		Field boardOffsetX:Int
		Field boardOffsetY:Int
		Field boardOffsetZ:Int
		Field checkCount:Int
		Field count:Int
		Field moveDistance:Int
		Field pauseKeepScale:Float
		
		Field preState:Int
		
		Field ringHudY:Int
		Field ringNum:Int
		Field ringNumY:Int
		
		Field scaleCount:Int
		Field skipOffsetY:Int
		
		Field startX:Int
		Field startY:Int
		
		Field state:Int
		
		Field trickCount2:Int
		Field trikCount:Int
		
		Field tutorID:Int
		Field tutorX:Int
		
		Field tutorSkip:MFTouchKey
		
		Field characterBoardDrawer:AnimationDrawer
		Field drawer:AnimationDrawer
		Field fontAnimationDrawer:AnimationDrawer
		Field spObjDrawer:AnimationDrawer
		Field tutorialSkipDrawer:AnimationDrawer
		
		Field tutorialDrawer:AnimationDrawer[]
		
		Field welcomeVelY:Int
		Field welcomeX:Int
		Field welcomeY:Int
		
		Field whiteBar:WhiteBarDrawer
		Field whiteBarX:Int
		Field whiteBarY:Int
		
		Field wordX:Int
	Public
		' Functions:
		Function updateScale:Void()
			Local previousCount:= Self.scaleCount
			
			Self.scaleCount += 1 ' i + 1
			
			If (previousCount >= (TOTAL_COUNT_SCALE_ZOOM-1)) Then
				Self.scaleCount = 0
			EndIf
			
			If (Self.scaleCount < SCALE_ZOOM_0_FRAME_COUNT) Then
				'scale = 0.92
				scale = 1.0+SCALE_ZOOM_0
			ElseIf (Self.scaleCount < (SCALE_ZOOM_0_FRAME_COUNT+SCALE_ZOOM_1_FRAME_COUNT)) Then
				'scale = 0.952
				scale = 1.0+SCALE_ZOOM_1
			ElseIf (Self.scaleCount < (SCALE_ZOOM_0_FRAME_COUNT+SCALE_ZOOM_1_FRAME_COUNT+SCALE_ZOOM_2_FRAME_COUNT)) Then
				'scale = 0.984
				scale = 1.0+SCALE_ZOOM_2
			ElseIf (Self.scaleCount < (SCALE_ZOOM_0_FRAME_COUNT+SCALE_ZOOM_1_FRAME_COUNT+SCALE_ZOOM_2_FRAME_COUNT+SCALE_ZOOM_3_FRAME_COUNT)) Then
				'scale = 1.016
				scale = 1.0+SCALE_ZOOM_3
			ElseIf (Self.scaleCount < (SCALE_ZOOM_0_FRAME_COUNT+SCALE_ZOOM_1_FRAME_COUNT+SCALE_ZOOM_2_FRAME_COUNT+SCALE_ZOOM_3_FRAME_COUNT+SCALE_ZOOM_4_FRAME_COUNT)) Then
				'scale = 1.048
				scale = 1.0+SCALE_ZOOM_4
			ElseIf (Self.scaleCount < (SCALE_ZOOM_IN+SCALE_ZOOM_0_FRAME_COUNT)) Then
				'scale = 1.08
				scale = 1.0+SCALE_ZOOM_5
			ElseIf (Self.scaleCount < (SCALE_ZOOM_IN+SCALE_ZOOM_0_FRAME_COUNT+SCALE_ZOOM_1_FRAME_COUNT)) Then
				'scale = 1.048
				scale = 1.0+SCALE_ZOOM_4
			ElseIf (Self.scaleCount < (SCALE_ZOOM_IN+SCALE_ZOOM_0_FRAME_COUNT+SCALE_ZOOM_1_FRAME_COUNT+SCALE_ZOOM_2_FRAME_COUNT)) Then
				'scale = 1.016
				scale = 1.0+SCALE_ZOOM_3
			ElseIf (Self.scaleCount < (SCALE_ZOOM_IN+SCALE_ZOOM_0_FRAME_COUNT+SCALE_ZOOM_1_FRAME_COUNT+SCALE_ZOOM_2_FRAME_COUNT+SCALE_ZOOM_3_FRAME_COUNT)) Then
				'scale = 0.984
				scale = 1.0+SCALE_ZOOM_2
			ElseIf (Self.scaleCount < TOTAL_COUNT_SCALE_ZOOM) Then
				'scale = 0.952
				scale = 1.0+SCALE_ZOOM_1
			EndIf
		End
		
		' Constructor(s):
		Method New(characterID:Int)
			Super.New(-1, 0, 0, 0)
			
			Self.pauseKeepScale = 1.0
			
			Self.ringHudY = RING_HUD_ORIGINAL
			Self.ringNumY = RING_NUM_ORIGINAL
			
			Self.moveDistance = 0
			
			Self.velZ = ACC_NORMAL
			
			Self.rect1 = Null
			Self.rect2 = Null
			
			Self.isPause = False
			
			Local animation:= New Animation(SSDef.SPECIAL_ANIMATION_PATH + ANIMATION_NAME[characterID])
			
			Self.drawer = animation.getDrawer()
			
			Self.characterBoardDrawer = animation.getDrawer(ANI_DIE_BOARD, True, 0)
			Self.actionID = STATE_INIT
			
			Self.hurtRect = New CollisionRect()
			
			Self.noMoving = True
			
			Self.fontAnimationDrawer = Animation.getInstanceFromQi("/special_res/sp_font.dat")[0].getDrawer()
			Self.spObjDrawer = objAnimation.getDrawer()
			
			Self.state = STATE_INIT
			Self.preState = Self.state
			
			Self.isNeedTouchPad = False
			Self.whiteBar = WhiteBarDrawer.getInstance()
			
			Local tutorAnimation:= Animation.getInstanceFromQi("/animation/special/sp_control_change_hint.dat")[0]
			
			Self.tutorialDrawer = New AnimationDrawer[TUTORIAL_ANIMATION_ID[0].Length]
			
			For Local i:= 0 Until Self.tutorialDrawer.Length
				Self.tutorialDrawer[i] = tutorAnimation.getDrawer()
			Next
			
			Self.tutorialSkipDrawer = New Animation("/animation/special/skip").getDrawer()
		End
		
		' Methods:
		Method logic:Void()
			If (Self.trikCount > 0) Then
				Self.trikCount -= 1
				
				If (Self.trikCount = 0 And Self.actionID <> ANI_NICE_SKILL) Then
					devcideRingFollow(False)
				EndIf
			EndIf
			
			If (Not Self.noMoving) Then
				Self.posZ += Self.velZ
				
				Self.ringHudY = MyAPI.calNextPosition(Double(Self.ringHudY), 5.0, 1, 3)
				Self.ringNumY = MyAPI.calNextPosition(Double(Self.ringNumY), 15.0, 1, 3)
			EndIf
			
			Self.moveDistance = 0
			
			Self.count += 1
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.state <> STATE_SPRING) Then
				Self.velX = 0
				Self.velY = 0
			ElseIf (Self.count >= SSSpringCount) Then
				Self.velX = 0
				Self.velY = 0
			EndIf
			
			If (GlobalResource.spsetConfig = 1) Then
				calSensor()
			Else
				Local touchDirectKey:= Key.touchdirectgamekey
				
				If (TouchDirectKey.IsKeyPressed()) Then
					Local degree:= Key.touchdirectgamekey.getDegree()
					
					If (Self.state = STATE_DASH) Then
						If (Self.state <> STATE_SPRING) Then
							Self.velX = ((Cos(degree) * MOVE_VELOCITY) / 100)
						ElseIf (Self.count >= SSSpringCount) Then
							Self.velX = ((Cos(degree) * MOVE_VELOCITY) / 100)
						EndIf
					ElseIf (Self.state <> STATE_SPRING) Then
						Self.velX = ((Cos(degree) * MOVE_VELOCITY) / 100)
						Self.velY = ((Sin(degree) * MOVE_VELOCITY) / 100)
					ElseIf (Self.count >= SSSpringCount) Then
						Self.velX = ((Cos(degree) * MOVE_VELOCITY) / 100)
						Self.velY = ((Sin(degree) * MOVE_VELOCITY) / 100)
					EndIf
				EndIf
			EndIf
			
			If (Self.state <> STATE_SPRING) Then
				Self.posX += Self.velX
				Self.posY += Self.velY
			ElseIf (Self.count >= SSSpringCount) Then
				Self.posX += Self.velX
				Self.posY += Self.velY
			EndIf
			
			Select (Self.state)
				Case STATE_NORMAL, STATE_READY
					If (Self.actionID <> ANI_DAMAGE) Then
						Self.actionID = ANI_STAND
						
						If (TouchDirectKey.IsKeyPressed()) Then
							Local actDegree:= Key.touchdirectgamekey.getDegree()
							
							If (actDegree > 337 Or actDegree < ANI_VICTORY_1) Then
								Self.actionID = ANI_MOVE_RIGHT
							ElseIf (actDegree >= ANI_VICTORY_1 And actDegree < 68) Then
								Self.actionID = ANI_MOVE_RIGHT_DOWN
							ElseIf (actDegree >= 68 And actDegree < 113) Then
								Self.actionID = ANI_MOVE_DOWN
							ElseIf (actDegree >= 113 And actDegree < 158) Then
								Self.actionID = ANI_MOVE_LEFT_DOWN
							ElseIf (actDegree >= 158 And actDegree < 203) Then
								Self.actionID = ANI_MOVE_LEFT
							ElseIf (actDegree >= 203 And actDegree < 248) Then
								Self.actionID = ANI_MOVE_LEFT_UP
							ElseIf (actDegree >= 248 And actDegree < 293) Then
								Self.actionID = ANI_MOVE_UP
							ElseIf (actDegree >= 293 And actDegree < 338) Then
								Self.actionID = ANI_MOVE_RIGHT_UP
							EndIf
						EndIf
						
						If (Self.state = STATE_NORMAL) Then
							If (Key.press(Key.gSelect)) Then
								Self.preState = Self.state
								Self.state = STATE_SKILLING
								
								If (Self.trikCount > 0) Then
									Self.actionID = ANI_NICE_SKILL
									
									SoundSystem.getInstance().playBgmSequence(SoundSystem.BGM_SP_TRICK, SoundSystem.BGM_SP)
									
									devcideRingFollow(True)
								Else
									Self.actionID = WHITE_BAR_HEIGHT
									
									SoundSystem.getInstance().playSe(SoundSystem.SE_149)
								EndIf
							EndIf
							
							If (Key.repeated(Key.B_HIGH_JUMP)) Then
								Self.state = STATE_DASH
								Self.actionID = ANI_DASH_1
								Self.velZ = ACC_FAST
							EndIf
						EndIf
						
						setStayAnimation()
					EndIf
				Case STATE_SKILLING
					Self.posX = preX
					Self.posY = preY
					
					If (Self.drawer.checkEnd()) Then
						Self.state = Self.preState
					EndIf
				Case STATE_DASH
					If (Not Key.repeated(Key.B_HIGH_JUMP)) Then
						Self.state = STATE_NORMAL
						Self.velZ = ACC_NORMAL
					Else
						If (GlobalResource.spsetConfig = 1) Then
							Select (Self.acc_value)
								Case STATE_DASH
									Self.posX = MyAPI.calNextPosition(Double(Self.posX), 0.0, 3, 16)
								Case STATE_DEAD
									Self.posX = MyAPI.calNextPosition(Double(Self.posX), 0.0, 3, 8)
								Case STATE_GOAL
									Self.posX = MyAPI.calNextPosition(Double(Self.posX), 0.0, 9, 16)
							End Select
						EndIf
						
						Self.posX = MyAPI.calNextPosition(Double(Self.posX), 0.0, 1, 4)
						Self.posY = MyAPI.calNextPosition(Double(Self.posY), 0.0, 1, 4)
						
						If (Self.drawer.checkEnd()) Then
							Self.actionID = ANI_DASH_2
						EndIf
					EndIf
				Case STATE_CHECK_POINT
					Self.posX = preX
					Self.posY = preY
					
					If (Self.velZ > ACC_NORMAL) Then
						Self.velZ = MyAPI.calNextPosition(Double(Self.velZ), 4.0, 1, 4)
					EndIf
					
					moveToCenter()
					
					Self.checkCount += 1
					
					If (Not isInCenter() Or Self.checkCount <= WHITE_BAR_HEIGHT) Then
						Self.count = 0
						Self.actionID = ANI_STAND
						Self.checkSuccess = (Int(Self.ringNum >= Self.targetRingNum) | Self.debugPassStage)
					ElseIf (Self.checkSuccess) Then
						If (Not (Self.actionID = ANI_VICTORY_1 Or Self.actionID = ANI_VICTORY_2)) Then
							Self.actionID = ANI_VICTORY_1
							
							If (Self.isGoal) Then
								SoundSystem.getInstance().playBgmSequence(SoundSystem.BGM_SP_CLEAR, SoundSystem.BGM_SP)
							EndIf
						EndIf
						
						If (Not Self.isGoal) Then
							If (Self.count = ANI_MOVE_LEFT_DOWN) Then
								initScoreBase()
							EndIf
							
							If (Self.count = WHITE_BAR_HEIGHT) Then
								Self.targetRingNum = RING_TARGET[SpecialMap.specialStageID][1]
								
								WhiteBarDrawer.getInstance().initBar(Self, 0)
							EndIf
							
							If (Self.whiteBar.getState() = STATE_DASH And Self.whiteBar.getCount() > 30) Then
								Self.state = STATE_READY
							EndIf
						ElseIf (Self.count > 48) Then
							Self.state = STATE_OVER
							
							Self.count = 0
						EndIf
					Else
						Self.boardOffsetZ -= 30
						Self.boardOffsetX -= 30
						
						Self.actionID = ANI_DIE_BODY
						
						If (Self.count > 48) Then
							Self.state = STATE_OVER
							
							Self.count = 0
						EndIf
					EndIf
					
					setStayAnimation()
				Case STATE_INIT
					Self.preState = Self.state
					Self.ringNum = 0
					Self.targetRingNum = RING_TARGET[SpecialMap.specialStageID][0]
					Self.state = STATE_READY
					Self.whiteBar.initBar(Self, 0)
					Self.startFlag = False
					Self.startX = (SCREEN_WIDTH / 2) ' Shr 1
					Self.startY = (SCREEN_HEIGHT / 2) ' Shr 1
					Self.noMoving = True
					
					initScoreBase()
					
					If (Not showTutorial Or GlobalResource.spsetConfig <> 1) Then
						Self.isNeedTouchPad = True
					Else
						Self.state = STATE_TUTORIAL
						Self.actionID = ANI_STAND
						
						Self.count += 1
						
						Self.tutorX = (SCREEN_WIDTH * 2) ' Shl 1
						Self.tutorSkip = New MFTouchKey(0, MyAPI.zoomOut(Def.SCREEN_HEIGHT) - WHITE_BAR_HEIGHT, 30, WHITE_BAR_HEIGHT, 1)
						
						MFDevice.addComponent(Self.tutorSkip)
						
						Self.skipOffsetY = WHITE_BAR_HEIGHT
						
						showTutorial = False
					EndIf
				Case STATE_OVER
					Self.posX = preX
					Self.posY = preY
					
					Self.isNeedTouchPad = False
				Case STATE_SPRING
					If (Self.count >= SSSpringCount) Then
						Self.velX = MyAPI.calNextPosition(Double(Self.velX), 0.0, 1, 4, 3.0)
						Self.velY = MyAPI.calNextPosition(Double(Self.velY), 0.0, 1, 4, 3.0)
						
						If (Self.velZ > ACC_NORMAL) Then
							Self.velZ = MyAPI.calNextPosition(Double(Self.velZ), 4.0, 1, 4)
						EndIf
					EndIf
					
					If (Self.velZ < ACC_NORMAL) Then
						Self.velZ += 1
					EndIf
					
					Self.posX += Self.velX
					Self.posY += Self.velY
					Self.posZ += Self.velZ
					
					If (Self.velX = 0 And Self.velY = 0 And Self.velZ = ACC_NORMAL) Then
						Self.state = STATE_NORMAL
					EndIf
					
					If (Self.count >= SSSpringCount And Self.velZ = ACC_NORMAL) Then
						Self.state = STATE_NORMAL
					EndIf
					
					Self.actionID = ANI_STAND
					
					setStayAnimation()
				Case STATE_TUTORIAL
					Self.posX = preX
					Self.posY = preY
					
					setStayAnimation()
					
					If (Self.count = 10) Then
						State.fadeInit(0, 200)
					EndIf
					
					If (Key.press(Key.B_S1) And Not Self.tutorMoving And Self.skipOffsetY = 0) Then
						Select (Self.tutorID)
							Case 0
								Self.tutorID = 1
								Self.tutorMoving = True
							Case 1
								Self.tutorID = 2
								Self.tutorMoving = True
						End Select
					EndIf
					
					If (Self.tutorID = STATE_DASH And Not Self.tutorMoving And State.fadeChangeOver()) Then
						If (Not Self.changingState) Then
							State.fadeInit(200, 0)
							
							Self.changingState = True
						EndIf
						
						Self.preState = Self.state
						Self.state = STATE_READY
						
						Self.isNeedTouchPad = True
						Self.changingState = False
						
						MFDevice.removeComponent(Self.tutorSkip)
					EndIf
			End Select
			
			Const MAX_VEL_Y:= 7680 ' (MOVE_VELOCITY * 8) ' MOVE_RIGHT
			Const MAX_VEL_X:= 9600 ' (MOVE_VELOCITY * (MOVE_LEFT + MOVE_RIGHT))
			
			If (Self.posX < -MAX_VEL_X) Then
				Self.posX = -MAX_VEL_X
			EndIf
			
			If (Self.posX > MAX_VEL_X) Then
				Self.posX = MAX_VEL_X
			EndIf
			
			If (Self.posY < -MAX_VEL_Y) Then
				Self.posY = -MAX_VEL_Y
			EndIf
			
			If (Self.posY > MAX_VEL_Y) Then
				Self.posY = MAX_VEL_Y
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			SpecialObject.calDrawPosition(Self.posX Shr 6, (-Self.posY) Shr 6, Self.posZ - (Self.boardOffsetX Shr 6))
			
			If (Not Self.isPause) Then
				If (Self.state <> STATE_SPRING And Self.state <> 4 And ((Self.state <> STATE_CHECK_POINT Or Not isInCenter() Or Self.checkCount <= WHITE_BAR_HEIGHT) And Self.state <> STATE_OVER)) Then
					updateScale()
				ElseIf (Self.checkSuccess) Then
					updateScale()
				Else
					scale *= SCALE_ZOOM_BASE
				EndIf
				
				Self.pauseKeepScale = scale
			ElseIf (Self.state = STATE_SPRING Or Self.state = STATE_DEAD Or ((Self.state = STATE_CHECK_POINT And isInCenter() And Self.checkCount > WHITE_BAR_HEIGHT) Or Self.state = STATE_OVER)) Then
				scale *= SCALE_ZOOM_BASE
			Else
				scale = Self.pauseKeepScale
			EndIf
			
			Self.drawer.setActionId(Self.actionID)
			Self.drawer.setLoop(ANI_LOOP[Self.actionID])
			
			drawObj(g, Self.drawer, (((Int((Float(Self.posX) * scale) - Float(Self.posX)))) / 4) Shr 6, (((Int((Float(Self.posY) * scale) - Float(Self.posY)))) / 4) Shr 6)
			
			If (Self.drawer.checkEnd()) Then
				Select (Self.actionID)
					Case ANI_VICTORY_1
						Self.actionID = ANI_VICTORY_2
					Case ANI_DAMAGE
						Self.actionID = ANI_STAND
				End Select
			EndIf
			
			Select (Self.state)
				Case STATE_CHECK_POINT
					If (Self.count > 1) Then
						If (Self.count < PickValue((Self.isGoal Or Not Self.checkSuccess), 48, 26)) Then
							Local ani:Int
							
							If (Self.checkSuccess) Then
								ani = ANI_MOVE_UP ' 10
							Else
								ani = ANI_MOVE_DOWN ' 11
							EndIf
							
							Local animationDrawer:= Self.spObjDrawer
							
							animationDrawer.draw(g, ani, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), False, 0) ' Shr 1
							
							If (Not Self.checkSuccess) Then
								SpecialObject.calDrawPosition((Self.posX + Self.boardOffsetX) Shr 6, ((-Self.posY) - Self.boardOffsetY) Shr 6, Self.posZ + (Self.boardOffsetZ Shr 6))
								
								drawObj(g, Self.characterBoardDrawer, 0, 0)
							EndIf
						EndIf
					EndIf
					
					If (Self.count = 0 And Not Self.checkSuccess) Then
						Self.fontAnimationDrawer.draw(g, ANI_STAND_RIGHT_UP, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), False, 0) ' Shr 1
					EndIf
				Case STATE_TUTORIAL
					State.drawFade(g)
					
					If (Self.count > STATE_SPRING And State.fadeChangeOver()) Then
						Local tutorDesX:= (SCREEN_WIDTH / 2) - (SCREEN_WIDTH * Self.tutorID) ' Shr 1
						
						Self.tutorX = MyAPI.calNextPosition(Double(Self.tutorX), Double(tutorDesX), 1, 3)
						
						For Local i:= 0 Until Self.tutorialDrawer.Length
							Self.tutorialDrawer[i].setPause(True)
							
							If (Self.tutorX = tutorDesX) Then
								Self.tutorialDrawer[i].setPause(False)
								Self.tutorMoving = False
							ElseIf (Self.tutorID >= 1) Then
								Self.tutorialDrawer[i].draw(g, TUTORIAL_ANIMATION_ID[Self.tutorID - 1][i], ((Self.tutorID - 1) * SCREEN_WIDTH) + Self.tutorX, (SCREEN_HEIGHT / 2), True, 0) ' Shr 1
							EndIf
							
							If (Self.tutorID <= 1) Then
								Self.tutorialDrawer[i].draw(g, TUTORIAL_ANIMATION_ID[Self.tutorID][i], (Self.tutorID * SCREEN_WIDTH) + Self.tutorX, (SCREEN_HEIGHT / 2), True, 0) ' Shr 1
							EndIf
						Next
						
						Self.skipOffsetY = MyAPI.calNextPosition(Double(Self.skipOffsetY), Double(PickValue((Self.tutorID > 1), WHITE_BAR_HEIGHT, 0)), 1, 3)
						Self.tutorialSkipDrawer.draw(g, Int(Key.repeated(Key.B_S1)), 0, Self.skipOffsetY + (SCREEN_HEIGHT - 1), True, 0)
					EndIf
			End Select
			
			drawcollisionRect(g)
		End
		
		Method drawInfo:Void(g:MFGraphics)
			Self.whiteBar.setPauseCount(Self.isPause)
			
			Select (Self.state)
				Case STATE_CHECK_POINT
					WhiteBarDrawer.getInstance().drawBar(g)
				Case STATE_READY
					If (Self.whiteBar.getState() = STATE_DASH Or Self.whiteBar.getState() = STATE_VICTORY Or Self.whiteBar.getState() = STATE_DEAD) Then
						If (Not Self.isPause) Then
							State.staticDrawFadeSlow(g)
						EndIf
					ElseIf (Self.preState = STATE_INIT) Then
						g.setColor(0)
						
						MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					EndIf
					
					If (Self.startFlag) Then
						Self.fontAnimationDrawer.draw(g, 4, Self.startX, Self.startY, False, 0) ' ANI_STAND_LEFT
						
						If (Self.whiteBar.getState() = STATE_VICTORY) Then
							Self.startX += WHITE_BAR_VEL_X
						EndIf
					EndIf
					
					WhiteBarDrawer.getInstance().drawBar(g)
					
					If (Self.whiteBar.getState() = 1) Then
						Self.startFlag = True
					EndIf
					
					If (Self.whiteBar.getState() = STATE_DEAD) Then
						Self.state = STATE_NORMAL
						
						Self.noMoving = False
					EndIf
				Case STATE_INIT
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			End Select
			
			If (Not (Self.state = STATE_INIT Or Self.state = STATE_READY)) Then
				Self.spObjDrawer.draw(g, ANI_MOVE_LEFT, (SCREEN_WIDTH / 2), Self.ringHudY, False, 0) ' Shr 1
				
				NumberDrawer.drawNum(g, 0, Self.targetRingNum, (SCREEN_WIDTH / 2) + 12, Self.ringNumY, 2) ' Shr 1
				NumberDrawer.drawNum(g, 0, Self.ringNum, (SCREEN_WIDTH  / 2) - 12, Self.ringNumY - 12, 2) ' Shr 1
			EndIf
			
			' Magic number: 16 ("Trick count")
			If (Self.triking And Self.trikCount = 0 And Self.trickCount2 < 16) Then
				Self.trickCount2 += 1
				
				If (Self.actionID = ANI_NICE_SKILL Or Self.niceTriking) Then
					Self.fontAnimationDrawer.draw(g, 5, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, False, 0)
					
					Self.niceTriking = True
				Else
					Self.fontAnimationDrawer.draw(g, 6, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, False, 0)
				EndIf
				
				If (Self.trikCount >= 16) Then
					Self.triking = False
				EndIf
			EndIf
		End
		
		Method initWelcome:Void()
			' Magic numbers: 50, 160, -2500
			Self.welcomeX = ((SCREEN_WIDTH / 2) + 50) Shl 6 ' (SCREEN_WIDTH Shr 1)
			Self.welcomeY = (SCREEN_HEIGHT + 160) Shl 6
			
			Self.welcomeVelY = -2500 ' WELCOMT_VEL_Y
		End
		
		Method logicWelcome:Void()
			Self.welcomeVelY += GRAVITY
			Self.welcomeY += Self.welcomeVelY
			Self.welcomeX += WELCOMT_VEL_X
		End
		
		Method drawWelcome:Void(g:MFGraphics)
			Local action:Int
			
			If (Self.welcomeVelY < -500) Then
				action = ANI_WELCOME_1
			ElseIf (Self.welcomeVelY < -333) Then
				action = ANI_WELCOME_2
			ElseIf (Self.welcomeVelY < -166) Then
				action = ANI_WELCOME_3
			ElseIf (Self.welcomeVelY < 166) Then
				action = ANI_WELCOME_4
			ElseIf (Self.welcomeVelY < 333) Then
				action = ANI_WELCOME_5
			ElseIf (Self.welcomeVelY < WELCOME_ANI_CHANGE_RANGE) Then
				action = ANI_WELCOME_6
			Else
				action = ANI_WELCOME_7
			EndIf
			
			Self.drawer.draw(g, action, Self.welcomeX Shr 6, Self.welcomeY Shr 6, True, 0)
			Self.fontAnimationDrawer.draw(g, 0, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) + 40, True, 0) ' Shr 1
		End
		
		Method isWelcomeOver:Bool()
			Return (Self.welcomeY > ((SCREEN_HEIGHT + STAY_TIME) Shl 6))
		End
		
		Method close:Void()
			Animation.closeAnimationDrawerArray(Self.tutorialDrawer)
			
			Self.tutorialDrawer = []
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			' Empty implementation.
		End
		
		Method beSpringX:Void(velX:Int)
			Self.velX = (velX Shl 6)
			Self.state = STATE_SPRING
			Self.count = 0
		End
		
		Method beSpringY:Void(velY:Int)
			Self.velY = (velY Shl 6)
			Self.state = STATE_SPRING
			Self.count = 0
		End
		
		Method beSpringZ:Void(velZ:Int)
			Self.velZ = velZ
			Self.state = STATE_SPRING
			Self.count = 0
		End
		
		Method beHurt:Void()
			If (Self.actionID <> ANI_DAMAGE) Then
				Self.actionID = ANI_DAMAGE
				
				Self.state = STATE_NORMAL
				
				If (Self.ringNum = 0) Then
					SoundSystem.getInstance().playSe(SoundSystem.SE_144)
				Else
					SoundSystem.getInstance().playSe(SoundSystem.SE_118)
				EndIf
				
				Local lostnum:= ringDirection.Length
				
				Self.ringNum -= ringDirection.Length
				
				If (Self.ringNum < 0) Then
					lostnum = (ringDirection.Length + Self.ringNum)
					
					Self.ringNum = 0
				EndIf
				
				For Local i:= 0 Until ringDirection.Length ' 10
					ringDirection[i] = i
					
					ringVel[i][0] = ((Cos(i * 36) * 800) / 100)
					ringVel[i][1] = ((Sin(i * 36) * 800) / 100)
				Next
				
				For Local i:= 0 Until ringDirection.Length ' 10
					Local pos:= MyRandom.nextInt(0, ringDirection.Length - 1)
					Local tmp:= ringDirection[pos]
					
					ringDirection[pos] = ringDirection[i]
					ringDirection[i] = tmp
				Next
				
				' Create "lost ring" objects to represent the rings we lost:
				For Local i:= 0 Until lostnum
					SpecialObject.addExtraObject(New SSLostRing(Self.posX, -Self.posY, Self.posZ, ringVel[ringDirection[i]][0], ringVel[ringDirection[i]][1], Self.velZ))
				Next
			EndIf
		End
		
		Public Method getRing:Void(ringNum:Int)
			Self.ringNum += ringNum
		End
		
		Public Method setCheckPoint:Void()
			Self.checkSuccess = (Int(Self.ringNum >= Self.targetRingNum) | Self.debugPassStage)
			
			Self.noMoving = True
			Self.state = STATE_CHECK_POINT
			Self.count = 0
			Self.checkCount = 0
			Self.isGoal = False
			Self.velZ = ACC_NORMAL
		End
		
		Public Method setGoal:Void()
			setCheckPoint()
			Self.isGoal = True
		End
		
		Public Method isTricking:Bool()
			Return Self.state = STATE_SKILLING
		End
		
		Public Method moveToCenter:Void()
			Self.posX = MyAPI.calNextPosition(Double(Self.posX), 0.0, STATE_DASH, ANI_VICTORY_2)
			Self.posY = MyAPI.calNextPosition(Double(Self.posY), 0.0, STATE_DASH, ANI_VICTORY_2)
		End
		
		Public Method isInCenter:Bool()
			Return Self.posY = 0 And Self.posX = 0
		End
		
		Public Method setStayAnimation:Void()
			
			If (Self.actionID = ANI_STAND) Then
				Self.moveDistance = 0
				
				If (Self.posX < -2560) Then
					Self.moveDistance |= STATE_DASH
				ElseIf (Self.posX > BarHorbinV.COLLISION_WIDTH) Then
					Self.moveDistance |= STATE_INIT
				EndIf
				
				If (Self.posY < -2560) Then
					Self.moveDistance |= 1
				ElseIf (Self.posY > BarHorbinV.COLLISION_WIDTH) Then
					Self.moveDistance |= STATE_DEAD
				EndIf
				
				If ((Self.moveDistance & STATE_SKILLING) <> 0) Then
					Self.actionID = STATE_DASH
					
					If ((Self.moveDistance & STATE_DASH) <> 0) Then
						Self.actionID = STATE_GOAL
					ElseIf ((Self.moveDistance & STATE_INIT) <> 0) Then
						Self.actionID = STATE_READY
					EndIf
					
				ElseIf ((Self.moveDistance & STATE_DEAD) <> 0) Then
					Self.actionID = STATE_VICTORY
					
					If ((Self.moveDistance & STATE_DASH) <> 0) Then
						Self.actionID = STATE_INIT
					ElseIf ((Self.moveDistance & STATE_INIT) <> 0) Then
						Self.actionID = STATE_OVER
					EndIf
					
				ElseIf ((Self.moveDistance & STATE_DASH) <> 0) Then
					Self.actionID = STATE_DEAD
				ElseIf ((Self.moveDistance & STATE_INIT) <> 0) Then
					Self.actionID = STATE_CHECK_POINT
				EndIf
			EndIf
			
		End
		
		Public Method isOver:Bool()
			Return Self.state = STATE_OVER And Self.count > WHITE_BAR_HEIGHT
		End
		
		Public Method drawWord:Void(g:MFGraphics, wordID:Int, x:Int, y:Int)
			Self.fontAnimationDrawer.draw(g, STATE_DASH, x, y, False, 0)
			MFGraphics mFGraphics = g
			Self.fontAnimationDrawer.draw(g, STATE_VICTORY, NumberDrawer.drawNum(mFGraphics, STATE_VICTORY, Self.targetRingNum, x + 50, y, STATE_SKILLING) + STATE_INIT, y, False, 0)
		End
		
		Public Method getWordLength:Int(wordID:Int)
			Return WORD_DISTANCE
		End
		
		Public Method getRingNum:Int()
			Return Self.ringNum
		End
		
		Public Method setTrikCount:Void()
			Self.triking = True
			Self.niceTriking = False
			Self.trikCount = STATE_GOAL
			Self.trickCount2 = 0
		End
		
		Public Method devcideRingFollow:Void(flag:Bool)
			For (Int i = 0; i < decideObjects.size(); i += 1)
				((SSFollowRing) decideObjects.elementAt(i)).setFollowOrNot(flag)
			Next
			decideObjects.removeAllElements()
		End
		
		Public Method isNeedTouchPad:Bool()
			Return Self.isNeedTouchPad
		End
		
		Public Method setPause:Void(statePause:Bool)
			Self.isPause = statePause
		End
	Private
		' Methods:
		Method refreshCollision:Void(x:Int, y:Int)
			Self.rect1 = Self.drawer.getCRect()
			Self.rect2 = Self.drawer.getARect()
			
			If (Self.rect1 <> Null) Then
				Self.collisionRect.setTwoPosition((x Shr 6) + Self.rect1[0], ((-y) Shr 6) - Self.rect1[1], ((x Shr 6) + Self.rect1[0]) + Self.rect1[2], (((-y) Shr 6) - Self.rect1[1]) - Self.rect1[3])
			EndIf
			
			If (Self.rect2 <> Null) Then
				If (Self.attackCollisionRect = Null) Then
					Self.attackCollisionRect = New CollisionRect()
				EndIf
				
				Self.attackCollisionRect.setTwoPosition((x Shr 6) + Self.rect2[0], ((-y) Shr 6) - Self.rect2[1], ((x Shr 6) + Self.rect2[0]) + Self.rect2[2], (((-y) Shr 6) - Self.rect2[1]) - Self.rect2[3])
			EndIf
		End
		
		Method drawcollisionRect:Void(g:MFGraphics)
			If (Self.rect1 <> Null And SonicDebug.showCollisionRect) Then
				g.setColor(16711680)
				
				g.drawRect(((drawX + (SCREEN_WIDTH / 2)) - SpecialMap.getCameraOffsetX()) + Self.rect1[0], ((drawY + (SCREEN_HEIGHT / 2)) - SpecialMap.getCameraOffsetY()) + Self.rect1[1], Self.rect1[2], Self.rect1[3]) ' Shr 1
			EndIf
			
			If (Self.rect2 <> Null And SonicDebug.showCollisionRect) Then
				g.setColor(65280)
				
				g.drawRect(((drawX + (SCREEN_WIDTH / 2)) - SpecialMap.getCameraOffsetX()) + Self.rect2[0], ((drawY + (SCREEN_HEIGHT / 2)) - SpecialMap.getCameraOffsetY()) + Self.rect2[1], Self.rect2[2], Self.rect2[3])
			EndIf
		End
		
		Method calSensor:Void()
			Local accX:= MFSensor.getAccX()
			Local accY:= MFSensor.getAccY()
			
			Select (GlobalResource.sensorConfig)
				Case 0
					Self.acc_value = ACC_SLOW
				Case 1
					Self.acc_value = ACC_NORMAL
				Case 2
					Self.acc_value = ACC_FAST
			End Select
			
			accX = Max(Min(accX, Float(Self.acc_value + CENTER_ACC_X)), Float(CENTER_ACC_X - Self.acc_value))
			accY = Max(Min(accY, Float(Self.acc_value)), Float(-Self.acc_value))
			
			If (Self.state = STATE_DASH) Then
				If (Self.state <> STATE_SPRING) Then
					Self.velX = Int((accY * 3600.0) / 10.0)
				ElseIf (Self.count >= SSSpringCount) Then
					Self.velX = Int((accY * 3600.0) / 10.0)
				EndIf
			ElseIf (Self.state <> STATE_SPRING) Then
				Self.velX = Int((accY * 3600.0) / 10.0)
				Self.velY = Int(((accX - 5.0) * 3600.0) / 10.0)
			ElseIf (Self.count >= SSSpringCount) Then
				Self.velX = Int((accY * 3600.0) / 10.0)
				Self.velY = Int(((accX - 5.0) * 3600.0) / 10.0)
			EndIf
		End
		
		Method initScoreBase:Void()
			Self.ringHudY = RING_HUD_ORIGINAL
			Self.ringNumY = RING_NUM_ORIGINAL
		End
End