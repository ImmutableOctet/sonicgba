Strict

Public

' Imports:
Private
	Import ending.plainending
	
	Import platformstandard.standard2
	
	Import state.specialstagestate
Public

' Classes:
Class NormalEnding Extends PlainEnding ' Final
	Private
		' Constant variable(s):
		'Const ANIMATION_LOOP:Bool[]
		
		Global CLOUD_RIGHT_SPEED:Int[] = [1, 2, 2, 1] ' Const
		Global CLOUD_UP_SPEED:Int[] = [16, 10, 14, 8] ' Const
		
		Global LOOK_UP_IMAGE_NAME:String[] = ["/look_up_sonic.png", "/look_up_tails.png", "/look_up_knuckles.png", "/look_up_amy.png"] ' Const
		Global WORD_PARAM:Int[][] = [[0, 0, 184, 24], [0, 24, 184, 48]] ' Const
		
		Const BACK_GROUND_STOP_Y:Int = -135
		
		' I'm pretty sure 8 is the original number in the GBA version.
		Const BIRD_NUM:Int = 10
		
		Const BIRD_OFFSET:Int = 2
		Const BIRD_SPACE_1:Int = 10
		Const BIRD_SPACE_2:Int = 14
		Const BIRD_VELOCITY:Int = 2
		Const BIRD_X:Int = 0
		Const BIRD_Y:Int = 1
		
		Const CLOUD_NUM:Int = 4
		Const CLOUD_APPEAR_Y:Int = -50
		Const CLOUD_END_Y:Int = -100
		Const CLOUD_GROUP_COUNT:Int = 3
		
		Const DEGREE_VELOCITY:Int = 10
		
		Const EMERALD_DISPLAY_COUNT:Int = 80
		Const END_DISPLAY_COUNT:Int = 45
		
		Const ENDING_NORMAL:Int = 0
		Const FADE_FILL_HEIGHT:Int = 40
		Const FADE_FILL_WIDTH:Int = 40
		
		Const FALL_COUNT:Int = 60
		
		Const FLOAT_RANGE:Int = 10
		
		Const OFFSET_RANGE:Int = 12
		Const OFFSET_SPEED:Int = DEGREE_VELOCITY ' 10
		
		Const PLANE_FLY_IN_FRAME:Int = 2
		Const PLANE_FLY_OUT_VEL_Y:Int = -10
		
		Global PLANE_DES_X:Int = ((-SCREEN_WIDTH) * 2) ' Const
		Global PLANE_START_X:Int = (SCREEN_WIDTH + 50) ' Const
		Global PLANE_START_Y:Int = ((SCREEN_HEIGHT / 2) + PLAYER_OFFSET_TO_PLANE_Y) ' Const ' Shr 1
		Global PLANE_TOUCH_DOWN_DES_X:Int = ((SCREEN_WIDTH / 2) + 10) ' Const ' Shr 1
		Global PLANE_VEL_X:Int = ((PLANE_TOUCH_DOWN_DES_X - PLANE_START_X) / 5) ' Const
		
		Const PLAYER_OFFSET_TO_PLANE_X:Int = 10
		Const PLAYER_OFFSET_TO_PLANE_Y:Int = 34
		
		Const SCALE_VELOCITY:Float = 0.03
		
		Const SPEED_LIGHT_NUM_PER_FRAME:Int = 2
		Const SPEED_LIGHT_VELOCITY:Int = 60
		
		Global WORD_DESTINY_1:Int = ((SCREEN_HEIGHT / 2) - 72) ' Const ' Shr 1
		Global WORD_DESTINY_2:Int = (SCREEN_HEIGHT - 52) ' Const
		Global WORD_START:Int = (SCREEN_HEIGHT + 72) ' Const
		
		Const WORD_VELOCITY:Int = -8
		
		' States:
		Const STATE_FALLING:Int = 1
		Const STATE_TOUCH_DOWN:Int = 2
		Const STATE_CLOUD_MOVE_RIGHT:Int = 3
		Const STATE_PLANE_INIT:Int = 4
		Const STATE_PLANE_SMILE:Int = 5
		Const STATE_PLANE_BIRD:Int = 6
		Const STATE_PLANE_LOOK_UP_1:Int = 7
		Const STATE_PLANE_LOOK_UP_2:Int = 8
		Const STATE_PLANE_LAST_WAIT:Int = 9
		Const STATE_PLANE_JUMPING:Int = 10
		Const STATE_SHOW_BIG_IMAGE:Int = 11
		Const STATE_CREDIT:Int = 12
		Const STATE_NEED_EMERALD:Int = 13
		Const STATE_INTERRUPT:Int = 14
		
		' Global variable(s):
		Global CLOUD_GROUP_OFFSET:Int[] = [0, -40, -80, -120]
		
		Global CLOUD_GROUP_START_X:Int = CLOUD_APPEAR_Y
		Global CLOUD_GROUP_START_Y:Int = -30
		
		Global CLOUD_GROUP_VEL_X:Int = 20
		Global CLOUD_GROUP_VEL_Y:Int = 20
		
		Global cloudInfoArray:Int[][] = [[0, 0], [0, 0], [0, 0], [0, 0]]
		
		Global endingBackGround:MFImage
		Global creditImage:MFImage
		Global endingWordImage:MFImage
		Global speedLight:MFImage
		
		Global cloudDrawer:AnimationDrawer
		Global needEmeraldDrawer:AnimationDrawer
		Global planeDrawer:AnimationDrawer
		Global planeHeadDrawer:AnimationDrawer
		Global skipDrawer:AnimationDrawer
		
		Global birdDrawer:AnimationDrawer[]
		
		Global preFadeAlpha:Int
		
		Global fadeAlpha:Int = FADE_FILL_WIDTH
		Global fadeFromValue:Int
		
		'Global fadeRGB:Int[] = New Int[FADE_FILL_WIDTH*FADE_FILL_HEIGHT]
		Global fadeColor:Int
		Global fadeToValue:Int
		Global fading:Bool
		
		Global speedLightVec:Stack<Int[]>
		
		' Fields:
		Field isSkipPressed:Bool
		Field cloudAppearFlag:Bool
		
		Field lookUpImage:MFImage
		Field bigPoseImage:MFImage
		
		Field interruptDrawer:AnimationDrawer
		
		Field playerScale:Float
		
		Field interrupt_state:Int
		
		Field degree:Int
		Field endcount:Int
		
		Field needEmeraldCount:Int
		
		Field cloudGroupCount:Int
		Field cloudGroupX:Int
		Field cloudGroupY:Int
		
		Field planeOffsetDegree:Int
		Field planeOffsetY:Int
		
		Field playerAccX:Int
		Field playerAccY:Int
		
		Field preCharacterX:Int
		Field preCharacterY:Int
		
		Field characterX:Int
		Field characterY:Int
		
		Field backGroundY:Int
		
		Field playerVelX:Int
		Field playerVelY:Int
		
		Field word1Y:Int
		Field word2Y:Int
		
		Field birdX:Int
		
		Field birdInfo:Int[][]
	Public
		' Functions:
		Function fadeInitAndStart:Void(from:Int, dest:Int)
			fadeFromValue = from
			fadeToValue = dest
			fadeAlpha = fadeFromValue
			
			preFadeAlpha = -1
			
			fading = True
		End
		
		' This implementation will be replaced eventually. (Software)
		Function drawFadeBase:Void(g:MFGraphics, vel2:Int)
			fadeAlpha = MyAPI.calNextPosition(Double(fadeAlpha), Double(fadeToValue), 1, vel2, 3.0)
			
			If (fadeAlpha <> 0) Then
				If (preFadeAlpha <> fadeAlpha) Then
					#Rem
						For Local w:= 0 Until FADE_FILL_WIDTH
							For Local h:= 0 Until FADE_FILL_HEIGHT
								fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl 24) & MFGraphics.COLOR_MASK_ALPHA) | (fadeRGB[(h * FADE_FILL_HEIGHT) + w] & MapManager.END_COLOR) ' FADE_FILL_WIDTH
							Next
						Next
					#End
					
					' Encode the current alpha value into the fade-color.
					fadeColor = MFGraphics.encodeAlpha(fadeColor, fadeAlpha)
					
					preFadeAlpha = fadeAlpha
				EndIf
				
				#Rem
					For Local w:= 0 Until MyAPI.zoomOut(SCREEN_WIDTH) Step FADE_FILL_WIDTH
						For Local h:= 0 Until MyAPI.zoomOut(SCREEN_HEIGHT) Step FADE_FILL_WIDTH
							g.drawRGB(fadeRGB, 0, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_WIDTH, True)
						Next
					Next
				#End
				
				MyAPI.drawScreenRect(g, fadeColor, SCREEN_WIDTH, SCREEN_HEIGHT)
			EndIf
		End
		
		Function drawFade:Void(g:MFGraphics)
			drawFadeBase(g, 3)
		End
		
		Function fadeChangeOver:Bool()
			Return (fadeAlpha = fadeToValue)
		End
		
		' Constructor(s):
		Method New()
			Self.birdInfo = New Int[BIRD_NUM][]
			
			For Local i:= 0 Until BIRD_NUM
				Self.birdInfo[i] = New Int[3]
			Next
			
			If (planeDrawer = Null) Then
				planeDrawer = New Animation("/animation/ending/ending_plane").getDrawer()
			EndIf
			
			If (cloudDrawer = Null) Then
				cloudDrawer = New Animation("/animation/ending/ending_cloud").getDrawer()
			EndIf
			
			If (planeHeadDrawer = Null) Then
				planeHeadDrawer = New Animation("/animation/ending/plane_head").getDrawer()
			EndIf
			
			If (birdDrawer.Length = 0) Then
				birdDrawer = New AnimationDrawer[BIRD_NUM]
				
				Local animation:= New Animation("/animation/ending/ending_bird")
				
				For Local i:= 0 Until BIRD_NUM
					birdDrawer[i] = animation.getDrawer()
				Next
			EndIf
			
			If (speedLight = Null) Then
				speedLight = MFImage.createImage("/animation/ending/speed_light.png")
				
				speedLightVec = New Stack<Int[]>()
			EndIf
			
			If (endingBackGround = Null) Then
				endingBackGround = MFImage.createImage("/animation/ending/ending_bg.png")
			EndIf
			
			If (endingWordImage = Null) Then
				endingWordImage = MFImage.createImage("/animation/ending/ending_word.png")
			EndIf
			
			fading = False
			
			If (needEmeraldDrawer = Null) Then
				needEmeraldDrawer = New Animation("/animation/ending/ed_emerald_hint").getDrawer(0, False, 0)
			EndIf
			
			If (creditImage = Null) Then
				creditImage = MFImage.createImage("/animation/ending/sega_logo_ed.png")
			EndIf
			
			If (skipDrawer = Null) Then
				skipDrawer = New Animation("/animation/skip").getDrawer(0, False, 0)
			EndIf
		End
		
		' Methods:
		Method initialize:Void(type:Int, characterID:Int) ' Method init:Void(type:Int, characterID:Int)
			Self.characterDrawer = New Animation(ENDING_ANIMATION_PATH + CHARACTER_ANIMATION_NAME[characterID]).getDrawer()
			
			Self.lookUpImage = MFImage.createImage(ENDING_ANIMATION_PATH + LOOK_UP_IMAGE_NAME[characterID])
			Self.bigPoseImage = MFImage.createImage("/animation/ending/big_show.png")
			
			Self.state = STATE_INIT
			
			Self.characterID = characterID
			
			' Choose who's driving the plane.
			Self.pilotHeadID = getPilot(characterID)
		End
		
		Method close:Void()
			Animation.closeAnimationDrawer(Self.interruptDrawer)
			Self.interruptDrawer = Null
			
			Animation.closeAnimationDrawer(planeDrawer)
			planeDrawer = Null
			
			Animation.closeAnimationDrawer(cloudDrawer)
			cloudDrawer = Null
			
			Animation.closeAnimationDrawer(planeHeadDrawer)
			planeHeadDrawer = Null
			
			Animation.closeAnimationDrawerArray(birdDrawer)
			birdDrawer = []
			
			Animation.closeAnimationDrawer(needEmeraldDrawer)
			needEmeraldDrawer = Null
			
			Animation.closeAnimationDrawer(skipDrawer)
			skipDrawer = Null
			
			endingBackGround = Null
			endingWordImage = Null
			creditImage = Null
			
			'System.gc()
			'Thread.sleep(100)
		End
		
		Method init:Void()
			' Empty implementation.
		End
		
		Method pause:Void()
			If (Self.state = STATE_INTERRUPT) Then
				'Self.state = STATE_INTERRUPT
				
				interruptInit()
				
				Return
			EndIf
			
			Self.interrupt_state = Self.state
			Self.state = STATE_INTERRUPT
			
			If (Self.interrupt_state = STATE_NEED_EMERALD) Then
				Self.needEmeraldCount = Self.endcount
			EndIf
			
			interruptInit()
			
			Key.touchInterruptInit()
			Key.touchkeyboardInit()
			
			SoundSystem.getInstance().stopBgm(False)
		End
		
		Method logic:Void()
			If (Self.state <> STATE_INTERRUPT) Then
				Self.count += 1
			EndIf
			
			degreeLogic()
			
			Select (Self.state)
				Case STATE_INIT
					Self.characterX = (SCREEN_WIDTH / 2) ' Shr 1
					Self.characterY = (SCREEN_HEIGHT / 2) ' Shr 1
					
					Self.state = STATE_FALLING
					
					cloudInfoArray[0][0] = (SCREEN_WIDTH * 4) / 4
					cloudInfoArray[1][0] = (SCREEN_WIDTH * 3) / 4
					cloudInfoArray[2][0] = (SCREEN_WIDTH * 1) / 4
					cloudInfoArray[3][0] = (SCREEN_WIDTH * 2) / 4
					
					Self.cloudAppearFlag = True
					
					Self.planeX = PLANE_START_X
					Self.planeY = PLANE_START_Y
					
					Self.count = 0
					
					SoundSystem.getInstance().playBgm(SoundSystem.BGM_ENDING_FINAL, False)
				Case STATE_FALLING
					Self.backGroundY = ((Self.count * BACK_GROUND_STOP_Y) / SPEED_LIGHT_VELOCITY)
					
					' From what I under stand, this generates the "light lines" in the scene:
					For Local i:= 0 Until SPEED_LIGHT_NUM_PER_FRAME
						Local position:= New Int[2]
						
						' X, Y:
						position[0] = MyRandom.nextInt(0, SCREEN_WIDTH)
						position[1] = 0 - (i * (-CLOUD_GROUP_START_Y)) ' 30
						
						speedLightVec.Push(position)
					Next
					
					If (Self.count > (FALL_COUNT / 2) + 6) Then ' 36
						Self.cloudAppearFlag = False
					EndIf
					
					If (Self.count >= FALL_COUNT) Then
						Self.state = STATE_TOUCH_DOWN
					EndIf
					
					If (Self.count >= (FALL_COUNT-2)) Then
						Self.planeX += PLANE_VEL_X
					EndIf
				Case STATE_TOUCH_DOWN
					Self.planeX += PLANE_VEL_X
					
					If (Self.characterDrawer.checkEnd()) Then
						Self.planeY += PLANE_FLY_OUT_VEL_Y
						
						Self.characterX = Self.planeX - PLAYER_OFFSET_TO_PLANE_X
						Self.characterY = Self.planeY - PLAYER_OFFSET_TO_PLANE_Y
					EndIf
					
					If (Self.planeX < PLANE_DES_X) Then
						Self.state = STATE_CLOUD_MOVE_RIGHT
						
						Self.cloudGroupX = CLOUD_GROUP_START_X
						Self.cloudGroupY = CLOUD_GROUP_START_Y
						
						For Local i:= 0 Until cloudInfoArray.Length
							cloudInfoArray[i][0] = 0 ' False
							cloudInfoArray[i][1] = CLOUD_GROUP_OFFSET[i]
						Next
						
						Self.cloudGroupCount = 0
					EndIf
				Case STATE_CLOUD_MOVE_RIGHT
					Self.cloudGroupX += CLOUD_GROUP_VEL_X
					Self.cloudGroupY += CLOUD_GROUP_VEL_Y
					
					If (Self.cloudGroupCount = (CLOUD_GROUP_COUNT-1)) Then
						Local nextState:Bool = False
						
						If (Self.cloudGroupY >= (SCREEN_HEIGHT * 2) / (CLOUD_NUM-1)) Then ' 3
							Self.cloudGroupY = (SCREEN_HEIGHT * 2) / (CLOUD_NUM-1) ' 3
						EndIf
						
						If (Self.cloudGroupX >= (SCREEN_WIDTH / 2) + DEGREE_VELOCITY) Then ' Shr 1
							Self.cloudGroupX = (SCREEN_WIDTH / 2) + DEGREE_VELOCITY ' Shr 1
							
							nextState = True
						EndIf
						
						If (nextState) Then
							Self.state = STATE_PLANE_INIT
							
							Self.planeX = Self.cloudGroupX - DEGREE_VELOCITY
							Self.planeY = Self.cloudGroupY + DEGREE_VELOCITY
							
							Self.count = 0
							
							' Magic number: 2 (Animation ID)
							' Not sure if this is right, but it should still work.
							Self.playerActionID = PLANE_FLY_IN_FRAME ' 2
							
							Return
						EndIf
						
						Self.planeX = (Self.cloudGroupX - DEGREE_VELOCITY)
						Self.planeY = (Self.cloudGroupY + DEGREE_VELOCITY)
					EndIf
					
					If (Self.cloudGroupX > SCREEN_WIDTH And Self.cloudGroupCount <> (CLOUD_GROUP_COUNT-1)) Then
						Self.cloudGroupX = CLOUD_GROUP_START_X
						Self.cloudGroupY = CLOUD_GROUP_START_Y
						
						Self.cloudGroupCount += 1
					EndIf
				Case STATE_PLANE_INIT
					' Magic number: 80
					If (Self.count = 80) Then
						' Magic number: 3 (Animation ID)
						' Not sure if this is right, but it'll work for now.
						Self.playerActionID = (PLANE_FLY_IN_FRAME+1) ' 3
						
						Self.state = STATE_PLANE_SMILE
						
						Self.count = 0
						
						Self.pilotSmile = True
					EndIf
				Case STATE_PLANE_SMILE
					' Magic number: 29
					If (Self.count = 29) Then
						Self.state = STATE_PLANE_BIRD
						
						birdInit()
						
						Self.count = 0
					EndIf
				Case STATE_PLANE_BIRD
					If (birdLogic() And Self.count >= 72) Then
						Self.state = STATE_PLANE_LOOK_UP_1
						
						' Magic number: 5 (Animation ID)
						' No idea if this is right, but it works for now.
						Self.playerActionID = (PLANE_FLY_IN_FRAME+2) ' 5
						
						Self.count = 0
						
						Self.pilotSmile = False
					EndIf
				Case STATE_PLANE_LOOK_UP_1
					' Magic number: 64
					If (Self.count >= 64) Then
						Self.count = 0
						
						Self.state = STATE_PLANE_LOOK_UP_2
					EndIf
				Case STATE_PLANE_LOOK_UP_2
					' Magic number: 64
					If (Self.count >= 64) Then
						' Magic number: 6 (Animation ID)
						' Again, no idea about this, but it works for now.
						Self.playerActionID = (PLANE_FLY_IN_FRAME+3) ' 6
						
						Self.count = 0
						
						Self.state = STATE_PLANE_LAST_WAIT
					EndIf
				Case STATE_PLANE_LAST_WAIT
					' Magic number: 16
					If (Self.count >= 16) Then
						' Magic number: 7 (Animation ID)
						Self.playerActionID = (PLANE_FLY_IN_FRAME+4) ' 7
						
						' Magic numbers: {18, -18}, {-2, 2} (X, Y)
						Self.playerVelX = 18
						Self.playerVelY = -18
						
						Self.playerAccX = -2
						Self.playerAccY = 2
						
						Self.preCharacterX = (Self.characterX + Self.playerVelX)
						Self.preCharacterY = (Self.characterY + Self.playerVelY)
						
						Self.state = STATE_PLANE_JUMPING
						
						Self.word1Y = 0
						Self.word2Y = 0
						
						Self.count = 0
						
						Self.playerScale = 1.0
					EndIf
				Case STATE_PLANE_JUMPING
					Self.playerVelX += Self.playerAccX
					Self.playerVelY += Self.playerAccY
					
					Self.characterX += Self.playerVelX
					Self.characterY += Self.playerVelY
					
					Self.playerScale += SCALE_VELOCITY
					
					If (Self.characterX < Self.preCharacterX And Self.playerVelX < 0) Then
						Self.state = STATE_SHOW_BIG_IMAGE
						
						Self.characterX -= Self.playerVelX
						Self.characterY -= Self.playerVelY
						
						fadeInitAndStart(0, 0)
					EndIf
					
					Self.word1Y += WORD_VELOCITY
					
					If (Self.word1Y <= WORD_DESTINY_1) Then
						Self.word1Y = WORD_DESTINY_1
					EndIf
					
					' Magic number: 70
					If (Self.count > 70) Then
						Self.word2Y += WORD_VELOCITY
						
						If (Self.word2Y <= WORD_DESTINY_2) Then
							Self.word2Y = WORD_DESTINY_2
						EndIf
					EndIf
				Case STATE_SHOW_BIG_IMAGE
					Self.word1Y += WORD_VELOCITY
					
					If (Self.word1Y <= WORD_DESTINY_1) Then
						Self.word1Y = WORD_DESTINY_1
					EndIf
					
					' Magic numbers: 70, 16
					If (Self.count > 70) Then
						If (Self.word2Y <= WORD_DESTINY_2) Then
							Self.word2Y = WORD_DESTINY_2
						Else
							Self.word2Y += WORD_VELOCITY
							
							Self.endcount = 0
						EndIf
						
						If (Self.word2Y = WORD_DESTINY_2) Then
							Self.endcount += 1
							
							If (Self.endcount = END_DISPLAY_COUNT) Then
								fadeInitAndStart(0, 255)
							ElseIf (Self.endcount > (END_DISPLAY_COUNT + 16) And fadeChangeOver()) Then ' (END_DISPLAY_COUNT + ?)
								Self.state = STATE_CREDIT
								
								creditInit()
							EndIf
						EndIf
					EndIf
				Case STATE_CREDIT
					If (Key.touchopeningskip.IsButtonPress() And Not Self.isSkipPressed) Then
						Self.isSkipPressed = True
						
						SoundSystem.getInstance().stopBgm(False)
						
						If (SpecialStageState.emeraldMissed()) Then
							fadeInitAndStart(0, 255)
							
							' Magic number: 30
							Self.endcount = 30
						Else
							fadeInitAndStart(0, 255)
							
							' Magic number: 10
							Self.endcount = 10
						EndIf
					EndIf
					
					' Magic numbers: 10, 26
					If (Self.endcount >= 10 And Self.endcount < 26) Then
						Self.endcount += 1
						
						If (Self.endcount >= 26 And fadeChangeOver()) Then
							Standard2.splashinit(True)
							
							State.setState(STATE_TITLE)
						EndIf
					EndIf
					
					' Magic numbers: 30, 46
					If (Self.endcount >= 30) Then
						Self.endcount += 1
						
						If (Self.endcount >= 46 And fadeChangeOver()) Then
							Self.state = STATE_NEED_EMERALD
							
							fadeInitAndStart(255, 0)
							
							Self.endcount = 0
						EndIf
					EndIf
				Case STATE_NEED_EMERALD
					If (fadeChangeOver()) Then
						Self.endcount += 1
						
						If (Self.endcount = EMERALD_DISPLAY_COUNT) Then
							fadeInitAndStart(0, 255)
							
							Key.touchOpeningClose()
						ElseIf ((Self.endcount > EMERALD_DISPLAY_COUNT) And fadeChangeOver()) Then
							SoundSystem.getInstance().stopBgm(False)
							
							Standard2.splashinit(True)
							
							State.setState(STATE_TITLE)
						EndIf
					EndIf
				Case STATE_INTERRUPT
					interruptLogic()
				Default
					' Nothing so far.
			End Select
		End
		
		Method draw:Void(g:MFGraphics)
			MyAPI.drawImage(g, endingBackGround, (SCREEN_WIDTH / 2), Self.backGroundY, TOP|HCENTER) ' Shr 1
			
			Select (Self.state)
				Case STATE_FALLING
					Self.characterDrawer.draw(g, 0, Self.characterX, Self.characterY, True, 0)
				Case STATE_TOUCH_DOWN
					drawPlane(g)
					
					Self.characterDrawer.draw(g, STATE_FALLING, Self.characterX, Self.characterY, False, 0)
				Case STATE_CLOUD_MOVE_RIGHT
					For Local i:= 0 Until cloudInfoArray.Length
						Local cloud:= cloudInfoArray[i]
						
						cloud[0] += CLOUD_RIGHT_SPEED[i]
						
						cloudDrawer.draw(g, i, cloud[0] + Self.cloudGroupX, cloud[1] + Self.cloudGroupY, False, 0)
					Next
					
					drawPlane(g)
					
					Self.characterX = (Self.planeX - PLAYER_OFFSET_TO_PLANE_X)
					Self.characterY = (Self.planeY - PLAYER_OFFSET_TO_PLANE_Y)
					
					Self.characterDrawer.draw(g, 2, Self.characterX, Self.characterY, True, 0) ' (g, PLANE_FLY_IN_FRAME, ...)
				Case STATE_PLANE_INIT, STATE_PLANE_SMILE, STATE_PLANE_BIRD, STATE_PLANE_LOOK_UP_1, STATE_PLANE_LOOK_UP_2, STATE_PLANE_LAST_WAIT, STATE_PLANE_JUMPING
					cloudRightLogic(g)
					
					' Check if the birds exist yet:
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw1(g)
					EndIf
					
					drawPlane(g)
					
					If (Self.state <> STATE_PLANE_JUMPING) Then
						Self.characterX = (Self.planeX - PLAYER_OFFSET_TO_PLANE_X)
						Self.characterY = (Self.planeY - PLAYER_OFFSET_TO_PLANE_Y) + Self.planeOffsetY
					EndIf
					
					If (Self.state = STATE_PLANE_JUMPING) Then
						g.saveCanvas()
						
						g.translateCanvas(Self.characterX, Self.characterY)
						g.scaleCanvas(Self.playerScale, Self.playerScale)
						
						Self.characterDrawer.draw(g, Self.playerActionID, 0, 0, ANIMATION_LOOP[Self.playerActionID], 0)
						
						g.restoreCanvas()
					Else
						Self.characterDrawer.draw(g, Self.playerActionID, Self.characterX, Self.characterY, ANIMATION_LOOP[Self.playerActionID], 0)
					EndIf
					
					If (Self.characterDrawer.checkEnd()) Then
						Select (Self.playerActionID)
							Case STATE_CLOUD_MOVE_RIGHT
								' Magic number: 4 (Animation ID)
								' I have no idea if this is correct or not.
								Self.playerActionID = (PLANE_FLY_IN_FRAME+1) ' 4
						End Select
					EndIf
					
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw2(g)
					EndIf
					
					If (Self.state = STATE_PLANE_LOOK_UP_1) Then
						' Magic number: 3 (Animation ID)
						' Again, not sure about this one.
						MyAPI.drawImage(g, Self.lookUpImage, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), PLANE_FLY_IN_FRAME) ' 3 ' Shr 1
					EndIf
					
					If (Self.state = STATE_PLANE_JUMPING) Then
						MyAPI.drawImage(g, endingWordImage, WORD_PARAM[0][0], WORD_PARAM[0][1], WORD_PARAM[0][2], WORD_PARAM[0][3], 0, (SCREEN_WIDTH / 2), Self.word1Y, 17) ' Shr 1
						MyAPI.drawImage(g, endingWordImage, WORD_PARAM[1][0], WORD_PARAM[1][1], WORD_PARAM[1][2], WORD_PARAM[1][3], 0, (SCREEN_WIDTH / 2), Self.word2Y, 17) ' Shr 1
					EndIf
				Case STATE_SHOW_BIG_IMAGE
					cloudRightLogic(g)
					
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw1(g)
					EndIf
					
					drawPlane(g)
					
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw2(g)
					EndIf
					
					' Magic numnber: 3
					MyAPI.drawImage(g, Self.bigPoseImage, (Self.characterID Mod 2) * 128, (Self.characterID / 2) * 128, 128, 128, 0, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), 3) ' Shr 1
					
					MyAPI.drawImage(g, endingWordImage, WORD_PARAM[0][0], WORD_PARAM[0][1], WORD_PARAM[0][2], WORD_PARAM[0][3], 0, (SCREEN_WIDTH / 2), Self.word1Y, 17) ' Shr 1
					MyAPI.drawImage(g, endingWordImage, WORD_PARAM[1][0], WORD_PARAM[1][1], WORD_PARAM[1][2], WORD_PARAM[1][3], 0, (SCREEN_WIDTH / 2), Self.word2Y, 17) ' Shr 1
					
					drawFade(g)
				Case STATE_CREDIT
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					' Magic number: 3
					MyAPI.drawImage(g, creditImage, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), 3) ' Shr 1
					
					skipDrawer.setActionId(Int(Key.touchopeningskip.Isin()))
					skipDrawer.draw(g, 0, SCREEN_HEIGHT)
					
					drawFade(g)
				Case STATE_NEED_EMERALD
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					needEmeraldDrawer.setActionId(0)
					needEmeraldDrawer.draw(g, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2) ' Shr 1
					
					needEmeraldDrawer.setActionId(1)
					needEmeraldDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
					
					drawFade(g)
				Case STATE_INTERRUPT
					interruptDraw(g)
			End Select
			
			If ((Self.state = STATE_FALLING Or Self.state = STATE_TOUCH_DOWN) And Self.backGroundY < CLOUD_APPEAR_Y) Then
				cloudUpLogic(g)
			EndIf
			
			speedLightLogic(g)
		End
	Private
		' Methods:
		Method speedLightLogic:Void(g:MFGraphics)
			Local i:= 0
			
			While (i < speedLightVec.Length)
				Local position:= speedLightVec.Get(i)
				position[1] += SPEED_LIGHT_VELOCITY
				
				If (position[1] > SCREEN_HEIGHT + speedLight.getHeight()) Then
					speedLightVec.Remove(i)
					
					i -= 1
				Else
					MyAPI.drawImage(g, speedLight, position[0], SCREEN_HEIGHT - position[1], 17)
				EndIf
				
				i += 1
			Wend
		End
		
		Method cloudUpLogic:Void(g:MFGraphics)
			For Local i:= 0 Until cloudInfoArray.Length
				Local position:= cloudInfoArray[i]
				
				position[1] += CLOUD_UP_SPEED[i]
				
				If (position[1] > SCREEN_HEIGHT + FADE_FILL_WIDTH And Self.cloudAppearFlag) Then
					position[1] = -CLOUD_GROUP_VEL_Y
					
					position[0] = MyRandom.nextInt(0, SCREEN_WIDTH)
				EndIf
				
				cloudDrawer.draw(g, i, position[0], SCREEN_HEIGHT - position[1], False, 0)
			Next
		End
		
		Method cloudRightLogic:Void(g:MFGraphics)
			For Local i:= 0 Until cloudInfoArray.Length
				Local cloud:= cloudInfoArray[i]
				
				cloud[0] += CLOUD_RIGHT_SPEED[i]
				
				cloudDrawer.setActionId(i)
				
				If (Self.cloudGroupX + cloud[0] > SCREEN_WIDTH + cloudDrawer.getCurrentFrameWidth()) Then
					cloud[0] = ((-cloudDrawer.getCurrentFrameWidth()) / 2) - Self.cloudGroupX ' Shr 1
				EndIf
				
				cloudDrawer.draw(g, i, cloud[0] + Self.cloudGroupX, cloud[1] + Self.cloudGroupY, False, 0)
			Next
		End
		
		Method drawPlane:Void(g:MFGraphics)
			If (Self.state >= STATE_PLANE_INIT) Then
				Self.planeOffsetY = getPlaneOffset()
			Else
				Self.planeOffsetY = 0
			EndIf
			
			' Draw the plane.
			planeDrawer.draw(g, Self.planeX, Self.planeY + Self.planeOffsetY)
			
			' Draw the pilot's head. (The X and Y offsets seem to just be there to position the head properly)
			planeHeadDrawer.draw(g, Self.pilotHeadID + Int(Self.pilotSmile), Self.planeX + 3, Self.planeOffsetY + (Self.planeY - 22), True, 0)
		End
		
		Method getPlaneOffset:Int()
			Self.planeOffsetDegree += OFFSET_SPEED
			
			Return ((MyAPI.dSin(Self.planeOffsetDegree) * OFFSET_RANGE) / 100) + OFFSET_SPEED
		End
		
		' This could use some work, but it should work fine.
		Method birdInit:Void()
			Const HALF_BIRD_NUM:= (BIRD_NUM/2) ' 5
			Const HALF_BIRD_NUM_INDEX:= (HALF_BIRD_NUM-1) ' 4 ' ((BIRD_NUM-BIRD_OFFSET) / 2)
			
			' Magic numbers: 30, 20, 15, -14
			
			' Top half?
			For Local i:= HALF_BIRD_NUM_INDEX To 0 Step -1 ' Until 0
				Self.birdInfo[i][1] = ((Self.planeY - ((HALF_BIRD_NUM - i) * BIRD_SPACE_1)) - 30) - 20
				Self.birdInfo[i][0] = (HALF_BIRD_NUM - i) * BIRD_SPACE_1 ' ((BIRD_SPACE_1 / 2) - i)
				Self.birdInfo[i][2] = MyRandom.nextInt(360)
			Next
			
			' Bottom half?
			For Local i:= HALF_BIRD_NUM Until BIRD_NUM
				Self.birdInfo[i][1] = ((Self.planeY - ((HALF_BIRD_NUM_INDEX - i) * BIRD_SPACE_2)) - 15) - 20 ' (BIRD_SPACE_2 + BIRD_Y) ' 15
				Self.birdInfo[i][0] = (HALF_BIRD_NUM_INDEX - i) * -BIRD_SPACE_2
				Self.birdInfo[i][2] = MyRandom.nextInt(360)
			Next
			
			Self.birdX = SCREEN_WIDTH + 30
		End
		
		Method birdLogic:Bool()
			Self.birdX -= BIRD_VELOCITY
			
			' Magic number: 40
			If (Self.birdX >= (SCREEN_WIDTH / 2) + 40) Then ' Shr 1 ' FADE_FILL_WIDTH
				Return False
			EndIf
			
			Self.birdX = (SCREEN_WIDTH / 2) + 40 ' Shr 1 ' FADE_FILL_WIDTH
			
			Return True
		End
		
		Method birdDraw1:Void(g:MFGraphics)
			For Local i:= 0 Until (BIRD_NUM / 2)
				Local bird:= Self.birdInfo[i]
				
				birdDrawer[i].draw(g, Self.birdX + bird[0], bird[1] + getOffsetY(bird[2]))
			Next
		End
		
		Method birdDraw2:Void(g:MFGraphics)
			For Local i:= (BIRD_NUM / 2) Until BIRD_NUM
				Local bird:= Self.birdInfo[i]
				
				birdDrawer[i].draw(g, Self.birdX + bird[0], bird[1] + getOffsetY(bird[2]))
			Next
		End
		
		Method degreeLogic:Void()
			Self.degree += DEGREE_VELOCITY
			Self.degree Mod= 360
		End
		
		Method getOffsetY:Int(degreeOffset:Int)
			Return (MyAPI.dSin(Self.degree + degreeOffset) * DEGREE_VELOCITY) / 100 ' * 10
		End
		
		Method creditInit:Void()
			fadeInitAndStart(0, 0)
			
			SoundSystem.getInstance().stopBgm(False)
			SoundSystem.getInstance().playBgm(SoundSystem.BGM_CREDIT)
			
			Key.touchOpeningInit()
			
			Self.endcount = 0
			Self.isSkipPressed = False
		End
		
		Method interruptInit:Void()
			If (Self.interruptDrawer = Null) Then
				Key.touchInterruptInit()
				
				Self.interruptDrawer = Animation.getInstanceFromQi("/animation/utl_res/suspend_resume.dat")[0].getDrawer(0, True, 0)
			EndIf
		End
		
		Method interruptLogic:Void()
			State.fadeInitAndStart(0, 0)
			
			SoundSystem.getInstance().stopBgm(False)
			
			If (Key.press(Key.B_S2)) Then
				' Nothing so far.
			EndIf
			
			If (Key.press(Key.B_BACK) Or (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress())) Then
				SoundSystem.getInstance().playSe(SoundSystem.SE_107)
				
				Key.touchInterruptClose()
				Key.touchkeyboardClose()
				
				If (Self.interrupt_state <= STATE_CREDIT) Then
					Self.state = STATE_CREDIT
					
					creditInit()
				ElseIf (Self.interrupt_state = STATE_NEED_EMERALD) Then
					fadeInitAndStart(0, 0)
					
					Self.state = STATE_NEED_EMERALD
					
					Self.endcount = Self.needEmeraldCount
				EndIf
				
				Key.clear()
			EndIf
		End
		
		Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId(Int(Key.touchinterruptreturn.Isin()))
			Self.interruptDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
		End
End