Strict

Public

' Preprocessor related:
#MONKEYLANG_EXTENSION_WIDECHARACTERS = True

#GLFW_USE_MINGW = False

'#SONICGBA_EASTEREGGS = True

#If TARGET = "glfw" Or TARGET = "stdcpp"
	#SONICGBA_FILESYSTEM_ENABLED = True
#End

' Imports:
Import application

' Functions:
Function Main:Int()
	New Application()
	
	Return 0
End