Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import com.sega.mobile.define.mdphone
	
	'Import sonicgba.gimmickobject
Public

' Classes:
Class MoveCalculator
	Private
		' Constant variable(s):
		Const DEGREE_VELOCITY:Int = 5
		Const HALF_MOVE_TIME:Int = (MOVE_TIME / 2) ' 17
		Const MOVE_TIME:Int = 34
		
		' Global variable(s):
		Global degree:Int
		
		Global isSide:Bool = False
		Global moveCount:Int
		Global moveCount2:Int
		
		' Fields:
		Field centerPosition:Int
		Field position:Int
		Field radius:Int
		
		Field ratio:Bool
	Public
		' Global variable(s):
		Global direction:Bool
		
		' Functions:
		Function staticLogic:Void()
			If (direction) Then
				isSide = False
				
				moveCount2 += 1
				
				If (moveCount2 > MOVE_TIME) Then
					moveCount2 = MOVE_TIME
					
					direction = False
					isSide = True
				EndIf
			Else
				isSide = False
				
				moveCount2 -= 1
				
				If (moveCount2 < 0) Then
					moveCount2 = 0
					
					direction = True
					isSide = True
				EndIf
			EndIf
			
			moveCount = (moveCount2 - HALF_MOVE_TIME)
			
			degree += DEGREE_VELOCITY
			degree Mod= 360
		End
		
		' Constructor(s):
		Method New(centerPosition:Int, radius:Int, ratio:Bool)
			Self.centerPosition = centerPosition
			Self.radius = radius
			Self.ratio = ratio
			Self.position = centerPosition
			
			isSide = False
		End
		
		' Methods:
		Method getSide:Bool()
			Return (degree = 90 Or degree = 270)
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method getPosition:Int()
			Return (Self.centerPosition + ((MyAPI.dSin(degree) * Self.radius) / 100))
		End
End
