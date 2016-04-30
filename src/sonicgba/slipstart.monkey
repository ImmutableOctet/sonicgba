Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playersonic
	Import sonicgba.playeramy
	
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
Public

' Classes:
Class SlipStart Extends GimmickObject
	Private
		' Constant variable(s):
		Const ACTIVE_SPEED_X:Int = 128
		Const ACTIVE_SPEED_Y:Int = 128
		
		Const COLLISION_HEIGHT:Int = 1792
		
		Const COLLISION_OFFSET_Y:Int = -128
		
		' Fields:
		Field isActived:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method logic:Void()
			' Empty implementation.
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (player.slipping And ((player.getCharacterID() = CHARACTER_SONIC) Or (player.getCharacterID() = CHARACTER_AMY))) Then
				player.setSlip0()
			EndIf
			
			If (Not Self.isActived) Then
				If (player.getCharacterID() = CHARACTER_SONIC) Then
					Local sonic:= PlayerSonic(player)
					
					If (sonic <> Null) Then
						If (Not Self.isActived) Then
							If (player.getVelX() > ACTIVE_SPEED_Y And player.getVelY() > ACTIVE_SPEED_Y And Self.collisionRect.collisionChk(player.getFootPositionX(), player.getFootPositionY()) And player.currentLayer = 1) Then
								PlayerObject.slidingFrame = 1 ' PlayerSonic.SONIC_ANI_WALK_1
								
								sonic.slipStart()
							EndIf
							
							Self.isActived = True
						EndIf
					EndIf
				ElseIf (player.getCharacterID() = CHARACTER_AMY) Then
					If (player.getCharacterAnimationID() >= PlayerAmy.AMY_ANI_DASH_1 And player.getCharacterAnimationID() <= PlayerAmy.AMY_ANI_DASH_5) Then
						Return
					EndIf
					
					If ((player.getCharacterAnimationID() < PlayerAmy.AMY_ANI_SQUAT_1 Or player.getCharacterAnimationID() > PlayerAmy.AMY_ANI_SQUAT_2) And Not Self.isActived) Then
						If (player.getVelX() > ACTIVE_SPEED_Y And player.getVelY() > ACTIVE_SPEED_Y And Self.collisionRect.collisionChk(player.getFootPositionX(), player.getFootPositionY()) And player.currentLayer = 1) Then
							PlayerObject.slidingFrame = 1 ' PlayerAmy.AMY_ANI_WALK_1
							
							Local amy:= PlayerAmy(player)
							
							If (amy <> Null) Then
								amy.slipStart()
							EndIf
						EndIf
						
						Self.isActived = True
					EndIf
				EndIf
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.isActived) Then
				If (player.slipping) Then
					player.faceDegree = 45
					
					player.calDivideVelocity()
					player.calTotalVelocity()
				EndIf
				
				player.worldCal.setMovedState(False)
				
				Self.isActived = False
			EndIf
		End
End