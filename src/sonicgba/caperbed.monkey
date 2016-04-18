Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playerknuckles
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class CaperBed Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2944
		Const COLLISION_HEIGHT:Int = 768
		
		Const MIN_POWER:Int = 1082
		Const MAX_POWER:Int = 2948
		
		' Global variable(s):
		Global caperAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
	Protected
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(caperAnimation)
			
			caperAnimation = Null
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (caperAnimation = Null) Then
				If (StageManager.getCurrentZoneId() <> 6) Then
					caperAnimation = New Animation("/animation/se_toramporin_" + String(StageManager.getCurrentZoneId()))
				Else
					caperAnimation = New Animation("/animation/se_toramporin_2")
				EndIf
			EndIf
			
			Self.drawer = caperAnimation.getDrawer(0, False, 0)
		End
	Public
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			If (Self.drawer.checkEnd()) Then
				Self.drawer.setActionId(0)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			Local power:Int
			
			Local refVelY:= p.getVelY()
			
			p.beStop(Self.collisionRect.y0, direction, Self)
			
			If (direction = DIRECTION_NONE And (p.getCharacterID() = CHARACTER_KNUCKLES) And p.myAnimationID = PlayerKnuckles.KNUCKLES_ANI_CLIMB_5) Then
				power = ((Abs(refVelY) * 4) / 3)
				
				If (power > MAX_POWER) Then
					power = MAX_POWER
				EndIf
				
				If (power < MIN_POWER) Then
					power = MIN_POWER
				EndIf
				
				p.beSpring(power, DIRECTION_DOWN)
				
				Self.drawer.setActionId(1)
				
				p.setAnimationId(PlayerKnuckles.KNUCKLES_ANI_SPRING_1)
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_176)
			EndIf
			
			Select (direction)
				Case DIRECTION_DOWN
					' This behavior may change in the future:
					If (p = player) Then
						power = ((Abs(refVelY) * 4) / 3)
						
						If (power > MAX_POWER) Then
							power = MAX_POWER
						EndIf
						
						If (power < MIN_POWER) Then
							power = MIN_POWER
						EndIf
						
						p.beSpring(power, DIRECTION_DOWN) ' direction
						
						Self.drawer.setActionId(1)
						
						p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_176)
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End