Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.enemyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Motor Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2048
		Const COLLISION_HEIGHT:Int = 2048
		
		Const ALERT_WIDTH:Int = 88
		Const ALERT_HEIGHT:Int = 20
		Const ALERT_RANGE:Int = 6144
		
		Const STATE_MOVE:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Global variable(s):
		Global motorAnimation:Animation
		
		' Fields:
		Field state:Int
		Field alert_state:Int
		
		Field attck_cnt:Int
		
		Field velocity:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field release_cnt:Int
		Field release_cnt_max:Int
		
		Field starty:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Magic number: 192
			Self.velocity = 192
			
			Self.attck_cnt = 0
			
			Self.release_cnt = 0
			Self.release_cnt_max = 5
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			Self.starty = Self.posY
			
			Self.posX = (Self.limitLeftX + (Self.mWidth / 2)) ' Shr 1
			
			If (motorAnimation = Null) Then
				motorAnimation = New Animation("/animation/motor")
			EndIf
			
			Self.drawer = motorAnimation.getDrawer(1, True, TRANS_NONE)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(motorAnimation)
			
			motorAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), ALERT_WIDTH, ALERT_HEIGHT)
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_MOVE
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_MIRROR)
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(TRANS_NONE)
							EndIf
						Else
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_NONE)
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(TRANS_NONE)
							EndIf
						EndIf
						
						If (Self.release_cnt < Self.release_cnt_max) Then
							Self.release_cnt += 1
						EndIf
						
						If (Self.alert_state = IN_ALERT_RANGE And Self.release_cnt = Self.release_cnt_max And Self.posX <> Self.limitLeftX And Self.posX <> Self.limitRightX) Then
							If (Self.posX < player.getCheckPositionX()) Then
								If (Self.drawer.getTransId() = TRANS_MIRROR And Self.drawer.getActionId() = 0) Then
									Self.state = STATE_ATTACK
									
									Self.attck_cnt = 0
								EndIf
							ElseIf (Self.posX > player.getCheckPositionX() And Self.drawer.getTransId() = TRANS_NONE And Self.drawer.getActionId() = 0) Then
								Self.state = STATE_ATTACK
								
								Self.attck_cnt = 0
							EndIf
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.drawer.getTransId() = TRANS_MIRROR And Self.drawer.getActionId() = 0) Then
							If (Self.velocity < 0) Then
								Self.velocity = -Self.velocity
							EndIf
							
							' Magic number: 5
							If (Self.attck_cnt < 5) Then
								Self.attck_cnt += 1
							Else
								Self.posX += (Self.velocity * 3)
								
								If (Self.posX >= Self.limitRightX) Then
									Self.posX = Self.limitRightX
								EndIf
							EndIf
						EndIf
						
						If (Self.drawer.getTransId() = TRANS_NONE And Self.drawer.getActionId() = 0) Then
							If (Self.velocity > 0) Then
								Self.velocity = -Self.velocity
							EndIf
							
							' Magic number: 5
							If (Self.attck_cnt < 5) Then
								Self.attck_cnt += 1
							Else
								Self.posX += (Self.velocity * 3)
								
								If (Self.posX <= Self.limitLeftX) Then
									Self.posX = Self.limitLeftX
								EndIf
							EndIf
						EndIf
						
						If (Self.posX = Self.limitLeftX Or Self.posX = Self.limitRightX) Then
							Self.state = 0
							Self.release_cnt = 0
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
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
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End