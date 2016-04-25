Strict

Public

' Imports:
Private
	Import lib.coordinate
	Import lib.myapi
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gameobject
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BreakPlatform Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 4096
		Const COLLISION_HEIGHT:Int = 2048
		
		Const BREAK_WIDTH:Int = 8
		Const BREAK_HEIGHT:Int = 8
		
		Const REST_FRAME:Int = 3
		
		' Global variable(s):
		Global platformImage:MFImage = Null
		
		' Fields:
		Field breakFlag:Bool
		
		Field blockNumX:Int
		Field blockNumY:Int
		
		Field breakCount:Int
		
		Field breakY:Int[][]
		Field breakVelY:Int[][]
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.breakFlag = False
			
			If (platformImage = Null) Then
				If (StageManager.getCurrentZoneId() <> 6) Then
					platformImage = MFImage.createImage("/gimmick/break_platform_" + String(StageManager.getCurrentZoneId()) + ".png")
				Else
					platformImage = MFImage.createImage("/gimmick/break_platform_" + String(StageManager.getCurrentZoneId()) + String(StageManager.getStageID() - 9) + ".png")
				EndIf
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			platformImage = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.used Or Not isStandingOver()) Then
				Select (direction)
					Case DIRECTION_DOWN
						player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self) ' direction
						
						If (Not Self.used) Then
							Self.used = True
							
							initialBreaking(platformImage)
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_173)
						EndIf
					Case DIRECTION_NONE
						If (player.getMoveDistance().y > 0 And player.getCollisionRect().y1 < Self.collisionRect.y1) Then
							player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
							
							If (Not Self.used) Then
								Self.used = True
								
								initialBreaking(platformImage)
								
								SoundSystem.getInstance().playSe(SoundSystem.SE_173)
							EndIf
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method logic:Void()
			If (Self.used And isStandingOver()) Then
				player.cancelFootObject(Self)
			EndIf
		End
		
		Method doInitWhileInCamera:Void()
			Self.used = False
			Self.breakFlag = False
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method draw:Void(g:MFGraphics)
			If (Self.breakFlag) Then
				breakingDraw(g, camera)
			Else
				drawInMap(g, platformImage, 0, 0, MyAPI.zoomIn(platformImage.getWidth()), MyAPI.zoomIn(platformImage.getHeight()), PickValue((Self.iLeft = 0), TRANS_NONE, TRANS_MIRROR), Self.posX, Self.posY, (PickValue((Self.iLeft = 0), LEFT, RIGHT) | TOP))
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.iLeft = 0) Then
				Self.collisionRect.setRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
			Else
				Self.collisionRect.setRect(x - COLLISION_WIDTH, y, COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
		
		Method close:Void()
			' Empty implementation.
		End
	Private
		' Methods:
		Method initialBreaking:Void(image:MFImage)
			Self.blockNumX = MyAPI.zoomIn(image.getWidth() / BREAK_WIDTH)
			Self.blockNumY = MyAPI.zoomIn(image.getHeight() / BREAK_WIDTH)
			
			Self.breakY = New Int[Self.blockNumX][]
			
			For Local i:= 0 Until Self.breakY.Length
				Self.breakY[i] = New Int[Self.blockNumY]
			Next
			
			Self.breakVelY = New Int[Self.blockNumX][]
			
			For Local i:= 0 Until Self.breakVelY.Length
				Self.breakVelY[i] = New Int[Self.blockNumY]
			Next
			
			Self.breakCount = 0
			
			Self.breakFlag = True
		End
		
		Method breakingDraw:Void(g:MFGraphics, camera:Coordinate)
			If (Self.breakFlag) Then
				If (Not GameObject.IsGamePause) Then
					For Local i:= 0 Until Self.breakCount
						Local block:= Self.breakVelY[(Self.blockNumX - 1) - (i Mod Self.blockNumX)]
						Local index:= i / Self.blockNumX
						
						block[i2] += GRAVITY
					Next
					
					Self.breakCount += 1
					
					If (Self.breakCount > (Self.blockNumX * Self.blockNumY)) Then
						Self.breakCount = (Self.blockNumX * Self.blockNumY)
					EndIf
				EndIf
				
				For Local i:= 0 Until (Self.blockNumX * Self.blockNumY)
					If (Not GameObject.IsGamePause) Then
						Local block:= Self.breakY[i Mod Self.blockNumX]
						
						block[i / Self.blockNumX] += Self.breakVelY[i Mod Self.blockNumX][i / Self.blockNumX]
					EndIf
					
					Local srcX:= (i Mod Self.blockNumX) * BREAK_WIDTH
					Local srcY:= (((Self.blockNumY - 1) - (i / Self.blockNumX)) * BREAK_HEIGHT)
					
					' Magic number: 512
					Local x:= (((DSgn(Self.iLeft = 0) * (i Mod Self.blockNumX)) * 512) + Self.posX)
					Local y:= (((((Self.blockNumY - 1) - (i / Self.blockNumX)) * 512) + Self.posY) + Self.breakY[i Mod Self.blockNumX][i / Self.blockNumX])
					
					Local anchor:= (PickValue((Self.iLeft = 0), LEFT, RIGHT) | TOP)
					
					drawInMap(g, platformImage, srcX, srcY, BREAK_WIDTH, BREAK_HEIGHT, PickValue((Self.iLeft = 0), TRANS_NONE, TRANS_MIRROR), x, y, anchor)
				Next
			EndIf
		End
		
		Method isBreakingOver:Bool()
			Return (Self.breakCount = Self.blockNumX * Self.blockNumY)
		End
		
		Method isStandingOver:Bool()
			Return (Self.breakCount >= Self.blockNumX * (Self.blockNumY - 1))
		End
End