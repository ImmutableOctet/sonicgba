Strict

Public

' Imports:
Import sonicgba.gimmickobject
Import sonicgba.playerobject

' Classes:
Class PlatformObject Extends GimmickObject Abstract
	Protected
		' Constructor(s):
		Method New(var1:Int, var2:Int)
			Super.New(0, var1, var2, 0, 0, 0, 0)
		End
		
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method doWhileCollision:Void(var1:PlayerObject, var2:Int)
			' Using 'Self' explicitly for code clarity:
			Select var2
				Case 1
					var1.beStop(Self.collisionRect.y0, 1, Self)
					
					Return
				Case 4
					If (var1.getMoveDistance().y > 0 And var1.getCollisionRect().y1 < Self.collisionRect.y1) Then
						var1.beStop(Self.collisionRect.y0, 1, Self)
					EndIf
				Default ' Case 2, 3
					' Nothing so far.
			End Select
		End
End