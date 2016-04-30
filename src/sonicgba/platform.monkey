Strict

Public

' Friends:
Friend sonicgba.gimmickobject

Friend sonicgba.boss3

' Imports:
Private
	Import lib.constutil
	
	Import sonicgba.collisionrect
	Import sonicgba.gimmickobject
	Import sonicgba.movecalculator
	Import sonicgba.playerknuckles
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	'Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Platform Extends GimmickObject
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		
		Const DRAW_OFFSET_Y:Int = 768
		
		Const STAND_OFFSET:Int = 192
		
		' Global variable(s):
		Global COLLISION_HEIGHT:Int = 1280
		Global COLLISION_OFFSET_Y:Int = 256
		
		' Fields:
		Field IsDisplay:Bool
		Field isH:Bool
		
		Field moveCal:MoveCalculator
		
		Field COLLISION_HEIGHT_OFFSET:Int
		
		Field offsetY:Int
		Field offsetY2:Int
	Private
		' Fields:
		Field initPosx:Int
		Field initPosy:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Local moveDirection:Bool
			
			Self.COLLISION_HEIGHT_OFFSET = 0
			Self.offsetY = 0
			Self.offsetY2 = 0
			
			Self.IsDisplay = True
			
			If (platformImage = Null) Then
				Try
					If (StageManager.getCurrentZoneId() <> 6) Then
						platformImage = MFImage.createImage("/gimmick/platform" + StageManager.getCurrentZoneId() + ".png")
					Else
						platformImage = MFImage.createImage("/gimmick/platform" + StageManager.getCurrentZoneId() + (StageManager.getStageID() - 9) + ".png")
					EndIf
				Catch E:Throwable
					' Nothing so far.
				End Try
				
				If (platformImage = Null) Then
					platformImage = MFImage.createImage("/gimmick/platform0.png")
				EndIf
			EndIf
			
			' Magic number: 5312
			If (StageManager.getStageID() = 5 And left = 5312) Then
				Self.COLLISION_HEIGHT_OFFSET = -DRAW_OFFSET_Y
			EndIf
			
			If (Self.mWidth >= Self.mHeight) Then
				Self.isH = True
				
				If (Self.iLeft = 0) Then
					moveDirection = False
				Else
					moveDirection = True
				EndIf
			Else
				Self.isH = False
				
				If (Self.iTop = 0) Then
					moveDirection = False
				Else
					moveDirection = True
				EndIf
			EndIf
			
			Self.moveCal = New MoveCalculator(PickValue(Self.isH, Self.posX, Self.posY), PickValue(Self.isH, Self.mWidth, Self.mHeight), moveDirection)
			
			Self.initPosx = Self.posX
			Self.initPosy = Self.posY
			
			Self.IsDisplay = True
		End
	Public
		' Methods:
		Method setDisplay:Void(state:Bool)
			Self.IsDisplay = state
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.IsDisplay And Not player.isFootOnObject(Self)) Then
				Select (direction)
					Case DIRECTION_UP
						If (player.isAntiGravity) Then
							player.beStop(Self.collisionRect.y0, direction, Self) ' DIRECTION_UP
							
							Self.used = True
						EndIf
					Case DIRECTION_DOWN
						If (Not player.isAntiGravity) Then
							player.beStop(Self.collisionRect.y0, direction, Self) ' DIRECTION_DOWN
							
							Self.used = True
						EndIf
					Case DIRECTION_NONE
						If (player.isAntiGravity Or player.getMoveDistance().y <= 0) Then
							If (player.isAntiGravity And player.getMoveDistance().y < 0 And player.getCollisionRect().y0 > Self.collisionRect.y0) Then
								player.beStop(Self.collisionRect.y0, DIRECTION_UP, Self)
								
								Self.used = True
							EndIf
						ElseIf (((player.getCollisionRect().y0 + player.getCollisionRect().y1) / 2) - (COLLISION_HEIGHT / 2) < Self.collisionRect.y1) Then
							player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
							Self.used = True
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Self.IsDisplay) Then
				drawInMap(g, platformImage, Self.posX, (Self.posY + DRAW_OFFSET_Y) + Self.offsetY, BOTTOM|HCENTER)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method logic:Void()
			If (Self.IsDisplay) Then
				Self.moveCal.logic()
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				If (Self.isH) Then
					If (Self.iLeft = 0) Then
						Self.posX = Self.moveCal.getPosition()
					Else
						Self.posX = Self.initPosx + (Self.initPosx - Self.moveCal.getPosition())
					EndIf
				ElseIf (Self.iTop = 0) Then
					Self.posY = Self.moveCal.getPosition()
				Else
					Self.posY = Self.initPosy + (Self.initPosy - Self.moveCal.getPosition())
				EndIf
				
				If (player.isFootOnObject(Self)) Then
					Self.offsetY = STAND_OFFSET
					
					If (player.getCharacterID() = CHARACTER_KNUCKLES) Then
						' Optimization potential; dynamic cast.
						Local knuckles:= PlayerKnuckles(player)
						
						' Just to be safe, make sure this is actually Knuckles:
						If (knuckles <> Null) Then
							knuckles.setFloating(False)
						EndIf
					EndIf
				Else
					Self.offsetY = 0
				EndIf
				
				If (StageManager.getCurrentZoneId() >= 3 And StageManager.getCurrentZoneId() <= 6) Then
					Self.offsetY2 = GimmickObject.PLATFORM_OFFSET_Y
				EndIf
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), (((COLLISION_OFFSET_Y + y) - DRAW_OFFSET_Y) + Self.offsetY) + Self.offsetY2, COLLISION_WIDTH, COLLISION_HEIGHT + Self.COLLISION_HEIGHT_OFFSET)
			
			If (Self.COLLISION_HEIGHT_OFFSET <> 0) Then
				Print("COLLISION_HEIGHT + COLLISION_HEIGHT_OFFSET = " + String(COLLISION_HEIGHT + Self.COLLISION_HEIGHT_OFFSET))
			EndIf
		End
		
		Method collisionChkWithObject:Bool(object:PlayerObject)
			Local objectRect:= object.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			rectV.setRect(objectRect.x0 + STAND_OFFSET, objectRect.y0 + Self.offsetY2, objectRect.getWidth() - (PlayerObject.BODY_OFFSET / 2), objectRect.getHeight()) ' (DRAW_OFFSET_Y / 2)
			
			Return thisRect.collisionChk(rectV)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End