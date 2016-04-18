Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	
	Import sonicgba.backgroundmanager
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class SnowStage4 Extends BackGroundManager
	Private
		' Global variable(s):
		Global IMAGE_WIDTH:Int = 256
		Global IMAGE_HEIGHT:Int = 256
		
		Global SPEED_X:Int = -1
		Global SPEED_Y:Int = 4
		
		Global posX:Int = 0
		Global posY:Int = 0
		
		' Fields:
		Field waterSurface:AnimationDrawer
		Field snowDrawer:AnimationDrawer
		
		Field waterImage:MFImage
	Public
		' Constructor(s):
		Method New()
			Self.snowDrawer = New Animation("/map/snow").getDrawer(0, True, 0)
			
			Self.snowDrawer.setPause(True)
			
			Self.waterImage = MFImage.createImage("/water/water_filter.png")
			Self.waterSurface = New Animation("/water/stage6_water_surface").getDrawer(0, True, 0)
		End
		
		' Methods:
		Method close:Void()
			Self.snowDrawer = Null
			Self.waterImage = Null
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not GameObject.IsGamePause) Then
				posX += SPEED_X
				posX Mod= IMAGE_WIDTH
				
				posY += SPEED_Y
				posY Mod= IMAGE_HEIGHT
			EndIf
			
			drawWater(g)
		End
		
		Method drawWater:Void(g:MFGraphics)
			Local cameraX:= MapManager.getCamera().x
			Local cameraY:= MapManager.getCamera().y
			
			Local waterLevel:= StageManager.getWaterLevel()
			Local waterStartY:= waterLevel
			
			If (waterLevel > 0 And cameraY > waterLevel) Then
				waterStartY = cameraY
			EndIf
			
			For Local y:= waterStartY Until (SCREEN_HEIGHT + cameraY) Step 96
				For Local x:= 0 Until SCREEN_WIDTH Step 96
					MyAPI.drawImage(g, Self.waterImage, x, y - cameraY, 20)
				Next
			Next
			
			If (waterLevel > cameraY - 2 And waterLevel < (SCREEN_HEIGHT + cameraY) + 2) Then
				For Local x:= 0 Until SCREEN_WIDTH
					Self.waterSurface.draw(g, x, waterLevel - cameraY)
				Next
			EndIf
			
			If (cameraY < waterLevel) Then
				g.setClip(0, 0, SCREEN_WIDTH, waterLevel - cameraY)
				
				For Local i:= ((cameraY / IMAGE_HEIGHT) - 1) Until ((cameraY / IMAGE_HEIGHT) + 3)
					For Local j:= (cameraX / IMAGE_WIDTH) Until ((cameraX / IMAGE_WIDTH) + 4)
						Self.snowDrawer.draw(g, (posX + (IMAGE_WIDTH * j)) - cameraX, (posY + (IMAGE_HEIGHT * i)) - cameraY)
					Next
				Next
				
				If (Not GameObject.IsGamePause) Then
					Self.snowDrawer.moveOn()
				EndIf
				
				g.setClip(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			EndIf
		End
End