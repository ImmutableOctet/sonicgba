Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
Public

' Classes:
Class TransPoint Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_HEIGHT:= 1024
		Const COLLISION_WIDTH:= 1024
		
		' Fields:
		Field desX:Int
		Field desY:Int
		
		Field drawer:AnimationDrawer
	Public
		' Global variable(s):
		Global caveAnimation:Animation
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.desX = ((Self.iLeft * 32) * (COLLISION_WIDTH/2) + (width Shl 6))
			Self.desX = ((Self.iTop * 32) * (COLLISION_HEIGHT/2) + (height Shl 6))
		End
	Public
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method draw:Void(graphics:MFGraphics)
			' Empty implementation.
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			player.beTrans(Self.desX, Self.desY)
			player.pipeOut()
			
			' Magic number; likely the sound effect number.
			SoundSystem.getInstance().playSe(SoundSystem.SE_148)
			
			player.setVelX(0)
			player.setVelY(0)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End