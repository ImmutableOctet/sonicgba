Strict

Public

' Preprocessor related:
#MONKEYLANG_EXTENSION_WIDECHARACTERS = True

#GLFW_USE_MINGW = False

'#SONICGBA_EASTEREGGS = True
'#SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_INDICES = True

#IOUTIL_PUBLICDATASTREAM_LEGACY_BIG_ENDIAN = False
#IOUTIL_ENDIANSTREAM_LEGACY_BIG_ENDIAN = False

#If TARGET = "glfw" Or TARGET = "stdcpp"
	#SONICGBA_FILESYSTEM_ENABLED = True
#End

#MOJO_IMAGE_FILTERING_ENABLED = False ' True

' Imports:
Import application

' Functions:
Function Main:Int()
	New Application()
	
	Return 0
End