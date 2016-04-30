Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.pipeout
Friend sonicgba.pipeset

' Imports:
Private
	Import sonicgba.basicpipe
	
	Import com.sega.engine.action.acworldcollisioncalculator
Public

' Classes:
Class PipeIn Extends BasicPipe
	Protected
		' Constant variable(s):
		Global TRANS:Int[] = [TRANS_NONE, TRANS_ROT180, TRANS_ROT270, TRANS_ROT90, TRANS_MIRROR, TRANS_MIRROR_ROT180] ' [0, 3, 6, 5, 2, 1] ' Const
	Private
		' Global variable(s):
		Global COLLISION_WIDTH:Int = 2304
		Global COLLISION_HEIGHT:Int = 2560
		
		' Fields:
		Field velx:Int
		Field vely:Int
	Public
		' Global variable(s):
		Global pipeAnimation:Animation
	Protected
		' Functions:
		Function releaseAllResource:Void()
			BasicPipe.releaseAllResource()
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, direction_or__width:Int, __height:Int)
			Super.New(id, x, y, left, top, direction_or__width, __height)
			
			Select (direction_or__width) ' Self.direction
				Case DIRECTION_UP
					Self.actionID = 0
				Case DIRECTION_DOWN
					Self.actionID = 0
				Case DIRECTION_LEFT
					Self.actionID = 2
				Case DIRECTION_RIGHT
					Self.actionID = 2
			End Select
			
			Self.velx = ((left * 96) Shr 6)
			Self.vely = ((top * 96) Shr 6)
			
			updateCollisionInfo()
			
			makeDrawer()
		End
		
		' Methods:
		
		' Extensions:
		Method updateCollisionInfo:Void()
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
	Public
		' Methods:
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
End