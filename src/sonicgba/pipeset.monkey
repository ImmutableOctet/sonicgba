Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.pipein
Friend sonicgba.pipeout

' Imports:
Private
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class PipeSet Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		' Fields:
		Field posx:Int
		Field posy:Int
		Field velx:Int
		Field vely:Int
		
		Field terminal:Bool
		Field touching:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Magic numbers: 127, 128 (Size):
			Self.velx = (left * ((COLLISION_WIDTH*2)-128)) / width
			Self.vely = (top * ((COLLISION_HEIGHT*2)-128)) / width
			
			Self.terminal = (height = 127)
		End
	Private
		Method pipeSetLogic:Void()
			' Magic numbers: 3, 25, 4 (Character ID, sound effect IDs):
			If (Self.terminal) Then
				player.pipeSet(Self.posX, Self.posY, Self.velx, Self.vely)
				
				Self.touching = True
				
				If (PlayerObject.getCharacterID() = 3) Then
					SoundSystem.getInstance().playSe(25)
					
					Return
				Else
					SoundSystem.getInstance().playSe(4)
					
					Return
				EndIf
			EndIf
			
			player.pipeSet(Self.posX, Self.posY, Self.velx, Self.vely)
			
			If (PlayerObject.getCharacterID() = 3) Then
				SoundSystem.getInstance().playSe(25)
			Else
				SoundSystem.getInstance().playSe(4)
			EndIf
		End
	Public
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.firstTouch) Then
				Return
			EndIf
			
			' Magic number: Stage ID.
			If (StageManager.getStageID() = 11) Then
				' Not sure why this is restricted to the stage with ID 11:
				If (player.piping) Then
					pipeSetLogic()
				EndIf
			ElseIf (Self.iHeight = 0 Or player.piping) Then
				pipeSetLogic()
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.touching) Then
				' Magic number: Stage ID.
				If (StageManager.getStageID() <> 11) Then
					' Not sure why, but we're only enabling pipe behavior on the stage with ID 11.
					player.pipeOut()
				EndIf
				
				Self.touching = False
			EndIf
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawCollisionRect(graphics)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
End