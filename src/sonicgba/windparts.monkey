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
Class WindParts Extends GimmickObject
	Private
		' Constant variable(s):
		Const MOVE_FRAME:Int = 8
		Const VELOCITY:Int = 500
		
		' Global variable(s):
		Global animation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
		
		Field moveCount:Int
		Field posOriginalY:Int
	Protected
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (animation = Null) Then
				animation = New Animation("/animation/wind_parts")
			Endif
			
			Self.drawer = animation.getDrawer(2 - Self.iLeft, True, 0)
			Self.posOriginalY = Self.posY
			Self.moveCount = 0
		End
	Public
		Method logic:Void()
			Self.moveCount += 1
			
			If (Self.moveCount >= MOVE_FRAME) Then
				Self.moveCount = 0
				Self.posY = Self.posOriginalY
			Else
				Self.posY -= VELOCITY
			Endif
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x, y, 1, 1)
		End
	
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, Self.drawer)
		End
	
		Method close:Void()
			Self.drawer = Null
		End
		
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(animation)
			
			animation = Null
		End
End