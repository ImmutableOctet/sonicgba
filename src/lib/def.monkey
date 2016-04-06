Strict

Public

' Imports:
Private
	Import gameengine.def
Public

' Aliases:
Private
	Alias engineDef = gameengine.def.Def
Public

' Constant variable(s):
Global FONT:= engineDef.FONT ' Const
Global FONT_H:= engineDef.FONT_H ' Const
Global FONT_H_HALF:= (FONT_H / 2) ' Const
Global LINE_SPACE:= (FONT_H + 2) ' Const

' Interfaces:
Interface Def
	Public
		' Constant variable(s):
		Const BOLD_STRING:Bool = True
		Const EN_VERSION:Bool = False
		Const USE_BMF:Bool = False
End