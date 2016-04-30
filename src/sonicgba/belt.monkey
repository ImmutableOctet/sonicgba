Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	'Import gameengine.def
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	Import sonicgba.playerknuckles
	Import sonicgba.playersonic
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Belt Extends GimmickObject
	Private
		' Constant variable(s):
		Const DRAW_Y_OFFSET:Int = 1024
		
		Const MOVE_SPEED:Int = 128
		Const SNOW_MAX_SPEED:Int = 118
		
		Const SPIN_DASH_ATTENUATE_PERCENTAGE:Int = 82
		
		' Fields:
		Field drawer:AnimationDrawer
		
		Field isActived:Bool
	Public
		' Global variable(s):
		Global beltAnimation:Animation
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Select (StageManager.getCurrentZoneId())
				Case 4
					Self.isActived = False
				Default
					If (beltAnimation = Null) Then
						Local primary:String = String(StageManager.getCurrentZoneId())
						
						Local secondary:String
						
						If (StageManager.getCurrentZoneId() = 6) Then
							secondary = String(StageManager.getStageID() - 9)
						EndIf
						
						beltAnimation = New Animation("/animation/conveyor_" + primary + secondary)
					EndIf
					
					If (beltAnimation <> Null) Then
						Local kind:Int
						
						If (StageManager.getCurrentZoneId() = 6) Then
							kind = PickValue(((width / 2) < 6), 0, 2) + PickValue((Self.iLeft = 0), 0, 1)
						Else
							kind = PickValue(((width / 2) = 6), 0, 2) + PickValue((Self.iLeft = 0), 0, 1)
						EndIf
						
						Self.drawer = beltAnimation.getDrawer(kind, True, 0)
					EndIf
					
					Self.isActived = False
			End Select
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(beltAnimation)
			
			beltAnimation = Null
		End
		
		' Methods:
		Public Method draw:Void(g:MFGraphics)
			Select (StageManager.getCurrentZoneId())
				Case 4
					' Nothing so far.
				Case 6
					If (Self.iTop <> 1) Then
						drawInMap(g, Self.drawer, Self.posX + (Self.mWidth / 2), Self.posY + DRAW_Y_OFFSET) ' Shr 1
					EndIf
				Default
					drawInMap(g, Self.drawer, Self.posX + (Self.mWidth / 2), Self.posY + DRAW_Y_OFFSET) ' Shr 1
			End Select
			
			drawCollisionRect(g)
		End
		
		Method logic:Void()
			Select (StageManager.getCurrentZoneId())
				Case 4
					If (Self.collisionRect.collisionChk(player.getCollisionRect()) And player.collisionState = PlayerObject.COLLISION_STATE_WALK) Then
						player.isStopByObject = True
						
						Local animationId:= player.getAnimationId()
						
						If (animationId = PlayerObject.ANI_JUMP) Then
							If (player.getVelX() > SNOW_MAX_SPEED) Then
								player.setVelXPercent(SPIN_DASH_ATTENUATE_PERCENTAGE)
							ElseIf (player.getVelX() < -SNOW_MAX_SPEED) Then
								player.setVelXPercent(SPIN_DASH_ATTENUATE_PERCENTAGE)
							EndIf
						ElseIf ((Not (player.getCharacterID() = CHARACTER_SONIC) Or player.getCharacterAnimationID() < PlayerSonic.SONIC_ANI_ATTACK_1 Or player.getCharacterAnimationID() > PlayerSonic.SONIC_ANI_ATTACK_3) And Not ((player.getCharacterID() = CHARACTER_AMY) And player.myAnimationID = PlayerAmy.AMY_ANI_DASH_4)) Then
							If (player.getVelX() > SNOW_MAX_SPEED) Then
								player.setVelX(SNOW_MAX_SPEED)
							ElseIf (player.getVelX() < -SNOW_MAX_SPEED) Then
								player.setVelX(-SNOW_MAX_SPEED)
							EndIf
						EndIf
						
						Self.isActived = True
						
						player.isInSnow = True
					EndIf
				Default
					If (StageManager.getStageID() <> 10 And Self.collisionRect.collisionChk(player.getCollisionRect()) And player.collisionState = PlayerObject.COLLISION_STATE_WALK) Then
						player.speedLock = True
						
						player.moveOnObject(player.footPointX + PickValue((Self.iLeft = 0), -MOVE_SPEED, MOVE_SPEED), player.footPointY)
						
						#Rem
							' I am so confused...
							If (player.getAnimationId() <> PlayerObject.ANI_CLIFF_1) Then
								player.getAnimationId()
							EndIf
						#End
						
						Self.isActived = True
					EndIf
			End Select
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If ((player.getCharacterID() = CHARACTER_KNUCKLES) And player.collisionState = PlayerKnuckles.COLLISION_STATE_CLIMB) Then
				player.collisionState = PlayerObject.COLLISION_STATE_JUMP
				player.animationID = PlayerObject.ANI_RUN_1
				
				soundInstance.stopLoopSe()
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.isActived) Then
				Select (StageManager.getCurrentZoneId())
					Case 4
						player.isInSnow = False
						player.isStopByObject = False
					Default
						If (player.getAnimationId() = PlayerObject.ANI_CLIFF_1 Or player.getAnimationId() = PlayerObject.ANI_CLIFF_2) Then
							player.setAnimationId(PlayerObject.ANI_STAND)
						EndIf
						
						player.speedLock = False
				End Select
				
				Self.isActived = False
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End