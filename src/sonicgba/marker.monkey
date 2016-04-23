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
	Import sonicgba.rocketseparateeffect
	Import sonicgba.stagemanager
	
	Import state.gamestate
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:

' Markers are also known as checkpoints: They let you respawn next to them if you die.
Class Marker Extends GimmickObject
	Private
		' Constant variable(s):
		Const MARKER_WIDTH:Int = 640
		Const MARKER_HEIGHT:Int = 3200
		
		Const MARKER_WIDTH_61:Int = 9216
		Const MARKER_HEIGHT_61:Int = 16384
		Const MARKER_HEIGHT_61_2:Int = 2560
		
		' Global variable(s):
		Global markerAnimation:Animation
		
		' Fields:
		Field MarkID:Int
		
		Field drawer:AnimationDrawer
		
		Field isStage61:Bool
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(markerAnimation)
			
			markerAnimation = Null
		End
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.MarkID = 0
			
			Self.used = False
			
			If (markerAnimation = Null) Then
				markerAnimation = New Animation("/animation/se_marker")
			EndIf
			
			Self.drawer = markerAnimation.getDrawer(0, True, TRANS_NONE)
			
			Self.MarkID = left
			
			Self.isStage61 = (StageManager.getStageID() = 10)
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (player.getCharacterID() = CHARACTER_KNUCKLES) Then
				' Optimization potential; dynamic cast.
				Local knuckles:= PlayerKnuckles(player)
				
				If (knuckles <> Null) Then
					knuckles.dripDownUnderWater()
				EndIf
			EndIf
			
			If (Not Self.used) Then
				If (PlayerObject.currentMarkId < Self.iLeft) Then
					Self.used = True
					
					Self.drawer.setActionId(1)
					Self.drawer.setLoop(False)
					
					If (stageModeState = STATE_NORMAL_MODE) Then
						StageManager.saveCheckPoint(Self.posX, Self.posY)
					EndIf
					
					If (Not Self.isStage61) Then
						PlayerObject.currentMarkId = Self.iLeft
						
						If (Not GameState.PreGame) Then
							soundInstance.playSe(SoundSystem.SE_169)
						EndIf
					ElseIf (player.faceDegree = 0) Then
						PlayerObject.currentMarkId = Self.iLeft
						
						RocketSeparateEffect.getInstance().init(Self.iLeft - 1)
					Else
						Self.used = False
					EndIf
				EndIf
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (StageManager.getStageID() <> 10) Then
				drawInMap(g, Self.drawer, Self.posX, Self.posY)
				
				If (Self.drawer.checkEnd()) Then
					Self.drawer.setActionId(2)
					
					Self.drawer.setLoop(True)
				EndIf
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method logic:Void()
			If (Not Self.used) Then
				If (PlayerObject.currentMarkId >= Self.iLeft) Then
					Self.used = True
					
					Self.drawer.setActionId(2)
					Self.drawer.setLoop(True)
					
					If (PlayerObject.currentMarkId = Self.iLeft And StageManager.getStageID() = 10) Then
						RocketSeparateEffect.getInstance().functionSecond(Self.iLeft - 1)
					EndIf
				EndIf
			EndIf
			
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (MARKER_WIDTH / 2), y - MARKER_HEIGHT, MARKER_WIDTH, MARKER_HEIGHT)
			
			If (StageManager.getStageID() = 10) Then
				Select (Self.iLeft - 1)
					Case 0
						Self.collisionRect.setRect(x - (MARKER_WIDTH / 2), y - MARKER_HEIGHT_61, MARKER_WIDTH, MARKER_HEIGHT_61)
					Default
						Self.collisionRect.setRect(x - (MARKER_WIDTH_61 / 2), y - MARKER_HEIGHT, MARKER_WIDTH_61, MARKER_HEIGHT_61_2)
				End Select
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End