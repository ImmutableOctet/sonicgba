Strict

Public

' Imports:
Private
	Import com.sega.engine.lib.myapi
	
	import com.sega.engine.action.acmovecaluser
	import com.sega.engine.action.acobject
	import com.sega.engine.action.acworld
Public

' Classes:
Class ACMoveCalculator
	Protected
		Field acObj:ACObject
		
		Field moveDistanceX:Int
		Field moveDistanceY:Int
		
		Field user:ACMoveCalUser
		Field worldInstance:ACWorld
	Private
		Field chkPointX:Int
		Field chkPointY:Int
	Public
		' Constructor(s):
		Method New(acObj:ACObject, user:ACMoveCalUser)
			Self.acObj = acObj
			Self.user = user
			Self.worldInstance = acObj.worldInstance
		End
		
		' Methods:
		Method actionLogic:Void(moveDistanceX:Int, moveDistanceY:Int)
			Self.moveDistanceX = moveDistanceX
			Self.moveDistanceY = moveDistanceY
			
			checkInMap()
		End
		
		Method stopMove:Void(degree:Int)
			Local moveDistanceY2:= (((-Self.moveDistanceX) * Sin(degree)) + (Self.moveDistanceY * Cos(degree))) ' / 1
			
			If (((Self.moveDistanceX * Cos(degree)) + (Self.moveDistanceY * Sin(degree))) > 0) Then ' / 1
				' Magic number: 10000
				Self.moveDistanceX = ((-moveDistanceY2) * Sin(degree)) / 10000
				Self.moveDistanceY = (Cos(degree) * moveDistanceY2) / 10000
			EndIf
		End
	
		Method stopMove:Void()
			stopMoveX()
			stopMoveY()
		End
	
		Method stopMoveX:Void()
			Self.moveDistanceX = 0
		End
	
		Method stopMoveY:Void()
			Self.moveDistanceY = 0
		End
	Private
		Method checkInMap:Void()
			If (Self.moveDistanceX = 0 And Self.moveDistanceY = 0) Then
				Self.user.didAfterEveryMove(0, 0)
			EndIf
			
			While (True)
				If (Self.moveDistanceX <> 0 Or Self.moveDistanceY <> 0) Then
					Self.chkPointX = Self.acObj.posX
					Self.chkPointY = Self.acObj.posY
					
					Local startPointX:= Self.chkPointX
					Local startPointY:= Self.chkPointY
					
					checkInSky()
					
					Self.acObj.posX = Self.chkPointX
					Self.acObj.posY = Self.chkPointY
					
					Self.user.didAfterEveryMove(Self.chkPointX - startPointX, Self.chkPointY - startPointY)
				Else
					Return
				EndIf
			Wend
		End
		
		Method checkInSky:Void()
			Local xFirst:Bool
			
			If (Abs(Self.moveDistanceX) > Abs(Self.moveDistanceY)) Then
				xFirst = True
			Else
				xFirst = False
			EndIf
			
			Local startPointX:= Self.chkPointX
			Local startPointY:= Self.chkPointY
			Local i:Int
			Local i2:Int
			
			If (xFirst) Then
				If (Abs(Self.moveDistanceX) > Self.worldInstance.getTileWidth()) Then
					i = Self.chkPointX
					
					If (Self.moveDistanceX > 0) Then
						i2 = 1
					Else
						i2 = -1
					EndIf
					
					Self.chkPointX = i + (i2 * Self.worldInstance.getTileWidth())
					Self.chkPointY += (Self.moveDistanceY * Self.worldInstance.getTileWidth()) / Abs(Self.moveDistanceX)
				Else
					Self.chkPointX += Self.moveDistanceX
					Self.chkPointY += Self.moveDistanceY
				EndIf
				
			ElseIf (Abs(Self.moveDistanceY) > Self.worldInstance.getTileHeight()) Then
				i = Self.chkPointY
				
				If (Self.moveDistanceY > 0) Then
					i2 = 1
				Else
					i2 = -1
				EndIf
				
				Self.chkPointY = i + (i2 * Self.worldInstance.getTileHeight())
				Self.chkPointX += (Self.moveDistanceX * Self.worldInstance.getTileHeight()) / Abs(Self.moveDistanceY)
			Else
				Self.chkPointX += Self.moveDistanceX
				Self.chkPointY += Self.moveDistanceY
			EndIf
			
			Local preMoveDistanceX:= Self.moveDistanceX
			Local preMoveDistanceY:= Self.moveDistanceY
			
			Self.moveDistanceX -= Self.chkPointX - startPointX
			Self.moveDistanceY -= Self.chkPointY - startPointY
			
			If (Self.moveDistanceX * preMoveDistanceX <= 0) Then
				Self.moveDistanceX = 0
			EndIf
			
			If (Self.moveDistanceY * preMoveDistanceY <= 0) Then
				Self.moveDistanceY = 0
			EndIf
		End
End