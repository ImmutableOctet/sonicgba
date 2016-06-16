Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	'Import sonicgba.sonicdef
	Import sonicgba.gimmickobject
	Import sonicgba.playerknuckles
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:

' This class is used for most configurations of spikes.
Class Hari Extends GimmickObject
	Public
		' Constant variable(s):
		Const IMAGE_COLLISION_OFFSET:Int = 192
	Private
		' Constant variable(s):
		Const OFFFSET:Int = 128
		
		' Global variable(s):
		Global hariAnimation:Animation
		
		' Fields:
		Field hariId:Byte ' Int
		
		Field firstCollisionDirection:Int
		
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(GIMMICK_HARI_LEFT, x, y, left, top, width, height) ' id
			
			id = GIMMICK_HARI_LEFT
			
			Self.firstCollisionDirection = DIRECTION_NONE
			
			If (hariAnimation = Null) Then
				hariAnimation = New Animation("/animation/se_hari")
			EndIf
			
			Self.hariId = Byte(id - 1)
			
			Self.drawer = hariAnimation.getDrawer(Self.hariId, True, 0)
			
			Self.mWidth = (Self.drawer.getCurrentFrameWidth() Shl 6)
			Self.mHeight = (Self.drawer.getCurrentFrameHeight() Shl 6)
			
			Self.drawer.setPause(True)
		End
		
		' Methods:
		
		' Extensions:
		Method playSound:Void()
			SoundSystem.getInstance().playSe(SoundSystem.SE_171)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(hariAnimation)
			
			hariAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If ((hariId = 2)) Then
				DebugStop()
			EndIf
			
			drawInMap(g, Self.drawer, Self.posX, Self.posY)
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This isn't optimal, but it's what the original version did:
			If (Self.firstCollisionDirection <> DIRECTION_NONE And direction = DIRECTION_NONE) Then
				direction = Self.firstCollisionDirection
			EndIf
			
			If (Self.firstCollisionDirection = DIRECTION_NONE And direction <> DIRECTION_NONE) Then
				Self.firstCollisionDirection = direction
			EndIf
			
			Select (Self.objId)
				Case GIMMICK_HARI_MOVE_UP, GIMMICK_HARI_MOVE_DOWN
					' Make sure this set of spikes has lifted from the ground before trying to stop the player.
					' If we didn't perform this check, the player would float above the ground, or be unable to pass:
					If (Self.drawer.getCurrentFrameHeight() <> 0) Then
						p.beStop(Self.collisionRect.x0, direction, Self)
					EndIf
				Default
					' Since we're a normal spike configuration, we should always be solid to the player.
					p.beStop(Self.collisionRect.x0, direction, Self)
			End Select
			
			' This is Knuckles specific behavior. From what I understand, it's here to account for gliding:
			If ((p.getCharacterID() = CHARACTER_KNUCKLES) And direction = DIRECTION_NONE And p.canAttackByHari) Then
				If (p.getRingNum() > 0) Then
					playSound()
				EndIf
				
				p.beHurt()
				
				p.canAttackByHari = False
				p.beAttackByHari = True
			EndIf
			
			Print("direction: " + direction + ", at: " + Self.hariId)
			
			' This behavior may change in the future:
			If (p = player And p.canBeHurt()) Then
				' Apply different effects based on our configuration:
				Select (Self.objId)
					Case GIMMICK_HARI_UP, GIMMICK_HARI_MOVE_UP
						If (direction = DIRECTION_DOWN And Self.drawer.getCurrentFrameHeight() <> 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
						EndIf
					Case GIMMICK_HARI_DOWN, GIMMICK_HARI_MOVE_DOWN
						If (direction = DIRECTION_UP And Self.drawer.getCurrentFrameHeight() <> 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
						EndIf
					Case GIMMICK_HARI_LEFT
						If (direction = DIRECTION_RIGHT) Then
							If (p.velX > 0 Or p.getAnimationId() = PlayerObject.ANI_STAND) Then
								If (p.getRingNum() > 0) Then
									playSound()
								EndIf
								
								p.beHurt()
								
								p.beAttackByHari = True
							EndIf
						EndIf
					Case GIMMICK_HARI_RIGHT
						If (direction = DIRECTION_LEFT) Then
							If (p.velX < 0 Or p.getAnimationId() = PlayerObject.ANI_STAND) Then
								If (p.getRingNum() > 0) Then
									playSound()
								EndIf
								
								p.beHurt()
								
								p.beAttackByHari = True
							EndIf
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.firstCollisionDirection = DIRECTION_NONE
		End
		
		Method logic:Void()
			Self.drawer.moveOn()
			
			checkWithPlayer(Self.posX, Self.posY, Self.posX, Self.posY)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Select (Self.objId)
				Case GIMMICK_HARI_UP, GIMMICK_HARI_MOVE_UP
					Self.collisionRect.setRect(x - (Self.mWidth / 2), ((y + OFFFSET) - (Self.drawer.getCurrentFrameHeight() Shl 6)) + IMAGE_COLLISION_OFFSET, Self.mWidth, (Self.drawer.getCurrentFrameHeight() Shl 6) - IMAGE_COLLISION_OFFSET) ' Shr 1
				Case GIMMICK_HARI_DOWN, GIMMICK_HARI_MOVE_DOWN
					Self.collisionRect.setRect(x - (Self.mWidth / 2), y - OFFFSET, Self.mWidth, (Self.drawer.getCurrentFrameHeight() Shl 6) - IMAGE_COLLISION_OFFSET) ' Shr 1
				Case GIMMICK_HARI_LEFT
					Self.collisionRect.setRect((x - (Self.drawer.getCurrentFrameWidth() Shl 6)) + OFFFSET, (y + OFFFSET) - (Self.drawer.getCurrentFrameHeight() Shl 6), Self.drawer.getCurrentFrameWidth() Shl 6, Self.drawer.getCurrentFrameHeight() Shl 6)
				Case GIMMICK_HARI_RIGHT
					Self.collisionRect.setRect(x - OFFFSET, (y + OFFFSET) - (Self.drawer.getCurrentFrameHeight() Shl 6), Self.drawer.getCurrentFrameWidth() Shl 6, Self.drawer.getCurrentFrameHeight() Shl 6)
				Default
					' Nothing so far.
			End Select
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End