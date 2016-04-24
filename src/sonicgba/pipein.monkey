Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.engine.action.acworldcollisioncalculator
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class PipeIn Extends GimmickObject
	Private
		' Global variable(s):
		Global COLLISION_WIDTH:Int = 2304
		Global COLLISION_HEIGHT:Int = 2560
		
		' Constant variable(s):
		Global TRANS:Int[] = [TRANS_NONE, TRANS_ROT180, TRANS_ROT270, TRANS_ROT90, TRANS_MIRROR, TRANS_MIRROR_ROT180] ' [0, 3, 6, 5, 2, 1] ' Const
		
		' Fields:
		Field drawer:AnimationDrawer
		
		Field actionID:Int
		Field dirRect:Int
		Field direction:Int
		Field transID:Int
		Field velx:Int
		Field vely:Int
	Public
		' Global variable(s):
		Global pipeAnimation:Animation
	Protected
		' Functions:
		Function updateCollisionInfo:Void()
			If (StageManager.getCurrentZoneId() = 2 Or StageManager.getStageID() = 10) Then
				If (Self.actionID = 0) Then
					COLLISION_WIDTH = 2944
					COLLISION_HEIGHT = 5632
				ElseIf (Self.actionID = 2) Then
					COLLISION_WIDTH = 6144
					COLLISION_HEIGHT = 2432
				EndIf
			ElseIf (StageManager.getStageID() = 11) Then
				If (Self.actionID = 0) Then
					COLLISION_WIDTH = 3712
					COLLISION_HEIGHT = 5504
				ElseIf (Self.actionID = 2) Then
					COLLISION_WIDTH = 6912
					COLLISION_HEIGHT = 3456
				EndIf
			EndIf
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, direction_or__width:Int, __height:Int)
			Super.New(id, x, y, left, top, direction_or__width, __height)
			
			If (pipeAnimation = Null) Then
				If (StageManager.getCurrentZoneId() <> 6) Then
					pipeAnimation = New Animation("/animation/pipe_in")
				Else
					pipeAnimation = New Animation("/animation/pipe_in" + StageManager.getCurrentZoneId() + (StageManager.getStageID() - 9))
				EndIf
			EndIf
			
			Self.direction = direction_or__width
			Self.dirRect = Self.direction ' direction_or__width
			
			Select (direction_or__width) ' Self.direction
				Case DIRECTION_UP
					Self.transID = 0
					Self.actionID = 0
				Case DIRECTION_DOWN
					Self.transID = 5
					Self.actionID = 0
				Case DIRECTION_LEFT
					Self.transID = 0
					Self.actionID = 2
				Case DIRECTION_RIGHT
					Self.transID = 4
					Self.actionID = 2
			End Select
			
			Self.velx = ((left * 96) Shr 6)
			Self.vely = ((top * 96) Shr 6)
			
			updateCollisionInfo()
			
			Self.drawer = pipeAnimation.getDrawer(Self.actionID, True, TRANS[Self.transID])
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(pipeAnimation)
			
			pipeAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			updateCollisionInfo()
			
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT) ' Shr 1
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not player.piping) Then
				If (Self.direction = direction) Then
					Select (direction)
						Case DIRECTION_UP
							player.collisionState = PlayerObject.COLLISION_STATE_JUMP
							
							' Magic number: 1
							player.worldCal.actionState = 1
							
							player.posX = Self.posX
						Case DIRECTION_DOWN
							player.posX = Self.posX
						Case DIRECTION_LEFT, DIRECTION_RIGHT
							' Magic number: 768
							player.posY = (Self.posY + 768)
					End Select
					
					player.pipeIn(Self.posX, Self.posY, Self.velx, Self.vely)
					
					If (PlayerObject.getCharacterID() = 3) Then
						SoundSystem.getInstance().playSe(SoundSystem.SE_133)
					Else
						SoundSystem.getInstance().playSe(SoundSystem.SE_109)
					EndIf
					
					player.setAnimationId(PlayerObject.ANI_JUMP)
					player.stopMove()
				Else
					player.beStop(0, direction, Self)
				EndIf
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
End