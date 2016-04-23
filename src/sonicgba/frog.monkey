Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.enemyobject
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.sonicdebug
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Frog Extends EnemyObject
	Private
		' Constant variable(s):
		Const ALERT_WIDTH:Int = 55
		Const ALERT_HEIGHT:Int = 160
		
		Const ALERT_RANGE:Int = 3072
		
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1280
		
		Const COLLISION_WIDTH_JUMP:Int = 896
		Const COLLISION_HEIGHT_JUMP:Int = 768
		
		Const FROG_JUMP_START_SPEED:Int = -1050
		
		Const DRIP_ACC:Int = 147 ' (GRAVITY - 25) ' Global
		
		Const STATE_WAIT:Int = 0
		Const STATE_JUMP:Int = 1
		Const STATE_COAXAR:Int = 2
		
		' Global variable(s):
		Global frogAnimation:Animation
		
		' Fields:
		Field IsFirstCoaxar:Bool
		Field beRight:Bool
		
		Field state:Int
		
		Field alert_state:Int
		Field attack_state:Int
		
		Field velocity:Int
		
		Field frog_time:Int
		Field interval:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field starty:Int
		
		Field velY:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 75
			
			Self.IsFirstCoaxar = False
			
			Self.frog_time = 0
			Self.interval = 1
			
			Self.beRight = False
			
			' Magic number: 5120
			Self.mWidth = 5120
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			If (frogAnimation = Null) Then
				frogAnimation = New Animation("/animation/frog")
			EndIf
			
			Self.drawer = frogAnimation.getDrawer(0, True, 0)
			
			Self.starty = Self.posY
			
			Self.posX = (Self.posX + (Self.mWidth / 2)) + PlayerObject.DETECT_HEIGHT ' (COLLISION_WIDTH * 2) ' Shr 1
			Self.posY = getGroundY(Self.posX, Self.posY)
			
			Self.IsFirstCoaxar = False
			Self.beRight = False
		End
	Private
		' Methods:
		Method jumpInit:Void()
			Self.state = STATE_JUMP
			
			If (Self.drawer.getTransId() = STATE_COAXAR) Then
				Self.drawer.setActionId(1)
				Self.drawer.setTrans(TRANS_MIRROR)
				Self.drawer.setLoop(False)
				
				Self.beRight = False
			ElseIf (Self.drawer.getTransId() = 0) Then
				Self.drawer.setActionId(1)
				Self.drawer.setTrans(TRANS_NONE)
				Self.drawer.setLoop(False)
				
				Self.beRight = True
			EndIf
			
			Self.velY = FROG_JUMP_START_SPEED
		End
		
		Method jumpChk:Bool()
			If (Self.alert_state = STATE_WAIT) Then
				Return True
			EndIf
			
			' Magic numbers: 3520, 7040, 10560
			If (Self.posX < player.getCheckPositionX()) Then
				If (player.getVelX() < 0 And player.getVelX() > -PlayerObject.SONIC_ATTACK_LEVEL_1_V0 And player.getFootPositionX() - Self.posX < 3520 And player.getFootPositionX() - Self.posX > 0) Then
					Return True
				EndIf
				
				If (player.getVelX() <= -PlayerObject.SONIC_ATTACK_LEVEL_1_V0 And player.getVelX() > -PlayerObject.SONIC_ATTACK_LEVEL_2_V0 And player.getFootPositionX() - Self.posX < 7040 And player.getFootPositionX() - Self.posX >= 3520) Then
					Return True
				EndIf
				
				If (player.getVelX() > -PlayerObject.SONIC_ATTACK_LEVEL_2_V0 Or player.getFootPositionX() - Self.posX >= 10560 Or player.getFootPositionX() - Self.posX < 7040) Then
					Return False
				EndIf
				
				Return True
			ElseIf (player.getVelX() > 0 And player.getVelX() < PlayerObject.SONIC_ATTACK_LEVEL_1_V0 And Self.posX - player.getFootPositionX() < 3520 And Self.posX - player.getFootPositionX() > 0) Then
				Return True
			Else
				If (player.getVelX() >= PlayerObject.SONIC_ATTACK_LEVEL_1_V0 And player.getVelX() < PlayerObject.SONIC_ATTACK_LEVEL_2_V0 And Self.posX - player.getFootPositionX() < 7040 And Self.posX - player.getFootPositionX() >= 3520) Then
					Return True
				EndIf
				
				If (player.getVelX() < PlayerObject.SONIC_ATTACK_LEVEL_2_V0 Or Self.posX - player.getFootPositionX() >= 10560 Or Self.posX - player.getFootPositionX() < 7040) Then
					Return False
				EndIf
				
				Return True
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(frogAnimation)
			
			frogAnimation = Null
		End
		
		' Methods:
		Method doInitWhileInCamera:Void()
			Self.posX = (Self.limitLeftX + (Self.mWidth / 2)) + PlayerObject.DETECT_HEIGHT ' Shr 1
			Self.posY = getGroundY(Self.posX, Self.posY)
			
			Self.IsFirstCoaxar = False
			
			refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
			
			Self.beRight = False
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				' Magic number: 16
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), ALERT_WIDTH, ALERT_HEIGHT, (Self.limitLeftX Shr 6), (Self.limitRightX Shr 6), 16)
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_WAIT
						If (Self.posX < player.getCheckPositionX()) Then
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_MIRROR)
							Self.drawer.setLoop(True)
						Else
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_NONE)
							Self.drawer.setLoop(True)
						EndIf
						
						If (isInCamera() And Not Self.IsFirstCoaxar) Then
							Self.frog_time = PlayerObject.getTimeCount()
							
							Self.IsFirstCoaxar = True
						EndIf
						
						If (Self.IsFirstCoaxar) Then
							Self.interval = ((PlayerObject.getTimeCount() - Self.frog_time) + STATE_JUMP) Mod 5000
							
							If (Self.interval <= 100) Then
								Self.state = STATE_COAXAR
								
								If (Self.drawer.getTransId() = STATE_COAXAR) Then
									Self.drawer.setActionId(TRANS_MIRROR)
									Self.drawer.setTrans(TRANS_MIRROR)
									Self.drawer.setLoop(False)
								ElseIf (Self.drawer.getTransId() = 0) Then
									Self.drawer.setActionId(TRANS_MIRROR)
									Self.drawer.setTrans(TRANS_NONE)
									Self.drawer.setLoop(False)
								EndIf
							EndIf
						EndIf
						
						If (jumpChk()) Then
							If (Self.posX < player.getCheckPositionX()) Then
								If (Self.velocity < 0) Then
									Self.velocity = -Self.velocity
								EndIf
							ElseIf (Self.velocity > 0) Then
								Self.velocity = -Self.velocity
							EndIf
							
							If (Self.posX + (Self.velocity * 10) > Self.limitLeftX And Self.posX + (Self.velocity * 10) < Self.limitLeftX + Self.mWidth) Then
								jumpInit()
							EndIf
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_JUMP
						Self.posX += Self.velocity
						
						If (Self.posY + Self.velY > getGroundY(Self.posX, Self.posY)) Then
							Self.posY = getGroundY(Self.posX, Self.posY)
							
							Self.state = STATE_WAIT
							
							If (Self.posX < player.getCheckPositionX()) Then
								Self.drawer.setActionId(TRANS_MIRROR)
								Self.drawer.setTrans(TRANS_MIRROR)
								Self.drawer.setLoop(False)
							Else
								Self.drawer.setActionId(TRANS_MIRROR)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(False)
							EndIf
						Else
							Self.velY += DRIP_ACC
							Self.posY += Self.velY
						EndIf
						
						If (Self.drawer.checkEnd()) Then
							Self.state = STATE_WAIT
							
							If (Self.posX < player.getCheckPositionX()) Then
								Self.drawer.setActionId(TRANS_MIRROR)
								Self.drawer.setTrans(TRANS_MIRROR)
								Self.drawer.setLoop(False)
							Else
								Self.drawer.setActionId(TRANS_MIRROR)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(False)
							EndIf
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_COAXAR
						If (Self.drawer.checkEnd()) Then
							Self.state = STATE_WAIT
							
							If (Self.drawer.getTransId() = STATE_COAXAR) Then
								Self.drawer.setActionId(0)
								Self.drawer.setTrans(TRANS_MIRROR)
								Self.drawer.setLoop(True)
							ElseIf (Self.drawer.getTransId() = 0) Then
								Self.drawer.setActionId(0)
								Self.drawer.setTrans(TRANS_NONE)
								Self.drawer.setLoop(True)
							EndIf
						EndIf
						
						If (jumpChk()) Then
							If (Self.posX < player.getCheckPositionX()) Then
								If (Self.velocity < 0) Then
									Self.velocity = -Self.velocity
								EndIf
								
							ElseIf (Self.velocity > 0) Then
								Self.velocity = -Self.velocity
							EndIf
							
							jumpInit()
						EndIf
				End Select
			EndIf
			
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
				drawCollisionRect(g)
				
				If (SonicDebug.showCollisionRect) Then
					drawAlertRangeLine(g, Self.alert_state, (Self.posX Shr 6), (Self.posY Shr 6), MapManager.getCamera())
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.state = STATE_JUMP) Then
				Self.collisionRect.setRect(x - (COLLISION_WIDTH_JUMP / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH_JUMP, COLLISION_HEIGHT_JUMP)
			Else
				Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
End