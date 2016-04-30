Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes
Class Mole Extends EnemyObject
	Private
		' Constant variable(s):
		Const STATE_WAIT:Int = 0
		Const STATE_UP:Int = 1
		
		Const HEIGHT_OFFSET:Int = 2
		
		' Global variable(s):
		Global COLLISION_HEIGHT:Int = 1600
		Global COLLISION_WIDTH:Int = 1024
		
		Global moleAnimation:Animation
		
		' Fields:
		Field state:Int
		
		Field wait_cnt:Int
		Field wait_cnt_max:Int
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(moleAnimation)
			
			moleAnimation = Null
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y + HEIGHT_OFFSET, left, top, width, height)
			
			Self.wait_cnt_max = 16
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (moleAnimation = Null) Then
				moleAnimation = New Animation("/animation/mole")
			EndIf
			
			Self.drawer = moleAnimation.getDrawer(0, True, 0)
			
			Self.wait_cnt = 0
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.dead Or p <> player) Then
				Return
			EndIf
			
			If (p.isAttackingEnemy()) Then
				If (Self.state = STATE_UP) Then
					beAttack()
					
					p.doAttackPose(Self, direction)
				EndIf
			ElseIf (Self.state = STATE_UP) Then
				p.beHurt()
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			' This behavior may change in the future:
			If (Not Self.dead And p = player And Self.state = STATE_UP) Then
				beAttack()
				
				p.doAttackPose(Self, direction)
			EndIf
		End
		
		Method logic:Void()
			If (Self.dead) Then
				Self.drawer.setActionId(0)
				
				Return
			EndIf
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Select (Self.state)
				Case STATE_WAIT
					If (Self.wait_cnt < Self.wait_cnt_max) Then
						Self.wait_cnt += 1
					ElseIf (Self.posX < player.getCheckPositionX()) Then
						Self.drawer.setActionId(1)
						Self.drawer.setTrans(TRANS_MIRROR) ' 2
						Self.drawer.setLoop(False)
						
						Self.state = STATE_UP
					Else
						Self.drawer.setActionId(1)
						Self.drawer.setTrans(TRANS_NONE) ' 0
						Self.drawer.setLoop(False)
						
						Self.state = STATE_UP
					EndIf
					
					checkWithPlayer(preX, preY, Self.posX, Self.posY)
				Case STATE_UP
					If (Self.drawer.checkEnd()) Then
						Self.drawer.setActionId(0)
						Self.drawer.setLoop(True)
						
						Self.state = 0
						Self.wait_cnt = 0
					EndIf
					
					checkWithPlayer(preX, preY, Self.posX, Self.posY)
			End Select
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End