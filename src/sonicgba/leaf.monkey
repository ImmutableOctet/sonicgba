Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.gimmickobject
Public

' Classes:
Class Leaf Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 4608
		
		' Global variable(s):
		Global leafAnimation:Animation
		
		' Fields:
		Field isStart:Bool
		Field leafdrawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (leafAnimation = Null) Then
				leafAnimation = New Animation("/animation/bush")
			EndIf
			
			Self.leafdrawer = leafAnimation.getDrawer(0, False, 0)
			Self.isStart = False
		End
	Public
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY()) And Not Self.isStart) Then
				Self.isStart = True
				
				' Magic number: Likely the sound-effect ID.
				SoundSystem.getInstance().playSe(49)
			EndIf
		End
	
		Method doWhileNoCollision:Void()
			Self.isStart = False
			Self.leafdrawer.restart()
		End
	
		Method draw:Void(graphics:MFGraphics)
			If (Self.isStart) Then
				drawInMap(graphics, Self.leafdrawer, Self.posX, Self.posY + COLLISION_WIDTH) ' (COLLISION_HEIGHT/4)
			EndIf
			
			drawCollisionRect(graphics)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End