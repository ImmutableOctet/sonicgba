Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.backgroundmanager
	Import sonicgba.gameobject
	
	'Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStageExtra Extends BackGroundManager
	Private
		' Constant variable(s):
		Global DIVIDE_PARAM:Int[][] = [[0, 0, 284, 91], [0, 91, 256, 10], [0, 101, 256, 5], [0, 106, 256, 7], [0, 113, 256, 15], [0, 128, 256, 2], [0, 130, 256, 3], [0, 133, 256, 4], [0, 137, 256, 5], [0, 142, 256, 5], [0, 147, 256, 6], [0, 153, 256, 7]] ' Const
		Global DIVIDE_VELOCITY:Int[] = [0, 15, 30, 60, 120, 240, 360, 480, 600, 720, 840, 960] ' Const
		
		' Global variable(s):
		Global bgImage:MFImage ' Field
		
		' Fields:
		Field xOffset:Int[]
	Public
		' Constructor(s):
		Method New()
			bgImage = MFImage.createImage("/map/ex_bg_1.png")
			
			Self.xOffset = New Int[DIVIDE_VELOCITY.Length]
		End
		
		' Methods:
		Method close:Void()
			bgImage = Null
			
			Self.xOffset = []
		End
		
		Method draw:Void(g:MFGraphics)
			g.setColor(0)
			
			MyAPI.fillRect(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			For Local i:= 0 Until DIVIDE_VELOCITY.Length
				For Local j:= 0 Until 4
					MyAPI.drawImage(g, bgImage, DIVIDE_PARAM[i][0], DIVIDE_PARAM[i][1], DIVIDE_PARAM[i][2], DIVIDE_PARAM[i][3], 0, ((j - 1) * 256) + (((-Self.xOffset[i]) / 256) + (SCREEN_WIDTH / 2)), DIVIDE_PARAM[i][1], 17)
				Next
				
				If (Not GameObject.IsGamePause) Then
					Local iArr:= Self.xOffset
					
					iArr[i] += DIVIDE_VELOCITY[i]
					iArr[i] Mod= 65536
				EndIf
			Next
		End
End