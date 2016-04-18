Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	'Import sonicgba.sonicdef
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playersonic
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Terminal Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_WIDTH_61:Int = 1024
		
		Const COLLISION_HEIGHT:Int = 9216
		Const COLLISION_HEIGHT_61:Int = 1
		
		' Global variable(s):
		Global drawer:AnimationDrawer
		
		' Fields:
		Field type:Int
		
		Field showDrawer:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.showDrawer = (Self.iLeft = COLLISION_HEIGHT_61 And (StageManager.getStageID() Mod 2 = 0) And StageManager.getStageID() <> 10)
			
			If (Self.showDrawer) Then
				' This behavior may change in the future.
				drawer = Null
				
				If (drawer = Null) Then
					drawer = New Animation("/animation/terminal").getDrawer(0, False, 0)
				EndIf
			Else
				Self.posX += (COLLISION_WIDTH / 2)
			EndIf
			
			Self.type = PlayerObject.TERMINAL_RUN_TO_RIGHT ' 0
			
			If (StageManager.getStageID() = 10) Then
				Self.type = PlayerObject.TERMINAL_NO_MOVE ' 1
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimationDrawer(drawer)
			
			drawer = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Self.showDrawer) Then
				drawInMap(g, drawer)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.showDrawer) Then
				Self.collisionRect.setRect(x, y - Self.mHeight, Self.mWidth, Self.mHeight)
			Else
				Self.collisionRect.setRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
			
			If (StageManager.getStageID() = 10) Then
				Self.collisionRect.setRect(x - (COLLISION_WIDTH_61 / 2), y, COLLISION_WIDTH_61, COLLISION_HEIGHT_61)
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not PlayerObject.isTerminal) Then
				Select (Self.type)
					Case PlayerObject.TERMINAL_RUN_TO_RIGHT ' 0
						If (drawer <> Null) Then
							If (Self.iLeft <> COLLISION_HEIGHT_61) Then
								player.setTerminalSingle(Self.type)
							ElseIf ((PlayerObject.getCharacterID() = CHARACTER_SONIC And (player.getCharacterAnimationID() = PlayerSonic.SONIC_ANI_JUMP_DASH_2 Or player.getCharacterAnimationID() = PlayerSonic.SONIC_ANI_JUMP_DASH_1)) Or player.getAnimationId() = PlayerObject.ANI_JUMP) Then
								player.setTerminalSingle(Self.type)
							Else
								player.setTerminal(Self.type)
							EndIf
							
							drawer.setActionId(COLLISION_HEIGHT_61)
							
							soundInstance.playSe(SoundSystem.SE_135)
						EndIf
					Case PlayerObject.TERMINAL_NO_MOVE ' 1
						If (Self.iLeft = 0) Then
							player.setTerminal(Self.type)
						EndIf
					Default
						' Nothing so far.
				End Select
			EndIf
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End