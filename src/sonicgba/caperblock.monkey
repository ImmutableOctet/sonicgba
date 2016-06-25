Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.soundsystem
	
	Import gameengine.key
	
	Import sonicgba.gimmickobject
	Import sonicgba.hobincal
	Import sonicgba.playerobject
	Import sonicgba.playerknuckles
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class CaperBlock Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2048
		Const COLLISION_HEIGHT:Int = 1024
		
		Const COLLISION_Y_OFFSET:Int = 192
		
		' Extensions:
		Const SPRING_FORCE:Int = 1350
		
		' Global variable(s):
		Global blockImage:MFImage
		
		' Fields:
		Field hobinCal:HobinCal
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.posY -= (COLLISION_HEIGHT / 2)
			
			If (blockImage = Null) Then
				If (StageManager.getCurrentZoneId() <> 6) Then
					blockImage = MFImage.createImage("/gimmick/caper_block_" + String(StageManager.getCurrentZoneId()) + ".png")
				Else
					blockImage = MFImage.createImage("/gimmick/caper_block_" + String(StageManager.getCurrentZoneId()) + String(StageManager.getStageID() - 9) + ".png")
				EndIf
			EndIf
			
			Self.hobinCal = New HobinCal()
		End
		
		' Methods:
		
		' Extensions:
		Method playSound:Void()
			soundInstance.playSe(SoundSystem.SE_148)
		End
		
		Method shake:Void()
			Self.hobinCal.startHobin(400, 90, 10)
		End
		
		Method changePlayerDirection:Void(p:PlayerObject)
			If (p.faceDirection) Then
				p.degreeForDraw = 1
				p.degreeRotateMode = PlayerObject.ROTATE_MODE_POSITIVE
			Else
				p.degreeForDraw = 359
				p.degreeRotateMode = PlayerObject.ROTATE_MODE_NEGATIVE
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			blockImage = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, blockImage, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), TOP|HCENTER)
			
			' This may be moved in the future.
			Self.hobinCal.logic()
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Self.hobinCal.isStop()) Then
				p.beStop(Self.collisionRect.x0, direction, Self)
				
				If (Key.repeated(Key.gLeft)) Then
					p.faceDirection = False
				ElseIf (Key.repeated(Key.gRight)) Then
					p.faceDirection = True
				EndIf
				
				' This behavior may change in the future (Forced usage of 'player'; applies to all cases):
				Select (direction)
					Case DIRECTION_DOWN
						If (p = player) Then
							p.beSpring(SPRING_FORCE, DIRECTION_DOWN) ' 1 ' direction
							
							shake()
							
							If ((p.getCharacterID() = CHARACTER_KNUCKLES) And (p.getCharacterAnimationID() >= PlayerKnuckles.KNUCKLES_ANI_FLY_1 And p.getCharacterAnimationID() <= PlayerKnuckles.KNUCKLES_ANI_FLY_4)) Then ' 1, 2, 3, 4
								p.setAnimationId(PlayerKnuckles.KNUCKLES_ANI_WALK_1) ' 1
							Else
								p.setAnimationId(PlayerObject.ANI_RUN_1) ' 1
							EndIf
							
							changePlayerDirection(p)
							
							playSound()
						EndIf
					Case DIRECTION_NONE
						If (p.getMoveDistance().y > 0 And p.getCollisionRect().y1 < Self.collisionRect.y1 And p = player) Then
							p.beSpring(SPRING_FORCE, DIRECTION_DOWN) ' 1
							
							shake()
							
							p.setAnimationId(PlayerObject.ANI_RUN_1)
							
							changePlayerDirection(p)
							
							playSound()
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect((x - (COLLISION_WIDTH / 2)), (y + COLLISION_Y_OFFSET), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.hobinCal = Null
		End
End