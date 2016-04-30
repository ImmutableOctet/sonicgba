Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.seabedvolcanobase
Friend sonicgba.seabedvolcanohurt

' Imports:
Private
	Import sonicgba.collisionrect
	Import sonicgba.gimmickobject
	Import sonicgba.playerknuckles
	Import sonicgba.playerobject
	
	Import sonicgba.seabedvolcanobase
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class SeabedVolcanoPlatform Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 1536
		
		Const COLLISION_OFFSET_Y:Int = 0
		
		Const LAUNCH_VEL:Int = -1400
		
		' Global variable(s):
		Global endCount:Int
		Global image:MFImage
		Global moving:Bool
		Global velocity:Int
		
		' Fields:
		Field posOriginalY:Int
		
		Field sb:SeabedVolcanoBase
	Public
		' Global variable(s):
		Global sPosY:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, sb:SeabedVolcanoBase)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Self.posOriginalY = Self.posY
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/platform4_fire_mt.png")
			EndIf
			
			Self.sb = sb
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		Function staticLogic:Void()
			If (moving) Then
				velocity += GRAVITY
				sPosY += velocity
				
				If (sPosY >= 0) Then
					sPosY = 0
					endCount -= 1
					
					If (endCount <= 0) Then
						moving = False
					Else
						velocity = ((-velocity) / 2)
					EndIf
				EndIf
			EndIf
		End
		
		Function shot:Void()
			moving = True
			
			velocity = LAUNCH_VEL
			
			endCount = 3
		End
		
		Function isShotting:Bool()
			Return (moving And (endCount = 3))
		End
		
		' Methods:
		Method logic:Void()
			If (player.isFootOnObject(Self) And (player.getCharacterID() = CHARACTER_KNUCKLES)) Then
				' Optimization potential; dynamic cast.
				Local knuckles:= PlayerKnuckles(player)
				
				If (knuckles <> Null) Then
					knuckles.setFloating(False)
				EndIf
			EndIf
			
			Local preY:= Self.posY
			
			Self.posY = Self.posOriginalY + sPosY
			
			checkWithPlayer(Self.posX, preY, Self.posX, Self.posY)
			
			Self.sb.sh.refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method drawPlatform:Void(g:MFGraphics)
			drawInMap(g, image, Self.posX, Self.posY + (COLLISION_HEIGHT / 2), BOTTOM|HCENTER)
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - COLLISION_HEIGHT, (y - (COLLISION_HEIGHT / 2)) - COLLISION_OFFSET_Y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (direction = DIRECTION_DOWN Or (direction = DIRECTION_NONE And player.getVelY() > 0)) Then
				player.beStop(0, DIRECTION_DOWN, Self)
			EndIf
			
			If (direction = DIRECTION_NONE And (player.getCharacterID() = CHARACTER_KNUCKLES) And player.myAnimationID = PlayerKnuckles.KNUCKLES_ANI_CLIMB_5) Then
				' Magic number: 268
				player.posY -= 268
			EndIf
		End
		
		Method close:Void()
			Self.sb = Null
		End
		
		Method collisionChkWithObject:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			' Magic numbers: 192, 384
			rectV.setRect((objectRect.x0 + 192), objectRect.y0, (objectRect.getWidth() - 384), objectRect.getHeight())
			
			Return thisRect.collisionChk(rectV)
		End
End