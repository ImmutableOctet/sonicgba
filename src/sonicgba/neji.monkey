Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Neji Extends GimmickObject
	Private
		' Constant variable(s):
		Const PLAYER_OFFSET:Int = 0
		
		Const STAD_GMK_NEJI_ADD_SPEED:Int = 48
		Const STAD_GMK_NEJI_MAX_SPEED:Int = 2304
		Const STAD_GMK_NEJI_MIN_SPEED:Int = 232
		
		Const VELOCITY:Int = 300
		Const VELOCITY_CHANGE:Int = 200
		
		' Fields:
		Field velocity:Int
		
		Field frameCnt:Int
		
		Field touching:Bool
	Public
		' Global variable(s):
		Global nejiAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.touching = False
			
			Self.frameCnt = 0
			Self.frameCnt = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(nejiAnimation)
			
			nejiAnimation = Null
		End
		
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic number: 512
			Self.collisionRect.setRect(Self.posX + (Self.iLeft * 512), Self.posY, Self.mWidth, 512)
		End
		
		Method draw:Void(g:MFGraphics)
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.firstTouch) Then
				isGotRings = False
				
				player.degreeForDraw = 0
			EndIf
			
			If (Self.firstTouch And Not Self.touching And Not player.hurtNoControl) Then
				player.setOutOfControl(Self)
				player.setAnimationId(PlayerObject.ANI_ROPE_ROLL_1)
				player.setFootPositionY(Self.posY + PLAYER_OFFSET)
				
				Self.touching = True
				Self.velocity = 0
			EndIf
		End
		
		Method logic:Void()
			If (Self.touching) Then
				Self.frameCnt += 1
				
				If (Self.velocity < STAD_GMK_NEJI_MIN_SPEED) Then
					Self.velocity += STAD_GMK_NEJI_ADD_SPEED
				EndIf
				
				If (Self.velocity > STAD_GMK_NEJI_MAX_SPEED) Then
					Self.velocity = STAD_GMK_NEJI_MAX_SPEED
				EndIf
				
				If (Key.repeated(Key.gLeft)) Then
					If (Self.velocity > STAD_GMK_NEJI_MIN_SPEED) Then
						Self.velocity -= STAD_GMK_NEJI_ADD_SPEED
					EndIf
				ElseIf (Key.repeated(Key.gRight)) Then
					Self.velocity += STAD_GMK_NEJI_ADD_SPEED
				EndIf
				
				Local positionDes:= (player.getFootPositionX() + Self.velocity)
				
				If (positionDes > Self.collisionRect.x1) Then
					positionDes = Self.collisionRect.x1
				EndIf
				
				player.checkWithObject(player.getFootPositionX(), player.getFootPositionY(), positionDes, player.getFootPositionY())
				
				player.setFootPositionX(positionDes)
				player.setFootPositionY(Self.posY + PLAYER_OFFSET)
				
				Local leaving:Bool = False
				Local isUp:Bool = False
				
				If (Key.press(Key.B_HIGH_JUMP)) Then
					leaving = True
				EndIf
				
				If (Not Key.repeated(Key.gUp | Key.B_LOOK) And Not Key.repeated(Key.gDown)) Then
					Local frame:= player.drawer.getCurrentFrame()
					
					If (player.getAnimationId() <> PlayerObject.ANI_ROPE_ROLL_1) Then
						player.getAnimationId()
					ElseIf (frame < 4) Then
						isUp = True
					EndIf
				ElseIf (Key.repeated(Key.gUp | Key.B_LOOK)) Then
					isUp = True
				ElseIf (Key.repeated(Key.gDown)) Then
					isUp = False
				EndIf
				
				If (leaving) Then
					player.outOfControl = False
					
					player.setVelX(0)
					
					player.collisionState = PlayerObject.COLLISION_STATE_JUMP
					
					' Magic number: 1800
					player.setVelY(DSgn(isUp) * 1800)
					
					player.setFootPositionY(Self.posY + PlayerObject.BODY_OFFSET) ' 768
					
					player.setAnimationId(PlayerObject.ANI_JUMP)
					
					If (Not (player.getCharacterID() = CHARACTER_AMY) And Self.firstTouch) Then
						soundInstance.playSe(SoundSystem.SE_109)
					EndIf
					
					Self.touching = False
				EndIf
				
				Self.firstTouch = False
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End