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
	Import sonicgba.seabedvolcanoasynhurt
	Import sonicgba.seabedvolcanoasynplatform
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class SeabedVolcanoAsynBase Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 4096
		Const COLLISION_HEIGHT:Int = 768
		
		Const FIRE_OFFSET_Y:Int = 192
		
		Global count:Byte
		
		' Fields:
		Field drawer:AnimationDrawer
	Public
		' Fields:
		Field sh:SeabedVolcanoAsynHurt
		Field sp:SeabedVolcanoAsynPlatform
	Protected
		' Methods:
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (firemtAnimation = Null) Then
				firemtAnimation = New Animation("/animation/firemt")
			EndIf
			
			If (firemtAnimation <> Null) Then
				Self.drawer = firemtAnimation.getDrawer(0, False, 0)
			EndIf
			
			Self.sh = New SeabedVolcanoAsynHurt(Self.posX, Self.posY, Self)
			Self.sp = New SeabedVolcanoAsynPlatform(Self.posX, Self.posY, Self)
			
			GameObject.addGameObject(Self.sh, Self.posX, Self.posY)
			GameObject.addGameObject(Self.sp, Self.posX, Self.posY)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(firemtAnimation)
			firemtAnimation = Null
		End
		
		Function staticLogic:Void()
			count += 1
			count Mod= 50
			
			If (count = 25) Then
				SeabedVolcanoAsynPlatform.shot()
			EndIf
			
			SeabedVolcanoAsynPlatform.staticLogic()
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (count = 22) Then
				Self.drawer.setActionId(1)
				Self.drawer.restart()
				
				soundInstance.playSe(SoundSystem.SE_182)
				count = 23 ' += 1
			EndIf
			
			drawInMap(g, Self.drawer, Self.posX, Self.posY + FIRE_OFFSET_Y)
			
			Self.sp.drawPlatform(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT) ' PlayerObject.DETECT_HEIGHT
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Nothing so far.
		End
		
		Method close:Void()
			Self.drawer = Null
			
			Self.sp = Null
			Self.sh = Null
		End
End