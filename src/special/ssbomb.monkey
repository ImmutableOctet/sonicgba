Strict

Public

' Imports:
Private
	Import special.specialmap
	Import special.specialobject
	
	Import sonicgba.sonicdebug
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SSBomb Extends SpecialObject
	Private
		' Constructor(s):
		Const COLLISION_WIDTH:Int = 8
		Const COLLISION_HEIGHT:Int = 6
		
		' Fields:
		Field used:Bool
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int)
			Super.New(SSOBJ_BOMB_ID, x, y, z)
			
			Self.drawer = objAnimation.getDrawer(2, True, 0)
			
			Self.used = False
		End
		
		' Methods:
		Method close:Void()
			' Empty implementation.
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			If (Not Self.used) Then
				player.beHurt()
				
				player.velZ = 4
				
				Self.drawer.setActionId(3)
				Self.drawer.setLoop(False)
				
				Self.used = True
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			SpecialObject.calDrawPosition(Self.posX, Self.posY, Self.posZ)
			drawObj(g, Self.drawer, 0, 0)
			
			SSBomb_drawCollisionRect(g, (drawX + (SCREEN_WIDTH / 2)) - SpecialMap.getCameraOffsetX(), (drawY + (SCREEN_HEIGHT / 2)) - SpecialMap.getCameraOffsetY()) ' / 2
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method refreshCollision:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
	Protected
		' Methods:
		Method SSBomb_drawCollisionRect:Void(g:MFGraphics, x:Int, y:Int)
			If (SonicDebug.showCollisionRect) Then
				g.setColor(16711680)
				
				g.drawRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
				g.drawRect((x - (COLLISION_WIDTH/2)) + 1, (y - (COLLISION_HEIGHT/2)) + 1, COLLISION_HEIGHT, 4)
			EndIf
		End
End