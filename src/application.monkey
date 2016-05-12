Strict

Public

' Preprocessor related:
#ALLOW_FORCE_EXIT = False ' True

' GLFW Configuration:
#GLFW_WINDOW_TITLE = "Sonic Advance"
#GLFW_WINDOW_WIDTH = 1280 ' 360
#GLFW_WINDOW_HEIGHT = 720 ' 640
#GLFW_WINDOW_SAMPLES = 0
#GLFW_WINDOW_RESIZABLE = True
#GLFW_WINDOW_DECORATED = True
#GLFW_WINDOW_FLOATING = False
#GLFW_WINDOW_FULLSCREEN = False

#MOJO_AUTO_SUSPEND_ENABLED = False

#TEXT_FILES+="*.txt|*.xml|*.json"
#IMAGE_FILES+="*.png|*.jpg"
#SOUND_FILES+="*.wav|*.ogg"
#MUSIC_FILES+="*.wav|*.ogg"
#BINARY_FILES+="*.bin|*.dat|*.ci|*.co|*.en|*.gi|*.it|*.pal|*.pm|*.pyx|*.ri"

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
	
	Import com.sega.mobile.framework.android.graphics
	
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
		
		' Booleans / Flags:
		Field isSuspended:Bool
	Public
		' Methods:
		Method OnCreate:Int()
			SetUpdateRate(0) ' 60 ' 30
			
			Seed = Millisecs()
			
			graphics = New Canvas(Null)
			
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
			
			MFDevice.initializeScreen(graphics, DeviceWidth(), DeviceHeight())
			MFDevice.notifyStart(graphics, getEntryGameState())
			
			Return 0
		End
		
		Method OnUpdate:Int()
			'HandleSystemKeys()
			
			'MFDevice.handleInput()
			
			MFDevice.Update()
			
			#If ALLOW_FORCE_EXIT
				If (MFDevice.exitFlag) Then
					Return OnClose()
				EndIf
			#End
			
			Return 0
		End
		
		Method OnRender:Int()
			If (isSuspended) Then
				OnRenderWhileSuspended()
				
				Return 0
			EndIf
			
			'graphics.Clear()
			
			If (MFDevice.clearBuffer) Then
				MFDevice.clearScreen()
			EndIf
			
			MFDevice.flushScreen()
			
			'graphics.Flush()
			
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
		
		Method OnSuspend:Int()
			isSuspended = True
			
			MFDevice.inSuspendFlag = True
			MFDevice.notifyPause()
			
			Return 0
		End
		
		Method OnResume:Int()
			If (Self.resumeFromOtherActivityFlag) Then
				Self.isResumeFromOtherActivity = True
				Self.resumeFromOtherActivityFlag = False
			EndIf
			
			isSuspended = False
			
			MFDevice.inSuspendFlag = False
			MFDevice.notifyResume()
			
			Return 0
		End
		
		Method OnRenderWhileSuspended:Void()
			graphics.Clear()
			
			graphics.SetFont(Null)
			
			graphics.SetColor(0.0, 0.0, 0.0)
			
			graphics.DrawText("Game Suspended", DeviceWidth() / 2, DeviceHeight() / 2, 0.5, 0.5)
			
			graphics.Flush()
		End
		
		Method getEntryGameState:MFGameState()
			' Magic numbers:
			MFDevice.setCanvasSize(Min(Max(240, (MFDevice.getDeviceWidth() * 160) / MFDevice.getDeviceHeight()), 284), 160) ' ssdef.PLAYER_MOVE_HEIGHT
			MFDevice.setEnableCustomBack(True)
			
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
			
			Self.mScoreStr = min + ":" + secStr + ":" + msecStr
			
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