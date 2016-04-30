Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gameobject
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.steamhurt
	Import sonicgba.steamplatform
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class SteamBase Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1280
		Const COLLISION_HEIGHT:Int = 768
		
		Const PLATFORM_OFFSET_Y:Int = -768
		
		' Global variable(s):
		Global animation:Animation
		
		Global count:Byte
		
		Global shotFlag:Bool
		
		' Fields:
		Field drawer:AnimationDrawer
	Public
		' Fields:
		Field sh:SteamHurt
		Field sp:SteamPlatform
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (animation = Null) Then
				animation = New Animation("/animation/steam")
			EndIf
			
			Self.drawer = animation.getDrawer(0, True, 0)
			
			Self.sh = New SteamHurt(Self.posX, Self.posY, Self)
			Self.sp = New SteamPlatform(Self.posX, Self.posY + PLATFORM_OFFSET_Y, Self)
			
			GameObject.addGameObject(Self.sh, Self.posX, Self.posY)
			GameObject.addGameObject(Self.sp, Self.posX, Self.posY)
		End
	Public
		' Functions:
		Function staticLogic:Void()
			If (count > 0) Then
				count -= 1
			EndIf
			
			If (count = 0) Then
				SteamPlatform.shot()
				
				count = 50
			EndIf
			
			SteamPlatform.staticLogic()
		End
		
		Function releaseAllResource:Void()
			Animation.closeAnimation(animation)
			
			animation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			Self.drawer.setActionId(Int(SteamPlatform.isShotting()))
			
			drawInMap(g, Self.drawer)
			
			Self.sp.drawPlatform(g)
			
			If (isInCamera() And count = 50) Then
				SoundSystem.getInstance().playSe(SoundSystem.SE_182)
				
				count = 49 ' -= 1
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			player.beStop(0, direction, Self)
		End
		
		Method close:Void()
			Self.drawer = Null
			
			Self.sp = Null
			Self.sh = Null
		End
End