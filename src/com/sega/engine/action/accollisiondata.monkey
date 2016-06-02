Strict

Public

' Imports:
Private
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acblock
Public

' Classes:
Class ACCollisionData Implements ACParam
	Public
		' Fields:
		Field chkPointID:Int
		Field collisionX:Int
		Field collisionY:Int
		Field newPosX:Int
		Field newPosY:Int
		Field reBlock:ACBlock
		
		' Constructor(s):
		Method New()
			reset()
		End
		
		' Methods:
		Method reset:Void()
			Self.newPosX = ACParam.NO_COLLISION
			Self.newPosY = ACParam.NO_COLLISION
			
			Self.reBlock = Null
		End
		
		Method isNoCollision:Bool()
			Return ((Self.newPosX = ACParam.NO_COLLISION) And (Self.newPosY = ACParam.NO_COLLISION))
		End
End