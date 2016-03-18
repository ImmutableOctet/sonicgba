Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import sonicgba.gimmickobject
Public

' Classes:
Class Ship Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_HEIGHT:Int = 192
		Const COLLISION_OFFSET_Y:Int = 768
		Const COLLISION_WIDTH:Int = 4224
		
		' Global variable(s):
		Global shipImage:MFImage
		
		' Fields:
		Field system:ShipSystem
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, system:ShipSystem)
			Super.New(id, x, y, 0, 0, 0, 0)
			
			Self.system = system
			
			If (shipImage = Null) Then
				shipImage = MFImage.createImage("/gimmick/ship.png")
			EndIf
		End
	Public
		' Methods:
		Method logic:Void()
			Self.system.getNewShipPosition(Self)
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y + COLLISION_OFFSET_Y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
	
		Method draw:Void(graphics:MFGraphics)
			' Magic numbers: 40, 2, 36
			drawInMap(graphics, shipImage, Self.posX, (Self.posY + COLLISION_OFFSET_Y) + COLLISION_HEIGHT, 40)
			drawInMap(graphics, shipImage, 0, 0, MyAPI.zoomIn(shipImage.getWidth()), MyAPI.zoomIn(shipImage.getHeight()), 2, Self.posX, (Self.posY + COLLISION_OFFSET_Y) + COLLISION_HEIGHT, 36)
			
			drawCollisionRect(graphics)
		End
	
		Public Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not player.isFootOnObject(Self)) Then
				Select (direction)
					Case DIRECTION_DOWN
						' Make sure the player doesn't fall through the ship.
						player.beStop(Self.collisionRect.y0, direction, Self)
					Default
						' Nothing so far.
				End Select
			EndIf
		End
	
		Method close:Void()
			Self.system = Null
		End
		
		' Functions:
		Function releaseAllResource:Void()
			shipImage = Null
		End
End