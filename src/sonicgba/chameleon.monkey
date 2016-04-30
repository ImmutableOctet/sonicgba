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

' Classes:
Class Chameleon Extends EnemyObject
	Private
		' Constant variable(s):
		Const STATE_MOVE:Int = 0
		Const STATE_TURN:Int = 1
		Const STATE_ATTACK:Int = 2
		
		Const attack_cnt_max:Int = 10
		
		' Global variable(s):
		Global chameleonAnimation:Animation
		
		' Fields:
		Field state:Int
		Field alert_state:Int
		
		Field velocity:Int
		
		Field ALERT_RANGE:Int
		
		Field COLLISION_WIDTH:Int
		Field COLLISION_HEIGHT:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field attack_cnt:Int
		Field collision_offset_x:Int
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(chameleonAnimation)
			
			chameleonAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((x - (Self.COLLISION_WIDTH / 2)) + Self.collision_offset_x, y - Self.COLLISION_HEIGHT, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT)
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.COLLISION_WIDTH = 2880
			Self.COLLISION_HEIGHT = 1408
			
			Self.ALERT_RANGE = 5760
			
			Self.velocity = 128
			
			Self.collision_offset_x = 1280
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			If (chameleonAnimation = Null) Then
				chameleonAnimation = New Animation("/animation/chameleon")
			EndIf
			
			Self.drawer = chameleonAnimation.getDrawer(0, True, 0)
			
			Self.attack_cnt = 0
			Self.collision_offset_x = 0
		End
	Private
		' Methods:
		
		' Extensions:
		Method IsFacePlayer:Bool(player:PlayerObject)
			If ((Self.posX <= player.getFootPositionX() Or Self.velocity >= 0) And (Self.posX >= player.getFootPositionX() Or Self.velocity <= 0)) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method IsFacePlayer:Bool()
			Return IsFacePlayer(player)
		End
	Public
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), (Self.ALERT_RANGE Shr 6), (Self.limitLeftX Shr 6), (Self.limitRightX Shr 6), (Self.COLLISION_WIDTH Shr 6))
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_MOVE
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_MIRROR)
							Self.drawer.setLoop(True)
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(TRANS_MIRROR)
								Self.drawer.setLoop(False)
								
								Self.state = STATE_TURN
							EndIf
						Else
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_NONE)
							Self.drawer.setLoop(True)
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(False)
								
								Self.state = STATE_TURN
							EndIf
						EndIf
						
						If (Self.attack_cnt < attack_cnt_max) Then
							Self.attack_cnt += STATE_TURN
						EndIf
						
						If (Self.alert_state = STATE_MOVE And Self.attack_cnt = attack_cnt_max And IsFacePlayer()) Then
							Self.state = STATE_ATTACK
							
							If (Self.posX < player.getCheckPositionX()) Then
								Self.drawer.setActionId(STATE_ATTACK)
								Self.drawer.setTrans(TRANS_MIRROR)
								Self.drawer.setLoop(False)
							Else
								Self.drawer.setActionId(STATE_ATTACK)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(False)
							EndIf
							
							Self.attack_cnt = 0
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_TURN
						If (Self.drawer.checkEnd()) Then
							Self.state = STATE_MOVE
						EndIf
						
						Self.attack_cnt = 0
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.drawer.getCurrentFrame() = 3) Then
							' Magic numbers: 640, -640
							If (Self.posX < player.getCheckPositionX()) Then
								Self.collision_offset_x = 640
							Else
								Self.collision_offset_x = -640
							EndIf
							
							' Magic number: 3840
							Self.COLLISION_WIDTH = 3840
							
							refreshCollisionRect(Self.posX, Self.posY)
						Else
							' Magic number: 2880
							Self.COLLISION_WIDTH = 2880
							
							Self.collision_offset_x = 0
							
							refreshCollisionRect(Self.posX, Self.posY)
						EndIf
						
						If (Self.drawer.checkEnd()) Then
							Self.state = STATE_MOVE
							
							Self.collision_offset_x = 0
							
							' Magic number: 2880
							Self.COLLISION_WIDTH = 2880
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						refreshCollisionRect(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
			EndIf
		End
End