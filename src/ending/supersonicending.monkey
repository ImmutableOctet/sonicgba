Strict

Public

' Imports:
Private
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
		
		Field planeDrawer:AnimationDrawer
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
		Method close:Void()
			Animation.closeAnimationDrawer(Self.interruptDrawer)
			Self.interruptDrawer = Null
			
			If (Self.moonImage <> Null) Then
				For Local i:= 0 Until Self.moonImage.Length
					Self.moonImage[i] = Null
				Next
			EndIf
			
			Self.moonImage = Null
			
			If (Self.catchImage <> Null) Then
				For Local i:= 0 Until Self.catchImage.Length
					Self.catchImage[i] = Null
				Next
			EndIf
			
			Self.catchImage = Null
			Self.daysLaterImage = Null
			Self.endingWordImage = Null
			Self.endingBgImage = Null
			
			Animation.closeAnimationDrawer(Self.planeDrawer)
			Self.planeDrawer = Null
			
			Animation.closeAnimationDrawer(Self.planeHeadDrawer)
			Self.planeHeadDrawer = Null
			
			Animation.closeAnimationDrawer(Self.cloudDrawer)
			Self.cloudDrawer = Null
			
			Animation.closeAnimationDrawer(Self.SuperSonicShiningDrawer)
			Self.SuperSonicShiningDrawer = Null
			
			Animation.closeAnimationDrawer(Self.faceChangeDrawer)
			Self.faceChangeDrawer = Null
			
			Animation.closeAnimationDrawerArray(Self.starDrawer)
			Self.starDrawer = []
			
			creditImage = Null
			
			Animation.closeAnimationDrawer(skipDrawer)
			skipDrawer = Null
			
			'System.gc()
			'Thread.sleep(100)
		End
		
		Method init:Void()
			' Nothing so far.
		End
		
		Method pause:Void()
			If (Self.state = STATE_INTERRUPT) Then
				'Self.state = STATE_INTERRUPT
				
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
		
		Method logic:Void()
			If (Self.state <> STATE_INTERRUPT) Then
				Self.count += 1
			EndIf
			
			Select (Self.state)
				Case STATE_INIT
					Self.state = STATE_MOON_START
					
					Self.count = 0
					Self.starCount = 0
					
					SoundSystem.getInstance().playBgmSequenceNoLoop(SoundSystem.BGM_ENDING_EX_01, SoundSystem.BGM_ENDING_EX_02)
				Case STATE_MOON_START
					If (Self.count > STATE_AFTER_THAT) Then
						Self.state = STATE_MOON_STAR_SHINING
					EndIf
				Case STATE_MOON_STAR_SHINING
					If (Self.starDrawer[3].checkEnd() And Self.count > 4) Then
						Self.state = STATE_MOON_MOVE
					EndIf
				Case STATE_MOON_MOVE
					For Local i:= 0 Until Self.moonOffset.Length ' 3
						Self.moonOffset[i] = MOON_BG_OFFSET_START[i] + (((MOON_BG_OFFSET_END[i] - MOON_BG_OFFSET_START[i]) * Self.count) / MOON_BG_MOVE_FRAME)
					Next
					
					If (Self.count >= MOON_BG_MOVE_FRAME) Then
						Self.state = STATE_MOON_END
						
						Self.count = 0
					EndIf
				Case STATE_MOON_END
					If (Self.count = PLANE_CATCH_UP_FRAME) Then
						State.fadeInitAndStart(0, 255)
					EndIf
					
					If (Self.count > PLANE_CATCH_UP_FRAME And State.fadeChangeOver()) Then
						Self.state = STATE_AFTER_THAT
						
						State.fading = False
						
						Self.count = 0
					EndIf
				Case STATE_AFTER_THAT
					If (Self.count = 160) Then
						State.fadeInitAndStart(255, 0)
						
						Self.state = STATE_TAILS_FLYING
						
						Self.count = 0
					EndIf
				Case STATE_TAILS_FLYING
					If (Self.count > 16) Then
						Self.state = STATE_TAILS_SEARCHING
						
						Self.count = 0
						
						Self.pilotHeadID = STATE_MOON_END
					EndIf
				Case STATE_TAILS_SEARCHING
					If (Self.count > 48) Then
						Self.shiningX -= SHINING_VEL_V
						Self.shiningY += SHINING_VEL_H
						
						' Magic number: 184
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
					Self.planeY += PLANE_PULL_DOWN_VEL
					
					If (Self.planeY > SCREEN_HEIGHT + 80) Then
						Self.state = STATE_TAILS_CATCH_UP
						
						Self.planeX = ((SCREEN_WIDTH * 3) / 4)
						Self.planeY = (SCREEN_HEIGHT + 40)
						
						Self.count = 0
						Self.planeDegree = 0
					EndIf
				Case STATE_TAILS_CATCH_UP
					Self.planeDegree = (Self.count * -55) / PLANE_CATCH_UP_FRAME
					
					Self.planeX = ((SCREEN_WIDTH * 3) / 4) + (((-40 - ((SCREEN_WIDTH * 3) / 4)) * Self.count) / PLANE_CATCH_UP_FRAME)
					Self.planeY = (SCREEN_HEIGHT + 40) + (((((SCREEN_HEIGHT / 2) - PLANE_PULL_DOWN_VEL) - (SCREEN_HEIGHT + 40)) * Self.count) / PLANE_CATCH_UP_FRAME) ' Shr 1
					
					Self.planeScale = 0.9 + ((-0.6000000000000001 * Double(Self.count)) / 30.0)
					
					If (Not Self.changeState And Self.planeX < -80) Then
						State.fadeInitAndStart(0, 255)
						
						Self.changeState = True
					EndIf
					
					If (Self.changeState And State.fadeChangeOver()) Then
						State.fadeInitAndStart(255, 0)
						
						Self.state = STATE_CATCH
						Self.changeState = False
						Self.count = 0
						Self.catchID = 0
						Self.congratulationY = SCREEN_HEIGHT + 20
						Self.thankY = SCREEN_HEIGHT + 20
					EndIf
				Case STATE_CATCH
					If (Self.count = 72) Then
						State.fadeInitAndStart(0, 255)
						
						Self.changeState = True
					EndIf
					
					If (Self.changeState And State.fadeChangeOver()) Then
						Self.changeState = False
						
						State.fadeInitAndStart(255, 0)
						
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
					Self.congratulationY = (SCREEN_HEIGHT + 20) + ((((((SCREEN_HEIGHT / 2) - 48) - 24) - (SCREEN_HEIGHT + 20)) * Self.count) / 13) ' Shr 1
					
					If (Self.congratulationY < ((SCREEN_HEIGHT / 2) - 48) - 24) Then ' Shr 1
						Self.congratulationY = ((SCREEN_HEIGHT / 2) - 48) - 24 ' Shr 1
					EndIf
					
					If (Self.count > 27) Then
						Self.thankY = (SCREEN_HEIGHT + 20) + ((((((SCREEN_HEIGHT / 2) + 48) - 6) - (SCREEN_HEIGHT + 20)) * (Self.count - 27)) / 13) ' Shr 1
						
						If (Self.thankY < WORD_DESTINY_2) Then
							Self.thankY = WORD_DESTINY_2
						EndIf
					EndIf
					
					If (Self.count = 189) Then
						State.fadeInitAndStart(0, 255)
					ElseIf (isOver() And State.fadeChangeOver()) Then
						Self.state = STATE_CREDIT
						
						creditInit()
					EndIf
				Case STATE_PRE_INIT
					Self.daysLaterImage = MFImage.createImage("/animation/ending/ed_fewdays.png")
					Self.endingBgImage = MFImage.createImage("/animation/ending/ending_bg.png")
					
					Self.planeDrawer = New Animation("/animation/ending/ending_plane").getDrawer()
					Self.planeHeadDrawer = New Animation("/animation/ending/plane_head").getDrawer()
					Self.cloudDrawer = New Animation("/animation/ending/ending_cloud").getDrawer()
					Self.SuperSonicShiningDrawer = New Animation("/animation/ending/Super.sonic_shining").getDrawer()
					
					Self.planeX = (SCREEN_WIDTH / 2) ' Shr 1
					Self.planeY = (SCREEN_HEIGHT / 2) + 40 ' Shr 1
					
					Self.pilotHeadID = PILOT_TAILS
					
					Self.shiningX = 480
					Self.shiningY = -40
					
					' Allocate frames for our "animation":
					Self.catchImage = New MFImage[4]
					
					For Local i:= 0 Until Self.catchImage.Length
						Self.catchImage[i] = MFImage.createImage("/animation/ending/ending_catch_" + (i + 1) + ".png")
					Next
					
					Self.endingWordImage = MFImage.createImage("/animation/ending/ending_word.png")
					
					Self.faceChangeDrawer = New Animation("/animation/ending/ed_SuperSonic_b").getDrawer(0, False, 0)
					
					Local starAnimation:= New Animation("/animation/ending/ending_star")
					
					Self.starDrawer = New AnimationDrawer[STAR_POSITION.Length]
					
					For Local i:= 0 Until STAR_POSITION.Length
						Self.starDrawer[i] = starAnimation.getDrawer(0, False, 0)
					Next
					
					If (creditImage = Null) Then
						creditImage = MFImage.createImage("/animation/ending/sega_logo_ed.png")
					EndIf
					
					If (skipDrawer = Null) Then
						skipDrawer = New Animation("/animation/skip").getDrawer(0, False, 0)
					EndIf
					
					Self.state = STATE_INIT
				Case STATE_CREDIT
					If (Key.touchopeningskip.IsButtonPress() And Not Self.isSkipPressed) Then
						Self.isSkipPressed = True
						
						SoundSystem.getInstance().stopBgm(False)
						
						State.fadeInitAndStart(0, 255)
						
						Self.count2 = 10
					EndIf
					
					If (Self.count2 >= 10) Then
						Self.count2 += 1
						
						If (Self.count2 >= 26 And State.fadeChangeOver()) Then
							Standard2.splashinit(True)
							
							State.setState(State.STATE_TITLE)
						EndIf
					EndIf
				Case STATE_INTERRUPT
					interruptLogic()
				Default
					' Nothing so far.
			End Select
		End
		
		Method draw:Void(g:MFGraphics)
			Select (Self.state)
				Case STATE_INIT, STATE_PRE_INIT
					For Local i:= 0 Until Self.moonImage.Length ' Self.moonOffset.Length
						MyAPI.drawImage(g, Self.moonImage[i], (SCREEN_WIDTH / 2), Self.moonOffset[i], 17) ' Shr 1
					Next
				Case STATE_MOON_START, STATE_MOON_STAR_SHINING, STATE_MOON_MOVE, STATE_MOON_END
					For Local i:= 0 Until Self.moonImage.Length ' Self.moonOffset.Length
						MyAPI.drawImage(g, Self.moonImage[i], (SCREEN_WIDTH / 2), Self.moonOffset[i], 17) ' Shr 1
					Next
					
					If (Self.state = STATE_MOON_STAR_SHINING) Then
						Select (Self.starCount)
							Case 0
								Self.starDrawer[0].draw(g, (SCREEN_WIDTH / 2) + STAR_POSITION[0][0], STAR_POSITION[0][1]) ' Shr 1
								
								If (Self.starDrawer[0].checkEnd()) Then
									Self.starCount = 1
								EndIf
							Case 1
								Self.starDrawer[1].draw(g, (SCREEN_WIDTH / 2) + STAR_POSITION[1][0], STAR_POSITION[1][1]) ' Shr 1
								Self.starDrawer[2].draw(g, (SCREEN_WIDTH / 2) + STAR_POSITION[2][0], STAR_POSITION[2][1]) ' Shr 1
								
								If (Self.starDrawer[1].checkEnd()) Then
									Self.starCount = 2
								EndIf
							Case 2
								Self.starDrawer[3].draw(g, (SCREEN_WIDTH / 2) + STAR_POSITION[3][0], STAR_POSITION[3][1]) ' Shr 1
								
								If (Self.starDrawer[3].checkEndTrigger()) Then
									Self.count = 0
								EndIf
							Default
								' Nothing so far.
						End Select
					EndIf
				Case STATE_AFTER_THAT
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, Self.daysLaterImage, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), 3) ' Shr 1
				Case STATE_TAILS_FLYING, STATE_TAILS_SEARCHING, STATE_TAILS_FIND, STATE_TAILS_PULL_DOWN
					drawBG(g)
					
					Self.SuperSonicShiningDrawer.draw(g, (Self.shiningX Shr 2), (Self.shiningY Shr 2))
					
					cloudLogic()
					cloudDraw(g)
					drawPlane(g)
				Case STATE_TAILS_CATCH_UP
					drawBG(g)
					cloudLogic()
					cloudDraw(g)
					drawCatchPlane(g)
				Case STATE_CATCH
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, Self.catchImage[Self.catchID], (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), 3) ' Shr 1
				Case STATE_CHANGING_FACE
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					Self.faceChangeDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
					
					If (Self.faceChangeDrawer.checkEnd()) Then
						Self.faceChangeDrawer.setActionId(1)
					EndIf
				Case STATE_CONGRATULATION
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					Self.faceChangeDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
					
					MyAPI.drawImage(g, Self.endingWordImage, WORD_PARAM[0][0], WORD_PARAM[0][1], WORD_PARAM[0][2], WORD_PARAM[0][3], 0, (SCREEN_WIDTH / 2), Self.congratulationY, 17) ' Shr 1
					MyAPI.drawImage(g, Self.endingWordImage, WORD_PARAM[1][0], WORD_PARAM[1][1], WORD_PARAM[1][2], WORD_PARAM[1][3], 0, (SCREEN_WIDTH / 2), Self.thankY, 17) ' Shr 1
				Case STATE_CREDIT
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					MyAPI.drawImage(g, creditImage, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2), 3) ' Shr 1
					
					Local animationDrawer:= skipDrawer
					
					animationDrawer.setActionId(Int(Key.touchopeningskip.Isin()))
					
					animationDrawer.draw(g, 0, SCREEN_HEIGHT)
				Case STATE_INTERRUPT
					interruptDraw(g)
				Default
					' Nothing so far.
			End Select
		End
		
		Method isOver:Bool()
			Return (Self.state = STATE_CONGRATULATION And Self.count > BGM_ENDING_COUNT)
		End
	Private
		' Methods:
		Method drawPlane:Void(g:MFGraphics)
			If (Self.state < STATE_TAILS_PULL_DOWN) Then
				Self.planeOffsetY = getPlaneOffset()
			Else
				Self.planeOffsetY = 0
			EndIf
			
			Self.planeDrawer.draw(g, Self.planeX, Self.planeY + Self.planeOffsetY)
			Self.planeHeadDrawer.draw(g, Self.pilotHeadID, Self.planeX + 3, Self.planeOffsetY + (Self.planeY - 22), True, 0)
		End
		
		Method getPlaneOffset:Int()
			Self.planeOffsetDegree += OFFSET_SPEED
			
			Return ((MyAPI.dSin(Self.planeOffsetDegree) * OFFSET_RANGE) / 100) + OFFSET_RANGE
		End
		
		Method drawCatchPlane:Void(g:MFGraphics)
			g.saveCanvas()
			
			g.translateCanvas(Self.planeX, Self.planeY)
			g.scaleCanvas(Float(Self.planeScale), Float(Self.planeScale))
			g.rotateCanvas(Float(Self.planeDegree))
			
			Self.planeDrawer.draw(g, 1, 0, 0, True, 0)
			
			g.restoreCanvas()
		End
		
		Method cloudLogic:Void()
			If (Self.cloudCount > 0) Then
				Self.cloudCount -= 1
			EndIf
			
			For Local cloud:= EachIn Self.cloudInfo
				If (cloud[0] <> 0) Then
					cloud[1] += CLOUD_VELOCITY[cloud[0] - 1]
					
					If (cloud[1] >= SCREEN_WIDTH + 75) Then
						cloud[0] = 0
					EndIf
				EndIf
				
				If (cloud[0] = 0 And Self.cloudCount = 0) Then
					cloud[0] = MyRandom.nextInt(1, 3)
					cloud[1] = -60
					cloud[2] = MyRandom.nextInt(20, SCREEN_HEIGHT - 40)
					
					Self.cloudCount = MyRandom.nextInt(8, 20)
				EndIf
			Next
		End
		
		Method cloudDraw:Void(g:MFGraphics)
			For Local cloud:= EachIn Self.cloudInfo
				If (cloud[0] <> 0) Then
					Self.cloudDrawer.setActionId(cloud[0] - 1)
					Self.cloudDrawer.draw(g, cloud[1], cloud[2])
				EndIf
			Next
		End
		
		Method drawBG:Void(g:MFGraphics)
			MyAPI.drawImage(g, Self.endingBgImage, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) - 30, 3) ' Shr 1
		End
		
		Method creditInit:Void()
			Self.isSkipPressed = False
			
			State.fadeInitAndStart(0, 0)
			
			SoundSystem.getInstance().stopBgm(False)
			SoundSystem.getInstance().playBgm(SoundSystem.BGM_CREDIT)
			
			Key.touchOpeningInit()
			
			Self.count = 0
			Self.count2 = 0
		End
		
		Method interruptInit:Void()
			If (Self.interruptDrawer = Null) Then
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
				EndIf
				
				Key.clear()
			EndIf
		End
		
		Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId(Int(Key.touchinterruptreturn.Isin()))
			Self.interruptDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
		End
End