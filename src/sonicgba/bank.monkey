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
		Method New(var1:Int, var2:Int, var3:Int, var4:Int, var5:Int, var6:Int, var7:Int)
			Super.New(var1, var2, var3, var4, var5, var6, var7)
		End
	Public
		' Methods:
		
		' This object's type seems to determine if 'var1' will be affected.
		Method doWhileCollision:Void(var1:PlayerObject, var2:Int)
			If (var1.onBank) Then
				var1.onBank = False
				var1.bankwalking = False
			ElseIf ((Self.objId = 28 And var2 = 3 Or Self.objId = 29 And var2 = 2) And var1.collisionState = 0) Then
				Self.touching = True
				var1.bankwalking = True ' player
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