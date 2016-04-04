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
	Import platformstandard.standard2
	
	Import sonicgba.gameobject
	Import sonicgba.gimmickobject
	Import sonicgba.globalresource
	Import sonicgba.mapmanager
	Import sonicgba.playeranimationcollisionrect
	Import sonicgba.playerobject
	Import sonicgba.sonicdef
	Import sonicgba.stagemanager
	
	Import special.ssdef
	
	'Import android.os.message
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

Class TitleState Extends State
	Private
		' Constant variable(s):
		Const ACTION_NUM_OFFSET:Int = 49
		Const ACTION_OFFSET:Int = 26
		Const ARRAW_OFFSET_Y:Int = 16
		Const BACK_LINE_SPACE_NORMAL:Int = 96
		Const BACK_LINE_SPACE_TIME:Int = 96
		Const BALL_INIT_Y:Int = (SCREEN_HEIGHT Shr 1) ' / 2
		Const BALL_POSITION_X:Int = 0
		Const BALL_RUN_POSITION_X:Int = -460
		Const CHARACTER_MOVE_OFFSET:Int = 8
		Const CHARACTER_MOVE_OFFSET_SPEED_MAX:Int = 32
		Const CHARACTER_OFFSET_LEFT:Int = 1
		Const CHARACTER_OFFSET_NONE:Int = 0
		Const CHARACTER_OFFSET_RIGHT:Int = 2
		Const CHARACTER_SELECT_ARROW_LEFT:Int = 1
		Const CHARACTER_SELECT_ARROW_NONE:Int = 0
		Const CHARACTER_SELECT_ARROW_RIGHT:Int = 2
		Global CHARACTER_STR:String[] = ["Sonic", "Tails", "Knuckles", "Amy"] ' "索尼克", "塔尔斯", "那克鲁兹", "艾米" ' Const
		Const COPY_RIGHT_X:Int = -2
		Const COPY_RIGHT_Y:Int = 4
		Const CREDIT_PAGE_BACKGROUND_WIDTH:Int = 112
		Const DEGREE_GAP:Int = 18
		Const DEGREE_START:Int = -DEGREE_GAP ' -18
		Const ELEMENT_OFFSET:Int = -1
		Const ELEMENT_V_OFFSET:Int = 0
		Const EN_TITLE_SPACE_FOR_STAGE_SELECT:Int = 0
		Const GESTURE_SLIDE_STATE_DOWN:Int = 2
		Const GESTURE_SLIDE_STATE_NONE:Int = 0
		Const GESTURE_SLIDE_STATE_UP:Int = 1
		Const intergradeRecordtoGamecnt_max:Int = 56
		Const INTERGRADE_RECORD_STAGE_NAME_SPEED:Int = -8
		Const INTERGRADE_RECORD_STAGE_NAME_WIDTH:Int = 200
		Const INTERVAL_ABOVE_RECORD_BAR:Int = (MENU_SPACE Shr 1) ' / 2
		Const INTERVAL_FOR_RECORD_BAR:Int = MENU_SPACE
		Const ITEMS_INTERVALS:Int = 20
		Const ITEM_SPACE:Int = 24
		Const LINE_START_X:Int = LOGO_POSITION_X
		Global LINE_START_Y:Int = ((SCREEN_HEIGHT / 2) + 4 + MENU_SPACE) + PickValue((SCREEN_HEIGHT = 240), 24, 0) ' Shr 1 ' Const
		Const LOGO_POSITION_X:Int = ORIGINAL_LOGO_X
		Const LOGO_POSITION_Y:Int = ORIGINAL_LOGO_Y_ROTATE
		Const LOGO_POSITION_Y_2:Int = ORIGINAL_LOGO_Y_NO_ROTATE
		Const MAIN_MENU_CENTER_X:Int = 51
		Const MAIN_MENU_CENTER_Y:Int = 159
		
		Global MAIN_MENU_FUNCTION_MOREGAME:Int[] = [4, 6, 7, 8, 9, 10, 11, 12] ' Const
		Global MAIN_MENU_FUNCTION_NO_MOREGAME:Int[4, 6, 7, 8, 9, 10, 11, 12] ' Const
		Global MAIN_MENU_FUNCTION_UNACTIVIATE:Int[4, 6, 7, 8, 9, 10, 11, 12] ' Const
		Global MAIN_MENU_MOREGAME:Int[] = [1, 2, 3, 4, 5, 6, 7, 8]
		Global MAIN_MENU_NO_MOREGAME:Int[] = [1, 2, 4, 5, 6, 7, 8] ' Const
		Global MAIN_MENU_UNACTIVIATE:Int[] = [1, 2, 4, 5, 6, 7, 8] ' Const
		
		Const MAIN_MENU_V_CENTER_X:Int = 56 + (SCREEN_WIDTH * 2) ' Shr 1
		Const MAIN_MENU_V_CENTER_Y:Int = 40 + (SCREEN_HEIGHT * 2) ' Shr 1
		Const MENU_SPACE_INTERVAL:Int = 0
		Const N5500_OFFSET:Int = -15
		Const N5500_OFFSET_2:Int = -7
		Const N5500_OFFSET_3:Int = -12
		
		Global OFFSET_ARRAY:Int[] = [0, -1, -1, 0, 1, 1] ' Const
		Global OPTION_DIFFICULTY:Int[] = [51, 53] ' Const
		
		Const OPTION_ELEMENT_NUM:Int = OPTION_TAG.Length
		Const OPTION_MOVING_INTERVAL:Int = 100
		Const OPTION_MOVING_SPEED:Int = 4
		
		Global OPTION_SE:Int[] = [55, 144] ' Const
		Global OPTION_SELECTOR:Int[][] = OPTION_SELECTOR_HAS_SE ' Const
		Global OPTION_SELECTOR_HAS_SE:Int[][] = [OPTION_DIFFICULTY, OPTION_SOUND, OPTION_SE, OPTION_TIME] ' Const
		Global OPTION_SELECTOR_NO_SE:Int[][] = [OPTION_DIFFICULTY, OPTION_SOUND, OPTION_TIME] ' Const
		Global OPTION_SOUND:Int[] = OPTION_SOUND_VOLUME ' Const
		Global OPTION_SOUND_NO_VOLUME:Int[] = [55, 144] ' Const
		Global OPTION_SOUND_VOLUME:Int[] = [55, 58, 58, 58, 57, 57, 57, 57, 56, 56, 56] ' Const
		Global OPTION_TAG:Int[] = OPTION_TAG_HAS_SE ' Const
		Global OPTION_TAG_HAS_SE:Int[] = [50, 54, 143, 59, 146] ' Const
		Global OPTION_TAG_NO_SE:Int[] = [50, 54, 59, 146] ' Const
		Global OPTION_TIME:Int[] = [60, 61] ' Const
		
		Const ORIGINAL_LOGO_X:Int = (152 * SCREEN_WIDTH / 240)
		Const ORIGINAL_LOGO_Y_NO_ROTATE:Int = (61 * SCREEN_HEIGHT / 320)
		Const ORIGINAL_LOGO_Y_ROTATE:Int = (168 * SCREEN_HEIGHT / 320)
		Const PATCH_OFFSET_X:Int = 66
		Const PATCH_OFFSET_Y:Int = 224
		Const PIC_OFFSET_X:Int = 92
		Const PIC_OFFSET_Y:Int = 12
		Const PRESS_START_Y:Int = (236 * SCREEN_HEIGHT / 320)
		Const RADIUS:Int = 137
		Const SHOW_ELEMENT_NUM:Int = 5
		Const SHOW_ELEMENT_V_NUM:Int = 3
		Const SONIC_BALL_SPACE:Int = 120
		Const SONIC_BIG_Y:Int = (28 * SCREEN_HEIGHT / 320)
		Const SONIC_RUN_POSITION_X:Int = -580
		Const STAGE_SELECT_ARROW_STATE_DOWN:Int = 2
		Const STAGE_SELECT_ARROW_STATE_NONE:Int = 0
		Const STAGE_SELECT_ARROW_STATE_UP:Int = 1
		Const STAGE_SELECT_PRESS_STATE_ARROW:Int = 2
		Const STAGE_SELECT_PRESS_STATE_NONE:Int = 0
		Const STAGE_SELECT_PRESS_STATE_SLIDING:Int = 1
		Const STAGE_SELECT_SIDE_BAR_WIDTH:Int = 60
		Const STAGE_TYPE_CANT_CHOOSE:Int = 137
		Const STAGE_TYPE_CHOOSE:Int = 19
		Const STAGE_TYPE_UNCHOOSE:Int = 13
		
		Global START_GAME_MENU:Int[] = [145, 12] ' Const
		
		Const STATE_ABOUT:Int = 11
		Const STATE_BP_TRY_PAYING:Int = 22
		Const STATE_CHARACTER_RECORD:Int = 25
		Const STATE_CHARACTER_SELECT:Int = 23
		Const STATE_EXIT:Int = 12
		Const STATE_GAMEOVER_RANKING:Int = 15
		Const STATE_GOTO_GAME:Int = 5
		Const STATE_HELP:Int = 10
		Const STATE_INTERGRADE_RECORD:Int = 26
		Const STATE_INTERRUPT:Int = 16
		Const STATE_MAIN_MENU:Int = 2
		Const STATE_MORE_GAME:Int = 7
		Const STATE_MOVING:Int = 2
		Const STATE_OPENING:Int = 3
		Const STATE_OPTION:Int = 9
		Const STATE_OPTION_CREDIT:Int = 35
		Const STATE_OPTION_DIFF:Int = 27
		Const STATE_OPTION_HELP:Int = 34
		Const STATE_OPTION_KEY_SET:Int = 31
		Const STATE_OPTION_LANGUAGE:Int = 33
		Const STATE_OPTION_RESET_RECORD:Int = 36
		Const STATE_OPTION_RESET_RECORD_ENSURE:Int = 37
		Const STATE_OPTION_SENSOR_SET:Int = 40
		Const STATE_OPTION_SOUND:Int = 28
		Const STATE_OPTION_SOUND_VOLUMN:Int = 39
		Const STATE_OPTION_SP_SET:Int = 32
		Const STATE_OPTION_TIME_LIMIT:Int = 30
		Const STATE_OPTION_VIBRATION:Int = 29
		Const STATE_PRESS_START:Int = 1
		Const STATE_PRE_PRESS_START:Int = 38
		Const STATE_PRO_RACE_MODE:Int = 24
		Const STATE_QUIT:Int = 13
		Const STATE_RACE_MODE:Int = 6
		Const STATE_RANKING:Int = 8
		Const STATE_RESET_RECORD_ASK:Int = 17
		Const STATE_RETURN_TO_LOGO_1:Int = 20
		Const STATE_RETURN_TO_LOGO_2:Int = 21
		Const STATE_SCORE_UPDATE:Int = 42
		Const STATE_SCORE_UPDATED:Int = 44
		Const STATE_SCORE_UPDATE_ENSURE:Int = 43
		Const STATE_SEGA_LOGO:Int = 0
		Const STATE_SEGA_MORE:Int = 41
		Const STATE_SELECT:Int = 1
		Const STATE_STAGE_SELECT:Int = 14
		Const STATE_START_GAME:Int = 4
		Const STATE_START_TO_MENU_1:Int = 18
		Const STATE_START_TO_MENU_2:Int = 19
		Const STATE_UP:Int = 0
		Const TIME_ATTACK_SPEED_X:Int = -2
		Const TIME_ATTACK_WIDTH:Int = 128
		Const TITLE_BG_COLOR_1:Int = 15530750
		Const TITLE_BG_COLOR_2:Int = 9886462
		Const TITLE_BG_OFFSET:Int = 31
		Const TITLE_BG_SPEED:Int = 1
		Const TITLE_BG_WIDTH:Int = 62
		Const TITLE_FRAME_HEIGHT:Int = (44 * SCREEN_HEIGHT / 320)
		Const TOTAL_OPTION_ITEMS_NUM:Int = 10
		Const VISIBLE_OPTION_ITEMS_NUM:Int = 9
		Const ZONE_NUM_OFFSET:Int = 1
		Const ZONE_OFFSET:Int = -22
		
		' These values will eventually be assigned to constants:
		Const OPENING_STATE_AMY:Byte = 5
		Const OPENING_STATE_EMERALD:Byte = 0
		Const OPENING_STATE_EMERALD_SHINING:Byte = 1
		Const OPENING_STATE_END:Byte = 6
		Const OPENING_STATE_KNUCKLES:Byte = 4
		Const OPENING_STATE_SONIC:Byte = 2
		Const OPENING_STATE_TAILS:Byte = 3
		
		Const PRESS_DELAY:Byte = 5
		
		' Global variable(s):
		Global upCursorDrawer:AnimationDrawer = Null
		Global downCursorDrawer:AnimationDrawer = Null
		
		Global IsSoundVolSet:Bool = False
		
		Global MAIN_MENU:Int[]
		Global MAIN_MENU_FUNCTION:Int[]
		Global MENU_INTERVAL:Int = 0
		Global MENU_OFFSET_X:Int = 0
		
		Global stageName:String[]
		
		Global state:Int
	Public
		' Constant variable(s):
		Const CHARACTER_RECORD_BG_HEIGHT:Int = 48
		Const CHARACTER_RECORD_BG_OFFSET:Int = 128
		Const CHARACTER_RECORD_BG_SPEED:Int = 4
		Const ITEM_X:Int = (5 * SCREEN_WIDTH / 6)
		Const RETURN_PRESSED:Int = 400
		Const STAGE_SELECT_KEY_DIRECT_PLAY:Int = 2
		Const STAGE_SELECT_KEY_RECORD_1:Int = 0
		Const STAGE_SELECT_KEY_RECORD_2:Int = 1
		
		' Global variable(s):
		Global preStageSelectState:Int
		Global titleLeftImage:MFImage
		Global titleRightImage:MFImage
		Global titleSegaImage:MFImage
		
		' Fields:
		Field IsFromOptionItems:Bool
		Field IsFromStageSelect:Bool
		
		Field interrupt_state:Int
		Field offset_flag:Int ' <-- This field may be moved in the future.
		Field titleScale:Float
	Private
		' Fields:
		Field characterRecordDisFlag:Bool
		Field character_arrow_display:Bool
		Field character_circleturnright:Bool
		Field character_idchangeFlag:Bool
		Field character_move:Bool
		Field character_outer:Bool
		Field character_reback:Bool
		Field fadeChangeState:Bool
		Field isAtMainMenu:Bool
		Field isChanged:Bool
		Field isDrawDownArrow:Bool
		Field isDrawUpArrow:Bool
		Field isFromStartGame:Bool
		Field isOptionChange:Bool
		Field isOptionDisFlag:Bool
		Field isRaceModeItemsSelected:Bool
		Field isSelectable:Bool
		Field isStageSelectChange:Bool
		Field isTitleBGMPlay:Bool
		Field mainMenuBackFlag:Bool
		Field mainMenuEnsureFlag:Bool
		Field openingEnding:Bool
		Field openingStateChanging:Bool
		Field optionArrowMoveable:Bool
		Field optionDownArrowAvailable:Bool
		Field optionReturnFlag:Bool
		Field optionUpArrowAvailable:Bool
		Field stageSelectArrowMoveable:Bool
		Field stageSelectDownArrowAvailable:Bool
		Field stageSelectReturnFlag:Bool
		Field stageSelectUpArrowAvailable:Bool
		Field startgameensureFlag:Bool
		
		Field RESET_INFO_COUNT:Int
		Field RecordtimeScrollPosY:Int
		Field STAGE_SEL_ARROW_DOWN_X:Int
		Field STAGE_SEL_ARROW_DOWN_Y:Int
		Field STAGE_SEL_ARROW_UP_X:Int
		Field STAGE_SEL_ARROW_UP_Y:Int
		Field STAGE_TOTAL_NUM:Int
		Field arrowPressState:Int
		Field ballVx:Int
		Field ballY:Int
		Field cameraX:Int
		
		Field charSelAni:Animation[]
		Field charSelAniDrawer:AnimationDrawer
		Field charSelArrowDrawer:AnimationDrawer
		Field charSelCaseDrawer:AnimationDrawer
		
		Field charSelFilAni:Animation[]
		Field charSelFilAniDrawer:AnimationDrawer
		Field charSelRoleDrawer:AnimationDrawer
		Field charSelTitleDrawer:AnimationDrawer
		
		Field interruptDrawer:AnimationDrawer
		
		Field openingAnimation:Animation[]
		Field openingDrawer:AnimationDrawer[]
		Field optionArrowDownDrawer:AnimationDrawer
		Field optionArrowUpDrawer:AnimationDrawer
		
		Field recordAni:Animation[]
		Field recordAniDrawer:AnimationDrawer
		
		Field skipDrawer:AnimationDrawer
		
		Field stageSelAni:Animation[]
		Field stageSelAniDrawer:AnimationDrawer
		Field stageSelArrowDownDrawer:AnimationDrawer
		Field stageSelArrowUpDrawer:AnimationDrawer
		Field stageSelEmeraldDrawer:AnimationDrawer
		
		Field timeAttAni:Animation[]
		Field timeAttAniDrawer:AnimationDrawer
		
		Field titleAni:Animation[]
		Field titleAniDrawer:AnimationDrawer
		
		Field titleSonicDrawer:AnimationDrawer
		
		Field titleFrameImage:MFImage
		
		Field sonicBigImage:MFImage
		Field sonicBigPatchImage:MFImage
		
		Field logoImage:MFImage
		Field copyrightImage:MFImage
		
		Field characterRecordBGOffsetX_1:Int
		Field characterRecordBGOffsetX_2:Int
		
		Field characterRecordID:Int
		Field characterRecordScoreUpdateCursor:Int
		Field characterRecordScoreUpdateIconY:Int
		
		Field character_id:Int
		
		Field character_move_frame:Int
		Field character_offset_state:Int
		Field character_preid:Int
		
		Field character_sel_frame_cnt:Int
		Field character_sel_offset_x:Int
		Field copyOffsetX:Int
		
		Field count:Int
		Field creditOffsetY:Int
		Field creditStringLineNum:Int
		Field currentStageSelectSlidePointY:Int
		Field debug_bgm_id:Int
		Field debug_bgm_state:Int
		Field degree:Int
		Field degreeDes:Int
		Field firstStageSelectSlidePointY:Int
		Field gestureSlideSpeed:Int
		Field gestureSlideState:Int
		Field intergradeRecordStageNameOffsetX:Int
		Field intergradeRecordtoGamecnt:Int
		Field itemOffsetX:Int
		Field logoGravity:Int
		Field logoVx:Int
		Field logoVy:Int
		Field logoX:Int
		Field logoY:Int
		Field mainMenuCursor:Int
		Field menuOptionCursor:Int
		Field multiMainItems:Int[]
		Field nextState:Int
		Field offsetOfVolumeInterface:Int
		Field offsetY:Int[]
		Field opengingCursor:Int
		Field openingCount:Int
		Field openingFrame:Int
		Field openingOffsetX:Int
		Field openingOffsetY:Int
		Field openingState:Byte
		Field optionArrowDriveOffsetY:Int
		Field optionArrowDriveY:Int
		Field optionCursor:Int[]
		Field optionDrawOffsetBottomY:Int
		Field optionDrawOffsetTmpY1:Int
		Field optionDrawOffsetY:Int
		Field optionMenuCursor:Int
		Field optionOffsetTmp:Int
		Field optionOffsetX:Int
		Field optionOffsetY:Int
		Field optionOffsetYAim:Int
		Field optionYDirect:Int
		Field optionslide_getprey:Int
		Field optionslide_gety:Int
		Field optionslide_y:Int
		Field optionslidefirsty:Int
		Field preCharaterSelectState:Int
		Field preStageSelectSlidePointY:Int
		Field pressDelay:Byte
		Field pressDelay2:Byte
		Field quitFlag:Int
		Field rankingScore:Int[]
		Field recordArrowOffsetXArray:Int[]
		Field recordArrowOffsetXID:Int
		Field resetInfoCount:Int
		Field returnCursor:Int
		Field scoreUpdateCursor:Int
		Field shakeCount:Int
		Field sonicBigX:Int
		Field sonicVx:Int
		Field sonicX:Int
		Field sonicY:Int
		Field stageDrawEndY:Int
		Field stageDrawKeyAimY:Int
		Field stageDrawKeyOffsetY:Int
		Field stageDrawOffsetBottomY:Int
		Field stageDrawOffsetTmpY1:Int
		Field stageDrawOffsetTmpY2:Int
		Field stageDrawOffsetY:Int
		Field stageDrawStartY:Int
		Field stageItemNumForShow:Int
		Field stageSelectArrowDriveOffsetY:Int
		Field stageSelectArrowDriveY:Int
		Field stageSelectSlideFrame:Int
		Field stageStartIndex:Int
		Field stageYDirect:Int
		Field stage_characterRecord_ID:Int
		Field stage_sel_key:Int
		Field stage_select_arrow_state:Int
		Field stage_select_press_state:Int
		Field stage_select_state:Int
		Field stageselectslide_getprey:Int
		Field stageselectslide_gety:Int
		Field stageselectslide_y:Int
		Field stageselectslidefirsty:Int
		Field startgamecursor:Int
		Field startgameframe:Int
		Field timeAttackOffsetX:Int
		Field timecount_ranking:Int
		Field titleDegree:Int
		Field titleFrame:Int
		Field title_name_center_x:Int
		Field title_name_center_y:Int
		Field vY:Int[]
	Public
		' Functions:
		Function setMainMenu:Void()
			MAIN_MENU = MAIN_MENU_MOREGAME
			MAIN_MENU_FUNCTION = MAIN_MENU_FUNCTION_MOREGAME
		End
		
		Function drawTitle:Void(g:MFGraphics, layer:Int)
			If (state = STATE_PRE_PRESS_START Or state = STATE_PRESS_START Or state = STATE_MOVING Or state = STATE_EXIT Or state = STATE_START_GAME Or state = STATE_SEGA_MORE) Then
				Local scale:= (Float(MFDevice.getDeviceHeight()) / Float(titleLeftImage.getHeight()))
				
				g.saveCanvas()
				g.scaleCanvas(scale, scale, 0, 0)
				g.drawImage(titleLeftImage, 0, 0, STATE_RETURN_TO_LOGO_1)
				g.restoreCanvas()
				
				g.saveCanvas()
				g.scaleCanvas(scale, scale, MFDevice.getDeviceWidth(), 0)
				g.drawImage(titleRightImage, MFDevice.getDeviceWidth(), 0, STATE_PRO_RACE_MODE)
				g.restoreCanvas()
				
				g.saveCanvas()
				g.scaleCanvas(scale, scale, MFDevice.getDeviceWidth(), MFDevice.getDeviceHeight())
				g.drawImage(titleSegaImage, MFDevice.getDeviceWidth(), MFDevice.getDeviceHeight(), STATE_OPTION_SENSOR_SET)
				g.restoreCanvas()
			EndIf
		End
	Protected
		' Constructor(s):
		Method Construct_TitleState:Void()
			Self.STAGE_TOTAL_NUM = STATE_STAGE_SELECT
			Self.count = 0
			Self.titleScale = 1.0
			Self.title_name_center_x = 77
			Self.title_name_center_y = -53
			Self.titleFrame = 0
			Self.mainMenuBackFlag = False
			Self.resetInfoCount = 0
			Self.RESET_INFO_COUNT = STATE_OPTION_TIME_LIMIT
			Self.optionCursor = New Int[OPTION_ELEMENT_NUM]
			Self.isOptionDisFlag = False
			Self.optionslide_getprey = ELEMENT_OFFSET
			Self.optionslide_gety = ELEMENT_OFFSET
			Self.offsetOfVolumeInterface = 0
			Self.pressDelay = PRESS_DELAY
			Self.pressDelay2 = OPENING_STATE_EMERALD_SHINING
			Self.rankingScore = New Int[STATE_GOTO_GAME]
			Self.timecount_ranking = 0
			Self.offset_flag = 0
			Self.RecordtimeScrollPosY = 0
			Self.logoX = LOGO_POSITION_X
			Self.logoGravity = 12
			Self.copyOffsetX = 0
			Self.opengingCursor = ELEMENT_OFFSET
			Self.shakeCount = 0
			Self.multiMainItems = [3, 5, 7, 12, 9]
			Self.isAtMainMenu = True
			Self.arrowPressState = 0
			Self.timeAttackOffsetX = 0
			Self.stageselectslide_getprey = ELEMENT_OFFSET
			Self.stageselectslide_gety = ELEMENT_OFFSET
			Self.stageSelectReturnFlag = False
			Self.characterRecordDisFlag = False
			
			Local iArr:= New Int[12]
			
			iArr[0] = ZONE_NUM_OFFSET
			iArr[ZONE_NUM_OFFSET] = ZONE_NUM_OFFSET
			iArr[STATE_MOVING] = STATE_MOVING
			iArr[STATE_OPENING] = STATE_MOVING
			iArr[STATE_START_GAME] = STATE_OPENING
			iArr[STATE_GOTO_GAME] = STATE_OPENING
			iArr[STATE_RACE_MODE] = STATE_MOVING
			iArr[STATE_MORE_GAME] = STATE_MOVING
			iArr[STATE_RANKING] = ZONE_NUM_OFFSET
			iArr[VISIBLE_OPTION_ITEMS_NUM] = ZONE_NUM_OFFSET
			
			Self.recordArrowOffsetXArray = iArr
			
			Self.isTitleBGMPlay = False
			Self.debug_bgm_state = 0
			Self.debug_bgm_id = 0
			
			state = 0
			
			Self.logoX = LOGO_POSITION_X
			Self.logoY = LOGO_POSITION_Y
			Self.sonicBigX = 0
		End
	Public
		' Constructor(s):
		Method New()
			Construct_TitleState()
			
			Key.touchsoftkeyInit()
			
			initTitleRes()
		End
		
		Method New(stateId:Int)
			Construct_TitleState()
			
			initTitleRes()
			
			Select (stateId)
				Case STATE_MOVING
					state = ZONE_NUM_OFFSET
					
					Self.nextState = ZONE_NUM_OFFSET
					Self.logoY = LOGO_POSITION_Y
					
					SoundSystem.getInstance().playBgm(ZONE_NUM_OFFSET, False)
				Case STATE_OPENING
					state = STATE_STAGE_SELECT
					
					Self.nextState = STATE_STAGE_SELECT
					
					preStageSelectState = STATE_CHARACTER_SELECT
					
					Self.preCharaterSelectState = STATE_PRO_RACE_MODE
					
					menuInit(Self.STAGE_TOTAL_NUM)
					initStageSelectRes()
					
					PlayerObject.stageModeState = ZONE_NUM_OFFSET
					
					SoundSystem.getInstance().playBgm(STATE_OPENING)
					
					Self.stage_sel_key = ZONE_NUM_OFFSET
				Case STATE_START_GAME
					rankingInit()
					
					state = STATE_GAMEOVER_RANKING
					
					Self.nextState = STATE_GAMEOVER_RANKING
					
					SoundSystem.getInstance().playBgm(STATE_START_GAME)
				Case STATE_GOTO_GAME
					state = STATE_STAGE_SELECT
					
					Self.nextState = STATE_STAGE_SELECT
					preStageSelectState = STATE_MOVING
					
					menuInit(Self.STAGE_TOTAL_NUM)
					initStageSelet()
					
					PlayerObject.stageModeState = 0
					
					SoundSystem.getInstance().playBgm(STATE_OPENING)
				Case VISIBLE_OPTION_ITEMS_NUM
					state = STATE_CHARACTER_SELECT
					
					Self.nextState = STATE_CHARACTER_SELECT
					Self.preCharaterSelectState = STATE_PRO_RACE_MODE
					Self.stage_sel_key = ZONE_NUM_OFFSET
					
					initCharacterSelectRes()
			End Select
			
			Key.touchkeypauseClose()
		End
		
		' Methods:
		Method close:Void()
			MFDevice.disableLayer(ELEMENT_OFFSET)
			
			titleLeftImage = Null
			titleRightImage = Null
			titleSegaImage = Null
			
			Animation.closeAnimationArray(Self.titleAni)
			Self.titleAni = Null
			
			Animation.closeAnimationDrawer(Self.titleAniDrawer)
			Self.titleAniDrawer = Null
			
			Animation.closeAnimationArray(Self.stageSelAni)
			Self.stageSelAni = Null
			
			Animation.closeAnimationDrawer(Self.stageSelAniDrawer)
			Self.stageSelAniDrawer = Null
			
			Animation.closeAnimationDrawer(Self.stageSelArrowUpDrawer)
			Self.stageSelArrowUpDrawer = Null
			
			Animation.closeAnimationDrawer(Self.stageSelArrowDownDrawer)
			Self.stageSelArrowDownDrawer = Null
			
			Animation.closeAnimationDrawer(Self.stageSelEmeraldDrawer)
			Self.stageSelEmeraldDrawer = Null
			
			Animation.closeAnimationDrawer(Self.optionArrowUpDrawer)
			Self.optionArrowUpDrawer = Null
			
			Animation.closeAnimationDrawer(Self.optionArrowDownDrawer)
			Self.optionArrowDownDrawer = Null
			
			Animation.closeAnimationArray(Self.timeAttAni)
			Self.timeAttAni = Null
			
			Animation.closeAnimationDrawer(Self.timeAttAniDrawer)
			Self.timeAttAniDrawer = Null
			
			Animation.closeAnimationArray(Self.recordAni)
			Self.recordAni = Null
			
			Animation.closeAnimationDrawer(Self.recordAniDrawer)
			Self.recordAniDrawer = Null
			
			Animation.closeAnimationArray(Self.charSelAni)
			Self.charSelAni = Null
			
			Animation.closeAnimationDrawer(Self.charSelAniDrawer)
			Self.charSelAniDrawer = Null
			
			Animation.closeAnimationDrawer(Self.charSelCaseDrawer)
			Self.charSelCaseDrawer = Null
			
			Animation.closeAnimationDrawer(Self.charSelRoleDrawer)
			Self.charSelRoleDrawer = Null
			
			Animation.closeAnimationDrawer(Self.charSelArrowDrawer)
			Self.charSelArrowDrawer = Null
			
			Animation.closeAnimationDrawer(Self.charSelTitleDrawer)
			Self.charSelTitleDrawer = Null
			
			Animation.closeAnimationArray(Self.charSelFilAni)
			Self.charSelFilAni = Null
			
			Animation.closeAnimationDrawer(Self.charSelFilAniDrawer)
			Self.charSelFilAniDrawer = Null
			
			Animation.closeAnimationDrawer(Self.titleSonicDrawer)
			Self.titleSonicDrawer = Null
			
			Self.logoImage = Null
			Self.sonicBigImage = Null
			Self.titleFrameImage = Null
			Self.copyrightImage = Null
			
			openingClose()
			
			Animation.closeAnimationDrawer(Self.interruptDrawer)
			Self.interruptDrawer = Null
			
			'System.gc()
			
			'Thread.sleep(100)
		End
		
		Public Method draw:Void(g:MFGraphics)
			Select (state)
				Case STATE_OPTION_HELP, STATE_OPTION_CREDIT
					g.setFont(STATE_ABOUT)
				Default
					g.setFont(STATE_STAGE_SELECT)
			End Select
			
			Select (state)
				Case 0
					Standard.drawSplash(g, MyAPI.zoomOut(SCREEN_WIDTH), MyAPI.zoomOut(SCREEN_HEIGHT))
				Case ZONE_NUM_OFFSET
					drawTitleBg(g)
				Case STATE_MOVING
					drawTitleBg(g)
					drawMainMenu(g)
				Case STATE_OPENING
					openingDraw(g)
				Case STATE_START_GAME
					drawTitleBg(g)
					drawMainMenu(g)
					State.drawFade(g)
					startGameDraw(g)
				Case STATE_RACE_MODE
					stageSelectDraw(g, ZONE_NUM_OFFSET)
					drawTouchKeySelectStage(g)
					State.drawSoftKey(g, True, True)
				Case STATE_MORE_GAME
					moregameDraw(g)
					State.drawSoftKey(g, True, True)
				Case STATE_RANKING
					rankingDraw(g)
					State.drawSoftKey(g, False, True)
				Case VISIBLE_OPTION_ITEMS_NUM
					optionDraw(g)
				Case TOTAL_OPTION_ITEMS_NUM
					helpDraw(g)
					drawTouchKeyHelp(g)
					State.drawSoftKey(g, False, True)
				Case STATE_ABOUT
					aboutDraw(g)
					drawTouchKeyAbout(g)
					State.drawSoftKey(g, False, True)
				Case STATE_EXIT
					drawTitleBg(g)
					
					If (Self.quitFlag = 0) Then
						drawMainMenu(g)
					EndIf
					
					State.drawFade(g)
					SecondEnsurePanelDraw(g, STATE_STAGE_SELECT)
				Case STATE_QUIT
					Standard.drawMoreGame(g, MyAPI.zoomOut(SCREEN_WIDTH), MyAPI.zoomOut(SCREEN_HEIGHT))
				Case STATE_STAGE_SELECT
					drawStageSelect(g)
				Case STATE_GAMEOVER_RANKING
					rankingDraw(g)
					State.drawSoftKey(g, False, True)
				Case STATE_INTERRUPT
					interruptDraw(g)
				Case STATE_RESET_RECORD_ASK
					menuBgDraw(g)
					optionDraw(g)
					State.drawFade(g)
					comfirmDraw(g, StringIndex.STR_RESET_RECORD_COMFIRM)
					State.drawSoftKey(g, True, True)
				Case STATE_START_TO_MENU_1, STATE_START_TO_MENU_2, STATE_RETURN_TO_LOGO_1, STATE_RETURN_TO_LOGO_2
					titleBgDraw0(g)
					drawTitle1(g)
					'drawTitle2(g)
					
					' This behavior may change in the future:
					If (state <> ZONE_NUM_OFFSET Or (Millisecs() / 500) Mod 2 = 0) Then
						drawTitle2(g)
					Else
						'drawTitle2(g)
					EndIf
				Case STATE_CHARACTER_SELECT
					drawCharacterSelect(g)
				Case STATE_PRO_RACE_MODE
					drawProTimeAttack(g)
				Case STATE_CHARACTER_RECORD
					drawCharacterRecord(g)
				Case STATE_INTERGRADE_RECORD
					drawIntergradeRecord(g)
				Case STATE_OPTION_DIFF
					optionDraw(g)
					itemsSelect2Draw(g, STATE_OPTION_LANGUAGE, STATE_OPTION_HELP)
				Case STATE_OPTION_SOUND
					optionDraw(g)
					itemsSelect2Draw(g, STATE_OPTION_CREDIT, STATE_OPTION_RESET_RECORD)
				Case STATE_OPTION_VIBRATION
					optionDraw(g)
					itemsSelect2Draw(g, STATE_OPTION_CREDIT, STATE_OPTION_RESET_RECORD)
				Case STATE_OPTION_TIME_LIMIT
					optionDraw(g)
					itemsSelect2Draw(g, STATE_OPTION_CREDIT, STATE_OPTION_RESET_RECORD)
				Case TITLE_BG_OFFSET
					optionDraw(g)
					State.drawFade(g)
				Case STATE_OPTION_SP_SET
					optionDraw(g)
					itemsSelect2Draw(g, STATE_OPTION_RESET_RECORD_ENSURE, STATE_PRE_PRESS_START)
				Case STATE_OPTION_LANGUAGE
					optionDraw(g)
					menuOptionLanguageDraw(g)
				Case STATE_OPTION_HELP
					optionDraw(g)
					helpDraw(g)
				Case STATE_OPTION_CREDIT
					optionDraw(g)
					creditDraw(g)
				Case STATE_OPTION_RESET_RECORD
					optionDraw(g)
					SecondEnsurePanelDraw(g, STATE_SCORE_UPDATED)
				Case STATE_OPTION_RESET_RECORD_ENSURE
					optionDraw(g)
					SecondEnsurePanelDraw(g, 45)
				Case STATE_PRE_PRESS_START
					g.setColor(0)
					Self.titleAniDrawer.setActionId(0)
					State.drawFade(g)
				Case STATE_OPTION_SOUND_VOLUMN
					optionDraw(g)
					soundVolumnDraw(g)
				Case STATE_OPTION_SENSOR_SET
					optionDraw(g)
					spSenorSetDraw(g)
				Case STATE_SEGA_MORE
					drawTitleBg(g)
					drawMainMenu(g)
					State.drawFade(g)
					SecondEnsurePanelDraw(g, 105)
			End Select
			
			If (isDrawTouchPad And state <> 0 And state <> ZONE_NUM_OFFSET And state <> STATE_QUIT) Then
				drawTouchKeyDirect(g)
			EndIf
		End
		
		Method logic:Void()
			If (Self.count > 0) Then
				Self.count -= ZONE_NUM_OFFSET
			EndIf
			
			fadeStateLogic()
			
			Select (state)
				Case STATE_SEGA_LOGO
					If (Key.press(Key.B_S1 | Key.gSelect)) Then
						Standard.pressConfirm()
					ElseIf (Key.press(2)) Then
						Standard.pressCancel()
					EndIf
					
					Select (Standard.execSplash())
						Case ZONE_NUM_OFFSET
							GlobalResource.soundSwitchConfig = ZONE_NUM_OFFSET
							
							If (GlobalResource.soundConfig = 0) Then
								GlobalResource.soundConfig = VISIBLE_OPTION_ITEMS_NUM
							EndIf
							
							GlobalResource.seConfig = ZONE_NUM_OFFSET
							
							SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
							SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
						Case STATE_MOVING
							GlobalResource.soundSwitchConfig = ZONE_NUM_OFFSET
							GlobalResource.soundConfig = 0
							GlobalResource.seConfig = 0
							
							SoundSystem.getInstance().setSoundState(0)
							SoundSystem.getInstance().setSeState(0)
						Case STATE_OPENING
							changeStateWithFade(STATE_OPENING)
							Key.touchOpeningInit()
							
							If (Not SoundSystem.getInstance().bgmPlaying()) Then
								SoundSystem.getInstance().playBgm(0, False)
							EndIf
							
							Key.touchsoftkeyClose()
							Key.touchanykeyInit()
							State.load_bp_string()
						Default
							' Nothing so far.
					End Select
				Case STATE_PRESS_START
					Self.titleFrame += 1
					
					If (Self.titleFrame > 212) Then
						state = STATE_OPENING
						
						openingInit()
						Key.touchOpeningInit()
						
						SoundSystem.getInstance().playBgm(0, False)
					EndIf
					
					If (Self.titleFrame > STATE_START_GAME) Then
						If (Key.buttonPress(Key.B_SEL)) Then
							SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
							
							gotoMainmenu()
							State.setFadeOver()
							Key.clear()
						EndIf
						
						If (Key.press(Key.B_BACK) And State.fadeChangeOver()) Then
							state = STATE_EXIT
							
							secondEnsureInit()
							State.fadeInit(0, 220)
							
							SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
							
							Self.quitFlag = 1
						EndIf
					EndIf
				Case STATE_MOVING
					mainMenuLogic()
				Case STATE_OPENING
					If (openingLogic()) Then
						state = STATE_PRE_PRESS_START
						
						Self.isTitleBGMPlay = True
						
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInit(255, 0)
						
						openingClose()
						initTitleRes()
					EndIf
				Case STATE_START_GAME
					startGameLogic()
				Case STATE_GOTO_GAME
					State.setState(ZONE_NUM_OFFSET)
				Case STATE_MORE_GAME
					Select (comfirmLogic())
						Case 0
							SoundSystem.getInstance().stopBgm(True)
							Standard.menuMoreGameSelected()
							State.exitGame()
						Case ZONE_NUM_OFFSET, RETURN_PRESSED
							state = STATE_MOVING
							menuInit(MAIN_MENU)
							mainMenuInit()
						Default
							' Nothing so far.
					End Select
				Case STATE_RANKING
					rankingLogic()
				Case VISIBLE_OPTION_ITEMS_NUM
					optionLogic()
				Case TOTAL_OPTION_ITEMS_NUM
					helpLogic()
					
					If (Key.press(2)) Then
						' Nothing so far.
					EndIf
					
					If (Key.press(Key.B_BACK)) Then
						changeStateWithFade(STATE_MOVING)
						menuInit(MAIN_MENU)
						mainMenuInit()
						Key.touchHelpClose()
					EndIf
				Case STATE_ABOUT
					aboutLogic()
				Case STATE_EXIT
					quitLogic()
				Case STATE_QUIT
					If (Key.press(Key.B_S1 | Key.gSelect)) Then
						Standard.pressConfirm()
					ElseIf (Key.press(STATE_MOVING)) Then
						Standard.pressCancel()
					EndIf
					
					Select (Standard.execMoreGame(True))
						Case 0
							Key.touchsoftkeyClose()
							
							GlobalResource.saveSystemConfig()
							
							State.exitGame()
							
							'sendMessage(New Message(), STATE_GOTO_GAME)
						Default
							' Nothing so far.
					End Select
				Case STATE_STAGE_SELECT
					stageSelectLogic()
				Case STATE_GAMEOVER_RANKING
					gameover_rankingLogic()
				Case STATE_INTERRUPT
					interruptLogic()
				Case STATE_RESET_RECORD_ASK
					Select (comfirmLogic())
						Case 0
							StageManager.resetGameRecord()
							Self.resetInfoCount = Self.RESET_INFO_COUNT
							state = VISIBLE_OPTION_ITEMS_NUM
						Case ZONE_NUM_OFFSET, RETURN_PRESSED
							state = VISIBLE_OPTION_ITEMS_NUM
						Default
							' Nothing so far.
					End Select
				Case STATE_START_TO_MENU_1
					Self.logoX = MyAPI.calNextPositionReverse(Self.logoX, LOGO_POSITION_X, SCREEN_WIDTH + (SCREEN_WIDTH Shr 1), ZONE_NUM_OFFSET, STATE_MOVING)
					
					If (Self.logoX = SCREEN_WIDTH + (SCREEN_WIDTH Shr 1)) Then
						Self.logoX = -(SCREEN_WIDTH Shr 1)
						state = STATE_MOVING
						Self.nextState = STATE_MOVING
						Self.logoY = LOGO_POSITION_Y_2
					EndIf
				Case STATE_START_TO_MENU_2
					Self.logoX = MyAPI.calNextPosition(Double(Self.logoX), Double(LOGO_POSITION_X), ZONE_NUM_OFFSET, STATE_MOVING)
					
					If (Self.logoX = LOGO_POSITION_X) Then
						state = STATE_MOVING
						
						Self.nextState = STATE_MOVING
					EndIf
				Case STATE_RETURN_TO_LOGO_1
					Self.logoX = MyAPI.calNextPositionReverse(Self.logoX, LOGO_POSITION_X, SCREEN_WIDTH + (SCREEN_WIDTH Shr 1), ZONE_NUM_OFFSET, STATE_MOVING)
					
					If (Self.logoX = SCREEN_WIDTH + (SCREEN_WIDTH Shr 1)) Then
						Self.logoX = -(SCREEN_WIDTH Shr 1)
						
						state = STATE_RETURN_TO_LOGO_2
						
						Self.nextState = STATE_RETURN_TO_LOGO_2
						Self.logoY = LOGO_POSITION_Y
					EndIf
					
					If (Self.mainMenuBackFlag And Not Self.menuMoving) Then
						Self.mainMenuBackFlag = False
					EndIf
				Case STATE_RETURN_TO_LOGO_2
					Self.logoX = MyAPI.calNextPosition(Double(Self.logoX), Double(LOGO_POSITION_X), ZONE_NUM_OFFSET, STATE_MOVING)
					
					If (Self.logoX = LOGO_POSITION_X) Then
						state = ZONE_NUM_OFFSET
						
						Self.nextState = ZONE_NUM_OFFSET
					EndIf
					
					If (Self.mainMenuBackFlag And Not Self.menuMoving) Then
						Self.mainMenuBackFlag = False
					EndIf
				Case STATE_CHARACTER_SELECT
					characterSelectLogic()
				Case STATE_PRO_RACE_MODE
					proRaceModeLogic()
				Case STATE_CHARACTER_RECORD
					characterRecordLogic()
				Case STATE_INTERGRADE_RECORD
					intergradeRecordLogic()
				Case STATE_OPTION_DIFF
					menuOptionDiffLogic()
				Case STATE_OPTION_SOUND
					menuOptionSoundLogic()
				Case STATE_OPTION_VIBRATION
					menuOptionVibLogic()
				Case STATE_OPTION_TIME_LIMIT
					menuOptionTimeLimitLogic()
				Case STATE_OPTION_SP_SET
					menuOptionSpSetLogic()
				Case STATE_OPTION_LANGUAGE
					menuOptionLanguageLogic()
				Case STATE_OPTION_HELP
					helpLogic()
					
					If ((Key.press(Key.B_BACK) Or (Key.touchhelpreturn.IsButtonPress() And Self.returnPageCursor = ZONE_NUM_OFFSET)) And State.fadeChangeOver()) Then
						changeStateWithFade(VISIBLE_OPTION_ITEMS_NUM)
						
						Self.isOptionDisFlag = False
						
						SoundSystem.getInstance().playSe(STATE_MOVING)
					EndIf
				Case STATE_OPTION_CREDIT
					creditLogic()
				Case STATE_OPTION_RESET_RECORD
					menuOptionResetRecordLogic()
				Case STATE_OPTION_RESET_RECORD_ENSURE
					menuOptionResetRecordEnsureLogic()
				Case STATE_PRE_PRESS_START
					If (State.fadeChangeOver()) Then
						state = ZONE_NUM_OFFSET
						
						State.setFadeColor(0)
						
						Key.touchOpeningClose()
					EndIf
				Case STATE_OPTION_SOUND_VOLUMN
					Select (soundVolumnLogic())
						Case STATE_MOVING
							State.fadeInit(220, 0)
							state = VISIBLE_OPTION_ITEMS_NUM
						Default
							' Nothing so far.
					End Select
				Case STATE_OPTION_SENSOR_SET
					Select (spSenorSetLogic())
						Case ZONE_NUM_OFFSET
							GlobalResource.sensorConfig = 0
							
							State.fadeInit(220, 0)
							
							state = VISIBLE_OPTION_ITEMS_NUM
						Case STATE_MOVING
							GlobalResource.sensorConfig = ZONE_NUM_OFFSET
							
							State.fadeInit(220, 0)
							
							state = VISIBLE_OPTION_ITEMS_NUM
						Case STATE_OPENING
							State.fadeInit(220, 0)
							
							state = VISIBLE_OPTION_ITEMS_NUM
						Case STATE_START_GAME
							GlobalResource.sensorConfig = STATE_MOVING
							
							State.fadeInit(220, 0)
							
							state = VISIBLE_OPTION_ITEMS_NUM
						Default
							' Nothing so far.
					End Select
				Case STATE_SEGA_MORE
					segaMoreLogic()
				Default
					' Nothing so far.
			End Select
		End
		
		Method init:Void()
			Try
				helpStrings = MyAPI.loadText("/help")
				aboutStrings = MyAPI.loadText("/about")
				
				Self.openingOffsetX = (SCREEN_WIDTH - 284) Shr 1
				Self.openingOffsetY = (SCREEN_HEIGHT - 160) Shr 1
			Catch E:Throwable
				' Nothing so far.
			End Try
			
			Self.count = 50
			
			State.initMenuFont()
			
			If (state = STATE_TITLE) Then
				openingInit()
			EndIf
			
			Self.titleScale = 4.0
		End
		
		Method changeUpSelect:Void()
			Self.degree = DEGREE_START
			Self.menuMoving = True
		End
		
		Method changeDownSelect:Void()
			Self.degree = STATE_START_TO_MENU_1
			Self.menuMoving = True
		End
		
		Method changeStateWithFade:Void(nState:Int)
			If (Not fading) Then
				fading = True
				
				State.fadeInit(0, 255)
				
				Self.nextState = nState
				Self.fadeChangeState = True
			EndIf
		End
		
		Method fadeStateLogic:Void()
			If (fading And Self.fadeChangeState And State.fadeChangeOver() And state <> Self.nextState) Then
				state = Self.nextState
				
				Self.fadeChangeState = False
				
				If (Self.IsFromStageSelect) Then
					State.fadeInit(255, 102)
					
					Self.IsFromStageSelect = False
				ElseIf (Self.IsFromOptionItems) Then
					State.fadeInit(255, 220)
					
					Self.IsFromOptionItems = False
				Else
					State.fadeInit(255, 0)
				EndIf
			EndIf
			
			If (state = Self.nextState And State.fadeChangeOver()) Then
				fading = False
			EndIf
		End
	Private
		' Methods:
		Method drawTitleName:Void(g:MFGraphics)
			If (Self.titleFrame = 0) Then
				Self.titleScale = 4.0
				Self.title_name_center_x = 216
				Self.title_name_center_y = 152
			ElseIf (Self.titleFrame = ZONE_NUM_OFFSET) Then
				Self.titleScale = 3.25f
				Self.title_name_center_x = 162
				Self.title_name_center_y = 114
			ElseIf (Self.titleFrame = STATE_MOVING) Then
				Self.titleScale = 2.5f
				Self.title_name_center_x = Def.TOUCH_SEL_1_W
				Self.title_name_center_y = 76
			ElseIf (Self.titleFrame = STATE_OPENING) Then
				Self.titleScale = 1.75f
				Self.title_name_center_x = 54
				Self.title_name_center_y = STATE_PRE_PRESS_START
			ElseIf (Self.titleFrame >= STATE_START_GAME) Then
				Self.titleScale = 1.0
				Self.title_name_center_x = 0
				Self.title_name_center_y = 0
			EndIf
			
			g.saveCanvas()
			
			g.translateCanvas(SCREEN_WIDTH + Self.title_name_center_x, (SCREEN_HEIGHT Shr 1) + Self.title_name_center_y)
			g.scaleCanvas(Self.titleScale, Self.titleScale)
			
			Self.titleAniDrawer.setActionId(ZONE_NUM_OFFSET)
			
			g.restoreCanvas()
			
			If (Self.titleFrame >= STATE_START_GAME) Then
				Self.titleAniDrawer.setActionId(STATE_ABOUT)
			EndIf
		End
		
		Method drawSegaLogo:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Method menuDraw:Void(g:MFGraphics)
			Self.menuMoving = False
			
			#Rem
				If (Self.currentElement <> Null) Then
					Local posStartY:= (SCREEN_HEIGHT - ((Self.currentElement.Length - 1) * MENU_INTERVAL)) Shr 1
					
					For Local i:= 0 Until Self.currentElement.Length
						' Nothing so far.
					Next
				EndIf
			#End
		End
		
		Method mainMenuInit:Void()
			Self.menuMoving = True
			Self.degree = (Self.currentElement.Length - 1) * STATE_START_TO_MENU_1
			Self.degreeDes = 0
		End
		
		Method mainMenuBackInit:Void()
			Self.menuMoving = True
			Self.mainMenuBackFlag = True
			Self.degree = 0
			Self.degreeDes = (Self.currentElement.Length - 1) * STATE_START_TO_MENU_1
		End
		
		Method mainMenuDraw:Void(g:MFGraphics)
			If (Self.mainMenuBackFlag) Then
				Self.degree = MyAPI.calNextPositionReverse(Self.degree, 0, Self.degreeDes, ZONE_NUM_OFFSET, STATE_OPENING)
			Else
				Self.degree = MyAPI.calNextPosition(Double(Self.degree), Double(Self.degreeDes), ZONE_NUM_OFFSET, STATE_OPENING)
			EndIf
			
			If (Self.degree = Self.degreeDes) Then
				Self.menuMoving = False
			EndIf
			
			If (Self.currentElement <> Null) Then
				Local startCursor:= (((Self.cursor + ELEMENT_OFFSET) - 1) + Self.currentElement.Length) Mod Self.currentElement.Length
				
				For Local i:= 0 Until 6
					Local elementId:= (startCursor + i) Mod Self.currentElement.Length
					Local currentDegree:= (Self.degree + DEGREE_START) + ((i - 1) * STATE_START_TO_MENU_1)
					
					If (currentDegree >= -27 And currentDegree <= 63) Then
						State.drawMenuFontById(g, Self.currentElement[elementId], ((Cos(currentDegree) * STAGE_TYPE_CANT_CHOOSE) + 5100) / OPTION_MOVING_INTERVAL, ((Sin(currentDegree) * STAGE_TYPE_CANT_CHOOSE) + 15900) / OPTION_MOVING_INTERVAL)
					EndIf
				Next
			EndIf
		End
		
		Method mainMenuDrawV:Void(g:MFGraphics)
			Self.menuMoving = False
			Self.mainMenuBackFlag = False
			
			Local startCursor:= (((Self.cursor + 0) - 1) + Self.elementNum) Mod Self.elementNum
			
			If (Self.currentElement <> Null) Then
				For Local i:= 0 Until 3
					Local currentPos:= MAIN_MENU_V_CENTER_Y + ((i - 1) * STATE_RETURN_TO_LOGO_1)
					
					State.drawMenuFontById(g, Self.currentElement[(startCursor + i) Mod Self.currentElement.Length], MAIN_MENU_V_CENTER_X, currentPos)
				Next
				
				State.drawMenuFontById(g, 95, MAIN_MENU_V_CENTER_X, (SCREEN_HEIGHT Shr 1) + TOTAL_OPTION_ITEMS_NUM)
				State.drawMenuFontById(g, BACK_LINE_SPACE_TIME, MAIN_MENU_V_CENTER_X, (SCREEN_HEIGHT Shr 1) + 70)
			EndIf
		End
		
		Method mainMenuDraw2:Void(g:MFGraphics)
			MENU_OFFSET_X = (SCREEN_WIDTH Shr 1) + STATE_INTERRUPT
			
			Self.degree = MyAPI.calNextPosition(Double(Self.degree), 0.0d, ZONE_NUM_OFFSET, STATE_OPENING)
			
			If (Self.degree = 0) Then
				Self.menuMoving = False
			EndIf
			
			Local startCursor:= (((Self.cursor + ELEMENT_OFFSET) - 1) + Self.currentElement.Length) Mod Self.currentElement.Length
			
			For Local i:= 0 Until 4
				Local elementId:= (startCursor + i) Mod Self.currentElement.Length
				Local x:= MENU_OFFSET_X
				Local y:= (Self.degree + LINE_START_Y) + ((MENU_SPACE + MENU_SPACE_INTERVAL) * (i - 1))
				
				If (y >= LINE_START_Y - ((MENU_SPACE + MENU_SPACE_INTERVAL) Shr 1) And y <= (LINE_START_Y + (MENU_OFFSET_X * 2)) + ((MENU_SPACE + MENU_SPACE_INTERVAL) Shr 1)) Then
					State.drawMenuFontById(g, Self.currentElement[elementId], x, y)
				EndIf
			Next
		End
		
		Method titleBgDraw0:Void(g:MFGraphics)
			' Nothing so far.
		End
		
		Method drawMenuSelection1:Void(g:MFGraphics, id:Int, x:Int, y:Int)
			State.drawMenuBar(g, ZONE_NUM_OFFSET, 0, y)
			
			Self.selectMenuOffsetX += STATE_RANKING
			Self.selectMenuOffsetX Mod= MOVE_DIRECTION
			
			While ((x - Self.selectMenuOffsetX) > 0)
				x -= MOVE_DIRECTION
			Wend
			
			For Local i:= 0 Until 2
				State.drawMenuFontById(g, id, (x + (MOVE_DIRECTION * i)) - Self.selectMenuOffsetX, y)
			Next
		End
		
		Method optionInit:Void()
			Self.optionMenuCursor = 0
			
			Self.optionCursor[0] = GlobalResource.difficultyConfig
			Self.optionCursor[ZONE_NUM_OFFSET] = GlobalResource.soundConfig
			Self.optionCursor[STATE_MOVING] = GlobalResource.seConfig
			Self.optionCursor[STATE_OPENING] = GlobalResource.timeLimit
			
			Self.resetInfoCount = 0
			
			warningY = WARNING_Y_DES_2
			
			Self.offsetOfVolumeInterface = 0
			Self.optionOffsetX = 0
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			If (Self.optionArrowUpDrawer = Null) Then
				Self.optionArrowUpDrawer = New Animation("/animation/mui").getDrawer(64, True, 0)
				Self.optionArrowDownDrawer = New Animation("/animation/mui").getDrawer(65, True, 0)
			EndIf
			
			Key.touchMenuOptionInit()
			
			Self.menuOptionCursor = 0
			Self.optionOffsetYAim = 0
			Self.optionOffsetY = 0
			Self.isChanged = False
			Self.isOptionDisFlag = False
			Self.optionslide_getprey = ELEMENT_OFFSET
			Self.optionslide_gety = ELEMENT_OFFSET
			Self.optionslide_y = 0
			Self.optionDrawOffsetBottomY = -96
			Self.optionYDirect = 0
		End
		
		Method optionLogic:Void()
			If (Not Self.isOptionDisFlag) Then
				SoundSystem.getInstance().playBgm(STATE_GOTO_GAME)
				
				Self.isOptionDisFlag = True
			EndIf
			
			Self.optionslide_gety = Key.slidesensormenuoption.getPointerY()
			
			If (Self.optionslide_gety = ELEMENT_OFFSET And Self.optionslide_getprey = ELEMENT_OFFSET) Then
				Self.optionslide_y = 0
				Self.optionslidefirsty = 0
			ElseIf (Self.optionslide_gety <> ELEMENT_OFFSET And Self.optionslide_getprey = ELEMENT_OFFSET) Then
				Self.optionslidefirsty = Self.optionslide_gety
			ElseIf (Self.optionslide_gety <> ELEMENT_OFFSET And Self.optionslide_getprey <> ELEMENT_OFFSET) Then
				Self.optionslide_y = Self.optionslide_gety - Self.optionslidefirsty
			ElseIf (Self.optionslide_gety = ELEMENT_OFFSET And Self.optionslide_getprey <> ELEMENT_OFFSET) Then
				Self.optionDrawOffsetTmpY1 = Self.optionslide_y + Self.optionDrawOffsetY
			EndIf
			
			For Local i:= 0 Until (Key.touchmenuoptionitems.Length / 2) ' Shr 1
				Key.touchmenuoptionitems[i * 2].setStartY((((i * STATE_PRO_RACE_MODE) + STATE_OPTION_SOUND) + Self.optionDrawOffsetY) + Self.optionslide_y)
				Key.touchmenuoptionitems[(i * 2) + ZONE_NUM_OFFSET].setStartY((((i * STATE_PRO_RACE_MODE) + STATE_OPTION_SOUND) + Self.optionDrawOffsetY) + Self.optionslide_y)
			Next
			
			If (Self.isSelectable) Then
				For Local i:= 0 Until Key.touchmenuoptionitems.Length
					If (Key.touchmenuoptionitems[i].Isin() And Key.touchmenuoption.IsClick()) Then
						Self.menuOptionCursor = (i / STATE_MOVING)
						Self.returnCursor = 0
						
						Exit
					EndIf
				Next
			EndIf
			
			If (Key.touchmenuoptionreturn.Isin() And Key.touchmenuoption.IsClick()) Then
				Self.returnCursor = ZONE_NUM_OFFSET
			EndIf
			
			If ((Key.press(Key.B_BACK) Or (Key.touchmenuoptionreturn.IsButtonPress() And Self.returnCursor = ZONE_NUM_OFFSET)) And State.fadeChangeOver()) Then
				changeStateWithFade(STATE_MOVING)
				
				Self.isTitleBGMPlay = False
				
				Key.touchMainMenuInit2()
				
				SoundSystem.getInstance().stopBgm(False)
				SoundSystem.getInstance().playSe(STATE_MOVING)
				
				GlobalResource.saveSystemConfig()
				
				Self.returnCursor = 0
				
				menuInit(Self.multiMainItems)
			EndIf
			
			If (Self.optionDrawOffsetY + Self.optionslide_y < 0) Then
				Self.optionUpArrowAvailable = True
			Else
				Self.optionUpArrowAvailable = False
			EndIf
			
			If (Self.optionDrawOffsetY + Self.optionslide_y > Self.optionDrawOffsetBottomY) Then
				Self.optionDownArrowAvailable = True
			Else
				Self.optionDownArrowAvailable = False
			EndIf
			
			If (Key.touchmenuoptionuparrow.Isin() And Self.optionUpArrowAvailable) Then
				Self.optionArrowDriveOffsetY = STATE_EXIT
				Self.optionArrowMoveable = True
			EndIf
			
			If (Key.touchmenuoptiondownarrow.Isin() And Self.optionDownArrowAvailable) Then
				Self.optionArrowDriveOffsetY = N5500_OFFSET_3
				Self.optionArrowMoveable = True
			EndIf
			
			If (Self.optionArrowMoveable) Then
				Self.optionArrowDriveOffsetY /= STATE_MOVING
				
				If (Self.optionArrowDriveOffsetY > 0 And Self.optionArrowDriveOffsetY < STATE_MOVING) Then
					Self.optionArrowDriveOffsetY = STATE_MOVING
				EndIf
				
				If (Self.optionArrowDriveOffsetY < 0 And Self.optionArrowDriveOffsetY > TIME_ATTACK_SPEED_X) Then
					Self.optionArrowDriveOffsetY = TIME_ATTACK_SPEED_X
				EndIf
				
				Self.optionArrowDriveY += Self.optionArrowDriveOffsetY
				
				If (Self.optionArrowDriveOffsetY > 0) Then
					If (Self.optionArrowDriveY >= STATE_PRO_RACE_MODE) Then
						Self.optionArrowDriveY = STATE_PRO_RACE_MODE
						Self.optionDrawOffsetY += Self.optionArrowDriveY
						Self.optionArrowDriveY = 0
						Self.optionArrowMoveable = False
					EndIf
					
				ElseIf (Self.optionArrowDriveOffsetY < 0 And Self.optionArrowDriveY <= -24) Then
					Self.optionArrowDriveY = -24
					Self.optionDrawOffsetY += Self.optionArrowDriveY
					Self.optionArrowDriveY = 0
					Self.optionArrowMoveable = False
				EndIf
			EndIf
			
			If (Key.slidesensormenuoption.isSliding()) Then
				If (Self.optionslide_y > STATE_START_GAME Or Self.optionslide_y < -4) Then
					Self.isOptionChange = True
					Self.isSelectable = False
					releaseOptionItemsTouchKey()
					Self.optionReturnFlag = False
				Else
					Self.isSelectable = True
				EndIf
				
				If (Key.slidesensormenuoption.isSlide(Key.DIR_UP)) Then
					Self.isOptionChange = True
					Self.isSelectable = False
				ElseIf (Key.slidesensormenuoption.isSlide(Key.DIR_DOWN)) Then
					Self.isOptionChange = True
					Self.isSelectable = False
				EndIf
			Else
				If (Self.isOptionChange And Self.optionslide_y = 0) Then
					Self.optionDrawOffsetY = Self.optionDrawOffsetTmpY1
					Self.isOptionChange = False
					Self.optionYDirect = 0
				EndIf
				
				If (Not Self.isOptionChange) Then
					Local speed:Int
					
					If (Self.optionDrawOffsetY > 0) Then
						Self.optionYDirect = ZONE_NUM_OFFSET
						speed = (-Self.optionDrawOffsetY) Shr 1
						
						If (speed > TIME_ATTACK_SPEED_X) Then
							speed = TIME_ATTACK_SPEED_X
						EndIf
						
						If (Self.optionDrawOffsetY + speed <= 0) Then
							Self.optionDrawOffsetY = 0
							Self.optionYDirect = 0
						Else
							Self.optionDrawOffsetY += speed
						EndIf
					ElseIf (Self.optionDrawOffsetY < Self.optionDrawOffsetBottomY) Then
						Self.optionYDirect = STATE_MOVING
						speed = (Self.optionDrawOffsetBottomY - Self.optionDrawOffsetY) Shr 1
						
						If (speed < STATE_MOVING) Then
							speed = STATE_MOVING
						EndIf
						
						If (Self.optionDrawOffsetY + speed >= Self.optionDrawOffsetBottomY) Then
							Self.optionDrawOffsetY = Self.optionDrawOffsetBottomY
							Self.optionYDirect = 0
						Else
							Self.optionDrawOffsetY += speed
						EndIf
					EndIf
				EndIf
			EndIf
			
			If (Self.isSelectable And Self.optionYDirect = 0) Then
				If (Key.touchmenuoptionitems[ZONE_NUM_OFFSET].IsButtonPress() And Self.menuOptionCursor = 0 And State.fadeChangeOver()) Then
					state = STATE_OPTION_DIFF
					itemsSelect2Init()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchmenuoptionitems[STATE_OPENING].IsButtonPress() And Self.menuOptionCursor = ZONE_NUM_OFFSET And GlobalResource.soundSwitchConfig <> 0 And State.fadeChangeOver()) Then
					state = STATE_OPTION_SOUND_VOLUMN
					soundVolumnInit()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchmenuoptionitems[STATE_GOTO_GAME].IsButtonPress() And Self.menuOptionCursor = STATE_MOVING And State.fadeChangeOver()) Then
					state = STATE_OPTION_VIBRATION
					itemsSelect2Init()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchmenuoptionitems[STATE_MORE_GAME].IsButtonPress() And Self.menuOptionCursor = STATE_OPENING And State.fadeChangeOver()) Then
					state = STATE_OPTION_TIME_LIMIT
					itemsSelect2Init()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchmenuoptionitems[VISIBLE_OPTION_ITEMS_NUM].IsButtonPress() And Self.menuOptionCursor = STATE_START_GAME And State.fadeChangeOver()) Then
					state = STATE_OPTION_SP_SET
					itemsSelect2Init()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchmenuoptionitems[STATE_ABOUT].IsButtonPress() And Self.menuOptionCursor = STATE_GOTO_GAME And State.fadeChangeOver()) Then
					If (GlobalResource.spsetConfig <> 0) Then
						state = STATE_OPTION_SENSOR_SET
						spSenorSetInit()
						SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
					Else
						SoundSystem.getInstance().playSe(STATE_MOVING)
					EndIf
				ElseIf (Key.touchmenuoptionitems[STATE_EXIT].IsButtonPress() And Self.menuOptionCursor = STATE_RACE_MODE And State.fadeChangeOver()) Then
					changeStateWithFade(STATE_OPTION_HELP)
					helpInit()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchmenuoptionitems[STATE_STAGE_SELECT].IsButtonPress() And Self.menuOptionCursor = STATE_MORE_GAME And State.fadeChangeOver()) Then
					changeStateWithFade(STATE_OPTION_CREDIT)
					creditInit()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchmenuoptionitems[STATE_INTERRUPT].IsButtonPress() And Self.menuOptionCursor = STATE_RANKING And State.fadeChangeOver()) Then
					state = STATE_OPTION_RESET_RECORD
					secondEnsureInit()
					State.fadeInit(102, 220)
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				EndIf
			EndIf
			
			Self.optionslide_getprey = Self.optionslide_gety
		End
		
		Method releaseOptionItemsTouchKey:Void()
			For Local i:= 0 Until Key.touchmenuoptionitems.Length
				Key.touchmenuoptionitems[i].resetKeyState()
			Next
		End
		
		Method optionDraw:Void(g:MFGraphics)
			Local i:Int
			
			g.setColor(0)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			muiAniDrawer.setActionId(52)
			
			For Local i2:= 0 Until (SCREEN_WIDTH / CHARACTER_RECORD_BG_HEIGHT) + 1 ' ZONE_NUM_OFFSET
				For Local j:= 0 Until (SCREEN_HEIGHT / CHARACTER_RECORD_BG_HEIGHT) + 1 ' ZONE_NUM_OFFSET
					muiAniDrawer.draw(g, i2 * CHARACTER_RECORD_BG_HEIGHT, j * CHARACTER_RECORD_BG_HEIGHT)
				Next
			Next
			
			If (state <> VISIBLE_OPTION_ITEMS_NUM) Then
				Self.menuOptionCursor = -2 ' TIME_ATTACK_SPEED_X
			EndIf
			
			Local animationDrawer:= muiAniDrawer
			
			animationDrawer.setActionId(STATE_START_TO_MENU_2)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + Self.optionArrowDriveY)
			
			If (Key.touchmenuoptionitems[ZONE_NUM_OFFSET].Isin() And Self.menuOptionCursor = 0 And Self.isSelectable) Then
				i = ZONE_NUM_OFFSET ' 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, ((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + Self.optionArrowDriveY)
			
			If (GlobalResource.difficultyConfig = 0) Then
				i = ZONE_NUM_OFFSET ' 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + STATE_OPTION_LANGUAGE)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, ((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + Self.optionArrowDriveY)
			animationDrawer.setActionId(STATE_CHARACTER_RECORD)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + STATE_PRO_RACE_MODE) + Self.optionArrowDriveY)
			
			If (GlobalResource.soundSwitchConfig = 0) Then
				i = 67
			Else
				i = (Key.touchmenuoptionitems[STATE_OPENING].Isin() And Self.menuOptionCursor = ZONE_NUM_OFFSET And Self.isSelectable) ? ZONE_NUM_OFFSET : 0
				i += 57
			EndIf
			
			animationDrawer.setActionId(i)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + STATE_PRO_RACE_MODE) + Self.optionArrowDriveY)
			animationDrawer.setActionId(GlobalResource.soundConfig + 73)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + STATE_PRO_RACE_MODE) + Self.optionArrowDriveY)
			animationDrawer.setActionId(STATE_RETURN_TO_LOGO_2)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + CHARACTER_RECORD_BG_HEIGHT) + Self.optionArrowDriveY)
			
			If (Key.touchmenuoptionitems[STATE_GOTO_GAME].Isin() And Self.menuOptionCursor = STATE_MOVING And Self.isSelectable) Then
				i = ZONE_NUM_OFFSET
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + CHARACTER_RECORD_BG_HEIGHT) + Self.optionArrowDriveY)
			
			If (GlobalResource.vibrationConfig = 0) Then
				i = ZONE_NUM_OFFSET
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + STATE_OPTION_CREDIT)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + CHARACTER_RECORD_BG_HEIGHT) + Self.optionArrowDriveY)
			animationDrawer.setActionId(STATE_BP_TRY_PAYING)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + 72) + Self.optionArrowDriveY)
			
			If (Key.touchmenuoptionitems[STATE_MORE_GAME].Isin() And Self.menuOptionCursor = STATE_OPENING And Self.isSelectable) Then
				i = ZONE_NUM_OFFSET ' 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + 72) + Self.optionArrowDriveY)
			animationDrawer.setActionId(GlobalResource.timeLimit + STATE_OPTION_CREDIT)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + 72) + Self.optionArrowDriveY)
			animationDrawer.setActionId(STATE_CHARACTER_SELECT)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + BACK_LINE_SPACE_TIME) + Self.optionArrowDriveY)
			
			i = (Key.touchmenuoptionitems[VISIBLE_OPTION_ITEMS_NUM].Isin() And Self.menuOptionCursor = STATE_START_GAME And Self.isSelectable) ? ZONE_NUM_OFFSET : 0
			
			animationDrawer.setActionId(i + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + BACK_LINE_SPACE_TIME) + Self.optionArrowDriveY)
			
			If (GlobalResource.spsetConfig = 0) Then
				i = 0
			Else
				i = ZONE_NUM_OFFSET ' 1
			EndIf
			
			animationDrawer.setActionId(i + STATE_OPTION_RESET_RECORD_ENSURE)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + BACK_LINE_SPACE_TIME) + Self.optionArrowDriveY)
			muiAniDrawer.setActionId(STATE_PRO_RACE_MODE)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + SONIC_BALL_SPACE) + Self.optionArrowDriveY)
			animationDrawer = muiAniDrawer
			
			If (GlobalResource.spsetConfig = 0) Then
				i = 67
			Else
				i = (Key.touchmenuoptionitems[STATE_ABOUT].Isin() And Self.menuOptionCursor = STATE_GOTO_GAME And Self.isSelectable) ? ZONE_NUM_OFFSET : 0
				i += 57
			EndIf
			
			animationDrawer.setActionId(i)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + SONIC_BALL_SPACE) + Self.optionArrowDriveY)
			
			Select (GlobalResource.sensorConfig)
				Case 0
					animationDrawer.setActionId(70)
				Case 1
					animationDrawer.setActionId(69)
				Case 2
					animationDrawer.setActionId(68)
			End Select
			
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + intergradeRecordtoGamecnt_max, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + SONIC_BALL_SPACE) + Self.optionArrowDriveY)
			
			If (Key.touchmenuoptionitems[STATE_EXIT].Isin() And Self.menuOptionCursor = STATE_RACE_MODE And Self.isSelectable) Then
				i = ZONE_NUM_OFFSET
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + STATE_OPTION_DIFF)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + StringIndex.STR_SOUND_OPEN) + Self.optionArrowDriveY)
			
			If (Key.touchmenuoptionitems[STATE_STAGE_SELECT].Isin() And Self.menuOptionCursor = STATE_MORE_GAME And Self.isSelectable) Then
				i = ZONE_NUM_OFFSET
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + STATE_OPTION_VIBRATION)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + 168) + Self.optionArrowDriveY)
			
			If (Key.touchmenuoptionitems[STATE_INTERRUPT].Isin() And Self.menuOptionCursor = STATE_RANKING And Self.isSelectable) Then
				i = ZONE_NUM_OFFSET
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + TITLE_BG_OFFSET)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, (((Self.optionDrawOffsetY + STATE_OPTION_SENSOR_SET) + Self.optionslide_y) + 192) + Self.optionArrowDriveY)
			
			If (Self.optionUpArrowAvailable) Then
				Self.optionArrowUpDrawer.draw(g, (SCREEN_WIDTH Shr 1) + Def.TOUCH_OPTION_ARROW_OFFSET_X, (SCREEN_HEIGHT Shr 1) - 19)
			EndIf
			
			If (Self.optionDownArrowAvailable) Then
				Self.optionArrowDownDrawer.draw(g, (SCREEN_WIDTH Shr 1) + Def.TOUCH_OPTION_ARROW_OFFSET_X, (SCREEN_HEIGHT Shr 1) + STATE_CHARACTER_RECORD)
			EndIf
			
			Self.optionOffsetX -= STATE_START_GAME
			Self.optionOffsetX Mod= OPTION_MOVING_INTERVAL
			
			animationDrawer.setActionId(MAIN_MENU_CENTER_X)
			
			For Local x1:= Self.optionOffsetX Until (SCREEN_WIDTH * 2) Step OPTION_MOVING_INTERVAL
				animationDrawer.draw(g, x1, 0)
			Next
			
			If (Key.touchmenuoptionreturn.Isin()) Then
				i = STATE_GOTO_GAME
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			animationDrawer.draw(g, 0, SCREEN_HEIGHT)
			
			State.drawFade(g)
		End
		
		Private Method itemsid:Int(id:Int)
			Int itemsidoffset = (Self.optionOffsetY / STATE_PRO_RACE_MODE) * 2
			
			If (id + itemsidoffset < 0) Then
				Return 0
			EndIf
			
			If (id + itemsidoffset > VISIBLE_OPTION_ITEMS_NUM) Then
				Return VISIBLE_OPTION_ITEMS_NUM
			EndIf
			
			Return id + itemsidoffset
		End
		
		Public Method aboutInit:Void()
			MyAPI.initString()
			strForShow = MyAPI.getStrings(aboutStrings[0], MENU_RECT_WIDTH - STATE_RETURN_TO_LOGO_1)
		End
		
		Public Method aboutLogic:Void()
			Bool IsUp
			Bool IsDown
			Key.touchAboutInit()
			
			If (Key.touchhelpup.Isin() Or Key.repeated(Key.gUp)) Then
				IsUp = True
			Else
				IsUp = False
			EndIf
			
			If (Key.touchhelpdown.Isin() Or Key.repeated(Key.gDown)) Then
				IsDown = True
			Else
				IsDown = False
			EndIf
			
			MyAPI.logicString(IsDown, IsUp)
			
			If (Key.press(STATE_MOVING)) Then
			EndIf
			
			If (Key.press(Key.B_BACK)) Then
				changeStateWithFade(STATE_MOVING)
				menuInit(MAIN_MENU)
				mainMenuInit()
				Key.touchAboutClose()
			EndIf
			
		End
		
		Public Method aboutDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			drawMenuTitle(g, STATE_MORE_GAME, 0)
			State.fillMenuRect(g, FRAME_X, STATE_OPTION_TIME_LIMIT, FRAME_WIDTH, FRAME_HEIGHT)
			g.setColor(0)
			MyAPI.drawBoldStrings(g, strForShow, FRAME_X + TOTAL_OPTION_ITEMS_NUM, STATE_PRE_PRESS_START, MENU_RECT_WIDTH - STATE_RETURN_TO_LOGO_1, FRAME_HEIGHT - STATE_INTERRUPT, MapManager.END_COLOR, 4656650, 0)
		End
		
		Private Method rankingInit:Void()
			StageManager.normalHighScoreInit()
		End
		
		Private Method rankingLogic:Void()
			Select (comfirmLogic())
				Case RETURN_PRESSED
					changeStateWithFade(STATE_MOVING)
					menuInit(MAIN_MENU)
					mainMenuInit()
					StageManager.drawHighScoreEnd()
				Default
			End Select
		End
		
		Private Method rankingDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			For (Int i = 0; i < (SCREEN_WIDTH / STATE_OPTION_SP_SET) + ZONE_NUM_OFFSET; i += 1)
				State.drawMenuFontById(g, 111, i * STATE_OPTION_SP_SET, 0)
				State.drawMenuFontById(g, CREDIT_PAGE_BACKGROUND_WIDTH, (i * STATE_OPTION_SP_SET) - 1, SCREEN_HEIGHT)
			Next
			drawMenuTitle(g, STATE_START_GAME, 0)
			StageManager.drawNormalHighScore(g)
		End
		
		Private Method gameover_rankingLogic:Void()
			Self.timecount_ranking += 1
			Select (comfirmLogic())
				Case RETURN_PRESSED
					changeStateWithFade(STATE_MOVING)
					menuInit(MAIN_MENU)
					mainMenuInit()
					Self.returnCursor = 0
					StageManager.drawHighScoreEnd()
				Default
			End Select
		End
		
		Private Method gameover_rankingDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			For (Int i = 0; i < (SCREEN_WIDTH / STATE_OPTION_SP_SET) + ZONE_NUM_OFFSET; i += 1)
				State.drawMenuFontById(g, 111, i * STATE_OPTION_SP_SET, 0)
				State.drawMenuFontById(g, CREDIT_PAGE_BACKGROUND_WIDTH, i * STATE_OPTION_SP_SET, SCREEN_HEIGHT)
			Next
			drawMenuTitle(g, STATE_START_GAME, 0)
			StageManager.drawNormalHighScore(g)
		End
		
		Private Method initStageSelet:Void()
			Self.stageItemNumForShow = getAvailableItemNum()
			Self.stageDrawEndY = (Self.stageDrawStartY + (Self.stageItemNumForShow * ITEM_SPACE)) - (ITEM_SPACE Shr 1)
			Self.stageStartIndex = 0
			Self.stageDrawOffsetY = 0
			Self.offsetY = New Int[Self.STAGE_TOTAL_NUM]
			Self.vY = New Int[Self.STAGE_TOTAL_NUM]
			Self.offsetY[0] = (SCREEN_HEIGHT Shr 1) - 72
			Self.vY[0] = STATE_START_GAME
			For (Int i = ZONE_NUM_OFFSET; i < Self.STAGE_TOTAL_NUM; i += 1)
				Self.offsetY[i] = Self.offsetY[i - 1] * 2
				Self.vY[i] = Self.vY[i - 1] * 2
			Next
			Self.stage_select_state = 0
			Self.optionMenuCursor = 0
		End
		
		Private Method getAvailableItemNum:Int()
			Int num = (((SCREEN_HEIGHT - INTERVAL_FOR_RECORD_BAR) - MENU_TITLE_DRAW_OFFSET_Y) - INTERVAL_ABOVE_RECORD_BAR) / ITEM_SPACE
			
			If (num Mod STATE_MOVING <> 0) Then
				If (num < STATE_MOVING) Then
					num += 1
				Else
					num += ELEMENT_OFFSET
				EndIf
			EndIf
			
			If (num > StageManager.STAGE_NUM) Then
				If (StageManager.STAGE_NUM < STATE_RANKING) Then
					Self.stageDrawStartY = (MENU_TITLE_DRAW_OFFSET_Y + (MENU_SPACE Shr 1)) + (((((SCREEN_HEIGHT - INTERVAL_FOR_RECORD_BAR) - MENU_TITLE_DRAW_OFFSET_Y) - INTERVAL_ABOVE_RECORD_BAR) - (StageManager.STAGE_NUM * ITEM_SPACE)) Shr 1)
				Else
					Self.stageDrawStartY = 72
				EndIf
				
				Return StageManager.STAGE_NUM
			EndIf
			
			Self.stageDrawStartY = (MENU_TITLE_DRAW_OFFSET_Y + (MENU_SPACE Shr 1)) + (ITEM_SPACE Shr 1)
			Return num
		End
		
		Public Method stageSelectDraw:Void(g:MFGraphics, type:Int)
			Int i
			menuBgDraw(g)
			Self.stageDrawOffsetY = MyAPI.calNextPosition((double) Self.stageDrawOffsetY, (double) ((-Self.stageStartIndex) * ITEM_SPACE), ZONE_NUM_OFFSET, STATE_MOVING)
			
			If (Self.stageItemNumForShow <> StageManager.STAGE_NUM) Then
				MyAPI.setClip(g, 0, Self.stageDrawStartY - (ITEM_SPACE Shr 1), SCREEN_WIDTH, Self.stageItemNumForShow * ITEM_SPACE)
			EndIf
			
			For (i = 0; i < StageManager.STAGE_NAME.Length; i += 1)
				
				If (i = Self.optionMenuCursor And Self.stage_select_state = ZONE_NUM_OFFSET) Then
					g.setColor(16711680)
				Else
					g.setColor(0)
				EndIf
				
				MyAPI.drawString(g, "stage" + StageManager.STAGE_NAME[i], SCREEN_WIDTH Shr 1, (Self.stageDrawOffsetY + (i * STATE_RETURN_TO_LOGO_1)) + STATE_RETURN_TO_LOGO_1, STATE_RESET_RECORD_ASK)
			Next
			MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			If (type = 0) Then
				For (i = 0; i < (SCREEN_HEIGHT / BACK_LINE_SPACE_TIME) + ZONE_NUM_OFFSET; i += 1)
					State.drawMenuFontById(g, 104, 0, i * BACK_LINE_SPACE_TIME)
				Next
				drawMenuTitle(g, ZONE_NUM_OFFSET, STATE_GOTO_GAME, 0)
			ElseIf (type = ZONE_NUM_OFFSET) Then
				For (i = 0; i < (SCREEN_HEIGHT / BACK_LINE_SPACE_TIME) + 2; i += 1)
					State.drawMenuFontById(g, GimmickObject.GIMMICK_NUM, 0, i * BACK_LINE_SPACE_TIME)
				Next
				drawMenuTitle(g, STATE_MOVING, STATE_GOTO_GAME, 0)
			EndIf
			
			Self.STAGE_SEL_ARROW_UP_X = (SCREEN_WIDTH Shr 1) - 64
			Self.STAGE_SEL_ARROW_UP_Y = (SCREEN_HEIGHT Shr 1) - CHARACTER_RECORD_BG_HEIGHT
			Self.STAGE_SEL_ARROW_DOWN_X = (SCREEN_WIDTH Shr 1) - 64
			Self.STAGE_SEL_ARROW_DOWN_Y = (SCREEN_HEIGHT Shr 1) + CHARACTER_RECORD_BG_HEIGHT
		End
		
		Private Method drawStageName:Void(g:MFGraphics, stageId:Int, type:Int, offsetX:Int, mOffsetY:Int)
			State.drawMenuFontById(g, 109, COMFIRM_X, ((Self.stageDrawStartY + (ITEM_SPACE * stageId)) + Self.offsetY[stageId]) + mOffsetY)
			State.drawMenuFontById(g, (type + 2) + (stageId Mod STATE_MOVING), (COMFIRM_X + ACTION_NUM_OFFSET) + offsetX, ((Self.stageDrawStartY + (ITEM_SPACE * stageId)) + Self.offsetY[stageId]) + mOffsetY)
			State.drawMenuFontById(g, type + ZONE_NUM_OFFSET, (COMFIRM_X + STATE_INTERGRADE_RECORD) + offsetX, ((Self.stageDrawStartY + (ITEM_SPACE * stageId)) + Self.offsetY[stageId]) + mOffsetY)
			State.drawMenuFontById(g, ((stageId Shr 1) + type) + 2, (COMFIRM_X + ZONE_NUM_OFFSET) + offsetX, ((Self.stageDrawStartY + (ITEM_SPACE * stageId)) + Self.offsetY[stageId]) + mOffsetY)
			State.drawMenuFontById(g, type, (COMFIRM_X + ZONE_OFFSET) + offsetX, ((Self.stageDrawStartY + (ITEM_SPACE * stageId)) + Self.offsetY[stageId]) + mOffsetY)
		End
		
		Private Method drawRecordtimeScroll:Void(g:MFGraphics, id:Int, y:Int, timeCount:Int, speed:Int, space:Int)
			State.drawBar(g, 0, y)
			Self.itemOffsetX += speed
			Self.itemOffsetX Mod= space
			Int x = 0
			While (x - Self.itemOffsetX > 0) {
				x -= space
			}
			Int drawNum = (((SCREEN_WIDTH + space) - 1) / space) + 2
			For (Int i = 0; i < drawNum; i += 1)
				Int x2 = x + (i * space)
				State.drawMenuFontById(g, id, x2 - Self.itemOffsetX, y)
				drawRecordtime(g, timeCount, (x2 - Self.itemOffsetX) + FONT_WIDTH, y)
			Next
		End
		
		Private Method drawRecordtime:Void(g:MFGraphics, timeCount:Int, x:Int, y:Int)
			PlayerObject.drawRecordTimeLeft(g, timeCount, x, y)
		End
		
		Private Method drawTimeNum:Void(g:MFGraphics, num:Int, x:Int, y:Int, blockNum:Int)
			Int i
			Int divideNum = ZONE_NUM_OFFSET
			For (i = ZONE_NUM_OFFSET; i < blockNum; i += 1)
				divideNum *= TOTAL_OPTION_ITEMS_NUM
			Next
			For (i = 0; i < blockNum; i += 1)
				divideNum /= TOTAL_OPTION_ITEMS_NUM
				State.drawMenuFontById(g, (Abs(num / divideNum) Mod TOTAL_OPTION_ITEMS_NUM) + STATE_OPTION_RESET_RECORD_ENSURE, (i * STATE_RANKING) + x, y)
			Next
		End
		
		Public Method pause:Void()
			
			If (state <> STATE_SCORE_UPDATED) Then
				If (state = STATE_INTERRUPT) Then
					state = STATE_INTERRUPT
					Self.nextState = STATE_INTERRUPT
					interruptInit()
					Return
				EndIf
				
				If (Self.fadeChangeState And Self.nextState <> state) Then
					state = Self.nextState
					Self.fadeChangeState = False
					
					If (Self.IsFromStageSelect) Then
						State.fadeInit(255, 102)
						Self.IsFromStageSelect = False
					ElseIf (Self.IsFromOptionItems) Then
						State.fadeInit(255, 220)
						Self.IsFromOptionItems = False
					Else
						State.fadeInit(255, 0)
					EndIf
				EndIf
				
				Self.interrupt_state = state
				state = STATE_INTERRUPT
				Self.nextState = STATE_INTERRUPT
				interruptInit()
				Key.touchInterruptInit()
				Standard.pause()
				Key.touchkeyboardInit()
			EndIf
			
		End
		
		Private Method interruptInit:Void()
			
			If (Self.interruptDrawer = Null) Then
				Self.interruptDrawer = Animation.getInstanceFromQi("/animation/utl_res/suspend_resume.dat")[0].getDrawer(0, True, 0)
			EndIf
			
			IsInInterrupt = True
			lastFading = fading
			fading = False
		End
		
		Public Method interruptLogic:Void()
			SoundSystem.getInstance().stopBgm(False)
			
			If (Key.press(STATE_MOVING)) Then
			EndIf
			
			If (Key.press(Key.B_BACK) Or (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress())) Then
				SoundSystem.getInstance().playSe(STATE_MOVING)
				Key.touchInterruptClose()
				Key.touchkeyboardClose()
				MFGamePad.resetKeys()
				
				If (Key.touchitemsselect2_1 <> Null) Then
					Key.touchitemsselect2_1.reset()
				EndIf
				
				If (Key.touchitemsselect2_2 <> Null) Then
					Key.touchitemsselect2_2.reset()
				EndIf
				
				If (Key.touchitemsselect3_1 <> Null) Then
					Key.touchitemsselect3_1.reset()
				EndIf
				
				If (Key.touchitemsselect3_2 <> Null) Then
					Key.touchitemsselect3_2.reset()
				EndIf
				
				If (Key.touchitemsselect3_3 <> Null) Then
					Key.touchitemsselect3_3.reset()
				EndIf
				
				Standard.resume()
				state = Self.interrupt_state
				Select (Self.interrupt_state)
					Case STATE_MOVING
						State.fadeInit(0, 0)
						break
					Case STATE_OPENING
						Self.interrupt_state = STATE_PRE_PRESS_START
						state = STATE_PRE_PRESS_START
						Self.isTitleBGMPlay = True
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInit(255, 0)
						initTitleRes()
						SoundSystem.getInstance().playBgm(ZONE_NUM_OFFSET, False)
						break
					Case STATE_RACE_MODE
					Case STATE_RANKING
						SoundSystem.getInstance().playBgm(STATE_START_GAME)
						break
					Case VISIBLE_OPTION_ITEMS_NUM
						SoundSystem.getInstance().playBgm(STATE_GOTO_GAME)
						break
					Case STATE_STAGE_SELECT
						State.fadeInit(0, 0)
						SoundSystem.getInstance().playBgm(STATE_OPENING)
						break
					Case STATE_CHARACTER_SELECT
						SoundSystem.getInstance().playBgm(STATE_MOVING)
						break
					Case STATE_PRO_RACE_MODE
						State.fadeInit(0, 0)
						initTimeStageRes()
						break
					Case STATE_CHARACTER_RECORD
						State.fadeInit(0, 0)
						Self.characterRecordDisFlag = False
						break
					Case STATE_OPTION_DIFF
					Case STATE_OPTION_SOUND
					Case STATE_OPTION_VIBRATION
					Case STATE_OPTION_TIME_LIMIT
					Case TITLE_BG_OFFSET
					Case STATE_OPTION_SP_SET
					Case STATE_OPTION_LANGUAGE
					Case STATE_OPTION_RESET_RECORD
					Case STATE_OPTION_RESET_RECORD_ENSURE
					Case STATE_OPTION_SOUND_VOLUMN
					Case STATE_OPTION_SENSOR_SET
						SoundSystem.getInstance().playBgm(STATE_GOTO_GAME)
						Self.IsFromOptionItems = True
						break
					Case STATE_OPTION_HELP
						SoundSystem.getInstance().playBgm(STATE_GOTO_GAME)
						break
					Case STATE_OPTION_CREDIT
						SoundSystem.getInstance().playBgm(STATE_OPTION_LANGUAGE)
						break
				End Select
				Select (Self.interrupt_state)
					Case 0
						Key.touchsoftkeyInit()
						break
					Case ZONE_NUM_OFFSET
						Key.touchanykeyInit()
						break
					Default
						Key.touchkeyboardInit()
						break
				End Select
				IsInInterrupt = False
				Self.IsFromStageSelect = False
				Self.IsFromOptionItems = False
				Key.clear()
			EndIf
			
		End
		
		Public Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId((Key.touchinterruptreturn.Isin() ? ZONE_NUM_OFFSET : 0) + 0)
			Self.interruptDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
		End
		
		Private Method openingInit:Void()
			close()
			Self.openingFrame = 0
			Self.openingState = OPENING_STATE_EMERALD
			Int i
			
			If (Self.openingAnimation = Null) Then
				Self.openingAnimation = Animation.getInstanceFromQi("/animation/opening/opening.dat")
				Self.openingDrawer = New AnimationDrawer[Self.openingAnimation.Length]
				For (i = 0; i < Self.openingDrawer.Length; i += 1)
					Self.openingDrawer[i] = Self.openingAnimation[i].getDrawer(0, False, 0)
					Self.openingDrawer[i].mustKeepFrameTime(63)
				Next
			Else
				For (i = 0; i < Self.openingDrawer.Length; i += 1)
					Self.openingDrawer[i].setActionId(0)
					Self.openingDrawer[i].restart()
				Next
			EndIf
			
			If (Self.skipDrawer = Null) Then
				Self.skipDrawer = New Animation("/animation/skip").getDrawer(0, False, 0)
			EndIf
			
			Self.openingStateChanging = False
		End
		
		Private Method openingClose:Void()
			Animation.closeAnimationArray(Self.openingAnimation)
			Self.openingAnimation = Null
			Animation.closeAnimationDrawerArray(Self.openingDrawer)
			Self.openingDrawer = Null
			Animation.closeAnimationDrawer(Self.skipDrawer)
			Self.skipDrawer = Null
			'System.gc()
			try {
				Thread.sleep(100)
			} catch (Exception e) {
				e.printStackTrace()
			}
		End
		
		Private Method openingLogic:Bool()
			Self.openingFrame += 1
			
			If (Key.touchopeningskip.Isin() And Key.touchopening.IsClick()) Then
				Self.opengingCursor = 0
			EndIf
			
			If ((Key.touchopeningskip.IsButtonPress() Or Key.press(Key.B_S1)) And Not Self.openingDrawer[STATE_START_GAME].checkEnd()) Then
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				SoundSystem.getInstance().stopBgm(False)
				SoundSystem.getInstance().playBgm(ZONE_NUM_OFFSET, False)
				Return True
			EndIf
			
			If (Self.openingCount > 0) Then
				Self.openingCount -= ZONE_NUM_OFFSET
			EndIf
			
			Select (Self.openingState)
				Case 0
					
					If (Self.openingDrawer[0].checkEnd()) Then
						Self.openingDrawer[0].setActionId(ZONE_NUM_OFFSET)
						Self.openingState = OPENING_STATE_EMERALD_SHINING
						SoundSystem.getInstance().playSequenceSe(80)
						break
					EndIf
					
					break
				Case ZONE_NUM_OFFSET
					
					If (Self.openingDrawer[0].checkEnd()) Then
						Self.openingDrawer[ZONE_NUM_OFFSET].setActionId(0)
						Self.openingState = OPENING_STATE_SONIC
						break
					EndIf
					
					break
				Case STATE_MOVING
					
					If (Self.openingDrawer[ZONE_NUM_OFFSET].checkEnd()) Then
						Self.openingDrawer[STATE_MOVING].setActionId(0)
						
						If (Self.openingStateChanging) Then
							If (State.fadeChangeOver()) Then
								Self.openingState = OPENING_STATE_TAILS
								Self.openingStateChanging = False
								break
							EndIf
						EndIf
						
						Self.openingStateChanging = True
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInit(0, 255)
						break
					EndIf
					
					break
				Case STATE_OPENING
					
					If (Self.openingDrawer[STATE_MOVING].checkEnd()) Then
						Self.openingDrawer[STATE_OPENING].setActionId(0)
						
						If (Self.openingStateChanging) Then
							If (State.fadeChangeOver()) Then
								Self.openingState = OPENING_STATE_KNUCKLES
								Self.openingStateChanging = False
								break
							EndIf
						EndIf
						
						Self.openingStateChanging = True
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInit(0, 255)
						break
					EndIf
					
					break
				Case STATE_START_GAME
					
					If (Self.openingDrawer[STATE_OPENING].checkEnd()) Then
						Self.openingDrawer[STATE_START_GAME].setActionId(0)
						Self.openingDrawer[STATE_START_GAME].restart()
						Self.openingEnding = False
						
						If (Self.openingStateChanging) Then
							If (State.fadeChangeOver()) Then
								Self.openingState = PRESS_DELAY
								Self.openingStateChanging = False
								break
							EndIf
						EndIf
						
						Self.openingStateChanging = True
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInit(0, 255)
						break
					EndIf
					
					break
				Case STATE_GOTO_GAME
					
					If (Self.openingDrawer[STATE_START_GAME].checkEnd() And Self.openingEnding And State.fadeChangeOver()) Then
						Self.openingState = OPENING_STATE_END
						break
					EndIf
					
				Case STATE_RACE_MODE
					Self.openingFrame = 0
					Return True
			End Select
			Return False
		End
		
		Private Method openingDraw:Void(g:MFGraphics)
			Select (Self.openingState)
				Case 0
				Case ZONE_NUM_OFFSET
					Self.openingDrawer[0].draw(g, Self.openingOffsetX, Self.openingOffsetY)
					break
				Case STATE_MOVING
					Self.openingDrawer[ZONE_NUM_OFFSET].draw(g, Self.openingOffsetX, Self.openingOffsetY)
					break
				Case STATE_OPENING
					Self.openingDrawer[STATE_MOVING].draw(g, Self.openingOffsetX, Self.openingOffsetY)
					break
				Case STATE_START_GAME
					Self.openingDrawer[STATE_OPENING].draw(g, Self.openingOffsetX, Self.openingOffsetY)
					break
				Case STATE_GOTO_GAME
					Self.openingDrawer[STATE_START_GAME].draw(g, Self.openingOffsetX, Self.openingOffsetY)
					
					If (Not Self.openingEnding And Self.openingDrawer[STATE_START_GAME].checkEnd()) Then
						Self.openingEnding = True
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInit(0, 255)
					EndIf
					
					If (Self.openingEnding) Then
						State.drawFadeBase(g, STATE_MOVING)
						break
					EndIf
					
					break
			End Select
			
			If (Self.openingStateChanging) Then
				State.drawFadeBase(g, STATE_MOVING)
			EndIf
			
			If (Not Self.openingDrawer[STATE_START_GAME].checkEnd()) Then
				Int i
				AnimationDrawer animationDrawer = Self.skipDrawer
				
				If (Key.touchopeningskip.Isin() And Self.opengingCursor = 0) Then
					i = ZONE_NUM_OFFSET
				Else
					i = 0
				EndIf
				
				animationDrawer.setActionId(i + 0)
				Self.skipDrawer.draw(g, 0, SCREEN_HEIGHT)
			EndIf
			
		End
		
		Private Method initTitleRes:Void()
			
			If (titleLeftImage = Null) Then
				MFDevice.enableLayer(ELEMENT_OFFSET)
				titleLeftImage = MFImage.createImage("/title/title_left.png")
				titleRightImage = MFImage.createImage("/title/title_right.png")
				titleSegaImage = MFImage.createImage("/title/title_sega.png")
				
				If (Self.titleAni = Null) Then
					Self.titleAni = Animation.getInstanceFromQi("/animation/utl_res/title.dat")
					Self.titleAniDrawer = Self.titleAni[0].getDrawer(0, True, 0)
				EndIf
				
				Self.titleFrame = 0
				Key.touchMainMenuInit2()
			EndIf
			
		End
		
		Private Method initTitleRes2:Void()
			
			If (Self.titleAni = Null) Then
				Self.titleAni = Animation.getInstanceFromQi("/animation/utl_res/title.dat")
				Self.titleAniDrawer = Self.titleAni[0].getDrawer(0, True, 0)
			EndIf
			
			Self.titleFrame = STATE_GOTO_GAME
			Key.touchMainMenuInit2()
		End
		
		Private Method drawTitleBg:Void(g:MFGraphics)
			g.setColor(0)
			Self.titleAniDrawer.setActionId(0)
			
			If (state = ZONE_NUM_OFFSET) Then
				If ((Millisecs() / 500) Mod 2 = 0) Then
					Self.titleAniDrawer.setActionId(STATE_MOVING)
					Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_OPTION_LANGUAGE)
				EndIf
				
			ElseIf (state = STATE_EXIT And Self.quitFlag = ZONE_NUM_OFFSET) Then
				Self.titleAniDrawer.setActionId(STATE_MOVING)
				Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_OPTION_LANGUAGE)
			EndIf
			
			drawSegaLogo(g)
			drawTitleName(g)
		End
		
		Private Method drawMainMenuNormal:Void(g:MFGraphics)
			
			If (state = STATE_MOVING) Then
				Self.isAtMainMenu = True
			Else
				Self.isAtMainMenu = False
			EndIf
			
			AnimationDrawer animationDrawer = Self.titleAniDrawer
			Int i = Self.isAtMainMenu ? (Key.touchmainmenustart.Isin() And Self.cursor = 0) ? ZONE_NUM_OFFSET : 0 : 0
			animationDrawer.setActionId(i + STATE_OPENING)
			Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_EXIT)
			animationDrawer = Self.titleAniDrawer
			i = Self.isAtMainMenu ? (Key.touchmainmenurace.Isin() And Self.cursor = ZONE_NUM_OFFSET) ? ZONE_NUM_OFFSET : 0 : 0
			animationDrawer.setActionId(i + STATE_GOTO_GAME)
			Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_OPTION_SP_SET)
			animationDrawer = Self.titleAniDrawer
			i = Self.isAtMainMenu ? (Key.touchmainmenuoption.Isin() And Self.cursor = STATE_MOVING) ? ZONE_NUM_OFFSET : 0 : 0
			animationDrawer.setActionId(i + STATE_MORE_GAME)
			Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + 52)
			animationDrawer = Self.titleAniDrawer
			i = Self.isAtMainMenu ? (Key.touchmainmenuend.Isin() And Self.cursor = STATE_OPENING) ? ZONE_NUM_OFFSET : 0 : 0
			animationDrawer.setActionId(i + VISIBLE_OPTION_ITEMS_NUM)
			Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + 72)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			animationDrawer = muiAniDrawer
			
			If (Key.touchmainmenureturn.Isin()) Then
				i = STATE_GOTO_GAME
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Private Method drawMainMenuMultiItems:Void(g:MFGraphics)
			
			If (state = STATE_MOVING) Then
				Self.isAtMainMenu = True
			Else
				Self.isAtMainMenu = False
			EndIf
			
			Self.degree = MyAPI.calNextPosition((double) Self.degree, 0.0d, ZONE_NUM_OFFSET, STATE_OPENING)
			
			If (Self.degree = 0) Then
				Self.menuMoving = False
			EndIf
			
			Self.titleAniDrawer.setActionId(STATE_STAGE_SELECT)
			Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_OPTION_SENSOR_SET)
			Int startCursor = (((Self.mainMenuItemCursor + ELEMENT_OFFSET) - 1) + Self.currentElement.Length) Mod Self.currentElement.Length
			For (Int i = 0; i < STATE_START_GAME; i += 1)
				Int elementId = (startCursor + i) Mod Self.currentElement.Length
				Int y = (Self.degree + STATE_RETURN_TO_LOGO_1) + ((i - 1) * STATE_RETURN_TO_LOGO_1)
				
				If (y >= TOTAL_OPTION_ITEMS_NUM And y <= 70) Then
					Int i2
					AnimationDrawer animationDrawer = Self.titleAniDrawer
					Int i3 = Self.currentElement[elementId]
					
					If (Self.mainMenuEnsureFlag And Self.mainMenuItemCursor = elementId) Then
						i2 = ZONE_NUM_OFFSET
					Else
						i2 = 0
					EndIf
					
					animationDrawer.setActionId(i3 + i2)
					Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + y)
				EndIf
				
			Next
			Self.titleAniDrawer.setActionId(STATE_GAMEOVER_RANKING)
			Self.titleAniDrawer.draw(g, 0, SCREEN_HEIGHT Shr 1)
			drawSegaLogo(g)
			drawTitleName(g)
			Self.titleAniDrawer.setActionId(STATE_INTERRUPT)
			Self.titleAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_OPTION_SENSOR_SET)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			animationDrawer = muiAniDrawer
			
			If (Key.touchmainmenureturn.Isin()) Then
				i3 = STATE_GOTO_GAME
			Else
				i3 = 0
			EndIf
			
			animationDrawer.setActionId(i3 + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Private Method drawMainMenu:Void(g:MFGraphics)
			drawMainMenuNormal(g)
		End
		
		Private Method initCharacterSelectRes:Void()
			
			If (Self.charSelAni = Null Or Self.charSelFilAni = Null) Then
				Self.charSelAni = Animation.getInstanceFromQi("/animation/utl_res/character_select.dat")
				Self.charSelAniDrawer = Self.charSelAni[0].getDrawer(0, False, 0)
				Self.charSelCaseDrawer = Self.charSelAni[0].getDrawer(STATE_OPENING, False, 0)
				Self.charSelRoleDrawer = Self.charSelAni[0].getDrawer(STATE_START_GAME, False, 0)
				Self.charSelArrowDrawer = Self.charSelAni[0].getDrawer(STATE_QUIT, True, 0)
				Self.charSelTitleDrawer = Self.charSelAni[0].getDrawer(STATE_STAGE_SELECT, True, 0)
				Self.charSelFilAni = Animation.getInstanceFromQi("/animation/utl_res/character_select_filter.dat")
				Self.charSelFilAniDrawer = Self.charSelFilAni[0].getDrawer(0, False, 0)
			EndIf
			
			Self.charSelAniDrawer.setActionId(0)
			Self.charSelCaseDrawer.setActionId(STATE_OPENING)
			Self.charSelRoleDrawer.setActionId(STATE_START_GAME)
			Self.charSelArrowDrawer.setActionId(STATE_QUIT)
			Self.charSelTitleDrawer.setActionId(STATE_STAGE_SELECT)
			Self.charSelFilAniDrawer.setActionId(0)
			Self.charSelAniDrawer.restart()
			Self.charSelCaseDrawer.restart()
			Self.charSelRoleDrawer.restart()
			Self.charSelArrowDrawer.restart()
			Self.charSelTitleDrawer.restart()
			Self.charSelFilAniDrawer.restart()
			Self.character_sel_frame_cnt = 0
			Self.character_id = 0
			Self.character_move = False
			Self.character_arrow_display = True
			Self.character_outer = False
			Self.cursor = 0
			Self.character_sel_offset_x = 0
			Self.character_idchangeFlag = False
			Self.character_offset_state = 0
			Key.touchCharacterSelectModeInit()
			Self.returnCursor = 0
		End
		
		Private Method characterSelectLogic:Void()
			Self.character_sel_frame_cnt += 1
			
			If (Self.character_sel_frame_cnt = ZONE_NUM_OFFSET) Then
				Self.charSelAniDrawer.setActionId(0)
				Self.arrowPressState = 0
				SoundSystem.getInstance().playBgm(STATE_MOVING)
			EndIf
			
			If (Self.character_sel_frame_cnt = STATE_START_GAME) Then
				Self.charSelCaseDrawer.setLoop(False)
			EndIf
			
			If (Self.character_sel_frame_cnt = VISIBLE_OPTION_ITEMS_NUM) Then
				Self.charSelRoleDrawer.setLoop(False)
			EndIf
			
			If (Self.character_sel_frame_cnt = TOTAL_OPTION_ITEMS_NUM) Then
				Self.charSelFilAniDrawer.setLoop(False)
			EndIf
			
			If (Self.character_sel_frame_cnt = STATE_INTERRUPT) Then
				Self.charSelCaseDrawer.setActionId(STATE_GAMEOVER_RANKING)
				Self.charSelRoleDrawer.setActionId(STATE_OPTION_SOUND)
			EndIf
			
			If (Self.character_sel_frame_cnt <= STATE_INTERRUPT) Then
				Self.returnCursor = 0
			ElseIf (Not Self.character_move) Then
				If (Key.touchcharsel <> Null And Key.touchcharsElselect.Isin() And Key.touchcharsel.IsClick()) Then
					Self.cursor = STATE_MOVING
					Self.returnCursor = 0
				EndIf
				
				If (Key.touchcharsel <> Null And Key.touchcharselleftarrow.Isin() And Key.touchcharsel.IsClick()) Then
					Self.cursor = STATE_OPENING
					Self.returnCursor = 0
				EndIf
				
				If (Key.touchcharsel <> Null And Key.touchcharselrightarrow.Isin() And Key.touchcharsel.IsClick()) Then
					Self.cursor = STATE_START_GAME
					Self.returnCursor = 0
				EndIf
				
				If (Key.touchcharselreturn <> Null And Key.touchcharsel.IsClick() And Key.touchcharselreturn.Isin()) Then
					Self.returnCursor = ZONE_NUM_OFFSET
				EndIf
				
				If (Not Self.character_outer) Then
					If (Key.touchcharselleftarrow.IsButtonPress() And Self.cursor = STATE_OPENING) Then
						Self.arrowPressState = ZONE_NUM_OFFSET
						Self.character_offset_state = ZONE_NUM_OFFSET
						Key.touchcharselleftarrow.resetKeyState()
					EndIf
					
					If (Key.touchcharselrightarrow.IsButtonPress() And Self.cursor = STATE_START_GAME) Then
						Self.arrowPressState = STATE_MOVING
						Self.character_offset_state = STATE_MOVING
						Key.touchcharselrightarrow.resetKeyState()
					EndIf
					
					If (Key.slidesensorcharsel.isSliding()) Then
						Bool idChanged = False
						
						If (Self.arrowPressState = 0) Then
							If (Not Key.slidesensorcharsel.isSlide(Key.DIR_LEFT)) Then
								If (Key.slidesensorcharsel.isSlide(Key.DIR_RIGHT)) Then
									Select (Self.character_offset_state)
										Case 0
											Self.character_id -= ZONE_NUM_OFFSET
											Self.character_circleturnright = False
											idChanged = True
											Self.character_offset_state = STATE_MOVING
											break
										Case ZONE_NUM_OFFSET
											Self.character_id -= ZONE_NUM_OFFSET
											Self.character_circleturnright = False
											idChanged = True
											Self.character_offset_state = 0
											break
										Case STATE_MOVING
											Self.character_offset_state = 0
											break
										Default
											break
									End Select
								EndIf
							EndIf
							
							Select (Self.character_offset_state)
								Case 0
									Self.character_id += 1
									Self.character_circleturnright = True
									idChanged = True
									Self.character_offset_state = ZONE_NUM_OFFSET
									break
								Case ZONE_NUM_OFFSET
									Self.character_offset_state = 0
									break
								Case STATE_MOVING
									Self.character_id += 1
									Self.character_circleturnright = True
									idChanged = True
									Self.character_offset_state = 0
									break
							End Select
							Select (Self.character_offset_state)
								Case 0
									Self.character_sel_offset_x = Key.slidesensorcharsel.getOffsetX()
									break
								Case ZONE_NUM_OFFSET
									Self.character_sel_offset_x = Key.slidesensorcharsel.getOffsetX() + 64
									break
								Case STATE_MOVING
									Self.character_sel_offset_x = Key.slidesensorcharsel.getOffsetX() - 64
									break
							End Select
							
							If (idChanged) Then
								Self.character_id += PlayerObject.CHARACTER_LIST.Length
								Self.character_id Mod= PlayerObject.CHARACTER_LIST.Length
								Self.charSelRoleDrawer.setLoop(False)
								Self.charSelRoleDrawer.setActionId(Self.character_id + STATE_OPTION_SOUND)
								Self.character_idchangeFlag = True
								
								If (Self.character_id <> Self.character_preid) Then
									Self.character_reback = True
								Else
									Self.character_reback = False
								EndIf
							EndIf
						EndIf
						
					Else
						Self.character_offset_state = 0
						
						If (Self.arrowPressState = 0) Then
							Self.character_sel_offset_x = MyAPI.calNextPosition((double) Self.character_sel_offset_x, 0.0d, ZONE_NUM_OFFSET, STATE_MOVING)
						Else
							
							If (Self.arrowPressState = ZONE_NUM_OFFSET) Then
								Self.character_sel_offset_x = MyAPI.calNextPosition((double) Self.character_sel_offset_x, 128.0d, ZONE_NUM_OFFSET, STATE_MOVING)
								
								If (Self.character_sel_offset_x = TIME_ATTACK_WIDTH) Then
									Self.character_id -= ZONE_NUM_OFFSET
									Self.character_circleturnright = False
									Self.character_id += PlayerObject.CHARACTER_LIST.Length
									Self.character_id Mod= PlayerObject.CHARACTER_LIST.Length
									Self.charSelRoleDrawer.setLoop(False)
									Self.charSelRoleDrawer.setActionId(Self.character_id + STATE_OPTION_SOUND)
									Self.character_idchangeFlag = True
									Self.arrowPressState = 0
									Self.character_reback = True
									Self.character_sel_offset_x = 0
								EndIf
							EndIf
							
							If (Self.arrowPressState = STATE_MOVING) Then
								Self.character_sel_offset_x = MyAPI.calNextPosition((double) Self.character_sel_offset_x, -128.0d, ZONE_NUM_OFFSET, STATE_MOVING)
								
								If (Self.character_sel_offset_x = Def.TOUCH_HELP_LEFT_X) Then
									Self.character_id += 1
									Self.character_circleturnright = True
									Self.character_id += PlayerObject.CHARACTER_LIST.Length
									Self.character_id Mod= PlayerObject.CHARACTER_LIST.Length
									Self.charSelRoleDrawer.setLoop(False)
									Self.charSelRoleDrawer.setActionId(Self.character_id + STATE_OPTION_SOUND)
									Self.character_idchangeFlag = True
									Self.arrowPressState = 0
									Self.character_reback = True
									Self.character_sel_offset_x = 0
								EndIf
							EndIf
						EndIf
						
						If (Self.character_idchangeFlag And Self.character_sel_offset_x = 0) Then
							If (Self.character_reback) Then
								Int i
								Self.character_move = True
								AnimationDrawer animationDrawer = Self.charSelAniDrawer
								
								If (Self.character_circleturnright) Then
									i = ZONE_NUM_OFFSET
								Else
									i = STATE_MOVING
								EndIf
								
								animationDrawer.setActionId(i)
								Self.charSelAniDrawer.restart()
							EndIf
							
							Self.charSelFilAniDrawer.setActionId(Self.character_id + ZONE_NUM_OFFSET)
							Self.character_idchangeFlag = False
							Key.touchcharsElselect.reset()
							SoundSystem.getInstance().playSe(0)
						EndIf
						
						If (Not Self.character_idchangeFlag And Self.character_sel_offset_x < STATE_RANKING And Self.character_sel_offset_x > INTERGRADE_RECORD_STAGE_NAME_SPEED And Key.touchcharsElselect.IsButtonPress() And Self.cursor = STATE_MOVING) Then
							SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
							Self.charSelTitleDrawer.setActionId(STATE_OPTION_DIFF)
							Self.character_arrow_display = False
							Self.charSelRoleDrawer.setActionId(Self.character_id + VISIBLE_OPTION_ITEMS_NUM)
							Self.character_outer = True
							Self.character_sel_offset_x = 0
						EndIf
						
						Self.character_preid = Self.character_id
					EndIf
					
					If (Self.character_sel_offset_x = 0 And ((Key.press(Key.B_BACK) Or (Key.touchcharselreturn.IsButtonPress() And Self.returnCursor = ZONE_NUM_OFFSET)) And State.fadeChangeOver())) Then
						changeStateWithFade(Self.preCharaterSelectState)
						Select (Self.preCharaterSelectState)
							Case STATE_MOVING
								Self.isTitleBGMPlay = False
								Key.touchMainMenuInit2()
								initTitleRes2()
								SoundSystem.getInstance().stopBgm(False)
								break
							Case STATE_PRO_RACE_MODE
								Key.touchProRaceModeInit()
								initTimeStageRes()
								break
						End Select
						SoundSystem.getInstance().playSe(STATE_MOVING)
					EndIf
				EndIf
				
				If (Self.character_outer And Self.charSelRoleDrawer.checkEnd()) Then
					PlayerObject.setCharacter(Self.character_id)
					
					If (StageManager.getStageID() = 0 And StageManager.getOpenedStageId() = 0 And GameObject.stageModeState = 0) Then
						StageManager.setStageID(0)
						StageManager.setStartStageID(0)
						State.setState(ZONE_NUM_OFFSET)
						PlayerObject.resetGameParam()
						StageManager.saveStageRecord()
					Else
						changeStateWithFade(STATE_STAGE_SELECT)
						preStageSelectState = STATE_CHARACTER_SELECT
						menuInit(Self.STAGE_TOTAL_NUM)
						initStageSelectRes()
					EndIf
					
					Key.touchCharacterSelectModeClose()
				EndIf
			EndIf
			
		End
		
		Private Method drawCharacterSelect:Void(g:MFGraphics)
			g.setColor(MapManager.END_COLOR)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			Self.charSelAniDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
			
			If (Self.character_sel_frame_cnt > STATE_START_GAME And Self.character_sel_frame_cnt <= STATE_INTERRUPT) Then
				Self.charSelCaseDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
				
				If (Self.character_sel_frame_cnt = STATE_INTERRUPT) Then
					Self.charSelCaseDrawer.setLoop(True)
				EndIf
			EndIf
			
			If (Self.character_sel_frame_cnt > VISIBLE_OPTION_ITEMS_NUM) Then
				Self.charSelRoleDrawer.draw(g, (SCREEN_WIDTH Shr 1) + Self.character_sel_offset_x, SCREEN_HEIGHT Shr 1)
			EndIf
			
			If (Self.character_sel_frame_cnt > STATE_INTERRUPT) Then
				If (Self.character_arrow_display) Then
					Self.charSelArrowDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
				EndIf
				
				Self.charSelTitleDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
				Self.charSelCaseDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
				
				If (Self.character_move And Self.charSelCaseDrawer.checkEnd()) Then
					Self.charSelCaseDrawer.setLoop(False)
					Self.charSelCaseDrawer.setActionId((Self.character_id * STATE_OPENING) + STATE_RESET_RECORD_ASK)
					Self.character_move = False
				EndIf
			EndIf
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			Else
				
				If (Key.touchcharselreturn <> Null) Then
					Int i
					AnimationDrawer animationDrawer = muiAniDrawer
					
					If (Key.touchcharselreturn.Isin()) Then
						i = STATE_GOTO_GAME
					Else
						i = 0
					EndIf
					
					animationDrawer.setActionId(i + 61)
				EndIf
				
				muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
			EndIf
			
			State.drawFade(g)
		End
		
		Private Method initTimeStageRes:Void()
			
			If (Self.timeAttAni = Null) Then
				Self.timeAttAni = Animation.getInstanceFromQi("/animation/utl_res/time_attack.dat")
				Self.timeAttAniDrawer = Self.timeAttAni[0].getDrawer(0, True, 0)
			EndIf
			
			Key.touchProRaceModeInit()
			SoundSystem.getInstance().playBgm(STATE_MOVING)
			Self.isRaceModeItemsSelected = False
		End
		
		Private Method proRaceModeLogic:Void()
			
			If (State.fadeChangeOver()) Then
				If (Key.touchproracemodestart.Isin() And Key.touchproracemode.IsClick()) Then
					Self.cursor = 0
				ElseIf (Key.touchproracemoderecord.Isin() And Key.touchproracemode.IsClick()) Then
					Self.cursor = ZONE_NUM_OFFSET
				ElseIf (Key.touchproracemodereturn.Isin() And Key.touchproracemode.IsClick()) Then
					Self.cursor = STATE_MOVING
				EndIf
				
				If (Key.touchproracemodestart.IsButtonPress() And Self.cursor = 0 And Not Self.isRaceModeItemsSelected) Then
					Self.isRaceModeItemsSelected = True
					Self.stage_sel_key = ZONE_NUM_OFFSET
					changeStateWithFade(STATE_CHARACTER_SELECT)
					Self.preCharaterSelectState = STATE_PRO_RACE_MODE
					initCharacterSelectRes()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchproracemoderecord.IsButtonPress() And Self.cursor = ZONE_NUM_OFFSET And Not Self.isRaceModeItemsSelected) Then
					Self.isRaceModeItemsSelected = True
					Self.stage_sel_key = 0
					changeStateWithFade(STATE_STAGE_SELECT)
					preStageSelectState = STATE_PRO_RACE_MODE
					initStageSelectRes()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchproracemodereturn.IsButtonPress() And Self.cursor = STATE_MOVING)) And State.fadeChangeOver()) Then
					changeStateWithFade(STATE_MOVING)
					Self.isTitleBGMPlay = False
					Key.touchMainMenuInit2()
					initTitleRes2()
					Self.returnCursor = 0
					SoundSystem.getInstance().playSe(STATE_MOVING)
					SoundSystem.getInstance().stopBgm(False)
					menuInit(Self.multiMainItems)
					Return
				EndIf
				
				Return
			EndIf
			
			Key.touchproracemodestart.reset()
			Key.touchproracemoderecord.reset()
		End
		
		Private Method drawProTimeAttack:Void(g:MFGraphics)
			g.setColor(MapManager.END_COLOR)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			Self.timeAttAniDrawer.setActionId(0)
			Self.timeAttAniDrawer.draw(g, 0, 0)
			Self.timeAttAniDrawer.setActionId(ZONE_NUM_OFFSET)
			Self.timeAttAniDrawer.draw(g, SCREEN_WIDTH, SCREEN_HEIGHT Shr 1)
			Int x
			
			If ((Key.touchproracemodestart.Isin() Or Self.isRaceModeItemsSelected) And Self.cursor = 0) Then
				Self.timeAttackOffsetX += TIME_ATTACK_SPEED_X
				Self.timeAttackOffsetX Mod= TIME_ATTACK_WIDTH
				Self.timeAttAniDrawer.setActionId(STATE_MOVING)
				For (x = Self.timeAttackOffsetX; x < (SCREEN_WIDTH * STATE_OPENING) / STATE_MOVING; x += TIME_ATTACK_WIDTH)
					Self.timeAttAniDrawer.draw(g, ((SCREEN_WIDTH Shr 1) + x) - STATE_RANKING, SCREEN_HEIGHT Shr 1)
				Next
				Self.timeAttAniDrawer.draw(g, ((Self.timeAttackOffsetX - TIME_ATTACK_WIDTH) + (SCREEN_WIDTH Shr 1)) - STATE_RANKING, SCREEN_HEIGHT Shr 1)
			ElseIf ((Key.touchproracemoderecord.Isin() Or Self.isRaceModeItemsSelected) And Self.cursor = ZONE_NUM_OFFSET) Then
				Self.timeAttackOffsetX += TIME_ATTACK_SPEED_X
				Self.timeAttackOffsetX Mod= TIME_ATTACK_WIDTH
				Self.timeAttAniDrawer.setActionId(STATE_OPENING)
				For (x = Self.timeAttackOffsetX; x < (SCREEN_WIDTH * STATE_OPENING) / STATE_MOVING; x += TIME_ATTACK_WIDTH)
					Self.timeAttAniDrawer.draw(g, ((SCREEN_WIDTH Shr 1) + x) - STATE_RANKING, SCREEN_HEIGHT Shr 1)
				Next
				Self.timeAttAniDrawer.draw(g, ((Self.timeAttackOffsetX - TIME_ATTACK_WIDTH) + (SCREEN_WIDTH Shr 1)) - STATE_RANKING, SCREEN_HEIGHT Shr 1)
			Else
				Self.timeAttackOffsetX = 0
			EndIf
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			Int i
			AnimationDrawer animationDrawer = muiAniDrawer
			
			If (Key.touchproracemodereturn.Isin()) Then
				i = STATE_GOTO_GAME
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Private Method initStageSelectRes:Void()
			
			If (Self.stageSelAni = Null) Then
				Self.stageSelAni = Animation.getInstanceFromQi("/animation/utl_res/stage_select.dat")
				Self.stageSelAniDrawer = Self.stageSelAni[0].getDrawer(0, True, 0)
				Self.stageSelArrowUpDrawer = Self.stageSelAni[0].getDrawer(MAIN_MENU_CENTER_X, True, 0)
				Self.stageSelArrowDownDrawer = Self.stageSelAni[0].getDrawer(52, True, 0)
			EndIf
			
			If (Self.stageSelEmeraldDrawer = Null) Then
				Self.stageSelEmeraldDrawer = New Animation("/animation/stage_select_emerald").getDrawer(0, False, 0)
			EndIf
			
			Key.touchStageSelectModeInit()
			Self.stageItemNumForShow = STATE_RACE_MODE
			Self.stageDrawEndY = (Self.stageDrawStartY + (Self.stageItemNumForShow * ITEM_SPACE)) - (ITEM_SPACE Shr 1)
			Self.stageStartIndex = 0
			Self.stageDrawOffsetY = 0
			Self.offsetY = New Int[Self.STAGE_TOTAL_NUM]
			Self.vY = New Int[Self.STAGE_TOTAL_NUM]
			Self.offsetY[0] = SCREEN_HEIGHT Shr 1
			Self.vY[0] = STATE_RACE_MODE
			For (Int i = ZONE_NUM_OFFSET; i < Self.STAGE_TOTAL_NUM; i += 1)
				Self.offsetY[i] = Self.offsetY[i - 1] * 2
				Self.vY[i] = Self.vY[i - 1] * 2
			Next
			Self.stage_select_state = 0
			Self.stageSelectReturnFlag = False
			Self.optionMenuCursor = ELEMENT_OFFSET
		End
		
		Private Method stageSelectLogic:Void()
			Int i
			
			If (Self.stage_select_state = 0) Then
				Key.touchstageselectreturn.resetKeyState()
				Key.touchCharacterSelectModeClose()
				Key.setKeyFunction(True)
				
				If (Self.offsetY[0] = (SCREEN_HEIGHT Shr 1)) Then
					SoundSystem.getInstance().playBgm(STATE_OPENING)
				EndIf
				
				If (Self.offsetY[0] - Self.vY[0] <= 0) Then
					For (i = 0; i < Self.STAGE_TOTAL_NUM; i += 1)
						Self.offsetY[i] = 0
					Next
					Self.stage_select_state = ZONE_NUM_OFFSET
				Else
					For (i = 0; i < Self.STAGE_TOTAL_NUM; i += 1)
						Int[] iArr = Self.offsetY
						iArr[i] = iArr[i] - Self.vY[i]
					Next
				EndIf
				
				Self.isStageSelectChange = False
				Self.stageselectslide_getprey = ELEMENT_OFFSET
				Self.stageselectslide_gety = ELEMENT_OFFSET
				Self.stageselectslide_y = 0
				Self.stageDrawOffsetBottomY = (-(StageManager.getMaxStageID() - STATE_GOTO_GAME)) * STATE_PRO_RACE_MODE
				Self.stageYDirect = 0
				Self.isSelectable = False
				Self.stageSelectReturnFlag = False
				Self.stage_select_press_state = 0
				Self.stage_select_arrow_state = 0
			ElseIf (Self.stage_select_state = ZONE_NUM_OFFSET) Then
				If (Self.stageStartIndex > 0) Then
					Self.stageSelectUpArrowAvailable = True
					Self.isDrawUpArrow = True
				Else
					Self.stageSelectUpArrowAvailable = False
					Self.isDrawUpArrow = False
				EndIf
				
				If (Self.stageStartIndex < StageManager.getMaxStageID() - STATE_GOTO_GAME) Then
					Self.stageSelectDownArrowAvailable = True
					Self.isDrawDownArrow = True
				Else
					Self.stageSelectDownArrowAvailable = False
					Self.isDrawDownArrow = False
				EndIf
				
				If (Key.touchstageselectuparrow.Isin() And Self.stageSelectUpArrowAvailable) Then
					Self.stageSelectArrowDriveOffsetY = STATE_EXIT
					Self.stageSelectArrowMoveable = True
				EndIf
				
				If (Key.touchstageselectdownarrow.Isin() And Self.stageSelectDownArrowAvailable) Then
					Self.stageSelectArrowDriveOffsetY = N5500_OFFSET_3
					Self.stageSelectArrowMoveable = True
				EndIf
				
				If (Self.stageSelectArrowMoveable) Then
					Self.stageSelectArrowDriveOffsetY /= STATE_MOVING
					
					If (Self.stageSelectArrowDriveOffsetY > 0 And Self.stageSelectArrowDriveOffsetY < STATE_MOVING) Then
						Self.stageSelectArrowDriveOffsetY = STATE_MOVING
					EndIf
					
					If (Self.stageSelectArrowDriveOffsetY < 0 And Self.stageSelectArrowDriveOffsetY > TIME_ATTACK_SPEED_X) Then
						Self.stageSelectArrowDriveOffsetY = TIME_ATTACK_SPEED_X
					EndIf
					
					Self.stageSelectArrowDriveY += Self.stageSelectArrowDriveOffsetY
					
					If (Self.stageSelectArrowDriveOffsetY > 0) Then
						If (Self.stageSelectArrowDriveY >= STATE_PRO_RACE_MODE) Then
							Self.stageSelectArrowDriveY = STATE_PRO_RACE_MODE
							Self.stageDrawOffsetY += Self.stageSelectArrowDriveY
							Self.stageSelectArrowDriveY = 0
							Self.stageSelectArrowMoveable = False
						EndIf
						
					ElseIf (Self.stageSelectArrowDriveOffsetY < 0 And Self.stageSelectArrowDriveY <= -24) Then
						Self.stageSelectArrowDriveY = -24
						Self.stageDrawOffsetY += Self.stageSelectArrowDriveY
						Self.stageSelectArrowDriveY = 0
						Self.stageSelectArrowMoveable = False
					EndIf
				EndIf
				
				Self.stageselectslide_gety = Key.slidesensorstagesel.getPointerY()
				
				If (Self.stageselectslide_gety = ELEMENT_OFFSET And Self.stageselectslide_getprey = ELEMENT_OFFSET) Then
					Self.stageselectslide_y = 0
					Self.stageselectslidefirsty = 0
				ElseIf (Self.stageselectslide_gety <> ELEMENT_OFFSET And Self.stageselectslide_getprey = ELEMENT_OFFSET) Then
					Self.stageselectslidefirsty = Self.stageselectslide_gety
					Self.firstStageSelectSlidePointY = Self.stageselectslidefirsty
					Self.stageSelectSlideFrame = 0
				ElseIf (Self.stageselectslide_gety <> ELEMENT_OFFSET And Self.stageselectslide_getprey <> ELEMENT_OFFSET) Then
					Self.stageselectslide_y = Self.stageselectslide_gety - Self.stageselectslidefirsty
				ElseIf (Self.stageselectslide_gety = ELEMENT_OFFSET And Self.stageselectslide_getprey <> ELEMENT_OFFSET) Then
					Self.stageDrawOffsetTmpY1 = Self.stageselectslide_y + Self.stageDrawOffsetY
				EndIf
				
				If (Key.slidesensorstagesel.isSliding()) Then
					Self.currentStageSelectSlidePointY = Self.stageselectslide_y
					
					If (Self.currentStageSelectSlidePointY - Self.preStageSelectSlidePointY >= STATE_MOVING Or Self.currentStageSelectSlidePointY - Self.preStageSelectSlidePointY <= TIME_ATTACK_SPEED_X) Then
						Self.stageSelectSlideFrame += 1
					Else
						Self.stageSelectSlideFrame = 0
						Self.firstStageSelectSlidePointY = Self.currentStageSelectSlidePointY
					EndIf
					
					Self.preStageSelectSlidePointY = Self.currentStageSelectSlidePointY
					
					If (Self.stageSelectSlideFrame = 0) Then
						Self.gestureSlideSpeed = 0
					Else
						Self.gestureSlideSpeed = ((Self.currentStageSelectSlidePointY - Self.firstStageSelectSlidePointY) / Self.stageSelectSlideFrame) * 2
					EndIf
					
				ElseIf (Self.stageYDirect = 0) Then
					If (Self.gestureSlideSpeed > 0) Then
						Self.gestureSlideSpeed -= STATE_OPENING
						
						If (Self.gestureSlideSpeed < STATE_MOVING) Then
							Self.gestureSlideSpeed = 0
						EndIf
					EndIf
					
					If (Self.gestureSlideSpeed < 0) Then
						Self.gestureSlideSpeed -= -3
						
						If (Self.gestureSlideSpeed > TIME_ATTACK_SPEED_X) Then
							Self.gestureSlideSpeed = 0
						EndIf
					EndIf
					
					Self.stageDrawOffsetY += Self.gestureSlideSpeed
					
					If (Self.stageDrawOffsetY + Self.gestureSlideSpeed > 0) Then
						Self.stageDrawOffsetY = 0
						Self.gestureSlideSpeed = 0
					ElseIf (Self.stageDrawOffsetY + Self.gestureSlideSpeed < Self.stageDrawOffsetBottomY) Then
						Self.stageDrawOffsetY = Self.stageDrawOffsetBottomY
						Self.gestureSlideSpeed = 0
					EndIf
				EndIf
				
				For (i = 0; i < Key.touchstageselectitem.Length; i += 1)
					Key.touchstageselectitem[i].setStartY((((Self.stageDrawStartY + ((i + ZONE_NUM_OFFSET) * STATE_PRO_RACE_MODE)) + Self.offsetY[i]) + Self.stageDrawOffsetY) + Self.stageselectslide_y)
				Next
				
				If (Self.isSelectable And Self.stageYDirect = 0) Then
					i = 0
					While (i < Key.touchstageselectitem.Length) {
						
						If (Key.touchstageselectitem[i].IsButtonPress() And Self.optionMenuCursor = i And State.fadeChangeOver() And Not Key.touchstageselect.Isin()) Then
							Select (Self.stage_sel_key)
								Case 0
									changeStateWithFade(STATE_CHARACTER_RECORD)
									Self.stage_characterRecord_ID = Self.optionMenuCursor
									initRecordRes()
									break
								Case ZONE_NUM_OFFSET
									changeStateWithFade(STATE_INTERGRADE_RECORD)
									Self.stage_characterRecord_ID = Self.optionMenuCursor
									initIntergradeRecordRes()
									break
								Case STATE_MOVING
									StageManager.setStageID(Self.optionMenuCursor)
									StageManager.setStartStageID(Self.optionMenuCursor)
									State.setState(ZONE_NUM_OFFSET)
									break
							End Select
							SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
						Else
							i += 1
						EndIf
						
					}
				EndIf
				
				If (Key.slidesensorstagesel.isSliding()) Then
					Self.stage_select_press_state = ZONE_NUM_OFFSET
					
					If (Self.stageselectslide_y > STATE_START_GAME Or Self.stageselectslide_y < -4) Then
						Self.isStageSelectChange = True
						Self.isSelectable = False
						releaseAllStageSelectItemsTouchKey()
						Self.optionMenuCursor = ELEMENT_OFFSET
						Self.stageSelectReturnFlag = False
					Else
						Self.isSelectable = True
					EndIf
					
					If (Key.slidesensorstagesel.isSlide(Key.DIR_UP)) Then
						Self.isStageSelectChange = True
						Self.isSelectable = False
					ElseIf (Key.slidesensorstagesel.isSlide(Key.DIR_DOWN)) Then
						Self.isStageSelectChange = True
						Self.isSelectable = False
					EndIf
					
				Else
					
					If (Self.isStageSelectChange And Self.stageselectslide_y = 0) Then
						Self.stageDrawOffsetY = Self.stageDrawOffsetTmpY1
						Self.isStageSelectChange = False
						Self.stageYDirect = 0
					EndIf
					
					If (Not Self.isStageSelectChange) Then
						Int speed
						
						If (Self.stageDrawOffsetY > 0) Then
							Self.stageYDirect = ZONE_NUM_OFFSET
							speed = (-Self.stageDrawOffsetY) Shr 1
							
							If (speed > TIME_ATTACK_SPEED_X) Then
								speed = TIME_ATTACK_SPEED_X
							EndIf
							
							If (Self.stageDrawOffsetY + speed <= 0) Then
								Self.stageDrawOffsetY = 0
								Self.stage_select_press_state = 0
								Self.stageYDirect = 0
							Else
								Self.stageDrawOffsetY += speed
							EndIf
							
						ElseIf (Self.stageDrawOffsetY < Self.stageDrawOffsetBottomY) Then
							Self.stageYDirect = STATE_MOVING
							speed = (Self.stageDrawOffsetBottomY - Self.stageDrawOffsetY) Shr 1
							
							If (speed < STATE_MOVING) Then
								speed = STATE_MOVING
							EndIf
							
							If (Self.stageDrawOffsetY + speed >= Self.stageDrawOffsetBottomY) Then
								Self.stageDrawOffsetY = Self.stageDrawOffsetBottomY
								Self.stage_select_press_state = 0
								Self.stageYDirect = 0
							Else
								Self.stageDrawOffsetY += speed
							EndIf
						EndIf
					EndIf
				EndIf
				
				Self.stageStartIndex = (-(Self.stageDrawOffsetY + Self.stageselectslide_y)) / STATE_PRO_RACE_MODE
				
				If (Self.stageYDirect = 0) Then
					If (Key.touchstageselectreturn.Isin() And Key.touchstageselect.IsClick()) Then
						Self.returnCursor = ZONE_NUM_OFFSET
					EndIf
					
					If (Self.isSelectable) Then
						i = 0
						While (i < Key.touchstageselectitem.Length) {
							
							If (Key.touchstageselectitem[i].Isin() And Key.touchstageselect.IsClick() And i <= StageManager.getOpenedStageId()) Then
								Self.optionMenuCursor = i
								Self.returnCursor = 0
							Else
								i += 1
							EndIf
							
						}
					EndIf
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchstageselectreturn.IsButtonPress() And Self.returnCursor = ZONE_NUM_OFFSET)) And State.fadeChangeOver()) Then
					SoundSystem.getInstance().stopBgm(False)
					changeStateWithFade(preStageSelectState)
					Select (preStageSelectState)
						Case STATE_MOVING
							Self.isTitleBGMPlay = False
							Key.touchMainMenuInit2()
							break
						Case STATE_CHARACTER_SELECT
							Key.touchCharacterSelectModeInit()
							initCharacterSelectRes()
							break
						Case STATE_PRO_RACE_MODE
							Key.touchProRaceModeInit()
							initTimeStageRes()
							break
					End Select
					SoundSystem.getInstance().playSe(STATE_MOVING)
				EndIf
				
				Self.stageselectslide_getprey = Self.stageselectslide_gety
			EndIf
			
		End
		
		Private Method releaseAllStageSelectItemsTouchKey:Void()
			For (Int i = 0; i < Key.touchstageselectitem.Length; i += 1)
				Key.touchstageselectitem[i].resetKeyState()
			Next
		End
		
		Private Method drawStageSelect:Void(g:MFGraphics)
			g.setColor(MapManager.END_COLOR)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			If (Self.stageItemNumForShow <> StageManager.STAGE_NUM) Then
				MyAPI.setClip(g, 0, Self.stageDrawStartY - STATE_EXIT, SCREEN_WIDTH, INTERGRADE_RECORD_STAGE_NAME_WIDTH)
			EndIf
			
			Int i = 0
			While (i < StageManager.STAGE_NAME.Length) {
				
				If (i = Self.optionMenuCursor And Self.stage_select_state = ZONE_NUM_OFFSET And Self.isSelectable And Self.stageYDirect = 0) Then
					drawStageName(g, ZONE_NUM_OFFSET, i, (Self.stageDrawOffsetY + Self.stageselectslide_y) + Self.stageSelectArrowDriveY)
					drawStageName(g, STATE_OPTION_VIBRATION, i, (Self.stageDrawOffsetY + Self.stageselectslide_y) + Self.stageSelectArrowDriveY)
				ElseIf (i <= StageManager.getOpenedStageId()) Then
					drawStageName(g, STATE_GAMEOVER_RANKING, i, (Self.stageDrawOffsetY + Self.stageselectslide_y) + Self.stageSelectArrowDriveY)
				ElseIf ((GameObject.stageModeState = 0 And i < STATE_QUIT) Or (GameObject.stageModeState = ZONE_NUM_OFFSET And i < STATE_EXIT)) Then
					drawStageName(g, ZONE_NUM_OFFSET, i, (Self.stageDrawOffsetY + Self.stageselectslide_y) + Self.stageSelectArrowDriveY)
				EndIf
				
				i += 1
			}
			i = 0
			While (i < (StageManager.STAGE_NAME.Length Shr 1) - 1 And i * 2 <= StageManager.getOpenedStageId()) {
				Self.stageSelAniDrawer.draw(g, i + STATE_SCORE_UPDATE_ENSURE, SCREEN_WIDTH, Self.stageSelectArrowDriveY + ((((Self.stageDrawStartY + Self.offsetY[(i * 2) + ZONE_NUM_OFFSET]) + ((i + ZONE_NUM_OFFSET) * CHARACTER_RECORD_BG_HEIGHT)) + Self.stageDrawOffsetY) + Self.stageselectslide_y), False, 0)
				i += 1
			}
			Int maxUnlockStage = ((StageManager.getOpenedStageId() / STATE_MOVING) * 2) + ZONE_NUM_OFFSET > STATE_EXIT ? STATE_EXIT : ((StageManager.getOpenedStageId() / STATE_MOVING) * 2) + ZONE_NUM_OFFSET
			
			If (maxUnlockStage = STATE_MORE_GAME) Then
				maxUnlockStage = STATE_RANKING
			EndIf
			
			If (GameObject.stageModeState = 0) Then
				For (i = 0; i < maxUnlockStage; i += 1)
					drawStageEmerald(g, i)
				Next
			EndIf
			
			If (STATE_EXIT <= StageManager.getOpenedStageId()) Then
				Self.stageSelAniDrawer.draw(g, ACTION_NUM_OFFSET, SCREEN_WIDTH, Self.stageSelectArrowDriveY + (((((Self.stageDrawStartY + Self.offsetY[STATE_EXIT]) + 336) - STATE_PRO_RACE_MODE) + Self.stageDrawOffsetY) + Self.stageselectslide_y), False, 0)
			EndIf
			
			If (STATE_QUIT <= StageManager.getOpenedStageId()) Then
				Self.stageSelAniDrawer.draw(g, 50, SCREEN_WIDTH, Self.stageSelectArrowDriveY + ((((Self.stageDrawStartY + Self.offsetY[STATE_QUIT]) + 336) + Self.stageDrawOffsetY) + Self.stageselectslide_y), False, 0)
			EndIf
			
			Self.stageSelAniDrawer.setActionId(0)
			Self.stageSelAniDrawer.draw(g, 0, 0)
			
			If (Self.isDrawUpArrow) Then
				Self.stageSelArrowUpDrawer.draw(g, STATE_SCORE_UPDATED, (SCREEN_HEIGHT Shr 1) - ACTION_NUM_OFFSET)
			EndIf
			
			If (Self.isDrawDownArrow) Then
				Self.stageSelArrowDownDrawer.draw(g, STATE_SCORE_UPDATED, (SCREEN_HEIGHT Shr 1) + ACTION_NUM_OFFSET)
			EndIf
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			Int i2
			AnimationDrawer animationDrawer = muiAniDrawer
			
			If (Key.touchstageselectreturn.Isin()) Then
				i2 = STATE_GOTO_GAME
			Else
				i2 = 0
			EndIf
			
			animationDrawer.setActionId(i2 + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Private Method drawStageName:Void(g:MFGraphics, preid:Int, stageId:Int, mOffsetY:Int)
			Self.stageSelAniDrawer.draw(g, preid + stageId, SCREEN_WIDTH Shr 1, ((Self.stageDrawStartY + ((stageId + ZONE_NUM_OFFSET) * STATE_PRO_RACE_MODE)) + Self.offsetY[stageId]) + mOffsetY, False, 0)
		End
		
		Private Method drawStageEmerald:Void(g:MFGraphics, stageId:Int)
			
			If (stageId <> STATE_MORE_GAME) Then
				Select (SpecialStageState.emeraldState(stageId))
					Case ZONE_NUM_OFFSET
						Self.stageSelEmeraldDrawer.draw(g, stageId < STATE_MORE_GAME ? (stageId Shr 1) + 2 : ((stageId Shr 1) + 2) + 2, SCREEN_WIDTH, Self.stageSelectArrowDriveY + ((((Self.stageDrawStartY + Self.offsetY[((stageId Shr 1) * 2) + ZONE_NUM_OFFSET]) + (((stageId Shr 1) + ZONE_NUM_OFFSET) * CHARACTER_RECORD_BG_HEIGHT)) + Self.stageDrawOffsetY) + Self.stageselectslide_y), False, 0)
					Case STATE_MOVING
						Self.stageSelEmeraldDrawer.draw(g, 0, SCREEN_WIDTH, ((((Self.stageDrawStartY + Self.offsetY[((stageId Shr 1) * 2) + ZONE_NUM_OFFSET]) + (((stageId Shr 1) + ZONE_NUM_OFFSET) * CHARACTER_RECORD_BG_HEIGHT)) + Self.stageDrawOffsetY) + Self.stageselectslide_y) + Self.stageSelectArrowDriveY, False, 0)
					Default
				End Select
			ElseIf (SpecialStageState.emeraldState(stageId - 1) = 0) Then
				Select (SpecialStageState.emeraldState(stageId))
					Case ZONE_NUM_OFFSET
						Self.stageSelEmeraldDrawer.draw(g, STATE_RACE_MODE, SCREEN_WIDTH, Self.stageSelectArrowDriveY + ((((Self.stageDrawStartY + Self.offsetY[((stageId Shr 1) * 2) + ZONE_NUM_OFFSET]) + (((stageId Shr 1) + ZONE_NUM_OFFSET) * CHARACTER_RECORD_BG_HEIGHT)) + Self.stageDrawOffsetY) + Self.stageselectslide_y), False, 0)
					Case STATE_MOVING
						Self.stageSelEmeraldDrawer.draw(g, 0, SCREEN_WIDTH, ((((Self.stageDrawStartY + Self.offsetY[((stageId Shr 1) * 2) + ZONE_NUM_OFFSET]) + (((stageId Shr 1) + ZONE_NUM_OFFSET) * CHARACTER_RECORD_BG_HEIGHT)) + Self.stageDrawOffsetY) + Self.stageselectslide_y) + Self.stageSelectArrowDriveY, False, 0)
					Default
				End Select
			Else
				Select (SpecialStageState.emeraldState(stageId))
					Case ZONE_NUM_OFFSET
						Self.stageSelEmeraldDrawer.draw(g, STATE_MORE_GAME, SCREEN_WIDTH, Self.stageSelectArrowDriveY + ((((Self.stageDrawStartY + Self.offsetY[((stageId Shr 1) * 2) + ZONE_NUM_OFFSET]) + (((stageId Shr 1) + ZONE_NUM_OFFSET) * CHARACTER_RECORD_BG_HEIGHT)) + Self.stageDrawOffsetY) + Self.stageselectslide_y), False, 0)
					Case STATE_MOVING
						Self.stageSelEmeraldDrawer.draw(g, ZONE_NUM_OFFSET, SCREEN_WIDTH, ((((Self.stageDrawStartY + Self.offsetY[((stageId Shr 1) * 2) + ZONE_NUM_OFFSET]) + (((stageId Shr 1) + ZONE_NUM_OFFSET) * CHARACTER_RECORD_BG_HEIGHT)) + Self.stageDrawOffsetY) + Self.stageselectslide_y) + Self.stageSelectArrowDriveY, False, 0)
					Default
				End Select
			EndIf
			
		End
		
		Private Method initRecordRes:Void()
			
			If (Self.recordAni = Null) Then
				Self.recordAni = Animation.getInstanceFromQi("/animation/utl_res/record.dat")
				Self.recordAniDrawer = Self.recordAni[0].getDrawer(0, True, 0)
			EndIf
			
			Key.touchCharacterRecordInit()
			Self.characterRecordID = 0
			Self.characterRecordDisFlag = False
			Self.characterRecordScoreUpdateIconY = -32
			Self.characterRecordScoreUpdateCursor = 0
		End
		
		Private Method characterRecordLogic:Void()
			
			If (Not Self.characterRecordDisFlag) Then
				SoundSystem.getInstance().playBgm(STATE_START_GAME)
				Self.characterRecordDisFlag = True
			EndIf
			
			If (Key.slidesensorcharacterrecord.isSliding()) Then
				If (Key.slidesensorcharacterrecord.isSlide(Key.DIR_LEFT)) Then
					Self.characterRecordID -= ZONE_NUM_OFFSET
					Self.characterRecordID += PlayerObject.CHARACTER_LIST.Length
					Self.characterRecordID Mod= PlayerObject.CHARACTER_LIST.Length
					SoundSystem.getInstance().playSe(STATE_OPENING)
				ElseIf (Key.slidesensorcharacterrecord.isSlide(Key.DIR_RIGHT)) Then
					Self.characterRecordID += 1
					Self.characterRecordID += PlayerObject.CHARACTER_LIST.Length
					Self.characterRecordID Mod= PlayerObject.CHARACTER_LIST.Length
					SoundSystem.getInstance().playSe(STATE_OPENING)
				EndIf
			EndIf
			
			If (Key.touchintergraderecordleftarrow.IsButtonPress() And State.fadeChangeOver()) Then
				Self.characterRecordID -= ZONE_NUM_OFFSET
				Self.characterRecordID += PlayerObject.CHARACTER_LIST.Length
				Self.characterRecordID Mod= PlayerObject.CHARACTER_LIST.Length
				SoundSystem.getInstance().playSe(STATE_OPENING)
			ElseIf (Key.touchintergraderecordrightarrow.IsButtonPress() And State.fadeChangeOver()) Then
				Self.characterRecordID += 1
				Self.characterRecordID += PlayerObject.CHARACTER_LIST.Length
				Self.characterRecordID Mod= PlayerObject.CHARACTER_LIST.Length
				SoundSystem.getInstance().playSe(STATE_OPENING)
			EndIf
			
			If ((Key.press(Key.B_BACK) Or Key.touchintergraderecordreturn.IsButtonPress()) And State.fadeChangeOver()) Then
				Self.stage_sel_key = 0
				changeStateWithFade(STATE_STAGE_SELECT)
				preStageSelectState = STATE_PRO_RACE_MODE
				initStageSelectRes()
				SoundSystem.getInstance().playSe(STATE_MOVING)
			EndIf
			
		End
		
		Private Method drawCharacterRecord:Void(g:MFGraphics)
			drawCharacterMovingBG(g, Self.characterRecordID)
			Self.recordAniDrawer.draw(g, Self.characterRecordID + STATE_START_GAME, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, False, 0)
			Self.recordAniDrawer.draw(g, Self.stage_characterRecord_ID + STATE_STAGE_SELECT, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, False, 0)
			drawRecordArrow(g)
			drawRecordTime(g, StageManager.getTimeModeScore(Self.characterRecordID, Self.stage_characterRecord_ID, 0), (SCREEN_HEIGHT Shr 1) + STATE_EXIT)
			drawRecordTime(g, StageManager.getTimeModeScore(Self.characterRecordID, Self.stage_characterRecord_ID, ZONE_NUM_OFFSET), ((SCREEN_HEIGHT Shr 1) + STATE_EXIT) + STATE_INTERRUPT)
			drawRecordTime(g, StageManager.getTimeModeScore(Self.characterRecordID, Self.stage_characterRecord_ID, STATE_MOVING), ((SCREEN_HEIGHT Shr 1) + STATE_EXIT) + STATE_OPTION_SP_SET)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			Int i
			AnimationDrawer animationDrawer = muiAniDrawer
			
			If (Key.touchintergraderecordreturn.Isin()) Then
				i = STATE_GOTO_GAME
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Private Method drawRecordArrow:Void(g:MFGraphics)
			Self.recordArrowOffsetXID += 1
			Self.recordArrowOffsetXID Mod= Self.recordArrowOffsetXArray.Length
			Self.recordAniDrawer.draw(g, STATE_EXIT, Self.recordArrowOffsetXArray[Self.recordArrowOffsetXID] + SCREEN_WIDTH, SCREEN_HEIGHT Shr 1, False, 0)
			Self.recordAniDrawer.draw(g, STATE_QUIT, 0 - Self.recordArrowOffsetXArray[Self.recordArrowOffsetXID], SCREEN_HEIGHT Shr 1, False, 0)
		End
		
		Private Method drawRecordTime:Void(g:MFGraphics, num:Int, y:Int)
			Int timenum
			
			If (num = 0) Then
				timenum = SonicDef.OVER_TIME
			Else
				timenum = num
			EndIf
			
			Int min = timenum / 60000
			Int sec = (timenum Mod 60000) / 1000
			Int sec10 = sec / TOTAL_OPTION_ITEMS_NUM
			Int sec01 = sec Mod TOTAL_OPTION_ITEMS_NUM
			Int msec = ((timenum Mod 60000) Mod 1000) / TOTAL_OPTION_ITEMS_NUM
			Int msec10 = msec / TOTAL_OPTION_ITEMS_NUM
			Int msec01 = msec Mod TOTAL_OPTION_ITEMS_NUM
			Self.recordAniDrawer.draw(g, min + STATE_OPTION_HELP, (SCREEN_WIDTH Shr 1) - STATE_PRE_PRESS_START, y, False, 0)
			Self.recordAniDrawer.draw(g, sec10 + STATE_OPTION_HELP, (SCREEN_WIDTH Shr 1) - STATE_RACE_MODE, y, False, 0)
			Self.recordAniDrawer.draw(g, sec01 + STATE_OPTION_HELP, (SCREEN_WIDTH Shr 1) + TOTAL_OPTION_ITEMS_NUM, y, False, 0)
			Self.recordAniDrawer.draw(g, msec10 + STATE_OPTION_HELP, (SCREEN_WIDTH Shr 1) + STATE_SCORE_UPDATE, y, False, 0)
			Self.recordAniDrawer.draw(g, msec01 + STATE_OPTION_HELP, (SCREEN_WIDTH Shr 1) + 58, y, False, 0)
		End
		
		Private Method drawCharacterMovingBG:Void(g:MFGraphics, character_id:Int)
			Int x
			Int y
			Self.recordAniDrawer.setActionId(character_id)
			Self.characterRecordBGOffsetX_1 += STATE_START_GAME
			Self.characterRecordBGOffsetX_1 Mod= TIME_ATTACK_WIDTH
			For (x = Self.characterRecordBGOffsetX_1; x < SCREEN_WIDTH * 2; x += TIME_ATTACK_WIDTH)
				For (y = 0; y < SCREEN_HEIGHT; y += CHARACTER_RECORD_BG_HEIGHT)
					Self.recordAniDrawer.draw(g, x - TIME_ATTACK_WIDTH, y)
				Next
			Next
			Self.characterRecordBGOffsetX_2 -= STATE_START_GAME
			Self.characterRecordBGOffsetX_2 Mod= TIME_ATTACK_WIDTH
			For (x = Self.characterRecordBGOffsetX_2 - 64; x < (SCREEN_WIDTH * STATE_OPENING) / STATE_MOVING; x += TIME_ATTACK_WIDTH)
				For (y = 0; y < SCREEN_HEIGHT; y += CHARACTER_RECORD_BG_HEIGHT)
					Self.recordAniDrawer.draw(g, x, y + STATE_PRO_RACE_MODE)
				Next
			Next
		End
		
		Private Method initIntergradeRecordRes:Void()
			
			If (Self.recordAni = Null) Then
				Self.recordAni = Animation.getInstanceFromQi("/animation/utl_res/record.dat")
				Self.recordAniDrawer = Self.recordAni[0].getDrawer(0, True, 0)
			EndIf
			
			Self.characterRecordID = PlayerObject.getCharacterID()
			Key.touchCharacterRecordInit()
			Key.touchanykeyInit()
			Self.intergradeRecordtoGamecnt = 0
		End
		
		Private Method intergradeRecordLogic:Void()
			Self.intergradeRecordtoGamecnt += 1
			
			If (Key.press(Key.B_SEL) And Self.intergradeRecordtoGamecnt <> intergradeRecordtoGamecnt_max) Then
				Self.intergradeRecordtoGamecnt = intergradeRecordtoGamecnt_max
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
			EndIf
			
			If (Self.intergradeRecordtoGamecnt = intergradeRecordtoGamecnt_max) Then
				StageManager.setStageID(Self.stage_characterRecord_ID)
				SoundSystem.getInstance().stopBgm(False)
				State.setState(ZONE_NUM_OFFSET)
				Key.touchCharacterRecordClose()
				Key.touchanykeyClose()
			EndIf
			
			If (Key.press(Key.B_BACK) And State.fadeChangeOver()) Then
				StageManager.setStageID(Self.stage_characterRecord_ID)
				SoundSystem.getInstance().stopBgm(False)
				State.setState(ZONE_NUM_OFFSET)
				Key.touchCharacterRecordClose()
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
			EndIf
			
		End
		
		Private Method drawIntergradeRecord:Void(g:MFGraphics)
			drawCharacterMovingBG(g, Self.characterRecordID)
			Self.recordAniDrawer.draw(g, Self.characterRecordID + STATE_RANKING, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, False, 0)
			Self.recordAniDrawer.draw(g, Self.stage_characterRecord_ID + STATE_STAGE_SELECT, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, False, 0)
			drawStageNameinIntergradeRecord(g)
			drawRecordTime(g, StageManager.getTimeModeScore(Self.characterRecordID, Self.stage_characterRecord_ID, 0), (SCREEN_HEIGHT Shr 1) + STATE_EXIT)
			drawRecordTime(g, StageManager.getTimeModeScore(Self.characterRecordID, Self.stage_characterRecord_ID, ZONE_NUM_OFFSET), ((SCREEN_HEIGHT Shr 1) + STATE_EXIT) + STATE_INTERRUPT)
			drawRecordTime(g, StageManager.getTimeModeScore(Self.characterRecordID, Self.stage_characterRecord_ID, STATE_MOVING), ((SCREEN_HEIGHT Shr 1) + STATE_EXIT) + STATE_OPTION_SP_SET)
		End
		
		Private Method drawStageNameinIntergradeRecord:Void(g:MFGraphics)
			Int aniID
			Self.recordAniDrawer.draw(g, STATE_INTERGRADE_RECORD, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1, False, 0)
			Self.intergradeRecordStageNameOffsetX += INTERGRADE_RECORD_STAGE_NAME_SPEED
			Self.intergradeRecordStageNameOffsetX Mod= INTERGRADE_RECORD_STAGE_NAME_WIDTH
			
			If (Self.stage_characterRecord_ID < TOTAL_OPTION_ITEMS_NUM) Then
				aniID = (Self.stage_characterRecord_ID Shr 1) + STATE_OPTION_DIFF
			Else
				aniID = (Self.stage_characterRecord_ID - STATE_GOTO_GAME) + STATE_OPTION_DIFF
			EndIf
			
			For (Int x = Self.intergradeRecordStageNameOffsetX - 100; x < (SCREEN_WIDTH * STATE_OPENING) / STATE_MOVING; x += INTERGRADE_RECORD_STAGE_NAME_WIDTH)
				Self.recordAniDrawer.draw(g, aniID, x, SCREEN_HEIGHT Shr 1, False, 0)
			Next
		End
		
		Private Method drawScrollString:Void(g:MFGraphics, string:String, y:Int, speed:Int, space:Int, color1:Int, color2:Int, color3:Int, anchor:Int)
			Self.itemOffsetX += speed
			Self.itemOffsetX Mod= space
			Int x = 0
			While (x - Self.itemOffsetX > 0) {
				x -= space
			}
			Int drawNum = (((SCREEN_WIDTH + space) - 1) / space) + 2
			For (Int i = 0; i < drawNum; i += 1)
				MyAPI.drawBoldString(g, string, (x + (i * space)) - Self.itemOffsetX, y, STATE_RESET_RECORD_ASK, color1, color2, color3)
			Next
		End
		
		Private Method drawTitle1:Void(g:MFGraphics)
			Self.copyOffsetX = MyAPI.calNextPosition((double) Self.copyOffsetX, 0.0d, ZONE_NUM_OFFSET, STATE_MOVING)
			MyAPI.drawImage(g, Self.sonicBigImage, Self.sonicBigX - Self.cameraX, SONIC_BIG_Y, STATE_RETURN_TO_LOGO_1)
		End
		
		Private Method drawTitle2:Void(g:MFGraphics)
			
			If (Self.logoX = LOGO_POSITION_X) Then
				degreeLogic()
			EndIf
			
		End
		
		Private Method degreeLogic:Void()
			Self.titleDegree += 1
			Self.titleDegree Mod= OFFSET_ARRAY.Length
		End
		
		Private Method getOffsetY:Int(degreeOffset:Int)
			Return OFFSET_ARRAY[Self.titleDegree]
		End
		
		Private Function drawTouchKeyMainMenu:Void(g:MFGraphics)
		}
		
		Private Function drawTouchKeyConfirm:Void(g:MFGraphics)
		}
		
		Private Function drawTouchKeyMenu:Void(g:MFGraphics)
		}
		
		Private Function drawTouchKeyHelp:Void(g:MFGraphics)
		}
		
		Private Function drawTouchKeyAbout:Void(g:MFGraphics)
		}
		
		Private Function drawTouchKeySelectStage:Void(g:MFGraphics)
		}
		
		Private Function drawTouchKeyOption:Void(g:MFGraphics)
		}
		
		Public Method gotoMainmenu:Void()
			state = STATE_MOVING
			Self.nextState = STATE_MOVING
			menuInit(Self.multiMainItems)
			mainMenuInit()
			Key.touchMainMenuInit2()
			Self.returnCursor = 0
			Key.touchanykeyClose()
			Key.touchkeyboardInit()
			Key.clear()
		End
		
		Public Method gotoStageSelect:Void()
			
			If (StageManager.characterFromGame = ELEMENT_OFFSET Or StageManager.stageIDFromGame = ELEMENT_OFFSET) Then
				changeStateWithFade(STATE_CHARACTER_SELECT)
				Self.preCharaterSelectState = STATE_MOVING
				Self.stage_sel_key = STATE_MOVING
				initCharacterSelectRes()
				GameState.isThroughGame = False
				StageManager.isContinueGame = False
				Return
			EndIf
			
			startGameInit()
			State.fadeInit(0, 102)
			state = STATE_START_GAME
		End
		
		Public Method BP_gotoPaying:Bool()
			Return False
		End
		
		Public Method BP_payingLogic:Void()
			
			If (Not BP_enteredPaying) Then
				If (State.BP_chargeLogic(0)) Then
					BP_enteredPaying = True
					State.activeGameProcess(True)
					State.setMenu()
					State.setTry()
					State.saveBPRecord()
					gotoStageSelect()
					Return
				EndIf
				
				BP_enteredPaying = True
				State.setTry()
				StageManager.resetStageIdforTry()
				State.saveBPRecord()
				gotoMainmenu()
			EndIf
			
		End
		
		Public Method characterSelectInit:Void()
		End
		
		Public Method characterSelectDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			For (Int i = 0; i < CHARACTER_STR.Length; i += 1)
				MyAPI.drawBoldString(g, CHARACTER_STR[i], SCREEN_WIDTH Shr 1, (i * STATE_OPTION_TIME_LIMIT) + STATE_RETURN_TO_LOGO_1, STATE_RESET_RECORD_ASK, 16776960, 0)
				
				If (i = PlayerObject.getCharacterID()) Then
					MFGraphics mFGraphics = g
					MyAPI.drawBoldString(mFGraphics, "*", ((SCREEN_WIDTH - MFGraphics.stringWidth(STATE_STAGE_SELECT, CHARACTER_STR[i])) Shr 1) - TOTAL_OPTION_ITEMS_NUM, (i * STATE_OPTION_TIME_LIMIT) + STATE_RETURN_TO_LOGO_1, STATE_PRO_RACE_MODE, 16776960, 0)
				EndIf
				
			Next
		End
		
		Private Method mainMenuNormalLogic:Void()
			
			If (Not Self.isTitleBGMPlay) Then
				Self.isTitleBGMPlay = True
			EndIf
			
			Key.touchanykeyClose()
			
			If (Key.touchmainmenustart.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.cursor = 0
			ElseIf (Key.touchmainmenurace.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.cursor = ZONE_NUM_OFFSET
			ElseIf (Key.touchmainmenuoption.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.cursor = STATE_MOVING
			ElseIf (Key.touchmainmenuend.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.cursor = STATE_OPENING
			EndIf
			
			If (Key.touchmainmenureturn.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.returnCursor = ZONE_NUM_OFFSET
			EndIf
			
			If (Key.touchmainmenustart.IsButtonPress() And Self.cursor = 0 And (State.fadeChangeOver() Or Self.isFromStartGame)) Then
				PlayerObject.stageModeState = 0
				
				If (Not BP_gotoPaying()) Then
					gotoStageSelect()
				EndIf
				
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				
				If (Self.isFromStartGame) Then
					Self.isFromStartGame = False
				EndIf
				
			ElseIf (Key.touchmainmenurace.IsButtonPress() And Self.cursor = ZONE_NUM_OFFSET And (State.fadeChangeOver() Or Self.isFromStartGame)) Then
				PlayerObject.stageModeState = ZONE_NUM_OFFSET
				changeStateWithFade(STATE_PRO_RACE_MODE)
				initTimeStageRes()
				Self.cursor = 0
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				
				If (Self.isFromStartGame) Then
					Self.isFromStartGame = False
				EndIf
				
				Self.isRaceModeItemsSelected = False
			ElseIf (Key.touchmainmenuoption.IsButtonPress() And Self.cursor = STATE_MOVING And (State.fadeChangeOver() Or Self.isFromStartGame)) Then
				optionInit()
				changeStateWithFade(VISIBLE_OPTION_ITEMS_NUM)
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				
				If (Self.isFromStartGame) Then
					Self.isFromStartGame = False
				EndIf
				
			ElseIf (Key.touchmainmenuend.IsButtonPress() And Self.cursor = STATE_OPENING And (State.fadeChangeOver() Or Self.isFromStartGame)) Then
				state = STATE_EXIT
				secondEnsureInit()
				State.fadeInit(0, 220)
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				
				If (Self.isFromStartGame) Then
					Self.isFromStartGame = False
				EndIf
				
				Self.quitFlag = 0
			EndIf
			
			If (Not Key.press(Key.B_BACK) And (Not Key.touchmainmenureturn.IsButtonPress() Or Self.returnCursor <> ZONE_NUM_OFFSET)) Then
				Return
			EndIf
			
			If (State.fadeChangeOver() Or Self.isFromStartGame) Then
				state = ZONE_NUM_OFFSET
				initTitleRes2()
				SoundSystem.getInstance().playSe(STATE_MOVING)
				
				If (Self.isFromStartGame) Then
					Self.isFromStartGame = False
				EndIf
				
				Key.touchanykeyInit()
				fading = False
			EndIf
			
		End
		
		Private Method mainMenuMultiItemsLogic:Void()
			
			If (Not Self.isTitleBGMPlay) Then
				Self.isTitleBGMPlay = True
			EndIf
			
			Key.touchanykeyClose()
			
			If (Self.menuMoving) Then
				Self.mainMenuCursor = 0
				Self.returnCursor = 0
				Self.mainMenuEnsureFlag = False
				Return
			EndIf
			
			If (Key.touchmainmenuup.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.mainMenuCursor = ZONE_NUM_OFFSET
			ElseIf (Key.touchmainmenudown.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.mainMenuCursor = STATE_MOVING
			ElseIf (Key.touchmainmenuitem.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.mainMenuCursor = STATE_OPENING
				Self.mainMenuEnsureFlag = True
			EndIf
			
			If (Key.touchmainmenureturn.Isin() And Key.touchmainmenu.IsClick()) Then
				Self.returnCursor = ZONE_NUM_OFFSET
			EndIf
			
			If (Key.touchmainmenuup.IsButtonPress() And Self.mainMenuCursor = ZONE_NUM_OFFSET) Then
				Self.mainMenuItemCursor -= ZONE_NUM_OFFSET
				Self.mainMenuItemCursor = (Self.mainMenuItemCursor + Self.elementNum) Mod Self.elementNum
				changeUpSelect()
				SoundSystem.getInstance().playSe(STATE_OPENING)
			ElseIf (Key.touchmainmenudown.IsButtonPress() And Self.mainMenuCursor = STATE_MOVING) Then
				Self.mainMenuItemCursor += 1
				Self.mainMenuItemCursor = (Self.mainMenuItemCursor + Self.elementNum) Mod Self.elementNum
				changeDownSelect()
				SoundSystem.getInstance().playSe(STATE_OPENING)
			ElseIf (Key.touchmainmenuitem.IsButtonPress() And Self.mainMenuCursor = STATE_OPENING) Then
				Select (Self.mainMenuItemCursor)
					Case ZONE_NUM_OFFSET
						PlayerObject.stageModeState = ZONE_NUM_OFFSET
						changeStateWithFade(STATE_PRO_RACE_MODE)
						initTimeStageRes()
						Self.cursor = 0
						
						If (Self.isFromStartGame) Then
							Self.isFromStartGame = False
						EndIf
						
						Self.isRaceModeItemsSelected = False
						break
					Case STATE_MOVING
						optionInit()
						changeStateWithFade(VISIBLE_OPTION_ITEMS_NUM)
						
						If (Self.isFromStartGame) Then
							Self.isFromStartGame = False
							break
						EndIf
						
						break
					Case STATE_OPENING
						state = STATE_SEGA_MORE
						secondEnsureInit()
						State.fadeInit(0, 220)
						
						If (Self.isFromStartGame) Then
							Self.isFromStartGame = False
						EndIf
						
						segaMoreInit()
						break
					Case STATE_START_GAME
						state = STATE_EXIT
						secondEnsureInit()
						State.fadeInit(0, 220)
						
						If (Self.isFromStartGame) Then
							Self.isFromStartGame = False
						EndIf
						
						Self.quitFlag = 0
						break
				End Select
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
			EndIf
			
			If (Not Key.press(Key.B_BACK) And (Not Key.touchmainmenureturn.IsButtonPress() Or Self.returnCursor <> ZONE_NUM_OFFSET)) Then
				Return
			EndIf
			
			If (State.fadeChangeOver() Or Self.isFromStartGame) Then
				state = ZONE_NUM_OFFSET
				initTitleRes2()
				SoundSystem.getInstance().playSe(STATE_MOVING)
				
				If (Self.isFromStartGame) Then
					Self.isFromStartGame = False
				EndIf
				
				Key.touchanykeyInit()
				fading = False
			EndIf
			
		End
		
		Private Method mainMenuLogic:Void()
			mainMenuNormalLogic()
		End
		
		Private Method startGameInit:Void()
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Key.touchStartGameInit()
			Self.startgamecursor = ELEMENT_OFFSET
			Self.startgameframe = 0
			Self.startgameensureFlag = False
			State.fadeInit(102, 220)
			StageManager.isContinueGame = False
		End
		
		Private Method startGameLogic:Void()
			Key.touchMainMenuReset2()
			
			If (Key.touchstartgamecontinue.Isin() And Key.touchstartgame.IsClick()) Then
				Self.startgamecursor = 0
			ElseIf (Key.touchstartgamenew.Isin() And Key.touchstartgame.IsClick()) Then
				Self.startgamecursor = ZONE_NUM_OFFSET
			ElseIf (Key.touchstartgamereturn.Isin() And Key.touchstartgame.IsClick() And Not Self.startgameensureFlag) Then
				Self.startgamecursor = STATE_MOVING
			EndIf
			
			If (Self.startgameensureFlag) Then
				Self.startgameframe += 1
				
				If (Self.startgameframe <> STATE_EXIT) Then
					Return
				EndIf
				
				If (Self.startgamecursor = 0) Then
					StageManager.isContinueGame = True
					State.fadeInit(255, 0)
					State.setState(ZONE_NUM_OFFSET)
					Print("continue")
					Return
				ElseIf (Self.startgamecursor = ZONE_NUM_OFFSET) Then
					StageManager.isContinueGame = False
					changeStateWithFade(STATE_CHARACTER_SELECT)
					initCharacterSelectRes()
					Self.preCharaterSelectState = STATE_MOVING
					Self.stage_sel_key = STATE_MOVING
					PlayerObject.stageModeState = 0
					Print("New game")
					Return
				Else
					Return
				EndIf
			EndIf
			
			If (Key.touchstartgamecontinue.IsButtonPress() And Self.startgamecursor = 0) Then
				Self.startgameensureFlag = True
				Self.startgameframe = 0
				StageManager.loadStageRecord()
				PlayerObject.setCharacter(StageManager.characterFromGame)
				StageManager.setStageID(StageManager.stageIDFromGame)
				State.fadeInit(102, 255)
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
			ElseIf (Key.touchstartgamenew.IsButtonPress() And Self.startgamecursor = ZONE_NUM_OFFSET) Then
				Self.startgameensureFlag = True
				Self.startgameframe = 0
				PlayerObject.setScore(0)
				PlayerObject.setLife(STATE_MOVING)
				State.fadeInit(102, 255)
				SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				GameState.isThroughGame = False
				StageManager.isContinueGame = False
			EndIf
			
			If ((Key.press(Key.B_BACK) Or (Key.touchstartgamereturn.IsButtonPress() And Self.startgamecursor = STATE_MOVING)) And State.fadeChangeOver()) Then
				State.fadeInit(102, 0)
				state = STATE_MOVING
				Self.nextState = STATE_MOVING
				State.setFadeOver()
				Self.isTitleBGMPlay = False
				Key.touchMainMenuInit2()
				Key.touchanykeyClose()
				Key.touchkeyboardInit()
				Key.clear()
				SoundSystem.getInstance().playSe(STATE_MOVING)
				initTitleRes2()
				Self.returnCursor = 0
			EndIf
			
		End
		
		Private Method startGameDraw:Void(g:MFGraphics)
			AnimationDrawer animationDrawer = muiAniDrawer
			Int i = (Key.touchstartgamecontinue.Isin() And Self.startgamecursor = 0) ? ZONE_NUM_OFFSET : 0
			animationDrawer.setActionId(i + 55)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - STATE_START_TO_MENU_1)
			animationDrawer = muiAniDrawer
			
			If (Key.touchstartgamenew.Isin() And Self.startgamecursor = ZONE_NUM_OFFSET) Then
				i = ZONE_NUM_OFFSET
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 55)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_START_TO_MENU_1)
			muiAniDrawer.setActionId(0)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - STATE_START_TO_MENU_1)
			muiAniDrawer.setActionId(ZONE_NUM_OFFSET)
			muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) + STATE_START_TO_MENU_1)
			animationDrawer = muiAniDrawer
			
			If (Key.touchstartgamereturn.Isin()) Then
				i = STATE_GOTO_GAME
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
			
			If (Self.startgameensureFlag) Then
				State.drawFadeSlow(g)
				
				If (Self.startgameframe >= STATE_EXIT) Then
					g.setColor(0)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				EndIf
			EndIf
			
		End
		
		Private Method quitLogic:Void()
			Key.touchMainMenuReset2()
			Select (secondEnsureLogic())
				Case ZONE_NUM_OFFSET
					close()
					'System.gc()
					state = STATE_QUIT
					SoundSystem.getInstance().stopBgm(True)
					Key.touchkeyboardClose()
					Key.touchsoftkeyInit()
				Case STATE_MOVING
					
					If (Self.quitFlag = ZONE_NUM_OFFSET) Then
						state = ZONE_NUM_OFFSET
						Key.touchanykeyInit()
					ElseIf (Self.quitFlag = 0) Then
						gotoMainmenu()
						Key.clear()
						State.setFadeOver()
					EndIf
					
				Default
			End Select
		End
		
		Private Method menuOptionDiffLogic:Void()
			Select (itemsSelect2Logic())
				Case ZONE_NUM_OFFSET
					GlobalResource.difficultyConfig = ZONE_NUM_OFFSET
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Case STATE_MOVING
					GlobalResource.difficultyConfig = 0
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Case STATE_OPENING
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Default
			End Select
		End
		
		Private Method menuOptionSoundLogic:Void()
			Select (itemsSelect2Logic())
				Case ZONE_NUM_OFFSET
					GlobalResource.soundSwitchConfig = ZONE_NUM_OFFSET
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				Case STATE_MOVING
					GlobalResource.soundSwitchConfig = 0
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
					SoundSystem.getInstance().setSoundState(0)
					SoundSystem.getInstance().setSeState(0)
				Case STATE_OPENING
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Default
			End Select
		End
		
		Private Method menuOptionVibLogic:Void()
			Select (itemsSelect2Logic())
				Case ZONE_NUM_OFFSET
					GlobalResource.vibrationConfig = ZONE_NUM_OFFSET
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
					MyAPI.vibrate()
				Case STATE_MOVING
					GlobalResource.vibrationConfig = 0
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Case STATE_OPENING
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Default
			End Select
		End
		
		Private Method menuOptionTimeLimitLogic:Void()
			Select (itemsSelect2Logic())
				Case ZONE_NUM_OFFSET
					GlobalResource.timeLimit = 0
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Case STATE_MOVING
					GlobalResource.timeLimit = ZONE_NUM_OFFSET
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Case STATE_OPENING
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Default
			End Select
		End
		
		Private Method menuOptionSpSetLogic:Void()
			Select (itemsSelect2Logic())
				Case ZONE_NUM_OFFSET
					GlobalResource.spsetConfig = 0
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Case STATE_MOVING
					GlobalResource.spsetConfig = ZONE_NUM_OFFSET
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Case STATE_OPENING
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Default
			End Select
		End
		
		Private Method menuOptionResetRecordLogic:Void()
			Select (secondEnsureDirectLogic())
				Case ZONE_NUM_OFFSET
					state = STATE_OPTION_RESET_RECORD_ENSURE
					secondEnsureInit()
				Case STATE_MOVING
					State.fadeInit(220, 0)
					state = VISIBLE_OPTION_ITEMS_NUM
				Default
			End Select
		End
		
		Private Method menuOptionResetRecordEnsureLogic:Void()
			Select (secondEnsureLogic())
				Case ZONE_NUM_OFFSET
					StageManager.resetGameRecord()
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
					Self.resetInfoCount = Self.RESET_INFO_COUNT
					state = VISIBLE_OPTION_ITEMS_NUM
					State.fadeInit(220, 0)
				Case STATE_MOVING
					state = STATE_OPTION_RESET_RECORD
					secondEnsureInit()
					State.fadeInit(220, 220)
				Default
			End Select
		End
		
		Private Method menuOptionLanguageInit:Void()
			Self.itemsselectcursor = 0
			Self.isItemsSelect = False
			State.fadeInit(102, 220)
			Key.touchMenuOptionLanguageInit()
		End
		
		Private Method menuOptionLanguageCheck:Int()
			Int i
			For (i = 0; i < STATE_GOTO_GAME; i += 1)
				
				If (Key.touchmenuoptionlanguageitems[i].Isin() And Key.touchmenuoptionlanguage.IsClick()) Then
					Self.itemsselectcursor = i
				EndIf
				
			Next
			
			If (Key.touchmenuoptionlanguagereturn.Isin() And Key.touchmenuoptionlanguage.IsClick()) Then
				Self.itemsselectcursor = TIME_ATTACK_SPEED_X
			EndIf
			
			If (Self.isItemsSelect) Then
				Self.itemsselectframe += 1
				
				If (Self.itemsselectframe > STATE_RANKING) Then
					State.fadeInit(220, 102)
					Return Self.Finalitemsselectcursor + 2
				EndIf
			EndIf
			
			i = 0
			While (i < STATE_GOTO_GAME) {
				
				If (Self.itemsselectcursor = i And Key.touchmenuoptionlanguageitems[i].IsClick()) Then
					Self.isItemsSelect = True
					Self.itemsselectframe = 0
					Self.Finalitemsselectcursor = i
					Return 0
				EndIf
				
				i += 1
			}
			
			If ((Not Key.press(Key.B_BACK) And (Not Key.touchmenuoptionlanguagereturn.IsButtonPress() Or Self.itemsselectcursor <> TIME_ATTACK_SPEED_X)) Or Not State.fadeChangeOver()) Then
				Return 0
			EndIf
			
			SoundSystem.getInstance().playSe(STATE_MOVING)
			Return ZONE_NUM_OFFSET
		End
		
		Private Method menuOptionLanguageLogic:Void()
			Int language = menuOptionLanguageCheck()
			
			If (language = ZONE_NUM_OFFSET) Then
				State.fadeInit(220, 102)
				state = VISIBLE_OPTION_ITEMS_NUM
			ElseIf (language >= STATE_MOVING) Then
				GlobalResource.languageConfig = language - STATE_MOVING
				State.fadeInit(220, 102)
				state = VISIBLE_OPTION_ITEMS_NUM
			EndIf
			
		End
		
		Private Method menuOptionLanguageDraw:Void(g:MFGraphics)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
				Return
			EndIf
			
			AnimationDrawer animationDrawer
			Int i
			Int i2 = 0
			While (i2 < STATE_GOTO_GAME) {
				animationDrawer = muiAniDrawer
				
				If (Key.touchmenuoptionlanguageitems[i2].Isin() And Self.itemsselectcursor = i2) Then
					i = ZONE_NUM_OFFSET
				Else
					i = 0
				EndIf
				
				animationDrawer.setActionId(i + 55)
				muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - CHARACTER_RECORD_BG_HEIGHT) + (i2 * STATE_PRO_RACE_MODE))
				muiAniDrawer.setActionId(i2 + STATE_OPTION_SOUND_VOLUMN)
				muiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - CHARACTER_RECORD_BG_HEIGHT) + (i2 * STATE_PRO_RACE_MODE))
				i2 += 1
			}
			animationDrawer = muiAniDrawer
			
			If (Key.touchmenuoptionlanguagereturn.Isin()) Then
				i = STATE_GOTO_GAME
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
		End
		
		Private Method creditInit:Void()
			MyAPI.initString()
			strForShow = MyAPI.getStrings(aboutStrings[0], STATE_ABOUT, SCREEN_WIDTH)
			Self.creditStringLineNum = strForShow.Length
			Self.creditOffsetY = 0
			muiUpArrowDrawer = New Animation("/animation/mui").getDrawer(93, True, 0)
			muiDownArrowDrawer = New Animation("/animation/mui").getDrawer(94, True, 0)
			Key.touchInstructionInit()
			SoundSystem.getInstance().playBgm(STATE_OPTION_LANGUAGE)
			Self.arrowframecnt = 0
			PageFrameCnt = 0
			
			If (Self.textBGImage = Null) Then
				Self.textBGImage = MFImage.createImage("/animation/text_bg.png")
			EndIf
			
			Self.returnPageCursor = 0
		End
		
		Private Method creditLogic:Void()
			
			If (Key.slidesensorhelp.isSliding()) Then
				If (Key.slidesensorhelp.isSlide(Key.DIR_UP)) Then
					MyAPI.logicString(True, False)
				ElseIf (Key.slidesensorhelp.isSlide(Key.DIR_DOWN)) Then
					MyAPI.logicString(False, True)
				EndIf
			EndIf
			
			Self.creditOffsetY Mod= (Self.creditStringLineNum * LINE_SPACE) + SCREEN_HEIGHT
			
			If (Key.touchhelpreturn.Isin() And Key.touchpage.IsClick()) Then
				Self.returnPageCursor = ZONE_NUM_OFFSET
			EndIf
			
			If ((Key.press(Key.B_BACK) Or (Key.touchhelpreturn.IsButtonPress() And Self.returnPageCursor = ZONE_NUM_OFFSET)) And State.fadeChangeOver()) Then
				changeStateWithFade(VISIBLE_OPTION_ITEMS_NUM)
				Self.isOptionDisFlag = False
				SoundSystem.getInstance().playSe(STATE_MOVING)
			EndIf
			
			If (Key.touchhelpuparrow.Isin()) Then
				Self.arrowframecnt += 1
				
				If (Self.arrowframecnt <= STATE_START_GAME And Not Self.isArrowClicked) Then
					MyAPI.logicString(False, True)
					Self.isArrowClicked = True
				ElseIf (Self.arrowframecnt > STATE_START_GAME And Self.arrowframecnt Mod STATE_MOVING = 0) Then
					MyAPI.logicString(False, True)
				EndIf
				
			ElseIf (Key.touchhelpdownarrow.Isin()) Then
				Self.arrowframecnt += 1
				
				If (Self.arrowframecnt <= STATE_START_GAME And Not Self.isArrowClicked) Then
					MyAPI.logicString(True, False)
					Self.isArrowClicked = True
				ElseIf (Self.arrowframecnt > STATE_START_GAME And Self.arrowframecnt Mod STATE_MOVING = 0) Then
					MyAPI.logicString(True, False)
				EndIf
				
			Else
				Self.arrowframecnt = 0
				Self.isArrowClicked = False
			EndIf
			
		End
		
		Private Method creditDraw:Void(g:MFGraphics)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			Else
				muiAniDrawer.setActionId(63)
				PageFrameCnt += 1
				PageFrameCnt Mod= STATE_ABOUT
				
				If (PageFrameCnt Mod STATE_MOVING = 0) Then
					PageBackGroundOffsetX += 1
					PageBackGroundOffsetX Mod= CREDIT_PAGE_BACKGROUND_WIDTH
					PageBackGroundOffsetY -= ZONE_NUM_OFFSET
					PageBackGroundOffsetY Mod= intergradeRecordtoGamecnt_max
				EndIf
				
				For (Int x = PageBackGroundOffsetX - 112; x < (SCREEN_WIDTH * STATE_OPENING) / STATE_MOVING; x += CREDIT_PAGE_BACKGROUND_WIDTH)
					For (Int y = PageBackGroundOffsetY - 56; y < (SCREEN_HEIGHT * STATE_OPENING) / STATE_MOVING; y += intergradeRecordtoGamecnt_max)
						muiAniDrawer.draw(g, x, y)
					Next
				Next
				For (Int i = 0; i < STATE_RANKING; i += 1)
					MyAPI.drawImage(g, Self.textBGImage, ((SCREEN_WIDTH Shr 1) - 104) + (i * STATE_INTERGRADE_RECORD), (SCREEN_HEIGHT Shr 1) - 72, 0)
				Next
				MyAPI.drawStrings(g, strForShow, (SCREEN_WIDTH Shr 1) - 104, ((SCREEN_HEIGHT Shr 1) - 72) + STATE_GOTO_GAME, (Int) Def.TOUCH_HELP_WIDTH, 131, (Int) 0, True, (Int) MapManager.END_COLOR, 4656650, (Int) 0, (Int) STATE_ABOUT)
				
				If (MyAPI.upPermit) Then
					muiUpArrowDrawer.draw(g, (SCREEN_WIDTH Shr 1) - STATE_CHARACTER_RECORD, SCREEN_HEIGHT)
				EndIf
				
				If (MyAPI.downPermit) Then
					muiDownArrowDrawer.draw(g, (SCREEN_WIDTH Shr 1) + STATE_PRO_RACE_MODE, SCREEN_HEIGHT)
				EndIf
				
				muiAniDrawer.setActionId((Key.touchhelpreturn.Isin() ? STATE_GOTO_GAME : 0) + 61)
				muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
			EndIf
			
			State.drawFade(g)
		End
		
		Private Method segaMoreLogic:Void()
			Key.touchMainMenuReset2()
			Select (secondEnsureLogic())
				Case ZONE_NUM_OFFSET
					MFDevice.openUrl(activity.segaMoreUrl, True)
					State.exitGame()
					sendMessage(New Message(), STATE_GOTO_GAME)
				Case STATE_MOVING
					gotoMainmenu()
					Key.clear()
					State.setFadeOver()
				Default
			End Select
		End
		
		Private Method scoreUpdateInit:Void()
			Key.touchgamekeyClose()
			Key.touchkeygameboardClose()
			Key.touchkeyboardInit()
			Key.touchscoreupdatekeyInit()
			changeStateWithFade(STATE_SCORE_UPDATE)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			If (GameState.guiAnimation = Null) Then
				GameState.guiAnimation = New Animation("/animation/gui")
			EndIf
			
			GameState.guiAniDrawer = GameState.guiAnimation.getDrawer(0, False, 0)
			Self.returnCursor = 0
			Self.scoreUpdateCursor = 0
			Self.characterRecordScoreUpdateIconY = -32
			Self.characterRecordScoreUpdateCursor = 0
		End
		
		Private Method scoreUpdateLogic:Void()
			
			If (State.fadeChangeOver()) Then
				If (Key.touchscoreupdatereturn.Isin() And Key.touchscoreupdate.IsClick()) Then
					Self.returnCursor = ZONE_NUM_OFFSET
				EndIf
				
				If (Key.touchscoreupdateyes.Isin() And Key.touchscoreupdate.IsClick()) Then
					Self.scoreUpdateCursor = ZONE_NUM_OFFSET
				ElseIf (Key.touchscoreupdateno.Isin() And Key.touchscoreupdate.IsClick()) Then
					Self.scoreUpdateCursor = STATE_MOVING
				EndIf
				
				If (Key.touchscoreupdateyes.IsButtonPress() And Self.scoreUpdateCursor = ZONE_NUM_OFFSET) Then
					state = STATE_SCORE_UPDATE_ENSURE
					secondEnsureInit()
					State.fadeInit(0, GimmickObject.GIMMICK_NUM)
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				ElseIf (Key.touchscoreupdateno.IsButtonPress() And Self.scoreUpdateCursor = STATE_MOVING) Then
					state = STATE_CHARACTER_RECORD
					State.setFadeOver()
					SoundSystem.getInstance().playSe(ZONE_NUM_OFFSET)
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchscoreupdatereturn.IsButtonPress() And Self.returnCursor = ZONE_NUM_OFFSET)) And State.fadeChangeOver()) Then
					state = STATE_CHARACTER_RECORD
					State.setFadeOver()
					SoundSystem.getInstance().playSe(STATE_MOVING)
				EndIf
			EndIf
			
		End
		
		Private Method scoreUpdateDraw:Void(g:MFGraphics)
			Int i
			g.setColor(0)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			muiAniDrawer.setActionId(52)
			For (Int i2 = 0; i2 < (SCREEN_WIDTH / CHARACTER_RECORD_BG_HEIGHT) + ZONE_NUM_OFFSET; i2 += 1)
				For (Int j = 0; j < (SCREEN_HEIGHT / CHARACTER_RECORD_BG_HEIGHT) + ZONE_NUM_OFFSET; j += 1)
					muiAniDrawer.draw(g, i2 * CHARACTER_RECORD_BG_HEIGHT, j * CHARACTER_RECORD_BG_HEIGHT)
				Next
			Next
			Self.optionOffsetX -= STATE_START_GAME
			Self.optionOffsetX Mod= TIME_ATTACK_WIDTH
			muiAniDrawer.setActionId(102)
			For (Int x1 = Self.optionOffsetX; x1 < SCREEN_WIDTH * 2; x1 += TIME_ATTACK_WIDTH)
				muiAniDrawer.draw(g, x1, 0)
			Next
			GameState.guiAniDrawer.setActionId(STATE_RESET_RECORD_ASK)
			GameState.guiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 37)
			PlayerObject.drawRecordTime(g, StageManager.getTimeModeScore(PlayerObject.getCharacterID()), (Def.SCREEN_WIDTH Shr 1) + 54, (Def.SCREEN_HEIGHT Shr 1) - 10, STATE_MOVING, STATE_MOVING)
			muiAniDrawer.setActionId((Key.touchscoreupdateyes.Isin() ? ZONE_NUM_OFFSET : 0) + 55)
			muiAniDrawer.draw(g, (Def.SCREEN_WIDTH Shr 1) - 60, (Def.SCREEN_HEIGHT Shr 1) + STATE_OPTION_SOUND)
			muiAniDrawer.setActionId(StringIndex.BLUE_BACKGROUND_ID)
			muiAniDrawer.draw(g, (Def.SCREEN_WIDTH Shr 1) - 60, (Def.SCREEN_HEIGHT Shr 1) + STATE_OPTION_SOUND)
			AnimationDrawer animationDrawer = muiAniDrawer
			
			If (Key.touchscoreupdateno.Isin()) Then
				i = ZONE_NUM_OFFSET
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 55)
			muiAniDrawer.draw(g, (Def.SCREEN_WIDTH Shr 1) + STAGE_SELECT_SIDE_BAR_WIDTH, (Def.SCREEN_HEIGHT Shr 1) + STATE_OPTION_SOUND)
			muiAniDrawer.setActionId(104)
			muiAniDrawer.draw(g, (Def.SCREEN_WIDTH Shr 1) + STAGE_SELECT_SIDE_BAR_WIDTH, (Def.SCREEN_HEIGHT Shr 1) + STATE_OPTION_SOUND)
			animationDrawer = muiAniDrawer
			
			If (Key.touchscoreupdatereturn.Isin()) Then
				i = STATE_GOTO_GAME
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
			State.drawFade(g)
		End
		
		Private Method scoreUpdateEnsureLogic:Void()
			Select (secondEnsureLogic())
				Case ZONE_NUM_OFFSET
					Message msg = New Message()
					setGameScore(StageManager.getTimeModeScore(PlayerObject.getCharacterID()))
					sendMessage(msg, STATE_RACE_MODE)
					state = STATE_SCORE_UPDATED
				Case STATE_MOVING
					state = STATE_SCORE_UPDATE
					State.fadeInit(GimmickObject.GIMMICK_NUM, 0)
					State.setFadeOver()
					Self.returnCursor = 0
					Self.scoreUpdateCursor = 0
				Default
			End Select
		End
		
		Private Method scoreUpdateEnsureDraw:Void(g:MFGraphics)
			scoreUpdateDraw(g)
			State.drawFade(g)
			SecondEnsurePanelDraw(g, 106)
		End
		
		Private Method scoreUpdatedLogic:Void()
			
			If (activity.isResumeFromOtherActivity) Then
				Standard2.splashinit(True)
				changeStateWithFade(0)
				activity.isResumeFromOtherActivity = False
			EndIf
			
		End
		
		Private Method scoreUpdatedDraw:Void(g:MFGraphics)
		End
		
		Private Method segaMoreInit:Void()
			activity.buildSegaMoreUrl()
		End
End