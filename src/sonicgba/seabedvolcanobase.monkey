Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.gameobject
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.seabedvolcanohurt
	Import sonicgba.seabedvolcanoplatform
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class SeabedVolcanoBase Extends GimmickObject
	Private
		' Constant variable(s)
		Const COLLISION_HEIGHT:Int = 768
		Const COLLISION_WIDTH:Int = 4096
		Const FIRE_OFFSET_Y:Int = 192
		
		' Global variable(s):
		Global count:Byte = 0
		
		' Fields:
		Field drawer:AnimationDrawer
	Public
		' Fields:
		Field sh:SeabedVolcanoHurt
		Field sp:SeabedVolcanoPlatform
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (firemtAnimation = Null) Then
				firemtAnimation = New Animation("/animation/firemt")
			EndIf
			
			If (firemtAnimation <> Null) Then
				Self.drawer = firemtAnimation.getDrawer(0, False, 0)
			EndIf
			
			Self.sh = New SeabedVolcanoHurt(Self.posX, Self.posY, Self)
			Self.sp = New SeabedVolcanoPlatform(Self.posX, Self.posY, Self)
			
			GameObject.addGameObject(Self.sh, Self.posX, Self.posY)
			GameObject.addGameObject(Self.sp, Self.posX, Self.posY)
		End
	Public
		' Functions:
		Function staticLogic:Void()
			count += 1
			count Mod= 50
			
			If (count = 3) Then
				SeabedVolcanoPlatform.shot()
			EndIf
			
			SeabedVolcanoPlatform.staticLogic()
		End
		
		Function releaseAllResource:Void()
			Animation.closeAnimation(firemtAnimation)
			
			firemtAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (count = 0) Then
				Self.drawer.setActionId(1)
				Self.drawer.restart()
				
				soundInstance.playSe(SoundSystem.SE_182)
				
				count = 1
			EndIf
			
			drawInMap(g, Self.drawer, Self.posX, Self.posY + FIRE_OFFSET_Y)
			
			Self.sp.drawPlatform(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - PlayerObject.DETECT_HEIGHT, y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method close:Void()
			Self.drawer = Null
			
			Self.sp = Null
			Self.sh = Null
		End
End