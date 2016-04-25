Strict

Public

' Imports:
Private
	Import com.sega.mobile.framework.device.mfcomponent
	Import com.sega.mobile.framework.device.mfgamepad
	
	Import com.sega.mobile.framework.utility.mfutility
Public

' Classes:
Class MFTouchKey Implements MFComponent
	Private
		' Fields:
		Field mWidth:Int
		Field mHeight:Int
		
		Field mX:Int
		Field mY:Int
		
		Field pointId:Int
		
		Field pointX:Int
		Field pointY:Int
		
		Field vKey:Int
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, width:Int, height:Int, visualKeyValue:Int)
			setPosition(x, y)
			
			setSize(width, height)
			setVisualKey(visualKeyValue)
			
			reset()
		End
		
		' Methods:
		Method reset:Void()
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
		
		Method setVisualKey:Void(visualKey:Int) Final
			Self.vKey = visualKey
		End
		
		Method tick:Void()
			' Nothing so far.
		End
		
		Method pointerDragged:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				If (MFUtility.pointInRegion(x, y, Self.mX, Self.mY, Self.mWidth, Self.mHeight)) Then
					Self.pointX = x
					Self.pointY = y
				Else
					MFGamePad.releaseVisualKey(Self.vKey)
					
					Self.pointId = -1
					
					Self.pointX = -1
					Self.pointY = -1
				EndIf
			EndIf
		End
		
		Method pointerPressed:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = -1) Then
				If (MFUtility.pointInRegion(x, y, Self.mX, Self.mY, Self.mWidth, Self.mHeight)) Then
					MFGamePad.pressVisualKey(Self.vKey)
					
					Self.pointId = pId
					
					Self.pointX = x
					Self.pointY = y
				EndIf
			EndIf
		End
		
		Method pointerReleased:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				MFGamePad.releaseVisualKey(Self.vKey)
				
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