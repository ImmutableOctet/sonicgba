Strict

Public

#Rem
	This is most likely the snow bank object.
	Well, either that, or it's a (Potentially shared) bank object.
	
	It seems to be used by multiple object types later on,
	so I'm going to assume shared behavior at least.
	
	Either way, it slows the character down, that's what matters right now.
#End

' Imports:
Import sonicgba.gimmickobject
Import sonicgba.playerobject

' Classes:
Class Bank Extends GimmickObject
	Private
		' Fields:
		Field touching:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		
		' This object's type seems to determine if 'var1' will be affected.
		Method doWhileCollision:Void(player:PlayerObject, value:Int)
			If (player.onBank) Then
				player.onBank = False
				player.bankwalking = False
			ElseIf ((Self.objId = 28 And value = 3 Or Self.objId = 29 And value = 2) And player.collisionState = 0) Then
				Self.touching = True
				player.bankwalking = True
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.touching) Then
				' Check if we should restrict the player's speed. (Initiate "bank-walking")
				If (Self.objId = 28 And player.getVelX() > 500 Or Self.objId = 29 And player.getVelX() < -500) Then
					player.setBank()
				EndIf
				
				Self.touching = False
			EndIf
		End
End