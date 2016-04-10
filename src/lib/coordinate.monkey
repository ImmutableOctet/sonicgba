Strict

Public

' Classes:
Class Coordinate
	Private
		' Global variable(s):
		Global returnInstance:Coordinate = New Coordinate()
	Public
		' Functions:
		Function returnCoordinate:Coordinate(x:Int, y:Int)
			returnInstance.setValue(x, y)
			
			Return returnInstance
		End
		
		' Fields:
		Field x:Int
		Field y:Int
		
		' Constructor(s):
		Method New()
			setValue(0, 0)
		End
		
		Method New(mx:Int, my:Int)
			setValue(mx, my)
		End
		
		' Methods:
		Method setValue:Void(mx:Int, my:Int)
			Self.x = mx
			Self.y = my
		End
		
		Method equals:Bool(v:Coordinate)
			If (Self.x = v.x And Self.y = v.y) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method inTheArea:Bool(area:Coordinate[])
			For Local v:= EachIn area
				If (equals(v)) Then
					Return True
				EndIf
			Next
			
			Return False
		End
End