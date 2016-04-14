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
		Const ATTACK4_ISINWATER_JUMP_START_V:Int = (-1354 - GRAVITY)
		Const ATTACK4_JUMP_START_V:Int = (-1188 - GRAVITY)
		Const EFFECT_JUMP:Int = 1
		Const EFFECT_NONE:Int = 0
		Const EFFECT_SLIP:Int = 2
		Const LOOP:Int = -1
		Const NO_ANIMATION:Int = -1
		Const NO_LOOP:Int = -2
		Const NO_LOOP_DEPAND:Int = -3
		Const SNOW_DIVIDE_COUNT:Int = 70
		Const SUPER_SONIC_ANI_CHANGE_1:Int = 1
		Const SUPER_SONIC_ANI_CHANGE_2:Int = 2
		Const SUPER_SONIC_ANI_GO:Int = 3
		Const SUPER_SONIC_ANI_LOOK_MOON:Int = 0
		
		Global ANIMATION_CONVERT:Int[] = [0, 1, 2, 3, 4, 10, 5, 6, 31, 19, 23, -1, 28, 39, 20, -1, -1, 54, -1, -1, -1, 52, 34, 35, 38, 32, 33, 41, 42, 43, 28, 40, 44, 45, 46, 47, 48, 49, 7, 8, 7, 30, 21, 22, 28, 29, 9, 36, 37, 51, 55, 56, 57, 50] ' Const
		Global LOOP_INDEX:Int[] = [-1, -1, -1, -1, -1, -1, -1, 8, -1, -3, -1, 4, -2, -1, -2, -1, -1, 18, -1, 22, -1, 22, 23, -1, -1, -1, -1, 28, -1, 30, -1, -1, 33, 32, 35, 34, -1, -1, -1, 20, 3, -1, -1, -1, -1, -1, -1, 48, -1, -2, 0, -2, -1, -1, -1, 56, -1, -1, 0] ' Const
		Global SUPER_SONIC_LOOP:Bool[] = [False, False, True, True] ' Const
		
		' Fields:
		Field effectID:Int
		
		Field attackRect:PlayerAnimationCollisionRect
		
		Field effectDrawer:AnimationDrawer
		Field SuperSonicDrawer:AnimationDrawer
		
		Field attackCount:Int
		Field attackLevel:Int
		
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
			Self.effectDrawer = animation.getDrawer()
			
			Self.attackRect = New PlayerAnimationCollisionRect(Self)
			
			If (StageManager.getStageID() = 12) Then
				Self.SuperSonicDrawer = New Animation("/animation/player/chr_Super.sonic").getDrawer()
			EndIf
		End
		
		' Methods:
		Method closeImpl:Void()
			Animation.closeAnimationDrawer(Self.SuperSonicDrawer)
			Self.SuperSonicDrawer = Null
			
			Animation.closeAnimationDrawer(Self.effectDrawer)
			Self.effectDrawer = Null
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
	Protected
		Protected Method extraLogicJump:Void()
			
			If (Not Self.hurtNoControl) Then
				If (Not Self.slipping And Key.press(Key.gLeft)) Then
					If (Not Self.jumpRollEnable) Then
						Self.leftCount = SONIC_ANI_SPIN_1
					EndIf
					
					Self.rightCount = SONIC_ANI_STAND
				EndIf
				
				If (Key.press(Key.gRight)) Then
					Self.leftCount = SONIC_ANI_STAND
					
					If (Not Self.jumpRollEnable) Then
						Self.rightCount = SONIC_ANI_SPIN_1
					EndIf
				EndIf
			EndIf
			
			If (Self.animationID = SONIC_ANI_JUMP And Self.firstJump) Then
				If (Self.leftCount > 0) Then
					Self.leftCount -= SUPER_SONIC_ANI_CHANGE_1
					
					If (Not Key.repeated(Key.gLeft)) Then
						Self.jumpRollEnable = True
					EndIf
					
					If (Self.jumpRollEnable And Key.repeated(Key.gLeft)) Then
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_JUMP_DASH_1
						Self.leftCount = SONIC_ANI_STAND
						Self.velY = SONIC_ANI_STAND
						Self.velX -= Self.maxVelocity Shr SUPER_SONIC_ANI_CHANGE_2
						soundInstance.playSe(SONIC_ANI_LOOK_UP_1)
						Self.firstJump = False
					EndIf
				EndIf
				
				If (Self.rightCount > 0) Then
					Self.rightCount -= SUPER_SONIC_ANI_CHANGE_1
					
					If (Not Key.repeated(Key.gRight)) Then
						Self.jumpRollEnable = True
					EndIf
					
					If (Self.jumpRollEnable And Key.repeated(Key.gRight)) Then
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_JUMP_DASH_1
						Self.rightCount = SONIC_ANI_STAND
						Self.velY = SONIC_ANI_STAND
						Self.velX += Self.maxVelocity Shr SUPER_SONIC_ANI_CHANGE_2
						soundInstance.playSe(SONIC_ANI_LOOK_UP_1)
						Self.firstJump = False
					EndIf
				EndIf
				
				If (Self.firstJump And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
					Self.effectID = SUPER_SONIC_ANI_CHANGE_1
					Self.firstJump = False
					soundInstance.playSe(79)
					Self.effectDrawer.restart()
					Self.effectDrawer.setActionId(SONIC_ANI_JUMP_ATTACK_EFFECT)
					Byte[] rect = Self.effectDrawer.getARect()
					
					If (rect <> Null) Then
						Self.attackRect.initCollision(rect[SONIC_ANI_STAND] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_CHANGE_1] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_CHANGE_2] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_GO] Shl SONIC_ANI_SPIN_2, SONIC_ANI_JUMP_ATTACK_EFFECT)
						Self.attackRectVec.addElement(Self.attackRect)
					EndIf
				EndIf
			EndIf
			
			If (Self.myAnimationID = SONIC_ANI_ATTACK_2 And Self.drawer.checkEnd()) Then
				Self.animationID = SONIC_ANI_STAND
			EndIf
			
		End
		
		Private Method startSpeedSet:Int(confFlag:Bool, sourceSpeed:Int, conf:Int)
			Return confFlag ? (sourceSpeed * conf) / 100 : sourceSpeed
		End
		
		Public Method isOnSlip0:Bool()
			Return Self.myAnimationID = SONIC_ANI_SLIDE_D0
		End
		
		Public Method setSlip0:Void()
			
			If (Self.collisionState = Null) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = SONIC_ANI_SLIDE_D0
			EndIf
			
			setMinSlipSpeed()
		End
		
		Private Method setMinSlipSpeed:Void()
			
			If (getVelX() < SPEED_LIMIT_LEVEL_1) Then
				setVelX(SPEED_LIMIT_LEVEL_1)
			EndIf
			
		End
		
		Protected Method extraLogicWalk:Void()
			
			If (Self.slipping) Then
				If (Key.repeated(Key.gLeft) And Self.myAnimationID = SONIC_ANI_SLIDE_D45) Then
					Self.totalVelocity -= SONIC_ANI_DEAD_2
				ElseIf (Key.repeated(Key.gDown | Key.gRight) And Self.faceDegree < StringIndex.FONT_COLON_RED) Then
					Self.totalVelocity += (MyAPI.dSin(Self.faceDegree) * 150) / 100
				EndIf
				
				Self.totalVelocity -= SONIC_ANI_DEAD_2
				Self.totalVelocity = Max(Self.totalVelocity, 192)
				Self.animationID = NO_ANIMATION
				Self.faceDirection = True
				
				If (Self.faceDegree = SONIC_ANI_BANK_2) Then
					Self.myAnimationID = SONIC_ANI_SLIDE_D45
					Self.effectID = SUPER_SONIC_ANI_CHANGE_2
				Else
					setMinSlipSpeed()
					Self.myAnimationID = SONIC_ANI_SLIDE_D0
				EndIf
				
				slidingFrame += SUPER_SONIC_ANI_CHANGE_1
				Print("~~slidingFrame:" + slidingFrame)
				
				If (slidingFrame = SUPER_SONIC_ANI_CHANGE_2) Then
					soundInstance.playLoopSe(SONIC_ANI_SQUAT_1)
				EndIf
			EndIf
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= SUPER_SONIC_ANI_CHANGE_1
			EndIf
			
			If ((Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) And Self.faceDegree <> 90 And Self.faceDegree <> 270 And Self.attackLevel = 0) Then
				Self.animationID = SONIC_ANI_STAND
				Self.myAnimationID = ANIMATION_CONVERT[SONIC_ANI_STAND]
				
				If (Self.collisionState = COLLISION_STATE_JUMP) Then
					Self.animationID = SONIC_ANI_JUMP
					Self.myAnimationID = ANIMATION_CONVERT[SONIC_ANI_JUMP]
				EndIf
			EndIf
			
			Int v0
			Int startSpeedSet
			Select (Self.myAnimationID)
				Case SONIC_ANI_ATTACK_1
					
					If ((Self.attackCount = 0 Or getVelX() = 0) And Not Self.isStopByObject) Then
						Self.attackLevel = SONIC_ANI_STAND
					Else
						Self.myAnimationID = SONIC_ANI_ATTACK_1
					EndIf
					
					If (Self.isStopByObject And Self.attackCount = 0) Then
						Self.attackLevel = SONIC_ANI_STAND
					EndIf
					
					If (Key.press(Key.gSelect) And Not Self.isCrashPipe) Then
						Self.attackLevel = SUPER_SONIC_ANI_CHANGE_2
						Self.myAnimationID = SONIC_ANI_ATTACK_2
						soundInstance.playSe(SONIC_ANI_JUMP_DASH_1)
						v0 = Self.isInWater ? SONIC_ATTACK_LEVEL_2_V0_IN_WATER : PlayerObject.SONIC_ATTACK_LEVEL_2_V0
						
						If (Self.collisionState = Null) Then
							If (Self.faceDirection) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							
							If (Self.faceDirection) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						soundInstance.playSe(SONIC_ANI_JUMP_DASH_1)
						break
					EndIf
					
					break
				Case SONIC_ANI_ATTACK_2
					
					If (Not Self.drawer.checkEnd()) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_2
					ElseIf (Self.attackLevel = SUPER_SONIC_ANI_GO And (getVelX() <> 0 Or Self.isStopByObject)) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_3
						v0 = Self.isInWater ? SONIC_ATTACK_LEVEL_3_V0_IN_WATER : PlayerObject.SONIC_ATTACK_LEVEL_3_V0
						
						If (Self.collisionState = Null) Then
							If (Self.faceDirection) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							
							If (Self.faceDirection) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.attackCount = SONIC_ANI_JUMP_ATTACK_EFFECT
						soundInstance.playSe(SONIC_ANI_SPIN_2)
					ElseIf (Self.attackLevel = SONIC_ANI_JUMP) Then
						Int preVelX = Self.isStopByObject ? (Self.faceDirection ~ Self.isAntiGravity) <> 0 ? BACK_JUMP_SPEED_X : -384 : getVelX()
						
						If (Self.isInSnow) Then
							preVelX Shr= SUPER_SONIC_ANI_CHANGE_1
						EndIf
						
						Int start_v = Self.isInWater ? ATTACK4_ISINWATER_JUMP_START_V : ATTACK4_JUMP_START_V
						
						If (Self.isAntiGravity) Then
							startSpeedSet = -start_v
						Else
							startSpeedSet = start_v
						EndIf
						
						Super.doJumpV(startSpeedSet)
						Self.attackLevel = SONIC_ANI_STAND
						setVelX(-preVelX)
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_ATTACK_4
						Self.noVelMinus = True
					Else
						Self.animationID = SONIC_ANI_STAND
						Self.attackLevel = SONIC_ANI_STAND
						setVelX(SONIC_ANI_STAND)
						Self.totalVelocity = SONIC_ANI_STAND
					EndIf
					
					If (Self.attackLevel <> 0) Then
						If (Not Key.press(Key.gSelect)) Then
							If (Key.press(Key.B_HIGH_JUMP)) Then
								Self.attackLevel = SONIC_ANI_JUMP
								break
							EndIf
						EndIf
						
						Self.attackLevel = SUPER_SONIC_ANI_GO
						break
					EndIf
					
					break
				Case SONIC_ANI_ATTACK_3
					
					If (getVelX() <> 0 Or Self.isStopByObject) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_3
					Else
						Self.attackLevel = SONIC_ANI_STAND
					EndIf
					
					If (Self.isStopByObject And Self.attackCount = 0) Then
						Self.attackLevel = SONIC_ANI_STAND
						break
					EndIf
					
					break
				Default
					
					If (Not (Self.animationID = SONIC_ANI_JUMP Or Not Key.press(Key.gSelect) Or Self.slipping Or Self.animationID = SONIC_ANI_LOOK_UP_2 Or Self.isCrashFallingSand)) Then
						If (Self.onBank) Then
							Self.onBank = False
						EndIf
						
						Self.attackLevel = SUPER_SONIC_ANI_CHANGE_1
						Self.attackCount = (Self.isInWater ? SUPER_SONIC_ANI_CHANGE_2 : SUPER_SONIC_ANI_CHANGE_1) * SONIC_ANI_SPIN_2
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_ATTACK_1
						Self.isFirstAttack = True
						v0 = Self.isInWater ? SONIC_ATTACK_LEVEL_1_V0_IN_WATER : PlayerObject.SONIC_ATTACK_LEVEL_1_V0
						
						If (Self.collisionState = Null) Then
							If (Self.faceDirection) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							
							If (Self.faceDirection) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.drawer.setActionId(SONIC_ANI_ATTACK_1)
						Byte[] rect = Self.drawer.getARect()
						
						If (rect <> Null) Then
							Self.attackRect.initCollision(rect[SONIC_ANI_STAND] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_CHANGE_1] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_CHANGE_2] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_GO] Shl SONIC_ANI_SPIN_2, SONIC_ANI_ATTACK_1)
							Self.attackRectVec.addElement(Self.attackRect)
							break
						EndIf
					EndIf
					
					break
			End Select
			Self.isStopByObject = False
			
			If (Self.attackLevel = 0) Then
				Self.isAttacking = False
			Else
				Self.isAttacking = True
			EndIf
			
		End
		
		Protected Method extraLogicOnObject:Void()
			Self.firstJump = False
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= SUPER_SONIC_ANI_CHANGE_1
			EndIf
			
			If ((Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) And Self.attackLevel = 0) Then
				Self.animationID = SONIC_ANI_STAND
				Self.myAnimationID = ANIMATION_CONVERT[SONIC_ANI_STAND]
			EndIf
			
			Int v0
			Int startSpeedSet
			Select (Self.myAnimationID)
				Case SONIC_ANI_ATTACK_1
					
					If ((Self.attackCount = 0 Or getVelX() = 0) And Not Self.isStopByObject) Then
						Self.attackLevel = SONIC_ANI_STAND
					Else
						Self.myAnimationID = SONIC_ANI_ATTACK_1
					EndIf
					
					If (Self.isStopByObject And Self.attackCount = 0) Then
						Self.attackLevel = SONIC_ANI_STAND
					EndIf
					
					If (Key.press(Key.gSelect) And Not Self.isCrashPipe) Then
						Self.attackLevel = SUPER_SONIC_ANI_CHANGE_2
						Self.myAnimationID = SONIC_ANI_ATTACK_2
						soundInstance.playSe(SONIC_ANI_JUMP_DASH_1)
						v0 = Self.isInWater ? SONIC_ATTACK_LEVEL_2_V0_IN_WATER : PlayerObject.SONIC_ATTACK_LEVEL_2_V0
						
						If (Self.collisionState = Null) Then
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						soundInstance.playSe(SONIC_ANI_JUMP_DASH_1)
						break
					EndIf
					
					break
				Case SONIC_ANI_ATTACK_2
					
					If (Not Self.drawer.checkEnd()) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_2
					ElseIf (Self.attackLevel < SUPER_SONIC_ANI_GO Or (getVelX() = 0 And Not Self.isStopByObject)) Then
						Self.animationID = SONIC_ANI_STAND
						Self.attackLevel = SONIC_ANI_STAND
						setVelX(SONIC_ANI_STAND)
						Self.totalVelocity = SONIC_ANI_STAND
					Else
						Self.myAnimationID = SONIC_ANI_ATTACK_3
						v0 = Self.isInWater ? SONIC_ATTACK_LEVEL_3_V0_IN_WATER : PlayerObject.SONIC_ATTACK_LEVEL_3_V0
						
						If (Self.collisionState = Null) Then
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.attackCount = SONIC_ANI_JUMP_ATTACK_EFFECT
						soundInstance.playSe(SONIC_ANI_SPIN_2)
					EndIf
					
					If (Key.press(Key.gSelect)) Then
						Self.attackLevel = SUPER_SONIC_ANI_GO
						break
					EndIf
					
					break
				Case SONIC_ANI_ATTACK_3
					
					If (getVelX() <> 0 Or Self.isStopByObject) Then
						Self.myAnimationID = SONIC_ANI_ATTACK_3
					Else
						Self.attackLevel = SONIC_ANI_STAND
					EndIf
					
					If (Self.isStopByObject And Self.attackCount = 0) Then
						Self.attackLevel = SONIC_ANI_STAND
						break
					EndIf
					
					break
				Default
					
					If (Not (Self.animationID = SONIC_ANI_JUMP Or Not Key.press(Key.gSelect) Or Self.animationID = SONIC_ANI_LOOK_UP_2 Or Self.isCrashFallingSand)) Then
						Self.attackLevel = SUPER_SONIC_ANI_CHANGE_1
						Self.attackCount = (Self.isInWater ? SUPER_SONIC_ANI_CHANGE_2 : SUPER_SONIC_ANI_CHANGE_1) * SONIC_ANI_SPIN_2
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = SONIC_ANI_ATTACK_1
						Self.isFirstAttack = True
						v0 = Self.isInWater ? SONIC_ATTACK_LEVEL_1_V0_IN_WATER : PlayerObject.SONIC_ATTACK_LEVEL_1_V0
						
						If (Self.collisionState = Null) Then
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							Self.totalVelocity = startSpeedSet
						Else
							
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								startSpeedSet = startSpeedSet(Self.isInSnow, v0, SNOW_DIVIDE_COUNT)
							Else
								startSpeedSet = startSpeedSet(Self.isInSnow, -v0, SNOW_DIVIDE_COUNT)
							EndIf
							
							setVelX(startSpeedSet)
						EndIf
						
						Self.drawer.setActionId(SONIC_ANI_ATTACK_1)
						Byte[] rect = Self.drawer.getARect()
						
						If (rect <> Null) Then
							Self.attackRect.initCollision(rect[SONIC_ANI_STAND] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_CHANGE_1] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_CHANGE_2] Shl SONIC_ANI_SPIN_2, rect[SUPER_SONIC_ANI_GO] Shl SONIC_ANI_SPIN_2, SONIC_ANI_ATTACK_1)
							Self.attackRectVec.addElement(Self.attackRect)
							break
						EndIf
					EndIf
					
					break
			End Select
			Self.isStopByObject = False
			
			If (Self.attackLevel = 0) Then
				Self.isAttacking = False
			Else
				Self.isAttacking = True
			EndIf
			
		End
		
		Public Method doJump:Void()
			
			If (Self.myAnimationID <> SONIC_ANI_ATTACK_1 And Self.myAnimationID <> SONIC_ANI_ATTACK_2 And Self.myAnimationID <> SONIC_ANI_ATTACK_3) Then
				If (Self.slipping) Then
					If (Not isHeadCollision()) Then
						Self.currentLayer = 1
					Else
						Return
					EndIf
				EndIf
				
				If (Self.slipping And Self.totalVelocity = 192) Then
					Super.doJumpV()
				Else
					Super.doJump()
				EndIf
				
				Self.leftCount = SONIC_ANI_STAND
				Self.rightCount = SONIC_ANI_STAND
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
		
		Public Method doHurt:Void()
			Super.doHurt()
			
			If (Self.slipping) Then
				Self.currentLayer = 1
				Self.slipping = False
			EndIf
			
		End
		
		Public Method drawCharacter:Void(g:MFGraphics)
			Coordinate camera = MapManager.getCamera()
			
			If (isTerminal And terminalType = SUPER_SONIC_ANI_GO And terminalState >= SUPER_SONIC_ANI_CHANGE_2) Then
				Select (terminalState)
					Case SUPER_SONIC_ANI_CHANGE_2
					Case SUPER_SONIC_ANI_GO
						Self.SuperSonicAnimationID = SONIC_ANI_STAND
						break
					Case SONIC_ANI_JUMP
					Case SONIC_ANI_SPIN_1
						
						If (Not (Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_1 Or Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_2)) Then
							Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_1
							break
						EndIf
						
					Case SONIC_ANI_SPIN_2
						Self.SuperSonicAnimationID = SUPER_SONIC_ANI_GO
						break
				End Select
				Self.SuperSonicDrawer.setActionId(Self.SuperSonicAnimationID)
				Self.SuperSonicDrawer.setLoop(SUPER_SONIC_LOOP[Self.SuperSonicAnimationID])
				drawInMap(g, Self.SuperSonicDrawer, Self.posX + Self.terminalOffset, Self.posY)
				
				If (Self.SuperSonicDrawer.checkEnd()) Then
					Select (Self.SuperSonicAnimationID)
						Case SUPER_SONIC_ANI_CHANGE_1
							Self.SuperSonicAnimationID = SUPER_SONIC_ANI_CHANGE_2
							Return
						Default
							Return
					End Select
				EndIf
				
				Return
			EndIf
			
			If (Self.animationID <> NO_ANIMATION) Then
				Self.myAnimationID = ANIMATION_CONVERT[Self.animationID]
			EndIf
			
			If (Self.myAnimationID <> NO_ANIMATION) Then
				Bool loop
				Int trans
				Int drawY
				Byte[] rect
				
				If (LOOP_INDEX[Self.myAnimationID] = NO_ANIMATION) Then
					loop = True
				Else
					loop = False
				EndIf
				
				If (Self.hurtCount Mod SUPER_SONIC_ANI_CHANGE_2 = 0) Then
					Int bodyCenterX
					Int bodyCenterY
					
					If (Self.animationID <> SONIC_ANI_JUMP) Then
						If (Self.animationID <> SONIC_ANI_SPIN_2 And Self.animationID <> SONIC_ANI_LOOK_UP_1) Then
							Select (Self.myAnimationID)
								Case SONIC_ANI_SLIDE_D0
									Self.drawer.draw(g, Self.myAnimationID, ((Self.footPointX Shr SONIC_ANI_SPIN_2) - camera.x) + SONIC_ANI_STAND, ((Self.footPointY Shr SONIC_ANI_SPIN_2) - camera.y) + SONIC_ANI_STAND, loop, SONIC_ANI_STAND)
									
									If (Not Self.isInWater) Then
										Self.effectDrawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_1)
										break
									Else
										Self.effectDrawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_2)
										break
									EndIf
									
								Case SONIC_ANI_SLIDE_D45
									Self.effectDrawer.draw(g, SONIC_ANI_SLIDE_D45_EFFECT, ((Self.footPointX Shr SONIC_ANI_SPIN_2) - camera.x) + SONIC_ANI_LOOK_UP_2, ((Self.footPointY Shr SONIC_ANI_SPIN_2) - camera.y) + SONIC_ANI_STAND, loop, SONIC_ANI_STAND)
									Self.drawer.draw(g, Self.myAnimationID, ((Self.footPointX Shr SONIC_ANI_SPIN_2) - camera.x) + SONIC_ANI_LOOK_UP_2, ((Self.footPointY Shr SONIC_ANI_SPIN_2) - camera.y) + SONIC_ANI_STAND, loop, SONIC_ANI_STAND)
									
									If (Not Self.isInWater) Then
										Self.effectDrawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_1)
										break
									Else
										Self.effectDrawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_2)
										break
									EndIf
									
								Default
									
									If (Self.isInWater) Then
										Self.drawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_2)
									Else
										Self.drawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_1)
									EndIf
									
									If (Self.myAnimationID = SONIC_ANI_CLIFF_1 Or Self.myAnimationID = SONIC_ANI_CLIFF_2 Or Self.myAnimationID = SONIC_ANI_LOOK_UP_1 Or Self.myAnimationID = SONIC_ANI_LOOK_UP_2) Then
										Self.degreeForDraw = Self.degreeStable
										Self.faceDegree = Self.degreeStable
									EndIf
									
									If (Self.myAnimationID = SONIC_ANI_BRAKE) Then
										Self.degreeForDraw = Self.degreeStable
									EndIf
									
									If (Not (Self.myAnimationID = SUPER_SONIC_ANI_CHANGE_1 Or Self.myAnimationID = SUPER_SONIC_ANI_CHANGE_2 Or Self.myAnimationID = SUPER_SONIC_ANI_GO Or Self.myAnimationID = SONIC_ANI_CAUGHT)) Then
										Self.degreeForDraw = Self.degreeStable
									EndIf
									
									If (Self.fallinSandSlipState <> 0) Then
										If (Self.fallinSandSlipState = SUPER_SONIC_ANI_CHANGE_1) Then
											Self.faceDirection = True
										ElseIf (Self.fallinSandSlipState = SUPER_SONIC_ANI_CHANGE_2) Then
											Self.faceDirection = False
										EndIf
									EndIf
									
									If (Self.faceDirection) Then
										trans = SONIC_ANI_STAND
									Else
										trans = SUPER_SONIC_ANI_CHANGE_2
									EndIf
									
									If (Self.degreeForDraw = Self.faceDegree) Then
										drawDrawerByDegree(g, Self.drawer, Self.myAnimationID, (Self.footPointX Shr SONIC_ANI_SPIN_2) - camera.x, (Self.footPointY Shr SONIC_ANI_SPIN_2) - camera.y, loop, Self.degreeForDraw, Not Self.faceDirection)
										break
									EndIf
									
									bodyCenterX = getNewPointX(Self.footPointX, SONIC_ANI_STAND, (-Self.collisionRect.getHeight()) Shr SUPER_SONIC_ANI_CHANGE_1, Self.faceDegree)
									bodyCenterY = getNewPointY(Self.footPointY, SONIC_ANI_STAND, (-Self.collisionRect.getHeight()) Shr SUPER_SONIC_ANI_CHANGE_1, Self.faceDegree)
									g.saveCanvas()
									g.translateCanvas((bodyCenterX Shr SONIC_ANI_SPIN_2) - camera.x, (bodyCenterY Shr SONIC_ANI_SPIN_2) - camera.y)
									g.rotateCanvas((Float) Self.degreeForDraw)
									Self.drawer.draw(g, Self.myAnimationID, SONIC_ANI_STAND, (Self.collisionRect.getHeight() Shr SUPER_SONIC_ANI_CHANGE_1) Shr SONIC_ANI_SPIN_2, loop, trans)
									g.restoreCanvas()
									break
							End Select
						EndIf
						
						drawDrawerByDegree(g, Self.drawer, Self.myAnimationID, (Self.footPointX Shr SONIC_ANI_SPIN_2) - camera.x, (Self.footPointY Shr SONIC_ANI_SPIN_2) - camera.y, loop, Self.degreeForDraw, Not Self.faceDirection)
					Else
						bodyCenterX = getNewPointX(Self.footPointX, SONIC_ANI_STAND, -512, Self.faceDegree)
						bodyCenterY = getNewPointY(Self.footPointY, SONIC_ANI_STAND, -512, Self.faceDegree)
						Int drawX = getNewPointX(bodyCenterX, SONIC_ANI_STAND, BarHorbinV.COLLISION_OFFSET, SONIC_ANI_STAND)
						drawY = getNewPointY(bodyCenterY, SONIC_ANI_STAND, BarHorbinV.COLLISION_OFFSET, SONIC_ANI_STAND)
						
						If (Self.collisionState = Null) Then
							If (Self.isAntiGravity) Then
								If (Self.faceDirection) Then
									trans = Self.totalVelocity >= 0 ? SUPER_SONIC_ANI_GO : SUPER_SONIC_ANI_CHANGE_1
									drawY -= 1024
								Else
									trans = Self.totalVelocity > 0 ? SUPER_SONIC_ANI_GO : SUPER_SONIC_ANI_CHANGE_1
									drawY -= 1024
								EndIf
								
							ElseIf (Self.faceDirection) Then
								trans = Self.totalVelocity >= 0 ? SONIC_ANI_STAND : SUPER_SONIC_ANI_CHANGE_2
							Else
								trans = Self.totalVelocity > 0 ? SONIC_ANI_STAND : SUPER_SONIC_ANI_CHANGE_2
							EndIf
							
						ElseIf (Self.isAntiGravity) Then
							If (Self.faceDirection) Then
								trans = Self.velX <= 0 ? SUPER_SONIC_ANI_GO : SUPER_SONIC_ANI_CHANGE_1
								drawY -= 1024
							Else
								trans = Self.velX < 0 ? SUPER_SONIC_ANI_GO : SUPER_SONIC_ANI_CHANGE_1
								drawY -= 1024
							EndIf
							
						ElseIf (Self.faceDirection) Then
							trans = Self.velX >= 0 ? SONIC_ANI_STAND : SUPER_SONIC_ANI_CHANGE_2
						Else
							trans = Self.velX > 0 ? SONIC_ANI_STAND : SUPER_SONIC_ANI_CHANGE_2
						EndIf
						
						Self.drawer.draw(g, Self.myAnimationID, (drawX Shr SONIC_ANI_SPIN_2) - camera.x, (drawY Shr SONIC_ANI_SPIN_2) - camera.y, loop, trans)
					EndIf
					
				Else
					
					If (Self.myAnimationID <> Self.drawer.getActionId()) Then
						Self.drawer.setActionId(Self.myAnimationID)
					EndIf
					
					If (Not AnimationDrawer.isAllPause()) Then
						Self.drawer.moveOn()
					EndIf
				EndIf
				
				Select (Self.effectID)
					Case SUPER_SONIC_ANI_CHANGE_1
						drawY = SONIC_ANI_STAND
						
						If (Self.collisionState = Null) Then
							If (Not Self.faceDirection) Then
								trans = Self.totalVelocity > 0 ? SONIC_ANI_STAND : SUPER_SONIC_ANI_CHANGE_2
							ElseIf (Self.totalVelocity >= 0) Then
								trans = SONIC_ANI_STAND
							Else
								trans = SUPER_SONIC_ANI_CHANGE_2
							EndIf
							
						ElseIf (Self.isAntiGravity) Then
							If (Self.faceDirection) Then
								trans = Self.velX <= 0 ? SUPER_SONIC_ANI_GO : SUPER_SONIC_ANI_CHANGE_1
								drawY = SONIC_ANI_STAND - 1024
							Else
								trans = Self.velX < 0 ? SUPER_SONIC_ANI_GO : SUPER_SONIC_ANI_CHANGE_1
								drawY = SONIC_ANI_STAND - 1024
							EndIf
							
						ElseIf (Self.faceDirection) Then
							trans = Self.velX >= 0 ? SONIC_ANI_STAND : SUPER_SONIC_ANI_CHANGE_2
						Else
							trans = Self.velX > 0 ? SONIC_ANI_STAND : SUPER_SONIC_ANI_CHANGE_2
						EndIf
						
						Self.effectDrawer.draw(g, SONIC_ANI_JUMP_ATTACK_EFFECT, (Self.posX Shr SONIC_ANI_SPIN_2) - camera.x, (((Self.posY + (Self.isAntiGravity ? SpecialMap.MAP_LENGTH : SONIC_ANI_STAND)) Shr SONIC_ANI_SPIN_2) + (drawY Shr SONIC_ANI_SPIN_2)) - camera.y, False, trans)
						
						If (Not Self.isInWater) Then
							Self.effectDrawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_1)
							break
						Else
							Self.effectDrawer.setSpeed(SUPER_SONIC_ANI_CHANGE_1, SUPER_SONIC_ANI_CHANGE_2)
							break
						EndIf
						
				End Select
				
				If (Self.effectDrawer.checkEnd()) Then
					Self.effectID = SONIC_ANI_STAND
				EndIf
				
				Self.attackRectVec.removeAllElements()
				
				If (Self.effectID = SUPER_SONIC_ANI_CHANGE_1) Then
					rect = Self.effectDrawer.getARect()
				Else
					rect = Self.drawer.getARect()
				EndIf
				
				If (Self.isAntiGravity) Then
					Byte[] rectTmp = Self.drawer.getARect()
					
					If (rectTmp <> Null) Then
						rect[SONIC_ANI_STAND] = (Byte) ((-rectTmp[SONIC_ANI_STAND]) - rectTmp[SUPER_SONIC_ANI_CHANGE_2])
						rect[SUPER_SONIC_ANI_CHANGE_1] = (Byte) ((-rectTmp[SUPER_SONIC_ANI_CHANGE_1]) - rectTmp[SUPER_SONIC_ANI_GO])
					EndIf
				EndIf
				
				If (rect <> Null) Then
					Int i
					
					If (SonicDebug.showCollisionRect) Then
						g.setColor(65280)
						g.drawRect(((Self.footPointX Shr SONIC_ANI_SPIN_2) + rect[SONIC_ANI_STAND]) - camera.x..((Self.footPointY Shr SONIC_ANI_SPIN_2) + rect[SUPER_SONIC_ANI_CHANGE_1]) - camera.y, rect[SUPER_SONIC_ANI_CHANGE_2], rect[SUPER_SONIC_ANI_GO])
					EndIf
					
					PlayerAnimationCollisionRect playerAnimationCollisionRect = Self.attackRect
					Int i2 = rect[SONIC_ANI_STAND] Shl SONIC_ANI_SPIN_2
					Int i3 = rect[SUPER_SONIC_ANI_CHANGE_1] Shl SONIC_ANI_SPIN_2
					Int i4 = rect[SUPER_SONIC_ANI_CHANGE_2] Shl SONIC_ANI_SPIN_2
					Int i5 = rect[SUPER_SONIC_ANI_GO] Shl SONIC_ANI_SPIN_2
					
					If (Self.effectID = SUPER_SONIC_ANI_CHANGE_1) Then
						i = SONIC_ANI_JUMP_ATTACK_EFFECT
					Else
						Int i6 = Self.myAnimationID
					EndIf
					
					playerAnimationCollisionRect.initCollision(i2, i3, i4, i5, i)
					Self.attackRectVec.addElement(Self.attackRect)
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
						soundInstance.playSe(SONIC_ANI_JUMP)
					EndIf
					
					Self.isFirstAttack = False
				EndIf
			EndIf
			
		End
		
		Public Method doWhileLand:Void(degree:Int)
			Super.doWhileLand(degree)
			Self.firstJump = False
		End
		
		Public Method extraInputLogic:Void()
			
			If (isTerminal And terminalState >= SUPER_SONIC_ANI_CHANGE_2) Then
				Select (terminalState)
					Case SONIC_ANI_JUMP
						Self.velX = SONIC_ANI_STAND
					Default
				End Select
			EndIf
			
		End
		
		Public Method getRetPower:Int()
			Int retPower = Super.getRetPower()
			
			If (speedCount > 0 And Self.myAnimationID >= SONIC_ANI_ATTACK_1 And Self.myAnimationID <= SONIC_ANI_ATTACK_2) Then
				retPower /= SUPER_SONIC_ANI_CHANGE_2
			EndIf
			
			If (Self.myAnimationID = SONIC_ANI_ATTACK_3) Then
				Return 150
			EndIf
			
			Return retPower
		End
		
		Public Method needRetPower:Bool()
			
			If (Self.slipping) Then
				Return False
			EndIf
			
			If (Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) Then
				Return True
			EndIf
			
			Return Super.needRetPower()
		End
		
		Public Method getSlopeGravity:Int()
			
			If (Self.slipping) Then
				Return SONIC_ANI_STAND
			EndIf
			
			Return Super.getSlopeGravity()
		End
		
		Public Method noRotateDraw:Bool()
			
			If (Self.myAnimationID = SONIC_ANI_ATTACK_1 Or Self.myAnimationID = SONIC_ANI_ATTACK_2 Or Self.myAnimationID = SONIC_ANI_ATTACK_3) Then
				Return True
			EndIf
			
			Return Super.noRotateDraw()
		End
		
		Public Method beSpring:Void(springPower:Int, direction:Int)
			Super.beSpring(springPower, direction)
			
			If (Self.attackLevel <> 0) Then
				Self.attackLevel = SONIC_ANI_STAND
				Self.attackCount = SONIC_ANI_STAND
				Select (direction)
					Case SUPER_SONIC_ANI_CHANGE_2
					Case SUPER_SONIC_ANI_GO
						Self.animationID = SUPER_SONIC_ANI_GO
						
						If (Key.repeated(Key.gDown)) Then
							Self.animationID = SONIC_ANI_JUMP
						EndIf
						
					Default
				End Select
			EndIf
			
		End
		
		Public Method beAccelerate:Bool(power:Int, IsX:Bool, sender:GameObject)
			Bool re = Super.beAccelerate(power, IsX, sender)
			
			If (Self.attackLevel <> 0) Then
				Self.attackLevel = SONIC_ANI_STAND
				Self.attackCount = SONIC_ANI_STAND
				Self.animationID = SUPER_SONIC_ANI_GO
				
				If (Key.repeated(Key.gDown)) Then
					Self.animationID = SONIC_ANI_JUMP
				EndIf
			EndIf
			
			Return re
		End
End