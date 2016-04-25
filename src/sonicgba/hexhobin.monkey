Strict

Public

' Imports:
Private
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.hobincal
	Import sonicgba.movecalculator
	
	Import sonicgba.playerobject
	Import sonicgba.playerknuckles
	Import sonicgba.playertails
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class HexHobin Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 2176
		
		Const HOBIN_POWER:Int = 1152
		
		Const VELOCITY:Int = 250
		
		' Global variable(s):
		Global hexHobinImage:MFImage = Null
		
		' Fields:
		Field isH:Bool
	Public
		' Fields:
		Field hobinCal:HobinCal
		Field moveCal:MoveCalculator
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (hexHobinImage = Null) Then
				hexHobinImage = MFImage.createImage("/gimmick/hex_hobin.png")
			EndIf
			
			Local moveDirection:Bool
			
			If (Self.mWidth >= Self.mHeight) Then
				Self.isH = True
				
				moveDirection = (Self.iLeft <> 0)
			Else
				Self.isH = False
				
				moveDirection = (Self.iTop <> 0)
			EndIf
			
			Self.moveCal = New MoveCalculator(PickValue(Self.isH, Self.posX, Self.posY), PickValue(Self.isH, Self.mWidth, Self.mHeight), moveDirection)
			
			Self.hobinCal = New HobinCal()
		End
		
		' Methods:
		
		' Extensions:
		Method doWhileCollision_jumpCheck:Bool(player:PlayerObject)
			Return ((player.getCharacterID() = CHARACTER_KNUCKLES) And ((player.getCharacterAnimationID() >= PlayerKnuckles.KNUCKLES_ANI_FLY_1 And player.getCharacterAnimationID() <= PlayerKnuckles.KNUCKLES_ANI_FLY_4) Or (player.getCharacterAnimationID() >= PlayerKnuckles.KNUCKLES_ANI_CLIMB_1 And player.getCharacterAnimationID() <= PlayerKnuckles.KNUCKLES_ANI_CLIMB_5))) Or ((player.getCharacterID() = CHARACTER_TAILS) And (player.getCharacterAnimationID() >= PlayerTails.TAILS_ANI_FLY_1 And player.getCharacterAnimationID() <= PlayerTails.TAILS_ANI_FLY_3))
		End
		
		Method doWhileCollision_jumpBehavior:Void(player:PlayerObject, direction:Int)
			If (direction = DIRECTION_RIGHT) Then
				player.rightStopped = False
				
				If (doWhileCollision_jumpCheck(player)) Then
					player.animationID = PlayerObject.ANI_JUMP
				EndIf
			ElseIf (direction = DIRECTION_LEFT) Then
				player.leftStopped = False
				
				If (doWhileCollision_jumpCheck(player)) Then
					player.animationID = PlayerObject.ANI_JUMP
				EndIf
			EndIf
			
			If (player.collisionState <> PlayerObject.COLLISION_STATE_WALK) Then
				player.collisionState = PlayerObject.COLLISION_STATE_JUMP
			EndIf
			
			player.dashRolling = False
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			hexHobinImage = Null
		End
		
		' Methods:
		Method logic:Void()
			Self.moveCal.logic()
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.isH) Then
				Self.posX = Self.moveCal.getPosition()
			Else
				Self.posY = Self.moveCal.getPosition()
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, hexHobinImage, (Self.posX + Self.hobinCal.getPosOffsetX()), (Self.posY + Self.hobinCal.getPosOffsetY()), VCENTER|HCENTER)
			
			' This probably belongs in 'logic'...
			Self.hobinCal.logic()
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			'If (player.collisionState = PlayerObject.COLLISION_STATE_JUMP And player.animationID <> PlayerObject.ANI_JUMP) Then
			player.beStop(Self.collisionRect.y0, direction, Self)
			'EndIf
			
			doWhileCollision_jumpBehavior(player, direction)
			
			' Magic number: 400
			Select (direction)
				Case DIRECTION_UP
					player.setVelY(HOBIN_POWER)
					
					If (((player.collisionRect.x0 + player.collisionRect.x1) / 2) < ((Self.collisionRect.x0 + Self.collisionRect.x1) / 2)) Then ' Shr 1
						player.setVelX(-HOBIN_POWER)
						
						Self.hobinCal.startHobin(400, 135, 10)
					ElseIf (((player.collisionRect.x0 + player.collisionRect.x1) / 2) > ((Self.collisionRect.x0 + Self.collisionRect.x1) / 2)) Then ' Shr 1
						player.setVelX(HOBIN_POWER)
						
						Self.hobinCal.startHobin(400, 45, 10)
					EndIf
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_183)
				Case DIRECTION_DOWN
					player.setVelY(-HOBIN_POWER)
					
					If (((player.collisionRect.x0 + player.collisionRect.x1) / 2) < ((Self.collisionRect.x0 + Self.collisionRect.x1) / 2)) Then ' Shr 1
						player.setVelX(-HOBIN_POWER)
						
						Self.hobinCal.startHobin(400, 225, 10)
					ElseIf (((player.collisionRect.x0 + player.collisionRect.x1) / 2) > ((Self.collisionRect.x0 + Self.collisionRect.x1) / 2)) Then ' Shr 1
						player.setVelX(HOBIN_POWER)
						
						Self.hobinCal.startHobin(400, -45, 10)
					EndIf
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_183)
				Case DIRECTION_LEFT
					player.setVelX(HOBIN_POWER)
					
					Self.hobinCal.startHobin(400, 180, 10)
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_183)
				Case DIRECTION_RIGHT
					player.setVelX(-HOBIN_POWER)
					
					Self.hobinCal.startHobin(400, 0, 10)
					
					SoundSystem.getInstance().playSe(SoundSystem.SE_183)
				Default
					' Nothing so far.
			End Select
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End