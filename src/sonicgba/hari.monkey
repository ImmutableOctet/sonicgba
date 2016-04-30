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
			Super.New(id, x, y, left, top, width, height)
			
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
			drawInMap(g, Self.drawer, Self.posX, Self.posY)
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Self.firstCollisionDirection <> DIRECTION_NONE And direction = DIRECTION_NONE) Then
				direction = Self.firstCollisionDirection
			EndIf
			
			If (Self.firstCollisionDirection = DIRECTION_NONE And direction <> DIRECTION_NONE) Then
				Self.firstCollisionDirection = direction
			EndIf
			
			Select (Self.objId)
				Case 5, 6
					If (Self.drawer.getCurrentFrameHeight() <> 0) Then
						p.beStop(Self.collisionRect.x0, direction, Self)
					EndIf
				Default
					p.beStop(Self.collisionRect.x0, direction, Self)
			End Select
			
			If ((p.getCharacterID() = CHARACTER_KNUCKLES) And direction = DIRECTION_NONE And p.canAttackByHari) Then
				If (p.getRingNum() > 0) Then
					playSound()
				EndIf
				
				p.beHurt()
				
				p.canAttackByHari = False
				p.beAttackByHari = True
			EndIf
			
			' This behavior may change in the future:
			If (p = player And p.canBeHurt()) Then
				Select (Self.objId)
					Case 1, 5
						If (direction = DIRECTION_DOWN And Self.drawer.getCurrentFrameHeight() <> 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
						EndIf
					Case 2, 6
						If (direction = DIRECTION_UP And Self.drawer.getCurrentFrameHeight() <> 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
						EndIf
					Case 3
						If (direction = DIRECTION_RIGHT And p.velX > 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
						ElseIf (direction = DIRECTION_RIGHT And p.getAnimationId() = 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
						EndIf
					Case 4
						If (direction = DIRECTION_LEFT And p.velX < 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
						ElseIf (direction = DIRECTION_LEFT And p.getAnimationId() = 0) Then
							If (p.getRingNum() > 0) Then
								playSound()
							EndIf
							
							p.beHurt()
							
							p.beAttackByHari = True
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
				Case 1, 5
					Self.collisionRect.setRect(x - (Self.mWidth / 2), ((y + OFFFSET) - (Self.drawer.getCurrentFrameHeight() Shl 6)) + IMAGE_COLLISION_OFFSET, Self.mWidth, (Self.drawer.getCurrentFrameHeight() Shl 6) - IMAGE_COLLISION_OFFSET) ' Shr 1
				Case 2, 6
					Self.collisionRect.setRect(x - (Self.mWidth / 2), y - OFFFSET, Self.mWidth, (Self.drawer.getCurrentFrameHeight() Shl 6) - IMAGE_COLLISION_OFFSET) ' Shr 1
				Case 3
					Self.collisionRect.setRect((x - (Self.drawer.getCurrentFrameWidth() Shl 6)) + OFFFSET, (y + OFFFSET) - (Self.drawer.getCurrentFrameHeight() Shl 6), Self.drawer.getCurrentFrameWidth() Shl 6, Self.drawer.getCurrentFrameHeight() Shl 6)
				Case 4
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