Strict

Public

' Imports:
Private
	Import lib.coordinate
	Import lib.soundsystem
	
	Import sonicgba.freefallsystem
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playertails
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class FreeFallBar Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 2560
		
		Const PLAYER_OFFSET:Int = -640
		
		' Global variable(s):
		Global barImage:MFImage
		Global frameCnt:Int = 0
		
		' Fields:
		Field isLeftEnter:Bool
		
		Field posXorg:Int
		Field posYorg:Int
		
		Field system:FreeFallSystem
	Protected
		' Constructor(s):
		Method New(system:FreeFallSystem, x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Self.system = system
			
			If (barImage = Null) Then
				barImage = MFImage.createImage("/gimmick/freefall_bar.png")
			EndIf
			
			frameCnt = 1
			
			Self.isLeftEnter = False
			
			Local co:= system.getBarPosition()
			
			Self.posXorg = co.x
			Self.posYorg = co.y
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			barImage = Null
		End
		
		' Methods:
		Method init:Void()
			Self.used = False
			
			frameCnt = 0
			
			Self.posX = Self.posXorg
			Self.posY = Self.posYorg
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method barLogic:Void()
			Local co:= Self.system.getBarPosition()
			
			Self.posX = co.x
			Self.posY = co.y
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (Self.system.moving) Then
				player.setFootPositionY(Self.posY - PLAYER_OFFSET)
				player.setFootPositionX(Self.posX)
				
				player.faceDirection = True
				
				Print("bar posX:" + (Self.posX Shr 6))
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.system.initFlag) Then
				If (Self.system.moving) Then
					frameCnt += 1
					
					If (player.getAnimationId() = PlayerObject.ANI_BAR_ROLL_1) Then
						drawInMap(g, barImage, BOTTOM|HCENTER)
						
						player.draw(g, True)
					ElseIf (player.getAnimationId() = PlayerObject.ANI_BAR_ROLL_2) Then
						player.draw(g, True)
						
						drawInMap(g, barImage, BOTTOM|HCENTER)
					Else
						player.setAnimationId(23)
					EndIf
					
					Print("player posX:" + (player.footPointX Shr 6))
				Else
					drawInMap(g, barImage, BOTTOM|HCENTER)
				EndIf
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.system.isSystemReady()) Then
				Return
			EndIf
			
			If (((player.getCharacterID() <> CHARACTER_TAILS) Or player.getCharacterAnimationID() < PlayerTails.TAILS_ANI_FLY_1 Or player.getCharacterAnimationID() > PlayerTails.TAILS_ANI_FLY_3) And Not Self.used And Not Self.system.moving) Then
				Self.used = True
				
				Self.system.moving = True
				
				Self.system.shootDirection = (player.getVelX() > 0)
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_209)
				
				player.changeVisible(False)
				player.setOutOfControl(Self)
				
				Select (direction)
					Case DIRECTION_LEFT
						player.setAnimationId(SoundSystem.ANI_BAR_ROLL_1)
						
						Self.isLeftEnter = True
					Case DIRECTION_RIGHT
						player.setAnimationId(SoundSystem.ANI_BAR_ROLL_2)
						
						Self.isLeftEnter = False
				End Select
				
				player.cancelFootObject()
				
				player.collisionChkBreak = True
				player.faceDirection = True
				
				player.collisionState = PlayerObject.COLLISION_STATE_JUMP
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.system = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method doInitInCamera:Void()
			Self.used = False
			
			frameCnt = 0
		End
End