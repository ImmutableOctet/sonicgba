Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.gimmickobject
Public

' Classes:
Class RailFlipper Extends GimmickObject
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 512
		Const COLLISION_HEIGHT:Int = 512
		Const COLLISION_OFFSET:Int = 512
	Private
		' Global variable(s):
		Global railFlipperAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (railFlipperAnimation = Null) Then
				railFlipperAnimation = New Animation("/animation/rail_flipper")
			End
			
			Self.drawer = railFlipperAnimation.getDrawer(0, False, 0)
		End
	Public
		' Methods:
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
			
			If (Self.drawer.getActionId() = 1 And Self.drawer.checkEnd()) Then
				Self.drawer.setActionId(0)
			End
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(Self.posX, Self.posY - COLLISION_OFFSET, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			If (Self.firstTouch) Then
				player.setRailFlip()
				
				Self.drawer.setActionId(1)
			End
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(railFlipperAnimation)
			
			railFlipperAnimation = Null
		End
End