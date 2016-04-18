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
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class FrontManagerStage2_1 Extends BackGroundManager
	Private
		' Constant variable(s):
		Const LIGHT_CIRCLE_1:Int = 32
		Const LIGHT_CIRCLE_2:Int = 120
		Const LIGHT_DEGREE_CENTER_1:Int = -90
		Const LIGHT_DEGREE_CENTER_2:Int = -90
		Const LIGHT_RANGE_1:Int = 40
		Const LIGHT_RANGE_2:Int = 68
		
		' Fields:
		Field degree1:Int
		Field degree2:Int
		
		Field drawer:AnimationDrawer
		Field screenMask:MFImage
		
		Field screenMaskRGB:Int[]
	Public
		' Constructor(s):
		Method New()
			Self.screenMask = MFImage.createImage(SCREEN_WIDTH, SCREEN_HEIGHT)
			Self.drawer = Animation.getInstanceFromQi("/animation/searchlight.dat")[0].getDrawer()
			
			Self.degree1 = 0
			Self.degree2 = 0
			
			Self.screenMaskRGB = New Int[(SCREEN_WIDTH * SCREEN_HEIGHT)]
		End
		
		' Methods:
		Method close:Void()
			Self.screenMask = Null
			Self.drawer = Null
			
			Self.screenMaskRGB = []
		End
		
		' This method may behave differently in the future. (Software graphics)
		Method draw:Void(g:MFGraphics)
			If (MapManager.getCamera().x <= 1456) Then
				If (Not GameObject.IsGamePause) Then
					Self.degree1 += 11
					Self.degree1 Mod= 360
					
					Self.degree2 += 3
					Self.degree2 Mod= 360
				EndIf
				
				Local g2:= Self.screenMask.getGraphics()
				
				g2.setColor(MapManager.END_COLOR)
				
				MyAPI.fillRect(g2, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				g2.saveCanvas()
				
				g2.translateCanvas((SCREEN_WIDTH / 2) - 60, (SCREEN_HEIGHT / 2) + 119) ' Shr 1
				g2.rotateCanvas(Float(((MyAPI.dSin(Self.degree1) * LIGHT_RANGE_1) / 100)))
				
				Self.drawer.draw(g2, 0, 0, 0, False, 0)
				
				g2.restoreCanvas()
				
				g2.saveCanvas()
				
				g2.translateCanvas((SCREEN_WIDTH / 2) + 80, (SCREEN_HEIGHT / 2) + 161) ' Shr 1
				g2.rotateCanvas(Float(((MyAPI.dSin(Self.degree2) * LIGHT_RANGE_2) / 100)))
				
				Self.drawer.draw(g2, 1, 0, 0, False, 0)
				
				g2.restoreCanvas()
				
				Self.screenMask.getRGB(Self.screenMaskRGB, 0, SCREEN_WIDTH, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				
				For Local i:= 0 Until Self.screenMaskRGB.Length
					If (Self.screenMaskRGB[i] = -1) Then
						Self.screenMaskRGB[i] = INT_MAX
					Else
						Self.screenMaskRGB[i] = 0
					EndIf
				Next
				
				g.drawRGB(Self.screenMaskRGB, 0, SCREEN_WIDTH, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, True)
			EndIf
		End
End