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
Class Crab Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2688
		Const COLLISION_HEIGHT:Int = 1792
		
		Const STATE_WALK:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Global variable(s):
		Global crabAnimation:Animation
		
		' Fields:
		Field state:Int
		Field emenyid:Int
		
		Field velocity:Int
		
		Field fire_cnt:Int
		Field fire_start_speed:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(crabAnimation)
			
			crabAnimation = Null
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Magic number: 192
			Self.velocity = 192
			
			' Magic number: 300
			Self.fire_start_speed = 300
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			If (crabAnimation = Null) Then
				crabAnimation = New Animation("/animation/crab")
			EndIf
			
			Self.drawer = crabAnimation.getDrawer(0, True, 0)
			
			Self.emenyid = id
		End
	Public
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_WALK
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								
								Self.velocity = -Self.velocity
								
								Self.state = STATE_ATTACK
								
								Self.drawer.setActionId(1)
								Self.drawer.setLoop(False)
								
								Self.fire_cnt = 0
							EndIf
						Else
							Self.posX += Self.velocity
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
								
								Self.state = STATE_ATTACK
								
								Self.drawer.setActionId(1)
								Self.drawer.setLoop(False)
								
								Self.fire_cnt = 0
							EndIf
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.fire_cnt = 0) Then
							BulletObject.addBullet(Self.emenyid, Self.posX - (COLLISION_WIDTH / 2), Self.posY - COLLISION_HEIGHT, -Self.fire_start_speed, -Self.fire_start_speed)
							BulletObject.addBullet(Self.emenyid, Self.posX + (COLLISION_WIDTH / 2), Self.posY - COLLISION_HEIGHT, Self.fire_start_speed, -Self.fire_start_speed)
						EndIf
						
						Self.fire_cnt += 1
						
						If (Self.drawer.checkEnd() Or Self.fire_cnt > 2) Then
							Self.state = STATE_WALK
							
							Self.drawer.setActionId(0)
							Self.drawer.setLoop(True)
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.drawer)
				
				drawCollisionRect(g)
			EndIf
		End
End