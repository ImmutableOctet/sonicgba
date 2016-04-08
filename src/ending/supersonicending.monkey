Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import ending.baseending
	
	Import platformstandard.standard2
Public

' Classes:
Class SuperSonicEnding Extends BaseEnding ' Final
	Private
		' Constant variable(s):
		Global CLOUD_VELOCITY:Int[] = [5, 4, 3] ' Const
		Global MOON_PNG_NAME:String[] = ["/ed_ex_moon_bg.png", "/ed_ex_forest.png", "/ed_ex_character.png"] ' Const
		
		Global STAR_POSITION:Int[][] = [[-16, 18], [-73, 96], [93, 70], [47, 95]] ' Const
		Global WORD_PARAM:Int[][] = [[0, 0, 184, 24], [0, 24, 184, 48]] ' Const
		
		Const BGM_ENDING_COUNT:Int = 205
		Const CLOUD_NUM:Int = 10
		Const CLOUD_TYPE:Int = 0
		Const CLOUD_X:Int = 1
		Const CLOUD_Y:Int = 2
		Const MOON_BG_MOVE_FRAME:Int = 56
		Const OFFSET_RANGE:Int = 8
		Const OFFSET_SPEED:Int = 5
		Const PLANE_CATCH_UP_FRAME:Int = 30
		Const PLANE_PULL_DOWN_VEL:Int = 10
		Const SHINING_VEL_H:Int = 4
		Const SHINING_VEL_V:Int = 7
		
		Global WORD_DESTINY_2:Int = (SCREEN_HEIGHT - 40) ' Const
		
		' States:
		Const STATE_MOON_START:Int = 1
		Const STATE_MOON_STAR_SHINING:Int = 2
		Const STATE_MOON_MOVE:Int = 3
		Const STATE_MOON_END:Int = 4
		Const STATE_AFTER_THAT:Int = 5
		Const STATE_TAILS_FLYING:Int = 6
		Const STATE_TAILS_SEARCHING:Int = 7
		Const STATE_TAILS_FIND:Int = 8
		Const STATE_TAILS_PULL_DOWN:Int = 9
		Const STATE_TAILS_CATCH_UP:Int = 10
		Const STATE_CATCH:Int = 11
		Const STATE_CHANGING_FACE:Int = 12
		Const STATE_CONGRATULATION:Int = 13
		Const STATE_PRE_INIT:Int = 14
		Const STATE_CREDIT:Int = 15
		Const STATE_INTERRUPT:Int = 16
		
		' Global variable(s):
		Global MOON_BG_OFFSET_END:Int[] = [-69, 11, 25]
		Global MOON_BG_OFFSET_START:Int[] = [0, 80, 180]
		
		Global creditImage:MFImage
		
		Global skipDrawer:AnimationDrawer
		
		' Fields:
		Field isSkipPressed:Bool
		Field changeState:Bool
		
		Field catchID:Int
		Field catchImage:MFImage[]
		
		Field cloudCount:Int
		Field cloudInfo:Int[][]
		
		Field cloudDrawer:AnimationDrawer
		
		Field congratulationY:Int
		
		Field thankY:Int
		
		Field count:Int
		Field count2:Int
		
		Field moonImage:MFImage[]
		
		Field daysLaterImage:MFImage
		Field endingBgImage:MFImage
		Field endingWordImage:MFImage
		
		Field starDrawer:AnimationDrawer[]
		
		Field SuperSonicShiningDrawer:AnimationDrawer
		Field faceChangeDrawer:AnimationDrawer
		Field interruptDrawer:AnimationDrawer
		Field planeHeadDrawer:AnimationDrawer
		
		Field interrupt_state:Int
		
		Field moonOffset:Int[]
		Field pilotHeadID:Int
		Field planeDegree:Int
		
		Field planeScale:Double ' Float
		
		Field planeOffsetDegree:Int
		Field planeOffsetY:Int
		
		Field shiningX:Int
		Field shiningY:Int
		
		Field starCount:Int
	Public
		' Constructor(s):
		Method New()
			Self.cloudInfo = New Int[CLOUD_NUM][]
			
			For Local i:= 0 Until Self.cloudInfo.Length
				Self.cloudInfo[i] = New Int[3]
			Next
			
			Self.cloudCount = 0
			
			Self.state = STATE_PRE_INIT
			
			Self.moonOffset = New Int[3]
			
			Self.moonImage = New MFImage[MOON_PNG_NAME.Length]
			
			For Local i:= 0 Until Self.moonImage.Length
				Self.moonImage[i] = MFImage.createImage(ENDING_ANIMATION_PATH + MOON_PNG_NAME[i])
			Next
			
			For Local i:= 0 Until Self.moonOffset.Length ' 3
				Self.moonOffset[i] = MOON_BG_OFFSET_START[i]
			Next
		End
		
		' Methods:
		Public Method logic:Void()
			
			If (Self.state <> STATE_INTERRUPT) Then
				Self.count += 1
			EndIf
			
			Int i
			Select (Self.state)
				Case STATE_INIT
					Self.state = STATE_MOON_START
					
					Self.count = 0
					Self.starCount = 0
					
					SoundSystem.getInstance().playBgmSequenceNoLoop(32, 45)
				Case STATE_MOON_START
					
					If (Self.count > STATE_AFTER_THAT) Then
						Self.state = STATE_MOON_STAR_SHINING
					EndIf
					
				Case STATE_MOON_STAR_SHINING
					
					If (Self.starDrawer[3].checkEnd() And Self.count > STATE_MOON_END) Then
						Self.state = STATE_MOON_MOVE
					EndIf
					
				Case STATE_MOON_MOVE
					For (i = 0; i < STATE_MOON_MOVE; i += 1)
						Self.moonOffset[i] = MOON_BG_OFFSET_START[i] + (((MOON_BG_OFFSET_END[i] - MOON_BG_OFFSET_START[i]) * Self.count) / MOON_BG_MOVE_FRAME)
					EndIf
					If (Self.count >= MOON_BG_MOVE_FRAME) Then
						Self.state = STATE_MOON_END
						Self.count = 0
					EndIf
					
				Case STATE_MOON_END
					
					If (Self.count = PLANE_CATCH_UP_FRAME) Then
						State.fadeInitAndStart(STATE_INIT, 255)
					EndIf
					
					If (Self.count > PLANE_CATCH_UP_FRAME And State.fadeChangeOver()) Then
						Self.state = STATE_AFTER_THAT
						State.fading = False
						Self.count = 0
					EndIf
					
				Case STATE_AFTER_THAT
					
					If (Self.count = 160) Then
						State.fadeInitAndStart(255, STATE_INIT)
						Self.state = STATE_TAILS_FLYING
						Self.count = 0
					EndIf
					
				Case STATE_TAILS_FLYING
					
					If (Self.count > STATE_INTERRUPT) Then
						Self.state = STATE_TAILS_SEARCHING
						Self.count = 0
						Self.pilotHeadID = STATE_MOON_END
					EndIf
					
				Case STATE_TAILS_SEARCHING
					
					If (Self.count > 48) Then
						Self.shiningX -= 7
						Self.shiningY += STATE_MOON_END
						
						If (Self.shiningY > 184) Then
							Self.shiningY = 184
						EndIf
						
						If (Self.count > 90) Then
							Self.pilotHeadID = STATE_AFTER_THAT
						EndIf
						
						If (Self.shiningX < -10) Then
							Self.state = STATE_TAILS_PULL_DOWN
							Self.planeY += Self.planeOffsetY
						EndIf
					EndIf
					
				Case STATE_TAILS_PULL_DOWN
					Self.planeY += STATE_TAILS_CATCH_UP
					
					If (Self.planeY > SCREEN_HEIGHT + 80) Then
						Self.state = STATE_TAILS_CATCH_UP
						Self.planeX = (SCREEN_WIDTH * STATE_MOON_MOVE) / STATE_MOON_END
						Self.planeY = SCREEN_HEIGHT + 40
						Self.count = 0
						Self.planeDegree = 0
					EndIf
					
				Case STATE_TAILS_CATCH_UP
					Self.planeDegree = (Self.count * -55) / PLANE_CATCH_UP_FRAME
					Self.planeX = ((SCREEN_WIDTH * STATE_MOON_MOVE) / STATE_MOON_END) + (((-40 - ((SCREEN_WIDTH * STATE_MOON_MOVE) / STATE_MOON_END)) * Self.count) / PLANE_CATCH_UP_FRAME)
					Self.planeY = (SCREEN_HEIGHT + 40) + (((((SCREEN_HEIGHT Shr 1) - STATE_TAILS_CATCH_UP) - (SCREEN_HEIGHT + 40)) * Self.count) / PLANE_CATCH_UP_FRAME)
					Self.planeScale = 0.9d + ((-0.6000000000000001d * ((double) Self.count)) / 30.0)
					
					If (Not Self.changeState And Self.planeX < -80) Then
						State.fadeInitAndStart(STATE_INIT, 255)
						Self.changeState = True
					EndIf
					
					If (Self.changeState And State.fadeChangeOver()) Then
						State.fadeInitAndStart(255, STATE_INIT)
						Self.state = STATE_CATCH
						Self.changeState = False
						Self.count = 0
						Self.catchID = 0
						Self.congratulationY = SCREEN_HEIGHT + 20
						Self.thankY = SCREEN_HEIGHT + 20
					EndIf
					
				Case STATE_CATCH
					
					If (Self.count = 72) Then
						State.fadeInitAndStart(STATE_INIT, 255)
						Self.changeState = True
					EndIf
					
					If (Self.changeState And State.fadeChangeOver()) Then
						Self.changeState = False
						State.fadeInitAndStart(255, STATE_INIT)
						Self.count = 0
						
						If (Self.catchID = 1) Then
							Self.state = STATE_CHANGING_FACE
						Else
							Self.catchID += 1
						EndIf
					EndIf
					
				Case STATE_CHANGING_FACE
					
					If (Self.faceChangeDrawer.checkEnd() And Self.faceChangeDrawer.getActionId() = 1) Then
						Self.state = STATE_CONGRATULATION
						Self.count = 0
					EndIf
					
				Case STATE_CONGRATULATION
					Self.congratulationY = (SCREEN_HEIGHT + 20) + ((((((SCREEN_HEIGHT Shr 1) - 48) - 24) - (SCREEN_HEIGHT + 20)) * Self.count) / STATE_CONGRATULATION)
					
					If (Self.congratulationY < ((SCREEN_HEIGHT Shr 1) - 48) - 24) Then
						Self.congratulationY = ((SCREEN_HEIGHT Shr 1) - 48) - 24
					EndIf
					
					If (Self.count > 27) Then
						Self.thankY = (SCREEN_HEIGHT + 20) + ((((((SCREEN_HEIGHT Shr 1) + 48) - STATE_TAILS_FLYING) - (SCREEN_HEIGHT + 20)) * (Self.count - 27)) / STATE_CONGRATULATION)
						
						If (Self.thankY < WORD_DESTINY_2) Then
							Self.thankY = WORD_DESTINY_2
						EndIf
					EndIf
					
					If (Self.count = 189) Then
						State.fadeInitAndStart(STATE_INIT, 255)
					ElseIf (isOver() And State.fadeChangeOver()) Then
						Self.state = STATE_CREDIT
						creditInit()
					EndIf
					
				Case STATE_PRE_INIT
					Self.daysLaterImage = MFImage.createImage("/animation/ending/ed_fewdays.png")
					Self.planeDrawer = New Animation("/animation/ending/ending_plane").getDrawer()
					Self.planeHeadDrawer = New Animation("/animation/ending/plane_head").getDrawer()
					Self.cloudDrawer = New Animation("/animation/ending/ending_cloud").getDrawer()
					Self.endingBgImage = MFImage.createImage("/animation/ending/ending_bg.png")
					Self.SuperSonicShiningDrawer = New Animation("/animation/ending/Super.sonic_shining").getDrawer()
					Self.planeX = SCREEN_WIDTH Shr 1
					Self.planeY = (SCREEN_HEIGHT Shr 1) + 40
					Self.pilotHeadID = STATE_MOON_STAR_SHINING
					Self.shiningX = 480
					Self.shiningY = -40
					Self.catchImage = New MFImage[STATE_MOON_END]
					For (i = 0; i < STATE_MOON_END; i += 1)
						Self.catchImage[i] = MFImage.createImage("/animation/ending/ending_catch_" + (i + 1) + ".png")
					EndIf
					Self.faceChangeDrawer = New Animation("/animation/ending/ed_SuperSonic_b").getDrawer(STATE_INIT, False, STATE_INIT)
					Self.endingWordImage = MFImage.createImage("/animation/ending/ending_word.png")
					Animation starAnimation = New Animation("/animation/ending/ending_star")
					Self.starDrawer = New AnimationDrawer[STAR_POSITION.Length]
					For (i = 0; i < STAR_POSITION.Length; i += 1)
						Self.starDrawer[i] = starAnimation.getDrawer(STATE_INIT, False, STATE_INIT)
					EndIf
					If (creditImage = Null) Then
						creditImage = MFImage.createImage("/animation/ending/sega_logo_ed.png")
					EndIf
					
					If (skipDrawer = Null) Then
						skipDrawer = New Animation("/animation/skip").getDrawer(STATE_INIT, False, STATE_INIT)
					EndIf
					
					Self.state = STATE_INIT
				Case STATE_CREDIT
					
					If (Key.touchopeningskip.IsButtonPress() And Not Self.isSkipPressed) Then
						Self.isSkipPressed = True
						SoundSystem.getInstance().stopBgm(False)
						State.fadeInitAndStart(STATE_INIT, 255)
						Self.count2 = STATE_TAILS_CATCH_UP
					EndIf
					
					If (Self.count2 >= STATE_TAILS_CATCH_UP) Then
						Self.count2 += 1
						
						If (Self.count2 >= 26 And State.fadeChangeOver()) Then
							Standard2.splashinit(True)
							State.setState(STATE_INIT)
						EndIf
					EndIf
					
				Case STATE_INTERRUPT
					interruptLogic()
				Default
			EndIf
		End
		
		Public Method draw:Void(g:MFGraphics)
			Int i
			Select (Self.state)
				Case STATE_INIT
				Case STATE_PRE_INIT
					For (i = 0; i < STATE_MOON_MOVE; i += 1)
						MyAPI.drawImage(g, Self.moonImage[i], SCREEN_WIDTH Shr 1, Self.moonOffset[i], 17)
					EndIf
				Case STATE_MOON_START
				Case STATE_MOON_STAR_SHINING
				Case STATE_MOON_MOVE
				Case STATE_MOON_END
					For (i = 0; i < STATE_MOON_MOVE; i += 1)
						MyAPI.drawImage(g, Self.moonImage[i], SCREEN_WIDTH Shr 1, Self.moonOffset[i], 17)
					EndIf
					If (Self.state = STATE_MOON_STAR_SHINING) Then
						Select (Self.starCount)
							Case 0
								Self.starDrawer[STATE_INIT].draw(g, (SCREEN_WIDTH Shr 1) + STAR_POSITION[STATE_INIT][STATE_INIT], STAR_POSITION[STATE_INIT][1])
								
								If (Self.starDrawer[STATE_INIT].checkEnd()) Then
									Self.starCount = 1
								EndIf
								
							Case 1
								Self.starDrawer[1].draw(g, (SCREEN_WIDTH Shr 1) + STAR_POSITION[1][STATE_INIT], STAR_POSITION[1][1])
								Self.starDrawer[STATE_MOON_STAR_SHINING].draw(g, (SCREEN_WIDTH Shr 1) + STAR_POSITION[STATE_MOON_STAR_SHINING][STATE_INIT], STAR_POSITION[STATE_MOON_STAR_SHINING][1])
								
								If (Self.starDrawer[1].checkEnd()) Then
									Self.starCount = 2
								EndIf
								
							Case 2
								Self.starDrawer[3].draw(g, (SCREEN_WIDTH Shr 1) + STAR_POSITION[3][STATE_INIT], STAR_POSITION[3][1])
								
								If (Self.starDrawer[3].checkEndTrigger()) Then
									Self.count = 0
								EndIf
								
							Default
						EndIf
					EndIf
					
				Case STATE_AFTER_THAT
					g.setColor(STATE_INIT)
					MyAPI.fillRect(g, STATE_INIT, STATE_INIT, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, Self.daysLaterImage, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, STATE_MOON_MOVE)
				Case STATE_TAILS_FLYING
				Case STATE_TAILS_SEARCHING
				Case STATE_TAILS_FIND
				Case STATE_TAILS_PULL_DOWN
					drawBG(g)
					Self.SuperSonicShiningDrawer.draw(g, Self.shiningX Shr STATE_MOON_STAR_SHINING, Self.shiningY Shr STATE_MOON_STAR_SHINING)
					cloudLogic()
					cloudDraw(g)
					drawPlane(g)
				Case STATE_TAILS_CATCH_UP
					drawBG(g)
					cloudLogic()
					cloudDraw(g)
					drawCatchPlane(g)
				Case STATE_CATCH
					g.setColor(STATE_INIT)
					MyAPI.fillRect(g, STATE_INIT, STATE_INIT, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, Self.catchImage[Self.catchID], SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, STATE_MOON_MOVE)
				Case STATE_CHANGING_FACE
					g.setColor(STATE_INIT)
					MyAPI.fillRect(g, STATE_INIT, STATE_INIT, SCREEN_WIDTH, SCREEN_HEIGHT)
					Self.faceChangeDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
					
					If (Self.faceChangeDrawer.checkEnd()) Then
						Self.faceChangeDrawer.setActionId(1)
					EndIf
					
				Case STATE_CONGRATULATION
					g.setColor(STATE_INIT)
					MyAPI.fillRect(g, STATE_INIT, STATE_INIT, SCREEN_WIDTH, SCREEN_HEIGHT)
					Self.faceChangeDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
					MyAPI.drawImage(g, Self.endingWordImage, WORD_PARAM[STATE_INIT][STATE_INIT], WORD_PARAM[STATE_INIT][1], WORD_PARAM[STATE_INIT][STATE_MOON_STAR_SHINING], WORD_PARAM[STATE_INIT][3], STATE_INIT, SCREEN_WIDTH Shr 1, Self.congratulationY, 17)
					MyAPI.drawImage(g, Self.endingWordImage, WORD_PARAM[1][STATE_INIT], WORD_PARAM[1][1], WORD_PARAM[1][STATE_MOON_STAR_SHINING], WORD_PARAM[1][3], STATE_INIT, SCREEN_WIDTH Shr 1, Self.thankY, 17)
				Case STATE_CREDIT
					Int i2
					g.setColor(STATE_INIT)
					MyAPI.fillRect(g, STATE_INIT, STATE_INIT, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, creditImage, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, STATE_MOON_MOVE)
					AnimationDrawer animationDrawer = skipDrawer
					
					If (Key.touchopeningskip.Isin()) Then
						i2 = 1
					Else
						i2 = 0
					EndIf
					
					animationDrawer.setActionId(i2 + STATE_INIT)
					skipDrawer.draw(g, STATE_INIT, SCREEN_HEIGHT)
				Case STATE_INTERRUPT
					interruptDraw(g)
				Default
			End Select
		End
		
		Public Method isOver:Bool()
			Return Self.state = STATE_CONGRATULATION And Self.count > BGM_ENDING_COUNT
		End
		
		Private Method drawPlane:Void(g:MFGraphics)
			
			If (Self.state < STATE_TAILS_PULL_DOWN) Then
				Self.planeOffsetY = getPlaneOffset()
			Else
				Self.planeOffsetY = 0
			EndIf
			
			Self.planeDrawer.draw(g, Self.planeX, Self.planeY + Self.planeOffsetY)
			Self.planeHeadDrawer.draw(g, Self.pilotHeadID, Self.planeX + STATE_MOON_MOVE, Self.planeOffsetY + (Self.planeY - 22), True, STATE_INIT)
		End
		
		Private Method getPlaneOffset:Int()
			Self.planeOffsetDegree += STATE_AFTER_THAT
			Return ((Sin(Self.planeOffsetDegree) * STATE_TAILS_FIND) / 100) + STATE_TAILS_FIND
		End
		
		Private Method drawCatchPlane:Void(g:MFGraphics)
			g.saveCanvas()
			g.translateCanvas(Self.planeX, Self.planeY)
			g.scaleCanvas((Float) Self.planeScale, (Float) Self.planeScale)
			g.rotateCanvas((Float) Self.planeDegree)
			Self.planeDrawer.draw(g, 1, STATE_INIT, STATE_INIT, True, STATE_INIT)
			g.restoreCanvas()
		End
		
		Private Method cloudLogic:Void()
			
			If (Self.cloudCount > 0) Then
				Self.cloudCount -= 1
			EndIf
			
			For (Int i = 0; i < STATE_TAILS_CATCH_UP; i += 1)
				
				If (Self.cloudInfo[i][STATE_INIT] <> 0) Then
					Int[] iArr = Self.cloudInfo[i]
					iArr[1] = iArr[1] + CLOUD_VELOCITY[Self.cloudInfo[i][STATE_INIT] - 1]
					
					If (Self.cloudInfo[i][1] >= SCREEN_WIDTH + 75) Then
						Self.cloudInfo[i][STATE_INIT] = 0
					EndIf
				EndIf
				
				If (Self.cloudInfo[i][STATE_INIT] = 0 And Self.cloudCount = 0) Then
					Self.cloudInfo[i][STATE_INIT] = MyRandom.nextInt(1, STATE_MOON_MOVE)
					Self.cloudInfo[i][1] = -60
					Self.cloudInfo[i][STATE_MOON_STAR_SHINING] = MyRandom.nextInt(20, SCREEN_HEIGHT - 40)
					Self.cloudCount = MyRandom.nextInt(STATE_TAILS_FIND, 20)
				EndIf
			EndIf
		End
		
		Private Method cloudDraw:Void(g:MFGraphics)
			For (Int i = 0; i < STATE_TAILS_CATCH_UP; i += 1)
				
				If (Self.cloudInfo[i][STATE_INIT] <> 0) Then
					Self.cloudDrawer.setActionId(Self.cloudInfo[i][STATE_INIT] - 1)
					Self.cloudDrawer.draw(g, Self.cloudInfo[i][1], Self.cloudInfo[i][STATE_MOON_STAR_SHINING])
				EndIf
			EndIf
		End
		
		Private Method drawBG:Void(g:MFGraphics)
			MyAPI.drawImage(g, Self.endingBgImage, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - PLANE_CATCH_UP_FRAME, STATE_MOON_MOVE)
		End
		
		Public Method close:Void()
			Int i
			Animation.closeAnimationDrawer(Self.interruptDrawer)
			Self.interruptDrawer = Null
			
			If (Self.moonImage <> Null) Then
				For (i = 0; i < Self.moonImage.Length; i += 1)
					Self.moonImage[i] = Null
				EndIf
			EndIf
			
			Self.moonImage = Null
			
			If (Self.catchImage <> Null) Then
				For (i = 0; i < Self.catchImage.Length; i += 1)
					Self.catchImage[i] = Null
				EndIf
			EndIf
			
			Self.catchImage = Null
			Self.daysLaterImage = Null
			Self.endingWordImage = Null
			Animation.closeAnimationDrawer(Self.planeDrawer)
			Self.planeDrawer = Null
			Animation.closeAnimationDrawer(Self.planeHeadDrawer)
			Self.planeHeadDrawer = Null
			Animation.closeAnimationDrawer(Self.cloudDrawer)
			Self.cloudDrawer = Null
			Self.endingBgImage = Null
			Animation.closeAnimationDrawer(Self.SuperSonicShiningDrawer)
			Self.SuperSonicShiningDrawer = Null
			Animation.closeAnimationDrawer(Self.faceChangeDrawer)
			Self.faceChangeDrawer = Null
			creditImage = Null
			Animation.closeAnimationDrawer(skipDrawer)
			skipDrawer = Null
			Animation.closeAnimationDrawerArray(Self.starDrawer)
			Self.starDrawer = Null
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
			interruptInit()
			Key.touchInterruptInit()
			Key.touchkeyboardInit()
			SoundSystem.getInstance().stopBgm(False)
		End
		
		Private Method creditInit:Void()
			Self.isSkipPressed = False
			State.fadeInitAndStart(STATE_INIT, STATE_INIT)
			SoundSystem.getInstance().stopBgm(False)
			SoundSystem.getInstance().playBgm(33)
			Key.touchOpeningInit()
			Self.count = 0
			Self.count2 = 0
		End
		
		Private Method interruptInit:Void()
			
			If (Self.interruptDrawer = Null) Then
				Self.interruptDrawer = Animation.getInstanceFromQi("/animation/utl_res/suspend_resume.dat")[STATE_INIT].getDrawer(STATE_INIT, True, STATE_INIT)
			EndIf
			
		End
		
		Private Method interruptLogic:Void()
			State.fadeInitAndStart(STATE_INIT, STATE_INIT)
			SoundSystem.getInstance().stopBgm(False)
			
			If (Key.press(STATE_MOON_STAR_SHINING)) Then
			EndIf
			
			If (Key.press(Key.B_BACK) Or (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress())) Then
				SoundSystem.getInstance().playSe(STATE_MOON_STAR_SHINING)
				Key.touchInterruptClose()
				Key.touchkeyboardClose()
				
				If (Self.interrupt_state <= STATE_CREDIT) Then
					Self.state = STATE_CREDIT
					creditInit()
				EndIf
				
				Key.clear()
			EndIf
			
		End
		
		Private Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId((Key.touchinterruptreturn.Isin() ? 1 : STATE_INIT) + STATE_INIT)
			Self.interruptDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
		End
End