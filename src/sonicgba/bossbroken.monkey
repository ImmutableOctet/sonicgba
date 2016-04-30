Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject

Friend sonicgba.boss1
Friend sonicgba.boss2
Friend sonicgba.boss3
Friend sonicgba.boss4
Friend sonicgba.boss5
Friend sonicgba.boss6

Friend sonicgba.bossf1
Friend sonicgba.bossf2
Friend sonicgba.bossf3

Friend sonicgba.proboss1

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class BossBroken Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1
		Const COLLISION_HEIGHT:Int = 1
		
		Const MAX_BOOM:Int = 8
		
		' Global variable(s):
		Global PartsAni:Animation
		Global frame:Int
		
		' Fields:
		Field IsEnd:Bool
		
		Field partsdrawer:AnimationDrawer
		
		Field boomdrawers:AnimationDrawer[]
		
		Field Vix:Int[]
		Field Viy:Int[]
		Field back_offset:Int[]
		Field boomPos:Int[][]
		Field pos:Int[][]
		
		Field boomCount:Int
		Field enemyid:Int
		Field jump_time:Int
		Field offsety:Int
		
		Field range:Int
		
		Field startx:Int
		Field starty:Int
		
		Field totalBoom:Int
		
		Field time_cnt:Int
		Field total_cnt:Int
		Field total_cnt_max:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.range = 6400
			
			Self.offsety = 0
			
			Self.Viy = [750, -300, -150, 150, 450, -750, 600, 300, -450]
			Self.Vix = [-1200, -1050, -900, -750, -600]
			
			Self.total_cnt_max = MAX_BOOM ' 8
			
			Self.jump_time = 10
			
			Self.back_offset = [-15, -10, -5, 0, 5, 10, 15]
			
			Self.posX -= (Self.iLeft * MAX_BOOM) ' 8
			Self.posY -= (Self.iTop * MAX_BOOM) ' 8
			
			Self.enemyid = id
			
			Select (id)
				Case EnemyObject.ENEMY_BOSS1
					Self.offsety = 1728
				Case EnemyObject.ENEMY_BOSS2
					Self.offsety = 960
				Case EnemyObject.ENEMY_BOSS3, EnemyObject.ENEMY_BOSS4
					Self.offsety = 0
			End Select
			
			Self.startx = Self.posX
			Self.starty = (Self.posY - Self.offsety)
			
			If (BoomAni = Null) Then
				BoomAni = New Animation("/animation/boom")
			EndIf
			
			Self.boomdrawers = New AnimationDrawer[MAX_BOOM]
			
			For Local i:= 0 Until MAX_BOOM
				Self.boomdrawers[i] = BoomAni.getDrawer(0, False, 0)
			Next
			
			Self.boomPos = New Int[MAX_BOOM][]
			
			For Local i:= 0 Until MAX_BOOM ' Self.boomPos.Length
				Self.boomPos[i] = New Int[2]
			Next
			
			Self.boomCount = 0
			Self.totalBoom = 0
			
			If (id <> EnemyObject.ENEMY_BOSS5) Then
				If (id = EnemyObject.ENEMY_BOSS6) Then
					If (PartsAni = Null) Then
						PartsAni = New Animation("/animation/boss6_parts")
					EndIf
				Else
					If (PartsAni = Null) Then
						PartsAni = New Animation("/animation/parts")
					EndIf
				EndIf
				
				Self.partsdrawer = PartsAni.getDrawer(0, True, 0)
			EndIf
			
			Self.pos = New Int[3][]
			
			For Local i:= 0 Until Self.pos.Length ' 3
				Self.pos[i] = New Int[5]
				
				Self.pos[i][0] = Self.startx
				Self.pos[i][1] = Self.starty
				
				Self.pos[i][2] = 0
				Self.pos[i][3] = 0
				Self.pos[i][4] = 0
			Next
			
			Self.total_cnt_max = MAX_BOOM ' 8
			
			Self.jump_time = 10
			
			frame = 1
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(BoomAni)
			Animation.closeAnimation(PartsAni)
			
			BoomAni = Null
			PartsAni = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method logicBoom:Void(carx:Int, cary:Int)
			If (Not IsGamePause) Then
				If (Self.total_cnt <= (Self.total_cnt_max / 2)) Then ' Shr 1
					Self.startx = carx
					Self.starty = cary
				Else
					Self.startx = ((Self.back_offset[MyRandom.nextInt(Self.back_offset.Length)] Shl 6) + carx)
					Self.starty = (((cary - 1344) + (Self.back_offset[MyRandom.nextInt(Self.back_offset.Length)] Shl 6)) - Self.offsety)
				EndIf
				
				frame += 1
				frame Mod= 11
				
				If ((frame Mod 2) = 0) Then
					soundInstance.playSe(SoundSystem.SE_144)
				EndIf
			EndIf
			
			AnimationDrawer.setAllPause(IsGamePause)
		End
		
		Method getEndState:Bool()
			Return Self.IsEnd
		End
		
		Method draw:Void(g:MFGraphics)
			If (Self.total_cnt < Self.total_cnt_max) Then
				If (Not IsGamePause) Then
					Self.time_cnt += 1
					
					If (Self.time_cnt Mod Self.jump_time = 0 Or Self.time_cnt = 0) Then
						Self.total_cnt += 1
						
						'For Local position:= EachIn Self.pos
						For Local i:= 0 Until Self.pos.Length
							Local position:= Self.pos[i]
							
							position[0] = Self.startx
							position[1] = Self.starty
							position[2] = Self.Vix[MyRandom.nextInt(Self.Vix.Length)]
							position[3] = Self.Viy[MyRandom.nextInt(Self.Viy.Length)]
							
							' Magic number: 6
							position[4] = MyRandom.nextInt(6)
						Next
					EndIf
					
					'For Local position:= EachIn Self.pos
					For Local i:= 0 Until Self.pos.Length
						Local position:= Self.pos[i]
						
						position[0] += position[2]
						position[3] += (GRAVITY / 2) ' Shr 1
						position[1] += position[3]
					Next
					
					If (Self.total_cnt >= Self.total_cnt_max) Then
						Self.IsEnd = True
					EndIf
					
					Self.boomCount += 1
					Self.boomCount Mod= 2
					
					If (Self.boomCount = 1) Then
						Self.boomPos[Self.totalBoom][0] = Self.startx + ((MyRandom.nextInt(60) - 30) Shl 6)
						Self.boomPos[Self.totalBoom][1] = Self.starty + ((MyRandom.nextInt(60) - 30) Shl 6)
						
						Self.boomdrawers[Self.totalBoom].restart()
						
						Self.totalBoom += 1
					EndIf
					
					If (Self.totalBoom = MAX_BOOM) Then
						Self.totalBoom = 0
					EndIf
				EndIf
				
				For Local i:= 0 To Self.totalBoom ' Until
					If (Not Self.boomdrawers[i].checkEnd()) Then
						Local position:= Self.boomPos[i]
						
						drawInMap(g, Self.boomdrawers[i], position[0], position[1])
					EndIf
				Next
				
				If (Self.enemyid <> EnemyObject.ENEMY_BOSS5) Then
					For Local i:= 0 Until Self.pos.Length
						Local position:= Self.pos[i]
						
						Self.partsdrawer.setActionId(position[4])
						
						drawInMap(g, Self.partsdrawer, position[0], position[1])
					Next
				EndIf
			EndIf
		End
		
		Method setTotalCntMax:Void(time:Int)
			Self.total_cnt_max = time
		End
		
		Method setJumpTime:Void(time:Int)
			Self.jump_time = time
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			For Local i:= 0 Until MAX_BOOM
				Self.boomdrawers[i] = Null
			Next
			
			Self.boomdrawers = []
			Self.pos = []
			
			Self.partsdrawer = Null
		End
End