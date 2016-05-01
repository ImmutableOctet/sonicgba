Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.platform
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class UpPlatform Extends Platform
	Private
		' Fields:
		Field offsetY:Int
		Field posOriginalY:Int
		Field velocity:Int
		
		Field initFlag:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 128 ' (COLLISION_OFFSET_Y / 2)
			Self.offsetY = COLLISION_OFFSET_Y
			
			Self.posOriginalY = Self.posY
			Self.initFlag = False
		End
	Public
		' Methods:
		Method logic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.initFlag) Then
				refreshCollisionRect(Self.posX, Self.posY)
				
				If (Not screenRect.collisionChk(Self.collisionRect)) Then
					Self.initFlag = False
					
					Return
				EndIf
				
				Return
			EndIf
			
			If (player.isFootOnObject(Self)) Then
				checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY + Self.velocity)
				
				Self.posY -= Self.velocity
			Else
				checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY + Self.velocity)
				
				If (Self.posY < Self.posOriginalY) Then
					Self.posY += Self.velocity
				Else
					Self.posY = Self.posOriginalY
				EndIf
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method doInitWhileInCamera:Void()
			Self.posY = Self.posOriginalY
			
			Self.used = False
			Self.initFlag = True
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.initFlag) Then
				If (Not (Not player.isFootOnObject(Self) Or Self.worldInstance.getWorldY(player.collisionRect.x0, player.footPointY - PlayerObject.HEIGHT, 1, 0) = -1000 Or Self.worldInstance.getWorldY(player.collisionRect.x1, player.footPointY - PlayerObject.HEIGHT, 1, 0) = -1000)) Then
					player.setDie(False)
				EndIf
				
				Super.doWhileCollision(player, direction)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.initFlag) Then
				drawInMap(g, platformImage, Self.posX, (Self.posY + DRAW_OFFSET_Y) + Self.offsetY, BOTTOM|HCENTER)
			EndIf
		End
End