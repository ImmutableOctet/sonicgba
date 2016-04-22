Strict

Public

' Imports:
Private
	Import lib.soundsystem
	
	Import sonicgba.effect
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Ice Extends GimmickObject
	Private
		' Constant variable(s):
		Const ICE_SIZE:Int = 2560
		
		' Global variable(s):
		Global image:MFImage
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/ice.png")
			EndIf
			
			Self.used = False
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Not Self.used) Then
				drawInMap(g, image, Self.posX, Self.posY, BOTTOM|HCENTER)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.used) Then
				Select (direction)
					Case DIRECTION_UP
						p.beStop(0, direction, Self) ' DIRECTION_UP
					Case DIRECTION_DOWN
						' This behavior may change in the future:
						If (p <> player Or Not p.isAttackingEnemy() Or Not Self.firstTouch) Then
							p.beStop(Self.collisionRect.y0, direction, Self) ' DIRECTION_DOWN
						Else
							Self.used = True
							
							p.setVelY(0)
							p.animationID = 1
						EndIf
					Case DIRECTION_LEFT, DIRECTION_RIGHT
						If (p <> player Or Not p.isAttackingEnemy() Or Not Self.firstTouch Or player.collisionState = Null) Then
							p.beStop(Self.collisionRect.y0, direction, Self)
						Else
							Self.used = True
							p.setVelY(0)
						EndIf
				End Select
				
				If (Self.used) Then
					Effect.showEffect(destroyEffectAnimation, 0, (Self.posX Shr 6), ((Self.posY - (ICE_SIZE / 2)) Shr 6), 0)
					Effect.showEffect(iceBreakAnimation, 0, (Self.posX Shr 6), ((Self.posY - (ICE_SIZE / 2)) Shr 6), 0)
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_193)
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (Not Self.used) Then
				Self.used = True
				
				If (Self.used) Then
					Effect.showEffect(destroyEffectAnimation, 0, (Self.posX Shr 6), ((Self.posY - (ICE_SIZE / 2)) Shr 6), 0)
					Effect.showEffect(iceBreakAnimation, 0, (Self.posX Shr 6), ((Self.posY - (ICE_SIZE / 2)) Shr 6), 0)
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_193)
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (ICE_SIZE / 2), y - ICE_SIZE, ICE_SIZE, ICE_SIZE)
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
End