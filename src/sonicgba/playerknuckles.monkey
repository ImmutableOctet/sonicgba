Strict

Public

' Imports:
Private
	'Import gameengine.def
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.myapi
	Import lib.soundsystem
	Import lib.constutil
	
	import sonicgba.effect
	import sonicgba.gameobject
	import sonicgba.mapmanager
	import sonicgba.playeranimationcollisionrect
	import sonicgba.playerobject
	import sonicgba.sonicdebug
	import sonicgba.stagemanager
	
	import com.sega.engine.action.acworld
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class PlayerKnuckles Extends PlayerObject
	Private
		' Constant variable(s):
		Global ANIMATION_CONVERT:Int[] = [0, 1, 2, 3, 4, 10, 5, 6, 23, 14, 18, -1, 25, 44, 15, -1, -1, 56, -1, -1, -1, 57, 41, 42, 43, 39, 40, 46, 47, 48, 25, 45, 49, 50, 51, 52, 53, 54, 7, 8, 7, 27, 16, 17, 25, 26, 9, 37, 38, 36, 61, 62, 60, 55] ' Const
		
		Const ATTACK_LEVEL_1:Int = 1
		Const ATTACK_LEVEL_2:Int = 2
		Const ATTACK_LEVEL_3:Int = 3
		Const ATTACK_LEVEL_NONE:Int = 0
		
		Const DRIP_SPEED_Y_LIMIT:Int = 128
		Const FALL_ADD_SPEED:Int = 337
		
		Const FLY_DEGREE_VELOCITY:Int = 20
		Const FLY_DOWN_SPEED:Int = 90
		Const FLY_GROUND_SPEED:Int = 64
		Const FLY_MAX_SPEED:Int = 4608
		Const FLY_MIN_SPEED:Int = 768
		Const FLY_SPEED_PLUS:Int = 22
		Const FLY_START_ADD_Y_SPEED:Int = 384
		Const FLY_START_X_SPEED:Int = 768
		Const FLY_VELOCITY:Int = 600
		
		Const KNUCKLES_ATTACK_1_COUNT:Int = 4
		Const KNUCKLES_ATTACK_2_COUNT:Int = 4
		Const KNUCKLES_ATTACK_3_COUNT:Int = 6
		
		Const LOOP:Int = -1
		
		Global LOOP_INDEX:Int[] = [-1, -1, -1, -1, -1, -1, -1, 8, -1, -2, -1, 0, 0, 18, 17, -1, 17, 18, -1, -1, -1, -1, -1, -1, 25, -1, 27, -1, -1, 30, -1, -1, -1, 0, -1, -1, -2, -1, -1, 40, 39, 42, 41, -1, 15, 3, -1, -1, -1, -1, -1, -1, 53, -1, -2, 0, -1, -1, -1, -1, 62, 62, -1, 0] ' Const
		
		Const NORMAL_FRAME_INTERVAL:Int = 3
		
		Const NO_ANIMATION:Int = -1
		Const NO_LOOP:Int = -2
		Const NO_LOOP_DEPAND:Int = -2
		
		Const PUNCH_MOVE01:Int = 768
		
		Const UPPER_INWATER_SPEED:Int = 832
		Const UPPER_SPEED:Int = 719
		
		Const WALL_CLIMB_SPEED:Int = 192
		Const WALL_CLIMB_SPEED_W:Int = 256
		
		Const WATER_FRAME_INTERVAL:Int = 6
		
		' Global variable(s):
		Global slipbrakeFrame:Int
		
		' Fields:
		Field attackRect:PlayerAnimationCollisionRect
		
		Field effectDrawer:AnimationDrawer
		
		Field knucklesDrawer1:AnimationDrawer
		Field knucklesDrawer2:AnimationDrawer
		
		Field attackCount:Int
		Field attackLevel:Int
		Field attackLevelNext:Int
		Field flyDegree:Int
		Field flyDegreeStable:Int
		Field flySpeed:Int
		Field waterframe:Int
		
		Field Floating:Bool
		Field isSlipActived:Bool
		Field preWaterFlag:Bool
		Field swimWaterEffectFlag:Bool
	Public
		' Constant variable(s):
		Const COLLISION_STATE_CLIMB:Int = 4
		
		Const KNUCKLES_ANI_ATTACK_1:Int = 11
		Const KNUCKLES_ANI_ATTACK_2:Int = 12
		Const KNUCKLES_ANI_ATTACK_3:Int = 13
		Const KNUCKLES_ANI_BANK_1:Int = 49
		Const KNUCKLES_ANI_BANK_2:Int = 50
		Const KNUCKLES_ANI_BANK_3:Int = 51
		Const KNUCKLES_ANI_BAR_MOVE:Int = 47
		Const KNUCKLES_ANI_BAR_STAY:Int = 46
		Const KNUCKLES_ANI_BRAKE:Int = 56
		Const KNUCKLES_ANI_BREATHE:Int = 36
		Const KNUCKLES_ANI_CAUGHT:Int = 60
		Const KNUCKLES_ANI_CELEBRATE_1:Int = 52
		Const KNUCKLES_ANI_CELEBRATE_2:Int = 53
		Const KNUCKLES_ANI_CELEBRATE_3:Int = 54
		Const KNUCKLES_ANI_CLIFF_1:Int = 37
		Const KNUCKLES_ANI_CLIFF_2:Int = 38
		Const KNUCKLES_ANI_CLIMB_1:Int = 29
		Const KNUCKLES_ANI_CLIMB_2:Int = 30
		Const KNUCKLES_ANI_CLIMB_3:Int = 31
		Const KNUCKLES_ANI_CLIMB_4:Int = 32
		Const KNUCKLES_ANI_CLIMB_5:Int = 33
		Const KNUCKLES_ANI_DEAD_1:Int = 26
		Const KNUCKLES_ANI_DEAD_2:Int = 27
		Const KNUCKLES_ANI_ENTER_SP:Int = 58
		Const KNUCKLES_ANI_FLY_1:Int = 19
		Const KNUCKLES_ANI_FLY_2:Int = 20
		Const KNUCKLES_ANI_FLY_3:Int = 21
		Const KNUCKLES_ANI_FLY_4:Int = 22
		Const KNUCKLES_ANI_HURT_1:Int = 24
		Const KNUCKLES_ANI_HURT_2:Int = 25
		Const KNUCKLES_ANI_JUMP:Int = 4
		Const KNUCKLES_ANI_LOOK_UP_1:Int = 7
		Const KNUCKLES_ANI_LOOK_UP_2:Int = 8
		Const KNUCKLES_ANI_POLE_H:Int = 45
		Const KNUCKLES_ANI_POLE_V:Int = 44
		Const KNUCKLES_ANI_PUSH_WALL:Int = 23
		Const KNUCKLES_ANI_RAIL_BODY:Int = 57
		Const KNUCKLES_ANI_ROLL_H_1:Int = 41
		Const KNUCKLES_ANI_ROLL_H_2:Int = 42
		Const KNUCKLES_ANI_ROLL_V_1:Int = 39
		Const KNUCKLES_ANI_ROLL_V_2:Int = 40
		Const KNUCKLES_ANI_RUN:Int = 3
		Const KNUCKLES_ANI_SPIN_1:Int = 5
		Const KNUCKLES_ANI_SPIN_2:Int = 6
		Const KNUCKLES_ANI_SPRING_1:Int = 14
		Const KNUCKLES_ANI_SPRING_2:Int = 15
		Const KNUCKLES_ANI_SPRING_3:Int = 16
		Const KNUCKLES_ANI_SPRING_4:Int = 17
		Const KNUCKLES_ANI_SPRING_5:Int = 18
		Const KNUCKLES_ANI_SQUAT_1:Int = 9
		Const KNUCKLES_ANI_SQUAT_2:Int = 10
		Const KNUCKLES_ANI_STAND:Int = 0
		Const KNUCKLES_ANI_SWIM_1:Int = 28
		Const KNUCKLES_ANI_SWIM_2:Int = 34
		Const KNUCKLES_ANI_SWIM_3:Int = 35
		Const KNUCKLES_ANI_SWIM_EFFECT:Int = 59
		Const KNUCKLES_ANI_UP_ARM:Int = 43
		Const KNUCKLES_ANI_VS_KNUCKLE:Int = 55
		Const KNUCKLES_ANI_WAITING_1:Int = 61
		Const KNUCKLES_ANI_WAITING_2:Int = 62
		Const KNUCKLES_ANI_WALK_1:Int = 1
		Const KNUCKLES_ANI_WALK_2:Int = 2
		Const KNUCKLES_ANI_WIND:Int = 48
		
		' Fields:
		Field flying:Bool
		
		' Constructor(s):
		Method New()
			Self.swimWaterEffectFlag = False
			Self.Floating = False
			
			Local chaImage:= MFImage.createImage("/animation/player/chr_knuckles.png")
			Local animation1:= New Animation(chaImage, "/animation/player/chr_knuckles_01")
			
			Self.knucklesDrawer1 = animation1.getDrawer()
			Self.effectDrawer = animation1.getDrawer()
			
			Self.knucklesDrawer2 = New Animation(chaImage, "/animation/player/chr_knuckles_02").getDrawer()
			
			Self.drawer = Self.knucklesDrawer1
			
			Self.attackRect = New PlayerAnimationCollisionRect(Self)
		End
		
		' Methods:
		Method closeImpl:Void()
			Animation.closeAnimationDrawer(Self.knucklesDrawer1)
			Self.knucklesDrawer1 = Null
			
			Animation.closeAnimationDrawer(Self.knucklesDrawer2)
			Self.knucklesDrawer2 = Null
			
			Animation.closeAnimationDrawer(Self.effectDrawer)
			Self.effectDrawer = Null
		End
		
		Method drawCharacter:Void(g:MFGraphics)
			Local camera:= MapManager.getCamera()
			
			If (Self.animationID <> NO_ANIMATION) Then
				Self.myAnimationID = ANIMATION_CONVERT[Self.animationID]
			EndIf
			
			If (Self.myAnimationID <> NO_ANIMATION) Then
				Local loop:Bool = (LOOP_INDEX[Self.myAnimationID] = NO_ANIMATION)
				
				Self.drawer = Self.knucklesDrawer1
				
				Local drawerActionID:= Self.myAnimationID
				
				If (Self.myAnimationID >= KNUCKLES_ANI_WAITING_1) Then
					Self.drawer = Self.knucklesDrawer2
					
					drawerActionID = (Self.myAnimationID - KNUCKLES_ANI_WAITING_1)
					
					If (Self.myAnimationID = KNUCKLES_ANI_WAITING_1 And Self.isResetWaitAni) Then
						Self.drawer.restart()
						
						Self.isResetWaitAni = False
					EndIf
				EndIf
				
				If (Self.isInWater) Then
					Self.drawer.setSpeed(1, 2)
				Else
					Self.drawer.setSpeed(1, 1)
				EndIf
				
				If ((Self.hurtCount Mod 2) <> 0) Then
					If (drawerActionID <> Self.drawer.getActionId()) Then
						Self.drawer.setActionId(drawerActionID)
					EndIf
					
					If (Not AnimationDrawer.isAllPause()) Then
						Self.drawer.moveOn()
					EndIf
				ElseIf (Self.animationID = KNUCKLES_ANI_JUMP) Then
					' Magic numbers: -512, 512
					bodyCenterX = getNewPointX(Self.footPointX, 0, -512, Self.faceDegree) ' -(SIDE_FOOT_FROM_CENTER * 2) ' -(WIDTH / 2)
					bodyCenterY = getNewPointY(Self.footPointY, 0, -512, Self.faceDegree)
					
					Local drawX:= getNewPointX(bodyCenterX, 0, 512, 0) ' (SIDE_FOOT_FROM_CENTER * 2) ' (WIDTH / 2)
					Local drawY:= getNewPointY(bodyCenterY, 0, 512, 0)
					
					If (Self.collisionState = Null) Then
						If (Self.isAntiGravity) Then
							If (Self.faceDirection) Then
								trans = PickValue(Self.totalVelocity >= 0, TRANS_ROT180, TRANS_MIRROR_ROT180)
								
								drawY -= WIDTH
							Else
								trans = PickValue((Self.totalVelocity > 0), TRANS_ROT180, TRANS_MIRROR_ROT180)
								
								drawY -= WIDTH
							EndIf
						ElseIf (Self.faceDirection) Then
							trans = PickValue((Self.totalVelocity >= 0), TRANS_NONE, TRANS_MIRROR)
						Else
							trans = PickValue((Self.totalVelocity > 0), TRANS_NONE, TRANS_MIRROR)
						EndIf
						
					ElseIf (Self.isAntiGravity) Then
						If (Self.faceDirection) Then
							trans = PickValue((Self.velX <= 0), TRANS_ROT180, TRANS_MIRROR_ROT180)
							
							drawY -= WIDTH
						Else
							trans = PickValue((Self.velX < 0), TRANS_ROT180, TRANS_MIRROR_ROT180)
							
							drawY -= WIDTH
						EndIf
						
					ElseIf (Self.faceDirection) Then
						trans = PickValue((Self.velX >= 0), TRANS_NONE, TRANS_MIRROR)
					Else
						trans = PickValue((Self.velX > 0), TRANS_NONE : TRANS_MIRROR)
					EndIf
					
					Self.drawer.draw(g, drawerActionID, (drawX Shr 6) - camera.x, (drawY Shr 6) - camera.y, loop, trans)
				ElseIf (Self.animationID = WATER_FRAME_INTERVAL Or Self.animationID = KNUCKLES_ANI_LOOK_UP_1) Then
					drawDrawerByDegree(g, Self.drawer, drawerActionID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, loop, Self.degreeForDraw, Not Self.faceDirection)
				Else
					If (Self.myAnimationID = KNUCKLES_ANI_FLY_1 Or Self.myAnimationID = KNUCKLES_ANI_FLY_2 Or Self.myAnimationID = KNUCKLES_ANI_FLY_3 Or Self.myAnimationID = KNUCKLES_ANI_SWIM_1) Then
						Local degre:Int
						
						If (Self.flyDegree >= 0) Then
							If (Self.isAntiGravity) Then
								degre = TRANS_MIRROR_ROT180
							Else
								degre = TRANS_NONE
							EndIf
						ElseIf (Self.isAntiGravity) Then
							degre = TRANS_ROT180
						Else
							degre = TRANS_MIRROR
						EndIf
						
						Self.drawer.draw(g, drawerActionID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, loop, degre)
					Else
						If (Self.myAnimationID = KNUCKLES_ANI_CLIFF_1 Or Self.myAnimationID = KNUCKLES_ANI_CLIFF_2 Or Self.myAnimationID = KNUCKLES_ANI_LOOK_UP_1 Or Self.myAnimationID = KNUCKLES_ANI_LOOK_UP_2) Then
							Self.degreeForDraw = Self.degreeStable
							Self.faceDegree = Self.degreeStable
						EndIf
						
						If (Self.myAnimationID = KNUCKLES_ANI_BRAKE) Then
							Self.degreeForDraw = Self.degreeStable
						EndIf
						
						If (Not (Self.myAnimationID = KNUCKLES_ANI_WALK_1 Or Self.myAnimationID = KNUCKLES_ANI_WALK_2 Or Self.myAnimationID = NORMAL_FRAME_INTERVAL Or Self.myAnimationID = KNUCKLES_ANI_CAUGHT)) Then
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
							trans = TRANS_MIRROR_ROT180
						EndIf
						
						If (Self.degreeForDraw <> Self.faceDegree) Then
							bodyCenterX = getNewPointX(Self.footPointX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree) ' Shr 1
							bodyCenterY = getNewPointY(Self.footPointY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree) ' Shr 1
							
							g.saveCanvas()
							
							g.translateCanvas((bodyCenterX Shr 6) - camera.x, (bodyCenterY Shr 6) - camera.y)
							g.rotateCanvas(Float(Self.degreeForDraw))
							
							Self.drawer.draw(g, drawerActionID, 0, (Self.collisionRect.getHeight() / 2) Shr 6, loop, trans) ' Shr 1
							
							g.restoreCanvas()
						Else
							Local x:= ((Self.footPointX Shr 6) - camera.x)
							Local y:= ((Self.footPointY Shr 6) - camera.y)
							
							drawDrawerByDegree(g, Self.drawer, drawerActionID, x, y, loop, Self.degreeForDraw, Not Self.faceDirection)
						EndIf
					EndIf
					
					If (Self.myAnimationID = KNUCKLES_ANI_SWIM_2 And Self.swimWaterEffectFlag) Then
						Self.effectDrawer.draw(g, KNUCKLES_ANI_SWIM_EFFECT, (Self.footPointX Shr 6) - camera.x, (((StageManager.getWaterLevel() Shl 6) Shr 6) + 14) - camera.y, True, getTrans()) ' + KNUCKLES_ANI_SPRING_1
					EndIf
				EndIf
				
				Self.attackRectVec.Clear()
				
				Local rect:= Self.drawer.getARect()
				
				If (Self.isAntiGravity) Then
					Local rectTmp:= Self.drawer.getARect()
					
					If (rectTmp.Length > 0) Then
						If (Self.attackLevel <> 0) Then
							rect[0] = Byte((-rectTmp[0]) - rectTmp[2])
						Else
							If (Self.flying And Self.faceDirection) Then
								rect[0] = Byte((-rectTmp[0]) - rectTmp[2])
							EndIf
							
							rect[1] = Byte((-rectTmp[1]) - rectTmp[3])
						EndIf
					EndIf
				EndIf
				
				If (rect <> Null) Then
					If (SonicDebug.showCollisionRect) Then
						g.setColor(65280)
						
						g.drawRect(((Self.footPointX Shr 6) + rect[0]) - camera.x..((Self.footPointY Shr 6) + PickValue(Self.isAntiGravity, (-rect[1]) - rect[3], rect[1])) - camera.y, rect[2], rect[3])
					EndIf
					
					Self.attackRect.initCollision(rect[0] Shl 6, rect[1] Shl 6, rect[2] Shl 6, rect[3] Shl 6, Self.myAnimationID)
					
					Self.attackRectVec.Push(Self.attackRect)
				Else
					Self.attackRect.reset()
				EndIf
				
				If (Self.animationID = NO_ANIMATION) Then
					If (Self.drawer.checkEnd()) Then
						If (LOOP_INDEX[Self.myAnimationID] >= 0) Then
							Select (Self.myAnimationID)
								Case KNUCKLES_ANI_CLIMB_5
									Self.canAttackByHari = True
									
									Self.collisionState = COLLISION_STATE_JUMP
									
									' Magic number: 1
									Self.worldCal.actionState = 1
							End Select
							
							Self.myAnimationID = LOOP_INDEX[Self.myAnimationID]
						EndIf
					EndIf
				EndIf
			EndIf
		End
		
		Public Method beSpring:Void(springPower:Int, direction:Int)
			
			If ((Self.myAnimationID = KNUCKLES_ANI_FLY_3 Or Self.myAnimationID = KNUCKLES_ANI_FLY_4) And (direction = NORMAL_FRAME_INTERVAL Or direction = 2)) Then
				Self.flying = False
				Self.animationID = KNUCKLES_ANI_STAND
			EndIf
			
			Super.beSpring(springPower, direction)
		End
		
		Protected Method extraLogicJump:Void()
			Bool z
			
			If (Self.myAnimationID = KNUCKLES_ANI_FLY_1 Or Self.myAnimationID = KNUCKLES_ANI_FLY_2 Or Self.myAnimationID = KNUCKLES_ANI_FLY_3 Or Self.myAnimationID = KNUCKLES_ANI_SWIM_1) Then
				z = True
			Else
				z = False
			EndIf
			
			Self.flying = z
			Int i
			
			If (Self.flying) Then
				If (Key.repeated(Key.B_HIGH_JUMP | Key.gUp)) Then
					If (Self.flySpeed < PUNCH_MOVE01) Then
						Self.flySpeed += KNUCKLES_ANI_FLY_4
					ElseIf (Self.flySpeed < FLY_MAX_SPEED And (Self.flyDegree = FLY_DOWN_SPEED Or Self.flyDegree = -90)) Then
						Self.flySpeed += KNUCKLES_ANI_ATTACK_1
					EndIf
					
					If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
						i = FLY_DOWN_SPEED
					Else
						i = -90
					EndIf
					
					Self.flyDegreeStable = i
					Self.flyDegree = MyAPI.calNextPosition((Double) Self.flyDegree, (Double) Self.flyDegreeStable, 1, 100, 20.0)
					Self.velX = (Self.flySpeed * MyAPI.dSin(Self.flyDegree)) / 100
					
					If (Self.isAntiGravity) Then
						If (Self.velY > def.TOUCH_HELP_LEFT_X) Then
							Self.velY -= FLY_DOWN_SPEED
						Else
							Self.velY += FLY_DOWN_SPEED
						EndIf
						
						Self.velY += getGravity()
					Else
						
						If (Self.velY < DRIP_SPEED_Y_LIMIT) Then
							Self.velY += FLY_DOWN_SPEED
						Else
							Self.velY -= FLY_DOWN_SPEED
						EndIf
						
						Self.velY -= getGravity()
					EndIf
					
					If (Abs(Self.flyDegree) >= 75) Then
						Self.myAnimationID = KNUCKLES_ANI_FLY_1
						
						If (Self.isInWater) Then
							Self.myAnimationID = KNUCKLES_ANI_SWIM_1
						EndIf
						
					ElseIf (Abs(Self.flyDegree) >= KNUCKLES_ANI_HURT_2) Then
						Self.myAnimationID = KNUCKLES_ANI_FLY_2
					Else
						Self.myAnimationID = KNUCKLES_ANI_FLY_3
					EndIf
					
				Else
					Self.flying = False
					Self.myAnimationID = KNUCKLES_ANI_SPRING_4
					Self.velX Shr= 2
				EndIf
				
			ElseIf (Self.animationID = KNUCKLES_ANI_JUMP And Self.doJumpForwardly And Key.press(Key.B_HIGH_JUMP | Key.gUp)) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = KNUCKLES_ANI_FLY_1
				
				If (Self.isInWater) Then
					Self.myAnimationID = KNUCKLES_ANI_SWIM_1
				EndIf
				
				Self.flyDegreeStable = PickValue((Self.isAntiGravity <> Self.faceDirection), FLY_DOWN_SPEED, -FLY_DOWN_SPEED) ' 90 ' -90
				
				Self.velY = 0
				
				Self.flyDegree = Self.flyDegreeStable
				
				Self.flying = True
				
				Self.velY += FLY_START_ADD_Y_SPEED
				
				If (Self.velY < 0) Then
					Self.velY = 0
				EndIf
				
				Self.velY -= getGravity()
				Self.flySpeed = PUNCH_MOVE01
				i = Self.footPointY - 512
				Self.footPointY = i
				Self.posY = i
			EndIf
			
			Floatchk()
			Int waterLevel = StageManager.getWaterLevel() Shl 6
			
			If (Self.Floating) Then
				Self.breatheCount = 0
			EndIf
			
			If (Not Self.Floating Or Not Self.isInWater) Then
				Return
			EndIf
			
			If (Key.press(Key.gDown)) Then
				Self.Floating = False
				Self.animationID = KNUCKLES_ANI_SQUAT_2
			ElseIf (Key.press(Key.B_HIGH_JUMP)) Then
				doJump()
				Self.velY = (Self.velY * NORMAL_FRAME_INTERVAL) / KNUCKLES_ANI_SPIN_1
				Self.Floating = False
			Else
				Int bodyCenterY = getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) Shr 1, Self.faceDegree)
				Self.animationID = NO_ANIMATION
				
				If (Key.repeated(Key.B_LOOK)) Then
					Self.myAnimationID = KNUCKLES_ANI_SWIM_3
					Self.focusMovingState = 1
				ElseIf (bodyCenterY - 320 <= waterLevel) Then
					Self.myAnimationID = KNUCKLES_ANI_SWIM_2
				EndIf
				
				If (Self.Floating) Then
					Self.velY -= getGravity()
					Self.velY -= FALL_ADD_SPEED
					Self.velY = Max(-1920, Self.velY)
					Self.velY = Max(waterLevel - bodyCenterY, Self.velY)
				EndIf
				
				Self.swimWaterEffectFlag = False
				
				If (Abs(bodyCenterY - waterLevel) < MDPhone.SCREEN_HEIGHT) Then
					Self.swimWaterEffectFlag = True
				Else
					resetBreatheCount()
				EndIf
			EndIf
			
		End
		
		Public Method dripDownUnderWater:Void()
			
			If (Self.Floating) Then
				Self.Floating = False
				Self.animationID = KNUCKLES_ANI_SQUAT_2
			EndIf
			
		End
		
		Private Method slipBrakeNoise:Void()
			
			If (Not Self.isSlipActived) Then
				SoundSystem soundSystem = soundInstance
				SoundSystem soundSystem2 = soundInstance
				soundSystem.playSequenceSe(WATER_FRAME_INTERVAL)
				Self.isSlipActived = True
			EndIf
			
		End
		
		Protected Method extraLogicWalk:Void()
			Int i
			Self.flying = False
			Self.Floating = False
			
			If (Self.myAnimationID = KNUCKLES_ANI_FLY_4) Then
				If (Self.totalVelocity = 0) Then
					Self.animationID = KNUCKLES_ANI_STAND
					Self.isSlipActived = False
				ElseIf (Not Key.repeated(Key.B_HIGH_JUMP | Key.gUp) Or ((Self.faceDegree >= KNUCKLES_ANI_POLE_H And Self.faceDegree <= 315 And Not Self.isAntiGravity) Or (Self.faceDegree < KNUCKLES_ANI_POLE_H And Self.faceDegree > 315 And Self.isAntiGravity))) Then
					Self.animationID = KNUCKLES_ANI_STAND
					Self.velX = 0
					Self.isSlipActived = False
				Else
					
					If (Self.faceDirection) Then
						Self.totalVelocity = Abs(Self.totalVelocity)
					Else
						Self.totalVelocity = -Abs(Self.totalVelocity)
					EndIf
					
					Int preTotalVelocity = Self.totalVelocity
					Int i2 = Self.totalVelocity
					
					If (Self.faceDirection) Then
						i = 1
					Else
						i = NO_ANIMATION
					EndIf
					
					Self.totalVelocity = i2 - (i * FLY_GROUND_SPEED)
					
					If (Self.totalVelocity * preTotalVelocity <= 0) Then
						Self.totalVelocity = 0
					EndIf
					
					Effect.showEffect(Self.dustEffectAnimation, 2, Self.posX Shr 6, Self.posY Shr 6, 0)
					slipBrakeNoise()
				EndIf
			EndIf
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= 1
			EndIf
			
			SoundSystem soundSystem
			SoundSystem soundSystem2
			Select (Self.attackLevel)
				Case 0
					
					If ((Self.animationID = KNUCKLES_ANI_STAND Or Self.animationID = KNUCKLES_ANI_WALK_1 Or Self.animationID = KNUCKLES_ANI_WALK_2 Or Self.animationID = NORMAL_FRAME_INTERVAL Or Self.animationID = KNUCKLES_ANI_BAR_MOVE Or Self.animationID = KNUCKLES_ANI_WIND Or Self.animationID = KNUCKLES_ANI_SPIN_1) And Key.press(Key.gSelect) And Self.myAnimationID <> KNUCKLES_ANI_PUSH_WALL) Then
						Self.attackLevel = 1
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = KNUCKLES_ANI_ATTACK_1
						
						calDivideVelocity()
						
						Self.velX = (DSgn(Self.isAntiGravity <> Self.faceDirection) * PUNCH_MOVE01)
						
						calTotalVelocity()
						
						If (Self.isInWater) Then
							i2 = 2
						Else
							i2 = 1
						EndIf
						
						Self.attackCount = i2 * KNUCKLES_ATTACK_2_COUNT
						Self.attackLevelNext = 0
						soundSystem = soundInstance
						soundSystem2 = soundInstance
						soundSystem.playSe(KNUCKLES_ANI_FLY_1)
						Self.drawer.setActionId(KNUCKLES_ANI_ATTACK_1)
						break
					EndIf
					
				Case KNUCKLES_ANI_WALK_1
					
					If (Self.attackCount <> 0) Then
						If (Key.press(Key.gSelect)) Then
							Self.attackLevelNext = 2
							break
						EndIf
					EndIf
					
					Self.attackLevel = Self.attackLevelNext
					Select (Self.attackLevelNext)
						Case 0
							Self.animationID = KNUCKLES_ANI_STAND
							break
						Case KNUCKLES_ANI_WALK_2
							Self.animationID = NO_ANIMATION
							Self.myAnimationID = KNUCKLES_ANI_ATTACK_2
							calDivideVelocity()
							
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								i2 = 1
							Else
								i2 = NO_ANIMATION
							EndIf
							
							Self.velX = i2 * PUNCH_MOVE01
							calTotalVelocity()
							
							If (Self.isInWater) Then
								i2 = 2
							Else
								i2 = 1
							EndIf
							
							Self.attackCount = i2 * KNUCKLES_ATTACK_2_COUNT
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSe(KNUCKLES_ANI_FLY_1)
							break
					End Select
					Self.attackLevelNext = 0
					break
					break
				Case KNUCKLES_ANI_WALK_2
					
					If (Self.attackCount <> 0) Then
						If (Key.press(Key.gSelect)) Then
							Self.attackLevelNext = NORMAL_FRAME_INTERVAL
							break
						EndIf
					EndIf
					
					Self.attackLevel = Self.attackLevelNext
					Select (Self.attackLevelNext)
						Case 0
							Self.animationID = KNUCKLES_ANI_STAND
							break
						Case NORMAL_FRAME_INTERVAL
							Self.animationID = NO_ANIMATION
							Self.myAnimationID = KNUCKLES_ANI_ATTACK_3
							Self.worldCal.actionState = 1
							Self.collisionState = COLLISION_STATE_JUMP
							Int jump = PickValue(Self.isInWater, UPPER_INWATER_SPEED, UPPER_SPEED)
							i2 = Self.velY
							
							If (Self.isAntiGravity) Then
								i = NO_ANIMATION
							Else
								i = 1
							EndIf
							
							Self.velY = i2 + (i * (-jump))
							
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								i2 = 1
							Else
								i2 = NO_ANIMATION
							EndIf
							
							Self.velX = i2 * jump
							
							If (Self.isInWater) Then
								i2 = 2
							Else
								i2 = 1
							EndIf
							
							Self.attackCount = i2 * WATER_FRAME_INTERVAL
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSe(KNUCKLES_ANI_FLY_2)
							break
					End Select
					Self.attackLevelNext = 0
					break
					break
				Case NORMAL_FRAME_INTERVAL
					
					If (Self.animationID <> NO_ANIMATION) Then
						Self.attackLevel = 0
						break
					EndIf
					
					break
			End Select
			Self.preWaterFlag = Self.isInWater
			
			If (isBodyCenterOutOfWater()) Then
				Self.Floating = False
			EndIf
			
			If (Self.attackLevel = 0) Then
				Self.isAttacking = False
			Else
				Self.isAttacking = True
			EndIf
			
		End
		
		Protected Method extraLogicOnObject:Void()
			Self.flying = False
			
			If (Self.myAnimationID = KNUCKLES_ANI_FLY_4) Then
				If (Self.velX = 0) Then
					Self.animationID = KNUCKLES_ANI_STAND
					Self.isSlipActived = False
				ElseIf (Not Key.repeated(Key.B_HIGH_JUMP | Key.gUp) Or ((Self.faceDegree >= KNUCKLES_ANI_POLE_H And Self.faceDegree <= 315 And Not Self.isAntiGravity) Or (Self.faceDegree < KNUCKLES_ANI_POLE_H And Self.faceDegree > 315 And Self.isAntiGravity))) Then
					Self.animationID = KNUCKLES_ANI_STAND
					Self.velX = 0
					Self.isSlipActived = False
				Else
					Local preTotalVelocity:= Self.velX
					
					Self.velX -= (DSgn(Not Self.faceDirection) * FLY_GROUND_SPEED)
					
					If (Self.velX * preTotalVelocity <= 0) Then
						Self.velX = 0
					EndIf
					
					Effect.showEffect(Self.dustEffectAnimation, 2, Self.posX Shr 6, Self.posY Shr 6, 0)
					slipBrakeNoise()
				EndIf
			EndIf
			
			If (Self.attackCount > 0) Then
				Self.attackCount -= 1
			EndIf
			
			Int i
			SoundSystem soundSystem
			SoundSystem soundSystem2
			Select (Self.attackLevel)
				Case 0
					
					If ((Self.animationID = KNUCKLES_ANI_STAND Or Self.animationID = KNUCKLES_ANI_WALK_1 Or Self.animationID = KNUCKLES_ANI_WALK_2 Or Self.animationID = NORMAL_FRAME_INTERVAL Or Self.animationID = KNUCKLES_ANI_BAR_MOVE Or Self.animationID = KNUCKLES_ANI_WIND Or Self.animationID = KNUCKLES_ANI_SPIN_1) And Key.press(Key.gSelect) And Self.myAnimationID <> KNUCKLES_ANI_PUSH_WALL) Then
						Self.attackLevel = 1
						Self.animationID = NO_ANIMATION
						Self.myAnimationID = KNUCKLES_ANI_ATTACK_1
						
						If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
							i = 1
						Else
							i = NO_ANIMATION
						EndIf
						
						Self.velX = i * PUNCH_MOVE01
						
						If (Self.isInWater) Then
							i = 2
						Else
							i = 1
						EndIf
						
						Self.attackCount = i * KNUCKLES_ATTACK_2_COUNT
						Self.attackLevelNext = 0
						soundSystem = soundInstance
						soundSystem2 = soundInstance
						soundSystem.playSe(KNUCKLES_ANI_FLY_1)
						Self.drawer.setActionId(KNUCKLES_ANI_ATTACK_1)
						break
					EndIf
					
				Case KNUCKLES_ANI_WALK_1
					
					If (Self.attackCount <> 0) Then
						If (Key.press(Key.gSelect)) Then
							Self.attackLevelNext = 2
							break
						EndIf
					EndIf
					
					Self.attackLevel = Self.attackLevelNext
					Select (Self.attackLevelNext)
						Case 0
							Self.animationID = KNUCKLES_ANI_STAND
							break
						Case KNUCKLES_ANI_WALK_2
							Self.animationID = NO_ANIMATION
							Self.myAnimationID = KNUCKLES_ANI_ATTACK_2
							
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								i = 1
							Else
								i = NO_ANIMATION
							EndIf
							
							Self.velX = i * PUNCH_MOVE01
							
							If (Self.isInWater) Then
								i = 2
							Else
								i = 1
							EndIf
							
							Self.attackCount = i * KNUCKLES_ATTACK_2_COUNT
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSe(KNUCKLES_ANI_FLY_1)
							break
					End Select
					Self.attackLevelNext = 0
					break
					break
				Case KNUCKLES_ANI_WALK_2
					
					If (Self.attackCount <> 0) Then
						If (Key.press(Key.gSelect)) Then
							Self.attackLevelNext = NORMAL_FRAME_INTERVAL
							break
						EndIf
					EndIf
					
					Self.attackLevel = Self.attackLevelNext
					Select (Self.attackLevelNext)
						Case 0
							Self.animationID = KNUCKLES_ANI_STAND
							break
						Case NORMAL_FRAME_INTERVAL
							Int i2
							Self.animationID = NO_ANIMATION
							Self.myAnimationID = KNUCKLES_ANI_ATTACK_3
							Self.worldCal.actionState = 1
							Self.collisionState = COLLISION_STATE_JUMP
							
							Local jump:= PickValue(Self.isInWater, UPPER_INWATER_SPEED, UPPER_SPEED)
							
							i = Self.velY
							
							If (Self.isAntiGravity) Then
								i2 = NO_ANIMATION
							Else
								i2 = 1
							EndIf
							
							Self.velY = i + (i2 * (-jump))
							
							If ((Self.isAntiGravity ~ Self.faceDirection) <> 0) Then
								i = 1
							Else
								i = NO_ANIMATION
							EndIf
							
							Self.velX = i * jump
							
							If (Self.isInWater) Then
								i = 2
							Else
								i = 1
							EndIf
							
							Self.attackCount = i * WATER_FRAME_INTERVAL
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSe(KNUCKLES_ANI_FLY_2)
							break
					End Select
					Self.attackLevelNext = 0
					break
					break
				Case NORMAL_FRAME_INTERVAL
					
					If (Self.animationID <> NO_ANIMATION) Then
						Self.attackLevel = 0
						break
					EndIf
					
					break
			End Select
			
			If (Self.attackLevel = 0) Then
				Self.isAttacking = False
			Else
				Self.isAttacking = True
			EndIf
			
		End
		
		Protected Method extraInputLogic:Void()
			Self.swimWaterEffectFlag = False
			Select (Self.collisionState)
				Case KNUCKLES_ATTACK_2_COUNT
					inputLogicClimb()
				Default
			End Select
		End
		
		Private Method inputLogicClimb:Void()
			Self.animationID = NO_ANIMATION
			Self.velX = 0
			Self.velY = 0
			
			If (Self.myAnimationID <> KNUCKLES_ANI_CLIMB_5) Then
				SoundSystem soundSystem
				SoundSystem soundSystem2
				Self.myAnimationID = KNUCKLES_ANI_CLIMB_2
				
				If ((Key.repeated(Key.B_LOOK) And Not Self.isAntiGravity) Or (Key.repeated(Key.gDown) And Self.isAntiGravity)) Then
					If (Self.isInWater) Then
						Self.waterframe += 1
						Self.waterframe Mod= WATER_FRAME_INTERVAL
						
						If (Self.waterframe = 1) Then
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSequenceSe(KNUCKLES_ANI_SPRING_5)
						EndIf
						
					Else
						Self.waterframe += 1
						Self.waterframe Mod= NORMAL_FRAME_INTERVAL
						
						If (Self.waterframe = 1) Then
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSequenceSe(KNUCKLES_ANI_SPRING_5)
						EndIf
					EndIf
					
					Self.velY = PickValue(Self.isInWater, -WALL_CLIMB_SPEED_W, -WALL_CLIMB_SPEED)
					Self.myAnimationID = PickValue(Self.isAntiGravity, KNUCKLES_ANI_CLIMB_4, KNUCKLES_ANI_CLIMB_3)
				EndIf
				
				If ((Key.repeated(Key.gDown) And Not Self.isAntiGravity) Or (Key.repeated(Key.B_LOOK) And Self.isAntiGravity)) Then
					If (Self.isInWater) Then
						Self.waterframe += 1
						Self.waterframe Mod= WATER_FRAME_INTERVAL
						
						If (Self.waterframe = 1) Then
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSequenceSe(KNUCKLES_ANI_SPRING_5)
						EndIf
						
					Else
						Self.waterframe += 1
						Self.waterframe Mod= NORMAL_FRAME_INTERVAL
						
						If (Self.waterframe = 1) Then
							soundSystem = soundInstance
							soundSystem2 = soundInstance
							soundSystem.playSequenceSe(KNUCKLES_ANI_SPRING_5)
						EndIf
					EndIf
					
					Self.velY = PickValue(Self.isInWater, WALL_CLIMB_SPEED_W, WALL_CLIMB_SPEED)
					Self.myAnimationID = PickValue(Self.isAntiGravity, KNUCKLES_ANI_CLIMB_3, KNUCKLES_ANI_CLIMB_4)
				EndIf
				
				If (Key.press(Key.B_HIGH_JUMP | Key.gUp)) Then
					soundInstance.stopLoopSe()
					
					Self.collisionState = COLLISION_STATE_JUMP
					
					Self.velY = PickValue(Self.isAntiGravity, SONIC_ATTACK_LEVEL_2_V0, -SONIC_ATTACK_LEVEL_2_V0)
					Self.velX = (DSgn((Self.faceDirection <> Self.isAntiGravity)) * -FLY_START_X_SPEED)
					
					Self.faceDirection = Not Self.faceDirection
					
					Self.animationID = KNUCKLES_ANI_JUMP
					
					Return
				EndIf
				
				Int playingLoopSeIndex
				
				If (Not (Self.myAnimationID = KNUCKLES_ANI_CLIMB_3 Or Self.myAnimationID = KNUCKLES_ANI_CLIMB_4)) Then
					playingLoopSeIndex = soundInstance.getPlayingLoopSeIndex()
					soundSystem2 = soundInstance
					
					If (playingLoopSeIndex = KNUCKLES_ANI_SPRING_5) Then
						soundInstance.stopLoopSe()
					EndIf
				EndIf
				
				Int climbPointX = Self.posX + (DSgn(Self.faceDirection <> Self.isAntiGravity) * WIDTH)
				Int climbPointY = (Self.posY + (DSgn(Self.isAntiGravity) * (getCollisionRectHeight() / 2))) + Self.velY ' Shr 1
				
				If (climbPointY < (MapManager.getPixelHeight() Shl 6) - HEIGHT Or Not Self.isAntiGravity) Then
					If (Self.worldInstance.getWorldX(climbPointX, climbPointY, Self.currentLayer, PickValue((Self.faceDirection <> Self.isAntiGravity), TRANS_ROT180, TRANS_MIRROR_ROT180)) = ACParam.NO_COLLISION) Then
						Int footX = Self.posX + (DSgn(Self.faceDirection <> Self.isAntiGravity) * WIDTH)
						Int newY = Self.worldInstance.getWorldY(footX, Self.posY, Self.currentLayer, PickValue(Self.isAntiGravity, 2, 0))
						
						If (newY <> ACParam.NO_COLLISION) Then
							playingLoopSeIndex = (footX - (DSgn(Self.faceDirection <> Self.isAntiGravity) * (Self.worldInstance.getTileWidth() / 2))) ' Shr 1
							Self.posX = playingLoopSeIndex
							Self.footPointX = playingLoopSeIndex
							Self.posY = newY
							Self.footPointY = newY
							Self.myAnimationID = KNUCKLES_ANI_CLIMB_5
							soundInstance.stopLoopSe()
							Self.velX = 0
							Self.velY = 0
							Return
						EndIf
						
						Self.collisionState = COLLISION_STATE_JUMP
						Self.animationID = KNUCKLES_ANI_WALK_1
						soundInstance.stopLoopSe()
						Return
					EndIf
					
					Int newPosX = Self.worldInstance.getWorldX(climbPointX, PickValue(Self.isAntiGravity, HEIGHT, -HEIGHT) + climbPointY, Self.currentLayer, PickValue((Self.faceDirection <> Self.isAntiGravity) <> 0, TRANS_ROT180, TRANS_MIRROR_ROT180)) - ((DSgn(Self.faceDirection <> Self.isAntiGravity)) * (WIDTH / 2))
					
					If (newPosX >= 0 And (((newPosX - Self.posX > 0 And (Self.faceDirection ~ Self.isAntiGravity) = 0) Or (newPosX - Self.posX < 0 And (Self.faceDirection ~ Self.isAntiGravity) <> 0)) And ((Self.velY < 0 And Not Self.isAntiGravity) Or (Self.velY > 0 And Self.isAntiGravity)))) Then
						Self.velY = 0
					EndIf
					
					If (Self.worldInstance.getWorldX(climbPointX, climbPointY - PickValue(Self.isAntiGravity, SONIC_ATTACK_LEVEL_3_V0, -SONIC_ATTACK_LEVEL_3_V0), Self.currentLayer, PickValue((Self.faceDirection <> Self.isAntiGravity), TRANS_ROT180, TRANS_MIRROR_ROT180)) - ((DSgn(Self.faceDirection <> Self.isAntiGravity)) * (WIDTH / 2)) = Self.posX) Then
						Return
					EndIf
					
					If ((Self.velY > 0 And Not Self.isAntiGravity) Or (Self.velY < 0 And Self.isAntiGravity)) Then
						Self.collisionState = COLLISION_STATE_JUMP
						Self.animationID = KNUCKLES_ANI_WALK_1
						soundInstance.stopLoopSe()
						Return
					EndIf
					
					Return
				EndIf
				
				Self.velY = 0
			EndIf
		End
		
		Public Method doWhileTouchWorld:Void(direction:Int, degree:Int)
			Super.doWhileTouchWorld(direction, degree)
			
			If (Not Self.flying) Then
				Return
			EndIf
			
			If (degree <> FLY_DOWN_SPEED And degree <> 270) Then
				Return
			EndIf
			
			If ((direction = 1 And Self.faceDirection) Or (direction = NORMAL_FRAME_INTERVAL And Not Self.faceDirection)) Then
				Self.collisionState = COLLISION_STATE_CLIMB
				Self.flying = False
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = KNUCKLES_ANI_CLIMB_1
				Self.worldCal.stopMove()
				Int i = Self.posY + WALL_CLIMB_SPEED_W
				Self.footPointY = i
				Self.posX = i
			EndIf
			
		End
		
		Public Method doWhileLand:Void(degree:Int)
			Super.doWhileLand(degree)
			
			If (Self.flying And Self.hurtCount = 0) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = KNUCKLES_ANI_FLY_4
			EndIf
			
		End
		
		Public Method needRetPower:Bool()
			
			If ((Self.attackLevel = 0 Or Self.attackLevel = NORMAL_FRAME_INTERVAL) And Self.myAnimationID <> KNUCKLES_ANI_FLY_4) Then
				Return Super.needRetPower()
			EndIf
			
			Return True
		End
		
		Public Method getRetPower:Int()
			
			If (Self.attackLevel = 0 Or Self.attackLevel = NORMAL_FRAME_INTERVAL) Then
				Return Super.getRetPower()
			EndIf
			
			Return 288
		End
		
		Public Method noRotateDraw:Bool()
			
			If (Self.myAnimationID = KNUCKLES_ANI_ATTACK_1 Or Self.myAnimationID = KNUCKLES_ANI_ATTACK_2 Or Self.myAnimationID = KNUCKLES_ANI_ATTACK_3) Then
				Return True
			EndIf
			
			Return Super.noRotateDraw()
		End
		
		Public Method getSlopeGravity:Int()
			
			If (Self.myAnimationID = KNUCKLES_ANI_FLY_4) Then
				Return 0
			EndIf
			
			Return Super.getSlopeGravity()
		End
		
		Public Method canDoJump:Bool()
			
			If (Self.myAnimationID = KNUCKLES_ANI_ATTACK_1 Or Self.myAnimationID = KNUCKLES_ANI_ATTACK_2) Then
				Return False
			EndIf
			
			Return Super.canDoJump()
		End
		
		Public Method doHurt:Void()
			
			If (Self.Floating) Then
				Self.Floating = False
			EndIf
			
			Super.doHurt()
		End
		
		Public Method doJump:Void()
			Self.attackLevel = 0
			Self.attackLevelNext = 0
			Self.attackCount = 0
			Super.doJump()
		End
		
		Public Method refreshCollisionRectWrap:Void()
			Super.refreshCollisionRectWrap()
			
			If (Self.animationID <> NO_ANIMATION) Then
				Return
			EndIf
			
			If (Self.myAnimationID = KNUCKLES_ANI_FLY_1 Or Self.myAnimationID = KNUCKLES_ANI_FLY_2 Or Self.myAnimationID = KNUCKLES_ANI_FLY_3 Or Self.myAnimationID = KNUCKLES_ANI_SWIM_1) Then
				Self.checkPositionX = getNewPointX(Self.footPointX, 0, ((-WIDTH) / 2), 0) ' Shr 1
				Self.checkPositionY = getNewPointY(Self.footPointY, 0, PickValue(Self.isAntiGravity, (WIDTH / 2), ((-WIDTH) / 2)), 0) ' Shr 1
				
				Int i = 1280 Shr 1
				i = WIDTH Shr 1
				
				Self.collisionRect.setTwoPosition(Self.checkPositionX - (1280 Shr 1), Self.checkPositionY - (WIDTH Shr 1), Self.checkPositionX + MDPhone.SCREEN_HEIGHT, Self.checkPositionY + 512)
			EndIf
			
		End
		
		Public Method getCollisionRectWidth:Int()
			
			If (Self.animationID = NO_ANIMATION And (Self.myAnimationID = KNUCKLES_ANI_FLY_1 Or Self.myAnimationID = KNUCKLES_ANI_FLY_2 Or Self.myAnimationID = KNUCKLES_ANI_FLY_3 Or Self.myAnimationID = KNUCKLES_ANI_SWIM_1)) Then
				Return 1280
			EndIf
			
			Return Super.getCollisionRectWidth()
		End
		
		Public Method getCollisionRectHeight:Int()
			
			If (Self.animationID = NO_ANIMATION And (Self.myAnimationID = KNUCKLES_ANI_FLY_1 Or Self.myAnimationID = KNUCKLES_ANI_FLY_2 Or Self.myAnimationID = KNUCKLES_ANI_FLY_3 Or Self.myAnimationID = KNUCKLES_ANI_SWIM_1)) Then
				Return WIDTH
			EndIf
			
			If (Self.collisionState <> KNUCKLES_ATTACK_2_COUNT Or Self.myAnimationID = KNUCKLES_ANI_CLIMB_5) Then
				Return Super.getCollisionRectHeight()
			EndIf
			
			Return 1280
		End
		
		Public Method beStop:Void(newPosition:Int, direction:Int, object:GameObject)
			Super.beStop(newPosition, direction, object)
			
			If (Self.isAntiGravity) Then
				If (direction = 1) Then
					direction = 0
				ElseIf (direction = 0) Then
					direction = 1
				EndIf
			EndIf
			
			If (direction = 1 And Self.flying And Self.hurtCount = 0) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = KNUCKLES_ANI_FLY_4
			EndIf
			
		End
		
		Public Method beAccelerate:Bool(power:Int, IsX:Bool, sender:GameObject)
			
			If (Self.myAnimationID = KNUCKLES_ANI_FLY_4) Then
				Return False
			EndIf
			
			Return Super.beAccelerate(power, IsX, sender)
		End
		
		Public Method setPreWaterFlag:Void(state:Bool)
			Self.preWaterFlag = state
		End
		
		Public Method Floatchk:Void()
			
			If (Not (Self.preWaterFlag Or Not Self.isInWater Or Self.flying)) Then
				Self.Floating = True
			EndIf
			
			Self.preWaterFlag = Self.isInWater
		End
		
		Public Method setFloating:Void(f:Bool)
			Self.Floating = f
		End
End