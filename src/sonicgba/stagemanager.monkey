Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import lib.myapi
	Import lib.record
	Import lib.soundsystem
	'Import lib.constutil
	
	Import sonicgba.backgroundmanager
	Import sonicgba.collisionmap
	Import sonicgba.enemyobject
	Import sonicgba.gameobject
	Import sonicgba.globalresource
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.rocketseparateeffect
	Import sonicgba.smallanimal
	Import sonicgba.sonicdef
	
	Import state.state
	Import state.gamestate
	Import state.specialstagestate
	Import state.titlestate
	
	'Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	
	'Import brl.databuffer
	Import brl.stream
	
	Import regal.typetool
	Import regal.sizeof
	
	Import regal.ioutil.publicdatastream
Public

' Classes:
Class StageManager ' Implements SonicDef
	Private
		' Constant variable(s):
		Const CHARACTER_NUM:Int = 4
		Const HIGH_SCORE_NUM:Int = 5
		
		Const HIGH_SCORE_OFFSET_X:Int = 0
		
		Global HIGH_SCORE_Y:Int = (44 + FONT_H_HALF) ' Const
		Global HIGH_SCORE_Y_TMP:Int = (SCREEN_HEIGHT - 5 * MENU_SPACE / 2) ' Shr 1 ' Const
		
		' Loading states:
		Const LOAD_RELEASE_MEMORY:Int = 0
		Const LOAD_RELEASE_MEMORY_2:Int = 1
		Const LOAD_MAP:Int = 2
		Const LOAD_COLLISION:Int = 3
		Const LOAD_BACKGROUND:Int = 4
		Const LOAD_OBJ_INIT:Int = 5
		Const LOAD_GIMMICK:Int = 6
		Const LOAD_RING:Int = 7
		Const LOAD_ENEMY:Int = 8
		Const LOAD_ITEM:Int = 9
		Const LOAD_ANIMAL:Int = 10
		Const LOAD_GAME_LOGIC:Int = 11
		Const LOAD_SE:Int = 12
		Const LOAD_GAME_INIT:Int = 13
		
		Const MOVING_SPACE:Int = 2
		
		Const RECORD_NUM:Int = 3
		
		Const STAGE_4_1_WATER_LEVEL:Int = 1548
		Const STAGE_4_2_WATER_LEVEL:Int = 1667
		
		Const STAGE_PASS_FRAME:Int = 0
		Const STAGE_TIMEOVER_FRAME:Int = 0
		Const STAGE_GAMEOVER_FRAME:Int = 10
		Const STAGE_RESTART_FRAME:Int = 10
		
		Global RANK_STR_FOR_EN:String[] = ["1st", "2nd", "3rd", "4th", "5th"] ' New String[HIGH_SCORE_NUM] ' Const
		Global STAGE_NAME_LOW:String[] = STAGE_NAME_LOW_SIX ' Const
		
		' Global variable(s):
		Global highScore:Int[] = New Int[HIGH_SCORE_NUM]
		
		Global rankingOffsetX:Int[] = New Int[HIGH_SCORE_NUM]
		
		Global stageIDArray:Int[] = New Int[CHARACTER_NUM]
		Global normalStageIDArray:Int[] = New Int[CHARACTER_NUM]
		Global openedStageIDArray:Int[] = New Int[CHARACTER_NUM]
		Global preStageIDArray:Int[] = New Int[CHARACTER_NUM]
		Global startStageIDArray:Int[] = New Int[CHARACTER_NUM]
		
		Global timeModeScore:Int[] = New Int[CHARACTER_NUM * RECORD_NUM * STAGE_NUM] ' 4 ' 3
		
		Global waterLevel:Int = STAGE_4_1_WATER_LEVEL
		
		Global isRacing:Bool = False
		Global stageGameoverFlag:Bool
		Global stagePassFlag:Bool
		Global stageRestartFlag:Bool
		Global stageTimeoverFlag:Bool
		
		Global drawNewScore:Int = -1
		Global loadStep:Int = LOAD_RELEASE_MEMORY
		Global movingCount:Int = 0
		Global movingRow:Int = 0
		Global normalStageId:Int
		Global openedStageId:Int = 0
		Global preStageId:Int
		Global stageGameoverCount:Int
		Global stageId:Int
		Global stagePassCount:Int
		Global stageRestartCount:Int
		Global stageTimeoverCount:Int
		Global startStageID:Int
	Protected
		' Constant variable(s):
		Const STR_STAGE_NAME_1:= StringIndex.STR_STAGE_NAME_1
		Const STR_STAGE_NAME_2:= StringIndex.STR_STAGE_NAME_2
		Const STR_STAGE_NAME_3:= StringIndex.STR_STAGE_NAME_3
		Const STR_STAGE_NAME_4:= StringIndex.STR_STAGE_NAME_4
	Public
		' Constant variable(s):
		Global STAGE_NUM:Int = STAGE_NAME.Length ' Const
		
		Global STAGE_NAME_HIGH:String[] = ["1_1", "1_2", "2_1", "2_2", "3_1", "3_2", "4_1", "4_2", "5_1", "5_2", "6_1", "6_2", "final", "EX"] ' Const
		Global STAGE_NAME_LOW_FOUR:String[] = ["1_1", "1_2", "2_1", "2_2"] ' Const
		Global STAGE_NAME_LOW_SIX:String[] = ["1_1", "1_2", "2_1", "2_2", "5_1", "5_2"] ' Const
		
		Global STAGE_NAME:String[] = STAGE_NAME_HIGH ' Const
		
		' These IDs should correspond with the stage names in 'state.stringindex'.
		Global STAGE_NAME_ID:Int[] = [STR_STAGE_NAME_1, STR_STAGE_NAME_2, STR_STAGE_NAME_3, STR_STAGE_NAME_4, STR_STAGE_NAME_4, STR_STAGE_NAME_4, STR_STAGE_NAME_4, STR_STAGE_NAME_4] ' [86, 87, 88, 89, 89, 89, 89, 89] ' Const
		
		' Presumably, this is used to match the Zones and acts as you move through the levels.
		Global ZOME_ID:Int[] = [0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 7] ' Const
		
		' If it wouldn't make the arrays huge, these would use the 'BGM constants' found in 'SoundSystem':
		Global MUSIC_ID:Int[] = MUSIC_ID_HIGH ' Const
		Global MUSIC_ID_HIGH:Int[] = [6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 20] ' Const
		Global MUSIC_ID_LOW:Int[] = [6, 7, 8, 9, 10, 11, 12, 13] ' Const
		
		Global PLAYER_START:Int[][] = [[96, 448], [96, 690], [96, 146], [96, 1600], [96, 160], [96, 640], [100, 200], [80, 868], [96, 832], [96, 928], [106, 6988], [100, 1732], [100, 771], [56, 230]] ' Const
		
		' Global variable(s):
		Global characterFromGame:Int = -1
		Global checkCameraDownX:Int
		Global checkCameraEnable:Bool
		Global checkCameraLeftX:Int
		Global checkCameraRightX:Int
		Global checkCameraUpX:Int
		Global checkPointEnable:Bool
		Global checkPointTime:Int
		Global checkPointX:Int
		Global checkPointY:Int
		Global IsCalculateScore:Bool = False
		Global isContinueGame:Bool
		Global isNextGameStageDirectedly:Bool = False
		Global isOnlyScoreCal:Bool = False
		Global isOnlyStagePass:Bool = False
		Global isSaveTimeModeScore:Bool = False
		Global isScoreBarOutOfScreen:Bool = False
		Global specialStagePointX:Int = 0
		Global specialStagePointY:Int = 0
		Global stageIDFromGame:Int = -1
		
		' Functions:
		
		' This function may need to be optimized in the future.
		' I say this because I'm pretty sure some things get done multiple times for no reason.
		' If someone were to extend this function with their own code, that could cause weird behavior.
		Function loadStageStep:Bool()
			Local nextStep:Bool = True
			
			Select (loadStep)
				Case LOAD_RELEASE_MEMORY
					SoundSystem.getInstance().stopBgm(True)
					
					MapManager.closeMap()
					CollisionMap.getInstance().closeMap()
					
					Key.touchkeygameboardClose()
					
					RocketSeparateEffect.getInstance().close()
					
					Key.touchGamePauseClose()
					
					State.isDrawTouchPad = False
					
					PlayerObject.isNeedPlayWaterSE = False
					
					SoundSystem.getInstance().setSoundSpeed(1.0)
				Case LOAD_RELEASE_MEMORY_2
					Local sameStage:Bool = (preStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()])
					
					nextStep = GameObject.closeObjectStep(sameStage)
				Case LOAD_MAP
					PlayerObject.initStageParam()
					
					If (getCurrentZoneId() = 4) Then
						' Check if this is the first or second act:
						If ((stageIDArray[PlayerObject.getCharacterID()] Mod 2) = 0) Then
							' Set the water level for stage 4-1.
							setWaterLevel(STAGE_4_1_WATER_LEVEL)
						Else
							' Set the water level for stage 4-2.
							setWaterLevel(STAGE_4_2_WATER_LEVEL)
						EndIf
					EndIf
					
					nextStep = MapManager.loadMapStep(stageIDArray[PlayerObject.getCharacterID()], STAGE_NAME[stageIDArray[PlayerObject.getCharacterID()]])
				Case LOAD_COLLISION
					nextStep = CollisionMap.getInstance().loadCollisionInfoStep(STAGE_NAME[stageIDArray[PlayerObject.getCharacterID()]])
				Case LOAD_BACKGROUND
					BackGroundManager.init(stageIDArray[PlayerObject.getCharacterID()])
				Case LOAD_OBJ_INIT
					GameObject.initObject(MapManager.getPixelWidth(), MapManager.getPixelHeight(), preStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()])
					
					preStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()]
					
					If (GameState.isBackFromSpStage) Then
						GameObject.setPlayerPosition(specialStagePointX, specialStagePointY)
					Else
						If (Not stageRestartFlag) Then
							checkPointEnable = False
							checkCameraEnable = False
						EndIf
						
						If (stageRestartFlag And checkPointEnable) Then
							GameObject.setPlayerPosition(checkPointX, checkPointY)
							
							PlayerObject.timeCount = checkPointTime
						Else
							GameObject.setPlayerPosition(PLAYER_START[stageIDArray[PlayerObject.getCharacterID()]][0], PLAYER_START[stageIDArray[PlayerObject.getCharacterID()]][1])
							
							PlayerObject.doInitInNewStage()
						EndIf
						
						If (checkCameraEnable And stageRestartFlag And GameObject.stageModeState <> GameObject.STATE_RACE_MODE) Then
							MapManager.setCameraUpLimit(checkCameraUpX)
							MapManager.setCameraDownLimit(checkCameraDownX)
							MapManager.setCameraLeftLimit(checkCameraLeftX)
							MapManager.setCameraRightLimit(checkCameraRightX)
							MapManager.calCameraImmidiately()
						EndIf
					EndIf
				Case LOAD_GIMMICK
					nextStep = GameObject.loadObjectStep("/map/" + STAGE_NAME[stageIDArray[PlayerObject.getCharacterID()]] + ".gi", 0)
					break
				Case LOAD_RING
					nextStep = GameObject.loadObjectStep("/map/" + STAGE_NAME[stageIDArray[PlayerObject.getCharacterID()]] + ".ri", 1)
					break
				Case LOAD_ENEMY
					nextStep = GameObject.loadObjectStep("/map/" + STAGE_NAME[stageIDArray[PlayerObject.getCharacterID()]] + ".en", 2)
					
					If (getCurrentZoneId() = 8) Then ' And nextStep
						Local enemy:= EnemyObject.getNewInstance(EnemyObject.ENEMY_BOSS_EXTRA, 0, 0, 0, 0, 0, 0)
						
						If (Not (enemy = Null Or EnemyObject.IsBoss)) Then
							GameObject.addGameObject(enemy)
						EndIf
						
						nextStep = True
					EndIf
				Case LOAD_ITEM
					nextStep = GameObject.loadObjectStep("/map/" + STAGE_NAME[stageIDArray[PlayerObject.getCharacterID()]] + ".it", RECORD_NUM)
					
					Key.clear()
					
					stagePassFlag = False
					stageRestartFlag = False
					stageGameoverFlag = False
					stageTimeoverFlag = False
				Case LOAD_ANIMAL
					SmallAnimal.animalInit()
					
					MapManager.focusQuickLocation()
				Case LOAD_GAME_LOGIC
					nextStep = True
					
					Key.clear()
					
					GameObject.logicObjects()
				Case LOAD_SE
					GameObject.isDamageSandActive = False
					
					SoundSystem.getInstance().preLoadAllSe()
				Case LOAD_GAME_INIT
					SoundSystem.getInstance().playBgm(getBgmId(), True)
					
					loadStep = LOAD_RELEASE_MEMORY
					
					If (State.loadingType = 2) Then
						isNextGameStageDirectedly = True
					Else
						isNextGameStageDirectedly = False
					EndIf
					
					Return True
			End Select
			
			If (nextStep) Then
				loadStep += 1
			EndIf
			
			Return False
		End
		
		Function getBgmId:Int()
			Return MUSIC_ID[stageIDArray[PlayerObject.getCharacterID()]]
		End
		
		Function draw:Void(g:MFGraphics)
			g.setColor(MapManager.END_COLOR)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			For Local i:= 0 Until STAGE_NAME.Length
				g.setColor(0)
				
				If (i = stageId) Then
					g.setColor(16711680)
				EndIf
				
				MyAPI.drawString(g, "stage" + STAGE_NAME[i], (SCREEN_WIDTH / 2), (i * 20) + 20, 17) ' Shr 1
			Next
		End
		
		Function getCurrentZoneId:Int()
			If (stageIDArray[PlayerObject.getCharacterID()] >= ZOME_ID.Length) Then
				Return (ZOME_ID[ZOME_ID.Length - 1] + 1)
			EndIf
			
			Return (ZOME_ID[stageIDArray[PlayerObject.getCharacterID()]] + 1)
		End
		
		Function setStagePass:Void()
			If (Not stagePassFlag) Then
				stagePassFlag = True
				
				stagePassCount = 0
			EndIf
		End
		
		Function setStageRestart:Void()
			If (Not stageRestartFlag) Then
				stageRestartFlag = True
				
				stageRestartCount = 10
			EndIf
		End
		
		Function setStageGameover:Void()
			If (Not stageGameoverFlag) Then
				stageGameoverFlag = True
				
				stageGameoverCount = 10
			EndIf
		End
		
		Function resetStageGameover:Void()
			stageGameoverFlag = False
		End
		
		Function setStageTimeover:Void()
			If (Not stageTimeoverFlag) Then
				stageTimeoverFlag = True
				
				stageTimeoverCount = 0
			EndIf
		End
		
		Function stageLogic:Void()
			If (stagePassFlag And stagePassCount > 0) Then
				stagePassCount -= 1
			EndIf
			
			If (stageRestartFlag And stageRestartCount > 0) Then
				stageRestartCount -= 1
			EndIf
			
			If (stageGameoverFlag And stageGameoverCount > 0) Then
				stageGameoverCount -= 1
			EndIf
			
			If (stageTimeoverFlag And stageTimeoverCount > 0) Then
				stageTimeoverCount -= 1
			EndIf
		End
		
		Function isStagePassTimePause:Bool()
			Return stagePassFlag
		End
		
		Function isStagePass:Bool()
			Return (stagePassFlag And stagePassCount = 0)
		End
		
		Function isStageRestart:Bool()
			Return (stageRestartFlag And stageRestartCount = 0)
		End
		
		Function isStageGameover:Bool()
			Return (stageGameoverFlag And stageGameoverCount = 0)
		End
		
		Function isStageTimeover:Bool()
			Return (stageTimeoverFlag And stageTimeoverCount = 0)
		End
		
		Function setStageID:Void(id:Int)
			stageIDArray[PlayerObject.getCharacterID()] = id
		End
		
		Function setStartStageID:Void(id:Int)
			startStageIDArray[PlayerObject.getCharacterID()] = id
		End
		
		Function getStartStageID:Int()
			Return startStageIDArray[PlayerObject.getCharacterID()]
		End
		
		Function getStageID:Int()
			Return stageIDArray[PlayerObject.getCharacterID()]
		End
		
		Function addStageID:Void() 
			Local characterID:= PlayerObject.getCharacterID()
			
			stageIDArray[characterID] += 1
			
			If (openedStageIDArray[PlayerObject.getCharacterID()] < stageIDArray[PlayerObject.getCharacterID()]) Then
				openedStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()]
			EndIf
		End
		
		Function IsStageEnd:Bool()
			If ((stageIDArray[PlayerObject.getCharacterID()] + 1) = STAGE_NAME.Length) Then
				Return True
			EndIf
			
			Return False
		End
		
		Function getTimeModeScore:Int(characterid:Int)
			Return getTimeModeScore(characterid, stageIDArray[characterid])
		End
		
		Function setTimeModeScore:Void(characterid:Int, score:Int)
			If (score <= timeModeScore[((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)]) Then
				timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 2] = timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 1]
				timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 1] = timeModeScore[((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)]
				timeModeScore[((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)] = score
			ElseIf (score <= timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 1]) Then
				timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 2] = timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 1]
				timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 1] = score
			ElseIf (score <= timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 2]) Then
				timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (stageIDArray[characterid] * RECORD_NUM)) + 2] = score
			EndIf
		End
		
		Function getTimeModeScore:Int(characterid:Int, id:Int)
			Return timeModeScore[((STAGE_NUM * RECORD_NUM) * characterid) + (id * RECORD_NUM)]
		End
		
		Function getTimeModeScore:Int(characterid:Int, id:Int, index:Int)
			Return timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (id * RECORD_NUM)) + index]
		End
		
		Function getTimeModeScore:Int[]()
			Return timeModeScore
		End
		
		Function setTimeModeScore:Void(tmpTimeModeScore:Int[])
			For Local i:= 0 Until timeModeScore.Length
				timeModeScore[i] = tmpTimeModeScore[i]
			Next
		End
		
		Function loadHighScoreRecord:Void()
			Local ds:Stream
			
			Try
				ds = Record.loadRecordStream(Record.HIGHSCORE_RECORD)
				
				For Local i:= 0 Until timeModeScore.Length
					timeModeScore[i] = ds.ReadInt()
				Next
			Catch E:StreamError
				For Local i:= 0 Until timeModeScore.Length
					timeModeScore[i] = OVER_TIME
				Next
				
				saveHighScoreRecord()
			End Try
			
			If (ds <> Null) Then
				ds.Close()
			EndIf
		End
		
		Function saveHighScoreRecord:Void()
			Local ds:PublicDataStream
			
			Try
				ds = New PublicDataStream((timeModeScore.Length * SizeOf_Integer))
				
				For Local i:= 0 Until timeModeScore.Length
					ds.WriteInt(timeModeScore[i])
				Next
				
				Record.saveRecordStream(Record.HIGHSCORE_RECORD, ds)
			Catch E:StreamError
				' Nothing so far.
			End Try
			
			If (ds <> Null) Then
				ds.Close()
			EndIf
		End
		
		Function loadStageRecord:Void()
			Local ds:Stream
			
			Try
				ds = Record.loadRecordStream(Record.STAGE_RECORD)
				
				stageId = ds.ReadByte()
				
				For Local i:= 0 Until CHARACTER_NUM ' stageIDArray.Length
					stageIDArray[i] = ds.ReadByte()
				Next
				
				openedStageId = ds.ReadByte()
				
				If (openedStageId >= STAGE_NUM) Then
					openedStageId = (STAGE_NUM - 1)
				EndIf
				
				'Local characterID:= PlayerObject.getCharacterID()
				
				For Local i:= 0 Until CHARACTER_NUM ' openedStageIDArray.Length
					openedStageIDArray[i] = ds.ReadByte()
					
					If (openedStageIDArray[i] >= STAGE_NUM) Then
						openedStageIDArray[i] = (STAGE_NUM - 1)
					EndIf
				Next
				
				' Skip the time-mode scores.
				ds.Seek(ds.Position + (timeModeScore.Length * SizeOf_Integer))
				
				normalStageId = ds.ReadByte()
				
				If (normalStageId <> stageId) Then
					stageId = normalStageId
				EndIf
				
				For Local i:= 0 Until CHARACTER_NUM ' normalStageIDArray.Length
					normalStageIDArray[i] = ds.ReadByte()
					
					If (normalStageIDArray[i] <> stageIDArray[i]) Then
						stageIDArray[i] = normalStageIDArray[i]
					EndIf
				Next
				
				startStageID = ds.ReadByte()
				
				For Local i:= 0 Until CHARACTER_NUM ' startStageIDArray.Length
					startStageIDArray[i] = ds.ReadByte()
				Next
				
				characterFromGame = ds.ReadByte()
				stageIDFromGame = ds.ReadByte()
				
				PlayerObject.setLife(ds.ReadByte())
				PlayerObject.setScore(ds.ReadInt())
			Catch E:StreamError
				Print("Exception caught: " + E.ToString())
				
				stageId = 0
				
				For Local i:= 0 Until CHARACTER_NUM ' stageIDArray.Length
					stageIDArray[i] = 0
				Next
				
				normalStageId = 0
				
				For Local i:= 0 Until CHARACTER_NUM ' stageIDArray.Length
					normalStageIDArray[i] = 0
				Next
				
				PlayerObject.setScore(0)
				PlayerObject.setLife(PlayerObject.LIFE_NUM_RESET)
				
				openedStageId = 0
				
				For Local i:= 0 Until CHARACTER_NUM ' openedStageIDArray.Length
					openedStageIDArray[i] = 0
				Next
				
				PlayerObject.resetGameParam()
				
				For Local i:= 0 Until timeModeScore.Length
					timeModeScore[i] = OVER_TIME
				Next
				
				startStageID = 0
				
				For Local i:= 0 Until CHARACTER_NUM ' startStageIDArray.Length
					startStageIDArray[i] = 0
				Next
				
				characterFromGame = -1
				stageIDFromGame = -1
				
				PlayerObject.setScore(0)
				PlayerObject.setLife(PlayerObject.LIFE_NUM_RESET)
				
				saveStageRecord()
			End Try
			
			If (ds <> Null) Then
				ds.Close()
			EndIf
		End
		
		Function saveStageRecord:Void()
			Local ds:PublicDataStream
			
			Try
				ds = New PublicDataStream((timeModeScore.Length * SizeOf_Integer))
				
				ds.WriteByte(stageId)
				
				For Local i:= 0 Until CHARACTER_NUM ' stageIDArray.Length
					ds.WriteByte(stageIDArray[i])
				Next
				
				ds.WriteByte(openedStageId)
				
				'Local characterID:= PlayerObject.getCharacterID()
				
				For Local i:= 0 Until CHARACTER_NUM ' openedStageIDArray.Length
					ds.WriteByte(openedStageIDArray[i])
				Next
				
				' These are normally skipped by 'loadStageRecord':
				For Local i:= 0 Until timeModeScore.Length
					ds.WriteInt(timeModeScore[i])
				Next
				
				ds.WriteByte(normalStageId)
				
				For Local i:= 0 Until CHARACTER_NUM ' normalStageIDArray.Length
					ds.WriteByte(normalStageIDArray[i])
				Next
				
				ds.WriteByte(startStageID)
				
				For Local i:= 0 Until CHARACTER_NUM ' startStageIDArray.Length
					ds.WriteByte(startStageIDArray[i])
				Next
				
				ds.WriteByte(characterFromGame)
				ds.WriteByte(stageIDFromGame)
				
				ds.WriteByte(PlayerObject.getLife())
				ds.WriteInt(PlayerObject.getScore())
				
				Record.saveRecordStream(Record.STAGE_RECORD, ds)
			Catch E:StreamError
				' Nothing so far.
			End Try
			
			If (ds <> Null) Then
				ds.Close()
			EndIf
		End
		
		Function addNewNormalScore:Void(newScore:Int)
			Local isNewScore:Bool = False
			Local tmpScore:Int = 0
			
			For Local i:= 0 Until HIGH_SCORE_NUM ' highScore.Length
				If (isNewScore) Then
					Local tmpScore2:= highScore[i]
					highScore[i] = tmpScore
					tmpScore = tmpScore2
				ElseIf (newScore > highScore[i]) Then
					isNewScore = True
					
					tmpScore = highScore[i]
					
					highScore[i] = newScore
					
					drawNewScore = i
				EndIf
			Next
		End
		
		Function normalHighScoreInit:Void()
			movingRow = 0
			movingCount = 0
			
			For Local i:= 0 Until rankingOffsetX.Length
				rankingOffsetX[i] = SCREEN_WIDTH
			Next
		End
		
		Function drawNormalHighScore:Void(g:MFGraphics)
			For Local i:= 0 Until HIGH_SCORE_NUM
				If (drawNewScore = i And ((Millisecs() / 300) Mod 2) = 0) Then
					State.drawMenuFontById(g, 49, (((SCREEN_WIDTH / 2) - 45) + rankingOffsetX[i]), HIGH_SCORE_Y + (MENU_SPACE * i)) ' Shr 1
					State.drawMenuFontById(g, i + 38, (((SCREEN_WIDTH / 2) - 45) + rankingOffsetX[i]), HIGH_SCORE_Y + (MENU_SPACE * i)) ' Shr 1
					
					PlayerObject.drawNum(g, highScore[i], ((((SCREEN_WIDTH / 2) + 20) + 48) + rankingOffsetX[i]), (MENU_SPACE * i) + HIGH_SCORE_Y, 2, 4) ' Shr 1
				Else
					State.drawMenuFontById(g, 48, (((SCREEN_WIDTH / 2) - 45) + rankingOffsetX[i]), HIGH_SCORE_Y + (MENU_SPACE * i)) ' Shr 1
					State.drawMenuFontById(g, i + 28, (((SCREEN_WIDTH / 2) - 45) + rankingOffsetX[i]), HIGH_SCORE_Y + (MENU_SPACE * i)) ' Shr 1
					PlayerObject.drawNum(g, highScore[i], ((((SCREEN_WIDTH / 2) + 20) + 48) + rankingOffsetX[i]), (MENU_SPACE * i) + HIGH_SCORE_Y, 2, 0) ' Shr 1
				EndIf
			Next
			
			If (movingRow < rankingOffsetX.Length And (movingCount Mod 2) = 0) Then
				movingRow += 1
			EndIf
			
			movingCount += 1
			
			For Local i:= 0 Until movingRow
				rankingOffsetX[i] = MyAPI.calNextPosition(Double(rankingOffsetX[i]), 0.0, 1, RECORD_NUM)
			Next
		End
		
		Function drawHighScoreEnd:Void()
			drawNewScore = -1
		End
		
		Function getOpenedStageId:Int()
			If (TitleState.preStageSelectState = TitleState.STATE_PRO_RACE_MODE) Then
				Return getMaxStageID()
			EndIf
			
			Local stageid:= openedStageIDArray[PlayerObject.getCharacterID()]
			
			If (PlayerObject.getCharacterID() = CHARACTER_SONIC) Then
				If (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
					If (stageid >= STAGE_NUM) Then
						stageid = STAGE_NUM
					EndIf
				ElseIf (GameObject.stageModeState = GameObject.STATE_RACE_MODE And stageid >= (STAGE_NUM - 3)) Then
					stageid = (STAGE_NUM - 3)
				EndIf
			ElseIf (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				stageid = Min(stageid, (STAGE_NUM - 2))
			ElseIf (GameObject.stageModeState = GameObject.STATE_RACE_MODE And stageid >= (STAGE_NUM - 3)) Then
				stageid = (STAGE_NUM - 3)
			EndIf
			
			Return stageid
		End
		
		Function getMaxStageID:Int()
			If (PlayerObject.getCharacterID() = 0) Then
				If (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
					If (openedStageIDArray[PlayerObject.getCharacterID()] >= (STAGE_NUM - 1)) Then
						Return (STAGE_NUM - 1)
					EndIf
					
					Return (STAGE_NUM - 2)
				ElseIf (GameObject.stageModeState = GameObject.STATE_RACE_MODE) Then
					Return (STAGE_NUM - 3)
				EndIf
			ElseIf (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				Return (STAGE_NUM - 2)
			Else
				If (GameObject.stageModeState = GameObject.STATE_RACE_MODE) Then
					Return (STAGE_NUM - 3)
				EndIf
			EndIf
			
			Return 0
		End
		
		Function resetOpenedStageIdforTry:Void(id:Int)
			openedStageIDArray[PlayerObject.getCharacterID()] = id
			stageIDArray[PlayerObject.getCharacterID()] = 0
			normalStageIDArray[PlayerObject.getCharacterID()] = 0
			
			saveStageRecord()
		End
		
		Function hasContinueGame:Bool()
			Return stageIDArray[PlayerObject.getCharacterID()] = 0
		End
		
		Function saveCheckPoint:Void(x:Int, y:Int)
			checkPointX = (x Shr 6)
			checkPointY = (y Shr 6)
			
			checkPointEnable = True
			
			checkPointTime = PlayerObject.timeCount
		End
		
		Function saveSpecialStagePoint:Void(x:Int, y:Int)
			specialStagePointX = (x Shr 6)
			specialStagePointY = (y Shr 6)
		End
		
		Function saveCheckPointCamera:Void(cameraUpX:Int, cameraDownX:Int, cameraLeftX:Int, cameraRightX:Int)
			checkCameraUpX = cameraUpX
			checkCameraDownX = cameraDownX
			checkCameraLeftX = cameraLeftX
			checkCameraRightX = cameraRightX
			
			checkCameraEnable = True
		End
		
		Function resetStageId:Void()
			If (openedStageIDArray[PlayerObject.getCharacterID()] < stageIDArray[PlayerObject.getCharacterID()]) Then
				openedStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()]
			EndIf
			
			stageIDArray[PlayerObject.getCharacterID()] = 0
			normalStageIDArray[PlayerObject.getCharacterID()] = 0
			
			saveStageRecord()
		End
		
		Function resetStageIdforTry:Void()
			openedStageIDArray[PlayerObject.getCharacterID()] = 0
			stageIDArray[PlayerObject.getCharacterID()] = 0
			normalStageIDArray[PlayerObject.getCharacterID()] = 0
			
			saveStageRecord()
		End
		
		Function resetStageIdforContinueEnd:Void()
			characterFromGame = -1
			stageIDFromGame = -1
			
			PlayerObject.setScore(0)
			PlayerObject.setLife(PlayerObject.LIFE_NUM_RESET)
			
			saveStageRecord()
		End
		
		Function resetGameRecord:Void()
			stageId = 0
			
			For Local i:= 0 Until CHARACTER_NUM ' stageIDArray.Length
				stageIDArray[i] = 0
			Next
			
			normalStageId = 0
			
			For Local i:= 0 Until CHARACTER_NUM ' normalStageIDArray.Length
				normalStageIDArray[i] = 0
			Next
			
			PlayerObject.setScore(0)
			PlayerObject.setLife(PlayerObject.LIFE_NUM_RESET)
			
			openedStageId = 0
			
			For Local i:= 0 Until CHARACTER_NUM ' openedStageIDArray.Length
				openedStageIDArray[i] = 0
			Next
			
			PlayerObject.resetGameParam()
			
			For Local i:= 0 Until timeModeScore.Length
				timeModeScore[i] = OVER_TIME
			Next
			
			startStageID = 0
			
			For Local i:= 0 Until CHARACTER_NUM ' startStageIDArray.Length
				startStageIDArray[i] = 0
			Next
			
			characterFromGame = -1
			stageIDFromGame = -1
			
			PlayerObject.setScore(0)
			PlayerObject.setLife(PlayerObject.LIFE_NUM_RESET)
			
			SpecialStageState.emptyEmeraldArray()
			
			GlobalResource.initSystemConfig()
			
			saveStageRecord()
		End
		
		Function doWhileEnterRace:Void()
			If (Not isRacing) Then
				normalStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()]
				
				isRacing = True
			EndIf
		End
		
		Function doWhileLeaveRace:Void()
			If (isRacing) Then
				stageIDArray[PlayerObject.getCharacterID()] = normalStageIDArray[PlayerObject.getCharacterID()]
				
				isRacing = False
			EndIf
		End
		
		Function getStageNameID:Int(stageID:Int)
			Return STAGE_NAME_ID[stageID / 2]
		End
		
		Function setWaterLevel:Void(level:Int)
			waterLevel = level
		End
		
		Function getWaterLevel:Int()
			If (getCurrentZoneId() = 4) Then
				Return waterLevel
			EndIf
			
			Return -1
		End
		
		Function isGoingToExtraStage:Bool()
			Return (PlayerObject.getCharacterID() = 0 And Not SpecialStageState.emeraldMissed() And getStartStageID() <> 12 And getStageID() = 12)
		End
		
		Function stagePassInit:Void()
			isOnlyScoreCal = False
			isOnlyStagePass = False
			isScoreBarOutOfScreen = False
			
			PlayerObject.isbarOut = False
		End
		
		Function setOnlyScoreCal:Void()
			isOnlyScoreCal = True
			isOnlyStagePass = False
			
			PlayerObject.isbarOut = True
		End
		
		Function setStraightlyPass:Void()
			isOnlyStagePass = True
		End
		
		Function isScoreBarOut:Bool()
			Return isScoreBarOutOfScreen
		End
End