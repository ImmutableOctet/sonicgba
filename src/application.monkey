Strict

Public

' Imports:
Private
	'Import mflib.mainstate
Public

Import mojo.app

' Classes:
Class Application Extends App
	' Methods:
	Method OnCreate:Int()
		SetUpdateRate(0) ' 60 ' 30
		
		Seed = Millisecs()
		
		Return 0
	End
	
	Method OnUpdate:Int()
		Return 0
	End
	
	Method OnRender:Int()
		Return 0
	End
	
	Method OnClose:Int()
		Return Super.OnClose()
	End
End