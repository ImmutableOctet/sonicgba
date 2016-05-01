Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.mapmanager
	Import sonicgba.rollisland
	Import sonicgba.stagemanager
	Import sonicgba.transpoint
	Import sonicgba.waterfall
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class GraphicPatch Extends GimmickObject
	Private
		' Constant variable(s):
		Const HOLE_PATCH_WIDTH:Int = 56
		Const HOLE_PATCH_HEIGHT:Int = 48
		
		Const HOLE_PATCH_OFFSET_X:Int = -32
		Const HOLE_PATCH_OFFSET_Y:Int = -48
		
		Const MAP_PATCH_WIDTH:Int = 12288
		Const MAP_PATCH_HEIGHT:Int = 12288
		
		Const MAP_PATCH_OFFSET_X:Int = -6144
		Const MAP_PATCH_OFFSET_Y:Int = -2048
		
		Const RAIL_SPACE:Int = 1024
		
		' Global variable(s):
		Global holePatchAnimation:Animation
		Global mapPatchAnimation:Animation
		Global poalImage:MFImage
		Global railPatchDrawer:AnimationDrawer
		Global ropeImage:MFImage
		
		' Fields:
		Field direction:Int
		Field moveDistance:Int
		
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Select (Self.iLeft)
				Case 0
					If (WaterFall.waterFallDrawer3 = Null) Then
						WaterFall.waterFallDrawer3 = New Animation("/animation/sand_03").getDrawer(0, True, 0)
						
						WaterFall.waterFallDrawer3.setPause(True)
					EndIf
					
					Self.drawer = WaterFall.waterFallDrawer3
				Case 1
					If (TransPoint.caveAnimation = Null) Then
						TransPoint.caveAnimation = New Animation("/animation/cave")
					EndIf
					
					Self.drawer = TransPoint.caveAnimation.getDrawer(1, True, 0)
				Case 2
					If (ropeImage = Null) Then
						ropeImage = MFImage.createImage("/gimmick/rope_patch.png")
					EndIf
				Case 3
					If (mapPatchAnimation = Null) Then
						mapPatchAnimation = New Animation(MapManager.image, "/animation/patch_st" + StageManager.getCurrentZoneId())
					EndIf
					
					Self.drawer = mapPatchAnimation.getDrawer(Self.iTop, False, 0)
					
					Self.mWidth = MAP_PATCH_WIDTH
					Self.mHeight = MAP_PATCH_HEIGHT
				Case 4
					If (holePatchAnimation = Null) Then
						holePatchAnimation = New Animation("/animation/hole_patch")
					EndIf
					
					Self.drawer = holePatchAnimation.getDrawer(Self.iTop, False, 0)
					
					Self.posX += HOLE_PATCH_OFFSET_X
					Self.posY += PickValue((Self.iTop = 0), HOLE_PATCH_OFFSET_Y, -(RAIL_SPACE / 2)) ' -(RAIL_SPACE / 2)
					
					Self.mWidth = HOLE_PATCH_WIDTH
					Self.mHeight = HOLE_PATCH_HEIGHT
				Case 5
					If (poalImage = Null) Then
						poalImage = MFImage.createImage("/gimmick/poal_patch.png")
					EndIf
				Case 6
					If (railPatchDrawer = Null) Then
						railPatchDrawer = New Animation("/animation/rail_patch_2").getDrawer()
					EndIf
					
					Self.direction = width
					
					Print("6 height:" + height)
					
					Self.moveDistance = height
			End Select
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(mapPatchAnimation)
			Animation.closeAnimation(holePatchAnimation)
			Animation.closeAnimationDrawer(railPatchDrawer)
			
			ropeImage = Null
			mapPatchAnimation = Null
			holePatchAnimation = Null
			poalImage = Null
			railPatchDrawer = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			Local i:Int, j:Int
			
			Select (Self.iLeft)
				Case 0
					MyAPI.setClip(g, (Self.collisionRect.x0 Shr 6) - camera.x, (Self.collisionRect.y0 Shr 6) - camera.y, Self.collisionRect.getWidth() Shr 6, Self.collisionRect.getHeight() Shr 6)
					
					i = Self.collisionRect.y0
					
					While (True)
						If (i >= Self.collisionRect.y1) Then
							MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
							
							Exit
						Else
							drawInMap(g, Self.drawer, Self.posX, i)
							
							i += (MAP_PATCH_HEIGHT / 2)
						EndIf
					Wend
				Case 1
					drawInMap(g, Self.drawer)
				Case 2
					i = Self.collisionRect.y0
					
					Local j2:= 0
					
					While (True)
						If (i < Self.collisionRect.y1) Then
							If (Self.iTop = 0) Then
								drawInMap(g, ropeImage, Self.posX + j2, i, TOP|LEFT)
							Else
								drawInMap(g, ropeImage, 0, 0, MyAPI.zoomIn(ropeImage.getWidth(), True), MyAPI.zoomIn(ropeImage.getHeight(), True), 2, (Self.posX - j2) + Self.mWidth, i, TOP|RIGHT)
							EndIf
							
							i += (RAIL_SPACE / 2)
							
							j = (j2 + RAIL_SPACE)
						Else
							Exit
						EndIf
					Wend
				Case 3
					drawInMap(g, Self.drawer, Self.posX, Self.posY)
				Case 4
					drawInMap(g, Self.drawer, Self.posX - HOLE_PATCH_OFFSET_X, Self.posY - PickValue((Self.iTop = 0), HOLE_PATCH_OFFSET_Y, 0))
				Case 5
					MyAPI.setClip(g, (Self.collisionRect.x0 Shr 6) - camera.x, (Self.collisionRect.y0 Shr 6) - camera.y, (RAIL_SPACE / 2), (Self.collisionRect.getHeight() Shr 6))
					
					j = Self.posY
					
					While (True)
						If (j >= Self.posY + Self.collisionRect.getHeight()) Then
							MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
							
							Exit
						Else
							drawInMap(g, poalImage, Self.posX + 128, j, 17)
							
							j += RAIL_SPACE
						EndIf
					Wend
				Case 6
					Local endX:= Self.posX + (RollIsland.DIRECTION[Self.direction][0] * ((Self.moveDistance / RAIL_SPACE) * RAIL_SPACE))
					Local endY:= Self.posY + (RollIsland.DIRECTION[Self.direction][1] * ((Self.moveDistance / RAIL_SPACE) * RAIL_SPACE))
					
					Local startX:= Self.posX
					Local startY:= Self.posY
					
					If (Self.posX > endX) Then
						startX = endX
						startY = endY
						
						endX = Self.posX
						endY = Self.posY
					Else
						If (Self.posY > endY) Then
							If (RollIsland.DIRECTION[Self.direction][1] * RollIsland.DIRECTION[Self.direction][0] <> -1) Then
								startX = endX
								startY = endY
								
								endX = Self.posX
								endY = Self.posY
							EndIf
						EndIf
					EndIf
					
					If (startX = endX) Then
						MyAPI.setClip(g, 0, (startY Shr 6) - camera.y, SCREEN_WIDTH, Abs(endY - startY) Shr 6)
					ElseIf (startY = endY) Then
						MyAPI.setClip(g, (startX Shr 6) - camera.x, 0, Abs(endX - startX) Shr 6, SCREEN_HEIGHT)
					Else
						MyAPI.setClip(g, ((startX Shr 6) - camera.x) - 2, ((Min(startY, endY) Shr 6) - camera.y) - 2, (Abs(endX - startX) Shr 6) + 4, (Abs(endY - startY) Shr 6) + 4)
					EndIf
					
					For i = 0 Until Self.moveDistance Step RAIL_SPACE
						Local x:Int, y:Int
						
						If (RollIsland.DIRECTION[Self.direction][1] * RollIsland.DIRECTION[Self.direction][0] = -1) Then
							x = startX + (RollIsland.DIRECTION[Self.direction][0] * i)
							y = startY + (RollIsland.DIRECTION[Self.direction][1] * i)
						Else
							x = startX + PickValue((RollIsland.DIRECTION[Self.direction][0] <> 0), i, 0)
							y = startY + PickValue((RollIsland.DIRECTION[Self.direction][1] <> 0), i, 0)
						EndIf
						
						Select (Self.direction)
							Case 0, 4
								railPatchDrawer.setActionId(1)
							Case 1, 5
								railPatchDrawer.setActionId(7)
							Case 2, 6
								railPatchDrawer.setActionId(0)
							Case 3, 7
								railPatchDrawer.setActionId(6)
						End Select
						
						drawInMap(g, railPatchDrawer, x, y)
					Next
					
					MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
					
					Select (Self.direction)
						Case 0, 4
							railPatchDrawer.setActionId(5)
							drawInMap(g, railPatchDrawer, startX, startY)
							
							railPatchDrawer.setActionId(4)
							drawInMap(g, railPatchDrawer, endX, endY)
						Case 1, 5
							railPatchDrawer.setActionId(10)
							drawInMap(g, railPatchDrawer, startX, startY)
							
							railPatchDrawer.setActionId(11)
							drawInMap(g, railPatchDrawer, endX, endY)
						Case 2, 6
							railPatchDrawer.setActionId(3)
							drawInMap(g, railPatchDrawer, startX, startY)
							
							railPatchDrawer.setActionId(2)
							drawInMap(g, railPatchDrawer, endX, endY)
						Case 3, 7
							railPatchDrawer.setActionId(8)
							drawInMap(g, railPatchDrawer, startX, startY)
							
							railPatchDrawer.setActionId(9)
							drawInMap(g, railPatchDrawer, endX, endY)
					End Select
			End Select
		End
		
		Public Method getPaintLayer:Int()
			Select (Self.iLeft)
				Case 1, 6
					Return 0
				Case 3
					If (Self.iTop = 1) Then
						Return 2
					EndIf
			End Select
			
			Return Super.getPaintLayer()
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Select (Self.iLeft)
				Case 3
					Self.collisionRect.setRect(x + MAP_PATCH_OFFSET_X, y + MAP_PATCH_OFFSET_Y, Self.mWidth, Self.mHeight)
				Case 6
					Local endX:= Self.posX + (RollIsland.DIRECTION[Self.direction][0] * Self.moveDistance)
					Local endY:= Self.posY + (RollIsland.DIRECTION[Self.direction][1] * Self.moveDistance)
					
					Local startX:= Self.posX
					Local startY:= Self.posY
					
					Self.collisionRect.setRect(Min(startX, endX), Min(startY, endY), Abs(startX - endX), Abs(startY - endY))
				Default
					Self.collisionRect.setRect(x, y, Self.mWidth, Self.mHeight)
			End Select
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End