Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.backgroundmanager
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStageFinal Extends BackGroundManager
	Private
		' Global variable(s):
		Global bgImage:MFImage ' Field
		
		' Fields:
		Field height:Int
	Public
		' Constructor(s):
		Method New()
			If (bgImage = Null) Then
				bgImage = MFImage.createImage("/map/final_bg.png")
			EndIf
			
			Self.Height = 20
		End
		
		' Methods:
		Method close:Void()
			bgImage = Null ' Self.bgImage
		End
		
		' This method and similar behavior will likely be replaced with Mojo.
		Method draw:Void(graphics:MFGraphics)
			' DRAW 'bgImage' HERE.
			
			Return
		End
End