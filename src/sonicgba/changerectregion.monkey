Strict

Public

' Imports:
Import sonicgba.gimmickobject
Import sonicgba.playerobject

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
		Method doWhileCollision:Void(var1:PlayerObject, var2:Int)
			' Code structured for accuracy, not best practices:
			If (var1.animationID = 4 And var1.collisionState = 1) Then
				var1.changeRectHeight = True
				isChanged = True
			Else
				var1.changeRectHeight = False
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