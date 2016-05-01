Strict

Public

' Friends:
Friend sonicgba.bulletobject

' Imports:
Private
	Import gameengine.def
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.bulletobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class MissileBullet Extends BulletObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1920
		Const COLLISION_HEIGHT:Int = 768
		
		Const SIDE_RIGHT:Int = 607744
		
		Global SIDE_LEFT:Int = (SIDE_RIGHT - (SCREEN_WIDTH Shl 6)) ' Const
		
		' Fields:
		Field boomdrawer:AnimationDrawer
		
		Field flyCounter:Int
		
		Field frame:Int
		
		Field mvel:Int
		
		Field velA:Int
		Field velA2:Int
		
		Field isboomed:Bool
		Field isbooming:Bool
	Public
		' Fields:
		Field isBoom:Bool
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int)
			Super.New(x, y, velX, velY, True)
			
			Self.velA = 64
			Self.velA2 = 256
			
			Self.flyCounter = 0
			Self.isBoom = False
			
			If (missileAnimation = Null) Then
				missileAnimation = New Animation("/animation/missile")
			EndIf
			
			If (velX > 0) Then
				Self.velA = Abs(Self.velA)
				Self.velA2 = Abs(Self.velA2)
				
				Self.drawer = missileAnimation.getDrawer(0, True, TRANS_MIRROR)
			ElseIf (velX < 0) Then
				Self.velA = -Abs(Self.velA)
				Self.velA2 = -Abs(Self.velA2)
				
				Self.drawer = missileAnimation.getDrawer(0, True, TRANS_NONE)
			EndIf
			
			Self.mvel = velX
			
			If (boomAnimation = Null) Then
				boomAnimation = New Animation("/animation/boom")
			EndIf
			
			Self.boomdrawer = boomAnimation.getDrawer(0, True, TRANS_NONE)
			
			Self.isboomed = False
			
			SoundSystem.getInstance().playSequenceSe(SoundSystem.SE_200_01)
		End
	Private
		' Methods:
		Method missleNoiseControl:Void()
			If ((IsHit() Or Not isInCamera()) And SoundSystem.getInstance().getPlayingLoopSeIndex() = SoundSystem.SE_200_01) Then
				SoundSystem.getInstance().stopLoopSe()
			EndIf
			
			If (IsHit() And Not Self.isboomed) Then
				Self.isboomed = True
			EndIf
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			missleNoiseControl()
			
			If (IsHit()) Then
				Self.boomdrawer.setActionId(0)
				Self.boomdrawer.setLoop(False)
				
				Self.isbooming = True
			Else
				Self.flyCounter += 1
				
				If (Self.flyCounter < 8) Then
					Self.velX += Self.velA
				Else
					Self.velX += Self.velA2
				EndIf
				
				Self.posX += Self.velX
				
				Self.velY = -((Self.posY - player.getCheckPositionY()) Shr 3) ' / 8
				
				Self.posY += Self.velY
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method screenOutChek:Bool()
			If (Self.mvel > 0) Then
				If (Self.posX > SIDE_RIGHT) Then
					Return True
				EndIf
				
				Return False
			ElseIf (Self.posX < SIDE_LEFT) Then
				Return True
			Else
				Return False
			EndIf
		End
		
		Method chkDestroy:Bool()
			Return (Super.chkDestroy() Or Self.boomdrawer.checkEnd() Or screenOutChek() Or Not isInCamera())
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.isbooming) Then
				drawInMap(g, Self.drawer)
			EndIf
			
			If (Self.isbooming And Not Self.boomdrawer.checkEnd()) Then
				drawInMap(g, Self.boomdrawer)
			EndIf
			
			Self.collisionRect.draw(g, camera)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.posX < player.getFootPositionX()) Then
				Self.collisionRect.setRect(x - COLLISION_WIDTH, y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
			Else
				Self.collisionRect.setRect(x, y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
		
		Method close:Void()
			Super.close()
			
			Self.boomdrawer = Null
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Super.doWhileCollision(player, direction)
			
			If (Not Self.isBoom) Then
				SoundSystem.getInstance().playSe(SoundSystem.SE_144)
				
				Self.isBoom = True
			EndIf
		End
End