Strict

Public

' Imports:
Private
	Import com.sega.engine.action.accollision
Public

' Classes:
Class ACDegreeGetter Abstract
	Method getDegreeFromCollisionByPosition:Void(degreeReturner:DegreeReturner, aCCollision:ACCollision, i:Int, i2:Int, i3:Int, i4:Int) Abstract

	Method getDegreeFromWorldByPosition:Void(degreeReturner:DegreeReturner, i:Int, i2:Int, i3:Int, i4:Int) Abstract
End

Class DegreeReturner
	' Fields:
	Field degree:Int
	Field newX:Int
	Field newY:Int
	
	Field degreeCalSuccess:Bool

	' Methods:
	Method reset:Void(x:Int, y:Int, degree:Int)
		Self.newX = x
		Self.newY = y
		Self.degree = degree
		
		Self.degreeCalSuccess = False
	End
End