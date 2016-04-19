Strict

Public

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playerknuckles
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class DownIsland Extends GimmickObject
	Private
		' Constant variable(s):
		Const VELOCITY:Int = 400
		
		' Global variable(s):
		Global COLLISION_HEIGHT:Int = 2560 ' Const
		Global COLLISION_WIDTH:Int = 2560 ' Const
		
		Global image:MFImage
		
		' Fields:
		Field posYOriginal:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.posYOriginal = Self.posY
			
			If (image = Null) Then
				If (StageManager.getCurrentZoneId() = 4) Then
					image = MFImage.createImage("/gimmick/drip_island_4.png")
				Else
					image = MFImage.createImage("/gimmick/down_island.png")
				EndIf
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method logic:Void()
			Local preY:= Self.posY
			
			If (player.isFootOnObject(Self)) Then
				If (player.getCharacterID() = CHARACTER_KNUCKLES) Then
					' Optimization potential; dynamic cast.
					Local knuckles:= PlayerKnuckles(player)
					
					If (knuckles <> Null) Then
						knuckles.setFloating(False)
					EndIf
				EndIf
				
				Self.posY += VELOCITY
				
				checkWithMap(Self.posX, preY, Self.posX, Self.posY)
				
				If (Self.posY + (COLLISION_HEIGHT / 2) >= getGroundY(Self.posX, Self.posY)) Then ' Shr 1
					Self.posY = (getGroundY(Self.posX, Self.posY) - (COLLISION_HEIGHT / 2)) 'Shr 1
				EndIf
			Else
				Self.posY -= VELOCITY
				
				If (Self.posY <= Self.posYOriginal) Then
					Self.posY = Self.posYOriginal
				EndIf
			EndIf
			
			checkWithPlayer(Self.posX, preY, Self.posX, Self.posY)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_BEFORE_SONIC
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, image, VCENTER|HCENTER)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Select (direction)
				Case DIRECTION_DOWN
					player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self) ' direction
					
					Self.used = True
				Case DIRECTION_LEFT, DIRECTION_RIGHT
					If (((player.faceDirection And direction = DIRECTION_RIGHT) Or (Not player.faceDirection And direction = DIRECTION_LEFT)) And player.getCollisionRect().y1 < Self.collisionRect.y1) Then
						player.beStop(Self.collisionRect.y0, 1, Self)
						
						Self.used = True
					EndIf
				Default
					' Nothing so far.
			End Select
		End
End