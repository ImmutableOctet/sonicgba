Strict

Public

' Imports:
Private
	Import cerberus.random
	
	Import regal.typetool
Public

' Classes:
Class MyRandom
	' Functions:
	Function nextInt:Int(min:Int, max:Int)
		Return ((Abs(nextInt()) Mod (Abs(max - min) + 1)) + Min(min, max))
	End

	Function nextInt:Int(range:Int)
		Return (Abs(nextInt()) Mod range)
	End

	Function nextInt:Int()
		Return Int(Rnd(-(INT_MAX-1), INT_MAX))
	End
End