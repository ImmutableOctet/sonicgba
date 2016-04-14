Strict

Public

#Rem
	TODO:
		* Replace 'Short' arrays with 'DataBuffers' to reduce the memory footprint.
#End

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
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import brl.databuffer
	Import brl.stream
	
	Import regal.typetool
	Import regal.sizeof
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
		
		Const LOAD_MAP_IMAGE:Int = 0
		Const LOAD_OPEN_FILE:Int = 1
		Const LOAD_OVERALL:Int = 2
		Const LOAD_MODEL:Int = 3
		Const LOAD_FRONT:Int = 4
		Const LOAD_BACK:Int = 5
		Const LOAD_CAMERA_RESET:Int = 6
		
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
	Protected
		' Constant variable(s):
		Const MODE_CHUNK_SIZE:= ((MODEL_WIDTH * MODEL_HEIGHT) * SizeOf_Short)
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
		
		Global mapBack:DataBuffer ' Short[][]
		Global mapFront:DataBuffer ' Short[][]
		
		' A collection of tile-maps.
		Global mapModel:DataBuffer[] ' Short[][][]
		
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
		
		' Extensions:
		Function AsMapCoord:Int(x:Int, y:Int)
			Return ((y * MODEL_HEIGHT) + x) ' x Mod MODEL_WIDTH
		End
		
		Function getTileAt:Int(data:DataBuffer, x:Int, y:Int)
			Return data.PeekShort(AsMapCoord(x, y))
		End
		
		Function cameraLogic:Void()
			If (focusObj <> Null And Not cameraLocked) Then
				If (getPixelWidth() < CAMERA_WIDTH) Then
					camera.x = ((CAMERA_WIDTH - getPixelWidth()) / 2)
				Else
					cameraActionX()
					
					If (actualLeftCameraLimit > proposeLeftCameraLimit) Then
						actualLeftCameraLimit -= CAMERA_SPEED
						
						If (actualLeftCameraLimit < proposeLeftCameraLimit) Then
							actualLeftCameraLimit = proposeLeftCameraLimit
						EndIf
						
					ElseIf (actualLeftCameraLimit < proposeLeftCameraLimit) Then
						actualLeftCameraLimit += CAMERA_SPEED
						
						If (actualLeftCameraLimit > proposeLeftCameraLimit) Then
							actualLeftCameraLimit = proposeLeftCameraLimit
						EndIf
					EndIf
					
					If (actualRightCameraLimit < proposeRightCameraLimit) Then
						actualRightCameraLimit += CAMERA_SPEED
						
						If (actualRightCameraLimit > proposeRightCameraLimit) Then
							actualRightCameraLimit = proposeRightCameraLimit
						EndIf
						
					ElseIf (actualRightCameraLimit > proposeRightCameraLimit) Then
						actualRightCameraLimit -= CAMERA_SPEED
						
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
							actualDownCameraLimit -= CAMERA_SPEED
							
							If (actualDownCameraLimit < proposeDownCameraLimit) Then
								actualDownCameraLimit = proposeDownCameraLimit
							EndIf
							
						ElseIf (actualDownCameraLimit < proposeDownCameraLimit) Then
							actualDownCameraLimit += CAMERA_SPEED
							
							If (actualDownCameraLimit > proposeDownCameraLimit) Then
								actualDownCameraLimit = proposeDownCameraLimit
							EndIf
						EndIf
						
						If (actualUpCameraLimit < proposeUpCameraLimit) Then
							actualUpCameraLimit += CAMERA_SPEED
							
							If (actualUpCameraLimit > proposeUpCameraLimit) Then
								actualUpCameraLimit = proposeUpCameraLimit
							EndIf
							
						ElseIf (actualUpCameraLimit > proposeUpCameraLimit) Then
							actualUpCameraLimit -= CAMERA_SPEED
							
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
		
		Function getPixelWidth:Int()
			Return ((mapWidth * TILE_WIDTH) * MODEL_WIDTH)
		End
		
		Function getPixelHeight:Int()
			Return ((mapHeight * TILE_WIDTH) * MODEL_HEIGHT)
		End
		
		Function getMapWidth:Int()
			Return mapWidth
		End
		
		Function getMapHeight:Int()
			Return mapHeight
		End
		
		Function setShake:Void(count:Int)
			setShake(count, SHAKE_RANGE)
		End
		
		Function setShake:Void(count:Int, power:Int)
			If (count > 0) Then
				shakeCount = count
				shakeMaxCount = count
				
				shakePowerY = power
			EndIf
		End
		
		Function setShakeX:Void(power:Int)
			shakePowerX = power
		End
		
		Function setMapBrokeParam:Void(pointY:Int, offsetY:Int)
			brokePointY = (pointY / 2)
			brokeOffsetY = offsetY
		End
		
		Function releaseCamera:Void()
			proposeLeftCameraLimit = 0
			
			proposeRightCameraLimit = getPixelWidth()
			
			proposeUpCameraLimit = 0
			
			proposeDownCameraLimit = getPixelHeight()
			
			calCameraImmidiately()
		End
		
		Function releaseCamera2:Void()
			proposeLeftCameraLimit = 0
			proposeRightCameraLimit = getPixelWidth()
			proposeUpCameraLimit = 0
			
			' Magic number: 2372
			proposeDownCameraLimit = 2372
			
			calCameraImmidiately()
		End
		
		Function setMapLoop:Void(loopLeft:Int, loopRight:Int)
			mapLoopLeft = loopLeft
			mapLoopRight = loopRight
		End
		
		Function setCameraLeftLimit:Void(limit:Int)
			proposeLeftCameraLimit = limit
			
			If (proposeLeftCameraLimit <= camera.x) Then
				actualLeftCameraLimit = proposeLeftCameraLimit
			Else
				actualLeftCameraLimit = camera.x
			EndIf
		End
		
		Function setCameraRightLimit:Void(limit:Int)
			proposeRightCameraLimit = limit
			
			If (proposeRightCameraLimit >= (camera.x + CAMERA_WIDTH)) Then
				actualRightCameraLimit = proposeRightCameraLimit
			Else
				actualRightCameraLimit = camera.x + CAMERA_WIDTH
			EndIf
		End
		
		Function setCameraDownLimit:Void(limit:Int)
			proposeDownCameraLimit = limit
			
			actualDownCameraLimit = (camera.y + CAMERA_HEIGHT)
		End
		
		Function setCameraUpLimit:Void(limit:Int)
			proposeUpCameraLimit = limit
			
			If (camera.y < proposeUpCameraLimit) Then
				actualUpCameraLimit = camera.y
			Else
				actualUpCameraLimit = proposeUpCameraLimit
			EndIf
		End
		
		Function calCameraImmidiately:Void()
			actualUpCameraLimit = proposeUpCameraLimit
			actualDownCameraLimit = proposeDownCameraLimit
			actualLeftCameraLimit = proposeLeftCameraLimit
			actualRightCameraLimit = proposeRightCameraLimit
		End
		
		Function releaseCameraUpLimit:Void()
			proposeUpCameraLimit = 0
		End
		
		Function releaseCameraLeftLimit:Void(limit:Int)
			proposeLeftCameraLimit = 0
		End
		
		Function releaseCameraRightLimit:Void(limit:Int)
			proposeRightCameraLimit = getPixelWidth()
		End
		
		Function getCameraRightLimit:Int()
			Return proposeRightCameraLimit
		End
		
		Function isCameraStop:Bool()
			If (focusObj = Null Or cameraLocked) Then
				Return True
			EndIf
			
			If (cameraActionX = 0 And cameraActionY = 0) Then
				Return True
			EndIf
			
			Return False
		End
		
		Function getCamera:Coordinate()
			Return camera
		End
		
		Function setFocusObj:Void(obj:Focusable)
			If (focusObj <> obj) Then
				cameraActionX = 1
				cameraActionY = 1
			EndIf
			
			focusObj = obj
			
			lockCamera(False)
		End
		
		Function focusQuickLocation:Void()
			cameraActionX = 0
			cameraActionY = 0
			
			If (focusObj <> Null) Then
				camera.x = focusObj.getFocusX() - (CAMERA_WIDTH / 2) ' Shr 1
				camera.y = focusObj.getFocusY() - (CAMERA_HEIGHT / 2) ' Shr 1
			EndIf
			
			cameraLogic()
		End
		
		Function setCameraMoving:Void()
			cameraActionX = 1
			cameraActionY = 1
			
			cameraLogic()
		End
		
		Function lockCamera:Void(lock:Bool)
			cameraLocked = lock
			
			If (Not lock) Then
				cameraUpDownLocked = False
			EndIf
		End
		
		Function lockUpDownCamera:Void(lock:Bool)
			cameraUpDownLocked = lock
		End
		
		Function loadMapStep:Bool(stageId:Int, stageName:String)
			Local imageNum:Int
			' Local stageId2:Int
			
			Select (loadStep)
				Case LOAD_MAP_IMAGE
					stage_id = stageId
					
					If (stageId = 0 Or stageId = 1 Or stageId = 5 Or stageId = 5 Or stageId = 6 Or stageId = 7 Or stageId = 8 Or stageId = 9 Or stageId = 10 Or stageId = 11) Then
						stageFlag = True
					Else
						stageFlag = False
						
						image = MFImage.createImage("/map/stage" + stageName + ".png")
					EndIf
					
					If (Not stageFlag) Then
						IMAGE_TILE_WIDTH = MyAPI.zoomIn(image.getWidth() / TILE_WIDTH)
					Else
						imageNum = 0
						
						Select (stageId)
							Case 0, 1, 4, 5, 10
								imageNum = 8
							Case 6, 7
								imageNum = 20
							Case 8, 9
								imageNum = 4
							Case 11
								imageNum = 16
						End Select
						
						tileimage = New MFImage[imageNum]
						
						If (stageId = 0 Or stageId = 1 Or stageId = 5 Or stageId = 5 Or stageId = 10 Or stageId = 11) Then
							For stageId = 0 Until imageNum
								tileimage[stageId] = MFImage.createImage("/map/stage" + stageName + "/#" + String(stageId + 1) + ".png")
							Next
						Else
							tileimage[0] = MFImage.createImage("/map/stage" + stageName + "/#1.png")
							
							For stageId = 1 Until imageNum
								tileimage[stageId] = MFImage.createPaletteImage("/map/stage" + stageName + "/#" + String(stageId + 1) + ".pal")
							Next
						EndIf
						
						IMAGE_TILE_WIDTH = MyAPI.zoomIn(tileimage[Null].getWidth() / TILE_WIDTH)
					EndIf
				Case LOAD_OPEN_FILE
					ds = MFDevice.getResourceAsStream("/map/" + stageName + MAP_EXTEND_NAME)
				Case LOAD_OVERALL
					Try
						mapWidth = ds.ReadByte()
						mapHeight = ds.ReadByte()
						
						If (mapWidth < 0) Then
							mapWidth += 256
						EndIf
						
						If (mapHeight < 0) Then
							mapHeight += 256
						EndIf
						
						Local mapSize:= (mapWidth*mapHeight*SizeOf_Short)
						
						mapFront = New DataBuffer(mapSize)
						mapBack = New DataBuffer(mapSize)
					Catch E:StreamError
						' Nothing so far.
					End Try
				Case LOAD_MODEL
					Try
						' Read the number of "chunks":
						imageNum = ds.ReadShort()
						
						' Skip the next two bytes (I'm not sure if this is supposed to be an 'Int' or not):
						'ds.ReadShort()
						ds.Seek(ds.Position+2)
						
						' Allocate an array of "map chunks":
						mapModel = New DataBuffer[imageNum]
						
						' Allocate the "chunks" we need:
						For Local i:= 0 Until imageNum ' mapModel.Length
							' Allocate a "chunk" using the pre-determined size.
							Local chunk:= New DataBuffer(MODE_CHUNK_SIZE)
							
							' Read the "chunk data" (Tile information) from the input-stream.
							ds.ReadAll(chunk, 0, MODE_CHUNK_SIZE) ' chunk.Length
							
							' Store the "chunk" in our container.
							mapModel[i] = chunk
						Next
					Catch E:StreamError
						' Nothing so far.
					End Try
				Case LOAD_FRONT
					Try
						ds.ReadAll(mapFront, 0, mapFront.Length) ' (mapWidth*mapHeight*SizeOf_Short)
					Catch E:StreamError
						' Nothing so far.
					End Try
				Case LOAD_BACK
					Try
						ds.ReadAll(mapBack, 0, mapBack.Length) ' (mapWidth*mapHeight*SizeOf_Short)
					Catch E:StreamError
						' Nothing so far.
					End Try
					
					If (ds <> Null) Then
						ds.Close()
					EndIf
				Case LOAD_CAMERA_RESET
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
					
					setMapLoop((mapWidth - 4), mapWidth)
					
					Select (StageManager.getCurrentZoneId())
						Case 8
							setCameraRightLimit(WIND_LOOP_WIDTH)
							setMapLoop((mapWidth - 28), mapWidth)
							
							calCameraImmidiately()
					End Select
					
					Select (StageManager.getStageID())
						Case 10
							setCameraRightLimit((getPixelWidth() - 1))
					End Select
					
					Return True
			End Select
			
			loadStep += 1
			
			Return False
		End
		
		Function closeMap:Void()
			image = Null
			
			'#Rem
			For Local i:= 0 Until tileimage.Length
				'tileimage[i].Discard()
				
				tileimage[i] = Null
			Next
			'#End
			
			tileimage = []
			
			For Local i:= 0 Until mapModel.Length
				mapModel[i].Discard()
				
				mapModel[i] = Null
			Next
			
			mapModel = []
			
			mapFront.Discard()
			mapBack.Discard()
			
			mapModel = Null
			mapFront = Null
			mapBack = Null
			
			'windImage.Discard()
			
			windImage = Null
			windDrawer = Null
		End
		
		Function drawBack:Void(g:MFGraphics)
			BackGroundManager.drawBackGround(g)
			
			drawMap(g, mapBack)
		End
		
		Function drawFrontNatural:Void(g:MFGraphics)
			BackGroundManager.drawFrontNatural(g)
		End
		
		Function drawFront:Void(g:MFGraphics)
			drawMap(g, mapFront)
		End
		
		Function drawMapFrame:Void(g:MFGraphics)
			If (CAMERA_OFFSET_X > 0 Or CAMERA_OFFSET_Y > 0) Then
				If (CAMERA_OFFSET_Y > 0) Then
					g.setColor(255)
					
					MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, CAMERA_OFFSET_Y)
					MyAPI.fillRect(g, 0, SCREEN_HEIGHT - CAMERA_OFFSET_Y, SCREEN_WIDTH, CAMERA_OFFSET_Y)
				EndIf
				
				If (CAMERA_OFFSET_X > 0) Then
					g.setColor(255)
					
					MyAPI.fillRect(g, 0, CAMERA_OFFSET_Y + 0, CAMERA_OFFSET_X, SCREEN_HEIGHT - (CAMERA_OFFSET_Y * 2)) ' Shl 1
					MyAPI.fillRect(g, SCREEN_WIDTH - CAMERA_OFFSET_X, CAMERA_OFFSET_Y + 0, CAMERA_OFFSET_X, SCREEN_HEIGHT - (CAMERA_OFFSET_Y * 2)) ' Shl 1
				EndIf
			EndIf
		End
		
		Function getConvertX:Int(x:Int)
			If (x < mapLoopRight) Then
				Return x
			EndIf
			
			Local duration:= (mapLoopRight - mapLoopLeft)
			
			Select (StageManager.getCurrentZoneId())
				Case 8
					Return (mapLoopLeft + ((x - mapLoopRight) Mod duration))
				Default
					Return (mapLoopLeft + ((x - mapLoopRight) Mod duration))
			End Select
		End
	Private
		' Functions:
		Function cameraActionX:Void()
			Local desCamX:= (focusObj.getFocusX() - (CAMERA_WIDTH / 2)) - CAMERA_OFFSET_X ' Shr 1
			
			Select (cameraActionX)
				Case 0
					Local preCameraX:= camera.x
					
					camera.x = MyAPI.calNextPosition(Double(camera.x), Double(desCamX), 3, 6, 4.0) ' SHAKE_RANGE
					
					If (Abs(preCameraX - camera.x) > CAMERA_MAX_SPEED_Y) Then
						If (camera.x > preCameraX) Then
							camera.x = preCameraX + CAMERA_MAX_SPEED_Y
						EndIf
						
						If (camera.x < preCameraX) Then
							camera.x = preCameraX - CAMERA_MAX_SPEED_Y
						EndIf
					EndIf
				Case 1
					Local destiny:= Max(desCamX, 0)
					
					Local move:= (((destiny - camera.x) * 100) / CAMERA_SPEED)
					Local coordinate:= camera
					
					Local i:= coordinate.x
					Local i2:= (move / 100)
					Local i3:= PickValue((move = 0), 0, PickValue((move > 0), CAMERA_SPEED, -CAMERA_SPEED))
					
					coordinate.x = i + (i2 + i3)
					
					If ((((destiny * 100) - (camera.x * 100)) * move) <= 0) Then
						cameraActionX = 0
					EndIf
				Case 2
					camera.x = desCamX
					
					cameraActionX = 0
				Default
					' Nothing so far.
			End Select
		End
		
		Function cameraActionY:Void()
			Local desCamY:= (focusObj.getFocusY() - (CAMERA_HEIGHT / 2)) - CAMERA_OFFSET_Y ' Shr 1
			
			Select (cameraActionY)
				Case 0
					Local preCameraY:= camera.y
					
					camera.y = MyAPI.calNextPosition(Double(camera.y), Double(desCamY), 3, 6, 4.0) ' SHAKE_RANGE
					
					If (Abs(preCameraY - camera.y) > CAMERA_MAX_SPEED_Y) Then
						If (camera.y > preCameraY) Then
							camera.y = (preCameraY + CAMERA_MAX_SPEED_Y)
						EndIf
						
						If (camera.y < preCameraY) Then
							camera.y = (preCameraY - CAMERA_MAX_SPEED_Y)
						EndIf
					EndIf
				Case 1
					Local destiny:= PickValue((focusObj.getFocusY() - (CAMERA_HEIGHT / 2) < 0), 0, (focusObj.getFocusY() - (CAMERA_HEIGHT / 2))) ' Shr 1
					
					Local move:= ((destiny - camera.y) * 100) / CAMERA_SPEED
					Local coordinate:= camera
					
					Local i:= coordinate.y
					Local i2:= (move / 100)
					Local i3:= PickValue((move = 0), 0, PickValue((move > 0), CAMERA_SPEED, -CAMERA_SPEED))
					
					coordinate.y = i + (i2 + i3)
					
					If ((((destiny * 100) - (camera.y * 100)) * move) <= 0) Then
						cameraActionY = 0
					EndIf
				Case 2
					camera.y = desCamY
					
					cameraActionY = 0
				Default
					' Nothing so far.
			End Select
		End
		
		Function drawWind:Void(g:MFGraphics)
			If (windImage = Null) Then
				windImage = MFImage.createImage("/animation/bg_cloud_" + StageManager.getCurrentZoneId() + ".png")
				
				windDrawer = New Animation(windImage, "/animation/bg_cloud").getDrawer()
			EndIf
			
			If (windImage <> Null And windDrawer <> Null) Then
				Local offsetX:= ((camera.x / 8) Mod WIND_LOOP_WIDTH)
				
				For Local i:= -1 Until 0
					For Local j:= 0 Until WIND_POSITION.Length
						Local wind:= WIND_POSITION[j]
						
						Local negLoopWidth:= (i * WIND_LOOP_WIDTH)
						
						If ((wind[0] - offsetX) + negLoopWidth >= (-(SCREEN_WIDTH / 2))) Then ' Shr 1
							If ((wind[0] - offsetX) + negLoopWidth > SCREEN_WIDTH) Then
								Exit
							EndIf
							
							windDrawer.setActionId(wind[2])
							windDrawer.draw(g, (wind[0] - offsetX) + negLoopWidth, wind[1])
						EndIf
					Next
				Next
			EndIf
		End
		
		Function fillChangeColorRect:Void(g:MFGraphics, x:Int, y:Int, w:Int, h:Int, colorStart:Int, colorEnd:Int, coorSpace:Int)
			y = ((h + coorSpace) - 1) / coorSpace
			
			For Local i:= 0 Until y
				h = (((((((65280 & colorEnd) Shr 8) * i) + (((65280 & colorStart) Shr 8) * (y - i))) / y) Shl 8) & 65280)
				
				x = (((((((colorEnd & 255) Shr 0) * i) + (((colorStart & 255) Shr 0) * (y - i))) / y) Shl 0) & 255)
				
				g.setColor(x | (h | (((((((16711680 & colorEnd) Shr 16) * i) + (((16711680 & colorStart) Shr 16) * (y - i))) / y) Shl 16) & 16711680)))
				
				MyAPI.fillRect(g, 0, coorSpace * i, w, coorSpace)
			Next
		End
		
		Function drawMap:Void(g:MFGraphics, mapArray:DataBuffer)
			Local startY:= (camera.y + CAMERA_OFFSET_Y) / TILE_HEIGHT
			
			Local endX:= (((((camera.x + CAMERA_WIDTH) + TILE_WIDTH) - 1) + CAMERA_OFFSET_X) - mapOffsetX) / TILE_WIDTH
			Local endY:= ((((camera.y + CAMERA_HEIGHT) + TILE_HEIGHT) - 1) + CAMERA_OFFSET_Y) / TILE_HEIGHT
			
			Local preCheckModelX:= -1
			
			Local x:= (((camera.x + CAMERA_OFFSET_X) - mapOffsetX) / TILE_WIDTH)
			
			While (x < endX)
				Local modelX:= (x / MODEL_WIDTH)
				
				Local my:Int
				Local y:Int
				
				Local tileId:Int
				
				Local flipX:Bool
				
				If (modelX <> preCheckModelX) Then
					preCheckModelX = 1
					
					For my = (startY / MODEL_HEIGHT) Until (((endY + MODEL_HEIGHT) - 1) / MODEL_HEIGHT)
						If (getModelIdByIndex(mapArray, modelX, my) <> 0) Then
							preCheckModelX = 0
							
							Exit
						EndIf
					Next
					
					my = (x / MODEL_HEIGHT) ' MODEL_WIDTH
					
					If (preCheckModelX <> 0) Then
						modelX = ((modelX + 1) * MODEL_WIDTH) - 1
						
						preCheckModelX = my
					EndIf
					
					y = startY
					
					While (y < endY)
						If (getModelId(mapArray, x, y) <> 0) Then
							preCheckModelX = (((y / MODEL_HEIGHT) + 1) * MODEL_HEIGHT) - 1
						Else
							tileId = getTileId(mapArray, x, y)
							
							flipX = ((MFGamePad.KEY_NUM_9 & tileId) = 0)
							
							If ((tileId & MFGamePad.KEY_NUM_8) = 0) Then
								modelX = 0
							Else
								modelX = 2 ' (0 | 2)
							EndIf
							
							If (flipX) Then
								preCheckModelX = modelX
							Else
								preCheckModelX = (modelX | 1)
							EndIf
							
							drawTile(g, (tileId & 16383), x, y, preCheckModelX)
							
							preCheckModelX = y
						EndIf
						
						y = (preCheckModelX + 1)
					Wend
					
					modelX = x
					preCheckModelX = my
				Else
					my = preCheckModelX
					y = startY
					
					While (y < endY)
						If (getModelId(mapArray, x, y) <> 0) Then
							tileId = getTileId(mapArray, x, y)
							
							#Rem
								If ((MFGamePad.KEY_NUM_9 & tileId) = 0) Then
									' Nothing so far.
								EndIf
								
								If ((tileId & MFGamePad.KEY_NUM_8) = 0) Then
									' Nothing so far.
								EndIf
							#End
							
							If ((tileId & MFGamePad.KEY_NUM_8) = 0) Then
								modelX = 0
							Else
								modelX = 2 ' (0 | 2)
							EndIf
							
							If (flipX) Then
								preCheckModelX = modelX
							Else
								preCheckModelX = (modelX | 1)
							EndIf
							
							drawTile(g, (tileId & 16383), x, y, preCheckModelX)
							
							preCheckModelX = y
						Else
							preCheckModelX = (((y / MODEL_HEIGHT) + 1) * MODEL_HEIGHT) - 1
						EndIf
						
						y = (preCheckModelX + 1)
					Wend
					
					modelX = x
					preCheckModelX = my
				EndIf
				
				x = modelX + 1
			Wend
		End
		
		Function getTileId:Int(mapArray:DataBuffer, x:Int, y:Int)
			Local chunk:= mapModel[getModelId(mapArray, x, y)]
			
			Return chunk.PeekShort(AsMapCoord(x Mod MODEL_WIDTH, y Mod MODEL_HEIGHT))
		End
		
		Function getModelId:Int(mapArray:DataBuffer, x:Int, y:Int)
			Return getModelIdByIndex(mapArray, (x / MODEL_WIDTH), (y / MODEL_HEIGHT))
		End
		
		Function getModelIdByIndex:Int(mapArray:DataBuffer, x:Int, y:Int)
			x = getConvertX(x)
			
			If (y >= MODEL_HEIGHT) Then
				Return 0
			EndIf
			
			Return getTileAt(mapArray, x, y)
		End
		
		Function drawTile:Void(g:MFGraphics, sy:Int, x:Int, y:Int, trans:Int)
			If (sy <> 0) Then
				Local sx:= (sy Mod IMAGE_TILE_WIDTH)
				
				sy /= IMAGE_TILE_WIDTH
				
				If (stageFlag) Then
					mappaintframe = gameFrame
					
					Select (stage_id)
						Case 0, 1, 8, 9, 10
							mappaintframe Mod= tileimage.Length
						Case 4, 5, 11
							mappaintframe = (gameFrame Mod (tileimage.Length * 2)) / 2
					End Select
					
					If (stage_id = 6 Or stage_id = 7) Then
						mappaintframe = zone4TileLoopID[gameFrame Mod zone4TileLoopID.Length]
					EndIf
					
					MyAPI.drawImage(g, tileimage[mappaintframe], (sx * TILE_WIDTH), (sy * TILE_HEIGHT), TILE_WIDTH, TILE_HEIGHT, trans, ((x * TILE_WIDTH) - camera.x) + mapOffsetX, ((y * TILE_HEIGHT) - camera.y) + PickValue((y >= brokePointY), brokeOffsetY, 0), COLOR_SPACE)
					
					Return
				EndIf
				
				MyAPI.drawImage(g, image, (sx * TILE_WIDTH), (sy * TILE_HEIGHT), TILE_WIDTH, TILE_HEIGHT, trans, ((x * TILE_WIDTH) - camera.x) + mapOffsetX, ((y * TILE_HEIGHT) - camera.y) + PickValue((y >= brokePointY), brokeOffsetY, 0), COLOR_SPACE)
			EndIf
		End
End