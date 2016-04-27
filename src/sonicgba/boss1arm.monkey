Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.soundsystem
	
	Import sonicgba.enemyobject
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	
	Import sonicgba.boss1
	
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss1Arm Extends EnemyObject
	Private
		' Global variable(s):
		Global ArmAni:Animation = Null
		
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2176
		Const COLLISION_HEIGHT:Int = 2176
		
		Const DEGREE_MIN:Int = Boss1.DEGREE_MIN
		Const DEGREE_MAX:Int = Boss1.DEGREE_MAX
		
		Const DEGREE_MIN_2:Int = 23680
		Const DEGREE_MAX_2:Int = 10880
		
		' States:
		Const STATE_WAIT:Int = Boss1.STATE_WAIT
		Const STATE_ATTACK_1:Int = Boss1.STATE_ATTACK_1
		Const STATE_READY:Int = Boss1.STATE_READY
		Const STATE_ATTACK_2:Int = Boss1.STATE_ATTACK_2
		Const STATE_ATTACK_3:Int = Boss1.STATE_ATTACK_3
		Const STATE_BROKEN:Int = Boss1.STATE_BROKEN
		
		' Fields:
		Field IsBreaking:Bool
		Field IsTurn:Bool
		
		Field armdrawer:AnimationDrawer
		Field boomdrawer:AnimationDrawer
		Field hammerdrawer:AnimationDrawer
		
		Field Step2CenterX:Int
		Field Step2CenterY:Int
		
		Field state:Int
		
		Field ball_size:Int
		Field con_size:Int
		
		Field degree:Int
		Field dg_plus:Int
		Field drop_cnt:Int
		
		Field offsetY:Int
		Field plus:Int
		Field pos:Int[][]
		Field prepos:Int[][]
		
		Field velX:Int[]
		Field velY:Int
	Protected
		' Functions:
		Function generatePositionArray:Int[]()
			Local pos:= New Int[6][]
			
			For Local i:= 0 Until pos.Length
				pos[i] = New Int[2]
			Next
			
			Return pos
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.offsetY = 2112
			Self.con_size = 1152
			Self.ball_size = 1536 ' PlayerObject.HEIGHT
			
			Self.dg_plus = 320 ' (5 Shl 6)
			Self.degree = 0
			
			Self.plus = 
			Self.posX -= Self.iLeft * 8
			Self.posY -= Self.iTop * 8
			Self.degree = 10560
			
			If (ArmAni = Null) Then
				ArmAni = New Animation("/animation/boss1_arm")
			EndIf
			
			Self.armdrawer = ArmAni.getDrawer(0, True, 0)
			
			If (BoomAni = Null) Then
				BoomAni = New Animation("/animation/boom")
			EndIf
			
			Self.boomdrawer = BoomAni.getDrawer(0, True, 0)
			
			Self.hammerdrawer = New Animation("/animation/boss1_hammer").getDrawer(0, False, 0)
			
			Self.pos = generatePositionArray()
			Self.prepos = generatePositionArray()
			
			Self.IsBreaking = False
			
			Self.velX = New Int[6]
			
			Self.velX[0] = -450
			Self.velX[1] = -300
			Self.velX[2] = -150
			Self.velX[3] = 150
			Self.velX[4] = 300
			Self.velX[5] = 450
			
			Self.velY = -1200
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(ArmAni)
			Animation.closeAnimation(BoomAni)
			
			ArmAni = Null
			BoomAni = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Not Self.dead And p = player And Self.state <> STATE_BROKEN) Then
				p.beHurt()
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method getArmState:Int()
			Return Self.state
		End
		
		Method getArmAngel:Int()
			Return Self.degree
		End
		
		Method setArmAngel:Void(degree:Int)
			Self.degree = degree
		End
		
		Method getTurnState:Bool()
			Return Self.IsTurn
		End
		
		Method setTurnState:Void(turn_state:Bool)
			Self.IsTurn = turn_state
		End
		
		Method setArmState:Void(arm_state:Int)
			Self.state = arm_state
		End
		
		Method setDegreeSpeed:Void(speed:Int)
			Self.dg_plus = speed
		End
		
		Method logic:Void()
			#Rem
				If (Not Self.dead) Then
					' Nothing so far.
				EndIf
			#End
		End
		
		Public Method logic:Int[](posx:Int, posy:Int, boss_state:Int, boss_velocity:Int)
			If (Self.dead) Then
				Return Self.pos[0]
			EndIf
			
			Local preX:= Self.pos[5][0] ' (Self.pos.Length - 1)
			Local preY:= Self.pos[5][1]
			
			Int i
			
			Select (boss_state)
				Case STATE_ATTACK_1
					If (Self.plus > 0) Then
						Self.degree += Self.plus * Self.dg_plus
						
						If (Self.degree >= DEGREE_MIN_2) Then
							Self.degree = DEGREE_MIN_2
							
							Self.plus = -Self.plus
							
							MapManager.setShake(8)
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_145)
						EndIf
					Else
						Self.degree += (Self.plus * Self.dg_plus)
						
						If (Self.degree <= DEGREE_MIN) Then
							Self.degree = DEGREE_MIN
							
							Self.plus = -Self.plus
							
							MapManager.setShake(8)
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_145)
						EndIf
					EndIf
					
					For Local i:= 0 Until (Self.pos.Length - 1)
						Self.pos[i][0] = posx - (((Self.con_size * i) * MyAPI.dCos(Self.degree Shr 6)) / 100)
						Self.pos[i][1] = (((Self.con_size * i) * MyAPI.dSin(Self.degree Shr 6)) / 100) + posy
					Next
					
					Self.pos[5][0] = posx - ((((Self.con_size * 4) + Self.ball_size) * MyAPI.dCos(Self.degree Shr 6)) / 100)
					Self.pos[5][1] = ((((Self.con_size * 4) + Self.ball_size) * MyAPI.dSin(Self.degree Shr 6)) / 100) + posy
					
					checkWithPlayer(preX, preY, Self.pos[5][0], Self.pos[5][1])
				Case STATE_ATTACK_2
					Self.dg_plus = 1137 ' (17 Shl 6)
					
					If (boss_velocity > 0) Then
						If (Self.plus > 0) Then
							If (Self.degree <= DEGREE_MIN) Then
								Self.degree = DEGREE_MIN
								
								Self.plus = -Self.plus
							Else
								Self.degree += (Self.plus * Self.dg_plus)
							EndIf
						ElseIf (Self.degree + (Self.plus * Self.dg_plus) <= DEGREE_MIN_2) Then
							Self.degree = DEGREE_MIN_2
							
							Self.state = STATE_ATTACK_3
							
							Self.IsTurn = False
						Else
							Self.degree += (Self.plus * Self.dg_plus)
						EndIf
					ElseIf (Self.plus > 0) Then
						If (Self.degree + (Self.plus * Self.dg_plus) >= DEGREE_MIN) Then
							Self.degree = DEGREE_MIN
							
							Self.state = STATE_ATTACK_3
							
							Self.IsTurn = False
						Else
							Self.degree += (Self.plus * Self.dg_plus)
						EndIf
					ElseIf (Self.degree >= DEGREE_MIN_2) Then
						Self.degree = DEGREE_MIN_2
						
						Self.plus = -Self.plus
					Else
						Self.degree += (Self.plus * Self.dg_plus)
					EndIf
					
					Self.pos[5][0] = Self.Step2CenterX
					Self.pos[5][1] = Self.Step2CenterY
					
					For Local i:= 1 Until Self.pos.Length
						Local position:= Self.pos[5 - i] ' (Self.pos.Length - 1) - i
						
						position[0] = (Self.Step2CenterX + ((((Self.con_size * (i - 1)) + Self.ball_size) * MyAPI.dCos(Self.degree Shr 6)) / 100))
						position[1] = (Self.Step2CenterY - ((((Self.con_size * (i - 1)) + Self.ball_size) * MyAPI.dSin(Self.degree Shr 6)) / 100))
					Next
					
					checkWithPlayer(preX, preY, Self.pos[5][0], Self.pos[5][1])
				Case STATE_ATTACK_3
					Self.dg_plus = 914 ' (14 Shl 6)
					
					If (boss_velocity > 0) Then
						If (Self.plus > 0) Then
							If (Self.degree >= DEGREE_MIN_2) Then
								Self.degree = DEGREE_MIN_2
								
								Self.plus = -Self.plus
							Else
								Self.degree += (Self.plus * Self.dg_plus)
							EndIf
						ElseIf (Self.degree + (Self.plus * Self.dg_plus) <= DEGREE_MIN) Then
							Self.degree = DEGREE_MIN
							
							Self.state = STATE_ATTACK_2
							
							Self.IsTurn = False
						Else
							Self.degree += (Self.plus * Self.dg_plus)
						EndIf
					ElseIf (Self.plus > 0) Then
						If (Self.degree + (Self.plus * Self.dg_plus) >= DEGREE_MIN_2) Then
							Self.degree = DEGREE_MIN_2
							
							Self.state = STATE_ATTACK_2
							
							Self.IsTurn = False
						Else
							Self.degree += (Self.plus * Self.dg_plus)
						EndIf
					ElseIf (Self.degree <= DEGREE_MIN) Then
						Self.degree = DEGREE_MIN
						
						Self.plus = -Self.plus
					Else
						Self.degree += (Self.plus * Self.dg_plus)
					EndIf
					
					For Local i:= 0 Until (Self.pos.Length - 1)
						Local position:= Self.pos[i]
						
						position[0] = (posx - (((Self.con_size * i) * MyAPI.dCos(Self.degree Shr 6)) / 100))
						position[1] = ((((Self.con_size * i) * MyAPI.dSin(Self.degree Shr 6)) / 100) + posy)
					Next
					
					Self.pos[5][0] = (posx - ((((Self.con_size * 4) + Self.ball_size) * MyAPI.dCos(Self.degree Shr 6)) / 100))
					Self.pos[5][1] = (((((Self.con_size * 4) + Self.ball_size) * MyAPI.dSin(Self.degree Shr 6)) / 100) + posy)
					
					If (Self.state = STATE_ATTACK_2) Then
						Self.Step2CenterX = Self.pos[5][0]
						Self.Step2CenterY = Self.pos[5][1]
						
						If (Self.degree = DEGREE_MIN_2) Then
							Self.degree -= 23040 ' (360 Shl 6)
						EndIf
						
						If (Self.degree = DEGREE_MIN) Then
							Self.degree += 23040 ' (360 Shl 6)
						EndIf
						
						MapManager.setShake(8)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_145)
					EndIf
					
					checkWithPlayer(preX, preY, Self.pos[5][0], Self.pos[5][1])
				Case STATE_BROKEN
					Self.state = STATE_BROKEN
					
					If (Not Self.IsBreaking) Then
						If (Self.pos[5][0] < Self.pos[0][0]) Then
							For Local i:= 0 Until Self.velX.Length
								Self.velX[i] = -Self.velX[i]
							Next
						EndIf
						
						Self.IsBreaking = True
					EndIf
					
					For Local i:= 0 Until Self.velX.Length
						Local tmpcol:Int
						
						If (i <> 5) Then
							tmpcol = (Self.con_size / 2) ' Shr 1
						Else
							tmpcol = (Self.offsetY / 2) ' Shr 1
						EndIf
						
						Local position:= Self.pos[i]
						
						Local groundY:= getGroundY(position[0], position[1])
						
						If ((position[1] + tmpcol) >= groundY) Then
							position[1] = (groundY - tmpcol)
							
							Select (Self.drop_cnt)
								Case 0
									Self.velY = -900
									
									Self.drop_cnt = 1
								Case 1
									Self.velY = -600
									
									Self.drop_cnt = 2
								Default
									' Nothing so far.
							End Select
						EndIf
						
						Self.prepos[i][0] = position[0]
						Self.prepos[i][1] = position[1]
						
						position[0] += Self.velX[i]
						
						Self.velY += (GRAVITY Shr 3) ' / 8
						
						position[1] += Self.velY
					Next
					
					checkWithPlayer(preX, preY, Self.pos[5][0], Self.pos[5][1])
			End Select
			
			If (boss_state = STATE_ATTACK_2) Then
				Return Self.pos[0]
			EndIf
			
			Return Self.pos[5]
		End
		
		Method draw:Void(g:MFGraphics)
			#Rem
				If (Not Self.dead) Then
					' Nothing so far.
				EndIf
			#End
		End
		
		Method drawArm:Void(g:MFGraphics)
			If (Not Self.dead) Then
				For Local i:= 0 Until Self.pos.Length
					If (Self.state = STATE_BROKEN And Self.drop_cnt < 2) Then
						drawInMap(g, Self.boomdrawer, Self.prepos[i][0], Self.prepos[i][1])
					EndIf
					
					If (i < (Self.pos.Length - 1) And Self.drop_cnt < 2) Then
						drawInMap(g, Self.armdrawer, Self.pos[i][0], Self.pos[i][1])
					EndIf
				Next
				
				If (Self.drop_cnt < 2) Then
					Local g2:= g.getSystemGraphics()
					
					g2.save()
					
					g2.translate(Float((Self.pos[5][0] Shr 6) - camera.x), Float((Self.pos[5][1] Shr 6) - camera.y))
					g2.rotate(Float((-Self.degree) Shr 6))
					
					Self.hammerdrawer.draw(g, 0, 0)
					
					g2.restore()
				EndIf
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.pos.Length = 0) Then
				Self.pos = generatePositionArray()
			EndIf
			
			Local position:= Self.pos[5]
			
			If (Self.state <> STATE_BROKEN) Then
				Self.collisionRect.setRect(position[0] - (COLLISION_WIDTH / 2), position[5][1] - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
		
		Method close:Void()
			Self.armdrawer = Null
			Self.boomdrawer = Null
			
			Self.pos = []
			Self.prepos = []
			Self.velX = []
		End
End