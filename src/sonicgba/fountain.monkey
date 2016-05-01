Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playerknuckles
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Fountain Extends GimmickObject
	Private
		' Constant variable(s):
		Const CRASH_WAIT_FRAME:Int = 8
		
		Const DRAWER_NUM:Int = 5
		
		Const DRAW_OFFSET_X:Int = 448
		Const DRAW_OFFSET_Y:Int = -384
		
		Const LINE_WIDTH:Int = 188
		Const LINE_HEIGHT:Int = 80
		
		Const PLAYER_CROSS_START_X:Int = 147200
		Const PLAYER_CROSS_END_X:Int = 152704
		
		Const PLAYER_ON_WATER_MAX_SPEED:Int = 1920
		
		Global POSITION_OFFSET:Int[][] = [[0, 0], [1024, -1024], [7168, -3072], [12288, -6144], [18432, -5120]] ' Const
		
		' Global variable(s):
		Global drawer:AnimationDrawer[]
		
		' Fields:
		Field crashCnt:Int
		
		Field isActived:Bool
		Field nonecrashable:Bool
		Field touching:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.touching = False
			Self.touching = False
			Self.isActived = False
			Self.nonecrashable = False
			
			Self.crashCnt = 0
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic number: 13312, 512, 24064
			Self.collisionRect.setRect(x - 13312, (Self.iTop * 512) + y, 24064, Self.mHeight) ' PlayerObject.ICE_SLIP_FLUSH_OFFSET_Y
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.touching Or (Not (player.collisionState = PlayerObject.COLLISION_STATE_WALK Or player.collisionState = PlayerObject.COLLISION_STATE_ON_OBJECT) Or player.getFootPositionX() <= PLAYER_CROSS_START_X Or player.getFootPositionX() >= PLAYER_CROSS_END_X)) Then
				If (Not Self.touching And Self.collisionRect.collisionChk(player.getFootPositionX(), player.getFootPositionY())) Then
					Local objY:= player.getFootPositionY()
					Local lineY:= getLineY(player.getFootPositionX())
					
					If (player.collisionState = PlayerObject.COLLISION_STATE_ON_OBJECT) Then
						Self.nonecrashable = True
					ElseIf (objY >= lineY And Not Self.nonecrashable) Then
						Self.touching = True
						
						player.setOutOfControl(Self)
						player.setBodyPositionY(lineY)
						player.setAnimationId(PlayerObject.ANI_YELL)
						player.setCollisionState(PlayerObject.COLLISION_STATE_JUMP)
						player.setNoKey()
						
						player.showWaterFlush = True
						
						Self.crashCnt = 0
					EndIf
				EndIf
				
				If (player.showWaterFlush) Then
					Self.crashCnt = 0
					
					If (Self.crashCnt > CRASH_WAIT_FRAME) Then
						player.showWaterFlush = False
					EndIf
					
					If (Not Self.isActived) Then
						soundInstance.playSe(SoundSystem.SE_177)
						
						Self.isActived = True
					EndIf
				EndIf
			Else
				Self.nonecrashable = True
				
				' Magic number: 3840
				player.setFootPositionX(player.getFootPositionX() - 3840) ' (PlayerObject.SONIC_DRAW_HEIGHT * 2)
				player.setAnimationId(PlayerObject.ANI_STAND)
				
				player.collisionState = PlayerObject.COLLISION_STATE_JUMP
				
				player.setVelX(0)
				
				player.faceDirection = False
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.touching) Then
				Self.touching = False
				
				player.outOfControl = False
				player.outOfControlObject = Null
				
				soundInstance.stopLoopSe()
				
				If (player.collisionState = PlayerObject.COLLISION_STATE_JUMP) Then
					player.doWhileLand(0)
				EndIf
				
				Self.isActived = False
				Self.crashCnt = 0
			EndIf
			
			Self.nonecrashable = False
		End
		
		Method logic:Void()
			If (Self.touching And player.outOfControl) Then
				If (player.getVelX() < 0) Then
					' Magic number: 300
					player.setVelX(player.getVelX() + 300)
				Else
					' Magic number: 100
					player.setVelX(player.getVelX() + 100)
				EndIf
				
				If (player.getVelX() > PLAYER_ON_WATER_MAX_SPEED) Then
					player.setVelX(PLAYER_ON_WATER_MAX_SPEED)
				EndIf
				
				player.setVelY(0)
				player.setFaceDegree(0)
				
				Local preX:= player.getFootPositionX()
				Local preY:= player.getFootPositionY()
				
				player.setAnimationId(PlayerObject.ANI_YELL)
				
				player.setNoKey()
				
				player.showWaterFlush = True
				player.justLeaveLand = False
				
				player.moveOnObject(player.getVelX() + preX, getLineY(player.getVelX() + preX) + PlayerObject.BODY_OFFSET, True) ' 768
				
				If (player.collisionState = PlayerObject.COLLISION_STATE_WALK) Then
					Self.touching = False
					
					player.outOfControl = False
					player.outOfControlObject = Null
					
					If ((PlayerObject.getCharacterID() = CHARACTER_KNUCKLES) And player.getCharacterAnimationID() = PlayerKnuckles.KNUCKLES_ANI_FLY_4) Then
						player.setAnimationId(1)
					EndIf
				EndIf
			EndIf
			
			If (player.getFootPositionX() >= ((((Self.posX Shr 6) + LINE_WIDTH) - 10) Shl 6)) Then
				Self.nonecrashable = False
				Self.isActived = False
			EndIf
		End
		
		Method getLineY:Int(playerX:Int)
			Local objX:= (playerX - Self.posX)
			
			Return ((((((objX Shr 6) * (objX Shr 6)) * LINE_HEIGHT) / 35344) Shl 6) + Self.collisionRect.y0)
		End
		
		Method draw:Void(g:MFGraphics)
			drawCollisionRect(g)
		End
		
		Method close:Void()
			drawer = []
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End