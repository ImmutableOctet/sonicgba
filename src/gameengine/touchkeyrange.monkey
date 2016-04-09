Strict

Public

' Imports:
Private
	Import lib.myapi
	'Import lib.constutil
	
	Import com.sega.mobile.framework.device.mfcomponent
Public

' Classes:
Class TouchKeyRange Implements MFComponent
	Private
		' Fields:
		Field keyState:Int
		Field press_x:Int
		Field press_y:Int
		
		Field IsDrag:Bool
		Field IsIn:Bool
	Public
		' Fields:
		Field result:Bool
		
		Field range_h:Int
		Field range_w:Int
		Field range_x:Int
		Field range_y:Int
		
		' Constructor(s):
		Method New(x:Int, y:Int, w:Int, h:Int)
			Self.result = False
			Self.IsDrag = False
			Self.IsIn = False
			
			Self.keyState = 0
			
			Self.range_x = MyAPI.zoomOut(x)
			Self.range_y = MyAPI.zoomOut(y)
			
			Self.range_w = MyAPI.zoomOut(w)
			Self.range_h = MyAPI.zoomOut(h)
			
			reset()
		End
		
		' Methods:
		Method setStartX:Void(x:Int)
			Self.range_x = MyAPI.zoomOut(x)
		End
		
		Method setStartY:Void(y:Int)
			Self.range_y = MyAPI.zoomOut(y)
		End
		
		Method tick:Void()
			' Empty implementation.
		End
		
		Method reset:Void()
			Self.result = False
			Self.IsDrag = False
			
			Self.keyState = 0
		End
		
		Method Isin:Bool()
			Return Self.result
		End
		
		Method IsinRange:Bool()
			Return Self.IsIn
		End
		
		Method IsClick:Bool()
			Return (Self.result And Not Self.IsDrag)
		End
		
		Method IsButtonPress:Bool()
			If (Self.keyState <> 2) Then
				Return False
			EndIf
			
			Self.keyState = 0
			
			Return True
		End
		
		Method resetKeyState:Void()
			Self.keyState = 0
			
			reset()
		End
		
		Method pointerPressed:Void(num:Int, x:Int, y:Int)
			If (x - Self.range_x <= 0 Or y - Self.range_y <= 0 Or Self.range_x + Self.range_w <= x Or Self.range_y + Self.range_h <= y) Then
				Self.result = False
				Self.IsIn = False
			Else
				Self.press_x = x
				Self.press_y = y
				
				Self.result = True
				
				If (Self.keyState = 0) Then
					Self.keyState = 1
				EndIf
				
				Self.IsIn = True
			EndIf
			
			Self.IsDrag = False
		End
		
		Method pointerReleased:Void(num:Int, x:Int, y:Int)
			If (x - Self.range_x > 0 And y - Self.range_y > 0 And Self.range_x + Self.range_w > x And Self.range_y + Self.range_h > y) Then
				Self.result = False
				
				If (Self.keyState = 1) Then
					Self.keyState = 2
				EndIf
			EndIf
		End
		
		Method pointerDragged:Void(num:Int, x:Int, y:Int)
			If (x - Self.range_x <= 0 Or y - Self.range_y <= 0 Or Self.range_x + Self.range_w <= x Or Self.range_y + Self.range_h <= y) Then
				Self.result = False
				Self.IsDrag = False
				Self.IsIn = False
			Else
				Self.result = True
				
				If (x - Self.press_x > 2 Or x - Self.press_x < -2 Or y - Self.press_y > 2 Or y - Self.press_y < -2) Then
					Self.IsDrag = True
				Else
					Self.IsDrag = False
				EndIf
				
				Self.IsIn = True
				
				If (Self.keyState = 0) Then
					Self.keyState = 1
				EndIf
			EndIf
		End
		
		Method getPointerID:Int()
			Return 0
		End
		
		Method getPointerX:Int()
			Return 0
		End
		
		Method getPointerY:Int()
			Return 0
		End
End