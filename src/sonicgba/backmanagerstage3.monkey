Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.myrandom
	
	Import sonicgba.backgroundmanager
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BackManagerStage3 Extends BackGroundManager
	Private
		' Constant variable(s):
		Const FILE_NAME:String = "/stage3_bg.png"
		
		Global CLIP_SPEED_N1:Int[] = [427, 32, 16, 8, 4, 2] ' Const
		Global CLIP_SPEED_N2:Int[] = [463, 32, 16, 8, 4, 2] ' Const
		
		Global IMAGE_CUT_N:Int[][] = [[0, 0, 300, 128], [0, 128, 256, 12], [0, 140, 256, 12], [0, 152, 256, 16], [0, 168, 256, 24], [0, 192, 256, 64]] ' Const
		Global IMAGE_CUT_W:Int[][] = [[0, 0, MyAPI.zoomIn(672, True), MyAPI.zoomIn(276, True)], [0, MyAPI.zoomIn(276, True), MyAPI.zoomIn(672, True), MyAPI.zoomIn(24, True)], [0, MyAPI.zoomIn(300, True), MyAPI.zoomIn(672, True), MyAPI.zoomIn(24, True)], [0, MyAPI.zoomIn(324, True), MyAPI.zoomIn(672, True), MyAPI.zoomIn(32, True)], [0, MyAPI.zoomIn(356, True), MyAPI.zoomIn(672, True), MyAPI.zoomIn(48, True)], [0, MyAPI.zoomIn(404, True), MyAPI.zoomIn(672, True), MyAPI.zoomIn(148, True)]] ' Const
		
		' Global variable(s):
		Global CLIP_SPEED_N:Int[]
		
		Global IMAGE_CUT:Int[][] = IMAGE_CUT_N
		
		Global IMAGE_WIDTH:Int = 256
		
		' Fields:
		Field firework:AnimationDrawer
		
		Field fireworkx:Int
		Field fireworky:Int
		
		Field imageBG:MFImage[]
		
		Field isDrawFireWork:Bool
	Public
		' Constructor(s):
		Method New()
			Self.imageBG = New MFImage[7]
			
			Self.imageBG[0] = MFImage.createImage("/map/stage3_bg/#1.png")
			
			For Local i:= 1 Until Self.imageBG.Length
				Self.imageBG[i] = MFImage.createPaletteImage("/map/stage3_bg/#" + String(i + 1) + ".pal")
			Next
			
			If (stageId = 4) Then
				CLIP_SPEED_N = CLIP_SPEED_N1
			ElseIf (stageId = 5) Then
				CLIP_SPEED_N = CLIP_SPEED_N2
			EndIf
			
			If (Self.firework = Null) Then
				Self.firework = New Animation("/map/stage3_bg/st3_firework").getDrawer(0, False, 0)
			EndIf
			
			Self.fireworkx = (IMAGE_CUT[0][0] - ((MapManager.getCamera().x / CLIP_SPEED_N[0]) Mod IMAGE_WIDTH)) + MyRandom.nextInt(0, 316)
			Self.fireworky = (IMAGE_CUT[0][1] - (MapManager.getCamera().y / 26)) + MyRandom.nextInt(0, 112)
			
			Self.isDrawFireWork = True
		End
		
		' Methods:
		Method close:Void()
			If (Self.imageBG.Length > 0) Then
				For Local i:= 0 Until Self.imageBG.Length
					Self.imageBG[i] = Null
				Next
			EndIf
			
			Self.imageBG = []
		End
		
		Method draw:Void(g:MFGraphics)
			Local cameraX:= MapManager.getCamera().x
			Local cameraY:= MapManager.getCamera().y
			
			Local yOffset:= -(cameraY / 29)
			
			If (stageId = 4) Then
				yOffset = -(cameraY / 26)
			ElseIf (stageId = 5) Then
				yOffset = -(cameraY / 29)
			EndIf
			
			Local tmpframe:= ((frame Mod (Self.imageBG.Length * 2)) / 2)
			
			For Local i:= 0 Until IMAGE_CUT.Length
				Local xOffset:= -((cameraX / CLIP_SPEED_N[i]) Mod IMAGE_WIDTH)
				
				Local j:= 0
				
				While (j < (MapManager.CAMERA_WIDTH - xOffset))
					MyAPI.drawImage(g, Self.imageBG[tmpframe], IMAGE_CUT[i][0], IMAGE_CUT[i][1], IMAGE_CUT[i][2], IMAGE_CUT[i][3], 0, xOffset + j, IMAGE_CUT[i][1] + yOffset, 20)
					
					j += IMAGE_WIDTH
				Wend
			Next
			
			If (Self.isDrawFireWork) Then
				If (Self.firework.checkEnd()) Then
					Self.isDrawFireWork = (MyRandom.nextInt(0, 10) > 5)
					
					If (GameObject.IsGamePause) Then
						Self.isDrawFireWork = False
					EndIf
					
					If (Self.isDrawFireWork) Then
						Self.fireworkx = ((IMAGE_CUT[0][0] - ((cameraX / CLIP_SPEED_N[0]) Mod IMAGE_WIDTH)) + MyRandom.nextInt(0, 316))
						Self.fireworky = ((IMAGE_CUT[0][1] + yOffset) + MyRandom.nextInt(0, 112))
						
						Self.firework.setActionId(Int(MyRandom.nextInt(0, 10) <= 5))
						Self.firework.restart()
					EndIf
					
					Return
				EndIf
			EndIf
			
			If (Self.isDrawFireWork) Then
				If (Not Self.firework.checkEnd()) Then
					Self.firework.draw(g, Self.fireworkx, Self.fireworky)
					
					Return
				EndIf
			Else
				Self.isDrawFireWork = (MyRandom.nextInt(0, 10) > 5)
				
				If (GameObject.IsGamePause) Then
					Self.isDrawFireWork = False
				EndIf
			EndIf
		End
End