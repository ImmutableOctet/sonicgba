Strict

Public

#Rem
	This module will likely be reworked in the future.
#End

' Friends:
Friend com.sega.mobile.framework.device.mfdevice

' Imports:
Private
	Import com.sega.mobile.define.mdphone
	
	Import mojo.keycodes
Public

' Classes:
Class MFGamePad ' Final
	Public
		' Constant variable(s):
		Const KEY_A:Int = 2112
		Const KEY_ANYKEY:Int = -1
		Const KEY_B:Int = 131072
		Const KEY_BACK:Int = 524288
		Const KEY_C:Int = 65536
		Const KEY_D:Int = 262144
		Const KEY_DOWN:Int = 16392
		Const KEY_DOWN_LEFT:Int = 8192
		Const KEY_DOWN_RIGHT:Int = 32768
		Const KEY_JOYSTICK_L1:Int = 67108864
		Const KEY_JOYSTICK_MENU:Int = 8388608
		Const KEY_JOYSTICK_O:Int = 524288
		Const KEY_JOYSTICK_R1:Int = 134217728
		Const KEY_JOYSTICK_RECT:Int = 2097152
		Const KEY_JOYSTICK_SELECT:Int = 16777216
		Const KEY_JOYSTICK_START:Int = 33554432
		Const KEY_JOYSTICK_TRIANGLE:Int = 4194304
		Const KEY_JOYSTICK_X:Int = 1048576
		Const KEY_LEFT:Int = 1040
		Const KEY_NULL:Int = 0
		Const KEY_NUM_0:Int = 131072
		Const KEY_NUM_1:Int = 128
		Const KEY_NUM_2:Int = 256
		Const KEY_NUM_3:Int = 512
		Const KEY_NUM_4:Int = 1024
		Const KEY_NUM_5:Int = 2048
		Const KEY_NUM_6:Int = 4096
		Const KEY_NUM_7:Int = 8192
		Const KEY_NUM_8:Int = 16384
		Const KEY_NUM_9:Int = 32768
		Const KEY_NUM_POUND:Int = 262144
		Const KEY_NUM_STAR:Int = 65536
		Const KEY_PAD_CONFIRM:Int = 64
		Const KEY_PAD_DOWN:Int = 8
		Const KEY_PAD_LEFT:Int = 16
		Const KEY_PAD_RIGHT:Int = 32
		Const KEY_PAD_UP:Int = 4
		Const KEY_RIGHT:Int = 4128
		Const KEY_S1:Int = 1
		Const KEY_S2:Int = 2
		Const KEY_UP:Int = 260
		Const KEY_UP_LEFT:Int = 128
		Const KEY_UP_RIGHT:Int = 512
	Private
		' Global variable(s):
		Global KEY:Int = KEY_NULL
		Global KEY_R:Int = 0
		Global KeyOld:Int = KEY_NULL
		Global KeyPress:Int = KEY_NULL
		Global KeyRelease:Int = KEY_NULL
		Global KeyRepeat:Int = KEY_NULL
		Global deviceKeyValue:Int = KEY_NULL
		Global lastTrackballAvailiable:Bool = True
		Global trackballAvailiable:Bool = True
		Global trackballKey:Int = KEY_NULL
	Public
		' Functions:
		Function resetKeys:Void()
			KEY = KEY_NULL
			KEY_R = KEY_NULL
			KeyPress = KEY_NULL
			KeyRepeat = KEY_NULL
			KeyRelease = KEY_NULL
			KeyOld = KEY_NULL
			deviceKeyValue = KEY_NULL
		End
		
		Function isKeyPress:Bool(key:Int)
			Return ((KeyPress & key) <> 0)
		End
		
		Function isKeyRepeat:Bool(key:Int)
			Return ((KeyRepeat & key) <> 0)
		End
		
		Function isKeyRelease:Bool(key:Int)
			Return ((KeyRelease & key) <> 0)
		End
		
		Function getKeyPress:Int()
			Return KeyPress
		End
		
		Function getKeyRepeat:Int()
			Return KeyRepeat
		End
		
		Function getKeyRelease:Int()
			Return KeyRelease
		End
		
		Function pressVisualKey:Void(key:Int)
			KEY |= key
		End
		
		Function releaseVisualKey:Void(key:Int)
			KEY_R |= key
		End
		
		Function DEBUG_GET_DEVICE_KEY_VALUE:Int()
			Return KEY_NULL
		End
	Protected
		' Functions:
		Function keyTick:Void()
			KeyRepeat = KEY
			KeyPress = ((KeyOld ~ KEY_ANYKEY) & KeyRepeat)
			
			KEY &= (KEY_R ~ KEY_ANYKEY)
			
			KeyOld = KeyRepeat
			KeyRepeat = KEY
			KeyRelease = (KeyOld & (KeyRepeat ~ KEY_ANYKEY))
			KeyOld = KeyRepeat
			
			KEY_R = KEY_NULL
			
			If (lastTrackballAvailiable) Then
				If (trackballKey <> 0) Then
					releaseVisualKey(decodeKey(trackballKey))
					
					trackballKey = KEY_NULL
				EndIf
				
				trackballAvailiable = True
			EndIf
			
			lastTrackballAvailiable = trackballAvailiable
		End
		
		Function keyPressed:Void(keyCode:Int)
			pressVisualKey(decodeKey(keyCode))
		End
		
		Function keyReleased:Void(keyCode:Int)
			releaseVisualKey(decodeKey(keyCode))
		End
		
		Function trackballMoved:Void(keyCode:Int)
			If (trackballAvailiable) Then
				trackballAvailiable = False
				pressVisualKey(decodeKey(keyCode))
				trackballKey = keyCode
			EndIf
		End
	Private
		' Functions:
		
		' This routine may change in the future:
		Function decodeKey:Int(keyCode:Int)
			Print("DECODING KEY: " + keyCode)
			
			' Magic numbers: 4, 19, 20, 21, 22, 52, 82 (Key-codes)
			Select (keyCode)
				Case keycodes.KEY_BACK ' 4 ' KEYCODE_BACK
					Return KEY_JOYSTICK_O ' $80000 ' KEY_JOYSTICK_SELECT
				Case keycodes.KEY_UP ' 19 ' KEYCODE_DPAD_UP
					Return KEY_PAD_UP
				Case keycodes.KEY_DOWN ' 20 ' KEYCODE_DPAD_DOWN
					Return KEY_PAD_DOWN
				Case keycodes.KEY_LEFT ' 21 ' KEYCODE_DPAD_LEFT
					Return KEY_PAD_LEFT
				Case keycodes.KEY_RIGHT ' 22 ' KEYCODE_DPAD_RIGHT
					Return KEY_PAD_RIGHT
				Case keycodes.KEY_X ' 52 ' KEYCODE_X
					Return KEY_S2
				Case keycodes.KEY_MENU ' 82 ' MDPhone.KEY_CODE_MENU ' KEYCODE_MENU
					Return KEY_JOYSTICK_MENU
				Default
					Return KEY_NULL
			End Select
		End
End