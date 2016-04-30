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
Class Fish Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2560
		Const COLLISION_HEIGHT:Int = 1024
		
		Const ALERT_RANGE:Int = 60
		
		Const FISH_XY_MAX_SPEED:Int = 432
		
		Const STATE_READY:Int = 0
		Const STATE_BREAK:Int = 1
		Const STATE_ATTACK:Int = 2
		
		' Global variable(s):
		Global fishAnimation:Animation
		
		' Fields:
		Field state:Int
		Field alert_state:Int
		
		Field velX:Int
		Field velY:Int
		
		Field iTrans:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (fishAnimation = Null) Then
				fishAnimation = New Animation("/animation/ice_fish")
			EndIf
			
			Self.drawer = fishAnimation.getDrawer(0, True, 0)
			
			Self.posX = (x Shl 6)
			Self.posY = (y Shl 6)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(fishAnimation)
			
			fishAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Self.alert_state = checkPlayerInEnemyAlertRange(Self.posX Shr 6, Self.posY Shr 6, ALERT_RANGE, ALERT_RANGE)
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_READY
						If (Self.alert_state = STATE_READY) Then
							Self.state = STATE_BREAK
							
							Self.drawer.setActionId(STATE_BREAK)
							Self.drawer.setLoop(False)
							Self.drawer.setTrans(0)
							
							Self.iTrans = checkEnemyFace()
						EndIf
					Case STATE_BREAK
						If (Self.drawer.checkEnd()) Then
							Self.state = STATE_ATTACK
							
							Self.drawer.setActionId(2)
							Self.drawer.setLoop(True)
							Self.drawer.setTrans(Self.iTrans)
							
							Self.velX = ((-(Self.posX - player.getCheckPositionX())) / 8)
							Self.velY = ((-(Self.posY - player.getCheckPositionY())) / 8)
							
							If (Self.velX > FISH_XY_MAX_SPEED) Then
								Self.velX = FISH_XY_MAX_SPEED
							ElseIf (Self.velX < -FISH_XY_MAX_SPEED) Then
								Self.velX = -FISH_XY_MAX_SPEED
							EndIf
							
							If (Self.velY > FISH_XY_MAX_SPEED) Then
								Self.velY = FISH_XY_MAX_SPEED
							ElseIf (Self.velY < -FISH_XY_MAX_SPEED) Then
								Self.velY = -FISH_XY_MAX_SPEED
							EndIf
							
							If (Abs(Self.velY) > Abs(Self.velX)) Then
								If (Self.velY <= 0 And Self.velY < 0) Then
									Self.velY = -Abs(Self.velX)
								Else
									Self.velY = Abs(Self.velX)
								EndIf
							EndIf
						EndIf
					Case STATE_ATTACK
						Self.posX += Self.velX
						Self.posY += Self.velY
				End Select
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
			
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer, Self.posX, Self.posY)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
	Private
		' Methods:
		Method checkEnemyFace:Int()
			If (Self.posX - player.getFootPositionX() >= 0) Then
				Return TRANS_NONE
			EndIf
			
			Return TRANS_MIRROR
		End
End