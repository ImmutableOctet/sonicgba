Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Door Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 2048
		
		Const COLLISION_H_OFFSET:Int = 512
		Const COLLISION_V_OFFSET:Int = 512
		
		' Fields:
		Field actionId:Int
		
		Field drawer:AnimationDrawer
		
		Field isActived:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (doorAnimation = Null) Then
				doorAnimation = New Animation("/animation/door")
			EndIf
			
			Select (Self.objId)
				Case GIMMICK_DOOR_V
					Self.actionId = 0
				Case GIMMICK_DOOR_H
					Self.actionId = 2
			End Select
			
			Self.drawer = doorAnimation.getDrawer(Self.actionId, False, 0)
			
			Self.isActived = False
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			' Empty implementation.
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			If (Self.drawer.checkEnd() And Self.isActived) Then
				Self.drawer.setActionId(Self.actionId)
				
				Self.isActived = False
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method doWhileNoCollision:Void()
			If (Not isInCameraSmaller() And Self.isActived) Then
				Self.isActived = False
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Select (Self.objId)
				Case GIMMICK_DOOR_V
					Select (direction)
						Case DIRECTION_LEFT
							If (Self.iLeft = 0) Then
								player.beStop(Self.collisionRect.y0, direction, Self)
							Else
								Self.drawer.setActionId(Self.actionId + 1)
								
								Self.isActived = True
								
								SoundSystem.getInstance().playSe(SoundSystem.SE_185)
								
								If (player.getVelX() <= 0 And player.getVelX() >= (-PlayerObject.MOVE_POWER)) Then
									player.outOfControl = True
									
									player.setFootPositionX(player.posX + COLLISION_WIDTH)
									
									player.outOfControl = False
								EndIf
							EndIf
						Case DIRECTION_RIGHT
							If (Self.iLeft <> 0) Then
								player.beStop(Self.collisionRect.y0, direction, Self)
							Else
								Self.drawer.setActionId(Self.actionId + 1)
								
								Self.isActived = True
								
								SoundSystem.getInstance().playSe(SoundSystem.SE_185)
								
								If (player.getVelX() >= 0 And player.getVelX() <= PlayerObject.MOVE_POWER) Then
									player.outOfControl = True
									
									player.setFootPositionX(player.posX - COLLISION_WIDTH)
									
									player.outOfControl = False
								EndIf
							EndIf
					End Select
				Case GIMMICK_DOOR_H
					Select (direction)
						Case DIRECTION_UP
							If (Self.iLeft <> 0) Then
								Self.drawer.setActionId(Self.actionId + 1)
								
								Self.isActived = True
								
								SoundSystem.getInstance().playSe(SoundSystem.SE_185)
							Else
								player.beStop(Self.collisionRect.y0, direction, Self)
							EndIf
						Case 1
							If (Self.iLeft <> 0) Then
								player.beStopbyDoor(Self.collisionRect.y0, direction, Self)
							Else
								Self.drawer.setActionId(Self.actionId + 1)
								
								Self.isActived = True
								
								SoundSystem.getInstance().playSe(SoundSystem.SE_185)
							EndIf
					End Select
			End Select
			
			If (Self.firstTouch) Then
				player.pipeOut()
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Select (Self.objId)
				Case GIMMICK_DOOR_V
					Self.collisionRect.setRect((x - COLLISION_V_OFFSET), y, COLLISION_WIDTH, COLLISION_HEIGHT)
				Case GIMMICK_DOOR_H
					Self.collisionRect.setRect(x, (y - COLLISION_V_OFFSET), COLLISION_HEIGHT, COLLISION_WIDTH)
			End Select
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End