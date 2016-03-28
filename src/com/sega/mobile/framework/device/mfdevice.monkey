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
	Import brl.datastream
	
	Import monkey.map
	Import monkey.stack
	
	Import regal.typetool
Public

' Classes:
Class MFDevice Final
	Public
		' Constant variable(s):
		Const APN_CMNET:Int = 2
		Const APN_CMWAP:Int = 1
		Const APN_NONE:Int = 0
		
		Const SIM_CMCC:Int = 1
		Const SIM_NONE:Int = 0
		Const SIM_TELECOM:Int = 3
		Const SIM_UNICOM:Int = 2
		
		' Global variable(s):
		Global bufferHeight:Int
		Global bufferWidth:Int
		Global canvasHeight:Int
		Global canvasWidth:Int
		Global clearBuffer:Bool
		Global enableTrackBall:Bool
		Global horizontalOffset:Int
		
		Global mainThread:Thread
		
		Global screenHeight:Int
		Global screenWidth:Int
		Global shieldInput:Bool
	
		Global verticvalOffset:Int
	Private
		' Constant variable(s):
		Const VERSION_INFO:String = "104_RELEASE"
		Const MAX_LAYER:Int = 1
		Const PER_VIBRATION_TIME:Int = 500
		Const RECORD_NAME:String = "rms"
		
		Global NULL_RECORD:Byte[] ' Const
		
		' Global variable(s):
		Global apnType:Int
		Global bufferImage:Image
		Global componentVector:Stack<MFComponent> ' Vector
		Global currentState:MFGameState
		Global currentSystemTime:Long
		Global deviceKeyValue:Int
		Global drawRect:Rect
		Global enableCustomBack:Bool
		Global enableVolumeKey:Bool
		Global exitFlag:Bool
		Global graphics:MFGraphics
		
		Global inSuspendFlag:Bool
		Global inVibrationFlag:Bool
		'Global interruptConfirm:MFTouchKey
		Global interruptPauseFlag:Bool
		Global lastSystemTime:Long
		Global logicTrace:Bool
		
		Global vibraionFlag:Bool
		Global vibrateStartTime:Long
		Global vibrateTime:Int
		Global vibrator:Vibrator
		Global webPageUrl:String
		
		Global methodCallTrace:Bool
		Global nextState:MFGameState
		Global postLayerGraphics:MFGraphics[]
		Global postLayerImage:Image[]
		Global preLayerGraphics:MFGraphics[]
		Global preLayerImage:Image[]
		
		Global records:StringMap<Byte[]>
		
		Global responseInterrupt:Bool
		
		Global simType:Int
	Protected
		' Global variable(s):
		Global mainCanvas:MyGameCanvas
		Global mainRunnable:Runnable
		
		Global preScaleShift:Int
		Global preScaleZoomInFlag:Bool
		Global preScaleZoomOutFlag:Bool
	Public
		' Functions:
		Function deviceDraw:Void(g:Graphics)
			' Magic numbers: 1, -1, etc.
			For Local i:= 1 Until 0 Step -1
				If (MFDevice.preLayerImage[i - 1] <> Null) Then
					g.drawImage(MFDevice.preLayerImage[i - 1], 0, 0, 0)
				EndIf
			Next
			
			If (MFDevice.bufferImage <> Null) Then
				g.drawScreen(MFDevice.bufferImage, Null, New Rect(0, 0, MFDevice.screenWidth, MFDevice.screenHeight))
			EndIf
			
			For Local i:= 1 To 1
				If (MFDevice.postLayerImage[i - 1] <> Null) Then
					g.drawImage(MFDevice.postLayerImage[i - 1], 0, 0, 0)
				EndIf
			Next
		End
		
		Function handleInput:Void()
			' Constant variable(s):
			Const START_MOUSE_INDEX:= MOUSE_LEFT
			Const LAST_MOUSE_INDEX:= MOUSE_MIDDLE
			
			Const START_KEY_INDEX:= 0
			Const LAST_KEY_INDEX:= 254 ' 255
			
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

	static {
		NULL_RECORD = New Byte[4]
		apnType = -1
		simType = -1
		shieldInput = True
		clearBuffer = True
		preLayerImage = New Image[SIM_CMCC]
		preLayerGraphics = New MFGraphics[SIM_CMCC]
		postLayerImage = New Image[SIM_CMCC]
		postLayerGraphics = New MFGraphics[SIM_CMCC]
		deviceKeyValue = SIM_NONE
		enableCustomBack = False
		enableTrackBall = True
		enableVolumeKey = True
		preScaleShift = SIM_NONE
		preScaleZoomInFlag = False
		preScaleZoomOutFlag = False
		mainCanvas = New MyGameCanvas(MFMain.getInstance())
		mainRunnable = New C00011()
	}

	Public Function addComponent:Void(component:MFComponent) Final
		
		If (componentVector <> Null And Not componentVector.contains(component)) Then
			component.reset()
			componentVector.addElement(component)
		EndIf
		
	}

	Public Function changeState:Void(gameState:MFGameState)
		nextState = gameState
	}

	Public Function clearScreen:Void() Final
		Int i
		For (i = SIM_CMCC; i > 0; i -= 1)
			
			If (preLayerImage[i - SIM_CMCC] <> Null) Then
				preLayerImage[i - SIM_CMCC].earseColor(SIM_NONE)
			EndIf
			
		Next
		
		If (bufferImage <> Null) Then
			bufferImage.earseColor(SIM_NONE)
		EndIf
		
		For (i = SIM_CMCC; i <= SIM_CMCC; i += SIM_CMCC)
			
			If (postLayerImage[i - SIM_CMCC] <> Null) Then
				postLayerImage[i - SIM_CMCC].earseColor(SIM_NONE)
			EndIf
			
		Next
	}

	Public Function currentTimeMillis:Long()
		Return System.currentTimeMillis()
	}

	Public Function DEBUG_ENABLE_LOGIC_TRACE:Void(enable:Bool) Final
	}

	Public Function DEBUG_ENABLE_METHOD_TRACE:Void(enable:Bool) Final
	}

	Public Function DEBUG_GET_DEVICE_KEY_VALUE:Int()
		Return SIM_NONE
	}

	Public Function DEBUG_PAINT_LOGIC_TRACE:Void(traceLog:String) Final
	}

	Public Function DEBUG_PAINT_MESSAGE:Void(message:String) Final
	}

	Public Function DEBUG_PAINT_METHOD_TRACE:Void(methodInfo:String) Final
	}

	Public Function DEBUG_SHOW_ERROR:Void(t:Throwable) Final
	}

	Public Function deleteRecord:Void(recordName:String) Final
		records.remove(recordName)
		updateRecords()
	}

	Public Function disableExceedBoundary:Void()
		graphics.disableExceedBoundary()
	}

	Public Function enableExceedBoundary:Void()
		graphics.enableExceedBoundary()
	}

	Public Function getApnType:Int()
		apnType = SIM_NONE
		Cursor cr = MFMain.getInstance().getContentResolver().query(Uri.parse("content://telephony/carriers/preferapn"), Null, Null, Null, Null)
		String pxy = ""
		While (cr <> Null And cr.moveToNext()) {
			pxy = cr.getString(cr.getColumnIndex("proxy"))
		}
		
		If (Not (pxy = Null Or pxy.equals(""))) Then
			apnType = SIM_CMCC
		EndIf
		
		Return apnType
	}

	Public Function getDeviceHeight:Int() Final
		Return screenHeight
	}

	Public Function getDeviceWidth:Int() Final
		Return screenWidth
	}

	Public Function getEnableCustomBack:Bool()
		Return enableCustomBack
	}

	Public Function getEnableTrackBall:Bool()
		Return enableTrackBall
	}

	Public Function getEnableVolumeKey:Bool()
		Return enableVolumeKey
	}

	Public Function getGraphics:MFGraphics()
		Return graphics
	}

	Public Function getMainThread:Thread()
		Return mainThread
	}

	Public Function getNativeCanvasBottom:Int()
		
		If (preScaleZoomOutFlag) Then
			Return (bufferHeight - verticvalOffset) Shl preScaleShift
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return (bufferHeight - verticvalOffset) Shr preScaleShift
		EndIf
		
		Return bufferHeight + verticvalOffset
	}

	Public Function getNativeCanvasHeight:Int()
		
		If (preScaleZoomOutFlag) Then
			Return bufferHeight Shl preScaleShift
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return bufferHeight Shr preScaleShift
		EndIf
		
		Return bufferHeight
	}

	Public Function getNativeCanvasLeft:Int()
		
		If (preScaleZoomOutFlag) Then
			Return -(horizontalOffset Shl preScaleShift)
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return -(horizontalOffset Shr preScaleShift)
		EndIf
		
		Return -horizontalOffset
	}

	Public Function getNativeCanvasRight:Int()
		
		If (preScaleZoomOutFlag) Then
			Return (bufferWidth - horizontalOffset) Shl preScaleShift
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return (bufferWidth - horizontalOffset) Shr preScaleShift
		EndIf
		
		Return bufferWidth + horizontalOffset
	}

	Public Function getNativeCanvasTop:Int()
		
		If (preScaleZoomOutFlag) Then
			Return -(verticvalOffset Shl preScaleShift)
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return -(verticvalOffset Shr preScaleShift)
		EndIf
		
		Return -verticvalOffset
	}

	Public Function getNativeCanvasWidth:Int()
		
		If (preScaleZoomOutFlag) Then
			Return bufferWidth Shl preScaleShift
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return bufferWidth Shr preScaleShift
		EndIf
		
		Return bufferWidth
	}

	Public Function getPackageVersion:String()
		String version = ""
		try {
			Return MFMain.getInstance().getPackageManager().getPackageInfo(MFMain.getInstance().getPackageName(), SIM_NONE).versionName
		} catch (NameNotFoundException e) {
			e.printStackTrace()
			Return version
		}
	}

	Public Function getResourceAsMFStream:MFInputStream(url:String) Final
		try {
			String substring
			AssetManager assets = MFMain.getInstance().getAssets()
			
			If (url.startsWith("/")) Then
				substring = url.substring(SIM_CMCC)
			Else
				substring = url
			EndIf
			
			Return New MFInputStream(assets.open(substring))
		} catch (Exception e) {
			Print("Error on loading: " + url)
			Return Null
		}
	}

	Public Function getResourceAsStream:InputStream(url:String) Final
		InputStream ret = Null
		try {
			String substring
			AssetManager assets = MFMain.getInstance().getAssets()
			
			If (url.startsWith("/")) Then
				substring = url.substring(SIM_CMCC)
			Else
				substring = url
			EndIf
			
			ret = assets.open(substring)
		} catch (Exception e) {
			Print("Error on loading: " + url)
		}
		Return ret
	}

	Public Function getScreenHeight:Int() Final
		
		If (preScaleZoomOutFlag) Then
			Return canvasHeight Shl preScaleShift
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return canvasHeight Shr preScaleShift
		EndIf
		
		Return canvasHeight
	}

	Public Function getScreenWidth:Int() Final
		
		If (preScaleZoomOutFlag) Then
			Return canvasWidth Shl preScaleShift
		EndIf
		
		If (preScaleZoomInFlag) Then
			Return canvasWidth Shr preScaleShift
		EndIf
		
		Return canvasWidth
	}

	Public Function getSimType:Int()
		
		If (simType < 0) Then
			simType = SIM_NONE
			String operator = ((TelephonyManager) MFMain.getInstance().getSystemService("phone")).getSimOperator()
			
			If (operator.equals("46000") Or operator.equals("46002")) Then
				simType = SIM_CMCC
			ElseIf (operator.equals("46001")) Then
				simType = SIM_UNICOM
			ElseIf (operator.equals("46003")) Then
				simType = SIM_TELECOM
			EndIf
		EndIf
		
		Return simType
	}

	Public Function getSystemDisplayable:Object() Final
		Return mainCanvas
	}

	Public Function getVersion:String() Final
		Return VERSION_INFO
	}

	Private Function initRecords:Void() Final
		Exception e
		
		If (records = Null) Then
			records = New Hashtable()
			DataInputStream dis = Null
			ByteArrayInputStream bis = Null
			try {
				ByteArrayInputStream bis2 = New ByteArrayInputStream(openRecordStore(RECORD_NAME))
				try {
					DataInputStream dis2 = New DataInputStream(bis2)
					try {
						Int recordStoreNumber = dis2.readInt()
						For (Int i = SIM_NONE; i < recordStoreNumber; i += SIM_CMCC)
							String name = dis2.readUTF()
							Int offset = SIM_NONE
							Int dataSize = dis2.readInt()
							Byte[] data = New Byte[dataSize]
							do {
								offset = dis2.read(data, offset, dataSize - offset)
							} While (offset < dataSize)
							records.put(name, data)
						Next
						bis = bis2
						dis = dis2
					} catch (Exception e2) {
						e = e2
						bis = bis2
						dis = dis2
					}
				} catch (Exception e22) {
					e = e22
					bis = bis2
					e.printStackTrace()
					dis.close()
					bis.close()
				}
			} catch (Exception e222) {
				e = e222
				e.printStackTrace()
				dis.close()
				bis.close()
			}
			try {
				dis.close()
			} catch (Exception e3) {
			}
			try {
				bis.close()
			} catch (Exception e4) {
			}
		EndIf
		
	}

	Public Function loadRecord:Byte[](recordName:String) Final
		Return (Byte[]) records.get(recordName)
	}

	Public Function notifyExit:Void() Final
		exitFlag = True
	}

	Public Function notifyPause:Void() Final
		synchronized (mainRunnable) {
			
			If (responseInterrupt And Not interruptPauseFlag) Then
				stopVibrate()
				MFGamePad.resetKeys()
				MFSound.deviceInterrupt()
				
				If (currentState <> Null) Then
					currentState.onPause()
				EndIf
				
				interruptPauseFlag = True
				
				If (componentVector <> Null) Then
					For (Int i = SIM_NONE; i < componentVector.size(); i += SIM_CMCC)
						((MFComponent) componentVector.elementAt(i)).reset()
					Next
					interruptConfirm = New MFTouchKey(SIM_NONE, canvasHeight - 50, 100, 50, Boss4Ice.DRAW_OFFSET_Y)
					addComponent(interruptConfirm)
				EndIf
			EndIf
			
		}
	}

	Public Function notifyResume:Void() Final
		synchronized (mainRunnable) {
			
			If (responseInterrupt And interruptPauseFlag) Then
				MFGamePad.resetKeys()
				MFSound.deviceResume()
				
				If (currentState <> Null) Then
					currentState.onResume()
				EndIf
				
				interruptPauseFlag = False
				
				If (componentVector <> Null) Then
					For (Int i = SIM_NONE; i < componentVector.size(); i += SIM_CMCC)
						((MFComponent) componentVector.elementAt(i)).reset()
					Next
					removeComponent(interruptConfirm)
				EndIf
			EndIf
			
		}
	}

	Public Function notifyStart:Void(width:Int, height:Int) Final
		
		If (mainThread = Null) Then
			If (MFMain.getInstance().getRequestedOrientation() = SIM_CMCC) Then
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

	Private Function openRecordStore:Byte[](str:String)
		FileNotFoundException fileNotFoundException
		DataOutputStream dos
		Byte[] ret = Null
		try {
			DataInputStream dis = New DataInputStream(MFMain.getInstance().openFileInput(New StringBuilder(String.valueOf(str)).append(".rms").toString()))
			try {
				Int t = dis.readInt()
				
				If (t = 0) Then
					ret = NULL_RECORD
				Else
					ret = New Byte[t]
					For (Int i = SIM_NONE; i < ret.length; i += SIM_CMCC)
						ret[i] = dis.readByte()
					Next
				EndIf
				
				dis.close()
				DataInputStream dataInputStream = dis
			} catch (FileNotFoundException e) {
				fileNotFoundException = e
				dataInputStream = dis
				try {
					Print("Create New save file.")
					ret = NULL_RECORD
					dos = New DataOutputStream(MFMain.getInstance().openFileOutput(New StringBuilder(String.valueOf(str)).append(".rms").toString(), SIM_NONE))
					dos.write(NULL_RECORD, SIM_NONE, NULL_RECORD.length)
					dos.flush()
					dos.close()
				} catch (IOException e2) {
					IOException ex = e2
					Print("RMS ERROR : Can't create rms file.")
				}
				Return ret
			} catch (IOException e22) {
				r4 = e22
				dataInputStream = dis
				Print("RMS ERROR : Can't read rms file.")
				Return ret
			}
		} catch (FileNotFoundException e3) {
			fileNotFoundException = e3
			Print("Create New save file.")
			ret = NULL_RECORD
			dos = New DataOutputStream(MFMain.getInstance().openFileOutput(New StringBuilder(String.valueOf(str)).append(".rms").toString(), SIM_NONE))
			dos.write(NULL_RECORD, SIM_NONE, NULL_RECORD.length)
			dos.flush()
			dos.close()
			Return ret
		} catch (IOException e222) {
			IOException iOException
			iOException = e222
			Print("RMS ERROR : Can't read rms file.")
			Return ret
		}
		Return ret
	}

	Public Function openUrl:Void() Final
		
		If (webPageUrl <> Null) Then
			try {
				MFMain.getInstance().platformRequest(webPageUrl)
			} catch (Exception e) {
				e.printStackTrace()
			}
		EndIf
		
	}

	Public Function openUrl:Void(url:String, needClose:Bool) Final
		
		If (needClose) Then
			webPageUrl = url
			notifyExit()
			Return
		EndIf
		
		try {
			MFMain.getInstance().platformRequest(url)
		} catch (Exception e) {
			e.printStackTrace()
		}
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
		
		If (layer <= 0 Or layer > SIM_CMCC) Then
			If (layer < 0 And layer >= -1 And preLayerImage[(-layer) - SIM_CMCC] = Null) Then
				preLayerImage[(-layer) - SIM_CMCC] = Image.createImage(screenWidth, screenHeight)
				preLayerGraphics[(-layer) - SIM_CMCC] = MFGraphics.createMFGraphics(preLayerImage[(-layer) - SIM_CMCC].getGraphics(), screenWidth, screenHeight)
			EndIf
			
		ElseIf (postLayerImage[layer - SIM_CMCC] = Null) Then
			postLayerImage[layer - SIM_CMCC] = Image.createImage(screenWidth, screenHeight)
			postLayerGraphics[layer - SIM_CMCC] = MFGraphics.createMFGraphics(postLayerImage[layer - SIM_CMCC].getGraphics(), screenWidth, screenHeight)
		EndIf
		
	}

	Public Function disableLayer:Void(layer:Int)
		
		If (layer > 0 And layer <= SIM_CMCC) Then
			postLayerImage[layer - SIM_CMCC] = Null
			postLayerGraphics[layer - SIM_CMCC] = Null
		ElseIf (layer < 0 And layer >= -1) Then
			preLayerImage[(-layer) - SIM_CMCC] = Null
			preLayerGraphics[(-layer) - SIM_CMCC] = Null
		EndIf
		
	}

	Public Function setFilterBitmap:Void(b:Bool)
		mainCanvas.setFilterBitmap(b)
	}

	Public Function setFullscreenMode:Void(b:Bool)
		
		If (b) Then
			drawRect = New Rect(SIM_NONE, SIM_NONE, screenWidth, screenHeight)
		ElseIf (((Float) screenWidth) / ((Float) canvasWidth) > ((Float) screenHeight) / ((Float) canvasHeight)) Then
			Int tmpHeight
			
			If (preScaleZoomOutFlag And canvasHeight > screenHeight) Then
				preScaleShift = SIM_NONE
				tmpHeight = canvasHeight
				While (tmpHeight > screenHeight And tmpHeight - screenHeight > screenHeight - (tmpHeight / SIM_UNICOM)) {
					tmpHeight /= SIM_UNICOM
					canvasWidth /= SIM_UNICOM
					canvasHeight /= SIM_UNICOM
					preScaleShift += SIM_CMCC
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomOutFlag = False
				EndIf
				
				preScaleZoomInFlag = False
			EndIf
			
			If (preScaleZoomInFlag And canvasHeight < screenHeight) Then
				preScaleShift = SIM_NONE
				tmpHeight = canvasHeight
				While (tmpHeight < screenHeight And screenHeight - tmpHeight > (tmpHeight * SIM_UNICOM) - screenHeight) {
					tmpHeight *= SIM_UNICOM
					canvasWidth *= SIM_UNICOM
					canvasHeight *= SIM_UNICOM
					preScaleShift += SIM_CMCC
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomInFlag = False
				EndIf
				
				preScaleZoomOutFlag = False
			EndIf
			
			h = screenHeight
			w = (canvasWidth * h) / canvasHeight
			Int x = (screenWidth - w) / SIM_UNICOM
			drawRect = New Rect(x, SIM_NONE, x + w, SIM_NONE + h)
			
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
				preScaleShift = SIM_NONE
				tmpWidth = canvasWidth
				While (tmpWidth > screenWidth And ((Float) tmpWidth) - ((Float) screenWidth) > ((Float) (screenWidth - (tmpWidth / SIM_UNICOM)))) {
					tmpWidth /= SIM_UNICOM
					canvasWidth /= SIM_UNICOM
					canvasHeight /= SIM_UNICOM
					preScaleShift += SIM_CMCC
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomOutFlag = False
				EndIf
				
				preScaleZoomInFlag = False
			EndIf
			
			If (preScaleZoomInFlag And canvasWidth < screenWidth) Then
				preScaleShift = SIM_NONE
				tmpWidth = canvasWidth
				While (tmpWidth < screenWidth And screenWidth - tmpWidth < (tmpWidth * SIM_UNICOM) - screenWidth) {
					tmpWidth *= SIM_UNICOM
					canvasWidth *= SIM_UNICOM
					canvasHeight *= SIM_UNICOM
					preScaleShift += SIM_CMCC
				}
				
				If (preScaleShift = 0) Then
					preScaleZoomInFlag = False
				EndIf
				
				preScaleZoomOutFlag = False
			EndIf
			
			w = screenWidth
			h = (canvasHeight * w) / canvasWidth
			Int y = (screenHeight - h) / SIM_UNICOM
			drawRect = New Rect(SIM_NONE, y, SIM_NONE + w, y + h)
			
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

	Private Function setRecord:Void(str:String, data:Byte[], len:Int)
		try {
			DataOutputStream dos = New DataOutputStream(MFMain.getInstance().openFileOutput(New StringBuilder(String.valueOf(str)).append(".rms").toString(), SIM_NONE))
			dos.writeInt(len)
			For (Int i = SIM_NONE; i < len; i += SIM_CMCC)
				dos.writeByte(data[i])
			Next
			dos.flush()
			dos.close()
		} catch (Exception e) {
			Print("RMS ERROR : Can't save rms file.")
		}
	}

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

	Private Function updateRecords:Void() Final
		Exception e
		DataOutputStream out = Null
		ByteArrayOutputStream bos = Null
		try {
			ByteArrayOutputStream bos2 = New ByteArrayOutputStream()
			try {
				DataOutputStream out2 = New DataOutputStream(bos2)
				try {
					Byte[] tmp
					out2.writeInt(records.size())
					Enumeration<String> e2 = records.keys()
					For (Int i = SIM_NONE; i < records.size(); i += SIM_CMCC)
						String name = (String) e2.nextElement()
						tmp = (Byte[]) records.get(name)
						out2.writeUTF(name)
						out2.writeInt(tmp.length)
						out2.write(tmp)
					Next
					out2.flush()
					tmp = bos2.toByteArray()
					setRecord(RECORD_NAME, tmp, tmp.length)
					bos = bos2
					out = out2
				} catch (Exception e3) {
					e = e3
					bos = bos2
					out = out2
				}
			} catch (Exception e32) {
				e = e32
				bos = bos2
				e.printStackTrace()
				out.close()
				bos.close()
			}
		} catch (Exception e322) {
			e = e322
			e.printStackTrace()
			out.close()
			bos.close()
		}
		try {
			out.close()
		} catch (Exception e4) {
		}
		try {
			bos.close()
		} catch (Exception e5) {
		}
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
					For (i = MFDevice.SIM_NONE; i < MFDevice.componentVector.size(); i += MFDevice.SIM_CMCC)
						((MFComponent) MFDevice.componentVector.elementAt(i)).tick()
					Next
				}
				MFSound.tick()
				
				If (MFDevice.vibraionFlag) Then
					If (MFDevice.vibrateTime > 0 And System.currentTimeMillis() - MFDevice.vibrateStartTime > ((Long) MFDevice.vibrateTime)) Then
						MFDevice.vibrateTime = MFDevice.SIM_NONE
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
						For (i = MFDevice.SIM_CMCC; i > 0; i -= 1)
							
							If (MFDevice.preLayerGraphics[i - MFDevice.SIM_CMCC] <> Null) Then
								MFDevice.currentState.onRender(MFDevice.preLayerGraphics[i - MFDevice.SIM_CMCC], -i)
							EndIf
							
						Next
						MFDevice.currentState.onRender(MFDevice.graphics)
						For (i = MFDevice.SIM_CMCC; i <= MFDevice.SIM_CMCC; i += MFDevice.SIM_CMCC)
							
							If (MFDevice.postLayerGraphics[i - MFDevice.SIM_CMCC] <> Null) Then
								MFDevice.currentState.onRender(MFDevice.postLayerGraphics[i - MFDevice.SIM_CMCC], i)
							EndIf
							
						Next
					EndIf
				EndIf
				
				MFDevice.mainCanvas.repaint()
			EndIf
			
		End
	}
#End