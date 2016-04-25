Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	
	Import sonicgba.sonicdef
	Import sonicgba.backgroundmanager
	Import sonicgba.gameobject
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	Import sonicgba.effect
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import monkey.stack
Public

Class RocketSeparateEffect ' Implements SonicDef
	Private
		Const ANICOUNT_TIME:Int = 5
		
		Const PARTS_ANIMATION_PATH:String = "/animation/parts"
		
		Const PARTS_INFO_TYPE:Int = 0
		
		Const PARTS_INFO_VX:Int = 3
		Const PARTS_INFO_VY:Int = 4
		
		Const PARTS_INFO_X:Int = 1
		Const PARTS_INFO_Y:Int = 2
		
		Const PARTS_NUM:Int = 6
		
		Const SHAKING_COUNT:Int = 80
		
		' States:
		Const STATE_NONE:Int = 0
		Const STATE_INIT:Int = 1
		Const STATE_SHAKING:Int = 2
		Const STATE_OVER:Int = 3
		Const STATE_WAITING:Int = 4
		Const STATE_WAITING_CAMERA:Int = 5
		Const STATE_MAP_BROKE_1:Int = 6
		Const STATE_MAP_BROKE_2:Int = 7
		Const STATE_MAP_BROKE_3:Int = 8
		Const STATE_MAP_BROKE_4:Int = 9
		
		' Global variable(s):
		Global instance:RocketSeparateEffect
		
		' Fields:
		Field state:Int
		
		Field effectID:Int
		Field count:Int
		
		Field brokeOffset:Int
		Field brokeVel:Int
		
		Field markY:Int
		
		Field partsDrawer:AnimationDrawer
		Field partsInfoVec:Stack<Int[]>
	Public
		' Functions:
		Function clearInstance:Void()
			instance = Null
		End
		
		Function getInstance:RocketSeparateEffect()
			If (instance = Null) Then
				instance = New RocketSeparateEffect()
			EndIf
			
			Return instance
		End
	Private
		' Constructor(s):
		Method New()
			Self.state = STATE_NONE
			
			Self.partsDrawer = New Animation(PARTS_ANIMATION_PATH).getDrawer()
			
			Self.partsInfoVec = New Stack<Int[]>()
		End
	Public
		' Methods:
		Method init:Void(effectID:Int)
			Self.effectID = effectID
			
			Select (effectID) ' Self.effectID
				Case Effect.EFFECT_LAYER_TOP
					' Magic number: 1056
					MapManager.setCameraLeftLimit(1056)
				Case Effect.EFFECT_LAYER_PLAYER
					' Magic number: 696
					Self.markY = 696
				Case Effect.EFFECT_LAYER_NUM
					' Magic number: 408
					Self.markY = 408
			End Select
			
			GameObject.player.setMeetingBoss(False)
			
			Self.state = STATE_INIT
		End
		
		Method functionSecond:Void(effectID:Int)
			Self.effectID = effectID
			
			If (PlayerObject.stageModeState = PlayerObject.STATE_NORMAL_MODE) Then ' GameObject
				PlayerObject.setTimeCount(ANICOUNT_TIME, 0, 0)
				PlayerObject.setOverCount(0, 0, 0)
			EndIf
			
			Select (effectID)
				Case STATE_SHAKING
					BackGroundManager.next()
				Default
					' Nothing so far.
			End Select
		End
		
		Method logic:Void()
			If (Not GameObject.IsGamePause) Then
				Self.count += 1
				
				Select (Self.state)
					Case STATE_INIT
						Self.count = 0
						
						Self.state = STATE_WAITING
						
						If (Self.effectID <> 0) Then
							PlayerObject.timeStopped = True
						EndIf
					Case STATE_SHAKING
						MapManager.setShake(20, MyRandom.nextInt(5, 10))
						
						If (Self.count = SHAKING_COUNT) Then
							Self.state = STATE_OVER
						EndIf
						
						If (Self.count Mod 4 = 0) Then
							SoundSystem.getInstance().playSe(SoundSystem.SE_144)
						EndIf
					Case STATE_OVER
						PlayerObject.timeStopped = False
						
						GameObject.player.setMeetingBoss(True)
						
						StageManager.saveCheckPointCamera(MapManager.proposeUpCameraLimit, MapManager.proposeDownCameraLimit, MapManager.proposeLeftCameraLimit, MapManager.proposeRightCameraLimit)
						
						MapManager.actualUpCameraLimit = MapManager.proposeUpCameraLimit
						
						Self.state = STATE_NONE
						
						If (PlayerObject.stageModeState = PlayerObject.STATE_NORMAL_MODE) Then ' GameObject
							PlayerObject.setTimeCount(ANICOUNT_TIME, 0, 0)
							PlayerObject.setOverCount(0, 0, 0)
						EndIf
					Case STATE_WAITING
						If (GameObject.player.isOnGound() And Self.count > 10) Then
							Select (Self.effectID)
								Case Effect.EFFECT_LAYER_TOP
									Self.state = STATE_SHAKING
								Case Effect.EFFECT_LAYER_PLAYER, Effect.EFFECT_LAYER_NUM
									MapManager.setCameraUpLimit((Self.markY - 2) * 8)
									
									Self.state = STATE_WAITING_CAMERA
							End Select
							
							Self.count = 0
						EndIf
					Case STATE_WAITING_CAMERA
						If (MapManager.proposeUpCameraLimit = MapManager.actualUpCameraLimit) Then
							Self.state = STATE_MAP_BROKE_4
							
							Self.brokeOffset = PARTS_INFO_VY ' 4
							Self.brokeVel = PARTS_INFO_Y ' 2
							
							createParts(2)
							
							MapManager.setMapBrokeParam(Self.markY, Self.brokeOffset)
							
							Self.count = 0
							
							If (Self.effectID = Effect.EFFECT_LAYER_NUM) Then ' 2
								BackGroundManager.next()
							EndIf
						EndIf
					Case STATE_MAP_BROKE_1
						If (Self.count Mod 4 = 0) Then
							SoundSystem.getInstance().playSe(SoundSystem.SE_144)
						EndIf
						
						Self.brokeOffset += Self.brokeVel
						
						If (Self.brokeOffset > (Self.brokeVel * 10)) Then
							Self.state = STATE_MAP_BROKE_2
						EndIf
						
						MapManager.setMapBrokeParam(Self.markY, Self.brokeOffset)
					Case STATE_MAP_BROKE_2
						If (Self.count Mod 4 = 0) Then
							SoundSystem.getInstance().playSe(SoundSystem.SE_144)
						EndIf
						
						Self.brokeVel += 1
						Self.brokeOffset += Self.brokeVel
						
						createParts(2)
						
						MapManager.setShakeX(MyRandom.nextInt(5, 10))
						MapManager.setShake(20, MyRandom.nextInt(5, 10))
						MapManager.setMapBrokeParam(Self.markY, Self.brokeOffset)
						
						If (Self.brokeOffset > SCREEN_HEIGHT) Then
							MapManager.releaseCameraUpLimit()
							MapManager.setCameraDownLimit(Self.markY * 8)
							
							PlayerObject.isDeadLineEffect = True
							
							Self.state = STATE_MAP_BROKE_3
						EndIf
					Case STATE_MAP_BROKE_3
						If (Self.count Mod 4 = 0) Then
							SoundSystem.getInstance().playSe(SoundSystem.SE_144)
						EndIf
						
						createParts(2)
						
						MapManager.setShakeX(MyRandom.nextInt(5, 10))
						MapManager.setShake(20, MyRandom.nextInt(5, 10))
						
						If (MapManager.proposeDownCameraLimit = MapManager.actualDownCameraLimit) Then
							Self.state = STATE_OVER
						EndIf
					Case STATE_MAP_BROKE_4
						If (Self.count = STATE_SHAKING) Then
							SoundSystem.getInstance().playSequenceSe(SoundSystem.SE_173)
						EndIf
						
						If (Self.count > STATE_MAP_BROKE_3) Then
							Self.state = STATE_MAP_BROKE_1
						EndIf
				End Select
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			partsDraw(g)
		End
		
		Method createParts:Void(partsNum:Int)
			For Local i:= 0 Until partsNum
				Local info:= New Int[5] ' [(PARTS_NUM - 1)]
				
				info[0] = MyRandom.nextInt(6) ' STATE_MAP_BROKE_1
				info[1] = MyRandom.nextInt(SCREEN_WIDTH)
				info[2] = MyRandom.nextInt(-20, -10)
				info[3] = MyRandom.nextInt(-5, 5)
				'info[4] = 0
				
				Self.partsInfoVec.Push(info)
			Next
		End
		
		Method partsDraw:Void(g:MFGraphics)
			Local i:= 0
			
			While (i < Self.partsInfoVec.Length())
				Local info:= Self.partsInfoVec.Get(i)
				
				If (Not GameObject.IsGamePause) Then
					info[4] += 2
					info[1] += info[3]
					info[2] += info[4]
					
					If (info[2] > (SCREEN_HEIGHT + 20)) Then
						Self.partsInfoVec.Remove(i)
						
						'i -= 1
						
						Continue
					EndIf
				EndIf
				
				Self.partsDrawer.draw(g, info[0], info[1], info[2], False, 0)
				
				i += 1
			Wend
		End
		
		Method close:Void()
			Self.state = STATE_NONE
		End
End