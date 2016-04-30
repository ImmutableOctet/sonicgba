Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private

Import sonicgba.gimmickobject
Import sonicgba.playerobject
Import sonicgba.playeramy
Import sonicgba.playerknuckles

Import com.sega.mobile.framework.device.mfgraphics
Import com.sega.mobile.framework.device.mfimage

Public

' Classes:
Class CageButton Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2176
		Const COLLISION_HEIGHT:Int = 896
		
		Const PUSH_OFFSET_Y:Int = 320
		
		' Global variable(s):
		Global cageButtonImage:MFImage = Null
		
		' Fields:
		Field posOriginalY:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			If (cageButtonImage = Null) Then
				cageButtonImage = MFImage.createImage("/gimmick/cage_button.png")
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			cageButtonImage = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Self.used) Then
				checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posOriginalY + PUSH_OFFSET_Y)
				
				Self.posY = (Self.posOriginalY + PUSH_OFFSET_Y)
				
				Return
			EndIf
			
			checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY)
		End
		
		Method drawButton:Void(g:MFGraphics)
			drawInMap(g, cageButtonImage, 33)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), (y - COLLISION_HEIGHT), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If ((player.getCharacterID() = CHARACTER_KNUCKLES) And player.myAnimationID >= PlayerKnuckles.KNUCKLES_ANI_FLY_1 And player.myAnimationID <= PlayerKnuckles.KNUCKLES_ANI_FLY_4) Then
				player.beStop(0, direction, Self)
			ElseIf (Not Self.used) Then
				If (direction <> DIRECTION_UP) Then
					player.beStop(0, direction, Self)
				EndIf
				
				If (direction = DIRECTION_DOWN And Not Self.used) Then
					Self.used = True
					
					isUnlockCage = True
					
					Self.posOriginalY = Self.posY
					
					player.setCelebrate()
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If ((player.getCharacterID() = CHARACTER_AMY) And player.myAnimationID <> PlayerAmy.AMY_ANI_DASH_4 And Not Self.used) Then
				Self.used = True
				
				isUnlockCage = True
				
				Self.posOriginalY = Self.posY
				
				player.setCelebrate()
				
				player.faceDirection = (Not player.faceDirection)
			EndIf
		End
		
		Method close:Void()
			' Empty implementation.
		End
End