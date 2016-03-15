Strict

Public

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
Public

' Classes:
Class PlatformObject Extends GimmickObject Abstract
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
		End
		
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Using 'Self' explicitly for code clarity:
			Select direction
				Case DIRECTION_DOWN
					' Stop the player from falling through.
					player.beStop(Self.collisionRect.y0, 1, Self)
					
					Return
				Case DIRECTION_NONE
					If (player.getMoveDistance().y > 0 And player.getCollisionRect().y1 < Self.collisionRect.y1) Then
						player.beStop(Self.collisionRect.y0, 1, Self)
					EndIf
				Default ' Case 2, 3
					' Nothing so far.
			End Select
		End
End