Strict

Public

' Friends:
Friend sonicgba.bulletobject
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.bossextra

' Imports:
Private
	Import gameengine.key
	
	Import lib.animation
	Import lib.myrandom
	Import lib.soundsystem
	
	Import sonicgba.sonicdef
	Import sonicgba.bulletobject
	Import sonicgba.moveringobject
	Import sonicgba.playerobject
	Import sonicgba.playersupersonic
	
	Import com.sega.engine.action.acmovecaluser
	Import com.sega.engine.action.acmovecalculator
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class BossExtraPacman Extends BulletObject Implements ACMoveCalUser
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1536
		
		Const COLLISION_OFFSET_Y:Int = -960
		
		Const PACMAN_LIFE:Int = 64
		
		Const RING_NUM:Int = 7
		
		Const STATE_BEGIN:Int = 0
		Const STATE_SEARCH:Int = 1
		Const STATE_DASH:Int = 2
		Const STATE_DEAD:Int = 3
		Const STATE_PACKAGING:Int = 4
		Const STATE_PACKAGED:Int = 5
		Const STATE_BROKE:Int = 6
		
		' Fields:
		Field isHigher:Bool
		
		Field moveCal:ACMoveCalculator
		
		Field SuperSonic:PlayerSuperSonic
		
		Field pieceInfo:Int[][]
		
		Field count:Int
		Field packageOffset:Int
		Field state:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(x, y, 0, 0, False)
			
			Self.pieceInfo = New Int[2][]
			
			For Local i:= 0 Until Self.pieceInfo.Length
				Self.pieceInfo[i] = New Int[4]
			Next
			
			If (pacmanAnimation = Null) Then
				pacmanAnimation = New Animation("/animation/boss_extra_pacman")
			EndIf
			
			Self.drawer = pacmanAnimation.getDrawer(0, True, 0)
			
			Self.state = STATE_BEGIN
			
			Self.count = 0
			
			Self.moveCal = New ACMoveCalculator(Self, Self)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(pacmanAnimation)
			
			pacmanAnimation = Null
		End
		
		' Methods:
		Method bulletLogic:Void()
			If ((player.getCharacterID() = CHARACTER_SUPER_SONIC) And Self.state <> STATE_BROKE) Then
				' Optimization potential; dynamic cast.
				Local supersonic:= PlayerSuperSonic(player) ' SuperSonic
				
				If (supersonic <> Null) Then
					If (supersonic.getBossDieFlag()) Then
						setDie()
					EndIf
				EndIf
			EndIf
			
			Self.count += 1
			
			Select (Self.state)
				Case STATE_BEGIN
					' Magic number: -240
					Self.moveCal.actionLogic(-240, 0)
					
					' Magic number: 12
					If (Self.count > 12) Then
						Self.state = STATE_SEARCH
						
						Self.isHigher = (Self.posY < player.posY)
					EndIf
				Case STATE_SEARCH
					If (Self.posY < player.posY) Then
						If (Self.isHigher) Then
							' Magic number: 240
							Self.moveCal.actionLogic(0, Min(player.posY - Self.posY, 240))
						Else
							Self.state = STATE_DASH
							
							Return
						EndIf
					ElseIf (Self.posY > player.posY) Then
						If (Self.isHigher) Then
							Self.state = STATE_DASH
							
							Return
						EndIf
						
						Self.moveCal.actionLogic(0, Max(player.posY - Self.posY, -240))
					EndIf
					
					If (player.posY = Self.posY) Then
						Self.state = STATE_DASH
					EndIf
				Case STATE_DASH
					Self.moveCal.actionLogic(-720, 0)
				Case STATE_PACKAGING
					Self.posX = player.posX
					Self.posY = player.posY
					
					If (Self.drawer.checkEnd()) Then
						Self.state = STATE_PACKAGED
						
						Self.count = 0
						
						If (Self.SuperSonic <> Null) Then
							Self.SuperSonic.setPackageObj(Self)
						EndIf
					EndIf
				Case STATE_PACKAGED
					Self.posX = player.posX
					Self.posY = player.posY
					
					' Magic numbers: -256, 256
					If (Key.press(Key.gLeft) And Self.packageOffset <> -256) Then
						Self.packageOffset = -256
						
						Self.count += 5
					ElseIf (Not Key.press(Key.gRight) Or Self.packageOffset = 256) Then
						Self.packageOffset = 0
					Else
						Self.packageOffset = 256
						
						Self.count += 5
					EndIf
					
					If (Self.count > PACMAN_LIFE) Then
						Self.SuperSonic.setPackageObj(Null)
						
						Self.state = STATE_BROKE
						
						doBroke()
					EndIf
				Case STATE_BROKE
					For Local i:= 0 Until Self.pieceInfo.Length
						Local iArr:= Self.pieceInfo[i]
						
						iArr[3] += (GRAVITY / 4) ' Shr 2
						iArr[0] += Self.pieceInfo[i][2]
						iArr[1] += Self.pieceInfo[i][3]
					Next
				Default
					' Nothing so far.
			End Select
		End
		
		Method draw:Void(g:MFGraphics)
			Select (Self.state)
				Case STATE_BEGIN
					Self.drawer.setActionId(STATE_BEGIN) ' 0
					Self.drawer.setLoop(False)
					
					drawInMap(g, Self.drawer)
				Case STATE_SEARCH, STATE_DASH
					Self.drawer.setActionId(STATE_SEARCH) ' 1
					Self.drawer.setLoop(True)
					
					drawInMap(g, Self.drawer)
				Case STATE_DEAD
					Self.drawer.setActionId(STATE_PACKAGING) ' 4
					
					drawInMap(g, Self.drawer)
				Case STATE_PACKAGING
					Self.drawer.setActionId(STATE_DASH) ' 2
					Self.drawer.setLoop(False)
					
					drawInMap(g, Self.drawer)
				Case STATE_PACKAGED
					Self.drawer.setActionId(STATE_DEAD) ' 3
					
					drawInMap(g, Self.drawer, Self.posX + Self.packageOffset, Self.posY)
				Case STATE_BROKE
					For Local i:= 0 Until Self.pieceInfo.Length
						Self.drawer.setActionId(i + 4)
						
						drawInMap(g, Self.drawer, Self.pieceInfo[i][0], Self.pieceInfo[i][1])
					Next
			End Select
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x, y + COLLISION_OFFSET_Y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method didAfterEveryMove:Void(moveDistanceX:Int, moveDistanceY:Int)
			refreshCollisionRect(Self.posX, Self.posY)
			
			doWhileCollisionWrapWithPlayer()
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (player.getCharacterID() = CHARACTER_SUPER_SONIC) Then
				' Optimization potential; dynamic cast.
				Local supersonic:= PlayerSuperSonic(player)
				
				If (supersonic <> Null) Then
					Self.SuperSonic = supersonic
					
					If (Self.state <> STATE_SEARCH And Self.state <> STATE_DASH) Then
						Return
					EndIf
					
					If (player.isAttackingEnemy()) Then
						Self.state = STATE_BROKE
						
						doBroke()
						ringBroke()
					Else
						Self.state = STATE_PACKAGING
					EndIf
				EndIf
			EndIf
		End
		
		Method setDie:Void()
			Self.state = STATE_BROKE
			
			doBroke()
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
		
		Method chkDestroy:Bool()
			Return ((Self.state = STATE_DEAD) Or Self.posX < 0 Or (Self.state = STATE_BROKE And (Self.pieceInfo[0][1] Shr 6) > (camera.y + SCREEN_HEIGHT) + 40))
		End
	Private
		' Methods:
		Method doBroke:Void()
			SoundSystem.getInstance().playSe(SoundSystem.SE_138)
			
			If (Self.pieceInfo.Length > 0) Then
				' Magic number: 640
				Self.pieceInfo[0][0] = Self.posX - 640
				Self.pieceInfo[1][0] = Self.posX + 640
				Self.pieceInfo[0][1] = Self.posY
				Self.pieceInfo[1][1] = Self.posY
				Self.pieceInfo[0][2] = -200
				Self.pieceInfo[1][2] = 200
				Self.pieceInfo[0][3] = -200
				Self.pieceInfo[1][3] = -200
			EndIf
		End
		
		Method ringBroke:Void()
			For Local i:= 0 Until RING_NUM
				GameObject.addGameObject(New MoveRingObject(Self.posX, Self.posY, MyRandom.nextInt(-400, 400), MyRandom.nextInt(-800 - (GRAVITY * 2), -300 - (GRAVITY)), 1, systemClock, 14))
			Next
		End
End