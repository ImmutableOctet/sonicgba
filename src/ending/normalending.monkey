Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import ending.plainending
	
	Import platformstandard.standard2
	
	Import sonicgba.mapmanager
	
	Import state.specialstagestate
	Import state.titlestate
	
	'Import com.sega.mobile.define.mdphone
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
		Const OFFSET_SPEED:Int = 10
		
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
		
		' This will be replaced eventually. (Software fading)
		Global fadeRGB:Int[] = New Int[FADE_FILL_WIDTH*FADE_FILL_HEIGHT]
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
		
		Field pilotHeadID:Int
		
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
		Method init:Void(type:Int, characterID:Int)
			Self.characterDrawer = New Animation(ENDING_ANIMATION_PATH + CHARACTER_ANIMATION_NAME[characterID]).getDrawer()
			
			Self.lookUpImage = MFImage.createImage(ENDING_ANIMATION_PATH + LOOK_UP_IMAGE_NAME[characterID])
			Self.bigPoseImage = MFImage.createImage("/animation/ending/big_show.png")
			
			Self.state = STATE_INIT
			
			Self.characterID = characterID
			
			' Choose who's driving the plane.
			Self.pilotHeadID = getPilot(characterID)
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
		
		Public Method draw:Void(g:MFGraphics)
			MyAPI.drawImage(g, endingBackGround, (SCREEN_WIDTH / 2), Self.backGroundY, 17) ' Shr 1
			
			Select (Self.state)
				Case STATE_FALLING
					Self.characterDrawer.draw(g, 0, Self.characterX, Self.characterY, True, 0)
					break
				Case STATE_TOUCH_DOWN
					drawPlane(g)
					Self.characterDrawer.draw(g, STATE_FALLING, Self.characterX, Self.characterY, False, 0)
					break
				Case STATE_CLOUD_MOVE_RIGHT
					For (Int i = 0; i < cloudInfoArray.Length; i += 1)
						Int[] iArr = cloudInfoArray[i]
						iArr[0] = iArr[0] + CLOUD_RIGHT_SPEED[i]
						cloudDrawer.draw(g, i, cloudInfoArray[i][0] + Self.cloudGroupX, cloudInfoArray[i][1] + Self.cloudGroupY, False, 0)
					EndIf
					drawPlane(g)
					Self.characterX = Self.planeX - STATE_PLANE_JUMPING
					Self.characterY = Self.planeY - PLAYER_OFFSET_TO_PLANE_Y
					Self.characterDrawer.draw(g, STATE_TOUCH_DOWN, Self.characterX, Self.characterY, True, 0)
					break
				Case STATE_PLANE_INIT
				Case STATE_PLANE_SMILE
				Case STATE_PLANE_BIRD
				Case STATE_PLANE_LOOK_UP_1
				Case STATE_PLANE_LOOK_UP_2
				Case STATE_PLANE_LAST_WAIT
				Case STATE_PLANE_JUMPING
					cloudRightLogic(g)
					
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw1(g)
					EndIf
					
					drawPlane(g)
					
					If (Self.state <> STATE_PLANE_JUMPING) Then
						Self.characterX = Self.planeX - STATE_PLANE_JUMPING
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
								Self.playerActionID = STATE_PLANE_INIT
								break
						EndIf
					EndIf
					
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw2(g)
					EndIf
					
					If (Self.state = STATE_PLANE_LOOK_UP_1) Then
						MyAPI.drawImage(g, Self.lookUpImage, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), STATE_CLOUD_MOVE_RIGHT) ' Shr 1
					EndIf
					
					If (Self.state = STATE_PLANE_JUMPING) Then
						MyAPI.drawImage(g, endingWordImage, WORD_PARAM[0][0], WORD_PARAM[0][1], WORD_PARAM[0][2], WORD_PARAM[0][3], 0, (SCREEN_WIDTH / 2), Self.word1Y, 17) ' Shr 1
						MyAPI.drawImage(g, endingWordImage, WORD_PARAM[1][0], WORD_PARAM[1][1], WORD_PARAM[1][2], WORD_PARAM[1][3], 0, (SCREEN_WIDTH / 2), Self.word2Y, 17) ' Shr 1
						break
					EndIf
					
					break
				Case STATE_SHOW_BIG_IMAGE
					cloudRightLogic(g)
					
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw1(g)
					EndIf
					
					drawPlane(g)
					
					If (Self.state >= STATE_PLANE_BIRD) Then
						birdDraw2(g)
					EndIf
					
					MyAPI.drawImage(g, Self.bigPoseImage, (Self.characterID Mod 2) * 128, (Self.characterID / 2) * 128, 128, 128, 0, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), STATE_CLOUD_MOVE_RIGHT) ' Shr 1
					MyAPI.drawImage(g, endingWordImage, WORD_PARAM[0][0], WORD_PARAM[0][1], WORD_PARAM[0][2], WORD_PARAM[0][3], 0, (SCREEN_WIDTH / 2), Self.word1Y, 17) ' Shr 1
					MyAPI.drawImage(g, endingWordImage, WORD_PARAM[1][0], WORD_PARAM[1][1], WORD_PARAM[1][2], WORD_PARAM[1][3], 0, (SCREEN_WIDTH / 2), Self.word2Y, 17) ' Shr 1
					drawFade(g)
					break
				Case STATE_CREDIT
					g.setColor(0)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, creditImage, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), STATE_CLOUD_MOVE_RIGHT) ' Shr 1
					skipDrawer.setActionId((Key.touchopeningskip.Isin() ? 1 : 0) + 0)
					skipDrawer.draw(g, 0, SCREEN_HEIGHT)
					drawFade(g)
					break
				Case STATE_NEED_EMERALD
					g.setColor(0)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					needEmeraldDrawer.setActionId(0)
					needEmeraldDrawer.draw(g, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2) ' Shr 1
					needEmeraldDrawer.setActionId(STATE_FALLING)
					needEmeraldDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
					drawFade(g)
					break
				Case STATE_INTERRUPT
					interruptDraw(g)
					break
			EndIf
			If ((Self.state = STATE_FALLING Or Self.state = STATE_TOUCH_DOWN) And Self.backGroundY < CLOUD_APPEAR_Y) Then
				cloudUpLogic(g)
			EndIf
			
			speedLightLogic(g)
		End
		
		Private Method speedLightLogic:Void(g:MFGraphics)
			Int i = 0
			While (i < speedLightVec.size()) {
				Int[] position = (Int[]) speedLightVec.elementAt(i)
				position[1] = position[1] + SPEED_LIGHT_VELOCITY
				
				If (position[1] > SCREEN_HEIGHT + speedLight.getHeight()) Then
					speedLightVec.Remove(i)
					i -= 1
				Else
					MyAPI.drawImage(g, speedLight, position[0], SCREEN_HEIGHT - position[1], 17)
				EndIf
				
				i += 1
			EndIf
		End
		
		Private Method cloudUpLogic:Void(g:MFGraphics)
			For (Int i = 0; i < cloudInfoArray.Length; i += 1)
				Int[] position = cloudInfoArray[i]
				position[1] = position[1] + CLOUD_UP_SPEED[i]
				
				If (position[1] > SCREEN_HEIGHT + FADE_FILL_WIDTH And Self.cloudAppearFlag) Then
					position[1] = -20
					position[0] = MyRandom.nextInt(0, SCREEN_WIDTH)
				EndIf
				
				cloudDrawer.draw(g, i, position[0], SCREEN_HEIGHT - position[1], False, 0)
			EndIf
		End
		
		Private Method cloudRightLogic:Void(g:MFGraphics)
			For (Int i = 0; i < cloudInfoArray.Length; i += 1)
				Int[] iArr = cloudInfoArray[i]
				iArr[0] = iArr[0] + CLOUD_RIGHT_SPEED[i]
				cloudDrawer.setActionId(i)
				
				If (Self.cloudGroupX + cloudInfoArray[i][0] > SCREEN_WIDTH + cloudDrawer.getCurrentFrameWidth()) Then
					cloudInfoArray[i][0] = ((-cloudDrawer.getCurrentFrameWidth()) / 2) - Self.cloudGroupX ' Shr 1
				EndIf
				
				cloudDrawer.draw(g, i, cloudInfoArray[i][0] + Self.cloudGroupX, cloudInfoArray[i][1] + Self.cloudGroupY, False, 0)
			EndIf
		End
		
		Private Method drawPlane:Void(g:MFGraphics)
			Int i
			
			If (Self.state >= STATE_PLANE_INIT) Then
				Self.planeOffsetY = getPlaneOffset()
			Else
				Self.planeOffsetY = 0
			EndIf
			
			planeDrawer.draw(g, Self.planeX, Self.planeY + Self.planeOffsetY)
			AnimationDrawer animationDrawer = planeHeadDrawer
			
			If (Self.pilotSmile) Then
				i = STATE_FALLING
			Else
				i = 0
			EndIf
			
			animationDrawer.draw(g, Self.pilotHeadID + i, Self.planeX + STATE_CLOUD_MOVE_RIGHT, Self.planeOffsetY + (Self.planeY - 22), True, 0)
		End
		
		Private Method getPlaneOffset:Int()
			Self.planeOffsetDegree += STATE_PLANE_JUMPING
			Return ((Sin(Self.planeOffsetDegree) * STATE_CREDIT) / 100) + STATE_CREDIT
		End
		
		Private Method birdInit:Void()
			Int i
			For (i = STATE_PLANE_INIT; i >= 0; i -= 1)
				Self.birdInfo[i][1] = ((Self.planeY - ((STATE_PLANE_SMILE - i) * STATE_PLANE_JUMPING)) - 30) - 20
				Self.birdInfo[i][0] = (STATE_PLANE_SMILE - i) * STATE_PLANE_JUMPING
				Self.birdInfo[i][2] = MyRandom.nextInt(MDPhone.SCREEN_WIDTH)
			EndIf
			For (i = STATE_PLANE_SMILE; i < STATE_PLANE_JUMPING; i += 1)
				Self.birdInfo[i][1] = ((Self.planeY - ((STATE_PLANE_INIT - i) * STATE_INTERRUPT)) - 15) - 20
				Self.birdInfo[i][0] = (STATE_PLANE_INIT - i) * -14
				Self.birdInfo[i][2] = MyRandom.nextInt(MDPhone.SCREEN_WIDTH)
			EndIf
			Self.birdX = SCREEN_WIDTH + 30
		End
		
		Private Method birdLogic:Bool()
			Self.birdX -= STATE_TOUCH_DOWN
			
			If (Self.birdX >= (SCREEN_WIDTH / 2) + FADE_FILL_WIDTH) Then ' Shr 1
				Return False
			EndIf
			
			Self.birdX = (SCREEN_WIDTH / 2) + FADE_FILL_WIDTH ' Shr 1
			
			Return True
		End
		
		Private Method birdDraw1:Void(g:MFGraphics)
			For (Int i = 0; i < STATE_PLANE_SMILE; i += 1)
				birdDrawer[i].draw(g, Self.birdX + Self.birdInfo[i][0], Self.birdInfo[i][1] + getOffsetY(Self.birdInfo[i][2]))
			EndIf
		End
		
		Private Method birdDraw2:Void(g:MFGraphics)
			For (Int i = STATE_PLANE_SMILE; i < STATE_PLANE_JUMPING; i += 1)
				birdDrawer[i].draw(g, Self.birdX + Self.birdInfo[i][0], Self.birdInfo[i][1] + getOffsetY(Self.birdInfo[i][2]))
			EndIf
		End
		
		Private Method degreeLogic:Void()
			Self.degree += STATE_PLANE_JUMPING
			Self.degree Mod= MDPhone.SCREEN_WIDTH
		End
		
		Private Method getOffsetY:Int(degreeOffset:Int)
			Return (Sin(Self.degree + degreeOffset) * STATE_PLANE_JUMPING) / 100
		End
		
		Public Function fadeInitAndStart:Void(from:Int, to:Int)
			fadeFromValue = from
			fadeToValue = to
			fadeAlpha = fadeFromValue
			preFadeAlpha = -1
			fading = True
		}
		
		Public Function drawFadeBase:Void(g:MFGraphics, vel2:Int)
			fadeAlpha = MyAPI.calNextPosition((double) fadeAlpha, (double) fadeToValue, STATE_FALLING, vel2, 3.0)
			
			If (fadeAlpha <> 0) Then
				Int w
				Int h
				
				If (preFadeAlpha <> fadeAlpha) Then
					For (w = 0; w < FADE_FILL_WIDTH; w += 1)
						For (h = 0; h < FADE_FILL_WIDTH; h += 1)
							fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl 24) & -16777216) | (fadeRGB[(h * FADE_FILL_WIDTH) + w] & MapManager.END_COLOR)
						EndIf
					EndIf
					preFadeAlpha = fadeAlpha
				EndIf
				
				For (w = 0; w < MyAPI.zoomOut(SCREEN_WIDTH); w += FADE_FILL_WIDTH)
					For (h = 0; h < MyAPI.zoomOut(SCREEN_HEIGHT); h += FADE_FILL_WIDTH)
						g.drawRGB(fadeRGB, 0, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_WIDTH, True)
					EndIf
				EndIf
			EndIf
			
		}
		
		Public Function drawFade:Void(g:MFGraphics)
			drawFadeBase(g, STATE_CLOUD_MOVE_RIGHT)
		}
		
		Public Function fadeChangeOver:Bool()
			Return fadeAlpha = fadeToValue
		}
		
		Private Method creditInit:Void()
			fadeInitAndStart(0, 0)
			SoundSystem.getInstance().stopBgm(False)
			SoundSystem.getInstance().playBgm(33)
			Key.touchOpeningInit()
			Self.endcount = 0
			Self.isSkipPressed = False
		End
		
		Public Method close:Void()
			Animation.closeAnimationDrawer(Self.interruptDrawer)
			Self.interruptDrawer = Null
			Animation.closeAnimationDrawer(planeDrawer)
			planeDrawer = Null
			Animation.closeAnimationDrawer(cloudDrawer)
			cloudDrawer = Null
			Animation.closeAnimationDrawer(planeHeadDrawer)
			planeHeadDrawer = Null
			Animation.closeAnimationDrawerArray(birdDrawer)
			birdDrawer = Null
			endingBackGround = Null
			endingWordImage = Null
			Animation.closeAnimationDrawer(needEmeraldDrawer)
			needEmeraldDrawer = Null
			creditImage = Null
			Animation.closeAnimationDrawer(skipDrawer)
			skipDrawer = Null
			'System.gc()
			try {
				Thread.sleep(100)
			} catch (Exception e) {
				e.printStackTrace()
			EndIf
		End
		
		Public Method init:Void()
		End
		
		Public Method pause:Void()
			
			If (Self.state = STATE_INTERRUPT) Then
				Self.state = STATE_INTERRUPT
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
		
		Private Method interruptInit:Void()
			
			If (Self.interruptDrawer = Null) Then
				Key.touchInterruptInit()
				Self.interruptDrawer = Animation.getInstanceFromQi("/animation/utl_res/suspend_resume.dat")[0].getDrawer(0, True, 0)
			EndIf
			
		End
		
		Private Method interruptLogic:Void()
			State.fadeInitAndStart(0, 0)
			SoundSystem.getInstance().stopBgm(False)
			
			If (Key.press(STATE_TOUCH_DOWN)) Then
			EndIf
			
			If (Key.press(Key.B_BACK) Or (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress())) Then
				SoundSystem.getInstance().playSe(STATE_TOUCH_DOWN)
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
		
		Private Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId((Key.touchinterruptreturn.Isin() ? 1 : 0) + 0)
			Self.interruptDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
		End
End