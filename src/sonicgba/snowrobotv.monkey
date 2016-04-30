Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	'Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.bulletobject
	Import sonicgba.collisionrect
	Import sonicgba.enemyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SnowRobotV Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1600
		Const COLLISION_HEIGHT:Int = 1152
		
		Const ALERT_WIDTH:Int = 200
		Const ALERT_HEIGHT:Int = 10
		
		Const SPEED:Int = 128
		Const LAUNCH_SPEED:Int = 960
		
		Const WAIT_MAX:Int = 30
		
		Const STATE_PATROL:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Fields:
		Field IsFire:Bool
		Field dir:Bool
		
		Field state:Int
		Field alert_state:Int
		
		Field iTrans:Int
		
		Field startPosY:Int
		Field endPosY:Int
		
		Field iLeft:Int
		
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
			
			Self.iLeft = left
			
			Self.iTrans = PickValue((Self.iLeft = 0), TRANS_ROT90, TRANS_ROT270)
			
			Self.drawer = snowrobotAnimation.getDrawer(0, True, Self.iTrans)
			
			Self.startPosY = (Self.posY)
			Self.endPosY = (Self.posY + Self.mHeight)
			
			Self.state = STATE_PATROL
			
			Self.wait_cn = 0
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
							Self.posY -= SPEED
							
							If (Self.posY <= Self.startPosY) Then
								Self.dir = False
								
								Self.posY = Self.startPosY
							EndIf
						Else
							Self.posY += SPEED
							
							If (Self.posY >= Self.endPosY) Then
								Self.dir = True
								
								Self.posY = Self.endPosY
							EndIf
						EndIf
						
						If (Not (Self.alert_state <> IN_ALERT_RANGE Or Self.posY = Self.startPosY Or Self.posY = Self.endPosY)) Then
							Self.state = STATE_ATTACK
							
							Self.drawer.setActionId(1)
							Self.drawer.setTrans(Self.iTrans)
							Self.drawer.setLoop(False)
							
							Self.IsFire = True
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.wait_cn < WAIT_MAX) Then
							Self.wait_cn += 1
							
							If (Self.drawer.checkEnd() And Self.IsFire) Then
								Self.IsFire = False
								
								Local xOffset:= PickValue((Self.iLeft = 0), COLLISION_WIDTH, -COLLISION_WIDTH)
								
								Local x:= (Self.posX + xOffset)
								Local y:= Self.posY
								
								Local launchSpeed:= PickValue((Self.iLeft = 0), LAUNCH_SPEED, -LAUNCH_SPEED)
								
								BulletObject.addBullet(BulletObject.BULLET_ROBOT, x, y, launchSpeed, 0)
							EndIf
						Else
							Self.wait_cn = 0
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(Self.iTrans)
							Self.drawer.setLoop(True)
							
							Self.state = STATE_PATROL
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(PickValue((Self.iLeft = 0), 0, -COLLISION_WIDTH) + x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
			EndIf
		End
End