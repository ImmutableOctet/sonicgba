Strict

Public

' Imports:
Private
	Import com.sega.engine.lib.myapi
	
	Import monkey.math
Public

' Classes:
Class ACUtilities
	' Functions:
	Function getQuaParam:Int(x:Int, divide:Int)
		If (x > 0) Then
			Return (x / divide)
		EndIf
		
		Return ((x - (divide - 1)) / divide)
	End

	Function getRelativePointX:Int(originalX:Int, offsetX:Int, offsetY:Int, degree:Int)
		Return (((Cos(degree) * offsetX) / 100) + originalX) - ((Sin(degree) * offsetY) / 100)
	End

	Function getRelativePointY:Int(originalY:Int, offsetX:Int, offsetY:Int, degree:Int)
		Return (((Sin(degree) * offsetX) / 100) + originalY) + ((Cos(degree) * offsetY) / 100)
	End

	Function getTotalFromDegree:Int(x:Int, y:Int, degree:Int)
		Return (((Cos(degree) * x) + (Sin(degree) * y)) / 100)
	End

	Function getNewXFromDegree:Int(x:Int, y:Int, degree:Int)
		Return ((Cos(degree) * getTotalFromDegree(x, y, degree)) / 100)
	End

	Function getNewXFromDegree:Int(total:Int, degree:Int)
		Return ((Cos(degree) * total) / 100)
	End

	Function getNewYFromDegree:Int(x:Int, y:Int, degree:Int)
		Return ((Sin(degree) * getTotalFromDegree(x, y, degree)) / 100)
	End

	Function getNewYFromDegree:Int(total:Int, degree:Int)
		Return ((Sin(degree) * total) / 100)
	End
End