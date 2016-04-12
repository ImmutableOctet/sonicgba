Strict

Public

' Imports:
Private
	Import gameengine.def
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.constutil
	
	Import platformstandard.standard2
	
	Import sonicgba.backgroundmanager
	Import sonicgba.effect
	Import sonicgba.enemyobject
	Import sonicgba.gameobject
	'Import sonicgba.gimmickobject
	Import sonicgba.globalresource
	Import sonicgba.mapmanager
	'Import sonicgba.playeranimationcollisionrect
	Import sonicgba.playerobject
	'Import sonicgba.playertails
	Import sonicgba.rocketseparateeffect
	Import sonicgba.stagemanager
	
	Import state.state
	
	'Import android.os.message
	
	'Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class GameState Extends State
	Private
		' Constant variable(s):
		Const ACTION:Int = 4
		
		Const BAR_COLOR:Int = 2
		
		Const BIRD_NUM:Int = 10
		Const BIRD_OFFSET:Int = 2
		Const BIRD_SPACE_1:Int = 10
		Const BIRD_SPACE_2:Int = 14
		Const BIRD_X:Int = 0
		Const BIRD_Y:Int = 1
		
		Global BP_ITEMS_HIGH:Int[] = [0, 1, 3] ' Const
		Global BP_ITEMS_HIGH_NORMAL_NUM:Int[] = [5, 3, 5] ' Const
		Global BP_ITEMS_LOW:Int[] = [0, 2, 3] ' Const
		Global BP_ITEMS_LOW_NORMAL_NUM:Int[] = [5, 5, 5] ' Const
		
		Const CLOUD_NUM:Int = 10
		Const CLOUD_TYPE:Int = 0
		
		Const CLOUD_X:Int = 1
		Const CLOUD_Y:Int = 2
		
		Global CLOUD_VELOCITY:Int[] = [5, 4, 3] ' Const
		Global COLOR_SEQ:Int[] = [16777024, 16756912, 11599680, 16756800] ' Const
		
		Const DEGREE_VELOCITY:Int = 10
		
		Const ED_STATE_NO_PLANE:Byte = 0
		Const ED_STATE_PLANE_APPEAR:Byte = 1
		Const ED_STATE_BIRD_APPEAR:Byte = 2
		Const ED_STATE_CONGRATULATION:Byte = 3
		Const ED_STATE_STAFF:Byte = 4
		Const ED_END:Byte = 5
		
		Const ENDING_ANIMATION_PATH:String = "/animation/ending"
		
		Const FLOAT_RANGE:Int = 10
		
		Const LOADING_TIME_LIMIT:Int = 10
		
		Const NUM:Byte = 6
		
		Const OPTION_ELEMENT_NUM:Int = 2 ' Global OPTION_ELEMENT_NUM:Int = OPTION_TAG.Length ' Const
		Const PAUSE_OPTION_ITEMS_NUM:Int = 6
		Const VISIBLE_OPTION_ITEMS_NUM:Int = 9
		
		Const OPTION_MOVING_INTERVAL:Int = 100
		Const OPTION_MOVING_SPEED:Int = 4
		
		Global OPTION_SE:Int[] = [55, 144] ' Const
		Global OPTION_SELECTOR:Int[][] = OPTION_SELECTOR_HAS_SE ' Const
		Global OPTION_SELECTOR_HAS_SE:Int[][] = [OPTION_SOUND, OPTION_SE] ' Const
		Global OPTION_SELECTOR_NO_SE:Int[][] = [OPTION_SOUND] ' Const
		Global OPTION_SOUND:Int[] = OPTION_SOUND_VOLUME ' Const
		Global OPTION_SOUND_NO_VOLUME:Int[] = [55, 144] ' Const
		Global OPTION_SOUND_VOLUME:Int[] = [55, 58, 58, 58, 57, 57, 57, 57, 56, 56, 56] ' Const
		Global OPTION_TAG:Int[] = OPTION_TAG_HAS_SE ' Const
		Global OPTION_TAG_HAS_SE:Int[] = [54, 143] ' Const
		Global OPTION_TAG_NO_SE:Int[] = [54] ' Const
		
		Global PAUSE_NORMAL_MODE_NOSHOP:Int[] = [0, 1, 3, 4] ' Const
		Global PAUSE_NORMAL_MODE_SHOP:Int[] = [0, 1, 2, 3, 4] ' Const
		
		Const PAUSE_NORMAL_RESUME:Int = 0
		Const PAUSE_NORMAL_TO_TITLE:Int = 1
		Const PAUSE_NORMAL_SHOP:Int = 2
		Const PAUSE_NORMAL_OPTION:Int = 3
		Const PAUSE_NORMAL_INSTRUCTION:Int = 4
		
		Const PAUSE_RACE_RESUME:Int = 0
		Const PAUSE_RACE_RETRY:Int = 1
		Const PAUSE_RACE_SELECT_STAGE:Int = 2
		Const PAUSE_RACE_TO_TITLE:Int = 3
		Const PAUSE_RACE_OPTION:Int = 4
		Const PAUSE_RACE_INSTRUCTION:Int = 5
		
		Const PLANE_VELOCITY:Int = 2
		
		Const POSX:Byte = 0
		Const POSY:Byte = 1
		
		Const PRESS_DELAY:Byte = 5
		
		Const SAW:Byte = 0
		
		Const SONIC:Byte = 3
		
		Global STAFF_CENTER_Y:Int = (2 * SCREEN_HEIGHT / 7) ' Const
		
		Const STAFF_SHOW_TIME:Int = 45
		
		Const STAGE_NAME:Byte = 2
		Const STAGE_NAME_S:Byte = 5
		
		' States:
		Const STATE_GAME:Byte = 0
		Const STATE_PAUSE:Byte = 1
		Const STATE_STAGE_SELECT:Byte = 2
		Const STATE_SET_PARAM:Byte = 3
		'Const STATE_STAGE_PASS:Byte = 4 ' This one is public.
		Const STATE_STAGE_LOADING:Byte = 5
		Const STATE_PAUSE_INSTRUCTION:Byte = 6
		Const STATE_PAUSE_OPTION:Byte = 7
		Const STATE_PAUSE_RETRY:Byte = 8
		Const STATE_PAUSE_SELECT_STAGE:Byte = 9
		Const STATE_PAUSE_TO_TITLE:Byte = 10
		Const STATE_TIME_OVER_0:Byte = 11
		Const STATE_GAME_OVER_1:Byte = 12
		Const STATE_GAME_OVER_2:Byte = 13
		Const STATE_ALL_CLEAR:Byte = 14
		Const STATE_PRE_GAME_1:Byte = 15
		Const STATE_PRE_GAME_2:Byte = 16
		Const STATE_PRE_GAME_3:Byte = 17
		Const STATE_INTERRUPT:Byte = 18
		Const STATE_BP_CONTINUE_TRY:Byte = 19
		Const STATE_BP_TRY_PAYING:Byte = 20
		Const STATE_BP_REVIVE:Byte = 21
		Const STATE_BP_SHOP:Byte = 22
		Const STATE_BP_BUY:Byte = 23
		Const STATE_BP_TOOLS_MAX:Byte = 24
		Const STATE_BP_TOOLS_USE:Byte = 25
		Const STATE_BP_TOOLS_USE_ENSURE:Byte = 26
		Const STATE_PRE_GAME_1_TYPE2:Byte = 27
		Const STATE_GAME_OVER_PRE:Byte = 28
		Const STATE_PAUSE_SELECT_CHARACTER:Byte = 29
		Const STATE_PAUSE_OPTION_SOUND:Byte = 30
		Const STATE_PAUSE_OPTION_VIB:Byte = 31
		Const STATE_PAUSE_OPTION_KEY_CONTROL:Byte = 32
		Const STATE_PAUSE_OPTION_SP_SET:Byte = 33
		Const STATE_PAUSE_OPTION_HELP:Byte = 34
		Const STATE_STAGE_LOADING_TURN:Byte = 35
		Const STATE_PRE_GAME_0:Byte = 36
		Const STATE_PRE_GAME_0_TYPE2:Byte = 37
		Const STATE_PAUSE_OPTION_SOUND_VOLUMN:Byte = 38
		Const STATE_PAUSE_OPTION_SENSOR:Byte = 39
		Const STATE_PRE_ALL_CLEAR:Byte = 40
		Const STATE_CONTINUE_0:Byte = 41
		Const STATE_CONTINUE_1:Byte = 42
		Const STATE_SCORE_UPDATE:Byte = 43
		Const STATE_SCORE_UPDATE_ENSURE:Byte = 44
		Const STATE_SCORE_UPDATED:Byte = 45
		
		Const USE_NARRAW_TEXT_TIPS:Bool = False
		
		Const VX:Byte = 2
		Const VY:Byte = 3
		
		Const WHITE_BAR:Byte = 1
		
		' Global variable(s):
		Global IsSoundVolSet:Bool = False
		
		Global PAUSE_NORMAL_MODE:Int[]
		Global STAFF_STR:String[]
		
		Global currentBPItems:Int[] = BP_ITEMS_HIGH
		Global currentBPItemsNormalNum:Int[] = BP_ITEMS_HIGH_NORMAL_NUM
		
		Global staffStringForShow:String[][]
		
		Global tipsForShow:String[]
		Global tipsString:String[]
		
		Global numberDrawer:AnimationDrawer
		
		Global spCheckPointID:Int
		Global spReserveRingNum:Int
		Global spTimeCount:Int
		
		Global tool_x:Int = 40
		Global tool_y:Int = 17
	Public
		' Constant variable(s):
		Const STATE_STAGE_PASS:Byte = 4
		
		' Global variable(s):
		Global IsSingleDown:Bool = False
		Global IsSingleUp:Bool = False
		Global PreGame:Bool = False
		Global isBackFromSpStage:Bool = False
		Global isThroughGame:Bool = False
		
		Global stageInfoAniDrawer:AnimationDrawer
		Global guiAniDrawer:AnimationDrawer
		Global guiAnimation:Animation
		
		' Fields:
		Field state:Int
		
		Field BP_CONTINUETRY_MENU_HEIGHT:Int
		Field BP_CONTINUETRY_MENU_START_X:Int
		Field BP_CONTINUETRY_MENU_START_Y:Int
		Field BP_CONTINUETRY_MENU_WIDTH:Int
		
		Field overcnt:Int
	Private
		' Fields:
		Field interrupt_state:Int
		Field nextState:Int
		
		Field frameCount:Int
		Field gameoverCnt:Int
		Field cnt:Int
		Field count:Int
		
		Field degree:Int
		
		Field endingState:Byte
		
		Field pressDelay:Byte
		
		Field BP_IsFromContinueTry:Bool
		
		Field IsActNumDrawable:Bool
		Field IsPlayerNameDrawable:Bool
		Field isChanged:Bool
		Field isOptionChange:Bool
		Field isOptionDisFlag:Bool
		Field isSelectable:Bool
		Field isStateClassSwitch:Bool
		
		Field changing:Bool
		Field fadeChangeState:Bool
		Field outing:Bool
		Field optionReturnFlag:Bool
		
		Field pause_optionFlag:Bool
		Field pause_returnFlag:Bool
		
		Field TIPS:String[]
		
		Field TIPS_OFFSET_X:Int
		Field TIPS_TEXT_INTERVAL_Y:Int
		Field TIPS_TEXT_OFFSET_Y:Int
		Field TIPS_TITLE_OFFSET_Y:Int
		
		Field allclearFrame:Int
		
		Field birdInfo:Int[][]
		
		Field birdX:Int
		
		Field cloudCount:Int
		Field cloudInfo:Int[][]
		
		Field colorCursor:Int
		
		Field continueCursor:Int
		Field continueFrame:Int
		Field continueMoveBlackBarX:Int
		Field continueMoveNumberX:Int
		Field continueNumber:Int
		
		Field continueNumberState:Int
		Field continueStartEndFrame:Int
		
		Field continueNumberScale:Float
		Field continueScale:Float
		
		Field display:Int[][]
		
		Field itemOffsetX:Int
		
		Field loadingStartTime:Long
		
		Field movingTitleSpeedX:Int
		Field movingTitleX:Int
		
		Field offsetOfVolumeInterface:Int
		
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
		
		Field overtitleID:Int
		
		Field pauseOptionCursor:Int
		
		Field pause_item_cursor:Int
		Field pause_item_speed:Int
		Field pause_item_x:Int
		Field pause_item_y:Int
		Field pause_optionframe:Int
		Field pause_returnframe:Int
		Field pause_saw_speed:Int
		Field pause_saw_x:Int
		Field pause_saw_y:Int
		
		Field pausecnt:Int
		
		Field planeX:Int
		Field planeY:Int
		Field position:Int
		Field preScore:Int
		Field racemode_cnt:Int
		Field scoreUpdateCursor:Int
		Field showCount:Int
		Field stateForSet:Int
		Field stringCursor:Int
		
		Field exendBg1Image:MFImage
		Field exendBgImage:MFImage
		
		Field stageInfoClearAni:Animation[]
		
		Field birdDrawer:AnimationDrawer[]
		
		Field cloudDrawer:AnimationDrawer
		Field interruptDrawer:AnimationDrawer
		Field loadingDrawer:AnimationDrawer
		Field loadingWordsDrawer:AnimationDrawer
		Field planeDrawer:AnimationDrawer
		Field stageInfoActNumDrawer:AnimationDrawer
		Field stageInfoPlayerNameDrawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method Construct_GameState:Void() ' Final
			Self.state = STATE_STAGE_SELECT
			
			Self.overtitleID = 0
			
			Self.movingTitleX = 0
			Self.movingTitleSpeedX = 0
			
			Self.display = New Int[6][] ' NUM
			
			For Local i:= 0 Until Self.display.Length ' 6 ' NUM
				Self.display[i] = New Int[4]
			Next
			
			Self.loadingStartTime = 0
			
			Self.TIPS_OFFSET_X = 16
			Self.TIPS_TITLE_OFFSET_Y = 0
			
			Self.TIPS_TEXT_OFFSET_Y = (FONT_H)
			Self.TIPS_TEXT_INTERVAL_Y = (FONT_H)
			
			Self.racemode_cnt = 60
			
			Self.optionCursor = New Int[OPTION_ELEMENT_NUM]
			
			Self.isOptionDisFlag = False
			
			Self.optionslide_getprey = -1
			Self.optionslide_gety = -1
			
			Self.offsetOfVolumeInterface = 0
			
			Self.pressDelay = PRESS_DELAY
			
			Self.cloudInfo = New Int[CLOUD_NUM][]
			
			For Local i:= 0 Until CLOUD_NUM ' Self.cloudInfo.Length
				Self.cloudInfo[i] = New Int[3]
			Next
			
			Self.cloudCount = 0
			
			Self.birdInfo = New Int[BIRD_NUM][]
			
			For Local i:= 0 Until BIRD_NUM ' Self.birdInfo.Length
				Self.birdInfo[i] = New Int[3]
			Next
			
			Self.BP_IsFromContinueTry = False
			
			Self.BP_CONTINUETRY_MENU_START_X = FRAME_X
			Self.BP_CONTINUETRY_MENU_START_Y = Self.MORE_GAME_START_Y
			
			Self.BP_CONTINUETRY_MENU_WIDTH = FRAME_WIDTH
			Self.BP_CONTINUETRY_MENU_HEIGHT = Self.MORE_GAME_HEIGHT
			
			Self.overcnt = 0
			
			Self.IsPlayerNameDrawable = False ' True
			Self.IsActNumDrawable = False
			
			Self.state = STAGE_NAME_S
			
			' Magic number: 0
			loadingType = 0
			
			State.fadeInit(255, 0)
			
			fading = False
			
			isBackFromSpStage = False
			
			initTips()
		End
	Private
		' Functions:
		Function drawTouchKeyPause:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Function drawTouchKeyPauseOption:Void(g:MFGraphics)
			' Empty implementation.
		End
	Public
		' Functions:
		Function setPauseMenu:Void()
			PAUSE_NORMAL_MODE = PickValue(State.IsToolsCharge(), PAUSE_NORMAL_MODE_SHOP, PAUSE_NORMAL_MODE_NOSHOP)
		End
		
		' Constructor(s):
		Method New()
			Construct_GameState()
		End
		
		Method New(stateID:Int)
			Construct_GameState()
			
			Select (stateID)
				Case STATE_PAUSE_OPTION
					isBackFromSpStage = True
					isThroughGame = True
				Default
					' Nothing so far.
			End Select
		End
		
		' Methods:
		Method logic:Void()
			If (Self.state <> STATE_INTERRUPT) Then
				fadeStateLogic()
			EndIf
			
			Select (Self.state)
				Case STATE_GAME
					If (Not (StageManager.isStagePassTimePause() Or GameObject.IsGamePause)) Then
						PlayerObject.timeLogic()
					EndIf
					
					GameObject.logicObjects()
					
					StageManager.stageLogic()
					
					If (Key.buttonPress(Key.B_S2)) Then
						' Nothing so far.
					EndIf
					
					If ((Key.touchkey_pause.IsButtonPress() Or Key.press(Key.B_BACK)) And State.fadeChangeOver() And Not GameObject.player.isDead) Then
						If (Not StageManager.isStagePassTimePause()) Then
							PlayerObject.gamepauseInit()
							
							Self.state = STATE_PAUSE
							
							gamePauseInit()
							
							isDrawTouchPad = False
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_142)
							
							Key.init()
							
							GameObject.IsGamePause = True
							
							State.fadeInit_Modify(0, 102)
							
							SoundSystem.getInstance().stopBgm(False)
							SoundSystem.getInstance().stopLongSe()
							SoundSystem.getInstance().stopLoopSe()
							
							Self.pauseoptionCursor = GlobalResource.soundConfig
							
							Key.touchgamekeyClose()
							Key.touchkeygameboardClose()
							Key.touchkeyboardInit()
						EndIf
					ElseIf (Not (Key.press(Key.B_0) Or Key.press(Key.B_PO) Or Not Key.press(Key.B_S1) Or Not State.IsToolsCharge() Or GameObject.stageModeState <> GameObject.STATE_NORMAL_MODE Or GameObject.player.isDead Or StageManager.isStagePassTimePause())) Then
						PlayerObject.gamepauseInit()
						
						Self.state = STATE_BP_TOOLS_USE
						
						Self.tooltipY = TOOL_TIP_Y_DES_2
						
						Key.init()
						
						GameObject.IsGamePause = True
						
						State.fadeInit(0, 102)
						
						SoundSystem.getInstance().stopBgm(False)
						
						Self.pauseoptionCursor = GlobalResource.soundConfig
						
						Key.touchgamekeyClose()
						Key.touchkeygameboardClose()
						Key.touchkeyboardInit()
					EndIf
					
					If (StageManager.isStagePass()) Then
						Self.state = STATE_STAGE_PASS
						
						isDrawTouchPad = False
						
						If (StageManager.IsStageEnd()) Then
							PlayerObject.isbarOut = True
							
							Self.state = STATE_PRE_ALL_CLEAR
							
							State.setFadeColor(MapManager.END_COLOR)
							State.fadeInit(0, 255)
						EndIf
					Else
						PlayerObject.initMovingBar()
						
						Self.cnt = 0
						
						PlayerObject.IsStarttoCnt = False
						PlayerObject.IsDisplayRaceModeNewRecord = False
						
						StageManager.IsCalculateScore = True
					EndIf
					
					If (StageManager.isStageRestart()) Then
						Self.state = STATE_STAGE_LOADING
						
						loadingType = 0
						
						Key.touchgamekeyClose()
						Key.touchkeygameboardClose()
						Key.touchkeyboardInit()
						
						initTips()
						
						State.fadeInit(255, 0)
						
						Return
					EndIf
					
					If (StageManager.isStageGameover()) Then
						If (State.IsToolsCharge() And PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
							BP_gotoRevive()
						Else
							gotoGameOver()
						EndIf
					EndIf
					
					If (StageManager.isStageTimeover()) Then
						IsTimeOver = True
						
						Self.overcnt = 0
						
						Self.state = STATE_GAME_OVER_PRE
						
						Self.movingTitleX = (SCREEN_WIDTH + 56)
						
						If (StageManager.isStageGameover()) Then
							IsTimeOver = False
							IsGameOver = True
							
							SoundSystem.getInstance().stopBgm(True)
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_GAMEOVER, False)
						Else
							Self.overtitleID = 136 ' Def.TOUCH_HELP_HEIGHT
							
							SoundSystem.getInstance().playSe(SoundSystem.BGM_SP_TOTAL_CLEAR)
						EndIf
						
						Key.touchgamekeyClose()
						Key.touchkeygameboardClose()
						Key.touchkeyboardInit()
					EndIf
					
					If (IsGameOver) Then
						Self.overtitleID = 78
					EndIf
					
					If (Self.overtitleID = 78) Then
						Self.movingTitleSpeedX = 24
					ElseIf (Self.overtitleID = 136) Then ' Def.TOUCH_HELP_HEIGHT
						Self.movingTitleSpeedX = 8
					EndIf
				Case STATE_PAUSE
					gamePauseLogic()
				Case STATE_STAGE_PASS
					stagePassLogic()
					
					If (StageManager.getStageID() <> 12 Or StageManager.isGoingToExtraStage()) Then
						GameObject.logicObjects()
					EndIf
					
					StageManager.stageLogic()
					
					If (StageManager.isStagePassTimePause() And StageManager.IsCalculateScore) Then
						StageManager.IsCalculateScore = False
						
						PlayerObject.calculateScore()
					EndIf
				Case STATE_STAGE_LOADING
					PlayerObject.isTerminal = False
					
					If (SoundSystem.getInstance().bgmPlaying()) Then
						SoundSystem.getInstance().stopBgm(False)
					EndIf
					
					PreGame = True
					
					If (loadingEnd()) Then
						Animation.closeAnimationDrawer(Self.loadingWordsDrawer)
						Self.loadingWordsDrawer = Null
						
						Animation.closeAnimationDrawer(Self.loadingDrawer)
						Self.loadingDrawer = Null
						
						'System.gc()
						
						If (isThroughGame) Then
							isThroughGame = False
						EndIf
						
						If (Not (isBackFromSpStage Or GameObject.stageModeState = GameObject.STATE_RACE_MODE)) Then
							StageManager.characterFromGame = PlayerObject.getCharacterID()
							StageManager.stageIDFromGame = StageManager.getStageID()
							
							StageManager.saveStageRecord()
						EndIf
						
						StageManager.isSaveTimeModeScore = False
						
						MapManager.setFocusObj(GameObject.player)
						
						GameObject.player.headInit()
						
						GameObject.bossFighting = False
						GameObject.isUnlockCage = False
						
						EnemyObject.isBossEnter = False
						
						If (isBackFromSpStage) Then
							PlayerObject.initSpParam(spReserveRingNum, spCheckPointID, spTimeCount)
							
							isBackFromSpStage = False
						EndIf
						
						If (Not (StageManager.getStageID() = 10 And PlayerObject.isDeadLineEffect)) Then
							PlayerObject.isDeadLineEffect = False
						EndIf
						
						Key.initSonic()
						
						IsGameOver = False
						
						Self.state = STATE_PRE_GAME_0
						
						initStageIntroType1Conf()
						initStageInfoClearRes()
						
						PlayerObject.clipMoveInit(0, (SCREEN_HEIGHT / 2) - 10, 20, SCREEN_WIDTH, 60) ' Shr 1
						
						Key.touchkeypauseInit()
						Key.touchkeyboardClose()
						Key.touchkeygameboardInit()
						
						StageManager.stagePassInit()
					EndIf
				Case STATE_PAUSE_INSTRUCTION
					helpLogic()
					
					If (Key.press(Key.B_S2)) Then
						' Nothing so far.
					EndIf
					
					If (Key.press(Key.B_BACK)) Then
						Self.state = STATE_PAUSE
						
						GameObject.IsGamePause = True
						
						Key.clear()
						
						Self.isOptionDisFlag = False
					EndIf
				Case STATE_PAUSE_OPTION
					optionLogic()
					
					If (Key.press(Key.B_S2)) Then
						' Nothing so far.
					EndIf
					
					If (Key.press(Key.B_BACK)) Then
						Self.state = STATE_PAUSE
						
						GameObject.IsGamePause = True
						
						Key.clear()
						
						SoundSystem.getInstance().stopBgm(False)
						
						State.fadeInit_Modify(192, 102)
					EndIf
				Case STATE_PAUSE_RETRY
					retryStageLogic()
				Case STATE_PAUSE_SELECT_STAGE
					pausetoSelectStageLogic()
				Case STATE_PAUSE_TO_TITLE
					pausetoTitleLogic()
				Case STATE_TIME_OVER_0
					If (Self.movingTitleX - Self.movingTitleSpeedX < (SCREEN_WIDTH / 2)) Then ' Shr 1
						Self.movingTitleX = SCREEN_WIDTH
						
						State.fadeInit(0, 255)
						
						Self.state = STATE_GAME_OVER_1
						
						Return
					EndIf
					
					Self.movingTitleX -= Self.movingTitleSpeedX
				Case STATE_GAME_OVER_1
					If (State.fadeChangeOver()) Then
						Self.state = STATE_GAME_OVER_2
						
						Self.gameoverCnt = 0
					EndIf
				Case STATE_GAME_OVER_2
					If (State.fadeChangeOver()) Then
						If (IsGameOver) Then
							If ((SoundSystem.getInstance().bgmPlaying() Or GlobalResource.soundSwitchConfig = 0) And Not (GlobalResource.soundSwitchConfig = 0 And Self.gameoverCnt = 128)) Then
								Self.gameoverCnt += 1
							Else
								If (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
									Standard2.splashinit(True)
									
									setStateWithFade(State.STATE_TITLE)
								ElseIf (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
									setStateWithFade(State.STATE_SELECT_RACE_STAGE)
								EndIf
								
								Key.touchkeyboardClose()
								Key.touchkeyboardInit()
							EndIf
						EndIf
						
						If (Not IsTimeOver) Then
							Return
						EndIf
						
						If (Self.gameoverCnt = 128) Then
							Self.state = STATE_STAGE_LOADING
							
							loadingType = 0
							
							StageManager.setStageRestart()
							StageManager.checkPointTime = 0
							
							State.fadeInit(255, 0)
							
							initTips()
							
							Return
						EndIf
						
						Self.gameoverCnt += 1
					EndIf
				Case STATE_ALL_CLEAR
					If (State.fadeChangeOver()) Then
						Self.allclearFrame += 1
						
						If (Self.allclearFrame > 20) Then
							stagePassLogic()
						EndIf
					EndIf
				Case STATE_PRE_GAME_1
					If (Self.frameCount < 10) Then ' LOADING_TIME_LIMIT
						Self.frameCount += 1
					Else
						releaseTips()
						
						Self.state = STATE_PRE_GAME_2
						
						Key.touchanykeyInit()
						
						State.fadeInit(204, 0)
					EndIf
					
					If (Self.frameCount < 1 Or Self.frameCount > 3) Then
						Self.display[0][2] = False
					Else
						Self.display[0][2] = 30
					EndIf
					
					If (Self.frameCount < 4 Or Self.frameCount > 7) Then
						Self.display[1][2] = 0
					Else
						Self.display[1][2] = -96
					EndIf
					
					If (Self.frameCount < 8 Or Self.frameCount > 10) Then ' LOADING_TIME_LIMIT
						Self.display[2][2] = 0
					Else
						Self.display[2][2] = -104
					EndIf
					
					If (Self.frameCount < 6 Or Self.frameCount > 7) Then
						Self.display[5][2] = 0
					Else
						Self.display[5][2] = -104
					EndIf
					
					If (Self.frameCount = 7) Then
						Self.IsPlayerNameDrawable = True
						Self.stageInfoPlayerNameDrawer.restart()
					EndIf
					
					If (Self.frameCount = 9) Then
						Self.IsActNumDrawable = True
						Self.stageInfoActNumDrawer.restart()
					EndIf
					
					Local iArr:Int[]
					
					iArr = Self.display[0]
					
					If ((iArr[0] + iArr[2]) > 0) Then
						iArr[0] = 0
					Else
						iArr[0] += iArr[2]
					EndIf
					
					iArr[1] += iArr[3]
					
					iArr = Self.display[1]
					iArr[0] += Self.display[1][2]
					
					If (Self.display[1][0] < 0) Then
						Self.display[1][0] = 0
					EndIf
					
					iArr = Self.display[1]
					iArr[1] += Self.display[1][3]
					
					iArr = Self.display[2]
					iArr[0] += Self.display[2][2]
					
					While (Self.display[2][0] < 0)
						iArr = Self.display[2]
						iArr[0] += STAGE_MOVE_DIRECTION
					Wend
					
					iArr = Self.display[2]
					iArr[0] Mod= STAGE_MOVE_DIRECTION
					
					iArr = Self.display[2]
					iArr[1] += Self.display[2][3]
					
					iArr = Self.display[4]
					iArr[0] += Self.display[4][2]
					
					If (Self.display[5][0] + Self.display[5][2] < SCREEN_WIDTH - 112) Then ' Def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1
						Self.display[5][0] = SCREEN_WIDTH - 112 ' Def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1
					Else
						iArr = Self.display[5]
						iArr[0] += Self.display[5][2]
					EndIf
					
					If (Self.state = STATE_PRE_GAME_2) Then
						Self.frameCount = 0
					EndIf
					
					GameObject.setNoInput()
					GameObject.logicObjects()
				Case STATE_PRE_GAME_2
					If (Self.frameCount < 48) Then
						Self.frameCount += 1
					Else
						Self.state = STATE_PRE_GAME_3
						
						Key.clear()
						Key.touchanykeyClose()
					EndIf
					
					Local iArr:Int[]
					
					Self.display[2][2] = -7
					Self.display[4][3] = 0
					
					iArr = Self.display[0]
					iArr[0] += Self.display[0][2]
					iArr = Self.display[0]
					iArr[1] += Self.display[0][3]
					iArr = Self.display[1]
					iArr[0] += Self.display[1][2]
					iArr = Self.display[1]
					iArr[1] += Self.display[1][3]
					iArr = Self.display[2]
					iArr[0] += Self.display[2][2]
					
					iArr = Self.display[2]
					
					While (iArr[0] < 0)
						iArr[0] += STAGE_MOVE_DIRECTION
					Wend
					
					iArr[0] Mod= STAGE_MOVE_DIRECTION
					
					iArr[1] += iArr[3]
					
					iArr = Self.display[3]
					
					iArr[0] += Self.display[3][2]
					iArr[1] += Self.display[3][3]
					
					iArr = Self.display[4]
					
					iArr[0] += Self.display[4][2]
					iArr[1] += Self.display[4][3]
					
					iArr = Self.display[5]
					
					iArr[0] += Self.display[5][2]
					
					If (Key.press(Key.B_SEL)) Then
						Self.state = STATE_PRE_GAME_3
						
						Key.clear()
						Key.touchanykeyClose()
						
						State.fadeInit(State.getCurrentFade(), 0)
					EndIf
					
					If (Self.state = STATE_PRE_GAME_3) Then
						Self.frameCount = 0
					EndIf
					
					GameObject.setNoInput()
					GameObject.logicObjects()
				Case STATE_PRE_GAME_3
					If (Self.frameCount < 3) Then
						Self.frameCount += 1
					Else
						PlayerObject.isNeedPlayWaterSE = True
						
						Self.state = STATE_GAME
						
						PreGame = False
					EndIf
					
					Self.display[0][2] = -30
					Self.display[1][2] = -97
					Self.display[2][2] = -105
					Self.display[5][2] = -105
					Self.display[3][3] = -75
					Self.display[4][3] = 45
					
					Local iArr:Int[]
					
					iArr = Self.display[0]
					
					iArr[0] += Self.display[0][2]
					iArr[1] += Self.display[0][3]
					
					iArr = Self.display[1]
					
					iArr[0] += Self.display[1][2]
					iArr[1] += Self.display[1][3]
					
					iArr = Self.display[2]
					
					iArr[0] += Self.display[2][2]
					
					iArr = Self.display[5]
					
					iArr[0] += Self.display[5][2]
					
					iArr = Self.display[2]
					
					iArr[1] += Self.display[2][3]
					
					iArr = Self.display[3]
					
					iArr[0] += Self.display[3][2]
					iArr[1] += Self.display[3][3]
					
					iArr = Self.display[4]
					
					iArr[0] += Self.display[4][2]
					iArr[1] += Self.display[4][3]
					
					If (Self.state = STATE_GAME) Then
						isDrawTouchPad = True
						
						Self.frameCount = 0
						
						State.fadeInit(102, 0)
						State.setFadeOver()
					EndIf
					
					GameObject.setNoInput()
					GameObject.logicObjects()
				Case STATE_INTERRUPT
					interruptLogic()
				Case STATE_PRE_GAME_1_TYPE2
					If (Self.frameCount < 18) Then
						Self.frameCount += 1
					Else
						releaseTips()
						
						Self.state = STATE_PRE_GAME_2
						
						Key.touchanykeyInit()
						
						State.fadeInit(204, 0)
					EndIf
					
					If (Self.frameCount < 9 Or Self.frameCount > 11) Then
						Self.display[0][2] = False
					Else
						Self.display[0][2] = 30
					EndIf
					
					If (Self.frameCount < 12 Or Self.frameCount > 15) Then
						Self.display[1][3] = False
					Else
						Self.display[1][3] = 28
					EndIf
					
					If (Self.frameCount < 16 Or Self.frameCount > 18) Then
						Self.display[2][2] = 0
					Else
						Self.display[2][2] = -104
					EndIf
					
					If (Self.frameCount < 14 Or Self.frameCount > 15) Then
						Self.display[5][2] = 0
					Else
						Self.display[5][2] = -104
					EndIf
					
					If (Self.frameCount = 15) Then
						Self.IsPlayerNameDrawable = True
						Self.stageInfoPlayerNameDrawer.restart()
					EndIf
					
					If (Self.frameCount = 17) Then
						Self.IsActNumDrawable = True
						Self.stageInfoActNumDrawer.restart()
					EndIf
					
					Local iArr:Int[]
					
					iArr = Self.display[0]
					
					If (Self.display[0][0] + Self.display[0][2] > 0) Then
						Self.display[0][0] = 0
					Else
						iArr[0] += Self.display[0][2]
					EndIf
					
					iArr[1] += Self.display[0][3]
					
					iArr = Self.display[1]
					iArr[0] += Self.display[1][2]
					
					If (Self.display[1][0] < 0) Then
						Self.display[1][0] = 0
					EndIf
					
					If (Self.display[1][1] + Self.display[1][3] > (SCREEN_HEIGHT / 2) + 48) Then ' Shr 1
						Self.display[1][1] = (SCREEN_HEIGHT / 2) + 48 ' Shr 1
					Else
						iArr = Self.display[1]
						iArr[1] += Self.display[1][3]
					EndIf
					
					iArr = Self.display[2]
					
					iArr[0] += Self.display[2][2]
					
					While (Self.display[2][0] < 0)
						iArr[0] += STAGE_MOVE_DIRECTION
					Wend
					
					iArr[0] Mod= STAGE_MOVE_DIRECTION
					iArr[1] += Self.display[2][3]
					
					iArr = Self.display[4]
					
					iArr[0] += Self.display[4][2]
					
					If (Self.display[5][0] + Self.display[5][2] < SCREEN_WIDTH - 112) Then ' Def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1
						Self.display[5][0] = SCREEN_WIDTH - 112 ' Def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1
					Else
						iArr = Self.display[5]
						
						iArr[0] += Self.display[5][2]
					EndIf
					
					If (Self.state = STATE_PRE_GAME_2) Then
						Self.frameCount = 0
					EndIf
					
					GameObject.setNoInput()
					GameObject.logicObjects()
				Case STATE_GAME_OVER_PRE
					Self.overcnt += 1
					
					If (Self.overcnt = 20) Then
						isDrawTouchPad = False
					EndIf
					
					If (Self.overtitleID = 78) Then
						If (Self.overcnt = 36) Then
							Self.state = STATE_CONTINUE_0
						EndIf
					ElseIf (Self.overtitleID = 136 And Self.overcnt = 28) Then ' Def.TOUCH_HELP_HEIGHT
						Self.state = STATE_TIME_OVER_0
					EndIf
				Case STATE_PAUSE_SELECT_CHARACTER
					pausetoSelectCharacterLogic()
				Case STATE_PAUSE_OPTION_SOUND
					pauseOptionSoundLogic()
				Case STATE_PAUSE_OPTION_VIB
					pauseOptionVibrationLogic()
				Case STATE_PAUSE_OPTION_SP_SET
					pauseOptionSpSetLogic()
				Case STATE_PAUSE_OPTION_HELP
					helpLogic()
					
					If ((Key.press(Key.B_BACK) Or (Key.touchhelpreturn.IsButtonPress() And Self.returnPageCursor = 1)) And State.fadeChangeOver()) Then
						changeStateWithFade(STATE_PAUSE_OPTION)
						
						GameObject.IsGamePause = True
						
						Self.isOptionDisFlag = False
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_107)
						
						Self.returnCursor = 0
					EndIf
				Case STATE_STAGE_LOADING_TURN
					If (State.fadeChangeOver()) Then
						Self.state = STATE_STAGE_LOADING
						
						MapManager.closeMap()
						
						initTips()
					EndIf
				Case STATE_PRE_GAME_0
					If (State.fadeChangeOver()) Then
						Self.state = STATE_PRE_GAME_1
						
						State.fadeInit(255, 204)
					EndIf
				Case STATE_PRE_GAME_0_TYPE2
					If (State.fadeChangeOver()) Then
						Self.state = STATE_PRE_GAME_1_TYPE2
						
						State.fadeInit(255, 204)
					EndIf
				Case STATE_PAUSE_OPTION_SOUND_VOLUMN
					Select (soundVolumnLogic())
						Case 2
							' Go back to the main "options menu":
							State.fadeInit(190, 0)
							
							Self.state = STATE_PAUSE_OPTION
							
							Self.returnCursor = 0
						Default
							' Nothing so far.
					End Select
				Case STATE_PAUSE_OPTION_SENSOR
					Local cleanup:Bool = True
					
					Select (spSenorSetLogic())
						Case 1
							GlobalResource.sensorConfig = 0
						Case 2
							GlobalResource.sensorConfig = 1
						Case 3
							' Nothing so far.
						Case STATE_STAGE_PASS
							GlobalResource.sensorConfig = 2
						Default
							cleanup = False
					End Select
					
					If (cleanup) Then
						State.fadeInit(190, 0)
						
						Self.state = STATE_PAUSE_OPTION
						
						Self.returnCursor = 0
					EndIf
				Case STATE_PRE_ALL_CLEAR
					If (State.fadeChangeOver()) Then
						PlayerObject.calculateScore()
						
						Self.state = STATE_ALL_CLEAR
						
						State.fadeInit(255, 0)
						
						' This is necessary in case a call to 'createImage' throws an exception:
						Self.exendBgImage = Null
						Self.exendBg1Image = Null
						
						Self.exendBgImage = MFImage.createImage("/animation/ending/ed_ex_moon_bg.png")
						Self.exendBg1Image = MFImage.createImage("/animation/ending/ed_ex_forest.png")
						
						SoundSystem.getInstance().stopBgm(False)
						
						Self.allclearFrame = 0
					EndIf
				Case STATE_CONTINUE_0
					If (Self.movingTitleX - Self.movingTitleSpeedX < (SCREEN_WIDTH / 2)) Then ' Shr 1
						Self.movingTitleX = SCREEN_WIDTH
						
						State.fadeInit(0, 102)
						
						continueInit()
						
						Return
					EndIf
					
					Self.movingTitleX -= Self.movingTitleSpeedX
				Case STATE_CONTINUE_1
					Self.continueFrame += 1
					
					If (Self.continueFrame <= 5) Then
						Self.continueScale -= 0.2
					ElseIf (Self.continueFrame <= 10) Then
						Self.continueScale += 0.2
						
						If (Self.continueScale > 1.0) Then
							Self.continueScale = 1.0
						EndIf
						
					ElseIf (Self.continueFrame > 10) Then
						If (Self.continueMoveBlackBarX + (SCREEN_WIDTH / 6) > 0) Then
							Self.continueMoveBlackBarX = 0
						Else
							Self.continueMoveBlackBarX += (SCREEN_WIDTH / 6)
						EndIf
						
						If (Self.continueMoveBlackBarX = 0) Then
							If (Self.continueNumberState = 0) Then
								Self.continueMoveNumberX += (SCREEN_WIDTH / 12)
								
								If (Self.continueMoveNumberX >= (SCREEN_WIDTH / 2)) Then ' Shr 1
									Self.continueMoveNumberX = (SCREEN_WIDTH / 2) ' Shr 1
									Self.continueNumberState = 1
									Self.continueNumberScale = 2.0
								EndIf
							ElseIf (Self.continueNumberState = 1) Then
								Self.continueNumberScale -= 0.125f
								
								If (Self.continueNumberScale <= 1.0) Then
									Self.continueNumberScale = 1.0
									Self.continueNumberState = 2
								EndIf
							ElseIf (Self.continueNumberState = 2) Then
								Self.continueMoveNumberX += (SCREEN_WIDTH / 12)
								
								If (Self.continueMoveNumberX >= (SCREEN_WIDTH + 30)) Then
									Self.continueMoveNumberX = -30
									Self.continueNumberState = 0
									Self.continueNumber -= 1
									
									If (Self.continueNumber = -1) Then
										continueEnd()
									EndIf
								EndIf
							ElseIf (Self.continueNumberState = 3) Then
								If (Self.continueFrame = (Self.continueStartEndFrame + 3)) Then
									State.fadeInit(102, 255)
								ElseIf (Self.continueFrame > (Self.continueStartEndFrame + 3) And State.fadeChangeOver()) Then
									If (Self.continueScale - 0.2f > 0.0) Then
										Self.continueScale -= 0.2f
									Else
										Self.continueScale = 0.0
									EndIf
									
									If (Self.continueScale = 0.0) Then
										Standard2.splashinit(True)
										
										State.setState(State.STATE_TITLE)
									EndIf
								EndIf
							ElseIf (Self.continueNumberState = 4) Then
								Self.continueMoveNumberX += (SCREEN_WIDTH / 12)
								
								If (Self.continueMoveNumberX >= (SCREEN_WIDTH / 2)) Then ' Shr 1
									Self.continueMoveNumberX = (SCREEN_WIDTH / 2) ' Shr 1
									Self.continueNumberState = 4
									Self.continueNumberScale = 2.0
								EndIf
							ElseIf (Self.continueNumberState = 4) Then
								Self.continueNumberScale -= 0.125f
								
								If (Self.continueNumberScale <= 1.0) Then
									Self.continueNumberScale = 1.0
									Self.continueNumberState = 4
								EndIf
							ElseIf (Self.continueNumberState = 4) Then
								Self.continueMoveNumberX += (SCREEN_WIDTH / 12)
								
								If (Self.continueMoveNumberX >= (SCREEN_WIDTH + 30)) Then
									Self.state = STATE_STAGE_LOADING
									
									loadingType = 0
									
									initTips()
									
									PlayerObject.resetGameParam()
								EndIf
							EndIf
							
							If (Self.continueNumberState < 3) Then
								If (Key.touchgameoveryres.Isin() And Key.touchgameover.IsClick()) Then
									Self.continueCursor = 0
								EndIf
								
								If (Key.touchgameoverno.Isin() And Key.touchgameover.IsClick()) Then
									Self.continueCursor = 1
								EndIf
								
								If (Key.touchgameoveryres.IsButtonPress() And Self.continueCursor = 0) Then
									Self.continueNumberState = 4
									
									Self.continueMoveNumberX = -30
									Self.continueNumberScale = 1.0
									
									SoundSystem.getInstance().playSe(SoundSystem.SE_106)
								EndIf
								
								If (Key.touchgameoverno.IsButtonPress() And Self.continueCursor = 1) Then
									continueEnd()
									
									SoundSystem.getInstance().playSe(SoundSystem.SE_107)
								EndIf
							EndIf
						EndIf
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method draw:Void(g:MFGraphics)
			' Magic numbers: 11, 14 (Font IDs)
			Select (Self.state)
				Case STATE_PAUSE_OPTION_HELP
					g.setFont(11)
				Default
					g.setFont(14)
			End Select
			
			Select (Self.state)
				Case STATE_STAGE_SELECT
					StageManager.draw(g)
				Case STATE_SET_PARAM, STATE_BP_CONTINUE_TRY, STATE_BP_TRY_PAYING, STATE_BP_REVIVE, STATE_BP_SHOP, STATE_BP_BUY, STATE_BP_TOOLS_MAX, STATE_SCORE_UPDATE, STATE_SCORE_UPDATE_ENSURE, STATE_SCORE_UPDATED
					' Nothing so far.
				Case STATE_STAGE_LOADING
					State.drawFadeSlow(g)
					drawLoading(g)
				Case STATE_PAUSE_INSTRUCTION
					helpDraw(g)
				Case STATE_PAUSE_OPTION
					optionDraw(g)
				Case STATE_GAME_OVER_2
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					drawTimeOver(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28)
				Case STATE_ALL_CLEAR
					MyAPI.drawImage(g, Self.exendBgImage, SCREEN_WIDTH Shr 1, 0, 17)
					MyAPI.drawImage(g, Self.exendBg1Image, SCREEN_WIDTH Shr 1, 80, 17)
					
					State.drawFade(g)
					
					If (State.fadeChangeOver() And Self.allclearFrame > 20) Then
						PlayerObject.stagePassDraw(g)
					EndIf
				Case STATE_INTERRUPT
					interruptDraw(g)
				Case STATE_PAUSE_OPTION_SOUND
					optionDraw(g)
					
					itemsSelect2Draw(g, 35, 36)
				Case STATE_PAUSE_OPTION_VIB
					optionDraw(g)
					
					itemsSelect2Draw(g, 35, 36)
				Case STATE_PAUSE_OPTION_KEY_CONTROL
					optionDraw(g)
				Case STATE_PAUSE_OPTION_SP_SET
					optionDraw(g)
					
					itemsSelect2Draw(g, 37, 38)
				Case STATE_PAUSE_OPTION_HELP
					helpDraw(g)
				Case STATE_PAUSE_OPTION_SOUND_VOLUMN
					optionDraw(g)
					
					soundVolumnDraw(g)
				Case STATE_PAUSE_OPTION_SENSOR
					optionDraw(g)
					
					spSenorSetDraw(g)
				Default
					If (GameObject.IsGamePause) Then
						AnimationDrawer.setAllPause(True)
					EndIf
					
					If (Not (Self.interrupt_state = STATE_STAGE_LOADING Or Self.interrupt_state = STATE_ALL_CLEAR Or Self.interrupt_state = STATE_STAGE_PASS)) Then
						drawGame(g)
					EndIf
					
					If (GameObject.IsGamePause) Then
						AnimationDrawer.setAllPause(False)
					EndIf
					
					If (Not (Self.state = STATE_PRE_GAME_1 Or Self.state = STATE_PRE_GAME_2 Or Self.state = STATE_PRE_GAME_3 Or Self.state = STATE_PRE_GAME_1_TYPE2)) Then
						PlayerObject.drawGameUI(g)
						
						drawGameSoftKey(g)
					EndIf
					
					If (Self.state = STATE_PAUSE) Then
						State.drawFade(g)
						
						drawGamePause(g)
					EndIf
					
					If (Self.state = STATE_BP_TOOLS_USE) Then
						State.drawFade(g)
						
						BP_toolsuseDraw(g)
					EndIf
					
					If (Self.state = STATE_BP_TOOLS_USE_ENSURE) Then
						State.drawFade(g)
						
						BP_ensureToolsUseDraw(g)
					EndIf
					
					If (Self.state = STATE_PRE_GAME_1 Or Self.state = STATE_PRE_GAME_1_TYPE2 Or Self.state = STATE_PRE_GAME_2 Or Self.state = STATE_PRE_GAME_3) Then
						If (Self.state = STATE_PRE_GAME_1 Or Self.state = STATE_PRE_GAME_1_TYPE2) Then
							State.drawFadeInSpeed(g, PAUSE_RACE_OPTION)
						ElseIf (Self.state = STATE_PRE_GAME_2) Then
							State.drawFadeInSpeed(g, 12)
						Else
							State.drawFade(g)
						EndIf
						
						drawSaw(g, Self.display[0][0], Self.display[0][1])
						
						drawWhiteBar(g, Self.display[1][0], Self.display[1][1])
						
						drawTinyStageName(g, StageManager.getStageID(), Self.display[5][0], Self.display[5][1])
						
						g.setClip(Self.display[1][0], Self.display[1][1] - 10, SCREEN_WIDTH, 20)
						
						drawHugeStageName(g, StageManager.getStageID(), Self.display[2][0], Self.display[2][1])
						
						g.setClip(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
						
						drawSonic(g, Self.display[3][0], Self.display[3][1])
						
						drawAction(g, StageManager.getStageID(), Self.display[4][0], Self.display[4][1])
					EndIf
					
					If (Self.state = STATE_PRE_GAME_0 Or Self.state = STATE_PRE_GAME_0_TYPE2) Then
						g.setColor(0)
						
						MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
						
						If (loadingType = 2) Then
							g.setColor(MapManager.END_COLOR)
							
							MyAPI.fillRect(g, 0, ((SCREEN_HEIGHT Shr 1) - 36) - 10, SCREEN_WIDTH, 20)
						EndIf
					EndIf
					
					If (Self.state = STATE_PAUSE_RETRY) Then
						drawGamePause(g)
						
						State.drawFade(g)
						
						SecondEnsurePanelDraw(g, 15)
					EndIf
					
					If (Self.state = STATE_PAUSE_SELECT_STAGE) Then
						drawGamePause(g)
						
						State.drawFade(g)
						
						SecondEnsurePanelDraw(g, 17)
					EndIf
					
					If (Self.state = STATE_PAUSE_SELECT_CHARACTER) Then
						drawGamePause(g)
						
						State.drawFade(g)
						
						SecondEnsurePanelDraw(g, 16)
					EndIf
					
					If (Self.state = STATE_PAUSE_TO_TITLE) Then
						drawGamePause(g)
						
						State.drawFade(g)
						
						SecondEnsurePanelDraw(g, 18)
					EndIf
					
					If (Self.state = STATE_TIME_OVER_0 Or Self.state = STATE_CONTINUE_0) Then
						drawTimeOver(g, Self.movingTitleX, (SCREEN_HEIGHT / 2) - 28) ' Shr 1
					EndIf
					
					If (Self.state = STATE_CONTINUE_1) Then
						State.drawFade(g)
						
						drawGameOver(g)
					EndIf
					
					If (Self.state = STATE_GAME_OVER_1) Then
						State.drawFade(g)
						
						drawTimeOver(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2) - 28) ' Shr 1
					EndIf
					
					If (Self.state = STATE_PRE_ALL_CLEAR) Then
						State.drawFade(g)
					EndIf
					
					If (Self.state = STATE_STAGE_PASS) Then
						PlayerObject.stagePassDraw(g)
					EndIf
					
					If (Self.state = STATE_STAGE_LOADING_TURN) Then
						State.drawFade(g)
						
						If (loadingType = 2) Then
							g.setColor(MapManager.END_COLOR)
							MyAPI.fillRect(g, 0, ((SCREEN_HEIGHT / 2) - 36) - 10, SCREEN_WIDTH, 20) ' Shr 1
						EndIf
					EndIf
			End Select
			
			If (isDrawTouchPad) Then
				If (Not (Self.state = STATE_STAGE_LOADING Or Self.state = STATE_ALL_CLEAR)) Then
					drawTouchKeyDirect(g)
				EndIf
				
				If (Self.state = STATE_ALL_CLEAR And Self.endingState > 3) Then
					drawTouchKeyDirect(g)
				EndIf
			EndIf
		End
		
		Method drawGame:Void(g:MFGraphics)
			g.setColor(MapManager.END_COLOR)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			If (Not GameObject.IsGamePause) Then
				MapManager.gameFrame += 1
			EndIf
			
			BackGroundManager.frame = MapManager.gameFrame
			
			MapManager.drawBack(g)
			
			GameObject.drawObjectBeforeSonic(g)
			GameObject.drawPlayer(g)
			
			Effect.draw(g, 1)
			
			GameObject.drawObjects(g)
			
			GameObject.player.drawSheild1(g)
			
			MapManager.drawFront(g)
			
			GameObject.player.draw2(g)
			
			GameObject.player.drawSheild2(g)
			
			GameObject.drawObjectAfterEveryThing(g)
			
			MapManager.drawFrontNatural(g)
			
			Effect.draw(g, 0)
			
			MapManager.drawMapFrame(g)
			
			RocketSeparateEffect.getInstance().draw(g)
		End
		
		Method drawGameSoftKey:Void(g:MFGraphics)
			If (Self.state <> STATE_PAUSE And Self.state <> STATE_PAUSE_TO_TITLE And Self.state <> STATE_PAUSE_RETRY And Self.state <> VISIBLE_OPTION_ITEMS_NUM And Self.state <> STATE_PAUSE_SELECT_CHARACTER And Self.state <> STATE_BP_TOOLS_USE And Self.state <> STATE_BP_TOOLS_USE_ENSURE And Self.state <> STATE_CONTINUE_0 And Self.state <> STATE_CONTINUE_1 And Self.state <> STATE_TIME_OVER_0 And Self.state <> STATE_GAME_OVER_1 And Self.state <> STATE_GAME_OVER_2 And Not StageManager.isStagePassTimePause()) Then
				If (Not GameObject.player.isDead) Then
					State.drawSoftKeyPause(g)
				EndIf
				
				If (Self.state <> STATE_BP_TOOLS_USE And Self.state <> STATE_BP_TOOLS_USE_ENSURE And Self.state <> STATE_PAUSE And Self.state <> STATE_PAUSE_INSTRUCTION And Self.state <> STATE_PAUSE_OPTION And Self.state <> STATE_PAUSE_RETRY And Self.state <> VISIBLE_OPTION_ITEMS_NUM And Self.state <> STATE_PAUSE_SELECT_CHARACTER And Self.state <> STATE_PAUSE_TO_TITLE And State.IsToolsCharge() And GameObject.stageModeState = GameObject.STATE_NORMAL_MODE And Not GameObject.player.isDead) Then
					MyAPI.drawImage(g, BP_wordsImg, 0, BP_wordsHeight, BP_wordsWidth, BP_wordsHeight, 0, tool_x, tool_y, 36)
				EndIf
			EndIf
		End
		
		Method close:Void()
			MapManager.closeMap()
			
			State.releaseTouchkeyBoard()
			
			Animation.closeAnimationArray(Self.stageInfoClearAni)
			Self.stageInfoClearAni = Null
			
			Animation.closeAnimationDrawer(stageInfoAniDrawer)
			stageInfoAniDrawer = Null
			
			Animation.closeAnimationDrawer(Self.stageInfoPlayerNameDrawer)
			Self.stageInfoPlayerNameDrawer = Null
			
			Animation.closeAnimationDrawer(Self.stageInfoActNumDrawer)
			Self.stageInfoActNumDrawer = Null
			
			Animation.closeAnimation(guiAnimation)
			guiAnimation = Null
			
			Animation.closeAnimationDrawer(guiAniDrawer)
			guiAniDrawer = Null
			
			Animation.closeAnimationDrawer(numberDrawer)
			numberDrawer = Null
			
			Animation.closeAnimationDrawer(Self.planeDrawer)
			Self.planeDrawer = Null
			
			Animation.closeAnimationDrawer(Self.cloudDrawer)
			Self.cloudDrawer = Null
			
			Animation.closeAnimationDrawer(Self.interruptDrawer)
			Self.interruptDrawer = Null
			
			Animation.closeAnimationDrawerArray(Self.birdDrawer)
			Self.birdDrawer = []
			
			Self.exendBgImage = Null
			Self.exendBg1Image = Null
			
			SoundSystem.getInstance().setSoundSpeed(1.0)
			
			Key.init()
			
			GameObject.quitGameState()
			
			'System.gc()
			'Thread.sleep(100)
		End
		
		Method init:Void()
			State.initTouchkeyBoard()
			Key.initSonic()
			
			releaseTips()
		End
		
		Method gamepauseLogic:Void()
			Local IsUp:Bool
			Local IsDown:Bool
			
			Key.touchkeyboardInit()
			
			If (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				PlayerObject.cursorMax = PickValue(State.IsToolsCharge(), PAUSE_RACE_INSTRUCTION, PAUSE_RACE_OPTION)
				
				Key.touchPauseInit(False)
			ElseIf (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
				PlayerObject.cursorMax = PAUSE_OPTION_ITEMS_NUM
				
				Key.touchPauseInit(True)
			EndIf
			
			If (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
				If ((Not Key.touchpausearrowup.Isin() Or IsSingleUp Or IsSingleDown) And Not ((Key.touchpausearrowupsingle.Isin() And IsSingleUp And Not IsSingleDown) Or Key.press(Key.gUp))) Then
					IsUp = False
				Else
					IsUp = True
				EndIf
				
				If ((Not Key.touchpausearrowdown.Isin() Or IsSingleUp Or IsSingleDown) And Not ((Key.touchpausearrowdownsingle.Isin() And Not IsSingleUp And IsSingleDown) Or Key.press(Key.gDown))) Then
					IsDown = False
				Else
					IsDown = True
				EndIf
			Else
				If (Key.press(Key.gUp)) Then
					IsUp = True
				Else
					IsUp = False
				EndIf
				
				If (Key.press(Key.gDown)) Then
					IsDown = True
				Else
					IsDown = False
				EndIf
			EndIf
			
			If (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				If ((Key.touchpause1.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex) Or ((Key.touchpause2.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 1) Or ((Key.touchpause3.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 2) Or (Key.touchpause4.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 3)))) Then
					Select (PAUSE_NORMAL_MODE[PlayerObject.cursor])
						Case PAUSE_NORMAL_RESUME
							BacktoGame()
						Case PAUSE_NORMAL_TO_TITLE
							Self.state = STATE_PAUSE_TO_TITLE
							Self.cursor = 1 ' PAUSE_NORMAL_TO_TITLE
						Case PAUSE_NORMAL_SHOP
							shopInit(True)
						Case PAUSE_NORMAL_OPTION
							optionInit()
							
							Self.state = STATE_PAUSE_OPTION
						Case PAUSE_NORMAL_INSTRUCTION
							helpInit()
							
							Self.state = STATE_PAUSE_INSTRUCTION
					End Select
					
					Key.touchPauseClose(False)
				ElseIf (Key.touchpause1.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex ' + 0
					
					Key.touchpause1.reset()
				ElseIf (Key.touchpause2.IsClick()) Then
					PlayerObject.cursor = (PlayerObject.cursorIndex + 1)
					
					Key.touchpause2.reset()
				ElseIf (Key.touchpause3.IsClick()) Then
					PlayerObject.cursor = (PlayerObject.cursorIndex + 2)
					
					Key.touchpause3.reset()
				ElseIf (Key.touchpause4.IsClick()) Then
					PlayerObject.cursor = (PlayerObject.cursorIndex + 3)
					
					Key.touchpause4.reset()
				EndIf
			ElseIf (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
				If ((Key.touchpause1.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 0) Or ((Key.touchpause2.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 1) Or ((Key.touchpause3.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 2) Or (Key.touchpause4.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 3)))) Then
					Select (PlayerObject.cursor)
						Case 0
							BacktoGame()
						Case 1
							Self.state = STATE_PAUSE_RETRY
							
							Self.cursor = 1
						Case 2
							Self.state = STATE_PAUSE_SELECT_STAGE
							
							Self.cursor = 0
						Case 3
							Self.state = STATE_PAUSE_TO_TITLE
							
							Self.cursor = 1
						Case 4
							optionInit()
							
							Self.state = STATE_PAUSE_OPTION
							
							Self.cursor = 0
						Case 5
							helpInit()
							
							Self.state = STATE_PAUSE_INSTRUCTION
							
							Self.cursor = 0
						Case 29
							Self.state = STATE_PAUSE_SELECT_CHARACTER
							
							Self.cursor = 0
					End Select
					
					Key.touchPauseClose(True)
				ElseIf (Key.touchpause1.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex ' + 0
					
					Key.touchpause1.reset()
				ElseIf (Key.touchpause2.IsClick()) Then
					PlayerObject.cursor = (PlayerObject.cursorIndex + 1)
					
					Key.touchpause2.reset()
				ElseIf (Key.touchpause3.IsClick()) Then
					PlayerObject.cursor = (PlayerObject.cursorIndex + 2)
					
					Key.touchpause3.reset()
				ElseIf (Key.touchpause4.IsClick()) Then
					PlayerObject.cursor = (PlayerObject.cursorIndex + 3)
					
					Key.touchpause4.reset()
				EndIf
			EndIf
			
			If (IsUp) Then
				PlayerObject.cursor -= 1
				PlayerObject.cursor += PlayerObject.cursorMax
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			ElseIf (IsDown) Then
				PlayerObject.cursor += 1
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			ElseIf (Key.press(Key.gSelect | Key.B_S1)) Then
				If (PlayerObject.stageModeState <> GameObject.STATE_NORMAL_MODE) Then
					If (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
						Select (PlayerObject.cursor)
							Case 0
								BacktoGame()
							Case 1
								Self.state = STATE_PAUSE_RETRY
								Self.cursor = 1
							Case 2
								Self.state = STATE_PAUSE_SELECT_STAGE
								Self.cursor = 0
							Case 3
								Self.state = STATE_PAUSE_TO_TITLE
								Self.cursor = 1
							Case 4
								optionInit()
								
								Self.state = STATE_PAUSE_OPTION
								Self.cursor = 0
							Case 5
								helpInit()
								
								Self.state = STATE_PAUSE_INSTRUCTION
								Self.cursor = 0
							Case 29
								Self.state = STATE_PAUSE_SELECT_CHARACTER
								Self.cursor = 0
							Default
								' Nothing so far.
						End Select
					EndIf
				EndIf
				
				Select (PAUSE_NORMAL_MODE[PlayerObject.cursor])
					Case PAUSE_NORMAL_RESUME
						BacktoGame()
					Case PAUSE_NORMAL_TO_TITLE
						Self.state = STATE_PAUSE_TO_TITLE
						
						Self.cursor = 1
					Case PAUSE_NORMAL_SHOP
						shopInit(True)
					Case PAUSE_NORMAL_OPTION
						optionInit()
						
						Self.state = STATE_PAUSE_OPTION
					Case PAUSE_NORMAL_INSTRUCTION
						helpInit()
						
						Self.state = STATE_PAUSE_INSTRUCTION
				End Select
				
				Key.clear()
			EndIf
			
			If (Key.press(Key.B_S2)) Then
				' Nothing so far.
			EndIf
			
			If (Key.press(Key.B_BACK)) Then
				doReturnGameStuff()
				
				If (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
					Key.touchPauseClose(False)
				ElseIf (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
					Key.touchPauseClose(True)
				EndIf
				
				Key.touchgamekeyInit()
				Key.touchkeyboardClose()
				Key.touchkeygameboardInit()
				
				Key.clear()
			EndIf
		End
		
		Method pause:Void()
			If (Self.state <> STATE_SCORE_UPDATED And Self.state <> STATE_INTERRUPT And Self.state <> STATE_PAUSE And Self.state <> 20 And Self.state <> 23 And Self.state <> 21) Then
				If (Self.state = STATE_GAME And GameObject.player.isDead) Then
					Self.interrupt_state = Self.state
					Self.state = STATE_INTERRUPT
					
					interruptInit()
				ElseIf (Self.state = STATE_STAGE_LOADING Or Self.state = STATE_STAGE_LOADING_TURN Or Self.state = STATE_ALL_CLEAR Or Self.state = STATE_STAGE_PASS Or Self.state = STATE_PAUSE_OPTION Or Self.state = STATE_PAUSE_RETRY Or Self.state = STATE_PAUSE_SELECT_STAGE Or Self.state = STATE_PAUSE_SELECT_CHARACTER Or Self.state = STATE_PAUSE_TO_TITLE Or Self.state = STATE_PAUSE_INSTRUCTION Or Self.state = STATE_PAUSE_SELECT_CHARACTER Or Self.state = STATE_CONTINUE_0 Or Self.state = STATE_CONTINUE_1 Or Self.state = STATE_GAME_OVER_PRE Or Self.state = STATE_TIME_OVER_0 Or Self.state = STATE_GAME_OVER_1 Or Self.state = STATE_GAME_OVER_2 Or Self.state = STATE_PAUSE_OPTION_SOUND Or Self.state = STATE_PAUSE_OPTION_VIB Or Self.state = STATE_PAUSE_OPTION_KEY_CONTROL Or Self.state = STATE_PAUSE_OPTION_SP_SET Or Self.state = STATE_PAUSE_OPTION_HELP Or Self.state = STATE_PAUSE_OPTION_SOUND_VOLUMN Or Self.state = STATE_PAUSE_OPTION_SENSOR Or Self.state = STATE_SCORE_UPDATE Or Self.state = STATE_SCORE_UPDATE_ENSURE Or Self.state = STATE_SCORE_UPDATED) Then
					Self.interrupt_state = Self.state
					Self.state = STATE_INTERRUPT
					
					interruptInit()
					
					Print("interrupt")
				Else
					PlayerObject.gamepauseInit()
					
					Self.state = STATE_PAUSE
					
					isDrawTouchPad = False
					
					gamePauseInit()
					
					Key.init()
					
					GameObject.IsGamePause = True
					
					State.fadeInit_Modify(0, 102)
					
					SoundSystem.getInstance().stopBgm(False)
					SoundSystem.getInstance().stopLongSe()
					SoundSystem.getInstance().stopLoopSe()
					
					Self.pauseoptionCursor = GlobalResource.soundConfig
					
					Key.touchgamekeyClose()
				EndIf
			EndIf
		End
		
		Method interruptLogic:Void()
			SoundSystem.getInstance().stopBgm(False)
			
			If (Key.press(Key.B_S2)) Then
				' Nothing so far.
			EndIf
			
			If (Key.press(Key.B_BACK) Or (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress())) Then
				fading = lastFading
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_107)
				
				Key.touchInterruptClose()
				
				Self.state = Self.interrupt_state
				Self.interrupt_state = -1
				
				Key.clear()
				
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
				
				isDrawTouchPad = True
				
				Select (Self.state)
					Case STATE_STAGE_PASS, STATE_STAGE_LOADING_TURN
						isDrawTouchPad = False
					Case STATE_PAUSE_OPTION
						optionInit()
						
						State.fadeInit(0, 0)
						
						Key.touchkeyboardClose()
						Key.touchkeyboardInit()
						
						isDrawTouchPad = False
					Case STATE_PAUSE_RETRY, STATE_PAUSE_SELECT_STAGE, STATE_PAUSE_TO_TITLE, STATE_PAUSE_SELECT_CHARACTER
						isDrawTouchPad = False
					Case STATE_TIME_OVER_0, STATE_GAME_OVER_1, STATE_GAME_OVER_2
						' Nothing so far.
					Case STATE_ALL_CLEAR, STATE_CONTINUE_0, STATE_CONTINUE_1
						isDrawTouchPad = False
					Case STATE_PAUSE_OPTION_SOUND, STATE_PAUSE_OPTION_VIB, STATE_PAUSE_OPTION_KEY_CONTROL, STATE_PAUSE_OPTION_SP_SET, STATE_PAUSE_OPTION_HELP, STATE_PAUSE_OPTION_SOUND_VOLUMN, STATE_PAUSE_OPTION_SENSOR
						isDrawTouchPad = False
						
						SoundSystem.getInstance().playBgm(SoundSystem.BGM_CONTINUE)
					Case STATE_SCORE_UPDATE, STATE_SCORE_UPDATED
						isDrawTouchPad = False
					Case STATE_SCORE_UPDATE_ENSURE
						isDrawTouchPad = False
				End Select
				
				isDrawTouchPad = False
				IsInInterrupt = False
			EndIf
		End
		
		Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId(Int(Key.touchinterruptreturn.Isin()))
			Self.interruptDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
		End
		
		Method changeStateWithFade:Void(nState:Int)
			Self.isStateClassSwitch = False
			
			If (Not fading) Then
				fading = True
				
				If (nstate = STATE_PAUSE_OPTION) Then
					State.fadeInit(102, 255)
				Else
					State.fadeInit(0, 255)
				EndIf
				
				Self.nextState = nState
				
				Self.fadeChangeState = True
			EndIf
		End
		
		Method fadeStateLogic:Void()
			If (Not Self.isStateClassSwitch) Then
				If (fading And Self.fadeChangeState And State.fadeChangeOver() And Self.state <> Self.nextState) Then
					Self.state = Self.nextState
					
					Self.fadeChangeState = False
					
					If (Self.state = STATE_PAUSE) Then
						State.fadeInit_Modify(255, 102)
					Else
						State.fadeInit(255, 0)
					EndIf
				EndIf
				
				If (Self.state = Self.nextState And State.fadeChangeOver()) Then
					fading = False
				EndIf
			ElseIf (fading And State.fadeChangeOver()) Then
				State.setState(Self.stateForSet)
				
				State.fadeInit(255, 0)
			EndIf
		End
	Private
		' Methods:
		
		' Extensions:
		Method LoadingInProgress:Bool()
			Return ((Millisecs() - Self.loadingStartTime) < (LOADING_TIME_LIMIT * 1000) Or Not StageManager.loadStageStep())
		End
		
		Method loadingEnd:Bool()
			Return (Not LoadingInProgress())
		End
		
		Method staffDraw:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Method initTips:Void()
			If (Self.loadingWordsDrawer = Null Or Self.loadingDrawer = Null) Then
				Local animation:= New Animation("/animation/loading")
				
				Self.loadingWordsDrawer = animation.getDrawer(0, True, 0)
				Self.loadingDrawer = animation.getDrawer(0, False, 0)
			EndIf
			
			Self.TIPS = []
			
			Select (PlayerObject.getCharacterID())
				Case CHARACTER_SONIC
					' Check if we're in the "Super Sonic stage":
					If (StageManager.getCurrentZoneId() <> 8) Then
						Self.TIPS = MyAPI.loadText("/tip/tips_sonic")
					Else
						Self.TIPS = MyAPI.loadText("/tip/tips_ssonic")
					EndIf
				Case CHARACTER_TAILS
					Self.TIPS = MyAPI.loadText("/tip/tips_tails")
				Case CHARACTER_KNUCKLES
					Self.TIPS = MyAPI.loadText("/tip/tips_knuckles")
				Case CHARACTER_AMY
					Self.TIPS = MyAPI.loadText("/tip/tips_amy")
			End Select
			
			MyAPI.initString()
			
			Self.loadingStartTime = Millisecs()
			
			releaseTips()
			
			State.fadeInit(255, 0)
		End
		
		Method doReturnGameStuff:Void()
			Self.state = STATE_GAME
			
			GameObject.IsGamePause = False
			
			State.fadeInit(102, 0)
			
			If (Not StageManager.isStagePass()) Then
				If (PlayerObject.IsInvincibility()) Then
					SoundSystem.getInstance().playBgm(SoundSystem.BGM_INVINCIBILITY)
				ElseIf (GameObject.bossFighting) Then
					' Magic numbers (Boss IDs):
					Select (GameObject.bossID)
						Case 21, 26
							If (Not GameObject.isBossHalf) Then
								SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_02, True)
							Else
								SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_03, True)
							EndIf
						Case 22, 23, 24, 25
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_01)
						Case 27
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_04)
						Case 28
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_F1)
						Case 29
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_F2)
						Case 30
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_FINAL3, True)
						Default
							' Nothing so far.
					End Select
				Else
					SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
				EndIf
			EndIf
			
			Key.initSonic()
		End
		
		Method drawLoadingBar:Void(g:MFGraphics, y:Int)
			drawTips(g, y)
			
			State.drawBar(g, 0, y)
			
			Self.selectMenuOffsetX += 8
			Self.selectMenuOffsetX Mod= MENU_TITLE_MOVE_DIRECTION
			
			Local x:= 0
			
			While (x - Self.selectMenuOffsetX > 0)
				x -= MENU_TITLE_MOVE_DIRECTION
			Wend
			
			#Rem
				For Local i:= 0 Until MENU_TITLE_DRAW_NUM
					Local i2:= (MENU_TITLE_MOVE_DIRECTION * i) + x
				Next
			#End
		End
		
		Method drawTips:Void(g:MFGraphics, endy:Int)
			State.fillMenuRect(g, ((SCREEN_WIDTH - MENU_RECT_WIDTH) / 2), (SCREEN_HEIGHT / 4) - 16, MENU_RECT_WIDTH + 0, (SCREEN_HEIGHT / 2) + 16) ' Shr 1 ' Shr 2
			
			If (tipsForShow.Length = 0) Then
				tipsForShow = MyAPI.getStrings(tipsString[MyRandom.nextInt(0, tipsString.Length - 1)], MENU_RECT_WIDTH - Self.TIPS_OFFSET_X)
				
				MyAPI.initString()
				
				Return
			EndIf
			
			g.setColor(0)
			
			Local y:= (Self.TIPS_TITLE_OFFSET_Y + ((SCREEN_HEIGHT / 4) - 8)) ' Shr 2
			
			MyAPI.drawBoldString(g, "hint", (((SCREEN_WIDTH - MENU_RECT_WIDTH) + Self.TIPS_OFFSET_X) / 2), y, 0, MapManager.END_COLOR, 4656650, 0) ' Shr 1 ' "~u5c0f~u63d0~u793a"
			MyAPI.drawBoldStrings(g, tipsForShow, (((SCREEN_WIDTH - MENU_RECT_WIDTH) + Self.TIPS_OFFSET_X) / 2), LINE_SPACE + ((SCREEN_HEIGHT / 4) - 8), MENU_RECT_WIDTH - Self.TIPS_OFFSET_X, (SCREEN_HEIGHT / 2) - LINE_SPACE, MapManager.END_COLOR, 4656650, 0) ' Shr 2 ' Shr 1
		End
		
		Method releaseTips:Void()
			tipsForShow = []
		End
		
		Method stagePassLogic:Void()
			PlayerObject.isNeedPlayWaterSE = False
			
			If (StageManager.isOnlyStagePass) Then
				State.fadeInit(0, 255)
				
				Self.state = STATE_STAGE_LOADING_TURN
				
				isThroughGame = True
				
				loadingType = 0
				
				StageManager.addStageID()
				
				SoundSystem.getInstance().stopBgm(False)
			ElseIf (PlayerObject.IsStarttoCnt) Then
				Self.cnt += 1
				
				If (Self.cnt = 1) Then
					If (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
						GameObject.ObjectClear()
					EndIf
					
					PlayerObject.isbarOut = True
				EndIf
				
				If (Self.cnt = 2) Then
					SoundSystem.getInstance().playSe(SoundSystem.SE_141, False)
				EndIf
				
				If (Self.cnt > 20) Then
					If (Self.cnt = 21) Then
						If (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
							GameObject.player.setStagePassRunOutofScreen()
						ElseIf (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
							If (PlayerObject.IsDisplayRaceModeNewRecord) Then
								Self.racemode_cnt = 128
							Else
								Self.racemode_cnt = 60
							EndIf
						EndIf
					ElseIf (Self.cnt > 21 And PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE And GameObject.player.stagePassRunOutofScreenLogic()) Then
						If (StageManager.IsStageEnd()) Then
							StageManager.characterFromGame = -1
							StageManager.stageIDFromGame = -1
							
							StageManager.saveStageRecord()
							
							State.setState(State.STATE_EXTRA_ENDING)
						ElseIf (StageManager.getStageID() <> 12) Then
							State.fadeInit(0, 255)
							
							Self.state = STATE_STAGE_LOADING_TURN
							
							isThroughGame = True
							loadingType = 0
							
							StageManager.addStageID()
							
							StageManager.characterFromGame = PlayerObject.getCharacterID()
							StageManager.stageIDFromGame = StageManager.getStageID()
							
							StageManager.saveStageRecord()
							
							SoundSystem.getInstance().stopBgm(False)
						ElseIf (StageManager.isGoingToExtraStage()) Then
							State.fadeInit(0, 255)
							
							Self.state = STATE_STAGE_LOADING_TURN
							
							isThroughGame = True
							loadingType = 0
							
							StageManager.addStageID()
							
							SoundSystem.getInstance().stopBgm(False)
						Else
							StageManager.characterFromGame = -1
							StageManager.stageIDFromGame = -1
							
							StageManager.saveStageRecord()
							
							State.setState(State.STATE_NORMAL_ENDING)
						EndIf
					EndIf
					
					If (Self.cnt = Self.racemode_cnt) Then
						If (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
							setStateWithFade(State.STATE_SELECT_RACE_STAGE)
							
							Key.touchgamekeyClose()
							Key.touchkeygameboardClose()
							Key.touchkeyboardInit()
						EndIf
						
						StageManager.saveHighScoreRecord()
					EndIf
				EndIf
			EndIf
		End
		
		Method drawSaw:Void(g:MFGraphics, x:Int, y:Int)
			stageInfoAniDrawer.draw(g, PlayerObject.getCharacterID(), x, y, False, 0)
		End
		
		Method drawWhiteBar:Void(g:MFGraphics, x:Int, y:Int)
			g.setColor(MapManager.END_COLOR)
			
			MyAPI.fillRect(g, x, y - 10, SCREEN_WIDTH, 20)
		End
		
		Method drawHugeStageName:Void(g:MFGraphics, stageid:Int, x:Int, y:Int)
			Local stage_id:Int
			
			Self.selectMenuOffsetX -= 8
			Self.selectMenuOffsetX Mod= STAGE_MOVE_DIRECTION
			
			If (stageid < 12) Then
				stage_id = stageid Shr 1 ' / 2
			Else
				stage_id = stageid - PAUSE_RACE_INSTRUCTION
			EndIf
			
			If (stageid = 11) Then
				stage_id = PAUSE_OPTION_ITEMS_NUM
			EndIf
			
			For Local x1:= (Self.selectMenuOffsetX - 294) Until (SCREEN_WIDTH * 2) Step STAGE_MOVE_DIRECTION
				stageInfoAniDrawer.draw(g, stage_id + PAUSE_RACE_INSTRUCTION, x1, (y - FLOAT_RANGE) + 2, False, 0) ' (y - 10)
			Next
		End
		
		Method drawTinyStageName:Void(g:MFGraphics, stageid:Int, x:Int, y:Int)
			Local stage_id:Int
			
			If (stageid < 11) Then
				stage_id = (stageid Shr 1) ' / 2
			Else
				stage_id = (stageid - 5)
			EndIf
			
			stageInfoAniDrawer.draw(g, stage_id + 14, x, y, False, 0) ' BIRD_SPACE_2
		End
		
		Method drawSonic:Void(g:MFGraphics, x:Int, y:Int)
			If (Self.IsPlayerNameDrawable) Then
				Self.stageInfoPlayerNameDrawer.draw(g, PlayerObject.getCharacterID() + 23, x, y, False, 0)
			EndIf
		End
		
		Method drawAction:Void(g:MFGraphics, id:Int, x:Int, y:Int)
			If (Self.IsActNumDrawable And StageManager.getStageID() < 12) Then
				Self.stageInfoActNumDrawer.draw(g, (StageManager.getStageID() Mod 2) + 27, x, y, False, 0)
			EndIf
		End
		
		Method interruptInit:Void()
			If (Self.interruptDrawer = Null) Then
				Self.interruptDrawer = Animation.getInstanceFromQi("/animation/utl_res/suspend_resume.dat")[0].getDrawer(0, True, 0)
			EndIf
			
			isDrawTouchPad = False
			IsInInterrupt = True
			
			lastFading = fading
			fading = False
			
			Key.touchkeygameboardClose()
			Key.touchkeyboardInit()
			Key.touchInterruptInit()
		End
		
		Method optionInit:Void()
			Self.optionMenuCursor = 0
			
			menuInit(OPTION_ELEMENT_NUM)
			
			Self.optionCursor[0] = GlobalResource.soundConfig
			Self.optionCursor[1] = GlobalResource.seConfig
			
			Self.offsetOfVolumeInterface = MENU_SPACE
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Self.optionOffsetX = 0
			Self.pauseOptionCursor = 0
			Self.isOptionDisFlag = False
			
			State.fadeInit(102, 102)
			
			Key.touchMenuOptionInit()
			
			Self.isChanged = False
			
			Self.optionOffsetYAim = 0
			Self.optionOffsetY = 0
			Self.optionslide_getprey = -1
			Self.optionslide_gety = -1
			Self.optionslide_y = 0
			Self.optionDrawOffsetBottomY = 0
			Self.optionYDirect = 0
		End
		
		Method itemsid:Int(id:Int)
			Local itemsidoffset:= ((Self.optionOffsetY / 24) * 2)
			
			If (id + itemsidoffset < 0) Then
				Return 0
			EndIf
			
			If (id + itemsidoffset > VISIBLE_OPTION_ITEMS_NUM) Then
				Return VISIBLE_OPTION_ITEMS_NUM
			EndIf
			
			Return (id + itemsidoffset)
		End
		
		Method optionLogic:Void()
			If (Not Self.isOptionDisFlag) Then
				SoundSystem.getInstance().playBgm(SoundSystem.BGM_CONTINUE)
				
				Self.isOptionDisFlag = True
			EndIf
			
			If (State.fadeChangeOver()) Then
				If (Key.touchmenuoptionreturn.Isin() And Key.touchmenuoption.IsClick()) Then
					Self.returnCursor = 1
				EndIf
				
				Self.optionslide_gety = Key.slidesensormenuoption.getPointerY()
				Self.optionslide_y = 0
				Self.optionslidefirsty = 0
				
				For Local i:= 0 Until (Key.touchmenuoptionitems.Length / 2) ' Shr 1
					Key.touchmenuoptionitems[i * 2].setStartY((((i * 24) + 28) + Self.optionDrawOffsetY) + Self.optionslide_y)
					Key.touchmenuoptionitems[(i * 2) + 1].setStartY((((i * 24) + 28) + Self.optionDrawOffsetY) + Self.optionslide_y)
				Next
				
				If (Self.isSelectable) Then
					For Local i:= 0 Until Key.touchmenuoptionitems.Length
						If (Key.touchmenuoptionitems[i].Isin() And Key.touchmenuoption.IsClick()) Then
							Self.pauseOptionCursor = (i / 2)
							Self.returnCursor = 0
							
							Exit
						EndIf
					Next
				EndIf
				
				If (Key.touchmenuoptionreturn.Isin() And Key.touchmenuoption.IsClick()) Then
					Self.returnCursor = 1
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchmenuoptionreturn.IsButtonPress() And Self.returnCursor = 1)) And State.fadeChangeOver()) Then
					changeStateWithFade(STATE_PAUSE)
					
					SoundSystem.getInstance().stopBgm(False)
					SoundSystem.getInstance().playSe(SoundSystem.SE_107)
					
					GlobalResource.saveSystemConfig()
				EndIf
				
				If (Key.slidesensormenuoption.isSliding()) Then
					Self.isSelectable = True
				Else
					If (Self.isOptionChange And Self.optionslide_y = 0) Then
						Self.optionDrawOffsetY = Self.optionDrawOffsetTmpY1
						Self.isOptionChange = False
						Self.optionYDirect = 0
					EndIf
					
					If (Not Self.isOptionChange) Then
						Local speed:Int
						
						If (Self.optionDrawOffsetY > 0) Then
							Self.optionYDirect = 1
							
							speed = ((-Self.optionDrawOffsetY) / VX) ' Shr 1
							
							If (speed > -VX) Then
								speed = -VX
							EndIf
							
							If ((Self.optionDrawOffsetY + speed) <= 0) Then
								Self.optionDrawOffsetY = 0
								Self.optionYDirect = 0
							Else
								Self.optionDrawOffsetY += speed
							EndIf
						ElseIf (Self.optionDrawOffsetY < Self.optionDrawOffsetBottomY) Then
							Self.optionYDirect = 2
							
							speed = ((Self.optionDrawOffsetBottomY - Self.optionDrawOffsetY) / VX) ' Shr 1
							
							If (speed < VX) Then
								speed = VX
							EndIf
							
							If ((Self.optionDrawOffsetY + speed) >= Self.optionDrawOffsetBottomY) Then
								Self.optionDrawOffsetY = Self.optionDrawOffsetBottomY
								Self.optionYDirect = 0
							Else
								Self.optionDrawOffsetY += speed
							EndIf
						EndIf
					EndIf
				EndIf
				
				If (Self.isSelectable And Self.optionYDirect = 0) Then
					If (Key.touchmenuoptionitems[1].IsButtonPress() And Self.pauseOptionCursor = 0 And GlobalResource.soundSwitchConfig <> 0 And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_OPTION_SOUND_VOLUMN
						
						soundVolumnInit()
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchmenuoptionitems[3].IsButtonPress() And Self.pauseOptionCursor = 1 And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_OPTION_VIB
						
						itemsSelect2Init()
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchmenuoptionitems[5].IsButtonPress() And Self.pauseOptionCursor = 2 And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_OPTION_SP_SET
						
						itemsSelect2Init()
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchmenuoptionitems[7].IsButtonPress() And Self.pauseOptionCursor = STATE_SET_PARAM And State.fadeChangeOver()) Then
						If (GlobalResource.spsetConfig <> 0) Then
							Self.state = STATE_PAUSE_OPTION_SENSOR
							
							spSenorSetInit()
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_106)
						Else
							SoundSystem.getInstance().playSe(SoundSystem.SE_107)
						EndIf
					ElseIf (Key.touchmenuoptionitems[8].IsButtonPress() And Self.pauseOptionCursor = PAUSE_RACE_OPTION And State.fadeChangeOver()) Then
						changeStateWithFade(STATE_PAUSE_OPTION_HELP)
						
						helpInit()
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					EndIf
				EndIf
				
				Self.optionslide_getprey = Self.optionslide_gety
				
			Else
				For Local i:= 0 Until Key.touchmenuoptionitems.Length
					Key.touchmenuoptionitems[i].resetKeyState()
				Next
			EndIf
		End
		
		Method releaseOptionItemsTouchKey:Void()
			For Local i:= 0 Until Key.touchmenuoptionitems.Length
				Key.touchmenuoptionitems[i].resetKeyState()
			Next
		End
		
		Method optionDraw:Void(g:MFGraphics)
			g.setColor(0)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			Local animationDrawer:= muiAniDrawer
			
			animationDrawer.setActionId(52)
			
			For Local x:= 0 To (SCREEN_WIDTH / 48)
				For Local y:= 0 To (SCREEN_HEIGHT / 48)
					animationDrawer.draw(g, i2 * 48, j * 48)
				Next
			Next
			
			If (Self.state <> STATE_PAUSE_OPTION) Then
				Self.pauseOptionCursor = -2
			EndIf
			
			animationDrawer.setActionId(25)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 0)
			
			animationDrawer.setActionId(PickValue((GlobalResource.soundSwitchConfig = 0), 67, (Int(Key.touchmenuoptionitems[1].Isin() And Self.pauseOptionCursor = 0 And Self.isSelectable) + 57)))
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 0)
			
			animationDrawer.setActionId(GlobalResource.soundConfig + 73)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 0)
			
			animationDrawer.setActionId(21)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			
			animationDrawer.setActionId(Int(Key.touchmenuoptionitems[3].Isin() And Self.pauseOptionCursor = 1 And Self.isSelectable) + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			
			animationDrawer.setActionId(Int(GlobalResource.vibrationConfig = 0) + 35)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			
			animationDrawer.setActionId(23)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			
			animationDrawer.setActionId(Int(Key.touchmenuoptionitems[5].Isin() And Self.pauseOptionCursor = 2 And Self.isSelectable) + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			
			animationDrawer.setActionId(Int(GlobalResource.spsetConfig <> 0) + 37)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			
			animationDrawer.setActionId(24)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
			
			animationDrawer.setActionId(PickValue((GlobalResource.spsetConfig = 0), 67, Int((Key.touchmenuoptionitems[7].Isin() And Self.pauseOptionCursor = 3 And Self.isSelectable)) + 57))
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
			
			Select (GlobalResource.sensorConfig)
				Case 0
					animationDrawer.setActionId(70)
				Case 1
					animationDrawer.setActionId(69)
				Case 2
					animationDrawer.setActionId(68)
			End Select
			
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
			
			animationDrawer.setActionId(Int(Key.touchmenuoptionitems[8].Isin() And Self.pauseOptionCursor = PAUSE_RACE_OPTION And Self.isSelectable) + 27)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 96)
			
			Self.optionOffsetX -= OPTION_MOVING_SPEED
			Self.optionOffsetX Mod= OPTION_MOVING_INTERVAL
			
			animationDrawer.setActionId(51)
			
			For Local x:= Self.optionOffsetX Until (SCREEN_WIDTH * 2) Step OPTION_MOVING_INTERVAL
				animationDrawer.draw(g, x1, 0)
			Next
			
			animationDrawer.setActionId(PickValue(Key.touchmenuoptionreturn.Isin(), 66, 61))
			animationDrawer.draw(g, 0, SCREEN_HEIGHT)
			
			State.drawFade(g)
		End
		
		Method setStateWithFade:Void(nState:Int)
			Self.isStateClassSwitch = True
			
			If (Not fading) Then
				fading = True
				
				State.fadeInit(0, 255)
				
				Self.stateForSet = nState
			EndIf
		End
		
		Method endingInit:Void()
			Self.planeDrawer = New Animation("/animation/ending/ending_plane").getDrawer()
			Self.cloudDrawer = New Animation("/animation/ending/ending_cloud").getDrawer()
			
			Local birdAnimation:= New Animation("/animation/ending/ending_bird")
			
			Self.birdDrawer = New AnimationDrawer[BIRD_NUM]
			
			For Local i:= 0 Until BIRD_NUM ' Self.birdDrawer.Length
				Self.birdDrawer[i] = birdAnimation.getDrawer()
			Next
			
			Self.endingState = 0 ' STATE_GAME
			Self.cloudCount = 0
			
			Self.count = 20
			
			planeInit()
			birdInit()
			staffInit()
			
			SoundSystem.getInstance().playBgm(SoundSystem.BGM_CREDIT, False)
		End
		
		Method endingLogic:Void()
			If (Self.count > 0) Then
				Self.count -= 1
			EndIf
			
			degreeLogic()
			cloudLogic()
			
			Select (Self.endingState)
				Case ED_STATE_NO_PLANE
					If (Self.count = 0) Then
						Self.endingState = WHITE_BAR
					EndIf
				Case ED_STATE_PLANE_APPEAR
					planeLogic()
					
					If (Self.planeX = (SCREEN_WIDTH / 2)) Then ' Shr 1
						Self.endingState = ED_STATE_BIRD_APPEAR
					EndIf
				Case ED_STATE_BIRD_APPEAR
					If (birdLogic()) Then
						Self.endingState = ED_STATE_CONGRATULATION
					EndIf
				Case ED_STATE_CONGRATULATION
					If (Self.showCount > 0) Then
						Self.showCount -= 1
					EndIf
					
					If (Self.showCount = 0) Then
						Self.changing = True
					EndIf
					
					If (Not Self.changing) Then
						Return
					EndIf
					
					If (Self.outing) Then
						Self.position = MyAPI.calNextPositionReverse(Self.position, (SCREEN_WIDTH / 2), ((SCREEN_WIDTH * 3) / 2), 1, 3) ' Shr 1
						
						If (Self.position = ((SCREEN_WIDTH * 3) / 2)) Then ' Shr 1
							Self.outing = False
							
							Self.position = ((-SCREEN_WIDTH) / 2) ' Shr 1
							
							Self.endingState = ED_STATE_STAFF
							
							Key.touchkeyboardClose()
							Key.touchkeyboardInit()
						EndIf
					Else
						Self.position = MyAPI.calNextPosition(Double(Self.position), Dobule(SCREEN_WIDTH / 2), 1, 3) ' Shr 1
						
						If (Self.position = (SCREEN_WIDTH / 2)) Then ' Shr 1
							Self.outing = True
							
							Self.showCount = STATE_SCORE_UPDATED
							
							Self.changing = False
						EndIf
					EndIf
				Case ED_STATE_STAFF
					staffLogic()
					
					If (Not Self.changing And Self.showCount = 0 And Self.stringCursor >= STAFF_STR.Length - 1) Then
						Self.endingState = ED_END
					EndIf
				Case ED_END
					If (Key.press(Key.B_S1 | Key.gSelect)) Then
						SoundSystem.getInstance().stopBgm(True)
						
						setStateWithFade(State.STATE_SCORE_RANKING)
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method endingDraw:Void(g:MFGraphics)
			g.setColor(35064)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			cloudDraw(g)
			
			birdDraw1(g)
			
			planeDraw(g)
			
			birdDraw2(g)
			
			Select (Self.endingState)
				Case ED_STATE_CONGRATULATION
					State.drawMenuFontById(g, 79, Self.position, 0)
				Case ED_STATE_STAFF
					staffDraw(g)
				Case ED_END
					staffDraw(g)
					
					State.drawSoftKey(g, True, False)
				Default
					' Nothing so far.
			End Select
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
					cloud[1] = 0
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
		
		Method planeInit:Void()
			Self.planeX = (SCREEN_WIDTH + 60)
			Self.planeY = ((SCREEN_HEIGHT * 4) / 5)
		End
		
		Method planeLogic:Void()
			Self.planeX -= PLANE_VELOCITY
			
			If (Self.planeX < (SCREEN_WIDTH / 2)) Then ' Shr 1
				Self.planeX = (SCREEN_WIDTH / 2) ' Shr 1
			EndIf
		End
		
		Method planeDraw:Void(g:MFGraphics)
			Self.planeDrawer.draw(g, Self.planeX, Self.planeY + getOffsetY(0))
		End
		
		Method birdInit:Void()
			For Local i:= BIRD_NUM To 0 Step -1
				Local bird:= Self.birdInfo[i]
				
				bird[1] = (Self.planeY - (((BIRD_NUM / 2) - i) * BIRD_NUM)) - ((BIRD_SPACE_2+BIRD_Y) * 2) ' / BIRD_OFFSET
				bird[0] = ((BIRD_NUM / 2) - i) * BIRD_NUM)
				bird[2] = MyRandom.nextInt(360) ' MDPhone.SCREEN_WIDTH
			Next
			
			For Local i:= (BIRD_NUM / 2) Until BIRD_NUM
				Local bird:= Self.birdInfo[i]
				
				bird[i][1] = (Self.planeY - ((BIRD_NUM - i) * BIRD_SPACE_2)) - (BIRD_SPACE_2+BIRD_Y) ' 15
				bird[i][0] = (BIRD_NUM - i) * -BIRD_SPACE_2
				bird[i][2] = MyRandom.nextInt(360) ' MDPhone.SCREEN_WIDTH
			Next
			
			Self.birdX = (SCREEN_WIDTH + 30) ' ((BIRD_SPACE_2+BIRD_Y) * 2)
		End
		
		Method birdLogic:Bool()
			Self.birdX -= BIRD_OFFSET ' 2 ' VX
			
			If (Self.birdX >= (SCREEN_WIDTH / 2) + 30) Then ' Shr 1
				Return False
			EndIf
			
			Self.birdX = ((SCREEN_WIDTH / 2) + 30) ' Shr 1
			
			Return True
		End
		
		Method birdDraw1:Void(g:MFGraphics)
			For Local i:= 0 Until (BIRD_NUM / 2)
				Self.birdDrawer[i].draw(g, Self.birdX + Self.birdInfo[i][0], Self.birdInfo[i][1] + getOffsetY(Self.birdInfo[i][2]))
			Next
		End
		
		Method birdDraw2:Void(g:MFGraphics)
			For Local i:= (BIRD_NUM / 2) Until BIRD_NUM
				Self.birdDrawer[i].draw(g, Self.birdX + Self.birdInfo[i][0], Self.birdInfo[i][1] + getOffsetY(Self.birdInfo[i][2]))
			Next
		End
		
		Method degreeLogic:Void()
			Self.degree += DEGREE_VELOCITY
			Self.degree Mod= 360
		End
		
		Method getOffsetY:Int(degreeOffset:Int)
			Return (MyAPI.dSin(Self.degree + degreeOffset) * DEGREE_VELOCITY) / 100
		End
		
		Method staffInit:Void()
			Self.colorCursor = MyRandom.nextInt(COLOR_SEQ.Length)
			
			Self.stringCursor = 0
			
			Self.position = ((-SCREEN_WIDTH) / 2) ' Shr 1
			
			Self.outing = False
		End
		
		Private Method staffLogic:Void()
			If (Self.showCount > 0) Then
				Self.showCount -= 1
			EndIf
			
			If (Self.showCount > 0 And Key.repeatAnyKey()) Then
				Self.showCount = 0
			EndIf
			
			If (Self.showCount = 0 And Self.stringCursor < STAFF_STR.Length - 1) Then
				Self.changing = True
			EndIf
			
			If (Not Self.changing) Then
				Return
			EndIf
			
			If (Self.outing) Then
				Self.position = MyAPI.calNextPositionReverse(Self.position, SCREEN_WIDTH Shr 1, (SCREEN_WIDTH * 3) Shr 1, 1, 3)
				
				If (Self.position = ((SCREEN_WIDTH * 3) Shr 1)) Then
					Self.outing = False
					Self.position = (-SCREEN_WIDTH) Shr 1
					Self.stringCursor += 1
					Self.colorCursor += MyRandom.nextInt(1, COLOR_SEQ.Length - 1)
					Self.colorCursor Mod= COLOR_SEQ.Length
					Return
				EndIf
				
				Return
			EndIf
			
			Self.position = MyAPI.calNextPosition((Double) Self.position, (Double) (SCREEN_WIDTH Shr 1), 1, 3)
			
			If (Self.position = (SCREEN_WIDTH Shr 1)) Then
				Self.changing = False
				Self.outing = True
				Self.showCount = STATE_SCORE_UPDATED
			EndIf
			
		End
		
		Public Method BacktoGame:Void()
			doReturnGameStuff()
			isDrawTouchPad = True
			Key.touchgamekeyInit()
			Key.touchkeyboardClose()
			Key.touchkeygameboardInit()
			
			If (Key.touchkey_pause <> Null) Then
				Key.touchkey_pause.resetKeyState()
			EndIf
			
			Key.touchkeyboardReset()
			Key.touchanykeyClose()
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
				MyAPI.drawBoldString(g, string, (x + (i * space)) - Self.itemOffsetX, y, 17, color1, color2, color3)
			Next
		End
		
		Public Method BP_GotoTryPaying:Void()
			
			If (StageManager.getStageID() = 1 And Not IsPaid) Then
				BP_continueTryInit()
			EndIf
			
			If (StageManager.getStageID() = 2 And Not IsPaid) Then
				Self.state = 20
				BP_enteredPaying = False
				Self.BP_IsFromContinueTry = False
				BP_payingInit(PAUSE_RACE_OPTION, 3)
				State.fadeInit(255, 0)
			EndIf
			
			If (IsPaid) Then
				Self.state = STATE_STAGE_LOADING
			EndIf
			
		End
		
		Public Method BP_continueTryInit:Void()
			Self.state = 19
			State.fadeInit(255, 0)
			MyAPI.initString()
			strForShow = MyAPI.getStrings(BPstrings[0], Self.BP_CONTINUETRY_MENU_WIDTH - 20)
			Self.BP_CONTINUETRY_MENU_HEIGHT = Self.MORE_GAME_HEIGHT + ((strForShow.Length - 1) * LINE_SPACE)
			Self.BP_CONTINUETRY_MENU_START_Y = (SCREEN_HEIGHT - Self.BP_CONTINUETRY_MENU_HEIGHT) Shr 1
			PlayerObject.cursor = 0
		End
		
		Public Method BP_continueTryLogic:Void()
			Bool IsUp
			Bool IsDown
			Key.touchkeyboardInit()
			PlayerObject.cursorMax = 2
			
			If (Key.press(Key.gUp)) Then
				IsUp = True
			Else
				IsUp = False
			EndIf
			
			If (Key.press(Key.gDown)) Then
				IsDown = True
			Else
				IsDown = False
			EndIf
			
			If (IsUp) Then
				PlayerObject.cursor -= 1
				PlayerObject.cursor += PlayerObject.cursorMax
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			ElseIf (IsDown) Then
				PlayerObject.cursor += 1
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			ElseIf (Not Key.press(Key.B_S1 | Key.gSelect)) Then
			Else
				
				If (PlayerObject.cursor = 0) Then
					Self.state = 20
					BP_enteredPaying = False
					BP_payingInit(PAUSE_RACE_OPTION, 3)
					Self.BP_IsFromContinueTry = True
					State.fadeInit(255, 0)
				ElseIf (PlayerObject.cursor = 1) Then
					Self.state = STATE_STAGE_LOADING
					State.fadeInit(255, 0)
				EndIf
			EndIf
			
		End
		
		Public Method BP_continueTryDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			State.fillMenuRect(g, Self.BP_CONTINUETRY_MENU_START_X, Self.BP_CONTINUETRY_MENU_START_Y, Self.BP_CONTINUETRY_MENU_WIDTH, Self.BP_CONTINUETRY_MENU_HEIGHT)
			g.setColor(0)
			MyAPI.drawBoldStrings(g, strForShow, Self.BP_CONTINUETRY_MENU_START_X + 20, Self.BP_CONTINUETRY_MENU_START_Y + LOADING_TIME_LIMIT, Self.BP_CONTINUETRY_MENU_WIDTH - 20, Self.BP_CONTINUETRY_MENU_HEIGHT - 20, MapManager.END_COLOR, 4656650, 0)
			State.drawMenuFontById(g, 119, SCREEN_WIDTH Shr 1, ((Self.BP_CONTINUETRY_MENU_START_Y + 15) + ((MENU_SPACE * 3) / 2)) + (MENU_SPACE * ((PlayerObject.cursor + strForShow.Length) - 1)))
			State.drawMenuFontById(g, 113, (SCREEN_WIDTH Shr 1) - 56, ((Self.BP_CONTINUETRY_MENU_START_Y + 15) + ((MENU_SPACE * 3) / 2)) + (MENU_SPACE * ((PlayerObject.cursor + strForShow.Length) - 1)))
			MyAPI.drawBoldString(g, BPstrings[1], SCREEN_WIDTH Shr 1, (Self.BP_CONTINUETRY_MENU_START_Y + 15) + (MENU_SPACE * ((strForShow.Length - 1) + 1)), 17, MapManager.END_COLOR, 0)
			MyAPI.drawBoldString(g, BPstrings[2], SCREEN_WIDTH Shr 1, (Self.BP_CONTINUETRY_MENU_START_Y + 15) + (MENU_SPACE * ((strForShow.Length - 1) + 2)), 17, MapManager.END_COLOR, 0)
			State.drawSoftKey(g, True, False)
		End
		
		Public Method gotoGameOver:Void()
			IsGameOver = True
			Self.overcnt = 0
			Self.state = STATE_GAME_OVER_PRE
			Self.overtitleID = 78
			SoundSystem.getInstance().stopBgm(True)
			SoundSystem.getInstance().playBgm(30, False)
			Self.movingTitleX = SCREEN_WIDTH + 30
			Key.touchgamekeyClose()
			Key.touchkeygameboardClose()
			Key.touchkeyboardInit()
		End
		
		Public Method BP_gotoRanking:Void()
			PlayerObject.doPauseLeaveGame()
			
			setStateWithFade(State.STATE_SCORE_RANKING)
			
			If (IsPaid) Then
				StageManager.addNewNormalScore(IsGameOver ? PlayerObject.getScore() : Self.preScore)
			Else
				StageManager.addNewNormalScore(0)
			EndIf
			
			StageManager.resetOpenedStageIdforTry(IsGameOver ? StageManager.getStageID() : StageManager.getStageID() - 1)
			Key.touchanykeyInit()
		End
		
		Public Method BP_payingLogic:Void()
			
			If (Not BP_enteredPaying) Then
				If (State.BP_chargeLogic(0)) Then
					BP_enteredPaying = True
					
					If (Not Self.BP_IsFromContinueTry) Then
						State.setTry()
					EndIf
					
					State.activeGameProcess(True)
					State.setMenu()
					State.saveBPRecord()
					
					If (IsGameOver) Then
						BP_gotoRanking()
						Return
					EndIf
					
					Self.state = STATE_STAGE_LOADING
					State.fadeInit(255, 0)
					Return
				EndIf
				
				BP_enteredPaying = True
				
				If (Not Self.BP_IsFromContinueTry) Then
					State.setTry()
				EndIf
				
				StageManager.resetStageIdforTry()
				
				State.saveBPRecord()
				
				State.setState(State.STATE_RETURN_FROM_GAME)
			EndIf
			
		End
		
		Public Method BP_gotoRevive:Void()
			Self.state = 21
			BP_payingInit(PAUSE_OPTION_ITEMS_NUM, PAUSE_RACE_INSTRUCTION)
			State.fadeInit(255, 0)
		End
		
		Public Method BP_reviveLogic:Void()
			
			If (State.BP_chargeLogic(1)) Then
				GameObject.player.resetPlayer()
				Self.state = STATE_GAME
				State.fadeInit(255, 0)
				Return
			EndIf
			
			gotoGameOver()
		End
		
		Public Method shopInit:Void(IsClearCursor:Bool)
			
			If (IsClearCursor) Then
				PlayerObject.cursor = 0
			EndIf
			
			Self.state = 22
			MyAPI.initString()
			Key.clear()
		End
		
		Public Method BP_shopLogic:Void()
			Bool IsUp
			Bool IsDown
			Self.IsInBP = False
			Key.touchkeyboardInit()
			PlayerObject.cursorMax = STATE_SET_PARAM
			
			If (Key.press(Key.gUp)) Then
				IsUp = True
			Else
				IsUp = False
			EndIf
			
			If (Key.press(Key.gDown)) Then
				IsDown = True
			Else
				IsDown = False
			EndIf
			
			If (IsUp) Then
				PlayerObject.cursor -= 1
				PlayerObject.cursor += PlayerObject.cursorMax
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			ElseIf (IsDown) Then
				PlayerObject.cursor += 1
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			ElseIf (Key.press(Key.B_S1 | Key.gSelect)) Then
				If (Not BP_IsToolsNumMax()) Then
					Self.state = 23
					tool_id = PlayerObject.cursor
					BP_payingInit(8, 7)
				EndIf
				
			ElseIf (Key.press(Key.B_S2)) Then
				Self.state = STATE_PAUSE
				GameObject.IsGamePause = True
				PlayerObject.cursor = 2
				Key.clear()
			EndIf
			
		End
		
		Private Method BP_IsToolsNumMax:Bool()
			
			If (BP_items_num[currentBPItems[PlayerObject.cursor]] + currentBPItemsNormalNum[PlayerObject.cursor] <= 99) Then
				Return False
			EndIf
			
			Self.state = 24
			Return True
		End
		
		Public Method BP_shopDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			State.fillMenuRect(g, CASE_X, 30, CASE_WIDTH, CASE_HEIGHT)
			MyAPI.drawImage(g, BP_wordsImg, 0, 0, BP_wordsWidth, BP_wordsHeight, 0, SCREEN_WIDTH Shr 1, 40, 17)
			MyAPI.drawBoldString(g, BPstrings[LOADING_TIME_LIMIT], (CASE_WIDTH Shr 2) + CASE_X, LINE_SPACE + 40, 17, MapManager.END_COLOR, 4656650)
			MyAPI.drawBoldString(g, BPstrings[11], ((CASE_WIDTH * 3) Shr 2) + CASE_X, LINE_SPACE + 40, 17, MapManager.END_COLOR, 4656650)
			For (Int i = 0; i < currentBPItems.Length; i += 1)
				MyAPI.drawImage(g, BP_itemsImg, BP_itemsWidth * currentBPItems[i], 0, BP_itemsWidth, BP_itemsHeight, 0, (CASE_X + (CASE_WIDTH Shr 2)) - (LINE_SPACE Shr 1), (LINE_SPACE * (i + 3)) + 30, 3)
				MyAPI.drawBoldString(g, "~u00d7 " + currentBPItemsNormalNum[i], BP_itemsWidth + ((CASE_X + (CASE_WIDTH Shr 2)) - (LINE_SPACE Shr 1)), ((LINE_SPACE * (i + 3)) + 30) - FONT_H_HALF, 20, MapManager.END_COLOR, 4656650)
				MyAPI.drawBoldString(g, BP_items_num[currentBPItems[i]], (FONT_WIDTH_NUM * 2) + (CASE_X + ((CASE_WIDTH * 3) Shr 2)), ((LINE_SPACE * (i + 3)) + 30) - FONT_H_HALF, 24, MapManager.END_COLOR, 4656650)
			Next
			State.drawMenuFontById(g, 113, ((CASE_X + (CASE_WIDTH Shr 2)) - (LINE_SPACE Shr 1)) - (BP_itemsWidth * 2), (LINE_SPACE * (PlayerObject.cursor + 3)) + 30)
			MyAPI.drawBoldString(g, BPstrings[12], BP_itemsWidth + CASE_X, (LINE_SPACE * 7) + 30, 20, MapManager.END_COLOR, 4656650)
			g.setColor(0)
			MyAPI.drawBoldStrings(g, BPEffectStrings[PlayerObject.cursor], BP_itemsWidth + CASE_X, (LINE_SPACE * 8) + 30, MENU_RECT_WIDTH - 20, CASE_HEIGHT - 20, MapManager.END_COLOR, 4656650, 0)
			State.drawSoftKey(g, True, True)
		End
		
		Public Function BP_toolsAdd:Void()
			Byte[] bArr = BP_items_num
			Int i = currentBPItems[tool_id]
			bArr[i]:Byte = (bArr[i] + currentBPItemsNormalNum[tool_id])
			State.saveBPRecord()
		}
		
		Public Method BP_buyLogic:Void()
			
			If (State.BP_chargeLogic(2)) Then
				BP_toolsAdd()
				shopInit(False)
				Return
			EndIf
			
			shopInit(False)
		End
		
		Public Method BP_toolsmaxLogic:Void()
			
			If (Key.press(Key.B_S2)) Then
				shopInit(False)
			EndIf
			
		End
		
		Public Method BP_toolsmaxDraw:Void(g:MFGraphics)
			menuBgDraw(g)
			State.fillMenuRect(g, FRAME_X, (SCREEN_HEIGHT Shr 1) - MENU_SPACE, FRAME_WIDTH, MENU_SPACE Shl 1)
			g.setColor(0)
			MyAPI.drawBoldString(g, BPstrings[19], SCREEN_WIDTH Shr 1, ((SCREEN_HEIGHT Shr 1) - MENU_SPACE) + LOADING_TIME_LIMIT, 17, MapManager.END_COLOR, 4656650)
			State.drawSoftKey(g, False, True)
		End
		
		Public Method IsToolsUsed:Bool(id:Int)
			Select (id)
				Case STATE_GAME
					Return PlayerObject.IsInvincibility()
				Case STATE_PAUSE
				Case 2
					Return PlayerObject.IsUnderSheild()
				Case STATE_SET_PARAM
					Return PlayerObject.IsSpeedUp()
				Default
					Return False
			End Select
		End
		
		Public Method BP_toolsuseLogic:Void()
			Bool IsUp
			Bool IsDown
			Key.touchkeyboardInit()
			PlayerObject.cursorMax = STATE_SET_PARAM
			
			If (Key.press(Key.gUp)) Then
				IsUp = True
			Else
				IsUp = False
			EndIf
			
			If (Key.press(Key.gDown)) Then
				IsDown = True
			Else
				IsDown = False
			EndIf
			
			If (IsUp) Then
				PlayerObject.cursor -= 1
				PlayerObject.cursor += PlayerObject.cursorMax
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			ElseIf (IsDown) Then
				PlayerObject.cursor += 1
				PlayerObject.cursor Mod= PlayerObject.cursorMax
			EndIf
			
			If (Key.press(Key.B_S1 | Key.gSelect) And BP_items_num[currentBPItems[PlayerObject.cursor]] > Null And Not IsToolsUsed(currentBPItems[PlayerObject.cursor])) Then
				Self.state = STATE_BP_TOOLS_USE_ENSURE
				Self.cursor = 0
			EndIf
			
			If (Key.press(Key.B_S2)) Then
				BacktoGame()
			EndIf
			
		End
		
		Public Method BP_ensureToolsUseLogic:Void()
			Select (comfirmLogic())
				Case STATE_GAME
					Select (currentBPItems[PlayerObject.cursor])
						Case STATE_GAME
							GameObject.player.getItem(STATE_SET_PARAM)
							break
						Case STATE_PAUSE
							GameObject.player.getItem(2)
							break
						Case 2
							GameObject.player.getItem(1)
							break
						Case STATE_SET_PARAM
							GameObject.player.getItem(PAUSE_RACE_OPTION)
							break
					End Select
					Byte[] bArr = BP_items_num
					Int i = currentBPItems[PlayerObject.cursor]
					bArr[i]:Byte = (bArr[i] - 1)
					State.saveBPRecord()
					BacktoGame()
				Case STATE_PAUSE
				Case TitleState.RETURN_PRESSED
					Self.state = STATE_BP_TOOLS_USE
				Default
			End Select
		End
		
		Public Method BP_ensureToolsUseDraw:Void(g:MFGraphics)
			confirmDraw(g, BPstrings[currentBPItems[PlayerObject.cursor] + 20])
			State.drawSoftKey(g, True, True)
		End
		
		Public Method BP_toolsuseDraw:Void(g:MFGraphics)
			State.fillMenuRect(g, (SCREEN_WIDTH Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_X, (SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y, PlayerObject.PAUSE_FRAME_WIDTH, PlayerObject.PAUSE_FRAME_HEIGHT)
			MyAPI.drawImage(g, BP_wordsImg, 0, BP_wordsHeight, BP_wordsWidth, BP_wordsHeight, 0, SCREEN_WIDTH Shr 1, LINE_SPACE + ((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y), 3)
			State.drawMenuFontById(g, 119, SCREEN_WIDTH Shr 1, (((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE) + (MENU_SPACE * PlayerObject.cursor))
			State.drawMenuFontById(g, 113, (SCREEN_WIDTH Shr 1) - 56, (((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE) + (MENU_SPACE * PlayerObject.cursor))
			Int i = 0
			While (i < currentBPItems.Length) {
				Int i2
				MFImage mFImage = BP_itemsImg
				Int i3 = BP_itemsWidth * currentBPItems[i]
				
				If (BP_items_num[currentBPItems[i]] = Null Or IsToolsUsed(currentBPItems[i])) Then
					i2 = BP_itemsHeight
				Else
					i2 = 0
				EndIf
				
				MyAPI.drawImage(g, mFImage, i3, i2, BP_itemsWidth, BP_itemsHeight, 0, (SCREEN_WIDTH Shr 1) - (BP_itemsWidth * 2), (MENU_SPACE * i) + (((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE), PAUSE_OPTION_ITEMS_NUM)
				g.setColor(0)
				MFGraphics mFGraphics = g
				MyAPI.drawBoldString(mFGraphics, "~u00d7", SCREEN_WIDTH Shr 1, ((((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE) + (MENU_SPACE * i)) - FONT_H_HALF, 17, MapManager.END_COLOR, 4656650)
				MyAPI.drawBoldString(g, BP_items_num[currentBPItems[i]], (BP_itemsWidth * 2) + (SCREEN_WIDTH Shr 1), ((((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE) + (MENU_SPACE * i)) - FONT_H_HALF, 24, MapManager.END_COLOR, 4656650)
				i += 1
			}
			
			If (BP_items_num[currentBPItems[PlayerObject.cursor]] = Null) Then
				Self.tooltipY = MyAPI.calNextPosition((Double) Self.tooltipY, (Double) TOOL_TIP_Y_DES, 1, 3)
			Else
				Self.tooltipY = MyAPI.calNextPositionReverse(Self.tooltipY, TOOL_TIP_Y_DES, TOOL_TIP_Y_DES_2, 1, 3)
			EndIf
			
			State.fillMenuRect(g, TOOL_TIP_X, Self.tooltipY, TOOL_TIP_WIDTH, TOOL_TIP_HEIGHT)
			For (i = 0; i < TOOL_TIP_STR.Length; i += 1)
				MyAPI.drawBoldString(g, TOOL_TIP_STR[i], SCREEN_WIDTH Shr 1, (LINE_SPACE * i) + (Self.tooltipY + LOADING_TIME_LIMIT), 17, MapManager.END_COLOR, 4656650, 0)
			Next
			State.drawSoftKey(g, True, True)
		End
		
		Private Method initStageInfoClearRes:Void()
			
			If (Self.stageInfoClearAni = Null) Then
				Self.stageInfoClearAni = Animation.getInstanceFromQi("/animation/utl_res/stage_intro_clear.dat")
				stageInfoAniDrawer = Self.stageInfoClearAni[0].getDrawer(0, False, 0)
				Self.stageInfoPlayerNameDrawer = Self.stageInfoClearAni[0].getDrawer(PlayerObject.getCharacterID() + 23, False, 0)
				Self.stageInfoActNumDrawer = Self.stageInfoClearAni[0].getDrawer(27, False, 0)
				
				If (guiAnimation = Null) Then
					guiAnimation = New Animation("/animation/gui")
				EndIf
				
				guiAniDrawer = guiAnimation.getDrawer(0, False, 0)
			EndIf
			
			Self.IsPlayerNameDrawable = False
			Self.IsActNumDrawable = False
		End
		
		Private Method drawLoading:Void(g:MFGraphics)
			Select (loadingType)
				Case STATE_GAME
					g.setColor(0)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					break
				Case STATE_PAUSE
					g.setColor(MapManager.END_COLOR)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					break
				Case 2
					g.setColor(0)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					g.setColor(MapManager.END_COLOR)
					MyAPI.fillRect(g, 0, ((SCREEN_HEIGHT Shr 1) - 36) - 10, SCREEN_WIDTH, 20)
					break
			End Select
			Self.loadingWordsDrawer.draw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
			Self.loadingDrawer.setActionId(1)
			Self.loadingDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
			
			If (tipsForShow.Length = 0) Then
				tipsForShow = MyAPI.getStrings(Self.TIPS[MyRandom.nextInt(0, Self.TIPS.Length - 1)], PlayerObject.SONIC_ATTACK_LEVEL_3_V0)
				
				MyAPI.initString()
				
				Return
			EndIf
			
			MyAPI.drawStrings(g, tipsForShow, (SCREEN_WIDTH Shr 1) - 72, ((SCREEN_HEIGHT Shr 1) - 50) - 2, 132, OPTION_MOVING_INTERVAL, 20, MapManager.END_COLOR, 4656650, 0)
		End
		
		Private Method initStageIntroType1Conf:Void()
			Self.frameCount = 0
			Self.display[0][0] = -50
			Self.display[0][1] = 0
			Self.display[0][2] = 0
			Self.display[0][3] = 0
			Self.display[1][0] = SCREEN_WIDTH
			Self.display[1][1] = (SCREEN_HEIGHT Shr 1) + 48
			Self.display[1][2] = 0
			Self.display[1][3] = 0
			Self.display[2][0] = 48
			Self.display[2][1] = (SCREEN_HEIGHT Shr 1) + 48
			Self.display[2][2] = 0
			Self.display[2][3] = 0
			Self.display[3][0] = 0
			Self.display[3][1] = 0
			Self.display[3][2] = 0
			Self.display[3][3] = 0
			Self.display[4][0] = SCREEN_WIDTH
			Self.display[4][1] = SCREEN_HEIGHT
			Self.display[4][2] = 0
			Self.display[4][3] = 0
			Self.display[5][0] = SCREEN_WIDTH
			Self.display[5][1] = (SCREEN_HEIGHT Shr 1) - 10
			Self.display[5][2] = 0
			Self.display[5][3] = 0
		End
		
		Private Method initStageIntroType2Conf:Void()
			Self.frameCount = 0
			Self.display[0][0] = -50
			Self.display[0][1] = 0
			Self.display[0][2] = 0
			Self.display[0][3] = 0
			Self.display[1][0] = 0
			Self.display[1][1] = (SCREEN_HEIGHT Shr 1) - 36
			Self.display[1][2] = 0
			Self.display[1][3] = 0
			Self.display[2][0] = 48
			Self.display[2][1] = (SCREEN_HEIGHT Shr 1) + 48
			Self.display[2][2] = 0
			Self.display[2][3] = 0
			Self.display[3][0] = 0
			Self.display[3][1] = 0
			Self.display[3][2] = 0
			Self.display[3][3] = 0
			Self.display[4][0] = SCREEN_WIDTH
			Self.display[4][1] = SCREEN_HEIGHT
			Self.display[4][2] = 0
			Self.display[4][3] = 0
			Self.display[5][0] = SCREEN_WIDTH
			Self.display[5][1] = (SCREEN_HEIGHT Shr 1) - 10
			Self.display[5][2] = 0
			Self.display[5][3] = 0
		End
		
		Private Method drawTimeOver:Void(g:MFGraphics, x:Int, y:Int)
			Int id = 11
			
			If (Self.overtitleID = 78) Then
				id = 11
			ElseIf (Self.overtitleID = 136) Then ' Def.TOUCH_HELP_HEIGHT
				id = LOADING_TIME_LIMIT
			EndIf
			
			If (guiAnimation = Null) Then
				guiAnimation = New Animation("/animation/gui")
			EndIf
			
			guiAniDrawer = guiAnimation.getDrawer(0, False, 0)
			guiAniDrawer.setActionId(id)
			guiAniDrawer.draw(g, x, y)
		End
		
		Private Method continueInit:Void()
			Self.state = STATE_CONTINUE_1
			Self.continueFrame = 0
			Self.continueScale = 1.0
			Self.continueMoveBlackBarX = -SCREEN_WIDTH
			Self.continueMoveNumberX = -30
			Self.continueNumber = VISIBLE_OPTION_ITEMS_NUM
			Self.continueNumberState = 0
			Self.continueNumberScale = 1.0
			Self.continueCursor = -1
			Key.touchgameoverensurekeyInit()
			
			If (guiAnimation = Null) Then
				guiAnimation = New Animation("/animation/gui")
			EndIf
			
			guiAniDrawer = guiAnimation.getDrawer(0, False, 0)
			
			If (numberDrawer = Null) Then
				numberDrawer = New Animation("/animation/number").getDrawer(0, False, 0)
			EndIf
			
			isThroughGame = False
		End
		
		Private Method continueEnd:Void()
			Self.continueNumberState = STATE_SET_PARAM
			Self.continueStartEndFrame = Self.continueFrame
			StageManager.resetStageIdforContinueEnd()
			Key.touchgameoverensurekeyClose()
			isThroughGame = False
		End
		
		Private Method drawGameOver:Void(g:MFGraphics)
			
			If (Self.continueFrame <= 5) Then
				MyAPI.drawScaleAni(g, guiAniDrawer, 11, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28, Self.continueScale, 1.0, 0.0, 0.0)
			ElseIf (Self.continueFrame <= 10) Then
				MyAPI.drawScaleAni(g, guiAniDrawer, 12, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28, Self.continueScale, 1.0, 0.0, 0.0)
			EndIf
			
			If (Self.continueFrame > 10) Then
				MyAPI.drawScaleAni(g, guiAniDrawer, 12, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28, Self.continueScale, Self.continueScale, 0.0, 8.0)
				g.setColor(0)
				MyAPI.fillRect(g, Self.continueMoveBlackBarX, (SCREEN_HEIGHT Shr 1) + LOADING_TIME_LIMIT, SCREEN_WIDTH, 20)
				
				If (Self.continueMoveBlackBarX = 0) Then
					If (Self.continueNumberState < 3) Then
						MyAPI.drawScaleAni(g, numberDrawer, Self.continueNumber + 32, Self.continueMoveNumberX - PAUSE_OPTION_ITEMS_NUM, (SCREEN_HEIGHT Shr 1) + 12, Self.continueNumberScale, Self.continueNumberScale, 6.0, 8.0)
					ElseIf (Self.continueNumberState > 3) Then
						MyAPI.drawScaleAni(g, guiAniDrawer, 13, Self.continueMoveNumberX, (SCREEN_HEIGHT Shr 1) + 20, Self.continueNumberScale, Self.continueNumberScale, 0.0, 0.0)
					EndIf
					
					If (Self.continueNumberState < 3 And Key.touchgameover <> Null) Then
						drawGameOverTouchKey(g)
					EndIf
				EndIf
			EndIf
			
		End
		
		Private Method drawGameOverSingle:Void(g:MFGraphics)
			Self.continueFrame += 1
			
			If (Self.continueFrame >= 65) Then
				If (Self.continueScale > 0.0) Then
					Self.continueScale -= 0.2f
				Else
					Self.continueScale = 0.0
				EndIf
				
				MyAPI.drawScaleAni(g, guiAniDrawer, 11, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28, Self.continueScale, 1.0, 0.0, 0.0)
				Return
			EndIf
			
			MyAPI.drawScaleAni(g, guiAniDrawer, 11, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28, 1.0, 1.0, 0.0, 0.0)
		End
		
		Private Method drawGameOverTouchKey:Void(g:MFGraphics)
			
			If (Key.touchgameoveryres.Isin()) Then
				State.drawTouchGameKeyBoardById(g, LOADING_TIME_LIMIT, SCREEN_WIDTH - 22, Def.TOUCH_A_Y)
			Else
				State.drawTouchGameKeyBoardById(g, VISIBLE_OPTION_ITEMS_NUM, SCREEN_WIDTH - 22, Def.TOUCH_A_Y)
			EndIf
			
			If (Key.touchgameoverno.Isin()) Then
				State.drawTouchGameKeyBoardById(g, 12, SCREEN_WIDTH - 67, Def.TOUCH_B_Y)
			Else
				State.drawTouchGameKeyBoardById(g, 11, SCREEN_WIDTH - 67, Def.TOUCH_B_Y)
			EndIf
			
			guiAniDrawer.draw(g, BIRD_SPACE_2, SCREEN_WIDTH - 22, Def.TOUCH_A_Y, False, 0)
			guiAniDrawer.draw(g, 15, SCREEN_WIDTH - 67, Def.TOUCH_B_Y, False, 0)
		End
		
		Private Method gamePauseInit:Void()
			Self.pausecnt = 0
			Self.pause_saw_x = -50
			Self.pause_saw_y = 0
			Self.pause_saw_speed = 30
			Self.pause_item_x = SCREEN_WIDTH - 26
			
			If (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				Self.pause_item_y = (SCREEN_HEIGHT Shr 1) - 36
				Key.touchGamePauseInit(0)
			ElseIf (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
				Self.pause_item_y = (SCREEN_HEIGHT Shr 1) - 60
				Key.touchGamePauseInit(1)
			EndIf
			
			Self.pause_item_speed = (-((SCREEN_WIDTH Shr 1) + BIRD_SPACE_2)) / 3
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Self.pause_returnFlag = False
		End
		
		Private Method gamePauseLogic:Void()
			Self.pausecnt += 1
			
			If (Self.pausecnt >= PAUSE_RACE_INSTRUCTION And Self.pausecnt <= 7) Then
				If (Self.pause_saw_x + Self.pause_saw_speed > 0) Then
					Self.pause_saw_x = 0
				Else
					Self.pause_saw_x += Self.pause_saw_speed
				EndIf
				
				If (Self.pause_item_x + Self.pause_item_speed < (SCREEN_WIDTH Shr 1) - 40) Then
					Self.pause_item_x = (SCREEN_WIDTH Shr 1) - 40
				Else
					Self.pause_item_x += Self.pause_item_speed
				EndIf
				
			ElseIf (Self.pausecnt > 7) Then
				Int i
				Int items = PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE ? STATE_SET_PARAM : PAUSE_OPTION_ITEMS_NUM
				For (i = 0; i < items; i += 1)
					
					If (Key.touchgamepauseitem[i].Isin() And Key.touchgamepause.IsClick()) Then
						Self.pause_item_cursor = i
					EndIf
					
				Next
				
				If (Key.touchgamepausereturn.Isin() And Key.touchgamepause.IsClick()) Then
					Self.pause_item_cursor = -2
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchgamepausereturn.IsButtonPress() And Self.pause_item_cursor = -2)) And Not Self.pause_returnFlag) Then
					Self.pause_returnFlag = True
					Self.pause_returnframe = Self.pausecnt
					SoundSystem.getInstance().playSe(SoundSystem.SE_107)
				EndIf
				
				If (Self.pause_returnFlag) Then
					If (Self.pausecnt > Self.pause_returnframe And Self.pausecnt <= Self.pause_returnframe + 3) Then
						Self.pause_saw_x -= Self.pause_saw_speed
						Self.pause_item_x -= Self.pause_item_speed
					ElseIf (Self.pausecnt > Self.pause_returnframe + 3) Then
						BacktoGame()
						isDrawTouchPad = True
						Self.pause_returnFlag = False
						State.setFadeOver()
					EndIf
				EndIf
				
				If (Self.pause_optionFlag And Self.pausecnt > Self.pause_optionframe + 3) Then
					optionInit()
					Self.state = STATE_PAUSE_OPTION
					Self.pause_optionFlag = False
				EndIf
				
				If (Not State.fadeChangeOver()) Then
					For (i = 0; i < items; i += 1)
						Key.touchgamepauseitem[i].resetKeyState()
					Next
				ElseIf (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
					If (Key.touchgamepauseitem[0].IsButtonPress() And Self.pause_item_cursor = 0 And Not Self.pause_returnFlag) Then
						Self.pause_returnFlag = True
						Self.pause_returnframe = Self.pausecnt
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchgamepauseitem[1].IsButtonPress() And Self.pause_item_cursor = 1 And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_TO_TITLE
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchgamepauseitem[2].IsButtonPress() And Self.pause_item_cursor = 2 And Not Self.pause_returnFlag) Then
						changeStateWithFade(STATE_PAUSE_OPTION)
						
						optionInit()
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					EndIf
					
				ElseIf (PlayerObject.stageModeState <> 1) Then
				Else
					
					If (Key.touchgamepauseitem[0].IsButtonPress() And Self.pause_item_cursor = 0 And Not Self.pause_returnFlag) Then
						Self.pause_returnFlag = True
						Self.pause_returnframe = Self.pausecnt
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchgamepauseitem[1].IsButtonPress() And Self.pause_item_cursor = 1 And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_RETRY
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchgamepauseitem[2].IsButtonPress() And Self.pause_item_cursor = 2 And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_SELECT_CHARACTER
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchgamepauseitem[3].IsButtonPress() And Self.pause_item_cursor = STATE_SET_PARAM And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_SELECT_STAGE
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchgamepauseitem[4].IsButtonPress() And Self.pause_item_cursor = PAUSE_RACE_OPTION And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_TO_TITLE
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					ElseIf (Key.touchgamepauseitem[5].IsButtonPress() And Self.pause_item_cursor = PAUSE_RACE_INSTRUCTION And Not Self.pause_returnFlag) Then
						changeStateWithFade(STATE_PAUSE_OPTION)
						
						optionInit()
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_106)
					EndIf
				EndIf
			EndIf
			
		End
		
		Private Method drawGamePause:Void(g:MFGraphics)
			
			If (Self.pausecnt > PAUSE_RACE_INSTRUCTION) Then
				muiAniDrawer.setActionId(50)
				muiAniDrawer.draw(g, Self.pause_saw_x, Self.pause_saw_y)
			EndIf
			
			If (Self.pausecnt > 7) Then
				muiAniDrawer.setActionId((Key.touchgamepausereturn.Isin() ? PAUSE_RACE_INSTRUCTION : 0) + 61)
				muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
			EndIf
			
			If (Self.pausecnt <= 5) Then
				Return
			EndIf
			
			AnimationDrawer animationDrawer
			Int i
			
			If (PlayerObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				animationDrawer = muiAniDrawer
				
				If (Self.pause_item_cursor = 0 And Key.touchgamepauseitem[0].Isin()) Then
					i = 1
				Else
					i = 0
				EndIf
				
				animationDrawer.setActionId(i + 2)
				muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y)
				animationDrawer = muiAniDrawer
				
				If (Self.pause_item_cursor = 1 And Key.touchgamepauseitem[1].Isin()) Then
					i = 1
				Else
					i = 0
				EndIf
				
				animationDrawer.setActionId(i + LOADING_TIME_LIMIT)
				muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + 24)
				animationDrawer = muiAniDrawer
				
				If (Self.pause_item_cursor = 2 And Key.touchgamepauseitem[2].Isin()) Then
					i = 1
				Else
					i = 0
				EndIf
				
				animationDrawer.setActionId(i + 12)
				muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + 48)
			ElseIf (PlayerObject.stageModeState = GameObject.STATE_RACE_MODE) Then
				Int i2 = 0
				While (i2 < PAUSE_OPTION_ITEMS_NUM) {
					Int i3
					animationDrawer = muiAniDrawer
					i = (i2 + 1) * 2
					
					If (Self.pause_item_cursor = i2 And Key.touchgamepauseitem[i2].Isin()) Then
						i3 = 1
					Else
						i3 = 0
					EndIf
					
					animationDrawer.setActionId(i + i3)
					muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + (i2 * 24))
					i2 += 1
				}
			EndIf
			
		End
		
		Private Method pausetoTitleLogic:Void()
			Select (secondEnsureLogic())
				Case STATE_PAUSE
					
					If (GameObject.stageModeState = GameObject.STATE_RACE_MODE) Then
						StageManager.doWhileLeaveRace()
					EndIf
					
					PlayerObject.doPauseLeaveGame()
					
					If (GameObject.stageModeState <> 1) Then
						StageManager.characterFromGame = PlayerObject.getCharacterID()
					EndIf
					
					StageManager.stageIDFromGame = StageManager.getStageID()
					
					setStateWithFade(State.STATE_RETURN_FROM_GAME)
					
					Key.touchanykeyInit()
					Key.touchMainMenuInit2()
				Case 2
					State.fadeInit_Modify(192, 102)
					Self.state = STATE_PAUSE
					GameObject.IsGamePause = True
				Default
			End Select
		End
		
		Private Method retryStageLogic:Void()
			Select (secondEnsureLogic())
				Case STATE_PAUSE
					Self.state = STATE_STAGE_LOADING
					loadingType = 0
					initTips()
				Case 2
					State.fadeInit_Modify(192, 102)
					Self.state = STATE_PAUSE
					GameObject.IsGamePause = True
				Default
			End Select
		End
		
		Private Method pausetoSelectStageLogic:Void()
			Select (secondEnsureLogic())
				Case STATE_PAUSE
					setStateWithFade(State.STATE_SELECT_RACE_STAGE)
				Case 2
					State.fadeInit(220, 102)
					State.fadeInit_Modify(192, 102)
					
					Self.state = STATE_PAUSE
					
					GameObject.IsGamePause = True
				Default
			End Select
		End
		
		Private Method pausetoSelectCharacterLogic:Void()
			Select (secondEnsureLogic())
				Case STATE_PAUSE
					setStateWithFade(State.STATE_SELECT_CHARACTER)
				Case 2
					State.fadeInit(220, 102)
					State.fadeInit_Modify(192, 102)
					Self.state = STATE_PAUSE
					GameObject.IsGamePause = True
				Default
			End Select
		End
		
		Private Method pauseOptionSoundLogic:Void()
			Select (itemsSelect2Logic())
				Case STATE_PAUSE
					GlobalResource.soundSwitchConfig = 1
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
					Self.returnCursor = 0
				Case 2
					GlobalResource.soundSwitchConfig = 0
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					SoundSystem.getInstance().setSoundState(0)
					SoundSystem.getInstance().setSeState(0)
					Self.returnCursor = 0
				Case STATE_SET_PARAM
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					Self.returnCursor = 0
				Default
			End Select
		End
		
		Private Method pauseOptionVibrationLogic:Void()
			Select (itemsSelect2Logic())
				Case STATE_PAUSE
					GlobalResource.vibrationConfig = 1
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					Self.returnCursor = 0
					MyAPI.vibrate()
				Case 2
					GlobalResource.vibrationConfig = 0
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					Self.returnCursor = 0
				Case STATE_SET_PARAM
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					Self.returnCursor = 0
				Default
			End Select
		End
		
		Private Method pauseOptionSpSetLogic:Void()
			Select (itemsSelect2Logic())
				Case STATE_PAUSE
					GlobalResource.spsetConfig = 0
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					Self.returnCursor = 0
				Case 2
					GlobalResource.spsetConfig = 1
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					Self.returnCursor = 0
				Case STATE_SET_PARAM
					State.fadeInit(102, 0)
					Self.state = STATE_PAUSE_OPTION
					Self.returnCursor = 0
				Default
			End Select
		End
		
		Public Function enterSpStage:Void(ringNum:Int, chekPointID:Int, timeCount:Int)
			spReserveRingNum = ringNum
			spCheckPointID = chekPointID
			spTimeCount = timeCount
			State.setState(State.STATE_SPECIAL)
		}
		
		Private Method scoreUpdateInit:Void()
			Key.touchgamekeyClose()
			Key.touchkeygameboardClose()
			Key.touchkeyboardInit()
			Key.touchscoreupdatekeyInit()
			
			changeStateWithFade(STATE_SCORE_UPDATE)
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			If (guiAnimation = Null) Then
				guiAnimation = New Animation("/animation/gui")
			EndIf
			
			guiAniDrawer = guiAnimation.getDrawer(0, False, 0)
			Self.returnCursor = 0
			Self.scoreUpdateCursor = 0
		End
		
		Private Method scoreUpdateLogic:Void()
			
			If (State.fadeChangeOver()) Then
				If (Key.touchscoreupdatereturn.Isin() And Key.touchscoreupdate.IsClick()) Then
					Self.returnCursor = 1
				EndIf
				
				If (Key.touchscoreupdateyes.Isin() And Key.touchscoreupdate.IsClick()) Then
					Self.scoreUpdateCursor = 1
				ElseIf (Key.touchscoreupdateno.Isin() And Key.touchscoreupdate.IsClick()) Then
					Self.scoreUpdateCursor = 2
				EndIf
				
				If (Key.touchscoreupdateyes.IsButtonPress() And Self.scoreUpdateCursor = 1) Then
					Self.state = STATE_SCORE_UPDATE_ENSURE
					secondEnsureInit()
					State.fadeInit(0, GimmickObject.GIMMICK_NUM)
					SoundSystem.getInstance().playSe(SoundSystem.SE_106)
				ElseIf (Key.touchscoreupdateno.IsButtonPress() And Self.scoreUpdateCursor = 2) Then
					Standard2.splashinit(True)
					
					setStateWithFade(State.STATE_TITLE)
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_106)
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchscoreupdatereturn.IsButtonPress() And Self.returnCursor = 1)) And State.fadeChangeOver()) Then
					Standard2.splashinit(True)
					
					setStateWithFade(State.STATE_TITLE)
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_107)
				EndIf
			EndIf
			
		End
		
		Private Method scoreUpdateDraw:Void(g:MFGraphics)
			Int i
			g.setColor(0)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			muiAniDrawer.setActionId(52)
			For (Int i2 = 0; i2 < (SCREEN_WIDTH / 48) + 1; i2 += 1)
				For (Int j = 0; j < (SCREEN_HEIGHT / 48) + 1; j += 1)
					muiAniDrawer.draw(g, i2 * 48, j * 48)
				Next
			Next
			Self.optionOffsetX -= PAUSE_RACE_OPTION
			Self.optionOffsetX Mod= 128
			muiAniDrawer.setActionId(102)
			For (Int x1 = Self.optionOffsetX; x1 < SCREEN_WIDTH * 2; x1 += 128)
				muiAniDrawer.draw(g, x1, 0)
			Next
			guiAniDrawer.setActionId(17)
			guiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 37)
			PlayerObject.drawRecordTime(g, StageManager.getTimeModeScore(PlayerObject.getCharacterID()), (SCREEN_WIDTH Shr 1) + 54, (SCREEN_HEIGHT Shr 1) - 10, 2, 2)
			muiAniDrawer.setActionId((Key.touchscoreupdateyes.Isin() ? 1 : 0) + 55)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 60, (SCREEN_HEIGHT Shr 1) + 28)
			muiAniDrawer.setActionId(StringIndex.BLUE_BACKGROUND_ID)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 60, (SCREEN_HEIGHT Shr 1) + 28)
			AnimationDrawer animationDrawer = muiAniDrawer
			
			If (Key.touchscoreupdateno.Isin()) Then
				i = 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 55)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 60, (SCREEN_HEIGHT Shr 1) + 28)
			muiAniDrawer.setActionId(104)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 60, (SCREEN_HEIGHT Shr 1) + 28)
			animationDrawer = muiAniDrawer
			
			If (Key.touchscoreupdatereturn.Isin()) Then
				i = 5
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
			State.drawFade(g)
		End
		
		Private Method scoreUpdateEnsureLogic:Void()
			Select (secondEnsureLogic())
				Case STATE_PAUSE
					Message msg = New Message()
					setGameScore(StageManager.getTimeModeScore(PlayerObject.getCharacterID()))
					sendMessage(msg, PAUSE_OPTION_ITEMS_NUM)
					Self.state = STATE_SCORE_UPDATED
				Case 2
					Self.state = STATE_SCORE_UPDATE
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
				
				setStateWithFade(State.STATE_TITLE)
				
				activity.isResumeFromOtherActivity = False
			EndIf
			
		End
		
		Private Method scoreUpdatedDraw:Void(g:MFGraphics)
		End
End