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
	'Import lib.constutil
	
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
	Public
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
		Public Method logic:Void()
			If (Self.state <> 18) Then
				fadeStateLogic()
			EndIf
			
			Int[] iArr
			
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
					ElseIf (Not (Key.press(Key.B_0) Or Key.press(Key.B_PO) Or Not Key.press(Key.B_S1) Or Not State.IsToolsCharge() Or GameObject.stageModeState <> 0 Or GameObject.player.isDead Or StageManager.isStagePassTimePause())) Then
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
						If (State.IsToolsCharge() And PlayerObject.stageModeState = 0) Then
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
						
						If (Not (isBackFromSpStage Or GameObject.stageModeState = 1)) Then
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
				Case PAUSE_OPTION_ITEMS_NUM
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
								If (PlayerObject.stageModeState = 0) Then
									Standard2.splashinit(True)
									
									setStateWithFade(0)
								ElseIf (PlayerObject.stageModeState = 1) Then
									setStateWithFade(STATE_SET_PARAM)
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
					
					Local iArr:= Self.display[0]
					
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
					
					iArr = Self.display[PAUSE_RACE_OPTION]
					iArr[0] += Self.display[PAUSE_RACE_OPTION][2]
					
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
					
					Self.display[2][2] = -7
					Self.display[PAUSE_RACE_OPTION][3] = False
					
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
					
					While (Self.display[2][0] < 0)
						iArr = Self.display[2]
						iArr[0] += STAGE_MOVE_DIRECTION
					Wend
					
					iArr = Self.display[2]
					iArr[0] Mod= STAGE_MOVE_DIRECTION
					iArr = Self.display[2]
					iArr[1] += Self.display[2][3]
					iArr = Self.display[3]
					iArr[0] += Self.display[3][2]
					iArr = Self.display[3]
					iArr[1] += Self.display[3][3]
					iArr = Self.display[PAUSE_RACE_OPTION]
					iArr[0] += Self.display[PAUSE_RACE_OPTION][2]
					iArr = Self.display[PAUSE_RACE_OPTION]
					iArr[1] += Self.display[PAUSE_RACE_OPTION][3]
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
				Case PlayerTails.TAILS_ANI_DEAD_1
					
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
					Self.display[PAUSE_RACE_OPTION][3] = STAFF_SHOW_TIME
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
					iArr = Self.display[5]
					iArr[0] += Self.display[5][2]
					iArr = Self.display[2]
					iArr[1] += Self.display[2][3]
					iArr = Self.display[3]
					iArr[0] += Self.display[3][2]
					iArr = Self.display[3]
					iArr[1] += Self.display[3][3]
					iArr = Self.display[PAUSE_RACE_OPTION]
					iArr[0] += Self.display[PAUSE_RACE_OPTION][2]
					iArr = Self.display[PAUSE_RACE_OPTION]
					iArr[1] += Self.display[PAUSE_RACE_OPTION][3]
					
					If (Self.state = STATE_GAME) Then
						isDrawTouchPad = True
						Self.frameCount = 0
						State.fadeInit(102, 0)
						State.setFadeOver()
					EndIf
					
					GameObject.setNoInput()
					GameObject.logicObjects()
				Case PlayerTails.TAILS_ANI_DEAD_2
					interruptLogic()
				Case PlayerTails.TAILS_ANI_CELEBRATE_1
					
					If (Self.frameCount < 18) Then
						Self.frameCount += 1
					Else
						releaseTips()
						Self.state = STATE_PRE_GAME_2
						Key.touchanykeyInit()
						State.fadeInit(204, 0)
					EndIf
					
					If (Self.frameCount < VISIBLE_OPTION_ITEMS_NUM Or Self.frameCount > 11) Then
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
					
					If (Self.frameCount < BIRD_SPACE_2 Or Self.frameCount > 15) Then
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
					
					If (Self.display[0][0] + Self.display[0][2] > 0) Then
						Self.display[0][0] = 0
					Else
						iArr = Self.display[0]
						iArr[0] += Self.display[0][2]
					EndIf
					
					iArr = Self.display[0]
					iArr[1] += Self.display[0][3]
					iArr = Self.display[1]
					iArr[0] += Self.display[1][2]
					
					If (Self.display[1][0] < 0) Then
						Self.display[1][0] = 0
					EndIf
					
					If (Self.display[1][1] + Self.display[1][3] > (SCREEN_HEIGHT Shr 1) + 48) Then
						Self.display[1][1] = (SCREEN_HEIGHT Shr 1) + 48
					Else
						iArr = Self.display[1]
						iArr[1] += Self.display[1][3]
					EndIf
					
					iArr = Self.display[2]
					iArr[0] += Self.display[2][2]
					While (Self.display[2][0] < 0) {
						iArr = Self.display[2]
						iArr[0] += STAGE_MOVE_DIRECTION
					}
					iArr = Self.display[2]
					iArr[0] Mod= STAGE_MOVE_DIRECTION
					iArr = Self.display[2]
					iArr[1] += Self.display[2][3]
					iArr = Self.display[PAUSE_RACE_OPTION]
					iArr[0] += Self.display[PAUSE_RACE_OPTION][2]
					
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
				Case PlayerTails.TAILS_ANI_CELEBRATE_2
					Self.overcnt += 1
					
					If (Self.overcnt = 20) Then
						isDrawTouchPad = False
					EndIf
					
					If (Self.overtitleID = 78) Then
						If (Self.overcnt = 36) Then
							Self.state = 41
						EndIf
						
					ElseIf (Self.overtitleID = 136 And Self.overcnt = 28) Then ' Def.TOUCH_HELP_HEIGHT
						Self.state = 11
					EndIf
					
				Case PlayerTails.TAILS_ANI_CELEBRATE_3
					pausetoSelectCharacterLogic()
				Case PlayerTails.TAILS_ANI_CELEBRATE_4
					pauseOptionSoundLogic()
				Case PlayerTails.TAILS_ANI_BANK_1
					pauseOptionVibrationLogic()
				Case PlayerTails.TAILS_ANI_BANK_3
					pauseOptionSpSetLogic()
				Case PlayerTails.TAILS_ANI_UP_ARM
					helpLogic()
					
					If ((Key.press(Key.B_BACK) Or (Key.touchhelpreturn.IsButtonPress() And Self.returnPageCursor = 1)) And State.fadeChangeOver()) Then
						changeStateWithFade(7)
						GameObject.IsGamePause = True
						Self.isOptionDisFlag = False
						SoundSystem.getInstance().playSe(PLANE_VELOCITY)
						Self.returnCursor = 0
					EndIf
					
				Case PlayerTails.TAILS_ANI_POLE_V
					
					If (State.fadeChangeOver()) Then
						Self.state = STATE_STAGE_LOADING
						MapManager.closeMap()
						initTips()
					EndIf
					
				Case PlayerTails.TAILS_ANI_POLE_H
					
					If (State.fadeChangeOver()) Then
						Self.state = 15
						State.fadeInit(255, 204)
					EndIf
					
				Case PlayerTails.TAILS_ANI_ROLL_V_1
					
					If (State.fadeChangeOver()) Then
						Self.state = 27
						State.fadeInit(255, 204)
					EndIf
					
				Case PlayerTails.TAILS_ANI_ROLL_V_2
					Select (soundVolumnLogic())
						Case PLANE_VELOCITY
							State.fadeInit(190, 0)
							Self.state = 7
							Self.returnCursor = 0
						Default
					End Select
				Case PlayerTails.TAILS_ANI_ROLL_H_1
					Select (spSenorSetLogic())
						Case STATE_PAUSE
							GlobalResource.sensorConfig = 0
							State.fadeInit(190, 0)
							Self.state = 7
							Self.returnCursor = 0
						Case PLANE_VELOCITY
							GlobalResource.sensorConfig = 1
							State.fadeInit(190, 0)
							Self.state = 7
							Self.returnCursor = 0
						Case PAUSE_RACE_TO_TITLE
							State.fadeInit(190, 0)
							Self.state = 7
							Self.returnCursor = 0
						Case STATE_STAGE_PASS
							GlobalResource.sensorConfig = PLANE_VELOCITY
							State.fadeInit(190, 0)
							Self.state = 7
							Self.returnCursor = 0
						Default
					End Select
				Case PlayerTails.TAILS_ANI_ROLL_H_2
					
					If (State.fadeChangeOver()) Then
						PlayerObject.calculateScore()
						Self.state = STATE_ALL_CLEAR
						State.fadeInit(255, 0)
						Self.exendBgImage = Null
						Self.exendBg1Image = Null
						Self.exendBgImage = MFImage.createImage("/animation/ending/ed_ex_moon_bg.png")
						Self.exendBg1Image = MFImage.createImage("/animation/ending/ed_ex_forest.png")
						SoundSystem.getInstance().stopBgm(False)
						Self.allclearFrame = 0
					EndIf
					
				Case PlayerTails.TAILS_ANI_BAR_STAY
					
					If (Self.movingTitleX - Self.movingTitleSpeedX < (SCREEN_WIDTH Shr 1)) Then
						Self.movingTitleX = SCREEN_WIDTH
						State.fadeInit(0, 102)
						continueInit()
						Return
					EndIf
					
					Self.movingTitleX -= Self.movingTitleSpeedX
				Case PlayerTails.TAILS_ANI_BAR_MOVE
					Self.continueFrame += 1
					
					If (Self.continueFrame <= PAUSE_RACE_INSTRUCTION) Then
						Self.continueScale -= 0.2f
					ElseIf (Self.continueFrame <= LOADING_TIME_LIMIT) Then
						Self.continueScale += 0.2f
						
						If (Self.continueScale > 1.0) Then
							Self.continueScale = 1.0
						EndIf
						
					ElseIf (Self.continueFrame > LOADING_TIME_LIMIT) Then
						If (Self.continueMoveBlackBarX + (SCREEN_WIDTH / PAUSE_OPTION_ITEMS_NUM) > 0) Then
							Self.continueMoveBlackBarX = 0
						Else
							Self.continueMoveBlackBarX += SCREEN_WIDTH / PAUSE_OPTION_ITEMS_NUM
						EndIf
						
						If (Self.continueMoveBlackBarX = 0) Then
							If (Self.continueNumberState = 0) Then
								Self.continueMoveNumberX += SCREEN_WIDTH / 12
								
								If (Self.continueMoveNumberX >= (SCREEN_WIDTH Shr 1)) Then
									Self.continueMoveNumberX = SCREEN_WIDTH Shr 1
									Self.continueNumberState = 1
									Self.continueNumberScale = 2.0
								EndIf
								
							ElseIf (Self.continueNumberState = 1) Then
								Self.continueNumberScale -= 0.125f
								
								If (Self.continueNumberScale <= 1.0) Then
									Self.continueNumberScale = 1.0
									Self.continueNumberState = PLANE_VELOCITY
								EndIf
								
							ElseIf (Self.continueNumberState = PLANE_VELOCITY) Then
								Self.continueMoveNumberX += SCREEN_WIDTH / 12
								
								If (Self.continueMoveNumberX >= SCREEN_WIDTH + 30) Then
									Self.continueMoveNumberX = -30
									Self.continueNumberState = 0
									Self.continueNumber -= 1
									
									If (Self.continueNumber = -1) Then
										continueEnd()
									EndIf
								EndIf
								
							ElseIf (Self.continueNumberState = PAUSE_RACE_TO_TITLE) Then
								If (Self.continueFrame = Self.continueStartEndFrame + PAUSE_RACE_TO_TITLE) Then
									State.fadeInit(102, 255)
								ElseIf (Self.continueFrame > Self.continueStartEndFrame + PAUSE_RACE_TO_TITLE And State.fadeChangeOver()) Then
									If (Self.continueScale - 0.2f > 0.0) Then
										Self.continueScale -= 0.2f
									Else
										Self.continueScale = 0.0
									EndIf
									
									If (Self.continueScale = 0.0) Then
										Standard2.splashinit(True)
										State.setState(0)
									EndIf
								EndIf
								
							ElseIf (Self.continueNumberState = PAUSE_RACE_OPTION) Then
								Self.continueMoveNumberX += SCREEN_WIDTH / 12
								
								If (Self.continueMoveNumberX >= (SCREEN_WIDTH Shr 1)) Then
									Self.continueMoveNumberX = SCREEN_WIDTH Shr 1
									Self.continueNumberState = PAUSE_RACE_INSTRUCTION
									Self.continueNumberScale = 2.0
								EndIf
								
							ElseIf (Self.continueNumberState = PAUSE_RACE_INSTRUCTION) Then
								Self.continueNumberScale -= 0.125f
								
								If (Self.continueNumberScale <= 1.0) Then
									Self.continueNumberScale = 1.0
									Self.continueNumberState = PAUSE_OPTION_ITEMS_NUM
								EndIf
								
							ElseIf (Self.continueNumberState = PAUSE_OPTION_ITEMS_NUM) Then
								Self.continueMoveNumberX += SCREEN_WIDTH / 12
								
								If (Self.continueMoveNumberX >= SCREEN_WIDTH + 30) Then
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
									Self.continueNumberState = PAUSE_RACE_OPTION
									Self.continueMoveNumberX = -30
									Self.continueNumberScale = 1.0
									SoundSystem.getInstance().playSe(1)
								EndIf
								
								If (Key.touchgameoverno.IsButtonPress() And Self.continueCursor = 1) Then
									continueEnd()
									SoundSystem.getInstance().playSe(PLANE_VELOCITY)
								EndIf
							EndIf
						EndIf
					EndIf
					
				Default
			End Select
		End
		
		Public Method draw:Void(g:MFGraphics)
			Select (Self.state)
				Case PlayerTails.TAILS_ANI_UP_ARM
					g.setFont(11)
					break
				Default
					g.setFont(BIRD_SPACE_2)
					break
			End Select
			Select (Self.state)
				Case PLANE_VELOCITY
					StageManager.draw(g)
					break
				Case PAUSE_RACE_TO_TITLE
				Case PlayerTails.TAILS_ANI_PUSH_WALL
				Case PlayerTails.TAILS_ANI_SPRING_1
				Case PlayerTails.TAILS_ANI_SPRING_2
				Case PlayerTails.TAILS_ANI_SPRING_3
				Case PlayerTails.TAILS_ANI_SPRING_4
				Case PlayerTails.TAILS_ANI_SPRING_5
				Case PlayerTails.TAILS_ANI_WIND
				Case PlayerTails.TAILS_ANI_RAIL_BODY
				Case STAFF_SHOW_TIME
					break
				Case STATE_STAGE_LOADING
					State.drawFadeSlow(g)
					drawLoading(g)
					break
				Case PAUSE_OPTION_ITEMS_NUM
					helpDraw(g)
					break
				Case STATE_PAUSE_OPTION
					optionDraw(g)
					break
				Case STATE_GAME_OVER_2
					g.setColor(0)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					drawTimeOver(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28)
					break
				Case STATE_ALL_CLEAR
					MyAPI.drawImage(g, Self.exendBgImage, SCREEN_WIDTH Shr 1, 0, 17)
					MyAPI.drawImage(g, Self.exendBg1Image, SCREEN_WIDTH Shr 1, 80, 17)
					State.drawFade(g)
					
					If (State.fadeChangeOver() And Self.allclearFrame > 20) Then
						PlayerObject.stagePassDraw(g)
						break
					EndIf
					
				Case PlayerTails.TAILS_ANI_DEAD_2
					interruptDraw(g)
					break
				Case PlayerTails.TAILS_ANI_CELEBRATE_4
					optionDraw(g)
					itemsSelect2Draw(g, 35, 36)
					break
				Case PlayerTails.TAILS_ANI_BANK_1
					optionDraw(g)
					itemsSelect2Draw(g, 35, 36)
					break
				Case PlayerTails.TAILS_ANI_BANK_2
					optionDraw(g)
					break
				Case PlayerTails.TAILS_ANI_BANK_3
					optionDraw(g)
					itemsSelect2Draw(g, 37, 38)
					break
				Case PlayerTails.TAILS_ANI_UP_ARM
					helpDraw(g)
					break
				Case PlayerTails.TAILS_ANI_ROLL_V_2
					optionDraw(g)
					soundVolumnDraw(g)
					break
				Case PlayerTails.TAILS_ANI_ROLL_H_1
					optionDraw(g)
					spSenorSetDraw(g)
					break
				Default
					
					If (GameObject.IsGamePause) Then
						AnimationDrawer.setAllPause(True)
					EndIf
					
					If (Not (Self.interrupt_state = PAUSE_RACE_INSTRUCTION Or Self.interrupt_state = BIRD_SPACE_2 Or Self.interrupt_state = PAUSE_RACE_OPTION)) Then
						drawGame(g)
					EndIf
					
					If (GameObject.IsGamePause) Then
						AnimationDrawer.setAllPause(False)
					EndIf
					
					If (Not (Self.state = 15 Or Self.state = STATE_PRE_GAME_2 Or Self.state = STATE_PRE_GAME_3 Or Self.state = 27)) Then
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
					
					If (Self.state = 26) Then
						State.drawFade(g)
						BP_ensureToolsUseDraw(g)
					EndIf
					
					If (Self.state = 15 Or Self.state = 27 Or Self.state = STATE_PRE_GAME_2 Or Self.state = STATE_PRE_GAME_3) Then
						If (Self.state = 15 Or Self.state = 27) Then
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
						drawAction(g, StageManager.getStageID(), Self.display[PAUSE_RACE_OPTION][0], Self.display[PAUSE_RACE_OPTION][1])
					EndIf
					
					If (Self.state = STATE_PRE_GAME_0 Or Self.state = 37) Then
						g.setColor(0)
						MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
						
						If (loadingType = PLANE_VELOCITY) Then
							g.setColor(MapManager.END_COLOR)
							MyAPI.fillRect(g, 0, ((SCREEN_HEIGHT Shr 1) - 36) - 10, SCREEN_WIDTH, 20)
						EndIf
					EndIf
					
					If (Self.state = STATE_PAUSE_RETRY) Then
						drawGamePause(g)
						State.drawFade(g)
						SecondEnsurePanelDraw(g, 15)
					EndIf
					
					If (Self.state = VISIBLE_OPTION_ITEMS_NUM) Then
						drawGamePause(g)
						State.drawFade(g)
						SecondEnsurePanelDraw(g, 17)
					EndIf
					
					If (Self.state = 29) Then
						drawGamePause(g)
						State.drawFade(g)
						SecondEnsurePanelDraw(g, 16)
					EndIf
					
					If (Self.state = LOADING_TIME_LIMIT) Then
						drawGamePause(g)
						State.drawFade(g)
						SecondEnsurePanelDraw(g, 18)
					EndIf
					
					If (Self.state = 11 Or Self.state = 41) Then
						drawTimeOver(g, Self.movingTitleX, (SCREEN_HEIGHT Shr 1) - 28)
					EndIf
					
					If (Self.state = 42) Then
						State.drawFade(g)
						drawGameOver(g)
					EndIf
					
					If (Self.state = STATE_GAME_OVER_1) Then
						State.drawFade(g)
						drawTimeOver(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28)
					EndIf
					
					If (Self.state = STATE_PRE_ALL_CLEAR) Then
						State.drawFade(g)
					EndIf
					
					If (Self.state = STATE_STAGE_PASS) Then
						PlayerObject.stagePassDraw(g)
					EndIf
					
					If (Self.state = 35) Then
						State.drawFade(g)
						
						If (loadingType = PLANE_VELOCITY) Then
							g.setColor(MapManager.END_COLOR)
							MyAPI.fillRect(g, 0, ((SCREEN_HEIGHT Shr 1) - 36) - 10, SCREEN_WIDTH, 20)
							break
						EndIf
					EndIf
					
					break
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
		
		Public Method drawGame:Void(g:MFGraphics)
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
		
		Public Method drawGameSoftKey:Void(g:MFGraphics)
			
			If (Self.state <> 1 And Self.state <> LOADING_TIME_LIMIT And Self.state <> 8 And Self.state <> VISIBLE_OPTION_ITEMS_NUM And Self.state <> 29 And Self.state <> 25 And Self.state <> 26 And Self.state <> 41 And Self.state <> 42 And Self.state <> 11 And Self.state <> 12 And Self.state <> 13 And Not StageManager.isStagePassTimePause()) Then
				If (Not GameObject.player.isDead) Then
					State.drawSoftKeyPause(g)
				EndIf
				
				If (Self.state <> 25 And Self.state <> 26 And Self.state <> 1 And Self.state <> PAUSE_OPTION_ITEMS_NUM And Self.state <> 7 And Self.state <> 8 And Self.state <> VISIBLE_OPTION_ITEMS_NUM And Self.state <> 29 And Self.state <> LOADING_TIME_LIMIT And State.IsToolsCharge() And GameObject.stageModeState = 0 And Not GameObject.player.isDead) Then
					MyAPI.drawImage(g, BP_wordsImg, 0, BP_wordsHeight, BP_wordsWidth, BP_wordsHeight, 0, tool_x, tool_y, 36)
				EndIf
			EndIf
			
		End
		
		Public Method close:Void()
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
			Animation.closeAnimationDrawerArray(Self.birdDrawer)
			Self.birdDrawer = Null
			Self.exendBgImage = Null
			Self.exendBg1Image = Null
			Animation.closeAnimationDrawer(Self.interruptDrawer)
			Self.interruptDrawer = Null
			SoundSystem.getInstance().setSoundSpeed(1.0)
			Key.init()
			GameObject.quitGameState()
			'System.gc()
			try {
				Thread.sleep(100)
			} catch (Exception e) {
				e.printStackTrace()
			}
		End
		
		Public Method init:Void()
			State.initTouchkeyBoard()
			Key.initSonic()
			tipsForShow = Null
		End
		
		Public Function setPauseMenu:Void()
			PAUSE_NORMAL_MODE = State.IsToolsCharge() ? PAUSE_NORMAL_MODE_SHOP : PAUSE_NORMAL_MODE_NOSHOP
		}
		
		Public Method gamepauseLogic:Void()
			Bool IsUp
			Bool IsDown
			Key.touchkeyboardInit()
			
			If (PlayerObject.stageModeState = 0) Then
				PlayerObject.cursorMax = State.IsToolsCharge() ? PAUSE_RACE_INSTRUCTION : PAUSE_RACE_OPTION
				Key.touchPauseInit(False)
			ElseIf (PlayerObject.stageModeState = 1) Then
				PlayerObject.cursorMax = PAUSE_OPTION_ITEMS_NUM
				Key.touchPauseInit(True)
			EndIf
			
			If (PlayerObject.stageModeState = 1) Then
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
			
			If (PlayerObject.stageModeState = 0) Then
				If ((Key.touchpause1.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 0) Or ((Key.touchpause2.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 1) Or ((Key.touchpause3.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + PLANE_VELOCITY) Or (Key.touchpause4.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + PAUSE_RACE_TO_TITLE)))) Then
					Select (PAUSE_NORMAL_MODE[PlayerObject.cursor])
						Case STATE_GAME
							BacktoGame()
							break
						Case STATE_PAUSE
							Self.state = LOADING_TIME_LIMIT
							Self.cursor = 1
							break
						Case PLANE_VELOCITY
							shopInit(True)
							break
						Case PAUSE_RACE_TO_TITLE
							optionInit()
							Self.state = 7
							break
						Case STATE_STAGE_PASS
							helpInit()
							Self.state = PAUSE_OPTION_ITEMS_NUM
							break
					End Select
					Key.touchPauseClose(False)
				ElseIf (Key.touchpause1.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + 0
					Key.touchpause1.reset()
				ElseIf (Key.touchpause2.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + 1
					Key.touchpause2.reset()
				ElseIf (Key.touchpause3.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + PLANE_VELOCITY
					Key.touchpause3.reset()
				ElseIf (Key.touchpause4.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + PAUSE_RACE_TO_TITLE
					Key.touchpause4.reset()
				EndIf
				
			ElseIf (PlayerObject.stageModeState = 1) Then
				If ((Key.touchpause1.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 0) Or ((Key.touchpause2.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + 1) Or ((Key.touchpause3.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + PLANE_VELOCITY) Or (Key.touchpause4.IsClick() And PlayerObject.cursor = PlayerObject.cursorIndex + PAUSE_RACE_TO_TITLE)))) Then
					Select (PlayerObject.cursor)
						Case STATE_GAME
							BacktoGame()
							break
						Case STATE_PAUSE
							Self.state = STATE_PAUSE_RETRY
							Self.cursor = 1
							break
						Case PLANE_VELOCITY
							Self.state = VISIBLE_OPTION_ITEMS_NUM
							Self.cursor = 0
							break
						Case PAUSE_RACE_TO_TITLE
							Self.state = LOADING_TIME_LIMIT
							Self.cursor = 1
							break
						Case STATE_STAGE_PASS
							optionInit()
							Self.state = 7
							Self.cursor = 0
							break
						Case STATE_STAGE_LOADING
							helpInit()
							Self.state = PAUSE_OPTION_ITEMS_NUM
							Self.cursor = 0
							break
						Case PlayerTails.TAILS_ANI_CELEBRATE_3
							Self.state = 29
							Self.cursor = 0
							break
					End Select
					Key.touchPauseClose(True)
				ElseIf (Key.touchpause1.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + 0
					Key.touchpause1.reset()
				ElseIf (Key.touchpause2.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + 1
					Key.touchpause2.reset()
				ElseIf (Key.touchpause3.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + PLANE_VELOCITY
					Key.touchpause3.reset()
				ElseIf (Key.touchpause4.IsClick()) Then
					PlayerObject.cursor = PlayerObject.cursorIndex + PAUSE_RACE_TO_TITLE
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
				If (PlayerObject.stageModeState <> 0) Then
					If (PlayerObject.stageModeState = 1) Then
						Select (PlayerObject.cursor)
							Case STATE_GAME
								BacktoGame()
								break
							Case STATE_PAUSE
								Self.state = STATE_PAUSE_RETRY
								Self.cursor = 1
								break
							Case PLANE_VELOCITY
								Self.state = VISIBLE_OPTION_ITEMS_NUM
								Self.cursor = 0
								break
							Case PAUSE_RACE_TO_TITLE
								Self.state = LOADING_TIME_LIMIT
								Self.cursor = 1
								break
							Case STATE_STAGE_PASS
								optionInit()
								Self.state = 7
								Self.cursor = 0
								break
							Case STATE_STAGE_LOADING
								helpInit()
								Self.state = PAUSE_OPTION_ITEMS_NUM
								Self.cursor = 0
								break
							Case PlayerTails.TAILS_ANI_CELEBRATE_3
								Self.state = 29
								Self.cursor = 0
								break
							Default
								break
						End Select
					EndIf
				EndIf
				
				Select (PAUSE_NORMAL_MODE[PlayerObject.cursor])
					Case STATE_GAME
						BacktoGame()
						break
					Case STATE_PAUSE
						Self.state = LOADING_TIME_LIMIT
						Self.cursor = 1
						break
					Case PLANE_VELOCITY
						shopInit(True)
						break
					Case PAUSE_RACE_TO_TITLE
						optionInit()
						Self.state = 7
						break
					Case STATE_STAGE_PASS
						helpInit()
						Self.state = PAUSE_OPTION_ITEMS_NUM
						break
				End Select
				Key.clear()
			EndIf
			
			If (Key.press(Key.B_S2)) Then
			EndIf
			
			If (Key.press(Key.B_BACK)) Then
				doReturnGameStuff()
				
				If (PlayerObject.stageModeState = 0) Then
					Key.touchPauseClose(False)
				ElseIf (PlayerObject.stageModeState = 1) Then
					Key.touchPauseClose(True)
				EndIf
				
				Key.touchgamekeyInit()
				Key.touchkeyboardClose()
				Key.touchkeygameboardInit()
				Key.clear()
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
		
		Private Method initTips:Void()
			
			If (Self.loadingWordsDrawer = Null Or Self.loadingDrawer = Null) Then
				Animation animation = New Animation("/animation/loading")
				Self.loadingWordsDrawer = animation.getDrawer(0, True, 0)
				Self.loadingDrawer = animation.getDrawer(0, False, 0)
			EndIf
			
			Self.TIPS = Null
			Select (PlayerObject.getCharacterID())
				Case STATE_GAME
					
					If (StageManager.getCurrentZoneId() <> 8) Then
						Self.TIPS = MyAPI.loadText("/tip/tips_sonic")
						break
					Else
						Self.TIPS = MyAPI.loadText("/tip/tips_ssonic")
						break
					EndIf
					
				Case STATE_PAUSE
					Self.TIPS = MyAPI.loadText("/tip/tips_tails")
					break
				Case PLANE_VELOCITY
					Self.TIPS = MyAPI.loadText("/tip/tips_knuckles")
					break
				Case PAUSE_RACE_TO_TITLE
					Self.TIPS = MyAPI.loadText("/tip/tips_amy")
					break
			End Select
			MyAPI.initString()
			Self.loadingStartTime = Millisecs()
			tipsForShow = Null
			State.fadeInit(255, 0)
		End
		
		Private Method doReturnGameStuff:Void()
			Self.state = STATE_GAME
			GameObject.IsGamePause = False
			State.fadeInit(102, 0)
			
			If (Not StageManager.isStagePass()) Then
				If (PlayerObject.IsInvincibility()) Then
					SoundSystem.getInstance().playBgm(44)
				ElseIf (GameObject.bossFighting) Then
					Select (GameObject.bossID)
						Case PlayerTails.TAILS_ANI_SPRING_2
						Case PlayerTails.TAILS_ANI_CLIFF_2
							
							If (Not GameObject.isBossHalf) Then
								SoundSystem.getInstance().playBgm(23, True)
								break
							Else
								SoundSystem.getInstance().playBgm(24, True)
								break
							EndIf
							
						Case PlayerTails.TAILS_ANI_SPRING_3
						Case PlayerTails.TAILS_ANI_SPRING_4
						Case PlayerTails.TAILS_ANI_SPRING_5
						Case PlayerTails.TAILS_ANI_CLIFF_1
							SoundSystem.getInstance().playBgm(22)
							break
						Case PlayerTails.TAILS_ANI_CELEBRATE_1
							SoundSystem.getInstance().playBgm(25)
							break
						Case PlayerTails.TAILS_ANI_CELEBRATE_2
							SoundSystem.getInstance().playBgm(46)
							break
						Case PlayerTails.TAILS_ANI_CELEBRATE_3
							SoundSystem.getInstance().playBgm(47)
							break
						Case PlayerTails.TAILS_ANI_CELEBRATE_4
							SoundSystem.getInstance().playBgm(19, True)
							break
						Default
							break
					End Select
				Else
					SoundSystem.getInstance().playBgm(StageManager.getBgmId(), True)
				EndIf
			EndIf
			
			Key.initSonic()
		End
		
		Private Method drawLoadingBar:Void(g:MFGraphics, y:Int)
			drawTips(g, y)
			State.drawBar(g, 0, y)
			Self.selectMenuOffsetX += 8
			Self.selectMenuOffsetX Mod= MENU_TITLE_MOVE_DIRECTION
			Int x = 0
			While (x - Self.selectMenuOffsetX > 0) {
				x -= MENU_TITLE_MOVE_DIRECTION
			}
			For (Int i = 0; i < MENU_TITLE_DRAW_NUM; i += 1)
				Int i2 = (MENU_TITLE_MOVE_DIRECTION * i) + x
			Next
		End
		
		Private Method drawTips:Void(g:MFGraphics, endy:Int)
			State.fillMenuRect(g, ((SCREEN_WIDTH - MENU_RECT_WIDTH) - 0) Shr 1, (SCREEN_HEIGHT Shr PLANE_VELOCITY) - 16, MENU_RECT_WIDTH + 0, (SCREEN_HEIGHT Shr 1) + 16)
			
			If (tipsForShow = Null) Then
				tipsForShow = MyAPI.getStrings(tipsString[MyRandom.nextInt(0, tipsString.Length - 1)], MENU_RECT_WIDTH - Self.TIPS_OFFSET_X)
				MyAPI.initString()
				Return
			EndIf
			
			g.setColor(0)
			Int i = Self.TIPS_TITLE_OFFSET_Y + ((SCREEN_HEIGHT Shr PLANE_VELOCITY) - 8)
			MFGraphics mFGraphics = g
			MyAPI.drawBoldString(mFGraphics, "~u5c0f~u63d0~u793a", ((SCREEN_WIDTH - MENU_RECT_WIDTH) + Self.TIPS_OFFSET_X) Shr 1, i, 0, MapManager.END_COLOR, 4656650, 0)
			MyAPI.drawBoldStrings(g, tipsForShow, ((SCREEN_WIDTH - MENU_RECT_WIDTH) + Self.TIPS_OFFSET_X) Shr 1, LINE_SPACE + ((SCREEN_HEIGHT Shr PLANE_VELOCITY) - 8), MENU_RECT_WIDTH - Self.TIPS_OFFSET_X, (SCREEN_HEIGHT Shr 1) - LINE_SPACE, MapManager.END_COLOR, 4656650, 0)
		End
		
		Private Method releaseTips:Void()
			tipsForShow = Null
		End
		
		Private Method stagePassLogic:Void()
			PlayerObject.isNeedPlayWaterSE = False
			
			If (StageManager.isOnlyStagePass) Then
				State.fadeInit(0, 255)
				Self.state = 35
				isThroughGame = True
				loadingType = 0
				StageManager.addStageID()
				SoundSystem.getInstance().stopBgm(False)
			ElseIf (PlayerObject.IsStarttoCnt) Then
				Self.cnt += 1
				
				If (Self.cnt = 1) Then
					If (PlayerObject.stageModeState = 1) Then
						GameObject.ObjectClear()
					EndIf
					
					PlayerObject.isbarOut = True
				EndIf
				
				If (Self.cnt = PLANE_VELOCITY) Then
					SoundSystem.getInstance().playSe(32, False)
				EndIf
				
				If (Self.cnt > 20) Then
					If (Self.cnt = 21) Then
						If (PlayerObject.stageModeState = 0) Then
							GameObject.player.setStagePassRunOutofScreen()
						ElseIf (PlayerObject.stageModeState = 1) Then
							If (PlayerObject.IsDisplayRaceModeNewRecord) Then
								Self.racemode_cnt = 128
							Else
								Self.racemode_cnt = 60
							EndIf
						EndIf
						
					ElseIf (Self.cnt > 21 And PlayerObject.stageModeState = 0 And GameObject.player.stagePassRunOutofScreenLogic()) Then
						If (StageManager.IsStageEnd()) Then
							StageManager.characterFromGame = -1
							StageManager.stageIDFromGame = -1
							StageManager.saveStageRecord()
							State.setState(11)
						ElseIf (StageManager.getStageID() <> 12) Then
							State.fadeInit(0, 255)
							Self.state = 35
							isThroughGame = True
							loadingType = 0
							StageManager.addStageID()
							StageManager.characterFromGame = PlayerObject.getCharacterID()
							StageManager.stageIDFromGame = StageManager.getStageID()
							StageManager.saveStageRecord()
							SoundSystem.getInstance().stopBgm(False)
						ElseIf (StageManager.isGoingToExtraStage()) Then
							State.fadeInit(0, 255)
							Self.state = 35
							isThroughGame = True
							loadingType = 0
							StageManager.addStageID()
							SoundSystem.getInstance().stopBgm(False)
						Else
							StageManager.characterFromGame = -1
							StageManager.stageIDFromGame = -1
							StageManager.saveStageRecord()
							State.setState(LOADING_TIME_LIMIT)
						EndIf
					EndIf
					
					If (Self.cnt = Self.racemode_cnt) Then
						If (PlayerObject.stageModeState = 1) Then
							setStateWithFade(STATE_SET_PARAM)
							Key.touchgamekeyClose()
							Key.touchkeygameboardClose()
							Key.touchkeyboardInit()
						EndIf
						
						StageManager.saveHighScoreRecord()
					EndIf
				EndIf
			EndIf
			
		End
		
		Private Method drawSaw:Void(g:MFGraphics, x:Int, y:Int)
			stageInfoAniDrawer.draw(g, PlayerObject.getCharacterID(), x, y, False, 0)
		End
		
		Private Method drawWhiteBar:Void(g:MFGraphics, x:Int, y:Int)
			g.setColor(MapManager.END_COLOR)
			MyAPI.fillRect(g, x, y - 10, SCREEN_WIDTH, 20)
		End
		
		Private Method drawHugeStageName:Void(g:MFGraphics, stageid:Int, x:Int, y:Int)
			Int stage_id
			Self.selectMenuOffsetX -= 8
			Self.selectMenuOffsetX Mod= STAGE_MOVE_DIRECTION
			
			If (stageid < 12) Then
				stage_id = stageid Shr 1
			Else
				stage_id = stageid - PAUSE_RACE_INSTRUCTION
			EndIf
			
			If (stageid = 11) Then
				stage_id = PAUSE_OPTION_ITEMS_NUM
			EndIf
			
			For (Int x1 = Self.selectMenuOffsetX - 294; x1 < SCREEN_WIDTH * PLANE_VELOCITY; x1 += STAGE_MOVE_DIRECTION)
				MFGraphics mFGraphics = g
				stageInfoAniDrawer.draw(mFGraphics, stage_id + PAUSE_RACE_INSTRUCTION, x1, (y - 10) + PLANE_VELOCITY, False, 0)
			Next
		End
		
		Private Method drawTinyStageName:Void(g:MFGraphics, stageid:Int, x:Int, y:Int)
			Int stage_id
			
			If (stageid < 11) Then
				stage_id = stageid Shr 1
			Else
				stage_id = stageid - PAUSE_RACE_INSTRUCTION
			EndIf
			
			stageInfoAniDrawer.draw(g, stage_id + BIRD_SPACE_2, x, y, False, 0)
		End
		
		Private Method drawSonic:Void(g:MFGraphics, x:Int, y:Int)
			
			If (Self.IsPlayerNameDrawable) Then
				Self.stageInfoPlayerNameDrawer.draw(g, PlayerObject.getCharacterID() + 23, x, y, False, 0)
			EndIf
			
		End
		
		Private Method drawAction:Void(g:MFGraphics, id:Int, x:Int, y:Int)
			
			If (Self.IsActNumDrawable And StageManager.getStageID() < 12) Then
				Self.stageInfoActNumDrawer.draw(g, (StageManager.getStageID() Mod PLANE_VELOCITY) + 27, x, y, False, 0)
			EndIf
			
		End
		
		Public Method pause:Void()
			
			If (Self.state <> STAFF_SHOW_TIME And Self.state <> 18 And Self.state <> 1 And Self.state <> 20 And Self.state <> 23 And Self.state <> 21) Then
				If (Self.state = STATE_GAME And GameObject.player.isDead) Then
					Self.interrupt_state = Self.state
					Self.state = 18
					interruptInit()
				ElseIf (Self.state = STATE_STAGE_LOADING Or Self.state = 35 Or Self.state = STATE_ALL_CLEAR Or Self.state = STATE_STAGE_PASS Or Self.state = 7 Or Self.state = STATE_PAUSE_RETRY Or Self.state = VISIBLE_OPTION_ITEMS_NUM Or Self.state = 29 Or Self.state = LOADING_TIME_LIMIT Or Self.state = PAUSE_OPTION_ITEMS_NUM Or Self.state = 29 Or Self.state = 41 Or Self.state = 42 Or Self.state = STATE_GAME_OVER_PRE Or Self.state = 11 Or Self.state = STATE_GAME_OVER_1 Or Self.state = STATE_GAME_OVER_2 Or Self.state = 30 Or Self.state = 31 Or Self.state = 32 Or Self.state = 33 Or Self.state = 34 Or Self.state = 38 Or Self.state = 39 Or Self.state = 43 Or Self.state = 44 Or Self.state = STAFF_SHOW_TIME) Then
					Self.interrupt_state = Self.state
					Self.state = 18
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
		
		Private Method interruptInit:Void()
			
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
		
		Public Method interruptLogic:Void()
			SoundSystem.getInstance().stopBgm(False)
			
			If (Key.press(Key.B_S2)) Then
			EndIf
			
			If (Key.press(Key.B_BACK) Or (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress())) Then
				fading = lastFading
				SoundSystem.getInstance().playSe(PLANE_VELOCITY)
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
					Case STATE_STAGE_PASS
					Case PlayerTails.TAILS_ANI_POLE_V
						isDrawTouchPad = False
						break
					Case STATE_PAUSE_OPTION
						optionInit()
						State.fadeInit(0, 0)
						Key.touchkeyboardClose()
						Key.touchkeyboardInit()
						isDrawTouchPad = False
						break
					Case STATE_PAUSE_RETRY
					Case STATE_PAUSE_SELECT_STAGE
					Case STATE_PAUSE_TO_TITLE
					Case PlayerTails.TAILS_ANI_CELEBRATE_3
						isDrawTouchPad = False
						break
					Case STATE_TIME_OVER_0
					Case STATE_GAME_OVER_1
					Case STATE_GAME_OVER_2
						break
					Case STATE_ALL_CLEAR
					Case PlayerTails.TAILS_ANI_BAR_STAY
					Case PlayerTails.TAILS_ANI_BAR_MOVE
						isDrawTouchPad = False
						break
					Case PlayerTails.TAILS_ANI_CELEBRATE_4
					Case PlayerTails.TAILS_ANI_BANK_1
					Case PlayerTails.TAILS_ANI_BANK_2
					Case PlayerTails.TAILS_ANI_BANK_3
					Case PlayerTails.TAILS_ANI_UP_ARM
					Case PlayerTails.TAILS_ANI_ROLL_V_2
					Case PlayerTails.TAILS_ANI_ROLL_H_1
						isDrawTouchPad = False
						SoundSystem.getInstance().playBgm(PAUSE_RACE_INSTRUCTION)
						break
					Case PlayerTails.TAILS_ANI_WIND
					Case STAFF_SHOW_TIME
						isDrawTouchPad = False
						break
					Case PlayerTails.TAILS_ANI_RAIL_BODY
						isDrawTouchPad = False
						break
				End Select
				isDrawTouchPad = False
				IsInInterrupt = False
			EndIf
			
		End
		
		Public Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId((Key.touchinterruptreturn.Isin() ? 1 : 0) + 0)
			Self.interruptDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
		End
		
		Private Method optionInit:Void()
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
			Self.optionOffsetYAim = 0
			Self.optionOffsetY = 0
			Self.isChanged = False
			Self.optionslide_getprey = -1
			Self.optionslide_gety = -1
			Self.optionslide_y = 0
			Self.optionDrawOffsetBottomY = 0
			Self.optionYDirect = 0
		End
		
		Private Method itemsid:Int(id:Int)
			Int itemsidoffset = (Self.optionOffsetY / 24) * PLANE_VELOCITY
			
			If (id + itemsidoffset < 0) Then
				Return 0
			EndIf
			
			If (id + itemsidoffset > VISIBLE_OPTION_ITEMS_NUM) Then
				Return VISIBLE_OPTION_ITEMS_NUM
			EndIf
			
			Return id + itemsidoffset
		End
		
		Private Method optionLogic:Void()
			
			If (Not Self.isOptionDisFlag) Then
				SoundSystem.getInstance().playBgm(PAUSE_RACE_INSTRUCTION)
				Self.isOptionDisFlag = True
			EndIf
			
			Int i
			
			If (State.fadeChangeOver()) Then
				If (Key.touchmenuoptionreturn.Isin() And Key.touchmenuoption.IsClick()) Then
					Self.returnCursor = 1
				EndIf
				
				Self.optionslide_gety = Key.slidesensormenuoption.getPointerY()
				Self.optionslide_y = 0
				Self.optionslidefirsty = 0
				For (i = 0; i < (Key.touchmenuoptionitems.Length Shr 1); i += 1)
					Key.touchmenuoptionitems[i * PLANE_VELOCITY].setStartY((((i * 24) + 28) + Self.optionDrawOffsetY) + Self.optionslide_y)
					Key.touchmenuoptionitems[(i * PLANE_VELOCITY) + 1].setStartY((((i * 24) + 28) + Self.optionDrawOffsetY) + Self.optionslide_y)
				Next
				
				If (Self.isSelectable) Then
					For (i = 0; i < Key.touchmenuoptionitems.Length; i += 1)
						
						If (Key.touchmenuoptionitems[i].Isin() And Key.touchmenuoption.IsClick()) Then
							Self.pauseOptionCursor = i / PLANE_VELOCITY
							Self.returnCursor = 0
							break
						EndIf
						
					Next
				EndIf
				
				If (Key.touchmenuoptionreturn.Isin() And Key.touchmenuoption.IsClick()) Then
					Self.returnCursor = 1
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchmenuoptionreturn.IsButtonPress() And Self.returnCursor = 1)) And State.fadeChangeOver()) Then
					changeStateWithFade(1)
					SoundSystem.getInstance().stopBgm(False)
					SoundSystem.getInstance().playSe(PLANE_VELOCITY)
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
						Int speed
						
						If (Self.optionDrawOffsetY > 0) Then
							Self.optionYDirect = 1
							speed = (-Self.optionDrawOffsetY) Shr 1
							
							If (speed > -2) Then
								speed = -2
							EndIf
							
							If (Self.optionDrawOffsetY + speed <= 0) Then
								Self.optionDrawOffsetY = 0
								Self.optionYDirect = 0
							Else
								Self.optionDrawOffsetY += speed
							EndIf
							
						ElseIf (Self.optionDrawOffsetY < Self.optionDrawOffsetBottomY) Then
							Self.optionYDirect = PLANE_VELOCITY
							speed = (Self.optionDrawOffsetBottomY - Self.optionDrawOffsetY) Shr 1
							
							If (speed < PLANE_VELOCITY) Then
								speed = PLANE_VELOCITY
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
					If (Key.touchmenuoptionitems[1].IsButtonPress() And Self.pauseOptionCursor = 0 And GlobalResource.soundSwitchConfig <> 0 And State.fadeChangeOver()) Then
						Self.state = 38
						soundVolumnInit()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchmenuoptionitems[3].IsButtonPress() And Self.pauseOptionCursor = 1 And State.fadeChangeOver()) Then
						Self.state = 31
						itemsSelect2Init()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchmenuoptionitems[5].IsButtonPress() And Self.pauseOptionCursor = PLANE_VELOCITY And State.fadeChangeOver()) Then
						Self.state = 33
						itemsSelect2Init()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchmenuoptionitems[7].IsButtonPress() And Self.pauseOptionCursor = PAUSE_RACE_TO_TITLE And State.fadeChangeOver()) Then
						If (GlobalResource.spsetConfig <> 0) Then
							Self.state = 39
							spSenorSetInit()
							SoundSystem.getInstance().playSe(1)
						Else
							SoundSystem.getInstance().playSe(PLANE_VELOCITY)
						EndIf
						
					ElseIf (Key.touchmenuoptionitems[8].IsButtonPress() And Self.pauseOptionCursor = PAUSE_RACE_OPTION And State.fadeChangeOver()) Then
						changeStateWithFade(34)
						helpInit()
						SoundSystem.getInstance().playSe(1)
					EndIf
				EndIf
				
				Self.optionslide_getprey = Self.optionslide_gety
				Return
			EndIf
			
			For (i = 0; i < Key.touchmenuoptionitems.Length; i += 1)
				Key.touchmenuoptionitems[i].resetKeyState()
			Next
		End
		
		Private Method releaseOptionItemsTouchKey:Void()
			For (Int i = 0; i < Key.touchmenuoptionitems.Length; i += 1)
				Key.touchmenuoptionitems[i].resetKeyState()
			Next
		End
		
		Private Method optionDraw:Void(g:MFGraphics)
			Int i
			g.setColor(0)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			muiAniDrawer.setActionId(52)
			For (Int i2 = 0; i2 < (SCREEN_WIDTH / 48) + 1; i2 += 1)
				For (Int j = 0; j < (SCREEN_HEIGHT / 48) + 1; j += 1)
					muiAniDrawer.draw(g, i2 * 48, j * 48)
				Next
			Next
			
			If (Self.state <> 7) Then
				Self.pauseOptionCursor = -2
			EndIf
			
			muiAniDrawer.setActionId(25)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 0)
			AnimationDrawer animationDrawer = muiAniDrawer
			
			If (GlobalResource.soundSwitchConfig = 0) Then
				i = 67
			Else
				i = (Key.touchmenuoptionitems[1].Isin() And Self.pauseOptionCursor = 0 And Self.isSelectable) ? 1 : 0
				i += 57
			EndIf
			
			animationDrawer.setActionId(i)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 0)
			muiAniDrawer.setActionId(GlobalResource.soundConfig + 73)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 0)
			muiAniDrawer.setActionId(21)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			animationDrawer = muiAniDrawer
			
			If (Key.touchmenuoptionitems[3].Isin() And Self.pauseOptionCursor = 1 And Self.isSelectable) Then
				i = 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 57)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			animationDrawer = muiAniDrawer
			
			If (GlobalResource.vibrationConfig = 0) Then
				i = 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 35)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			muiAniDrawer.setActionId(23)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			animationDrawer = muiAniDrawer
			
			If (Key.touchmenuoptionitems[5].Isin() And Self.pauseOptionCursor = PLANE_VELOCITY And Self.isSelectable) Then
				i = 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 57)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			animationDrawer = muiAniDrawer
			
			If (GlobalResource.spsetConfig = 0) Then
				i = 0
			Else
				i = 1
			EndIf
			
			animationDrawer.setActionId(i + 37)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			muiAniDrawer.setActionId(24)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
			animationDrawer = muiAniDrawer
			
			If (GlobalResource.spsetConfig = 0) Then
				i = 67
			Else
				i = (Key.touchmenuoptionitems[7].Isin() And Self.pauseOptionCursor = PAUSE_RACE_TO_TITLE And Self.isSelectable) ? 1 : 0
				i += 57
			EndIf
			
			animationDrawer.setActionId(i)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
			Select (GlobalResource.sensorConfig)
				Case STATE_GAME
					muiAniDrawer.setActionId(70)
					break
				Case STATE_PAUSE
					muiAniDrawer.setActionId(69)
					break
				Case PLANE_VELOCITY
					muiAniDrawer.setActionId(68)
					break
			End Select
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
			animationDrawer = muiAniDrawer
			
			If (Key.touchmenuoptionitems[8].Isin() And Self.pauseOptionCursor = PAUSE_RACE_OPTION And Self.isSelectable) Then
				i = 1
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 27)
			muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 96)
			Self.optionOffsetX -= PAUSE_RACE_OPTION
			Self.optionOffsetX Mod= OPTION_MOVING_INTERVAL
			muiAniDrawer.setActionId(51)
			For (Int x1 = Self.optionOffsetX; x1 < SCREEN_WIDTH * PLANE_VELOCITY; x1 += OPTION_MOVING_INTERVAL)
				muiAniDrawer.draw(g, x1, 0)
			Next
			animationDrawer = muiAniDrawer
			
			If (Key.touchmenuoptionreturn.Isin()) Then
				i = PAUSE_RACE_INSTRUCTION
			Else
				i = 0
			EndIf
			
			animationDrawer.setActionId(i + 61)
			muiAniDrawer.draw(g, 0, SCREEN_HEIGHT)
			State.drawFade(g)
		End
		
		Private Method setStateWithFade:Void(nState:Int)
			Self.isStateClassSwitch = True
			
			If (Not fading) Then
				fading = True
				State.fadeInit(0, 255)
				Self.stateForSet = nState
			EndIf
			
		End
		
		Public Method changeStateWithFade:Void(nState:Int)
			Self.isStateClassSwitch = False
			
			If (Not fading) Then
				fading = True
				
				If (nState = 7) Then
					State.fadeInit(102, 255)
				Else
					State.fadeInit(0, 255)
				EndIf
				
				Self.nextState = nState
				Self.fadeChangeState = True
			EndIf
			
		End
		
		Public Method fadeStateLogic:Void()
			
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
		
		Private Method endingInit:Void()
			Self.planeDrawer = New Animation("/animation/ending/ending_plane").getDrawer()
			Self.cloudDrawer = New Animation("/animation/ending/ending_cloud").getDrawer()
			Animation birdAnimation = New Animation("/animation/ending/ending_bird")
			Self.birdDrawer = New AnimationDrawer[LOADING_TIME_LIMIT]
			For (Int i = 0; i < LOADING_TIME_LIMIT; i += 1)
				Self.birdDrawer[i] = birdAnimation.getDrawer()
			Next
			Self.endingState = STATE_GAME
			Self.cloudCount = 0
			Self.count = 20
			planeInit()
			birdInit()
			staffInit()
			SoundSystem.getInstance().playBgm(33, False)
		End
		
		Private Method endingLogic:Void()
			
			If (Self.count > 0) Then
				Self.count -= 1
			EndIf
			
			degreeLogic()
			cloudLogic()
			Select (Self.endingState)
				Case STATE_GAME
					
					If (Self.count = 0) Then
						Self.endingState = WHITE_BAR
					EndIf
					
				Case STATE_PAUSE
					planeLogic()
					
					If (Self.planeX = (SCREEN_WIDTH Shr 1)) Then
						Self.endingState = VX
					EndIf
					
				Case PLANE_VELOCITY
					
					If (birdLogic()) Then
						Self.endingState = VY
					EndIf
					
				Case PAUSE_RACE_TO_TITLE
					
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
						Self.position = MyAPI.calNextPositionReverse(Self.position, SCREEN_WIDTH Shr 1, (SCREEN_WIDTH * PAUSE_RACE_TO_TITLE) Shr 1, 1, PAUSE_RACE_TO_TITLE)
						
						If (Self.position = ((SCREEN_WIDTH * PAUSE_RACE_TO_TITLE) Shr 1)) Then
							Self.outing = False
							Self.position = (-SCREEN_WIDTH) Shr 1
							Self.endingState = STATE_STAGE_PASS
							Key.touchkeyboardClose()
							Key.touchkeyboardInit()
							Return
						EndIf
						
						Return
					EndIf
					
					Self.position = MyAPI.calNextPosition((Double) Self.position, (Double) (SCREEN_WIDTH Shr 1), 1, PAUSE_RACE_TO_TITLE)
					
					If (Self.position = (SCREEN_WIDTH Shr 1)) Then
						Self.outing = True
						Self.showCount = STAFF_SHOW_TIME
						Self.changing = False
					EndIf
					
				Case STATE_STAGE_PASS
					staffLogic()
					
					If (Not Self.changing And Self.showCount = 0 And Self.stringCursor >= STAFF_STR.Length - 1) Then
						Self.endingState = STATE_STAGE_LOADING
					EndIf
					
				Case STATE_STAGE_LOADING
					
					If (Key.press(Key.B_S1 | Key.gSelect)) Then
						SoundSystem.getInstance().stopBgm(True)
						setStateWithFade(PAUSE_RACE_OPTION)
					EndIf
					
				Default
			End Select
		End
		
		Private Method endingDraw:Void(g:MFGraphics)
			g.setColor(35064)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			cloudDraw(g)
			birdDraw1(g)
			planeDraw(g)
			birdDraw2(g)
			Select (Self.endingState)
				Case PAUSE_RACE_TO_TITLE
					State.drawMenuFontById(g, 79, Self.position, 0)
				Case STATE_STAGE_PASS
					staffDraw(g)
				Case STATE_STAGE_LOADING
					staffDraw(g)
					State.drawSoftKey(g, True, False)
				Default
			End Select
		End
		
		Private Method cloudLogic:Void()
			
			If (Self.cloudCount > 0) Then
				Self.cloudCount -= 1
			EndIf
			
			For (Int i = 0; i < LOADING_TIME_LIMIT; i += 1)
				
				If (Self.cloudInfo[i][0] <> 0) Then
					Int[] iArr = Self.cloudInfo[i]
					iArr[1] + CLOUD_VELOCITY[Self.cloudInfo[i][0] -= 1]
					
					If (Self.cloudInfo[i][1] >= SCREEN_WIDTH + 75) Then
						Self.cloudInfo[i][0] = 0
					EndIf
				EndIf
				
				If (Self.cloudInfo[i][0] = 0 And Self.cloudCount = 0) Then
					Self.cloudInfo[i][0] = MyRandom.nextInt(1, PAUSE_RACE_TO_TITLE)
					Self.cloudInfo[i][1] = 0
					Self.cloudInfo[i][2] = MyRandom.nextInt(20, SCREEN_HEIGHT - 40)
					Self.cloudCount = MyRandom.nextInt(8, 20)
				EndIf
				
			Next
		End
		
		Private Method cloudDraw:Void(g:MFGraphics)
			For (Int i = 0; i < LOADING_TIME_LIMIT; i += 1)
				
				If (Self.cloudInfo[i][0] <> 0) Then
					Self.cloudDrawer.setActionId(Self.cloudInfo[i][0] - 1)
					Self.cloudDrawer.draw(g, Self.cloudInfo[i][1], Self.cloudInfo[i][2])
				EndIf
				
			Next
		End
		
		Private Method planeInit:Void()
			Self.planeX = SCREEN_WIDTH + 60
			Self.planeY = (SCREEN_HEIGHT * PAUSE_RACE_OPTION) / PAUSE_RACE_INSTRUCTION
		End
		
		Private Method planeLogic:Void()
			Self.planeX -= PLANE_VELOCITY
			
			If (Self.planeX < (SCREEN_WIDTH Shr 1)) Then
				Self.planeX = SCREEN_WIDTH Shr 1
			EndIf
			
		End
		
		Private Method planeDraw:Void(g:MFGraphics)
			Self.planeDrawer.draw(g, Self.planeX, Self.planeY + getOffsetY(0))
		End
		
		Private Method birdInit:Void()
			Int i
			
			For (i = PAUSE_RACE_OPTION; i >= 0; i -= 1)
				Self.birdInfo[i][1] = (Self.planeY - ((PAUSE_RACE_INSTRUCTION - i) * LOADING_TIME_LIMIT)) - 30
				Self.birdInfo[i][0] = (PAUSE_RACE_INSTRUCTION - i) * LOADING_TIME_LIMIT
				Self.birdInfo[i][2] = MyRandom.nextInt(360) ' MDPhone.SCREEN_WIDTH
			Next
			
			For (i = PAUSE_RACE_INSTRUCTION; i < LOADING_TIME_LIMIT; i += 1)
				Self.birdInfo[i][1] = (Self.planeY - ((PAUSE_RACE_OPTION - i) * BIRD_SPACE_2)) - 15
				Self.birdInfo[i][0] = (PAUSE_RACE_OPTION - i) * -14
				Self.birdInfo[i][2] = MyRandom.nextInt(360) ' MDPhone.SCREEN_WIDTH
			Next
			
			Self.birdX = SCREEN_WIDTH + 30
		End
		
		Private Method birdLogic:Bool()
			Self.birdX -= PLANE_VELOCITY
			
			If (Self.birdX >= (SCREEN_WIDTH Shr 1) + 30) Then
				Return False
			EndIf
			
			Self.birdX = (SCREEN_WIDTH Shr 1) + 30
			Return True
		End
		
		Private Method birdDraw1:Void(g:MFGraphics)
			For (Int i = 0; i < PAUSE_RACE_INSTRUCTION; i += 1)
				Self.birdDrawer[i].draw(g, Self.birdX + Self.birdInfo[i][0], Self.birdInfo[i][1] + getOffsetY(Self.birdInfo[i][2]))
			Next
		End
		
		Private Method birdDraw2:Void(g:MFGraphics)
			For (Int i = PAUSE_RACE_INSTRUCTION; i < LOADING_TIME_LIMIT; i += 1)
				Self.birdDrawer[i].draw(g, Self.birdX + Self.birdInfo[i][0], Self.birdInfo[i][1] + getOffsetY(Self.birdInfo[i][2]))
			Next
		End
		
		Private Method degreeLogic:Void()
			Self.degree += LOADING_TIME_LIMIT
			Self.degree Mod= 360
		End
		
		Private Method getOffsetY:Int(degreeOffset:Int)
			Return (MyAPI.dSin(Self.degree + degreeOffset) * LOADING_TIME_LIMIT) / OPTION_MOVING_INTERVAL
		End
		
		Private Method staffInit:Void()
			Self.colorCursor = MyRandom.nextInt(COLOR_SEQ.Length)
			Self.stringCursor = 0
			Self.position = (-SCREEN_WIDTH) Shr 1
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
				Self.position = MyAPI.calNextPositionReverse(Self.position, SCREEN_WIDTH Shr 1, (SCREEN_WIDTH * PAUSE_RACE_TO_TITLE) Shr 1, 1, PAUSE_RACE_TO_TITLE)
				
				If (Self.position = ((SCREEN_WIDTH * PAUSE_RACE_TO_TITLE) Shr 1)) Then
					Self.outing = False
					Self.position = (-SCREEN_WIDTH) Shr 1
					Self.stringCursor += 1
					Self.colorCursor += MyRandom.nextInt(1, COLOR_SEQ.Length - 1)
					Self.colorCursor Mod= COLOR_SEQ.Length
					Return
				EndIf
				
				Return
			EndIf
			
			Self.position = MyAPI.calNextPosition((Double) Self.position, (Double) (SCREEN_WIDTH Shr 1), 1, PAUSE_RACE_TO_TITLE)
			
			If (Self.position = (SCREEN_WIDTH Shr 1)) Then
				Self.changing = False
				Self.outing = True
				Self.showCount = STAFF_SHOW_TIME
			EndIf
			
		End
		
		Private Method staffDraw:Void(g:MFGraphics)
		End
		
		Private Function drawTouchKeyPause:Void(g:MFGraphics)
		}
		
		Private Function drawTouchKeyPauseOption:Void(g:MFGraphics)
		}
		
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
			Int drawNum = (((SCREEN_WIDTH + space) - 1) / space) + PLANE_VELOCITY
			For (Int i = 0; i < drawNum; i += 1)
				MyAPI.drawBoldString(g, string, (x + (i * space)) - Self.itemOffsetX, y, 17, color1, color2, color3)
			Next
		End
		
		Public Method BP_GotoTryPaying:Void()
			
			If (StageManager.getStageID() = 1 And Not IsPaid) Then
				BP_continueTryInit()
			EndIf
			
			If (StageManager.getStageID() = PLANE_VELOCITY And Not IsPaid) Then
				Self.state = 20
				BP_enteredPaying = False
				Self.BP_IsFromContinueTry = False
				BP_payingInit(PAUSE_RACE_OPTION, PAUSE_RACE_TO_TITLE)
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
			PlayerObject.cursorMax = PLANE_VELOCITY
			
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
					BP_payingInit(PAUSE_RACE_OPTION, PAUSE_RACE_TO_TITLE)
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
			State.drawMenuFontById(g, 119, SCREEN_WIDTH Shr 1, ((Self.BP_CONTINUETRY_MENU_START_Y + 15) + ((MENU_SPACE * PAUSE_RACE_TO_TITLE) / PLANE_VELOCITY)) + (MENU_SPACE * ((PlayerObject.cursor + strForShow.Length) - 1)))
			State.drawMenuFontById(g, 113, (SCREEN_WIDTH Shr 1) - 56, ((Self.BP_CONTINUETRY_MENU_START_Y + 15) + ((MENU_SPACE * PAUSE_RACE_TO_TITLE) / PLANE_VELOCITY)) + (MENU_SPACE * ((PlayerObject.cursor + strForShow.Length) - 1)))
			MyAPI.drawBoldString(g, BPstrings[1], SCREEN_WIDTH Shr 1, (Self.BP_CONTINUETRY_MENU_START_Y + 15) + (MENU_SPACE * ((strForShow.Length - 1) + 1)), 17, MapManager.END_COLOR, 0)
			MyAPI.drawBoldString(g, BPstrings[2], SCREEN_WIDTH Shr 1, (Self.BP_CONTINUETRY_MENU_START_Y + 15) + (MENU_SPACE * ((strForShow.Length - 1) + PLANE_VELOCITY)), 17, MapManager.END_COLOR, 0)
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
			setStateWithFade(PAUSE_RACE_OPTION)
			
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
				State.setState(PLANE_VELOCITY)
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
			PlayerObject.cursorMax = PAUSE_RACE_TO_TITLE
			
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
				PlayerObject.cursor = PLANE_VELOCITY
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
			MyAPI.drawBoldString(g, BPstrings[LOADING_TIME_LIMIT], (CASE_WIDTH Shr PLANE_VELOCITY) + CASE_X, LINE_SPACE + 40, 17, MapManager.END_COLOR, 4656650)
			MyAPI.drawBoldString(g, BPstrings[11], ((CASE_WIDTH * PAUSE_RACE_TO_TITLE) Shr PLANE_VELOCITY) + CASE_X, LINE_SPACE + 40, 17, MapManager.END_COLOR, 4656650)
			For (Int i = 0; i < currentBPItems.Length; i += 1)
				MyAPI.drawImage(g, BP_itemsImg, BP_itemsWidth * currentBPItems[i], 0, BP_itemsWidth, BP_itemsHeight, 0, (CASE_X + (CASE_WIDTH Shr PLANE_VELOCITY)) - (LINE_SPACE Shr 1), (LINE_SPACE * (i + PAUSE_RACE_TO_TITLE)) + 30, PAUSE_RACE_TO_TITLE)
				MyAPI.drawBoldString(g, "~u00d7 " + currentBPItemsNormalNum[i], BP_itemsWidth + ((CASE_X + (CASE_WIDTH Shr PLANE_VELOCITY)) - (LINE_SPACE Shr 1)), ((LINE_SPACE * (i + PAUSE_RACE_TO_TITLE)) + 30) - FONT_H_HALF, 20, MapManager.END_COLOR, 4656650)
				MyAPI.drawBoldString(g, BP_items_num[currentBPItems[i]], (FONT_WIDTH_NUM * PLANE_VELOCITY) + (CASE_X + ((CASE_WIDTH * PAUSE_RACE_TO_TITLE) Shr PLANE_VELOCITY)), ((LINE_SPACE * (i + PAUSE_RACE_TO_TITLE)) + 30) - FONT_H_HALF, 24, MapManager.END_COLOR, 4656650)
			Next
			State.drawMenuFontById(g, 113, ((CASE_X + (CASE_WIDTH Shr PLANE_VELOCITY)) - (LINE_SPACE Shr 1)) - (BP_itemsWidth * PLANE_VELOCITY), (LINE_SPACE * (PlayerObject.cursor + PAUSE_RACE_TO_TITLE)) + 30)
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
			
			If (State.BP_chargeLogic(PLANE_VELOCITY)) Then
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
				Case PLANE_VELOCITY
					Return PlayerObject.IsUnderSheild()
				Case PAUSE_RACE_TO_TITLE
					Return PlayerObject.IsSpeedUp()
				Default
					Return False
			End Select
		End
		
		Public Method BP_toolsuseLogic:Void()
			Bool IsUp
			Bool IsDown
			Key.touchkeyboardInit()
			PlayerObject.cursorMax = PAUSE_RACE_TO_TITLE
			
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
				Self.state = 26
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
							GameObject.player.getItem(PAUSE_RACE_TO_TITLE)
							break
						Case STATE_PAUSE
							GameObject.player.getItem(PLANE_VELOCITY)
							break
						Case PLANE_VELOCITY
							GameObject.player.getItem(1)
							break
						Case PAUSE_RACE_TO_TITLE
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
			MyAPI.drawImage(g, BP_wordsImg, 0, BP_wordsHeight, BP_wordsWidth, BP_wordsHeight, 0, SCREEN_WIDTH Shr 1, LINE_SPACE + ((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y), PAUSE_RACE_TO_TITLE)
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
				
				MyAPI.drawImage(g, mFImage, i3, i2, BP_itemsWidth, BP_itemsHeight, 0, (SCREEN_WIDTH Shr 1) - (BP_itemsWidth * PLANE_VELOCITY), (MENU_SPACE * i) + (((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE), PAUSE_OPTION_ITEMS_NUM)
				g.setColor(0)
				MFGraphics mFGraphics = g
				MyAPI.drawBoldString(mFGraphics, "~u00d7", SCREEN_WIDTH Shr 1, ((((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE) + (MENU_SPACE * i)) - FONT_H_HALF, 17, MapManager.END_COLOR, 4656650)
				MyAPI.drawBoldString(g, BP_items_num[currentBPItems[i]], (BP_itemsWidth * PLANE_VELOCITY) + (SCREEN_WIDTH Shr 1), ((((((SCREEN_HEIGHT Shr 1) + PlayerObject.PAUSE_FRAME_OFFSET_Y) + LOADING_TIME_LIMIT) + (MENU_SPACE Shr 1)) + MENU_SPACE) + (MENU_SPACE * i)) - FONT_H_HALF, 24, MapManager.END_COLOR, 4656650)
				i += 1
			}
			
			If (BP_items_num[currentBPItems[PlayerObject.cursor]] = Null) Then
				Self.tooltipY = MyAPI.calNextPosition((Double) Self.tooltipY, (Double) TOOL_TIP_Y_DES, 1, PAUSE_RACE_TO_TITLE)
			Else
				Self.tooltipY = MyAPI.calNextPositionReverse(Self.tooltipY, TOOL_TIP_Y_DES, TOOL_TIP_Y_DES_2, 1, PAUSE_RACE_TO_TITLE)
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
				Case PLANE_VELOCITY
					g.setColor(0)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					g.setColor(MapManager.END_COLOR)
					MyAPI.fillRect(g, 0, ((SCREEN_HEIGHT Shr 1) - 36) - 10, SCREEN_WIDTH, 20)
					break
			End Select
			Self.loadingWordsDrawer.draw(g, SCREEN_WIDTH, SCREEN_HEIGHT)
			Self.loadingDrawer.setActionId(1)
			Self.loadingDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
			
			If (tipsForShow = Null) Then
				tipsForShow = MyAPI.getStrings(Self.TIPS[MyRandom.nextInt(0, Self.TIPS.Length - 1)], PlayerObject.SONIC_ATTACK_LEVEL_3_V0)
				MyAPI.initString()
				Return
			EndIf
			
			MyAPI.drawStrings(g, tipsForShow, (SCREEN_WIDTH Shr 1) - 72, ((SCREEN_HEIGHT Shr 1) - 50) - PLANE_VELOCITY, 132, OPTION_MOVING_INTERVAL, 20, MapManager.END_COLOR, 4656650, 0)
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
			Self.display[PAUSE_RACE_OPTION][0] = SCREEN_WIDTH
			Self.display[PAUSE_RACE_OPTION][1] = SCREEN_HEIGHT
			Self.display[PAUSE_RACE_OPTION][2] = 0
			Self.display[PAUSE_RACE_OPTION][3] = 0
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
			Self.display[PAUSE_RACE_OPTION][0] = SCREEN_WIDTH
			Self.display[PAUSE_RACE_OPTION][1] = SCREEN_HEIGHT
			Self.display[PAUSE_RACE_OPTION][2] = 0
			Self.display[PAUSE_RACE_OPTION][3] = 0
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
			Self.state = 42
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
			Self.continueNumberState = PAUSE_RACE_TO_TITLE
			Self.continueStartEndFrame = Self.continueFrame
			StageManager.resetStageIdforContinueEnd()
			Key.touchgameoverensurekeyClose()
			isThroughGame = False
		End
		
		Private Method drawGameOver:Void(g:MFGraphics)
			
			If (Self.continueFrame <= PAUSE_RACE_INSTRUCTION) Then
				MyAPI.drawScaleAni(g, guiAniDrawer, 11, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28, Self.continueScale, 1.0, 0.0, 0.0)
			ElseIf (Self.continueFrame <= LOADING_TIME_LIMIT) Then
				MyAPI.drawScaleAni(g, guiAniDrawer, 12, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 28, Self.continueScale, 1.0, 0.0, 0.0)
			EndIf
			
			If (Self.continueFrame > LOADING_TIME_LIMIT) Then
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
			
			If (PlayerObject.stageModeState = 0) Then
				Self.pause_item_y = (SCREEN_HEIGHT Shr 1) - 36
				Key.touchGamePauseInit(0)
			ElseIf (PlayerObject.stageModeState = 1) Then
				Self.pause_item_y = (SCREEN_HEIGHT Shr 1) - 60
				Key.touchGamePauseInit(1)
			EndIf
			
			Self.pause_item_speed = (-((SCREEN_WIDTH Shr 1) + BIRD_SPACE_2)) / PAUSE_RACE_TO_TITLE
			
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
				Int items = PlayerObject.stageModeState = 0 ? PAUSE_RACE_TO_TITLE : PAUSE_OPTION_ITEMS_NUM
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
					SoundSystem.getInstance().playSe(PLANE_VELOCITY)
				EndIf
				
				If (Self.pause_returnFlag) Then
					If (Self.pausecnt > Self.pause_returnframe And Self.pausecnt <= Self.pause_returnframe + PAUSE_RACE_TO_TITLE) Then
						Self.pause_saw_x -= Self.pause_saw_speed
						Self.pause_item_x -= Self.pause_item_speed
					ElseIf (Self.pausecnt > Self.pause_returnframe + PAUSE_RACE_TO_TITLE) Then
						BacktoGame()
						isDrawTouchPad = True
						Self.pause_returnFlag = False
						State.setFadeOver()
					EndIf
				EndIf
				
				If (Self.pause_optionFlag And Self.pausecnt > Self.pause_optionframe + PAUSE_RACE_TO_TITLE) Then
					optionInit()
					Self.state = 7
					Self.pause_optionFlag = False
				EndIf
				
				If (Not State.fadeChangeOver()) Then
					For (i = 0; i < items; i += 1)
						Key.touchgamepauseitem[i].resetKeyState()
					Next
				ElseIf (PlayerObject.stageModeState = 0) Then
					If (Key.touchgamepauseitem[0].IsButtonPress() And Self.pause_item_cursor = 0 And Not Self.pause_returnFlag) Then
						Self.pause_returnFlag = True
						Self.pause_returnframe = Self.pausecnt
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchgamepauseitem[1].IsButtonPress() And Self.pause_item_cursor = 1 And State.fadeChangeOver()) Then
						Self.state = LOADING_TIME_LIMIT
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchgamepauseitem[2].IsButtonPress() And Self.pause_item_cursor = PLANE_VELOCITY And Not Self.pause_returnFlag) Then
						changeStateWithFade(7)
						optionInit()
						SoundSystem.getInstance().playSe(1)
					EndIf
					
				ElseIf (PlayerObject.stageModeState <> 1) Then
				Else
					
					If (Key.touchgamepauseitem[0].IsButtonPress() And Self.pause_item_cursor = 0 And Not Self.pause_returnFlag) Then
						Self.pause_returnFlag = True
						Self.pause_returnframe = Self.pausecnt
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchgamepauseitem[1].IsButtonPress() And Self.pause_item_cursor = 1 And State.fadeChangeOver()) Then
						Self.state = STATE_PAUSE_RETRY
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchgamepauseitem[2].IsButtonPress() And Self.pause_item_cursor = PLANE_VELOCITY And State.fadeChangeOver()) Then
						Self.state = 29
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchgamepauseitem[3].IsButtonPress() And Self.pause_item_cursor = PAUSE_RACE_TO_TITLE And State.fadeChangeOver()) Then
						Self.state = VISIBLE_OPTION_ITEMS_NUM
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchgamepauseitem[PAUSE_RACE_OPTION].IsButtonPress() And Self.pause_item_cursor = PAUSE_RACE_OPTION And State.fadeChangeOver()) Then
						Self.state = LOADING_TIME_LIMIT
						State.fadeInit(102, 220)
						secondEnsureInit()
						SoundSystem.getInstance().playSe(1)
					ElseIf (Key.touchgamepauseitem[5].IsButtonPress() And Self.pause_item_cursor = PAUSE_RACE_INSTRUCTION And Not Self.pause_returnFlag) Then
						changeStateWithFade(7)
						optionInit()
						SoundSystem.getInstance().playSe(1)
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
			
			If (Self.pausecnt <= PAUSE_RACE_INSTRUCTION) Then
				Return
			EndIf
			
			AnimationDrawer animationDrawer
			Int i
			
			If (PlayerObject.stageModeState = 0) Then
				animationDrawer = muiAniDrawer
				
				If (Self.pause_item_cursor = 0 And Key.touchgamepauseitem[0].Isin()) Then
					i = 1
				Else
					i = 0
				EndIf
				
				animationDrawer.setActionId(i + PLANE_VELOCITY)
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
				
				If (Self.pause_item_cursor = PLANE_VELOCITY And Key.touchgamepauseitem[2].Isin()) Then
					i = 1
				Else
					i = 0
				EndIf
				
				animationDrawer.setActionId(i + 12)
				muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + 48)
			ElseIf (PlayerObject.stageModeState = 1) Then
				Int i2 = 0
				While (i2 < PAUSE_OPTION_ITEMS_NUM) {
					Int i3
					animationDrawer = muiAniDrawer
					i = (i2 + 1) * PLANE_VELOCITY
					
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
					
					If (GameObject.stageModeState = 1) Then
						StageManager.doWhileLeaveRace()
					EndIf
					
					PlayerObject.doPauseLeaveGame()
					
					If (GameObject.stageModeState <> 1) Then
						StageManager.characterFromGame = PlayerObject.getCharacterID()
					EndIf
					
					StageManager.stageIDFromGame = StageManager.getStageID()
					setStateWithFade(PLANE_VELOCITY)
					Key.touchanykeyInit()
					Key.touchMainMenuInit2()
				Case PLANE_VELOCITY
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
				Case PLANE_VELOCITY
					State.fadeInit_Modify(192, 102)
					Self.state = STATE_PAUSE
					GameObject.IsGamePause = True
				Default
			End Select
		End
		
		Private Method pausetoSelectStageLogic:Void()
			Select (secondEnsureLogic())
				Case STATE_PAUSE
					setStateWithFade(STATE_SET_PARAM)
				Case PLANE_VELOCITY
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
					setStateWithFade(VISIBLE_OPTION_ITEMS_NUM)
				Case PLANE_VELOCITY
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
					Self.state = 7
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
					Self.returnCursor = 0
				Case PLANE_VELOCITY
					GlobalResource.soundSwitchConfig = 0
					State.fadeInit(102, 0)
					Self.state = 7
					SoundSystem.getInstance().setSoundState(0)
					SoundSystem.getInstance().setSeState(0)
					Self.returnCursor = 0
				Case PAUSE_RACE_TO_TITLE
					State.fadeInit(102, 0)
					Self.state = 7
					Self.returnCursor = 0
				Default
			End Select
		End
		
		Private Method pauseOptionVibrationLogic:Void()
			Select (itemsSelect2Logic())
				Case STATE_PAUSE
					GlobalResource.vibrationConfig = 1
					State.fadeInit(102, 0)
					Self.state = 7
					Self.returnCursor = 0
					MyAPI.vibrate()
				Case PLANE_VELOCITY
					GlobalResource.vibrationConfig = 0
					State.fadeInit(102, 0)
					Self.state = 7
					Self.returnCursor = 0
				Case PAUSE_RACE_TO_TITLE
					State.fadeInit(102, 0)
					Self.state = 7
					Self.returnCursor = 0
				Default
			End Select
		End
		
		Private Method pauseOptionSpSetLogic:Void()
			Select (itemsSelect2Logic())
				Case STATE_PAUSE
					GlobalResource.spsetConfig = 0
					State.fadeInit(102, 0)
					Self.state = 7
					Self.returnCursor = 0
				Case PLANE_VELOCITY
					GlobalResource.spsetConfig = 1
					State.fadeInit(102, 0)
					Self.state = 7
					Self.returnCursor = 0
				Case PAUSE_RACE_TO_TITLE
					State.fadeInit(102, 0)
					Self.state = 7
					Self.returnCursor = 0
				Default
			End Select
		End
		
		Public Function enterSpStage:Void(ringNum:Int, chekPointID:Int, timeCount:Int)
			spReserveRingNum = ringNum
			spCheckPointID = chekPointID
			spTimeCount = timeCount
			State.setState(PAUSE_OPTION_ITEMS_NUM)
		}
		
		Private Method scoreUpdateInit:Void()
			Key.touchgamekeyClose()
			Key.touchkeygameboardClose()
			Key.touchkeyboardInit()
			Key.touchscoreupdatekeyInit()
			changeStateWithFade(43)
			
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
					Self.scoreUpdateCursor = PLANE_VELOCITY
				EndIf
				
				If (Key.touchscoreupdateyes.IsButtonPress() And Self.scoreUpdateCursor = 1) Then
					Self.state = 44
					secondEnsureInit()
					State.fadeInit(0, GimmickObject.GIMMICK_NUM)
					SoundSystem.getInstance().playSe(1)
				ElseIf (Key.touchscoreupdateno.IsButtonPress() And Self.scoreUpdateCursor = PLANE_VELOCITY) Then
					Standard2.splashinit(True)
					setStateWithFade(0)
					SoundSystem.getInstance().playSe(1)
				EndIf
				
				If ((Key.press(Key.B_BACK) Or (Key.touchscoreupdatereturn.IsButtonPress() And Self.returnCursor = 1)) And State.fadeChangeOver()) Then
					Standard2.splashinit(True)
					setStateWithFade(0)
					SoundSystem.getInstance().playSe(PLANE_VELOCITY)
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
			For (Int x1 = Self.optionOffsetX; x1 < SCREEN_WIDTH * PLANE_VELOCITY; x1 += 128)
				muiAniDrawer.draw(g, x1, 0)
			Next
			guiAniDrawer.setActionId(17)
			guiAniDrawer.draw(g, SCREEN_WIDTH Shr 1, (SCREEN_HEIGHT Shr 1) - 37)
			PlayerObject.drawRecordTime(g, StageManager.getTimeModeScore(PlayerObject.getCharacterID()), (SCREEN_WIDTH Shr 1) + 54, (SCREEN_HEIGHT Shr 1) - 10, PLANE_VELOCITY, PLANE_VELOCITY)
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
				i = PAUSE_RACE_INSTRUCTION
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
					Self.state = STAFF_SHOW_TIME
				Case PLANE_VELOCITY
					Self.state = 43
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
				setStateWithFade(0)
				activity.isResumeFromOtherActivity = False
			EndIf
			
		End
		
		Private Method scoreUpdatedDraw:Void(g:MFGraphics)
		End
End