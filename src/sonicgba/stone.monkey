Strict

Public

' Imports:
Private
	Import sonicgba.effect
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Stone Extends GimmickObject
	Private
		' Constant variable(s):
		Const STONE_WIDTH:Int = 2624
		Const STONE_HEIGHT:Int = 1728
		
		Const STONE_OFFSETY:Int = -128
		
		' Global variable(s):
		Global image:MFImage
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/stone.png")
			EndIf
			
			Self.used = False
		End
		
		' Methods:
		
		' Extensions:
		Method playSound:Void()
			soundInstance.playSe(SoundSystem.SE_138)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.used) Then
				drawInMap(g, image, Self.posX, Self.posY + STONE_OFFSETY, BOTTOM|HCENTER)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.used) Then
				Select (direction)
					Case DIRECTION_UP
						p.beStop(0, direction, Self)
					Case DIRECTION_DOWN
						' This behavior may change in the future:
						If (p <> player Or Not p.isAttackingEnemy() Or Not Self.firstTouch) Then
							p.beStop(Self.collisionRect.y0, direction, Self)
						Else
							Self.used = True
							
							p.doAttackPose(Self, direction)
							
							playSound()
						EndIf
					Case DIRECTION_LEFT, DIRECTION_RIGHT
						' This behavior may change in the future:
						If (p <> player Or Not p.isAttackingItem() Or Not Self.firstTouch Or player.collisionState = PlayerObject.COLLISION_STATE_WALK) Then
							p.beStop(Self.collisionRect.y0, direction, Self)
						Else
							Self.used = True
							
							p.doAttackPose(Self, direction)
							
							playSound()
						EndIf
				End Select
				
				If (Self.used) Then
					Effect.showEffect(rockBreakAnimation, 0, (Self.posX Shr 6), (Self.posY Shr 6), 0)
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (Not Self.used And animationID <> PlayerObject.ANI_SPIN_LV2 And animationID <> PlayerObject.ANI_SPIN_LV1 And animationID <> PlayerObject.ANI_BAR_ROLL_1 And animationID <> PlayerObject.ANI_ATTACK_2 And animationID <> PlayerObject.ANI_HURT) Then
				player.doAttackPose(Self, direction)
				
				playSound()
				
				Self.used = True
				
				Effect.showEffect(rockBreakAnimation, 0, (Self.posX Shr 6), (Self.posY Shr 6), 0)
				
				player.cancelFootObject()
				player.setVelY(GRAVITY)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (STONE_WIDTH / 2), y - STONE_HEIGHT, STONE_WIDTH, STONE_HEIGHT)
		End
		
		Method close:Void()
			' Empty implementation.
		End
End