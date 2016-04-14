Strict

Public

' Imports:
Private
	Import gameengine.def
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.soundsystem
	Import lib.constutil
	
	Import platformstandard.standard
	
	Import sonicgba.globalresource
	
	' Used for the 'end-color'.
	Import sonicgba.mapmanager
	
	'Import android.os.message
	
	Import com.sega.mflib.main
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	Import com.sega.mobile.framework.ui.mfbutton
	
	Import application
Public

' Classes
Class Standard2 ' Implements Def ' Final
	Private
		' Constant variable(s):
		Const CLIP_NUM:Int = 25
		
		Const FADE_FILL_WIDTH:Int = 40
		Const FADE_FILL_HEIGHT:Int = 40
		
		Const FRAME_DIFF:Int = 8
		
		' Splash-screen states:
		Const SPLASH_INIT:Int = 0
		Const SPLASH_SOUND:Int = 1
		Const SPLASH_SEGA:Int = 2
		Const SPLASH_SONIC_TEAM:Int = 3
		Const SPLASH_OVER:Int = 4
		Const SPLASH_EXIT:Int = 5
		Const SPLASH_QUIT:Int = 6
		
		Const SPLASH_2_COME_IN_COUNT:Int = 30
		
		Const STANDARD_RES:String = "/standard"
		
		' States:
		Const STATE_INIT:Int = 0
		Const STATE_LOGO_IN:Int = 1
		Const STATE_SHOW:Int = 2
		Const STATE_LOGO_OUT:Int = 3
		Const STATE_OVER:Int = 4
		
		' Global variable(s):
		Global isFromEnding:Bool = False
		
		Global count:Int = 0
		
		Global fadeAlpha:Int = FADE_FILL_WIDTH
		Global fadeFromValue:Int = 0
		
		' This will eventually be replaced for hardware fading.
		Global fadeRGB:Int[] = New Int[FADE_FILL_WIDTH*FADE_FILL_HEIGHT]
		
		Global fadeToValue:Int
		Global preFadeAlpha:Int = 0 ' -1
		
		Global yesButton:MFButton
		Global noButton:MFButton
		
		Global returnValue:Int
		
		Global soundUIDrawer:AnimationDrawer
		
		Global splashImage1:MFImage
		Global splashImage2:MFImage
		
		Global state:Int
		Global splashState:Int
	Public
		' Constant variable(s):
		Const ANIMATION_PATH:String = "/animation"
		
		Const MESSAGE_INIT_SDK:Int = 0
		Const MESSAGE_PAGE:Int = 1
		Const MESSAGE_GAME_TOP:Int = 2
		Const MESSAGE_RANKING:Int = 3
		Const MESSAGE_USER:Int = 4
		Const MESSAGE_EXIT:Int = 5
		Const MESSAGE_SAVE:Int = 6
		
		' Global variable(s):
		Global activity:Application
		Global confirmcursor:Int = 0
		Global confirmframe:Int = 0
		Global isConfirm:Bool
		Global muiAniDrawer:AnimationDrawer
	Protected
		' Global variable(s):
		Global keyCancel:Bool
		Global keyConfirm:Bool
	Public
		' Functions:
		Function splashinit:Void(isNeedSoundControl:Bool)
			isFromEnding = isNeedSoundControl
			splashState = 0
		End
		
		Function splashLogic:Int()
			returnValue = 0
			
			Select (splashState)
				Case SPLASH_INIT
					soundInit()
					
					If (Not isFromEnding) Then
						splashState = SPLASH_SOUND
						
						setFadeOver()
					Else
						state = STATE_INIT
						splashState = SPLASH_SEGA
						
						If (yesButton <> Null) Then
							MFDevice.removeComponent(yesButton)
						EndIf
						
						If (noButton <> Null) Then
							MFDevice.removeComponent(noButton)
						EndIf
					EndIf
				Case SPLASH_SOUND
					If (Not soundLogic() And Key.press(Key.B_BACK) And fadeChangeOver()) Then
						splashState = SPLASH_EXIT
						
						secondEnsureInit()
						
						fadeInit(0, 220)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					Else
						state = STATE_INIT
						splashState = SPLASH_SEGA
						
						If (yesButton <> Null) Then
							MFDevice.removeComponent(yesButton)
						EndIf
						
						If (noButton <> Null) Then
							MFDevice.removeComponent(noButton)
						EndIf
					EndIf
				Case SPLASH_SEGA
					splashLogic1()
					
					If (splashIsOver1()) Then
						state = STATE_INIT
						splashState = SPLASH_SONIC_TEAM
					EndIf
				Case SPLASH_SONIC_TEAM
					splashLogic2()
					
					If (splash2IsOver()) Then
						splashState = SPLASH_OVER
					EndIf
				Case SPLASH_OVER
					returnValue = 3
					
					isFromEnding = False
				Case SPLASH_EXIT
					' Selection resolution?
					Select (secondEnsureLogic())
						Case 1
							close()
							
							'System.gc()
							
							splashState = SPLASH_QUIT
							
							SoundSystem.getInstance().stopBgm(True)
							
							Key.touchkeyboardClose()
							Key.touchsoftkeyInit()
						Case 2
							soundInit()
							
							splashState = SPLASH_SOUND
						Default
							' Nothing so far.
					End Select
				Case SPLASH_QUIT
					If (Key.press(Key.B_S1 | Key.gSelect)) Then
						Standard.pressConfirm()
					ElseIf (Key.press(Key.B_S2)) Then
						Standard.pressCancel()
					EndIf
					
					Select (Standard.execMoreGame(True))
						Case Standard.MORE_GAME_LOAD
							Key.touchsoftkeyClose()
							
							GlobalResource.saveSystemConfig()
							
							MFDevice.notifyExit()
							'sendMessage(New Message(), MESSAGE_EXIT)
						Default
							' Nothing so far.
					End Select
			End Select
			
			Return returnValue
		End
		
		Function splashDraw:Void(g:MFGraphics, SCREEN_WIDTH:Int, SCREEN_HEIGHT:Int)
			Select (splashState)
				Case SPLASH_SOUND
					soundDraw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case SPLASH_SEGA
					splashDraw1(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case SPLASH_SONIC_TEAM
					splashDraw2(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case SPLASH_OVER
					splashDraw2(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case SPLASH_EXIT
					soundDraw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					drawFade(g)
					
					SecondEnsurePanelDraw(g, 14)
				Default
					' Nothing so far.
			End Select
		End
		
		Function splashOver:Bool()
			Return (splashState = SPLASH_OVER)
		End
		
		Function close:Void()
			splashImage1 = Null
			splashImage2 = Null
		End
		
		Function pressConfirm:Void()
			keyConfirm = True
		End
		
		Function pressCancel:Void()
			keyCancel = True
		End
		
		Function fadeInit:Void(from:Int, dest:Int)
			fadeFromValue = from
			fadeToValue = dest
			
			fadeAlpha = fadeFromValue
			
			preFadeAlpha = -1
		End
		
		' This behavior will change in the future. (Software fade)
		Function drawFade:Void(g:MFGraphics)
			fadeAlpha = MyAPI.calNextPosition(Double(fadeAlpha), Double(fadeToValue), 1, 3, 3.0)
			
			If (fadeAlpha <> 0) Then
				If (preFadeAlpha <> fadeAlpha) Then
					For Local w:= 0 Until FADE_FILL_WIDTH
						For Local h:= 0 Until FADE_FILL_HEIGHT
							fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl 24) & -16777216) | (fadeRGB[(h * FADE_FILL_WIDTH) + w] & MapManager.END_COLOR) ' FADE_FILL_HEIGHT
						Next
					Next
					
					preFadeAlpha = fadeAlpha
				EndIf
				
				For Local w:= 0 Until MyAPI.zoomOut(SCREEN_WIDTH) Step FADE_FILL_WIDTH
					For Local h:= 0 Until MyAPI.zoomOut(SCREEN_HEIGHT) Step FADE_FILL_HEIGHT
						g.drawRGB(fadeRGB, 0, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_HEIGHT, True)
					Next
				Next
			EndIf
		End
		
		Function setFadeOver:Void()
			fadeAlpha = fadeToValue
		End
		
		Function fadeChangeOver:Bool()
			Return (fadeAlpha = fadeToValue)
		End
		
		Function secondEnsureInit:Void()
			isConfirm = False
			
			confirmframe = 0
			confirmcursor = 0
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Key.touchSecondEnsureClose()
			Key.touchSecondEnsureInit()
		End
		
		Function secondEnsureLogic:Int()
			If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
				confirmcursor = 2
			EndIf
			
			If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
				confirmcursor = 0
			EndIf
			
			If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
				confirmcursor = 1
			EndIf
			
			If (isConfirm) Then
				confirmframe += 1
				
				If (confirmframe > FRAME_DIFF) Then
					Return 1
				EndIf
			EndIf
			
			If (Key.touchsecondensureyes.IsButtonPress() And confirmcursor = 0 And Not isConfirm) Then
				isConfirm = True
				confirmframe = 0
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_106)
				
				Return 0
			ElseIf (Key.touchsecondensureno.IsButtonPress() And confirmcursor = 1 And Not isConfirm) Then
				SoundSystem.getInstance().playSe(SoundSystem.SE_107)
				
				Return 2
			ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver() Or isConfirm) Then
				Return 0
			EndIf
			
			SoundSystem.getInstance().playSe(SoundSystem.SE_107)
			
			Return 2
		End
		
		Function SecondEnsurePanelDraw:Void(g:MFGraphics, ani_id:Int)
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				
				Return
			EndIf
			
			Local animationDrawer:= muiAniDrawer
			
			animationDrawer.setActionId(54)
			animationDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) - 20) ' Shr 1
			
			animationDrawer.setActionId(Int(Key.touchsecondensureyes.Isin() And confirmcursor = 0) + 59)
			animationDrawer.draw(g, (SCREEN_WIDTH / 2) - FADE_FILL_WIDTH, (SCREEN_HEIGHT / 2) + FADE_FILL_WIDTH) ' Shr 1
			
			animationDrawer.setActionId(Int(Key.touchsecondensureno.Isin() And confirmcursor = 1) + 59)
			animationDrawer.draw(g, (SCREEN_WIDTH / 2) + FADE_FILL_WIDTH, (SCREEN_HEIGHT / 2) + FADE_FILL_WIDTH) ' Shr 1
			
			animationDrawer.setActionId(46)
			animationDrawer.draw(g, (SCREEN_WIDTH / 2) - FADE_FILL_WIDTH, (SCREEN_HEIGHT / 2) + FADE_FILL_WIDTH) ' Shr 1
			
			animationDrawer.setActionId(47)
			animationDrawer.draw(g, (SCREEN_WIDTH / 2) + FADE_FILL_WIDTH, (SCREEN_HEIGHT / 2) + FADE_FILL_WIDTH) ' Shr 1
			
			animationDrawer.setActionId(ani_id)
			animationDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) - 20) ' Shr 1
			
			animationDrawer.setActionId(PickValue(Key.touchsecondensurereturn.Isin(), 5, 0) + 61)
			animationDrawer.draw(g, 0, SCREEN_HEIGHT)
			
			If (isConfirm) Then
				If (confirmframe = 1) Then
					fadeInit(220, 255)
				EndIf
				
				drawFade(g)
				
				If (confirmframe > FRAME_DIFF) Then
					g.setColor(0)
					
					MyAPI.fillRect(g, 1, 1, SCREEN_WIDTH, SCREEN_HEIGHT)
				EndIf
			EndIf
		End
		
		Function getMain:Void(main:Application)
			activity = main
		End
		
		#Rem
			Function sendMessage:Void(msg:Message, id:Int)
				'msg.what = id
				'activity.handler.handleMessage(msg)
			End
		#End
	Private
		' Functions:
		Function splashInit1:Void()
			splashImage1 = MFImage.createImage("/standard/sega_logo.png")
			
			count = 0
		End
		
		Function splashLogic1:Void()
			' Constant variable(s):
			Const LOGO_TRANSITION_TIME:= 16
			Const LOGO_SHOW_TIME:= 60
			
			count += 1
			
			Select (state)
				Case STATE_INIT
					splashInit1()
					
					state = STATE_LOGO_IN
				Case STATE_LOGO_IN
					If (count >= LOGO_TRANSITION_TIME) Then
						state = STATE_SHOW
						
						count = 0
					EndIf
				Case STATE_SHOW
					If (count >= LOGO_SHOW_TIME) Then
						state = STATE_LOGO_OUT
						
						count = 0
					EndIf
				Case STATE_LOGO_OUT
					If (count >= LOGO_TRANSITION_TIME) Then
						state = STATE_OVER
						
						count = 0
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Function splashDraw1:Void(g:MFGraphics, screenWidth:Int, screenHeight:Int)
			g.setColor(MapManager.END_COLOR)
			
			g.fillRect(1, 1, screenWidth, screenHeight)
			
			Select (state)
				Case STATE_LOGO_IN
					drawSplashEffect1(g, splashImage1, (screenWidth / 2), (screenHeight / 2) - (splashImage1.getHeight() / 2), count) ' Shr 1
				Case STATE_SHOW
					MyAPI.drawImage(g, splashImage1, (screenWidth / 2), (screenHeight / 2) - (splashImage1.getHeight() / 2), 17) ' Shr 1
				Case STATE_LOGO_OUT
					drawSplashEffect2(g, splashImage1, (screenWidth / 2), (screenHeight / 2) - (splashImage1.getHeight() / 2), count, screenHeight) ' Shr 1
				Default
					' Nothing so far.
			End Select
		End
		
		Function splashIsOver1:Bool()
			Return (state = STATE_OVER And count >= 20)
		End
		
		Function drawSplashEffect1:Void(g:MFGraphics, image:MFImage, x:Int, y:Int, count:Int)
			Local w:= image.getWidth()
			Local h:= image.getHeight()
			
			Local a:= (h + y)
			Local b:= ((count * h) / 16)
			
			For Local i:= 0 Until (a - b)
				MyAPI.drawImage(g, image, 0, (h - b) - 1, w, 1, 0, x, i, 17)
			Next
			
			MyAPI.drawImage(g, image, 0, (h - b), w, b, 0, x, a - b, 17)
		End
		
		Function drawSplashEffect2:Void(g:MFGraphics, image:MFImage, x:Int, y:Int, count:Int, screenHeight:Int)
			Local w:= image.getWidth()
			Local h:= image.getHeight()
			
			Local a:= (h + y)
			Local b:= ((count * h) / 16)
			
			For Local i:= (a - b) Until screenHeight
				MyAPI.drawImage(g, image, 0, (h - b) - 1, w, 1, 0, x, i, 17)
			Next
			
			MyAPI.drawImage(g, image, 1, 1, w, (h - b), 0, x, y, 17)
		End
		
		Function splashInit2:Void()
			splashImage2 = MFImage.createImage("/standard/sonic_team.png")
			
			count = 0
		End
		
		Function splashLogic2:Void()
			count += 1
			
			Select (state)
				Case STATE_INIT
					splashInit2()
					
					state = STATE_LOGO_IN
					
					SoundSystem.getInstance().preLoadSequenceSe(SoundSystem.SE_117) ' 12
				Case STATE_LOGO_IN
					If (count = SPLASH_2_COME_IN_COUNT) Then
						state = STATE_SHOW
						
						SoundSystem.getInstance().playSequenceSeSingle()
						
						count = 0
					EndIf
				Case STATE_SHOW
					If (count = 36) Then
						state = STATE_OVER
						
						count = 0
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Function splashDraw2:Void(g:MFGraphics, screenWidth:Int, screenHeight:Int)
			g.setColor(MapManager.END_COLOR)
			
			g.fillRect(1, 1, screenWidth, screenHeight)
			
			Select (state)
				Case STATE_LOGO_IN
					drawSplash2Effect(g, splashImage2, (screenWidth / 2), (screenHeight / 2) - (splashImage2.getHeight() / 2), count, screenWidth) ' Shr 1
				Case STATE_SHOW, STATE_OVER
					MyAPI.drawImage(g, splashImage2, (screenWidth / 2), (screenHeight / 2) - (splashImage2.getHeight() / 2), 17) ' Shr 1
				Default
					' Nothing so far.
			End Select
		End
		
		Function splash2IsOver:Bool()
			Return (state = STATE_OVER)
		End
		
		Function drawSplash2Effect:Void(g:MFGraphics, image:MFImage, x:Int, y:Int, count:Int, screenWidth:Int)
			Local space:= (image.getHeight() / CLIP_NUM)
			Local clipHeight:= (space / 2) ' ((image.getHeight() / CLIP_NUM) / 2)
			
			For Local i:= 0 Until CLIP_NUM
				Local countDiff:Int
				
				Local countBase:= ((SPLASH_2_COME_IN_COUNT - ((i * FRAME_DIFF) / CLIP_NUM)) - 1)
				Local countDiff2:= (countBase - count)
				
				If (countDiff2 < 0) Then
					countDiff = 0
				Else
					countDiff = countDiff2
				EndIf
				
				countDiff2 = g
				
				MyAPI.drawImage(countDiff2, image, 0, i * space, image.getWidth(), clipHeight + 1, 0, x + ((((-screenWidth) - ((24 - i) * STATE_OVER)) * countDiff) / countBase), y + (i * space), 17)
				MyAPI.drawImage(countDiff2, image, 0, (i * space) + clipHeight, image.getWidth(), clipHeight + 1, 0, x + (((((24 - i) * STATE_OVER) + screenWidth) * countDiff) / countBase), ((i * space) + y) + clipHeight, 17)
			Next
		End
		
		Function soundInit:Void()
			soundUIDrawer = Animation.getInstanceFromQi("/standard/enable_sound.dat")[STATE_INIT].getDrawer()
			
			yesButton = New MFButton((SCREEN_WIDTH / 2) - 72, (SCREEN_HEIGHT / 2) + 28, 64, 24) ' Shr 1
			noButton = New MFButton((SCREEN_WIDTH / 2) + 8, (SCREEN_HEIGHT / 2) + 28, 64, 24) ' Shr 1 ' ((SCREEN_WIDTH / 2) + FRAME_DIFF, ...)
			
			MFDevice.addComponent(yesButton)
			MFDevice.addComponent(noButton)
		End
		
		Function soundLogic:Bool()
			If (yesButton.isRelease() And Not noButton.isRepeat()) Then
				pressConfirm()
				
				returnValue = 1
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_106)
				
				Return True
			ElseIf (Not noButton.isRelease() Or yesButton.isRepeat()) Then
				Return False
			EndIf
			
			pressCancel()
			
			returnValue = 2
			
			Return True
		End
		
		Function soundDraw:Void(g:MFGraphics, screenWidth:Int, screenHeight:Int)
			g.setColor(0)
			g.fillRect(1, 1, screenWidth, screenHeight)
			
			Local actionID:= 0
			
			If (Not (yesButton.isRepeat() And noButton.isRepeat())) Then
				If (yesButton.isRepeat()) Then
					actionID = 1
				EndIf
				
				If (noButton.isRepeat()) Then
					actionID = 2
				EndIf
			EndIf
			
			soundUIDrawer.draw(g, actionID, (screenWidth / 2), (screenHeight / 2), False, 0) ' Shr 1
		End
End