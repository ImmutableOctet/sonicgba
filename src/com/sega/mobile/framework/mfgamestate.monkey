Strict

Public

' Imports:
Private
	Import com.sega.mobile.mdversion
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Interfaces:
Interface MFGameState
	' Constant variable(s):
	Const VERSION:= MDVersion.VERSION
	
	' Methods:
	Method getFrameTime:Int() ' Long
	
	' Callbacks:
	Method onEnter:Void()
	Method onExit:Void()
	Method onPause:Void()
	Method onRender:Void(mFGraphics:MFGraphics)
	Method onRender:Void(mFGraphics:MFGraphics, layer:Int)
	Method onResume:Void()
	Method onTick:Void()
	Method onVolumeDown:Void()
	Method onVolumeUp:Void()
End