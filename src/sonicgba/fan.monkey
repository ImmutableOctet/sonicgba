Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.basicgimmick
Public

' Classes:
Class Fan Extends BasicGimmickObject
	Private
		' Global variable(s):
		
		' Shared animation for this gimmick. (Atlas descriptor)
		Global animation:Animation
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Check if we have a shared animation resource loaded:
			If (animation = Null) Then
				' Load the animation for this gimmick.
				' This will later be destroyed when 'releaseAllResource' is called.
				animation = New Animation("/animation/bigfan")
			EndIf
			
			If (animation <> Null) Then
				Self.drawer = animation.getDrawer(0, True, 0)
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
End