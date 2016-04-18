Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.backgroundmanager
	Import sonicgba.
	Import sonicgba.
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStage62 Extends BackGroundManager
	Private
		' Constant variable(s):
		Global LIGHT_PARAM:Int[][] = [[0, 120, 256, 16], [0, 176, 256, 16]] ' Const
		
		' Global variable(s):
		Global IMAGE_WIDTH:Int = 256
		Global IMAGE_HEIGHT:Int = 232
		
		Global bgImage:MFImage[]
		
		' Fields:
		Field lightX:Int[]
	Public
		' Constructor(s):
		Method New()
			Self.lightX = New Int[LIGHT_PARAM.Length]
			
			If (bgImage.Length = 0) Then
				bgImage = New MFImage[4]
				
				For Local i:= 0 Until bgImage.Length ' 4
					bgImage[i] = MFImage.createImage("/map/stage6_bg_3/#" + String(i + 1) + ".png")
				Next
				
				IMAGE_WIDTH = bgImage[0].getWidth()
				IMAGE_HEIGHT = bgImage[0].getHeight()
			EndIf
		End
		
		' Methods:
		Method close:Void()
			If (bgImage.Length > 0) Then
				For Local i:= 0 Until bgImage.Length ' 4
					bgImage[i] = Null
				Next
			EndIf
			
			bgImage = []
		End
		
		Method draw:Void(g:MFGraphics)
			Local cameraX:= MapManager.getCamera().x
			Local cameraY:= MapManager.getCamera().y
			Local tmpframe:= ((frame Mod (bgImage.Length * 2)) / 2)
			
			MyAPI.drawImage(g, bgImage[tmpframe], 0, 0, IMAGE_WIDTH, IMAGE_HEIGHT, 0, (-cameraX) / 46, (-cameraY) / 33, 0)
			MyAPI.drawImage(g, bgImage[tmpframe], 0, 0, IMAGE_WIDTH, IMAGE_HEIGHT, 2, IMAGE_WIDTH + ((-cameraX) / 46), (-cameraY) / 33, 0)
			
			For Local i:= 0 Until LIGHT_PARAM.Length
				For Local j:= 0 Until ((SCREEN_WIDTH + 255) / 256) + 2
					MyAPI.drawImage(g, bgImage[tmpframe], LIGHT_PARAM[i][0], LIGHT_PARAM[i][1], LIGHT_PARAM[i][2], LIGHT_PARAM[i][3], 0, ((j - 1) * 256) + (((-(cameraX / 38)) Mod 256) + (Self.lightX[i] Shr 6)), LIGHT_PARAM[i][1] + ((-cameraY) / 33), 0)
				Next
				
				If (Not GameObject.IsGamePause) Then
					If (i = 0) Then
						Self.lightX[i] += 120
					Else
						Self.lightX[i] -= 120
					EndIf
					
					Self.lightX[i] += 16384
					Self.lightX[i] Mod= 16384
				EndIf
			EndIf
		End
End