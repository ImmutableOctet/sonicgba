Strict

Public

' Imports:
Private
	Import com.sega.mobile.framework.device.mfcomponent
	Import com.sega.mobile.framework.utility.mfutility
Public

' Classes:
Class MFSliderBar Implements MFComponent
	Public
		' Constant variable(s):
		Const VERTICAL:Int = 0
		Const HORIZONTAL:Int = 1
	Private
		' Fields:
		Field onTouch:Bool
		
		Field inSliderOffset:Int
		
		Field pointId:Int
		
		Field pointX:Int
		Field pointY:Int
		
		Field sWidth:Int
		Field sHeight:Int
		
		Field sOrientation:Int
		
		Field sX:Int
		Field sY:Int
		
		Field sliderBarLength:Int
		
		Field sliderPosition:Int
	Public
		' Constructor(s):
		Method New(sliderBarX:Int, sliderBarY:Int, sliderBarLength:Int, sliderBarOrientation:Int, sliderWidth:Int, sliderHeight:Int)
			setPosition(sliderBarX, sliderBarY)
			setSize(sliderWidth, sliderHeight)
			
			setOrientation(sliderBarOrientation)
			setLength(sliderBarLength)
			
			reset()
		End
		
		' Methods:
		Method reset:Void()
			Self.inSliderOffset = 0
			
			Self.onTouch = False
			
			Self.pointId = -1
		End
		
		Method setPosition:Void(x:Int, y:Int) Final
			Self.sX = x
			Self.sY = y
		End
		
		Method setSize:Void(width:Int, height:Int) Final
			Self.sWidth = width
			Self.sHeight = height
		End
		
		Method setOrientation:Void(sliderBarOrientation:Int) Final
			Self.sOrientation = sliderBarOrientation
		End
		
		Method setLength:Void(length:Int)
			Self.sliderBarLength = length
			
			If (Self.sliderBarLength < HORIZONTAL) Then
				Self.sliderBarLength = HORIZONTAL
			EndIf
		End
		
		Method getLength:Int()
			Return Self.sliderBarLength
		End
		
		Method getSliderPosition:Int()
			Return Self.sliderPosition
		End
		
		Method setSliderPosition:Void(position:Int)
			Self.sliderPosition = position
			
			If (Self.sliderPosition < 0) Then
				Self.sliderPosition = 0
			EndIf
			
			If (Self.sliderPosition > Self.sliderBarLength) Then
				Self.sliderPosition = Self.sliderBarLength
			EndIf
		End
		
		Method tick:Void()
			' Nothing so far.
		End
		
		Method pointerDragged:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId And Self.onTouch) Then
				If (Self.sOrientation = 0) Then
					If (MFUtility.pointInRegion(x, y, Self.sX - (Self.sWidth / 2), (Self.sY + Self.inSliderOffset) - (Self.sHeight / 2), Self.sWidth, Self.sHeight + Self.sliderBarLength)) Then ' Shr HORIZONTAL
						setSliderPosition((y - Self.sY) - Self.inSliderOffset)
						
						Self.pointX = x
						Self.pointY = y
					EndIf
				Else
					If (MFUtility.pointInRegion(x, y, (Self.sX + Self.inSliderOffset) - (Self.sWidth / 2), Self.sY - (Self.sHeight / 2), Self.sWidth + Self.sliderBarLength, Self.sHeight)) Then ' Shr HORIZONTAL
						setSliderPosition((x - Self.sX) - Self.inSliderOffset)
						
						Self.pointX = x
						Self.pointY = y
					EndIf
				EndIf
			EndIf
		End
		
		Method pointerPressed:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = -1) Then
				If (Self.sOrientation = 0) Then
					If (MFUtility.pointInRegion(x, y, Self.sX - (Self.sWidth / 2), (Self.sY - (Self.sHeight / 2)) + Self.sliderPosition, Self.sWidth, Self.sHeight)) Then ' Shr HORIZONTAL
						Self.inSliderOffset = (y - Self.sY) - Self.sliderPosition
						
						Self.onTouch = True
						
						Self.pointId = pId
						
						Self.pointX = x
						Self.pointY = y
					EndIf
				Else
					If (MFUtility.pointInRegion(x, y, (Self.sX - (Self.sWidth / 2)) + Self.sliderPosition, Self.sY - (Self.sHeight / 2), Self.sWidth, Self.sHeight)) Then ' Shr HORIZONTAL
						Self.inSliderOffset = (x - Self.sX) - Self.sliderPosition
						
						Self.onTouch = True
						
						Self.pointId = pId
						
						Self.pointX = x
						Self.pointY = y
					EndIf
				EndIf
			EndIf
		End
		
		Method pointerReleased:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				Self.onTouch = False
				
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