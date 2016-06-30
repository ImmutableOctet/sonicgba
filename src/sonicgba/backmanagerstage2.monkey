Strict

Public

' Imports:
Private
	Import gameengine.def
	
	Import lib.myapi
	
	Import sonicgba.backgroundmanager
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStage2 Extends BackGroundManager
	Private
		' Constant variable(s):
		Const FILE_NAME_1:String = "/stage2_bg_0.png"
		Const FILE_NAME_2:String = "/stage2_bg_1.png"
		
		Global IMAGE_2_CUT_N:Int[][] = [[0, 0, 256, 64], [0, 64, 256, 16], [0, 80, 256, 24]] ' Const
		Global LINE_2_OFFSET_N:Int[] = [64, 64, 128] ' Const
		
		Global X_DRAW_NUM:Int = (SCREEN_WIDTH + ((STAGE_BG_WIDTH - 1) * 2)) / STAGE_BG_WIDTH ' Const
		
		' Global variable(s):
		Global IMAGE_WIDTH:Int = 256
		Global STAGE_BG_WIDTH:Int = 256 ' IMAGE_WIDTH
		
		' Fields:
		Field image1:MFImage
		
		Field imageBG2:MFImage[]
	Public
		' Constructor(s):
		Method New()
			If (stageId = 2) Then
				Self.image1 = MFImage.createImage("/map/stage2_bg_0.png")
				
				IMAGE_WIDTH = MyAPI.zoomIn(Self.image1.getWidth(), True)
			EndIf
			
			Self.imageBG2 = New MFImage[8]
			
			Self.imageBG2[0] = MFImage.createImage("/map/stage2_bg_1/#1.png")
			
			For Local i:= 1 Until Self.imageBG2.Length
				Self.imageBG2[i] = MFImage.createPaletteImage("/map/stage2_bg_1/#" + String(i + 1) + ".pal")
			Next
			
			STAGE_BG_WIDTH = MyAPI.zoomIn(Self.imageBG2[0].getWidth(), True)
		End
		
		' Methods:
		Method close:Void()
			If (MFImage.releaseImage(Self.image1)) Then
				Self.image1 = Null
			EndIf
			
			If (Self.imageBG2.Length > 0) Then
				For Local i:= 0 Until Self.imageBG2.Length
					If (MFImage.releaseImage(Self.imageBG2[i])) Then
						Self.imageBG2[i] = Null
					EndIf
				Next
			EndIf
			
			Self.imageBG2 = []
		End
		
		Method draw:Void(g:MFGraphics)
			If (stageId = 2) Then
				drawStage1(g)
			Else
				drawStage2(g)
			EndIf
		End
		
		Method drawStage1:Void(g:MFGraphics)
			Local cameraX:= MapManager.getCamera().x
			
			If (cameraX <= 1456) Then
				g.setColor(1054752)
				
				MyAPI.fillRect(g, DRAW_X, DRAW_Y, DRAW_WIDTH, DRAW_HEIGHT)
				
				Local j:= 0
				
				While (j < MapManager.CAMERA_WIDTH)
					MyAPI.drawImage(g, Self.image1, (-(cameraX / 74)) + j, (SCREEN_HEIGHT / 2), 6) ' Shr 1
					
					j += IMAGE_WIDTH
				Wend
			Else
				drawType2(g)
			EndIf
		End
		
		Method drawStage2:Void(g:MFGraphics)
			drawType2(g)
		End
		
		Method drawType2:Void(g:MFGraphics)
			Local tmpframe:= ((frame Mod (Self.imageBG2.Length * 3)) / 3)
			
			Local cameraX:= MapManager.getCamera().x
			Local cameraY:= MapManager.getCamera().y
			
			Local startX:= (-((cameraX / 4) Mod STAGE_BG_WIDTH))
			Local startY:= (-((cameraY / 4) Mod 64))
			
			For Local x:= 0 Until X_DRAW_NUM
				For Local y:= 0 Until 6
					MyAPI.drawImage(g, Self.imageBG2[tmpframe], IMAGE_2_CUT_N[0][0], IMAGE_2_CUT_N[0][1], IMAGE_2_CUT_N[0][2], IMAGE_2_CUT_N[0][3], 0, (STAGE_BG_WIDTH * x) + startX, (y * 64) + startY, 20)
				Next
			Next
			
			startX = -((cameraX / 2) Mod STAGE_BG_WIDTH)
			startY = (-((cameraY / 2) Mod 256)) + 112
			
			For Local x:= 0 Until X_DRAW_NUM
				Local i:= 0
				Local y2:= startY
				
				While (y2 < (DRAW_HEIGHT + 16))
					If (y2 > -16) Then
						MyAPI.drawImage(g, Self.imageBG2[tmpframe], IMAGE_2_CUT_N[1][0], IMAGE_2_CUT_N[1][1], IMAGE_2_CUT_N[1][2], IMAGE_2_CUT_N[1][3], 0, (STAGE_BG_WIDTH * x) + startX, y2, 20)
					EndIf
					
					y2 += LINE_2_OFFSET_N[i]
					
					i = ((i + 1) Mod LINE_2_OFFSET_N.Length)
				Wend
			Next
			
			startX = -(((cameraX * 2) / 3) Mod STAGE_BG_WIDTH)
			startY = ((-(((cameraY * 2) / 3) Mod 256)) + 200)
			
			For Local x:= 0 Until X_DRAW_NUM
				For Local y2:= startY Until (DRAW_HEIGHT + 24) Step 256 ' STAGE_BG_WIDTH
					If (y2 > -24) Then
						MyAPI.drawImage(g, Self.imageBG2[tmpframe], IMAGE_2_CUT_N[2][0], IMAGE_2_CUT_N[2][1], IMAGE_2_CUT_N[2][2], IMAGE_2_CUT_N[2][3], 0, (STAGE_BG_WIDTH * x) + startX, y2, 20)
					EndIf
				Next
			Next
		End
End