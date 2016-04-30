Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.bulletobject
	Import sonicgba.enemyobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Bat Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1792
		Const COLLISION_HEIGHT:Int = 1792
		
		Const ALERT_RANGE:Int = 7168
		
		Const FLY_TOP:Int = 1536
		
		Const STATE_FLY:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Global variable(s):
		Global batAnimation:Animation
		
		' Fields:
		Field state:Int
		Field alert_state:Int
		
		Field emenyid:Int
		
		Field attack_cnt:Int
		Field attack_cnt_max:Int
		
		Field limitTopY:Int
		Field limitBottomY:Int
		Field limitLeftX:Int
		Field limitRightX:Int
		
		Field velocity:Int
		
		Field offsety:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 128
			Self.offsety = 384
			
			Self.attack_cnt_max = 30
			
			Self.posY -= 1024
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			Self.limitTopY = (Self.posY - FLY_TOP)
			Self.limitBottomY = Self.posY
			
			If (batAnimation = Null) Then
				batAnimation = New Animation("/animation/bat")
			EndIf
			
			Self.drawer = batAnimation.getDrawer(0, True, 0)
			
			Self.emenyid = id
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(batAnimation)
			
			batAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Self.alert_state = checkPlayerInEnemyAlertRange((Self.posX Shr 6), (Self.posY Shr 6), ALERT_RANGE)
				
				Select (Self.state)
					Case STATE_FLY
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
							EndIf
						Else
							Self.posX += Self.velocity
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
							EndIf
						EndIf
						
						If (Self.offsety > 0) Then
							Self.posY += Self.offsety
							
							If (Self.posY >= Self.limitBottomY) Then
								Self.posY = Self.limitBottomY
								
								Self.offsety = -Self.offsety
							EndIf
						Else
							Self.posY += Self.offsety
							
							If (Self.posY <= Self.limitTopY) Then
								Self.posY = Self.limitTopY
								
								Self.offsety = -Self.offsety
							EndIf
						EndIf
						
						If (Abs(player.getCheckPositionX() - Self.posX) < COLLISION_WIDTH And Self.alert_state = IN_ALERT_RANGE) Then
							If (Self.attack_cnt >= Self.attack_cnt_max) Then
								Self.state = STATE_ATTACK
							Else
								Self.attack_cnt += 1
							EndIf
						EndIf
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						Self.drawer.setActionId(1)
						Self.drawer.setLoop(False)
						
						If (Self.drawer.checkEnd()) Then
							BulletObject.addBullet(Self.emenyid, Self.posX, Self.posY, 0, 0)
							
							Self.state = STATE_FLY
							
							Self.drawer.setActionId(0)
							Self.drawer.setLoop(True)
							
							Self.attack_cnt = 0
						EndIf
						
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
			' Magic number: 320
			Self.collisionRect.setRect((x - (COLLISION_WIDTH / 2)), (y - (COLLISION_HEIGHT / 2)) - 320, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End