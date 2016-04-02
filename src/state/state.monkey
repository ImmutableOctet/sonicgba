Strict

Public

' Imports:
Private
	'Import gameengine.def
	'Import gameengine.key
	'Import gameengine.touchdirectkey
	
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
		Global RESET_STR:String[] = MyAPI.getStrings("History reset!", WARNING_FONT_WIDTH) ' \u8bb0\u5f55\u5df2\u91cd\u7f6e\uff01
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
		Const WARNING_STR:String[] = MyAPI.getStrings(WARNING_STR_ORIGNAL, WARNING_FONT_WIDTH)
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
		Global activity:Main
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
			Self.selectMenuOffsetX = WARNING_HEIGHT
			Self.isArrowClicked = False
			Self.arrowindex = -1
			Self.returnPageCursor = WARNING_HEIGHT
			
			Self.MORE_GAME_WIDTH = FRAME_WIDTH
			Self.MORE_GAME_HEIGHT = ((MENU_SPACE * STATE_SCORE_RANKING) + BAR_HEIGHT)
			Self.MORE_GAME_START_X = FRAME_X
			Self.MORE_GAME_START_Y = ((SCREEN_HEIGHT - Self.MORE_GAME_HEIGHT) Shr 1) ' / 2
			
			Self.menuMoving = True
			Self.returnCursor = WARNING_HEIGHT
			Self.tooltipY = TOOL_TIP_Y_DES_2
			Self.IsInBP = False
			Self.confirmcursor = WARNING_HEIGHT
		End
		
	Public Function setState:Void(mStateId:Int)
		
		If (stateId <> mStateId) Then
			If (state <> Null) Then
				state.close()
				state = Null
				'System.gc()
			EndIf
			
			stateId = mStateId
			Select (stateId)
				Case WARNING_HEIGHT
					state = New TitleState()
					break
				Case STATE_GAME
					Key.touchCharacterSelectModeClose()
					state = New GameState()
					break
				Case STATE_RETURN_FROM_GAME
					Key.touchkeyboardClose()
					break
				Case STATE_SELECT_RACE_STAGE
				Case STATE_SCORE_RANKING
				Case STATE_SELECT_NORMAL_STAGE
				Case STATE_SELECT_CHARACTER
					break
				Case STATE_SPECIAL
					state = New SpecialStageState()
					break
				Case STATE_SPECIAL_TO_GMAE
					state = New GameState(stateId)
					break
				Case STATE_NORMAL_ENDING
					state = New EndingState(WARNING_HEIGHT)
					break
				Case STATE_EXTRA_ENDING
					state = New EndingState(STATE_GAME)
					break
				Case STATE_SPECIAL_ENDING
					state = New EndingState(STATE_RETURN_FROM_GAME)
					break
			End Select
			state = New TitleState(stateId)
			state.init()
			isDrawTouchPad = False
			
			If (stateId = STATE_SPECIAL) Then
				isInSPStage = True
			Else
				isInSPStage = False
			EndIf
		EndIf
		
	}

	Public Function stateLogic:Void()
		SoundSystem.getInstance().exec()
		
		If (state <> Null) Then
			try {
				arrowLogic()
				state.logic()
			} catch (Exception e) {
				e.printStackTrace()
			}
		EndIf
		
	}

	Public Function stateDraw:Void(g:MFGraphics)
		
		If (state <> Null) Then
			try {
				MyAPI.setClip(g, WARNING_HEIGHT, WARNING_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
				state.draw(g)
			} catch (Exception e) {
				e.printStackTrace()
			}
			
			If (fading) Then
				drawFade(g)
			EndIf
		EndIf
		
	}

	Public Function stateInit:Void()
		Key.init()
		Record.initRecord()
		initArrowDrawer()
		StageManager.loadStageRecord()
		GlobalResource.loadSystemConfig()
		SpecialStageState.loadData()
		StageManager.loadHighScoreRecord()
	}

	Public Function exitGame:Void()
		
		If (state <> Null) Then
			state.close()
			state = Null
		EndIf
		
		MFDevice.notifyExit()
	}

	Public Function statePause:Void()
		
		If (state <> Null) Then
			state.pause()
		EndIf
		
		SoundSystem.getInstance().stopBgm(True)
	}

	Public Function pauseTrigger:Void()
		
		If (SoundSystem.getInstance().bgmPlaying2()) Then
			SoundSystem.getInstance().stopBgm(True)
			SoundSystem.getInstance().stopLongSe()
			SoundSystem.getInstance().stopLoopSe()
		EndIf
		
	}

	Private Function initArrowDrawer:Void()
	}

	Public Function arrowLogic:Void()
	}

	Public Function setFadeColor:Void(color:Int)
		For (Int i = WARNING_HEIGHT; i < fadeRGB.length; i += STATE_GAME)
			fadeRGB[i] = color
		Next
	}

	Public Function fadeInit:Void(from:Int, to:Int)
		
		If (to = 220 Or to = RollPlatformSpeedB.DEGREE_VELOCITY) Then
			to = PlayerAnimationCollisionRect.CHECK_OFFSET
		EndIf
		
		fadeFromValue = from
		fadeToValue = to
		fadeAlpha = fadeFromValue
		preFadeAlpha = -1
	}

	Public Function fadeInit_Modify:Void(from:Int, to:Int)
		fadeFromValue = from
		fadeToValue = to
		fadeAlpha = fadeFromValue
		preFadeAlpha = -1
	}

	Public Function getCurrentFade:Int()
		Return fadeAlpha
	}

	Public Function fadeInitAndStart:Void(from:Int, to:Int)
		fadeFromValue = from
		fadeToValue = to
		fadeAlpha = fadeFromValue
		preFadeAlpha = -1
		fading = True
	}

	Private Function drawFadeCore:Void(g:MFGraphics)
		
		If (fadeAlpha <> 0) Then
			Int w
			Int h
			
			If (preFadeAlpha <> fadeAlpha) Then
				For (w = WARNING_HEIGHT; w < FADE_FILL_WIDTH; w += STATE_GAME)
					For (h = WARNING_HEIGHT; h < FADE_FILL_WIDTH; h += STATE_GAME)
						fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl MENU_BG_OFFSET) & -16777216) | (fadeRGB[(h * FADE_FILL_WIDTH) + w] & MENU_BG_COLOR_1)
					Next
				Next
				preFadeAlpha = fadeAlpha
			EndIf
			
			For (w = WARNING_HEIGHT; w < MyAPI.zoomOut(SCREEN_WIDTH); w += FADE_FILL_WIDTH)
				For (h = WARNING_HEIGHT; h < MyAPI.zoomOut(SCREEN_HEIGHT); h += FADE_FILL_WIDTH)
					g.drawRGB(fadeRGB, WARNING_HEIGHT, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_WIDTH, True)
				Next
			Next
		EndIf
		
	}

	Public Function drawFadeBase:Void(g:MFGraphics, vel2:Int)
		fadeAlpha = MyAPI.calNextPosition((double) fadeAlpha, (double) fadeToValue, STATE_GAME, vel2, 3.0d)
		drawFadeCore(g)
	}

	Public Function drawFadeInSpeed:Void(g:MFGraphics, vel:Int)
		
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
	}

	Public Function drawFade:Void(g:MFGraphics)
		drawFadeBase(g, STATE_SELECT_RACE_STAGE)
	}

	Public Function staticDrawFadeSlow:Void(g:MFGraphics)
		
		If (state <> Null) Then
			drawFadeSlow(g)
		EndIf
		
	}

	Public Function drawFadeSlow:Void(g:MFGraphics)
		drawFadeBase(g, STATE_SPECIAL)
	}

	Public Function fadeChangeOver:Bool()
		Return fadeAlpha = fadeToValue
	}

	Public Function getFade:Int()
		Return fadeAlpha
	}

	Public Function setFadeOver:Void()
		fadeAlpha = fadeToValue
	}

	Public Function drawSoftKey:Void(g:MFGraphics, IsLeft:Bool, IsRight:Bool)
		
		If (IsLeft) Then
			drawLeftSoftKey(g)
		EndIf
		
		If (IsRight) Then
			drawRightSoftKey(g)
		EndIf
		
	}

	Private Function drawLeftSoftKey:Void(g:MFGraphics)
	}

	Private Function drawRightSoftKey:Void(g:MFGraphics)
	}

	Public Function drawSoftKeyPause:Void(g:MFGraphics)
		
		If (Not isInSPStage) Then
			Int offsetx = GameObject.stageModeState = 0 ? WARNING_HEIGHT : 32
			
			If (Key.touchkey_pause = Null) Then
				Return
			EndIf
			
			If (Key.touchkey_pause.Isin()) Then
				drawTouchKeyBoardById(g, 14, SCREEN_WIDTH + offsetx, WARNING_HEIGHT)
			Else
				drawTouchKeyBoardById(g, 13, SCREEN_WIDTH + offsetx, WARNING_HEIGHT)
			EndIf
			
		ElseIf (Key.touchspstagepause = Null) Then
		Else
			
			If (Key.touchspstagepause.Isin()) Then
				drawTouchKeyBoardById(g, 14, SCREEN_WIDTH + 32, WARNING_HEIGHT)
			Else
				drawTouchKeyBoardById(g, 13, SCREEN_WIDTH + 32, WARNING_HEIGHT)
			EndIf
		EndIf
		
	}

	Public Function drawSkipSoftKey:Void(g:MFGraphics)
	}

	Public Function initMenuFont:Void()
	}

	Public Function drawMenuFontById:Void(g:MFGraphics, id:Int, x:Int, y:Int)
		drawMenuFontById(g, id, x, y, WARNING_HEIGHT)
	}

	Public Function drawMenuFontById:Void(g:MFGraphics, id:Int, x:Int, y:Int, trans:Int)
	}

	Public Function drawMenuStringById:Void(g:MFGraphics, id:Int, x:Int, y:Int, trans:Int)
	}

	Public Function drawMenuFontByString:Void(g:MFGraphics, string:String, x:Int, y:Int, anchor:Int, color1:Int, color2:Int)
		MyAPI.drawBoldString(g, string, x, y - FONT_H_HALF, anchor, color1, color2)
	}

	Public Function drawMenuFontByString:Void(g:MFGraphics, id:Int, x:Int, y:Int)
		drawMenuFontByString(g, id, x, y, 17)
	}

	Public Function drawMenuFontByString:Void(g:MFGraphics, id:Int, x:Int, y:Int, anchor:Int)
	}

	Public Function drawMenuFontByString:Void(g:MFGraphics, string:String, x:Int, y:Int, anchor:Int)
		drawMenuFontByString(g, string, x, y, anchor, MENU_BG_COLOR_1, WARNING_HEIGHT)
	}

	Public Function getMenuFontWidth:Int(id:Int)
		
		If (menuFontDrawer = Null) Then
			initMenuFont()
		EndIf
		
		menuFontDrawer.setActionId(id)
		Return menuFontDrawer.getCurrentFrameWidth()
	}

	Public Function drawBar:Void(g:MFGraphics, barID:Int, x:Int, y:Int)
		g.setColor(BAR_COLOR[barID])
		MyAPI.fillRect(g, x, y - 10, SCREEN_WIDTH, BAR_HEIGHT)
	}

	Public Function drawMenuBar:Void(g:MFGraphics, barID:Int, x:Int, y:Int)
		For (Int i = WARNING_HEIGHT; i < BG_NUM; i += STATE_GAME)
			drawMenuFontById(g, BAR_ANIMATION[barID], (i * BACKGROUND_WIDTH) + x, y)
		Next
	}

	Public Function drawBar:Void(g:MFGraphics, barID:Int, y:Int)
		drawBar(g, barID, WARNING_HEIGHT, y)
	}

	Public Function fillMenuRect:Void(g:MFGraphics, x:Int, y:Int, w:Int, h:Int)
		drawMenuFontById(g, FRAME_DOWN, x, y + h)
		drawMenuFontById(g, FRAME_DOWN, x + w, y + h, STATE_RETURN_FROM_GAME)
		
		If (h - MENU_BG_WIDTH > 0) Then
			MyAPI.setClip(g, x, y + MENU_BG_OFFSET, w, h - MENU_BG_WIDTH)
			For (Int i = WARNING_HEIGHT; i < h - MENU_BG_WIDTH; i += MENU_BG_OFFSET)
				drawMenuFontById(g, FRAME_MIDDLE, x, (y + MENU_BG_OFFSET) + i)
				drawMenuFontById(g, FRAME_MIDDLE, x + w, (y + MENU_BG_OFFSET) + i, STATE_RETURN_FROM_GAME)
			Next
		EndIf
		
		MyAPI.setClip(g, WARNING_HEIGHT, WARNING_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
		drawMenuFontById(g, FRAME_UP, x, y)
		drawMenuFontById(g, FRAME_UP, x + w, y, STATE_RETURN_FROM_GAME)
	}

	Public Method comfirmLogic:Int()
		Key.touchConfirmInit()
		
		If (Key.press(Key.gSelect | Key.B_S1)) Then
			Key.touchConfirmClose()
			Return Self.cursor
		ElseIf (Key.touchConfirmYes.Isin() And Self.cursor = STATE_GAME) Then
			Self.cursor = WARNING_HEIGHT
			Key.touchConfirmYes.reset()
			Return -1
		ElseIf (Key.touchConfirmNo.Isin() And Self.cursor = 0) Then
			Self.cursor = STATE_GAME
			Key.touchConfirmNo.reset()
			Return -1
		ElseIf ((Key.touchConfirmYes.Isin() And Self.cursor = 0) Or (Key.touchConfirmNo.Isin() And Self.cursor = STATE_GAME)) Then
			Key.touchConfirmClose()
			Return Self.cursor
		Else
			
			If (Key.press(STATE_RETURN_FROM_GAME)) Then
			EndIf
			
			If (Key.press(Key.B_BACK)) Then
				Key.touchConfirmClose()
				Return RETURN_PRESSED
			EndIf
			
			If (Key.press(Key.gLeft)) Then
				Self.cursor -= STATE_GAME
				Self.cursor += STATE_RETURN_FROM_GAME
				Self.cursor Mod= STATE_RETURN_FROM_GAME
			ElseIf (Key.press(Key.gRight)) Then
				Self.cursor += STATE_GAME
				Self.cursor += STATE_RETURN_FROM_GAME
				Self.cursor Mod= STATE_RETURN_FROM_GAME
			EndIf
			
			Return -1
		EndIf
		
	End

	Public Method comfirmDraw:Void(g:MFGraphics, id:Int)
		drawMenuFontById(g, COMFIRM_FRAME_ID, COMFIRM_X, COMFIRM_Y)
		drawMenuFontById(g, id, COMFIRM_X, COMFIRM_Y - (MENU_SPACE Shr 1))
		drawMenuFontById(g, 101, ((Self.cursor * FADE_FILL_WIDTH) + COMFIRM_X) - BAR_HEIGHT, COMFIRM_Y + (MENU_SPACE Shr 1))
		drawMenuFontById(g, 10, COMFIRM_X, COMFIRM_Y + (MENU_SPACE Shr 1))
	End

	Public Method confirmDraw:Void(g:MFGraphics, title:String)
		drawMenuFontById(g, COMFIRM_FRAME_ID, COMFIRM_X, COMFIRM_Y)
		MyAPI.drawBoldString(g, title, COMFIRM_X, ((COMFIRM_Y - CONFIRM_FRAME_OFFSET_Y) + 10) + LINE_SPACE, 17, MENU_BG_COLOR_1, 4656650)
		drawMenuFontById(g, 101, ((Self.cursor * FADE_FILL_WIDTH) + COMFIRM_X) - BAR_HEIGHT, COMFIRM_Y + (MENU_SPACE Shr 1))
		drawMenuFontById(g, 10, COMFIRM_X, COMFIRM_Y + (MENU_SPACE Shr 1))
	End

	Public Method menuBgDraw:Void(g:MFGraphics)
	End

	Public Method drawLowQualifyBackGround:Void(g:MFGraphics, color1:Int, color2:Int, offset:Int)
		g.setColor(color1)
		MyAPI.fillRect(g, WARNING_HEIGHT, WARNING_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
		g.setColor(color2)
		Self.titleBgOffsetX += MENU_BG_SPEED
		Self.titleBgOffsetY += MENU_BG_SPEED
		Self.titleBgOffsetX Mod= offset
		Self.titleBgOffsetY Mod= offset
		Int x = (-offset) + Self.titleBgOffsetX
		While (x < SCREEN_WIDTH) {
			Int y = (-offset) - Self.titleBgOffsetY
			While (y < SCREEN_HEIGHT) {
				MyAPI.fillRect(g, x, y, offset Shr 1, offset Shr 1)
				MyAPI.fillRect(g, (offset Shr 1) + x, (offset Shr 1) + y, offset Shr 1, offset Shr 1)
				y += offset
			}
			x += offset
		}
	End

	Public Method drawMenuTitle:Void(g:MFGraphics, id:Int, y:Int)
		drawScrollFont(g, id, MENU_TITLE_DRAW_OFFSET_Y, MENU_TITLE_MOVE_DIRECTION)
	End

	Public Method drawMenuTitle:Void(g:MFGraphics, id:Int, y:Int, width:Int)
		drawScrollFont(g, id, MENU_TITLE_DRAW_OFFSET_Y, width > 0 ? width : MENU_TITLE_MOVE_DIRECTION)
	End

	Public Method drawScrollFont:Void(g:MFGraphics, id:Int, y:Int, width:Int)
		drawBar(g, WARNING_HEIGHT, y)
		Self.selectMenuOffsetX += STATE_ENDING
		Self.selectMenuOffsetX Mod= width
		Int x = WARNING_HEIGHT
		While (x - Self.selectMenuOffsetX > 0) {
			x -= width
		}
		For (Int i = WARNING_HEIGHT; i < MENU_TITLE_DRAW_NUM; i += STATE_GAME)
			drawMenuFontById(g, id, (x + (i * width)) - Self.selectMenuOffsetX, y)
		Next
	End

	Public Method helpInit:Void()
		helpStrings = MyAPI.loadText("/help")
		Self.helpIndex = WARNING_HEIGHT
		MyAPI.initString()
		strForShow = MyAPI.getStrings(helpStrings[Self.helpIndex], STATE_EXTRA_ENDING, SCREEN_WIDTH)
		helpTitleString = MyAPI.getStringToDraw(strForShow[WARNING_HEIGHT])
		muiLeftArrowDrawer = New Animation("/animation/mui").getDrawer(91, True, WARNING_HEIGHT)
		muiRightArrowDrawer = New Animation("/animation/mui").getDrawer(92, True, WARNING_HEIGHT)
		muiUpArrowDrawer = New Animation("/animation/mui").getDrawer(93, True, WARNING_HEIGHT)
		muiDownArrowDrawer = New Animation("/animation/mui").getDrawer(94, True, WARNING_HEIGHT)
		Key.touchInstructionInit()
		Self.arrowframecnt = WARNING_HEIGHT
		Self.isArrowClicked = False
		PageFrameCnt = WARNING_HEIGHT
		
		If (Self.textBGImage = Null) Then
			Self.textBGImage = MFImage.createImage("/animation/text_bg.png")
		EndIf
		
		Self.arrowindex = -1
		Self.returnPageCursor = WARNING_HEIGHT
	End

	Public Method helpLogic:Void()
		
		If (Key.touchhelpleftarrow.Isin() And Key.touchpage.IsClick()) Then
			Self.arrowindex = WARNING_HEIGHT
		ElseIf (Key.touchhelprightarrow.Isin() And Key.touchpage.IsClick()) Then
			Self.arrowindex = STATE_GAME
		EndIf
		
		If (Key.touchhelpreturn.Isin() And Key.touchpage.IsClick()) Then
			Self.returnPageCursor = STATE_GAME
		EndIf
		
		If (Key.slidesensorhelp.isSliding()) Then
			If (Key.slidesensorhelp.isSlide(Key.DIR_UP)) Then
				MyAPI.logicString(True, False)
			ElseIf (Key.slidesensorhelp.isSlide(Key.DIR_DOWN)) Then
				MyAPI.logicString(False, True)
			EndIf
		EndIf
		
		If (Key.touchhelpuparrow.Isin()) Then
			Self.arrowframecnt += STATE_GAME
			
			If (Self.arrowframecnt <= STATE_SCORE_RANKING And Not Self.isArrowClicked) Then
				MyAPI.logicString(False, True)
				Self.isArrowClicked = True
			ElseIf (Self.arrowframecnt > STATE_SCORE_RANKING And Self.arrowframecnt Mod STATE_RETURN_FROM_GAME = 0) Then
				MyAPI.logicString(False, True)
			EndIf
			
		ElseIf (Key.touchhelpdownarrow.Isin()) Then
			Self.arrowframecnt += STATE_GAME
			
			If (Self.arrowframecnt <= STATE_SCORE_RANKING And Not Self.isArrowClicked) Then
				MyAPI.logicString(True, False)
				Self.isArrowClicked = True
			ElseIf (Self.arrowframecnt > STATE_SCORE_RANKING And Self.arrowframecnt Mod STATE_RETURN_FROM_GAME = 0) Then
				MyAPI.logicString(True, False)
			EndIf
			
		Else
			Self.arrowframecnt = WARNING_HEIGHT
			Self.isArrowClicked = False
		EndIf
		
		If (Key.touchhelpleftarrow.IsButtonPress() And Self.arrowindex = 0) Then
			SoundSystem.getInstance().playSe(STATE_SELECT_RACE_STAGE)
			Self.helpIndex -= STATE_GAME
			Self.helpIndex += helpStrings.length
			Self.helpIndex Mod= helpStrings.length
			MyAPI.initString()
			strForShow = MyAPI.getStrings(helpStrings[Self.helpIndex], STATE_EXTRA_ENDING, SCREEN_WIDTH)
		ElseIf (Key.touchhelprightarrow.IsButtonPress() And Self.arrowindex = STATE_GAME) Then
			SoundSystem.getInstance().playSe(STATE_SELECT_RACE_STAGE)
			Self.helpIndex += STATE_GAME
			Self.helpIndex Mod= helpStrings.length
			MyAPI.initString()
			strForShow = MyAPI.getStrings(helpStrings[Self.helpIndex], STATE_EXTRA_ENDING, SCREEN_WIDTH)
		EndIf
		
	End

	Public Method helpDraw:Void(g:MFGraphics)
		drawFade(g)
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
			Return
		EndIf
		
		muiAniDrawer.setActionId(62)
		PageFrameCnt += STATE_GAME
		PageFrameCnt Mod= STATE_EXTRA_ENDING
		
		If (PageFrameCnt Mod STATE_RETURN_FROM_GAME = 0) Then
			PageBackGroundOffsetX += STATE_GAME
			PageBackGroundOffsetX Mod= HELP_PAGE_BACKGROUND_WIDTH
			PageBackGroundOffsetY -= STATE_GAME
			PageBackGroundOffsetY Mod= PAGE_BACKGROUND_HEIGHT
		EndIf
		
		For (Int x = PageBackGroundOffsetX - 64; x < (SCREEN_WIDTH * 3) / STATE_RETURN_FROM_GAME; x += HELP_PAGE_BACKGROUND_WIDTH)
			For (Int y = PageBackGroundOffsetY - 56; y < (SCREEN_HEIGHT * 3) / STATE_RETURN_FROM_GAME; y += PAGE_BACKGROUND_HEIGHT)
				muiAniDrawer.draw(g, x, y)
			Next
		Next
		For (Int i = WARNING_HEIGHT; i < STATE_ENDING; i += STATE_GAME)
			MyAPI.drawImage(g, Self.textBGImage, ((SCREEN_WIDTH Shr 1) - Def.TOUCH_ROTATE_MAIN_MENU_ITEM_WIDTH) + (i * 26), (SCREEN_HEIGHT Shr 1) - 72, WARNING_HEIGHT)
		Next
		MyAPI.drawStrings(g, strForShow, ((SCREEN_WIDTH Shr 1) - Def.TOUCH_ROTATE_MAIN_MENU_ITEM_WIDTH) + 10, ((SCREEN_HEIGHT Shr 1) - 72) + STATE_SELECT_NORMAL_STAGE, SCREEN_WIDTH, 131, (Int) WARNING_HEIGHT, True, (Int) MENU_BG_COLOR_1, 4656650, (Int) WARNING_HEIGHT, (Int) STATE_EXTRA_ENDING)
		muiLeftArrowDrawer.draw(g, WARNING_HEIGHT, (SCREEN_HEIGHT Shr 1) - STATE_SCORE_RANKING)
		muiRightArrowDrawer.draw(g, SCREEN_WIDTH, (SCREEN_HEIGHT Shr 1) - STATE_SCORE_RANKING)
		
		If (MyAPI.upPermit) Then
			muiUpArrowDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 25, SCREEN_HEIGHT)
		EndIf
		
		If (MyAPI.downPermit) Then
			muiDownArrowDrawer.draw(g, (SCREEN_WIDTH Shr 1) + MENU_BG_OFFSET, SCREEN_HEIGHT)
		EndIf
		
		muiAniDrawer.setActionId(Self.helpIndex + 95)
		muiAniDrawer.draw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
		muiAniDrawer.setActionId((Key.touchhelpreturn.Isin() ? STATE_SELECT_NORMAL_STAGE : WARNING_HEIGHT) + 61)
		muiAniDrawer.draw(g, WARNING_HEIGHT, SCREEN_HEIGHT)
	End

	Public Method moregameDraw:Void(g:MFGraphics)
		menuBgDraw(g)
		drawMenuTitle(g, STATE_SELECT_RACE_STAGE, WARNING_HEIGHT)
		fillMenuRect(g, Self.MORE_GAME_START_X, Self.MORE_GAME_START_Y, Self.MORE_GAME_WIDTH, Self.MORE_GAME_HEIGHT)
		MFGraphics mFGraphics = g
		MyAPI.drawBoldString(mFGraphics, "\u662f\u5426\u9000\u51fa\u6e38\u620f", SCREEN_WIDTH Shr 1, Self.MORE_GAME_START_Y + 10, 17, MENU_BG_COLOR_1, WARNING_HEIGHT)
		Int i = MENU_SPACE + (Self.MORE_GAME_START_Y + 10)
		mFGraphics = g
		MyAPI.drawBoldString(mFGraphics, "\u5e76\u8fde\u63a5\u7f51\u7edc", SCREEN_WIDTH Shr 1, i, 17, MENU_BG_COLOR_1, WARNING_HEIGHT)
		drawMenuFontById(g, 101, ((Self.cursor * FADE_FILL_WIDTH) + COMFIRM_X) - BAR_HEIGHT, ((Self.MORE_GAME_START_Y + 10) + (MENU_SPACE * 3)) + FONT_H_HALF)
		drawMenuFontById(g, 10, COMFIRM_X, ((Self.MORE_GAME_START_Y + 10) + (MENU_SPACE * 3)) + FONT_H_HALF)
	End

	Public Method pauseoptionLogic:Void()
		
		If (Key.press(Key.gSelect)) Then
			Self.pauseoptionCursor += STATE_GAME
			Self.pauseoptionCursor += STATE_SCORE_RANKING
			Self.pauseoptionCursor Mod= STATE_SCORE_RANKING
		EndIf
		
	End

	Public Method pauseoptionDraw:Void(g:MFGraphics)
		drawMenuTitle(g, STATE_SELECT_NORMAL_STAGE, WARNING_HEIGHT)
		drawMenuFontById(g, 54, (SCREEN_WIDTH Shr 1) - 32, SCREEN_HEIGHT Shr 1)
		drawMenuFontById(g, StringIndex.STR_RIGHT_ARROW, (SCREEN_WIDTH Shr 1) - 76, SCREEN_HEIGHT Shr 1)
		drawMenuFontById(g, OPTION_SOUND[Self.pauseoptionCursor] + 55, (SCREEN_WIDTH Shr 1) + 32, SCREEN_HEIGHT Shr 1)
	End

	Public Method menuInit:Void(menuElement:Int[])
		Self.currentElement = menuElement
		Self.cursor = WARNING_HEIGHT
		Self.mainMenuItemCursor = WARNING_HEIGHT
		Self.menuMoving = True
		Self.elementNum = Self.currentElement.length
		Self.selectMenuOffsetX = WARNING_HEIGHT
		Self.cursor = Self.returnCursor
		Self.mainMenuItemCursor = Self.returnCursor
	End

	Public Method menuInit:Void(nElementNum:Int)
		Self.cursor = WARNING_HEIGHT
		Self.mainMenuItemCursor = WARNING_HEIGHT
		Self.menuMoving = False
		Self.elementNum = nElementNum
		Self.selectMenuOffsetX = WARNING_HEIGHT
		Self.cursor = Self.returnCursor
		Self.mainMenuItemCursor = Self.returnCursor
	End

	Public Method menuInit:Void(nElementNum:Int, cursorIndex:Int)
		menuInit(nElementNum)
		Self.cursor = cursorIndex
		Self.mainMenuItemCursor = cursorIndex
	End

	Public Method getMenuPosY:Int(i:Int)
		Return ((SCREEN_HEIGHT - ((Self.elementNum - 1) * MENU_SPACE)) Shr 1) + (MENU_SPACE * i)
	End

	Public Method getMenuPosY:Int(i:Int, num:Int)
		Return ((SCREEN_HEIGHT - ((num - 1) * MENU_SPACE)) Shr 1) + (MENU_SPACE * i)
	End

	Public Method menuLogic:Int()
		Key.touchMenuInit()
		
		If (Key.touchmenunew.Isin() And Self.cursor = STATE_GAME) Then
			Self.cursor = WARNING_HEIGHT
			Key.touchmenunew.reset()
			Return -1
		ElseIf (Key.touchmenucon.Isin() And Self.cursor = 0) Then
			Self.cursor = STATE_GAME
			Key.touchmenucon.reset()
			Return -1
		ElseIf ((Key.touchmenunew.Isin() And Self.cursor = 0) Or (Key.touchmenucon.Isin() And Self.cursor = STATE_GAME)) Then
			Return Self.cursor
		Else
			
			If (Self.menuMoving) Then
				Return -1
			EndIf
			
			If (Key.press(Key.gUp)) Then
				Self.cursor -= STATE_GAME
				Self.cursor = (Self.cursor + Self.elementNum) Mod Self.elementNum
				Self.selectMenuOffsetX = WARNING_HEIGHT
				changeUpSelect()
			ElseIf (Key.press(Key.gDown)) Then
				Self.cursor += STATE_GAME
				Self.cursor = (Self.cursor + Self.elementNum) Mod Self.elementNum
				Self.selectMenuOffsetX = WARNING_HEIGHT
				changeDownSelect()
			ElseIf (Key.press(Key.gSelect | Key.B_S1)) Then
				Self.cursor = (Self.cursor + Self.elementNum) Mod Self.elementNum
				Key.touchMenuClose()
				Return Self.cursor
			Else
				
				If (Key.press(STATE_RETURN_FROM_GAME)) Then
				EndIf
				
				If (Key.press(Key.B_BACK)) Then
					Key.touchMenuClose()
					Return RETURN_PRESSED
				EndIf
			EndIf
			
			Return -1
		EndIf
		
	End

	Public Method changeUpSelect:Void()
	End

	Public Method changeDownSelect:Void()
	End

	Public Function initTouchkeyBoard:Void()
		
		If (touchkeyboardAnimation = Null) Then
			touchkeyboardAnimation = New Animation("/tuch/control_panel")
		EndIf
		
		touchkeyboardDrawer = touchkeyboardAnimation.getDrawer(WARNING_HEIGHT, True, WARNING_HEIGHT)
		touchgamekeyboardDrawer = touchkeyboardAnimation.getDrawer(WARNING_HEIGHT, True, WARNING_HEIGHT)
	}

	Public Function releaseTouchkeyBoard:Void()
		Animation.closeAnimation(touchkeyboardAnimation)
		touchkeyboardAnimation = Null
		Animation.closeAnimationDrawer(touchkeyboardDrawer)
		touchkeyboardDrawer = Null
		Animation.closeAnimation(touchgamekeyboardAnimation)
		touchgamekeyboardAnimation = Null
		Animation.closeAnimationDrawer(touchgamekeyboardDrawer)
		touchgamekeyboardDrawer = Null
		touchgamekeyImage = Null
	}

	Public Function drawTouchGameKey:Void(g:MFGraphics)
	}

	Public Function drawTouchKeyBoardById:Void(g:MFGraphics, id:Int, x:Int, y:Int)
		touchkeyboardDrawer.setActionId(id)
		touchkeyboardDrawer.draw(g, x, y)
	}

	Public Function drawTouchGameKeyBoardById:Void(g:MFGraphics, id:Int, x:Int, y:Int)
		touchgamekeyboardDrawer.setActionId(id)
		touchgamekeyboardDrawer.draw(g, x, y)
	}

	Public Method drawArcLine:Void(g:MFGraphics, centerx:Int, centery:Int, pointx:Int, pointy:Int)
		g.setColor(16711680)
		MyAPI.drawLine(g, centerx, centery, pointx, pointy)
	End

	Private Method transTouchPointX:Int(directkey:TouchDirectKey, pointx:Int, pointy:Int)
		Int reset_x = pointx - 32
		Int reset_y = pointy - TitleState.CHARACTER_RECORD_BG_OFFSET
		
		If ((reset_x * reset_x) + (reset_y * reset_y) > RollPlatformSpeedC.COLLISION_OFFSET_Y) Then
			Return ((Cos(directkey.getDegree()) * 16) / COMFIRM_FRAME_ID) + 32
		EndIf
		
		Return pointx
	End

	Private Method transTouchPointY:Int(directkey:TouchDirectKey, pointx:Int, pointy:Int)
		Int reset_x = pointx - 32
		Int reset_y = pointy - TitleState.CHARACTER_RECORD_BG_OFFSET
		
		If ((reset_x * reset_x) + (reset_y * reset_y) > RollPlatformSpeedC.COLLISION_OFFSET_Y) Then
			Return ((Sin(directkey.getDegree()) * 16) / COMFIRM_FRAME_ID) + TitleState.CHARACTER_RECORD_BG_OFFSET
		EndIf
		
		Return pointy
	End

	Private Method drawTouchKeyDirectPad:Void(g:MFGraphics)
		Int degree = WARNING_HEIGHT
		
		If (Key.touchdirectgamekey <> Null) Then
			degree = Key.touchdirectgamekey.getDegree()
		EndIf
		
		Int id = WARNING_HEIGHT
		
		If (degree >= 248 And degree < 292) Then
			id = STATE_GAME
		ElseIf (degree >= 292 And degree < 337) Then
			id = STATE_RETURN_FROM_GAME
		ElseIf ((degree >= 0 And degree < 22) Or (degree >= 337 And degree <= MDPhone.SCREEN_WIDTH)) Then
			id = STATE_SELECT_RACE_STAGE
		ElseIf (degree >= 22 And degree < 67) Then
			id = STATE_SCORE_RANKING
		ElseIf (degree >= 67 And degree < StringIndex.STR_RIGHT_ARROW) Then
			id = STATE_SELECT_NORMAL_STAGE
		ElseIf (degree >= StringIndex.STR_RIGHT_ARROW And degree < 157) Then
			id = STATE_SPECIAL
		ElseIf (degree >= 157 And degree < 202) Then
			id = STATE_SPECIAL_TO_GMAE
		ElseIf (degree >= 202 And degree < 248) Then
			id = STATE_ENDING
		EndIf
		
		drawTouchGameKeyBoardById(g, id, 32, TitleState.CHARACTER_RECORD_BG_OFFSET)
	End

	/* JADX WARNING: inconsistent code. */
	/* Code decompiled incorrectly, please refer to instructions dump. */
	Public Method drawTouchKeyDirect:Void(r7:com.sega.mobile.framework.device.MFGraphics)
		/*
		r6 = Self
		r5 = 16777216; // 0x1000000 Float:2.3509887E-38 double:8.289046E-317
		r4 = 138; // 0x8a Float:1.93E-43 double:6.8E-322
		r3 = 123; // 0x7b Float:1.72E-43 double:6.1E-322
		r0 = GameEngine.Key.touchdirectgamekey
		r0 = GameEngine.TouchDirectKey.IsKeyReleased()
		
		If (r0 = 0) goto L_0x0045
	L_0x000e:
		r0 = 0
		r1 = 32
		r2 = 128; // 0x80 Float:1.794E-43 double:6.32E-322
		drawTouchGameKeyBoardById(r7, r0, r1, r2)
	L_0x0016:
		r0 = GameEngine.Key.press(r5)
		
		If (r0 <> 0) goto L_0x0022
	L_0x001c:
		r0 = GameEngine.Key.repeat(r5)
		
		If (r0 = 0) goto L_0x0059
	L_0x0022:
		r0 = 10
		r1 = SCREEN_WIDTH
		r1 = r1 + -22
		drawTouchGameKeyBoardById(r7, r0, r1, r3)
	L_0x002b:
		r0 = GameEngine.Key.B_SEL
		r0 = GameEngine.Key.press(r0)
		
		If (r0 <> 0) goto L_0x003b
	L_0x0033:
		r0 = GameEngine.Key.B_SEL
		r0 = GameEngine.Key.repeat(r0)
		
		If (r0 = 0) goto L_0x0063
	L_0x003b:
		r0 = 12
		r1 = SCREEN_WIDTH
		r1 = r1 + -67
		drawTouchGameKeyBoardById(r7, r0, r1, r4)
	L_0x0044:
		Return
	L_0x0045:
		r0 = GameEngine.Key.touchdirectgamekey
		r0 = GameEngine.TouchDirectKey.IsKeyDragged()
		
		If (r0 <> 0) goto L_0x0055
	L_0x004d:
		r0 = GameEngine.Key.touchdirectgamekey
		r0 = GameEngine.TouchDirectKey.IsKeyPressed()
		
		If (r0 = 0) goto L_0x0016
	L_0x0055:
		r6.drawTouchKeyDirectPad(r7)
		goto L_0x0016
	L_0x0059:
		r0 = 9
		r1 = SCREEN_WIDTH
		r1 = r1 + -22
		drawTouchGameKeyBoardById(r7, r0, r1, r3)
		goto L_0x002b
	L_0x0063:
		r0 = 11
		r1 = SCREEN_WIDTH
		r1 = r1 + -67
		drawTouchGameKeyBoardById(r7, r0, r1, r4)
		goto L_0x0044
		*/
		throw New UnsupportedOperationException("Method not decompiled: State.State.drawTouchKeyDirect(com.sega.mobile.framework.device.MFGraphics):Void")
	End

	Public Function setTry:Void()
		
		If (trytimes > 0) Then
			trytimes -= STATE_GAME
		Else
			trytimes = WARNING_HEIGHT
		EndIf
		
	}

	Public Function IsActiveGame:Bool()
		Return False
	}

	Public Function IsToolsCharge:Bool()
		Return False
	}

	Public Function activeGameProcess:Void(state:Bool)
		IsPaid = state
	}

	Public Function load_bp_string:Void()
		setMenu()
	}

	Public Function setMenu:Void()
		TitleState.setMainMenu()
		GameState.setPauseMenu()
	}

	Public Function init_bp:Void()
	}

	Public Function loadBPRecord:Void()
	}

	Public Function saveBPRecord:Void()
	}

	Public Function BP_chargeLogic:Bool(index:Int)
		Return False
	}

	Public Function BP_IsChargeByIndex:Bool(index:Int)
		Return False
	}

	Public Method BP_payingInit:Void(text_id:Int, title_id:Int)
		MyAPI.initString()
		strForShow = MyAPI.getStrings(BPstrings[text_id], MENU_RECT_WIDTH - BAR_HEIGHT)
		BPPayingTitle = BPstrings[title_id]
		Self.IsInBP = True
	End

	Public Method BP_payingDraw:Void(g:MFGraphics)
		menuBgDraw(g)
	End

	Public Function BP_loadImage:Void()
	}

	Public Method secondEnsureInit:Void()
		Self.isConfirm = False
		Self.confirmframe = WARNING_HEIGHT
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
		EndIf
		
		Key.touchSecondEnsureClose()
		Key.touchSecondEnsureInit()
	End

	Public Method secondEnsureInit2:Void()
		Self.isConfirm = False
		Self.confirmframe = WARNING_HEIGHT
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
		EndIf
		
		Key.touchSecondEnsureClose()
		Key.touchSecondEnsureInit()
	End

	Public Method secondEnsureLogic:Int()
		
		If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = STATE_RETURN_FROM_GAME
		EndIf
		
		If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = WARNING_HEIGHT
		EndIf
		
		If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = STATE_GAME
		EndIf
		
		If (Self.isConfirm) Then
			Self.confirmframe += STATE_GAME
			
			If (Self.confirmframe > STATE_ENDING) Then
				Return STATE_GAME
			EndIf
		EndIf
		
		If (Key.touchsecondensureyes.IsButtonPress() And Self.confirmcursor = 0 And Not Self.isConfirm) Then
			Self.isConfirm = True
			Self.confirmframe = WARNING_HEIGHT
			SoundSystem.getInstance().playSe(STATE_GAME)
			Return WARNING_HEIGHT
		ElseIf (Key.touchsecondensureno.IsButtonPress() And Self.confirmcursor = STATE_GAME And Not Self.isConfirm) Then
			SoundSystem.getInstance().playSe(STATE_RETURN_FROM_GAME)
			Return STATE_RETURN_FROM_GAME
		ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver() Or Self.isConfirm) Then
			Return WARNING_HEIGHT
		Else
			SoundSystem.getInstance().playSe(STATE_RETURN_FROM_GAME)
			Return STATE_RETURN_FROM_GAME
		EndIf
		
	End

	Public Method secondEnsureDirectLogic:Int()
		
		If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = STATE_RETURN_FROM_GAME
		EndIf
		
		If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = WARNING_HEIGHT
		EndIf
		
		If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = STATE_GAME
		EndIf
		
		If (Key.touchsecondensureyes.IsButtonPress() And Self.confirmcursor = 0) Then
			Self.isConfirm = True
			Self.confirmframe = WARNING_HEIGHT
			SoundSystem.getInstance().playSe(STATE_GAME)
			Return STATE_GAME
		ElseIf (Key.touchsecondensureno.IsButtonPress() And Self.confirmcursor = STATE_GAME) Then
			SoundSystem.getInstance().playSe(STATE_RETURN_FROM_GAME)
			Return STATE_RETURN_FROM_GAME
		ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver()) Then
			Return WARNING_HEIGHT
		Else
			SoundSystem.getInstance().playSe(STATE_RETURN_FROM_GAME)
			Return STATE_RETURN_FROM_GAME
		EndIf
		
	End

	Public Method SecondEnsurePanelDraw:Void(g:MFGraphics, ani_id:Int)
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
			Return
		EndIf
		
		muiAniDrawer.setActionId(54)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
		AnimationDrawer animationDrawer = muiAniDrawer
		Int i = (Key.touchsecondensureyes.Isin() And Self.confirmcursor = 0) ? STATE_GAME : WARNING_HEIGHT
		animationDrawer.setActionId(i + 59)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		animationDrawer = muiAniDrawer
		
		If (Key.touchsecondensureno.Isin() And Self.confirmcursor = STATE_GAME) Then
			i = STATE_GAME
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 59)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		muiAniDrawer.setActionId(46)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		muiAniDrawer.setActionId(47)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		muiAniDrawer.setActionId(ani_id)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
		animationDrawer = muiAniDrawer
		
		If (Key.touchsecondensurereturn.Isin()) Then
			i = STATE_SELECT_NORMAL_STAGE
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 61)
		muiAniDrawer.draw(g, WARNING_HEIGHT, SCREEN_HEIGHT)
		
		If (Self.isConfirm And Self.confirmframe > STATE_ENDING) Then
			g.setColor(WARNING_HEIGHT)
			MyAPI.fillRect(g, WARNING_HEIGHT, WARNING_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT)
		EndIf
		
	End

	Public Method itemsSelect2Init:Void()
		Key.touchItemsSelect2Init()
		Self.itemsselectcursor = WARNING_HEIGHT
		Self.isItemsSelect = False
		fadeInit(WARNING_HEIGHT, PlayerAnimationCollisionRect.CHECK_OFFSET)
	End

	Public Method itemsSelect2Logic:Int()
		
		If (Key.touchitemsselect2_return.Isin() And Key.touchitemsselect2.IsClick()) Then
			Self.itemsselectcursor = STATE_RETURN_FROM_GAME
		EndIf
		
		If (Key.touchitemsselect2_1.Isin() And Key.touchitemsselect2.IsClick()) Then
			Self.itemsselectcursor = WARNING_HEIGHT
		EndIf
		
		If (Key.touchitemsselect2_2.Isin() And Key.touchitemsselect2.IsClick()) Then
			Self.itemsselectcursor = STATE_GAME
		EndIf
		
		If (Self.isItemsSelect) Then
			Self.itemsselectframe += STATE_GAME
			
			If (Self.itemsselectframe > STATE_ENDING) Then
				fadeInit(220, RollPlatformSpeedB.DEGREE_VELOCITY)
				
				If (Self.Finalitemsselectcursor = 0) Then
					Return STATE_GAME
				EndIf
				
				Return STATE_RETURN_FROM_GAME
			EndIf
		EndIf
		
		If (Key.touchitemsselect2_1.IsButtonPress() And Self.itemsselectcursor = 0 And Not Self.isItemsSelect) Then
			Self.isItemsSelect = True
			Self.itemsselectframe = WARNING_HEIGHT
			Self.Finalitemsselectcursor = WARNING_HEIGHT
			SoundSystem.getInstance().playSe(STATE_GAME)
			Return WARNING_HEIGHT
		ElseIf (Key.touchitemsselect2_2.IsButtonPress() And Self.itemsselectcursor = STATE_GAME And Not Self.isItemsSelect) Then
			Self.isItemsSelect = True
			Self.itemsselectframe = WARNING_HEIGHT
			Self.Finalitemsselectcursor = STATE_GAME
			SoundSystem.getInstance().playSe(STATE_GAME)
			Return WARNING_HEIGHT
		ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchitemsselect2_return.IsButtonPress()) Or Not fadeChangeOver()) Then
			Return WARNING_HEIGHT
		Else
			SoundSystem.getInstance().playSe(STATE_RETURN_FROM_GAME)
			Return STATE_SELECT_RACE_STAGE
		EndIf
		
	End

	Public Method itemsSelect2Draw:Void(g:MFGraphics, items1:Int, items2:Int)
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
			Return
		EndIf
		
		AnimationDrawer animationDrawer = muiAniDrawer
		Int i = (Key.touchitemsselect2_1.Isin() And Self.itemsselectcursor = 0) ? STATE_GAME : WARNING_HEIGHT
		animationDrawer.setActionId(i + 55)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 18)
		animationDrawer = muiAniDrawer
		
		If (Key.touchitemsselect2_2.Isin() And Self.itemsselectcursor = STATE_GAME) Then
			i = STATE_GAME
		Else
			i = WARNING_HEIGHT
		EndIf
		
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
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 61)
		muiAniDrawer.draw(g, WARNING_HEIGHT, SCREEN_HEIGHT)
	End

	Public Method soundVolumnInit:Void()
		Key.touchSecondEnsureClose()
		Key.touchSecondEnsureInit()
		Self.timeCnt = WARNING_HEIGHT
		Self.isSoundVolumnClick = False
		fadeInit(WARNING_HEIGHT, PlayerAnimationCollisionRect.CHECK_OFFSET)
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
		EndIf
		
	End

	Public Method soundVolumnLogic:Int()
		
		If (Key.touchsecondensurereturn.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = STATE_RETURN_FROM_GAME
		EndIf
		
		If (Key.touchsecondensureyes.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = WARNING_HEIGHT
		EndIf
		
		If (Key.touchsecondensureno.Isin() And Key.touchsecondensure.IsClick()) Then
			Self.confirmcursor = STATE_GAME
		EndIf
		
		If (Key.touchsecondensureyes.Isin()) Then
			Self.timeCnt += STATE_GAME
			
			If (Self.timeCnt <= STATE_SCORE_RANKING And Not Self.isSoundVolumnClick) Then
				If (GlobalResource.soundConfig <= 0) Then
					GlobalResource.soundConfig = WARNING_HEIGHT
				Else
					GlobalResource.soundConfig -= STATE_GAME
				EndIf
				
				If (GlobalResource.soundConfig = 0) Then
					GlobalResource.seConfig = WARNING_HEIGHT
				EndIf
				
				SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
				SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				Self.isSoundVolumnClick = True
			ElseIf (Self.timeCnt > STATE_SCORE_RANKING And Self.timeCnt Mod STATE_RETURN_FROM_GAME = 0) Then
				If (GlobalResource.soundConfig <= 0) Then
					GlobalResource.soundConfig = WARNING_HEIGHT
				Else
					GlobalResource.soundConfig -= STATE_GAME
				EndIf
				
				If (GlobalResource.soundConfig = 0) Then
					GlobalResource.seConfig = WARNING_HEIGHT
				EndIf
				
				SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
				SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
			EndIf
			
		ElseIf (Key.touchsecondensureno.Isin()) Then
			Self.timeCnt += STATE_GAME
			
			If (Self.timeCnt <= STATE_SCORE_RANKING And Not Self.isSoundVolumnClick) Then
				If (GlobalResource.soundConfig >= 15) Then
					GlobalResource.soundConfig = 15
				Else
					GlobalResource.soundConfig += STATE_GAME
				EndIf
				
				If (GlobalResource.soundConfig > 0) Then
					GlobalResource.seConfig = STATE_GAME
				EndIf
				
				Self.isSoundVolumnClick = True
				SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
				SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				
				If (GlobalResource.soundConfig = STATE_GAME) Then
					SoundSystem.getInstance().resumeBgm()
				EndIf
				
			ElseIf (Self.timeCnt > STATE_SCORE_RANKING And Self.timeCnt Mod STATE_RETURN_FROM_GAME = 0) Then
				If (GlobalResource.soundConfig >= 15) Then
					GlobalResource.soundConfig = 15
				Else
					GlobalResource.soundConfig += STATE_GAME
				EndIf
				
				If (GlobalResource.soundConfig > 0) Then
					GlobalResource.seConfig = STATE_GAME
				EndIf
				
				SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
				SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				
				If (GlobalResource.soundConfig = STATE_GAME) Then
					SoundSystem.getInstance().resumeBgm()
				EndIf
			EndIf
			
		Else
			Self.timeCnt = WARNING_HEIGHT
			Self.isSoundVolumnClick = False
		EndIf
		
		If (GlobalResource.soundConfig >= 15) Then
			GlobalResource.soundConfig = 15
		ElseIf (GlobalResource.soundConfig <= 0) Then
			GlobalResource.soundConfig = WARNING_HEIGHT
		EndIf
		
		If (GlobalResource.soundConfig > 0) Then
			GlobalResource.seConfig = STATE_GAME
		EndIf
		
		If ((Not Key.press(Key.B_BACK) And Not Key.touchsecondensurereturn.IsButtonPress()) Or Not fadeChangeOver()) Then
			Return WARNING_HEIGHT
		EndIf
		
		SoundSystem.getInstance().playSe(STATE_RETURN_FROM_GAME)
		Return STATE_RETURN_FROM_GAME
	End

	Public Method soundVolumnDraw:Void(g:MFGraphics)
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
			Return
		EndIf
		
		Int i
		muiAniDrawer.setActionId(54)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
		AnimationDrawer animationDrawer = muiAniDrawer
		
		If (Key.touchsecondensureyes.Isin() And Self.confirmcursor = 0) Then
			i = STATE_GAME
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 59)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		animationDrawer = muiAniDrawer
		
		If (Key.touchsecondensureno.Isin() And Self.confirmcursor = STATE_GAME) Then
			i = STATE_GAME
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 59)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		muiAniDrawer.setActionId(89)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		muiAniDrawer.setActionId(90)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + FADE_FILL_WIDTH, (SCREEN_HEIGHT Shr 1) + FADE_FILL_WIDTH)
		muiAniDrawer.setActionId(71)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
		muiAniDrawer.setActionId(72)
		For (Int i2 = STATE_GAME; i2 <= GlobalResource.soundConfig; i2 += STATE_GAME)
			muiAniDrawer.draw(g, ((SCREEN_WIDTH Shr 1) - PAGE_BACKGROUND_HEIGHT) + ((i2 - 1) * STATE_ENDING), (SCREEN_HEIGHT Shr 1) - BAR_HEIGHT)
		EndIf
		muiAniDrawer.setActionId(GlobalResource.soundConfig + 73)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
		animationDrawer = muiAniDrawer
		
		If (Key.touchsecondensurereturn.Isin()) Then
			i = STATE_SELECT_NORMAL_STAGE
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 61)
		muiAniDrawer.draw(g, WARNING_HEIGHT, SCREEN_HEIGHT)
	End

	Public Method spSenorSetInit:Void()
		Key.touchItemsSelect3Init()
		Self.itemsselectcursor = WARNING_HEIGHT
		Self.isItemsSelect = False
		fadeInit(WARNING_HEIGHT, RollPlatformSpeedB.DEGREE_VELOCITY)
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
		EndIf
		
	End

	Public Method spSenorSetLogic:Int()
		
		If (Key.touchitemsselect3_return.Isin() And Key.touchitemsselect3.IsClick()) Then
			Self.itemsselectcursor = STATE_RETURN_FROM_GAME
		EndIf
		
		If (Key.touchitemsselect3_1.Isin() And Key.touchitemsselect3.IsClick()) Then
			Self.itemsselectcursor = WARNING_HEIGHT
		EndIf
		
		If (Key.touchitemsselect3_2.Isin() And Key.touchitemsselect3.IsClick()) Then
			Self.itemsselectcursor = STATE_GAME
		EndIf
		
		If (Key.touchitemsselect3_3.Isin() And Key.touchitemsselect3.IsClick()) Then
			Self.itemsselectcursor = STATE_SCORE_RANKING
		EndIf
		
		If (Self.isItemsSelect) Then
			Self.itemsselectframe += STATE_GAME
			
			If (Self.itemsselectframe > STATE_ENDING) Then
				fadeInit(220, RollPlatformSpeedB.DEGREE_VELOCITY)
				
				If (Self.Finalitemsselectcursor = 0) Then
					Return STATE_GAME
				EndIf
				
				If (Self.Finalitemsselectcursor = STATE_GAME) Then
					Return STATE_RETURN_FROM_GAME
				EndIf
				
				Return STATE_SCORE_RANKING
			EndIf
		EndIf
		
		If (Key.touchitemsselect3_1.IsButtonPress() And Self.itemsselectcursor = 0 And Not Self.isItemsSelect) Then
			Self.isItemsSelect = True
			Self.itemsselectframe = WARNING_HEIGHT
			Self.Finalitemsselectcursor = WARNING_HEIGHT
			SoundSystem.getInstance().playSe(STATE_GAME)
			Return WARNING_HEIGHT
		ElseIf (Key.touchitemsselect3_2.IsButtonPress() And Self.itemsselectcursor = STATE_GAME And Not Self.isItemsSelect) Then
			Self.isItemsSelect = True
			Self.itemsselectframe = WARNING_HEIGHT
			Self.Finalitemsselectcursor = STATE_GAME
			SoundSystem.getInstance().playSe(STATE_GAME)
			Return WARNING_HEIGHT
		ElseIf (Key.touchitemsselect3_3.IsButtonPress() And Self.itemsselectcursor = STATE_SCORE_RANKING And Not Self.isItemsSelect) Then
			Self.isItemsSelect = True
			Self.itemsselectframe = WARNING_HEIGHT
			Self.Finalitemsselectcursor = STATE_RETURN_FROM_GAME
			SoundSystem.getInstance().playSe(STATE_GAME)
			Return WARNING_HEIGHT
		ElseIf ((Not Key.press(Key.B_BACK) And Not Key.touchitemsselect2_return.IsButtonPress()) Or Not fadeChangeOver()) Then
			Return WARNING_HEIGHT
		Else
			SoundSystem.getInstance().playSe(STATE_RETURN_FROM_GAME)
			Return STATE_SELECT_RACE_STAGE
		EndIf
		
	End

	Public Method spSenorSetDraw:Void(g:MFGraphics)
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(WARNING_HEIGHT, False, WARNING_HEIGHT)
			Return
		EndIf
		
		AnimationDrawer animationDrawer = muiAniDrawer
		Int i = (Key.touchitemsselect3_1.Isin() And Self.itemsselectcursor = 0) ? STATE_GAME : WARNING_HEIGHT
		animationDrawer.setActionId(i + 55)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 36)
		animationDrawer = muiAniDrawer
		
		If (Key.touchitemsselect3_2.Isin() And Self.itemsselectcursor = STATE_GAME) Then
			i = STATE_GAME
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 55)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 36)
		animationDrawer = muiAniDrawer
		
		If (Key.touchitemsselect3_3.Isin() And Self.itemsselectcursor = STATE_SCORE_RANKING) Then
			i = STATE_GAME
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 55)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 72)
		muiAniDrawer.setActionId(70)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 36)
		muiAniDrawer.setActionId(69)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 36)
		muiAniDrawer.setActionId(68)
		muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - 36) + 72)
		animationDrawer = muiAniDrawer
		
		If (Key.touchitemsselect3_return.Isin()) Then
			i = STATE_SELECT_NORMAL_STAGE
		Else
			i = WARNING_HEIGHT
		EndIf
		
		animationDrawer.setActionId(i + 61)
		muiAniDrawer.draw(g, WARNING_HEIGHT, SCREEN_HEIGHT)
	End

	Public Function setSoundVolumnDown:Void()
		
		If (GlobalResource.soundConfig <= 0) Then
			GlobalResource.soundConfig = WARNING_HEIGHT
		Else
			GlobalResource.soundConfig -= STATE_GAME
		EndIf
		
		If (GlobalResource.soundConfig = 0) Then
			GlobalResource.seConfig = WARNING_HEIGHT
		EndIf
		
		SoundSystem.getInstance().setVolumnState(GlobalResource.soundConfig)
		SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
	}

	Public Function setSoundVolumnUp:Void()
		
		If (GlobalResource.soundConfig >= 15) Then
			GlobalResource.soundConfig = 15
		Else
			GlobalResource.soundConfig += STATE_GAME
		EndIf
		
		If (GlobalResource.soundConfig = STATE_GAME) Then
			SoundSystem.getInstance().resumeBgm()
		EndIf
		
		If (GlobalResource.soundConfig > 0) Then
			GlobalResource.seConfig = STATE_GAME
		EndIf
		
		SoundSystem.getInstance().setVolumnState(GlobalResource.soundConfig)
		SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
	}

	Public Function getMain:Void(main:Main)
		activity = main
	}

	Public Method setGameScore:Void(strScore:Int)
		activity.setScore(strScore)
	End

	Public Method sendMessage:Void(msg:Message, id:Int)
		msg.what = id
		activity.handler.handleMessage(msg)
	End
End