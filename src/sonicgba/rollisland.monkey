Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class RollIsland Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1792
		Const COLLISION_HEIGHT:Int = 1792
		
		Const VELOCITY:Int = 250
		Const VELOCITY_X:Int = 200
		
		Const MAX_VELOCITY:Int = 1280
		Const ROLL_MAX_VELOCITY:Int = 256
		
		Const MOVE_POWER:Int = 44
		
		' Global variable(s):
		Global animation:Animation = Null
		
		' Fields:
		Field controlling:Bool
		Field isActive:Bool
		
		Field noCollisionCount:Byte
		
		Field drawer:AnimationDrawer
		
		Field frame:Int
		
		Field moveDistance__rollisland:Int
		
		Field velocity:Int
		
		Field posOriginalX:Int
		Field posOriginalY:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.posX += ROLL_MAX_VELOCITY
			Self.posY += ROLL_MAX_VELOCITY
			
			If (animation = Null) Then
				animation = New Animation("/animation/roll_island")
			EndIf
			
			Self.drawer = animation.getDrawer(0, True, 0)
			
			Self.moveDistance__rollisland = ((width * 42) * 4) + (top * 4) ' (MOVE_POWER - 2)
			
			If ((Self.iLeft Mod 2) = 1) Then
				Self.moveDistance__rollisland Shr= 1 ' /= 2
			EndIf
			
			Self.posOriginalX = Self.posX
			Self.posOriginalY = Self.posY
			
			Self.controlling = False
			Self.isActive = False
		End
	Private
		' Methods:
		Method spinCheck:Bool()
			Local result:Bool = False
			
			If (player.faceDirection And Self.velocity > 0) Then
				result = True
			EndIf
			
			If (player.faceDirection Or Self.velocity >= 0) Then
				Return result
			EndIf
			
			Return True
		End
	Public
		' Constant variable(s):
		Global DIRECTION:Int[][] = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]] ' Const
		
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(animation)
			
			animation = Null
		End
		
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method logic:Void()
			If (Self.noCollisionCount > 0) Then
				Self.noCollisionCount -= 1
			EndIf
			
			If (player.outOfControl And player.outOfControlObject = Self) Then
				If (Key.repeated(Key.gRight)) Then
					Self.velocity += MOVE_POWER
					
					If (Self.velocity > MAX_VELOCITY) Then
						Self.velocity = MAX_VELOCITY
					EndIf
					
					player.faceDirection = True
				ElseIf (Key.repeated(Key.gLeft)) Then
					Self.velocity -= MOVE_POWER
					
					If (Self.velocity < -MAX_VELOCITY) Then
						Self.velocity = -MAX_VELOCITY
					EndIf
					
					player.faceDirection = False
				ElseIf (Self.posX = Self.posOriginalX And Self.posY = Self.posOriginalY) Then
					player.spinLogic2()
					
					If (player.getCharacterID() = CHARACTER_AMY) Then
						player.dashRollingLogicCheck()
					EndIf
					
					' Magic number: 64
					If (Abs(player.getVelX()) >= 64 And player.isAfterSpinDash) Then
						Self.velocity = player.getVelX()
						
						player.isAfterSpinDash = False
					EndIf
				Else
					Self.velocity -= MOVE_POWER
				EndIf
				
				rollLogic()
				
				Local preX:= player.getFootPositionX()
				Local preY:= player.getFootPositionY()
				
				player.setFootPositionX(Self.posX)
				player.setFootPositionY(Self.collisionRect.y0)
				
				player.checkWithObject(preX, preY, player.getFootPositionX(), player.getFootPositionY())
				
				If (player.outOfControl And player.outOfControlObject = Self) Then
					If (Not Key.repeated(Key.gUp | Key.B_LOOK)) Then
						If (player.getAnimationId() = PlayerObject.ANI_JUMP) Then
							If (Not spinCheck()) Then
								If (Abs(Self.velocity) = 0) Then
									If (Not Key.repeated(Key.gDown)) Then
										player.setAnimationId(PlayerObject.ANI_STAND)
									EndIf
								ElseIf (Abs(Self.velocity) < PlayerObject.SPEED_LIMIT_LEVEL_1) Then
									player.setAnimationId(PlayerObject.ANI_RUN_1)
								ElseIf (Abs(Self.velocity) < PlayerObject.SPEED_LIMIT_LEVEL_2) Then
									player.setAnimationId(PlayerObject.ANI_RUN_2)
								Else
									player.setAnimationId(PlayerObject.ANI_RUN_3)
								EndIf
							EndIf
						ElseIf (Abs(Self.velocity) = 0) Then
							If (Not Key.repeated(Key.gDown)) Then
								player.setAnimationId(PlayerObject.ANI_STAND)
							EndIf
						ElseIf (Abs(Self.velocity) < PlayerObject.SPEED_LIMIT_LEVEL_1) Then
							player.setAnimationId(PlayerObject.ANI_RUN_1)
						ElseIf (Abs(Self.velocity) < PlayerObject.SPEED_LIMIT_LEVEL_2) Then
							player.setAnimationId(PlayerObject.ANI_RUN_2)
						Else
							player.setAnimationId(PlayerObject.ANI_RUN_3)
						EndIf
					EndIf
					
					If (Key.press(Key.gUp | Key.B_HIGH_JUMP) And Not Key.repeated(Key.gDown)) Then
						player.outOfControl = False
						
						Self.controlling = False
						
						If (player.getAnimationId() = PlayerObject.ANI_JUMP) Then
							player.doJumpV()
						Else
							player.doJump()
						EndIf
						
						If (Self.velocity > 0) Then
							player.setVelX(VELOCITY_X)
						ElseIf (Self.velocity < 0) Then
							player.setVelX(-VELOCITY_X)
						Else
							player.setVelX(0)
						EndIf
					EndIf
				EndIf
				
				If (Self.posX = Self.posOriginalX Or Self.posY = Self.posOriginalY) Then
					player.lookUpCheck()
				EndIf
			EndIf
			
			' Magic number: 308
			Self.velocity -= 308
			
			rollLogic()
		End
		
		Method releaseWhileBeHurt:Bool()
			Self.noCollisionCount = 0
			
			Return True
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.noCollisionCount <= 0) Then
				player.beStop(0, direction, Self)
				
				If (direction = DIRECTION_DOWN) Then
					player.setOutOfControl(Self)
					
					Self.controlling = True
				EndIf
				
				Self.isActive = True
			EndIf
		End
		
		Method rollLogic:Void()
			Local vx:= (((DIRECTION[Self.iLeft][0] * Self.velocity) * 20) / 100)
			Local vy:= (((DIRECTION[Self.iLeft][1] * Self.velocity) * 20) / 100)
			
			If (vx > 0) Then
				If (vx > ROLL_MAX_VELOCITY) Then
					vx = ROLL_MAX_VELOCITY
				EndIf
			ElseIf (vx < 0 And vx < PLATFORM_OFFSET_Y) Then
				vx = PLATFORM_OFFSET_Y
			EndIf
			
			If (vy > 0) Then
				If (vy > ROLL_MAX_VELOCITY) Then
					vy = ROLL_MAX_VELOCITY
				EndIf
			ElseIf (vy < 0 And vy < PLATFORM_OFFSET_Y) Then
				vy = PLATFORM_OFFSET_Y
			EndIf
			
			Self.posX += vx
			Self.posY += vy
			
			If (Self.velocity > 0) Then
				If (DIRECTION[Self.iLeft][0] > 0) Then
					If (Self.posX > Self.posOriginalX + Self.moveDistance__rollisland) Then
						Self.posX = Self.posOriginalX + Self.moveDistance__rollisland
					EndIf
				ElseIf (DIRECTION[Self.iLeft][0] < 0 And Self.posX < Self.posOriginalX - Self.moveDistance__rollisland) Then
					Self.posX = Self.posOriginalX - Self.moveDistance__rollisland
				EndIf
				
				If (DIRECTION[Self.iLeft][1] > 0) Then
					If (Self.posY > Self.posOriginalY + Self.moveDistance__rollisland) Then
						Self.posY = Self.posOriginalY + Self.moveDistance__rollisland
					EndIf
				ElseIf (DIRECTION[Self.iLeft][1] < 0 And Self.posY < Self.posOriginalY - Self.moveDistance__rollisland) Then
					Self.posY = Self.posOriginalY - Self.moveDistance__rollisland
				EndIf
				
				Self.drawer.setActionId(1)
			Else
				If (DIRECTION[Self.iLeft][0] > 0) Then
					If (Self.posX < Self.posOriginalX) Then
						Self.posX = Self.posOriginalX
					EndIf
				ElseIf (DIRECTION[Self.iLeft][0] < 0 And Self.posX > Self.posOriginalX) Then
					Self.posX = Self.posOriginalX
				EndIf
				
				If (DIRECTION[Self.iLeft][1] > 0) Then
					If (Self.posY < Self.posOriginalY) Then
						Self.posY = Self.posOriginalY
					EndIf
				ElseIf (DIRECTION[Self.iLeft][1] < 0 And Self.posY > Self.posOriginalY) Then
					Self.posY = Self.posOriginalY
				EndIf
				
				Self.drawer.setActionId(1)
			EndIf
			
			Self.drawer.setActionId(1)
			
			If (Self.posX = Self.posOriginalX And Self.posY = Self.posOriginalY) Then
				Self.velocity = 0
				
				If (Self.isActive) Then
					soundInstance.stopLoopSe()
					
					Self.isActive = False
				EndIf
			EndIf
			
			If (Self.velocity = 0) Then
				Self.drawer.setActionId(0)
			EndIf
			
			If (Not (Self.posX = Self.posOriginalX And Self.posY = Self.posOriginalY)) Then
				Self.frame += 1
				
				If (Abs(Self.velocity) <> 0) Then
					' Magic number: 160
					If (Abs(Self.velocity) < 160) Then
						If ((Self.frame Mod 7) = 0) Then
							soundInstance.playSe(SoundSystem.SE_212)
						EndIf
					' Magic number: 1020
					ElseIf (Abs(Self.velocity) < 1020) Then
						If ((Self.frame Mod 4) = 0) Then
							soundInstance.playSe(SoundSystem.SE_213)
						EndIf
					ElseIf ((Self.frame Mod 2) = 0) Then
						soundInstance.playSe(SoundSystem.SE_214)
					EndIf
				EndIf
			EndIf
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End