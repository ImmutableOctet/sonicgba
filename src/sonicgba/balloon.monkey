Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Balloon Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_HEIGHT:Int = 1600
		Const COLLISION_WIDTH:Int = 1408
		
		Const POP_POWER:Int = 1600 ' COLLISION_HEIGHT
		
		' Global variable(s):
		Global balloonAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (balloonAnimation = Null) Then
				balloonAnimation = New Animation("/animation/balloon")
			EndIf
			
			Self.drawer = balloonAnimation.getDrawer((Abs(Self.iLeft) Mod 3) * 2, True, 0)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(balloonAnimation)
			
			balloonAnimation = Null
		End
		
		' Methods:
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.used) Then
				player.bePop(POP_POWER, 1)
				
				Self.used = True
				
				Self.drawer.setActionId(((Abs(Self.iLeft) Mod 3) * 2) + 1)
				Self.drawer.setLoop(False)
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_189)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method doInitWhileInCamera:Void()
			Self.used = False
			
			Self.drawer.setActionId((Abs(Self.iLeft) Mod 3) * 2)
			Self.drawer.setLoop(True)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End