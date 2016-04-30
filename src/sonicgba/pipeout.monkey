Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.pipein
Friend sonicgba.pipeset

' Imports:
Private
	Import lib.constutil
	
	Import sonicgba.basicpipe
Public

' Classes:
Class PipeOut Extends BasicPipe
	Private
		' Constant variable(s):
		Const OUT_SPEED_1:Int = 1440
		Const OUT_SPEED_2:Int = 1824
		
		Const PIPE_OUT_VELOCITY:Int = 28
		
		' Global variable(s):
		Global COLLISION_WIDTH:Int = 2304
		Global COLLISION_HEIGHT:Int = 2560
		
		' Fields:
		Field outVel:Int
		
		Field touching:Bool
	Protected
		' Functions:
		Function updateCollisionInfo:Void()
			If (StageManager.getCurrentZoneId() = 2 Or StageManager.getStageID() = 10) Then
				If (Self.actionID = 1) Then
					COLLISION_WIDTH = 2944
					COLLISION_HEIGHT = 5632
				ElseIf (Self.actionID = 3) Then
					COLLISION_WIDTH = 6144
					COLLISION_HEIGHT = 2432
				EndIf
			ElseIf (StageManager.getStageID() = 11) Then
				If (Self.actionID = 1) Then
					COLLISION_WIDTH = 3712
					COLLISION_HEIGHT = 5504
				ElseIf (Self.actionID = 3) Then
					COLLISION_WIDTH = 6912
					COLLISION_HEIGHT = 3456
				EndIf
			EndIf
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, direction_or__width:Int, __height:Int)
			Super.New(id, x, y, left, top, direction_or__width, __height)
			
			Select (direction_or__width) ' Self.direction
				Case DIRECTION_UP
					Self.actionID = 1
				Case DIRECTION_DOWN
					Self.actionID = 1
				Case DIRECTION_LEFT
					Self.actionID = 3
				Case DIRECTION_RIGHT
					Self.actionID = 3
			End Select
			
			If (top = 20) Then
				Self.outVel = PickValue((Self.direction = DIRECTION_DOWN Or Self.direction = DIRECTION_RIGHT), -OUT_SPEED_1, OUT_SPEED_1)
			ElseIf (top = 30) Then
				Self.outVel = PickValue((Self.direction = DIRECTION_DOWN Or Self.direction = DIRECTION_RIGHT), -OUT_SPEED_2, OUT_SPEED_2)
			EndIf
			
			updateCollisionInfo()
			
			makeDrawer()
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(pipeAnimation)
			
			pipeAnimation = Null
		End
		
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			updateCollisionInfo()
			
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT) ' Shr 1
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.firstTouch And player.piping) Then
				Self.touching = True
				
				Select (Self.direction)
					Case DIRECTION_UP, DIRECTION_DOWN
						If (player.velX = 0) Then
							player.velY = Self.outVel
							player.velX = 0
						Else
							player.pipeSet(Self.posX, Self.posY, 0, Self.outVel)
						EndIf
					Case DIRECTION_LEFT, DIRECTION_RIGHT
						If (player.velY <> 0) Then
							player.pipeSet(Self.posX, Self.posY, Self.outVel, 0)
						Else
							player.velX = Self.outVel
							player.velY = 0
						EndIf
						
						If (Self.direction = DIRECTION_LEFT) Then
							player.faceDirection = True
						EndIf
						
						If (Self.direction = DIRECTION_RIGHT) Then
							player.faceDirection = False
						EndIf
				End Select
			EndIf
			
			If (player.piping And (Self.direction = DIRECTION_LEFT Or Self.direction = DIRECTION_RIGHT)) Then
				player.footPointY = (Self.posY + (PlayerObject.HEIGHT / 2))
				
				player.changeVisible(False)
			EndIf
			
			If (Not Self.touching Or Not player.piping) Then
				player.beStop(0, direction, Self)
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.touching And player.piping) Then
				player.pipeOut()
				
				player.changeVisible(True)
				
				Self.touching = False
				
				If (Self.direction <> DIRECTION_DOWN) Then
					player.setVelY(0)
				EndIf
			EndIf
		End
End