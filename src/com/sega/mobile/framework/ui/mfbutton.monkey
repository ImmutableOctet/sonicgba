Strict

Public

' Imports:
Private
	Import com.sega.mobile.framework.device.mfcomponent
	Import com.sega.mobile.framework.utility.mfutility
Public

' Classes:
Class MFButton Implements MFComponent
	Private
		' Constant variable(s):
		Const BUTTON_PRESS:Int = 0
		Const BUTTON_REPEAT:Int = 1
		Const BUTTON_RELEASE:Int = 2
		
		' Extensions:
		Const BUTTON_FLAG_LENGTH:= 3
		
		' Fields:
		Field buttonFlag:Bool[]
		Field buttonTmpFlag:Bool[]
		
		Field mWidth:Int
		Field mHeight:Int
		
		Field mX:Int
		Field mY:Int
		
		Field pointId:Int
		
		Field pointX:Int
		Field pointY:Int
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, width:Int, height:Int)
			setPosition(x, y)
			setSize(width, height)
			
			reset()
		End
		
		' Methods:
		Method reset:Void()
			Self.buttonFlag = New Bool[BUTTON_FLAG_LENGTH]
			Self.buttonTmpFlag = New Bool[BUTTON_FLAG_LENGTH]
			
			For Local i:= 0 Until BUTTON_FLAG_LENGTH ' BUTTON_PRESS
				Self.buttonFlag[i] = False
				Self.buttonTmpFlag[i] = False
			Next
			
			Self.pointId = -1
		End
		
		Method setPosition:Void(x:Int, y:Int) Final
			Self.mX = x
			Self.mY = y
		End
		
		Method getX:Int() Final
			Return Self.mX
		End
		
		Method getY:Int() Final
			Return Self.mY
		End
		
		Method getWidth:Int() Final
			Return Self.mWidth
		End
		
		Method getHeight:Int() Final
			Return Self.mHeight
		End
		
		Method setSize:Void(width:Int, height:Int) Final
			Self.mWidth = width
			Self.mHeight = height
		End
		
		Method isPress:Bool() Final
			Return Self.buttonFlag[BUTTON_PRESS]
		End
		
		Method isRepeat:Bool() Final
			Return Self.buttonFlag[BUTTON_REPEAT]
		End
		
		Method isRelease:Bool() Final
			Return Self.buttonFlag[BUTTON_RELEASE]
		End
		
		Method tick:Void()
			For Local i:= 0 Until Self.buttonFlag.Legth
				Self.buttonFlag[i] = False
				
				If (Self.buttonTmpFlag[i]) Then
					Self.buttonFlag[i] = True
					
					If (i <> 1) Then
						Self.buttonTmpFlag[i] = False
					EndIf
				EndIf
			Next
		End
		
		Method pointerDragged:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = -1 Or Self.pointId = pId) Then
				If (MFUtility.pointInRegion(x, y, Self.mX, Self.mY, Self.mWidth, Self.mHeight)) Then
					If (Self.pointId = pId And Not Self.buttonTmpFlag[BUTTON_REPEAT]) Then
						Self.buttonTmpFlag[BUTTON_PRESS] = True
						Self.buttonTmpFlag[BUTTON_REPEAT] = True
					EndIf
					
					Self.pointX = x
					Self.pointY = y
				Else
					Self.buttonTmpFlag[BUTTON_REPEAT] = False
					
					Self.pointId = -1
				EndIf
			EndIf
		End
		
		Method pointerPressed:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = -1) Then
				If (MFUtility.pointInRegion(x, y, Self.mX, Self.mY, Self.mWidth, Self.mHeight)) Then
					Self.buttonTmpFlag[BUTTON_PRESS] = True
					Self.buttonTmpFlag[BUTTON_REPEAT] = True
					
					Self.pointX = x
					Self.pointY = y
				EndIf
				
				Self.pointId = pId
			EndIf
		End
		
		Method pointerReleased:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				If (Self.buttonTmpFlag[BUTTON_REPEAT]) Then
					If (MFUtility.pointInRegion(x, y, Self.mX, Self.mY, Self.mWidth, Self.mHeight)) Then
						Self.buttonTmpFlag[BUTTON_RELEASE] = True
					EndIf
				EndIf
				
				Self.buttonTmpFlag[BUTTON_REPEAT] = False
				
				Self.pointId = -1
				
				Self.pointX = -1
				Self.pointY = -1
			EndIf
		End
		
		Method getPointerID:Int()
			Return Self.pointId
		End
		
		Method getPointerX:Int()
			Return Self.pointX
		End
		
		Method getPointerY:Int()
			Return Self.pointY
		End
End