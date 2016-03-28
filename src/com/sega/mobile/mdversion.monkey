Strict

Public

' Imports:
' Nothing so far.

' Interfaces:
Interface MDVersion
	#If CONFIG = "debug"
		Const DEBUG_VERSION:Bool = True ' False
	#Else
		Const DEBUG_VERSION:Bool = False
	#End
	
	Const VERSION:Int = 104
End