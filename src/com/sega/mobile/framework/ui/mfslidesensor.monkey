Strict

Public

' Imports:
Private
	Import com.sega.mobile.framework.device.mfcomponent
	Import com.sega.mobile.framework.utility.mfutility
Public

' Classes:
Class MFSlideSensor Implements MFComponent
	Public
		' Constant variable(s):
		Const DIRETION_UP:Int = 1
		Const DIRETION_DOWN:Int = 2
		Const DIRETION_LEFT:Int = 4
		Const DIRETION_RIGHT:Int = 8
	Private
		' Fields:
		Field directionOffsetX:Int
		Field directionOffsetY:Int
		
		Field directionState:Int
		
		Field pX:Int
		Field pY:Int
		
		Field pointId:Int
		
		Field pointX:Int
		Field pointY:Int
		
		Field sAccuracy:Int
		
		Field sWidth:Int
		Field sHeight:Int
		
		Field sX:Int
		Field sY:Int
		
		Field sliding:Bool
	Public
		' Constructor(s):
		Method New(sensorX:Int, sensorY:Int, sensorW:Int, sensorH:Int, sensorAccuracy:Int)
			Self.sliding = False
			
			setPosition(sensorX, sensorY)
			setSize(sensorW, sensorH)
			setAccuracy(sensorAccuracy)
			
			reset()
		End
		
		' Methods:
		Method reset:Void()
			Self.directionState = 0
			
			Self.pX = -1
			Self.pY = -1
			
			Self.pointX = -1
			Self.pointY = -1
			
			Self.pointId = -1
			
			Self.directionOffsetX = 0
			Self.directionOffsetY = 0
			
			Self.sliding = False
		End
		
		Method setPosition:Void(x:Int, y:Int) Final
			Self.sX = x
			Self.sY = y
		End
		
		Method setSize:Void(width:Int, height:Int) Final
			Self.sWidth = width
			Self.sHeight = height
		End
		
		Method setAccuracy:Void(sensorAccuracy:Int) Final
			Self.sAccuracy = sensorAccuracy
			
			If (Self.sAccuracy < DIRETION_UP) Then
				Self.sAccuracy = DIRETION_UP
			EndIf
		End
		
		Method isSlide:Bool(direction:Int) Final
			Return ((Self.directionState & direction) <> 0)
		End
		
		Method getOffsetX:Int()
			Return Self.pointX - (Self.pX + (Self.directionOffsetX * Self.sAccuracy))
		End
		
		Method getOffsetY:Int()
			Return Self.pointY - (Self.pY + (Self.directionOffsetY * Self.sAccuracy))
		End
		
		Method isSliding:Bool()
			Return Self.sliding
		End
		
		Method tick:Void()
			Self.directionState = 0
			
			If (Self.pX <> -1) Then
				Local tmpOffsetX:= ((Self.pointX - Self.pX) / Self.sAccuracy)
				
				If (Self.directionOffsetX < tmpOffsetX) Then
					Self.directionState |= DIRETION_RIGHT
				ElseIf (Self.directionOffsetX > tmpOffsetX) Then
					Self.directionState |= DIRETION_LEFT
				EndIf
				
				Self.directionOffsetX = tmpOffsetX
				
				Local tmpOffsetY:= ((Self.pointY - Self.pY) / Self.sAccuracy)
				
				If (Self.directionOffsetY < tmpOffsetY) Then
					Self.directionState |= DIRETION_DOWN
				ElseIf (Self.directionOffsetY > tmpOffsetY) Then
					Self.directionState |= DIRETION_UP
				EndIf
				
				Self.directionOffsetY = tmpOffsetY
			EndIf
		End
		
		Method pointerDragged:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				If (MFUtility.pointInRegion(x, y, Self.sX, Self.sY, Self.sWidth, Self.sHeight)) Then
					Self.pointX = x
					Self.pointY = y
				Else
					reset()
				EndIf
			EndIf
		End
		
		Method pointerPressed:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = -1) Then
				If (MFUtility.pointInRegion(x, y, Self.sX, Self.sY, Self.sWidth, Self.sHeight)) Then
					Self.pointId = pId
					
					Self.pX = x
					Self.pY = y
					
					Self.pointX = x
					Self.pointY = y
					
					Self.sliding = True
				EndIf
			EndIf
		End
		
		Method pointerReleased:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				reset()
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