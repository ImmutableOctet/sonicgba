Strict

Public

' Friends:
Friend application

' Imports:
Private
	Import mflib.bpdef
	
	#Rem
		Import android.content.context
		Import android.content.pm.packagemanager.namenotfoundexception
		Import android.content.res.assetmanager
		Import android.database.cursor
		Import android.graphics.rect
		Import android.net.uri
		Import android.os.vibrator
		Import android.telephony.telephonymanager
	#End
	
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.mfgamestate
	Import com.sega.mobile.framework.mfmain
	
	'Import com.sega.mobile.framework.android.canvas
	Import com.sega.mobile.framework.android.graphics
	
	Import mojo.app
	Import mojo.input
	
	Import brl.databuffer
	Import brl.stream
	
	Import brl.datastream
	Import brl.filestream
	
	Import monkey.map
	Import monkey.stack
	
	Import regal.typetool
	Import regal.ioutil.publicdatastream
Public

' Classes:
Class MFDevice Final
	Public
		' Global variable(s):
		Global bufferWidth:Int
		Global bufferHeight:Int
		
		Global canvasWidth:Int
		Global canvasHeight:Int
		
		Global clearBuffer:Bool = True
		
		'Global mainThread:Thread
		
		Global screenHeight:Int
		Global screenWidth:Int
		
		Global horizontalOffset:Int
		Global verticvalOffset:Int
		
		Global enableTrackBall:Bool = True ' False
		Global shieldInput:Bool = True
	Private
		' Constant variable(s):
		Const VERSION_INFO:String = "104_RELEASE" ' "100_RELEASE" ' "DEBUG"
		Const MAX_LAYER:Int = 1
		Const PER_VIBRATION_TIME:Int = 500
		Const RECORD_NAME:String = "rms"
		
		Global NULL_RECORD:DataBuffer = New DataBuffer(4) ' Const
		
		' Global variable(s):
		
		' Input related:
		Global deviceKeyValue:Int = 0
		
		Global enableCustomBack:Bool = False
		Global enableVolumeKey:Bool = True ' False
		
		Global componentVector:Stack<MFComponent> ' Vector
		
		Global currentState:MFGameState
		Global currentSystemTime:Long ' Int
		Global drawRect:Rect
		
		Global exitFlag:Bool
		Global graphics:MFGraphics
		
		Global inSuspendFlag:Bool
		Global inVibrationFlag:Bool
		'Global interruptConfirm:MFTouchKey
		Global interruptPauseFlag:Bool
		Global lastSystemTime:Long
		Global logicTrace:Bool
		
		#Rem
			Global vibraionFlag:Bool
			Global vibrateStartTime:Long
			Global vibrateTime:Int
			Global vibrator:Vibrator
		#End
		
		'Global webPageUrl:String
		
		'Global methodCallTrace:Bool
		
		Global nextState:MFGameState
		Global records:StringMap<DataBuffer>
		Global responseInterrupt:Bool
		
		' Graphis:
		'Global bufferImage:Image ' <-- Used to be used to represent the screen.
		
		Global postLayerGraphics:MFGraphics[] = New MFGraphics[MAX_LAYER]
		Global postLayerImage:Image[] = New Image[MAX_LAYER]
		Global preLayerGraphics:MFGraphics[] = New MFGraphics[MAX_LAYER]
		Global preLayerImage:Image[] = New Image[MAX_LAYER]
	Protected
		' Global variable(s):
		'Global mainRunnable:Runnable = New C00011()
		'Global mainCanvas:MyGameCanvas = New MyGameCanvas(MFMain.getInstance())
		
		' Graphics:
		Global preScaleShift:Int = 0
		
		Global preScaleZoomInFlag:Bool = False
		Global preScaleZoomOutFlag:Bool = False
	Public
		' Functions:
		
		' Extensions:
		Function deviceDraw:Void(g:Graphics)
			For Local i:= preLayerImage.Length Until 0 Step -1 ' MAX_LAYER
				If (preLayerImage[i - preLayerImage.Length] <> Null) Then
					g.drawImage(preLayerImage[i - preLayerImage.Length], 0, 0, 0)
				EndIf
			Next
			
			If (bufferImage <> Null) Then
				g.drawScreen(bufferImage, Null, New Rect(0, 0, screenWidth, screenHeight))
			EndIf
			
			For Local i:= postLayerImage.Length To postLayerImage.Length ' MAX_LAYER
				If (postLayerImage[i - MAX_LAYER] <> Null) Then
					g.drawImage(postLayerImage[i - MAX_LAYER], 0, 0, 0)
				EndIf
			Next
		End
		
		Function handleInput:Void()
			' Constant variable(s):
			Const START_MOUSE_INDEX:= MOUSE_LEFT
			Const LAST_MOUSE_INDEX:= MOUSE_MIDDLE
			
			Const START_KEY_INDEX:= 0
			Const LAST_KEY_INDEX:= 255 ' 256
			
			Local character:= GetChar()
			
			' Check if at least one character was pressed:
			If (character <> 0) Then
				For Local key:= START_KEY_INDEX To LAST_KEY_INDEX
					If (KeyHit(key)) Then
						MFGamePad.keyPressed(keyCode)
						MFGamePad.keyReleased(keyCode)
					ElseIf (KeyDown(key)) Then
						MFGamePad.keyPressed(keyCode)
					EndIf
				Next
			EndIf
			
			'MFGamePad.trackballMoved(keyCode)
			
			Local tx:= TouchX()
			Local ty:= TouchY()
			
			For Local index:= START_MOUSE_INDEX To LAST_MOUSE_INDEX
				If (TouchHit(index)) Then
					pointerPressed(index, tx, ty)
					pointerReleased(index, tx, ty)
				ElseIf (TouchDown(index)) Then
					pointerPressed(index, tx, ty)
					'pointerDragged(index, tx, ty)
				EndIf
			Next
		End
		
		Function pointerDragged:Void(id:Int, x:Int, y:Int)
			If (preScaleZoomOutFlag) Then
				x Shl= preScaleShift
				y Shl= preScaleShift
			ElseIf (preScaleZoomInFlag) Then
				x Shr= preScaleShift
				y Shr= preScaleShift
			EndIf
			
			x = ((x - drawRect.left) * canvasWidth) / drawRect.width()
			y = ((y - drawRect.top) * canvasHeight) / drawRect.height()
			
			If (componentVector <> Null) Then
				For Local component:= EachIn componentVector
					component.pointerDragged(id, x, y)
				Next
			EndIf
		End
		
		Function pointerPressed:Void(id:Int, x:Int, y:Int)
			If (preScaleZoomOutFlag) Then
				x Shl= preScaleShift
				y Shl= preScaleShift
			ElseIf (preScaleZoomInFlag) Then
				x Shr= preScaleShift
				y Shr= preScaleShift
			EndIf
			
			x = ((x - drawRect.left) * canvasWidth) / drawRect.width()
			y = ((y - drawRect.top) * canvasHeight) / drawRect.height()
			
			If (componentVector <> Null) Then
				For Local component:= EachIn componentVector
					component.pointerPressed(id, x, y)
				Next
			EndIf
		End
		
		Function pointerReleased:Void(id:Int, x:Int, y:Int)
			If (preScaleZoomOutFlag) Then
				x Shl= preScaleShift
				y Shl= preScaleShift
			ElseIf (preScaleZoomInFlag) Then
				x Shr= preScaleShift
				y Shr= preScaleShift
			EndIf
			
			x = ((x - drawRect.left) * canvasWidth) / drawRect.width()
			y = ((y - drawRect.top) * canvasHeight) / drawRect.height()
			
			If (componentVector <> Null) Then
				For Local component:= EachIn componentVector
					component.pointerReleased(id, x, y)
				Next
			EndIf
		End
		
		Function addComponent:Void(component:MFComponent)
			If (componentVector <> Null And Not componentVector.Contains(component)) Then
				component.reset()
				
				componentVector.Push(component)
			EndIf
		End
		
		Function changeState:Void(gameState:MFGameState)
			nextState = gameState
		End
		
		Function clearScreen:Void()
			For Local i:= preLayerImage.Length Until 0 Step -1 ' MAX_LAYER
				Local revIndex:= (i - MAX_LAYER) ' preLayerImage.Length
				Local img:= preLayerImage[revIndex]
				
				If (img <> Null) Then
					'img.earseColor(0)
					preLayerGraphics[i].clear()
				EndIf
			Next
			
			#Rem
				If (bufferImage <> Null) Then
					bufferImage.earseColor(0)
				EndIf
			#End
			
			graphics.clear()
			
			For Local i:= postLayerImage.Length To postLayerImage.Length ' MAX_LAYER
				Local revIndex:= (i - MAX_LAYER) ' postLayerImage.Length
				Local img:= postLayerImage[revIndex]
				
				If (img <> Null) Then
					'img.earseColor(0)
					
					postLayerGraphics[revIndex].clear()
				EndIf
			Next
		End
		
		Function currentTimeMillis:Long() ' Int
			Return Millisecs()
		End
		
		Function deleteRecord:Void(recordName:String)
			records.Remove(recordName)
			updateRecords()
		End
		
		Function disableExceedBoundary:Void()
			graphics.disableExceedBoundary()
		End
	
		Function enableExceedBoundary:Void()
			graphics.enableExceedBoundary()
		End
		
		Function getDeviceHeight:Int()
			Return screenHeight
		End
		
		Function getDeviceWidth:Int()
			Return screenWidth
		End
		
		Function getEnableCustomBack:Bool()
			Return enableCustomBack
		End
		
		Function getEnableTrackBall:Bool()
			Return enableTrackBall
		End
		
		Function getEnableVolumeKey:Bool()
			Return enableVolumeKey
		End
		
		Function getGraphics:MFGraphics()
			Return graphics
		End
		
		#Rem
			Function getMainThread:Thread()
				Return mainThread
			End
		#End
		
		Function getNativeCanvasBottom:Int()
			If (preScaleZoomOutFlag) Then
				Return ((bufferHeight - verticvalOffset) Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return ((bufferHeight - verticvalOffset) Shr preScaleShift)
			EndIf
			
			Return (bufferHeight + verticvalOffset)
		End
		
		Function getNativeCanvasHeight:Int()
			If (preScaleZoomOutFlag) Then
				Return (bufferHeight Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return (bufferHeight Shr preScaleShift)
			EndIf
			
			Return (bufferHeight)
		End
		
		Function getNativeCanvasLeft:Int()
			If (preScaleZoomOutFlag) Then
				Return -(horizontalOffset Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return -(horizontalOffset Shr preScaleShift)
			EndIf
			
			Return -(horizontalOffset)
		End
		
		Function getNativeCanvasRight:Int()
			If (preScaleZoomOutFlag) Then
				Return ((bufferWidth - horizontalOffset) Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return ((bufferWidth - horizontalOffset) Shr preScaleShift)
			EndIf
			
			Return (bufferWidth + horizontalOffset)
		End
		
		Function getNativeCanvasTop:Int()
			If (preScaleZoomOutFlag) Then
				Return -(verticvalOffset Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return -(verticvalOffset Shr preScaleShift)
			EndIf
			
			Return -(verticvalOffset)
		End
		
		Function getNativeCanvasWidth:Int()
			If (preScaleZoomOutFlag) Then
				Return (bufferWidth Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return (bufferWidth Shr preScaleShift)
			EndIf
			
			Return (bufferWidth)
		End
		
		Function getPackageVersion:String()
			#Rem
			Local version:String = ""
			
			Return MFMain.getInstance().getPackageManager().getPackageInfo(MFMain.getInstance().getPackageName(), 0).versionName
			#End
			
			Return getVersion() ' VERSION_INFO
		End
		
		Function getResourceAsStream:Stream(url:String)
			Try
				Local substring:String
				
				Print("Attempting to load from URL: " + url)
				
				'Local assets:AssetManager = MFMain.getInstance().getAssets()
				
				If (url.StartsWith("/")) Then
					' Skip the first slash.
					substring = url[1..]
				Else
					substring = url
				EndIf
				
				'ret = assets.open(substring)
				
				Local f:= OpenFileStream(url, "r")
				
				Return f
			Catch E:StreamError
				Print("Error on loading: " + url)
			End Try
			
			Return Null
		End
		
		Function getScreenWidth:Int() Final
			If (preScaleZoomOutFlag) Then
				Return (canvasWidth Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return (canvasWidth Shr preScaleShift)
			EndIf
			
			Return canvasWidth
		End
		
		Function getScreenHeight:Int()
			If (preScaleZoomOutFlag) Then
				Return (canvasHeight Shl preScaleShift)
			EndIf
			
			If (preScaleZoomInFlag) Then
				Return (canvasHeight Shr preScaleShift)
			EndIf
			
			Return canvasHeight
		End
		
		#Rem
			Function getSystemDisplayable:Canvas()
				Return mainCanvas
			End
		#End
		
		Function getVersion:String()
			Return VERSION_INFO
		End
	Private
		' Functions:
		
		' Extensions:
		Function OpenFileStream:FileStream(path:String, mode:String)
			Local f:= FileStream.Open(path, mode)
			
			If (f = Null) Then
				Throw New FileNotFoundException(f, path)
			EndIf
			
			Return f
		End
		
		' Record-related:
		Function ToRecordPath:String(name:String)
			Return ("records/" + name + ".rms")
		End
		
		Function readRecord:DataBuffer(dis:Stream)
			Local size:= dis.ReadInt()
			
			Local ret:DataBuffer
			
			If (t = 0) Then
				ret = NULL_RECORD
			Else
				ret = New DataBuffer(size)
				
				dis.ReadAll(ret, 0, size)
			EndIf
			
			Return ret
		End
		
		Function writeRecord:Void(dos:Stream, values:DataBuffer, offset:Int=0, count:Int=0)
			If (count = 0) Then
				count = values.Length
			EndIf
			
			Local rLen:= Max(Int(offset - count), 0) ' values.Length
			
			dos.WriteInt(rLen)
			
			dos.WriteAll(values, offset, count)
		End
		
		Function loadRecordFrom:DataBuffer(path:String)
			Local dis:= OpenFileStream(path, "r")
			
			Local ret:= readRecord(dis)
			
			dis.Close()
			
			Return ret
		End
		
		Function saveRecordTo:Void(path:String, values:DataBuffer, offset:Int=0, count:Int=0)
			Local dos:= OpenFileStream(path, "w")
			
			writeRecord(dos, values, offset, count)
			
			dos.Close()
		End
		
		Function openRecordStore:DataBuffer(str:String)
			Local ret:DataBuffer = Null
			Local path:String = ToRecordPath(str)
			
			Try
				ret = loadRecordFrom(path)
			Catch notFound:FileNotFoundException
				Print("Create new record file: " + path)
				
				ret = NULL_RECORD
				
				saveRecordTo(path, ret)
			Catch E:StreamError
				Print("RMS ERROR : Can't read rms file.")
			End Try
			
			Return ret
		End
		
		Function initRecords:Void(force:Bool=False)
			If (Not force And records <> Null) Then
				Return
			EndIf
			
			records = New StringMap<DataBuffer>()
			
			Local recordStoreNumber:= dis.ReadInt()
			
			Local dis:= New DataStream(openRecordStore(RECORD_NAME))
			
			For Local i:= 0 Until recordStoreNumber
				Local nameLen:= dis.ReadShort()
				Local name:String = dis.ReadString(nameLen, "utf8") ' "ascii"
				Local record:= readRecord(dis)
				
				records.Set(name, record)
			Next
		End
		
		Function updateRecords:Void()
			' Constant variable(s):
			Const DEFAULT_FILE_SIZE:= 4096 ' Bytes.
			
			' Local variable(s):
			Local dos:= new PublicDataStream(DEFAULT_FILE_SIZE)
			
			dos.WriteInt(records.Count())
			
			For Local rNode:= EachIn records
				Local name:= rNode.Key
				Local record:= rNode.Value
				
				Local nameLen:= name.Length
				
				dos.WriteShort(nameLen)
				dos.WriteString(name, "utf8")
				
				'writeRecord:Void(dos:Stream, values:DataBuffer, offset:Int=0, count:Int=0)
				writeRecord(dos, record)
			Next
			
			Local len:= dos.Length
			
			Local buffer:= dos.CloseWithoutBuffer()
			
			setRecord(RECORD_NAME, buffer, len)
		End
	Public
		' Functions:
		Function loadRecord:DataBuffer(recordName:String)
			Return records.Get(recordName)
		End
		
		Function notifyExit:Void()
			exitFlag = True
		End
		
		Function notifyPause:Void()
			If (responseInterrupt And Not interruptPauseFlag) Then
				stopVibrate()
				
				MFGamePad.resetKeys()
				'MFSound.deviceInterrupt()
				
				If (currentState <> Null) Then
					currentState.onPause()
				EndIf
				
				interruptPauseFlag = True
				
				If (componentVector <> Null) Then
					For (Int i = 0; i < componentVector.size(); i += 1)
						((MFComponent) componentVector.elementAt(i)).reset()
					Next
					interruptConfirm = New MFTouchKey(0, canvasHeight - 50, 100, 50, Boss4Ice.DRAW_OFFSET_Y)
					addComponent(interruptConfirm)
				EndIf
			EndIf
		End

		Function notifyResume:Void()
			If (responseInterrupt And interruptPauseFlag) Then
				MFGamePad.resetKeys()
				MFSound.deviceResume()
				
				If (currentState <> Null) Then
					currentState.onResume()
				EndIf
				
				interruptPauseFlag = False
				
				If (componentVector <> Null) Then
					For (Int i = 0; i < componentVector.size(); i += 1)
						((MFComponent) componentVector.elementAt(i)).reset()
					Next
					removeComponent(interruptConfirm)
				EndIf
			EndIf
		End

	Public Function notifyStart:Void(width:Int, height:Int) Final
		
		If (mainThread = Null) Then
			If (MFMain.getInstance().getRequestedOrientation() = 1) Then
				canvasHeight = MDPhone.SCREEN_HEIGHT
				canvasWidth = MDPhone.SCREEN_WIDTH
				
				If (width > height) Then
					screenWidth = height
					screenHeight = width
				Else
					screenWidth = width
					screenHeight = height
				EndIf
				
			Else
				canvasHeight = MDPhone.SCREEN_WIDTH
				canvasWidth = MDPhone.SCREEN_HEIGHT
				
				If (width < height) Then
					screenWidth = height
					screenHeight = width
				Else
					screenWidth = width
					screenHeight = height
				EndIf
			EndIf
			
			Print("screenwidth:" + screenWidth + ",screenheight:" + screenHeight)
			changeState(MFMain.getInstance().getEntryGameState())
			setFullscreenMode(False)
			startThread()
		EndIf
		
	}

	Public Function notifyVolumeChange:Void(isUp:Bool) Final
		
		If (isUp) Then
			currentState.onVolumeUp()
		Else
			currentState.onVolumeDown()
		EndIf
		
	}
	
	Public Function removeAllComponents:Void() Final
		
		If (componentVector <> Null) Then
			componentVector.removeAllElements()
		EndIf
		
	}

	Public Function removeComponent:Void(component:MFComponent) Final
		
		If (componentVector <> Null) Then
			componentVector.removeElement(component)
		EndIf
		
	}

	Public Function saveRecord:Void(recordName:String, record:Byte[]) Final
		records.put(recordName, record)
		updateRecords()
	}

	Public Function setAntiAlias:Void(b:Bool)
		mainCanvas.setAntiAlias(b)
	}

	Public Function setCanvasSize:Void(w:Int, h:Int)
		canvasWidth = w
		canvasHeight = h
	}

	Public Function setClearBuffer:Void(b:Bool)
		clearBuffer = b
	}

	Public Function setEnableCustomBack:Void(b:Bool)
		enableCustomBack = b
	}

	Public Function setEnableTrackBall:Void(b:Bool)
		enableTrackBall = b
	}

	Public Function setEnableVolumeKey:Void(b:Bool)
		enableVolumeKey = b
	}

	Public Function enableLayer:Void(layer:Int)
		
		If (layer <= 0 Or layer > 1) Then
			If (layer < 0 And layer >= -1 And preLayerImage[(-layer) - 1] = Null) Then
				preLayerImage[(-layer) - 1] = Image.createImage(screenWidth, screenHeight)
				preLayerGraphics[(-layer) - 1] = MFGraphics.createMFGraphics(preLayerImage[(-layer) - 1].getGraphics(), screenWidth, screenHeight)
			EndIf
			
		ElseIf (postLayerImage[layer - 1] = Null) Then
			postLayerImage[layer - 1] = Image.createImage(screenWidth, screenHeight)
			postLayerGraphics[layer - 1] = MFGraphics.createMFGraphics(postLayerImage[layer - 1].getGraphics(), screenWidth, screenHeight)
		EndIf
		
	}

	Public Function disableLayer:Void(layer:Int)
		
		If (layer > 0 And layer <= 1) Then
			postLayerImage[layer - 1] = Null
			postLayerGraphics[layer - 1] = Null
		ElseIf (layer < 0 And layer >= -1) Then
			preLayerImage[(-layer) - 1] = Null
			preLayerGraphics[(-layer) - 1] = Null
		EndIf
		
	}

	Public Function setFilterBitmap:Void(b:Bool)
		mainCanvas.setFilterBitmap(b)
	}

	Public Function setFullscreenMode:Void(b:Bool)
		
		If (b) Then
			drawRect = New Rect(0, 0, screenWidth, screenHeight)
		ElseIf (((Float) screenWidth) / ((Float) canvasWidth) > ((Float) screenHeight) / ((Float) canvasHeight)) Then
			Int tmpHeight
			
			If (preScaleZoomOutFlag And canvasHeight > screenHeight) Then
				preScaleShift = 0
				tmpHeight = canvasHeight
				While (tmpHeight > screenHeight And tmpHeight - screenHeight > screenHeight - (tmpHeight / 2)) {
					tmpHeight /= 2
					canvasWidth /= 2
					canvasHeight /= 2
					preScaleShift += 1
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomOutFlag = False
				EndIf
				
				preScaleZoomInFlag = False
			EndIf
			
			If (preScaleZoomInFlag And canvasHeight < screenHeight) Then
				preScaleShift = 0
				tmpHeight = canvasHeight
				While (tmpHeight < screenHeight And screenHeight - tmpHeight > (tmpHeight * 2) - screenHeight) {
					tmpHeight *= 2
					canvasWidth *= 2
					canvasHeight *= 2
					preScaleShift += 1
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomInFlag = False
				EndIf
				
				preScaleZoomOutFlag = False
			EndIf
			
			h = screenHeight
			w = (canvasWidth * h) / canvasHeight
			Int x = (screenWidth - w) / 2
			drawRect = New Rect(x, 0, x + w, 0 + h)
			
			If (preScaleZoomOutFlag) Then
				bufferImage = Image.createImage(((canvasHeight * screenWidth) / screenHeight) Shl preScaleShift, canvasHeight Shl preScaleShift)
			ElseIf (preScaleZoomInFlag) Then
				bufferImage = Image.createImage(((canvasHeight * screenWidth) / screenHeight) Shr preScaleShift, canvasHeight Shr preScaleShift)
			Else
				bufferImage = Image.createImage((canvasHeight * screenWidth) / screenHeight, canvasHeight)
			EndIf
			
			graphics = MFGraphics.createMFGraphics(bufferImage.getGraphics(), (canvasHeight * screenWidth) / screenHeight, canvasHeight)
		Else
			Int tmpWidth
			
			If (preScaleZoomOutFlag And canvasWidth > screenWidth) Then
				preScaleShift = 0
				tmpWidth = canvasWidth
				While (tmpWidth > screenWidth And ((Float) tmpWidth) - ((Float) screenWidth) > ((Float) (screenWidth - (tmpWidth / 2)))) {
					tmpWidth /= 2
					canvasWidth /= 2
					canvasHeight /= 2
					preScaleShift += 1
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomOutFlag = False
				EndIf
				
				preScaleZoomInFlag = False
			EndIf
			
			If (preScaleZoomInFlag And canvasWidth < screenWidth) Then
				preScaleShift = 0
				tmpWidth = canvasWidth
				While (tmpWidth < screenWidth And screenWidth - tmpWidth < (tmpWidth * 2) - screenWidth) {
					tmpWidth *= 2
					canvasWidth *= 2
					canvasHeight *= 2
					preScaleShift += 1
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomInFlag = False
				EndIf
				
				preScaleZoomOutFlag = False
			EndIf
			
			w = screenWidth
			h = (canvasHeight * w) / canvasWidth
			Int y = (screenHeight - h) / 2
			drawRect = New Rect(0, y, 0 + w, y + h)
			
			If (preScaleZoomOutFlag) Then
				bufferImage = Image.createImage(canvasWidth Shl preScaleShift, ((canvasWidth * screenHeight) / screenWidth) Shl preScaleShift)
			ElseIf (preScaleZoomInFlag) Then
				bufferImage = Image.createImage(canvasWidth Shr preScaleShift, ((canvasWidth * screenHeight) / screenWidth) Shr preScaleShift)
			Else
				bufferImage = Image.createImage(canvasWidth, (canvasWidth * screenHeight) / screenWidth)
			EndIf
			
			graphics = MFGraphics.createMFGraphics(bufferImage.getGraphics(), canvasWidth, (canvasWidth * screenHeight) / screenWidth)
		EndIf
		
		bufferWidth = bufferImage.getWidth() Shr preScaleShift
		bufferHeight = bufferImage.getHeight() Shr preScaleShift
		horizontalOffset = (drawRect.left * bufferWidth) / screenWidth
		verticvalOffset = (drawRect.top * bufferHeight) / screenHeight
		graphics.f7g.getCanvas().translate((Float) horizontalOffset, (Float) verticvalOffset)
	}

	Public Function setPreScale:Void(zoomIn:Bool, zoomOut:Bool)
		preScaleZoomInFlag = zoomIn
		preScaleZoomOutFlag = zoomOut
	}

	Private Function setRecord:Void(str:String, data:DataBuffer, len:Int)
		Try
			saveRecordTo(ToRecordPath(str), data, 0, len)
		Catch E:StreamError
			Print("RMS ERROR : Can't save rms file.")
		End
	End

	Public Function setResponseInterruptFlag:Void(flag:Bool) Final
		responseInterrupt = flag
	}

	Public Function setShieldInput:Void(b:Bool) Final
		shieldInput = b
	}

	Public Function setUseMultitouch:Void(b:Bool)
		mainCanvas.setUseMultitouch(b)
	}

	Public Function setVibrationFlag:Void(enable:Bool) Final
		vibraionFlag = enable
		
		If (Not vibraionFlag) Then
			stopVibrate()
		EndIf
		
	}

	Public Function startThread:Void() Final
		
		If (mainThread = Null) Then
			mainThread = New Thread(mainRunnable)
			mainThread.start()
		EndIf
		
	}

	Public Function startVibrate:Void() Final
		
		If (vibraionFlag) Then
			inVibrationFlag = True
			((Vibrator) MFMain.getInstance().getSystemService("vibrator")).vibrate(10000)
		EndIf
		
	}

	Public Function stopVibrate:Void() Final
		
		If (inVibrationFlag) Then
			inVibrationFlag = False
			((Vibrator) MFMain.getInstance().getSystemService("vibrator")).cancel()
		EndIf
		
	}

	Public Function vibrateByTime:Void(time:Int) Final
		
		If (vibraionFlag) Then
			vibrationImpl(time)
		EndIf
		
	}

	Private Function vibrationImpl:Void(time:Int) Final
		vibrator.vibrate((Long) time)
	}
End

#Rem
	/* renamed from: com.sega.mobile.framework.device.MFDevice.1 */
	Class C00011 Implements Runnable {
		C00011() {
		}

		/* JADX WARNING: inconsistent code. */
		/* Code decompiled incorrectly, please refer to instructions dump. */
		Public Method run:Void() Final
			/*
			r4 = Self
			r3 = 1
			r2 = 0
			com.sega.mobile.framework.device.MFDevice.interruptPauseFlag = r2
			com.sega.mobile.framework.device.MFDevice.responseInterrupt = r3
			com.sega.mobile.framework.device.MFDevice.exitFlag = r2
			r0 = java.lang.System.currentTimeMillis()
			com.sega.mobile.framework.device.MFDevice.lastSystemTime = r0
			com.sega.mobile.framework.device.MFDevice.initRecords()
			com.sega.mobile.framework.device.MFGraphics.init()
			com.sega.mobile.framework.device.MFSound.init()
			com.sega.mobile.framework.device.MFSensor.init()
			com.sega.mobile.framework.device.MFGamePad.resetKeys()
			r0 = com.sega.mobile.framework.MFMain.getInstance()
			r1 = "vibrator"
			r0 = r0.getSystemService(r1)
			r0 = (android.os.Vibrator) r0
			com.sega.mobile.framework.device.MFDevice.vibrator = r0
			r0 = New java.util.Vector
			r0.<init>()
			com.sega.mobile.framework.device.MFDevice.componentVector = r0
			com.sega.mobile.framework.device.MFDevice.vibraionFlag = r3
			com.sega.mobile.framework.device.MFDevice.inVibrationFlag = r2
		L_0x003e:
			r0 = com.sega.mobile.framework.device.MFDevice.exitFlag
			
			If (r0 = 0) goto L_0x0053
		L_0x0044:
			r0 = com.sega.mobile.framework.device.MFDevice.currentState
			r0.onExit()
			r0 = com.sega.mobile.framework.MFMain.getInstance()
			r0.notifyDestroyed()
			Return
		L_0x0053:
			r4.tick()
		L_0x0056:
			r0 = 10
			java.lang.Thread.sleep(r0);	 Catch:{ Exception -> 0x0095 }
		L_0x005b:
			r0 = java.lang.System.currentTimeMillis()
			com.sega.mobile.framework.device.MFDevice.currentSystemTime = r0
			r0 = com.sega.mobile.framework.device.MFDevice.currentState
			
			If (r0 = 0) goto L_0x008d
		L_0x0068:
			r0 = com.sega.mobile.framework.device.MFDevice.currentSystemTime
			r2 = com.sega.mobile.framework.device.MFDevice.lastSystemTime
			r0 = r0 - r2
			r2 = 0
			r0 = (r0 > r2 ? 1 : (r0 = r2 ? 0 : -1))
			
			If (r0 <= 0) goto L_0x008d
		L_0x0077:
			r0 = com.sega.mobile.framework.device.MFDevice.currentSystemTime
			r2 = com.sega.mobile.framework.device.MFDevice.lastSystemTime
			r0 = r0 - r2
			r2 = com.sega.mobile.framework.device.MFDevice.currentState
			r2 = r2.getFrameTime()
			r2 = (Long) r2
			r0 = (r0 > r2 ? 1 : (r0 = r2 ? 0 : -1))
			
			If (r0 < 0) goto L_0x0056
		L_0x008d:
			r0 = java.lang.System.currentTimeMillis()
			com.sega.mobile.framework.device.MFDevice.lastSystemTime = r0
			goto L_0x003e
		L_0x0095:
			r0 = move-exception
			goto L_0x005b
			*/
			throw New UnsupportedOperationException("Method not decompiled: com.sega.mobile.framework.device.MFDevice.1.run():Void")
		End

		Private Method tick:Void()
			
			If (MFDevice.mainCanvas.initialized()) Then
				Int i
				synchronized (MFDevice.mainRunnable) {
					MFGamePad.keyTick()
					For (i = MFDevice.0; i < MFDevice.componentVector.size(); i += MFDevice.1)
						((MFComponent) MFDevice.componentVector.elementAt(i)).tick()
					Next
				}
				MFSound.tick()
				
				If (MFDevice.vibraionFlag) Then
					If (MFDevice.vibrateTime > 0 And System.currentTimeMillis() - MFDevice.vibrateStartTime > ((Long) MFDevice.vibrateTime)) Then
						MFDevice.vibrateTime = MFDevice.0
						MFDevice.inVibrationFlag = False
					EndIf
					
					If (MFDevice.inVibrationFlag) Then
						MFDevice.vibrationImpl(MFDevice.PER_VIBRATION_TIME)
					EndIf
				EndIf
				
				If (MFDevice.nextState <> Null) Then
					If (MFDevice.currentState <> Null) Then
						MFDevice.currentState.onExit()
					EndIf
					
					MFDevice.currentState = MFDevice.nextState
					MFDevice.currentState.onEnter()
					MFDevice.nextState = Null
				EndIf
				
				MFDevice.graphics.reset()
				
				If (MFDevice.clearBuffer) Then
					MFDevice.clearScreen()
				EndIf
				
				If (MFDevice.interruptPauseFlag) Then
					If (Not MFDevice.inSuspendFlag And MFMain.getInstance().logicDeviceSuspend()) Then
						MFDevice.notifyResume()
					EndIf
					
					MFMain.getInstance().drawDeviceSuspend(MFDevice.graphics)
				Else
					MFDevice.currentState.onTick()
					
					If (Not MFDevice.exitFlag) Then
						For (i = MFDevice.1; i > 0; i -= 1)
							
							If (MFDevice.preLayerGraphics[i - MFDevice.1] <> Null) Then
								MFDevice.currentState.onRender(MFDevice.preLayerGraphics[i - MFDevice.1], -i)
							EndIf
							
						Next
						MFDevice.currentState.onRender(MFDevice.graphics)
						For (i = MFDevice.1; i <= MFDevice.1; i += MFDevice.1)
							
							If (MFDevice.postLayerGraphics[i - MFDevice.1] <> Null) Then
								MFDevice.currentState.onRender(MFDevice.postLayerGraphics[i - MFDevice.1], i)
							EndIf
							
						Next
					EndIf
				EndIf
				
				MFDevice.mainCanvas.repaint()
			EndIf
			
		End
	}
#End

Class FileNotFoundException Extends StreamError
	' Constructor(s):
	Method New(stream:Stream, filepath:String)
		Super.New(stream)
		
		Self.file = filepath
	End
	
	' Methods:
	Method ToString:String()
		Return ("Unable to find the specified file: " + file)
	End
	
	' Fields:
	Field file:String
End