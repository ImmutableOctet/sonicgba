Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.constutil
	
	Import gameengine.def
	Import gameengine.gbadef
	
	Import sonicgba.backgroundmanager
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStageFinal Extends BackGroundManager
	Private
		' Global variable(s):
		'Global bgImage:MFImage
		
		' Fields:
		Field bgImage:MFImage
		
		Field height:Int
	Public
		' Constructor(s):
		Method New()
			'If (bgImage = Null) Then
			bgImage = MFImage.createImage("/map/final_bg.png")
			'EndIf
			
			' Magic number: 20
			Self.height = 20
		End
		
		' Methods:
		Method close:Void()
			If (MFImage.releaseImage(bgImage)) Then
				bgImage = Null
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			g.setColor(0)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			Local cameraX:= MapManager.getCamera().x
			Local cameraY:= MapManager.getCamera().y
			
			' Magic numbers: 43, -12
			Local x:= (Max(((-cameraX) / 43), -12) - GBA_EXT_WIDTH + SCREEN_WIDTH) ' 284
			
			Local y:= ((-cameraY) / 18) + Self.height
			
			If (y > 0) Then
				y = 0
			EndIf
			
			MyAPI.drawImage(g, bgImage, x, y, 0)
		End
End