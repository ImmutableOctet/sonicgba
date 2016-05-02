Strict

Public

' Preprocessor related:
#If SONICGBA_EASTEREGGS
	#SONICGBA_SPSPRING_EASTEREGG = True
#End

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.spring

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.sonicdef
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	Import sonicgba.spring
	Import sonicgba.stagemanager
	
	Import state.gamestate
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SpSpring Extends Spring
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1920
		Const COLLISION_HEIGHT:Int = 2048
		
		Const ENTERED_SP_SPRING_POWER:Int = 2096
		Const SP_SPRING_POWER:Int = 2800
		Const VELOCITY_MINUS:Int = 7
		
		' Fields:
		Field drawer__spspring:AnimationDrawer
		
		Field spEntered:Bool
	Public
		' Global variable(s):
		Global springAnimation:Animation = Null
		
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(springAnimation)
			
			springAnimation = Null
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (springAnimation = Null) Then
				springAnimation = New Animation("/animation/sp_bane")
			EndIf
			
			Self.springPower = SP_SPRING_POWER
			
			Self.drawer__spspring = springAnimation.getDrawer(0, False, 0)
			Self.spEntered = GameState.isBackFromSpStage
		End
		
		' Methods:
		
		' Extensions:
		Method playSound:Void()
			#If Not SONICGBA_SPSPRING_EASTEREGG
				soundInstance.playSe(SoundSystem.SE_148)
			#Else
				soundInstance.playSe(SoundSystem.SE_166)
			#End
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer__spspring, Self.posX, Self.posY)
			
			If (Self.drawer__spspring.checkEnd()) Then
				Self.drawer__spspring.setActionId(0)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.used) Then
				p.beStop(Self.collisionRect.x0, direction, Self)
				
				' This behavior may change in the future:
				If (p = player) Then
					Select (direction)
						Case DIRECTION_DOWN
							If (Self.spEntered) Then
								p.beSpring(ENTERED_SP_SPRING_POWER, direction)
								p.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
								
								playSound()
							Else
								p.beSpSpring(Self.springPower, direction)
								
								StageManager.saveSpecialStagePoint(Self.posX - COLLISION_WIDTH, Self.posY)
							EndIf
							
							Self.drawer__spspring.setActionId(1)
						Default
							' Nothing so far.
					End Select
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (PlayerObject.getCharacterID() = CHARACTER_AMY And animationID <> PlayerAmy.AMY_ANI_DASH_3 And animationID <> PlayerAmy.AMY_ANI_DASH_4 And direction = DIRECTION_NONE) Then
				If (Self.spEntered) Then
					' Magic number: 2724
					player.beSpring(2724, DIRECTION_DOWN)
					
					player.setAnimationId(PlayerObject.ANI_POP_JUMP_UP)
					
					playSound()
				Else
					player.beSpSpring(Self.springPower, direction)
					
					StageManager.saveSpecialStagePoint((Self.posX - COLLISION_WIDTH), Self.posY)
				EndIf
				
				Self.drawer__spspring.setActionId(1)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.drawer__spspring = Null
		End
End