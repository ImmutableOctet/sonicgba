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
	
	Import state.gamestate
	Import state.specialstagestate
	Import state.state
	Import state.titlestate
	Import state.stringindex
	
	'Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	
	'Import brl.databuffer
	Import brl.stream
	
	Import regal.typetool
	'Import regal.sizeof
Public

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
		
		Public Function draw:Void(g:MFGraphics)
			g.setColor(MapManager.END_COLOR)
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			For (Int i = 0; i < STAGE_NAME.Length; i += 1)
				g.setColor(0)
				
				If (i = stageId) Then
					g.setColor(16711680)
				EndIf
				
				MyAPI.drawString(g, "stage" + STAGE_NAME[i], SCREEN_WIDTH Shr 1, (i * 20) + 20, 17)
			Next
		}
		
		Public Function getCurrentZoneId:Int()
			
			If (stageIDArray[PlayerObject.getCharacterID()] >= ZOME_ID.Length) Then
				Return ZOME_ID[ZOME_ID.Length - 1] + 1
			EndIf
			
			Return ZOME_ID[stageIDArray[PlayerObject.getCharacterID()]] + 1
		}
		
		Public Function setStagePass:Void()
			
			If (Not stagePassFlag) Then
				stagePassFlag = True
				stagePassCount = 0
			EndIf
			
		}
		
		Public Function setStageRestart:Void()
			
			If (Not stageRestartFlag) Then
				stageRestartFlag = True
				stageRestartCount = STAGE_RESTART_FRAME
			EndIf
			
		}
		
		Public Function setStageGameover:Void()
			
			If (Not stageGameoverFlag) Then
				stageGameoverFlag = True
				stageGameoverCount = STAGE_RESTART_FRAME
			EndIf
			
		}
		
		Public Function resetStageGameover:Void()
			stageGameoverFlag = False
		}
		
		Public Function setStageTimeover:Void()
			
			If (Not stageTimeoverFlag) Then
				stageTimeoverFlag = True
				stageTimeoverCount = 0
			EndIf
			
		}
		
		Public Function stageLogic:Void()
			
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
			
		}
		
		Public Function isStagePassTimePause:Bool()
			Return stagePassFlag
		}
		
		Public Function isStagePass:Bool()
			Return stagePassFlag And stagePassCount = 0
		}
		
		Public Function isStageRestart:Bool()
			Return stageRestartFlag And stageRestartCount = 0
		}
		
		Public Function isStageGameover:Bool()
			Return stageGameoverFlag And stageGameoverCount = 0
		}
		
		Public Function isStageTimeover:Bool()
			Return stageTimeoverFlag And stageTimeoverCount = 0
		}
		
		Public Function setStageID:Void(id:Int)
			stageIDArray[PlayerObject.getCharacterID()] = id
		}
		
		Public Function setStartStageID:Void(id:Int)
			startStageIDArray[PlayerObject.getCharacterID()] = id
		}
		
		Public Function getStartStageID:Int()
			Return startStageIDArray[PlayerObject.getCharacterID()]
		}
		
		Public Function getStageID:Int()
			Return stageIDArray[PlayerObject.getCharacterID()]
		}
		
		Public Function addStageID:Void()
			Int[] iArr = stageIDArray
			Int characterID = PlayerObject.getCharacterID()
			iArr[characterID] = iArr[characterID] + 1
			
			If (openedStageIDArray[PlayerObject.getCharacterID()] < stageIDArray[PlayerObject.getCharacterID()]) Then
				openedStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()]
			EndIf
			
		}
		
		Public Function IsStageEnd:Bool()
			
			If (stageIDArray[PlayerObject.getCharacterID()] + 1 = STAGE_NAME.Length) Then
				Return True
			EndIf
			
			Return False
		}
		
		Public Function getTimeModeScore:Int(characterid:Int)
			Return getTimeModeScore(characterid, stageIDArray[characterid])
		}
		
		Public Function setTimeModeScore:Void(characterid:Int, score:Int)
			
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
			
		}
		
		Public Function getTimeModeScore:Int(characterid:Int, id:Int)
			Return timeModeScore[((STAGE_NUM * RECORD_NUM) * characterid) + (id * RECORD_NUM)]
		}
		
		Public Function getTimeModeScore:Int(characterid:Int, id:Int, index:Int)
			Return timeModeScore[(((STAGE_NUM * RECORD_NUM) * characterid) + (id * RECORD_NUM)) + index]
		}
		
		Public Function getTimeModeScore:Int[]()
			Return timeModeScore
		}
		
		Public Function setTimeModeScore:Void(tmpTimeModeScore:Int[])
			For (Int i = 0; i < timeModeScore.Length; i += 1)
				timeModeScore[i] = tmpTimeModeScore[i]
			Next
		}
		
		Public Function loadHighScoreRecord:Void()
			Int i
			ByteArrayInputStream bs = Record.loadRecordStream(Record.HIGHSCORE_RECORD)
			try {
				DataInputStream ds = New DataInputStream(bs)
				For (i = 0; i < timeModeScore.Length; i += 1)
					timeModeScore[i] = ds.readInt()
				Next
				
				If (bs <> Null) Then
					try {
						bs.close()
					} catch (IOException e) {
						e.printStackTrace()
					}
				EndIf
				
			} catch (Exception e2) {
				e2.printStackTrace()
				For (i = 0; i < timeModeScore.Length; i += 1)
					timeModeScore[i] = Sonicdef.OVER_TIME
				Next
				saveHighScoreRecord()
				
				If (bs <> Null) Then
					try {
						bs.close()
					} catch (Exception e3) {
						e3.printStackTrace()
					}
				EndIf
				
			} catch (Throwable th) {
				
				If (bs <> Null) Then
					try {
						bs.close()
					} catch (IOException e4) {
						e4.printStackTrace()
					}
				EndIf
				
			}
		}
		
		/* JADX WARNING: inconsistent code. */
		/* Code decompiled incorrectly, please refer to instructions dump. */
		Public Function saveHighScoreRecord:Void()
			/*
			r0 = New java.io.ByteArrayOutputStream
			r0.<init>()
			r1 = New java.io.DataOutputStream
			r1.<init>(r0)
			r3 = 0
		L_0x000b:
			r4 = timeModeScore;	 Catch:{ Exception -> 0x0023, all -> 0x002d }
			r4 = r4.Length;	 Catch:{ Exception -> 0x0023, all -> 0x002d }
			
			If (r3 < r4) goto L_0x0019
		L_0x0010:
			r4 = "SONIC_HIGHSCORE_RECORD"
			Lib.Record.saveRecordStream(r4, r0);	 Catch:{ Exception -> 0x0023, all -> 0x002d }
			r1.close();	 Catch:{ IOException -> 0x0037 }
		L_0x0018:
			Return
		L_0x0019:
			r4 = timeModeScore;	 Catch:{ Exception -> 0x0023, all -> 0x002d }
			r4 = r4[r3];	 Catch:{ Exception -> 0x0023, all -> 0x002d }
			r1.writeInt(r4);	 Catch:{ Exception -> 0x0023, all -> 0x002d }
			r3 = r3 + 1
			goto L_0x000b
		L_0x0023:
			r4 = move-exception
			r1.close();	 Catch:{ IOException -> 0x0028 }
			goto L_0x0018
		L_0x0028:
			r2 = move-exception
			r2.printStackTrace()
			goto L_0x0018
		L_0x002d:
			r4 = move-exception
			r1.close();	 Catch:{ IOException -> 0x0032 }
		L_0x0031:
			throw r4
		L_0x0032:
			r2 = move-exception
			r2.printStackTrace()
			goto L_0x0031
		L_0x0037:
			r2 = move-exception
			r2.printStackTrace()
			goto L_0x0018
			*/
			throw New UnsupportedOperationException("Method not decompiled: SonicGBA.StageManager.saveHighScoreRecord():Void")
		}
		
		Public Function loadStageRecord:Void()
			ByteArrayInputStream bs = Record.loadRecordStream(Record.STAGE_RECORD)
			Int i
			try {
				DataInputStream ds = New DataInputStream(bs)
				stageId = ds.readByte()
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					stageIDArray[i] = ds.readByte()
				Next
				openedStageId = ds.readByte()
				
				If (openedStageId >= STAGE_NUM) Then
					openedStageId = STAGE_NUM - 1
				EndIf
				
				Int characterID = PlayerObject.getCharacterID()
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					openedStageIDArray[i] = ds.readByte()
					
					If (openedStageIDArray[i] >= STAGE_NUM) Then
						openedStageIDArray[i] = STAGE_NUM - 1
					EndIf
					
				Next
				For (i = 0; i < timeModeScore.Length; i += 1)
					ds.readInt()
				Next
				normalStageId = ds.readByte()
				
				If (normalStageId <> stageId) Then
					stageId = normalStageId
				EndIf
				
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					normalStageIDArray[i] = ds.readByte()
					
					If (normalStageIDArray[i] <> stageIDArray[i]) Then
						stageIDArray[i] = normalStageIDArray[i]
					EndIf
					
				Next
				startStageID = ds.readByte()
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					startStageIDArray[i] = ds.readByte()
				Next
				characterFromGame = ds.readByte()
				stageIDFromGame = ds.readByte()
				PlayerObject.setLife(ds.readByte())
				PlayerObject.setScore(ds.readInt())
				
				If (bs <> Null) Then
					try {
						bs.close()
					} catch (IOException e) {
						e.printStackTrace()
					}
				EndIf
				
			} catch (Exception e2) {
				e2.printStackTrace()
				stageId = 0
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					stageIDArray[i] = 0
				Next
				normalStageId = 0
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					normalStageIDArray[i] = 0
				Next
				PlayerObject.setScore(0)
				PlayerObject.setLife(2)
				openedStageId = 0
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					openedStageIDArray[i] = 0
				Next
				PlayerObject.resetGameParam()
				For (i = 0; i < timeModeScore.Length; i += 1)
					timeModeScore[i] = Sonicdef.OVER_TIME
				Next
				startStageID = 0
				For (i = 0; i < LOAD_BACKGROUND; i += 1)
					startStageIDArray[i] = 0
				Next
				characterFromGame = -1
				stageIDFromGame = -1
				PlayerObject.setScore(0)
				PlayerObject.setLife(2)
				saveStageRecord()
				
				If (bs <> Null) Then
					try {
						bs.close()
					} catch (Exception e3) {
						e3.printStackTrace()
					}
				EndIf
				
			} catch (Throwable th) {
				
				If (bs <> Null) Then
					try {
						bs.close()
					} catch (IOException e4) {
						e4.printStackTrace()
					}
				EndIf
			EndIf
			
		}
		
		/* JADX WARNING: inconsistent code. */
		/* Code decompiled incorrectly, please refer to instructions dump. */
		Public Function saveStageRecord:Void()
			/*
			r8 = 1
			r7 = 4
			r0 = New java.io.ByteArrayOutputStream
			r0.<init>()
			r2 = New java.io.DataOutputStream
			r2.<init>(r0)
			r5 = stageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = 0
		L_0x0012:
			
			If (r4 < r7) goto L_0x00b1
		L_0x0014:
			r5 = openedStageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = stageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 >= r6) goto L_0x001e
		L_0x001a:
			r5 = stageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			openedStageId = r5;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
		L_0x001e:
			r5 = openedStageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = STAGE_NUM;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 < r6) goto L_0x0029
		L_0x0024:
			r5 = STAGE_NUM;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5 - r8
			openedStageId = r5;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
		L_0x0029:
			r5 = openedStageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r1 = SonicGBA.PlayerObject.getCharacterID();	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = openedStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r1];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = stageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = r6[r1];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 >= r6) goto L_0x0044
		L_0x003c:
			r5 = openedStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = stageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = r6[r1];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5[r1] = r6;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
		L_0x0044:
			r5 = openedStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r1];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = STAGE_NUM;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 < r6) goto L_0x0053
		L_0x004c:
			r5 = openedStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = STAGE_NUM;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = r6 - r8
			r5[r1] = r6;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
		L_0x0053:
			r4 = 0
		L_0x0054:
			
			If (r4 < r7) goto L_0x00bc
		L_0x0056:
			r4 = 0
		L_0x0057:
			r5 = timeModeScore;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5.Length;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r4 < r5) goto L_0x00c6
		L_0x005c:
			r5 = isRacing;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 <> 0) goto L_0x006a
		L_0x0060:
			r5 = normalStageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = stageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 = r6) goto L_0x006a
		L_0x0066:
			r5 = stageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			normalStageId = r5;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
		L_0x006a:
			r5 = isRacing;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 <> 0) goto L_0x0080
		L_0x006e:
			r5 = normalStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r1];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = stageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = r6[r1];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			
			If (r5 = r6) goto L_0x0080
		L_0x0078:
			r5 = normalStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = stageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r6 = r6[r1];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5[r1] = r6;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
		L_0x0080:
			r5 = normalStageId;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = 0
		L_0x0086:
			
			If (r4 < r7) goto L_0x00d0
		L_0x0088:
			r5 = startStageID;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = 0
		L_0x008e:
			
			If (r4 < r7) goto L_0x00da
		L_0x0090:
			r5 = characterFromGame;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = stageIDFromGame;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = SonicGBA.PlayerObject.getLife();	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = SonicGBA.PlayerObject.getScore();	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeInt(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = "SONIC_STAGE_RECORD"
			Lib.Record.saveRecordStream(r5, r0);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.close();	 Catch:{ IOException -> 0x00f8 }
		L_0x00b0:
			Return
		L_0x00b1:
			r5 = stageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r4];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = r4 + 1
			goto L_0x0012
		L_0x00bc:
			r5 = openedStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r4];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = r4 + 1
			goto L_0x0054
		L_0x00c6:
			r5 = timeModeScore;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r4];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeInt(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = r4 + 1
			goto L_0x0057
		L_0x00d0:
			r5 = normalStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r4];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = r4 + 1
			goto L_0x0086
		L_0x00da:
			r5 = startStageIDArray;	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r5 = r5[r4];	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r2.writeByte(r5);	 Catch:{ Exception -> 0x00e4, all -> 0x00ee }
			r4 = r4 + 1
			goto L_0x008e
		L_0x00e4:
			r5 = move-exception
			r2.close();	 Catch:{ IOException -> 0x00e9 }
			goto L_0x00b0
		L_0x00e9:
			r3 = move-exception
			r3.printStackTrace()
			goto L_0x00b0
		L_0x00ee:
			r5 = move-exception
			r2.close();	 Catch:{ IOException -> 0x00f3 }
		L_0x00f2:
			throw r5
		L_0x00f3:
			r3 = move-exception
			r3.printStackTrace()
			goto L_0x00f2
		L_0x00f8:
			r3 = move-exception
			r3.printStackTrace()
			goto L_0x00b0
			*/
			throw New UnsupportedOperationException("Method not decompiled: SonicGBA.StageManager.saveStageRecord():Void")
		}
		
		Public Function addNewNormalScore:Void(newScore:Int)
			Bool isNewScore = False
			Int tmpScore = 0
			For (Int i = 0; i < LOAD_OBJ_INIT; i += 1)
				
				If (isNewScore) Then
					Int tmpScore2 = highScore[i]
					highScore[i] = tmpScore
					tmpScore = tmpScore2
				ElseIf (newScore > highScore[i]) Then
					isNewScore = True
					tmpScore = highScore[i]
					highScore[i] = newScore
					drawNewScore = i
				EndIf
			EndIf
			
		}
		
		Public Function normalHighScoreInit:Void()
			movingRow = 0
			movingCount = 0
			For (Int i = 0; i < rankingOffsetX.Length; i += 1)
				rankingOffsetX[i] = SCREEN_WIDTH
			EndIf
		}
		
		Public Function drawNormalHighScore:Void(g:MFGraphics)
			Int i
			For (i = 0; i < LOAD_OBJ_INIT; i += 1)
				
				If (drawNewScore = i And (Millisecs() / 300) Mod 2 = 0) Then
					State.drawMenuFontById(g, 49, (((SCREEN_WIDTH Shr 1) - 45) + rankingOffsetX[i]) + 0, HIGH_SCORE_Y + (MENU_SPACE * i))
					State.drawMenuFontById(g, i + 38, (((SCREEN_WIDTH Shr 1) - 45) + rankingOffsetX[i]) + 0, HIGH_SCORE_Y + (MENU_SPACE * i))
					PlayerObject.drawNum(g, highScore[i]..((((SCREEN_WIDTH Shr 1) + 20) + 48) + rankingOffsetX[i]) + 0, (MENU_SPACE * i) + HIGH_SCORE_Y, 2, LOAD_BACKGROUND)
				Else
					State.drawMenuFontById(g, 48, (((SCREEN_WIDTH Shr 1) - 45) + rankingOffsetX[i]) + 0, HIGH_SCORE_Y + (MENU_SPACE * i))
					State.drawMenuFontById(g, i + 28, (((SCREEN_WIDTH Shr 1) - 45) + rankingOffsetX[i]) + 0, HIGH_SCORE_Y + (MENU_SPACE * i))
					PlayerObject.drawNum(g, highScore[i]..((((SCREEN_WIDTH Shr 1) + 20) + 48) + rankingOffsetX[i]) + 0, (MENU_SPACE * i) + HIGH_SCORE_Y, 2, 0)
				EndIf
			EndIf
			If (movingRow < rankingOffsetX.Length And movingCount Mod 2 = 0) Then
				movingRow += 1
			EndIf
			
			movingCount += 1
			For (i = 0; i < movingRow; i += 1)
				rankingOffsetX[i] = MyAPI.calNextPosition((Double) rankingOffsetX[i], 0.0, 1, RECORD_NUM)
			EndIf
		}
		
		Public Function drawHighScoreEnd:Void()
			drawNewScore = -1
		}
		
		Public Function getOpenedStageId:Int()
			
			If (TitleState.preStageSelectState = 24) Then
				Return getMaxStageID()
			EndIf
			
			Int stageid = openedStageIDArray[PlayerObject.getCharacterID()]
			
			If (PlayerObject.getCharacterID() = 0) Then
				If (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
					If (stageid >= STAGE_NUM) Then
						stageid = STAGE_NUM
					EndIf
					
				ElseIf (GameObject.stageModeState = GameObject.STATE_RACE_MODE And stageid >= STAGE_NUM - RECORD_NUM) Then
					stageid = STAGE_NUM - RECORD_NUM
				EndIf
				
			ElseIf (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				If (stageid >= STAGE_NUM - 2) Then
					stageid = STAGE_NUM - 2
				EndIf
				
			ElseIf (GameObject.stageModeState = GameObject.STATE_RACE_MODE And stageid >= STAGE_NUM - RECORD_NUM) Then
				stageid = STAGE_NUM - RECORD_NUM
			EndIf
			
			Return stageid
		}
		
		Public Function getMaxStageID:Int()
			
			If (PlayerObject.getCharacterID() = 0) Then
				If (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
					If (openedStageIDArray[PlayerObject.getCharacterID()] >= STAGE_NUM - 1) Then
						Return STAGE_NUM - 1
					EndIf
					
					Return STAGE_NUM - 2
				ElseIf (GameObject.stageModeState = GameObject.STATE_RACE_MODE) Then
					Return STAGE_NUM - RECORD_NUM
				EndIf
				
			ElseIf (GameObject.stageModeState = GameObject.STATE_NORMAL_MODE) Then
				Return STAGE_NUM - 2
			Else
				
				If (GameObject.stageModeState = GameObject.STATE_RACE_MODE) Then
					Return STAGE_NUM - RECORD_NUM
				EndIf
			EndIf
			
			Return 0
		}
		
		Public Function resetOpenedStageIdforTry:Void(id:Int)
			openedStageIDArray[PlayerObject.getCharacterID()] = id
			stageIDArray[PlayerObject.getCharacterID()] = 0
			normalStageIDArray[PlayerObject.getCharacterID()] = 0
			saveStageRecord()
		}
		
		Public Function hasContinueGame:Bool()
			Return stageIDArray[PlayerObject.getCharacterID()] = 0
		}
		
		Public Function saveCheckPoint:Void(x:Int, y:Int)
			checkPointX = x Shr LOAD_GIMMICK
			checkPointY = y Shr LOAD_GIMMICK
			checkPointEnable = True
			checkPointTime = PlayerObject.timeCount
		}
		
		Public Function saveSpecialStagePoint:Void(x:Int, y:Int)
			specialStagePointX = x Shr LOAD_GIMMICK
			specialStagePointY = y Shr LOAD_GIMMICK
		}
		
		Public Function saveCheckPointCamera:Void(cameraUpX:Int, cameraDownX:Int, cameraLeftX:Int, cameraRightX:Int)
			checkCameraUpX = cameraUpX
			checkCameraDownX = cameraDownX
			checkCameraLeftX = cameraLeftX
			checkCameraRightX = cameraRightX
			checkCameraEnable = True
		}
		
		Public Function resetStageId:Void()
			
			If (openedStageIDArray[PlayerObject.getCharacterID()] < stageIDArray[PlayerObject.getCharacterID()]) Then
				openedStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()]
			EndIf
			
			stageIDArray[PlayerObject.getCharacterID()] = 0
			normalStageIDArray[PlayerObject.getCharacterID()] = 0
			saveStageRecord()
		}
		
		Public Function resetStageIdforTry:Void()
			openedStageIDArray[PlayerObject.getCharacterID()] = 0
			stageIDArray[PlayerObject.getCharacterID()] = 0
			normalStageIDArray[PlayerObject.getCharacterID()] = 0
			saveStageRecord()
		}
		
		Public Function resetStageIdforContinueEnd:Void()
			characterFromGame = -1
			stageIDFromGame = -1
			PlayerObject.setScore(0)
			PlayerObject.setLife(2)
			saveStageRecord()
		}
		
		Public Function resetGameRecord:Void()
			Int i
			stageId = 0
			For (i = 0; i < LOAD_BACKGROUND; i += 1)
				stageIDArray[i] = 0
			EndIf
			normalStageId = 0
			For (i = 0; i < LOAD_BACKGROUND; i += 1)
				normalStageIDArray[i] = 0
			EndIf
			PlayerObject.setScore(0)
			PlayerObject.setLife(2)
			openedStageId = 0
			For (i = 0; i < LOAD_BACKGROUND; i += 1)
				openedStageIDArray[i] = 0
			EndIf
			PlayerObject.resetGameParam()
			For (i = 0; i < timeModeScore.Length; i += 1)
				timeModeScore[i] = Sonicdef.OVER_TIME
			EndIf
			startStageID = 0
			For (i = 0; i < LOAD_BACKGROUND; i += 1)
				startStageIDArray[i] = 0
			EndIf
			characterFromGame = -1
			stageIDFromGame = -1
			PlayerObject.setScore(0)
			PlayerObject.setLife(2)
			SpecialStageState.emptyEmeraldArray()
			GlobalResource.initSystemConfig()
			saveStageRecord()
		}
		
		Public Function doWhileEnterRace:Void()
			
			If (Not isRacing) Then
				normalStageIDArray[PlayerObject.getCharacterID()] = stageIDArray[PlayerObject.getCharacterID()]
				isRacing = True
			EndIf
			
		}
		
		Public Function doWhileLeaveRace:Void()
			
			If (isRacing) Then
				stageIDArray[PlayerObject.getCharacterID()] = normalStageIDArray[PlayerObject.getCharacterID()]
				isRacing = False
			EndIf
			
		}
		
		Public Function getStageNameID:Int(stageID:Int)
			Return STAGE_NAME_ID[stageID / 2]
		}
		
		Public Function setWaterLevel:Void(level:Int)
			waterLevel = level
		}
		
		Public Function getWaterLevel:Int()
			
			If (getCurrentZoneId() = 4) Then
				Return waterLevel
			EndIf
			
			Return -1
		}
		
		Public Function isGoingToExtraStage:Bool()
			Return PlayerObject.getCharacterID() = 0 And Not SpecialStageState.emeraldMissed() And getStartStageID() <> LOAD_SE And getStageID() = LOAD_SE
		}
		
		Public Function stagePassInit:Void()
			isOnlyScoreCal = False
			isOnlyStagePass = False
			isScoreBarOutOfScreen = False
			PlayerObject.isbarOut = False
		}
		
		Public Function setOnlyScoreCal:Void()
			isOnlyScoreCal = True
			isOnlyStagePass = False
			PlayerObject.isbarOut = True
		}
		
		Public Function setStraightlyPass:Void()
			isOnlyStagePass = True
		}
		
		Public Function isScoreBarOut:Bool()
			Return isScoreBarOutOfScreen
		}
End