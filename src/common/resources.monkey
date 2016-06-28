Strict

Public

' Imports:
Private
	Import common.numberdrawer
	
	Import lib.animation
Public

' Functions:
Function InitCommonResources:Void()
	NumberDrawer.numberDrawer = New Animation("/animation/number").getDrawer()
End

Function DeinitCommonResources:Void()
	Animation.closeAnimationDrawer(NumberDrawer.numberDrawer)
	
	NumberDrawer.numberDrawer = Null
End