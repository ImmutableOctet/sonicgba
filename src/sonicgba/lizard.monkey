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
Class Lizard Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1728
		Const COLLISION_HEIGHT:Int = 2048
		
		Const STATE_MOVE:Int = 0
		Const STATE_ATTACK:Int = 1
		
		' Global variable(s):
		Global lizardAnimation:Animation
		
		' Fields:
		Field IsFired:Bool
		
		Field state:Int
		Field enemyid:Int
		
		Field velocity:Int
		Field fire_start_speed:Int
		
		Field limitLeftX:Int
		Field limitRightX:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 150
			Self.fire_start_speed = 1200
			
			Self.mWidth = 4096
			
			Self.limitLeftX = Self.posX
			Self.limitRightX = (Self.posX + Self.mWidth)
			
			Self.posX += (Self.mWidth / 2) ' Shr 1
			
			If (lizardAnimation = Null) Then
				lizardAnimation = New Animation("/animation/lizard")
			EndIf
			
			Self.drawer = lizardAnimation.getDrawer(0, True, 0)
			
			Self.IsFired = False
			
			Self.enemyid = id
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(lizardAnimation)
			
			lizardAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_MOVE
						Local pos:= (Self.limitLeftX + (Self.mWidth / 2)) / 150 ' Shr 1
						
						If (Self.velocity > 0) Then
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(TRANS_MIRROR)
							Self.drawer.setLoop(True)
							
							If (Self.posX >= Self.limitRightX) Then
								Self.posX = Self.limitRightX
								Self.velocity = -Self.velocity
								Self.IsFired = False
							EndIf
							
							If ((Self.posX / 150) = pos And Not Self.IsFired) Then
								Self.state = STATE_ATTACK
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(TRANS_MIRROR)
								Self.drawer.setLoop(False)
								
								Self.IsFired = True
							EndIf
						Else
							Self.posX += Self.velocity
							
							Self.drawer.setActionId(0)
							Self.drawer.setTrans(0)
							Self.drawer.setLoop(True)
							
							If (Self.posX <= Self.limitLeftX) Then
								Self.posX = Self.limitLeftX
								
								Self.velocity = -Self.velocity
								
								Self.IsFired = False
							EndIf
							
							If ((Self.posX / 150) = pos And Not Self.IsFired) Then
								Self.state = STATE_ATTACK
								
								Self.drawer.setActionId(1)
								Self.drawer.setTrans(0)
								Self.drawer.setLoop(False)
								
								Self.IsFired = True
							EndIf
						EndIf
						
						Self.posY = getGroundY(Self.posX, Self.posY)
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
					Case STATE_ATTACK
						If (Self.drawer.checkEnd()) Then
							BulletObject.addBullet(Self.enemyid, Self.posX, Self.posY - (COLLISION_HEIGHT / 2), 0, -Self.fire_start_speed)
							
							Self.state = STATE_MOVE
							
							If (Self.velocity > 0) Then
								Self.drawer.setActionId(0)
								Self.drawer.setTrans(TRANS_MIRROR)
							Else
								Self.drawer.setActionId(0)
								Self.drawer.setTrans(0)
							EndIf
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