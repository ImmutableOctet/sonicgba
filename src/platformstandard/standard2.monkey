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
	'Import lib.constutil
	
	Import platformstandard.standard
	
	Import sonicgba.globalresource
	'Import sonicgba.mapmanager
	
	'Import android.os.message
	
	Import com.sega.mflib.main
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	Import com.sega.mobile.framework.ui.mfbutton
Public

' Classes
Class Standard2 Implements Def ' Final
	Private
		' Constant variable(s):
		Const CLIP_NUM:Int = 25
		
		Const FADE_FILL_WIDTH:Int = 40
		Const FADE_FILL_HEIGHT:Int = 40
		
		Const FRAME_DIFF:Int = 8
		
		Const SPLASH_INIT:Int = 0
		Const SPLASH_SOUND:Int = 1
		Const SPLASH_SEGA:Int = 2
		Const SPLASH_SONIC_TEAM:Int = 3
		Const SPLASH_OVER:Int = 4
		Const SPLASH_EXIT:Int = 5
		Const SPLASH_QUIT:Int = 6
		
		Const SPLASH_2_COME_IN_COUNT:Int = 30
		
		Const STANDARD_RES:String = "/standard"
		
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
		Global fadeRGB:Int[] = New Int[1600] ' <-- This will eventually be replaced.
		Global fadeToValue:Int
		Global preFadeAlpha:Int
		
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
		Global activity:Main
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
						
						fadeInit(STATE_INIT, 220)
						
						SoundSystem.getInstance().playSe(STATE_LOGO_IN)
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
		
		Public Function splashDraw:Void(g:MFGraphics, SCREEN_WIDTH:Int, SCREEN_HEIGHT:Int)
			Select (splashState)
				Case STATE_LOGO_IN
					soundDraw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case STATE_SHOW
					splashDraw1(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case STATE_LOGO_OUT
					splashDraw2(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case STATE_OVER
					splashDraw2(g, SCREEN_WIDTH, SCREEN_HEIGHT)
				Case SPLASH_EXIT
					soundDraw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
					drawFade(g)
					SecondEnsurePanelDraw(g, 14)
				Default
			End Select
		}
		
		Public Function splashOver:Bool()
			Return splashState = STATE_OVER
		}
		
		Public Function close:Void()
			splashImage1 = Null
			splashImage2 = Null
		}
		
		Private Function splashInit1:Void()
			splashImage1 = MFImage.createImage("/standard/sega_logo.png")
			count = 0
		}
		
		Private Function splashLogic1:Void()
			count += STATE_LOGO_IN
			Select (state)
				Case STATE_INIT
					splashInit1()
					state = STATE_LOGO_IN
				Case STATE_LOGO_IN
					
					If (count = 16) Then
						state = STATE_SHOW
						count = 0
					EndIf
					
				Case STATE_SHOW
					
					If (count = 60) Then
						state = STATE_LOGO_OUT
						count = 0
					EndIf
					
				Case STATE_LOGO_OUT
					
					If (count = 16) Then
						state = STATE_OVER
						count = 0
					EndIf
					
				Default
			End Select
		}
		
		Private Function splashDraw1:Void(g:MFGraphics, screenWidth:Int, screenHeight:Int)
			g.setColor(MapManager.END_COLOR)
			g.fillRect(STATE_INIT, STATE_INIT, screenWidth, screenHeight)
			Select (state)
				Case STATE_LOGO_IN
					drawSplashEffect1(g, splashImage1, screenWidth Shr STATE_LOGO_IN, (screenHeight Shr STATE_LOGO_IN) - (splashImage1.getHeight() Shr STATE_LOGO_IN), count)
				Case STATE_SHOW
					MyAPI.drawImage(g, splashImage1, screenWidth Shr STATE_LOGO_IN, (screenHeight Shr STATE_LOGO_IN) - (splashImage1.getHeight() Shr STATE_LOGO_IN), 17)
				Case STATE_LOGO_OUT
					drawSplashEffect2(g, splashImage1, screenWidth Shr STATE_LOGO_IN, (screenHeight Shr STATE_LOGO_IN) - (splashImage1.getHeight() Shr STATE_LOGO_IN), count, screenHeight)
				Default
			End Select
		}
		
		Private Function splashIsOver1:Bool()
			Return state = STATE_OVER And count >= 20
		}
		
		Private Function drawSplashEffect1:Void(g:MFGraphics, image:MFImage, x:Int, y:Int, count:Int)
			For (Int i = 0; i < (image.getHeight() + y) - ((image.getHeight() * count) / 16); i += STATE_LOGO_IN)
				MyAPI.drawImage(g, image, STATE_INIT, (image.getHeight() - ((image.getHeight() * count) / 16)) - STATE_LOGO_IN, image.getWidth(), STATE_LOGO_IN, STATE_INIT, x, i, 17)
			Next
			MyAPI.drawImage(g, image, STATE_INIT, image.getHeight() - ((image.getHeight() * count) / 16), image.getWidth(), (image.getHeight() * count) / 16, STATE_INIT, x, (y + image.getHeight()) - ((count * image.getHeight()) / 16), 17)
		}
		
		Private Function drawSplashEffect2:Void(g:MFGraphics, image:MFImage, x:Int, y:Int, count:Int, screenHeight:Int)
			For (Int i = (image.getHeight() + y) - ((image.getHeight() * count) / 16); i < screenHeight; i += STATE_LOGO_IN)
				MyAPI.drawImage(g, image, STATE_INIT, (image.getHeight() - ((image.getHeight() * count) / 16)) - STATE_LOGO_IN, image.getWidth(), STATE_LOGO_IN, STATE_INIT, x, i, 17)
			Next
			MyAPI.drawImage(g, image, STATE_INIT, STATE_INIT, image.getWidth(), image.getHeight() - ((count * image.getHeight()) / 16), STATE_INIT, x, y, 17)
		}
		
		Private Function splashInit2:Void()
			splashImage2 = MFImage.createImage("/standard/sonic_team.png")
			count = 0
		}
		
		Private Function splashLogic2:Void()
			count += STATE_LOGO_IN
			Select (state)
				Case STATE_INIT
					splashInit2()
					state = STATE_LOGO_IN
					SoundSystem.getInstance().preLoadSequenceSe(12)
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
			End Select
		}
		
		Private Function splashDraw2:Void(g:MFGraphics, screenWidth:Int, screenHeight:Int)
			g.setColor(MapManager.END_COLOR)
			g.fillRect(STATE_INIT, STATE_INIT, screenWidth, screenHeight)
			Select (state)
				Case STATE_LOGO_IN
					drawSplash2Effect(g, splashImage2, screenWidth Shr STATE_LOGO_IN, (screenHeight Shr STATE_LOGO_IN) - (splashImage2.getHeight() Shr STATE_LOGO_IN), count, screenWidth)
				Case STATE_SHOW
				Case STATE_OVER
					MyAPI.drawImage(g, splashImage2, screenWidth Shr STATE_LOGO_IN, (screenHeight Shr STATE_LOGO_IN) - (splashImage2.getHeight() Shr STATE_LOGO_IN), 17)
				Default
			End Select
		}
		
		Private Function splash2IsOver:Bool()
			Return state = STATE_OVER
		}
		
		Private Function drawSplash2Effect:Void(g:MFGraphics, image:MFImage, x:Int, y:Int, count:Int, screenWidth:Int)
			Int space = image.getHeight() / CLIP_NUM
			Int clipHeight = (image.getHeight() / CLIP_NUM) / STATE_SHOW
			For (Int i = 0; i < CLIP_NUM; i += STATE_LOGO_IN)
				Int countDiff
				Int countBase = (SPLASH_2_COME_IN_COUNT - ((i * FRAME_DIFF) / CLIP_NUM)) - STATE_LOGO_IN
				Int countDiff2 = countBase - count
				
				If (countDiff2 < 0) Then
					countDiff = 0
				Else
					countDiff = countDiff2
				EndIf
				
				countDiff2 = g
				MFImage mFImage = image
				MyAPI.drawImage(countDiff2, mFImage, STATE_INIT, i * space, image.getWidth(), clipHeight + STATE_LOGO_IN, STATE_INIT, x + ((((-screenWidth) - ((24 - i) * STATE_OVER)) * countDiff) / countBase), y + (i * space), 17)
				countDiff2 = g
				mFImage = image
				MyAPI.drawImage(countDiff2, mFImage, STATE_INIT, (i * space) + clipHeight, image.getWidth(), clipHeight + STATE_LOGO_IN, STATE_INIT, x + (((((24 - i) * STATE_OVER) + screenWidth) * countDiff) / countBase), ((i * space) + y) + clipHeight, 17)
			Next
		}
		
		Private Function soundInit:Void()
			soundUIDrawer = Animation.getInstanceFromQi("/standard/enable_sound.dat")[STATE_INIT].getDrawer()
			yesButton = New MFButton((SCREEN_WIDTH Shr STATE_LOGO_IN) - 72, (SCREEN_HEIGHT Shr STATE_LOGO_IN) + 28, 64, 24)
			noButton = New MFButton((SCREEN_WIDTH Shr STATE_LOGO_IN) + FRAME_DIFF, (SCREEN_HEIGHT Shr STATE_LOGO_IN) + 28, 64, 24)
			MFDevice.addComponent(yesButton)
			MFDevice.addComponent(noButton)
		}
		
		Private Function soundLogic:Bool()
			
			If (yesButton.isRelease() And Not noButton.isRepeat()) Then
				pressConfirm()
				returnValue = STATE_LOGO_IN
				SoundSystem.getInstance().playSe(STATE_LOGO_IN)
				Return True
			ElseIf (Not noButton.isRelease() Or yesButton.isRepeat()) Then
				Return False
			Else
				pressCancel()
				returnValue = STATE_SHOW
				Return True
			EndIf
			
		}
		
		Private Function soundDraw:Void(g:MFGraphics, screenWidth:Int, screenHeight:Int)
			g.setColor(STATE_INIT)
			g.fillRect(STATE_INIT, STATE_INIT, screenWidth, screenHeight)
			Int actionID = 0
			
			If (Not (yesButton.isRepeat() And noButton.isRepeat())) Then
				If (yesButton.isRepeat()) Then
					actionID = STATE_LOGO_IN
				EndIf
				
				If (noButton.isRepeat()) Then
					actionID = STATE_SHOW
				EndIf
			EndIf
			
			soundUIDrawer.draw(g, actionID, screenWidth Shr STATE_LOGO_IN, screenHeight Shr STATE_LOGO_IN, False, STATE_INIT)
		}
		
		Public Function pressConfirm:Void()
			keyConfirm = True
		}
		
		Public Function pressCancel:Void()
			keyCancel = True
		}
		
		Public Function fadeInit:Void(from:Int, to:Int)
			fadeFromValue = from
			fadeToValue = to
			fadeAlpha = fadeFromValue
			preFadeAlpha = -1
		}
		
		Public Function drawFade:Void(g:MFGraphics)
			fadeAlpha = MyAPI.calNextPosition((double) fadeAlpha, (double) fadeToValue, STATE_LOGO_IN, STATE_LOGO_OUT, 3.0)
			
			If (fadeAlpha <> 0) Then
				Int w
				Int h
				
				If (preFadeAlpha <> fadeAlpha) Then
					For (w = 0; w < FADE_FILL_WIDTH; w += STATE_LOGO_IN)
						For (h = 0; h < FADE_FILL_WIDTH; h += STATE_LOGO_IN)
							fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl 24) & -16777216) | (fadeRGB[(h * FADE_FILL_WIDTH) + w] & MapManager.END_COLOR)
						EndIf
					EndIf
					preFadeAlpha = fadeAlpha
				EndIf
				
				For (w = 0; w < MyAPI.zoomOut(SCREEN_WIDTH); w += FADE_FILL_WIDTH)
					For (h = 0; h < MyAPI.zoomOut(SCREEN_HEIGHT); h += FADE_FILL_WIDTH)
						g.drawRGB(fadeRGB, STATE_INIT, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_WIDTH, True)
					EndIf
				EndIf
			EndIf
			
		}
		
		Public Function setFadeOver:Void()
			fadeAlpha = fadeToValue
		}
		
		Public Function fadeChangeOver:Bool()
			Return fadeAlpha = fadeToValue
		}
		
		Public Function secondEnsureInit:Void()
			isConfirm = False
			confirmframe = 0
			confirmcursor = 0
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(STATE_INIT, False, STATE_INIT)
			EndIf
			
			Key.touchSecondEnsureClose()
			Key.touchSecondEnsureInit()
		}
		
		Public Function secondEnsureLogic:Int()
			
			If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
				confirmcursor = STATE_SHOW
			EndIf
			
			If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
				confirmcursor = 0
			EndIf
			
			If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
				confirmcursor = STATE_LOGO_IN
			EndIf
			
			If (isConfirm) Then
				confirmframe += STATE_LOGO_IN
				
				If (confirmframe > FRAME_DIFF) Then
					Return STATE_LOGO_IN
				EndIf
			EndIf
			
			If (Key.touchsecondensureyes.IsButtonPress() And confirmcursor = 0 And Not isConfirm) Then
				isConfirm = True
				confirmframe = 0
				SoundSystem.getInstance().playSe(STATE_LOGO_IN)
				Return STATE_INIT
			ElseIf (Key.touchsecondensureno.IsButtonPress() And confirmcursor = STATE_LOGO_IN And Not isConfirm) Then
				SoundSystem.getInstance().playSe(STATE_SHOW)
				Return STATE_SHOW
			ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver() Or isConfirm) Then
				Return STATE_INIT
			Else
				SoundSystem.getInstance().playSe(STATE_SHOW)
				Return STATE_SHOW
			EndIf
			
		}
		
		Public Function SecondEnsurePanelDraw:Void(g:MFGraphics, ani_id:Int)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(STATE_INIT, False, STATE_INIT)
				Return
			EndIf
			
			muiAniDrawer.setActionId(54)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr STATE_LOGO_IN, (SCREEN_HEIGHT Shr STATE_LOGO_IN) - 20)
			AnimationDrawer animationDrawer = muiAniDrawer
			Int i = (Key.touchsecondensureyes.Isin() And confirmcursor = 0) ? STATE_LOGO_IN : STATE_INIT
			animationDrawer.setActionId(i + 59)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr STATE_LOGO_IN) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr STATE_LOGO_IN) + FADE_FILL_WIDTH)
			animationDrawer = muiAniDrawer
			
			If (Key.touchsecondensureno.Isin() And confirmcursor = STATE_LOGO_IN) Then
				i = STATE_LOGO_IN
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 59)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr STATE_LOGO_IN) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr STATE_LOGO_IN) + FADE_FILL_WIDTH)
			muiAniDrawer.setActionId(46)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr STATE_LOGO_IN) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr STATE_LOGO_IN) + FADE_FILL_WIDTH)
			muiAniDrawer.setActionId(47)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr STATE_LOGO_IN) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr STATE_LOGO_IN) + FADE_FILL_WIDTH)
			muiAniDrawer.setActionId(ani_id)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr STATE_LOGO_IN, (SCREEN_HEIGHT Shr STATE_LOGO_IN) - 20)
			animationDrawer = muiAniDrawer
			
			If (Key.touchsecondensurereturn.Isin()) Then
				i = SPLASH_EXIT
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, STATE_INIT, SCREEN_HEIGHT)
			
			If (isConfirm) Then
				If (confirmframe = STATE_LOGO_IN) Then
					fadeInit(220, 255)
				EndIf
				
				drawFade(g)
				
				If (confirmframe > FRAME_DIFF) Then
					g.setColor(STATE_INIT)
					MyAPI.fillRect(g, STATE_INIT, STATE_INIT, SCREEN_WIDTH, SCREEN_HEIGHT)
				EndIf
			EndIf
			
		}
		
		Public Function getMain:Void(main:Main)
			activity = main
		}
		
		#Rem
			Public Function sendMessage:Void(msg:Message, id:Int)
				'msg.what = id
				'activity.handler.handleMessage(msg)
			End
		#End
End