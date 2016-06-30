Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.backgroundmanager
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStage1 Extends BackGroundManager
	Private
		' Constant variable(s):
		Const FILE_NAME:String = "/stage1_bg.png"
		
		Const POS_X_SPEED_DIVIDE:Int = 64
		
		Global BG_CUT_HEIGHT_N:Int[] = [8, 16, 16, 56, 2, 4, 5, 6, 7, 8, 9, 11, 12] ' Const
		Global BG_CUT_HEIGHT_W:Int[] = [MyAPI.zoomIn(36, True), MyAPI.zoomIn(32, True), MyAPI.zoomIn(32, True), MyAPI.zoomIn(112, True), MyAPI.zoomIn(32, True), MyAPI.zoomIn(32, True), MyAPI.zoomIn(32, True), MyAPI.zoomIn(32, True), MyAPI.zoomIn(20, True)] ' Const
		Global CAMERA_POS_X_SPEED_N:Int[] = [0, 0, 0, 0, 4, 5, 6, 7, 8, 10, 12, 16, 22] ' Const
		Global CAMERA_POS_X_SPEED_W:Int[] = [0, 0, 0, 0, MyAPI.zoomIn(4, True), MyAPI.zoomIn(8, True), MyAPI.zoomIn(12, True), MyAPI.zoomIn(16, True), MyAPI.zoomIn(20, True)] ' Const
		Global POS_X_SPEED_N:Int[] = [32, 16, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0] ' Const
		Global POS_X_SPEED_W:Int[] = [MyAPI.zoomIn(32, True), MyAPI.zoomIn(16, True), MyAPI.zoomIn(8, True), 0, 0, 0, 0, 0, 0] ' Const
		
		' Global variable(s):
		Global IMAGE_WIDTH:Int = 256
		
		Global BG_CUT_HEIGHT:Int[] = BG_CUT_HEIGHT_N
		Global CAMERA_POS_X_SPEED:Int[] = CAMERA_POS_X_SPEED_N
		Global POS_X_SPEED:Int[] = POS_X_SPEED_N
		
		' Fields:
		Field imageBG:MFImage[]
		
		Field posX:Int[]
	Public
		' Constructor(s):
		Method New()
			Self.posX = New Int[BG_CUT_HEIGHT.Length]
			
			Self.imageBG = New MFImage[4]
			
			Self.imageBG[0] = MFImage.createImage("/map/stage1_bg/#1.png")
			
			For Local i:= 1 Until 4 ' Self.imageBG.Length
				Self.imageBG[i] = MFImage.createPaletteImage("/map/stage1_bg/#" + (i + 1) + ".pal")
			Next
			
			IMAGE_WIDTH = MyAPI.zoomIn(Self.imageBG[0].getWidth(), True)
		End
		
		' Methods:
		Method close:Void()
			Self.posX = []
			
			If (Self.imageBG.Length > 0) Then
				For Local i:= 0 Until Self.imageBG.Length
					If (MFImage.releaseImage(Self.imageBG[i])) Then
						Self.imageBG[i] = Null
					EndIf
				Next
			EndIf
			
			Self.imageBG = []
		End
		
		Method draw:Void(g:MFGraphics)
			Local cameraX:= MapManager.getCamera().x
			Local tmpframe:= ((frame Mod 16) / 4)
			
			Local y:= 0
			
			For Local i:= 0 Until BG_CUT_HEIGHT.Length
				If (Not GameObject.IsGamePause) Then
					Self.posX[i] += POS_X_SPEED[i]
				EndIf
				
				Local drawX:= -((((CAMERA_POS_X_SPEED[i] * cameraX) / POS_X_SPEED_DIVIDE) + (Self.posX[i] Shr 6)) Mod IMAGE_WIDTH)
				
				Local j:= 0
				
				While (j < (MapManager.CAMERA_WIDTH - drawX))
					MyAPI.drawRegion(g, Self.imageBG[tmpframe], 0, y, IMAGE_WIDTH, BG_CUT_HEIGHT[i], 0, drawX + j, y, 20)
					
					j += IMAGE_WIDTH
				Wend
				
				y += BG_CUT_HEIGHT[i]
			Next
		End
End