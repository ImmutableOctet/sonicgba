Strict

Public

' Friends:
Friend com.sega.engine.action.acworldcollisioncalculator
Friend com.sega.engine.action.acobject

' Imports:
Private
	Import com.sega.engine.lib.myapi
	
	import com.sega.engine.action.acmovecaluser
	import com.sega.engine.action.acobject
	import com.sega.engine.action.acworld
	
	Import lib.constutil
Public

' Classes:
Class ACMoveCalculator
	Protected
		' Fields:
		Field acObj:ACObject
		
		Field moveDistanceX:Int
		Field moveDistanceY:Int
		
		Field user:ACMoveCalUser
		Field worldInstance:ACWorld
	Private
		' Fields:
		Field chkPointX__mcalc:Int
		Field chkPointY__mcalc:Int
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
		
		Method actionLogic:Void(moveDistanceX:Int, moveDistanceY:Int, totalVelocity:Int)
			actionLogic(moveDistanceX, moveDistanceY)
		End
		
		Method stopMove:Void(degree:Int)
			Local moveDistanceY2:= (((-Self.moveDistanceX) * MyAPI.dSin(degree)) + (Self.moveDistanceY * MyAPI.dCos(degree))) ' / 1
			
			If (((Self.moveDistanceX * MyAPI.dCos(degree)) + (Self.moveDistanceY * MyAPI.dSin(degree))) > 0) Then ' / 1
				' Magic number: 10000
				Self.moveDistanceX = ((-moveDistanceY2) * MyAPI.dSin(degree)) / 10000
				Self.moveDistanceY = (MyAPI.dCos(degree) * moveDistanceY2) / 10000
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
		' Methods:
		Method checkInMap:Void()
			If (Self.moveDistanceX = 0 And Self.moveDistanceY = 0) Then
				Self.user.didAfterEveryMove(0, 0)
			EndIf
			
			While (Self.moveDistanceX <> 0 Or Self.moveDistanceY <> 0)
				Self.chkPointX__mcalc = Self.acObj.posX
				Self.chkPointY__mcalc = Self.acObj.posY
				
				Local startPointX:= Self.chkPointX__mcalc
				Local startPointY:= Self.chkPointY__mcalc
				
				checkInSky()
				
				Self.acObj.posX = Self.chkPointX__mcalc
				Self.acObj.posY = Self.chkPointY__mcalc
				
				Self.user.didAfterEveryMove(Self.chkPointX__mcalc - startPointX, Self.chkPointY__mcalc - startPointY)
			Wend
		End
		
		Method checkInSky:Void()
			Local xFirst:Bool = (Abs(Self.moveDistanceX) > Abs(Self.moveDistanceY))
			
			Local startPointX:= Self.chkPointX__mcalc
			Local startPointY:= Self.chkPointY__mcalc
			
			Local i:Int
			Local i2:Int
			
			If (xFirst) Then
				If (Abs(Self.moveDistanceX) > Self.worldInstance.getTileWidth()) Then
					Self.chkPointX__mcalc += (DSgn((Self.moveDistanceX > 0)) * Self.worldInstance.getTileWidth())
					Self.chkPointY__mcalc += ((Self.moveDistanceY * Self.worldInstance.getTileWidth()) / Abs(Self.moveDistanceX))
				Else
					Self.chkPointX__mcalc += Self.moveDistanceX
					Self.chkPointY__mcalc += Self.moveDistanceY
				EndIf
			ElseIf (Abs(Self.moveDistanceY) > Self.worldInstance.getTileHeight()) Then
				Self.chkPointY__mcalc += (DSgn((Self.moveDistanceY > 0)) * Self.worldInstance.getTileHeight())
				Self.chkPointX__mcalc += ((Self.moveDistanceX * Self.worldInstance.getTileHeight()) / Abs(Self.moveDistanceY))
			Else
				Self.chkPointX__mcalc += Self.moveDistanceX
				Self.chkPointY__mcalc += Self.moveDistanceY
			EndIf
			
			Local preMoveDistanceX:= Self.moveDistanceX
			Local preMoveDistanceY:= Self.moveDistanceY
			
			Self.moveDistanceX -= (Self.chkPointX__mcalc - startPointX)
			Self.moveDistanceY -= (Self.chkPointY__mcalc - startPointY)
			
			If ((Self.moveDistanceX * preMoveDistanceX) <= 0) Then
				Self.moveDistanceX = 0
			EndIf
			
			If ((Self.moveDistanceY * preMoveDistanceY) <= 0) Then
				Self.moveDistanceY = 0
			EndIf
		End
End