Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.myrandom
	Import lib.soundsystem
	
	Import pyxeditor.pyxanimation
	
	import sonicgba.boom
	import sonicgba.bossobject
	import sonicgba.bulletobject
	import sonicgba.collisionrect
	import sonicgba.globalresource
	import sonicgba.mapmanager
	import sonicgba.playerobject
	import sonicgba.playersupersonic
	import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class BossExtra Extends BossObject
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
			Self.state = 0
			Self.bossAnimation = New Animation[STATE_APPEAR_1]
			Self.bossAnimation[0] = New Animation("/animation/boss_extra")
			Self.pyxAnimation = New PyxAnimation("/animation/aaa.pyx", Self.bossAnimation)
			Self.warningDrawer = Animation.getInstanceFromQi("/animation/utl_res/warning.dat")[0].getDrawer(0, True, 0)
			Self.headFlashDrawer = Self.bossAnimation[0].getDrawer(15, False, 0)
			Self.posX = APPEAR_X
			Self.posY = APPEAR_Y
			Self.velY = 0
			Self.distanceToGround = 2800
			Self.pyxAnimation.setSpeed(PYX_ANI_SPEED)
			
			If (GlobalResource.isEasyMode() And stageModeState = 0) Then
				Self.HP = STATE_LASER
			Else
				Self.HP = STATE_DEAD
			EndIf
		End
	Public
		' Methods:
		Public Method logic:Void()
			Select (Self.state)
				Case 0
					Self.posX = APPEAR_X
					Self.posY = APPEAR_Y
					Self.isOnLand = False
					
					If (PlayerObject.getTimeCount() > 0) Then
						Self.count += STATE_APPEAR_1
						
						If (Self.count = WARNING_COUNT) Then
							Self.state = STATE_APPEAR_1
							Self.count = 0
							Self.pyxAnimation.setAction(STATE_DEAD)
							Self.velX = APPEAR_VELOCITY_1
							Self.velY = 0
							break
						EndIf
					EndIf
					
					break
				Case STATE_APPEAR_1
					Self.posX += Self.velX
					Self.posY += Self.velY
					Self.count += STATE_APPEAR_1
					
					If (Self.count = 32) Then
						Self.pyxAnimation.changeToAction(0, 14)
						Self.velY = 128
						Self.state = STATE_APPEAR_2
						Self.count = 0
						break
					EndIf
					
					break
				Case STATE_APPEAR_2
					Self.posX += Self.velX
					Self.posY += Self.velY
					Self.count += STATE_APPEAR_1
					
					If (Self.count > 14) Then
						Self.velX = APPEAR_VELOCITY_2
						Self.posY = getGroundY(Self.posX, Self.posY + Self.distanceToGround) - Self.distanceToGround
						
						If (Self.posX < 26368) Then
							Self.posX = 26368
							Self.state = STATE_FIRST_DEFENCE
							Self.pyxAnimation.setAction(STATE_APPEAR_1)
							Self.actionID = 0
							Self.isOnLand = True
							Self.pacmanFlag = True
							Self.pacmanCount = 0
							break
						EndIf
					EndIf
					
					break
				Case STATE_FIRST_DEFENCE
					
					If (Self.pyxAnimation.chkEnd()) Then
						Self.state = STATE_SEQUENCE_1
						Self.pyxAnimation.setAction(ANI_SEQUENCE_1[Self.actionID])
						Self.actionID += STATE_APPEAR_1
						break
					EndIf
					
					break
				Case STATE_SEQUENCE_1
					
					If (Self.pyxAnimation.chkEnd()) Then
						If (Self.actionID >= ANI_SEQUENCE_1.Length) Then
							Self.state = STATE_GROUND
							Self.pyxAnimation.setAction(STATE_GROUND)
							Self.pyxAnimation.setLoop(True)
							Self.count = 0
							break
						EndIf
						
						Self.pyxAnimation.setAction(ANI_SEQUENCE_1[Self.actionID])
						Self.actionID += STATE_APPEAR_1
						break
					EndIf
					
					break
				Case STATE_GROUND
					Self.count += STATE_APPEAR_1
					
					If (Self.count Mod 15 = 0) Then
						BulletObject.addBullet(24, Self.posX + MyRandom.nextInt(GimmickObject.PLATFORM_OFFSET_Y, 256), (Self.posY + 3072) + MyRandom.nextInt(def.TOUCH_HELP_LEFT_X, 128), 0, 0)
						BulletObject.addBullet(24, Self.posX + MyRandom.nextInt(GimmickObject.PLATFORM_OFFSET_Y, 256), (Self.posY + 3072) + MyRandom.nextInt(def.TOUCH_HELP_LEFT_X, 128), 0, 0)
					EndIf
					
					If (Self.count > GROUND_COUNT) Then
						Self.state = STATE_LASER
						Self.pyxAnimation.setAction(STATE_LASER)
						Self.pyxAnimation.setLoop(False)
						Self.count = 0
						Self.laserNumCount = 0
						break
					EndIf
					
					break
				Case STATE_LASER
					Self.pyxAnimation.chkEnd()
					
					If (Self.count Mod LASER_DIVIDE_COUNT = 0 And Self.laserNumCount < STATE_SEQUENCE_1) Then
						Self.laserDegree = LASER_DEGREE_START
						Self.laserDegreeVelocity = 0
						Self.laserCount = 0
						Self.isShotting = True
						Self.afterLaserCount = 0
						Self.laserHeight = STATE_APPEAR_1
						Self.laserNumCount += STATE_APPEAR_1
						Self.pyxAnimation.changeAnimation("head", 0, STATE_FIRST_DEFENCE)
					EndIf
					
					If (Not Self.isShotting And Self.laserNumCount = STATE_SEQUENCE_1) Then
						Self.state = STATE_DEFENCE
						Self.pyxAnimation.setAction(STATE_DEFENCE)
					EndIf
					
					Self.count += STATE_APPEAR_1
					break
				Case STATE_DEFENCE
					
					If (Self.pyxAnimation.chkEnd()) Then
						Self.state = STATE_SEQUENCE_1
						Self.actionID = 0
						Self.pyxAnimation.setAction(ANI_SEQUENCE_1[Self.actionID])
						Self.actionID += STATE_APPEAR_1
						break
					EndIf
					
					break
				Case STATE_DEAD
					damageframe += STATE_APPEAR_1
					damageframe Mod= 11
					
					If (damageframe Mod STATE_APPEAR_2 = 0) Then
						SoundSystem.getInstance().playSe(35)
					EndIf
					
					Int cameraX = MapManager.getCamera().x
					Int cameraY = MapManager.getCamera().y
					
					If (damageframe Mod STATE_FIRST_DEFENCE = 0) Then
						GameObject.addGameObject(New Boom(37, (((Self.posX Shr STATE_LASER) - 50) + MyRandom.nextInt(0, 100)) Shl STATE_LASER, (((Self.posY Shr STATE_LASER) - 50) + MyRandom.nextInt(0, 100)) Shl STATE_LASER, 0, 0, 0, 0))
					EndIf
					
					Self.distanceToGround -= 120
					
					If (Self.distanceToGround < DEAD_DISTANCE_TO_GROUND) Then
						Self.distanceToGround = DEAD_DISTANCE_TO_GROUND
					EndIf
					
					If (Self.distanceToGround = DEAD_DISTANCE_TO_GROUND) Then
						Self.posX -= MDPhone.SCREEN_HEIGHT
					EndIf
					
					If (Self.posX < -12800) Then
						StageManager.setStagePass()
						break
					EndIf
					
					break
			EndIf
			If (Self.isOnLand) Then
				Self.posY = getGroundY(Self.posX, Self.posY + Self.distanceToGround) - Self.distanceToGround
			EndIf
			
			If (Self.isShotting) Then
				If (Self.laserDegree > LASER_DEGREE_END) Then
					Self.isShotting = False
					Self.bulletShowing = True
					Self.pyxAnimation.changeAnimation("head", 0, STATE_APPEAR_2)
				Else
					Self.laserDegree += Self.laserDegreeVelocity
					Self.laserDegreeVelocity += LASER_VELOCITY_ACCELERATE
				EndIf
			EndIf
			
			If (Self.state <> STATE_DEAD) Then
				If (Self.pacmanFlag) Then
					Self.pacmanCount += STATE_APPEAR_1
					
					If (Self.pacmanCount >= PYX_ANI_SPEED_GROUND) Then
						Self.pacmanCount = 0
						BulletObject.addBullet(22, Self.posX - BarHorbinV.HOBIN_POWER, Self.posY - 896, 0, 0)
					EndIf
				EndIf
				
				If (Self.bulletShowing) Then
					Self.afterLaserCount += STATE_APPEAR_1
					
					If (Self.afterLaserCount >= STATE_GROUND And (Self.afterLaserCount - STATE_GROUND) Mod STATE_SEQUENCE_1 = 0) Then
						Int x = 320 - (((Self.afterLaserCount - STATE_GROUND) * 32) / STATE_SEQUENCE_1)
						
						If (x > 0) Then
							BulletObject.addBullet(23, x Shl STATE_LASER, Self.posY + Self.distanceToGround, 0, 0)
							SoundSystem.getInstance().playSe(81)
							Return
						EndIf
						
						Self.bulletShowing = False
					EndIf
				EndIf
			EndIf
			
		End
		
		Public Method draw:Void(g:MFGraphics)
			
			If (PlayerObject.getTimeCount() <> 0) Then
				Graphics g2
				Coordinate camera = MapManager.getCamera()
				Self.pyxAnimation.drawAction(g, (Self.posX Shr STATE_LASER) - camera.x, (Self.posY Shr STATE_LASER) - camera.y)
				Select (Self.state)
					Case 0
						Self.warningDrawer.draw(g, SCREEN_WIDTH Shr STATE_APPEAR_1, SCREEN_HEIGHT Shr STATE_APPEAR_1)
						break
				EndIf
				If (Self.isShotting) Then
					Int laserX = Self.pyxAnimation.getNodeXByAnimationNamed("head", -20, -12)
					Int laserY = Self.pyxAnimation.getNodeYByAnimationNamed("head", -20, -12)
					g2 = (Graphics) g.getSystemGraphics()
					g2.save()
					g2.translate((Float) (((Self.posX Shr STATE_LASER) + laserX) - camera.x), (Float) (((Self.posY Shr STATE_LASER) + laserY) - camera.y))
					g2.rotate((Float) (Self.laserDegree Shr STATE_LASER))
					g.setColor(MapManager.END_COLOR)
					g.fillRect(0, (-Self.laserHeight) Shr STATE_APPEAR_1, PlayerObject.BANKING_MIN_SPEED, Self.laserHeight)
					Self.laserHeight += STATE_APPEAR_1
					
					If (Self.laserHeight > STATE_SEQUENCE_1) Then
						Self.laserHeight = STATE_SEQUENCE_1
					EndIf
					
					g2.restore()
				EndIf
				
				If (Not IsGamePause) Then
					Self.damageCount -= STATE_APPEAR_1
				EndIf
				
				If (Self.damageCount < 0) Then
					Self.damageCount = 0
				EndIf
				
				If ((Self.damageCount / STATE_APPEAR_1) Mod STATE_APPEAR_2 = STATE_APPEAR_1) Then
					Self.pyxAnimation.getNodeInfo(nodeInfo, "head")
					
					If (nodeInfo.hasNode()) Then
						g2 = (Graphics) g.getSystemGraphics()
						g2.save()
						g2.translate((Float) ((nodeInfo.animationX + (Self.posX Shr STATE_LASER)) - camera.x), (Float) ((nodeInfo.animationY + (Self.posY Shr STATE_LASER)) - camera.y))
						g2.rotate((Float) nodeInfo.degree)
						Self.headFlashDrawer.draw(g, 0, 0)
						g2.restore()
					EndIf
				EndIf
			EndIf
			
		End
		
		Public Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(15360, 0, 15360, COLLISION_HEIGHT)
		End
		
		Public Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			
			If (Self.state <> STATE_DEAD) Then
				For (Int i = 0; i < COLLISION_BODY_NAME.Length; i += STATE_APPEAR_1)
					Self.pyxAnimation.getNodeInfo(nodeInfo, COLLISION_BODY_NAME[i])
					
					If (nodeInfo.hasNode()) Then
						Byte[] animationRect = nodeInfo.drawer.getCRect()
						
						If (animationRect <> Null) Then
							bodyRect.setRect(Self.posX + ((nodeInfo.animationX + animationRect[0]) Shl STATE_LASER), Self.posY + ((nodeInfo.animationY + animationRect[STATE_APPEAR_1]) Shl STATE_LASER), animationRect[STATE_APPEAR_2] Shl STATE_LASER, animationRect[STATE_FIRST_DEFENCE] Shl STATE_LASER)
							bodyRect.setRotate(nodeInfo.degree, ((-animationRect[0]) + (nodeInfo.rotateX - nodeInfo.animationX)) Shl STATE_LASER..((-animationRect[STATE_APPEAR_1]) + (nodeInfo.rotateY - nodeInfo.animationY)) Shl STATE_LASER)
							
							If (bodyRect.collisionChk(player.getCollisionRect())) Then
								If (i <> STATE_APPEAR_1) Then
									player.beHurt()
									Return
								ElseIf (player.isAttackingEnemy() And Self.damageCount = 0) Then
									Self.HP -= STATE_APPEAR_1
									
									If (Self.HP = 0) Then
										Self.state = STATE_DEAD
										Self.pyxAnimation.changeToAction(ANI_DEAD, 10)
										Self.pyxAnimation.setLoop(False)
										player.getBossScore()
										
										If (player instanceof PlayerSuperSonic) Then
											((PlayerSuperSonic) player).setBossDieFlag(True)
										EndIf
										
									Else
										Self.damageCount = 10
									EndIf
									
									player.doBossAttackPose(Self, STATE_APPEAR_2)
									Return
								ElseIf (Self.damageCount = 0) Then
									player.beHurt()
									Return
								Else
									Return
								EndIf
							EndIf
							
						Else
							continue
						EndIf
					EndIf
				EndIf
			EndIf
			
		End
		
		Public Method doWhileBeAttack:Void(object:PlayerObject, direction:Int, animationID:Int)
			
			If (Self.state <> STATE_DEAD) Then
				For (Int i = 0; i < COLLISION_BODY_NAME.Length; i += STATE_APPEAR_1)
					Self.pyxAnimation.getNodeInfo(nodeInfo, COLLISION_BODY_NAME[i])
					
					If (nodeInfo.hasNode()) Then
						Byte[] animationRect = nodeInfo.drawer.getCRect()
						
						If (animationRect <> Null) Then
							bodyRect.setRect(Self.posX + ((nodeInfo.animationX + animationRect[0]) Shl STATE_LASER), Self.posY + ((nodeInfo.animationY + animationRect[STATE_APPEAR_1]) Shl STATE_LASER), animationRect[STATE_APPEAR_2] Shl STATE_LASER, animationRect[STATE_FIRST_DEFENCE] Shl STATE_LASER)
							bodyRect.setRotate(nodeInfo.degree, ((-animationRect[0]) + (nodeInfo.rotateX - nodeInfo.animationX)) Shl STATE_LASER..((-animationRect[STATE_APPEAR_1]) + (nodeInfo.rotateY - nodeInfo.animationY)) Shl STATE_LASER)
							
							If (bodyRect.collisionChk(player.getCollisionRect())) Then
								If (i = STATE_APPEAR_1 And Self.damageCount = 0) Then
									Self.HP -= STATE_APPEAR_1
									
									If (Self.HP = 0) Then
										Self.state = STATE_DEAD
										Self.pyxAnimation.changeToAction(ANI_DEAD, 10)
										Self.pyxAnimation.setLoop(False)
										player.getBossScore()
										
										If (player instanceof PlayerSuperSonic) Then
											((PlayerSuperSonic) player).setBossDieFlag(True)
										EndIf
										
									Else
										Self.damageCount = 10
									EndIf
									
									player.doBossAttackPose(Self, STATE_APPEAR_2)
									Return
								EndIf
								
								Return
							EndIf
							
						Else
							continue
						EndIf
					EndIf
				EndIf
			EndIf
		End
End