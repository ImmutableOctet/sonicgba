Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.freefallplatform
Friend sonicgba.freefallbar

' Imports:
Private
	Import gameengine.key
	
	Import lib.coordinate
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.freefallbar
	Import sonicgba.freefallplatform
	
	Import com.sega.mobile.framework.device.mfgamepad
Public

' Classes:
Class FreeFallSystem Extends GimmickObject
	Private ' Protected
		' Constant variable(s):
		Const MOVE_DISTANCE:Int = 30720
		Const MOVE_VELOCITY:Int = 320
		
		Const SHOOT_TIME:Int = 80
		
		' Fields:
		Field bar:FreeFallBar
		Field platform:FreeFallPlatform
		
		Field barOriginalPosX:Int
		Field barOriginalPosY:Int
		Field frame:Int
		
		Field isActive:Bool
		
		Field plaOriginalPosX:Int
		Field plaOriginalPosY:Int
		
		Field posYOriginal:Int
		Field position:Coordinate
		Field shootCnt:Int
	Public
		' Fields:
		Field initFlag:Bool
		Field moving:Bool
		Field releaseAble:Bool
		Field shootDirection:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.posYOriginal = 0
			Self.posYOriginal = Self.posY
			
			Self.position = New Coordinate()
			
			Self.position.x = Self.posX
			Self.position.y = Self.posY
			
			Self.moving = False
			Self.releaseAble = False
			
			Self.bar = New FreeFallBar(Self, Self.posX, Self.posY)
			Self.platform = New FreeFallPlatform(Self, Self.posX, Self.posY)
			
			GameObject.addGameObject(Self.bar, Self.posX, Self.posY)
			GameObject.addGameObject(Self.platform, Self.posX, Self.posY)
			
			Self.plaOriginalPosX = Self.posX
			Self.plaOriginalPosY = Self.posY
			
			Self.barOriginalPosX = Self.posX
			Self.barOriginalPosY = Self.posY
			
			Self.initFlag = False
			Self.isActive = False
			Self.shootDirection = False
			
			Self.frame = 0
			Self.shootCnt = 0
		End
		
		' Methods:
		
		' Extensions:
		Method logic_makePlayerRun:Void(player:PlayerObject, velX:Int, faceDirection:Bool)
			player.changeVisible(True)
			
			player.outOfControl = False
			
			player.setVelX(velX)
			
			player.faceDirection = faceDirection
			
			Self.moving = False
			Self.releaseAble = False
			
			Self.frame = 0
			
			player.setAnimationId(PlayerObject.ANI_RUN_3)
			player.restartAniDrawer()
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			' Empty implementation.
		End
		
		' Methods:
		Method getBarPosition:Coordinate()
			Return Self.position
		End
		
		Method getPlatformPosition:Coordinate()
			Return Self.position
		End
		
		Method logic:Void()
			If (Self.initFlag) Then
				refreshCollisionRect(Self.posX, Self.posY)
				
				If (Not screenRect.collisionChk(Self.bar.collisionRect) And Not screenRect.collisionChk(Self.platform.collisionRect)) Then
					Self.initFlag = False
				EndIf
				
				Return
			EndIf
			
			If (Self.moving) Then
				If (Not IsGamePause) Then
					Self.isActive = True
				EndIf
				
				Self.posY += MOVE_VELOCITY
				
				If (Self.posY >= (Self.posYOriginal + MOVE_DISTANCE)) Then
					Self.posY = (Self.posYOriginal + MOVE_DISTANCE)
					
					Self.releaseAble = True
				EndIf
				
				Self.position.y = Self.posY
				
				refreshCollisionRect(Self.posX, Self.posY)
			EndIf
			
			Self.bar.barLogic()
			Self.platform.platformLogic()
			
			If (Self.releaseAble) Then
				Self.shootCnt += 1
				
				If (Self.shootCnt < SHOOT_TIME) Then
					If (Key.press(Key.gLeft)) Then
						' Magic number: -2000
						logic_makePlayerRun(player, -2000, False)
					ElseIf (Key.press(Key.gRight)) Then
						' Magic number: 2000
						logic_makePlayerRun(player, 2000, True)
					EndIf
				ElseIf (Self.shootDirection) Then
					' Magic number: -2000
					logic_makePlayerRun(player, -2000, False)
				Else
					' Magic number: 2000
					logic_makePlayerRun(player, 2000, True)
				EndIf
			EndIf
			
			If (Self.moving And Not IsGamePause) Then
				Self.frame += 1
				
				If (Self.frame <= 32) Then
					If ((Self.frame Mod 7) = 0) Then ' 8
						SoundSystem.getInstance().playSe(SoundSystem.SE_209)
					EndIf
				ElseIf (Self.frame <= 64) Then
					If ((Self.frame Mod 4) = 0) Then
						SoundSystem.getInstance().playSe(SoundSystem.SE_210)
					EndIf
				ElseIf ((Self.frame Mod 2) = 0) Then
					SoundSystem.getInstance().playSe(SoundSystem.SE_211)
				EndIf
			EndIf
			
			If (Self.posY = (Self.posYOriginal + MOVE_DISTANCE)) Then
				' Magic numbers: 16384, 9216
				If (player.posX - Self.posX > 16384 Or Self.posX - player.posX > 16384 Or player.posY - Self.posY > 9216 Or Self.posY - player.posY > 9216) Then
					doInitInCamera()
				EndIf
			EndIf
		End
		
		Method isSystemReady:Bool()
			Return (Self.posY = Self.posYOriginal)
		End
		
		Method doWhileNoCollision:Void()
			If (Self.isActive) Then
				Self.shootCnt = 0
				
				Self.isActive = False
			EndIf
		End
		
		Method close:Void()
			Self.bar = Null
			Self.platform = Null
			Self.position = Null
		End
		
		Method doInitInCamera:Void()
			Self.posX = Self.plaOriginalPosX
			Self.posY = Self.plaOriginalPosY
			
			Self.position.x = Self.posX
			Self.position.y = Self.posY
			
			Self.initFlag = False
			
			Self.bar.init()
			Self.platform.init()
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Empty implementation.
		End
End