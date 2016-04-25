Strict

Public

' Imports:
Private
	'Import gameengine.def
	
	Import lib.animation
	Import lib.constutil
	
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	Import sonicgba.playertails
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Mira Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_HEIGHT:Int = 1920
		
		Const ATTACK_WIDTH:Int = 2048
		Const DEFENCE_WIDTH:Int = 1920
		
		Const ALERT_WIDTH:Int = 128
		Const ALERT_HEIGHT:Int = 64
		
		Const DISTANCE:Int = 2560
		
		Const SPEED:Int = 128
		Const BULLET_SPEED:Int = 480
		
		Const WAIT_MAX:Int = 30
		
		Const STATE_PATROL:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Global variable(s):
		Global miraAnimation:Animation
		
		' Fields:
		Field IsFire:Bool
		Field dir:Bool
		
		Field state:Int
		Field alert_state:Int
		
		Field startPosX:Int
		Field endPosX:Int
		
		Field journey:Int
		
		Field trans:Int
		
		Field wait_cn:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.dir = False
			Self.IsFire = False
			
			If (miraAnimation = Null) Then
				miraAnimation = New Animation("/animation/mira")
			EndIf
			
			Self.drawer = miraAnimation.getDrawer(0, True, 0)
			
			Self.startPosX = Self.posX
			Self.endPosX = (Self.posX + Self.mWidth)
			
			Self.dir = False
			
			Self.state = STATE_PATROL
			
			Self.trans = TRANS_NONE
			
			Self.wait_cn = 0
			
			' Magic number: 960
			Self.posY -= 960 ' (BULLET_SPEED * 2)
		End
	Private
		' Methods:
		
		' Extensions:
		Method checkEnemyFace:Int(player:PlayerObject)
			If ((Self.posX - player.getFootPositionX()) >= 0) Then
				Return TRANS_NONE
			EndIf
			
			Return TRANS_MIRROR
		End
		
		Method checkEnemyFace:Int()
			Return checkEnemyFace(player)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(miraAnimation)
			
			miraAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), ALERT_WIDTH, ALERT_HEIGHT)
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_PATROL
						If (Self.dir) Then
							Self.posX -= SPEED
							Self.journey += SPEED
							
							If (Self.posX <= Self.startPosX) Then
								Self.dir = False
								
								Self.posX = Self.startPosX
							EndIf
						Else
							Self.posX += SPEED
							Self.journey += SPEED
							
							If (Self.posX >= Self.endPosX) Then
								Self.dir = True
								
								Self.posX = Self.endPosX
							EndIf
						EndIf
						
						If (Self.journey >= DISTANCE And Self.alert_state = IN_ALERT_RANGE) Then
							Self.state = STATE_ATTACK
							
							Self.journey = 0
							
							Self.trans = checkEnemyFace() ' player
							
							Self.drawer.setActionId(1)
							Self.drawer.setTrans(Self.trans)
							Self.drawer.setLoop(False)
							
							Self.IsFire = True
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.wait_cn < WAIT_MAX) Then
							Self.wait_cn += 1
							
							If (Self.drawer.checkEnd() And Self.IsFire) Then
								Self.IsFire = False
								
								BulletObject.addBullet(BulletObject.BULLET_MIRA, (Self.posX + PickValue((Self.trans = 0), -SPEED, SPEED)), Self.posY, PickValue((Self.trans = TRANS_NONE), -BULLET_SPEED, BULLET_SPEED), 0)
							EndIf
						Else
							Self.wait_cn = 0
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_NONE)
							Self.drawer.setLoop(True)
							
							Self.state = STATE_PATROL
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
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.dead) Then
				Select (Self.state)
					Case STATE_PATROL
						' This behavior may change in the future:
						If (p = player) Then
							p.beHurt()
						EndIf
					Case STATE_ATTACK
						' This may also need a check against the global 'player' object:
						If (p.isAttackingEnemy()) Then
							p.doAttackPose(Self, direction)
							
							beAttack()
						Else
							p.beHurt()
						EndIf
				End Select
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (Not Self.dead) Then
				Select (Self.state)
					Case STATE_PATROL, STATE_ATTACK
						If (player.isAttackingEnemy()) Then
							player.doAttackPose(Self, direction)
							
							beAttack()
						ElseIf ((player.getCharacterID() = CHARACTER_TAILS) And (player.getCharacterAnimationID() >= PlayerTails.TAILS_ANI_FLY_1 And player.getCharacterAnimationID() <= PlayerTails.TAILS_ANI_FLY_3)) Then
							beAttack()
						Else
							player.beHurt()
						EndIf
				End Select
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Select (Self.state)
				Case STATE_PATROL
					Self.collisionRect.setRect(x - (DEFENCE_WIDTH / 2), y - (COLLISION_HEIGHT / 2), DEFENCE_WIDTH, COLLISION_HEIGHT)
				Case STATE_ATTACK
					Self.collisionRect.setRect(x - (ATTACK_WIDTH / 2), y - (COLLISION_HEIGHT / 2), ATTACK_WIDTH, COLLISION_HEIGHT)
			End Select
		End
End