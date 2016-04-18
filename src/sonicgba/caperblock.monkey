Strict

Public

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
	Public
		' Functions:
		Function releaseAllResource:Void()
			blockImage = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, blockImage, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), TOP|HCENTER)
			
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
				
				' This behavior may change in the future (Forced usage of 'player'):
				Select (direction)
					Case DIRECTION_DOWN
						If (p = player) Then
							p.beSpring(1350, DIRECTION_DOWN) ' direction
							
							Self.hobinCal.startHobin(400, 90, 10)
							
							If ((p.getCharacterID() = CHARACTER_KNUCKLES) And (p.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_FLY_1 Or p.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_FLY_2 Or p.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_FLY_3 Or p.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_FLY_4)) Then
								p.setAnimationId(PlayerKnuckles.KNUCKLES_ANI_WALK_1) ' 1
							Else
								p.setAnimationId(PlayerObject.ANI_RUN_1) ' 1
							EndIf
							
							If (p.faceDirection) Then
								p.degreeForDraw = 1
								p.degreeRotateMode = 1
							Else
								p.degreeForDraw = 359
								p.degreeRotateMode = 2
							EndIf
							
							soundInstance.playSe(SoundSystem.SE_148)
						EndIf
					Case DIRECTION_NONE
						If (p.getMoveDistance().y > 0 And p.getCollisionRect().y1 < Self.collisionRect.y1 And p = player) Then
							p.beSpring(1350, DIRECTION_DOWN)
							
							Self.hobinCal.startHobin(400, 90, 10)
							
							p.setAnimationId(PlayerObject.ANI_RUN_1)
							
							If (p.faceDirection) Then
								p.degreeForDraw = 1
								p.degreeRotateMode = 1
							Else
								p.degreeForDraw = 359
								p.degreeRotateMode = 2
							EndIf
							
							soundInstance.playSe(SoundSystem.SE_148)
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y + COLLISION_Y_OFFSET, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.hobinCal = Null
		End
End