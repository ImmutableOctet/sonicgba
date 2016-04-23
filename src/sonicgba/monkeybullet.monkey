Strict

Publ;ic

' Imports:
Private
	Import lib.animation
	
	Import sonicgba.bulletobject
	Import sonicgba.playerobject
	
	Import sonicgba.monkey
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class MonkeyBullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_BOOM_WIDTH:Int = 1600
		Const COLLISION_BOOM_HEIGHT:Int = 1600
		
		Const COLLISION_WIDTH:Int = 640
		Const COLLISION_HEIGHT:Int = 832
		
		Const STATE_DROP:Int = 0
		Const STATE_BOOM:Int = 1
		
		Const boom_cnt_max:Int = 10
		Const drop_cnt_max:Int = 2
		
		' Fields:
		Field isboom:Bool
		Field isbooming:Bool
		
		Field boom_cnt:Int
		Field drop_cnt:Int
		
		Field state:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY, True)
			
			If (monkeybulletAnimation = Null) Then
				monkeybulletAnimation = New Animation("/animation/monkey_bullet")
			EndIf
			
			Self.drawer = monkeybulletAnimation.getDrawer(0, True, TRANS_NONE)
			
			Self.isboom = False
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player And player.canBeHurt()) Then
				p.beHurt()
				
				Self.state = STATE_BOOM
				
				Self.boom_cnt = boom_cnt_max
			EndIf
		End
		
		Method bulletLogic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Select (Self.state)
				Case STATE_DROP
					Self.isbooming = False
					
					Self.drawer.setActionId(0)
					Self.drawer.setLoop(True)
					
					Self.boom_cnt = 0
					
					Self.posX += Self.velX
					Self.velY += GRAVITY
					Self.posY += Self.velY
					
					If (Self.posY + (COLLISION_HEIGHT / 2) >= getGroundY(Self.posX, Self.posY)) Then
						Self.posY = (getGroundY(Self.posX, Self.posY) - (COLLISION_HEIGHT / 2))
						
						' Magic numbers: -450, -300
						Select (Self.drop_cnt)
							Case (drop_cnt_max - 2)
								Self.velY = -450
								
								Self.drop_cnt = 1
							Case (drop_cnt_max - 1)
								Self.velY = -300
								
								Self.drop_cnt = drop_cnt_max
							Case drop_cnt_max
								Self.state = STATE_BOOM
						End Select
					EndIf
					
					checkWithPlayer(preX, preY, Self.posX, Self.posY)
				Case STATE_BOOM
					If (Self.boom_cnt < boom_cnt_max) Then
						Self.boom_cnt += 1
					Else
						Self.drawer.setActionId(1)
						Self.drawer.setLoop(False)
						
						Self.isbooming = True
					EndIf
					
					If (Self.drawer.checkEnd() And Self.isbooming) Then
						Self.isboom = True
					EndIf
					
					checkWithPlayer(preX, preY, Self.posX, Self.posY)
			End Select
		End
		
		Method chkDestroy:Bool()
			If (Self.isbooming) Then
				Return Self.isboom
			EndIf
			
			Return Super.chkDestroy()
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.isboom) Then
				drawInMap(g, Self.drawer)
			EndIf
			
			Self.collisionRect.draw(g, camera)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.isbooming) Then
				Self.collisionRect.setRect(x - (COLLISION_BOOM_WIDTH / 2), y - (COLLISION_BOOM_HEIGHT / 2), COLLISION_BOOM_WIDTH, COLLISION_BOOM_HEIGHT)
			Else
				Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
End