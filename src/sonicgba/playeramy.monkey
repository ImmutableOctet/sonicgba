Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
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
		Public Method closeImpl:Void()
			Animation.closeAnimationDrawer(Self.amyDrawer1)
			Self.amyDrawer1 = Null
			Animation.closeAnimation(Self.amyAnimation)
			Self.amyAnimation = Null
			Animation.closeAnimationDrawer(Self.amyDrawer2)
			Self.amyDrawer2 = Null
		End
		
		Public Method drawCharacter:Void(g:MFGraphics)
			Coordinate camera = MapManager.getCamera()
			
			If (Self.animationID <> NO_ANIMATION) Then
				Self.myAnimationID = ANIMATION_CONVERT[Self.animationID]
			EndIf
			
			If (Self.myAnimationID <> NO_ANIMATION) Then
				Bool loop = LOOP_INDEX[Self.myAnimationID] = NO_ANIMATION
				Int effectID = NO_ANIMATION
				Select (Self.myAnimationID)
					Case AMY_ANI_ATTACK_1
						effectID = AMY_ANI_STAND
						Self.isAttacking = True
						break
					Case AMY_ANI_ATTACK_2
						effectID = AMY_ANI_WALK_1
						Self.isAttacking = True
						break
					Case AMY_ANI_JUMP_ATTACK_1
						effectID = AMY_ANI_WALK_2
						checkBreatheReset()
						Self.isAttacking = True
						break
					Case AMY_ANI_JUMP_ATTACK_2
						effectID = AMY_ANI_RUN
						Self.isAttacking = True
						break
					Case AMY_ANI_JUMP_ATTACK_3
						effectID = AMY_ANI_DASH_1
						Self.isAttacking = True
						break
				End Select
				
				If (effectID >= 0) Then
					Int frame = Self.drawer.getCurrentFrame()
					
					If (frame >= 0 And frame < HEART_SYMBOL_PARAM[effectID].Length) Then
						For (Int i = AMY_ANI_STAND; i < HEART_SYMBOL_PARAM[effectID][frame][AMY_ANI_STAND]; i += AMY_ANI_WALK_1)
							Effect.showEffect(Self.amyAnimation, AMY_ANI_HEART_SYMBOL, (Self.footPointX Shr AMY_ANI_DASH_3) + (((Self.isAntiGravity ~ Self.faceDirection) <> 0 ? AMY_ANI_WALK_1 : NO_ANIMATION) * HEART_SYMBOL_PARAM[effectID][frame][(i * AMY_ANI_WALK_2) + AMY_ANI_WALK_1])..(Self.footPointY Shr AMY_ANI_DASH_3) + ((Self.isAntiGravity ? NO_ANIMATION : AMY_ANI_WALK_1) * HEART_SYMBOL_PARAM[effectID][frame][(i * AMY_ANI_WALK_2) + AMY_ANI_WALK_2]), AMY_ANI_STAND, AMY_ANI_WALK_1)
						Next
					EndIf
				EndIf
				
				Self.drawer = Self.amyDrawer1
				Int drawerActionID = Self.myAnimationID
				
				If (Self.myAnimationID >= AMY_ANI_WAITING_1) Then
					Self.drawer = Self.amyDrawer2
					drawerActionID = Self.myAnimationID - AMY_ANI_WAITING_1
					
					If (Self.myAnimationID = AMY_ANI_WAITING_1 And Self.isResetWaitAni) Then
						Self.drawer.restart()
						Self.isResetWaitAni = False
					EndIf
				EndIf
				
				If (Self.isInWater) Then
					Self.drawer.setSpeed(AMY_ANI_WALK_1, AMY_ANI_WALK_2)
				Else
					Self.drawer.setSpeed(AMY_ANI_WALK_1, AMY_ANI_WALK_1)
				EndIf
				
				If (Self.hurtCount Mod AMY_ANI_WALK_2 = 0) Then
					Int trans
					
					If (Self.fallinSandSlipState <> 0) Then
						If (Self.fallinSandSlipState = AMY_ANI_WALK_1) Then
							Self.faceDirection = True
						ElseIf (Self.fallinSandSlipState = AMY_ANI_WALK_2) Then
							Self.faceDirection = False
						EndIf
					EndIf
					
					If (Self.faceDirection) Then
						trans = AMY_ANI_STAND
					Else
						trans = AMY_ANI_WALK_2
					EndIf
					
					If (Self.animationID <> AMY_ANI_DASH_1) Then
						If (Self.animationID <> AMY_ANI_DASH_3 And Self.animationID <> AMY_ANI_DASH_4) Then
							Select (Self.myAnimationID)
								Case AMY_ANI_SLIP_D0
									Self.drawer.draw(g, drawerActionID, ((Self.footPointX Shr AMY_ANI_DASH_3) - camera.x) + AMY_ANI_STAND, ((Self.footPointY Shr AMY_ANI_DASH_3) - camera.y) + AMY_ANI_STAND, loop, AMY_ANI_STAND)
									break
								Case AMY_ANI_SLIP_D45
									Self.drawer.draw(g, drawerActionID, ((Self.footPointX Shr AMY_ANI_DASH_3) - camera.x) + AMY_ANI_DASH_5, ((Self.footPointY Shr AMY_ANI_DASH_3) - camera.y) + AMY_ANI_STAND, loop, AMY_ANI_STAND)
									break
								Default
									
									If (Self.myAnimationID = AMY_ANI_JUMP_ATTACK_3) Then
										If (Self.drawer.checkEnd()) Then
											soundInstance.playSe(AMY_ANI_SPRING_1)
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
										Bool z
										AnimationDrawer animationDrawer = Self.drawer
										Int i2 = (Self.footPointX Shr AMY_ANI_DASH_3) - camera.x
										Int i3 = (Self.footPointY Shr AMY_ANI_DASH_3) - camera.y
										Int i4 = Self.degreeForDraw
										
										If (Self.faceDirection) Then
											z = False
										Else
											z = True
										EndIf
										
										drawDrawerByDegree(g, animationDrawer, drawerActionID, i2, i3, loop, i4, z)
										break
									EndIf
									
									Int bodyCenterX = getNewPointX(Self.footPointX, AMY_ANI_STAND, (-Self.collisionRect.getHeight()) Shr AMY_ANI_WALK_1, Self.faceDegree)
									Int bodyCenterY = getNewPointY(Self.footPointY, AMY_ANI_STAND, (-Self.collisionRect.getHeight()) Shr AMY_ANI_WALK_1, Self.faceDegree)
									g.saveCanvas()
									g.translateCanvas((bodyCenterX Shr AMY_ANI_DASH_3) - camera.x, (bodyCenterY Shr AMY_ANI_DASH_3) - camera.y)
									g.rotateCanvas((Float) Self.degreeForDraw)
									Self.drawer.draw(g, drawerActionID, AMY_ANI_STAND, (Self.collisionRect.getHeight() Shr AMY_ANI_WALK_1) Shr AMY_ANI_DASH_3, loop, trans)
									g.restoreCanvas()
									break
							End Select
						EndIf
						
						Self.drawer.draw(g, drawerActionID, (Self.footPointX Shr AMY_ANI_DASH_3) - camera.x, (Self.footPointY Shr AMY_ANI_DASH_3) - camera.y, loop, trans)
					Else
						Self.drawer.draw(g, drawerActionID, (getNewPointX(getNewPointX(Self.footPointX, AMY_ANI_STAND, -512, Self.faceDegree), AMY_ANI_STAND, 512, AMY_ANI_STAND) Shr AMY_ANI_DASH_3) - camera.x, (getNewPointY(getNewPointY(Self.footPointY, AMY_ANI_STAND, -512, Self.faceDegree), AMY_ANI_STAND, 512, AMY_ANI_STAND) Shr AMY_ANI_DASH_3) - camera.y, loop, AMY_ANI_STAND)
					EndIf
					
					Self.attackRectVec.removeAllElements()
					Byte[] rect = Self.drawer.getARect()
					
					If (Self.isAntiGravity) Then
						Byte[] rectTmp = Self.drawer.getARect()
						
						If (rectTmp <> Null) Then
							rect[AMY_ANI_STAND] = (Byte) ((-rectTmp[AMY_ANI_STAND]) - rectTmp[AMY_ANI_WALK_2])
						EndIf
					EndIf
					
					If (rect <> Null) Then
						If (SonicDebug.showCollisionRect) Then
							g.setColor(65280)
							g.drawRect(((Self.footPointX Shr AMY_ANI_DASH_3) + rect[AMY_ANI_STAND]) - camera.x..((Self.footPointY Shr AMY_ANI_DASH_3) + (Self.isAntiGravity ? (-rect[AMY_ANI_WALK_1]) - rect[AMY_ANI_RUN] : rect[AMY_ANI_WALK_1])) - camera.y, rect[AMY_ANI_WALK_2], rect[AMY_ANI_RUN])
						EndIf
						
						Self.attackRect.initCollision(rect[AMY_ANI_STAND] Shl AMY_ANI_DASH_3, rect[AMY_ANI_WALK_1] Shl AMY_ANI_DASH_3, rect[AMY_ANI_WALK_2] Shl AMY_ANI_DASH_3, rect[AMY_ANI_RUN] Shl AMY_ANI_DASH_3, Self.myAnimationID)
						Self.attackRectVec.addElement(Self.attackRect)
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
								break
							Case AMY_ANI_ATTACK_1
								
								If (Self.attackLevel <> AMY_ANI_WALK_2) Then
									Self.animationID = AMY_ANI_STAND
									Self.attackLevel = AMY_ANI_STAND
									Self.isAttacking = False
									break
								EndIf
								
								Self.myAnimationID = AMY_ANI_ATTACK_2
								Self.attack2Flag = True
								Self.worldCal.actionLogic(((Self.isAntiGravity ~ Self.faceDirection) <> 0 ? AMY_ANI_WALK_1 : NO_ANIMATION) * 768, AMY_ANI_STAND, (Self.faceDirection ? AMY_ANI_WALK_1 : NO_ANIMATION) * 768)
								Return
							Case AMY_ANI_ATTACK_2
								Self.animationID = AMY_ANI_STAND
								Self.attackLevel = AMY_ANI_STAND
								Self.isAttacking = False
								break
							Case AMY_ANI_JUMP_ATTACK_1
								Self.animationID = ATTACK_COUNT_MAX
								Self.isAttacking = False
								break
						End Select
						
						If (LOOP_INDEX[Self.myAnimationID] >= 0) Then
							Self.myAnimationID = LOOP_INDEX[Self.myAnimationID]
						EndIf
					EndIf
				EndIf
			EndIf
			
		End
		
		Protected Method spinLogic:Bool()
			
			If (Not (Key.repeated(Key.gLeft) Or Key.repeated(Key.gRight) Or isTerminal Or Self.animationID = NO_ANIMATION)) Then
				If (Key.repeated(Key.gDown)) Then
					If (Not (Self.animationID = AMY_ANI_DASH_2 Or Self.animationID = AMY_ANI_BANK_2 Or Self.animationID = AMY_ANI_BANK_3)) Then
						Self.animationID = AMY_ANI_BANK_1
					EndIf
					
					Int jump
					
					If (Key.press(Key.B_HIGH_JUMP | Key.gUp) And ((Not Self.isAntiGravity And (Self.faceDegree < 90 Or Self.faceDegree > 270)) Or (Self.isAntiGravity And Self.faceDegree > 90 And Self.faceDegree < 270))) Then
						Int i
						Int i2
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = AMY_ANI_DASH_1
						Self.collisionState = (Byte) 1
						Self.worldCal.actionState = (Byte) 1
						Int jump_x = Self.isInWater ? STEP_JUMP_INWATER_X : STEP_JUMP_X
						jump = Self.isInWater ? STEP_JUMP_INWATER_Y : STEP_JUMP_Y
						
						If (Self.faceDirection) Then
							i = AMY_ANI_WALK_1
						Else
							i = NO_ANIMATION
						EndIf
						
						Self.velX = ((i * jump_x) * MyAPI.dCos(Self.faceDegree)) / 100
						
						If (Self.faceDirection) Then
							i = AMY_ANI_WALK_1
						Else
							i = NO_ANIMATION
						EndIf
						
						Self.velY = ((i * jump_x) * MyAPI.dSin(Self.faceDegree)) / 100
						
						If (Self.velY < STEP_JUMP_LIMIT_Y) Then
							Self.velY = STEP_JUMP_LIMIT_Y
						EndIf
						
						i = Self.velY
						
						If (Self.isAntiGravity) Then
							i2 = NO_ANIMATION
						Else
							i2 = AMY_ANI_WALK_1
						EndIf
						
						Self.velY = i + (i2 * ((-jump) - getGravity()))
						soundInstance.playSe(AMY_ANI_SQUAT_1)
						Return True
					ElseIf (Key.press(Key.gSelect)) Then
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = AMY_ANI_BIG_JUMP
						Self.isinBigJumpAttack = True
						Self.collisionState = (Byte) 1
						Self.worldCal.actionState = (Byte) 1
						jump = Self.isInWater ? BIG_JUMP_INWATER_POWER : BIG_JUMP_POWER
						Self.velY += (((-jump) - getGravity()) * MyAPI.dCos(Self.faceDegree)) / 100
						Self.velX += (((-jump) - getGravity()) * (-MyAPI.dSin(Self.faceDegree))) / 100
						soundInstance.playSe(AMY_ANI_SQUAT_1)
					ElseIf (Abs(getVelX()) <= SLIDING_BRAKE And getDegreeDiff(Self.faceDegree, Self.degreeStable) <= AMY_ANI_WIND) Then
						Self.focusMovingState = AMY_ANI_WALK_2
					EndIf
					
				ElseIf (Self.animationID = AMY_ANI_DASH_2) Then
					Self.animationID = AMY_ANI_BANK_1
				EndIf
			EndIf
			
			Return False
		End
		
		Public Method doJump:Void()
			
			If (Self.myAnimationID <> AMY_ANI_BIG_JUMP And Self.myAnimationID <> AMY_ANI_DASH_4 And Self.myAnimationID <> AMY_ANI_DASH_5) Then
				Self.jumpAttackUsed = False
				
				If (Self.slipping) Then
					If (Not isHeadCollision()) Then
						Self.currentLayer = AMY_ANI_WALK_1
					Else
						Return
					EndIf
				EndIf
				
				If (Self.slipping And Self.totalVelocity = 192) Then
					Super.doJumpV()
				Else
					Super.doJump()
				EndIf
				
				If (Self.slipping) Then
					Self.currentLayer = AMY_ANI_WALK_1
					Self.slipping = False
				EndIf
				
				Self.animationID = AMY_ANI_SPRING_2
			EndIf
			
		End
		
		Public Method isOnSlip0:Bool()
			Return Self.myAnimationID = AMY_ANI_SLIP_D0
		End
		
		Public Method setSlip0:Void()
			
			If (Self.collisionState = Null) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = AMY_ANI_SLIP_D0
			EndIf
			
			setMinSlipSpeed()
		End
		
		Protected Method extraLogicWalk:Void()
			
			If (Self.myAnimationID = AMY_ANI_ATTACK_1 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_1) Then
				If (Self.attack1Flag) Then
					soundInstance.playSe(AMY_ANI_JUMP_ATTACK_2)
					Self.attack1Flag = False
				EndIf
				
			ElseIf (Self.myAnimationID = AMY_ANI_ATTACK_2 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_2 And Self.attack2Flag) Then
				soundInstance.playSe(AMY_ANI_JUMP_ATTACK_2)
				Self.attack2Flag = False
			EndIf
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= AMY_ANI_WALK_1
				
				If (Self.attackCount = 0) Then
					Self.attackLevel = AMY_ANI_STAND
				EndIf
			EndIf
			
			If (Self.attackLevel > 0) Then
				Self.totalVelocity = AMY_ANI_STAND
			EndIf
			
			If (Self.attackLevel = 0) Then
				isCanJump = True
			Else
				isCanJump = False
			EndIf
			
			If (Not (Self.cannotAttack Or Not Key.press(Key.gSelect) Or Self.myAnimationID = AMY_ANI_PUSH_WALL Or Self.collisionState = (Byte) 1)) Then
				If (Self.animationID <> NO_ANIMATION And Not Key.repeated(Key.gDown)) Then
					Self.totalVelocity = AMY_ANI_STAND
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = AMY_ANI_ATTACK_1
					Self.attack1Flag = True
					Self.attackCount = Self.isInWater ? AMY_ANI_JUMP_ATTACK_1 : ATTACK_COUNT_MAX
					Self.attackLevel = AMY_ANI_WALK_1
				ElseIf (Self.attackCount > 0 And Self.attackLevel < AMY_ANI_WALK_2) Then
					Self.attackLevel += AMY_ANI_WALK_1
				EndIf
			EndIf
			
			If (Self.myAnimationID = AMY_ANI_DASH_4 And Self.totalVelocity = 0) Then
				Self.myAnimationID = AMY_ANI_DASH_5
			EndIf
			
			If (Self.slipping) Then
				If (Key.repeated(Key.gLeft) And Self.myAnimationID = AMY_ANI_SLIP_D45) Then
					Self.totalVelocity -= AMY_ANI_ROLL_V_2
				ElseIf (Key.repeated(Key.gDown | Key.gRight) And Self.faceDegree < StringIndex.FONT_COLON_RED) Then
					Self.totalVelocity += (MyAPI.dSin(Self.faceDegree) * 150) / 100
				EndIf
				
				Self.totalVelocity -= AMY_ANI_ROLL_V_2
				Self.totalVelocity = Max(Self.totalVelocity, 192)
				Self.animationID = NO_ANIMATION
				Self.faceDirection = True
				
				If (Self.faceDegree = AMY_ANI_WIND) Then
					Self.myAnimationID = AMY_ANI_SLIP_D45
					
					If (Self.slideSoundStart) Then
						soundInstance.playSe(AMY_ANI_DASH_5)
						Self.slideSoundStart = False
					EndIf
					
				Else
					setMinSlipSpeed()
					Self.myAnimationID = AMY_ANI_SLIP_D0
					
					If (Self.slideSoundStart) Then
						soundInstance.playSe(AMY_ANI_DASH_5)
						Self.slideSoundStart = False
					EndIf
				EndIf
				
				slidingFrame += AMY_ANI_WALK_1
				
				If (slidingFrame = AMY_ANI_DASH_1) Then
					soundInstance.playLoopSe(AMY_ANI_LOOK_UP_1)
				EndIf
			EndIf
			
		End
		
		Protected Method extraLogicJump:Void()
			Select (Self.myAnimationID)
				Case AMY_ANI_DASH_1
				Case AMY_ANI_DASH_2
					
					If (Not Key.press(Key.gSelect)) Then
						If (Self.velX <> 0) Then
							If (Self.velX >= 0) Then
								Self.velX = Max(Self.velX, STEP_JUMP_X_V0)
								break
							Else
								Self.velX = Min(Self.velX, -912)
								break
							EndIf
						EndIf
					EndIf
					
					Self.myAnimationID = AMY_ANI_DASH_3
					break
					break
				Case AMY_ANI_SPRING_2
				Case AMY_ANI_SPRING_3
				Case AMY_ANI_SPRING_4
				Case AMY_ANI_SPRING_5
				Case AMY_ANI_SPRING_1
					
					If (Not (Not Key.press(Key.gSelect) Or Self.isinBigJumpAttack Or Self.jumpAttackUsed)) Then
						Self.jumpAttackUsed = True
						
						If (Not Key.repeated(Key.gDown)) Then
							Self.animationID = NO_ANIMATION
							Self.myAnimationID = AMY_ANI_JUMP_ATTACK_1
							soundInstance.playSe(AMY_ANI_JUMP_ATTACK_3)
							break
						EndIf
						
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = AMY_ANI_JUMP_ATTACK_2
						break
					EndIf
					
			End Select
			
			If (Self.animationID >= AMY_ANI_WALK_1 And Self.animationID <= AMY_ANI_RUN And Key.press(Key.gSelect) And Not Self.jumpAttackUsed) Then
				Self.jumpAttackUsed = True
				
				If (Key.repeated(Key.gDown)) Then
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = AMY_ANI_JUMP_ATTACK_2
				Else
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = AMY_ANI_JUMP_ATTACK_1
					soundInstance.playSe(AMY_ANI_JUMP_ATTACK_3)
				EndIf
			EndIf
			
			If (Self.myAnimationID = AMY_ANI_SPRING_1 Or Self.myAnimationID = AMY_ANI_SPRING_5) Then
				Self.skipBeStop = False
			EndIf
			
		End
		
		Protected Method extraLogicOnObject:Void()
			Self.isinBigJumpAttack = False
			
			If (Self.myAnimationID = AMY_ANI_ATTACK_1 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_1) Then
				If (Self.attack1Flag) Then
					soundInstance.playSe(AMY_ANI_JUMP_ATTACK_2)
					Self.attack1Flag = False
				EndIf
				
			ElseIf (Self.myAnimationID = AMY_ANI_ATTACK_2 And Self.drawer.getCurrentFrame() = AMY_ANI_DASH_2 And Self.attack2Flag) Then
				soundInstance.playSe(AMY_ANI_JUMP_ATTACK_2)
				Self.attack2Flag = False
			EndIf
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= AMY_ANI_WALK_1
				
				If (Self.attackCount = 0) Then
					Self.attackLevel = AMY_ANI_STAND
				EndIf
			EndIf
			
			If (Self.attackLevel > 0) Then
				Self.totalVelocity = AMY_ANI_STAND
			EndIf
			
			If (Self.attackLevel = 0) Then
				isCanJump = True
			Else
				isCanJump = False
			EndIf
			
			If (Self.myAnimationID = AMY_ANI_DASH_4 And Self.velX = 0 And Self.velY = 0) Then
				Self.myAnimationID = AMY_ANI_DASH_5
			EndIf
			
			If (Not Key.press(Key.gSelect)) Then
				Return
			EndIf
			
			If (Self.animationID <> NO_ANIMATION And Not Key.repeated(Key.gDown) And Self.collisionState <> (Byte) 1) Then
				Self.totalVelocity = AMY_ANI_STAND
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = AMY_ANI_ATTACK_1
				Self.attack1Flag = True
				Self.attackCount = Self.isInWater ? AMY_ANI_JUMP_ATTACK_1 : ATTACK_COUNT_MAX
				Self.attackLevel = AMY_ANI_WALK_1
			ElseIf (Self.attackCount > 0 And Self.attackLevel < AMY_ANI_WALK_2) Then
				Self.attackLevel += AMY_ANI_WALK_1
			EndIf
			
		End
		
		Public Method doWhileLand:Void(degree:Int)
			Super.doWhileLand(degree)
			Self.jumpAttackUsed = False
			
			If (Self.myAnimationID = AMY_ANI_DASH_4 Or Self.myAnimationID = AMY_ANI_DASH_3) Then
				Self.myAnimationID = AMY_ANI_DASH_4
				Self.animationID = NO_ANIMATION
				soundInstance.playSe(AMY_ANI_DASH_3)
			EndIf
			
			Self.isinBigJumpAttack = False
			
			If (Self.myAnimationID = AMY_ANI_JUMP_ATTACK_2 Or Self.myAnimationID = AMY_ANI_JUMP_ATTACK_3) Then
				Self.isAttacking = False
			EndIf
			
		End
		
		Public Method slipStart:Void()
			Self.currentLayer = AMY_ANI_STAND
			Self.slipping = True
			Self.slideSoundStart = True
			Self.collisionState = (Byte) 1
			Self.worldCal.actionState = (Byte) 1
			setMinSlipSpeed()
		End
		
		Private Method setMinSlipSpeed:Void()
			
			If (getVelX() < SPEED_LIMIT_LEVEL_1) Then
				setVelX(SPEED_LIMIT_LEVEL_1)
			EndIf
			
		End
		
		Public Method slipJumpOut:Void()
			
			If (Self.slipping) Then
				Self.currentLayer = AMY_ANI_WALK_1
				Self.slipping = False
				calDivideVelocity()
				setVelY(Self.isInWater ? JUMP_INWATER_START_VELOCITY : JUMP_START_VELOCITY)
				Self.collisionState = (Byte) 1
				Self.worldCal.actionState = (Byte) 1
				Self.collisionChkBreak = True
				Self.worldCal.stopMove()
			EndIf
			
		End
		
		Public Method slipEnd:Void()
			
			If (Self.slipping) Then
				Self.currentLayer = AMY_ANI_WALK_1
				Self.slipping = False
				calDivideVelocity()
				Self.collisionState = (Byte) 1
				Self.worldCal.actionState = (Byte) 1
				Self.velY = -1540
				Self.animationID = AMY_ANI_LOOK_UP_1
				Self.collisionChkBreak = True
				Self.worldCal.stopMove()
				soundInstance.stopLoopSe()
				soundInstance.playSequenceSe(AMY_ANI_SQUAT_1)
			EndIf
			
		End
		
		Public Method setSlideAni:Void()
			Self.animationID = NO_ANIMATION
			Self.myAnimationID = AMY_ANI_SLIP_D0
		End
		
		Public Method doHurt:Void()
			Super.doHurt()
			
			If (Self.slipping) Then
				Self.currentLayer = AMY_ANI_WALK_1
				Self.slipping = False
			EndIf
			
		End
		
		Public Method beSpring:Void(springPower:Int, direction:Int)
			Self.attackLevel = AMY_ANI_STAND
			Self.attackCount = AMY_ANI_STAND
			Self.jumpAttackUsed = False
			Super.beSpring(springPower, direction)
			
			If (Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4) Then
				If (Not (Self.animationID = 0 And Self.animationID = AMY_ANI_WALK_1 And Self.animationID = AMY_ANI_WALK_2 And Self.animationID = AMY_ANI_RUN)) Then
					Self.animationID = AMY_ANI_STAND
				EndIf
				
				If (Key.repeated(Key.gDown)) Then
					Self.animationID = AMY_ANI_DASH_2
				EndIf
			EndIf
			
		End
		
		Public Method getRetPower:Int()
			
			If (Self.animationID = AMY_ANI_DASH_2 And Self.fallTime = 0) Then
				Return MOVE_POWER_REVERSE
			EndIf
			
			If (Self.myAnimationID <> AMY_ANI_DASH_3 And Self.myAnimationID <> AMY_ANI_DASH_4) Then
				Return Super.getRetPower()
			EndIf
			
			Effect.showEffectPlayer(Self.dustEffectAnimation, AMY_ANI_WALK_2, Self.posX Shr AMY_ANI_DASH_3, Self.posY Shr AMY_ANI_DASH_3, AMY_ANI_STAND)
			Return SLIDING_BRAKE
		End
		
		Public Method beAccelerate:Bool(power:Int, IsX:Bool, sender:GameObject)
			
			If (Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4) Then
				Return False
			EndIf
			
			Bool re = Super.beAccelerate(power, IsX, sender)
			
			If (Not (Self.animationID = 0 And Self.animationID = AMY_ANI_WALK_1 And Self.animationID = AMY_ANI_WALK_2 And Self.animationID = AMY_ANI_RUN)) Then
				Self.animationID = AMY_ANI_STAND
			EndIf
			
			If (Key.repeated(Key.gDown)) Then
				Self.animationID = AMY_ANI_DASH_2
			EndIf
			
			Return re
		End
		
		Public Method needRetPower:Bool()
			Bool re = Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4
			Return re | Super.needRetPower()
		End
		
		Public Method getSlopeGravity:Int()
			
			If (Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4) Then
				Return AMY_ANI_STAND
			EndIf
			
			Return Super.getSlopeGravity()
		End
		
		Public Method noRotateDraw:Bool()
			Return Self.myAnimationID = AMY_ANI_ATTACK_1 Or Self.myAnimationID = AMY_ANI_ATTACK_2 Or Self.myAnimationID = AMY_ANI_DASH_3 Or Self.myAnimationID = AMY_ANI_DASH_4 Or Self.myAnimationID = AMY_ANI_DASH_5 Or Super.noRotateDraw()
		End
		
		Public Method resetAttackLevel:Void()
			Self.attackLevel = AMY_ANI_STAND
			Self.attackCount = AMY_ANI_STAND
		End
		
		Public Method setCannotAttack:Void(cannot:Bool)
			Self.cannotAttack = cannot
		End
End