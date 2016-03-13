Strict

Public

' Imports:
Import gameengine.def

' Interfaces:
Interface SonicDef Extends Def
	' Constant variable(s):
	Const ALPHA_CHANGE_STATE:= True
	Const ANIMATION_PATH:= "/animation"
	
	' Directions:
	Const DIRECTION_UP:=			0
	Const DIRECTION_DOWN:=			1
	Const DIRECTION_LEFT:=			2
	Const DIRECTION_RIGHT:=			3
	Const DIRECTION_NONE:=			4
	
	Const MENU_SPACE:=		20
	Const NO_WATER:=		-1
	Const OVER_TIME:=		599999
	
	Const PI:= 201
	
	Const STAGE_PATH:= "/map"
	
	Const TITLE_HEIGHT:= 8
	Const TITLE_WIDTH:= 8
	Const TITLE_WIDTH_ZOOM:= 512
	Const TITLE_ZOOM:= 3
	Const TITLE_PATH:= "/title"
	
	' May or may not be relevant in future versions.
	Const TOUCH_ANI_PACH:= "/tuch"
	
	Const UTL_PATH:= "/utl"
	Const UTL_RES:= "/animation/utl_res"
	
	Const ZOOM:= 6
End