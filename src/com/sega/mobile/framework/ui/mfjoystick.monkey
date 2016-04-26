Strict

Public

' Imports:
Private
	Import lib.constutil
	
	Import com.sega.mobile.framework.device.mfcomponent
	Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.utility.mfutility
Public

' Classes:
Class MFJoyStick Implements MFComponent
	Public
		' Constant variable(s):
		Const TYPE_4_DIRECTION:Int = 0
		Const TYPE_8_DIRECTION:Int = 1
	Private
		' Constant variable(s):
		Global DIRECTIONS:Int[][] = [[260, 4388, 4388, 4128, 4128, 20520, 20520, 16392, 16392, 17432, 17432, 1040, 1040, 1300, 1300, 260], [260, 512, 512, 4128, 4128, 32768, 32768, 16392, 16392, 8192, 8192, 1040, 1040, 128, 128, 260]] ' Const
		Global KEY_FOR_RELEASE:Int[] = [21820, 63420] ' Const
		
		' Fields:
		Field cX:Int
		Field cY:Int
		
		Field keyIndex:Int
		Field lastKeyIndex:Int
		
		Field pR:Int
		
		Field pointId:Int
		
		Field pointX:Int
		Field pointY:Int
		
		Field rSize:Int
		
		Field rX:Int
		Field rY:Int
		
		Field sMs:Int
		
		Field sR:Int
		Field sRs:Int
		
		Field sType:Int
		
		Field sX:Int
		Field sY:Int
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, padRadius:Int, stickRaidus:Int, type:Int)
			Self.cX = x
			Self.cY = y
			
			Self.pR = padRadius
			Self.sR = stickRaidus
			
			Self.sRs = (Self.sR * Self.sR)
			
			Self.rX = (Self.cX - Self.pR)
			Self.rY = (Self.cY - Self.pR)
			
			Self.rSize = (Self.pR * 2)
			
			Self.sMs = (Self.pR / 10)
			
			If (Self.sMs < 10) Then
				Self.sMs = 10
			EndIf
			
			Self.sMs *= Self.sMs
			
			Self.sType = type
			
			Self.lastKeyIndex = -1
			
			Self.sX = 0
			Self.sY = 0
		End
	Private
		' Methods:
		Method stickMoved:Void(pId:Int, x:Int, y:Int)
			If (MFUtility.pointInRegion(x, y, Self.rX, Self.rY, Self.rSize, Self.rSize)) Then
				Local tmpX:= x - Self.cX
				Local tmpY:= y - Self.cY
				
				Local powXY:= ((tmpX * tmpX) + (tmpY * tmpY))
				
				If (powXY < Self.sMs) Then
					Self.sX = 0
					Self.sY = 0
				ElseIf (powXY <= Self.sRs) Then
					Self.sX = tmpX
					Self.sY = tmpY
				Else
					If (tmpX <= 0) Then
						tmpX = -tmpX
					EndIf
					
					If (tmpY <= 0) Then
						tmpY = -tmpY
					EndIf
					
					If (tmpX <= tmpY) Then
						If (tmpY <> 0) Then
							Self.sY = 0
							
							While (Self.sY < tmpY)
								Self.sX = ((Self.sY * tmpX) / tmpY)
								
								If ((Self.sX * Self.sX) + (Self.sY * Self.sY) >= Self.sRs) Then
									Exit
								EndIf
								
								Self.sY += 1
							Wend
						Else
							Self.sY = 0
							
							Self.sX = PickValue((tmpX > Self.sR), Self.sR, tmpX)
						EndIf
					ElseIf (tmpX <> 0) Then
						Self.sX = 0
						
						While (Self.sX < tmpX)
							Self.sY = (Self.sX * tmpY) / tmpX
							
							If ((Self.sX * Self.sX) + (Self.sY * Self.sY) >= Self.sRs) Then
								Exit
							EndIf
							
							Self.sX += 1
						Wend
					Else
						Self.sX = 0
						Self.sY = PickValue((tmpY > Self.sR), Self.sR, tmpY)
					EndIf
					
					Self.sX = (x - PickValue((Self.cX > 0), Self.sX, -Self.sX))
					Self.sY = PickValue((y - Self.cY > 0), Self.sY, -Self.sY)
				EndIf
				
				If (Self.sX = 0 And Self.sY = 0) Then
					reset()
				Else
					Local tan:= PickValue((Self.sY = 0), 99, ((Self.sX * 10) / Self.sY))
					
					If (tan < 0) Then
						tan = -tan
					EndIf
					
					If (tan < 4) Then
						If (Self.sY < 0) Then
							If (Self.sX > 0) Then
								Self.keyIndex = 0
							Else
								Self.keyIndex = 15
							EndIf
						ElseIf (Self.sX > 0) Then
							Self.keyIndex = 7
						Else
							Self.keyIndex = 8
						EndIf
					ElseIf (tan < 10) Then
						If (Self.sY < 0) Then
							If (Self.sX > 0) Then
								Self.keyIndex = 1
							Else
								Self.keyIndex = 14
							EndIf
						ElseIf (Self.sX > 0) Then
							Self.keyIndex = 6
						Else
							Self.keyIndex = 9
						EndIf
					ElseIf (tan < 24) Then
						If (Self.sY < 0) Then
							If (Self.sX > 0) Then
								Self.keyIndex = 2
							Else
								Self.keyIndex = 13
							EndIf
						ElseIf (Self.sX > 0) Then
							Self.keyIndex = 5
						Else
							Self.keyIndex = 10
						EndIf
					ElseIf (Self.sY < 0) Then
						If (Self.sX > 0) Then
							Self.keyIndex = 3
						Else
							Self.keyIndex = 12
						EndIf
					ElseIf (Self.sX > 0) Then
						Self.keyIndex = 4
					Else
						Self.keyIndex = 11
					EndIf
					
					If (Self.lastKeyIndex <> Self.keyIndex) Then
						Local direction:Int
						
						If (Self.lastKeyIndex = -1) Then
							direction = 0
						Else
							direction = DIRECTIONS[Self.sType][Self.lastKeyIndex]
						EndIf
						
						MFGamePad.pressVisualKey(DIRECTIONS[Self.sType][Self.keyIndex] & (direction ~ -1))
						
						Local visualKey:Int
						
						If (Self.lastKeyIndex = -1) Then
							visualKey = 0 ' TYPE_4_DIRECTION
						Else
							visualKey = DIRECTIONS[Self.sType][Self.lastKeyIndex] & (DIRECTIONS[Self.sType][Self.keyIndex] ~ -1)
						EndIf
						
						MFGamePad.releaseVisualKey(visualKey)
						
						Self.lastKeyIndex = Self.keyIndex
					EndIf
				EndIf
				
				Self.pointId = pId
				
				Self.pointX = x
				Self.pointY = y
			Else
				outOfRange()
			EndIf
		End
		
		Method outOfRange:Void()
			MFGamePad.releaseVisualKey(KEY_FOR_RELEASE[Self.sType])
			
			Self.lastKeyIndex = -1
			
			Self.sX = 0
			Self.sY = 0
		End
	Public
		' Methods:
		Method getStickPosX:Int()
			Return Self.sX
		End
		
		Method getStickPosY:Int()
			Return Self.sY
		End
		
		Method reset:Void()
			outOfRange()
			
			Self.pointId = -1
		End
		
		Method tick:Void()
			' Empty implementation.
		End
		
		Method pointerDragged:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				stickMoved(pId, x, y)
			EndIf
		End
		
		Method pointerPressed:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = -1) Then
				stickMoved(pId, x, y)
			EndIf
		End
		
		Method pointerReleased:Void(pId:Int, x:Int, y:Int)
			If (Self.pointId = pId) Then
				reset()
				
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
		
		Method setPosition:Void(x:Int, y:Int) Final
			Self.cX = x
			Self.cY = y
			
			Self.rX = (Self.cX - Self.pR)
			Self.rY = (Self.cY - Self.pR)
			
			Self.lastKeyIndex = -1
			
			Self.sX = 0
			Self.sY = 0
		End
		
		Method getX:Int() Final
			Return Self.cX
		End
		
		Method getY:Int() Final
			Return Self.cY
		End
End