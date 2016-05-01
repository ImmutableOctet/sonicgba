Strict

Public

' Imports:
Private
	Import special.specialobject
	Import special.ssring
	
	Import lib.myapi
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class SSFollowRing Extends SSRing
	Private
		' Constant variable(s):
		Const FOLLOW_RING_MOVEMENT_Z:Int = 4
		
		' Fields:
		Field decided:Bool
		Field follow:Bool
		
		Field sleepCount:Int
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int, follow:Bool)
			Super.New(x, y, z)
			
			Self.follow = False
			Self.sleepCount = 10
			Self.decided = False
		End
		
		' Methods:
		Method setFollowOrNot:Void(flag:Bool)
			Self.decided = True
			
			Self.follow = flag
		End
		
		Method logic:Void()
			If (Self.sleepCount > 0) Then
				Self.sleepCount -= 1
			EndIf
			
			If (Self.follow And Not Self.used And Self.sleepCount = 0) Then
				Self.posX = MyAPI.calNextPosition(Double(Self.posX), Double(player.posX Shr 6), 1, FOLLOW_RING_MOVEMENT_Z, 3.0)
				Self.posY = MyAPI.calNextPosition(Double(Self.posY), Double(player.posY Shr 6), 1, FOLLOW_RING_MOVEMENT_Z, 3.0)
				Self.posZ = MyAPI.calNextPosition(Double(Self.posZ), Double(player.posZ), 1, FOLLOW_RING_MOVEMENT_Z, 4.0)
			EndIf
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			If (Self.decided And Self.follow And Self.sleepCount = 0) Then
				Super.doWhileCollision(collisionObj)
			EndIf
		End
		
		Method chkDestroy:Bool()
			If (Self.decided) Then
				Return ((Self.posZ < ((player.posZ - 6) - 30) + 1) And Not Self.follow) Or (Self.used And Self.drawer.checkEnd())
			Else
				Return False
			EndIf
		End
End