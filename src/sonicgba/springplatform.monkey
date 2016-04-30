Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.spring

' Imports:
Private
	Import sonicgba.collisionrect
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class SpringPlatform Extends GimmickObject
	Private
		' Constructor(s):
		Const COLLISION_WIDTH:Int = 2048
		Const COLLISION_HEIGHT:Int = 2304
		
		Const FAR_DISTANCE:Int = 3840
		Const MOST_ACCELATE:Int = 150
		
		' Global variable(s):
		Global image:MFImage
		
		' Fields:
		Field centerY:Int
		Field velY:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/spring_platform.png")
			EndIf
			
			Self.centerY = Self.posY
			
			Self.velY = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, image, VCENTER|HCENTER)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Select (direction)
				Case DIRECTION_DOWN
					If (Self.firstTouch) Then
						Self.velY += player.getVelY()
					EndIf
					
					player.beStop(0, direction, Self)
				Case DIRECTION_NONE
					If (player.getVelY() > 0 And player.getCollisionRect().y1 < Self.collisionRect.y1) Then
						player.beStop(0, DIRECTION_DOWN, Self)
					EndIf
			End Select
			
			If (player.isFootOnObject(Self)) Then
				player.setSqueezeEnable(False)
			EndIf
		End
		
		Method logic:Void()
			Local accelerate:= (((Self.centerY - Self.posY) * MOST_ACCELATE) / FAR_DISTANCE)
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Self.velY += accelerate
			
			' Magic number: 10
			If (Self.velY > 0) Then
				Self.velY -= 10
			ElseIf (Self.velY < 0) Then
				Self.velY += 10
			EndIf
			
			Self.posY += Self.velY
			
			If (Self.posY > (Self.centerY + FAR_DISTANCE)) Then
				Self.posY = (Self.centerY + FAR_DISTANCE)
				
				Self.velY = 0
			EndIf
			
			If (Self.posY < (Self.centerY - FAR_DISTANCE)) Then
				Self.posY = (Self.centerY - FAR_DISTANCE)
				
				Self.velY = 0
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
			
			If (Not player.isFootOnObject(Self)) Then
				player.setSqueezeEnable(True)
			EndIf
		End
		
		Method collisionChkWithObject:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			' Magic numbers: 192, 384
			rectV.setRect(objectRect.x0 + 192, objectRect.y0, objectRect.getWidth() - 384, objectRect.getHeight()) ' ((PlayerObject.BODY_OFFSET / 2) / 2)
			
			Return thisRect.collisionChk(rectV)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End