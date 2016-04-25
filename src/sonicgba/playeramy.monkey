Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.soundsystem
	Import lib.constutil
	Import lib.myapi
	
	Import sonicgba.effect
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	Import sonicgba.playeranimationcollisionrect
	Import sonicgba.playerobject
	Import sonicgba.sonicdebug
	
	Import com.sega.engine.action.acworldcollisioncalculator
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class PlayerAmy Extends PlayerObject
	Public
		' Constant variable(s):
		Const AMY_ANI_ATTACK_1:Int = 18
		Const AMY_ANI_ATTACK_2:Int = 19
		Const AMY_ANI_BANK_1:Int = 46
		Const AMY_ANI_BANK_2:Int = 47
		Const AMY_ANI_BANK_3:Int = 48
		Const AMY_ANI_BAR_MOVE:Int = 44
		Const AMY_ANI_BAR_STAY:Int = 43
		Const AMY_ANI_BIG_JUMP:Int = 13
		Const AMY_ANI_BRAKE:Int = 54
		Const AMY_ANI_BREATHE:Int = 53
		Const AMY_ANI_CAUGHT:Int = 58
		Const AMY_ANI_CELEBRATE_1:Int = 49
		Const AMY_ANI_CELEBRATE_2:Int = 50
		Const AMY_ANI_CELEBRATE_3:Int = 51
		Const AMY_ANI_CLIFF_1:Int = 33
		Const AMY_ANI_CLIFF_2:Int = 34
		Const AMY_ANI_CLIFF_3:Int = 35
		Const AMY_ANI_CLIFF_4:Int = 36
		Const AMY_ANI_DASH_1:Int = 4
		Const AMY_ANI_DASH_2:Int = 5
		Const AMY_ANI_DASH_3:Int = 6
		Const AMY_ANI_DASH_4:Int = 7
		Const AMY_ANI_DASH_5:Int = 8
		Const AMY_ANI_DEAD_1:Int = 26
		Const AMY_ANI_DEAD_2:Int = 27
		Const AMY_ANI_ENTER_SP:Int = 56
		Const AMY_ANI_HEART_SYMBOL:Int = 57
		Const AMY_ANI_HURT_1:Int = 24
		Const AMY_ANI_HURT_2:Int = 25
		Const AMY_ANI_JUMP_ATTACK_1:Int = 20
		Const AMY_ANI_JUMP_ATTACK_2:Int = 21
		Const AMY_ANI_JUMP_ATTACK_3:Int = 22
		Const AMY_ANI_LOOK_UP_1:Int = 9
		Const AMY_ANI_LOOK_UP_2:Int = 10
		Const AMY_ANI_POLE_H:Int = 42
		Const AMY_ANI_POLE_V:Int = 41
		Const AMY_ANI_PUSH_WALL:Int = 28
		Const AMY_ANI_RAIL_BODY:Int = 55
		Const AMY_ANI_ROLL:Int = 39
		Const AMY_ANI_ROLL_H_1:Int = 31
		Const AMY_ANI_ROLL_H_2:Int = 32
		Const AMY_ANI_ROLL_V_1:Int = 29
		Const AMY_ANI_ROLL_V_2:Int = 30
		Const AMY_ANI_RUN:Int = 3
		Const AMY_ANI_SLIP_D0:Int = 37
		Const AMY_ANI_SLIP_D45:Int = 38
		Const AMY_ANI_SPRING_1:Int = 23
		Const AMY_ANI_SPRING_2:Int = 14
		Const AMY_ANI_SPRING_3:Int = 15
		Const AMY_ANI_SPRING_4:Int = 16
		Const AMY_ANI_SPRING_5:Int = 17
		Const AMY_ANI_SQUAT_1:Int = 11
		Const AMY_ANI_SQUAT_2:Int = 12
		Const AMY_ANI_STAND:Int = 0
		Const AMY_ANI_UP_ARM:Int = 40
		Const AMY_ANI_VS_KNUCKLE:Int = 52
		Const AMY_ANI_WAITING_1:Int = 59
		Const AMY_ANI_WAITING_2:Int = 60
		Const AMY_ANI_WALK_1:Int = 1
		Const AMY_ANI_WALK_2:Int = 2
		Const AMY_ANI_WIND:Int = 45
		
		' Global variable(s):
		Global isCanJump:Bool = False
		
		' Fields:
		Field slideframe:Int
		
		Field skipBeStop:Bool
	Private
		' Constant variable(s):
		Global ANIMATION_CONVERT:Int[] = [0, 1, 2, 3, 39, 12, -1, -1, 28, 23, 17, -1, 25, 41, 14, -1, -1, 54, -1, -1, -1, 55, 31, 32, 40, 29, 30, 43, 44, 45, 25, 42, 46, 47, 48, 49, 50, 51, 9, 10, 9, 27, 15, 16, 25, 26, 11, 34, 36, 53, 59, 60, 58, 52] ' Const
		
		Global HEART_SYMBOL_PARAM:Int[][][] = [[[0], [0], [0], [2, 0, -41, 13, -36], [1, 23, -27], [1, 26, -14]],
												[[0], [0], [0], [1, 7, -41], [1, 20, -36], [1, 30, -27], [1, 33, -14]],
												[[1, -10, -41], [1, 8, -43], [1, 22, -32], [1, 28, -16], [1, 23, 1], [1, 10, 11]],
												[[0], [1, 0, -1], [1, 19, -9]],
												[[1, 28, -11], [1, -28, -11], [1, 0, -9]]] ' Const
		
		Global LOOP_INDEX:Int[] = [-1, -1, -1, -1, 5, -1, 7, -1, 0, 10, -1, -2, -1, 17, -1, 16, 17, -1, 0, 0, 17, 22, -1, 16, 25, -1, 27, -1, -1, 30, 29, 32, 31, 34, -1, 36, -1, -1, -1, -1, -1, 14, 3, -1, -1, -1, -1, -1, -1, 50, -1, -2, 0, -2, -1, -1, -1, -2, 60, 60, -1, 0] ' Const
		
		Const ATTACK_COUNT_MAX:Int = 10
		
		Const BIG_JUMP_INWATER_POWER:Int = 1728
		Const BIG_JUMP_POWER:Int = 1536
		
		Const LOOP:Int = -1
		
		Const NO_ANIMATION:Int = -1
		Const NO_LOOP:Int = -2
		Const NO_LOOP_DEPAND:Int = -2
		
		Const SLIDING_BRAKE:Int = 64
		
		Const STEP_JUMP_INWATER_X:Int = 1504
		Const STEP_JUMP_INWATER_Y:Int = 388
		Const STEP_JUMP_LIMIT_Y:Int = -820
		Const STEP_JUMP_X:Int = 1024
		Const STEP_JUMP_X_V0:Int = 912
		Const STEP_JUMP_Y:Int = 320
		
		' Fields:
		Field attack1Flag:Bool
		Field attack2Flag:Bool
		
		Field cannotAttack:Bool
		Field isinBigJumpAttack:Bool
		Field jumpAttackUsed:Bool
		
		Field amyAnimation:Animation
		
		Field amyDrawer1:AnimationDrawer
		Field amyDrawer2:AnimationDrawer
		
		Field attackRect:PlayerAnimationCollisionRect
		
		Field attackCount:Int
		Field attackLevel:Int
	Public
		' Constructor(s):
		Method New()
			Self.isinBigJumpAttack = False
			Self.cannotAttack = False
			
			Local amyImage:= MFImage.createImage("/animation/player/chr_amy.png")
			
			Self.amyAnimation = New Animation(amyImage, "/animation/player/chr_amy_01")
			
			Self.amyDrawer1 = Self.amyAnimation.getDrawer()
			Self.drawer = Self.amyDrawer1
			
			Self.amyDrawer2 = New Animation(amyImage, "/animation/player/chr_amy_02").getDrawer()
			
			Self.attackRect = New PlayerAnimationCollisionRect(Self)
			
			Self.cannotAttack = False
		End
		
		' Methods:
		Method closeImpl:Void()
			Animation.closeAnimationDrawer(Self.amyDrawer1)
			Self.amyDrawer1 = Null
			
			Animation.closeAnimation(Self.amyAnimation)
			Self.amyAnimation = Null
			
			Animation.closeAnimationDrawer(Self.amyDrawer2)
			Self.amyDrawer2 = Null
		End
		
		Method drawCharacter:Void(g:MFGraphics)
			Local camera:= MapManager.getCamera()
			
			If (Self.animationID <> NO_ANIMATION) Then
				Self.myAnimationID = ANIMATION_CONVERT[Self.animationID]
			EndIf
			
			If (Self.myAnimationID <> NO_ANIMATION) Then
				Local loop:Bool = (LOOP_INDEX[Self.myAnimationID] = LOOP)
				Local effectID:= EFFECT_NONE ' -1
				
				Select (Self.myAnimationID)
					Case AMY_ANI_ATTACK_1
						effectID = 0 ' EFFECT_SAND_1
						
						Self.isAttacking = True
					Case AMY_ANI_ATTACK_2
						effectID = 1 ' EFFECT_SAND_2
						
						Self.isAttacking = True
					Case AMY_ANI_JUMP_ATTACK_1
						effectID = 2
						
						checkBreatheReset()
						
						Self.isAttacking = True
					Case AMY_ANI_JUMP_ATTACK_2
						effectID = 3
						
						Self.isAttacking = True
					Case AMY_ANI_JUMP_ATTACK_3
						effectID = 4
						
						Self.isAttacking = True
				End Select
				
				If (effectID >= 0) Then
					Local frame:= Self.drawer.getCurrentFrame()
					
					If (frame >= 0 And frame < HEART_SYMBOL_PARAM[effectID].Length) Then
						For Local i:= 0 Until HEART_SYMBOL_PARAM[effectID][frame][0]
							Effect.showEffect(Self.amyAnimation, AMY_ANI_HEART_SYMBOL, (Self.footPointX Shr 6) + ((DSgn((Self.isAntiGravity <> Self.faceDirection) <> 0)) * HEART_SYMBOL_PARAM[effectID][frame][(i * 2) + 1]), (Self.footPointY Shr 6) + (DSgn(Not Self.isAntiGravity) * HEART_SYMBOL_PARAM[effectID][frame][(i * 2) + 2]), 0, 1) ' 57
						Next
					EndIf
				EndIf
				
				Self.drawer = Self.amyDrawer1
				
				Local drawerActionID:= Self.myAnimationID
				
				If (Self.myAnimationID >= AMY_ANI_WAITING_1) Then
					Self.drawer = Self.amyDrawer2
					
					drawerActionID = (Self.myAnimationID - AMY_ANI_WAITING_1)
					
					If (Self.myAnimationID = AMY_ANI_WAITING_1 And Self.isResetWaitAni) Then
						Self.drawer.restart()
						
						Self.isResetWaitAni = False
					EndIf
				EndIf
				
				If (Self.isInWater) Then
					Self.drawer.setSpeed(1, 2)
				Else
					Self.drawer.setSpeed(1, 1)
				EndIf
				
				If ((Self.hurtCount Mod 2) = 0) Then
					If (Self.fallinSandSlipState <> 0) Then
						If (Self.fallinSandSlipState = 1) Then
							Self.faceDirection = True
						ElseIf (Self.fallinSandSlipState = 2) Then
							Self.faceDirection = False
						EndIf
					EndIf
					
					Local trans:Int ' = TRANS_NONE
					
					If (Self.faceDirection) Then
						trans = TRANS_NONE
					Else
						trans = TRANS_MIRROR
					EndIf
					
					If (Self.animationID <> AMY_ANI_DASH_1) Then
						If (Self.animationID <> AMY_ANI_DASH_3 And Self.animationID <> AMY_ANI_DASH_4) Then
							Select (Self.myAnimationID)
								Case AMY_ANI_SLIP_D0
									Self.drawer.draw(g, drawerActionID, ((Self.footPointX Shr 6) - camera.x), ((Self.footPointY Shr 6) - camera.y), loop, 0) ' TRANS_NONE
								Case AMY_ANI_SLIP_D45
									Self.drawer.draw(g, drawerActionID, ((Self.footPointX Shr 6) - camera.x) + 8, ((Self.footPointY Shr 6) - camera.y), loop, 0) ' TRANS_NONE
								Default
									If (Self.myAnimationID = AMY_ANI_JUMP_ATTACK_3) Then
										If (Self.drawer.checkEnd()) Then
											soundInstance.playSe(SoundSystem.SE_131)
										EndIf
									EndIf
									
									If (Self.myAnimationID = AMY_ANI_CLIFF_1 Or Self.myAnimationID = AMY_ANI_CLIFF_2 Or Self.myAnimationID = AMY_ANI_LOOK_UP_1 Or Self.myAnimationID = ATTACK_COUNT_MAX) Then
										Self.degreeForDraw = Self.degreeStable
										Self.faceDegree = Self.degreeStable
									EndIf
									
									If (Self.myAnimationID >= AMY_ANI_DASH_1 And Self.myAnimationID <= AMY_ANI_DASH_5) Then
										Self.degreeForDraw = Self.degreeStable
									EndIf
									
									If (Self.myAnimationID = AMY_ANI_BRAKE) Then
										Self.degreeForDraw = Self.degreeStable
									EndIf
									
									If (Not (Self.myAnimationID = AMY_ANI_WALK_1 Or Self.myAnimationID = AMY_ANI_WALK_2 Or Self.myAnimationID = AMY_ANI_RUN Or Self.myAnimationID = AMY_ANI_CAUGHT)) Then
										Self.degreeForDraw = Self.degreeStable
									EndIf
									
									If (Self.degreeForDraw = Self.faceDegree) Then
										drawDrawerByDegree(g, Self.drawer, drawerActionID, ((Self.footPointX Shr 6) - camera.x), ((Self.footPointY Shr 6) - camera.y), loop, Self.degreeForDraw, Not Self.faceDirection)
									Else
										Local bodyCenterX:= getNewPointX(Self.footPointX, 0, ((-Self.collisionRect.getHeight()) / 2), Self.faceDegree) ' Shr 1
										Local bodyCenterY:= getNewPointY(Self.footPointY, 0, ((-Self.collisionRect.getHeight()) / 2), Self.faceDegree) ' Shr 1
										
										g.saveCanvas()
										
										g.translateCanvas((bodyCenterX Shr 6) - camera.x, (bodyCenterY Shr 6) - camera.y)
										g.rotateCanvas(Float(Self.degreeForDraw))
										
										Self.drawer.draw(g, drawerActionID, 0, ((Self.collisionRect.getHeight() / 2) Shr 6), loop, trans) ' Shr 1
										
										g.restoreCanvas()
									EndIf
							End Select
						EndIf
						
						Self.drawer.draw(g, drawerActionID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, loop, trans)
					Else
						Self.drawer.draw(g, drawerActionID, (getNewPointX(getNewPointX(Self.footPointX, 0, -RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.faceDegree), 0, RIGHT_WALK_COLLISION_CHECK_OFFSET_X, 0) Shr 6) - camera.x, (getNewPointY(getNewPointY(Self.footPointY, 0, RIGHT_WALK_COLLISION_CHECK_OFFSET_Y, Self.faceDegree), 0, -RIGHT_WALK_COLLISION_CHECK_OFFSET_Y, 0) Shr 6) - camera.y, loop, 0) ' 512 ' (SIDE_FOOT_FROM_CENTER * 2)
					EndIf
					
					' I don't know why this is done in a draw routine, but whatever:
					Self.attackRectVec.Clear()
					
					Local rect:= Self.drawer.getARect()
					
					If (Self.isAntiGravity) Then
						Local rectTmp:= Self.drawer.getARect() ' rect
						
						If (rectTmp.Length > 0) Then
							rect[0] = Byte((-rectTmp[0]) - rectTmp[2])
						EndIf
					EndIf
					
					If (rect.Length > 0) Then
						If (SonicDebug.showCollisionRect) Then
							g.setColor(65280)
							
							g.drawRect(((Self.footPointX Shr 6) + rect[0]) - camera.x, ((Self.footPointY Shr 6) + PickValue(Self.isAntiGravity, (-rect[1]) - rect[3], rect[1])) - camera.y, rect[2], rect[3])
						EndIf
						
						Self.attackRect.initCollision((rect[0] Shl 6), (rect[1] Shl 6), (rect[2] Shl 6), (rect[3] Shl 6), Self.myAnimationID)
						
						Self.attackRectVec.Push(Self.attackRect)
					Else
						Self.attackRect.reset()
					EndIf
				Else
					If (drawerActionID <> Self.drawer.getActionId()) Then
						Self.drawer.setActionId(drawerActionID)
					EndIf
					
					If (Not AnimationDrawer.isAllPause()) Then
						Self.drawer.moveOn()
					EndIf
				EndIf
				
				If (Self.animationID = NO_ANIMATION) Then
					If (Self.drawer.checkEnd()) Then
						Select (Self.myAnimationID)
							Case AMY_ANI_DASH_5
								Self.animationID = AMY_ANI_STAND
							Case AMY_ANI_ATTACK_1
								If (Self.attackLevel <> 2) Then
									Self.animationID = AMY_ANI_STAND
									
									Self.attackLevel = 0
									
									Self.isAttacking = False
								Else
									Self.myAnimationID = AMY_ANI_ATTACK_2
									
									Self.attack2Flag = True
									
									Self.worldCal.actionLogic((DSgn((Self.isAntiGravity <> Self.faceDirection) <> 0)) * (BIG_JUMP_POWER / 2), 0, DSgn(Self.faceDirection) * (BIG_JUMP_POWER / 2)) ' 768
								EndIf
							Case AMY_ANI_ATTACK_2
								Self.animationID = AMY_ANI_STAND
								Self.attackLevel = 0
								
								Self.isAttacking = False
							Case AMY_ANI_JUMP_ATTACK_1
								Self.animationID = AMY_ANI_LOOK_UP_2
								
								Self.isAttacking = False
						End Select
						
						If (LOOP_INDEX[Self.myAnimationID] >= 0) Then
							Self.myAnimationID = LOOP_INDEX[Self.myAnimationID]
						EndIf
					EndIf
				EndIf
			EndIf
		End
		
		Method doJump:Void()
			If (Self.myAnimationID <> AMY_ANI_BIG_JUMP And Self.myAnimationID <> AMY_ANI_DASH_4 And Self.myAnimationID <> AMY_ANI_DASH_5) Then
				Self.jumpAttackUsed = False
				
				If (Self.slipping) Then
					If (Not isHeadCollision()) Then
						Self.currentLayer = 1
					Else
						Return
					EndIf
				EndIf
				
				' Magic number: 192
				If (Self.slipping And Self.totalVelocity = 192) Then ' (HURT_POWER_X / 2)
					Super.doJumpV()
				Else
					Super.doJump()
				EndIf
				
				If (Self.slipping) Then
					Self.currentLayer = 1
					
					Self.slipping = False
				EndIf
				
				Self.animationID = AMY_ANI_SPRING_2
			EndIf
		End
		
		Method isOnSlip0:Bool()
			Return (Self.myAnimationID = AMY_ANI_SLIP_D0)
		End
		
		Method setSlip0:Void()
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = AMY_ANI_SLIP_D0
			EndIf
			
			setMinSlipSpeed()
		End
		
		Method doWhileLand:Void(degree:Int)
			Super.doWhileLand(degree)
			
			Self.jumpAttackUsed = False
			
			If (Self.myAnimationID = AMY_ANI_DASH_4 Or Self.myAnimationID = AMY_ANI_DASH_3) Then
				Self.myAnimationID = AMY_ANI_DASH_4
				
				Self.animationID = NO_ANIMATION
				
				soundInstance.playSe(SoundSystem.SE_111)
			EndIf
			
			Self.isinBigJumpAttack = False
			
			If (Self.myAnimationID = AMY_ANI_JUMP_ATTACK_2 Or Self.myAnimationID = AMY_ANI_JUMP_ATTACK_3) Then
				Self.isAttacking = False
			EndIf
		End
		
		Method slipStart:Void()
			' Magic number: 0
			Self.currentLayer = 0
			
			Self.slipping = True
			Self.slideSoundStart = True
			
			' Magic numbers: 1
			Self.collisionState = COLLISION_STATE_JUMP
			Self.worldCal.actionState = 1
			
			setMinSlipSpeed()
		End
		
		Method slipJumpOut:Void()
			If (Self.slipping) Then
				' Magic numbers: 1
				
				Self.currentLayer = 1
				
				Self.slipping = False
				
				calDivideVelocity()
				
				setVelY(PickValue(Self.isInWater, JUMP_INWATER_START_VELOCITY, JUMP_START_VELOCITY))
				
				Self.collisionState = COLLISION_STATE_JUMP
				Self.worldCal.actionState = 1
				
				Self.collisionChkBreak = True
				
				Self.worldCal.stopMove()
			EndIf
		End
		
		Method slipEnd:Void()
			If (Self.slipping) Then
				' Magic numbers: 1
				
				Self.currentLayer = 1
				
				Self.slipping = False
				
				calDivideVelocity()
				
				Self.collisionState = COLLISION_STATE_JUMP
				Self.worldCal.actionState = 1
				
				' Magic number: -1540
				Self.velY = -1540
				
				Self.animationID = AMY_ANI_LOOK_UP_1
				
				Self.collisionChkBreak = True
				
				Self.worldCal.stopMove()
				
				soundInstance.stopLoopSe()
				soundInstance.playSequenceSe(SoundSystem.SE_116)
			EndIf
		End
		
		Method setSlideAni:Void()
			Self.animationID = NO_ANIMATION
			Self.myAnimationID = AMY_ANI_SLIP_D0
		End
		
		Method doHurt:Void()
			Super.doHurt()
			
			If (Self.slipping) Then
				' Magic number: 1
				Self.currentLayer = 1
				
				Self.slipping = False
			EndIf
		End
		
		Method beSpring:Void(springPower:Int, direction:Int)
			Self.attackLevel = 0
			Self.attackCount = 0
			
			Self.jumpAttackUsed = False
			
			Super.beSpring(springPower, direction)
			
			If (Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4) Then
				If (Not (Self.animationID = AMY_ANI_STAND And Self.animationID = AMY_ANI_WALK_1 And Self.animationID = AMY_ANI_WALK_2 And Self.animationID = AMY_ANI_RUN)) Then
					Self.animationID = AMY_ANI_STAND
				EndIf
				
				If (Key.repeated(Key.gDown)) Then
					Self.animationID = AMY_ANI_DASH_2
				EndIf
			EndIf
		End
		
		Method getRetPower:Int()
			If (Self.animationID = AMY_ANI_DASH_2 And Self.fallTime = 0) Then
				Return MOVE_POWER_REVERSE
			EndIf
			
			If (Self.myAnimationID <> AMY_ANI_DASH_3 And Self.myAnimationID <> AMY_ANI_DASH_4) Then
				Return Super.getRetPower()
			EndIf
			
			Effect.showEffectPlayer(Self.dustEffectAnimation, 2, (Self.posX Shr 6), (Self.posY Shr 6), 0)
			
			Return SLIDING_BRAKE
		End
		
		Method beAccelerate:Bool(power:Int, IsX:Bool, sender:GameObject)
			If (Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4) Then
				Return False
			EndIf
			
			Local re:= Super.beAccelerate(power, IsX, sender)
			
			If (Not (Self.animationID = AMY_ANI_STAND And Self.animationID = AMY_ANI_WALK_1 And Self.animationID = AMY_ANI_WALK_2 And Self.animationID = AMY_ANI_RUN)) Then
				Self.animationID = AMY_ANI_STAND
			EndIf
			
			If (Key.repeated(Key.gDown)) Then
				Self.animationID = AMY_ANI_DASH_2
			EndIf
			
			Return re
		End
		
		Method needRetPower:Bool()
			Return ((Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4) Or Super.needRetPower())
		End
		
		Method getSlopeGravity:Int()
			If (Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4) Then
				Return 0
			EndIf
			
			Return Super.getSlopeGravity()
		End
		
		Method noRotateDraw:Bool()
			Return (Self.myAnimationID = AMY_ANI_ATTACK_1 Or Self.myAnimationID = AMY_ANI_ATTACK_2 Or Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4 Or Self.myAnimationID = AMY_ANI_DASH_5 Or Super.noRotateDraw())
		End
		
		Method resetAttackLevel:Void()
			Self.attackLevel = 0
			Self.attackCount = 0
		End
		
		Method setCannotAttack:Void(cannot:Bool)
			Self.cannotAttack = cannot
		End
	Protected
		' Methods:
		Method spinLogic:Bool()
			If (Not (Key.repeated(Key.gLeft) Or Key.repeated(Key.gRight) Or isTerminal Or Self.animationID = NO_ANIMATION)) Then
				If (Key.repeated(Key.gDown)) Then
					If (Not (Self.animationID = AMY_ANI_DASH_2 Or Self.animationID = AMY_ANI_BANK_2 Or Self.animationID = AMY_ANI_BANK_3)) Then
						Self.animationID = AMY_ANI_BANK_1
					EndIf
					
					Local jump:Int
					
					If (Key.press(Key.B_HIGH_JUMP | Key.gUp) And ((Not Self.isAntiGravity And (Self.faceDegree < 90 Or Self.faceDegree > 270)) Or (Self.isAntiGravity And Self.faceDegree > 90 And Self.faceDegree < 270))) Then
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = AMY_ANI_DASH_1
						
						' Magic numbers: 1
						Self.collisionState = COLLISION_STATE_JUMP
						Self.worldCal.actionState = 1
						
						Local jump_x:= PickValue(Self.isInWater, STEP_JUMP_INWATER_X, STEP_JUMP_X)
						
						jump = PickValue(Self.isInWater, STEP_JUMP_INWATER_Y, STEP_JUMP_Y)
						
						Local directionSgn:Int = DSgn(Self.faceDirection)
						
						Self.velX = (((directionSgn * jump_x) * MyAPI.dCos(Self.faceDegree)) / 100)
						Self.velY = (((directionSgn * jump_x) * MyAPI.dSin(Self.faceDegree)) / 100) ' jump
						
						If (Self.velY < STEP_JUMP_LIMIT_Y) Then
							Self.velY = STEP_JUMP_LIMIT_Y
						EndIf
						
						Self.velY += (DSgn(Not Self.isAntiGravity) * ((-jump) - getGravity()))
						
						soundInstance.playSe(SoundSystem.SE_116)
						
						Return True
					ElseIf (Key.press(Key.gSelect)) Then
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = AMY_ANI_BIG_JUMP
						
						Self.isinBigJumpAttack = True
						
						' Magic numbers: 1
						Self.collisionState = COLLISION_STATE_JUMP
						Self.worldCal.actionState = 1
						
						jump = PickValue(Self.isInWater, BIG_JUMP_INWATER_POWER, BIG_JUMP_POWER)
						
						Self.velY += ((((-jump) - getGravity()) * MyAPI.dCos(Self.faceDegree)) / 100)
						Self.velX += ((((-jump) - getGravity()) * (-MyAPI.dSin(Self.faceDegree))) / 100)
						
						soundInstance.playSe(SoundSystem.SE_116)
					ElseIf (Abs(getVelX()) <= SLIDING_BRAKE And getDegreeDiff(Self.faceDegree, Self.degreeStable) <= AMY_ANI_WIND) Then
						' Magic number: 2
						Self.focusMovingState = 2
					EndIf
				ElseIf (Self.animationID = AMY_ANI_DASH_2) Then
					Self.animationID = AMY_ANI_BANK_1
				EndIf
			EndIf
			
			Return False
		End
		
		Method extraLogicWalk:Void()
			If (Self.myAnimationID = AMY_ANI_ATTACK_1 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_1) Then
				If (Self.attack1Flag) Then
					soundInstance.playSe(SoundSystem.SE_128)
					
					Self.attack1Flag = False
				EndIf
			ElseIf (Self.myAnimationID = AMY_ANI_ATTACK_2 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_2 And Self.attack2Flag) Then
				soundInstance.playSe(SoundSystem.SE_128)
				
				Self.attack2Flag = False
			EndIf
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= 1
				
				If (Self.attackCount = 0) Then
					Self.attackLevel = 0
				EndIf
			EndIf
			
			If (Self.attackLevel > 0) Then
				Self.totalVelocity = 0
			EndIf
			
			If (Self.attackLevel = 0) Then
				isCanJump = True
			Else
				isCanJump = False
			EndIf
			
			If (Not (Self.cannotAttack Or Not Key.press(Key.gSelect) Or Self.myAnimationID = AMY_ANI_PUSH_WALL Or Self.collisionState = COLLISION_STATE_JUMP)) Then
				If (Self.animationID <> NO_ANIMATION And Not Key.repeated(Key.gDown)) Then
					Self.totalVelocity = 0
					
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = AMY_ANI_ATTACK_1
					
					Self.attack1Flag = True
					
					Self.attackCount = PickValue(Self.isInWater, (ATTACK_COUNT_MAX * 2), ATTACK_COUNT_MAX) ' 20 ' AMY_ANI_JUMP_ATTACK_1
					
					Self.attackLevel = 1
				ElseIf (Self.attackCount > 0 And Self.attackLevel < 2) Then
					Self.attackLevel += 1
				EndIf
			EndIf
			
			If (Self.myAnimationID = AMY_ANI_DASH_4 And Self.totalVelocity = 0) Then
				Self.myAnimationID = AMY_ANI_DASH_5
			EndIf
			
			If (Self.slipping) Then
				' Magic numbers: 30
				
				If (Key.repeated(Key.gLeft) And Self.myAnimationID = AMY_ANI_SLIP_D45) Then
					Self.totalVelocity -= 30
				ElseIf (Key.repeated(Key.gDown | Key.gRight) And Self.faceDegree < 135) Then
					Self.totalVelocity += ((MyAPI.dSin(Self.faceDegree) * 150) / 100)
				EndIf
				
				Self.totalVelocity -= 30
				
				' Magic number: 192
				Self.totalVelocity = Max(Self.totalVelocity, 192)
				
				Self.animationID = NO_ANIMATION
				Self.faceDirection = True
				
				If (Self.faceDegree = AMY_ANI_WIND) Then
					Self.myAnimationID = AMY_ANI_SLIP_D45
					
					If (Self.slideSoundStart) Then
						soundInstance.playSe(SoundSystem.SE_114_01)
						
						Self.slideSoundStart = False
					EndIf
				Else
					setMinSlipSpeed()
					
					Self.myAnimationID = AMY_ANI_SLIP_D0
					
					If (Self.slideSoundStart) Then
						soundInstance.playSe(SoundSystem.SE_114_01)
						
						Self.slideSoundStart = False
					EndIf
				EndIf
				
				slidingFrame += 1
				
				If (slidingFrame = AMY_ANI_DASH_1) Then
					soundInstance.playLoopSe(SoundSystem.SE_114_02)
				EndIf
			EndIf
		End
		
		Method extraLogicJump:Void()
			Select (Self.myAnimationID)
				Case AMY_ANI_DASH_1, AMY_ANI_DASH_2
					If (Not Key.press(Key.gSelect) And Self.velX <> 0) Then
						If (Self.velX >= 0) Then
							Self.velX = Max(Self.velX, STEP_JUMP_X_V0) ' 912
						Else
							Self.velX = Min(Self.velX, -STEP_JUMP_X_V0)
						EndIf
					Else
						Self.myAnimationID = AMY_ANI_DASH_3
					EndIf
				Case AMY_ANI_SPRING_1, AMY_ANI_SPRING_2, AMY_ANI_SPRING_3, AMY_ANI_SPRING_4, AMY_ANI_SPRING_5
					If (Not (Not Key.press(Key.gSelect) Or Self.isinBigJumpAttack Or Self.jumpAttackUsed)) Then
						Self.jumpAttackUsed = True
						
						If (Not Key.repeated(Key.gDown)) Then
							Self.animationID = NO_ANIMATION
							Self.myAnimationID = AMY_ANI_JUMP_ATTACK_1
							
							soundInstance.playSe(SoundSystem.SE_130)
						Else
							Self.animationID = NO_ANIMATION
							Self.myAnimationID = AMY_ANI_JUMP_ATTACK_2
						EndIf
					EndIf
			End Select
			
			If (Self.animationID >= 1 And Self.animationID <= AMY_ANI_RUN And Key.press(Key.gSelect) And Not Self.jumpAttackUsed) Then
				Self.jumpAttackUsed = True
				
				If (Key.repeated(Key.gDown)) Then
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = AMY_ANI_JUMP_ATTACK_2
				Else
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = AMY_ANI_JUMP_ATTACK_1
					
					soundInstance.playSe(SoundSystem.SE_130)
				EndIf
			EndIf
			
			If (Self.myAnimationID = AMY_ANI_SPRING_1 Or Self.myAnimationID = AMY_ANI_SPRING_5) Then
				Self.skipBeStop = False
			EndIf
		End
		
		Method extraLogicOnObject:Void()
			Self.isinBigJumpAttack = False
			
			If (Self.myAnimationID = AMY_ANI_ATTACK_1 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_1) Then
				If (Self.attack1Flag) Then
					soundInstance.playSe(SoundSystem.SE_128)
					
					Self.attack1Flag = False
				EndIf
			ElseIf (Self.myAnimationID = AMY_ANI_ATTACK_2 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_2 And Self.attack2Flag) Then
				soundInstance.playSe(SoundSystem.SE_128)
				
				Self.attack2Flag = False
			EndIf
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= 1
				
				If (Self.attackCount = 0) Then
					Self.attackLevel = 0
				EndIf
			EndIf
			
			If (Self.attackLevel > 0) Then
				Self.totalVelocity = 0
			EndIf
			
			isCanJump = (Self.attackLevel = 0)
			
			If (Self.myAnimationID = AMY_ANI_DASH_4 And Self.velX = 0 And Self.velY = 0) Then
				Self.myAnimationID = AMY_ANI_DASH_5
			EndIf
			
			If (Key.press(Key.gSelect)) Then
				If (Self.animationID <> NO_ANIMATION And Not Key.repeated(Key.gDown) And Self.collisionState <> COLLISION_STATE_JUMP) Then
					Self.totalVelocity = 0
					
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = AMY_ANI_ATTACK_1
					
					Self.attack1Flag = True
					Self.attackCount = PickValue(Self.isInWater, (ATTACK_COUNT_MAX * 2), ATTACK_COUNT_MAX) ' 20
					
					Self.attackLevel = 1
				ElseIf (Self.attackCount > 0 And Self.attackLevel < 2) Then
					Self.attackLevel += 1
				EndIf
			EndIf
		End
	Private
		' Methods:
		Method setMinSlipSpeed:Void()
			If (getVelX() < SPEED_LIMIT_LEVEL_1) Then
				setVelX(SPEED_LIMIT_LEVEL_1)
			EndIf
		End
End