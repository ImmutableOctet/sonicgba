Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.movecalculator
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	Import sonicgba.stagemanager
	
	Import com.sega.engine.action.acparam
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class DekaPlatform Extends GimmickObject
	Private
		' Constant variable(s):
		Const VELOCITY:Int = 250
		
		' Global variable(s):
		Global image:MFImage
		Global image2:MFImage
		
		' Fields:
		Field isActived:Bool
		Field isDirectionDown:Bool
		Field isH:Bool
		
		Field COLLISION_WIDTH1:Int
		Field COLLISION_HEIGHT1:Int
		
		Field COLLISION_WIDTH2:Int
		Field COLLISION_HEIGHT2:Int
		
		Field initPos:Int
		
		Field lastDirection:Int
		Field offset_distance:Int
		
		Field mCalc:MoveCalculator
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.lastDirection = DIRECTION_NONE
			Self.isActived = False
			
			Local moveDirection:Bool
			
			If (Self.mWidth >= Self.mHeight) Then
				Self.isH = True
				
				moveDirection = (Self.iLeft <> 0)
			Else
				Self.isH = False
				
				moveDirection = (Self.iTop <> 0)
			EndIf
			
			Self.mCalc = New MoveCalculator(PickValue(Self.isH, Self.posX, Self.posY), PickValue(Self.isH, Self.mWidth, Self.mHeight), moveDirection)
			
			Self.initPos = PickValue(Self.isH, Self.posX, Self.posY)
			
			If (StageManager.getCurrentZoneId() <> 6) Then
				If (image = Null) Then
					image = MFImage.createImage("/gimmick/deka_platform_" + StageManager.getCurrentZoneId() + ".png")
				EndIf
				
				Self.COLLISION_WIDTH1 = (MyAPI.zoomIn(image.getWidth()) Shl 6)
				Self.COLLISION_HEIGHT1 = (MyAPI.zoomIn(image.getHeight()) Shl 6)
			ElseIf (Self.iTop = 1) Then
				If (image = Null) Then
					image = MFImage.createImage("/gimmick/deka_platform_" + StageManager.getCurrentZoneId() + (StageManager.getStageID() - 9) + "_2.png")
				EndIf
				
				Self.COLLISION_WIDTH1 = (MyAPI.zoomIn(image.getWidth()) Shl 6)
				Self.COLLISION_HEIGHT1 = (MyAPI.zoomIn(image.getHeight()) Shl 6)
			Else
				If (image2 = Null) Then
					image2 = MFImage.createImage("/gimmick/deka_platform_" + StageManager.getCurrentZoneId() + (StageManager.getStageID() - 9) + ".png")
				EndIf
				
				Self.COLLISION_WIDTH2 = (MyAPI.zoomIn(image2.getWidth()) Shl 6)
				Self.COLLISION_HEIGHT2 = (MyAPI.zoomIn(image2.getHeight()) Shl 6)
			EndIf
			
			If (StageManager.getCurrentZoneId() = 5 And Self.iTop = 0 And Self.iLeft = 0) Then
				If (image2 = Null) Then
					image2 = MFImage.createImage("/gimmick/deka_platform_" + StageManager.getCurrentZoneId() + "_2.png")
				EndIf
				
				Self.COLLISION_WIDTH1 = (MyAPI.zoomIn(image2.getWidth()) Shl 6)
				Self.COLLISION_HEIGHT1 = (MyAPI.zoomIn(image2.getHeight()) Shl 6)
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
			image2 = Null
		End
		
		' Methods:
		Method logic:Void()
			Self.mCalc.logic()
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.isH) Then
				If (Self.iLeft = 0) Then
					Self.posX = Self.mCalc.getPosition()
				Else
					Self.offset_distance = (Self.initPos - Self.mCalc.getPosition())
					Self.posX = (Self.initPos + Self.offset_distance)
				EndIf
			ElseIf (Self.iTop = 0) Then
				Self.posY = Self.mCalc.getPosition()
			Else
				Self.offset_distance = (Self.initPos - Self.mCalc.getPosition())
				Self.posY = (Self.initPos + Self.offset_distance)
			EndIf
			
			If (Not player.isFootOnObject(Self) Or Self.worldInstance.getWorldY(player.collisionRect.x0, player.collisionRect.y0, 1, 0) = ACParam.NO_COLLISION Or Self.worldInstance.getWorldY(player.collisionRect.x1, player.collisionRect.y0, 1, 0) = ACParam.NO_COLLISION) Then
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			Else
				player.setDie(False)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (StageManager.getCurrentZoneId() = 5 And Self.iTop = 0 And Self.iLeft = 0) Then
				drawInMap(g, image2, VCENTER|HCENTER)
			ElseIf (StageManager.getCurrentZoneId() <> 6) Then
				drawInMap(g, image, VCENTER|HCENTER)
			ElseIf (Self.iTop = 1) Then
				drawInMap(g, image, VCENTER|HCENTER)
			Else
				drawInMap(g, image2, VCENTER|HCENTER)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (StageManager.getCurrentZoneId() <> 6) Then
				Self.collisionRect.setRect(x - (Self.COLLISION_WIDTH1 / 2), y - (Self.COLLISION_HEIGHT1 / 2), Self.COLLISION_WIDTH1, Self.COLLISION_HEIGHT1) ' Shr 1
			ElseIf (Self.iTop = 1) Then
				Self.collisionRect.setRect(x - (Self.COLLISION_WIDTH1 / 2), y - (Self.COLLISION_HEIGHT1 / 2), Self.COLLISION_WIDTH1, Self.COLLISION_HEIGHT1) ' Shr 1
			Else
				Self.collisionRect.setRect(x - (Self.COLLISION_WIDTH2 / 2), y - (Self.COLLISION_HEIGHT2 / 2), Self.COLLISION_WIDTH2, Self.COLLISION_HEIGHT2) ' Shr 1
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (direction = DIRECTION_NONE) Then
				direction = Self.lastDirection
			Else
				Self.lastDirection = direction
			EndIf
			
			If (direction = DIRECTION_DOWN) Then
				Self.isDirectionDown = True
			Else
				Self.isDirectionDown = False
			Endif
			
			' Optimization potential; dynamic cast. (Potentially unsafe; no 'Null' check)
			If ((player.getCharacterID() <> CHARACTER_AMY) Or Not PlayerAmy(player).skipBeStop) Then
				If (direction = DIRECTION_NONE And player.collisionRect.x0 < Self.collisionRect.x1 And player.collisionRect.x1 > Self.collisionRect.x1) Then
					direction = DIRECTION_LEFT
				EndIf
				
				If ((player.velX < 0 And direction = DIRECTION_RIGHT Or player.velX > 0 And direction = DIRECTION_LEFT) And (player.collisionRect.x1 + player.velX + PlayerObject.WIDTH / 2 < Self.collisionRect.x0 Or player.collisionRect.x0 + player.velX - PlayerObject.WIDTH / 2 > Self.collisionRect.x1)) Then ' 1024
					player.posX += player.velX
				Else
					player.beStop(0, direction, this, Self.isDirectionDown)
				EndIf
			EndIf
			
			If (direction = DIRECTION_RIGHT Or direction = DIRECTION_LEFT) Then
				Self.isActived = true
				
				player.isSidePushed = direction
				
				If (player.movedSpeedX > 0) Then
					player.movedSpeedX = 1
				ElseIf (player.movedSpeedX < 0) Then
					player.movedSpeedX = -1
				EndIf
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.lastDirection = DIRECTION_NONE
			
			If (Self.isActived) Then
				player.movedSpeedX = 0
				
				Self.isActived = False
			EndIf
			
			' Not sure why we're doing this, but whatever:
			If (player.isSidePushed <> DIRECTION_NONE) Then
				player.isSidePushed = DIRECTION_NONE
			EndIf
		End
		
		Method close:Void()
			Self.mCalc = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End