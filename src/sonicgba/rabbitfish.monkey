Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.sonicdef
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	Import sonicgba.playersonic
	Import sonicgba.playertails
	Import sonicgba.playerknuckles
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class RabbitFish Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1536
		Const COLLISION_HEIGHT:Int = 1536
		
		Const ALERT_RANGE:Int = 80
		
		Const STATE_MOVE:Int = 0
		Const STATE_DEFEND:Int = 1
		
		' Global variable(s):
		Global fishAnimation:Animation
		
		' Fields:
		Field state:Int
		Field alert_state:Int
		
		Field velocity:Int
		
		Field starty:Int
		
		Field defend_cnt:Int
		Field defend_frame:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field move_cnt:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			' Magic number: 8
			Super.New(id, x, (y - 8), left, top, width, height) ' (ALERT_RANGE / 10)
			
			Self.velocity = 140
			
			Self.move_cnt = 0
			
			Self.defend_cnt = 0
			Self.defend_frame = 16
			
			' Magic number: 4096
			Self.mWidth = 4096
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			Self.posX += (Self.mWidth / 2) ' Shr 1
			
			Self.starty = Self.posY
			
			If (fishAnimation = Null) Then
				fishAnimation = New Animation("/animation/rabbit_fish")
			EndIf
			
			Self.drawer = fishAnimation.getDrawer(0, True, 0)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(fishAnimation)
			
			fishAnimation = Null
		End
		
		' Methods:
		
		' Extensions:
		Method IsFacetoPlayer:Bool(player:PlayerObject)
			If ((Self.posX <= player.getFootPositionX() Or Self.velocity >= 0) And (Self.posX >= player.getFootPositionX() Or Self.velocity <= 0)) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method IsFacetoPlayer:Bool()
			IsFacetoPlayer(player)
		End
		
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.dead Or p <> player) Then
				Return
			EndIf
			
			If (Self.state <> STATE_MOVE) Then
				p.beHurt()
			ElseIf ((p.getCharacterID() = CHARACTER_SONIC) And (p.getCharacterAnimationID() = PlayerSonic.SONIC_ANI_JUMP Or p.getCharacterAnimationID() = PlayerSonic.SONIC_ANI_SPIN_1 Or p.getCharacterAnimationID() = PlayerSonic.SONIC_ANI_SPIN_2)) Then
				p.doAttackPose(Self, direction)
				
				beAttack()
			ElseIf ((p.getCharacterID() = CHARACTER_KNUCKLES) And (p.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_JUMP Or p.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_SPIN_1 Or p.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_SPIN_2)) Then
				p.doAttackPose(Self, direction)
				
				beAttack()
			ElseIf ((p.getCharacterID() = CHARACTER_TAILS) And (p.getCharacterAnimationID() = PlayerTails.TAILS_ANI_JUMP_BODY Or p.getCharacterAnimationID() = PlayerTails.TAILS_ANI_JUMP_TAIL Or p.getCharacterAnimationID() = PlayerTails.TAILS_ANI_SPIN)) Then
				p.doAttackPose(Self, direction)
				
				beAttack()
			Else
				' This behavior may change in the future.
				p.beHurt()
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			' This behavior may change in the future:
			If (Self.dead Or p <> player Or Self.state <> STATE_MOVE) Then
				Return
			EndIf
			
			If (p.isAttackingEnemy()) Then
				p.doAttackPose(Self, direction)
				
				beAttack()
				
				Return
			EndIf
			
			p.beHurt()
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_MOVE
						Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), ALERT_RANGE, ALERT_RANGE)
						
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							Self.move_cnt += Abs(Self.velocity)
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_MIRROR)
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
							EndIf
						Else
							Self.posX += Self.velocity
							Self.move_cnt += Abs(Self.velocity)
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_NONE)
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
							EndIf
						EndIf
						
						' Magic number: 5120
						If (Self.alert_state = IN_ALERT_RANGE And IsFacetoPlayer() And Self.move_cnt >= 5120) Then
							Self.state = STATE_DEFEND
							
							Self.drawer.setActionId(1)
							
							Self.defend_cnt = 0
							Self.move_cnt = 0
							
							If (Self.velocity > 0) Then
								Self.drawer.setTrans(TRANS_MIRROR)
							Else
								Self.drawer.setTrans(TRANS_NONE)
							EndIf
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_DEFEND
						If (Self.defend_cnt < Self.defend_frame) Then
							Self.defend_cnt += 1
						Else
							Self.state = STATE_MOVE
							
							Self.drawer.setActionId(0)
							
							If (Self.velocity > 0) Then
								Self.drawer.setTrans(TRANS_MIRROR)
							Else
								Self.drawer.setTrans(TRANS_NONE)
							EndIf
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End