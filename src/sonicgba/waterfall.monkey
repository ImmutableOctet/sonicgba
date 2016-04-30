Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.soundsystem
	
	'Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerknuckles
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class WaterFall Extends GimmickObject
	Private
		' Global variable(s):
		Global frame:Int
		
		' Fields:
		Field drawSpace:Int
		
		Field drawer:AnimationDrawer
		
		Field isActived:Bool
		Field isFirstTouchedSandFall:Bool
		Field isTouchSand:Bool
	Public
		' Global variable(s):
		Global waterFallDrawer1:AnimationDrawer
		Global waterFallDrawer2:AnimationDrawer
		Global waterFallDrawer3:AnimationDrawer
		Global waterFallDrawer4:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			'Self.isTouchSand = False
			'Self.isFirstTouchedSandFall = False
			
			player.initWaterFall()
			
			player.isCrashFallingSand = False
			
			Self.isActived = False
			Self.isFirstTouchedSandFall = False
			
			If (StageManager.getCurrentZoneId() = 1) Then
				Self.isTouchSand = False
			ElseIf (StageManager.getCurrentZoneId() = 5) Then
				Self.isTouchSand = False
				
				frame = 0
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimationDrawer(waterFallDrawer1)
			Animation.closeAnimationDrawer(waterFallDrawer2)
			Animation.closeAnimationDrawer(waterFallDrawer3)
			Animation.closeAnimationDrawer(waterFallDrawer4)
			
			waterFallDrawer1 = Null
			waterFallDrawer2 = Null
			waterFallDrawer3 = Null
			waterFallDrawer4 = Null
		End
		
		Function staticLogic:Void()
			If (waterFallDrawer1 <> Null) Then
				waterFallDrawer1.moveOn()
			EndIf
			
			If (waterFallDrawer2 <> Null) Then
				waterFallDrawer2.moveOn()
			EndIf
			
			If (waterFallDrawer3 <> Null) Then
				waterFallDrawer3.moveOn()
			EndIf
			
			If (waterFallDrawer4 <> Null) Then
				waterFallDrawer4.moveOn()
			EndIf
		End
		
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player And Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
				If (StageManager.getCurrentZoneId() = 5) Then
					Self.isActived = True
					
					If (p.collisionState = PlayerObject.COLLISION_STATE_JUMP) Then
						p.collisionState = PlayerObject.COLLISION_STATE_IN_SAND
					EndIf
					
					If (Not Self.isTouchSand) Then
						Self.isTouchSand = True
					EndIf
					
					p.isCrashFallingSand = True
					
					If ((p.getCharacterID() = CHARACTER_KNUCKLES)) Then
						' Optimization potential; dynamic cast.
						Local knuckles:= PlayerKnuckles(p)
						
						If (knuckles <> Null) Then
							If (knuckles.flying) Then
								p.setVelX(0)
								
								knuckles.flying = False
							EndIf
						EndIf
					EndIf
					
					' Magic numbers: 498, -498
					If (p.getVelX() >= 498) Then
						p.setVelX(498)
					ElseIf (p.getVelX() <= -498) Then
						p.setVelX(-498)
					EndIf
					
					If (Not Self.isFirstTouchedSandFall) Then
						soundInstance.playSe(SoundSystem.SE_201_01)
						
						Self.isFirstTouchedSandFall = True
						
						frame = 0
					EndIf
					
					If (Self.isFirstTouchedSandFall) Then
						frame += 1
						
						If (frame > 4 And Not IsGamePause) Then
							soundInstance.playLoopSe(SoundSystem.SE_201_02)
						EndIf
					EndIf
				ElseIf (StageManager.getCurrentZoneId() <> 1) Then
					Self.isActived = True
					
					' Magic number: 11
					frame += 1
					frame Mod= 11
					
					If (Not Self.isTouchSand) Then
						Self.isTouchSand = True
					EndIf
					
					p.isCrashFallingSand = False
				Else
					p.isCrashFallingSand = False
				EndIf
				
				p.beWaterFall()
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.isActived) Then
				If (Self.isFirstTouchedSandFall) Then
					If (soundInstance.getPlayingLoopSeIndex() = SoundSystem.SE_201_02) Then
						soundInstance.stopLoopSe()
					EndIf
					
					Self.isFirstTouchedSandFall = False
				EndIf
				
				player.isCrashFallingSand = False
				
				Self.isActived = False
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Self.drawer <> Null) Then
				MyAPI.setClip(g, (Self.collisionRect.x0 Shr 6) - camera.x, (Self.collisionRect.y0 Shr 6) - camera.y, Self.collisionRect.getWidth() Shr 6, Self.collisionRect.getHeight() Shr 6)
				
				Local i:= Self.collisionRect.y0
				
				While (i < Self.collisionRect.y1)
					drawInMap(g, Self.drawer, Self.posX, i)
					
					i += Self.drawSpace
				Wend
				
				MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic number: 512
			Self.collisionRect.setRect(x, (Self.iTop * 512) + y, Self.mWidth, Self.mHeight)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
End