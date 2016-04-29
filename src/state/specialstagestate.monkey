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
	Import lib.constutil
	
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
	
	Import state.state
	Import state.titlestate
	
	#Rem
		Import java.io.Bytearrayinputstream
		Import java.io.Bytearrayoutputstream
		Import java.io.datainputstream
		Import java.io.dataoutputstream
		Import java.util.vector
	#End
	
	Import brl.stream
	Import brl.datastream
	
	Import monkey.stack
	
	'Import regal.ioutil.publicdatastream
	Import regal.typetool
Public

' Classes:
Class SpecialStageState Extends State Implements BarWord ' SSDef
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
		Global emeraldStatus:Byte[] = New Byte[7]
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
	Public
		' Constructor(s):
		Method New()
			Self.characterY = SCREEN_HEIGHT
			
			Self.bonusY = New Int[3]
			Self.emeraldX = New Int[7]
			
			Self.isOptionDisFlag = False
			Self.optionslide_getprey = -1
			Self.optionslide_gety = -1
			
			Self.state = STATE_READY
			
			Self.isIntroBGMplay = False
			
			fading = False
			
			Self.barDrawer = WhiteBarDrawer.getInstance()
			
			If (GlobalResource.spsetConfig = 1) Then
				bButton = New MFTouchKey(0, 0, MyAPI.zoomOut(SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(SCREEN_HEIGHT), Key.B_SEL)
				
				MFDevice.addComponent(bButton)
				
				aButton = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH) Shr 1, 0, MyAPI.zoomOut(SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(SCREEN_HEIGHT), Key.B_HIGH_JUMP)
				
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
		
		' Methods:
		Method logic:Void()
			fadeStateLogic()
			
			If (Key.press(Key.B_PO)) Then
			EndIf
			
			Local i:Int
			
			Select (Self.state)
				Case STATE_READY
					If (State.fadeChangeOver()) Then
						If (Not Self.isIntroBGMplay) Then
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_SP_INTRO, False)
							
							Self.isIntroBGMplay = True
						EndIf
						
						If (Self.changingState) Then
							Self.state = 1
							State.fadeInitAndStart(255, 0)
							SpecialObject.player.initWelcome()
							Self.changingState = False
						Else
							Self.characterY -= STATE_PAUSE_OPTION_SOUND_VOLUMN
							
							If (Self.characterY < -40) Then
								State.fadeInitAndStart(0, 255)
								Self.changingState = True
							EndIf
						EndIf
					EndIf
					
					i = 0
					
					While (i < Self.speedLightVec.Length)
						Local position:= Self.speedLightVec.Get(i)
						
						position[1] += SPEED_LIGHT_VELOCITY
						
						If (position[1] > SCREEN_HEIGHT + Self.speedLight.getHeight()) Then
							Self.speedLightVec.Remove(i)
							
							i -= 1
						EndIf
						
						i += 1
					Wend
					
					For i = 0 Until 2
						Local position:= New Int[2]
						
						position[0] = MyRandom.nextInt(0, SCREEN_WIDTH)
						position[1] = -(i * 30)
						
						Self.speedLightVec.Push(position)
					Next
				Case WORD_FINISH_STAGE
					SpecialObject.player.logicWelcome()
					
					If (Not State.fadeChangeOver()) Then
						Return
					EndIf
					
					If (Self.changingState) Then
						Self.state = STATE_GAMING
						
						SoundSystem.getInstance().playBgm(SoundSystem.BGM_SP)
						
						fading = False
						
						State.fadeInit(255, 0)
						
						Self.changingState = False
					ElseIf (SpecialObject.player.isWelcomeOver()) Then
						State.fadeInitAndStart(0, 255)
						
						Self.changingState = True
					EndIf
				Case STATE_GAMING
					SpecialObject.player.logic()
					SpecialObject.objectLogic()
					
					If (Not Self.changingState And SpecialObject.player.isOver()) Then
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInitAndStart(0, 255)
						
						Self.changingState = True
					EndIf
					
					If (State.fadeChangeOver() And Self.changingState) Then
						Self.state = STATE_END
						
						State.setFadeColor(0)
						
						fading = False
						
						Self.barDrawer.initBar(Self, Int(Not SpecialObject.player.checkSuccess))
						Self.barDrawer.setPause(True)
						
						Self.changingState = False
						
						Self.count = 0
						
						For Local i:= 0 Until Self.bonusY.Length
							Self.bonusY[i] = BONUS_Y_ORIGINAL
						Next
						
						For Local i:= 0 Until Self.emeraldX.Length
							Self.emeraldX[i] = EMERALD_X_ORIGINAL
						Next
						
						Self.ringScore = (SpecialObject.player.getRingNum() * OPTION_MOVING_INTERVAL)
						Self.clearScore = PickValue(SpecialObject.player.checkSuccess, 10000, 0)
						Self.totalScore = 0
						
						If (SpecialObject.player.checkSuccess) Then
							setEmeraldState(StageManager.getStageID(), WORD_FINISH_STAGE)
							
							saveData()
							
							Self.endingInstance = New SpecialEnding(PlayerObject.getCharacterID(), STAGE_ID_TO_SPECIAL_ID[StageManager.getStageID()])
							Self.state = STATE_GET_EMERALD
							
							State.setFadeColor(MapManager.END_COLOR)
							State.fadeInitAndStart(255, 0)
							
							SoundSystem.getInstance().stopBgm(False)
						Else
							If (emeraldState(StageManager.getStageID()) <> WORD_FINISH_STAGE) Then
								setEmeraldState(StageManager.getStageID(), STATE_GAMING)
								
								saveData()
							EndIf
							
							SoundSystem.getInstance().playBgm(SoundSystem.BGM_SP_TOTAL_MISS)
						EndIf
					EndIf
					
					If (Not SpecialObject.player.isNeedTouchPad()) Then
						Return
					EndIf
					
					If (Key.touchspstagepause.IsButtonPress() Or Key.press(Key.B_BACK)) Then
						SoundSystem.getInstance().playSe(SoundSystem.SE_142)
						
						pauseInit()
					EndIf
				Case STATE_END
					Self.count += 1
					
					If (Self.count >= 13) Then
						For Local i:= 0 Until Self.bonusY.Length ' 3
							If (i <= Self.count - 13) Then
								Self.bonusY[i] = MyAPI.calNextPosition(Double(Self.bonusY[i]), Double(BONUS_Y_START + (i * BONUS_Y_SPACE)), 1, 4)
							EndIf
						Next
					EndIf
					
					If (Self.count >= 16) Then
						For Local i:= 0 Until Self.emeraldX.Length ' 7
							If (i <= Self.count - 16) Then
								Self.emeraldX[i] = MyAPI.calNextPosition(Double(Self.emeraldX[i]), Double(EMERALD_X_START + (i * EMERALD_SPACE)), 1, 4)
							EndIf
						Next
					EndIf
					
					If (Self.count > 46) Then
						Local scoreChange:Int
						
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
							SoundSystem.getInstance().playSe(SoundSystem.SE_141)
						Else
							SoundSystem.getInstance().playSe(SoundSystem.SE_140)
						EndIf
						
						If (Self.ringScore = 0 And Self.clearScore = 0) Then
							PlayerObject.setScore(PlayerObject.getScore() + Self.totalScore)
							
							Self.state = STATE_WAIT_FOR_OVER
							Self.count = 0
						EndIf
					EndIf
				Case STATE_GET_EMERALD
					Self.endingInstance.logic()
					
					If (Self.endingInstance.isOver() And Not Self.changingState) Then
						State.setFadeColor(MapManager.END_COLOR)
						State.fadeInitAndStart(0, 255)
						
						Self.changingState = True
					EndIf
					
					If (Not State.fadeChangeOver()) Then
						Return
					EndIf
					
					If (Self.changingState) Then
						Self.state = STATE_END
						
						SoundSystem.getInstance().playBgm(SoundSystem.BGM_SP_TOTAL_CLEAR)
						
						Self.changingState = False
						
						State.setFadeColor(0)
						
						fading = False
						
						Return
					EndIf
					
					State.setFadeColor(0)
				Case STATE_WAIT_FOR_OVER
					Self.count += 1
					
					If (Self.count = 128) Then
						Self.barDrawer.setPause(False)
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
					
					If ((Key.press(Key.B_BACK) Or (Key.touchhelpreturn.IsButtonPress() And Self.returnPageCursor = 1)) And State.fadeChangeOver()) Then
						changeStateWithFade(STATE_PAUSE_OPTION)
						
						AnimationDrawer.setAllPause(True)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_107)
					EndIf
				Case STATE_INTERRUPT
					interruptLogic()
				Case STATE_PAUSE_OPTION_SOUND_VOLUMN
					Select (soundVolumnLogic())
						Case STATE_GAMING
							State.fadeInit(102, 0)
							
							Self.state = STATE_PAUSE_OPTION
						Default
							' Nothing so far.
					End Select
				Case STATE_PAUSE_OPTION_SENSOR
					Select (spSenorSetLogic())
						Case WORD_FINISH_STAGE
							GlobalResource.sensorConfig = 0
							
							State.fadeInit(102, 0)
							
							Self.state = STATE_PAUSE_OPTION
						Case STATE_GAMING
							GlobalResource.sensorConfig = 1
							
							State.fadeInit(102, 0)
							
							Self.state = STATE_PAUSE_OPTION
						Case STATE_END
							State.fadeInit(102, 0)
							
							Self.state = STATE_PAUSE_OPTION
						Case STATE_GET_EMERALD
							GlobalResource.sensorConfig = 2
							
							State.fadeInit(102, 0)
							
							Self.state = STATE_PAUSE_OPTION
						Default
							' Nothing so far.
					End Select
				Default
					' Nothing so far.
			End Select
		End
		
		Method draw:Void(g:MFGraphics)
			Select (Self.state)
				Case STATE_PAUSE_OPTION_HELP
					g.setFont(STATE_PAUSE_OPTION_KEY_CONTROL)
				Default
					g.setFont(STATE_INTERRUPT)
			End Select
			
			Select (Self.state)
				Case STATE_READY
					MyAPI.drawImage(g, Self.readyBgImage, 0, 0, 0)
					
					For Local i:= 0 Until Self.speedLightVec.Length
						Local position:= Self.speedLightVec.Get(i)
						
						' Magic number: 33
						MyAPI.drawImage(g, Self.speedLight, position[0], position[1], 33)
					Next
					
					Self.characterUpDrawer.draw(g, SCREEN_WIDTH Shr 1, Self.characterY)
				Case WORD_FINISH_STAGE
					g.setColor(0)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, Self.welcomeBgImage, 0, 0, 0)
					
					SpecialObject.player.setPause(False)
					SpecialObject.player.drawWelcome(g)
				Case STATE_GAMING
					SpecialMap.drawMap(g)
					
					SpecialObject.drawObjects(g)
					SpecialObject.player.setPause(False)
					SpecialObject.player.drawInfo(g)
					
					If (GlobalResource.spsetConfig = 0 And SpecialObject.player.isNeedTouchPad()) Then
						drawTouchKeyDirect(g)
					EndIf
					
					If (SpecialObject.player.isNeedTouchPad()) Then
						State.drawSoftKeyPause(g)
					EndIf
				Case STATE_END, STATE_WAIT_FOR_OVER
					g.setColor(MapManager.END_COLOR)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					Self.barDrawer.drawBar(g)
					
					For Local i:= 0 Until Self.bonusY.Length
						Self.fontDrawer.draw(g, BONUS_ID[i], Self.barDrawer.getBarX() + BONUS_X, Self.bonusY[i], False, 0)
						
						Local drawNum:= 0
						
						Select (i)
							Case 0
								drawNum = Self.ringScore
							Case 1
								drawNum = Self.clearScore
							Case 2
								drawNum = Self.totalScore
							Default
								' Nothing so far.
						End Select
						
						NumberDrawer.drawNum(g, 0, drawNum, Self.barDrawer.getBarX() + ((SCREEN_WIDTH Shr 1) + 75), Self.bonusY[i], 4)
					Next
					
					' Line of collected emeralds:
					For Local i:= 0 Until emeraldStatus.Length ' 7
						Self.fontDrawer.draw(g, PickValue((emeraldStatus[i] = 1), (i + 15), 14), Self.emeraldX[i] + Self.barDrawer.getBarX(), EMERALD_Y, False, 0)
					Next
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
					' Nothing so far.
			End Select
		End
		
		Method init:Void()
			State.initTouchkeyBoard()
			SpecialMap.loadMap()
			SpecialObject.initObjects()
			
			Self.characterUpDrawer = New Animation("/animation/special/sp_up_chr").getDrawer(PlayerObject.getCharacterID(), True, 0)
			
			Self.characterY = SCREEN_HEIGHT + 40
			
			State.fadeInitAndStart(255, 0)
			
			Self.speedLight = MFImage.createImage("/special_res/speed_light.png")
			
			Self.speedLightVec = New Stack<Int[]>()
			
			Self.changingState = False
			
			Self.readyBgImage = MFImage.createImage("/special_res/sp_up_bg.png")
			Self.welcomeBgImage = MFImage.createImage("/special_res/sp_welcome_bg.png")
			
			Self.fontDrawer = Animation.getInstanceFromQi("/special_res/sp_font.dat")[0].getDrawer()
		End
		
		Method close:Void()
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
			'Thread.sleep(100)
		End
		
		Method drawWord:Void(g:MFGraphics, wordID:Int, x:Int, y:Int)
			Select (wordID)
				Case STATE_READY
					Self.fontDrawer.draw(g, PlayerObject.getCharacterID() + STATE_PAUSE_OPTION, x, y, False, 0)
					Self.fontDrawer.draw(g, 12, x, y, False, 0)
				Case WORD_FINISH_STAGE
					Self.fontDrawer.draw(g, 13, x, y, False, 0)
				Default
					' Nothing so far.
			End Select
		End
		
		Method getWordLength:Int(wordID:Int)
			Return 320
		End
		
		Method changeStateWithFade:Void(nState:Int)
			If (Not fading) Then
				fading = True
				
				If (nState = STATE_PAUSE_OPTION) Then
					State.fadeInit(102, 255)
				Else
					State.fadeInit(0, 255)
				EndIf
				
				Self.nextState = nState
				Self.fadeChangeState = True
			EndIf
		End
		
		Method fadeStateLogic:Void()
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
		End
		
		' Functions:
		Function loadData:Void()
			Local ds:Stream
			
			Try
				ds = Record.loadRecordStream(Record.EMERALD_RECORD)
				
				For Local i:= 0 Until emeraldStatus.Length
					emeraldStatus[i] = ds.ReadByte()
				Next
				
				Return
			Catch E:StreamError
				If (ds <> Null) Then
					ds.Close()
				EndIf
			End Try
			
			For Local i:= 0 Until emeraldStatus.Length
				emeraldStatus[i] = 0
			Next
		End
		
		Function saveData:Void()
			#Rem
				' Constant variable(s):
				Const DEFAULT_FILE_SIZE:= 16 ' 7
				
				' Local variable(s):
				Local ds:= New PublicDataStream(DEFAULT_FILE_SIZE)
				
				For Local i:= 0 Until emeraldStatus.Length
					ds.WriteByte(emeraldStatus[i])
				Next
				
				Record.saveRecord(Record.EMERALD_RECORD, ds.ToDataBuffer())
				
				ds.Close()
			#End
			
			Local buffer:= New DataBuffer(emeraldStatus.Length)
			
			For Local i:= 0 Until emeraldStatus.Length
				buffer.PokeByte(i, emeraldStatus[i])
			Next
			
			Record.saveRecord(Record.EMERALD_RECORD, buffer)
		End
		
		Function emptyEmeraldArray:Void()
			For Local i:= 0 Until emeraldStatus.Length
				emeraldStatus[i] = 0
			Next
			
			saveData()
		End
		
		Function emeraldMissed:Bool()
			For Local i:= 0 Until emeraldStatus.Length
				If (emeraldStatus[i] <> 1) Then
					Return True
				EndIf
			Next
			
			Return False
		End
		
		Function emeraldID:Int(stageId:Int)
			Return STAGE_ID_TO_SPECIAL_ID[stageId]
		End
		
		Function emeraldState:Int(stageId:Int)
			Return emeraldStatus[emeraldID(stageId)]
		End
		
		Function setEmeraldState:Void(stageId:Int, state:Int)
			emeraldStatus[emeraldID(stageId)] = state
		End
	Private
		' Methods:
		Method backToGameStage:Void()
			State.setState(STATE_PAUSE_TO_TITLE)
		End
		
		Method pausetoTitleLogic:Void()
			Select (secondEnsureLogic())
				Case WORD_FINISH_STAGE
					Key.touchanykeyInit()
					Key.touchMainMenuInit2()
					
					AnimationDrawer.setAllPause(False)
					
					StageManager.characterFromGame = PlayerObject.getCharacterID()
					StageManager.stageIDFromGame = StageManager.getStageID()
					
					State.setState(STATE_GAMING)
				Case STATE_GAMING
					pauseInitFromItems()
				Default
					' Nothing so far.
			End Select
		End
		
		Method pauseOptionSoundLogic:Void()
			Select (itemsSelect2Logic())
				Case WORD_FINISH_STAGE
					GlobalResource.soundConfig = 5
					GlobalResource.seConfig = 1
					
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
					
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				Case STATE_GAMING
					GlobalResource.soundConfig = 0
					GlobalResource.seConfig = 0
					
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
					
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				Case STATE_END
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
					
					SoundSystem.getInstance().setSoundState(GlobalResource.soundConfig)
					SoundSystem.getInstance().setSeState(GlobalResource.seConfig)
				Default
					' Nothing so far.
			End Select
		End
		
		Method pauseOptionVibrationLogic:Void()
			Select (itemsSelect2Logic())
				Case WORD_FINISH_STAGE
					GlobalResource.vibrationConfig = 1
					
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
					
					MyAPI.vibrate()
				Case STATE_GAMING
					GlobalResource.vibrationConfig = 0
					
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
				Case STATE_END
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
				Default
					' Nothing so far.
			End Select
		End
		
		Method pauseOptionSpSetLogic:Void()
			Select (itemsSelect2Logic())
				Case 1
					GlobalResource.spsetConfig = 0
					
					State.fadeInit(102, 0)
					
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
				Case 2
					GlobalResource.spsetConfig = 1
					
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
					
					Key.touchkeyboardClose()
					
					If (bButton = Null) Then
						bButton = New MFTouchKey(0, 0, MyAPI.zoomOut(SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(SCREEN_HEIGHT), Key.B_SEL)
						
						MFDevice.addComponent(bButton)
					EndIf
					
					If (aButton = Null) Then
						aButton = New MFTouchKey(MyAPI.zoomOut(SCREEN_WIDTH) Shr 1, 0, MyAPI.zoomOut(SCREEN_WIDTH) Shr 1, MyAPI.zoomOut(SCREEN_HEIGHT), Key.B_HIGH_JUMP)
						
						MFDevice.addComponent(aButton)
					EndIf
				Case 3
					State.fadeInit(102, 0)
					
					Self.state = STATE_PAUSE_OPTION
				Default
					' Nothing so far.
			End Select
		End
		
		Method pauseInit:Void()
			If (SpecialObject.player.velZ <> 0) Then
				Self.preVelZ = SpecialObject.player.velZ
			EndIf
			
			SpecialObject.player.velZ = 0
			
			Self.state = STATE_PAUSE
			
			Key.touchGamePauseInit(0)
			
			Self.pausecnt = 0
			Self.pause_saw_x = -50
			Self.pause_saw_y = 0
			Self.pause_saw_speed = 30
			Self.pause_item_x = SCREEN_WIDTH - 26
			Self.pause_item_speed = (-((SCREEN_WIDTH Shr 1) + 14)) / 3
			
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Self.pause_returnFlag = False
			Self.pause_item_y = (SCREEN_HEIGHT Shr 1) - 36
			
			State.fadeInit_Modify(0, 102)
			SoundSystem.getInstance().stopBgm(False)
			Key.touchgamekeyClose()
			AnimationDrawer.setAllPause(True)
		End
		
		Method pauseInitFromItems:Void()
			If (SpecialObject.player.velZ <> 0) Then
				Self.preVelZ = SpecialObject.player.velZ
			EndIf
			
			SpecialObject.player.velZ = 0
			
			Self.state = STATE_PAUSE
			
			Key.touchGamePauseInit(0)
			Key.touchgamekeyClose()
			
			State.fadeInit_Modify(192, 102)
		End
		
		Method pauseLogic:Void()
			Self.pausecnt += 1
			
			If (Self.pausecnt >= 5 And Self.pausecnt <= 7) Then
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
				For Local i:= 0 Until 3 ' Key.touchgamepauseitem.Length
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
					EndIf
				EndIf
				
				If (Self.pause_optionFlag And Self.pausecnt > Self.pause_optionframe + 3) Then
					optionInit()
					
					Self.state = STATE_PAUSE_OPTION
					Self.pause_optionFlag = False
				EndIf
				
				If (Not State.fadeChangeOver()) Then
					For Local i:= 0 Until 3 ' Key.touchgamepauseitem[i].Length
						Key.touchgamepauseitem[i].resetKeyState()
					Next
				ElseIf (Key.touchgamepauseitem[0].IsButtonPress() And Self.pause_item_cursor = 0 And Not Self.pause_optionFlag) Then
					Self.pause_returnFlag = True
					Self.pause_returnframe = Self.pausecnt
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
				ElseIf (Key.touchgamepauseitem[1].IsButtonPress() And Self.pause_item_cursor = 1 And State.fadeChangeOver()) Then
					Self.state = STATE_PAUSE_TO_TITLE
					
					State.fadeInit(102, 220)
					
					secondEnsureInit()
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
				ElseIf (Key.touchgamepauseitem[2].IsButtonPress() And Self.pause_item_cursor = 2 And Not Self.pause_optionFlag) Then
					changeStateWithFade(STATE_PAUSE_OPTION)
					optionInit()
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
				EndIf
			EndIf
		End
		
		Method pauseDraw:Void(g:MFGraphics)
			State.drawFade(g)
			
			Local animationDrawer:= muiAniDrawer
			
			If (Self.pausecnt > 5) Then
				animationDrawer.setActionId(50)
				animationDrawer.draw(g, Self.pause_saw_x, Self.pause_saw_y)
			EndIf
			
			If (Self.pausecnt > 7) Then
				animationDrawer.setActionId(PickValue(Key.touchgamepausereturn.Isin(), 5, 0) + 61)
				animationDrawer.draw(g, 0, SCREEN_HEIGHT)
			EndIf
			
			If (Self.pausecnt > 5) Then
				animationDrawer.setActionId(Int((Self.pause_item_cursor = 0 And Key.touchgamepauseitem[0].Isin())) + 2)
				animationDrawer.draw(g, Self.pause_item_x, Self.pause_item_y)
				
				animationDrawer.setActionId(Int(Self.pause_item_cursor = 1 And Key.touchgamepauseitem[1].Isin()) + 10)
				animationDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + 24)
				
				animationDrawer.setActionId(Int(Self.pause_item_cursor = 2 And Key.touchgamepauseitem[2].Isin()) + 12)
				animationDrawer.draw(g, Self.pause_item_x, Self.pause_item_y + 48)
			EndIf
		End
		
		Method itemsid:Int(id:Int)
			Local itemsidoffset:= ((Self.optionOffsetY / 24) * 2)
			
			If (id + itemsidoffset < 0) Then
				Return 0
			EndIf
			
			If (id + itemsidoffset > 9) Then
				Return 9
			EndIf
			
			Return (id + itemsidoffset)
		End
		
		Method optionInit:Void()
			If (muiAniDrawer = Null) Then
				muiAniDrawer = New Animation("/animation/mui").getDrawer(0, False, 0)
			EndIf
			
			Self.optionOffsetX = 0
			
			Key.touchGamePauseOptionInit()
			
			Self.pauseOptionCursor = 0
			Self.isOptionDisFlag = False
			
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
		
		Method optionLogic:Void()
			If (Not Self.isOptionDisFlag) Then
				SoundSystem.getInstance().playBgm(SoundSystem.BGM_CONTINUE)
				
				Self.isOptionDisFlag = True
			EndIf
			
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
						
						speed = (-Self.optionDrawOffsetY) Shr 1 ' / 2
						
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
						Self.optionYDirect = 2
						
						speed = ((Self.optionDrawOffsetBottomY - Self.optionDrawOffsetY) Shr 1) ' / 2
						
						If (speed < 2) Then
							speed = 2
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
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
				ElseIf (Key.touchmenuoptionitems[STATE_END].IsButtonPress() And Self.pauseOptionCursor = 1 And State.fadeChangeOver()) Then
					Self.state = STATE_PAUSE_OPTION_VIB
					
					itemsSelect2Init()
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
				ElseIf (Key.touchmenuoptionitems[STATE_WAIT_FOR_OVER].IsButtonPress() And Self.pauseOptionCursor = 2 And State.fadeChangeOver()) Then
					Self.state = STATE_PAUSE_OPTION_SP_SET
					
					itemsSelect2Init()
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
				ElseIf (Key.touchmenuoptionitems[STATE_PAUSE_TO_TITLE].IsButtonPress() And Self.pauseOptionCursor = STATE_END And GlobalResource.spsetConfig <> 0 And State.fadeChangeOver()) Then
					Self.state = STATE_PAUSE_OPTION_SENSOR
					
					spSenorSetInit()
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
				ElseIf (Key.touchmenuoptionitems[STATE_PAUSE_OPTION].IsButtonPress() And Self.pauseOptionCursor = 4 And State.fadeChangeOver()) Then
					changeStateWithFade(STATE_PAUSE_OPTION_HELP)
					AnimationDrawer.setAllPause(False)
					helpInit()
					
					SoundSystem.getInstance().playSe(WORD_FINISH_STAGE)
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
			g.setColor(0)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			Local animationDrawer:= muiAniDrawer
			
			animationDrawer.setActionId(52)
			
			' Magic number: 48 (Width and height?)
			For Local x:= 0 Until ((SCREEN_WIDTH / 48) + 1)
				For Local y:= 0 Until ((SCREEN_HEIGHT / 48) + 1)
					animationDrawer.draw(g, i2 * 48, j * 48)
				Next
			Next
			
			If (Self.state <> STATE_PAUSE_OPTION) Then
				Self.pauseOptionCursor = -2
			EndIf
			
			animationDrawer.setActionId(25)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y))
			
			animationDrawer.setActionId(PickValue((GlobalResource.soundSwitchConfig = 0), 67, Int(Key.touchmenuoptionitems[1].Isin() And Self.pauseOptionCursor = 0 And Self.isSelectable) + 57))
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y))
			
			animationDrawer.setActionId(GlobalResource.soundConfig + 73)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y))
			
			animationDrawer.setActionId(21)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			
			animationDrawer.setActionId(Int(Key.touchmenuoptionitems[STATE_END].Isin() And Self.pauseOptionCursor = 1 And Self.isSelectable) + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			
			animationDrawer.setActionId(Int(GlobalResource.vibrationConfig = 0) + 35)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 24)
			
			animationDrawer.setActionId(23)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			
			animationDrawer.setActionId(Int(Key.touchmenuoptionitems[STATE_WAIT_FOR_OVER].Isin() And Self.pauseOptionCursor = 2 And Self.isSelectable) + 57)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			
			animationDrawer.setActionId(Int(GlobalResource.spsetConfig <> 0) + 37)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) + 56, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 48)
			
			animationDrawer.setActionId(24)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 72)
			
			animationDrawer.setActionId(PickValue((GlobalResource.spsetConfig = 0), 67, Int(Key.touchmenuoptionitems[STATE_PAUSE_TO_TITLE].Isin() And Self.pauseOptionCursor = STATE_END And Self.isSelectable) + 57))
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
			
			animationDrawer.setActionId(Int(Key.touchmenuoptionitems[STATE_PAUSE_OPTION].Isin() And Self.pauseOptionCursor = 4 And Self.isSelectable) + 27)
			animationDrawer.draw(g, (SCREEN_WIDTH Shr 1) - 96, ((Self.optionDrawOffsetY + 40) + Self.optionslide_y) + 96)
			
			Self.optionOffsetX -= 4
			Self.optionOffsetX Mod= OPTION_MOVING_INTERVAL
			
			animationDrawer.setActionId(51)
			
			For Local x1:= Self.optionOffsetX Until (SCREEN_WIDTH * 2) Step OPTION_MOVING_INTERVAL
				animationDrawer.draw(g, x1, 0)
			Next
			
			animationDrawer.setActionId(PickValue(Key.touchmenuoptionreturn.Isin(), 5, 0) + 61)
			animationDrawer.draw(g, 0, SCREEN_HEIGHT)
			
			State.drawFade(g)
		End
		
		Method BacktoGame:Void()
			Self.state = STATE_GAMING
			
			State.fadeInit(102, 0)
			
			SoundSystem instance = SoundSystem.getInstance()
			SoundSystem.getInstance()
			
			instance.playBgm(SoundSystem.BGM_SP)
			
			Key.initSonic()
			
			SpecialObject.player.velZ = Self.preVelZ
			AnimationDrawer.setAllPause(False)
			
			If (Key.touchspstagepause <> Null) Then
				Key.touchspstagepause.resetKeyState()
			EndIf
		End
		
		Method pause:Void()
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
		
		Method interruptInit:Void()
			State.fadeInitAndStart(0, 0)
			
			If (SpecialObject.player.velZ <> 0) Then
				Self.preVelZ = SpecialObject.player.velZ
			EndIf
			
			SpecialObject.player.velZ = 0
			
			If (Self.interruptDrawer = Null) Then
				Self.interruptDrawer = Animation.getInstanceFromQi("/animation/utl_res/suspend_resume.dat")[0].getDrawer(0, True, 0)
			EndIf
			
			isDrawTouchPad = False
			Key.touchInterruptInit()
		End
		
		Method interruptLogic:Void()
			If (Key.touchinterruptreturn <> Null And Key.touchinterruptreturn.IsButtonPress()) Then
				SoundSystem.getInstance().playSe(SoundSystem.SE_107)
				
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
				fading = False
				
				Select (Self.state)
					Case STATE_READY, STATE_INTRO
						State.fadeInit(0, 0)
						
						SpecialObject.player.velZ = Self.preVelZ
					Case STATE_GAMING
						State.fadeInit(192, 192)
						
						SpecialObject.player.velZ = Self.preVelZ
						
						SoundSystem.getInstance().playBgm(SoundSystem.BGM_SP)
					Case STATE_GET_EMERALD
						Self.endingInstance.setOverFromInterrupt()
					Case STATE_PAUSE_TO_TITLE
						State.fadeInit(192, 192)
						
						isDrawTouchPad = False
					Case STATE_PAUSE_OPTION
						optionInit()
						
						isDrawTouchPad = False
					Case STATE_PAUSE_OPTION_SOUND, STATE_PAUSE_OPTION_VIB, STATE_PAUSE_OPTION_KEY_CONTROL, STATE_PAUSE_OPTION_SP_SET, STATE_PAUSE_OPTION_SOUND_VOLUMN, STATE_PAUSE_OPTION_SENSOR
						State.fadeInit(192, 192)
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method interruptDraw:Void(g:MFGraphics)
			Self.interruptDrawer.setActionId(Int(Key.touchinterruptreturn.Isin()))
			Self.interruptDrawer.draw(g, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2) ' Shr 1
		End
End