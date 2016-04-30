Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.ballhobin
Public

' Classes:
Class RollHobin Extends BallHobin
	Private
		' Constant variable(s):
		Const DEGREE_VELOCITY:Int = -4
		
		' Global variable(s):
		Global degree:Int
		
		' Fields:
		Field centerX:Int
		Field centerY:Int
		Field degreeOffset:Int
		Field radius:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.radius = Max(Self.mWidth, Self.mHeight)
			
			Self.centerX = Self.posX
			Self.centerY = Self.posY
			
			calHobinPosition()
			
			Self.degreeOffset = ((Self.iLeft * 360) / 8)
		End
	Private
		' Methods:
		Method calHobinPosition:Void()
			Self.posX = Self.centerX + ((Self.radius * MyAPI.dCos(degree + Self.degreeOffset)) / 100)
			Self.posY = Self.centerY + ((Self.radius * MyAPI.dSin(degree + Self.degreeOffset)) / 100)
		End
	Public
		' Methods:
		Method logic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			calHobinPosition()
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End

		Function staticLogic:Void()
			degree += DEGREE_VELOCITY
			degree += 360
			degree Mod= 360
		End

		Method close:Void()
			' Empty implementation.
		End
		
		' Functions:
		Function releaseAllResource:Void()
			' Empty implementation.
		End
End