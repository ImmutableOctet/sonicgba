Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Shatter Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1792
		Const COLLISION_HEIGHT:Int = 3072
		
		Const VELOCITY:Int = 600
		
		' Global variable(s):
		Global image:MFImage
		
		' Fields:
		Field posYOriginal:Int
		Field trigger:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.trigger = False
			
			Self.posYOriginal = (Self.posY - COLLISION_HEIGHT)
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/shatter.png")
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Self.trigger) Then
				drawInMap(g, image, 17)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.trigger) Then
				Self.collisionRect.collisionChk(player.getBodyPositionX(), player.getBodyPositionY())
				
				Self.trigger = True
				Self.posY = Self.posYOriginal
				
				refreshCollisionRect(Self.posX, Self.posY)
			ElseIf (direction = DIRECTION_LEFT Or direction = DIRECTION_RIGHT) Then
				player.beStop(0, direction, Self)
			Else
				player.beStop(0, 2, Self)
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.trigger And Not isInCamera()) Then
				Self.trigger = False
				
				Self.posY = (Self.posYOriginal + COLLISION_HEIGHT)
				
				refreshCollisionRect(Self.posX, Self.posY)
			EndIf
		End
		
		Method logic:Void()
			If (Self.trigger) Then
				Local preY:= Self.posY
				
				Self.posY += VELOCITY
				
				If (Self.posY >= (Self.posYOriginal + COLLISION_HEIGHT)) Then
					Self.posY = (Self.posYOriginal + COLLISION_HEIGHT)
				EndIf
				
				checkWithPlayer(Self.posX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.trigger) Then
				Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y, COLLISION_WIDTH, COLLISION_HEIGHT)
			Else
				' Magic number: 512
				Self.collisionRect.setRect(x + 512, y, Self.mWidth, Self.mHeight)
			EndIf
		End
		
		Method close:Void()
			' Empty implementation.
		End
End