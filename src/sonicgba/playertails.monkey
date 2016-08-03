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
	
	Import sonicgba.mapmanager
	Import sonicgba.playeranimationcollisionrect
	Import sonicgba.playerobject
	Import sonicgba.sonicdebug
	
	Import com.sega.engine.lib.crlfp32
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class PlayerTails Extends PlayerObject
	Private
		' Constant variable(s):
		Global ANIMATION_CONVERT:Int[] = [0, 1, 2, 3, 5, 10, 4, 4, 19, 20, 24, -1, 16, 35, 21, -1, -1, 46, -1, -1, -1, 44, 39, 40, 34, 37, 38, 41, 42, 43, 16, 36, 31, 32, 33, 27, 28, 29, 7, 8, 7, 18, 22, 23, 16, 17, 9, 25, 26, 52, 53, 54, 47, 50] ' Const
		
		Global LOOP_INDEX:Int[] = [-1, -1, -1, -1, -1, -1, -1, 8, -1, -2, -1, 0, -1, 14, -1, 16, -1, 18, -1, -1, 23, -1, 23, 24, -1, -1, -1, 28, -1, 30, -1, -1, -1, -1, -1, 21, 3, 38, 37, 40, 39, -1, -1, -1, -1, -1, -1, -1, 49, -1, -1, -2, -2, 54, -1, 0] ' Const
		
		Const FLY_GRAVITY:Int = 30
		Const FLY_POWER:Int = -90
		Const FLY_POWER_COUNT:Int = 8
		Const FLY_TIME:Int = 128
		
		Const LOOP:Int = -1
		
		Const MAX_FLY_VEL_Y:Int = -176
		
		Const NO_ANIMATION:Int = -1
		Const NO_LOOP:Int = -2
		Const NO_LOOP_DEPAND:Int = -2
		
		' Fields:
		Field attackRect:PlayerAnimationCollisionRect
		
		Field tailDrawer:AnimationDrawer
		Field tailsDrawer1:AnimationDrawer
		Field tailsDrawer2:AnimationDrawer
		
		Field flyUpCoolCount:Int
	Public
		' Constant variable(s):
		Const TAILS_ANI_ATTACK:Int = 11
		Const TAILS_ANI_BANK_1:Int = 31
		Const TAILS_ANI_BANK_2:Int = 32
		Const TAILS_ANI_BANK_3:Int = 33
		Const TAILS_ANI_BAR_MOVE:Int = 42
		Const TAILS_ANI_BAR_STAY:Int = 41
		Const TAILS_ANI_BRAKE:Int = 46
		Const TAILS_ANI_BREATHE:Int = 52
		Const TAILS_ANI_CAUGHT:Int = 47
		Const TAILS_ANI_CELEBRATE_1:Int = 27
		Const TAILS_ANI_CELEBRATE_2:Int = 28
		Const TAILS_ANI_CELEBRATE_3:Int = 29
		Const TAILS_ANI_CELEBRATE_4:Int = 30
		Const TAILS_ANI_CLIFF_1:Int = 25
		Const TAILS_ANI_CLIFF_2:Int = 26
		Const TAILS_ANI_DEAD_1:Int = 17
		Const TAILS_ANI_DEAD_2:Int = 18
		Const TAILS_ANI_ENTER_SP:Int = 51
		Const TAILS_ANI_FLY_1:Int = 12
		Const TAILS_ANI_FLY_2:Int = 13
		Const TAILS_ANI_FLY_3:Int = 14
		Const TAILS_ANI_HURT_1:Int = 15
		Const TAILS_ANI_HURT_2:Int = 16
		Const TAILS_ANI_JUMP_BODY:Int = 5
		Const TAILS_ANI_JUMP_TAIL:Int = 6
		Const TAILS_ANI_LOOK_UP_1:Int = 7
		Const TAILS_ANI_LOOK_UP_2:Int = 8
		Const TAILS_ANI_POLE_H:Int = 36
		Const TAILS_ANI_POLE_V:Int = 35
		Const TAILS_ANI_PUSH_WALL:Int = 19
		Const TAILS_ANI_RAIL_BODY:Int = 44
		Const TAILS_ANI_RAIL_TAIL:Int = 45
		Const TAILS_ANI_ROLL_H_1:Int = 39
		Const TAILS_ANI_ROLL_H_2:Int = 40
		Const TAILS_ANI_ROLL_V_1:Int = 37
		Const TAILS_ANI_ROLL_V_2:Int = 38
		Const TAILS_ANI_RUN:Int = 3
		Const TAILS_ANI_SPIN:Int = 4
		Const TAILS_ANI_SPRING_1:Int = 20
		Const TAILS_ANI_SPRING_2:Int = 21
		Const TAILS_ANI_SPRING_3:Int = 22
		Const TAILS_ANI_SPRING_4:Int = 23
		Const TAILS_ANI_SPRING_5:Int = 24
		Const TAILS_ANI_SQUAT_1:Int = 9
		Const TAILS_ANI_SQUAT_2:Int = 10
		Const TAILS_ANI_STAND:Int = 0
		Const TAILS_ANI_SWIM_1:Int = 48
		Const TAILS_ANI_SWIM_2:Int = 49
		Const TAILS_ANI_UP_ARM:Int = 34
		Const TAILS_ANI_VS_KNUCKLE:Int = 50
		Const TAILS_ANI_WAITING_1:Int = 53
		Const TAILS_ANI_WAITING_2:Int = 54
		Const TAILS_ANI_WALK_1:Int = 1
		Const TAILS_ANI_WALK_2:Int = 2
		Const TAILS_ANI_WIND:Int = 43
		
		' Global variable(s):
		Global isInWind:Bool = False ' Field
		
		' Fields:
		Field flyCount:Int
		
		' Constructor(s):
		Method New()
			Self.flyCount = 0
			
			Local tailsImage:= MFImage.createImage("/animation/player/chr_tails.png")
			
			Local animation1:= New Animation(tailsImage, "/animation/player/chr_tails_01", False)
			
			Self.tailsDrawer1 = animation1.getDrawer()
			Self.tailDrawer = animation1.getDrawer()
			
			Self.drawer = Self.tailsDrawer1
			
			Self.tailsDrawer2 = New Animation(tailsImage, "/animation/player/chr_tails_02", False).getDrawer()
			
			MFImage.releaseImage(tailsImage)
			
			'tailsImage = Null
			
			Self.attackRect = New PlayerAnimationCollisionRect(Self)
		End
		
		' Methods:
		Method closeImpl:Void()
			Animation.closeAnimationDrawer(Self.tailsDrawer1)
			Self.tailsDrawer1 = Null
			
			Animation.closeAnimationDrawer(Self.tailDrawer)
			Self.tailDrawer = Null
			
			Animation.closeAnimationDrawer(Self.tailsDrawer2)
			Self.tailsDrawer2 = Null
		End
		
		Method drawCharacter:Void(g:MFGraphics)
			Local camera:= MapManager.getCamera()
			
			Local preMyAnimationID:= Self.myAnimationID
			
			If (Self.animationID <> NO_ANIMATION) Then
				Self.myAnimationID = ANIMATION_CONVERT[Self.animationID]
			EndIf
			
			If (preMyAnimationID = TAILS_ANI_CELEBRATE_4 And Self.myAnimationID = TAILS_ANI_CELEBRATE_3) Then
				Self.myAnimationID = TAILS_ANI_CELEBRATE_4
			EndIf
			
			If (Self.myAnimationID <> NO_ANIMATION) Then
				Local loop:Bool = (LOOP_INDEX[Self.myAnimationID] = NO_ANIMATION)
				
				If (Self.myAnimationID = TAILS_ANI_VS_KNUCKLE) Then
					loop = False
				EndIf
				
				Self.drawer = Self.tailsDrawer1
				
				Local drawerActionID:= Self.myAnimationID
				
				If (Self.myAnimationID >= TAILS_ANI_SWIM_1) Then
					Self.drawer = Self.tailsDrawer2
					
					drawerActionID = (Self.myAnimationID - TAILS_ANI_SWIM_1)
					
					If (Self.myAnimationID = TAILS_ANI_WAITING_1 And Self.isResetWaitAni) Then
						Self.drawer.restart()
						
						Self.isResetWaitAni = False
					EndIf
				EndIf
				
				If (Self.isInWater) Then
					Self.drawer.setSpeed(1, 2)
					Self.tailDrawer.setSpeed(1, 2)
				Else
					Self.drawer.setSpeed(1, 1)
					Self.tailDrawer.setSpeed(1, 1)
				EndIf
				
				If ((Self.hurtCount Mod 2) = 0) Then
					drawTail(g)
					
					Local bodyCenterX:Int, bodyCenterY:Int
					
					Local trans:Int
					
					If (Self.animationID = TAILS_ANI_SPIN) Then
						' Maigc numbers: -512, 512
						bodyCenterX = getNewPointX(Self.footPointX, 0, -512, Self.faceDegree) ' (-((WIDTH) / 2))
						bodyCenterY = getNewPointY(Self.footPointY, 0, -512, Self.faceDegree)
						
						Local drawX:= getNewPointX(bodyCenterX, 0, 512, 0)
						Local drawY:= getNewPointY(bodyCenterY, 0, 512, 0)
						
						If (Self.collisionState = COLLISION_STATE_WALK) Then
							If (Self.isAntiGravity) Then
								' Magic number: 1024
								If (Self.faceDirection) Then
									trans = PickValue((Self.totalVelocity >= 0), TRANS_ROT180, TRANS_MIRROR_ROT180)
									
									drawY -= 1024
								Else
									trans = PickValue((Self.totalVelocity > 0), TRANS_ROT180, TRANS_MIRROR_ROT180)
									
									drawY -= 1024
								EndIf
							ElseIf (Self.faceDirection) Then
								trans = PickValue((Self.totalVelocity >= 0), TRANS_NONE, TRANS_MIRROR)
							Else
								trans = PickValue((Self.totalVelocity > 0), TRANS_NONE, TRANS_MIRROR)
							EndIf
						ElseIf (Self.isAntiGravity) Then
							' Magic number: 1024
							If (Self.faceDirection) Then
								trans = PickValue((Self.velX <= 0), TRANS_ROT180, TRANS_MIRROR_ROT180)
								
								drawY -= 1024
							Else
								trans = PickValue((Self.velX < 0), TRANS_ROT180, TRANS_MIRROR_ROT180)
								
								drawY -= 1024
							EndIf
						ElseIf (Self.faceDirection) Then
							trans = PickValue((Self.velX >= 0), TRANS_NONE, TRANS_MIRROR)
						Else
							trans = PickValue((Self.velX > 0), TRANS_NONE, TRANS_MIRROR)
						EndIf
						
						Self.drawer.draw(g, drawerActionID, (drawX Shr 6) - camera.x, (drawY Shr 6) - camera.y, loop, trans)
					ElseIf (Self.animationID = TAILS_ANI_JUMP_TAIL Or Self.animationID = TAILS_ANI_LOOK_UP_1) Then
						drawDrawerByDegree(g, Self.drawer, drawerActionID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, loop, Self.degreeForDraw, Not Self.faceDirection)
					Else
						If (Self.myAnimationID = TAILS_ANI_CLIFF_1 Or Self.myAnimationID = TAILS_ANI_CLIFF_2 Or Self.myAnimationID = TAILS_ANI_LOOK_UP_1 Or Self.myAnimationID = TAILS_ANI_LOOK_UP_2) Then
							Self.degreeForDraw = Self.degreeStable
							Self.faceDegree = Self.degreeStable
						EndIf
						
						If (Self.myAnimationID = TAILS_ANI_BRAKE) Then
							Self.degreeForDraw = Self.degreeStable
						EndIf
						
						If (Not (Self.myAnimationID = TAILS_ANI_WALK_1 Or Self.myAnimationID = TAILS_ANI_WALK_2 Or Self.myAnimationID = TAILS_ANI_RUN Or Self.myAnimationID = TAILS_ANI_CAUGHT)) Then
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
						
						If (Self.degreeForDraw <> Self.faceDegree) Then
							bodyCenterX = getNewPointX(Self.footPointX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree) ' Shr 1
							bodyCenterY = getNewPointY(Self.footPointY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree) ' Shr 1
							
							g.saveCanvas()
							
							g.translateCanvas((bodyCenterX Shr 6) - camera.x, (bodyCenterY Shr 6) - camera.y)
							g.rotateCanvas(Float(Self.degreeForDraw))
							
							Self.drawer.draw(g, drawerActionID, 0, (Self.collisionRect.getHeight() / 2) Shr 6, loop, trans) ' Shr 1
							
							g.restoreCanvas()
						Else
							drawDrawerByDegree(g, Self.drawer, drawerActionID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, loop, Self.degreeForDraw, Not Self.faceDirection)
						EndIf
					EndIf
				Else
					If (drawerActionID <> Self.drawer.getActionId()) Then
						Self.drawer.setActionId(drawerActionID)
					EndIf
					
					If (Not AnimationDrawer.isAllPause()) Then
						Self.drawer.moveOn()
						Self.tailDrawer.moveOn()
					EndIf
				EndIf
				
				' No idea why this is in a draw routine, but that's how it's done, I guess:
				Self.attackRectVec.Clear()
				
				Local rect:= Self.drawer.getARect()
				
				If (Self.isAntiGravity) Then
					Local rectTmp:= Self.drawer.getARect()
					
					If (rectTmp.Length > 0) Then
						rect[0] = Byte((-rectTmp[0]) - rectTmp[2])
					EndIf
				EndIf
				
				If (rect.Length > 0) Then
					If (SonicDebug.showCollisionRect) Then
						Local color:= g.getColor()
						
						g.setColor(65280)
						
						g.drawRect(((Self.footPointX Shr 6) + rect[0]) - camera.x, ((Self.footPointY Shr 6) + PickValue(Self.isAntiGravity, (-rect[1]) - rect[3], rect[1])) - camera.y, rect[2], rect[3])
						
						g.setColor(color)
					EndIf
					
					Self.attackRect.initCollision((rect[0] Shl 6), (rect[1] Shl 6), (rect[2] Shl 6), (rect[3] Shl 6), Self.myAnimationID)
					
					Self.attackRectVec.Push(Self.attackRect)
				Else
					Self.attackRect.reset()
				EndIf
				
				If (Self.myAnimationID = TAILS_ANI_VS_KNUCKLE And Self.drawer.checkEnd()) Then
					Self.animationID = TAILS_ANI_STAND ' 0
				Else
					If (Self.drawer.checkEnd()) Then
						If (LOOP_INDEX[Self.myAnimationID] >= 0) Then
							If (Self.animationID = NO_ANIMATION) Then
								Select (Self.myAnimationID)
									Case TAILS_ANI_ATTACK
										Self.animationID = TAILS_ANI_STAND ' 0
										Self.isAttacking = False
								End Select
							EndIf
							
							Self.myAnimationID = LOOP_INDEX[Self.myAnimationID]
						EndIf
					EndIf
				EndIf
			EndIf
		End
		
		Method getGravity:Int()
			' This may be useful later:
			If (Self.flyCount = 0) Then
				Return Super.getGravity()
			EndIf
			
			Return 0
		End
		
		Method getGravity2:Int()
			Return Super.getGravity()
		End
		
		Method resetFlyCount:Void()
			Self.flyCount = 0
		End
		
		Method flyState:Bool()
			Return (Self.flyCount > 0)
		End
		
		Method stopFly:Void()
			soundInstance.stopLoopSe()
			
			Self.flyCount = 0
		End
		
		Method doPoalMotion:Bool(x:Int, y:Int, isLeft:Bool)
			If (Self.myAnimationID = TAILS_ANI_FLY_1 Or Self.myAnimationID = TAILS_ANI_FLY_2 Or Self.myAnimationID = TAILS_ANI_FLY_3) Then
				Return False
			EndIf
			
			Return Super.doPoalMotion(x, y, isLeft)
		End
		
		Method needRetPower:Bool()
			If (Self.myAnimationID = TAILS_ANI_ATTACK) Then
				Return True
			EndIf
			
			Return Super.needRetPower()
		End
		
		Method getRetPower:Int()
			If (Self.myAnimationID = TAILS_ANI_ATTACK) Then
				Return (MOVE_POWER_REVERSE / 2) ' Shr 1
			EndIf
			
			Return Super.getRetPower()
		End
		
		Method noRotateDraw:Bool()
			If (Self.myAnimationID = TAILS_ANI_ATTACK) Then
				Return True
			EndIf
			
			Return Super.noRotateDraw()
		End
		
		Method canDoJump:Bool()
			If (Self.myAnimationID = TAILS_ANI_ATTACK) Then
				Return False
			EndIf
			
			Return Super.canDoJump()
		End
	Protected
		' Methods:
		Method extraLogicJump:Void()
			If (Self.myAnimationID = TAILS_ANI_FLY_2 Or Self.myAnimationID = TAILS_ANI_FLY_3) Then
				Self.velY += PickValue(Self.isAntiGravity, -FLY_GRAVITY, FLY_GRAVITY)
				
				Self.velY -= (DSgn(Not Self.isAntiGravity) * getGravity())
			EndIf
			
			If (Self.myAnimationID = TAILS_ANI_FLY_1 Or Self.myAnimationID = TAILS_ANI_SWIM_1 Or Self.myAnimationID = TAILS_ANI_SWIM_2) Then
				Self.flyCount -= 1
				
				If (Self.flyUpCoolCount = 1) Then
					If (Key.press(Key.B_HIGH_JUMP) And (((Not Self.isAntiGravity And Self.velY >= MAX_FLY_VEL_Y) Or (Self.isAntiGravity And Self.velY <= -MAX_FLY_VEL_Y)) And Self.flyCount > 0)) Then
						Self.flyUpCoolCount = 2
					EndIf
					
					Self.velY += PickValue(Self.isAntiGravity, -FLY_GRAVITY, FLY_GRAVITY)
				ElseIf ((Self.isAntiGravity Or Self.velY < MAX_FLY_VEL_Y) And (Not Self.isAntiGravity Or Self.velY > -MAX_FLY_VEL_Y)) Then
					Self.flyUpCoolCount = 1
				Else
					If (Self.myAnimationID = TAILS_ANI_SWIM_1 Or Self.myAnimationID = TAILS_ANI_SWIM_2) Then
						' Magic number: -450
						Self.velY += (DSgn(Not Self.isAntiGravity) * -450)
					Else
						Self.velY += PickValue(Self.isAntiGravity, -FLY_POWER, FLY_POWER)
					EndIf
					
					Self.flyUpCoolCount += 1
					
					If (Self.flyUpCoolCount = TAILS_ANI_LOOK_UP_2) Then
						Self.flyUpCoolCount = 1
					EndIf
				EndIf
				
				Self.velY -= (DSgn(Not Self.isAntiGravity) * getGravity()) ' += (DSgn(Self.isAntiGravity) * getGravity())
				
				If (Self.isInWater And Self.myAnimationID = TAILS_ANI_FLY_1) Then
					Self.myAnimationID = TAILS_ANI_SWIM_1
				ElseIf (Not Self.isInWater) Then
					Self.myAnimationID = TAILS_ANI_FLY_1
				EndIf
				
				If (Self.flyCount = 0) Then
					Self.myAnimationID = TAILS_ANI_FLY_2
					
					soundInstance.stopLoopSe()
				ElseIf (Not Self.isInWater And Not isInWind And Not Self.isCrashFallingSand And Not IsGamePause) Then
					soundInstance.playLoopSe(SoundSystem.SE_120)
				EndIf
			ElseIf (Self.animationID <> TAILS_ANI_SPIN) Then
				' Nothing so far.
			Else
				If ((Self.doJumpForwardly Or Self.isCrashFallingSand) And Key.press(Key.B_HIGH_JUMP)) Then
					Self.animationID = NO_ANIMATION
					Self.myAnimationID = TAILS_ANI_FLY_1
					
					If (Self.isInWater) Then
						Self.myAnimationID = TAILS_ANI_SWIM_1
					Else
						soundInstance.playLoopSe(SoundSystem.SE_120)
					EndIf
					
					Self.flyCount = FLY_TIME
					
					Self.flyUpCoolCount = 1
					
					Self.velY += (DSgn(Not Self.isAntiGravity) * getGravity2())
					Self.velY = ((Self.velY * TAILS_ANI_FLY_2) / TAILS_ANI_HURT_2) ' 13 ' 16
					
					Self.velY -= (DSgn(Not Self.isAntiGravity) * getGravity())
					Self.velY += (DSgn(Not Self.isAntiGravity) * FLY_GRAVITY)
				EndIf
			EndIf
		End
		
		Method extraLogicWalk:Void()
			If (Self.flyCount > 0) Then
				soundInstance.stopLoopSe()
				
				Self.flyCount = 0
			EndIf
			
			If (Key.press(Key.gSelect) And Self.myAnimationID <> TAILS_ANI_ATTACK And Self.myAnimationID <> TAILS_ANI_PUSH_WALL And Self.collisionState <> COLLISION_STATE_JUMP And Self.animationID <> TAILS_ANI_SPIN) Then
				Self.animationID = NO_ANIMATION
				Self.myAnimationID = TAILS_ANI_ATTACK
				
				Self.drawer.restart()
				
				soundInstance.playSe(SoundSystem.SE_121)
				
				Self.isAttacking = True
			EndIf
		End
		
		Method extraLogicOnObject:Void()
			extraLogicWalk()
		End
	Private
		' Methods:
		Method drawTail:Void(g:MFGraphics)
			Local tailID:= NO_ANIMATION ' -1
			
			' Magic number: -512
			Local bodyCenterX:= getNewPointX(Self.footPointX, 0, -512, Self.faceDegree)
			Local bodyCenterY:= getNewPointY(Self.footPointY, 0, -512, Self.faceDegree)
			
			If (Self.myAnimationID = TAILS_ANI_JUMP_BODY) Then
				tailID = TAILS_ANI_JUMP_TAIL
			ElseIf (Self.myAnimationID = TAILS_ANI_RAIL_BODY) Then
				tailID = TAILS_ANI_RAIL_TAIL
			EndIf
			
			Local tailDegree:= Self.faceDegree
			Local trans:= getTrans(tailDegree)
			
			Local mirror:Bool = (Not Self.faceDirection)
			
			Local preFaceDirection:= Self.faceDirection
			
			If (Self.animationID = TAILS_ANI_SPIN) Then
				If (Self.collisionState = COLLISION_STATE_WALK) Then
					If (Not Self.faceDirection) Then
						mirror = (Self.totalVelocity <= 0)
					ElseIf (Self.totalVelocity < 0) Then
						mirror = True
					Else
						mirror = False
					EndIf
				ElseIf (Self.faceDirection) Then
					mirror = (Self.velX < 0)
				Else
					mirror = (Self.velX <= 0)
				EndIf
			EndIf
			
			If (Self.collisionState = COLLISION_STATE_JUMP Or Self.collisionState = COLLISION_STATE_IN_SAND Or ((Self.piping And Self.pipeState = STATE_PIPING) Or Self.myAnimationID = TAILS_ANI_RAIL_BODY)) Then
				tailDegree = CrlFP32.actTanDegree(Self.velY, Self.velX)
				
				trans = TRANS[getTransId(tailDegree)]
				
				mirror = False
				
				Self.faceDirection = True
			EndIf
			
			If (tailID <> NO_ANIMATION) Then ' -1
				drawDrawerByDegree(g, Self.tailDrawer, tailID, (bodyCenterX Shr 6) - camera.x, (bodyCenterY Shr 6) - camera.y, True, tailDegree, mirror)
			EndIf
			
			Self.faceDirection = preFaceDirection
		End
End