Strict

Public

#Rem
	This module starts an annoying trend with the codebase:
	
	Gimmicks largely handle the same code, but
	can't take advantage of inheritance easily.
#End

' Imports:

' Traditional gimmick imports:
Import lib.animation
Import lib.animationdrawer

Import sonicgba.gimmickobject

Import com.sega.mobile.framework.device.mfgraphics

' Classes:
Class FallFlush Extends GimmickObject
	Private
		' Global variable(s):
		
		' Shared animation for this gimmick. (Atlas descriptor)
		Global animation:Animation
		
		' Fields:
		
		' This is used to display the graphic for this gimmick.
		Field drawer:AnimationDrawer
	Protected
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Check if we have a shared animation resource loaded:
			If (animation = Null) Then
				' Load the animation for this gimmick.
				' This will later be destroyed when 'releaseAllResource' is called.
				animation = New Animation("/animation/fall_flush")
			EndIf
			
			If (animation <> Null) Then
				Self.drawer = animation.getDrawer(0, true, 0)
			EndIf
		End
	Public
		' Functions:
		
		' This is used to clean up after 'animation'.
		Function releaseAllResource:Void()
			Animation.closeAnimation(animation)	
			
			animation = Null
			
			Return
		End
		
		' Methods:
		Method close:Void()
			Self.drawer = Null
			
			Return
		End
		
		' The 'var1' argument is likely a "context" object. (Abstracted from other details, anyway)
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, drawer)
			drawCollisionRect(graphics)
		End
End