Strict

Public

' Friends:
Friend application

' Imports:
Private
	Import lib.rect
	
	'Import mflib.bpdef
	
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
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfcomponent
	Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	Import com.sega.mobile.framework.ui.mftouchkey
	
	Import com.sega.mobile.framework.device.mfsensor
	'Import com.sega.mobile.framework.device.mfsound
	'Import com.sega.mobile.framework.mfmain
	'Import com.sega.mobile.framework.android.canvas
	'Import com.sega.mobile.framework.android.image
	
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
		Global interruptConfirm:MFTouchKey
		Global interruptPauseFlag:Bool
		Global lastSystemTime:Long
		Global logicTrace:Bool
		
		Global vibraionFlag:Bool
		Global vibrateStartTime:Long
		Global vibrateTime:Int
		'Global vibrator:Vibrator
		
		'Global webPageUrl:String
		
		'Global methodCallTrace:Bool
		
		Global nextState:MFGameState
		Global records:StringMap<DataBuffer>
		Global responseInterrupt:Bool
		
		' Graphis:
		'Global bufferImage:Image ' <-- Used to be used to represent the screen.
		
		#Rem
		Global postLayerGraphics:MFGraphics[] = New MFGraphics[MAX_LAYER]
		Global postLayerImage:Image[] = New Image[MAX_LAYER]
		Global preLayerGraphics:MFGraphics[] = New MFGraphics[MAX_LAYER]
		Global preLayerImage:Image[] = New Image[MAX_LAYER]
		#End
		
		Global postLayer:MFImage[] = New MFImage[MAX_LAYER]
		Global preLayer:MFImage[] = New MFImage[MAX_LAYER]
	Public ' Protected
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
		Function FixResourcePath:String(url:String)
			If (url.StartsWith("/")) Then
				' Skip the first slash.
				Return url[1..]
			EndIf
			
			Return url
		End
		
		Function Update:Void()
			MFGamePad.keyTick()
			
			For Local component:= EachIn componentVector 
				component.tick()
			Next
			
			'MFSound.tick()
			
			' Update vibration behavior:
			If (vibraionFlag) Then
				If (vibrateTime > 0 And currentTimeMillis() - vibrateStartTime > Long(vibrateTime)) Then
					vibrateTime = 0
					
					inVibrationFlag = False
				EndIf
				
				If (inVibrationFlag) Then
					vibrationImpl(PER_VIBRATION_TIME)
				EndIf
			EndIf
			
			' Handle state changes:
			If (nextState <> Null) Then
				If (currentState <> Null) Then
					currentState.onExit()
				EndIf
				
				currentState = nextState
				
				currentState.onEnter()
				
				nextState = Null
			EndIf
			
			If (Not interruptPauseFlag) Then
				currentState.onTick()
			EndIf
		End
		
		Function Render:Void(context:Graphics)
			graphics.reset()
			
			If (Not interruptPauseFlag) Then
				If (Not exitFlag) Then
					For Local i:= preLayer.Length Until 0 Step -1 ' MAX_LAYER ' To 0
						Local layer:= preLayer[i - 1]
						
						If (layer <> Null) Then
							currentState.onRender(layer.getGraphics(), -i)
						EndIf
					Next
					
					currentState.onRender(graphics)
					
					For Local i:= postLayer.Length To postLayer.Length ' MAX_LAYER
						Local layer:= postLayer[i - MAX_LAYER]
						
						If (layer <> Null) Then
							currentState.onRender(layer.getGraphics(), i)
						EndIf
					Next
				EndIf
			EndIf
		End
		
		Function deviceDraw:Void(g:Graphics)
			For Local i:= preLayer.Length Until 0 Step -1 ' MAX_LAYER ' To 0
				Local layer:= preLayer[i - preLayer.Length]
				
				If (layer <> Null) Then
					g.drawImage(layer.getNativeImage(), 0, 0, 0)
				EndIf
			Next
			
			#Rem
			If (bufferImage <> Null) Then
				g.drawScreen(bufferImage, Null, New Rect(0, 0, screenWidth, screenHeight))
			EndIf
			#End
			
			For Local i:= postLayer.Length To postLayer.Length ' Until 0 Step -1 ' MAX_LAYER
				Local layer:= postLayer[i - MAX_LAYER]
				
				If (layer <> Null) Then
					g.drawImage(layer.getNativeImage(), 0, 0, 0)
				EndIf
			Next
		End
		
		Function handleInput:Void()
			' Constant variable(s):
			Const START_MOUSE_INDEX:= MOUSE_LEFT
			Const LAST_MOUSE_INDEX:= MOUSE_MIDDLE
			
			Const START_KEY_INDEX:= 0
			Const LAST_KEY_INDEX:= 255 ' 256
			
			Local keyCode:= GetChar()
			
			' Check if at least one character was pressed:
			If (keyCode <> 0) Then
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
		
		Function flushScreen:Void()
			deviceDraw(graphics.getSystemGraphics())
			
			graphics.flush()
		End
		
		Function clearScreen:Void()
			For Local i:= preLayer.Length Until 0 Step -1 ' MAX_LAYER ' To 0
				Local revIndex:= (i - MAX_LAYER) ' preLayerImage.Length
				Local img:= preLayer[revIndex]
				
				If (img <> Null) Then
					'img.earseColor(0)
					
					img.getGraphics().clear()
				EndIf
			Next
			
			#Rem
				If (bufferImage <> Null) Then
					bufferImage.earseColor(0)
				EndIf
			#End
			
			graphics.clear()
			
			For Local i:= postLayer.Length To postLayer.Length ' MAX_LAYER
				Local revIndex:= (i - MAX_LAYER) ' postLayer.Length
				Local img:= postLayer[revIndex]
				
				If (img <> Null) Then
					'img.earseColor(0)
					
					img.getGraphics().clear()
				EndIf
			Next
		End
		
		Function currentTimeMillis:Long() ' Int
			Return Long(Millisecs())
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
				
				url = FixResourcePath(url)
				
				'ret = assets.open(substring)
				
				Local f:= OpenFileStream(url, "r")
				
				Return f
			Catch E:StreamError
				Print("Error on loading: " + url)
			End Try
			
			Return Null
		End
		
		Function getScreenWidth:Int()
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
			
			If (size = 0) Then
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
				Print("Create New record file: " + path)
				
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
			
			Local dis:= New DataStream(openRecordStore(RECORD_NAME))
			
			Local recordStoreNumber:= dis.ReadInt()
			
			For Local i:= 0 Until recordStoreNumber
				Local nameLen:= dis.ReadShort()
				Local name:String = dis.ReadString(nameLen, "utf8") ' "ascii"
				Local record:= readRecord(dis)
				
				records.Set(name, record)
			Next
		End
		
		Function updateRecords:Void()
			' Constant variable(s):
			Const DEFAULT_FILE_SIZE:= 1024 ' Bytes.
			
			' Local variable(s):
			Local dos:= New PublicDataStream(DEFAULT_FILE_SIZE)
			
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
			Local outBuffer:= dos.ToDataBuffer()
			
			dos.Close()
			
			setRecord(RECORD_NAME, outBuffer, len)
		End
		
		Function setRecord:Void(str:String, data:DataBuffer, len:Int)
			Try
				saveRecordTo(ToRecordPath(str), data, 0, len)
			Catch E:StreamError
				Print("RMS ERROR : Can't save rms file.")
			End
		End
	Public
		' Functions:
		
		' Record-related:
		Function loadRecord:DataBuffer(recordName:String)
			Return records.Get(recordName)
		End
		
		' Notifications:
		Function notifyStart:Void(context:Graphics, startState:MFGameState, width:Int, height:Int)
			Local isSideways:Bool = False ' (MFMain.getInstance().getRequestedOrientation() = SCREEN_ORIENTATION_PORTRAIT)
			
			'If (mainThread = Null) Then
			If (Not isSideways) Then
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
			
			Print("screenwidth: " + screenWidth + ", screenheight:" + screenHeight)
			
			changeState(startState)
			
			setFullscreenMode(context, False)
			
			'startThread()
			'EndIf
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
					For Local component:= EachIn componentVector
						component.reset()
					Next
					
					interruptConfirm = New MFTouchKey(0, canvasHeight - 50, 100, 50, 2112)
					
					addComponent(interruptConfirm)
				EndIf
			EndIf
		End

		Function notifyResume:Void()
			If (responseInterrupt And interruptPauseFlag) Then
				MFGamePad.resetKeys()
				'MFSound.deviceResume()
				
				If (currentState <> Null) Then
					currentState.onResume()
				EndIf
				
				interruptPauseFlag = False
				
				If (componentVector <> Null) Then
					For Local component:= EachIn componentVector
						component.reset()
					Next
					
					removeComponent(interruptConfirm)
				EndIf
			EndIf
		End
		
		Function notifyVolumeChange:Void(isUp:Bool)
			If (isUp) Then
				currentState.onVolumeUp()
			Else
				currentState.onVolumeDown()
			EndIf
		End
		
		Function removeAllComponents:Void()
			If (componentVector <> Null) Then
				componentVector.Clear()
			EndIf
		End
		
		Function removeComponent:Void(component:MFComponent)
			If (componentVector <> Null) Then
				componentVector.RemoveEach(component)
			EndIf
		End
		
		Function saveRecord:Void(recordName:String, record:DataBuffer)
			records.Set(recordName, record)
			
			updateRecords()
		End
		
		Function setAntiAlias:Void(b:Bool)
			'mainCanvas.setAntiAlias(b)
		End
		
		Function setCanvasSize:Void(w:Int, h:Int)
			canvasWidth = w
			canvasHeight = h
		End
	
		Function setClearBuffer:Void(b:Bool)
			clearBuffer = b
		End
	
		Function setEnableCustomBack:Void(b:Bool)
			enableCustomBack = b
		End
	
		Function setEnableTrackBall:Void(b:Bool)
			enableTrackBall = b
		End
	
		Function setEnableVolumeKey:Void(b:Bool)
			enableVolumeKey = b
		End
		
		Function enableLayer:Void(layer:Int)
			If (layer <= 0 Or layer > MAX_LAYER) Then ' (layer <> MAX_LAYER)
				If (layer < 0 And layer >= -MAX_LAYER And preLayer[(-layer) - MAX_LAYER] = Null) Then
					preLayer[(-layer) - MAX_LAYER] = MFImage.createImage(screenWidth, screenHeight)
				EndIf
			ElseIf (postLayer[layer - MAX_LAYER] = Null) Then
				postLayer[layer - MAX_LAYER] = MFImage.createImage(screenWidth, screenHeight)
			EndIf
		End
		
		Function disableLayer:Void(layer:Int)
			If (layer > 0 And layer <= MAX_LAYER) Then
				postLayer[layer - MAX_LAYER] = Null
			ElseIf (layer < 0 And layer >= -MAX_LAYER) Then
				preLayer[(-layer) - MAX_LAYER] = Null
			EndIf
		End
		
		Function setFilterBitmap:Void(b:Bool)
			'mainCanvas.setFilterBitmap(b)
		End
		
		Function setFullscreenMode:Void(context:Graphics, b:Bool)
			Local vWidth:Int, vHeight:Int
			
			If (b) Then
				drawRect = New Rect(0, 0, screenWidth, screenHeight)
				
				vWidth = screenWidth
				vHeight = screenHeight
			ElseIf (Float(screenWidth) / Float(canvasWidth) > Float(screenHeight) / Float(canvasHeight)) Then
				Local tmpHeight:Int
				
				If (preScaleZoomOutFlag And canvasHeight > screenHeight) Then
					preScaleShift = 0
					
					tmpHeight = canvasHeight
					
					While (tmpHeight > screenHeight And tmpHeight - screenHeight > screenHeight - (tmpHeight / 2))
						tmpHeight /= 2
						
						canvasWidth /= 2
						canvasHeight /= 2
						
						preScaleShift += 1
					Wend
					
					If (preScaleShift = 0) Then
						preScaleZoomOutFlag = False
					EndIf
					
					preScaleZoomInFlag = False
				EndIf
				
				If (preScaleZoomInFlag And canvasHeight < screenHeight) Then
					preScaleShift = 0
					
					tmpHeight = canvasHeight
					
					While (tmpHeight < screenHeight And screenHeight - tmpHeight > (tmpHeight * 2) - screenHeight)
						tmpHeight *= 2
						
						canvasWidth *= 2
						canvasHeight *= 2
						
						preScaleShift += 1
					Wend
					
					If (preScaleShift = 0) Then
						preScaleZoomInFlag = False
					EndIf
					
					preScaleZoomOutFlag = False
				EndIf
				
				Local h:= screenHeight
				Local w:= ((canvasWidth * h) / canvasHeight)
				
				Local x:= ((screenWidth - w) / 2)
				
				drawRect = New Rect(x, 0, x + w, h)
				
				#Rem
					If (preScaleZoomOutFlag) Then
						bufferImage = MFImage.generateNativeImage(((canvasHeight * screenWidth) / screenHeight) Shl preScaleShift, canvasHeight Shl preScaleShift)
					ElseIf (preScaleZoomInFlag) Then
						bufferImage = MFImage.generateNativeImage(((canvasHeight * screenWidth) / screenHeight) Shr preScaleShift, canvasHeight Shr preScaleShift)
					Else
						bufferImage = MFImage.generateNativeImage((canvasHeight * screenWidth) / screenHeight, canvasHeight)
					EndIf
					
					graphics = MFGraphics.createMFGraphics(bufferImage.getGraphics(), (canvasHeight * screenWidth) / screenHeight, canvasHeight)
				#End
				
				vWidth = ((canvasHeight * screenWidth) / screenHeight)
				vHeight = canvasHeight
			Else
				Local tmpWidth:Int
				
				If (preScaleZoomOutFlag And canvasWidth > screenWidth) Then
					preScaleShift = 0
					
					tmpWidth = canvasWidth
					
					While (tmpWidth > screenWidth And Float(tmpWidth) - Float(screenWidth) > Float(screenWidth - (tmpWidth / 2)))
						tmpWidth /= 2
						
						canvasWidth /= 2
						canvasHeight /= 2
						
						preScaleShift += 1
					Wend
					
					If (preScaleShift = 0) Then
						preScaleZoomOutFlag = False
					EndIf
					
					preScaleZoomInFlag = False
				EndIf
				
				If (preScaleZoomInFlag And canvasWidth < screenWidth) Then
					preScaleShift = 0
					
					tmpWidth = canvasWidth
					
					While (tmpWidth < screenWidth And screenWidth - tmpWidth < (tmpWidth * 2) - screenWidth)
						tmpWidth *= 2
						
						canvasWidth *= 2
						canvasHeight *= 2
						
						preScaleShift += 1
					Wend
					
					If (preScaleShift = 0) Then
						preScaleZoomInFlag = False
					EndIf
					
					preScaleZoomOutFlag = False
				EndIf
				
				Local w:= screenWidth
				Local h:= ((canvasHeight * w) / canvasWidth)
				
				Local y:= ((screenHeight - h) / 2)
				
				drawRect = New Rect(0, y, w, y + h)
				
				#Rem
					If (preScaleZoomOutFlag) Then
						bufferImage = MFImage.generateNativeImage(canvasWidth Shl preScaleShift, ((canvasWidth * screenHeight) / screenWidth) Shl preScaleShift)
					ElseIf (preScaleZoomInFlag) Then
						bufferImage = MFImage.generateNativeImage(canvasWidth Shr preScaleShift, ((canvasWidth * screenHeight) / screenWidth) Shr preScaleShift)
					Else
						bufferImage = MFImage.generateNativeImage(canvasWidth, (canvasWidth * screenHeight) / screenWidth)
					EndIf
					
					graphics = MFGraphics.createMFGraphics(bufferImage.getGraphics(), canvasWidth, (canvasWidth * screenHeight) / screenWidth)
				#End
				
				vWidth = canvasWidth
				vHeight = ((canvasWidth * screenHeight) / screenWidth)
			EndIf
			
			graphics = MFGraphics.createMFGraphics(context, vWidth, vHeight)
			
			bufferWidth = (vWidth Shr preScaleShift)
			bufferHeight = (vHeight Shr preScaleShift)
			
			horizontalOffset = ((drawRect.left * bufferWidth) / screenWidth)
			verticvalOffset = ((drawRect.top * bufferHeight) / screenHeight)
			
			graphics.context.getCanvas().Translate(Float(horizontalOffset), Float(verticvalOffset))
		End
		
		Function setPreScale:Void(zoomIn:Bool, zoomOut:Bool)
			preScaleZoomInFlag = zoomIn
			preScaleZoomOutFlag = zoomOut
		End
		
		Function setResponseInterruptFlag:Void(flag:Bool)
			responseInterrupt = flag
		End
		
		Function setShieldInput:Void(b:Bool)
			shieldInput = b
		End
		
		Function setUseMultitouch:Void(b:Bool)
			'mainCanvas.setUseMultitouch(b)
		End
		
		Function setVibrationFlag:Void(enable:Bool)
			vibraionFlag = enable
			
			If (Not vibraionFlag) Then
				stopVibrate()
			EndIf
		End
		
		#Rem
			Function startThread:Void()
				If (mainThread = Null) Then
					mainThread = New Thread(mainRunnable)
					mainThread.start()
				EndIf
			End
		#End
		
		Function startVibrate:Void()
			If (vibraionFlag) Then
				inVibrationFlag = True
				
				'((Vibrator) MFMain.getInstance().getSystemService("vibrator")).vibrate(10000)
			EndIf
		End
		
		Function stopVibrate:Void()
			If (inVibrationFlag) Then
				inVibrationFlag = False
				
				'((Vibrator) MFMain.getInstance().getSystemService("vibrator")).cancel()
			EndIf
		End
		
		Function vibrateByTime:Void(time:Int)
			If (vibraionFlag) Then
				vibrationImpl(time)
			EndIf
		End
		
		Function vibrationImpl:Void(time:Int) ' Long
			'vibrator.vibrate(Long(time))
		End
End

Class FileNotFoundException Extends StreamError
	' Constructor(s):
	Method New(stream:Stream, filepath:String="")
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

' Functions:
Function InitializeMobileFramework:Void()
	MFDevice.interruptPauseFlag = False
	MFDevice.responseInterrupt = True
	MFDevice.exitFlag = False
	MFDevice.lastSystemTime = Millisecs()
	
	MFDevice.initRecords()
	
	MFGraphics.init()
	
	'MFSound.init()
	MFSensor.init()
	MFGamePad.resetKeys()
	
	'MFDevice.vibrator = (Vibrator)MFMain.getInstance().getSystemService("vibrator")
	MFDevice.componentVector = New Stack<MFComponent>()
	MFDevice.vibraionFlag = True
	MFDevice.inVibrationFlag = False
End