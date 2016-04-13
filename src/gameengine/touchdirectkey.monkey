Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.crlfp32
	Import lib.constutil
	
	'Import gameengine.key
	
	Import state.titlestate
	
	Import com.sega.mobile.define.mdphone
	
	Import com.sega.mobile.framework.device.mfcomponent
	Import com.sega.mobile.framework.device.mfgamepad
Public

' Classes:
Class TouchDirectKey Implements MFComponent
	Private
		' Global variable(s):
		Global B_NONE:Int = 1073741824
		
		Global IsDragged:Bool = False
		Global IsPressed:Bool = False
		Global IsReleased:Bool = False
		Global PressedX:Int = 0
		Global PressedY:Int = 0
		Global posID:Int = -1
		Global type:Int = -1
		
		' Fields:
		Field CenterX:Int
		Field CenterY:Int
		Field CurrentVKey:Int
		Field ExceptCircleR:Int
		Field NoneCircleR:Int
		Field OrgVKey:Int
		Field OutCircleR:Int
		Field PointDegree:Int
	Public
		' Functions:
		Function getPressedPointX:Int()
			Return PressedX
		End
		
		Function getPressedPointY:Int()
			Return PressedY
		End
		
		Function IsKeyDragged:Bool()
			Return IsDragged
		End
		
		Function IsKeyPressed:Bool()
			Return IsPressed
		End
		
		Function IsKeyReleased:Bool()
			Return IsReleased
		End
		
		' Constructor(s):
		Method New()
			Self(-1, -1, 1, 0, -1)
		End
		
		Method New(centerx:Int, centery:Int, outr:Int, noner:Int, type:Int)
			setCenterPoint(centerx, centery)
			setCircleRadius(outr)
			setNoneCircleRadius(noner)
			
			type = type
			
			reset()
		End
		
		' Methods:
		Method setCenterPoint:Void(x:Int, y:Int) Final
			Self.CenterX = x
			Self.CenterY = y
		End
		
		Method setPressedPoint:Void(x:Int, y:Int)
			PressedX = MyAPI.zoomIn(x)
			PressedY = MyAPI.zoomIn(y)
		End
		
		Method getDegree:Int()
			Return Self.PointDegree
		End
		
		Method setCircleRadius:Void(r:Int) Final
			Self.OutCircleR = r
		End
		
		Method setNoneCircleRadius:Void(r:Int) Final
			Self.NoneCircleR = r
		End
		
		Method setExceptionCircleRadius:Void(r:Int) Final
			Self.ExceptCircleR = r
		End
		
		Method reset:Void()
			IsReleased = True
		End
		
		Method tick:Void()
			' Empty implementation.
		End
		
		Method pointerPressed:Void(num:Int, x:Int, y:Int)
			If (rangeChk(x, y)) Then
				If (posID = -1) Then
					posID = num
				EndIf
				
				If (posID = num) Then
					setPressedPoint(x, y)
					
					Self.OrgVKey = pointer2Key(x, y)
					Self.PointDegree = getPointerDegree(x, y)
					
					MFGamePad.pressVisualKey(Self.OrgVKey)
					
					If (Self.OrgVKey <> 0) Then
						IsPressed = True
						IsReleased = False
					EndIf
				EndIf
			EndIf
		End
		
		Method pointerReleased:Void(num:Int, x:Int, y:Int)
			If (posID = num) Then
				MFGamePad.releaseVisualKey(pointer2Key(x, y))
				MFGamePad.releaseVisualKey(Self.OrgVKey)
				MFGamePad.releaseVisualKey(Self.CurrentVKey)
				
				IsPressed = False
				IsReleased = True
				
				posID = -1
			EndIf
		End
		
		Method pointerDragged:Void(num:Int, x:Int, y:Int)
			If (rangeChk(x, y)) Then
				If (posID = -1) Then
					posID = num
				EndIf
				
				If (posID = num) Then
					Self.CurrentVKey = pointer2Key(x, y)
					
					If (Self.CurrentVKey = 0) Then
						setPressedPoint(x, y)
						
						MFGamePad.releaseVisualKey(Self.OrgVKey)
						
						IsDragged = False
						IsPressed = False
						IsReleased = True
					ElseIf (Self.CurrentVKey <> Self.OrgVKey) Then
						setPressedPoint(x, y)
						
						MFGamePad.releaseVisualKey(Self.OrgVKey)
						
						Self.PointDegree = getPointerDegree(x, y)
						
						setPressedPoint(x, y)
						
						Self.OrgVKey = pointer2Key(x, y)
						Self.PointDegree = getPointerDegree(x, y)
						
						MFGamePad.pressVisualKey(Self.OrgVKey)
						
						If (Self.OrgVKey <> 0) Then
							IsPressed = True
							IsReleased = False
						EndIf
						
						IsDragged = True
						IsReleased = False
					Else
						setPressedPoint(x, y)
						setPressedPoint(x, y)
						
						Self.OrgVKey = pointer2Key(x, y)
						Self.PointDegree = getPointerDegree(x, y)
						
						MFGamePad.pressVisualKey(Self.OrgVKey)
						
						If (Self.OrgVKey <> 0) Then
							IsPressed = True
							IsReleased = False
						EndIf
						
						If (Self.CurrentVKey <> 0) Then
							Self.PointDegree = getPointerDegree(x, y)
						EndIf
						
						IsDragged = True
						IsReleased = False
					EndIf
				EndIf
			ElseIf (posID = num) Then
				MFGamePad.releaseVisualKey(pointer2Key(x, y))
				MFGamePad.releaseVisualKey(Self.OrgVKey)
				MFGamePad.releaseVisualKey(Self.CurrentVKey)
				
				IsPressed = False
				IsReleased = True
				
				posID = -1
			EndIf
		End
		
		Method getPointerID:Int()
			Return posID
		End
		
		Method getPointerX:Int()
			Return 0
		End
		
		Method getPointerY:Int()
			Return 0
		End
	Private
		' Methods:
		Method pointer2Key:Int(x:Int, y:Int)
			Local reset_x:= (x - Self.CenterX)
			Local reset_y:= (y - Self.CenterY)
			
			Local degree:= ((crlFP32.actTanDegree(reset_y, reset_x) + 360) Mod 360)
			
			If ((reset_x * reset_x) + (reset_y * reset_y) >= Self.OutCircleR * Self.OutCircleR) Then
				Return MFGamePad.KEY_NULL
			EndIf
			
			If ((reset_x * reset_x) + (reset_y * reset_y) <= Self.NoneCircleR * Self.NoneCircleR) Then
				Return B_NONE
			EndIf
			
			If (type = 0) Then
				If (degree >= 235 And degree < 305) Then
					Return MFGamePad.KEY_UP
				EndIf
				
				If (degree >= 305 And degree < 337) Then
					Return MFGamePad.KEY_UP_RIGHT
				EndIf
				
				If ((degree >= 0 And degree < 22) Or (degree >= 337 And degree <= 360)) Then
					Return MFGamePad.KEY_RIGHT
				EndIf
				
				If (degree >= 22 And degree < 54) Then
					Return MFGamePad.KEY_DOWN_RIGHT
				EndIf
				
				If (degree >= 54 And degree < 126) Then
					Return MFGamePad.KEY_DOWN
				EndIf
				
				If (degree >= 126 And degree < 157) Then
					Return MFGamePad.KEY_DOWN_LEFT
				EndIf
				
				If (degree < 157 Or degree >= 202) Then
					Return PickValue((degree < 202 Or degree >= 235), MFGamePad.KEY_NULL, MFGamePad.KEY_UP_LEFT)
				Else
					Return MFGamePad.KEY_LEFT
				EndIf
			ElseIf (type <> 1) Then
				Return MFGamePad.KEY_NULL
			Else
				If (degree >= 235 And degree < 305) Then
					Return Key.B_LOOK
				EndIf
				
				If ((degree >= 0 And degree < 54) Or (degree >= 305 And degree <= 360)) Then
					Return MFGamePad.KEY_RIGHT
				EndIf
				
				If (degree < 54 Or degree >= 126) Then
					Return PickValue((degree < 126 Or degree >= 235), MFGamePad.KEY_NULL, MFGamePad.KEY_LEFT)
				Else
					Return MFGamePad.KEY_DOWN
				EndIf
			EndIf
		End
		
		Method getPointerDegree:Int(x:Int, y:Int)
			Return ((crlFP32.actTanDegree(y - Self.CenterY, x - Self.CenterX) + 360) Mod 360)
		End
		
		Method rangeChk:Bool(x:Int, y:Int)
			If (Self.CenterX - Self.OutCircleR >= x Or Self.CenterX + Self.OutCircleR <= x Or Self.CenterY - Self.OutCircleR >= y Or Self.CenterY + Self.OutCircleR <= y) Then
				Return False
			EndIf
			
			Return True
		End
End