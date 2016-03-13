Strict

Public

' Imports:
Import lib.animation
Import lib.animationdrawer

Import com.sega.mobile.framework.device.mfgraphics

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
		Method New(var1:Int, var2:Int, var3:Int, var4:Int, var5:Int, var6:Int, var7:Int)
			Super.New(var1, var2, var3, var4, var5, var6, var7)
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