Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.gimmickobject
Friend sonicgba.boss6blockarray
Friend sonicgba.boss6

' Imports:
Private
	Import sonicgba.collisionrect
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Boss6Block Extends GimmickObject
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2176
		Const COLLISION_HEIGHT:Int = 1536
		
		Const COLLISION2_HEIGHT:Int = 1664
	Private
		' Global variable(s):
		Global blockImage:MFImage
		
		' Fields:
		Field IsDisplay:Bool
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(GIMMICK_BOSS6_BLOCK, x, y, 0, 0, 0, 0)
			
			If (blockImage = Null) Then
				blockImage = MFImage.createImage("/gimmick/boss6_block.png")
			EndIf
			
			Self.IsDisplay = True
			
			Self.used = False
			
			Self.posX = x
			Self.posY = y
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			blockImage = Null
		End
		
		' Methods:
		Method logic:Void(x:Int, y:Int)
			If (Self.IsDisplay) Then
				Self.posX = x
				Self.posY = y
				
				checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY)
			EndIf
		End
		
		Method getUsedState:Bool()
			Return Self.used
		End
		
		Method setUsedState:Void(state:Bool)
			Self.used = state
		End
		
		Method setDisplayState:Void(state:Bool)
			Self.IsDisplay = state
		End
		
		Method draw:Void(g:MFGraphics)
			If (Self.IsDisplay) Then
				drawInMap(g, blockImage, Self.posX, Self.posY, VCENTER|HCENTER)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.IsDisplay) Then
				player.beStop(Self.collisionRect.y0, DIRECTION_DOWN, Self)
				
				Self.used = True
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.IsDisplay) Then
				Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
		
		Method collisionChkWithObject:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			' Magic numbers: 192, 384
			rectV.setRect(objectRect.x0 + 192, objectRect.y0, objectRect.getWidth() - 384, objectRect.getHeight())
			
			Return thisRect.collisionChk(rectV)
		End
End