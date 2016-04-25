Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import lib.myapi
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
Public

' Classes:
Class Split Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		Const DEGREE_VELOCITY:Int = 2560
		Const SHOOT_SPEED:Int = 2700
		
		Const RADIUS:Int = 512
		
		' Fields:
		Field controlling:Bool
		Field degree:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.posY -= (RADIUS / 2) ' 256
		End
		
		' Methods:
		
		' Extensions:
		Method playSound:Void(player:PlayerObject)
			If (player.getCharacterID() <> CHARACTER_AMY) Then
				soundInstance.playSe(SoundSystem.SE_109)
			Else
				soundInstance.playSe(SoundSystem.SE_133)
			EndIf
		End
		
		Method playSound:Void()
			playSound(player)
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method logic:Void()
			If (Self.controlling) Then
				Self.firstTouch = False
				
				Self.degree += DEGREE_VELOCITY
				Self.degree Mod= 23040 ' (360 Shl 6)
				
				player.setBodyPositionX(Self.posX + ((MyAPI.dCos(Self.degree Shr 6) * RADIUS) / 100))
				player.setBodyPositionY(Self.posY + ((MyAPI.dSin(Self.degree Shr 6) * RADIUS) / 100))
				
				Local left:Bool = False
				
				Local nextVelX:= 0
				Local nextVelY:= 0
				
				Select (Self.iLeft)
					Case 0 ' Down + Right
						If (Key.press(Key.gDown)) Then
							player.setBodyPositionX(Self.posX)
							player.setBodyPositionY(Self.posY + RADIUS)
							
							left = True
							
							nextVelX = 0
							nextVelY = SHOOT_SPEED
							
							playSound()
						ElseIf (Key.press(Key.gRight)) Then
							player.setBodyPositionX(Self.posX + RADIUS)
							player.setBodyPositionY(Self.posY)
							
							left = True
							
							nextVelX = SHOOT_SPEED
							nextVelY = -GRAVITY ' 0 - GRAVITY
							
							player.faceDirection = True
							
							playSound()
						EndIf
					Case 1 ' Left + Right
						If (Key.press(Key.gLeft)) Then
							player.setBodyPositionX(Self.posX)
							player.setBodyPositionY(Self.posY)
							
							left = True
							
							nextVelX = -SHOOT_SPEED
							nextVelY = SHOOT_SPEED - GRAVITY
							
							player.faceDirection = False
							
							playSound()
						ElseIf (Key.press(Key.gRight)) Then
							player.setBodyPositionX(Self.posX)
							player.setBodyPositionY(Self.posY)
							
							left = True
							
							nextVelX = SHOOT_SPEED
							nextVelY = SHOOT_SPEED - GRAVITY
							
							player.faceDirection = True
							
							playSound()
						EndIf
					Case 2 ' Right
						If (Key.press(Key.gRight)) Then
							player.setBodyPositionX(Self.posX + RADIUS)
							player.setBodyPositionY(Self.posY)
							
							left = True
							
							nextVelX = SHOOT_SPEED
							nextVelY = GRAVITY ' 0 - GRAVITY
							
							player.faceDirection = True
							
							playSound()
						EndIf
					Case 3 ' Down
						If (Key.press(Key.gDown)) Then
							player.setBodyPositionX(Self.posX)
							player.setBodyPositionY(Self.posY + RADIUS)
							
							left = True
							
							nextVelX = 0
							nextVelY = SHOOT_SPEED
							
							playSound()
						EndIf
				End Select
				
				If (left) Then
					player.collisionState = PlayerObject.COLLISION_STATE_JUMP
					
					player.setAnimationId(PlayerObject.ANI_JUMP)
					
					player.setVelX(nextVelX)
					player.setVelY(nextVelY)
					
					Self.controlling = False
					
					player.outOfControl = False
				EndIf
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.firstTouch) Then
				Self.controlling = True
				
				player.setAnimationId(PlayerObject.ANI_JUMP)
				player.setOutOfControlInPipe(Self)
				
				soundInstance.playSe(SoundSystem.SE_148)
			EndIf
		End
End