Strict

Public

' Classes:
Class Direction
	Public
		' Constant variable(s):
		Const UP:Int = -1
		Const DOWN:Int = 1
		Const NONE:Int = 0
		Const LEFT:Int = -1
		Const RIGHT:Int = 1
	Private
		' Fields:
		Field directionX:Int
		Field directionY:Int
	Public
		' Constructor(s):
		Method New(x:Int, y:Int)
			Self.directionX = x
			Self.directionY = y
		End
		
		Method New(srcX:Int, srcY:Int, desX:Int, desY:Int)
			If (srcX > desX) Then
				Self.directionX = LEFT
			ElseIf (srcX < desX) Then
				Self.directionX = RIGHT
			Else
				Self.directionX = NONE
			EndIf
			
			If (srcY > desY) Then
				Self.directionY = UP
			ElseIf (srcY < desY) Then
				Self.directionY = DOWN
			Else
				Self.directionY = NONE
			EndIf
		End
		
		' Methods:
		Method getReverse:Direction()
			Return New Direction(-Self.directionX, -Self.directionY)
		End
		
		Method getValueX:Int(x:Int)
			Return (Self.directionX * Abs(x))
		End
		
		Method getValueY:Int(y:Int)
			Return (Self.directionY * Abs(y))
		End
		
		Method sameDirectionX:Bool(v:Int)
			If ((Self.directionX * v) < 0) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method sameDirectionY:Bool(v:Int)
			If ((Self.directionY * v) < 0) Then
				Return False
			EndIf
			
			Return True
		End
End