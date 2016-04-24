Strict

Public

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Heriko Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1280
		Const COLLISION_HEIGHT:Int = 1856
		
		Const ALERT_WIDTH:Int = 64
		Const ALERT_HEIGHT:Int = 128
		
		Const SPEED:Int = 128
		Const BULLET_SPEED:Int = 512
		
		Const DISTANCE:Int = 2560
		Const HEIGHT_OFFSET:Int = 4
		
		Const STATE_PATROL:Int = 0
		Const STATE_ATTACK:Int = 1
		
		Const WAIT_MAX:Int = 30
		
		' Global variable(s):
		Global herikoAnimation:Animation
		
		' Fields:
		Field IsFire:Bool
		Field dir:Bool
		
		Field state:Int
		Field alert_state:Int
		
		Field startPosX:Int
		Field endPosX:Int
		
		Field wait_cn:Int
		Field journey:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, (y - HEIGHT_OFFSET), left, top, width, height)
			
			Self.dir = False
			Self.IsFire = False
			
			If (herikoAnimation = Null) Then
				herikoAnimation = New Animation("/animation/heriko")
			EndIf
			
			Self.drawer = herikoAnimation.getDrawer(0, True, 0)
			
			Self.startPosX = Self.posX
			Self.endPosX = Self.posX + Self.mWidth
			
			Self.state = STATE_PATROL
			
			Self.wait_cn = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(herikoAnimation)
			
			herikoAnimation = Null
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
							
							Self.drawer.setActionId(STATE_ATTACK)
							Self.drawer.setLoop(False)
							
							Self.IsFire = True
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.wait_cn < WAIT_MAX) Then
							Self.wait_cn += 1
							
							If (Self.drawer.checkEnd() And Self.IsFire) Then
								Self.IsFire = False
								
								BulletObject.addBullet(BulletObject.BULLET_MIRA, Self.posX, Self.posY, 0, BULLET_SPEED) ' BulletObject.BULLET_HERIKO
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
			' Magic number: 1664
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - 1664, COLLISION_WIDTH, COLLISION_HEIGHT) ' (COLLISION_HEIGHT / 2)
		End
End