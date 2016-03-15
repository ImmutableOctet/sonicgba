Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.soundsystem
	Import lib.crlfp32
	
	Import special.specialmap
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import sonicgba.gimmickobject
Public

' Classes:
Class RopeStart Extends GimmickObject
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:= 1024
		Const COLLISION_HEIGHT:= 2560
		
		' Fields:
		Field degree:Int
	Private
		' Constant variable(s):
	    Const DRAW_HEIGHT:= 24
	    Const DRAW_WIDTH:= 16
	    Const MAX_VELOCITY:= 1800
		
		' Global variable(s):
	    Global hookImage2:MFImage
		
		' This variable should be considered constant.
		Global DEGREE:= crlFP32.actTanDegree(1, 2)
		
		' Fields:
    	Field controlling:Bool
    	Field initFlag:Bool
    	
		Field posOriginalX:Int
    	Field posOriginalY:Int
		
    	Field velocity:Int
End