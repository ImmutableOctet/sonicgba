Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.myapi
	Import lib.constutil
	
	Import sonicgba.backgroundmanager
	Import sonicgba.focusable
	Import sonicgba.sonicdef
	Import sonicgba.stagemanager
	
	'Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import brl.stream
	
	Import regal.typetool
Public

' Classes:
Class MapManager ' Implements SonicDef
	Private
		' Constant variable(s):
		Const CAMERA_MAX_SPEED_X:Int = 48
		Const CAMERA_MAX_SPEED_Y:Int = 48
		
		Const CAMERA_SPEED:Int = 5
		
		Const CAM_OFF:Int = 5
		
		Const LINE_HEIGHT:Int = 2
		
		Const LOAD_BACK:Int = 5
		Const LOAD_CAMERA_RESET:Int = 6
		Const LOAD_FRONT:Int = 4
		Const LOAD_MAP_IMAGE:Int = 0
		Const LOAD_MODEL:Int = 3
		Const LOAD_OPEN_FILE:Int = 1
		Const LOAD_OVERALL:Int = 2
		
		Global LOOP_COUNT:Int = (((960 + SCREEN_WIDTH) - 1) / 480) ' Const
		
		Const MODEL_CACHE_DRAW:Bool = False
		
		Const MODEL_WIDTH:Int = 6
		Const MODEL_HEIGHT:Int = 6
		
		Const NO_LINE:Bool = True
		
		Const RECT_FRAME_WIDTH:Int = 40
		
		Const SHAKE_RANGE:Int = 6
		
		Const TILE_WIDTH:Int = 16
		Const TILE_HEIGHT:Int = 16
		
		Const WIND_LOOP_WIDTH:Int = 480
		
		Global WIND_POSITION:Int[][] = [[0, 24, 0], [60, 80, 1], [100, 0, 1], [120, 44, 0], [216, 58, 1], [296, 12, 0], [352, 72, 0], [386, 36, 1]] ' Const
		
		' Global variable(s):
		Global brokeOffsetY:Int
		Global brokePointY:Int
		
		Global camera:Coordinate = New Coordinate()
		Global cameraActionX:Int = LINE_HEIGHT ' 2
		Global cameraActionY:Int = LINE_HEIGHT ' 2
		
		' Flags:
		Global cameraLocked:Bool
		Global cameraUpDownLocked:Bool
		
		Global shakingUp:Bool
		
		Global stageFlag:Bool = False
		
		' Streams:
		Global ds:Stream
		Global is:Stream
		
		Global focusObj:Focusable
		
		Global IMAGE_TILE_WIDTH:Int = TILE_WIDTH
		
		Global loadStep:Int = LOAD_MAP_IMAGE
		
		Global mapLoopLeft:Int
		Global mapLoopRight:Int
		
		Global mappaintframe:Int = 0
		
		Global modelImageArray:MFImage[]
		'Global modelRGB:Int[] = ' New Int[9216]
		
		Global windDrawer:AnimationDrawer
		Global windImage:MFImage
		
		Global shakeCount:Int
		Global shakeMaxCount:Int
		
		Global shakePowerX:Int
		Global shakePowerY:Int
		
		Global stage_id:Int
		
		Global zone4TileLoopID:Int[] = [0, 1, 2, 3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5, 6, 7, 8, 9, 9, 9, 9, 9, 9, 9, 9, 10, 11, 12, 13, 14, 14, 14, 14, 14, 14, 14, 14, 15, 16, 17, 18, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19]
	Public
		' Constant variable(s):
		Global CAMERA_WIDTH:Int = SCREEN_WIDTH ' Const
		Global CAMERA_HEIGHT:Int = SCREEN_HEIGHT ' Const
		
		Global CAMERA_OFFSET_X:Int = ((SCREEN_WIDTH - CAMERA_WIDTH) / 2) ' Const
		Global CAMERA_OFFSET_Y:Int = ((SCREEN_HEIGHT - CAMERA_HEIGHT) / 2) ' Const
		
		Const COLOR_SPACE:Int = 20
		Const END_COLOR:Int = 16777215
		
		Const START_COLOR:Int = 6067452
		Const START_COLOR_2:Int = 15964672
		
		Const MAP_EXTEND_NAME:String = ".pm"
		Const PNG_NAME:String = "/stage"
		
		' Global variable(s):
		Global gameFrame:Int = 0
		
		Global actualDownCameraLimit:Int
		Global actualLeftCameraLimit:Int
		Global actualRightCameraLimit:Int
		Global actualUpCameraLimit:Int
		
		Global image:MFImage
		
		Global tileimage:MFImage[]
		
		Global mapBack:Short[][]
		Global mapFront:Short[][]
		Global mapModel:Short[][][]
		
		Global mapWidth:Int
		Global mapHeight:Int
		Global mapOffsetX:Int
		Global mapVelX:Int = -30
		
		Global proposeDownCameraLimit:Int
		Global proposeLeftCameraLimit:Int
		Global proposeRightCameraLimit:Int
		Global proposeUpCameraLimit:Int
		
		Global reCamera:Coordinate = New Coordinate()
		
		' Functions:
		Function cameraLogic:Void()
			If (focusObj <> Null And Not cameraLocked) Then
				If (getPixelWidth() < CAMERA_WIDTH) Then
					camera.x = ((CAMERA_WIDTH - getPixelWidth()) / 2)
				Else
					cameraActionX()
					
					If (actualLeftCameraLimit > proposeLeftCameraLimit) Then
						actualLeftCameraLimit -= 5
						
						If (actualLeftCameraLimit < proposeLeftCameraLimit) Then
							actualLeftCameraLimit = proposeLeftCameraLimit
						EndIf
						
					ElseIf (actualLeftCameraLimit < proposeLeftCameraLimit) Then
						actualLeftCameraLimit += 5
						
						If (actualLeftCameraLimit > proposeLeftCameraLimit) Then
							actualLeftCameraLimit = proposeLeftCameraLimit
						EndIf
					EndIf
					
					If (actualRightCameraLimit < proposeRightCameraLimit) Then
						actualRightCameraLimit += 5
						
						If (actualRightCameraLimit > proposeRightCameraLimit) Then
							actualRightCameraLimit = proposeRightCameraLimit
						EndIf
						
					ElseIf (actualRightCameraLimit > proposeRightCameraLimit) Then
						actualRightCameraLimit -= 5
						
						If (actualRightCameraLimit < proposeRightCameraLimit) Then
							actualRightCameraLimit = proposeRightCameraLimit
						EndIf
					EndIf
					
					If (camera.x < actualLeftCameraLimit - CAMERA_OFFSET_X) Then
						camera.x = (actualLeftCameraLimit - CAMERA_OFFSET_X)
						
						cameraActionX = 0
					EndIf
					
					If (actualRightCameraLimit <> getPixelWidth() And camera.x > (actualRightCameraLimit - CAMERA_WIDTH) - CAMERA_OFFSET_X) Then
						camera.x = ((actualRightCameraLimit - CAMERA_WIDTH) - CAMERA_OFFSET_X)
						
						cameraActionX = 0
					EndIf
					
					If (actualRightCameraLimit <> getPixelWidth() And Abs(actualRightCameraLimit - actualLeftCameraLimit) < CAMERA_WIDTH) Then
						camera.x = (((actualRightCameraLimit + actualLeftCameraLimit) - CAMERA_WIDTH) Shr 1) ' / 2
						
						cameraActionX = 0
					EndIf
				EndIf
				
				If (Not cameraUpDownLocked) Then
					If (getPixelHeight() < CAMERA_HEIGHT) Then
						camera.y = (CAMERA_HEIGHT - getPixelHeight()) / 2
					Else
						cameraActionY()
						
						If (actualDownCameraLimit > proposeDownCameraLimit) Then
							actualDownCameraLimit -= 5
							
							If (actualDownCameraLimit < proposeDownCameraLimit) Then
								actualDownCameraLimit = proposeDownCameraLimit
							EndIf
							
						ElseIf (actualDownCameraLimit < proposeDownCameraLimit) Then
							actualDownCameraLimit += 5
							
							If (actualDownCameraLimit > proposeDownCameraLimit) Then
								actualDownCameraLimit = proposeDownCameraLimit
							EndIf
						EndIf
						
						If (actualUpCameraLimit < proposeUpCameraLimit) Then
							actualUpCameraLimit += 5
							
							If (actualUpCameraLimit > proposeUpCameraLimit) Then
								actualUpCameraLimit = proposeUpCameraLimit
							EndIf
							
						ElseIf (actualUpCameraLimit > proposeUpCameraLimit) Then
							actualUpCameraLimit -= 5
							
							If (actualUpCameraLimit < proposeUpCameraLimit) Then
								actualUpCameraLimit = proposeUpCameraLimit
							EndIf
						EndIf
						
						If (camera.y < actualUpCameraLimit - CAMERA_OFFSET_Y) Then
							camera.y = actualUpCameraLimit - CAMERA_OFFSET_Y
							cameraActionY = 0
						ElseIf (camera.y > (actualDownCameraLimit - CAMERA_HEIGHT) - CAMERA_OFFSET_Y) Then
							camera.y = (actualDownCameraLimit - CAMERA_HEIGHT) - CAMERA_OFFSET_Y
							cameraActionY = 0
						EndIf
					EndIf
				EndIf
				
				Local coordinate:= camera
				
				coordinate.x += shakePowerX
				
				shakePowerX = 0
				
				If (shakeCount > 0) Then
					shakeCount -= 1
					
					Local shakeRange:= ((shakeCount * shakePowerY) / shakeMaxCount)
					
					coordinate.y += PickValue(shakingUp, shakeRange, -shakeRange)
					
					shakingUp = (Not shakingUp)
					
					If (camera.x < 0) Then
						camera.x = 0
					EndIf
					
					If (camera.x + CAMERA_WIDTH > getPixelWidth()) Then
						camera.x = (getPixelWidth() - CAMERA_WIDTH)
					EndIf
					
					If (camera.y < 0) Then
						camera.y = 0
					EndIf
					
					If (camera.y + CAMERA_HEIGHT > getPixelHeight()) Then
						camera.y = (getPixelHeight() - CAMERA_HEIGHT)
					EndIf
				EndIf
				
				If (StageManager.getCurrentZoneId() = 8) Then
					mapOffsetX += mapVelX
					
					If ((-mapOffsetX) + camera.x > getPixelWidth() - CAMERA_WIDTH And Abs(mapOffsetX) < 0) Then
						' Magic number: 448
						mapOffsetX += 448
					EndIf
				EndIf
			EndIf
		End
	Private
		Private Function cameraActionX:Void()
			Int desCamX = (focusObj.getFocusX() - (CAMERA_WIDTH Shr 1)) - CAMERA_OFFSET_X
			Select (cameraActionX)
				Case 0
					Int preCameraX = camera.x
					camera.x = MyAPI.calNextPosition((Double) camera.x, (Double) desCamX, LOAD_MODEL, SHAKE_RANGE, 4.0)
					
					If (Abs(preCameraX - camera.x) > CAMERA_MAX_SPEED_Y) Then
						If (camera.x > preCameraX) Then
							camera.x = preCameraX + CAMERA_MAX_SPEED_Y
						EndIf
						
						If (camera.x < preCameraX) Then
							camera.x = preCameraX - CAMERA_MAX_SPEED_Y
						EndIf
					EndIf
					
				Case LOAD_OPEN_FILE
					Int destiny
					
					If (desCamX < 0) Then
						destiny = 0
					Else
						destiny = desCamX
					EndIf
					
					Int move = ((destiny - camera.x) * 100) / LOAD_BACK
					Coordinate coordinate = camera
					Int i = coordinate.x
					Int i2 = move / 100
					Int i3 = move = 0 ? 0 : move > 0 ? LOAD_BACK : -5
					coordinate.x = i + (i2 + i3)
					
					If (((destiny * 100) - (camera.x * 100)) * move <= 0) Then
						cameraActionX = 0
					EndIf
					
				Case LOAD_OVERALL
					camera.x = desCamX
					cameraActionX = 0
				Default
			End Select
		}
		
		Private Function cameraActionY:Void()
			Int desCamY = (focusObj.getFocusY() - (CAMERA_HEIGHT Shr 1)) - CAMERA_OFFSET_Y
			Select (cameraActionY)
				Case 0
					Int preCameraY = camera.y
					camera.y = MyAPI.calNextPosition((Double) camera.y, (Double) desCamY, LOAD_MODEL, SHAKE_RANGE, 4.0)
					
					If (Abs(preCameraY - camera.y) > CAMERA_MAX_SPEED_Y) Then
						If (camera.y > preCameraY) Then
							camera.y = preCameraY + CAMERA_MAX_SPEED_Y
						EndIf
						
						If (camera.y < preCameraY) Then
							camera.y = preCameraY - CAMERA_MAX_SPEED_Y
						EndIf
					EndIf
					
				Case LOAD_OPEN_FILE
					Int destiny = focusObj.getFocusY() - (CAMERA_HEIGHT Shr 1) < 0 ? 0 : focusObj.getFocusY() - (CAMERA_HEIGHT Shr 1)
					Int move = ((destiny - camera.y) * 100) / LOAD_BACK
					Coordinate coordinate = camera
					Int i = coordinate.y
					Int i2 = move / 100
					Int i3 = move = 0 ? 0 : move > 0 ? LOAD_BACK : -5
					coordinate.y = i + (i2 + i3)
					
					If (((destiny * 100) - (camera.y * 100)) * move <= 0) Then
						cameraActionY = 0
					EndIf
					
				Case LOAD_OVERALL
					camera.y = desCamY
					cameraActionY = 0
				Default
			End Select
		}
		
		Public Function setCameraLeftLimit:Void(limit:Int)
			proposeLeftCameraLimit = limit
			
			If (proposeLeftCameraLimit <= camera.x) Then
				actualLeftCameraLimit = proposeLeftCameraLimit
			Else
				actualLeftCameraLimit = camera.x
			EndIf
			
		}
		
		Public Function setCameraRightLimit:Void(limit:Int)
			proposeRightCameraLimit = limit
			
			If (proposeRightCameraLimit >= camera.x + CAMERA_WIDTH) Then
				actualRightCameraLimit = proposeRightCameraLimit
			Else
				actualRightCameraLimit = camera.x + CAMERA_WIDTH
			EndIf
			
		}
		
		Public Function setCameraDownLimit:Void(limit:Int)
			proposeDownCameraLimit = limit
			actualDownCameraLimit = camera.y + CAMERA_HEIGHT
		}
		
		Public Function setCameraUpLimit:Void(limit:Int)
			proposeUpCameraLimit = limit
			
			If (camera.y < proposeUpCameraLimit) Then
				actualUpCameraLimit = camera.y
			Else
				actualUpCameraLimit = proposeUpCameraLimit
			EndIf
			
		}
		
		Public Function calCameraImmidiately:Void()
			actualUpCameraLimit = proposeUpCameraLimit
			actualDownCameraLimit = proposeDownCameraLimit
			actualLeftCameraLimit = proposeLeftCameraLimit
			actualRightCameraLimit = proposeRightCameraLimit
		}
		
		Public Function releaseCameraUpLimit:Void()
			proposeUpCameraLimit = 0
		}
		
		Public Function releaseCameraLeftLimit:Void(limit:Int)
			proposeLeftCameraLimit = 0
		}
		
		Public Function releaseCameraRightLimit:Void(limit:Int)
			proposeRightCameraLimit = getPixelWidth()
		}
		
		Public Function getCameraRightLimit:Int()
			Return proposeRightCameraLimit
		}
		
		Public Function isCameraStop:Bool()
			
			If (focusObj = Null Or cameraLocked) Then
				Return True
			EndIf
			
			If (cameraActionX = 0 And cameraActionY = 0) Then
				Return True
			EndIf
			
			Return False
		}
		
		Public Function getCamera:Coordinate()
			Return camera
		}
		
		Public Function setFocusObj:Void(obj:Focusable)
			
			If (focusObj <> obj) Then
				cameraActionX = LOAD_OPEN_FILE
				cameraActionY = LOAD_OPEN_FILE
			EndIf
			
			focusObj = obj
			lockCamera(False)
		}
		
		Public Function focusQuickLocation:Void()
			cameraActionX = 0
			cameraActionY = 0
			
			If (focusObj <> Null) Then
				camera.x = focusObj.getFocusX() - (CAMERA_WIDTH Shr 1)
				camera.y = focusObj.getFocusY() - (CAMERA_HEIGHT Shr 1)
			EndIf
			
			cameraLogic()
		}
		
		Public Function setCameraMoving:Void()
			cameraActionX = LOAD_OPEN_FILE
			cameraActionY = LOAD_OPEN_FILE
			cameraLogic()
		}
		
		Public Function lockCamera:Void(lock:Bool)
			cameraLocked = lock
			
			If (Not lock) Then
				cameraUpDownLocked = False
			EndIf
			
		}
		
		Public Function lockUpDownCamera:Void(lock:Bool)
			cameraUpDownLocked = lock
		}
		
		Public Function loadMapStep:Bool(stageId:Int, stageName:String)
			Int imageNum
			Select (loadStep)
				Case 0
					try {
						stage_id = stageId
						
						If (stageId = 0 Or stageId = LOAD_OPEN_FILE Or stageId = LOAD_FRONT Or stageId = LOAD_BACK Or stageId = SHAKE_RANGE Or stageId = 7 Or stageId = 8 Or stageId = 9 Or stageId = 10 Or stageId = 11) Then
							stageFlag = True
						Else
							stageFlag = False
							image = MFImage.createImage("/map/stage" + stageName + ".png")
						EndIf
						
						If (Not stageFlag) Then
							IMAGE_TILE_WIDTH = MyAPI.zoomIn(image.getWidth() / TILE_WIDTH)
							break
						EndIf
						
						imageNum = 0
						Select (stageId)
							Case 0
							Case LOAD_OPEN_FILE
							Case LOAD_FRONT
							Case LOAD_BACK
							Case SSdef.SSOBJ_CHECKPT
								imageNum = 8
								break
							Case SHAKE_RANGE
							Case SSdef.SSOBJ_BNRD_ID
								imageNum = COLOR_SPACE
								break
							Case SpecialObject.COLLISION_RANGE_Z
							Case SSdef.SSOBJ_BOMB_ID
								imageNum = LOAD_FRONT
								break
							Case SSdef.SSOBJ_GOAL
								imageNum = TILE_WIDTH
								break
						End Select
						tileimage = New MFImage[imageNum]
						
						If (stageId = 0 Or stageId = LOAD_OPEN_FILE Or stageId = LOAD_FRONT Or stageId = LOAD_BACK Or stageId = 10 Or stageId = 11) Then
							For (stageId = 0; stageId < imageNum; stageId += 1)
								tileimage[stageId] = MFImage.createImage("/map/stage" + stageName + "/#" + (stageId + LOAD_OPEN_FILE) + ".png")
							Next
						Else
							tileimage[0] = MFImage.createImage("/map/stage" + stageName + "/#1.png")
							For (stageId = LOAD_OPEN_FILE; stageId < imageNum; stageId += 1)
								tileimage[stageId] = MFImage.createPaletteImage("/map/stage" + stageName + "/#" + (stageId + LOAD_OPEN_FILE) + ".pal")
							Next
						EndIf
						
						IMAGE_TILE_WIDTH = MyAPI.zoomIn(tileimage[Null].getWidth() / TILE_WIDTH)
						break
					} catch (Int stageId2) {
						stageId2.printStackTrace()
						break
					}
					break
				Case LOAD_OPEN_FILE
					is = MFDevice.getResourceAsStream("/map/" + stageName + MAP_EXTEND_NAME)
					ds = New DataInputStream(is)
					break
				Case LOAD_OVERALL
					try {
						mapWidth = ds.readByte()
						mapHeight = ds.readByte()
						
						If (mapWidth < 0) Then
							mapWidth += 256
						EndIf
						
						If (mapHeight < 0) Then
							mapHeight += 256
						EndIf
						
						mapFront = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{mapWidth, mapHeight})
						mapBack = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{mapWidth, mapHeight})
						break
					} catch (Exception e) {
						break
					}
				Case LOAD_MODEL
					try {
						imageNum = ds.readShort()
						ds.readShort()
						mapModel = (Short[][][]) Array.newInstance(Short.TYPE, New Int[]{imageNum, SHAKE_RANGE, SHAKE_RANGE})
						For (Int n = 0; n < imageNum; n += 1)
							For (stageId2 = 0; stageId2 < SHAKE_RANGE; stageId2 += 1)
								For (stageName = Null; stageName < SHAKE_RANGE; stageName += 1)
									mapModel[n][stageId2][stageName] = ds.readShort()
								Next
							Next
						Next
						break
					} catch (Exception e2) {
						e2.printStackTrace()
						break
					}
				Case LOAD_FRONT
					stageId2 = 0
					While (stageId2 < mapWidth) {
						try {
							For (stageName = Null; stageName < mapHeight; stageName += 1)
								mapFront[stageId2][stageName] = ds.readShort()
							Next
							stageId2 += 1
						} catch (Exception e3) {
							break
						}
					}
					break
				Case LOAD_BACK
					stageId2 = 0
					While (stageId2 < mapWidth) {
						try {
							For (stageName = Null; stageName < mapHeight; stageName += 1)
								mapBack[stageId2][stageName] = ds.readShort()
							Next
							stageId2 += 1
						} catch (Exception e4) {
							break
						}
					}
					
					If (ds <> 0) Then
						ds.close()
						break
					EndIf
					
					break
				Case SHAKE_RANGE
					proposeLeftCameraLimit = 0
					actualLeftCameraLimit = 0
					proposeUpCameraLimit = 0
					actualUpCameraLimit = 0
					proposeRightCameraLimit = getPixelWidth()
					actualRightCameraLimit = getPixelWidth()
					proposeDownCameraLimit = getPixelHeight()
					actualDownCameraLimit = getPixelHeight()
					loadStep = 0
					mapOffsetX = 0
					shakeCount = 0
					brokePointY = 0
					brokeOffsetY = 0
					setMapLoop(mapWidth - LOAD_FRONT, mapWidth)
					Select (StageManager.getCurrentZoneId())
						Case SpecialObject.COLLISION_RANGE_Z
							setCameraRightLimit(WIND_LOOP_WIDTH)
							setMapLoop(mapWidth - 28, mapWidth)
							calCameraImmidiately()
							break
					End Select
					Select (StageManager.getStageID())
						Case SSdef.SSOBJ_CHECKPT
							setCameraRightLimit(getPixelWidth() - LOAD_OPEN_FILE)
							break
					End Select
					Return True
			End Select
			
			If (True) Then
				loadStep += 1
			EndIf
			
			Return False
		}
		
		Public Function closeMap:Void()
			image = Null
			
			If (tileimage <> Null) Then
				For (Int i = 0; i < tileimage.Length; i += 1)
					tileimage[i] = Null
				Next
			EndIf
			
			tileimage = Null
			mapModel = Null
			mapFront = Null
			mapBack = Null
			windImage = Null
			windDrawer = Null
		}
		
		Public Function drawBack:Void(g:MFGraphics)
			BackGroundManager.drawBackGround(g)
			drawMap(g, mapBack)
		}
		
		Public Function drawFrontNatural:Void(g:MFGraphics)
			BackGroundManager.drawFrontNatural(g)
		}
		
		Private Function drawWind:Void(g:MFGraphics)
			
			If (windImage = Null) Then
				windImage = MFImage.createImage("/animation/bg_cloud_" + StageManager.getCurrentZoneId() + ".png")
				windDrawer = New Animation(windImage, "/animation/bg_cloud").getDrawer()
			EndIf
			
			If (windImage <> Null And windDrawer <> Null) Then
				Int offsetX = (camera.x / 8) Mod WIND_LOOP_WIDTH
				For (Int i = -1; i < 0; i += 1)
					For (Int j = 0; j < WIND_POSITION.Length; j += 1)
						
						If ((WIND_POSITION[j][0] - offsetX) + (i * WIND_LOOP_WIDTH) >= (-(SCREEN_WIDTH Shr 1))) Then
							If ((WIND_POSITION[j][0] - offsetX) + (i * WIND_LOOP_WIDTH) > SCREEN_WIDTH) Then
								break
							EndIf
							
							windDrawer.setActionId(WIND_POSITION[j][LOAD_OVERALL])
							windDrawer.draw(g, (WIND_POSITION[j][0] - offsetX) + (i * WIND_LOOP_WIDTH), WIND_POSITION[j][LOAD_OPEN_FILE])
						EndIf
						
					Next
				Next
			EndIf
			
		}
		
		Private Function fillChangeColorRect:Void(g:MFGraphics, x:Int, y:Int, w:Int, h:Int, colorStart:Int, colorEnd:Int, coorSpace:Int)
			y = ((h + coorSpace) - LOAD_OPEN_FILE) / coorSpace
			For (Int i = 0; i < y; i += 1)
				h = ((((((65280 & colorEnd) Shr 8) * i) + (((65280 & colorStart) Shr 8) * (y - i))) / y) Shl 8) & 65280
				x = ((((((colorEnd & 255) Shr 0) * i) + (((colorStart & 255) Shr 0) * (y - i))) / y) Shl 0) & 255
				g.setColor(x | (h | (((((((16711680 & colorEnd) Shr TILE_WIDTH) * i) + (((16711680 & colorStart) Shr TILE_WIDTH) * (y - i))) / y) Shl TILE_WIDTH) & 16711680)))
				MyAPI.fillRect(g, 0, coorSpace * i, w, coorSpace)
			Next
		}
		
		Public Function drawFront:Void(g:MFGraphics)
			drawMap(g, mapFront)
		}
		
		Public Function drawMapFrame:Void(g:MFGraphics)
			
			If (CAMERA_OFFSET_X > 0 Or CAMERA_OFFSET_Y > 0) Then
				If (CAMERA_OFFSET_Y > 0) Then
					g.setColor(255)
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, CAMERA_OFFSET_Y)
					MyAPI.fillRect(g, 0, SCREEN_HEIGHT - CAMERA_OFFSET_Y, SCREEN_WIDTH, CAMERA_OFFSET_Y)
				EndIf
				
				If (CAMERA_OFFSET_X > 0) Then
					g.setColor(255)
					MyAPI.fillRect(g, 0, CAMERA_OFFSET_Y + 0, CAMERA_OFFSET_X, SCREEN_HEIGHT - (CAMERA_OFFSET_Y Shl LOAD_OPEN_FILE))
					MyAPI.fillRect(g, SCREEN_WIDTH - CAMERA_OFFSET_X, CAMERA_OFFSET_Y + 0, CAMERA_OFFSET_X, SCREEN_HEIGHT - (CAMERA_OFFSET_Y Shl LOAD_OPEN_FILE))
				EndIf
			EndIf
			
		}
		
		Private Function drawMap:Void(g:MFGraphics, mapArray:Short[][])
			Int startY = (camera.y + CAMERA_OFFSET_Y) / TILE_WIDTH
			Int endX = (((((camera.x + CAMERA_WIDTH) + TILE_WIDTH) - LOAD_OPEN_FILE) + CAMERA_OFFSET_X) - mapOffsetX) / TILE_WIDTH
			Int endY = ((((camera.y + CAMERA_HEIGHT) + TILE_WIDTH) - LOAD_OPEN_FILE) + CAMERA_OFFSET_Y) / TILE_WIDTH
			Int preCheckModelX = -1
			Int x = ((camera.x + CAMERA_OFFSET_X) - mapOffsetX) / TILE_WIDTH
			While (x < endX) {
				Int modelX = x / SHAKE_RANGE
				Int my
				Int y
				Int tileId
				Bool flipX
				
				If (modelX <> preCheckModelX) Then
					preCheckModelX = LOAD_OPEN_FILE
					For (my = startY / SHAKE_RANGE; my < ((endY + SHAKE_RANGE) - LOAD_OPEN_FILE) / SHAKE_RANGE; my += 1)
						
						If (getModelIdByIndex(mapArray, modelX, my) <> 0) Then
							preCheckModelX = 0
							break
						EndIf
						
					Next
					my = x / SHAKE_RANGE
					
					If (preCheckModelX <> 0) Then
						modelX = ((modelX + LOAD_OPEN_FILE) * SHAKE_RANGE) - LOAD_OPEN_FILE
						preCheckModelX = my
					EndIf
					
					y = startY
					While (y < endY) {
						
						If (getModelId(mapArray, x, y) <> 0) Then
							preCheckModelX = (((y / SHAKE_RANGE) + LOAD_OPEN_FILE) * SHAKE_RANGE) - LOAD_OPEN_FILE
						Else
							tileId = getTileId(mapArray, x, y)
							flipX = (MFGamePad.KEY_NUM_9 & tileId) = 0 ? True : False
							
							If ((tileId & MFGamePad.KEY_NUM_8) = 0 ? True : False) Then
								modelX = 0
							Else
								modelX = 0 | LOAD_OVERALL
							EndIf
							
							If (flipX) Then
								preCheckModelX = modelX
							Else
								preCheckModelX = modelX | LOAD_OPEN_FILE
							EndIf
							
							drawTile(g, tileId & 16383, x, y, preCheckModelX)
							preCheckModelX = y
						EndIf
						
						y = preCheckModelX + LOAD_OPEN_FILE
					}
					modelX = x
					preCheckModelX = my
				Else
					my = preCheckModelX
					y = startY
					While (y < endY) {
						
						If (getModelId(mapArray, x, y) <> 0) Then
							tileId = getTileId(mapArray, x, y)
							
							If ((MFGamePad.KEY_NUM_9 & tileId) = 0) Then
							EndIf
							
							If ((tileId & MFGamePad.KEY_NUM_8) = 0) Then
							EndIf
							
							If ((tileId & MFGamePad.KEY_NUM_8) = 0 ? True : False) Then
								modelX = 0
							Else
								modelX = 0 | LOAD_OVERALL
							EndIf
							
							If (flipX) Then
								preCheckModelX = modelX
							Else
								preCheckModelX = modelX | LOAD_OPEN_FILE
							EndIf
							
							drawTile(g, tileId & 16383, x, y, preCheckModelX)
							preCheckModelX = y
						Else
							preCheckModelX = (((y / SHAKE_RANGE) + LOAD_OPEN_FILE) * SHAKE_RANGE) - LOAD_OPEN_FILE
						EndIf
						
						y = preCheckModelX + LOAD_OPEN_FILE
					}
					modelX = x
					preCheckModelX = my
				EndIf
				
				x = modelX + LOAD_OPEN_FILE
			}
		}
		
		Private Function getTileId:Int(mapArray:Short[][], x:Int, y:Int)
			Return mapModel[getModelId(mapArray, x, y)][x Mod SHAKE_RANGE][y Mod SHAKE_RANGE]
		}
		
		Private Function getModelId:Int(mapArray:Short[][], x:Int, y:Int)
			Return getModelIdByIndex(mapArray, x / SHAKE_RANGE, y / SHAKE_RANGE)
		}
		
		Private Function getModelIdByIndex:Int(mapArray:Short[][], x:Int, y:Int)
			x = getConvertX(x)
			
			If (y >= mapArray[0].Length) Then
				Return 0
			EndIf
			
			Return mapArray[x][y]
		}
		
		Public Function getConvertX:Int(x:Int)
			
			If (x < mapLoopRight) Then
				Return x
			EndIf
			
			Int duration = mapLoopRight - mapLoopLeft
			Select (StageManager.getCurrentZoneId())
				Case SpecialObject.COLLISION_RANGE_Z
					Return mapLoopLeft + ((x - mapLoopRight) Mod duration)
				Default
					Return mapLoopLeft + ((x - mapLoopRight) Mod duration)
			End Select
		}
		
		Private Function drawTile:Void(g:MFGraphics, sy:Int, x:Int, y:Int, trans:Int)
			
			If (sy <> 0) Then
				Int sx = sy Mod IMAGE_TILE_WIDTH
				sy /= IMAGE_TILE_WIDTH
				
				If (stageFlag) Then
					mappaintframe = gameFrame
					Select (stage_id)
						Case 0
						Case LOAD_OPEN_FILE
						Case SpecialObject.COLLISION_RANGE_Z
						Case SSdef.SSOBJ_BOMB_ID
						Case SSdef.SSOBJ_CHECKPT
							mappaintframe Mod= tileimage.Length
							break
						Case LOAD_FRONT
						Case LOAD_BACK
						Case SSdef.SSOBJ_GOAL
							mappaintframe = (gameFrame Mod (tileimage.Length * LOAD_OVERALL)) / 2
							break
					End Select
					
					If (stage_id = SHAKE_RANGE Or stage_id = 7) Then
						mappaintframe = zone4TileLoopID[gameFrame Mod zone4TileLoopID.Length]
					EndIf
					
					MyAPI.drawImage(g, tileimage[mappaintframe], sx * TILE_WIDTH, sy * TILE_WIDTH, TILE_WIDTH, TILE_WIDTH, trans, ((x * TILE_WIDTH) - camera.x) + mapOffsetX, ((y * TILE_WIDTH) - camera.y) + (y >= brokePointY ? brokeOffsetY : 0), COLOR_SPACE)
					Return
				EndIf
				
				MyAPI.drawImage(g, image, sx * TILE_WIDTH, sy * TILE_WIDTH, TILE_WIDTH, TILE_WIDTH, trans, ((x * TILE_WIDTH) - camera.x) + mapOffsetX, ((y * TILE_WIDTH) - camera.y) + (y >= brokePointY ? brokeOffsetY : 0), COLOR_SPACE)
			EndIf
			
		}
		
		Public Function getPixelWidth:Int()
			Return (mapWidth * TILE_WIDTH) * SHAKE_RANGE
		}
		
		Public Function getPixelHeight:Int()
			Return (mapHeight * TILE_WIDTH) * SHAKE_RANGE
		}
		
		Public Function getMapWidth:Int()
			Return mapWidth
		}
		
		Public Function getMapHeight:Int()
			Return mapHeight
		}
		
		Public Function setShake:Void(count:Int)
			setShake(count, SHAKE_RANGE)
		}
		
		Public Function setShake:Void(count:Int, power:Int)
			
			If (count > 0) Then
				shakeCount = count
				shakeMaxCount = count
				shakePowerY = power
			EndIf
			
		}
		
		Public Function setShakeX:Void(power:Int)
			shakePowerX = power
		}
		
		Public Function setMapBrokeParam:Void(pointY:Int, offsetY:Int)
			brokePointY = pointY / 2
			brokeOffsetY = offsetY
		}
		
		Public Function releaseCamera:Void()
			proposeLeftCameraLimit = 0
			proposeRightCameraLimit = getPixelWidth()
			proposeUpCameraLimit = 0
			proposeDownCameraLimit = getPixelHeight()
			calCameraImmidiately()
		}
		
		Public Function releaseCamera2:Void()
			proposeLeftCameraLimit = 0
			proposeRightCameraLimit = getPixelWidth()
			proposeUpCameraLimit = 0
			proposeDownCameraLimit = 2372
			calCameraImmidiately()
		}
		
		Public Function setMapLoop:Void(loopLeft:Int, loopRight:Int)
			mapLoopLeft = loopLeft
			mapLoopRight = loopRight
		}
End