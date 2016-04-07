Strict

Public

' Imports:
Private
	Import gameengine.def
	Import gameengine.key
	Import gameengine.touchdirectkey
	
	Import lib.constutil
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.record
	Import lib.soundsystem
	
	Import sonicgba.gameobject
	Import sonicgba.globalresource
	'Import sonicgba.playeranimationcollisionrect
	Import sonicgba.sonicdef
	Import sonicgba.stagemanager
	
	Import state.endingstate
	Import state.gamestate
	Import state.specialstagestate
	Import state.stringindex
	Import state.titlestate
	
	'Import android.os.message
	
	'Import com.sega.mflib.main
	
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import application
	
	Import regal.typetool
Public

Class State Implements SonicDef, StringIndex Abstract
	Private
		' Constant variable(s):
		Global BAR_ANIMATION:Int[] = [103, 102, 118] ' Const
		Global BAR_COLOR:Int[] = [255, 0, 16777215] ' Const
		
		' Magic numbers: 55, 58, etc. (Sound-effects IDs?)
		Global OPTION_SOUND:Int[] = [SoundSystem.SE_184, SoundSystem.SE_190, SoundSystem.SE_189, SoundSystem.SE_185] ' [55, 58, 57, 56] ' Const
		
		Global CONFIRM_FRAME_OFFSET_X:Int = Max(FONT_WIDTH * 6, 72) ' Const
		Global CONFIRM_FRAME_OFFSET_Y:Int = Max(MENU_SPACE, 32) + BAR_HEIGHT ' 20 ' Const
		
		Const CONFIRM_OFFSET_X:Int = WARNING_HEIGHT
		Const CONFIRM_STR_OFFSET_X:Int = 44
		
		Const FADE_FILL_WIDTH:Int = 40
		Const FADE_FILL_HEIGHT:Int = 40
		
		Const FRAME_DOWN:Int = 117
		Const FRAME_MIDDLE:Int = 116
		Const FRAME_OFFSET_Y:Int = 24
		Const FRAME_UP:Int = 115
		
		Const HELP_PAGE_BACKGROUND_WIDTH:Int = 64
		
		Const MENU_BG_COLOR_1:Int = 16777215
		Const MENU_BG_COLOR_2:Int = 15658734
		Const MENU_BG_OFFSET:Int = 24
		Global MENU_BG_SPEED:Int = MyAPI.zoomIn(1) ' Const
		Const MENU_BG_WIDTH:Int = 48
		Const MENU_FRAME_BACK_COLOR:Int = 16763904
		Const MENU_FRAME_BAR_COLOR:Int = 16750916
		
		Const PAUSE_SOUND_ITEMS:Int = 4
		
		Const SELECT_BOX_COLOR:Int = 16773039
		Const SELECT_BOX_WIDTH:Int = (FONT_H + 4)
		
		Const SOFT_KEY_OFFSET:Int = 2
		Const SOUND_VOLUMN_WAIT_FRAME:Int = 4
		
		Const STR_YES:Int = 148
		Const STR_NO:Int = 149
		
		' Global variable(s):
		Global fadeAlpha:Int = FADE_FILL_WIDTH
		Global fadeToValue:Int
		Global fadeFromValue:Int
		
		Global fadeRGB:Int[] = New Int[1600] ' <-- This should be removed in the future.
		
		Global helpTitleString:String
		
		Global pause_x:Int = (SCREEN_WIDTH - FADE_FILL_WIDTH)
		Global pause_y:Int = 17 ' (SCREEN_HEIGHT - FADE_FILL_HEIGHT)
		
		Global preFadeAlpha:Int
		
		Global softKeyWidth:Int = WARNING_HEIGHT ' WARNING_WIDTH
		Global softKeyHeight:Int = WARNING_HEIGHT
		Global softKeyImage:MFImage
		
		Global state:State
		Global stateId:Int = -1
	Protected
		' Constant variable(s):
		Const VOL_IMAGE_WIDTH:Int = 8
		Const VOL_SIGN_IMAGE_WIDTH:Int = 10
		
		' Global variable(s):
		Global skipImage:MFImage
		Global volumeImage:MFImage
	Public
		' Constant variable(s):
		Const ARROW_WAIT_FRAME:Int = 4
		Const BACKGROUND_WIDTH:Int = 80
		Const BAR_HEIGHT:Int = 20
		Const BAR_ID_BLACK:Int = 1
		Const BAR_ID_BLUE:Int = 0
		Const BAR_ID_WHITE:Int = 2
		Const BG_NUM:Int = ((SCREEN_WIDTH + BACKGROUND_WIDTH) - 1) / BACKGROUND_WIDTH
		Const CASE_HEIGHT:Int = (SCREEN_HEIGHT - 60)
		Const CASE_WIDTH:Int = MENU_RECT_WIDTH
		Const CASE_X:Int = ((SCREEN_WIDTH - MENU_RECT_WIDTH) Shr 1) ' / 2
		Const CASE_Y:Int = 30
		Const COMFIRM_FRAME_ID:Int = 100
		Const COMFIRM_ID:Int = 10
		Const COMFIRM_X:Int = (SCREEN_WIDTH Shr 1) ' / 2
		Const COMFIRM_Y:Int = (SCREEN_HEIGHT Shr 1) ' / 2
		Const DRAW_NUM:Int = 2
		Const EMERALD_STATE_FAILD:Int = 2
		Const EMERALD_STATE_NONENTER:Int = 0
		Const EMERALD_STATE_SUCCESS:Int = 1
		Const FONT_MOVE_SPEED:Int = 8
		Const FRAME_HEIGHT:Int = ((SCREEN_HEIGHT - FRAME_Y) - FRAME_Y)
		Const FRAME_WIDTH:Int = MENU_RECT_WIDTH
		Const FRAME_X:Int = ((SCREEN_WIDTH - MENU_RECT_WIDTH) Shr 1)
		Const FRAME_Y:Int = 30
		Const LOADING_TYPE_BAR:Int = 2
		Const LOADING_TYPE_BLACK:Int = 0
		Const LOADING_TYPE_WHITE:Int = 1
		
		Global MENU_TITLE_DRAW_NUM:Int = (((SCREEN_WIDTH + MENU_TITLE_MOVE_DIRECTION) - 1) / MENU_TITLE_MOVE_DIRECTION) + 2 ' Const
		Global MENU_TITLE_DRAW_OFFSET_Y:Int = PickValue(MOVING_TITLE_TOP, 10, PickValue(SCREEN_HEIGHT < 220, 10, FRAME_Y)) ' Const
		Global MENU_TITLE_MOVE_DIRECTION:Int = Max(MOVE_DIRECTION_FONT, BACKGROUND_WIDTH) ' Const
		
		Const MESSAGE_EXIT:Int = 5
		Const MESSAGE_GAME_TOP:Int = 2
		Const MESSAGE_INIT_SDK:Int = 0
		Const MESSAGE_PAGE:Int = 1
		Const MESSAGE_RANKING:Int = 3
		Const MESSAGE_SAVE:Int = 6
		Const MESSAGE_USER:Int = 4
		Const MORE_GAME_COMFIRM:Int = 3
		
		Global MOVE_DIRECTION:Int = Max(MOVE_DIRECTION_FONT, 120) ' Const
		
		Const MOVE_DIRECTION_FONT:Int = BACKGROUND_WIDTH ' 80
		Const PAGE_BACKGROUND_HEIGHT:Int = 56
		Const PAGE_BACKGROUND_SPEED:Int = 1
		Const QUIT_COMFIRM:Int = 9
		Global RESET_STR:String[] = MyAPI.getStrings("History reset!", WARNING_FONT_WIDTH) ' ~u8bb0~u5f55~u5df2~u91cd~u7f6e~uff01
		Global RESET_HEIGHT:Int = (RESET_STR.Length * LINE_SPACE) + BAR_HEIGHT ' Const
		Const RESET_Y_DES:Int = (SCREEN_HEIGHT - RESET_HEIGHT)
		Const RETURN_PRESSED:Int = 400
		Const STAGE_MOVE_DIRECTION:Int = 224
		Const STATE_ENDING:Int = 8
		Const STATE_EXTRA_ENDING:Int = 11
		Const STATE_GAME:Int = 1
		Const STATE_NORMAL_ENDING:Int = 10
		Const STATE_RETURN_FROM_GAME:Int = 2
		Const STATE_SCORE_RANKING:Int = 4
		Const STATE_SELECT_CHARACTER:Int = 9
		Const STATE_SELECT_NORMAL_STAGE:Int = 5
		Const STATE_SELECT_RACE_STAGE:Int = 3
		Const STATE_SPECIAL:Int = 6
		Const STATE_SPECIAL_ENDING:Int = 12
		Const STATE_SPECIAL_TO_GMAE:Int = 7
		Const STATE_TITLE:Int = 0
		Const TEXT_DISPLAY_WIDTH:Int = 188
		Const TOOL_TIP_FONT_WIDTH:Int = WARNING_FONT_WIDTH
		Const TOOL_TIP_WIDTH:Int = WARNING_WIDTH
		Const WARNING_FONT_WIDTH:Int = (SCREEN_WIDTH - ((WARNING_X + 5) * 2)) ' (10 / 2)
		Const WARNING_HEIGHT:Int = (WARNING_STR.Length * LINE_SPACE) + BAR_HEIGHT)
		Global WARNING_STR:String[] = MyAPI.getStrings(WARNING_STR_ORIGNAL, WARNING_FONT_WIDTH) ' Const
		Const WARNING_STR_ORIGNAL:String = "WARNING: Starting a new game will overwrite your current game progress." ' "~u8b66~u544a~uff1a~u5f00~u59cb~u65b0~u6e38~u620f~u5c06~u8986~u76d6~u60a8~u5f53~u524d~u7684~u6e38~u620f~u8fdb~u5ea6"
		Const WARNING_WIDTH:Int = (SCREEN_WIDTH - (WARNING_X * 2))
		Const WARNING_X:Int = PickValue(SCREEN_WIDTH > SCREEN_HEIGHT, 50, 26)
		Const WARNING_Y_DES:Int = (SCREEN_HEIGHT - WARNING_HEIGHT)
		Const WARNING_Y_DES_2:Int = (SCREEN_HEIGHT + FADE_FILL_WIDTH)
		Const BP_ITEM_BLUE_SHELTER:Byte = 1
		Const BP_ITEM_GREEN_SHELTER:Byte = 2
		Const BP_ITEM_INVINCIBILITY:Byte = 0
		Const BP_ITEM_SPEED:Byte = 3
		Const TXT_BLUE_SHELTER_EFFECT:Byte = 14
		Const TXT_BUY_TOOL:Byte = 18
		Const TXT_BUY_TOOLS_TEXT:Byte = 8
		Const TXT_BUY_TOOLS_TITLE:Byte = 7
		Const TXT_CONTINUE_TRY:Byte = 2
		Const TXT_EFFECT:Byte = 12
		Const TXT_GREEN_SHELTER_EFFECT:Byte = 15
		Const TXT_HOLD_NUM:Byte = 11
		Const TXT_INVINCIBILITY_EFFECT:Byte = 16
		Const TXT_MENU:Byte = 10
		Const TXT_PAY:Byte = 1
		Const TXT_PAY_TEXT:Byte = 4
		Const TXT_PAY_TITLE:Byte = 3
		Const TXT_REVIVE_TEXT:Byte = 6
		Const TXT_REVIVE_TITLE:Byte = 5
		Const TXT_SHOP:Byte = 9
		Const TXT_SPEED_EFFECT:Byte = 13
		Const TXT_TOOL:Byte = 17
		Const TXT_TOOL_MAX:Byte = 19
		Const TXT_TRY_TITLE:Byte = 0
		Const TXT_USE_BLUE_SHELTER:Byte = 21
		Const TXT_USE_GREEN_SHELTER:Byte = 22
		Const TXT_USE_INVINCIBILITY:Byte = 20
		Const TXT_USE_SPEED:Byte = 23
		
		' Global variable(s):
		Global aboutStrings:String[]
		Global activity:Application
		Global allStrings:String[]
		Global arrowAnimation:Animation
		Global BPEffectStrings:String[][]
		Global BPPayingTitle:String
		Global BPstrings:String[]
		Global BP_enteredPaying:Bool = False
		Global BP_itemsHeight:Int = 0
		Global BP_itemsImg:MFImage = Null
		Global BP_itemsWidth:Int = 0
		Global BP_items_num:Byte[] = New Byte[4]
		Global BP_wordsHeight:Int = 0
		Global BP_wordsImg:MFImage = Null
		Global BP_wordsWidth:Int = 0
		Global downArrowDrawer:AnimationDrawer
		Global fading:Bool
		Global helpStrings:String[]
		Global IsAllClear:Bool = False
		Global isDrawTouchPad:Bool
		Global IsGameOver:Bool = False
		Global IsInInterrupt:Bool = False
		Global isInSPStage:Bool = False
		Global IsPaid:Bool = False
		Global IsTimeOver:Bool = False
		Global lastFading:Bool
		Global loadingType:Int = LOADING_TYPE_BLACK
		Global leftArrowDrawer:AnimationDrawer
		Global menuBg:MFImage
		Global menuFontDrawer:AnimationDrawer
		Global muiAniDrawer:AnimationDrawer
		Global muiDownArrowDrawer:AnimationDrawer
		Global muiLeftArrowDrawer:AnimationDrawer
		Global muiRightArrowDrawer:AnimationDrawer
		Global muiUpArrowDrawer:AnimationDrawer
		Global PageBackGroundOffsetX:Int = 0
		Global PageBackGroundOffsetY:Int = 0
		Global PageFrameCnt:Int = 0
		Global rightArrowDrawer:AnimationDrawer
		Global SELECT_BAR_WIDTH:Int = 40
		Global strForShow:String[]
		Global tool_id:Int
		Global TOOL_TIP_HEIGHT:Int = 0
		Global TOOL_TIP_STR:String[]
		Global TOOL_TIP_STR_ORIGNAL:String
		Global TOOL_TIP_X:Int = WARNING_X
		Global TOOL_TIP_Y_DES:Int = 0
		Global TOOL_TIP_Y_DES_2:Int = WARNING_Y_DES_2
		Global touchgamekeyboardAnimation:Animation
		Global touchgamekeyboardDrawer:AnimationDrawer
		Global touchgamekeyImage:MFImage
		Global touchkeyboardAnimation:Animation
		Global touchkeyboardDrawer:AnimationDrawer
		Global trytimes:Int = 3 ' STATE_SELECT_RACE_STAGE
		Global upArrowDrawer:AnimationDrawer
		Global VOLUME_X:Int = (SCREEN_WIDTH - (((VOL_IMAGE_WIDTH - 1) * 10) + 1)) Shr 1
		Global warningY:Int = WARNING_Y_DES_2
	Private
		' Fields:
		Field helpIndex:Int
		Field timeCnt:Int
		
		Field isSoundVolumnClick:Bool
	Public
		' Fields:
		Field isArrowClicked:Bool
		Field isConfirm:Bool
		Field IsInBP:Bool
		Field isItemsSelect:Bool
		Field menuMoving:Bool
		
		Field arrowframecnt:Int
		Field arrowindex:Int
		Field confirmcursor:Int
		Field confirmframe:Int
		Field cursor:Int
		Field elementNum:Int
		Field Finalitemsselectcursor:Int
		Field itemsselectcursor:Int
		Field itemsselectframe:Int
		Field mainMenuItemCursor:Int
		
		Field MORE_GAME_WIDTH:Int
		Field MORE_GAME_HEIGHT:Int
		Field MORE_GAME_START_X:Int
		Field MORE_GAME_START_Y:Int
		
		Field pauseoptionCursor:Int
		Field returnCursor:Int
		Field returnPageCursor:Int
		Field selectMenuOffsetX:Int
		Field titleBgOffsetX:Int
		Field titleBgOffsetY:Int
		Field tooltipY:Int
		Field currentElement:Int[]
		Field textBGImage:MFImage
		
		' Methods (Abstract):
		Method close:Void() Abstract
		Method draw:Void(mFGraphics:MFGraphics) Abstract
		Method init:Void() Abstract
		Method logic:Void() Abstract
		Method pause:Void() Abstract
		
		' Constructor(s):
		Method New()
			Self.selectMenuOffsetX = 0
			Self.isArrowClicked = False
			Self.arrowindex = -1
			Self.returnPageCursor = 0
			
			Self.MORE_GAME_WIDTH = FRAME_WIDTH
			Self.MORE_GAME_HEIGHT = ((MENU_SPACE * STATE_SCORE_RANKING) + BAR_HEIGHT)
			Self.MORE_GAME_START_X = FRAME_X
			Self.MORE_GAME_START_Y = ((SCREEN_HEIGHT - Self.MORE_GAME_HEIGHT) Shr 1) ' / 2
			
			Self.menuMoving = True
			Self.returnCursor = 0
			Self.tooltipY = TOOL_TIP_Y_DES_2
			Self.IsInBP = False
			Self.confirmcursor = 0
		End
		
		' Functions:
		Function setSoundVolumnDown:Void()
			If (GlobalResource.soundConfig <= 0) Then
				GlobalResource.soundConfig = 0
			Else
				GlobalResource.soundConfig -= 1
			EndIf
			
			If (GlobalResource.soundConfig = 0) Then
				GlobalResource.seConfig = 0
			EndIf
			
			SoundSystem.getInstance().setVolumnState(GlobalResource.soundConfig)
			SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
		End
		
		Function setSoundVolumnUp:Void()
			If (GlobalResource.soundConfig >= 15) Then
				GlobalResource.soundConfig = 15
			Else
				GlobalResource.soundConfig += 1
			EndIf
			
			If (GlobalResource.soundConfig = 1) Then
				SoundSystem.getInstance().resumeBgm()
			EndIf
			
			If (GlobalResource.soundConfig > 0) Then
				GlobalResource.seConfig = 1
			EndIf
			
			SoundSystem.getInstance().setVolumnState(GlobalResource.soundConfig)
			SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
		End
		
		Function getMain:Void(app:Application)
			activity = app
		End
		
		Function setState:Void(mStateId:Int)
			If (stateId <> mStateId) Then
				If (state <> Null) Then
					state.close()
					
					state = Null
					
					'System.gc()
				EndIf
				
				stateId = mStateId
				
				Select (stateId)
					Case STATE_TITLE
						state = New TitleState()
					Case STATE_GAME
						Key.touchCharacterSelectModeClose()
						state = New GameState()
					Case STATE_RETURN_FROM_GAME
						Key.touchkeyboardClose()
					Case STATE_SELECT_RACE_STAGE, STATE_SCORE_RANKING, STATE_SELECT_NORMAL_STAGE, STATE_SELECT_CHARACTER
						state = New TitleState(stateId)
					Case STATE_SPECIAL
						state = New SpecialStageState()
					Case STATE_SPECIAL_TO_GMAE
						state = New GameState(stateId)
					Case STATE_NORMAL_ENDING
						state = New EndingState(0)
					Case STATE_EXTRA_ENDING
						state = New EndingState(1)
					Case STATE_SPECIAL_ENDING
						state = New EndingState(2)
				End Select
				
				state.init()
				isDrawTouchPad = False
				
				If (stateId = STATE_SPECIAL) Then
					isInSPStage = True
				Else
					isInSPStage = False
				EndIf
			EndIf
		End
		
		Function stateLogic:Void()
			SoundSystem.getInstance().exec()
			
			If (state <> Null) Then
				arrowLogic()
				state.logic()
			EndIf
		End
		
		Function stateDraw:Void(g:MFGraphics)
			If (state <> Null) Then
				MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				state.draw(g)
				
				If (fading) Then
					drawFade(g)
				EndIf
			EndIf
		End
		
		Function stateInit:Void()
			Key.init()
			Record.initRecord()
			initArrowDrawer()
			StageManager.loadStageRecord()
			GlobalResource.loadSystemConfig()
			SpecialStageState.loadData()
			StageManager.loadHighScoreRecord()
		End
		
		Function exitGame:Void()
			If (state <> Null) Then
				state.close()
				
				state = Null
			EndIf
			
			MFDevice.notifyExit()
		End
		
		Function statePause:Void()
			If (state <> Null) Then
				state.pause()
			EndIf
			
			SoundSystem.getInstance().stopBgm(True)
		End
		
		Function pauseTrigger:Void()
			If (SoundSystem.getInstance().bgmPlaying2()) Then
				SoundSystem.getInstance().stopBgm(True)
				SoundSystem.getInstance().stopLongSe()
				SoundSystem.getInstance().stopLoopSe()
			EndIf
		End
		
		Function arrowLogic:Void()
			' Empty implementation.
		End
		
		Function setFadeColor:Void(color:Int)
			' This should be replaced in the future:
			For Local i:= 0 Until fadeRGB.Length
				fadeRGB[i] = color
			Next
		End
		
		Function fadeInit:Void(from:Int, dest:Int)
			' Magic numbers: 220, 102, 192
			If (dest = 220 Or dest = 102) Then
				dest = 192
			EndIf
			
			fadeFromValue = from
			fadeToValue = dest
			fadeAlpha = fadeFromValue
			preFadeAlpha = -1
		End
		
		Function fadeInit_Modify:Void(from:Int, dest:Int)
			fadeFromValue = from
			fadeToValue = dest
			fadeAlpha = fadeFromValue
			preFadeAlpha = -1
		End
		
		Function getCurrentFade:Int()
			Return fadeAlpha
		End
	
		Function fadeInitAndStart:Void(from:Int, dest:Int)
			fadeFromValue = from
			fadeToValue = dest
			fadeAlpha = fadeFromValue
			preFadeAlpha = -1
			
			fading = True
		End
		
		Function initTouchkeyBoard:Void()
			If (touchkeyboardAnimation = Null) Then
				touchkeyboardAnimation = New Animation("/tuch/control_panel")
			EndIf
			
			touchkeyboardDrawer = touchkeyboardAnimation.getDrawer(0, True, 0)
			touchgamekeyboardDrawer = touchkeyboardAnimation.getDrawer(0, True, 0)
		End
		
		Function releaseTouchkeyBoard:Void()
			Animation.closeAnimation(touchkeyboardAnimation)
			touchkeyboardAnimation = Null
			
			Animation.closeAnimationDrawer(touchkeyboardDrawer)
			touchkeyboardDrawer = Null
			
			Animation.closeAnimation(touchgamekeyboardAnimation)
			touchgamekeyboardAnimation = Null
			
			Animation.closeAnimationDrawer(touchgamekeyboardDrawer)
			touchgamekeyboardDrawer = Null
			
			touchgamekeyImage = Null
		End
		
		Function drawTouchGameKey:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Function drawTouchKeyBoardById:Void(g:MFGraphics, id:Int, x:Int, y:Int)
			touchkeyboardDrawer.setActionId(id)
			touchkeyboardDrawer.draw(g, x, y)
		End
		
		Function drawTouchGameKeyBoardById:Void(g:MFGraphics, id:Int, x:Int, y:Int)
			touchgamekeyboardDrawer.setActionId(id)
			touchgamekeyboardDrawer.draw(g, x, y)
		End
	Private
		' Functions:
		Function initArrowDrawer:Void()
			' Empty implementation.
		End
		
		Function drawFadeCore:Void(g:MFGraphics)
			' This implementation will need to be replaced:
			If (fadeAlpha <> 0) Then
				If (preFadeAlpha <> fadeAlpha) Then
					For Local w:= 0 Until FADE_FILL_WIDTH
						For Local h:= 0 Until FADE_FILL_HEIGHT
							fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl MENU_BG_OFFSET) & -16777216) | (fadeRGB[(h * FADE_FILL_WIDTH) + w] & MENU_BG_COLOR_1)
						Next
					Next
					
					preFadeAlpha = fadeAlpha
				EndIf
				
				For Local w:= 0 Until MyAPI.zoomOut(SCREEN_WIDTH) Step FADE_FILL_WIDTH
					For Local w:= 0 Until MyAPI.zoomOut(SCREEN_HEIGHT) Step FADE_FILL_HEIGHT
						g.drawRGB(fadeRGB, 0, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_WIDTH, True)
					Next
				Next
			EndIf
		End
		
		Function drawLeftSoftKey:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Function drawRightSoftKey:Void(g:MFGraphics)
			' Empty implementation.
		End
	Public
		' Functions:
		Function drawFadeBase:Void(g:MFGraphics, vel2:Int)
			fadeAlpha = MyAPI.calNextPosition(Double(fadeAlpha), Double(fadeToValue), 1, vel2, 3.0)
			
			drawFadeCore(g)
		End
		
		Function drawFadeInSpeed:Void(g:MFGraphics, vel:Int)
			If (fadeFromValue > fadeToValue) Then
				fadeAlpha -= vel
				
				If (fadeAlpha <= fadeToValue) Then
					fadeAlpha = fadeToValue
				EndIf
			ElseIf (fadeFromValue < fadeToValue) Then
				fadeAlpha += vel
				
				If (fadeAlpha >= fadeToValue) Then
					fadeAlpha = fadeToValue
				EndIf
			EndIf
			
			drawFadeCore(g)
		End
		
		Function drawFade:Void(g:MFGraphics)
			' Magic number: 3 (Fade speed?)
			drawFadeBase(g, 3)
		End
		
		Function staticDrawFadeSlow:Void(g:MFGraphics)
			If (state <> Null) Then
				drawFadeSlow(g)
			EndIf
		End
		
		Function drawFadeSlow:Void(g:MFGraphics)
			' Magic number: 6 (Fade speed?)
			drawFadeBase(g, 6)
		End
		
		Function fadeChangeOver:Bool()
			Return (fadeAlpha = fadeToValue)
		End
		
		Function getFade:Int()
			Return fadeAlpha
		End
		
		Function setFadeOver:Void()
			fadeAlpha = fadeToValue
		End
		
		Function drawSoftKey:Void(g:MFGraphics, IsLeft:Bool, IsRight:Bool)
			If (IsLeft) Then
				drawLeftSoftKey(g)
			EndIf
			
			If (IsRight) Then
				drawRightSoftKey(g)
			EndIf
		End
		
		Function drawSoftKeyPause:Void(g:MFGraphics)
			' Magic numbers: 32, 14, 13
			If (Not isInSPStage) Then
				Local offsetx:= PickValue((GameObject.stageModeState = 0), 0, 32)
				
				If (Key.touchkey_pause = Null) Then
					Return
				EndIf
				
				If (Key.touchkey_pause.Isin()) Then
					drawTouchKeyBoardById(g, 14, SCREEN_WIDTH + offsetx, 0)
				Else
					drawTouchKeyBoardById(g, 13, SCREEN_WIDTH + offsetx, 0)
				EndIf
			ElseIf (Key.touchspstagepause = Null) Then
				' Nothing so far.
			Else
				If (Key.touchspstagepause.Isin()) Then
					drawTouchKeyBoardById(g, 14, SCREEN_WIDTH + 32, 0)
				Else
					drawTouchKeyBoardById(g, 13, SCREEN_WIDTH + 32, 0)
				EndIf
			EndIf
		End
		
		Function drawSkipSoftKey:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Function initMenuFont:Void()
			' Empty implementation.
		End
		
		Function drawMenuFontById:Void(g:MFGraphics, id:Int, x:Int, y:Int)
			drawMenuFontById(g, id, x, y, 0)
		End
		
		Function drawMenuFontById:Void(g:MFGraphics, id:Int, x:Int, y:Int, trans:Int)
			' Empty implementation.
		End
		
		Function drawMenuStringById:Void(g:MFGraphics, id:Int, x:Int, y:Int, trans:Int)
			' Empty implementation.
		End
		
		Function drawMenuFontByString:Void(g:MFGraphics, string:String, x:Int, y:Int, anchor:Int, color1:Int, color2:Int)
			MyAPI.drawBoldString(g, string, x, y - FONT_H_HALF, anchor, color1, color2)
		End
		
		Function drawMenuFontByString:Void(g:MFGraphics, id:Int, x:Int, y:Int)
			drawMenuFontByString(g, id, x, y, 17)
		End
		
		Function drawMenuFontByString:Void(g:MFGraphics, id:Int, x:Int, y:Int, anchor:Int)
			' Empty implementation.
		End
		
		Function drawMenuFontByString:Void(g:MFGraphics, string:String, x:Int, y:Int, anchor:Int)
			drawMenuFontByString(g, string, x, y, anchor, MENU_BG_COLOR_1, 0)
		End
		
		Function getMenuFontWidth:Int(id:Int)
			If (menuFontDrawer = Null) Then
				initMenuFont()
			EndIf
			
			menuFontDrawer.setActionId(id)
			
			Return menuFontDrawer.getCurrentFrameWidth()
		End
		
		Function drawBar:Void(g:MFGraphics, barID:Int, x:Int, y:Int)
			g.setColor(BAR_COLOR[barID])
			
			MyAPI.fillRect(g, x, y - 10, SCREEN_WIDTH, BAR_HEIGHT)
		End
		
		Function drawMenuBar:Void(g:MFGraphics, barID:Int, x:Int, y:Int)
			For Local i:= 0 Until BG_NUM
				drawMenuFontById(g, BAR_ANIMATION[barID], (i * BACKGROUND_WIDTH) + x, y)
			Next
		End
		
		Function drawBar:Void(g:MFGraphics, barID:Int, y:Int)
			drawBar(g, barID, 0, y)
		End
		
		Function fillMenuRect:Void(g:MFGraphics, x:Int, y:Int, w:Int, h:Int)
			drawMenuFontById(g, FRAME_DOWN, x, y + h)
			drawMenuFontById(g, FRAME_DOWN, x + w, y + h, 2)
			
			If (h - MENU_BG_WIDTH > 0) Then
				MyAPI.setClip(g, x, y + MENU_BG_OFFSET, w, h - MENU_BG_WIDTH)
				For (Int i = 0; i < h - MENU_BG_WIDTH; i += MENU_BG_OFFSET)
					drawMenuFontById(g, FRAME_MIDDLE, x, (y + MENU_BG_OFFSET) + i)
					drawMenuFontById(g, FRAME_MIDDLE, x + w, (y + MENU_BG_OFFSET) + i, 2)
				Next
			EndIf
			
			MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			drawMenuFontById(g, FRAME_UP, x, y)
			drawMenuFontById(g, FRAME_UP, x + w, y, 2)
		End
		
		Function setTry:Void()
			If (trytimes > 0) Then
				trytimes -= 1
			Else
				trytimes = 0
			EndIf
		End
		
		Function IsActiveGame:Bool()
			Return False
		End
		
		Function IsToolsCharge:Bool()
			Return False
		End
		
		Function activeGameProcess:Void(state:Bool)
			IsPaid = state
		End
		
		Function load_bp_string:Void()
			setMenu()
		End
		
		Function setMenu:Void()
			TitleState.setMainMenu()
			GameState.setPauseMenu()
		End
		
		Function init_bp:Void()
			' Empty implementation.
		End
		
		Function loadBPRecord:Void()
		End
		
		Function saveBPRecord:Void()
			' Empty implementation.
		End
		
		Function BP_chargeLogic:Bool(index:Int)
			Return False
		End
		
		Function BP_IsChargeByIndex:Bool(index:Int)
			Return False
		End
		
		Function BP_loadImage:Void()
			' Empty implementation.
		End
	Private
		' Methods:
		Method transTouchPointX:Int(directkey:TouchDirectKey, pointx:Int, pointy:Int)
			Local reset_x:= (pointx - 32)
			Local reset_y:= (pointy - 128)
			
			If ((reset_x * reset_x) + (reset_y * reset_y) > RollPlatformSpeedC.COLLISION_OFFSET_Y) Then
				Return ((Cos(directkey.getDegree()) * 16) / 100) + 32
			EndIf
			
			Return pointx
		End
		
		Method transTouchPointY:Int(directkey:TouchDirectKey, pointx:Int, pointy:Int)
			Local reset_x:= (pointx - 32)
			Local reset_y:= (pointy - 128)
			
			If ((reset_x * reset_x) + (reset_y * reset_y) > RollPlatformSpeedC.COLLISION_OFFSET_Y) Then
				Return ((Sin(directkey.getDegree()) * 16) / 100) + 128
			EndIf
			
			Return pointy
		End
		
		Method drawTouchKeyDirectPad:Void(g:MFGraphics)
			Local degree:= 0
			
			If (Key.touchdirectgamekey <> Null) Then
				degree = Key.touchdirectgamekey.getDegree()
			EndIf
			
			Local id:= 0
			
			' Magic numbers (Constants need to be replaced, etc):
			If (degree >= 248 And degree < 292) Then
				id = 1
			ElseIf (degree >= 292 And degree < 337) Then
				id = 2
			ElseIf ((degree >= 0 And degree < 22) Or (degree >= 337 And degree <= 360)) Then
				id = STATE_SELECT_RACE_STAGE
			ElseIf (degree >= 22 And degree < 67) Then
				id = STATE_SCORE_RANKING
			ElseIf (degree >= 67 And degree < 113) Then
				id = STATE_SELECT_NORMAL_STAGE
			ElseIf (degree >= 113 And degree < 157) Then
				id = STATE_SPECIAL
			ElseIf (degree >= 157 And degree < 202) Then
				id = STATE_SPECIAL_TO_GMAE
			ElseIf (degree >= 202 And degree < 248) Then
				id = STATE_ENDING
			EndIf
			
			drawTouchGameKeyBoardById(g, id, 32, 128)
		End
	Public
		' Methods:
		Method comfirmLogic:Int()
			Key.touchConfirmInit()
			
			If (Key.press(Key.gSelect | Key.B_S1)) Then
				Key.touchConfirmClose()
				
				Return Self.cursor
			ElseIf (Key.touchConfirmYes.Isin() And Self.cursor = 1) Then
				Self.cursor = 0
				
				Key.touchConfirmYes.reset()
				
				Return -1
			ElseIf (Key.touchConfirmNo.Isin() And Self.cursor = 0) Then
				Self.cursor = 1
				
				Key.touchConfirmNo.reset()
				
				Return -1
			ElseIf ((Key.touchConfirmYes.Isin() And Self.cursor = 0) Or (Key.touchConfirmNo.Isin() And Self.cursor = 1)) Then
				Key.touchConfirmClose()
				
				Return Self.cursor
			Else
				If (Key.press(2)) Then
					' Nothing so far.
				EndIf
				
				If (Key.press(Key.B_BACK)) Then
					Key.touchConfirmClose()
					Return RETURN_PRESSED
				EndIf
				
				If (Key.press(Key.gLeft)) Then
					Self.cursor -= 1
					Self.cursor += 2
					Self.cursor Mod= 2
				ElseIf (Key.press(Key.gRight)) Then
					Self.cursor += 1
					Self.cursor += 2
					Self.cursor Mod= 2
				EndIf
				
				Return -1
			EndIf
		End
		
		Method comfirmDraw:Void(g:MFGraphics, id:Int)
			drawMenuFontById(g, 100, COMFIRM_X, COMFIRM_Y)
			drawMenuFontById(g, id, COMFIRM_X, COMFIRM_Y - (MENU_SPACE Shr 1))
			drawMenuFontById(g, 101, ((Self.cursor * FADE_FILL_WIDTH) + COMFIRM_X) - BAR_HEIGHT, COMFIRM_Y + (MENU_SPACE Shr 1))
			drawMenuFontById(g, 10, COMFIRM_X, COMFIRM_Y + (MENU_SPACE Shr 1))
		End
		
		Method confirmDraw:Void(g:MFGraphics, title:String)
			drawMenuFontById(g, 100, COMFIRM_X, COMFIRM_Y)
			MyAPI.drawBoldString(g, title, COMFIRM_X, ((COMFIRM_Y - CONFIRM_FRAME_OFFSET_Y) + 10) + LINE_SPACE, 17, MENU_BG_COLOR_1, 4656650)
			drawMenuFontById(g, 101, ((Self.cursor * FADE_FILL_WIDTH) + COMFIRM_X) - BAR_HEIGHT, COMFIRM_Y + (MENU_SPACE Shr 1))
			drawMenuFontById(g, 10, COMFIRM_X, COMFIRM_Y + (MENU_SPACE Shr 1))
		End
		
		Method menuBgDraw:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Method drawLowQualifyBackGround:Void(g:MFGraphics, color1:Int, color2:Int, offset:Int)
			g.setColor(color1)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			g.setColor(color2)
			
			Self.titleBgOffsetX += MENU_BG_SPEED
			Self.titleBgOffsetY += MENU_BG_SPEED
			
			Self.titleBgOffsetX Mod= offset
			Self.titleBgOffsetY Mod= offset
			
			For Local x:= ((-offset) + Self.titleBgOffsetX) Until SCREEN_WIDTH
				For Local y:= ((-offset) - Self.titleBgOffsetY) Until SCREEN_HEIGHT
					MyAPI.fillRect(g, x, y, (offset Shr 1), (offset Shr 1))
					MyAPI.fillRect(g, (offset Shr 1) + x, (offset Shr 1) + y, (offset Shr 1), (offset Shr 1))
				Next
			Next
		End
		
		Method drawMenuTitle:Void(g:MFGraphics, id:Int, y:Int)
			drawScrollFont(g, id, MENU_TITLE_DRAW_OFFSET_Y, MENU_TITLE_MOVE_DIRECTION)
		End
		
		Method drawMenuTitle:Void(g:MFGraphics, id:Int, y:Int, width:Int)
			drawScrollFont(g, id, MENU_TITLE_DRAW_OFFSET_Y, PickValue((width > 0), width, MENU_TITLE_MOVE_DIRECTION))
		End
		
		Method drawScrollFont:Void(g:MFGraphics, id:Int, y:Int, width:Int)
			drawBar(g, 0, y)
			
			Self.selectMenuOffsetX += STATE_ENDING
			Self.selectMenuOffsetX Mod= width
			
			Local x:= 0
			
			While (x - Self.selectMenuOffsetX > 0)
				x -= width
			Wend
			
			For Local i:= 0 Until MENU_TITLE_DRAW_NUM
				drawMenuFontById(g, id, (x + (i * width)) - Self.selectMenuOffsetX, y)
			Next
		End
		
		Method helpInit:Void()
			helpStrings = MyAPI.loadText("/help")
			
			Self.helpIndex = 0
			
			MyAPI.initString()
			
			strForShow = MyAPI.getStrings(helpStrings[Self.helpIndex], STATE_EXTRA_ENDING, SCREEN_WIDTH)
			helpTitleString = MyAPI.getStringToDraw(strForShow[0])
			
			' Optimization potential: Multiple objects may not be needed.
			muiLeftArrowDrawer = New Animation("/animation/mui").getDrawer(91, True, 0)
			muiRightArrowDrawer = New Animation("/animation/mui").getDrawer(92, True, 0)
			muiUpArrowDrawer = New Animation("/animation/mui").getDrawer(93, True, 0)
			muiDownArrowDrawer = New Animation("/animation/mui").getDrawer(94, True, 0)
			
			Key.touchInstructionInit()
			
			Self.arrowframecnt = 0
			Self.isArrowClicked = False
			
			PageFrameCnt = 0
			
			If (Self.textBGImage = Null) Then
				Self.textBGImage = MFImage.createImage("/animation/text_bg.png")
			EndIf
			
			Self.arrowindex = -1
			Self.returnPageCursor = 0
		End
		
		Method helpLogic:Void()
			If (Key.touchhelpleftarrow.Isin() And Key.touchpage.IsClick()) Then
				Self.arrowindex = 0
			ElseIf (Key.touchhelprightarrow.Isin() And Key.touchpage.IsClick()) Then
				Self.arrowindex = 1
			EndIf
			
			If (Key.touchhelpreturn.Isin() And Key.touchpage.IsClick()) Then
				Self.returnPageCursor = 1
			EndIf
			
			If (Key.slidesensorhelp.isSliding()) Then
				If (Key.slidesensorhelp.isSlide(Key.DIR_UP)) Then
					MyAPI.logicString(True, False)
				ElseIf (Key.slidesensorhelp.isSlide(Key.DIR_DOWN)) Then
					MyAPI.logicString(False, True)
				EndIf
			EndIf
			
			If (Key.touchhelpuparrow.Isin()) Then
				Self.arrowframecnt += 1
				
				If (Self.arrowframecnt <= STATE_SCORE_RANKING And Not Self.isArrowClicked) Then
					MyAPI.logicString(False, True)
					Self.isArrowClicked = True
				ElseIf (Self.arrowframecnt > STATE_SCORE_RANKING And Self.arrowframecnt Mod 2 = 0) Then
					MyAPI.logicString(False, True)
				EndIf
				
			ElseIf (Key.touchhelpdownarrow.Isin()) Then
				Self.arrowframecnt += 1
				
				If (Self.arrowframecnt <= STATE_SCORE_RANKING And Not Self.isArrowClicked) Then
					MyAPI.logicString(True, False)
					Self.isArrowClicked = True
				ElseIf (Self.arrowframecnt > STATE_SCORE_RANKING And Self.arrowframecnt Mod 2 = 0) Then
					MyAPI.logicString(True, False)
				EndIf
			Else
				Self.arrowframecnt = 0
				Self.isArrowClicked = False
			EndIf
			
			If (Key.touchhelpleftarrow.IsButtonPress() And Self.arrowindex = 0) Then
				SoundSystem.getInstance().playSe(STATE_SELECT_RACE_STAGE)
				
				Self.helpIndex -= 1
				Self.helpIndex += helpStrings.Length
				Self.helpIndex Mod= helpStrings.Length
				
				MyAPI.initString()
				
				strForShow = MyAPI.getStrings(helpStrings[Self.helpIndex], STATE_EXTRA_ENDING, SCREEN_WIDTH)
			ElseIf (Key.touchhelprightarrow.IsButtonPress() And Self.arrowindex = 0) Then
				SoundSystem.getInstance().playSe(STATE_SELECT_RACE_STAGE)
				
				Self.helpIndex += 1
				Self.helpIndex Mod= helpStrings.Length
				
				MyAPI.initString()
				
				strForShow = MyAPI.getStrings(helpStrings[Self.helpIndex], STATE_EXTRA_ENDING, SCREEN_WIDTH)
			EndIf
		End
		
		Method helpDraw:Void(g:MFGraphics)
			drawFade(g)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			muiAniDrawer.setActionId(62)
			PageFrameCnt += 1
			PageFrameCnt Mod= STATE_EXTRA_ENDING
			
			If (PageFrameCnt Mod 2 = 0) Then
				PageBackGroundOffsetX += 1
				PageBackGroundOffsetX Mod= HELP_PAGE_BACKGROUND_WIDTH
				PageBackGroundOffsetY -= 1
				PageBackGroundOffsetY Mod= PAGE_BACKGROUND_HEIGHT
			EndIf
			
			For Local x:= (PageBackGroundOffsetX - 64)  Until ((SCREEN_WIDTH * 3) / 2) Step HELP_PAGE_BACKGROUND_WIDTH
				For Local y:= (PageBackGroundOffsetY - 56) Until  ((SCREEN_HEIGHT * 3) / 2) Step PAGE_BACKGROUND_HEIGHT
					muiAniDrawer.draw(g, x, y)
				Next
			Next
			
			For Local i:= 0 Until 8
				MyAPI.drawImage(g, Self.textBGImage, ((SCREEN_WIDTH Shr 1) - 104) + (i * 26), (SCREEN_HEIGHT Shr 1) - 72, 0)
			Next
			
			MyAPI.drawStrings(g, strForShow, ((SCREEN_WIDTH Shr 1) - 104) + 10, ((SCREEN_HEIGHT Shr 1) - 72) + STATE_SELECT_NORMAL_STAGE, SCREEN_WIDTH, 131, (Int) 0, True, (Int) MENU_BG_COLOR_1, 4656650, (Int) 0, (Int) STATE_EXTRA_ENDING)
			
			muiLeftArrowDrawer.draw(g, 0, (SCREEN_HEIGHT Shr 1) - STATE_SCORE_RANKING)
			muiRightArrowDrawer.draw(g, SCREEN_WIDTH, (SCREEN_HEIGHT Shr 1) - STATE_SCORE_RANKING)
			
			If (MyAPI.upPermit) Then
				muiUpArrowDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 25, SCREEN_HEIGHT)
			EndIf
			
			If (MyAPI.downPermit) Then
				muiDownArrowDrawer.draw(g, (SCREEN_WIDTH Shr 1) + MENU_BG_OFFSET, SCREEN_HEIGHT)
			EndIf
			
			muiAniDrawer.setActionId(Self.helpIndex + 95)
			muiAniDrawer.draw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
			muiAniDrawer.setActionId((Key.touchhelpreturn.Isin() ? STATE_SELECT_NORMAL_STAGE : 0) + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Method moregameDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			drawMenuTitle(g, STATE_SELECT_RACE_STAGE, 0)
			fillMenuRect(g, Self.MORE_GAME_START_X, Self.MORE_GAME_START_Y, Self.MORE_GAME_WIDTH, Self.MORE_GAME_HEIGHT)
			
			MyAPI.drawBoldString(g, "Whether to exit the game", SCREEN_WIDTH Shr 1, Self.MORE_GAME_START_Y + 10, 17, MENU_BG_COLOR_1, 0) ' "~u662f~u5426~u9000~u51fa~u6e38~u620f"
			
			Local i:= MENU_SPACE + (Self.MORE_GAME_START_Y + 10)
			
			MyAPI.drawBoldString(g, "And connect to the network", SCREEN_WIDTH Shr 1, i, 17, MENU_BG_COLOR_1, 0) ' "~u5e76~u8fde~u63a5~u7f51~u7edc"
			
			drawMenuFontById(g, 101, ((Self.cursor * FADE_FILL_WIDTH) + COMFIRM_X) - BAR_HEIGHT, ((Self.MORE_GAME_START_Y + 10) + (MENU_SPACE * 3)) + FONT_H_HALF)
			drawMenuFontById(g, 10, COMFIRM_X, ((Self.MORE_GAME_START_Y + 10) + (MENU_SPACE * 3)) + FONT_H_HALF)
		End
		
		Method pauseoptionLogic:Void()
			If (Key.press(Key.gSelect)) Then
				Self.pauseoptionCursor += 1
				Self.pauseoptionCursor += STATE_SCORE_RANKING
				Self.pauseoptionCursor Mod= STATE_SCORE_RANKING
			EndIf
		End
		
		Method pauseoptionDraw:Void(g:MFGraphics)
			drawMenuTitle(g, 5, 0) ' (10 / 2)
			drawMenuFontById(g, 54, (SCREEN_WIDTH Shr 1) - 32, SCREEN_HEIGHT Shr 1)
			drawMenuFontById(g, 113, (SCREEN_WIDTH Shr 1) - 76, SCREEN_HEIGHT Shr 1)
			drawMenuFontById(g, OPTION_SOUND[Self.pauseoptionCursor] + 55, (SCREEN_WIDTH Shr 1) + 32, SCREEN_HEIGHT Shr 1)
		End
		
		Method menuInit:Void(menuElement:Int[])
			Self.currentElement = menuElement
			Self.cursor = 0
			Self.mainMenuItemCursor = 0
			Self.menuMoving = True
			Self.elementNum = Self.currentElement.Length
			Self.selectMenuOffsetX = 0
			Self.cursor = Self.returnCursor
			Self.mainMenuItemCursor = Self.returnCursor
		End
		
		Method menuInit:Void(nElementNum:Int)
			Self.cursor = 0
			Self.mainMenuItemCursor = 0
			Self.menuMoving = False
			Self.elementNum = nElementNum
			Self.selectMenuOffsetX = 0
			Self.cursor = Self.returnCursor
			Self.mainMenuItemCursor = Self.returnCursor
		End
		
		Method menuInit:Void(nElementNum:Int, cursorIndex:Int)
			menuInit(nElementNum)
			
			Self.cursor = cursorIndex
			Self.mainMenuItemCursor = cursorIndex
		End
		
		Method getMenuPosY:Int(i:Int)
			Return ((SCREEN_HEIGHT - ((Self.elementNum - 1) * MENU_SPACE)) Shr 1) + (MENU_SPACE * i)
		End
		
		Method getMenuPosY:Int(i:Int, num:Int)
			Return ((SCREEN_HEIGHT - ((num - 1) * MENU_SPACE)) Shr 1) + (MENU_SPACE * i)
		End
		
		Method menuLogic:Int()
			Key.touchMenuInit()
			
			If (Key.touchmenunew.Isin() And Self.cursor = 1) Then
				Self.cursor = 0
				Key.touchmenunew.reset()
				
				Return -1
			ElseIf (Key.touchmenucon.Isin() And Self.cursor = 0) Then
				Self.cursor = 1
				
				Key.touchmenucon.reset()
				
				Return -1
			ElseIf ((Key.touchmenunew.Isin() And Self.cursor = 0) Or (Key.touchmenucon.Isin() And Self.cursor = 1)) Then
				Return Self.cursor
			Else
				If (Self.menuMoving) Then
					Return -1
				EndIf
				
				If (Key.press(Key.gUp)) Then
					Self.cursor -= 1
					Self.cursor = (Self.cursor + Self.elementNum) Mod Self.elementNum
					Self.selectMenuOffsetX = 0
					
					changeUpSelect()
				ElseIf (Key.press(Key.gDown)) Then
					Self.cursor += 1
					Self.cursor = (Self.cursor + Self.elementNum) Mod Self.elementNum
					Self.selectMenuOffsetX = 0
					
					changeDownSelect()
				ElseIf (Key.press(Key.gSelect | Key.B_S1)) Then
					Self.cursor = (Self.cursor + Self.elementNum) Mod Self.elementNum
					
					Key.touchMenuClose()
					
					Return Self.cursor
				Else
					
					If (Key.press(2)) Then
						' Nothing so far.
					EndIf
					
					If (Key.press(Key.B_BACK)) Then
						Key.touchMenuClose()
						
						Return RETURN_PRESSED
					EndIf
				EndIf
				
				Return -1
			EndIf
		End
		
		Method changeUpSelect:Void()
			' Empty implementation.
		End
		
		Method changeDownSelect:Void()
			' Empty implementation.
		End
		
		Method drawArcLine:Void(g:MFGraphics, centerx:Int, centery:Int, pointx:Int, pointy:Int)
			g.setColor(16711680)
			
			MyAPI.drawLine(g, centerx, centery, pointx, pointy)
		End
		
		' This implementation may change in the future.
		Method drawTouchKeyDirect:Void(var1:MFGraphics)
			' Magic numbers everywhere:
			Local var10000:TouchDirectKey = Key.touchdirectgamekey
			
			If (TouchDirectKey.IsKeyReleased()) Then
				drawTouchGameKeyBoardById(var1, 0, 32, 128)
			Else
				var10000 = Key.touchdirectgamekey
				
				If (Not TouchDirectKey.IsKeyDragged()) Then
					var10000 = Key.touchdirectgamekey
					
					If (Not TouchDirectKey.IsKeyPressed()) Then
						drawTouchKeyDirectPad(var1)
					EndIf
				EndIf
			EndIf
			
			If (Not Key.press(16777216) And Not Key.repeated(16777216)) Then
				drawTouchGameKeyBoardById(var1, 9, -22 + SCREEN_WIDTH, 123)
			Else
				drawTouchGameKeyBoardById(var1, 10, -22 + SCREEN_WIDTH, 123)
			EndIf
			
			If (Not Key.press(Key.B_SEL) And Not Key.repeated(Key.B_SEL)) Then
				drawTouchGameKeyBoardById(var1, 11, -67 + SCREEN_WIDTH, 138)
			Else
				drawTouchGameKeyBoardById(var1, 12, -67 + SCREEN_WIDTH, 138)
			EndIf
		End
		
		Method BP_payingInit:Void(text_id:Int, title_id:Int)
			MyAPI.initString()
			
			strForShow = MyAPI.getStrings(BPstrings[text_id], MENU_RECT_WIDTH - BAR_HEIGHT)
			BPPayingTitle = BPstrings[title_id]
			
			Self.IsInBP = True
		End
		
		Method BP_payingDraw:Void(g:MFGraphics)
			menuBgDraw(g)
		End
		
		Method secondEnsureInit:Void()
			Self.isConfirm = False
			Self.confirmframe = 0
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Key.touchSecondEnsureClose()
			Key.touchSecondEnsureInit()
		End
		
		Method secondEnsureInit2:Void()
			Self.isConfirm = False
			Self.confirmframe = 0
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Key.touchSecondEnsureClose()
			Key.touchSecondEnsureInit()
		End
		
		Method secondEnsureLogic:Int()
			If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 2
			EndIf
			
			If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 0
			EndIf
			
			If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 1
			EndIf
			
			If (Self.isConfirm) Then
				Self.confirmframe += 1
				
				If (Self.confirmframe > STATE_ENDING) Then
					Return 1
				EndIf
			EndIf
			
			If (Key.touchsecondensureyes.IsButtonPress() And Self.confirmcursor = 0 And Not Self.isConfirm) Then
				Self.isConfirm = True
				Self.confirmframe = 0
				
				SoundSystem.getInstance().playSe(1)
				
				Return 0
			ElseIf (Key.touchsecondensureno.IsButtonPress() And Self.confirmcursor = 1 And Not Self.isConfirm) Then
				SoundSystem.getInstance().playSe(2)
				
				Return 2
			ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver() Or Self.isConfirm) Then
				Return 0
			Else
				SoundSystem.getInstance().playSe(2)
				
				Return 2
			EndIf
		End
		
		Method secondEnsureDirectLogic:Int()
			If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 2
			EndIf
			
			If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 0
			EndIf
			
			If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 1
			EndIf
			
			If (Key.touchsecondensureyes.IsButtonPress() And Self.confirmcursor = 0) Then
				Self.isConfirm = True
				Self.confirmframe = 0
				
				SoundSystem.getInstance().playSe(1)
				
				Return 1
			ElseIf (Key.touchsecondensureno.IsButtonPress() And Self.confirmcursor = 1) Then
				SoundSystem.getInstance().playSe(2)
				
				Return 2
			ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver()) Then
				Return 0
			Else
				SoundSystem.getInstance().playSe(2)
				
				Return 2
			EndIf
		End
		
		Method SecondEnsurePanelDraw:Void(g:MFGraphics, ani_id:Int)
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				
				Return
			EndIf
			
			Local animationDrawer:= muiAniDrawer
			
			animationDrawer.setActionId(54)
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
			
			Local i:= Int(Key.touchsecondensureyes.Isin() And Self.confirmcursor = 0)
			
			animationDrawer.setActionId(i + 59)
			
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			
			i = Int(Key.touchsecondensureno.Isin() And Self.confirmcursor = 1)
			
			animationDrawer.setActionId(i + 59)
			
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			
			animationDrawer.setActionId(46)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			
			animationDrawer.setActionId(47)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			
			animationDrawer.setActionId(ani_id)
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
			
			If (Key.touchsecondensurereturn.Isin()) Then
				i = 5
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			animationDrawer.draw(g, 0, SCREEN_HEIGHT)
			
			If (Self.isConfirm And Self.confirmframe > 8) Then
				g.setColor(0)
				
				MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			EndIf
		End
		
		Method itemsSelect2Init:Void()
			Key.touchItemsSelect2Init()
			
			Self.itemsselectcursor = 0
			Self.isItemsSelect = False
			
			fadeInit(0, 192)
		End
		
		Public Method itemsSelect2Logic:Int()
			
			If (Key.touchitemsselect2_return.Isin() And Key.touchitemsselect2.IsClick()) Then
				Self.itemsselectcursor = 2
			EndIf
			
			If (Key.touchitemsselect2_1.Isin() And Key.touchitemsselect2.IsClick()) Then
				Self.itemsselectcursor = 0
			EndIf
			
			If (Key.touchitemsselect2_2.Isin() And Key.touchitemsselect2.IsClick()) Then
				Self.itemsselectcursor = 1
			EndIf
			
			If (Self.isItemsSelect) Then
				Self.itemsselectframe += 1
				
				If (Self.itemsselectframe > STATE_ENDING) Then
					fadeInit(220, 102)
					
					If (Self.Finalitemsselectcursor = 0) Then
						Return 1
					EndIf
					
					Return 2
				EndIf
			EndIf
			
			If (Key.touchitemsselect2_1.IsButtonPress() And Self.itemsselectcursor = 0 And Not Self.isItemsSelect) Then
				Self.isItemsSelect = True
				Self.itemsselectframe = 0
				Self.Finalitemsselectcursor = 0
				
				SoundSystem.getInstance().playSe(1)
				
				Return 0
			ElseIf (Key.touchitemsselect2_2.IsButtonPress() And Self.itemsselectcursor = 1 And Not Self.isItemsSelect) Then
				Self.isItemsSelect = True
				Self.itemsselectframe = 0
				Self.Finalitemsselectcursor = 1
				
				SoundSystem.getInstance().playSe(1)
				
				Return 0
			ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchitemsselect2_return.IsButtonPress()) Or Not fadeChangeOver()) Then
				Return 0
			Else
				SoundSystem.getInstance().playSe(2)
				
				Return STATE_SELECT_RACE_STAGE
			EndIf
		End
		
		Method itemsSelect2Draw:Void(g:MFGraphics, items1:Int, items2:Int)
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				
				Return
			EndIf
			
			Local animationDrawer:= muiAniDrawer
			
			Local i:= Int(Key.touchitemsselect2_1.Isin() And Self.itemsselectcursor = 0)
			
			animationDrawer.setActionId(i + 55)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 18)
			animationDrawer = muiAniDrawer
			
			i = Int(Key.touchitemsselect2_2.Isin() And Self.itemsselectcursor = 1)
			
			animationDrawer.setActionId(i + 55)
			
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + 18)
			
			muiAniDrawer.setActionId(items1)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 18)
			
			muiAniDrawer.setActionId(items2)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + 18)
			
			animationDrawer = muiAniDrawer
			
			If (Key.touchitemsselect2_return.Isin()) Then
				i = STATE_SELECT_NORMAL_STAGE
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Method soundVolumnInit:Void()
			Key.touchSecondEnsureClose()
			Key.touchSecondEnsureInit()
			
			Self.timeCnt = 0
			Self.isSoundVolumnClick = False
			
			fadeInit(0, 192)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
		End
		
		Method soundVolumnLogic:Int()
			If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 2
			EndIf
			
			If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 0
			EndIf
			
			If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
				Self.confirmcursor = 1
			EndIf
			
			If (Key.touchsecondensureyes.Isin()) Then
				Self.timeCnt += 1
				
				If (Self.timeCnt <= STATE_SCORE_RANKING And Not Self.isSoundVolumnClick) Then
					If (GlobalResource.soundConfig <= 0) Then
						GlobalResource.soundConfig = 0
					Else
						GlobalResource.soundConfig -= 1
					EndIf
					
					If (GlobalResource.soundConfig = 0) Then
						GlobalResource.seConfig = 0
					EndIf
					
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
					
					Self.isSoundVolumnClick = True
				ElseIf (Self.timeCnt > STATE_SCORE_RANKING And Self.timeCnt Mod 2 = 0) Then
					If (GlobalResource.soundConfig <= 0) Then
						GlobalResource.soundConfig = 0
					Else
						GlobalResource.soundConfig -= 1
					EndIf
					
					If (GlobalResource.soundConfig = 0) Then
						GlobalResource.seConfig = 0
					EndIf
					
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				EndIf
				
			ElseIf (Key.touchsecondensureno.Isin()) Then
				Self.timeCnt += 1
				
				If (Self.timeCnt <= STATE_SCORE_RANKING And Not Self.isSoundVolumnClick) Then
					If (GlobalResource.soundConfig >= 15) Then
						GlobalResource.soundConfig = 15
					Else
						GlobalResource.soundConfig += 1
					EndIf
					
					If (GlobalResource.soundConfig > 0) Then
						GlobalResource.seConfig = 1
					EndIf
					
					Self.isSoundVolumnClick = True
					
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
					
					If (GlobalResource.soundConfig = 1) Then
						SoundSystem.getInstance().resumeBgm()
					EndIf
				ElseIf (Self.timeCnt > STATE_SCORE_RANKING And (Self.timeCnt Mod 2) = 0) Then
					If (GlobalResource.soundConfig >= 15) Then
						GlobalResource.soundConfig = 15
					Else
						GlobalResource.soundConfig += 1
					EndIf
					
					If (GlobalResource.soundConfig > 0) Then
						GlobalResource.seConfig = 1
					EndIf
					
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
					
					If (GlobalResource.soundConfig = 1) Then
						SoundSystem.getInstance().resumeBgm()
					EndIf
				EndIf
			Else
				Self.timeCnt = 0
				Self.isSoundVolumnClick = False
			EndIf
			
			If (GlobalResource.soundConfig >= 15) Then
				GlobalResource.soundConfig = 15
			ElseIf (GlobalResource.soundConfig <= 0) Then
				GlobalResource.soundConfig = 0
			EndIf
			
			If (GlobalResource.soundConfig > 0) Then
				GlobalResource.seConfig = 1
			EndIf
			
			If ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver()) Then
				Return 0
			EndIf
			
			SoundSystem.getInstance().playSe(2)
			
			Return 2
		End
		
		Method soundVolumnDraw:Void(g:MFGraphics)
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			Local i:Int
			
			muiAniDrawer.setActionId(54)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
			AnimationDrawer animationDrawer = muiAniDrawer
			
			i = Int(Key.touchsecondensureyes.Isin() And Self.confirmcursor = 0)
			
			animationDrawer.setActionId(i + 59)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			animationDrawer = muiAniDrawer
			
			i = Int(Key.touchsecondensureno.Isin() And Self.confirmcursor = 1)
			
			animationDrawer.setActionId(i + 59)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			
			muiAniDrawer.setActionId(89)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			
			muiAniDrawer.setActionId(90)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
			
			muiAniDrawer.setActionId(71)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
			
			muiAniDrawer.setActionId(72)
			
			For Local i2:= 0 Until GlobalResource.soundConfig
				muiAniDrawer.draw(g, ((SCREEN_WIDTH Shr 1) - PAGE_BACKGROUND_HEIGHT) + ((i2 - 1) * STATE_ENDING), (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
			EndIf
			
			muiAniDrawer.setActionId(GlobalResource.soundConfig + 73)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
			animationDrawer = muiAniDrawer
			
			If (Key.touchsecondensurereturn.Isin()) Then
				i = STATE_SELECT_NORMAL_STAGE
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Method spSenorSetInit:Void()
			Key.touchItemsSelect3Init()
			
			Self.itemsselectcursor = 0
			Self.isItemsSelect = False
			
			fadeInit(0, 102)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
		End
		
		Method spSenorSetLogic:Int()
			If (Key.touchitemsselect3_return.Isin() And Key.touchitemsselect3.IsClick()) Then
				Self.itemsselectcursor = 2
			EndIf
			
			If (Key.touchitemsselect3_1.Isin() And Key.touchitemsselect3.IsClick()) Then
				Self.itemsselectcursor = 0
			EndIf
			
			If (Key.touchitemsselect3_2.Isin() And Key.touchitemsselect3.IsClick()) Then
				Self.itemsselectcursor = 1
			EndIf
			
			If (Key.touchitemsselect3_3.Isin() And Key.touchitemsselect3.IsClick()) Then
				Self.itemsselectcursor = STATE_SCORE_RANKING
			EndIf
			
			If (Self.isItemsSelect) Then
				Self.itemsselectframe += 1
				
				If (Self.itemsselectframe > STATE_ENDING) Then
					fadeInit(220, 102)
					
					If (Self.Finalitemsselectcursor = 0) Then
						Return 1
					EndIf
					
					If (Self.Finalitemsselectcursor = 1) Then
						Return 2
					EndIf
					
					Return STATE_SCORE_RANKING
				EndIf
			EndIf
			
			If (Key.touchitemsselect3_1.IsButtonPress() And Self.itemsselectcursor = 0 And Not Self.isItemsSelect) Then
				Self.isItemsSelect = True
				Self.itemsselectframe = 0
				Self.Finalitemsselectcursor = 0
				
				SoundSystem.getInstance().playSe(1)
				
				Return 0
			ElseIf (Key.touchitemsselect3_2.IsButtonPress() And Self.itemsselectcursor = 1 And Not Self.isItemsSelect) Then
				Self.isItemsSelect = True
				Self.itemsselectframe = 0
				Self.Finalitemsselectcursor = 1
				
				SoundSystem.getInstance().playSe(1)
				
				Return 0
			ElseIf (Key.touchitemsselect3_3.IsButtonPress() And Self.itemsselectcursor = STATE_SCORE_RANKING And Not Self.isItemsSelect) Then
				Self.isItemsSelect = True
				Self.itemsselectframe = 0
				Self.Finalitemsselectcursor = 2
				
				SoundSystem.getInstance().playSe(1)
				
				Return 0
			ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchitemsselect2_return.IsButtonPress()) Or Not fadeChangeOver()) Then
				Return 0
			Else
				SoundSystem.getInstance().playSe(2)
				
				Return STATE_SELECT_RACE_STAGE
			EndIf
		End
		
		Method spSenorSetDraw:Void(g:MFGraphics)
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				
				Return
			EndIf
			
			Local animationDrawer:= muiAniDrawer
			
			Local i = Int(Key.touchitemsselect3_1.Isin() And Self.itemsselectcursor = 0)
			
			animationDrawer.setActionId(i + 55)
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 36)
			
			If (Key.touchitemsselect3_2.Isin() And Self.itemsselectcursor = 1) Then
				i = 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 55)
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 36)
			
			i = Int(Key.touchitemsselect3_3.Isin() And Self.itemsselectcursor = STATE_SCORE_RANKING)
			
			animationDrawer.setActionId(i + 55)
			
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 72)
			animationDrawer.setActionId(70)
			
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 36)
			animationDrawer.setActionId(69)
			
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 36)
			animationDrawer.setActionId(68)
			
			animationDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 72)
			
			If (Key.touchitemsselect3_return.Isin()) Then
				i = STATE_SELECT_NORMAL_STAGE
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Method setGameScore:Void(strScore:Int)
			activity.setScore(strScore)
		End
End