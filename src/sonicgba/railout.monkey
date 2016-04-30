Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.railin

' Imports:
Private
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import sonicgba.gimmickobject
	Import sonicgba.railin
Public

' Classes:
Class RailOut Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2688
		Const COLLISION_HEIGHT:Int = 2560
		
		Const IMAGE_HEIGHT:Int = 1536
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			RailIn.MakeImage()
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT) ' (y - (COLLISION_HEIGHT/2))
		End
		
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			If (Not Self.used) Then
				Local collisionRect:= Self.collisionRect
				
				Local bodyPositionX:= player.getBodyPositionX()
				Local bodyPositionY:= player.getBodyPositionY()
				
				If (collisionRect.collisionChk(bodyPositionX, bodyPositionY - (IMAGE_HEIGHT / 2)) Or Self.collisionRect.collisionChk(player.getBodyPositionX(), player.getBodyPositionY())) Then
					player.railOut(Self.posX, Self.posY)
					
					Self.used = True
				EndIf
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Select (direction)
				Case DIRECTION_DOWN, DIRECTION_LEFT, DIRECTION_RIGHT
					player.beStop(0, direction, Self)
				Default
					' Nothing so far.
			End Select
		End
		
		Method doWhileNoCollision:Void()
			Self.used = False
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_BEFORE_SONIC
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, RailIn.railInOutImage, Self.posX, (Self.posY - COLLISION_HEIGHT) + IMAGE_HEIGHT, 17)
			drawCollisionRect(graphics)
		End
End