Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	
	'Import sonicgba.penguinbullet
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Penguin Extends EnemyObject
	Private
		' Constant variable(s):
		Const ALERT_WIDTH:Int = 60
		Const ALERT_HEIGHT:Int = 60
		
		Const ATTACK_SPEED:Int = 640
		
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1600
		
		Const SPEED:Int = 128
		
		Const STATE_PATROL:Int = 0
		Const STATE_ATTACK:Int = 1
		
		Const WAIT_MAX:Int = 10
		
		' Global variable(s):
		Global penguinAnimation:Animation
		
		' Fields:
		Field IsFire:Bool
		Field dir:Bool
		
		Field state:Int
		
		Field alert_state:Int
		
		Field startPosX:Int
		Field endPosX:Int
		
		Field iTrans:Int
		
		Field release_cnt:Int
		Field release_cnt_max:Int
		
		Field wait_cn:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.dir = False
			Self.IsFire = False
			
			Self.release_cnt = 0
			Self.release_cnt_max = WAIT_MAX
			
			If (penguinAnimation = Null) Then
				penguinAnimation = New Animation("/animation/pen")
			EndIf
			
			Self.drawer = penguinAnimation.getDrawer(0, True, 2)
			
			Self.startPosX = Self.posX
			Self.endPosX = Self.posX + Self.mWidth
			
			Self.posY = getGroundY(Self.posX, Self.posY)
			
			Self.dir = False
			Self.IsFire = False
			
			Self.state = STATE_PATROL
			
			Self.wait_cn = 0
			Self.release_cnt = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(penguinAnimation)
			
			penguinAnimation = Null
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
								
								Self.drawer.setTrans(TRANS_MIRROR)
							EndIf
						Else
							Self.posX += SPEED
							
							If (Self.posX >= Self.endPosX) Then
								Self.dir = True
								
								Self.posX = Self.endPosX
								
								Self.drawer.setTrans(TRANS_NONE)
							EndIf
						EndIf
						
						If (Self.release_cnt < Self.release_cnt_max) Then
							Self.release_cnt += 1
						EndIf
						
						If (Self.alert_state = STATE_PATROL And Self.posX <> Self.startPosX And Self.posX <> Self.endPosX And Self.release_cnt = Self.release_cnt_max) Then
							Self.state = STATE_ATTACK
							
							Self.iTrans = Self.drawer.getTransId()
							
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
								
								BulletObject.addBullet(BulletObject.BULLET_PENGUIN, Self.posX, Self.posY, PickValue((Self.iTrans = 0), -ATTACK_SPEED, ATTACK_SPEED), 0)
							EndIf
						Else
							Self.wait_cn = 0
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(Self.iTrans)
							Self.drawer.setLoop(True)
							
							Self.state = STATE_PATROL
							
							Self.release_cnt = 0
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
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End