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
		Method New(var1:Int, var2:Int, var3:Int, var4:Int, var5:Int, var6:Int, var7:Int)
			Super.New(var1, var2, var3, var4, var5, var6, var7)
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