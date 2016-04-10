Strict

Public

' Imports:
Private
	Import com.sega.mobile.define.mdphone
	
	Import sonicgba.ballhobin
Public

' Classes:
Class RollHobin Extends BallHobin
	Private
		' Constant variable(s):
		Const DEGREE_VELOCITY:Int = -4
		
		' Global variable(s):
		Global degree:Int
	Private
		' Fields:
		Field centerX:Int
		Field centerY:Int
		Field degreeOffset:Int
		Field radius:Int
	Public

	Protected
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.radius = Max(Self.mWidth, Self.mHeight)
			
			Self.centerX = Self.posX
			Self.centerY = Self.posY
			
			calHobinPosition()
			
			Self.degreeOffset = ((Self.iLeft * MDPhone.SCREEN_WIDTH) / 8)
		End
	Private
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
			degree += MDPhone.SCREEN_WIDTH
			degree Mod= MDPhone.SCREEN_WIDTH
		End

		Method close:Void()
		End
		
		' Functions:
		Function releaseAllResource:Void()
		End
End