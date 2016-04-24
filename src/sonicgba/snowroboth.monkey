Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.bulletobject
	Import sonicgba.enemeyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SnowRobotH Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1152
		Const COLLISION_HEIGHT:Int = 1600
		
		Const ALERT_WIDTH:Int = 2
		Const ALERT_HEIGHT:Int = 100
		
		Const SPEED:Int = 128
		Const WAIT_MAX:Int = 20
		
		Const LAUNCH_SPEED:Int = -1280
		
		Const STATE_PATROL:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Fields:
		Field IsFire:Bool
		Field dir:Bool
		
		Field state:Int
		Field alert_state:Int
		
		Field startPosX:Int
		Field endPosX:Int
		
		Field wait_cn:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.dir = False
			Self.IsFire = False
			
			If (snowrobotAnimation = Null) Then
				snowrobotAnimation = New Animation("/animation/yukimal")
			EndIf
			
			Self.drawer = snowrobotAnimation.getDrawer(0, True, 0)
			Self.startPosX = Self.posX
			Self.endPosX = Self.posX + Self.mWidth
			Self.posY = getGroundY(Self.posX, Self.posY)
			Self.dir = False
			Self.state = STATE_PATROL
			Self.wait_cn = 0
			Self.IsFire = False
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(snowrobotAnimation)
			
			snowrobotAnimation = Null
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
						
						If (Not (Self.alert_state <> IN_ALERT_RANGE Or Self.posX = Self.startPosX Or Self.posX = Self.endPosX)) Then
							Self.state = STATE_ATTACK
							
							Self.drawer.setActionId(1)
							Self.drawer.setLoop(False)
							
							Self.IsFire = True
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.wait_cn < WAIT_MAX) Then
							Self.wait_cn += 1
							
							If (Self.drawer.checkEnd() And Self.IsFire) Then
								Self.IsFire = False
								
								BulletObject.addBullet(BulletObject.BULLET_ROBOT, Self.posX, (Self.posY - COLLISION_HEIGHT), 0, LAUNCH_SPEED)
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
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), (y - COLLISION_HEIGHT), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End