Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.soundsystem
	
	Import sonicgba.effect
	Import sonicgba.gimmickobject
	Import sonicgba.mapmanager
	Import sonicgba.mapobject
	Import sonicgba.playerobject
	Import sonicgba.sonicdebug
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class StoneBall Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1792
		Const COLLISION_HEIGHT:Int = 1792
		
		Const STARTUP_WIDTH:Int = 16384
		Const STARTUP_HEIGHT:Int = 9216
		
		' Global variable(s):
		Global animation:Animation
		
		' Fields:
		Field WAIT:Int ' Final
		
		Field drawer:AnimationDrawer
		Field mapObj:MapObject
		
		Field originalX:Int
		Field originalY:Int
		Field waitCount:Int
		
		Field noBall:Bool
	Public
		' Constant variable(s):
		Const OUT_VELOCITY:Int = 300
		
		Const STATE_NONE:Byte = 0
		Const STATE_OUT:Byte = 1
		Const STATE_GO:Byte = 2
		
		' Fields:
		Field state:Byte
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.WAIT = 20
			
			If (animation = Null) Then
				animation = New Animation("/animation/stone_ball")
			EndIf
			
			Self.drawer = animation.getDrawer(0, True, 0)
			
			Self.noBall = True
			
			Self.originalX = Self.posX
			Self.originalY = Self.posY
			
			Self.mapObj = New MapObject(Self.posX + PlayerObject.DETECT_HEIGHT, Self.posY, 0, 0, Self, Self.iLeft)
		End
	Private
		' Methods:
		Method inScreen:Bool()
			Local camera:= MapManager.getCamera()
			
			If ((Self.posX Shr 6) <= camera.x Or (Self.posX Shr 6) >= (camera.x + SCREEN_WIDTH) Or (Self.posY Shr 6) <= camera.y Or (Self.posY Shr 6) >= (camera.y + SCREEN_HEIGHT)) Then
				Return False
			EndIf
			
			Return True
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(animation)
			
			animation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Self.state <> STATE_NONE) Then
				drawInMap(g, Self.drawer)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method drawCollisionRect:Void(g:MFGraphics)
			Super.drawCollisionRect(g)
			
			If (SonicDebug.showCollisionRect) Then
				g.setColor(16711680)
				
				' Magic numbers: 512, 288, 510, 286
				g.drawRect(((Self.originalX - STARTUP_WIDTH) Shr 6) - camera.x, ((Self.originalY - STARTUP_HEIGHT) Shr 6) - camera.y, 512, 288)
				g.drawRect((((Self.originalX - STARTUP_WIDTH) Shr 6) - camera.x) + 1, (((Self.originalY - STARTUP_HEIGHT) Shr 6) - camera.y) + 1, 510, 286)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.state <> STATE_NONE) Then
				player.beHurt()
			EndIf
		End
		
		Method logic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.waitCount > 0) Then
				Self.waitCount -= 1
			EndIf
			
			Select (Self.state)
				Case STATE_NONE
					Self.posX = Self.originalX
					Self.posY = Self.originalY
					
					transportTo(Self.posX, Self.posY)
					
					If (Self.waitCount = 0 And player.getFootPositionX() > Self.originalX - STARTUP_WIDTH And player.getFootPositionX() < Self.originalX + STARTUP_WIDTH And player.getFootPositionY() > Self.originalY - STARTUP_HEIGHT And player.getFootPositionY() < Self.originalY + STARTUP_HEIGHT) Then
						Self.state = STATE_OUT
					EndIf
				Case STATE_OUT
					Self.posX += OUT_VELOCITY
					
					If (Self.posX > Self.originalX + PlayerObject.DETECT_HEIGHT) Then
						Self.state = STATE_GO
						
						Self.mapObj.setPosition(Self.posX, Self.posY, OUT_VELOCITY, 0, Self)
						Self.mapObj.setCrashCount(2)
					EndIf
					
					checkWithPlayer(preX, preY, Self.posX, Self.posY)
				Case STATE_GO
					Self.mapObj.logic()
					
					checkWithPlayer(Self.posX, Self.posY, Self.mapObj.getPosX(), Self.mapObj.getPosY())
					
					Self.posX = Self.mapObj.getPosX()
					Self.posY = Self.mapObj.getPosY()
					
					If (Self.mapObj.chkCrash()) Then
						Self.state = STATE_NONE
						
						' Magic number: 20
						Self.waitCount = 20
						
						Effect.showEffect(rockBreakAnimation, 0, (Self.posX Shr 6), (Self.posY Shr 6), 0)
						
						If (inScreen()) Then
							SoundSystem.getInstance().playSe(SoundSystem.SE_144)
						EndIf
					EndIf
			End Select
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End