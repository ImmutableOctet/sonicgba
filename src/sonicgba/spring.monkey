Strict

Public

' Preprocessor related:
#If SONICGBA_EASTEREGGS
	#SONICGBA_SPRING_EASTEREGG = True
#End

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.spspring

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.constutil
	'Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playeramy
	Import sonicgba.playerknuckles
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Spring Extends GimmickObject
	Private
		' Constant variable(s):
		Global VELOCITY_MINUS:Int[] = [20, 85, 20, 20] ' Const
		Global VELOCITY_MINUS_2:Int[] = [30, 100, 30, 30] ' Const
		
		' Fields:
		Field drawer:AnimationDrawer
		
		Field firstCollisionDirection:Int
	Public
		' Constant variable(s):
		Global COLLISION_PARAM:Int[][] = [[-15, -15, 30, 15], [-15, 0, 30, 19], [-16, -28, 16, 26], [0, -28, 16, 26], [-22, -29, 26, 26], [-4, -29, 26, 26], [-22, -21, 26, 13], [-4, -21, 26, 13]] ' Const
		Global SPRING_INWATER_POWER:Int[] = [2064 + (GRAVITY / 2), 2256 + (GRAVITY / 2), 2440 + (GRAVITY / 2), 2624] ' Const ' Shr 1
		Global SPRING_POWER:Int[] = [1968 + (GRAVITY / 2), 2351 + (GRAVITY / 2), 2744 + (GRAVITY / 2), 3234] ' Const ' Shr 1
		Global SPRING_POWER_ORIGINAL:Int[] = [1920, 2304, 2688, 3072] ' Const
		
		' Global variable(s):
		Global springAnimation:Animation
		
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(springAnimation)
			
			springAnimation = Null
		End
		
		' Fields:
		Field centerPointX:Int
		Field springPower:Int
		
		Field springAttacked:Bool
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.firstCollisionDirection = DIRECTION_NONE
			
			If (springAnimation = Null) Then
				springAnimation = New Animation("/animation/se_bane_kiro")
			EndIf
			
			If (Self.iLeft < 0) Then
				Self.iLeft = 0
			ElseIf (Self.iLeft > 3) Then
				Self.iLeft = 3
			EndIf
			
			Self.springPower = SPRING_POWER[Self.iLeft]
			
			Self.drawer = springAnimation.getDrawer((Self.objId - GIMMICK_SPRING_UP) * 2, False, 0)
			
			If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
				Self.drawer.setActionId(Self.objId * 2)
			EndIf
			
			Self.centerPointX = ((Self.collisionRect.x0 + Self.collisionRect.x1) / 2) ' Shr 1
		End
		
		' Methods:
		
		' Extensions:
		Method playSound:Void()
			#If Not SONICGBA_SPRING_EASTEREGG
				soundInstance.playSe(SoundSystem.SE_148)
			#Else
				soundInstance.playSe(SoundSystem.SE_206)
			#End
		End
		
		Method draw:Void(g:MFGraphics)
			Self.springPower = PickValue(player.isInWater, SPRING_INWATER_POWER[Self.iLeft], SPRING_POWER[Self.iLeft])
			
			drawInMap(g, Self.drawer, Self.posX, Self.posY)
			
			If (Self.drawer.checkEnd()) Then
				If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
					Self.drawer.setActionId(Self.objId * 2)
				Else
					Self.drawer.setActionId((Self.objId - GIMMICK_SPRING_UP) * 2)
				EndIf
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.used) Then
				If (PlayerObject.getCharacterID() <> CHARACTER_AMY Or Not Self.springAttacked) Then
					If (Self.firstCollisionDirection <> DIRECTION_NONE And direction = DIRECTION_NONE) Then
						direction = Self.firstCollisionDirection
					EndIf
					
					If (Self.firstCollisionDirection = DIRECTION_NONE And direction <> DIRECTION_NONE) Then
						Self.firstCollisionDirection = direction
					EndIf
					
					p.beStop(Self.collisionRect.x0, direction, Self)
					
					If (p = player) Then
						Select (direction)
							Case DIRECTION_UP
								Select (Self.objId)
									Case GIMMICK_SPRING_DOWN
										If ((p.getCharacterID() = CHARACTER_KNUCKLES) And p.getCharacterAnimationID() >= PlayerKnuckles.KNUCKLES_ANI_CLIMB_1 And p.getCharacterAnimationID() <= PlayerKnuckles.KNUCKLES_ANI_CLIMB_5) Then
											p.collisionState = PlayerObject.COLLISION_STATE_JUMP
											
											p.restartAniDrawer()
										EndIf
										
										p.beSpring(Self.springPower, direction)
										
										If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
											Self.drawer.setActionId((Self.objId * 2) + 1)
										Else
											Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
										EndIf
										
										If (p.isAntiGravity And Self.iLeft = 1) Then
											p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
										EndIf
										
										playSound()
									Case GIMMICK_SPRING_LEFT
										If (p.isAntiGravity And Self.firstTouch) Then
											p.setAnimationId(PlayerObject.ANI_STAND)
										EndIf
									Case GIMMICK_SPRING_RIGHT
										If (p.isAntiGravity And Self.firstTouch) Then
											p.setAnimationId(PlayerObject.ANI_STAND)
										EndIf
								End Select
							Case DIRECTION_DOWN
								Select (Self.objId)
									Case GIMMICK_SPRING_UP
										p.beSpring(Self.springPower, direction)
										
										If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
											Self.drawer.setActionId((Self.objId * 2) + 1)
										Else
											Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
										EndIf
										
										If (Self.iLeft = 1) Then
											p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
										EndIf
										
										If (Self.firstTouch) Then
											playSound()
										EndIf
									Case GIMMICK_SPRING_LEFT
										If (Self.firstTouch) Then
											p.setAnimationId(PlayerObject.ANI_STAND)
										EndIf
									Case GIMMICK_SPRING_RIGHT
										If (Self.firstTouch) Then
											p.setAnimationId(PlayerObject.ANI_STAND)
										EndIf
										
										If (StageManager.getStageID() = 4 And p.degreeForDraw <> 0) Then
											p.faceDirection = True
											
											p.beSpring(Self.springPower, 2)
											
											Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
											
											playSound()
											
											If (p.getCharacterID() = CHARACTER_AMY) Then
												p.setAnimationId(PlayerObject.ANI_RUN_3)
												
												p.restartAniDrawer()
											EndIf
										EndIf
									Case GIMMICK_SPRING_LEFT_UP, GIMMICK_SPRING_LEFT_UP_BURY
										If (p.getCheckPositionX() < Self.collisionRect.x0 + ((Self.collisionRect.x1 - Self.collisionRect.x0) / 4)) Then
											p.beSpring((Self.springPower * VELOCITY_MINUS[Self.iLeft]) / VELOCITY_MINUS_2[Self.iLeft], DIRECTION_RIGHT)
											p.beSpring(Self.springPower, direction)
											
											If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
												Self.drawer.setActionId((Self.objId * 2) + 1)
											Else
												Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
											EndIf
											
											If (Self.iLeft = 1) Then
												p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
											EndIf
											
											p.setFootPositionY(Self.collisionRect.y0)
											
											playSound()
										ElseIf (Self.firstTouch) Then
											p.setAnimationId(PlayerObject.ANI_STAND)
										EndIf
									Case GIMMICK_SPRING_RIGHT_UP, GIMMICK_SPRING_RIGHT_UP_BURY
										If (p.getCheckPositionX() > Self.collisionRect.x0 + (((Self.collisionRect.x1 - Self.collisionRect.x0) * 3) / 4)) Then
											p.beSpring((Self.springPower * VELOCITY_MINUS[Self.iLeft]) / VELOCITY_MINUS_2[Self.iLeft], 2)
											p.beSpring(Self.springPower, direction)
											
											If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
												Self.drawer.setActionId((Self.objId * 2) + 1)
											Else
												Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
											EndIf
											
											If (Self.iLeft = 1) Then
												p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
											EndIf
											
											p.setFootPositionY(Self.collisionRect.y0)
											
											playSound()
										ElseIf (Self.firstTouch) Then
											p.setAnimationId(PlayerObject.ANI_STAND)
										EndIf
									Default
										If ((p.getCharacterID() = CHARACTER_AMY) And ((p.getCharacterAnimationID() >= PlayerAmy.AMY_ANI_DASH_2 And p.getCharacterAnimationID() <= PlayerAmy.AMY_ANI_DASH_4) Or ((p.getCharacterAnimationID() >= PlayerAmy.AMY_ANI_JUMP_ATTACK_1 And p.getCharacterAnimationID() <= PlayerAmy.AMY_ANI_JUMP_ATTACK_3) Or (p.getCharacterAnimationID() >= PlayerAmy.AMY_ANI_SPRING_2 And p.getCharacterAnimationID() <= PlayerAmy.AMY_ANI_SPRING_5)))) Then
											p.setAnimationId(PlayerObject.ANI_STAND)
											p.restartAniDrawer()
										EndIf
										
										If ((p.getCharacterID() = CHARACTER_KNUCKLES) And p.getCharacterAnimationID() >= PlayerKnuckles.KNUCKLES_ANI_CLIMB_1 And p.getCharacterAnimationID() <= PlayerKnuckles.KNUCKLES_ANI_CLIMB_5) Then
											p.collisionState = PlayerObject.COLLISION_STATE_ON_OBJECT
											
											p.setAnimationId(PlayerObject.ANI_STAND)
											p.restartAniDrawer()
										EndIf
								End Select
							Case DIRECTION_LEFT
								Select (Self.objId)
									Case GIMMICK_SPRING_RIGHT
										p.faceDirection = (Not p.isAntiGravity)
										
										p.beSpring(Self.springPower, direction)
										
										Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
										
										playSound()
										
										If (p.getCharacterID() = CHARACTER_AMY) Then
											p.setAnimationId(PlayerObject.ANI_RUN_3)
											p.restartAniDrawer()
										EndIf
									Case GIMMICK_SPRING_RIGHT_UP, GIMMICK_SPRING_RIGHT_UP_BURY
										If (p.getCheckPositionX() > Self.centerPointX) Then
											p.beSpring((Self.springPower * VELOCITY_MINUS[Self.iLeft]) / VELOCITY_MINUS_2[Self.iLeft], direction)
											p.beSpring(Self.springPower, DIRECTION_DOWN)
											
											Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
											
											If (Self.iLeft = 1) Then
												p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
											EndIf
											
											p.setFootPositionY(Self.collisionRect.y0)
											p.setFootPositionX(Self.collisionRect.x1)
											
											playSound()
										EndIf
								End Select
							Case DIRECTION_RIGHT
								Select (Self.objId)
									Case GIMMICK_SPRING_LEFT
										p.faceDirection = p.isAntiGravity
										
										p.beSpring(Self.springPower, direction)
										
										Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
										
										playSound()
										
										If (p.getCharacterID() = CHARACTER_AMY) Then
											p.setAnimationId(PlayerObject.ANI_RUN_3) ' PlayerAmy.AMY_ANI_RUN
											p.restartAniDrawer()
										EndIf
									Case GIMMICK_SPRING_LEFT_UP, GIMMICK_SPRING_LEFT_UP_BURY
										If (p.getCheckPositionX() < Self.centerPointX) Then
											p.beSpring((Self.springPower * VELOCITY_MINUS[Self.iLeft]) / VELOCITY_MINUS_2[Self.iLeft], direction)
											p.beSpring(Self.springPower, 1)
											Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
											
											If (Self.iLeft = 1) Then
												p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
											EndIf
											
											p.setFootPositionY(Self.collisionRect.y0)
											p.setFootPositionX(Self.collisionRect.x0)
											
											playSound()
										EndIf
								End Select
							Case DIRECTION_NONE
								If (p.getCharacterID() = CHARACTER_KNUCKLES) Then
									Select (Self.objId)
										Case GIMMICK_SPRING_UP
											p.beSpring(Self.springPower, DIRECTION_DOWN)
											
											If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
												Self.drawer.setActionId((Self.objId * 2) + 1)
											Else
												Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
											EndIf
											
											If (Self.iLeft = 1) Then
												p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
											EndIf
											
											playSound()
										Case GIMMICK_SPRING_DOWN
											p.beSpring(Self.springPower, DIRECTION_UP)
											
											If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
												Self.drawer.setActionId((Self.objId * 2) + 1)
											Else
												Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
											EndIf
											
											If (p.isAntiGravity And Self.iLeft = 1) Then
												p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
											EndIf
											
											playSound()
									End Select
								EndIf
								
								If (Self.objId = GIMMICK_SPRING_LEFT_UP_BURY And Self.firstTouch) Then
									p.beSpring((Self.springPower * VELOCITY_MINUS[Self.iLeft]) / VELOCITY_MINUS_2[Self.iLeft], DIRECTION_RIGHT)
									p.beSpring(Self.springPower, DIRECTION_DOWN)
									
									Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
									
									If (Self.iLeft = 1) Then
										p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
									EndIf
									
									p.setFootPositionY(Self.collisionRect.y0)
									p.setFootPositionX(Self.collisionRect.x0)
									
									playSound()
								EndIf
						End Select
					EndIf
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			If (PlayerObject.getCharacterID() = CHARACTER_AMY And p.myAnimationID <> PlayerAmy.AMY_ANI_DASH_4 And p.myAnimationID <> PlayerAmy.AMY_ANI_DASH_5) Then
				If (Not (Self.objId = GIMMICK_SPRING_LEFT Or Self.objId = GIMMICK_SPRING_RIGHT)) Then
					Self.springAttacked = True
				EndIf
				
				Select (Self.objId)
					Case GIMMICK_SPRING_UP
						If (animationID <> PlayerAmy.AMY_ANI_DASH_3 And animationID <> PlayerAmy.AMY_ANI_DASH_4) Then
							p.beSpring((Self.springPower * 13) / 10, DIRECTION_DOWN)
							
							If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
								Self.drawer.setActionId((Self.objId * 2) + 1)
							Else
								Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
							EndIf
							
							If (Self.iLeft = 1) Then
								p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
							EndIf
							
							playSound()
						EndIf
					Case GIMMICK_SPRING_DOWN
						If (animationID <> PlayerAmy.AMY_ANI_DASH_3 And animationID <> PlayerAmy.AMY_ANI_DASH_4) Then
							p.beSpring((Self.springPower * 13) / 10, DIRECTION_UP)
							
							If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
								Self.drawer.setActionId((Self.objId * 2) + 1)
							Else
								Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
							EndIf
							
							If (p.isAntiGravity And Self.iLeft = 1) Then
								p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
							EndIf
							
							playSound()
						EndIf
					Case GIMMICK_SPRING_LEFT_UP, GIMMICK_SPRING_LEFT_UP_BURY
						If (animationID <> PlayerAmy.AMY_ANI_DASH_3 And animationID <> PlayerAmy.AMY_ANI_DASH_4) Then
							p.beSpring((((Self.springPower * 13) / 10) * VELOCITY_MINUS[Self.iLeft]) / VELOCITY_MINUS_2[Self.iLeft], DIRECTION_RIGHT)
							p.beSpring((Self.springPower * 13) / 10, DIRECTION_DOWN)
							
							If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
								Self.drawer.setActionId((Self.objId * 2) + 1)
							Else
								Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
							EndIf
							
							If (Self.iLeft = 1) Then
								p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
							EndIf
							
							playSound()
						EndIf
					Case GIMMICK_SPRING_RIGHT_UP, GIMMICK_SPRING_RIGHT_UP_BURY
						If (animationID <> PlayerAmy.AMY_ANI_DASH_3 And animationID <> PlayerAmy.AMY_ANI_DASH_4) Then
							p.beSpring((((Self.springPower * 13) / 10) * VELOCITY_MINUS[Self.iLeft]) / VELOCITY_MINUS_2[Self.iLeft], DIRECTION_LEFT)
							p.beSpring((Self.springPower * 13) / 10, DIRECTION_DOWN)
							
							If ((Self.objId = GIMMICK_SPRING_UP Or Self.objId = GIMMICK_SPRING_DOWN) And Self.iLeft = 2) Then
								Self.drawer.setActionId((Self.objId * 2) + 1)
							Else
								Self.drawer.setActionId(((Self.objId - GIMMICK_SPRING_UP) * 2) + 1)
							EndIf
							
							If (Self.iLeft = 1) Then
								p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
							EndIf
							
							playSound()
						EndIf
					Default
						If (direction = DIRECTION_DOWN) Then
							p.setAnimationId(PlayerObject.ANI_STAND)
							p.restartAniDrawer()
						EndIf
				End Select
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.firstCollisionDirection = DIRECTION_NONE
			
			Self.springAttacked = False
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((COLLISION_PARAM[Self.objId - GIMMICK_SPRING_UP][0] Shl 6) + x, (COLLISION_PARAM[Self.objId - GIMMICK_SPRING_UP][1] Shl 6) + y, COLLISION_PARAM[Self.objId - GIMMICK_SPRING_UP][2] Shl 6, COLLISION_PARAM[Self.objId - GIMMICK_SPRING_UP][3] Shl 6)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End