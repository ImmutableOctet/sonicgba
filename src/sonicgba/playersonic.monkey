Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	Import lib.coordinate
	Import lib.constutil
	
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	Import sonicgba.playeranimationcollisionrect
	Import sonicgba.playerobject
	Import sonicgba.sonicdebug
	Import sonicgba.stagemanager
	
	Import com.sega.engine.action.acworldcollisioncalculator
	
	Import com.sega.engine.lib.myapi
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class PlayerSonic Extends PlayerObject
	Public
		' Constant variable(s):
		Const ATTACK_COUNT_LEVEL_1:Int = 6
		Const ATTACK_COUNT_LEVEL_2:Int = 12
		
		Const BACK_JUMP_SPEED_X:Int = 384
		
		Const SONIC_ANI_ATTACK_1:Int = 13
		Const SONIC_ANI_ATTACK_2:Int = 14
		Const SONIC_ANI_ATTACK_3:Int = 15
		Const SONIC_ANI_ATTACK_4:Int = 16
		Const SONIC_ANI_BANK_1:Int = 44
		Const SONIC_ANI_BANK_2:Int = 45
		Const SONIC_ANI_BANK_3:Int = 46
		Const SONIC_ANI_BAR_MOVE:Int = 42
		Const SONIC_ANI_BAR_STAY:Int = 41
		Const SONIC_ANI_BRAKE:Int = 54
		Const SONIC_ANI_BREATHE:Int = 51
		Const SONIC_ANI_CAUGHT:Int = 57
		Const SONIC_ANI_CELEBRATE_1:Int = 47
		Const SONIC_ANI_CELEBRATE_2:Int = 48
		Const SONIC_ANI_CELEBRATE_3:Int = 49
		Const SONIC_ANI_CLIFF_1:Int = 36
		Const SONIC_ANI_CLIFF_2:Int = 37
		Const SONIC_ANI_DEAD_1:Int = 29
		Const SONIC_ANI_DEAD_2:Int = 30
		Const SONIC_ANI_ENTER_SP:Int = 53
		Const SONIC_ANI_HURT_1:Int = 27
		Const SONIC_ANI_HURT_2:Int = 28
		Const SONIC_ANI_JUMP:Int = 4
		Const SONIC_ANI_JUMP_ATTACK_BODY:Int = 11
		Const SONIC_ANI_JUMP_ATTACK_EFFECT:Int = 12
		Const SONIC_ANI_JUMP_DASH_1:Int = 17
		Const SONIC_ANI_JUMP_DASH_2:Int = 18
		Const SONIC_ANI_LOOK_UP_1:Int = 7
		Const SONIC_ANI_LOOK_UP_2:Int = 8
		Const SONIC_ANI_POLE_H:Int = 40
		Const SONIC_ANI_POLE_V:Int = 39
		Const SONIC_ANI_PUSH_WALL:Int = 31
		Const SONIC_ANI_RAIL_BODY:Int = 52
		Const SONIC_ANI_ROLL_H_1:Int = 34
		Const SONIC_ANI_ROLL_H_2:Int = 35
		Const SONIC_ANI_ROLL_V_1:Int = 32
		Const SONIC_ANI_ROLL_V_2:Int = 33
		Const SONIC_ANI_RUN:Int = 3
		Const SONIC_ANI_SLIDE_D0:Int = 24
		Const SONIC_ANI_SLIDE_D45:Int = 25
		Const SONIC_ANI_SLIDE_D45_EFFECT:Int = 26
		Const SONIC_ANI_SPIN_1:Int = 5
		Const SONIC_ANI_SPIN_2:Int = 6
		Const SONIC_ANI_SPRING_1:Int = 19
		Const SONIC_ANI_SPRING_2:Int = 20
		Const SONIC_ANI_SPRING_3:Int = 21
		Const SONIC_ANI_SPRING_4:Int = 22
		Const SONIC_ANI_SPRING_5:Int = 23
		Const SONIC_ANI_SQUAT_1:Int = 9
		Const SONIC_ANI_SQUAT_2:Int = 10
		Const SONIC_ANI_STAND:Int = 0
		Const SONIC_ANI_UP_ARM:Int = 38
		Const SONIC_ANI_VS_KNUCKLE:Int = 50
		Const SONIC_ANI_WAITING_1:Int = 55
		Const SONIC_ANI_WAITING_2:Int = 56
		Const SONIC_ANI_WALK_1:Int = 1
		Const SONIC_ANI_WALK_2:Int = 2
		Const SONIC_ANI_WIND:Int = 43
		
		Const SONIC_ATTACK_LEVEL_1_V0_IN_WATER:Int = 650
		Const SONIC_ATTACK_LEVEL_2_V0_IN_WATER:Int = 1036
		Const SONIC_ATTACK_LEVEL_3_V0_IN_WATER:Int = 1620
	Private
		' Constant variable(s):
		Const AIR_DASH_TIME_COUNT:Int = 5
		
		Global ATTACK4_ISINWATER_JUMP_START_V:Int = (-1354 - GRAVITY) ' Const
		Global ATTACK4_JUMP_START_V:Int = (-1188 - GRAVITY) ' Const
		
		Const EFFECT_NONE:Int = 0
		Const EFFECT_JUMP:Int = 1
		Const EFFECT_SLIP:Int = 2
		
		Const LOOP:Int = -1
		Const NO_ANIMATION:Int = -1
		Const NO_LOOP:Int = -2
		Const NO_LOOP_DEPAND:Int = -3
		
		Const SNOW_DIVIDE_COUNT:Int = 70
		
		Const SUPER_SONIC_ANI_LOOK_MOON:Int = 0
		Const SUPER_SONIC_ANI_CHANGE_1:Int = 1
		Const SUPER_SONIC_ANI_CHANGE_2:Int = 2
		Const SUPER_SONIC_ANI_GO:Int = 3
		
		Global ANIMATION_CONVERT:Int[] = [0, 1, 2, 3, 4, 10, 5, 6, 31, 19, 23, -1, 28, 39, 20, -1, -1, 54, -1, -1, -1, 52, 34, 35, 38, 32, 33, 41, 42, 43, 28, 40, 44, 45, 46, 47, 48, 49, 7, 8, 7, 30, 21, 22, 28, 29, 9, 36, 37, 51, 55, 56, 57, 50] ' Const
		Global LOOP_INDEX:Int[] = [-1, -1, -1, -1, -1, -1, -1, 8, -1, -3, -1, 4, -2, -1, -2, -1, -1, 18, -1, 22, -1, 22, 23, -1, -1, -1, -1, 28, -1, 30, -1, -1, 33, 32, 35, 34, -1, -1, -1, 20, 3, -1, -1, -1, -1, -1, -1, 48, -1, -2, 0, -2, -1, -1, -1, 56, -1, -1, 0] ' Const
		Global SUPER_SONIC_LOOP:Bool[] = [False, False, True, True] ' Const
		
		' Fields:
		Field sonic_effectID:Int
		
		Field attackRect:PlayerAnimationCollisionRect
		
		Field sonic_effectDrawer:AnimationDrawer
		
		Field SuperSonicDrawer:AnimationDrawer
		
		Field sonic_attackCount:Int
		Field sonic_attackLevel:Int
		
		Field leftCount:Int
		Field rightCount:Int
		
		Field SuperSonicAnimationID:Int
		
		Field firstJump:Bool
		Field isFirstAttack:Bool
		Field jumpRollEnable:Bool
	Public
		' Constructor(s):
		Method New()
			Self.firstJump = False
			
			Local animation:= New Animation("/animation/player/chr_sonic")
			
			Self.drawer = animation.getDrawer()
			Self.sonic_effectDrawer = animation.getDrawer()
			
			Self.attackRect = New PlayerAnimationCollisionRect(Self)
			
			If (StageManager.getStageID() = 12) Then
				Self.SuperSonicDrawer = New Animation("/animation/player/chr_Super.sonic").getDrawer()
			EndIf
		End
		
		' Methods:
		Method closeImpl:Void()
			Animation.closeAnimationDrawer(Self.SuperSonicDrawer)
			Self.SuperSonicDrawer = Null
			
			Animation.closeAnimationDrawer(Self.sonic_effectDrawer)
			Self.sonic_effectDrawer = Null
		End
		
		Method slipStart:Void()
			Self.currentLayer = 0
			
			Self.slipping = True
			Self.slideSoundStart = True
			
			soundInstance.playSe(SoundSystem.SE_114_01)
			
			slidingFrame = SONIC_ANI_STAND
			
			Self.collisionState = COLLISION_STATE_JUMP
			Self.worldCal.actionState = ACWorldCollisionCalculator.JUMP_ACTION_STATE
			
			setMinSlipSpeed()
			
			Self.worldCal.setMovedState(True)
		End
		
		Method slipJumpOut:Void()
			If (Self.slipping) Then
				Self.currentLayer = 1
				
				Self.slipping = False
				
				calDivideVelocity()
				
				setVelY(PickValue(Self.isInWater, JUMP_INWATER_START_VELOCITY, JUMP_START_VELOCITY))
				
				Self.collisionState = COLLISION_STATE_JUMP
				Self.worldCal.actionState = ACWorldCollisionCalculator.JUMP_ACTION_STATE
				
				Self.collisionChkBreak = True
				
				Self.worldCal.stopMove()
				
				Self.worldCal.setMovedState(False)
			EndIf
		End
		
		Method slipEnd:Void()
			If (Self.slipping) Then
				Self.currentLayer = 1
				
				Self.slipping = False
				
				calDivideVelocity()
				
				Self.collisionState = COLLISION_STATE_JUMP
				Self.worldCal.actionState = ACWorldCollisionCalculator.JUMP_ACTION_STATE
				
				Self.velY = -1540
				Self.animationID = SONIC_ANI_SQUAT_1
				
				Self.collisionChkBreak = True
				
				Self.worldCal.stopMove()
				
				soundInstance.stopLoopSe()
				soundInstance.playSequenceSe(SoundSystem.SE_116)
				
				Self.worldCal.setMovedState(False)
			EndIf
		End
		
		Method setSlideAni:Void()
			Self.animationID = NO_ANIMATION
			Self.myAnimationID = SONIC_ANI_SLIDE_D0
		End
		
		Method isOnSlip0:Bool()
			Return (Self.myAnimationID = SONIC_ANI_SLIDE_D0)
		End
		
		Method setSlip0:Void()
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = SONIC_ANI_SLIDE_D0
			EndIf
			
			setMinSlipSpeed()
		End
		
		Method doJump:Void()
			If (Self.myAnimationID <> SONIC_ANI_ATTACK_1 And Self.myAnimationID <> SONIC_ANI_ATTACK_2 And Self.myAnimationID <> SONIC_ANI_ATTACK_3) Then
				If (Self.slipping) Then
					If (Not isHeadCollision()) Then
						Self.currentLayer = 1
					Else
						Return
					EndIf
				EndIf
				
				' Magic number: 192
				If (Self.slipping And Self.totalVelocity = 192) Then
					Super.doJumpV()
				Else
					Super.doJump()
				EndIf
				
				Self.leftCount = 0
				Self.rightCount = 0
				
				Self.jumpRollEnable = False
				
				If (Self.slipping) Then
					Self.currentLayer = 1
					
					Self.slipping = False
				EndIf
				
				Self.firstJump = True
				
				If (Self.bankwalking) Then
					Self.firstJump = False
				EndIf
			EndIf
		End
		
		Method doHurt:Void()
			Super.doHurt()
			
			If (Self.slipping) Then
				Self.currentLayer = 1
				Self.slipping = False
			EndIf
		End
		
		Method drawCharacter:Void(g:MFGraphics)
			Local camera:= MapManager.getCamera()
			
			If (isTerminal And terminalType = TER_STATE_LOOK_MOON_WAIT And terminalState >= TER_STATE_LOOK_MOON) Then
				Select (terminalState)
					Case TER_STATE_LOOK_MOON, TER_STATE_LOOK_MOON_WAIT
						Self.SuperSonicAnimationID = 0
					Case TER_STATE_CHANGE_1, TER_STATE_CHANGE_2
						If (Not (Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_1 Or Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_2)) Then
							Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_1
						EndIf
					Case TER_STATE_GO_AWAY
						Self.SuperSonicAnimationID = SUPER_SONIC_ANI_GO
				End Select
				
				Self.SuperSonicDrawer.setActionId(Self.SuperSonicAnimationID)
				Self.SuperSonicDrawer.setLoop(SUPER_SONIC_LOOP[Self.SuperSonicAnimationID])
				
				drawInMap(g, Self.SuperSonicDrawer, Self.posX + Self.terminalOffset, Self.posY)
				
				If (Self.SuperSonicDrawer.checkEnd()) Then
					Select (Self.SuperSonicAnimationID)
						Case SUPER_SONIC_ANI_CHANGE_1
							Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_2
						Default
							' Nothing so far.
					End Select
				EndIf
				
				Return
			EndIf
			
			If (Self.animationID <> NO_ANIMATION) Then
				Self.myAnimationID = ANIMATION_CONVERT[Self.animationID]
			EndIf
			
			If (Self.myAnimationID <> NO_ANIMATION) Then
				Local trans:Int
				Local drawY:Int
				
				Local rect:Byte[]
				
				Local loop:Bool = (LOOP_INDEX[Self.myAnimationID] = NO_ANIMATION)
				
				' I'm pretty sure this is to make the sprite flash when hurt:
				If ((Self.hurtCount Mod 2) = 0) Then
					Local bodyCenterX:Int
					Local bodyCenterY:Int
					
					If (Self.animationID <> SONIC_ANI_JUMP) Then
						If (Self.animationID <> SONIC_ANI_SPIN_2 And Self.animationID <> SONIC_ANI_LOOK_UP_1) Then
							Select (Self.myAnimationID)
								Case SONIC_ANI_SLIDE_D0
									Self.drawer.draw(g, Self.myAnimationID, ((Self.footPointX Shr 6) - camera.x), ((Self.footPointY Shr 6) - camera.y), loop, 0)
									
									If (Not Self.isInWater) Then
										Self.sonic_effectDrawer.setSpeed(1, 1) ' EFFECT_JUMP
									Else
										Self.sonic_effectDrawer.setSpeed(1, 2) ' EFFECT_JUMP ' EFFECT_SLIP
									EndIf
								Case SONIC_ANI_SLIDE_D45
									Self.sonic_effectDrawer.draw(g, SONIC_ANI_SLIDE_D45_EFFECT, ((Self.footPointX Shr 6) - camera.x) + 8, ((Self.footPointY Shr 6) - camera.y), loop, 0)
									
									Self.drawer.draw(g, Self.myAnimationID, ((Self.footPointX Shr 6) - camera.x) + 8, ((Self.footPointY Shr 6) - camera.y), loop, 0)
									
									If (Not Self.isInWater) Then
										Self.sonic_effectDrawer.setSpeed(1, 1) ' EFFECT_JUMP
									Else
										Self.sonic_effectDrawer.setSpeed(1, 2) ' EFFECT_JUMP ' EFFECT_SLIP
									EndIf
								Default
									If (Self.isInWater) Then
										Self.drawer.setSpeed(1, 2) ' EFFECT_JUMP ' EFFECT_SLIP
									Else
										Self.drawer.setSpeed(1, 1) ' EFFECT_JUMP
									EndIf
									
									If (Self.myAnimationID = SONIC_ANI_CLIFF_1 Or Self.myAnimationID = SONIC_ANI_CLIFF_2 Or Self.myAnimationID = SONIC_ANI_LOOK_UP_1 Or Self.myAnimationID = SONIC_ANI_LOOK_UP_2) Then
										Self.degreeForDraw = Self.degreeStable
										Self.faceDegree = Self.degreeStable
									EndIf
									
									If (Self.myAnimationID = SONIC_ANI_BRAKE) Then
										Self.degreeForDraw = Self.degreeStable
									EndIf
									
									If (Not (Self.myAnimationID = SONIC_ANI_WALK_1 Or Self.myAnimationID = SONIC_ANI_WALK_2 Or Self.myAnimationID = SONIC_ANI_RUN Or Self.myAnimationID = SONIC_ANI_CAUGHT)) Then
										Self.degreeForDraw = Self.degreeStable
									EndIf
									
									If (Self.fallinSandSlipState <> FALL_IN_SAND_SLIP_NONE) Then
										If (Self.fallinSandSlipState = FALL_IN_SAND_SLIP_RIGHT) Then
											Self.faceDirection = True
										ElseIf (Self.fallinSandSlipState = FALL_IN_SAND_SLIP_LEFT) Then
											Self.faceDirection = False
										EndIf
									EndIf
									
									If (Self.faceDirection) Then
										trans = TRANS_NONE
									Else
										trans = TRANS_MIRROR
									EndIf
									
									If (Self.degreeForDraw = Self.faceDegree) Then
										drawDrawerByDegree(g, Self.drawer, Self.myAnimationID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, loop, Self.degreeForDraw, Not Self.faceDirection)
									Else
										bodyCenterX = getNewPointX(Self.footPointX, 0, (-Self.collisionRect.getHeight()) Shr 1, Self.faceDegree)
										bodyCenterY = getNewPointY(Self.footPointY, 0, (-Self.collisionRect.getHeight()) Shr 1, Self.faceDegree)
										
										g.saveCanvas()
										
										g.translateCanvas((bodyCenterX Shr 6) - camera.x, (bodyCenterY Shr 6) - camera.y)
										g.rotateCanvas(Float(Self.degreeForDraw))
										
										Self.drawer.draw(g, Self.myAnimationID, 0, (Self.collisionRect.getHeight() Shr 1) Shr 6, loop, trans)
										
										g.restoreCanvas()
									EndIf
							End Select
						EndIf
						
						drawDrawerByDegree(g, Self.drawer, Self.myAnimationID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, loop, Self.degreeForDraw, (Not Self.faceDirection))
					Else
						bodyCenterX = getNewPointX(Self.footPointX, 0, LEFT_WALK_COLLISION_CHECK_OFFSET_X, Self.faceDegree) ' -512
						bodyCenterY = getNewPointY(Self.footPointY, 0, LEFT_WALK_COLLISION_CHECK_OFFSET_Y, Self.faceDegree) ' -512
						
						Local drawX:= getNewPointX(bodyCenterX, 0, (HINER_JUMP_LIMIT / 2), 0) ' (WIDTH / 2) ' 512
						
						drawY = getNewPointY(bodyCenterY, 0, (HINER_JUMP_LIMIT / 2), 0) ' (BALL_HEIGHT_OFFSET / 2) ' 512
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If (Self.isAntiGravity) Then
								If (Self.faceDirection) Then
									trans = PickValue((Self.totalVelocity >= 0), TRANS_MIRROR|TRANS_MIRROR_ROT180, TRANS_MIRROR_ROT180)
									drawY -= BALL_HEIGHT_OFFSET ' HINER_JUMP_LIMIT
								Else
									trans = PickValue((Self.totalVelocity > 0), TRANS_MIRROR|TRANS_MIRROR_ROT180, TRANS_MIRROR_ROT180)
									drawY -= BALL_HEIGHT_OFFSET ' HINER_JUMP_LIMIT
								EndIf
							ElseIf (Self.faceDirection) Then
								trans = PickValue((Self.totalVelocity >= 0), TRANS_NONE, TRANS_MIRROR)
							Else
								trans = PickValue((Self.totalVelocity > 0), TRANS_NONE, TRANS_MIRROR)
							EndIf
						ElseIf (Self.isAntiGravity) Then
							If (Self.faceDirection) Then
								trans = PickValue((Self.velX <= 0), TRANS_MIRROR|TRANS_MIRROR_ROT180, TRANS_MIRROR_ROT180)
								drawY -= BALL_HEIGHT_OFFSET ' HINER_JUMP_LIMIT
							Else
								trans = PickValue((Self.velX < 0), TRANS_MIRROR|TRANS_MIRROR_ROT180, TRANS_MIRROR_ROT180)
								drawY -= BALL_HEIGHT_OFFSET ' HINER_JUMP_LIMIT
							EndIf
						ElseIf (Self.faceDirection) Then
							trans = PickValue((Self.velX >= 0), TRANS_NONE, TRANS_MIRROR)
						Else
							trans = PickValue((Self.velX > 0), TRANS_NONE, TRANS_MIRROR)
						EndIf
						
						Self.drawer.draw(g, Self.myAnimationID, (drawX Shr 6) - camera.x, (drawY Shr 6) - camera.y, loop, trans)
					EndIf
				Else
					If (Self.myAnimationID <> Self.drawer.getActionId()) Then
						Self.drawer.setActionId(Self.myAnimationID)
					EndIf
					
					If (Not AnimationDrawer.isAllPause()) Then
						Self.drawer.moveOn()
					EndIf
				EndIf
				
				Select (Self.sonic_effectID)
					Case EFFECT_JUMP
						drawY = 0
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If (Not Self.faceDirection) Then
								trans = PickValue((Self.totalVelocity > 0), TRANS_NONE, TRANS_MIRROR)
							ElseIf (Self.totalVelocity >= 0) Then
								trans = TRANS_NONE
							Else
								trans = TRANS_MIRROR
							EndIf
						ElseIf (Self.isAntiGravity) Then
							If (Self.faceDirection) Then
								trans = PickValue((Self.velX <= 0), TRANS_MIRROR_ROT180|TRANS_MIRROR, TRANS_MIRROR_ROT180)
								drawY = -BALL_HEIGHT_OFFSET ' HINER_JUMP_LIMIT
							Else
								trans = PickValue((Self.velX < 0), TRANS_MIRROR_ROT180|TRANS_MIRROR, TRANS_MIRROR_ROT180)
								drawY = -BALL_HEIGHT_OFFSET ' HINER_JUMP_LIMIT
							EndIf
						ElseIf (Self.faceDirection) Then
							trans = PickValue((Self.velX >= 0), TRANS_NONE, TRANS_MIRROR)
						Else
							trans = PickValue((Self.velX > 0), TRANS_NONE, TRANS_MIRROR)
						EndIf
						
						Self.sonic_effectDrawer.draw(g, SONIC_ANI_JUMP_ATTACK_EFFECT, (Self.posX Shr 6) - camera.x, (((Self.posY + PickValue(Self.isAntiGravity, BALL_HEIGHT_OFFSET, 0)) Shr 6) + (drawY Shr 6)) - camera.y, False, trans) ' 12 ' 1024
						
						If (Not Self.isInWater) Then
							Self.sonic_effectDrawer.setSpeed(1, 1)
						Else
							Self.sonic_effectDrawer.setSpeed(1, 2)
						EndIf
				End Select
				
				If (Self.sonic_effectDrawer.checkEnd()) Then
					Self.sonic_effectID = EFFECT_NONE
				EndIf
				
				Self.attackRectVec.Clear()
				
				If (Self.sonic_effectID = EFFECT_JUMP) Then
					rect = Self.sonic_effectDrawer.getARect()
				Else
					rect = Self.drawer.getARect()
				EndIf
				
				If (Self.isAntiGravity) Then
					Local rectTmp:= Self.drawer.getARect()
					
					If (rectTmp.Length > 0) Then
						rect[0] = Byte((-rectTmp[0]) - rectTmp[2])
						rect[1] = Byte((-rectTmp[1]) - rectTmp[3])
					EndIf
				EndIf
				
				If (rect.Length > 0) Then
					If (SonicDebug.showCollisionRect) Then
						g.setColor(65280)
						
						g.drawRect(((Self.footPointX Shr 6) + rect[0]) - camera.x, ((Self.footPointY Shr 6) + rect[1]) - camera.y, rect[2], rect[3])
					EndIf
					
					Local animColRect:= Self.attackRect
					
					Local xOffset:= (rect[0] Shl 6)
					Local yOffset:= (rect[1] Shl 6)
					Local width:= (rect[2] Shl 6)
					Local height:= (rect[3] Shl 6)
					
					Local animID:Int ' = SONIC_ANI_STAND ' 0
					
					If (Self.sonic_effectID = EFFECT_JUMP) Then
						animID = SONIC_ANI_JUMP_ATTACK_EFFECT
					Else
						animID = Self.myAnimationID
					EndIf
					
					animColRect.initCollision(xOffset, yOffset, width, height, animID)
					
					Self.attackRectVec.Push(Self.attackRect)
				Else
					Self.attackRect.reset()
				EndIf
				
				If (Self.animationID = NO_ANIMATION) Then
					If (Self.drawer.checkEnd()) Then
						If (LOOP_INDEX[Self.myAnimationID] >= 0) Then
							Self.myAnimationID = LOOP_INDEX[Self.myAnimationID]
						EndIf
					EndIf
				EndIf
				
				If (Self.isFirstAttack) Then
					If (Self.myAnimationID = SONIC_ANI_ATTACK_1 And Not Self.isCrashFallingSand) Then
						soundInstance.playSe(SoundSystem.SE_109)
					EndIf
					
					Self.isFirstAttack = False
				EndIf
			EndIf
		End
		
		Method doWhileLand:Void(degree:Int)
			Super.doWhileLand(degree)
			
			Self.firstJump = False
		End
		
		Method extraInputLogic:Void()
			If (isTerminal And terminalState >= SUPER_SONIC_ANI_CHANGE_2) Then
				Select (terminalState)
					Case SONIC_ANI_JUMP
						Self.velX = 0
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method getRetPower:Int()
			Local retPower:= Super.getRetPower()
			
			If (speedCount > 0 And Self.myAnimationID >= SONIC_ANI_ATTACK_1 And Self.myAnimationID <= SONIC_ANI_ATTACK_2) Then
				retPower /= 2
			EndIf
			
			If (Self.myAnimationID = SONIC_ANI_ATTACK_3) Then
				Return 150
			EndIf
			
			Return retPower
		End
		
		Method needRetPower:Bool()
			If (Self.slipping) Then
				Return False
			EndIf
			
			If (Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) Then
				Return True
			EndIf
			
			Return Super.needRetPower()
		End
		
		Method getSlopeGravity:Int()
			If (Self.slipping) Then
				Return 0
			EndIf
			
			Return Super.getSlopeGravity()
		End
		
		Method noRotateDraw:Bool()
			If (Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) Then
				Return True
			EndIf
			
			Return Super.noRotateDraw()
		End
		
		Method beSpring:Void(springPower:Int, direction:Int)
			Super.beSpring(springPower, direction)
			
			If (Self.sonic_attackLevel <> 0) Then
				Self.sonic_attackLevel = 0
				Self.sonic_attackCount = 0
				
				Select (direction)
					Case DIRECTION_LEFT, DIRECTION_RIGHT
						Self.animationID = SUPER_SONIC_ANI_GO
						
						If (Key.repeated(Key.gDown)) Then
							Self.animationID = SONIC_ANI_JUMP
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method beAccelerate:Bool(power:Int, IsX:Bool, sender:GameObject)
			Local re:= Super.beAccelerate(power, IsX, sender)
			
			If (Self.sonic_attackLevel <> 0) Then
				Self.sonic_attackLevel = 0
				Self.sonic_attackCount = 0
				Self.animationID = SUPER_SONIC_ANI_GO
				
				If (Key.repeated(Key.gDown)) Then
					Self.animationID = SONIC_ANI_JUMP
				EndIf
			EndIf
			
			Return re
		End
	Private
		' Methods:
		Method getStartSpeed:Int(confFlag:Bool, sourceSpeed:Int, conf:Int)
			Return PickValue(confFlag, ((sourceSpeed * conf) / 100), sourceSpeed)
		End
		
		Method setMinSlipSpeed:Void()
			If (getVelX() < SPEED_LIMIT_LEVEL_1) Then
				setVelX(SPEED_LIMIT_LEVEL_1)
			EndIf
		End
	Protected
		' Methods:
		Method extraLogicJump:Void()
			If (Not Self.hurtNoControl) Then
				' Magic numbers: 5
				If (Not Self.slipping And Key.press(Key.gLeft)) Then
					If (Not Self.jumpRollEnable) Then
						Self.leftCount = 5
					EndIf
					
					Self.rightCount = 0
				EndIf
				
				If (Key.press(Key.gRight)) Then
					Self.leftCount = 0
					
					If (Not Self.jumpRollEnable) Then
						Self.rightCount = 5
					EndIf
				EndIf
			EndIf
			
			If (Self.animationID = SONIC_ANI_JUMP And Self.firstJump) Then
				If (Self.leftCount > 0) Then
					Self.leftCount -= 1
					
					If (Not Key.repeated(Key.gLeft)) Then
						Self.jumpRollEnable = True
					EndIf
					
					If (Self.jumpRollEnable And Key.repeated(Key.gLeft)) Then
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_JUMP_DASH_1
						
						Self.leftCount = 0
						
						Self.velY = 0
						Self.velX -= (Self.maxVelocity Shr 2) ' / 4
						
						soundInstance.playSe(SoundSystem.SE_112)
						
						Self.firstJump = False
					EndIf
				EndIf
				
				If (Self.rightCount > 0) Then
					Self.rightCount -= 1
					
					If (Not Key.repeated(Key.gRight)) Then
						Self.jumpRollEnable = True
					EndIf
					
					If (Self.jumpRollEnable And Key.repeated(Key.gRight)) Then
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_JUMP_DASH_1
						
						Self.rightCount = 0
						
						Self.velY = 0
						Self.velX += (Self.maxVelocity / 4) ' Shr 2
						
						soundInstance.playSe(SoundSystem.SE_112)
						
						Self.firstJump = False
					EndIf
				EndIf
				
				If (Self.firstJump And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
					Self.sonic_effectID = EFFECT_JUMP
					
					Self.firstJump = False
					
					soundInstance.playSe(79)
					
					Self.sonic_effectDrawer.restart()
					Self.sonic_effectDrawer.setActionId(SONIC_ANI_JUMP_ATTACK_EFFECT)
					
					Local rect:= Self.sonic_effectDrawer.getARect()
					
					If (rect.Length > 0) Then
						Self.attackRect.initCollision(rect[0] Shl 6, rect[1] Shl 6, rect[2] Shl 6, rect[3] Shl 6, SONIC_ANI_JUMP_ATTACK_EFFECT)
						Self.attackRectVec.Push(Self.attackRect)
					EndIf
				EndIf
			EndIf
			
			If (Self.myAnimationID = SONIC_ANI_ATTACK_2 And Self.drawer.checkEnd()) Then
				Self.animationID = SONIC_ANI_STAND
			EndIf
		End
		
		Method extraLogicWalk:Void()
			If (Self.slipping) Then
				' Magic number: 30
				If (Key.repeated(Key.gLeft) And Self.myAnimationID = SONIC_ANI_SLIDE_D45) Then
					Self.totalVelocity -= 30
				ElseIf (Key.repeated(Key.gDown | Key.gRight) And Self.faceDegree < 135) Then
					Self.totalVelocity += (MyAPI.dSin(Self.faceDegree) * 150) / 100
				EndIf
				
				Self.totalVelocity -= 30
				
				' Magic number: 192
				Self.totalVelocity = Max(Self.totalVelocity, 192)
				
				Self.animationID = NO_ANIMATION
				
				Self.faceDirection = True
				
				If (Self.faceDegree = 45) Then
					Self.myAnimationID = SONIC_ANI_SLIDE_D45
					
					Self.sonic_effectID = EFFECT_SLIP
				Else
					setMinSlipSpeed()
					
					Self.myAnimationID = SONIC_ANI_SLIDE_D0
				EndIf
				
				slidingFrame += 1
				
				Print("~~slidingFrame:" + slidingFrame)
				
				If (slidingFrame = 2) Then
					soundInstance.playLoopSe(SoundSystem.SE_114_02)
				EndIf
			EndIf
			
			If (Self.sonic_attackCount > 0) Then
				Self.sonic_attackCount -= 1
			EndIf
			
			If ((Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) And Self.faceDegree <> 90 And Self.faceDegree <> 270 And Self.sonic_attackLevel = 0) Then
				Self.animationID = SONIC_ANI_STAND
				Self.myAnimationID = ANIMATION_CONVERT[0]
				
				If (Self.collisionState = COLLISION_STATE_JUMP) Then
					Self.animationID = SONIC_ANI_JUMP
					
					Self.myAnimationID = ANIMATION_CONVERT[SONIC_ANI_JUMP]
				EndIf
			EndIf
			
			Local v0:Int
			Local startSpeedSet:Int
			
			Select (Self.myAnimationID)
				Case SONIC_ANI_ATTACK_1
					If ((Self.sonic_attackCount = 0 Or getVelX() = 0) And Not Self.isStopByObject) Then
						Self.sonic_attackLevel = 0
					Else
						Self.myAnimationID = SONIC_ANI_ATTACK_1
					EndIf
					
					If (Self.isStopByObject And Self.sonic_attackCount = 0) Then
						Self.sonic_attackLevel = 0
					EndIf
					
					If (Key.press(Key.gSelect) And Not Self.isCrashPipe) Then
						Self.sonic_attackLevel = 2
						Self.myAnimationID = SONIC_ANI_ATTACK_2
						
						soundInstance.playSe(SoundSystem.SE_117)
						
						v0 = PickValue(Self.isInWater, SONIC_ATTACK_LEVEL_2_V0_IN_WATER, SONIC_ATTACK_LEVEL_2_V0)
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If (Self.faceDirection) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							If (Self.faceDirection) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						soundInstance.playSe(SONIC_ANI_JUMP_DASH_1)
					EndIf
				Case SONIC_ANI_ATTACK_2
					If (Not Self.drawer.checkEnd()) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_2
					ElseIf (Self.sonic_attackLevel = SUPER_SONIC_ANI_GO And (getVelX() <> 0 Or Self.isStopByObject)) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_3
						
						v0 = PickValue(Self.isInWater, SONIC_ATTACK_LEVEL_3_V0_IN_WATER, SONIC_ATTACK_LEVEL_3_V0)
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If (Self.faceDirection) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							If (Self.faceDirection) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.sonic_attackCount = 12 ' SONIC_ANI_JUMP_ATTACK_EFFECT
						
						soundInstance.playSe(SoundSystem.SE_111)
					ElseIf (Self.sonic_attackLevel = SONIC_ANI_JUMP) Then
						Local preVelX:= PickValue(Self.isStopByObject, PickValue(((Self.faceDirection ~ Self.isAntiGravity) <> 0), BACK_JUMP_SPEED_X, -BACK_JUMP_SPEED_X), getVelX())
						
						If (Self.isInSnow) Then
							preVelX Shr= 1 ' /= 2
						EndIf
						
						Local start_v:= PickValue(Self.isInWater, ATTACK4_ISINWATER_JUMP_START_V, ATTACK4_JUMP_START_V)
						
						If (Self.isAntiGravity) Then
							startSpeedSet = -start_v
						Else
							startSpeedSet = start_v
						EndIf
						
						Super.doJumpV(startSpeedSet)
						
						Self.sonic_attackLevel = 0
						
						setVelX(-preVelX)
						
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_ATTACK_4
						
						Self.noVelMinus = True
					Else
						Self.animationID = SONIC_ANI_STAND
						
						Self.sonic_attackLevel = 0
						
						setVelX(0)
						
						Self.totalVelocity = 0
					EndIf
					
					If (Self.sonic_attackLevel <> 0) Then
						If (Not Key.press(Key.gSelect) And Key.press(Key.B_HIGH_JUMP)) Then
							Self.sonic_attackLevel = 4
						Else
							Self.sonic_attackLevel = 3
						EndIf
					EndIf
				Case SONIC_ANI_ATTACK_3
					If (getVelX() <> 0 Or Self.isStopByObject) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_3
						
						If (Self.isStopByObject And Self.sonic_attackCount = 0) Then
							Self.sonic_attackLevel = 0
						EndIf
					Else
						Self.sonic_attackLevel = 0
					EndIf
				Default
					If (Not (Self.animationID = SONIC_ANI_JUMP Or Not Key.press(Key.gSelect) Or Self.slipping Or Self.animationID = SONIC_ANI_LOOK_UP_2 Or Self.isCrashFallingSand)) Then
						If (Self.onBank) Then
							Self.onBank = False
						EndIf
						
						Self.sonic_attackLevel = 1
						
						Self.sonic_attackCount = PickValue(Self.isInWater, ATTACK_COUNT_LEVEL_2, ATTACK_COUNT_LEVEL_1)
						
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_ATTACK_1
						
						Self.isFirstAttack = True
						
						v0 = PickValue(Self.isInWater, SONIC_ATTACK_LEVEL_1_V0_IN_WATER, PlayerObject.SONIC_ATTACK_LEVEL_1_V0)
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If (Self.faceDirection) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							If (Self.faceDirection) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.drawer.setActionId(SONIC_ANI_ATTACK_1)
						
						Local rect:= Self.drawer.getARect()
						
						If (rect.Length > 0) Then
							Self.attackRect.initCollision(rect[0] Shl 6, rect[1] Shl 6, rect[2] Shl 6, rect[3] Shl 6, SONIC_ANI_ATTACK_1)
							
							Self.attackRectVec.Push(Self.attackRect)
						EndIf
					EndIf
			End Select
			
			Self.isStopByObject = False
			
			Self.isAttacking = (Self.sonic_attackLevel <> 0)
		End
		
		Method extraLogicOnObject:Void()
			Self.firstJump = False
			
			If (Self.sonic_attackCount > 0) Then
				Self.sonic_attackCount -= 1
			EndIf
			
			If ((Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) And Self.sonic_attackLevel = 0) Then
				Self.animationID = SONIC_ANI_STAND
				Self.myAnimationID = ANIMATION_CONVERT[0]
			EndIf
			
			Local v0:Int
			Local startSpeedSet:Int
			
			Select (Self.myAnimationID)
				Case SONIC_ANI_ATTACK_1
					If ((Self.sonic_attackCount = 0 Or getVelX() = 0) And Not Self.isStopByObject) Then
						Self.sonic_attackLevel = 0
					Else
						Self.myAnimationID = SONIC_ANI_ATTACK_1
					EndIf
					
					If (Self.isStopByObject And Self.sonic_attackCount = 0) Then
						Self.sonic_attackLevel = 0
					EndIf
					
					If (Key.press(Key.gSelect) And Not Self.isCrashPipe) Then
						Self.sonic_attackLevel = 2
						
						Self.myAnimationID = SONIC_ANI_ATTACK_2
						
						soundInstance.playSe(SoundSystem.SE_123)
						
						v0 = PickValue(Self.isInWater, SONIC_ATTACK_LEVEL_2_V0_IN_WATER, SONIC_ATTACK_LEVEL_2_V0)
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						soundInstance.playSe(SoundSystem.SE_123)
					EndIf
				Case SONIC_ANI_ATTACK_2
					If (Not Self.drawer.checkEnd()) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_2
					ElseIf (Self.sonic_attackLevel < 3 Or (getVelX() = 0 And Not Self.isStopByObject)) Then
						Self.animationID = SONIC_ANI_STAND
						
						Self.sonic_attackLevel = 0
						
						setVelX(0)
						
						Self.totalVelocity = 0
					Else
						Self.myAnimationID = SONIC_ANI_ATTACK_3
						
						v0 = PickValue(Self.isInWater, SONIC_ATTACK_LEVEL_3_V0_IN_WATER, SONIC_ATTACK_LEVEL_3_V0)
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.sonic_attackCount = ATTACK_COUNT_LEVEL_2
						
						soundInstance.playSe(SoundSystem.SE_111)
					EndIf
					
					If (Key.press(Key.gSelect)) Then
						Self.sonic_attackLevel = 3
					EndIf
				Case SONIC_ANI_ATTACK_3
					If (getVelX() <> 0 Or Self.isStopByObject) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_3
					Else
						Self.sonic_attackLevel = 0
					EndIf
					
					If (Self.isStopByObject And Self.sonic_attackCount = 0) Then
						Self.sonic_attackLevel = 0
					EndIf
				Default
					If (Not (Self.animationID = SONIC_ANI_JUMP Or Not Key.press(Key.gSelect) Or Self.animationID = SONIC_ANI_LOOK_UP_2 Or Self.isCrashFallingSand)) Then
						Self.sonic_attackLevel = SUPER_SONIC_ANI_CHANGE_1
						
						Self.sonic_attackCount = PickValue(Self.isInWater, ATTACK_COUNT_LEVEL_2, ATTACK_COUNT_LEVEL_1)
						
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_ATTACK_1
						
						Self.isFirstAttack = True
						
						v0 = PickValue(Self.isInWater, SONIC_ATTACK_LEVEL_1_V0_IN_WATER, PlayerObject.SONIC_ATTACK_LEVEL_1_V0)
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = getStartSpeed(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = getStartSpeed(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.drawer.setActionId(SONIC_ANI_ATTACK_1)
						
						Local rect:= Self.drawer.getARect()
						
						If (rect.Length > 0) Then
							Self.attackRect.initCollision(rect[0] Shl 6, rect[1] Shl 6, rect[2] Shl 6, rect[3] Shl 6, SONIC_ANI_ATTACK_1)
							Self.attackRectVec.Push(Self.attackRect)
						EndIf
					EndIf
			End Select
			
			Self.isStopByObject = False
			
			If (Self.sonic_attackLevel = 0) Then
				Self.isAttacking = False
			Else
				Self.isAttacking = True
			EndIf
		End
End