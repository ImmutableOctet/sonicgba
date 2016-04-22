Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class FlipV Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1088
		Const COLLISION_HEIGHT:Int = 3072
		
		Const COLLISION_HEIGHT_OFFSET:Int = 512
		
		Const ACCELERATE_POWER:Int = 3000
		
		' Global variable(s):
		Global flipAnimation:Animation
	Private
		' Fields:
		Field count:Int
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (flipAnimation = Null) Then
				flipAnimation = New Animation("/animation/flip")
			EndIf
			
			Self.drawer = flipAnimation.getDrawer(0, True, 0)
			
			Self.count = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(flipAnimation)
			
			flipAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Self.count <> 0) Then
				Self.count += 1
			EndIf
			
			' Magic number: 5
			If (Self.count = 5 And (player.getCharacterID() = CHARACTER_AMY)) Then
				' Optimization potential; dynamic cast.
				Local amy:= PlayerAmy(player)
				
				If (amy <> Null) Then
					amy.setCannotAttack(False)
				EndIf
			EndIf
			
			' Magic number: 10
			If (Self.count >= 10) Then
				Self.count = 0
			EndIf
			
			drawInMap(g, Self.drawer)
			
			If (Self.drawer.checkEnd()) Then
				Self.drawer.setActionId(0)
				Self.drawer.setLoop(True)
				
				Self.drawer.setTrans(TRANS_NONE)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), (y - COLLISION_HEIGHT) + COLLISION_HEIGHT_OFFSET, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player And Self.drawer.getActionId() = 0) Then
				Select (direction)
					Case DIRECTION_DOWN
						player.beStop(Self.collisionRect.y0, direction, Self)
					Case DIRECTION_LEFT
						If (p.collisionState = PlayerObject.COLLISION_STATE_JUMP) Then
							p.beStop(Self.collisionRect.y0, direction, Self)
						ElseIf (Self.count = 0) Then
							If (player.beAccelerate(ACCELERATE_POWER, True, Self)) Then
								If (player.getCharacterID() = CHARACTER_AMY) Then
									' Optimization potential; dynamic cast.
									Local amy:= PlayerAmy(player)
									
									If (amy <> Null) Then
										amy.resetAttackLevel()
										amy.setCannotAttack(True)
									EndIf
								EndIf
								
								Self.drawer.setActionId(1)
								Self.drawer.setLoop(False)
								
								SoundSystem.getInstance().playSe(SoundSystem.SE_183)
							EndIf
							
							Self.count += 1
						EndIf
					Case DIRECTION_RIGHT
						If (p.collisionState = PlayerObject.COLLISION_STATE_JUMP) Then
							p.beStop(Self.collisionRect.y0, direction, Self)
						ElseIf (Self.count = 0) Then
							If (player.beAccelerate(-ACCELERATE_POWER, True, Self)) Then
								' Optimization potential; dynamic cast.
								Local amy:= PlayerAmy(player)
								
								If (amy <> Null) Then
									amy.resetAttackLevel()
									amy.setCannotAttack(True)
								EndIf
								
								Self.drawer.setActionId(1)
								Self.drawer.setLoop(False)
								
								Self.drawer.setTrans(TRANS_MIRROR)
								
								SoundSystem.getInstance().playSe(SoundSystem.SE_183)
							EndIf
							
							Self.count += 1
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End