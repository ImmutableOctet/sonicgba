Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.stagemanager
Friend sonicgba.playersupersonic

Friend sonicgba.bossextrapacman
Friend sonicgba.bossextrastone

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.myrandom
	Import lib.soundsystem
	
	Import pyxeditor.pyxanimation
	
	Import sonicgba.sonicdef
	Import sonicgba.boom
	Import sonicgba.bossobject
	Import sonicgba.bulletobject
	Import sonicgba.collisionrect
	Import sonicgba.globalresource
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.playersupersonic
	Import sonicgba.stagemanager
	
	Import sonicgba.bossextrapacman
	Import sonicgba.bossextrastone
	
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class BossExtra Extends BossObject
	Protected
		' Constant variable(s):
		
		' States:
		Const STATE_NONE:Int = 0
		Const STATE_APPEAR_1:Int = 1
		Const STATE_APPEAR_2:Int = 2
		Const STATE_FIRST_DEFENCE:Int = 3
		Const STATE_SEQUENCE_1:Int = 4
		Const STATE_GROUND:Int = 5
		Const STATE_LASER:Int = 6
		Const STATE_DEFENCE:Int = 7
		Const STATE_DEAD:Int = 8
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 30720
		Const COLLISION_HEIGHT:Int = 18432
		
		Global ANI_SEQUENCE_1:Int[] = [ANI_ATTACK_1, ANI_ATTACK_2, ANI_GROUND_READY] ' [2, 3, 4] ' Const
		
		Global COLLISION_BODY_NAME:String[] = ["body", "head", "hand_f", "hand_b", "leg_front", "leg_back"] ' Const
		
		' Animations:
		Const ANI_APPEAR_1:Int = 0
		Const ANI_FIRST_DEFENCE:Int = 1
		Const ANI_ATTACK_1:Int = 2
		Const ANI_ATTACK_2:Int = 3
		Const ANI_GROUND_READY:Int = 4
		Const ANI_GROUND:Int = 5
		Const ANI_LASER:Int = 6
		Const ANI_DEFENCE:Int = 7
		Const ANI_APPEAR_2:Int = 8
		Const ANI_DEAD:Int = 9
		
		Const APPEAR_VELOCITY_1:Int = 1920
		Const APPEAR_VELOCITY_2:Int = -960
		
		Const APPEAR_X:Int = -3584
		Const APPEAR_Y:Int = 8192
		
		Const DEAD_DISTANCE_TO_GROUND:Int = 1200
		Const GROUND_COUNT:Int = 60
		
		Const LASER_COUNT:Int = 18
		Const LASER_NUM:Int = 4
		
		Const LASER_DEGREE_END:Int = 10880
		Const LASER_DEGREE_START:Int = 8320
		Const LASER_DIVIDE_COUNT:Int = 110
		Const LASER_VELOCITY_ACCELERATE:Int = 80
		
		Const PYX_ANI_SPEED:Int = 240
		Const PYX_ANI_SPEED_GROUND:Int = 64
		
		Const WARNING_COUNT:Int = 48
		
		' Global variable(s)
		Global bodyRect:CollisionRect = New CollisionRect()
		Global nodeInfo:NodeInfo = New NodeInfo()
		
		Global damageframe:Int
		
		' Fields:
		Field pyxAnimation:PyxAnimation
		
		Field bossAnimation:Animation[]
		
		Field headFlashDrawer:AnimationDrawer
		Field warningDrawer:AnimationDrawer
		
		Field bulletShowing:Bool
		Field pacmanFlag:Bool
		Field isOnLand:Bool
		Field isShotting:Bool
		
		Field actionID:Int
		
		Field state:Int
		
		Field afterLaserCount:Int
		
		Field count:Int
		Field damageCount:Int
		
		Field distanceToGround:Int
		
		Field laserCount:Int
		
		Field laserDegree:Int
		Field laserDegreeVelocity:Int
		
		Field laserHeight:Int
		
		Field laserNumCount:Int
		
		Field pacmanCount:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.laserNumCount = 0
			Self.laserCount = 0
			
			Self.state = STATE_NONE
			
			Self.bossAnimation = New Animation[1]
			
			Self.bossAnimation[0] = New Animation("/animation/boss_extra")
			
			Self.pyxAnimation = New PyxAnimation("/animation/aaa.pyx", Self.bossAnimation)
			
			Self.warningDrawer = Animation.getInstanceFromQi("/animation/utl_res/warning.dat")[0].getDrawer(0, True, 0)
			
			' Magic number: 15
			Self.headFlashDrawer = Self.bossAnimation[0].getDrawer(15, False, 0)
			
			Self.posX = APPEAR_X
			Self.posY = APPEAR_Y
			
			Self.velY = 0
			
			' Magic number: 2800
			Self.distanceToGround = 2800
			
			Self.pyxAnimation.setSpeed(PYX_ANI_SPEED)
			
			setBossHP()
		End
		
		' Methods:
		
		' Extensions:
		Method onPlayerAttack:Void(player:PlayerObject, direction:Int) ' animationID:Int
			If (Self.state <> STATE_DEAD) Then
				For Local i:= 0 Until COLLISION_BODY_NAME.Length
					Self.pyxAnimation.getNodeInfo(nodeInfo, COLLISION_BODY_NAME[i])
					
					If (nodeInfo.hasNode()) Then
						Local animationRect:= nodeInfo.drawer.getCRect()
						
						If (animationRect <> Null) Then
							bodyRect.setRect(Self.posX + ((nodeInfo.animationX + animationRect[0]) Shl 6), Self.posY + ((nodeInfo.animationY + animationRect[1]) Shl 6), animationRect[2] Shl 6, animationRect[3] Shl 6)
							bodyRect.setRotate(nodeInfo.degree, ((-animationRect[0]) + (nodeInfo.rotateX - nodeInfo.animationX)) Shl 6, ((-animationRect[1]) + (nodeInfo.rotateY - nodeInfo.animationY)) Shl 6)
							
							If (bodyRect.collisionChk(player.getCollisionRect())) Then
								If (i <> 1) Then
									player.beHurt()
								ElseIf (player.isAttackingEnemy() And Self.damageCount = 0) Then
									Self.HP -= 1
									
									If (Self.HP = 0) Then
										Self.state = STATE_DEAD
										
										' Magic number: 10 (Duration)
										Self.pyxAnimation.changeToAction(ANI_DEAD, 10)
										Self.pyxAnimation.setLoop(False)
										
										player.getBossScore()
										
										If (player.getCharacterID() = CHARACTER_SUPER_SONIC) Then
											' Optimization potential; dynamic cast.
											Local supersonic:= PlayerSuperSonic(player)
											
											If (supersonic <> Null) Then
												supersonic.setBossDieFlag(True)
											EndIf
										EndIf
									Else
										Self.damageCount = 10
									EndIf
									
									player.doBossAttackPose(Self, DIRECTION_LEFT)
								Else
									If (Self.damageCount = 0) Then
										player.beHurt()
									EndIf
								EndIf
								
								Exit
							EndIf
						Else
							Continue
						EndIf
					EndIf
				Next
			EndIf
		End
	Public
		' Methods:
		Method logic:Void()
			Select (Self.state)
				Case STATE_NONE
					Self.posX = APPEAR_X
					Self.posY = APPEAR_Y
					
					Self.isOnLand = False
					
					If (PlayerObject.getTimeCount() > 0) Then
						Self.count += 1
						
						If (Self.count = WARNING_COUNT) Then
							Self.state = STATE_APPEAR_1
							
							Self.count = 0
							
							Self.pyxAnimation.setAction(ANI_APPEAR_2)
							
							Self.velX = APPEAR_VELOCITY_1
							
							Self.velY = 0
						EndIf
					EndIf
				Case STATE_APPEAR_1
					Self.posX += Self.velX
					Self.posY += Self.velY
					
					Self.count += 1
					
					' Magic number: 32
					If (Self.count = 32) Then
						' Magic number: 14 (Duration)
						Self.pyxAnimation.changeToAction(ANI_APPEAR_1, 14)
						
						' Magic number: 128
						Self.velY = 128
						
						Self.state = STATE_APPEAR_2
						
						Self.count = 0
					EndIf
				Case STATE_APPEAR_2
					Self.posX += Self.velX
					Self.posY += Self.velY
					
					Self.count += 1
					
					' Magic number: 14
					If (Self.count > 14) Then
						Self.velX = APPEAR_VELOCITY_2
						
						Self.posY = (getGroundY(Self.posX, Self.posY + Self.distanceToGround) - Self.distanceToGround)
						
						' Magic number: 26368
						If (Self.posX < 26368) Then
							Self.posX = 26368
							
							Self.state = STATE_FIRST_DEFENCE
							
							Self.pyxAnimation.setAction(ANI_FIRST_DEFENCE)
							
							Self.actionID = 0
							
							Self.isOnLand = True
							
							Self.pacmanFlag = True
							
							Self.pacmanCount = 0
						EndIf
					EndIf
				Case STATE_FIRST_DEFENCE
					If (Self.pyxAnimation.chkEnd()) Then
						Self.state = STATE_SEQUENCE_1
						
						Self.pyxAnimation.setAction(ANI_SEQUENCE_1[Self.actionID])
						
						Self.actionID += 1
					EndIf
				Case STATE_SEQUENCE_1
					If (Self.pyxAnimation.chkEnd()) Then
						If (Self.actionID >= ANI_SEQUENCE_1.Length) Then
							Self.state = STATE_GROUND
							
							Self.pyxAnimation.setAction(ANI_GROUND)
							Self.pyxAnimation.setLoop(True)
							
							Self.count = 0
						Else
							Self.pyxAnimation.setAction(ANI_SEQUENCE_1[Self.actionID])
							
							Self.actionID += 1
						EndIf
					EndIf
				Case STATE_GROUND
					Self.count += 1
					
					' Magic number: 15
					If ((Self.count Mod 15) = 0) Then
						' Magic numbers: -256, 256, 3072, -128, 128
						BulletObject.addBullet(BulletObject.BULLET_BOSS_STONE, Self.posX + MyRandom.nextInt(-256, 256), (Self.posY + 3072) + MyRandom.nextInt(-128, 128), 0, 0)
						BulletObject.addBullet(BulletObject.BULLET_BOSS_STONE, Self.posX + MyRandom.nextInt(-256, 256), (Self.posY + 3072) + MyRandom.nextInt(-128, 128), 0, 0)
					EndIf
					
					If (Self.count > GROUND_COUNT) Then
						Self.state = STATE_LASER
						
						Self.pyxAnimation.setAction(ANI_LASER)
						Self.pyxAnimation.setLoop(False)
						
						Self.count = 0
						Self.laserNumCount = 0
					EndIf
				Case STATE_LASER
					Self.pyxAnimation.chkEnd()
					
					If ((Self.count Mod LASER_DIVIDE_COUNT) = 0 And Self.laserNumCount < 4) Then
						Self.laserDegree = LASER_DEGREE_START
						Self.laserDegreeVelocity = 0
						
						Self.laserCount = 0
						
						Self.isShotting = True
						
						Self.afterLaserCount = 0
						
						Self.laserHeight = 1
						Self.laserNumCount += 1
						
						Self.pyxAnimation.changeAnimation("head", 0, ANI_ATTACK_2)
					EndIf
					
					If (Not Self.isShotting And Self.laserNumCount = 4) Then
						Self.state = STATE_DEFENCE
						
						Self.pyxAnimation.setAction(ANI_DEFENCE)
					EndIf
					
					Self.count += 1
				Case STATE_DEFENCE
					If (Self.pyxAnimation.chkEnd()) Then
						Self.state = STATE_SEQUENCE_1
						
						Self.actionID = 0
						
						Self.pyxAnimation.setAction(ANI_SEQUENCE_1[Self.actionID])
						
						Self.actionID += 1
					EndIf
				Case STATE_DEAD
					damageframe += 1
					damageframe Mod= 11
					
					If ((damageframe Mod 2) = 0) Then
						SoundSystem.getInstance().playSe(SoundSystem.SE_144)
					EndIf
					
					Local cameraX:= MapManager.getCamera().x
					Local cameraY:= MapManager.getCamera().y
					
					If ((damageframe Mod 3) = 0) Then
						GameObject.addGameObject(New Boom(ENEMY_BOOM, (((Self.posX Shr 6) - 50) + MyRandom.nextInt(0, 100)) Shl 6, (((Self.posY Shr 6) - 50) + MyRandom.nextInt(0, 100)) Shl 6, 0, 0, 0, 0))
					EndIf
					
					' Magic number: 120
					Self.distanceToGround -= 120
					
					If (Self.distanceToGround < DEAD_DISTANCE_TO_GROUND) Then
						Self.distanceToGround = DEAD_DISTANCE_TO_GROUND
					EndIf
					
					If (Self.distanceToGround = DEAD_DISTANCE_TO_GROUND) Then
						' Magic number: 640
						Self.posX -= 640
					EndIf
					
					' Magic number: -12800
					If (Self.posX < -12800) Then
						StageManager.setStagePass()
					EndIf
			End Select
			
			If (Self.isOnLand) Then
				Self.posY = (getGroundY(Self.posX, Self.posY + Self.distanceToGround) - Self.distanceToGround)
			EndIf
			
			If (Self.isShotting) Then
				If (Self.laserDegree > LASER_DEGREE_END) Then
					Self.isShotting = False
					Self.bulletShowing = True
					Self.pyxAnimation.changeAnimation("head", 0, 2)
				Else
					Self.laserDegree += Self.laserDegreeVelocity
					Self.laserDegreeVelocity += LASER_VELOCITY_ACCELERATE
				EndIf
			EndIf
			
			If (Self.state <> STATE_DEAD) Then
				If (Self.pacmanFlag) Then
					Self.pacmanCount += 1
					
					If (Self.pacmanCount >= BossExtraPacman.PACMAN_LIFE) Then ' PYX_ANI_SPEED_GROUND
						Self.pacmanCount = 0
						
						' Magic numbers: 1152, 896
						BulletObject.addBullet(BulletObject.BULLET_BOSS_EXTRA_PACMAN, Self.posX - 1152, Self.posY - 896, 0, 0)
					EndIf
				EndIf
				
				If (Self.bulletShowing) Then
					Self.afterLaserCount += 1
					
					If (Self.afterLaserCount >= 5 And ((Self.afterLaserCount - 5) Mod 4) = 0) Then
						' Magic number: 320
						Local x:= (320 - (((Self.afterLaserCount - 5) * 32) / 4))
						
						If (x > 0) Then
							BulletObject.addBullet(BulletObject.BULLET_BOSS_EXTRA_LASER, (x Shl 6), Self.posY + Self.distanceToGround, 0, 0)
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_162)
						Else
							Self.bulletShowing = False
						EndIf
					EndIf
				EndIf
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (PlayerObject.getTimeCount() <> 0) Then
				Local camera:= MapManager.getCamera()
				
				Self.pyxAnimation.drawAction(g, (Self.posX Shr 6) - camera.x, (Self.posY Shr 6) - camera.y)
				
				Select (Self.state)
					Case STATE_NONE
						Self.warningDrawer.draw(g, (SCREEN_WIDTH / 2), (SCREEN_HEIGHT / 2)) ' Shr 1
				End Select
				
				If (Self.isShotting) Then
					Local laserX:= Self.pyxAnimation.getNodeXByAnimationNamed("head", -20, -12)
					Local laserY:= Self.pyxAnimation.getNodeYByAnimationNamed("head", -20, -12)
					
					Local g2:= g.getSystemGraphics()
					
					g2.save()
					
					g2.translate(Float(((Self.posX Shr 6) + laserX) - camera.x), Float(((Self.posY Shr 6) + laserY) - camera.y))
					g2.rotate(Float(Self.laserDegree Shr 6))
					
					g.setColor(MapManager.END_COLOR)
					
					g.fillRect(0, ((-Self.laserHeight) / 2), 500, Self.laserHeight) ' Shr 1
					
					Self.laserHeight += 1
					
					If (Self.laserHeight > 4) Then
						Self.laserHeight = 4
					EndIf
					
					g2.restore()
				EndIf
				
				If (Not IsGamePause) Then
					Self.damageCount -= 1
				EndIf
				
				If (Self.damageCount < 0) Then
					Self.damageCount = 0
				EndIf
				
				If ((Self.damageCount / 1) Mod 2 = 1) Then
					Self.pyxAnimation.getNodeInfo(nodeInfo, "head")
					
					If (nodeInfo.hasNode()) Then
						Local g2:= g.getSystemGraphics()
						
						g2.save()
						
						g2.translate(Float((nodeInfo.animationX + (Self.posX Shr 6)) - camera.x), Float((nodeInfo.animationY + (Self.posY Shr 6)) - camera.y))
						g2.rotate(Float(nodeInfo.degree))
						
						Self.headFlashDrawer.draw(g, 0, 0)
						
						g2.restore()
					EndIf
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((COLLISION_WIDTH / 2), 0, (COLLISION_WIDTH / 2), COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			onPlayerAttack(player, direction)
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			onPlayerAttack(player, direction)
		End
End