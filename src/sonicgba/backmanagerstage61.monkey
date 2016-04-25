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
Class BackManagerStage61 Extends BackGroundManager
	Private
		' Constant variable(s):
		Global IMAGE_DIVIDE_PARAM:Int[][] = [[0, 120, 284, 284], [0, 0, 284, 120], [0, 256, 284, 124], [0, 380, 284, 128], [0, 0, 284, 256]] ' Const
		
		' States:
		Const STATE_EVE:Int = 0
		Const STATE_PASSING:Int = 1
		Const STATE_STAR:Int = 2
		
		' Fields:
		Field image0:MFImage
		Field image1:MFImage
		Field image2:MFImage
		
		Field bgY:Int
		
		Field cloudY:Int
		Field passingY:Int
		
		Field starY1:Int
		Field starY2:Int
	Public
		' Fields:
		Field state:Int
		
		' Constructor(s):
		Method New()
			Self.image0 = MFImage.createImage("/map/stage6_bg_0.png")
			Self.image1 = MFImage.createImage("/map/stage6_bg_1.png")
			Self.image2 = MFImage.createImage("/map/stage6_bg_2.png")
			
			Self.state = STATE_EVE
			Self.starY1 = 0
			
			Self.starY2 = 32768 ' (MapManager.TILE_HEIGHT * 2048)
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			Local cameraX:= MapManager.getCamera().x
			
			Select (Self.state)
				Case STATE_EVE
					If (cameraX <= 1058) Then
						MyAPI.drawImage(g, Self.image0, (-cameraX) / 51, 0, 0)
						
						Return
					EndIf
					
					For Local i:= 0 Until (((SCREEN_HEIGHT + 255) / 256) + 1)
						MyAPI.drawImage(g, Self.image1, IMAGE_DIVIDE_PARAM[0][0], IMAGE_DIVIDE_PARAM[0][1], IMAGE_DIVIDE_PARAM[0][2], IMAGE_DIVIDE_PARAM[0][3], 0, 0, ((Self.bgY - 16384) + (i * 16384)) Shr 6, 0)
					Next
					
					If (Not GameObject.IsGamePause) Then
						Self.bgY += 480
						Self.bgY Mod= 16384
					EndIf
				Case STATE_PASSING
					g.setColor(MapManager.END_COLOR)
					
					MyAPI.fillRect(g, 0, (Self.passingY Shr 6) + 224, SCREEN_WIDTH, 8)
					
					drawStarWorld(g, (Self.passingY Shr 6), True)
					
					MyAPI.setClip(g, 0, (Self.passingY Shr 6) + 104, SCREEN_WIDTH, 128)
					
					For Local i:= 0 Until 2
						MyAPI.drawImage(g, Self.image2, IMAGE_DIVIDE_PARAM[3][0], IMAGE_DIVIDE_PARAM[3][1], IMAGE_DIVIDE_PARAM[3][2], IMAGE_DIVIDE_PARAM[3][3], 0, 0, (Self.passingY Shr 6) + (((Self.cloudY + (32768 * (i - 1))) / 256) + 104), 0)
					Next
					
					MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					MyAPI.drawImage(g, Self.image1, IMAGE_DIVIDE_PARAM[1][0], IMAGE_DIVIDE_PARAM[1][1], IMAGE_DIVIDE_PARAM[1][2], IMAGE_DIVIDE_PARAM[1][3], 0, 0, ((Self.passingY Shr 6) + 224) + 8, 0)
					
					For Local i:= 0 Until (((SCREEN_HEIGHT + 255) / 256) + 1)
						MyAPI.drawImage(g, Self.image1, IMAGE_DIVIDE_PARAM[0][0], IMAGE_DIVIDE_PARAM[0][1], IMAGE_DIVIDE_PARAM[0][2], IMAGE_DIVIDE_PARAM[0][3], 0, 0, (i * 256) + ((((Self.passingY Shr 6) + 224) + 8) + 120), 0)
					Next
					
					If (Not GameObject.IsGamePause) Then
						If (Self.passingY < -960) Then
							Self.passingY += 480
						Else
							Self.passingY = MyAPI.calNextPosition(Double(Self.passingY), 0.0, 1, 2)
						EndIf
					EndIf
					
					If (Self.passingY = 0) Then
						Self.state = STATE_STAR
					EndIf
				Case STATE_STAR
					drawStarWorld(g, 0, False)
			End Select
		End
		
		Method close:Void()
			Self.image0 = Null
			Self.image1 = Null
			Self.image2 = Null
		End
		
		Method nextState:Void()
			Self.state = STATE_PASSING
			
			Self.passingY = -(38912 - Self.bgY)
		End
	Private
		' Methods:
		Method drawStarWorld:Void(g:MFGraphics, yOffset:Int, passing:Bool)
			g.setColor(528448)
			
			MyAPI.fillRect(g, 0, yOffset, SCREEN_WIDTH, 100)
			
			For Local i:= 0 Until 2
				MyAPI.drawImage(g, Self.image2, IMAGE_DIVIDE_PARAM[4][0], IMAGE_DIVIDE_PARAM[4][1], IMAGE_DIVIDE_PARAM[4][2], IMAGE_DIVIDE_PARAM[4][3], 0, -128, ((Self.starY2 + (65536 * (i - 1))) / 256) + yOffset, 0)
				MyAPI.drawImage(g, Self.image2, IMAGE_DIVIDE_PARAM[4][0], IMAGE_DIVIDE_PARAM[4][1], IMAGE_DIVIDE_PARAM[4][2], IMAGE_DIVIDE_PARAM[4][3], 0, 128, ((Self.starY2 + (65536 * (i - 1))) / 256) + yOffset, 0)
			Next
			
			For Local i:= 0 Until 2
				MyAPI.drawImage(g, Self.image2, IMAGE_DIVIDE_PARAM[4][0], IMAGE_DIVIDE_PARAM[4][1], IMAGE_DIVIDE_PARAM[4][2], IMAGE_DIVIDE_PARAM[4][3], 0, 0, ((Self.starY1 + (65536 * (i - 1))) / 256) + yOffset, 0)
			Next
			
			MyAPI.drawImage(g, Self.image2, IMAGE_DIVIDE_PARAM[2][0], IMAGE_DIVIDE_PARAM[2][1], IMAGE_DIVIDE_PARAM[2][2], IMAGE_DIVIDE_PARAM[2][3], 0, 0, yOffset + 100, 0)
			
			If (Not passing) Then
				MyAPI.setClip(g, 0, yOffset + 104, SCREEN_WIDTH, SCREEN_HEIGHT - 104)
				
				For Local i:= 0 Until ((((SCREEN_HEIGHT - 104) + 127) / 128) + 1)
					MyAPI.drawImage(g, Self.image2, IMAGE_DIVIDE_PARAM[3][0], IMAGE_DIVIDE_PARAM[3][1], IMAGE_DIVIDE_PARAM[3][2], IMAGE_DIVIDE_PARAM[3][3], 0, 0, (((Self.cloudY + (32768 * (i - 1))) / 256) + 104) + yOffset, 0)
				Next
				
				MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			EndIf
			
			If (Not GameObject.IsGamePause) Then
				Self.cloudY -= 30
				Self.cloudY += 32768
				Self.cloudY Mod= 32768
				Self.starY1 -= 120
				Self.starY1 += 65536
				Self.starY1 Mod= 65536
				Self.starY2 -= 15
				Self.starY2 += 65536
				Self.starY2 Mod= 65536
			EndIf
		End
End