Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Cement Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1152
		Const COLLISION_HEIGHT:Int = 1152
		
		Const DEFENCE_WIDTH:Int = 2560
		Const DEFENCE_HEIGHT:Int = 2560
		
		Const ALERT_RANGE:Int = 30
		
		Const PATROL_FRAME:Int = 136
		Const WAIT_FRAME:Int = 32
		
		Const SPEED:Int = 60
		
		Const STATE_PATROL:Int = 0
		Const STATE_DEFENCE:Int = 1
		
		' Global variable(s):
		Global cementAnimation:Animation
		
		' Fields:
		Field state:Int
		Field alert_state:Int
		
		Field startPosX:Int
		Field endPosX:Int
		
		Field patrol_cn:Int
		Field wait_cn:Int
		
		Field dir:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.dir = False
			
			If (cementAnimation = Null) Then
				cementAnimation = New Animation("/animation/kura")
			EndIf
			
			Self.drawer = cementAnimation.getDrawer(0, True, 0)
			
			Self.startPosX = Self.posX
			Self.endPosX = (Self.posX + Self.mWidth)
			
			Self.dir = False
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(cementAnimation)
			
			cementAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_PATROL
						If (Self.dir) Then
							Self.posX -= SPEED
							
							If (Self.posX <= Self.startPosX) Then
								Self.dir = False
								
								Self.posX = Self.startPosX
							EndIf
						Else
							Self.posX += SPEED
							
							If (Self.posX >= Self.endPosX) Then
								Self.dir = True
								
								Self.posX = Self.endPosX
							EndIf
						EndIf
						
						If (Self.patrol_cn >= PATROL_FRAME) Then
							Self.patrol_cn = 0
							Self.wait_cn = 0
							
							Self.state = STATE_DEFENCE
							
							Self.drawer.setActionId(1)
							Self.drawer.setLoop(True)
						Else
							Self.patrol_cn += 1
						EndIf
					Case STATE_DEFENCE
						If (Self.wait_cn >= WAIT_FRAME) Then
							Self.patrol_cn = 0
							Self.wait_cn = 0
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_NONE)
							Self.drawer.setLoop(True)
							
							Self.state = STATE_PATROL
						Else
							Self.wait_cn += 1
						EndIf
				End Select
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.dead) Then
				Select (Self.state)
					Case STATE_PATROL
						' This behavior may change in the future:
						If (player.isAttackingEnemy()) Then
							player.doAttackPose(Self, direction)
							
							beAttack()
						Else
							player.beHurt()
						EndIf
					Case STATE_DEFENCE
						' This behavior may change in the future:
						If (p = player) Then
							p.beHurt()
						EndIf
				End Select
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (Not Self.dead) Then
				Select (Self.state)
					Case STATE_PATROL
						beAttack()
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Select (Self.state)
				Case STATE_PATROL
					Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
				Case STATE_DEFENCE
					Self.collisionRect.setRect(x - (DEFENCE_WIDTH / 2), y - (DEFENCE_HEIGHT / 2), DEFENCE_WIDTH, DEFENCE_HEIGHT)
			End Select
		End
End