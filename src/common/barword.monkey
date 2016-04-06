Strict

Public

' Imports:
Private
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Interfaces:
Interface BarWord
	' Methods:
	Method drawWord:Void(mFGraphics:MFGraphics, wordID:Int, x:Int, y:Int)
	Method getWordLength:Int(wordID:Int)
End