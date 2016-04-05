Strict

Public

' Imports:
Private
	Import special.specialobject
	Import special.ssring
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SSLostRing Extends SSRing
	Private
		' Constant variable(s):
		Const GRAVITY:Int = 172
		
		' Fields:
		Field velX:Int
		Field velY:Int
		Field velZ:Int
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int, velX:Int, velY:Int, velZ:Int)
			Super.New(x, y, z Shl 3)
			
			Self.velX = velX
			Self.velY = velY
			Self.velZ = velZ
		End
		
		' Methods:
		Method close:Void()
			' Empty implementation.
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			' Empty implementation.
		End
	
		Method draw:Void(g:MFGraphics)
			SpecialObject.calDrawPosition(Self.posX Shr 6, Self.posY Shr 6, Self.posZ)
			
			drawObj(g, ringDrawer, 0, 8)
		End
		
		Method logic:Void()
			Self.posZ += Self.velZ
			Self.posX += Self.velX
			Self.posY += Self.velY
		End
	
		Method refreshCollision:Void(x:Int, y:Int)
			' Empty implementation.
		End
		
		Method chkDestory:Bool()
			Return (Self.posZ < ((player.posZ - 6) - 30) + 1)
		End
End