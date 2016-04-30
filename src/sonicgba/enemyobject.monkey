Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	Import lib.coordinate
	Import lib.constutil
	
	Import sonicgba.aspiratebubble
	Import sonicgba.bat
	Import sonicgba.bee
	Import sonicgba.bonus100pts
	Import sonicgba.boom
	Import sonicgba.boss1
	Import sonicgba.boss1arm
	Import sonicgba.boss2
	Import sonicgba.boss2spring
	Import sonicgba.boss3
	Import sonicgba.boss4
	Import sonicgba.boss5
	Import sonicgba.boss6
	Import sonicgba.bossbroken
	Import sonicgba.bossextra
	Import sonicgba.bossf1
	Import sonicgba.bossf2
	Import sonicgba.bossf3
	Import sonicgba.breakingparts
	Import sonicgba.caterpillar
	Import sonicgba.cement
	Import sonicgba.chameleon
	Import sonicgba.clown
	Import sonicgba.collisionblock
	Import sonicgba.crab
	Import sonicgba.effect
	Import sonicgba.fish
	Import sonicgba.frog
	Import sonicgba.gameobject
	Import sonicgba.globalresource
	Import sonicgba.heriko
	Import sonicgba.ladybug
	Import sonicgba.lizard
	Import sonicgba.magma
	Import sonicgba.mapmanager
	Import sonicgba.mira
	Import sonicgba.mole
	Import sonicgba.monkeyobject
	Import sonicgba.motor
	Import sonicgba.penguin
	Import sonicgba.playeramy
	Import sonicgba.playerobject
	Import sonicgba.playertails
	Import sonicgba.proboss1
	Import sonicgba.rabbitfish
	Import sonicgba.smallanimal
	Import sonicgba.snowroboth
	Import sonicgba.snowrobotv
	
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	
	'Import com.sega.mobile.define.mdphone
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	'Import regal.util
Public

' Classes:
Class EnemyObject Extends GameObject Abstract
	Private
		' Global variable(s):
		Global magmaEnable:Bool = False
		
		' Fields:
		Field currentBlock:CollisionBlock
		
		Field objId:Int
		Field faceDegree:Int
	Protected
		' Constant variable(s):
		Const ENEMY_RES_PATH:String = "/enemy"
	Public
		' Constant variable(s):
		Const ENEMY_100PTS:Int = 39
		Const ENEMY_ASPIRATE_BUBBLE:Int = 40
		Const ENEMY_BAT:Int = 9
		Const ENEMY_BEE:Int = 1
		Const ENEMY_BOOM:Int = 37
		Const ENEMY_BOSS1_ARM:Int = 31
		Const ENEMY_BOSS2_SPRING:Int = 32
		Const ENEMY_BOSS3_HARDBASE:Int = 35
		Const ENEMY_BOSS3_SHADOW:Int = 34
		Const ENEMY_BOSS5_FLYDEFENCE:Int = 33
		Const ENEMY_BREAKING_PARTS:Int = 38
		Const ENEMY_CATERPILLAR:Int = 13
		Const ENEMY_CHAMELEON:Int = 11
		Const ENEMY_CLOWN:Int = 10
		Const ENEMY_CRAB:Int = 2
		Const ENEMY_DORISAME:Int = 18
		Const ENEMY_DROWN_BUBBLE:Int = 41
		Const ENEMY_FROG:Int = 4
		Const ENEMY_HERIKO:Int = 14
		Const ENEMY_KORA:Int = 19
		Const ENEMY_LADYBUG:Int = 6
		Const ENEMY_LIZARD:Int = 8
		Const ENEMY_MAGMA:Int = 7
		Const ENEMY_MIRA:Int = 12
		Const ENEMY_MOLE:Int = 15
		Const ENEMY_MONKEY:Int = 0
		Const ENEMY_MOTOR:Int = 3
		Const ENEMY_PEN:Int = 20
		Const ENEMY_RABBIT_FISH:Int = 5
		Const ENEMY_YOKOYUKIMAL:Int = 17
		Const ENEMY_YUKIMAL:Int = 16
		
		Const ENEMY_PROBOSS1:Int = 21
		Const ENEMY_BOSS1:Int = 22
		Const ENEMY_BOSS2:Int = 23
		Const ENEMY_BOSS3:Int = 24
		Const ENEMY_BOSS4:Int = 25
		Const ENEMY_BOSS5:Int = 26
		Const ENEMY_BOSS6:Int = 27
		
		Const ENEMY_BOSSF1:Int = 28
		Const ENEMY_BOSSF2:Int = 29
		Const ENEMY_BOSSF3:Int = 30
		
		Const ENEMY_BOSS_EXTRA:Int = 36
	Protected
		' Constant variable(s):
		Const POS_TOP:Int = 0
		Const POS_BOTTOM:Int = 1
		Const POS_LEFT:Int = 2
		Const POS_RIGHT:Int = 3
		
		' Global variable(s):
		Global BoomAni:Animation = Null
		Global snowrobotAnimation:Animation = Null
		
		' Fields:
		Field iLeft:Int
		Field iTop:Int
		
		Field drawer:AnimationDrawer
		
		Field dead:Bool
		Field IsPlayBossBattleBGM:Bool
	Public
		' Constant variable(s):
		Const IN_ALERT_RANGE:Int = 0
		Const IN_AVAILABLE_RANGE:Int = 1
		Const CANNOT_BE_SEEN:Int = 2
		
		' Global variable(s):
		Global IsBoss:Bool = False
		Global isBossEnter:Bool = False
		
		' Fields:
		Field layer:Int
		
		' Functions:
		Function getNewInstance:EnemyObject(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			IsBoss = False
			
			Select (id)
				Case ENEMY_BEE
					If (GlobalResource.isEasyMode() And stageModeState = STATE_NORMAL_MODE) Then
						Return Null
					EndIf
					
					Return New Bee(id, x, y, left, top, width, height)
				Case ENEMY_FROG
					Return New Frog(id, x, y, left, top, width, height)
				Case ENEMY_RABBIT_FISH
					If (GlobalResource.isEasyMode() And stageModeState = STATE_NORMAL_MODE) Then
						Return Null
					EndIf
					
					Return New RabbitFish(id, x, y, left, top, width, height)
				Case ENEMY_LADYBUG
					Return New LadyBug(id, x, y, left, top, width, height)
				Case ENEMY_MAGMA
					magmaEnable = True
					
					Return New Magma(id, x, y, left, top, width, height)
				Case ENEMY_MOLE
					Return New Mole(id, x, y, left, top, width, height)
				Case ENEMY_BOSS2
					IsBoss = True
					
					Return New Boss2(id, x, y, left, top, width, height)
				Default
					Select (id)
						Case ENEMY_MONKEY
							Return New Monkey(id, x, y, left, top, width, height)
						Case ENEMY_CRAB
							Return New Crab(id, x, y, left, top, width, height)
						Case ENEMY_MOTOR
							Return New Motor(id, x, y, left, top, width, height)
						Case ENEMY_LIZARD
							Return New Lizard(id, x, y, left, top, width, height)
						Case ENEMY_BAT
							If (GlobalResource.isEasyMode() And stageModeState = STATE_NORMAL_MODE) Then
								Return Null
							EndIf
							
							Return New Bat(id, x, y, left, top, width, height)
						Case ENEMY_CLOWN
							Return New Clown(id, x, y, left, top, width, height)
						Case ENEMY_CATERPILLAR
							Return New Caterpillar(id, x, y, left, top, width, height)
						Case ENEMY_PROBOSS1
							Return New ProBoss1(id, x, y, left, top, width, height)
						Case ENEMY_BOSS1
							IsBoss = True
							
							Return New Boss1(id, x, y, left, top, width, height)
						Case ENEMY_BOSS3
							IsBoss = True
							
							Return New Boss3(id, x, y, left, top, width, height)
						Case ENEMY_BOSS5
							IsBoss = True
							
							Return New Boss5(id, x, y, left, top, width, height)
						Default
							Select (id)
								Case ENEMY_CHAMELEON
									If (GlobalResource.isEasyMode() And stageModeState = STATE_NORMAL_MODE) Then
										Return Null
									EndIf
									
									Return New Chameleon(id, x, y, left, top, width, height)
								Case ENEMY_MIRA
									If (GlobalResource.isEasyMode() And stageModeState = STATE_NORMAL_MODE) Then
										Return Null
									EndIf
									
									Return New Mira(id, x, y, left, top, width, height)
								Case ENEMY_HERIKO
									Return New Heriko(id, x, y, left, top, width, height)
								Case ENEMY_YUKIMAL
									Return New SnowRobotH(id, x, y, left, top, width, height)
								Case ENEMY_YOKOYUKIMAL
									Return New SnowRobotV(id, x, y, left, top, width, height)
								Case ENEMY_DORISAME
									Return New Fish(id, x, y, left, top, width, height)
								Case ENEMY_KORA
									Return New Cement(id, x, y, left, top, width, height)
								Case ENEMY_PEN
									If (GlobalResource.isEasyMode() And stageModeState = STATE_NORMAL_MODE) Then
										Return Null
									EndIf
									
									Return New Penguin(id, x, y, left, top, width, height)
								Case ENEMY_BOSS4
									IsBoss = True
									
									Return New Boss4(id, x, y, left, top, width, height)
								Case ENEMY_BOSS5
									IsBoss = True
									
									Return New Boss2(id, x, y, left, top, width, height)
								Case ENEMY_BOSS6
									IsBoss = True
									
									Return New Boss6(id, x, y, left, top, width, height)
								Case ENEMY_BOSSF1
									IsBoss = True
									
									Return New BossF1(id, x, y, left, top, width, height)
								Case ENEMY_BOSSF2
									IsBoss = True
									
									Return New BossF2(id, x, y, left, top, width, height)
								Case ENEMY_BOSSF3
									IsBoss = True
									
									Return New BossF3(id, x, y, left, top, width, height)
								Case ENEMY_BOSS_EXTRA
									IsBoss = True
									
									Return New BossExtra(id, x, y, left, top, width, height)
								Default
									Return Null
							End Select
					End Select
			End Select
		End
		
		Function releaseAllEnemyResource:Void()
			Bee.releaseAllResource()
			Frog.releaseAllResource()
			RabbitFish.releaseAllResource()
			LadyBug.releaseAllResource()
			Magma.releaseAllResource()
			Mole.releaseAllResource()
			Motor.releaseAllResource()
			Monkey.releaseAllResource()
			Crab.releaseAllResource()
			Clown.releaseAllResource()
			Caterpillar.releaseAllResource()
			Bat.releaseAllResource()
			Lizard.releaseAllResource()
			Chameleon.releaseAllResource()
			Mira.releaseAllResource()
			Heriko.releaseAllResource()
			SnowRobotH.releaseAllResource()
			SnowRobotV.releaseAllResource()
			Fish.releaseAllResource()
			Cement.releaseAllResource()
			Penguin.releaseAllResource()
			
			BossBroken.releaseAllResource()
			Boss1.releaseAllResource()
			Boss1Arm.releaseAllResource()
			Boss2.releaseAllResource()
			Boss2Spring.releaseAllResource()
			Boss3.releaseAllResource()
			Boss4.releaseAllResource()
			Boss5.releaseAllResource()
			
			Boss6.releaseAllResource()
			
			ProBoss1.releaseAllResource()
			
			'''BossF1.releaseAllResource()
			'''BossF2.releaseAllResource()
			'''BossF3.releaseAllResource()
			
			Boom.releaseAllResource()
			BreakingParts.releaseAllResource()
			Bonus100pts.releaseAllResource()
			AspirateBubble.releaseAllResource()
		End
		
		Function enemyinit:Void()
			magmaEnable = False
		End
		
		Function enemyStaticLogic:Void()
			If (magmaEnable) Then
				Magma.staticlogic()
			EndIf
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Self.objId = id
			
			Self.posX = (x Shl 6)
			Self.posY = (y Shl 6)
			
			Self.iLeft = (left Shl 6)
			Self.iTop = (top Shl 6)
			
			Self.mWidth = ((width * 8) Shl 6)
			Self.mHeight = ((height * 8) Shl 6)
			
			Self.posX += (Self.iLeft * 8)
			Self.posY += (Self.iTop * 8)
			
			If (width < height) Then
				If (width = 0) Then
					Self.layer = 0
				Else
					Self.layer = 1
				EndIf
			ElseIf (height = 0) Then
				Self.layer = 0
			Else
				Self.layer = 1
			EndIf
			
			Self.IsPlayBossBattleBGM = False
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
	Public
		' Methods:
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method draw:Void(g:MFGraphics)
			Local camera:= MapManager.getCamera()
			
			g.setColor(65280)
			
			g.drawRect(Self.posX - camera.x, Self.posY - camera.y, Self.mWidth, Self.mHeight)
			g.drawRect((Self.posX + POS_BOTTOM) - camera.x, (Self.posY + POS_BOTTOM) - camera.y, Self.mWidth - POS_LEFT, Self.mHeight - POS_LEFT)
			
			g.setColor(0)
			
			g.drawString("ID:" + Self.objId + ";iLeft:" + Self.iLeft + ";iTop:" + Self.iTop, (Self.posX - camera.x) - POS_BOTTOM, (Self.posY - camera.y) - POS_BOTTOM, ENEMY_BOSS_EXTRA)
			g.drawString("ID:" + Self.objId + ";iLeft:" + Self.iLeft + ";iTop:" + Self.iTop, (Self.posX - camera.x) + POS_BOTTOM, (Self.posY - camera.y) - POS_BOTTOM, ENEMY_BOSS_EXTRA)
			g.drawString("ID:" + Self.objId + ";iLeft:" + Self.iLeft + ";iTop:" + Self.iTop, Self.posX - camera.x, ((Self.posY - camera.y) - POS_BOTTOM) - POS_BOTTOM, ENEMY_BOSS_EXTRA)
			g.drawString("ID:" + Self.objId + ";iLeft:" + Self.iLeft + ";iTop:" + Self.iTop, Self.posX - camera.x, ((Self.posY - camera.y) - POS_BOTTOM) + POS_BOTTOM, ENEMY_BOSS_EXTRA)
			
			g.setColor(16776960)
			
			g.drawString("ID:" + Self.objId + ";iLeft:" + Self.iLeft + ";iTop:" + Self.iTop, Self.posX - camera.x, (Self.posY - camera.y) - POS_BOTTOM, ENEMY_BOSS_EXTRA)
		End
		
		Method beAttack:Void()
			If (Not Self.dead) Then
				Self.dead = True
				
				Effect.showEffect(destroyEffectAnimation, 0, (Self.posX Shr 6), (Self.posY Shr 6) - 10, 0)
				
				If (Self.objId = ENEMY_LADYBUG Or Self.objId = ENEMY_HERIKO) Then
					SmallAnimal.addAnimal(Self.posX, Self.posY, getLayer(), True)
				Else
					SmallAnimal.addAnimal(Self.posX, Self.posY, getLayer())
				EndIf
				
				player.getEnemyScore()
				
				soundInstance.playSe(SoundSystem.SE_138)
				
				GameObject.addGameObject(New Bonus100pts(ENEMY_100PTS, Self.posX, Self.posY - (Bonus100pts.COLLISION_HEIGHT * 10), 0, 0, 0, 0))
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (Not Self.dead) Then
				If ((player.getCharacterID() = CHARACTER_AMY) And (player.getCharacterAnimationID() < 6 Or player.getCharacterAnimationID() > 8)) Then
					player.setVelY(PickValue(player.isAntiGravity, -1, 1) * PlayerObject.MIN_ATTACK_JUMP)
				EndIf
				
				If ((player.getCharacterID() = CHARACTER_TAILS) And player.myAnimationID = ENEMY_MIRA And direction = DIRECTION_DOWN) Then
					player.velY = -600
				EndIf
			EndIf
			
			beAttack()
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.dead Or p <> player) Then
				Return
			EndIf
			
			If (p.isAttackingEnemy()) Then
				p.doAttackPose(Self, direction)
				
				beAttack()
				
				Return
			EndIf
			
			p.beHurt()
		End
		
		Method getLayer:Int()
			Return player.currentLayer
		End
		
		Method drawPatrolRect:Void(g:MFGraphics, x:Int, y:Int, w:Int, h:Int)
			g.setColor(16711680)
			g.drawRect(((x Shr 6) - camera.x), ((y Shr 6) - camera.y), (w Shr 6), (h Shr 6))
		End
		
		Method checkPlayerInEnemyAlertRange:Int(currentX:Int, currentY:Int, range:Int)
			range Shr= 6
			
			Local src_distance:= ((currentX - (player.getCheckPositionX() Shr 6)) * (currentX - (player.getCheckPositionX() Shr 6))) + ((currentY - (player.getCheckPositionY() Shr 6)) * (currentY - (player.getCheckPositionY() Shr 6)))
			Local range_distance:= (range * range) ' Sq(range)
			
			If (src_distance <= range_distance) Then
				Return IN_ALERT_RANGE
			EndIf
			
			If (src_distance <= range_distance Or src_distance > (range_distance * 6)) Then
				Return CANNOT_BE_SEEN
			EndIf
			
			Return IN_AVAILABLE_RANGE
		End
		
		Method checkPlayerInEnemyAlertRange:Int(currentX:Int, currentY:Int, range_width:Int, range_height:Int)
			Local range_x:= Abs(currentX - (player.getFootPositionX() Shr 6))
			Local range_y:= Abs(currentY - (player.getFootPositionY() Shr 6))
			
			If (range_x <= range_width And range_y <= range_height) Then
				Return IN_ALERT_RANGE
			EndIf
			
			If (range_x > (range_width * 2) Or range_y > (range_height * 2)) Then
				Return CANNOT_BE_SEEN
			EndIf
			
			Return IN_AVAILABLE_RANGE
		End
		
		Method checkPlayerInEnemyAlertRangeScale:Bool(currentX:Int, currentY:Int, min:Int, max:Int)
			Local range_x:= Abs(currentX - (player.getFootPositionX() Shr 6))
			Local range_y:= Abs(currentY - (player.getFootPositionY() Shr 6))
			
			If (range_x = 0) Then
				Return False
			EndIf
			
			Local scale:= ((range_y * 100) / range_x)
			
			Return (scale >= min And scale <= max)
		End
		
		Method checkPlayerInEnemyAlertRange:Int(currentX:Int, currentY:Int, range:Int, limitMinx:Int, limitMaxX:Int, enemywidth:Int)
			Local src_distance:= ((currentX - (player.getFootPositionX() Shr 6)) * (currentX - (player.getFootPositionX() Shr 6))) + ((currentY - (player.getFootPositionY() Shr 6)) * (currentY - (player.getFootPositionY() Shr 6)))
			Local range_distance:= (range * range)
			
			If ((player.getFootPositionX() Shr 6) > (limitMinx - (enemywidth / 2)) - 8 And (player.getFootPositionX() Shr 6) < ((enemywidth / 2) + limitMaxX) + 8 And (player.getFootPositionY() Shr 6) <= currentY + ENEMY_CHAMELEON And (player.getFootPositionY() Shr 6) >= currentY - 44 And src_distance <= range_distance) Then ' Shr 1
				Return IN_ALERT_RANGE
			EndIf
			
			If (((player.getFootPositionX() Shr 6) > (limitMinx - (enemywidth / 2)) - 8 Or (player.getFootPositionX() Shr 6) < limitMinx - (enemywidth * 2)) And ((player.getFootPositionX() Shr 6) < ((enemywidth / 2) + limitMaxX) + 8 Or (player.getFootPositionX() Shr 6) > (enemywidth * 2) + limitMinx)) Then ' Shr 1
				Return CANNOT_BE_SEEN
			EndIf
			
			Return IN_AVAILABLE_RANGE
		End
		
		Method checkPlayerInEnemyAlertRange:Int(currentX:Int, currentY:Int, range_width:Int, range_height:Int, limitMinx:Int, limitMaxX:Int, enemywidth:Int)
			Local range_x:= Abs(currentX - (player.getFootPositionX() Shr 6))
			Local range_y:= Abs(currentY - (player.getFootPositionY() Shr 6))
			
			If ((player.getFootPositionX() Shr 6) > (limitMinx - (enemywidth / 2)) - 8 And (player.getFootPositionX() Shr 6) < ((enemywidth / 2) + limitMaxX) + 8 And range_x <= range_width And range_y <= range_height) Then ' Shr 1
				Return IN_ALERT_RANGE
			EndIf
			
			If (range_x > (range_width * 2) Or range_y > (range_height * 2)) Then
				Return CANNOT_BE_SEEN
			EndIf
			
			Return IN_AVAILABLE_RANGE
		End
		
		Method drawAlertRangeLine:Void(g:MFGraphics, state:Int, currentX:Int, currentY:Int, camera:Coordinate)
			Select (state)
				Case 0
					g.setColor(16711680)
					
					g.drawLine((player.getFootPositionX() Shr 6) - camera.x, (player.getFootPositionY() Shr 6) - camera.y, currentX - camera.x, currentY - camera.y)
				Case 1
					g.setColor(65280)
					
					g.drawLine((player.getFootPositionX() Shr 6) - camera.x, (player.getFootPositionY() Shr 6) - camera.y, currentX - camera.x, currentY - camera.y)
				Default
					' Nothing so far.
			End Select
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
End