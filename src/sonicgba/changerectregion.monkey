Strict

Public

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
Public

' Classes:
Class ChangeRectRegion Extends GimmickObject
	Private
		' Fields:
		Field isChanged:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Code structured for accuracy, not best practices:
			If (player.animationID = 4 And player.collisionState = 1) Then
				player.changeRectHeight = True
				isChanged = True
			Else
				player.changeRectHeight = False
				isChanged = False
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (isChanged And player.changeRectHeight) Then
				player.changeRectHeight = False
				isChanged = False
			EndIf
		End
End