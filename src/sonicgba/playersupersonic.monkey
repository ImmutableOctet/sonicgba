Strict

Public

' Preprocessor related:
'#SONICGBA_SUPERSONIC_MUTE_WARNING_SOUND = True

' Imports:
Private
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	
	'Import mflib.bpdef
	
	Import sonicgba.bossextrapacman
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	Import sonicgba.stareffect
	
	Import com.sega.engine.action.acmovecalculator
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import monkey.stack
Public

' Classes:
Class PlayerSuperSonic Extends PlayerObject
	Private
		' Constant variable(s):
		Const WIDTH:Int = 1536
		Const HEIGHT:Int = 1024
		
		Const ATTACK_VELOCITY:Int = 1200
		
		Const HURT_COUNT:Int = 20
		
		Const INIT_RING_NUM:Int = 50
		
		Const MOVE_MAX_VELOCITY:Int = 960
		Const MOVE_POWER:Int = 240
		
		Const ROLLING_COUNT:Int = 7
		
		Const SMALL_JUMP_COUNT:Int = 9
		
		Const SUPER_ANI_ATTACK:Int = 4
		Const SUPER_ANI_ATTACK_EFFECT:Int = 5
		Const SUPER_ANI_DAMAGE:Int = 6
		Const SUPER_ANI_DIE_1:Int = 7
		Const SUPER_ANI_DIE_2:Int = 8
		Const SUPER_ANI_STAND:Int = 3
		Const SUPER_ANI_STAR_1:Int = 9
		Const SUPER_ANI_STAR_2:Int = 10
		
		Const VELOCITY_STAY:Int = 400
		
		Global START_JUMP_VELOCITY:Int = (GRAVITY + SHOOT_POWER) ' Const
		
		' Fields:
		Field attackEffectShow:Bool
		Field bossDie:Bool
		Field jumplocked:Bool
		Field noRingLose:Bool
		
		Field attackEffectCount:Int
		Field frameCount:Int
		Field nextStarCount:Int
		
		Field jumpframe:Int
		
		Field myAnimationID:Int
		
		Field shadowPosition:Int[][]
		
		Field moveCal:ACMoveCalculator
		
		Field pacman:BossExtraPacman
		
		Field attackEffectDrawer:AnimationDrawer
		Field shadowDrawer:AnimationDrawer
		Field SuperSonicDrawer:AnimationDrawer
		
		Field SuperSonicAcnimation:Animation
		
		Field starVec:Stack<StarEffect>
		
		Field smallJumpCount:Int
		Field starCount:Int
	Public
		' Constructor(s):
		Method New()
			Self.noRingLose = False
			
			Self.SuperSonicAcnimation = New Animation("/animation/player/chr_Super.sonic")
			
			Self.SuperSonicDrawer = Self.SuperSonicAcnimation.getDrawer()
			Self.shadowDrawer = Self.SuperSonicAcnimation.getDrawer(0, True, 0)
			Self.attackEffectDrawer = Self.SuperSonicAcnimation.getDrawer(SUPER_ANI_ATTACK_EFFECT, False, 0)
			
			Self.moveCal = New ACMoveCalculator(Self, Self)
			
			Self.myAnimationID = SUPER_ANI_STAND
			
			Self.drawer = Self.SuperSonicDrawer
			
			Self.starVec = New Stack<StarEffect>()
			
			Self.shadowPosition = New Int[3][]
			
			For Local i:= 0 Until Self.shadowPosition.Length
				Self.shadowPosition[i] = [Self.posX, Self.posY]
			Next
			
			ringNum = INIT_RING_NUM
		End
		
		' Methods:
		Method closeImpl:Void()
			Animation.closeAnimationDrawer(Self.SuperSonicDrawer)
			Self.SuperSonicDrawer = Null
			
			Animation.closeAnimationDrawer(Self.shadowDrawer)
			Self.shadowDrawer = Null
			
			Animation.closeAnimationDrawer(Self.attackEffectDrawer)
			Self.attackEffectDrawer = Null
			
			Animation.closeAnimation(Self.SuperSonicAcnimation)
			Self.SuperSonicAcnimation = Null
		End
		
		Method logic:Void()
			' Magic number: 200
			MapManager.setCameraUpLimit(MapManager.getPixelHeight() - 200)
			
			If (getBossDieFlag()) Then
				timeStopped = True
			EndIf
			
			If (getTimeCount() > 0 And Not Self.noRingLose And (timeCount - lastTimeCount) >= 1000) Then
				lastTimeCount += 1000
				
				If (ringNum > 0) Then
					ringNum -= 1
					
					#If Not SONICGBA_SUPERSONIC_MUTE_WARNING_SOUND
						If (ringNum <= 10) Then
							SoundSystem.getInstance().playSe(SoundSystem.SE_139)
						EndIf
					#End
				EndIf
				
				If (ringNum = 0) Then
					timeCount -= (timeCount Mod 1000)
					
					setDieWithoutSE()
					
					If (Self.pacman <> Null) Then
						Self.pacman.setDie()
					EndIf
					
					Self.pacman = Null
					
					Self.myAnimationID = SUPER_ANI_DIE_1
				EndIf
			EndIf
			
			If (Self.isDead) Then
				timeCount -= (timeCount Mod 1000)
				
				ringNum = 0
				
				If (Self.pacman <> Null) Then
					Self.pacman.setDie()
					
					Self.pacman = Null
				EndIf
				
				Self.velY += getGravity()
				
				Self.posX += Self.velX
				Self.posY += Self.velY
				
				' Magic number: 4096
				If (Self.posY > ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + 4096) Then
					Self.posY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + 4096
					
					If (Not Self.finishDeadStuff) Then
						If (stageModeState = 1) Then
							StageManager.setStageRestart()
						ElseIf (lifeNum > 0) Then
							lifeNum -= 1
							
							StageManager.setStageRestart()
						Else
							StageManager.setStageGameover()
						EndIf
						
						Self.finishDeadStuff = True
					EndIf
				EndIf
			ElseIf (Self.pacman <> Null) Then
				Self.moveCal.actionLogic(0, 0)
			Else
				Self.shadowPosition[0][1] = Self.shadowPosition[1][1]
				Self.shadowPosition[1][1] = Self.shadowPosition[2][1]
				Self.shadowPosition[2][1] = Self.posY
				
				Self.hurtCount -= 1
				
				' Magic number: 12
				If (Self.hurtCount = 12) Then
					Self.myAnimationID = SUPER_ANI_STAND
				EndIf
				
				If (Self.hurtCount < 0) Then
					Self.hurtCount = 0
				EndIf
				
				' Magic number: 13
				If (Self.hurtCount < 13) Then
					Select (Self.collisionState)
						Case COLLISION_STATE_WALK
							inputWalkLogic()
						Case COLLISION_STATE_JUMP
							inputJumpLogic()
					End Select
				EndIf
				
				Self.velY = 0
				
				' Magic number: -1243
				Self.velX = -1243
				
				Self.moveCal.actionLogic(Self.velX, Self.velY)
				
				Local moveLength:= (((Self.velX + MOVE_MAX_VELOCITY) * 2) / 3)
				
				Self.shadowPosition[0][0] = Self.posX - (moveLength * 3)
				Self.shadowPosition[1][0] = Self.posX - (moveLength * 2)
				Self.shadowPosition[2][0] = Self.posX - moveLength
				
				addStar()
			EndIf
		End
		
		Public Method didAfterEveryMove:Void(moveDistanceX:Int, moveDistanceY:Int)
			If (Self.posX - 768 < (MapManager.actualLeftCameraLimit Shl 6)) Then
				Self.posX = (MapManager.actualLeftCameraLimit Shl 6) + 768
				
				If (getVelX() < 0) Then
					setVelX(0)
				EndIf
			EndIf
			
			If (MapManager.actualRightCameraLimit <> MapManager.getPixelWidth() And Self.posX + 768 > (MapManager.actualRightCameraLimit Shl 6)) Then
				Self.posX = (MapManager.actualRightCameraLimit Shl 6) - 768
				
				If (getVelX() > 0) Then
					setVelX(0)
				EndIf
			EndIf
			
			If (Not Self.isDead And Self.footPointY > (MapManager.actualDownCameraLimit Shl 6)) Then
				Self.posY = MapManager.actualDownCameraLimit Shl 6
				setDieWithoutSE()
			EndIf
			
			If (Self.leftStopped And Self.rightStopped) Then
				setDieWithoutSE()
			EndIf
			
			Int groundY = getGroundY(Self.posX, Self.posY) - VELOCITY_STAY
			Select (Self.collisionState)
				Case 0
					Self.posY = groundY
					break
				Case 1
					
					If (Self.velY > 0 And groundY < Self.posY) Then
						Self.collisionState = (Byte) 0
						Self.posY = groundY
						break
					EndIf
					
			End Select
			Super.didAfterEveryMove(moveDistanceX, moveDistanceY)
		End
		
		Public Method drawCharacter:Void(g:MFGraphics)
			
			If (Self.pacman = Null) Then
				Self.drawer.setLoop(True)
				Self.drawer.setTrans(0)
				Self.drawer.setActionId(Self.myAnimationID)
				
				If (Self.myAnimationID = SUPER_ANI_DIE_1) Then
					Self.drawer.setLoop(False)
				EndIf
				
				If (Not Self.isDead) Then
					If (Self.attackEffectShow And Self.attackEffectCount Mod 2 = 1) Then
						drawInMap(g, Self.attackEffectDrawer, Self.posX, Self.posY)
					EndIf
					
					drawShadow(g)
				EndIf
				
				If (Self.myAnimationID = SUPER_ANI_DAMAGE) Then
					drawDamage(g, Self.drawer, Self.posX, Self.posY)
				ElseIf (Self.hurtCount Mod 2 = 0) Then
					drawInMap(g, Self.drawer, Self.posX, Self.posY)
				Else
					Self.drawer.moveOn()
					
					If (Self.drawer.checkEnd() And Self.myAnimationID = SUPER_ANI_DIE_1) Then
						Self.myAnimationID = SUPER_ANI_DIE_2
					EndIf
				EndIf
				
				If (Not Self.isDead And Self.attackEffectShow) Then
					If (Self.attackEffectCount Mod 2 = 0) Then
						drawInMap(g, Self.attackEffectDrawer, Self.posX, Self.posY)
					EndIf
					
					If (Not IsGamePause) Then
						Self.attackEffectCount += 1
					EndIf
					
					If (Self.attackEffectDrawer.checkEnd()) Then
						Self.attackEffectShow = False
						
						If (Self.myAnimationID = SUPER_ANI_ATTACK) Then
							Self.myAnimationID = SUPER_ANI_STAND
						EndIf
					EndIf
				EndIf
				
				If (Self.isDead And StageManager.isStageTimeover()) Then
					Self.myAnimationID = SUPER_ANI_DIE_1
					Self.drawer.setLoop(False)
					
					If (Not IsGamePause) Then
						Self.velY += getGravity()
						Self.posX += Self.velX
						Self.posY += Self.velY
						
						If (Self.posY > ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + MFGamePad.KEY_NUM_6) Then
							Self.posY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + MFGamePad.KEY_NUM_6
						EndIf
					EndIf
				EndIf
				
				drawStar(g)
				drawCollisionRect(g)
			EndIf
			
		End
		
		Public Method getFocusX:Int()
			Return Super.getFocusX() + (SCREEN_WIDTH Shr 2)
		End
		
		Public Method doWhileCollision:Void()
		End
		
		Public Method beHurt:Void()
			
			If (player.canBeHurt()) Then
				Self.myAnimationID = SUPER_ANI_DAMAGE
				Self.hurtCount = HURT_COUNT
				SoundSystem.getInstance().playSe(14)
			EndIf
			
			If (Self.pacman <> Null) Then
				Self.pacman.setDie()
				Self.pacman = Null
			EndIf
			
		End
		
		Public Method setBossDieFlag:Void(die:Bool)
			Self.bossDie = die
		End
		
		Public Method getBossDieFlag:Bool()
			Return Self.bossDie
		End
		
		Public Method setPackageObj:Void(pacman:BossExtraPacman)
			
			If (Self.pacman <> Null) Then
				Self.pacman.setDie()
			EndIf
			
			Self.pacman = pacman
		End
		
		Public Method isAttackingEnemy:Bool()
			Return Super.isAttackingEnemy() Or Self.attackEffectShow
		End
		
		Public Method refreshCollisionRectWrap:Void()
			Self.collisionRect.setRect(Self.posX - 768, Self.posY - HEIGHT, WIDTH, HEIGHT)
		End
		
		Public Method doBossAttackPose:Void(object:GameObject, direction:Int)
			
			If (Self.collisionState = 1) Then
				setVelX(-1243)
				Self.attackEffectShow = False
				Self.myAnimationID = SUPER_ANI_STAND
			EndIf
			
		End
		
		Public Method getBossScore:Void()
			Super.getBossScore()
			Self.noRingLose = True
		End
	Private
		' Methods:
		Private Method inputWalkLogic:Void()
			
			If (Self.hurtCount < 13) Then
				If (Key.repeated(Key.gLeft)) Then
					If (Self.velX > -960) Then
						Self.velX -= MOVE_POWER
						
						If (Self.velX < -960) Then
							Self.velX = -960
						EndIf
					EndIf
					
				ElseIf (Key.repeated(Key.gRight)) Then
					If (Self.velX < MOVE_MAX_VELOCITY) Then
						Self.velX += MOVE_POWER
						
						If (Self.velX > MOVE_MAX_VELOCITY) Then
							Self.velX = MOVE_MAX_VELOCITY
						EndIf
					EndIf
					
				ElseIf (Self.velX > 0) Then
					Self.velX -= MOVE_POWER
					
					If (Self.velX < 0) Then
						Self.velX = 0
					EndIf
					
				ElseIf (Self.velX < 0) Then
					Self.velX += MOVE_POWER
					
					If (Self.velX > 0) Then
						Self.velX = 0
					EndIf
				EndIf
				
				If (Key.press(Key.B_HIGH_JUMP)) Then
					Self.jumplocked = False
					Self.velY = 0
					Self.collisionState = (Byte) 1
					SoundSystem.getInstance().playSe(11)
					Self.smallJumpCount = SUPER_ANI_STAR_1
				EndIf
				
				If (Key.press(Key.gSelect) And Not Self.attackEffectShow) Then
					Self.velX = ATTACK_VELOCITY
					Self.attackEffectShow = True
					Self.attackEffectDrawer.restart()
					Self.myAnimationID = SUPER_ANI_ATTACK
					Self.attackEffectCount = 0
					SoundSystem.getInstance().playSe(SUPER_ANI_DIE_1)
				EndIf
			EndIf
			
		End
		
		Private Method inputJumpLogic:Void()
			
			If (Key.repeated(Key.gLeft)) Then
				If (Self.velX > -960) Then
					Self.velX -= MOVE_POWER
					
					If (Self.velX < -960) Then
						Self.velX = -960
					EndIf
				EndIf
				
			ElseIf (Key.repeated(Key.gRight)) Then
				If (Self.velX < MOVE_MAX_VELOCITY) Then
					Self.velX += MOVE_POWER
					
					If (Self.velX > MOVE_MAX_VELOCITY) Then
						Self.velX = MOVE_MAX_VELOCITY
					EndIf
				EndIf
				
			ElseIf (Self.velX > 0) Then
				Self.velX -= MOVE_POWER
				
				If (Self.velX < 0) Then
					Self.velX = 0
				EndIf
				
			ElseIf (Self.velX < 0) Then
				Self.velX += MOVE_POWER
				
				If (Self.velX > 0) Then
					Self.velX = 0
				EndIf
			EndIf
			
			If (Self.smallJumpCount > 0) Then
				Self.smallJumpCount -= 1
				
				If (Not Key.repeated(Key.gUp | Key.B_HIGH_JUMP)) Then
					Self.velY += GRAVITY Shr 1
					Self.velY += GRAVITY Shr 2
				EndIf
			EndIf
			
			If (Self.attackEffectShow) Then
				Self.velY = 0
			Else
				Self.velY += GRAVITY
			EndIf
			
			If (Key.press(Key.gSelect) And Not Self.attackEffectShow) Then
				Self.velX = ATTACK_VELOCITY
				Self.attackEffectShow = True
				Self.attackEffectDrawer.restart()
				Self.myAnimationID = SUPER_ANI_ATTACK
				Self.attackEffectCount = 0
				SoundSystem.getInstance().playSe(SUPER_ANI_DIE_1)
			EndIf
			
		End
		
		Private Method jumpRelock:Void()
			Self.jumpframe = 0
			Self.jumplocked = True
		End
		
		Private Method addStar:Void()
			Self.starCount += 1
			
			If (Self.starCount >= Self.nextStarCount) Then
				Self.starVec.addElement(New StarEffect(Self.SuperSonicAcnimation, MyRandom.nextInt(2) = 0 ? SUPER_ANI_STAR_1 : SUPER_ANI_STAR_2, Self.posX + WIDTH, Self.posY + MyRandom.nextInt(-400, 0)))
				Self.starCount = 0
				Self.nextStarCount = MyRandom.nextInt(2, SUPER_ANI_DAMAGE)
			EndIf
			
		End
		
		Private Method drawStar:Void(g:MFGraphics)
			Int i = 0
			While (i < Self.starVec.size()) {
				StarEffect star = (StarEffect) Self.starVec.elementAt(i)
				
				If (star.draw(g)) Then
					star.close()
					Self.starVec.removeElementAt(i)
					i -= 1
				EndIf
				
				i += 1
			}
		End
		
		Private Method drawShadow:Void(g:MFGraphics)
			Self.frameCount += 1
			Self.frameCount Mod= SUPER_ANI_STAND
			Self.shadowDrawer.setActionId(Self.myAnimationID)
			For (Int i = 0; i < Self.shadowPosition.Length; i += 1)
				
				If (Self.myAnimationID = SUPER_ANI_DAMAGE) Then
					drawDamage(g, Self.shadowDrawer, Self.shadowPosition[i][0], Self.shadowPosition[i][1])
				Else
					
					If (IsGamePause) Then
						Self.frameCount = 0
					EndIf
					
					If (Self.frameCount Mod 2 = 0) Then
						Self.shadowDrawer.draw(g, (Self.shadowPosition[i][0] Shr 6) - camera.x..(Self.shadowPosition[i][1] Shr 6) - camera.y)
					Else
						Self.shadowDrawer.moveOn()
					EndIf
				EndIf
				
			Next
		End
		
		Private Method drawDamage:Void(g:MFGraphics, drawer:AnimationDrawer, x:Int, y:Int)
			Int degree = ((Self.hurtCount - HURT_COUNT) * MDPhone.SCREEN_WIDTH) / SUPER_ANI_DIE_1
			Graphics g2 = (Graphics) g.getSystemGraphics()
			g2.save()
			g2.translate((Float) ((x Shr 6) - camera.x), (Float) ((y Shr 6) - camera.y))
			g2.rotate((Float) degree)
			drawer.draw(g, 0, 0)
			g2.restore()
		End
End