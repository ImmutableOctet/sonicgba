Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	
	Import special.ssdef
	Import special.specialobject
	
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class SpecialMap Implements SSDef
	Public
		' Constant variable(s):
		Global CAMERA_MAX_X:Int = Abs(SCREEN_WIDTH - MAP_WIDTH) ' Const
		Global CAMERA_MAX_Y:Int = Abs(SCREEN_HEIGHT - MAP_HEIGHT) ' Const
		
		Const MAP_WIDTH:Int = 304
		Const MAP_HEIGHT:Int = 224
		
		Const MAP_LENGTH:Int = 1024
		
		Const MAP_VELOCITY_STANDARD:Int = 1
		
		' Global variable(s):
		Global cameraX:Int
		Global cameraY:Int
		Global mapBg1Drawer:AnimationDrawer
		Global mapBg2Drawer:AnimationDrawer
		Global mapDrawer:AnimationDrawer
		Global mapProgress:Int
		Global showingInfo:Bool
		Global specialStageID:Int
		Global starImage:MFImage
	Private
		' Global variable(s):
		Global targetRingNum:Int
	Public
		' Functions:
		Function loadMap:Void()
			specialStageID = STAGE_ID_TO_SPECIAL_ID[StageManager.getStageID()]
			
			Local img:MFImage = Null
			
			If (specialStageID > 0) Then
				img = MFImage.createPaletteImage("/special_res/sp_bg_" + (specialStageID + 1) + ".pal")
			EndIf
			
			Local animation:= Animation.getInstanceFromQi("/special_res/sp_bg.dat")[0]
			
			If (img <> Null) Then
				animation.setImage(img, 0)
			EndIf
			
			mapDrawer = animation.getDrawer()
			
			' Magic numbers: 16, 17 (Action/animation IDs)
			mapBg1Drawer = animation.getDrawer(16, True, 0)
			mapBg2Drawer = animation.getDrawer(17, True, 0)
			
			starImage = MFImage.createImage("/special_res/sp_star_bg.png")
		End
		
		Function releaseMap:Void()
			Animation.closeAnimationDrawer(mapDrawer)
			Animation.closeAnimationDrawer(mapBg1Drawer)
			Animation.closeAnimationDrawer(mapBg2Drawer)
			
			starImage = Null
		End
		
		Function cameraLogic:Void()
			Local topPlayerY:= ((SpecialObject.player.posY Shr 6) + 120)
			
			cameraX = ((CAMERA_MAX_X * ((SpecialObject.player.posX Shr 6) + 150)) / SSDef.PLAYER_MOVE_WIDTH)
			cameraY = ((CAMERA_MAX_Y * topPlayerY) / SSDef.PLAYER_MOVE_HEIGHT)
			
			mapProgress += ((SpecialObject.player.velZ Shl 6) / MAP_VELOCITY_STANDARD)
			
			While (mapProgress < 0)
				mapProgress += MAP_LENGTH
			Wend
			
			mapProgress Mod= MAP_LENGTH
			
			mapDrawer.setActionId((mapProgress Shr 6))
		End
		
		Function drawMap:Void(g:MFGraphics)
			cameraLogic()
			
			g.setColor(CAMERA_MAX_Y)
			
			g.fillRect(CAMERA_MAX_Y, CAMERA_MAX_Y, SCREEN_WIDTH, SCREEN_HEIGHT)
			
			Local x:= CAMERA_MAX_Y ' CAMERA_MAX_X
			
			While (x < SCREEN_WIDTH)
				Local y:= CAMERA_MAX_Y
				
				While (y < SCREEN_HEIGHT)
					MyAPI.drawImage(g, starImage, x, y, CAMERA_MAX_Y)
					
					y += starImage.getHeight()
				Wend
				
				x += starImage.getWidth()
			Wend
			
			mapBg1Drawer.draw(g, ((SCREEN_WIDTH + CAMERA_MAX_X) Shr MAP_VELOCITY_STANDARD) - cameraX, ((SCREEN_HEIGHT + CAMERA_MAX_Y) Shr MAP_VELOCITY_STANDARD) - cameraY)
			mapBg2Drawer.draw(g, ((SCREEN_WIDTH + CAMERA_MAX_X) Shr MAP_VELOCITY_STANDARD) - cameraX, ((SCREEN_HEIGHT + CAMERA_MAX_Y) Shr MAP_VELOCITY_STANDARD) - cameraY)
			
			mapDrawer.draw(g, ((SCREEN_WIDTH + CAMERA_MAX_X) Shr MAP_VELOCITY_STANDARD) - cameraX, ((SCREEN_HEIGHT + CAMERA_MAX_Y) Shr MAP_VELOCITY_STANDARD) - cameraY)
		End
		
		Function getCameraOffsetX:Int()
			Return (cameraX - (CAMERA_MAX_X Shr MAP_VELOCITY_STANDARD))
		End
		
		Function getCameraOffsetY:Int()
			Return (cameraY - (CAMERA_MAX_Y Shr MAP_VELOCITY_STANDARD))
		End
		
		Function drawInfomation:Void(g:MFGraphics)
			' Empty implementation.
		End
End