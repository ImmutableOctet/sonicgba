Strict

Public

' Imports:
Private
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acdegreegetter.degreereturner
	Import com.sega.engine.action.acparam
	
	Import com.sega.mobile.define.mdphone
Public

' Classes:
Class MyDegreeGetter Extends ACDegreeGetter Implements ACParam
	Private
		Field block:CollisionBlock
		Field world:CollisionMap
	Public
		Method New(world:CollisionMap)
			Self.world = world
			
			Self.block = CollisionBlock(CollisionMap.getInstance().getNewCollisionBlock())
		End
		
		Method getDegreeFromCollisionByPosition:Void(re:DegreeReturner, obj:ACCollision, currentDegree:Int, x:Int, y:Int, z:Int)
			' Empty implementation.
		End
		
		Method getDegreeFromWorldByPosition:Void(re:DegreeReturner, currentDegree:Int, x:Int, y:Int, z:Int)
			re.reset(x, y, currentDegree)
			
			CollisionMap.getInstance().getCollisionBlock(Self.block, x, y, z)
			
			re.degree = Self.block.getDegree(currentDegree, getDirectionByDegree(currentDegree))
		End
	Private
		Method getDirectionByDegree:Int(degree:Int)
			While (degree < 0)
				degree += 360.0 ' MDPhone.SCREEN_WIDTH
			Wend
			
			degree Mod= 360.0 ' MDPhone.SCREEN_WIDTH
			
			If (degree >= 315 Or degree <= 45) Then
				Return DIRECTION_UP
			End
			
			If (degree > 225 And degree < 315) Then
				Return DIRECTION_LEFT
			End
			
			If (degree < 135 Or degree > 225) Then
				Return DIRECTION_RIGHT
			End
			
			Return DIRECTION_DOWN
		End
End