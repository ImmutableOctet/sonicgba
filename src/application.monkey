Strict

Public

' Preprocessor related:
#ALLOW_FORCE_EXIT = False ' True

' Imports:
Private
	Import mflib.mainstate
	Import state.state
	
	Import sonicgba.effect
	'Import sonicgba.globalresource
	
	Import com.sega.mobile.framework.mfgamestate
	'Import com.sega.mobile.framework.mfmain
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	
	'Import com.sega.mobile.framework.android.graphics
	
	#Rem
		Import javax.crypto.Cipher
		Import javax.crypto.spec.IvParameterSpec
		Import javax.crypto.spec.SecretKeySpec
		
		Import android.app.dialog
		Import android.content.Context
		Import android.os.handler
		Import android.os.message
		Import android.telephony.telephonymanager
		Import android.view.keyevent
	#End
	
	'Import month.monthcertificationstate
	
	Import mojo.app
	
	'Import mojo2.graphics
	
	#If TARGET = "glfw"
		Import brl.requesters
	#End
	
	Import monkey.random
Public

' Functions:
#If TARGET <> "glfw"
	Function Confirm:Bool(title:String, text:String, serious:Bool=False)
		Return True ' False
	End
#End

' Classes:
Class Application Extends App ' Main Extends MFMain
	Public
		' Global variable(s):
		Global BULLET_TIME:Bool = False
		'Global MONTH_CHECK:Bool = False
		
		' Fields:
		'Field context:Context
		'Field handler:Handler
		
		Field isResumeFromOtherActivity:Bool
		Field resumeFromOtherActivityFlag:Bool
		
		'Field segaMoreUrl:String
	Private
		' Fields:
		
		'Field encryptionSubID:String
		'Field esubid:String
		
		Field mScore:String
		Field mScoreStr:String
		
		'Field tMgr:TelephonyManager
		
		' Extensions / Replacements:
		'Field graphics:Graphics
		Field graphics:Canvas
		
		' Letterbox parameters:
		Field screenX:Float, screenY:Float
		Field screenWidth:Float, screenHeight:Float
		
		' Booleans / Flags:
		Field isSuspended:Bool
	Public
		' Methods:
		Method OnCreate:Int()
			SetUpdateRate(30) ' 15 ' 20 ' 16 ' 30 ' 0 ' 60
			
			Seed = Millisecs()
			
			graphics = New Canvas(Null)
			
			#If SONICGBA_MFDEVICE_ALLOW_DEBUG_GRAPHICS
				MFDevice.__NATIVEGRAPHICS = graphics
			#End
			
			#Rem
				Self.mScore = ""
				Self.mScoreStr = ""
				Self.handler = New C00001()
			#End
			
			' Extensions:
			isSuspended = False
			
			' Initialize the framework.
			InitializeMobileFramework()
			
			' Initialize the global "effect array".
			Effect.effectArray = Effect.GenerateEffectArray()
			
			Local devWidth:= DeviceWidth()
			Local devHeight:= DeviceHeight()
			
			Local width:= Max(GBA_WIDTH, (devWidth * GBA_HEIGHT) / devHeight)
			Local height:= GBA_HEIGHT
			
			width = Min(width, GBA_EXT_WIDTH)
			
			MFDevice.setCanvasSize(width, height)
			MFDevice.setEnableCustomBack(True)
			
			MFDevice.initializeScreen(graphics)
			
			MFDevice.notifyStart(graphics, getEntryGameState())
			
			UpdateLetterBox(devWidth, devHeight, width, height) ' (SCREEN_WIDTH, SCREEN_HEIGHT)
			
			'OnResize()
			
			Return 0
		End
		
		Method OnUpdate:Int()
			OnResize()
			
			HandleSystemKeys()
			
			MFDevice.Update()
			
			'RenderGame()
			
			#If ALLOW_FORCE_EXIT
				If (MFDevice.exitFlag) Then
					Return OnClose()
				EndIf
			#End
			
			Return 0
		End
		
		Method OnRender:Int()
			RenderGame()
			
			Return 0
		End
		
		Method OnClose:Int()
			' applicationName, message, acceptText, declineText
			'setExitConfirmStr("ソニックアドバンス", "ゲームを終了しますか？", "はい", "キャンセル")
			'setExitConfirmStr("Sonic Advance", "Are you sure you want to exit the game?", "Yes", "Cancel")
			
			If (Confirm("Sonic Advance", "Are you sure you want to exit the game?", False)) Then
				' This call may be moved later.
				MFDevice.currentState.onExit()
				
				Return Super.OnClose() ' EndApp()
			EndIf
			
			Return 1 ' 0
		End
		
		#Rem
			Method OnSuspend:Int()
				isSuspended = True
				
				MFDevice.inSuspendFlag = True
				MFDevice.notifyPause()
				
				Return Super.OnSuspend()
			End
			
			Method OnResume:Int()
				If (Self.resumeFromOtherActivityFlag) Then
					Self.isResumeFromOtherActivity = True
					Self.resumeFromOtherActivityFlag = False
				EndIf
				
				isSuspended = False
				
				MFDevice.inSuspendFlag = False
				MFDevice.notifyResume()
				
				Return Super.OnResume()
			End
		#End
		
		Method OnResize:Int()
			Local devWidth:= DeviceWidth()
			Local devHeight:= DeviceHeight()
			
			graphics.SetViewport(0, 0, devWidth, devHeight)
			graphics.SetProjection2d(0, devWidth, 0, devHeight)
			
			' Inverted Y axis.
			'graphics.SetProjection2d(0, devWidth, devHeight, 0)
			
			'Print("Device Size: " + devWidth + "x" + devHeight)
			'Print("Canvas Size: " + graphics.Width + "x" + graphics.Height)
			
			UpdateLetterBox(devWidth, devHeight, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			MFDevice.updateDrawRect(Self.screenX, Self.screenY, Self.screenWidth, Self.screenHeight)
			
			Return Super.OnResize()
		End
		
		Method OnRenderWhileSuspended:Void()
			graphics.Clear()
			
			graphics.SetColor(0.0, 0.0, 0.0)
			
			graphics.DrawText("Game Suspended", DeviceWidth() / 2, DeviceHeight() / 2, 0.5, 0.5)
			
			graphics.Flush()
		End
		
		Method RenderGame:Void()
			If (isSuspended) Then
				OnRenderWhileSuspended()
				
				Return
			EndIf
			
			' Clear the "real screen".
			graphics.Clear() ' (0.8, 0.4, 0.25)
			
			' Check if we should clear the graphics drawn by our device.
			If (MFDevice.clearBuffer) Then
				' Clear the game screen and associated layers.
				MFDevice.clearScreen()
			EndIf
			
			' Render the game, then flush to the appropriate canvases.
			MFDevice.deviceDraw(graphics, Self.screenX, Self.screenY, Self.screenWidth, Self.screenHeight)
			
			' Display the screen we rendered.
			graphics.Flush()
		End
		
		Method UpdateLetterBox:Void(deviceWidth:Int, deviceHeight:Int, virtualWidth:Int, virtualHeight:Int, X:Float=0.0, Y:Float=0.0)
			Local VASPECT:= (Float(virtualWidth) / Float(virtualHeight))
			
			Local virtualAspectRatio:Float = VASPECT
			Local deviceAspectRatio:Float = (Float(deviceWidth) / Float(deviceHeight))
			
			' These will represent our inner viewport.
			Local vx:Float, vy:Float, vw:Float, vh:Float
			
			If (deviceAspectRatio > virtualAspectRatio) Then
				' Grab the current device-height.
				vh = Float(deviceHeight)
				
				' Calculate the scaled width.
				vw = (vh * virtualAspectRatio) ' Float(deviceHeight)
				
				' Using our previously scaled width, subtract from the
				' current device-width, then add our X-offset.
				vx = (Float((deviceWidth - vw) / 2) + X)
				
				' Grab the Y-offset specified above.
				vy = Y
			Else ' Elseif (virtualAspectRatio < deviceAspectRatio) Then
				' Grab the current device-width.
				vw = Float(deviceWidth)
				
				' Calculate the scaled height.
				vh = (vw / virtualAspectRatio) ' Float(deviceWidth)
				
				' Grab the X-offset specified above.
				vx = X
				
				' Using our previously scaled height, subtract from the
				' current device-height, then add our Y-offset.
				vy = (Float((deviceHeight - vh) / 2) + Y)
			Endif
			
			Self.screenX = vx
			Self.screenY = vy
			Self.screenWidth = vw
			Self.screenHeight = vh
		End
		
		Method getEntryGameState:MFGameState()
			Return New MainState(Self)
		End
		
		Method setScore:Void(strScore:String)
			Self.mScore = strScore
		End
		
		Method setScoreStr:Void(strScore:String)
			Self.mScoreStr = strScore
		End
		
		Method setScore:Void(score:Int)
			Local min:= (score / 60000)
			Local sec:= ((score Mod 60000) / 1000)
			Local msec:= (((score Mod 60000) Mod 1000) / 10)
			
			Local secStr:String
			Local msecStr:String
			
			If (sec < 10) Then
				secStr = "0" + String(sec) ' 07, 08, 09...
			Else
				secStr = String(sec)
			EndIf
			
			If (msec < 10) Then
				msecStr = "0" + String(msec) ' 01, 02, 03...
			Else
				msecStr = String(msec)
			EndIf
			
			Self.mScore = (sonicdef.OVER_TIME - score)
			
			Print("~~mScore:" + Self.mScore)
			
			Self.mScoreStr = (min + ":" + secStr + ":" + msecStr)
			
			Print("~~mScoreStr:" + Self.mScoreStr)
		End
		
		' Extensions:
		Method HandleSystemKeys:Void()
			#Rem
				Local k:= GetChar()
				
				HandleSystemKey(k)
			#End
		End
		
		#Rem
			Method HandleSystemKey:Void(keyCode:Int)
				Select keyCode
					Case KEYCODE_VOLUME_DOWN
						If (GlobalResource.soundSwitchConfig = 0) Then
							Return
						EndIf
						
						If (Not State.IsInInterrupt) Then
							State.setSoundVolumnDown()
						EndIf
						
						MFDevice.getEnableVolumeKey()
					Case KEYCODE_VOLUME_UP
						If (GlobalResource.soundSwitchConfig = 0) Then
							Return
						EndIf
						
						If (Not State.IsInInterrupt) Then
							State.setSoundVolumnUp()
						EndIf
						
						MFDevice.getEnableVolumeKey()
				End Select
			End
		#End
End