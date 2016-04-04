Strict

Public

' Imports:
Private
	Import common.barword
	Import common.numberdrawer
	Import common.whitebardrawer
	
	Import ending.specialending
	
	Import gameengine.def
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.myrandom
	Import lib.record
	Import lib.soundsystem
	
	Import sonicgba.globalresource
	Import sonicgba.mapmanager
	Import sonicgba.playeranimationcollisionrect
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import special.ssdef
	Import special.specialmap
	Import special.specialobject
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	Import com.sega.mobile.framework.ui.mftouchkey
	
	#Rem
		Import java.io.Bytearrayinputstream
		Import java.io.Bytearrayoutputstream
		Import java.io.datainputstream
		Import java.io.dataoutputstream
		Import java.util.vector
	#End
	
	Import brl.stream
	Import brl.datastream
	'Import brl.filestream
	
	Import monkey.stack
Public

' Classes:
Class SpecialStageState Extends State Implements SSDef, BarWord
	Private
		' Constant variable(s):
		Global BONUS_ID:Int[] = [22, 23, 24] ' Const
		
		Const BONUS_NUM_X:Int = ((SCREEN_WIDTH Shr 1) + 75)
		Const BONUS_X:Int = ((SCREEN_WIDTH Shr 1) - 79)
		Const BONUS_Y_ORIGINAL:Int = (SCREEN_HEIGHT + 40)
		Const BONUS_Y_SPACE:Int = 18
		Const BONUS_Y_START:Int = ((SCREEN_HEIGHT Shr 1) - 7)
		
		Const EMERALD_SPACE:Int = 32
		Const EMERALD_X_ORIGINAL:Int = (SCREEN_WIDTH + 30)
		Const EMERALD_X_START:Int = ((SCREEN_WIDTH Shr 1) - 96)
		Const EMERALD_Y:Int = ((SCREEN_HEIGHT Shr 1) - EMERALD_SPACE)
		
		Const IS_EMERALD_DEBUG_FULL:Bool = False
		Const OPTION_MOVING_INTERVAL:Int = 100
		Const OPTION_MOVING_SPEED:Int = 4
		Const PAUSE_OPTION_ITEMS_NUM:Int = 6
		
		Const SPEED_LIGHT_NUM_PER_FRAME:Int = 2
		Const SPEED_LIGHT_VELOCITY:Int = 60
		
		Const STATE_END:Int = 3
		Const STATE_GAMING:Int = 2
		Const STATE_GET_EMERALD:Int = 4
		Const STATE_INTERRUPT:Int = 14
		Const STATE_INTRO:Int = 1
		Const STATE_PAUSE:Int = 6
		Const STATE_PAUSE_OPTION:Int = 8
		Const STATE_PAUSE_OPTION_HELP:Int = 13
		Const STATE_PAUSE_OPTION_KEY_CONTROL:Int = 11
		Const STATE_PAUSE_OPTION_SENSOR:Int = 16
		Const STATE_PAUSE_OPTION_SOUND:Int = 9
		Const STATE_PAUSE_OPTION_SOUND_VOLUMN:Int = 15
		Const STATE_PAUSE_OPTION_SP_SET:Int = 12
		Const STATE_PAUSE_OPTION_VIB:Int = 10
		Const STATE_PAUSE_TO_TITLE:Int = 7
		Const STATE_READY:Int = 0
		Const STATE_WAIT_FOR_OVER:Int = 5
		
		Const VISIBLE_OPTION_ITEMS_NUM:Int = 9
		
		Const WORD_FINISH_STAGE:Int = 1
		Const WORD_GET_EMERALD:Int = 0
		
		' Global variable(s):
		Global emeraldStatus:Int[] = New Int[7]
	Public
		' Global variable(s):
		Global aButton:MFTouchKey
		Global bButton:MFTouchKey
	Private
		' Fields:
		Field changingState:Bool
		Field fadeChangeState:Bool
		Field isChanged:Bool
		Field isIntroBGMplay:Bool
		Field isOptionChange:Bool
		Field isOptionDisFlag:Bool
		Field isSelectable:Bool
		Field optionReturnFlag:Bool
		Field pause_optionFlag:Bool
		Field pause_returnFlag:Bool
		
		Field barDrawer:WhiteBarDrawer
		Field bonusY:Int[]
		Field characterUpDrawer:AnimationDrawer
		Field characterY:Int
		Field clearScore:Int
		Field count:Int
		Field emeraldX:Int[]
		Field endingInstance:SpecialEnding
		Field fontDrawer:AnimationDrawer
		Field interruptDrawer:AnimationDrawer
		Field interrupt_state:Int
		Field nextState:Int
		Field optionDrawOffsetBottomY:Int
		Field optionDrawOffsetTmpY1:Int
		Field optionDrawOffsetY:Int
		Field optionOffsetTmp:Int
		Field optionOffsetX:Int
		Field optionOffsetY:Int
		Field optionOffsetYAim:Int
		Field optionYDirect:Int
		Field optionslide_getprey:Int
		Field optionslide_gety:Int
		Field optionslide_y:Int
		Field optionslidefirsty:Int
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
		Field preVelZ:Int
		Field ringScore:Int
		Field state:Int
		Field totalScore:Int
		Field readyBgImage:MFImage
		Field speedLight:MFImage
		Field welcomeBgImage:MFImage
		Field speedLightVec:Stack<Int[]>
		
		' Constructor(s):
	Public Method SpecialStageState:public()
		Self.characterY = SCREEN_HEIGHT
		Self.bonusY = New Int[STATE_END]
		Self.emeraldX = New Int[STATE_PAUSE_TO_TITLE]
		Self.isOptionDisFlag = IS_EMERALD_DEBUG_FULL
		Self.optionslide_getprey = -1
		Self.optionslide_gety = -1
		Self.state = STATE_READY
		Self.isIntroBGMplay = IS_EMERALD_DEBUG_FULL
		fading = IS_EMERALD_DEBUG_FULL
		Self.barDrawer = WhiteBarDrawer.getInstance()
		
		If (GlobalResource.spsetConfig = WORD_FINISH_STAGE) Then
			bButton = New MFTouchKey(STATE_READY, STATE_READY, MyAPI.zoomOut(Def.SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(Def.SCREEN_HEIGHT), Key.B_SEL)
			MFDevice.addComponent(bButton)
			aButton = New MFTouchKey(MyAPI.zoomOut(Def.SCREEN_WIDTH) Shr 1, STATE_READY, MyAPI.zoomOut(Def.SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(Def.SCREEN_HEIGHT), Key.B_HIGH_JUMP)
			MFDevice.addComponent(aButton)
		ElseIf (GlobalResource.spsetConfig = 0) Then
			If (bButton <> Null) Then
				MFDevice.removeComponent(bButton)
			EndIf
			
			bButton = Null
			
			If (aButton <> Null) Then
				MFDevice.removeComponent(aButton)
			EndIf
			
			aButton = Null
			Key.touchkeyboardClose()
			Key.touchSpKeyboardInit()
		EndIf
		
		Key.touchSPstageInit()
		loadData()
		
		If (emeraldState(StageManager.getStageID()) <> WORD_FINISH_STAGE) Then
			setEmeraldState(StageManager.getStageID(), STATE_GAMING)
			saveData()
		EndIf
		
	End

	Public Method logic:Void()
		fadeStateLogic()
		
		If (Key.press(Key.B_PO)) Then
		EndIf
		
		Int i
		Select (Self.state)
			Case STATE_READY
				Int[] position
				
				If (State.fadeChangeOver()) Then
					If (Not Self.isIntroBGMplay) Then
						SoundSystem.getInstance().playBgm(34, IS_EMERALD_DEBUG_FULL)
						Self.isIntroBGMplay = True
					EndIf
					
					If (Self.changingState) Then
						Self.state = WORD_FINISH_STAGE
						State.fadeInitAndStart(255, STATE_READY)
						SpecialObject.player.initWelcome()
						Self.changingState = IS_EMERALD_DEBUG_FULL
					Else
						Self.characterY -= STATE_PAUSE_OPTION_SOUND_VOLUMN
						
						If (Self.characterY < -40) Then
							State.fadeInitAndStart(STATE_READY, 255)
							Self.changingState = True
						EndIf
					EndIf
				EndIf
				
				i = STATE_READY
				While (i < Self.speedLightVec.size()) {
					position = (Int[]) Self.speedLightVec.elementAt(i)
					position[WORD_FINISH_STAGE] = position[WORD_FINISH_STAGE] + SPEED_LIGHT_VELOCITY
					
					If (position[WORD_FINISH_STAGE] > SCREEN_HEIGHT + Self.speedLight.getHeight()) Then
						Self.speedLightVec.removeElementAt(i)
						i -= 1
					EndIf
					
					i += WORD_FINISH_STAGE
				}
				For (i = STATE_READY; i < STATE_GAMING; i += WORD_FINISH_STAGE)
					position = New Int[STATE_GAMING]
					position[STATE_READY] = MyRandom.nextInt(STATE_READY, SCREEN_WIDTH)
					position[WORD_FINISH_STAGE] = STATE_READY - (i * 30)
					Self.speedLightVec.addElement(position)
				Next
			Case WORD_FINISH_STAGE
				SpecialObject.player.logicWelcome()
				
				If (Not State.fadeChangeOver()) Then
					Return
				EndIf
				
				If (Self.changingState) Then
					Self.state = STATE_GAMING
					SoundSystem.getInstance().playBgm(35)
					fading = IS_EMERALD_DEBUG_FULL
					State.fadeInit(255, STATE_READY)
					Self.changingState = IS_EMERALD_DEBUG_FULL
				ElseIf (SpecialObject.player.isWelcomeOver()) Then
					State.fadeInitAndStart(STATE_READY, 255)
					Self.changingState = True
				EndIf
				
			Case STATE_GAMING
				SpecialObject.player.logic()
				SpecialObject.objectLogic()
				
				If (Not Self.changingState And SpecialObject.player.isOver()) Then
					State.setFadeColor(MapManager.END_COLOR)
					State.fadeInitAndStart(STATE_READY, 255)
					Self.changingState = True
				EndIf
				
				If (State.fadeChangeOver() And Self.changingState) Then
					Int i2
					Self.state = STATE_END
					State.setFadeColor(STATE_READY)
					fading = IS_EMERALD_DEBUG_FULL
					Self.barDrawer.initBar(Self, SpecialObject.player.checkSuccess ? STATE_READY : WORD_FINISH_STAGE)
					Self.barDrawer.setPause(True)
					Self.changingState = IS_EMERALD_DEBUG_FULL
					Self.count = STATE_READY
					For (i = STATE_READY; i < Self.bonusY.length; i += WORD_FINISH_STAGE)
						Self.bonusY[i] = BONUS_Y_ORIGINAL
					Next
					For (i = STATE_READY; i < Self.emeraldX.length; i += WORD_FINISH_STAGE)
						Self.emeraldX[i] = EMERALD_X_ORIGINAL
					Next
					Self.ringScore = SpecialObject.player.getRingNum() * OPTION_MOVING_INTERVAL
					
					If (SpecialObject.player.checkSuccess) Then
						i2 = 10000
					Else
						i2 = STATE_READY
					EndIf
					
					Self.clearScore = i2
					Self.totalScore = STATE_READY
					
					If (SpecialObject.player.checkSuccess) Then
						setEmeraldState(StageManager.getStageID(), WORD_FINISH_STAGE)
						saveData()
						Self.endingInstance = New SpecialEnding(PlayerObject.getCharacterID(), STAGE_ID_TO_SPECIAL_ID[StageManager.getStageID()])
						Self.state = STATE_GET_EMERALD
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInitAndStart(255, STATE_READY)
						SoundSystem.getInstance().stopBgm(IS_EMERALD_DEBUG_FULL)
					Else
						
						If (emeraldState(StageManager.getStageID()) <> WORD_FINISH_STAGE) Then
							setEmeraldState(StageManager.getStageID(), STATE_GAMING)
							saveData()
						EndIf
						
						SoundSystem.getInstance().playBgm(39)
					EndIf
				EndIf
				
				If (Not SpecialObject.player.isNeedTouchPad()) Then
					Return
				EndIf
				
				If (Key.touchspstagepause.IsButtonPress() Or Key.press(Key.B_BACK)) Then
					SoundSystem.getInstance().playSe(33)
					pauseInit()
				EndIf
				
			Case STATE_END
				Self.count += WORD_FINISH_STAGE
				
				If (Self.count >= STATE_PAUSE_OPTION_HELP) Then
					For (i = STATE_READY; i < STATE_END; i += WORD_FINISH_STAGE)
						
						If (i <= Self.count - STATE_PAUSE_OPTION_HELP) Then
							Self.bonusY[i] = MyAPI.calNextPosition((double) Self.bonusY[i], (double) (BONUS_Y_START + (i * BONUS_Y_SPACE)), WORD_FINISH_STAGE, STATE_GET_EMERALD)
						EndIf
						
					Next
				EndIf
				
				If (Self.count >= STATE_PAUSE_OPTION_SENSOR) Then
					For (i = STATE_READY; i < STATE_PAUSE_TO_TITLE; i += WORD_FINISH_STAGE)
						
						If (i <= Self.count - STATE_PAUSE_OPTION_SENSOR) Then
							Self.emeraldX[i] = MyAPI.calNextPosition((double) Self.emeraldX[i], (double) (EMERALD_X_START + (i * EMERALD_SPACE)), WORD_FINISH_STAGE, STATE_GET_EMERALD)
						EndIf
						
					Next
				EndIf
				
				If (Self.count > 46) Then
					Int scoreChange
					
					If (Self.ringScore > 0) Then
						scoreChange = Min(TitleState.RETURN_PRESSED, Self.ringScore)
						Self.ringScore -= scoreChange
						Self.totalScore += scoreChange
					EndIf
					
					If (Self.clearScore > 0) Then
						scoreChange = Min(TitleState.RETURN_PRESSED, Self.clearScore)
						Self.clearScore -= scoreChange
						Self.totalScore += scoreChange
					EndIf
					
					If (Self.ringScore = 0) Then
						SoundSystem.getInstance().playSe(EMERALD_SPACE)
					Else
						SoundSystem.getInstance().playSe(31)
					EndIf
					
					If (Self.ringScore = 0 And Self.clearScore = 0) Then
						PlayerObject.setScore(PlayerObject.getScore() + Self.totalScore)
						Self.state = STATE_WAIT_FOR_OVER
						Self.count = STATE_READY
					EndIf
				EndIf
				
			Case STATE_GET_EMERALD
				Self.endingInstance.logic()
				
				If (Self.endingInstance.isOver() And Not Self.changingState) Then
					State.setFadeColor(MapManager.END_COLOR)
					State.fadeInitAndStart(STATE_READY, 255)
					Self.changingState = True
				EndIf
				
				If (Not State.fadeChangeOver()) Then
					Return
				EndIf
				
				If (Self.changingState) Then
					Self.state = STATE_END
					SoundSystem.getInstance().playBgm(40)
					Self.changingState = IS_EMERALD_DEBUG_FULL
					State.setFadeColor(STATE_READY)
					fading = IS_EMERALD_DEBUG_FULL
					Return
				EndIf
				
				State.setFadeColor(STATE_READY)
			Case STATE_WAIT_FOR_OVER
				Self.count += WORD_FINISH_STAGE
				
				If (Self.count = 128) Then
					Self.barDrawer.setPause(IS_EMERALD_DEBUG_FULL)
				EndIf
				
				If (Self.barDrawer.getState() = STATE_GET_EMERALD) Then
					backToGameStage()
				EndIf
				
			Case STATE_PAUSE
				pauseLogic()
			Case STATE_PAUSE_TO_TITLE
				pausetoTitleLogic()
			Case STATE_PAUSE_OPTION
				optionLogic()
			Case VISIBLE_OPTION_ITEMS_NUM
				pauseOptionSoundLogic()
			Case STATE_PAUSE_OPTION_VIB
				pauseOptionVibrationLogic()
			Case STATE_PAUSE_OPTION_SP_SET
				pauseOptionSpSetLogic()
			Case STATE_PAUSE_OPTION_HELP
				helpLogic()
				
				If ((Key.press(Key.B_BACK) Or (Key.touchhelpreturn.IsButtonPress() And Self.returnPageCursor = WORD_FINISH_STAGE)) And State.fadeChangeOver()) Then
					changeStateWithFade(STATE_PAUSE_OPTION)
					AnimationDrawer.setAllPause(True)
					SoundSystem.getInstance().playSe(STATE_GAMING)
				EndIf
				
			Case STATE_INTERRUPT
				interruptLogic()
			Case STATE_PAUSE_OPTION_SOUND_VOLUMN
				Select (soundVolumnLogic())
					Case STATE_GAMING
						State.fadeInit(102, STATE_READY)
						Self.state = STATE_PAUSE_OPTION
					Default
				End Select
			Case STATE_PAUSE_OPTION_SENSOR
				Select (spSenorSetLogic())
					Case WORD_FINISH_STAGE
						GlobalResource.sensorConfig = STATE_READY
						State.fadeInit(102, STATE_READY)
						Self.state = STATE_PAUSE_OPTION
					Case STATE_GAMING
						GlobalResource.sensorConfig = WORD_FINISH_STAGE
						State.fadeInit(102, STATE_READY)
						Self.state = STATE_PAUSE_OPTION
					Case STATE_END
						State.fadeInit(102, STATE_READY)
						Self.state = STATE_PAUSE_OPTION
					Case STATE_GET_EMERALD
						GlobalResource.sensorConfig = STATE_GAMING
						State.fadeInit(102, STATE_READY)
						Self.state = STATE_PAUSE_OPTION
					Default
				End Select
			Default
		End Select
	End

	Private Method pausetoTitleLogic:Void()
		Select (secondEnsureLogic())
			Case WORD_FINISH_STAGE
				Key.touchanykeyInit()
				Key.touchMainMenuInit2()
				AnimationDrawer.setAllPause(IS_EMERALD_DEBUG_FULL)
				StageManager.characterFromGame = PlayerObject.getCharacterID()
				StageManager.stageIDFromGame = StageManager.getStageID()
				State.setState(STATE_GAMING)
			Case STATE_GAMING
				pauseInitFromItems()
			Default
		End Select
	End

	Private Method pauseOptionSoundLogic:Void()
		Select (itemsSelect2Logic())
			Case WORD_FINISH_STAGE
				GlobalResource.soundConfig = STATE_WAIT_FOR_OVER
				GlobalResource.seConfig = WORD_FINISH_STAGE
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
				SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
				SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
			Case STATE_GAMING
				GlobalResource.soundConfig = STATE_READY
				GlobalResource.seConfig = STATE_READY
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
				SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
				SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
			Case STATE_END
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
				SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
				SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
			Default
		End Select
	End

	Private Method pauseOptionVibrationLogic:Void()
		Select (itemsSelect2Logic())
			Case WORD_FINISH_STAGE
				GlobalResource.vibrationConfig = WORD_FINISH_STAGE
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
				MyAPI.vibrate()
			Case STATE_GAMING
				GlobalResource.vibrationConfig = STATE_READY
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
			Case STATE_END
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
			Default
		End Select
	End

	Private Method pauseOptionSpSetLogic:Void()
		Select (itemsSelect2Logic())
			Case WORD_FINISH_STAGE
				GlobalResource.spsetConfig = STATE_READY
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
				Key.touchkeyboardClose()
				Key.touchSpKeyboardInit()
				
				If (bButton <> Null) Then
					MFDevice.removeComponent(bButton)
					bButton = Null
				EndIf
				
				If (aButton <> Null) Then
					MFDevice.removeComponent(aButton)
					aButton = Null
				EndIf
				
			Case STATE_GAMING
				GlobalResource.spsetConfig = WORD_FINISH_STAGE
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
				Key.touchkeyboardClose()
				
				If (bButton = Null) Then
					bButton = New MFTouchKey(STATE_READY, STATE_READY, MyAPI.zoomOut(Def.SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(Def.SCREEN_HEIGHT), Key.B_SEL)
					MFDevice.addComponent(bButton)
				EndIf
				
				If (aButton = Null) Then
					aButton = New MFTouchKey(MyAPI.zoomOut(Def.SCREEN_WIDTH) Shr 1, STATE_READY, MyAPI.zoomOut(Def.SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(Def.SCREEN_HEIGHT), Key.B_HIGH_JUMP)
					MFDevice.addComponent(aButton)
				EndIf
				
			Case STATE_END
				State.fadeInit(102, STATE_READY)
				Self.state = STATE_PAUSE_OPTION
			Default
		End Select
	End

	Public Method draw:Void(g:MFGraphics)
		Select (Self.state)
			Case STATE_PAUSE_OPTION_HELP
				g.setFont(STATE_PAUSE_OPTION_KEY_CONTROL)
				break
			Default
				g.setFont(STATE_INTERRUPT)
				break
		End Select
		Int i
		Select (Self.state)
			Case STATE_READY
				MyAPI.drawImage(g, Self.readyBgImage, STATE_READY, STATE_READY, STATE_READY)
				For (i = STATE_READY; i < Self.speedLightVec.size(); i += WORD_FINISH_STAGE)
					Int[] position = (Int[]) Self.speedLightVec.elementAt(i)
					MyAPI.drawImage(g, Self.speedLight, position[STATE_READY], position[WORD_FINISH_STAGE], 33)
				Next
				Self.characterUpDrawer.draw(g, SCREEN_WIDTH Shr 1, Self.characterY)
			Case WORD_FINISH_STAGE
				g.setColor(STATE_READY)
				MyAPI.fillRect(g, STATE_READY, STATE_READY, SCREEN_WIDTH, SCREEN_HEIGHT)
				MyAPI.drawImage(g, Self.welcomeBgImage, STATE_READY, STATE_READY, STATE_READY)
				SpecialObject.player.setPause(IS_EMERALD_DEBUG_FULL)
				SpecialObject.player.drawWelcome(g)
			Case STATE_GAMING
				SpecialMap.drawMap(g)
				SpecialObject.drawObjects(g)
				SpecialObject.player.setPause(IS_EMERALD_DEBUG_FULL)
				SpecialObject.player.drawInfo(g)
				
				If (GlobalResource.spsetConfig = 0 And SpecialObject.player.isNeedTouchPad()) Then
					drawTouchKeyDirect(g)
				EndIf
				
				If (SpecialObject.player.isNeedTouchPad()) Then
					State.drawSoftKeyPause(g)
				EndIf
				
			Case STATE_END
			Case STATE_WAIT_FOR_OVER
				g.setColor(MapManager.END_COLOR)
				MyAPI.fillRect(g, STATE_READY, STATE_READY, SCREEN_WIDTH, SCREEN_HEIGHT)
				Self.barDrawer.drawBar(g)
				For (i = STATE_READY; i < Self.bonusY.length; i += WORD_FINISH_STAGE)
					Self.fontDrawer.draw(g, BONUS_ID[i], Self.barDrawer.getBarX() + BONUS_X, Self.bonusY[i], IS_EMERALD_DEBUG_FULL, STATE_READY)
					Int drawNum = STATE_READY
					Select (i)
						Case STATE_READY
							drawNum = Self.ringScore
							break
						Case WORD_FINISH_STAGE
							drawNum = Self.clearScore
							break
						Case STATE_GAMING
							drawNum = Self.totalScore
							break
						Default
							break
					End Select
					NumberDrawer.drawNum(g, STATE_READY, drawNum, Self.barDrawer.getBarX() + ((SCREEN_WIDTH Shr 1) + 75), Self.bonusY[i], STATE_GET_EMERALD)
				Next
				i = STATE_READY
				While (i < STATE_PAUSE_TO_TITLE) {
					Self.fontDrawer.draw(g, emeraldStatus[i] = WORD_FINISH_STAGE ? i + STATE_PAUSE_OPTION_SOUND_VOLUMN : STATE_INTERRUPT, Self.emeraldX[i] + Self.barDrawer.getBarX(), EMERALD_Y, IS_EMERALD_DEBUG_FULL, STATE_READY)
					i += WORD_FINISH_STAGE
				}
			Case STATE_GET_EMERALD
				Self.endingInstance.draw(g)
			Case STATE_PAUSE
				SpecialMap.drawMap(g)
				SpecialObject.drawObjects(g)
				SpecialObject.player.setPause(True)
				SpecialObject.player.drawInfo(g)
				pauseDraw(g)
			Case STATE_PAUSE_TO_TITLE
				SpecialMap.drawMap(g)
				SpecialObject.drawObjects(g)
				SpecialObject.player.setPause(True)
				SpecialObject.player.drawInfo(g)
				muiAniDrawer.setActionId(50)
				muiAniDrawer.draw(g, Self.pause_saw_x, Self.pause_saw_y)
				State.drawFade(g)
				SecondEnsurePanelDraw(g, BONUS_Y_SPACE)
			Case STATE_PAUSE_OPTION
				optionDraw(g)
			Case VISIBLE_OPTION_ITEMS_NUM
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
			Case STATE_INTERRUPT
				interruptDraw(g)
			Case STATE_PAUSE_OPTION_SOUND_VOLUMN
				optionDraw(g)
				soundVolumnDraw(g)
			Case STATE_PAUSE_OPTION_SENSOR
				optionDraw(g)
				spSenorSetDraw(g)
			Default
		End Select
	End

	Public Method init:Void()
		State.initTouchkeyBoard()
		SpecialMap.loadMap()
		SpecialObject.initObjects()
		Self.characterUpDrawer = New Animation("/animation/special/sp_up_chr").getDrawer(PlayerObject.getCharacterID(), True, STATE_READY)
		Self.characterY = SCREEN_HEIGHT + 40
		State.fadeInitAndStart(255, STATE_READY)
		Self.speedLight = MFImage.createImage("/special_res/speed_light.png")
		Self.speedLightVec = New Vector()
		Self.changingState = IS_EMERALD_DEBUG_FULL
		Self.readyBgImage = MFImage.createImage("/special_res/sp_up_bg.png")
		Self.welcomeBgImage = MFImage.createImage("/special_res/sp_welcome_bg.png")
		Self.fontDrawer = Animation.getInstanceFromQi("/special_res/sp_font.dat")[STATE_READY].getDrawer()
	End

	Public Method close:Void()
		State.releaseTouchkeyBoard()
		Animation.closeAnimationDrawer(Self.characterUpDrawer)
		Self.characterUpDrawer = Null
		Self.speedLight = Null
		Self.readyBgImage = Null
		Self.welcomeBgImage = Null
		Animation.closeAnimationDrawer(Self.fontDrawer)
		Self.fontDrawer = Null
		Animation.closeAnimationDrawer(Self.interruptDrawer)
		Self.interruptDrawer = Null
		SpecialMap.releaseMap()
		SpecialObject.closeObjects()
		
		If (bButton <> Null) Then
			MFDevice.removeComponent(bButton)
		EndIf
		
		If (aButton <> Null) Then
			MFDevice.removeComponent(aButton)
		EndIf
		
		If (GlobalResource.spsetConfig = 0) Then
			Key.touchkeyboardClose()
		EndIf
		
		Key.touchSPstageClose()
		'System.gc()
		try {
			Thread.sleep(100)
		} catch (Exception e) {
			e.printStackTrace()
		}
	End

	Private Method pauseInit:Void()
		
		If (SpecialObject.player.velZ <> 0) Then
			Self.preVelZ = SpecialObject.player.velZ
		EndIf
		
		SpecialObject.player.velZ = STATE_READY
		Self.state = STATE_PAUSE
		Key.touchGamePauseInit(STATE_READY)
		Self.pausecnt = STATE_READY
		Self.pause_saw_x = -50
		Self.pause_saw_y = STATE_READY
		Self.pause_saw_speed = 30
		Self.pause_item_x = SCREEN_WIDTH - 26
		Self.pause_item_speed = (-((SCREEN_WIDTH Shr 1) + STATE_INTERRUPT)) / STATE_END
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(STATE_READY, IS_EMERALD_DEBUG_FULL, STATE_READY)
		EndIf
		
		Self.pause_returnFlag = IS_EMERALD_DEBUG_FULL
		Self.pause_item_y = (SCREEN_HEIGHT Shr 1) - 36
		State.fadeInit_Modify(STATE_READY, 102)
		SoundSystem.getInstance().stopBgm(IS_EMERALD_DEBUG_FULL)
		Key.touchgamekeyClose()
		AnimationDrawer.setAllPause(True)
	End

	Private Method pauseInitFromItems:Void()
		
		If (SpecialObject.player.velZ <> 0) Then
			Self.preVelZ = SpecialObject.player.velZ
		EndIf
		
		SpecialObject.player.velZ = STATE_READY
		Self.state = STATE_PAUSE
		Key.touchGamePauseInit(STATE_READY)
		Key.touchgamekeyClose()
		State.fadeInit_Modify(192, 102)
	End

	Private Method pauseLogic:Void()
		Self.pausecnt += WORD_FINISH_STAGE
		
		If (Self.pausecnt >= STATE_WAIT_FOR_OVER And Self.pausecnt <= STATE_PAUSE_TO_TITLE) Then
			If (Self.pause_saw_x + Self.pause_saw_speed > 0) Then
				Self.pause_saw_x = STATE_READY
			Else
				Self.pause_saw_x += Self.pause_saw_speed
			EndIf
			
			If (Self.pause_item_x + Self.pause_item_speed < (SCREEN_WIDTH Shr 1) - 40) Then
				Self.pause_item_x = (SCREEN_WIDTH Shr 1) - 40
			Else
				Self.pause_item_x += Self.pause_item_speed
			EndIf
			
		ElseIf (Self.pausecnt > STATE_PAUSE_TO_TITLE) Then
			Int i
			For (i = STATE_READY; i < STATE_END; i += WORD_FINISH_STAGE)
				
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
				SoundSystem.getInstance().playSe(STATE_GAMING)
			EndIf
			
			If (Self.pause_returnFlag) Then
				If (Self.pausecnt > Self.pause_returnframe And Self.pausecnt <= Self.pause_returnframe + STATE_END) Then
					Self.pause_saw_x -= Self.pause_saw_speed
					Self.pause_item_x -= Self.pause_item_speed
				ElseIf (Self.pausecnt > Self.pause_returnframe + STATE_END) Then
					BacktoGame()
					isDrawTouchPad = True
					Self.pause_returnFlag = IS_EMERALD_DEBUG_FULL
				EndIf
			EndIf
			
			If (Self.pause_optionFlag And Self.pausecnt > Self.pause_optionframe + STATE_END) Then
				optionInit()
				Self.state = STATE_PAUSE_OPTION
				Self.pause_optionFlag = IS_EMERALD_DEBUG_FULL
			EndIf
			
			If (Not State.fadeChangeOver()) Then
				For (i = STATE_READY; i < STATE_END; i += WORD_FINISH_STAGE)
					Key.touchgamepauseitem[i].resetKeyState()
				Next
			ElseIf (Key.touchgamepauseitem[STATE_READY].IsButtonPress() And Self.pause_item_cursor = 0 And Not Self.pause_optionFlag) Then
				Self.pause_returnFlag = True
				Self.pause_returnframe = Self.pausecnt
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			ElseIf (Key.touchgamepauseitem[WORD_FINISH_STAGE].IsButtonPress() And Self.pause_item_cursor = WORD_FINISH_STAGE And State.fadeChangeOver()) Then
				Self.state = STATE_PAUSE_TO_TITLE
				State.fadeInit(102, 220)
				secondEnsureInit()
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			ElseIf (Key.touchgamepauseitem[STATE_GAMING].IsButtonPress() And Self.pause_item_cursor = STATE_GAMING And Not Self.pause_optionFlag) Then
				changeStateWithFade(STATE_PAUSE_OPTION)
				optionInit()
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			EndIf
		EndIf
		
	End

	Private Method pauseDraw:Void(g:MFGraphics)
		State.drawFade(g)
		
		If (Self.pausecnt > STATE_WAIT_FOR_OVER) Then
			muiAniDrawer.setActionId(50)
			muiAniDrawer.draw(g, Self.pause_saw_x, Self.pause_saw_y)
		EndIf
		
		If (Self.pausecnt > STATE_PAUSE_TO_TITLE) Then
			muiAniDrawer.setActionId((Key.touchgamepausereturn.Isin() ? STATE_WAIT_FOR_OVER : STATE_READY) + 61)
			muiAniDrawer.draw(g, STATE_READY, SCREEN_HEIGHT)
		EndIf
		
		If (Self.pausecnt > STATE_WAIT_FOR_OVER) Then
			Int i
			AnimationDrawer animationDrawer = muiAniDrawer
			
			If (Self.pause_item_cursor = 0 And Key.touchgamepauseitem[STATE_READY].Isin()) Then
				i = WORD_FINISH_STAGE
			Else
				i = STATE_READY
			EndIf
			
			animationDrawer.setActionId(i + STATE_GAMING)
			muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y)
			animationDrawer = muiAniDrawer
			
			If (Self.pause_item_cursor = WORD_FINISH_STAGE And Key.touchgamepauseitem[WORD_FINISH_STAGE].Isin()) Then
				i = WORD_FINISH_STAGE
			Else
				i = STATE_READY
			EndIf
			
			animationDrawer.setActionId(i + STATE_PAUSE_OPTION_VIB)
			muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + 24)
			animationDrawer = muiAniDrawer
			
			If (Self.pause_item_cursor = STATE_GAMING And Key.touchgamepauseitem[STATE_GAMING].Isin()) Then
				i = WORD_FINISH_STAGE
			Else
				i = STATE_READY
			EndIf
			
			animationDrawer.setActionId(i + STATE_PAUSE_OPTION_SP_SET)
			muiAniDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + 48)
		EndIf
		
	End

	Private Method itemsid:Int(id:Int)
		Int itemsidoffset = (Self.optionOffsetY / 24) * STATE_GAMING
		
		If (id + itemsidoffset < 0) Then
			Return STATE_READY
		EndIf
		
		If (id + itemsidoffset > VISIBLE_OPTION_ITEMS_NUM) Then
			Return VISIBLE_OPTION_ITEMS_NUM
		EndIf
		
		Return id + itemsidoffset
	End

	Private Method optionInit:Void()
		
		If (muiAniDrawer = Null) Then
			muiAniDrawer = New Animation("/animation/mui").getDrawer(STATE_READY, IS_EMERALD_DEBUG_FULL, STATE_READY)
		EndIf
		
		Self.optionOffsetX = STATE_READY
		Key.touchGamePauseOptionInit()
		Self.pauseOptionCursor = STATE_READY
		Self.isOptionDisFlag = IS_EMERALD_DEBUG_FULL
		Key.touchMenuOptionInit()
		Self.optionOffsetYAim = STATE_READY
		Self.optionOffsetY = STATE_READY
		Self.isChanged = IS_EMERALD_DEBUG_FULL
		Self.optionslide_getprey = -1
		Self.optionslide_gety = -1
		Self.optionslide_y = STATE_READY
		Self.optionDrawOffsetBottomY = STATE_READY
		Self.optionYDirect = STATE_READY
	End

	Private Method optionLogic:Void()
		Int i
		
		If (Not Self.isOptionDisFlag) Then
			SoundSystem.getInstance().playBgm(STATE_WAIT_FOR_OVER)
			Self.isOptionDisFlag = True
		EndIf
		
		If (Key.touchmenuoptionreturn.Isin() And Key.touchmenuoption.IsClick()) Then
			Self.returnCursor = WORD_FINISH_STAGE
		EndIf
		
		Self.optionslide_gety = Key.slidesensormenuoption.getPointerY()
		Self.optionslide_y = STATE_READY
		Self.optionslidefirsty = STATE_READY
		For (i = STATE_READY; i < (Key.touchmenuoptionitems.length Shr 1); i += WORD_FINISH_STAGE)
			Key.touchmenuoptionitems[i * STATE_GAMING].setStartY((((i * 24) + 28) + Self.optionDrawOffsetY) + Self.optionslide_y)
			Key.touchmenuoptionitems[(i * STATE_GAMING) + WORD_FINISH_STAGE].setStartY((((i * 24) + 28) + Self.optionDrawOffsetY) + Self.optionslide_y)
		Next
		
		If (Self.isSelectable) Then
			For (i = STATE_READY; i < Key.touchmenuoptionitems.length; i += WORD_FINISH_STAGE)
				
				If (Key.touchmenuoptionitems[i].Isin() And Key.touchmenuoption.IsClick()) Then
					Self.pauseOptionCursor = i / STATE_GAMING
					Self.returnCursor = STATE_READY
					break
				EndIf
				
			Next
		EndIf
		
		If (Key.touchmenuoptionreturn.Isin() And Key.touchmenuoption.IsClick()) Then
			Self.returnCursor = WORD_FINISH_STAGE
		EndIf
		
		If ((Key.press(Key.B_BACK) Or (Key.touchmenuoptionreturn.IsButtonPress() And Self.returnCursor = WORD_FINISH_STAGE)) And State.fadeChangeOver()) Then
			changeStateWithFade(STATE_PAUSE)
			SoundSystem.getInstance().stopBgm(IS_EMERALD_DEBUG_FULL)
			SoundSystem.getInstance().playSe(STATE_GAMING)
			GlobalResource.saveSystemConfig()
		EndIf
		
		If (Key.slidesensormenuoption.isSliding()) Then
			Self.isSelectable = True
		Else
			
			If (Self.isOptionChange And Self.optionslide_y = 0) Then
				Self.optionDrawOffsetY = Self.optionDrawOffsetTmpY1
				Self.isOptionChange = IS_EMERALD_DEBUG_FULL
				Self.optionYDirect = STATE_READY
			EndIf
			
			If (Not Self.isOptionChange) Then
				Int speed
				
				If (Self.optionDrawOffsetY > 0) Then
					Self.optionYDirect = WORD_FINISH_STAGE
					speed = (-Self.optionDrawOffsetY) Shr 1
					
					If (speed > -2) Then
						speed = -2
					EndIf
					
					If (Self.optionDrawOffsetY + speed <= 0) Then
						Self.optionDrawOffsetY = STATE_READY
						Self.optionYDirect = STATE_READY
					Else
						Self.optionDrawOffsetY += speed
					EndIf
					
				ElseIf (Self.optionDrawOffsetY < Self.optionDrawOffsetBottomY) Then
					Self.optionYDirect = STATE_GAMING
					speed = (Self.optionDrawOffsetBottomY - Self.optionDrawOffsetY) Shr 1
					
					If (speed < STATE_GAMING) Then
						speed = STATE_GAMING
					EndIf
					
					If (Self.optionDrawOffsetY + speed >= Self.optionDrawOffsetBottomY) Then
						Self.optionDrawOffsetY = Self.optionDrawOffsetBottomY
						Self.optionYDirect = STATE_READY
					Else
						Self.optionDrawOffsetY += speed
					EndIf
				EndIf
			EndIf
		EndIf
		
		If (Self.isSelectable And Self.optionYDirect = 0) Then
			If (Key.touchmenuoptionitems[WORD_FINISH_STAGE].IsButtonPress() And Self.pauseOptionCursor = 0 And GlobalResource.soundSwitchConfig <> 0 And State.fadeChangeOver()) Then
				Self.state = STATE_PAUSE_OPTION_SOUND_VOLUMN
				soundVolumnInit()
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			ElseIf (Key.touchmenuoptionitems[STATE_END].IsButtonPress() And Self.pauseOptionCursor = WORD_FINISH_STAGE And State.fadeChangeOver()) Then
				Self.state = STATE_PAUSE_OPTION_VIB
				itemsSelect2Init()
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			ElseIf (Key.touchmenuoptionitems[STATE_WAIT_FOR_OVER].IsButtonPress() And Self.pauseOptionCursor = STATE_GAMING And State.fadeChangeOver()) Then
				Self.state = STATE_PAUSE_OPTION_SP_SET
				itemsSelect2Init()
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			ElseIf (Key.touchmenuoptionitems[STATE_PAUSE_TO_TITLE].IsButtonPress() And Self.pauseOptionCursor = STATE_END And GlobalResource.spsetConfig <> 0 And State.fadeChangeOver()) Then
				Self.state = STATE_PAUSE_OPTION_SENSOR
				spSenorSetInit()
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			ElseIf (Key.touchmenuoptionitems[STATE_PAUSE_OPTION].IsButtonPress() And Self.pauseOptionCursor = STATE_GET_EMERALD And State.fadeChangeOver()) Then
				changeStateWithFade(STATE_PAUSE_OPTION_HELP)
				AnimationDrawer.setAllPause(IS_EMERALD_DEBUG_FULL)
				helpInit()
				SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
			EndIf
		EndIf
		
		Self.optionslide_getprey = Self.optionslide_gety
	End

	Private Method releaseOptionItemsTouchKey:Void()
		For (Int i = STATE_READY; i < Key.touchmenuoptionitems.length; i += WORD_FINISH_STAGE)
			Key.touchmenuoptionitems[i].resetKeyState()
		Next
	End

	Private Method optionDraw:Void(g:MFGraphics)
		Int i
		g.setColor(STATE_READY)
		MyAPI.fillRect(g, STATE_READY, STATE_READY, SCREEN_WIDTH, SCREEN_HEIGHT)
		muiAniDrawer.setActionId(52)
		For (Int i2 = STATE_READY; i2 < (SCREEN_WIDTH / 48) + WORD_FINISH_STAGE; i2 += WORD_FINISH_STAGE)
			For (Int j = STATE_READY; j < (SCREEN_HEIGHT / 48) + WORD_FINISH_STAGE; j += WORD_FINISH_STAGE)
				muiAniDrawer.draw(g, i2 * 48, j * 48)
			Next
		Next
		
		If (Self.state <> STATE_PAUSE_OPTION) Then
			Self.pauseOptionCursor = -2
		EndIf
		
		muiAniDrawer.setActionId(25)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + STATE_READY)
		AnimationDrawer animationDrawer = muiAniDrawer
		
		If (GlobalResource.soundSwitchConfig = 0) Then
			i = 67
		Else
			i = (Key.touchmenuoptionitems[WORD_FINISH_STAGE].Isin() And Self.pauseOptionCursor = 0 And Self.isSelectable) ? WORD_FINISH_STAGE : STATE_READY
			i += 57
		EndIf
		
		animationDrawer.setActionId(i)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + STATE_READY)
		muiAniDrawer.setActionId(GlobalResource.soundConfig + 73)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + STATE_READY)
		muiAniDrawer.setActionId(21)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
		animationDrawer = muiAniDrawer
		
		If (Key.touchmenuoptionitems[STATE_END].Isin() And Self.pauseOptionCursor = WORD_FINISH_STAGE And Self.isSelectable) Then
			i = WORD_FINISH_STAGE
		Else
			i = STATE_READY
		EndIf
		
		animationDrawer.setActionId(i + 57)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
		animationDrawer = muiAniDrawer
		
		If (GlobalResource.vibrationConfig = 0) Then
			i = WORD_FINISH_STAGE
		Else
			i = STATE_READY
		EndIf
		
		animationDrawer.setActionId(i + 35)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
		muiAniDrawer.setActionId(23)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
		animationDrawer = muiAniDrawer
		
		If (Key.touchmenuoptionitems[STATE_WAIT_FOR_OVER].Isin() And Self.pauseOptionCursor = STATE_GAMING And Self.isSelectable) Then
			i = WORD_FINISH_STAGE
		Else
			i = STATE_READY
		EndIf
		
		animationDrawer.setActionId(i + 57)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
		animationDrawer = muiAniDrawer
		
		If (GlobalResource.spsetConfig = 0) Then
			i = STATE_READY
		Else
			i = WORD_FINISH_STAGE
		EndIf
		
		animationDrawer.setActionId(i + 37)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
		muiAniDrawer.setActionId(24)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
		animationDrawer = muiAniDrawer
		
		If (GlobalResource.spsetConfig = 0) Then
			i = 67
		Else
			i = (Key.touchmenuoptionitems[STATE_PAUSE_TO_TITLE].Isin() And Self.pauseOptionCursor = STATE_END And Self.isSelectable) ? WORD_FINISH_STAGE : STATE_READY
			i += 57
		EndIf
		
		animationDrawer.setActionId(i)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
		Select (GlobalResource.sensorConfig)
			Case STATE_READY
				muiAniDrawer.setActionId(70)
				break
			Case WORD_FINISH_STAGE
				muiAniDrawer.setActionId(69)
				break
			Case STATE_GAMING
				muiAniDrawer.setActionId(68)
				break
		End Select
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
		animationDrawer = muiAniDrawer
		
		If (Key.touchmenuoptionitems[STATE_PAUSE_OPTION].Isin() And Self.pauseOptionCursor = STATE_GET_EMERALD And Self.isSelectable) Then
			i = WORD_FINISH_STAGE
		Else
			i = STATE_READY
		EndIf
		
		animationDrawer.setActionId(i + 27)
		muiAniDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 96)
		Self.optionOffsetX -= STATE_GET_EMERALD
		Self.optionOffsetX Mod= OPTION_MOVING_INTERVAL
		muiAniDrawer.setActionId(51)
		For (Int x1 = Self.optionOffsetX; x1 < SCREEN_WIDTH * STATE_GAMING; x1 += OPTION_MOVING_INTERVAL)
			muiAniDrawer.draw(g, x1, STATE_READY)
		Next
		animationDrawer = muiAniDrawer
		
		If (Key.touchmenuoptionreturn.Isin()) Then
			i = STATE_WAIT_FOR_OVER
		Else
			i = STATE_READY
		EndIf
		
		animationDrawer.setActionId(i + 61)
		muiAniDrawer.draw(g, STATE_READY, SCREEN_HEIGHT)
		State.drawFade(g)
	End

	Private Method BacktoGame:Void()
		Self.state = STATE_GAMING
		State.fadeInit(102, STATE_READY)
		SoundSystem instance = SoundSystem.getInstance()
		SoundSystem.getInstance()
		instance.playBgm(35)
		Key.initSonic()
		SpecialObject.player.velZ = Self.preVelZ
		AnimationDrawer.setAllPause(IS_EMERALD_DEBUG_FULL)
		
		If (Key.touchspstagepause <> Null) Then
			Key.touchspstagepause.resetKeyState()
		EndIf
		
	End

	Public Method pause:Void()
		
		If (Self.state <> STATE_INTERRUPT And Self.state <> STATE_PAUSE) Then
			If (Self.state = STATE_GAMING And SpecialObject.player.isNeedTouchPad()) Then
				pauseInit()
			Else
				Self.interrupt_state = Self.state
				Self.state = STATE_INTERRUPT
				interruptInit()
			EndIf
			
			If (Self.interrupt_state = STATE_GET_EMERALD) Then
				Self.endingInstance.pause()
			EndIf
		EndIf
		
	End

	Private Method interruptInit:Void()
		State.fadeInitAndStart(STATE_READY, STATE_READY)
		
		If (SpecialObject.player.velZ <> 0) Then
			Self.preVelZ = SpecialObject.player.velZ
		EndIf
		
		SpecialObject.player.velZ = STATE_READY
		
		If (Self.interruptDrawer = Null) Then
			Self.interruptDrawer = Animation.getInstanceFromQi("/animation/utl_res/suspend_resume.dat")[STATE_READY].getDrawer(STATE_READY, True, STATE_READY)
		EndIf
		
		isDrawTouchPad = IS_EMERALD_DEBUG_FULL
		Key.touchInterruptInit()
	End

	Private Method interruptLogic:Void()
		
		If (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress()) Then
			SoundSystem.getInstance().playSe(STATE_GAMING)
			Key.touchInterruptClose()
			
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
			
			Self.state = Self.interrupt_state
			Self.interrupt_state = -1
			Key.clear()
			isDrawTouchPad = True
			fading = IS_EMERALD_DEBUG_FULL
			Select (Self.state)
				Case STATE_READY
				Case WORD_FINISH_STAGE
					State.fadeInit(STATE_READY, STATE_READY)
					SpecialObject.player.velZ = Self.preVelZ
				Case STATE_GAMING
					State.fadeInit(192, 192)
					SpecialObject.player.velZ = Self.preVelZ
					SoundSystem.getInstance().playBgm(35)
				Case STATE_GET_EMERALD
					Self.endingInstance.setOverFromInterrupt()
				Case STATE_PAUSE_TO_TITLE
					State.fadeInit(192, 192)
					isDrawTouchPad = IS_EMERALD_DEBUG_FULL
				Case STATE_PAUSE_OPTION
					optionInit()
					isDrawTouchPad = IS_EMERALD_DEBUG_FULL
				Case VISIBLE_OPTION_ITEMS_NUM
				Case STATE_PAUSE_OPTION_VIB
				Case STATE_PAUSE_OPTION_KEY_CONTROL
				Case STATE_PAUSE_OPTION_SP_SET
				Case STATE_PAUSE_OPTION_SOUND_VOLUMN
				Case STATE_PAUSE_OPTION_SENSOR
					State.fadeInit(192, 192)
				Default
			End Select
		EndIf
		
	End

	Private Method interruptDraw:Void(g:MFGraphics)
		Self.interruptDrawer.setActionId((Key.touchinterruptreturn.Isin() ? WORD_FINISH_STAGE : STATE_READY) + STATE_READY)
		Self.interruptDrawer.draw(g, SCREEN_WIDTH Shr 1, SCREEN_HEIGHT Shr 1)
	End

	Public Method drawWord:Void(g:MFGraphics, wordID:Int, x:Int, y:Int)
		Select (wordID)
			Case STATE_READY
				Self.fontDrawer.draw(g, PlayerObject.getCharacterID() + STATE_PAUSE_OPTION, x, y, IS_EMERALD_DEBUG_FULL, STATE_READY)
				Self.fontDrawer.draw(g, STATE_PAUSE_OPTION_SP_SET, x, y, IS_EMERALD_DEBUG_FULL, STATE_READY)
			Case WORD_FINISH_STAGE
				Self.fontDrawer.draw(g, STATE_PAUSE_OPTION_HELP, x, y, IS_EMERALD_DEBUG_FULL, STATE_READY)
			Default
		End Select
	End

	Public Method getWordLength:Int(wordID:Int)
		Return 320
	End

	Private Method backToGameStage:Void()
		State.setState(STATE_PAUSE_TO_TITLE)
	End

	Public Function loadData:Void()
		Int i
		Byte[] record = Record.loadRecord(Record.EMERALD_RECORD)
		
		If (record <> Null) Then
			DataInputStream ds = New DataInputStream(New ByteArrayInputStream(record))
			i = STATE_READY
			While (i < emeraldStatus.length) {
				try {
					emeraldStatus[i] = ds.readByte()
					i += WORD_FINISH_STAGE
				} catch (Exception e) {
					For (i = STATE_READY; i < emeraldStatus.length; i += WORD_FINISH_STAGE)
						emeraldStatus[i] = STATE_READY
					Next
					Return
				}
			}
			Return
		EndIf
		
		For (i = STATE_READY; i < emeraldStatus.length; i += WORD_FINISH_STAGE)
			emeraldStatus[i] = STATE_READY
		Next
	}

	Public Function saveData:Void()
		ByteArrayOutputStream os = New ByteArrayOutputStream()
		DataOutputStream ds = New DataOutputStream(os)
		Int i = STATE_READY
		While (i < emeraldStatus.length) {
			try {
				ds.writeByte(emeraldStatus[i])
				i += WORD_FINISH_STAGE
			} catch (Exception e) {
				Return
			}
		}
		Record.saveRecord(Record.EMERALD_RECORD, os.toByteArray())
	}

	Public Function emptyEmeraldArray:Void()
		For (Int i = STATE_READY; i < emeraldStatus.length; i += WORD_FINISH_STAGE)
			emeraldStatus[i] = STATE_READY
		Next
		saveData()
	}

	Public Function emeraldMissed:Bool()
		For (Int i = STATE_READY; i < emeraldStatus.length; i += WORD_FINISH_STAGE)
			
			If (emeraldStatus[i] <> WORD_FINISH_STAGE) Then
				Return True
			EndIf
			
		Next
		Return IS_EMERALD_DEBUG_FULL
	}

	Public Function emeraldID:Int(stageId:Int)
		Return STAGE_ID_TO_SPECIAL_ID[stageId]
	}

	Public Function emeraldState:Int(stageId:Int)
		Return emeraldStatus[emeraldID(stageId)]
	}

	Public Function setEmeraldState:Void(stageId:Int, state:Int)
		emeraldStatus[emeraldID(stageId)] = state
	}

	Public Method changeStateWithFade:Void(nState:Int)
		
		If (Not fading) Then
			fading = True
			
			If (nState = STATE_PAUSE_OPTION) Then
				State.fadeInit(102, 255)
			Else
				State.fadeInit(STATE_READY, 255)
			EndIf
			
			Self.nextState = nState
			Self.fadeChangeState = True
		EndIf
		
	End

	Public Method fadeStateLogic:Void()
		
		If (fading And Self.fadeChangeState And State.fadeChangeOver() And Self.state <> Self.nextState) Then
			Self.state = Self.nextState
			Self.fadeChangeState = IS_EMERALD_DEBUG_FULL
			
			If (Self.state = STATE_PAUSE) Then
				State.fadeInit_Modify(255, 102)
			Else
				State.fadeInit(255, STATE_READY)
			EndIf
		EndIf
		
		If (Self.state = Self.nextState And State.fadeChangeOver()) Then
			fading = IS_EMERALD_DEBUG_FULL
		EndIf
		
	End
End