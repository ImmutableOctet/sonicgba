Strict

Public

' Imports:
Private
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acworld
Public

' Classes:
Class ACObject Implements ACParam Abstract
	Private
		' Fields:
		Field collisionVec:Stack<ACCollision>
	Protected
		' Fields:
		Field width:Int
		Field height:Int
		
		Field worldInstance:ACWorld
		Field worldZoom:Int ' Final
		
		Field posZ:Int
	Public
		' Fields:
		Field posX:Int
		Field posY:Int
		
		Field velX:Int
		Field velY:Int
		
		' Methods (Abstract):
		Method doBeforeCollisionCheck:Void() Abstract
		Method doWhileCollision:Void(aCObject:ACObject, aCCollision:ACCollision, i:Int, i2:Int, i3:Int, i4:Int, i5:Int) Abstract
		
		' Constructor(s):
		Method New(worldInstance:ACWorld)
			Self.worldInstance = worldInstance
			Self.worldZoom = worldInstance.getZoom()
			
			Self.collisionVec = New Stack<ACCollision>()
		End
		
		' Methods (Implemented):
		Method addCollision:Void(collision:ACCollision)
			Self.collisionVec.Push(collision)
		End
		
		Method removeCollision:Void(index:Int)
			If (index >= 0 And index < Self.collisionVec.Length) Then
				Self.collisionVec.Remove(index)
			EndIf
		End
		
		Method getCollisionVec:Stack<ACCollision>()
			Return Self.collisionVec
		End
		
		Method setPosition:Void(x:Int, y:Int)
			Self.posX = x
			Self.posY = y
		End
		
		Method setRect:Void(w:Int, h:Int)
			Self.width = w
			Self.height = h
		End
		
		Method getObjWidth:Int()
			Return Self.width
		End
		
		Method getObjHeight:Int()
			Return Self.height
		End
		
		Method getWorld:ACWorld()
			Return Self.worldInstance
		End
		
		Method getX:Int()
			Return Self.posX
		End
		
		Method getY:Int()
			Return Self.posY
		End
		
		Method doCheckCollisionWithObj:Void(obj:ACObject, moveDistanceX:Int, moveDistanceY:Int)
			For Local i:= 0 Until Self.collisionVec.Length
				Local element:= Self.collisionVec.Get(i)
				
				Local objCollisionVec:= obj.getCollisionVec()
				
				For Local j:= 0 Until objCollisionVec.Length
					element.doCheckCollisionWithCollision(objCollisionVec.Get(j), moveDistanceX, moveDistanceY)
				Next
			EndIf
		End
End