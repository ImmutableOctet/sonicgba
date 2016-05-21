Strict

Public

' Preprocessor related:
'#SONICGBA_MFDEVICE_ALLOW_LAYERS = True

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
	'Import com.sega.mobile.framework.android.graphics
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
	
	#If SONICGBA_FILESYSTEM_ENABLED
		Import brl.filepath
		Import brl.filesystem
	#End
	
	Import brl.databuffer
	Import brl.stream
	
	Import brl.datastream
	'Import brl.filestream
	
	Import monkey.map
	Import monkey.stack
	
	Import regal.typetool
	
	Import regal.ioutil.endianstream
	Import regal.ioutil.publicdatastream
	
	Import regal.autostream
	
	' Debugging related:
	Import gameengine.def
Public

' Classes:
Class MFDevice Final
	Public
		' Global variable(s):
		
		' The internal resolution.
		Global canvasWidth:Int = MDPhone.SCREEN_WIDTH
		Global canvasHeight:Int = MDPhone.SCREEN_HEIGHT
		
		Global clearBuffer:Bool = True
		
		'Global mainThread:Thread
		
		Global enableTrackBall:Bool = True ' False
		Global shieldInput:Bool = True
	Private
		' Constant variable(s):
		Const VERSION_INFO:String = "104_RELEASE" ' "100_RELEASE" ' "DEBUG"
		
		#If SONICGBA_MFDEVICE_ALLOW_LAYERS
			Const MAX_LAYER:Int = 1
		#Else
			Const MAX_LAYER:Int = 0
		#End
		
		Const PER_VIBRATION_TIME:Int = 500
		
		Const RECORD_NAME:String = "rms"
		
		Global NULL_RECORD:DataBuffer = New DataBuffer(4) ' Const ' Int(0)
		
		' Global variable(s):
		
		' Input related:
		Global deviceKeyValue:Int = 0
		
		Global enableCustomBack:Bool = False
		Global enableVolumeKey:Bool = True ' False
		
		Global componentVector:Stack<MFComponent> ' Vector
		
		Global currentState:MFGameState
		Global nextState:MFGameState
		
		Global currentSystemTime:Long ' Int
		Global drawRect:Rect
		
		Global graphics:MFGraphics
		
		Global interruptConfirm:MFTouchKey
		
		Global inSuspendFlag:Bool
		Global inVibrationFlag:Bool
		
		Global exitFlag:Bool
		
		Global interruptPauseFlag:Bool
		Global logicTrace:Bool
		
		Global lastSystemTime:Long
		
		Global vibraionFlag:Bool
		Global vibrateStartTime:Long
		Global vibrateTime:Int
		'Global vibrator:Vibrator
		
		'Global webPageUrl:String
		
		'Global methodCallTrace:Bool
		
		Global records:StringMap<DataBuffer>
		Global responseInterrupt:Bool
		
		' Graphis:
		Global bufferImage:MFImage
		
		Global postLayer:MFImage[] = New MFImage[MAX_LAYER]
		Global preLayer:MFImage[] = New MFImage[MAX_LAYER]
	Public ' Protected
		' Global variable(s):
		'Global mainRunnable:Runnable = New C00011()
		'Global mainCanvas:MyGameCanvas = New MyGameCanvas(MFMain.getInstance())
		
		' Graphics:
		'Global preScaleShift:Int = 0
		
		'Global preScaleZoomInFlag:Bool = False
		'Global preScaleZoomOutFlag:Bool = False
		
		#If SONICGBA_MFDEVICE_ALLOW_DEBUG_GRAPHICS
			Global __NATIVEGRAPHICS:Canvas = Null
		#End
	Public
		' Functions:
		
		' Extensions:
		Function FixInvalidSymbolsInPath:String(path:String)
			path = path.Replace("#", "_number_")
			
			Return path
		End
		
		Function FixGlobalPath:String(path:String)
			If (path.StartsWith("/")) Then
				' Skip the first slash.
				path = path[1..]
			EndIf
			
			Return FixInvalidSymbolsInPath(path)
		End
		
		Function FixResourcePath:String(path:String)
			'path = FixGlobalPath(path)
			
			If (path.StartsWith("/")) Then
				' Skip the first slash.
				path = path[1..]
			EndIf
			
			If (Not path.StartsWith( "." )) Then ' And Not path.StartsWith( "/" )
				path = ("data/" + path) ' "monkey://data/"
			EndIf
			
			Return FixInvalidSymbolsInPath(path)
		End
		
		Function OpenFileStream:BasicEndianStreamManager(path:String, mode:String, bigEndian:Bool=True) ' Stream ' FileStream ' False
			If (mode = "w") Then
				#If SONICGBA_FILESYSTEM_ENABLED
					If (Not MakeFolderPath(ExtractDir(path))) Then
						Throw New FileNotFoundException(Null, path)
					EndIf
				#End
			EndIf
			
			'Local f:= FileStream.Open(path, mode)
			Local f:= OpenAutoStream(path, mode)
			
			If (f = Null) Then ' mode <> "w"
				Print("Unable to find file: " + path + " {'"+mode+"'}")
				
				'DebugStop()
				
				Throw New FileNotFoundException(f, path) ' Null
			EndIf
			
			Return New BasicEndianStreamManager(f, bigEndian) ' False
		End
		
		Function MakeFolderPath:Bool(folder:String)
			#If SONICGBA_FILESYSTEM_ENABLED
				' Constant variable(s):
				Const Slash:= "/"
				
				' Local variable(s):
				Local initPos:= folder.Find(Slash)
				
				If (initPos <> -1) Then
					Local slashPos:= -1
					
					Repeat
						slashPos = folder.Find(Slash, (slashPos + 1))
						
						If (slashPos <> -1) Then
							If (Not CreateDir(folder[..slashPos])) Then
								Return False
							EndIf
						Else
							If (Not CreateDir(folder[(slashPos + 1)..])) Then
								Return False
							EndIf
							
							Exit
						EndIf
					Forever
					
					Return True
				EndIf
				
				Return CreateDir(folder)
			#Else
				Return False
			#End
		End
		
		Function allocateLayer:MFImage(width:Int, height:Int)
			Return MFImage.createImage(width, height)
		End
		
		Function allocateLayer:MFImage()
			Local width:= canvasWidth ' SCREEN_WIDTH
			Local height:= canvasHeight ' SCREEN_HEIGHT
			 
			Return allocateLayer(width, height)
		End
		
		Function CheckStates:MFGameState()
			' Handle state changes:
			If (nextState <> Null) Then
				If (currentState <> Null) Then
					currentState.onExit()
				EndIf
				
				currentState = nextState
				
				currentState.onEnter()
				
				nextState = Null
			EndIf
			
			Return currentState
		End
		
		Function Update:Void()
			handleInput()
			
			''' Update (Input) components:
			#Rem
			For Local component:= EachIn componentVector 
				component.tick()
			Next
			#End
			
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
			
			CheckStates()
			
			If (Not interruptPauseFlag) Then
				currentState.onTick()
			EndIf
			
			'''MFGamePad.keyTick()
		End
		
		' This performs a raw render of the game without displaying
		' layers or flushing draw operations to the GPU.
		Function Render:Void(graphics:MFGraphics) ' Canvas ' Graphics
			graphics.reset()
			
			If (Not interruptPauseFlag) Then
				If (Not exitFlag) Then
					For Local i:= preLayer.Length Until 0 Step -1 ' MAX_LAYER ' To 0
						Local layer:= preLayer[i - 1]
						
						If (layer <> Null) Then
							Local g:= layer.getGraphics()
							
							g.reset() ' layer.getWidth(), layer.getHeight()
							
							currentState.onRender(g, -i)
						EndIf
					Next
					
					currentState.onRender(graphics)
					
					For Local i:= postLayer.Length To postLayer.Length ' MAX_LAYER
						Local layer:= postLayer[i - MAX_LAYER]
						
						If (layer <> Null) Then
							Local g:= layer.getGraphics()
							
							g.reset() ' layer.getWidth(), layer.getHeight()
							
							currentState.onRender(g, i)
						EndIf
					Next
				EndIf
			EndIf
		End
		
		' The 'screen' argument represents the device's screen/canvas.
		' The 'graphics' argument represents the primary layer used to render the game.
		' If unsure, use the other overload. (Automatically establishes a primary layer)
		Function deviceDraw:Void(screen:Canvas, graphics:MFGraphics, vx:Float, vy:Float, vw:Float, vh:Float) ' Canvas ' Graphics
			' For debugging purposes, we are scheduling this draw operation in advance.
			' Draw the main graphics layer to the screen. (Game graphics, etc)
			screen.DrawRect(vx, vy, vw, vh, bufferImage.getNativeImage())
			
			' Testing related:
			'screen.SetAlpha(0.5)
			'screen.DrawImage(bufferImage.getNativeImage(), screen.Width / 2, screen.Height, 0.0, 1.0, -1.0)
			'screen.SetAlpha(1.0)
			
			MFDevice.Render(graphics)
			
			' Execute the draw operations queued on the background layer(s):
			For Local i:= preLayer.Length Until 0 Step -1 ' MAX_LAYER ' To 0
				Local layer:= preLayer[i - preLayer.Length]
				
				If (layer <> Null) Then
					' Execute commands to this layer.
					layer.getGraphics().flush()
					
					' Draw this background layer to the screen.
					screen.DrawRect(vx, vy, vw, vh, layer.getNativeImage())
				EndIf
			Next
			
			' Debugging related:
			'graphics.context.SetColor(0.8, 0.0, 0.0, 0.5)
			'graphics.context.DrawRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			'graphics.context.SetColor(1.0, 1.0, 1.0)
			
			' Execute the draw operations queued up for the main graphics layer.
			graphics.flush()
			
			' Execute the draw operations queued on the foreground layer(s):
			For Local i:= postLayer.Length To postLayer.Length ' Until 0 Step -1 ' MAX_LAYER
				Local layer:= postLayer[i - MAX_LAYER]
				
				If (layer <> Null) Then
					' Execute commands to this layer.
					layer.getGraphics().flush()
					
					' Draw this foreground/post layer to the screen.
					screen.DrawRect(vx, vy, vw, vh, layer.getNativeImage())
				EndIf
			Next
		End
		
		' This overload calls the main implementation, but instead of leaving
		' it up to the user, this passes 'graphics' as the primary layer.
		Function deviceDraw:Void(screen:Canvas, vx:Float, vy:Float, vw:Float, vh:Float) ' Canvas ' Graphics
			deviceDraw(screen, graphics, vx, vy, vw, vh)
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
			x = ((x - drawRect.left) * canvasWidth) / drawRect.width()
			y = ((y - drawRect.top) * canvasHeight) / drawRect.height()
			
			If (componentVector <> Null) Then
				For Local component:= EachIn componentVector
					component.pointerDragged(id, x, y)
				Next
			EndIf
		End
		
		Function pointerPressed:Void(id:Int, x:Int, y:Int)
			x = ((x - drawRect.left) * canvasWidth) / drawRect.width()
			y = ((y - drawRect.top) * canvasHeight) / drawRect.height()
			
			If (componentVector <> Null) Then
				For Local component:= EachIn componentVector
					component.pointerPressed(id, x, y)
				Next
			EndIf
		End
		
		Function pointerReleased:Void(id:Int, x:Int, y:Int)
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
			For Local i:= preLayer.Length Until 0 Step -1 ' MAX_LAYER ' To 0
				Local revIndex:= (i - MAX_LAYER) ' preLayerImage.Length
				Local img:= preLayer[revIndex]
				
				If (img <> Null) Then
					'img.earseColor(0)
					
					img.getGraphics().clear()
				EndIf
			Next
			
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
		
		Function getDeviceWidth:Int()
			Return canvasWidth ' SCREEN_WIDTH ' screenWidth
		End
		
		Function getDeviceHeight:Int()
			Return canvasHeight ' SCREEN_HEIGHT ' screenHeight
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
			Return (bufferHeight + verticvalOffset)
		End
		
		Function getNativeCanvasHeight:Int()
			Return bufferHeight
		End
		
		Function getNativeCanvasLeft:Int()
			Return -horizontalOffset
		End
		
		Function getNativeCanvasRight:Int()
			Return (bufferWidth + horizontalOffset)
		End
		
		Function getNativeCanvasTop:Int()
			Return -verticvalOffset
		End
		
		Function getNativeCanvasWidth:Int()
			Return bufferWidth
		End
		
		Function getPackageVersion:String()
			#Rem
			Local version:String = ""
			
			Return MFMain.getInstance().getPackageManager().getPackageInfo(MFMain.getInstance().getPackageName(), 0).versionName
			#End
			
			Return getVersion() ' VERSION_INFO
		End
		
		Function getResourceAsStream:Stream(url:String, bigEndian:Bool=True)
			Try
				Print("Attempting to load from URL: " + url)
				
				'Local assets:AssetManager = MFMain.getInstance().getAssets()
				
				url = FixResourcePath(url)
				
				'ret = assets.open(substring)
				
				Local f:= OpenFileStream(url, "r", bigEndian)
				
				Return f
			Catch E:StreamError
				Print("Error on loading: " + url)
			End Try
			
			Return Null
		End
		
		Function getScreenWidth:Int()
			Return canvasWidth
		End
		
		Function getScreenHeight:Int()
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
		
		Function initRecords:Void(force:Bool=False, bigEndian:Bool=True) ' False
			Try
				If (Not force And records <> Null) Then
					Return
				EndIf
				
				records = New StringMap<DataBuffer>()
				
				Local dis:= New EndianStreamManager<DataStream>(New DataStream(openRecordStore(RECORD_NAME)), bigEndian) ' Flase
				
				Local recordStoreNumber:= dis.ReadInt()
				
				For Local i:= 0 Until recordStoreNumber
					Local nameLen:= dis.ReadShort()
					Local name:String = dis.ReadString(nameLen, "utf8") ' "ascii"
					Local record:= readRecord(dis)
					
					records.Set(name, record)
				Next
			Catch E:StreamError ' Throwable
				' Nothing so far.
			End Try
		End
		
		Function updateRecords:Void()
			' Constant variable(s):
			Const DEFAULT_FILE_SIZE:= 1024 ' Bytes.
			
			' Local variable(s):
			Local dos:= New PublicDataStream(DEFAULT_FILE_SIZE, True) ' False
			
			dos.WriteInt(records.Count())
			
			For Local rNode:= EachIn records
				Local name:= rNode.Key
				Local record:= rNode.Value
				
				Local nameLen:= name.Length
				
				dos.WriteShort(HToNS(nameLen))
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
		
		' Extensions:
		Function initializeScreen:MFGraphics(context:Canvas)
			' This may be replaced later with another 'Canvas' targeting the same thing as 'context':
			bufferImage = allocateLayer()
			
			graphics = bufferImage.getGraphics()
			
			Return graphics
		End
		
		' Record-related:
		Function loadRecord:DataBuffer(recordName:String)
			Return records.Get(recordName)
		End
		
		' Notifications:
		Function notifyStart:Void(context:Canvas, startState:MFGameState) ' Graphics
			'If (mainThread = Null) Then
			
			changeState(startState)
			
			CheckStates()
			
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
					preLayer[(-layer) - MAX_LAYER] = allocateLayer() ' (screenWidth, screenHeight)
				EndIf
			ElseIf (postLayer[layer - MAX_LAYER] = Null) Then
				postLayer[layer - MAX_LAYER] = allocateLayer() ' (screenWidth, screenHeight)
			EndIf
		End
		
		Function disableLayer:Void(layer:Int)
			If (layer > 0 And layer <= MAX_LAYER) Then
				postLayer[layer - MAX_LAYER].discard()
				postLayer[layer - MAX_LAYER] = Null
			ElseIf (layer < 0 And layer >= -MAX_LAYER) Then
				preLayer[(-layer) - MAX_LAYER].discard()
				preLayer[(-layer) - MAX_LAYER] = Null
			EndIf
		End
		
		Function setFilterBitmap:Void(b:Bool)
			'mainCanvas.setFilterBitmap(b)
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