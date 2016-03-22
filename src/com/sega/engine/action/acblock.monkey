Strict

Public

' Imports:
' Nothing so far.

' Classes:
Class ACBlock Extends ACCollision Abstract
	Public
		' Global variable(s):
		Global downSide:Int
		Global leftSide:Int
		Global rightSide:Int
		Global upSide:Int
	Protected
		' Fields:
		Field height:Int
		Field posX:Int
		Field posY:Int
		Field width:Int
	Public
		' Methods (Abstract):
		Method getCollisionXFromLeft:Int(Int i) Abstract
		Method getCollisionXFromRight:Int(Int i) Abstract
		Method getCollisionYFromDown:Int(Int i) Abstract
		Method getCollisionYFromUp:Int(Int i) Abstract
		
		' Constructor(s):
		Method New(worldInstance:ACWorld)
			Super.New(Null, worldInstance)
			
			Self.width = worldInstance.getTileWidth()
			Self.height = worldInstance.getTileHeight()
			
			leftSide = 0
			upSide = 0
			rightSide = worldInstance.getTileWidth() - 1
			downSide = worldInstance.getTileHeight() - 1
		End
		
		' Methods (Implemented):
		Method doWhileCollision:Void(arg0:ACObject, collision:ACCollision, arg1:Int, x:Int, y:Int, objX:Int, objY:Int) Final
			' Empty implementation.
		End
		
		Method update:Void() Final
			' Empty implementation.
		End
		
		Method setPosition:Void(x:Int, y:Int) Final
			Self.posX = x
			Self.posY = y
		End
		
		Method getLeftX:Int()
			Return Self.posX
		End
		
		Method getTopY:Int()
			Return Self.posY
		End
		
		Method getWidth:Int()
			Return Self.width
		End
		
		Method getHeight:Int()
			Return Self.height
		End
End