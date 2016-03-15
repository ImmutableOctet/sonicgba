Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class TutorialPoint Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 2048
		
		' Global variable(s):
		Global tutorialAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(tutorialAnimation)
			
			tutorialAnimation = Null
		End
		
		' Methods:
		Method close:Void()
			Self.drawer = Null
		End
		
		Method draw:Void(graphics:MFGraphics)
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return 0
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			collisionRect.setRect(x - 1024, y - 1024, 2048, 2048)
		End
End