Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.spring

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.constutil
	Import lib.soundsystem
	
	Import sonicgba.collisionrect
	Import sonicgba.movecalculator
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	Import sonicgba.spring
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SpringIsland Extends GimmickObject
	Private
		' Constructor(s):
		Const COLLISION_WIDTH:Int = 1920
		Const COLLISION_HEIGHT:Int = 2688
		
		Const COLLSION_OFFSET_Y:Int = 1856
		
		' Global variable(s):
		Global SPRING_POWER:Int = Spring.SPRING_POWER[0]
		
		Global animation:Animation
		
		' Fields:
		Field debugCollisionHeight:Int
		Field initPos:Int
		Field offset_distance:Int
		
		Field isH:Bool
		
		Field drawer:AnimationDrawer
		Field moveCal:MoveCalculator
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.debugCollisionHeight = 0
			
			If (animation = Null) Then
				If (StageManager.getCurrentZoneId() = 4 Or StageManager.getCurrentZoneId() = 6) Then
					animation = New Animation("/animation/spring_island" + StageManager.getCurrentZoneId())
				Else
					animation = New Animation("/animation/spring_island")
				EndIf
			EndIf
			
			Self.drawer = animation.getDrawer(0, False, 0)
			
			Local moveDirection:Bool
			
			If (Self.mWidth >= Self.mHeight) Then
				Self.isH = True
				
				If (Self.iLeft = 0) Then
					moveDirection = False
				Else
					moveDirection = True
				EndIf
			Else
				Self.isH = False
				
				If (Self.iTop = 0) Then
					moveDirection = False
				Else
					moveDirection = True
				EndIf
			EndIf
			
			Self.initPos = PickValue(Self.isH, Self.posX, Self.posY)
			
			' Magic numbers: 69632, 35328, 3200
			If (Self.posX = 69632 And Self.posY = 35328) Then
				Self.debugCollisionHeight = 3200
			EndIf
			
			Self.moveCal = New MoveCalculator(Self.initPos, PickValue(Self.isH, Self.mWidth, Self.mHeight), moveDirection)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(animation)
			
			animation = Null
		End
		
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - RollPlatformSpeedC.COLLISION_HEIGHT, (y + COLLSION_OFFSET_Y) - COLLISION_HEIGHT, COLLISION_WIDTH, PickValue((Self.debugCollisionHeight = 0), COLLISION_HEIGHT, Self.debugCollisionHeight))
		End
		
		Method draw:Void(g:MFGraphics)
			' I'm not entirely sure why this is in 'draw', but whatever.
			' This behavior may change in the future. (May be moved to 'logic')
			SPRING_POWER = PickValue(player.isInWater, Spring.SPRING_INWATER_POWER[0], Spring.SPRING_POWER[0])
			
			drawInMap(g, Self.drawer)
			
			If (Self.drawer.checkEnd() And Self.drawer.getActionId() = 1) Then
				Self.drawer.setActionId(0)
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (direction = DIRECTION_LEFT) Then
				player.beStop(0, direction, Self)
			ElseIf (direction = DIRECTION_RIGHT) Then
				player.beStop(0, direction, Self)
			ElseIf (direction = DIRECTION_NONE) Then
				If (player.animationID = PlayerObject.ANI_ROTATE_JUMP) Then
					Return
				EndIf
				
				If (player.velX < 0) Then
					player.beStop(0, DIRECTION_LEFT, Self)
				ElseIf (player.velX > 0) Then
					player.beStop(0, DIRECTION_RIGHT, Self)
				EndIf
			ElseIf (direction = DIRECTION_DOWN) Then
				player.beSpring(SPRING_POWER, direction)
				
				Self.drawer.setActionId(1)
				
				soundInstance.playSe(SoundSystem.SE_148)
			ElseIf (direction = DIRECTION_UP) Then
				player.beStop(0, direction, Self)
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (PlayerObject.getCharacterID() = CHARACTER_AMY) Then
				If (player.myAnimationID >= PlayerAmy.AMY_ANI_DASH_3 And player.myAnimationID <= PlayerAmy.AMY_ANI_DASH_4) Then
					Return
				EndIf
				
				If (direction = DIRECTION_NONE Or direction = DIRECTION_DOWN) Then
					player.beSpring((SPRING_POWER * 13) / 10, DIRECTION_DOWN)
					
					' Optimization potential; dynamic cast.
					Local amy:= PlayerAmy(player)
					
					If (amy <> Null) Then
						amy.skipBeStop = True
					EndIf
					
					Self.drawer.setActionId(1)
					
					soundInstance.playSe(SoundSystem.SE_148)
				EndIf
			EndIf
		End
		
		Method logic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.isH) Then
				If (Self.iLeft = 0) Then
					Self.posX = Self.moveCal.getPosition()
				Else
					Self.offset_distance = (Self.initPos - Self.moveCal.getPosition())
					Self.posX = (Self.initPos + Self.offset_distance)
				EndIf
			ElseIf (Self.iTop = 0) Then
				Self.posY = Self.moveCal.getPosition()
			Else
				Self.offset_distance = (Self.initPos - Self.moveCal.getPosition())
				Self.posY = (Self.initPos + Self.offset_distance)
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End