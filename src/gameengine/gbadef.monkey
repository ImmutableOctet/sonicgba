Strict

Public

' Imports:
' Nothing so far.

' Constant variable(s):
#If Not SONICGBA_RESOLUTION_TEST
	Const GBA_WIDTH:= 240
	Const GBA_HEIGHT:= 160
	
	' This is the 16:9 equivalent of 'GBA_WIDTH'.
	Const GBA_EXT_WIDTH:= 284
#Else
	Const GBA_WIDTH:= 0
	Const GBA_HEIGHT:= 320
	
	Const GBA_EXT_WIDTH:= 568
#End