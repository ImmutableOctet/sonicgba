Strict

Public

' Imports:
Private
	Import lib.crlfp32
	Import lib.constutil
	
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acworld
Public

' Classes:
Class ACCollision Implements ACParam Abstract
	Protected
		' Fields:
		Field acObj:ACObject
		Field worldZoom:Int
	Private
		' Fields:
		Field horizontalCollision:Bool
		Field verticalCollision:Bool
		Field isLeftCollision:Bool
		Field isUpCollision:Bool
		
		Field horizontalDistance:Int
		Field objDownHighPointY:Int
		Field objLeftHighPointX:Int
		Field objRightHighPointX:Int
		Field objUpHighPointY:Int
		Field thisDownHighPointX:Int
		Field thisDownHighPointY:Int
		Field thisLeftHighPointX:Int
		Field thisLeftHighPointY:Int
		Field thisRightHighPointX:Int
		Field thisRightHighPointY:Int
		Field thisUpHighPointX:Int
		Field thisUpHighPointY:Int
		Field verticalDistance:Int
	Public
		' Methods (Abstract):
		Method getCollisionXFromLeft:Int(value:Int) Abstract
		Method getCollisionXFromRight:Int(value:Int) Abstract
		
		Method getCollisionYFromUp:Int(value:Int) Abstract
		Method getCollisionYFromDown:Int(value:Int) Abstract
		
		Method getWidth:Int() Abstract
		Method getHeight:Int() Abstract
		
		Method getLeftX:Int() Abstract
		Method getTopY:Int() Abstract
		
		Method update:Void() Abstract
		
		' Constructor(s):
		Method New(acObj:ACObject, worldInstance:ACWorld)
			Self.thisLeftHighPointX = ACParam.NO_COLLISION
			Self.thisRightHighPointX = ACParam.NO_COLLISION
			Self.thisLeftHighPointY = ACParam.NO_COLLISION
			Self.objLeftHighPointX = ACParam.NO_COLLISION
			Self.objRightHighPointX = ACParam.NO_COLLISION
			Self.thisRightHighPointY = ACParam.NO_COLLISION
			Self.thisUpHighPointY = ACParam.NO_COLLISION
			Self.objUpHighPointY = ACParam.NO_COLLISION
			Self.thisUpHighPointX = ACParam.NO_COLLISION
			Self.thisDownHighPointY = ACParam.NO_COLLISION
			Self.objDownHighPointY = ACParam.NO_COLLISION
			Self.thisDownHighPointX = ACParam.NO_COLLISION
			
			setObject(acObj)
			
			Self.worldZoom = worldInstance.getZoom()
		End
	Public
		' Methods (Implemented):
		Method setObject:Void(acObj:ACObject)
			Self.acObj = acObj
		End
	
		Method getObject:ACObject()
			Return Self.acObj
		End
		
		Method doCheckCollisionWithCollision:Void(obj:ACCollision, moveDistanceX:Int, moveDistanceY:Int)
			Self.acObj.doBeforeCollisionCheck()
			obj.getObject().doBeforeCollisionCheck()
			
			update()
			obj.update()
			
			Self.horizontalDistance = CrlFP32.MAX_VALUE
			Self.verticalDistance = CrlFP32.MAX_VALUE
			
			doCheckCollisionX(obj, moveDistanceX)
			doCheckCollisionY(obj, moveDistanceY)
			
			If (Self.horizontalCollision And Self.verticalCollision) Then
				If (Self.horizontalDistance <= Self.verticalDistance) Then
					doHorizontalCollision(obj)
					
					Self.acObj.doBeforeCollisionCheck()
					obj.getObject().doBeforeCollisionCheck()
					
					update()
					obj.update()
					
					doCheckCollisionY(obj, moveDistanceY)
					
					If (Self.verticalCollision) Then
						doVerticalCollision(obj)
						
						Return
					EndIf
					
					Return
				EndIf
				
				doVerticalCollision(obj)
				
				Self.acObj.doBeforeCollisionCheck()
				obj.getObject().doBeforeCollisionCheck()
				
				update()
				obj.update()
				
				doCheckCollisionX(obj, moveDistanceX)
				
				If (Self.horizontalCollision) Then
					doHorizontalCollision(obj)
				EndIf
			ElseIf (Self.horizontalCollision) Then
				doHorizontalCollision(obj)
			ElseIf (Self.verticalCollision) Then
				doVerticalCollision(obj)
			EndIf
		End
		
		Method getCollisionX:Int(y:Int, direction:Int)
			If (y < getTopY() Or y >= getTopY() + getHeight()) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			y -= getTopY()
			
			Local refX:= ACParam.NO_COLLISION
			
			Select (direction)
				Case DIRECTION_RIGHT
					refX = getCollisionXFromRight(y)
				Case DIRECTION_LEFT
					refX = getCollisionXFromLeft(y)
			End Select
			
			If (refX <> ACParam.NO_COLLISION) Then
				Return (getLeftX() + refX)
			EndIf
			
			Return ACParam.NO_COLLISION
		End
	
		Method getCollisionY:Int(x:Int, direction:Int)
			If (x < getLeftX() Or x >= getLeftX() + getWidth()) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			x -= getLeftX()
			
			Local refY:= ACParam.NO_COLLISION
			
			Select (direction)
				Case DIRECTION_UP
					refY = getCollisionYFromUp(x)
				Case DIRECTION_DOWN
					refY = getCollisionYFromDown(x)
			End Select
			
			If (refY <> ACParam.NO_COLLISION) Then
				Return getTopY() + refY
			EndIf
			
			Return ACParam.NO_COLLISION
		End
	Private
		' Methods:
		Method doObjCollision:Void(collision:ACCollision, direction:Int, touchX:Int, touchY:Int, objTouchX:Int, objTouchY:Int)
			Local obj:= collision.getObject()
			
			If (Self.acObj <> Null And obj <> Null) Then
				Self.acObj.onCollision(obj, Self, direction, touchX, touchY, objTouchX, objTouchY)
			EndIf
		End
		
		Method doHorizontalCollision:Void(obj:ACCollision)
			If (Self.isLeftCollision) Then
				doObjCollision(obj, DIRECTION_LEFT, Self.thisLeftHighPointX, Self.thisLeftHighPointY, Self.objLeftHighPointX, Self.thisLeftHighPointY)
				obj.doObjCollision(Self, DIRECTION_RIGHT, Self.objLeftHighPointX, Self.thisLeftHighPointY, Self.thisLeftHighPointX, Self.thisLeftHighPointY)
				
				Return
			EndIf
			
			doObjCollision(obj, DIRECTION_RIGHT, Self.thisRightHighPointX, Self.thisRightHighPointY, Self.objRightHighPointX, Self.thisRightHighPointY)
			obj.doObjCollision(Self, DIRECTION_LEFT, Self.objRightHighPointX, Self.thisRightHighPointY, Self.thisRightHighPointX, Self.thisRightHighPointY)
		End
		
		Method doVerticalCollision:Void(obj:ACCollision)
			If (Self.isUpCollision) Then
				doObjCollision(obj, DIRECTION_UP, Self.thisUpHighPointX, Self.thisUpHighPointY, Self.thisUpHighPointX, Self.objUpHighPointY)
				obj.doObjCollision(Self, DIRECTION_DOWN, Self.thisUpHighPointX, Self.objUpHighPointY, Self.thisUpHighPointX, Self.thisUpHighPointY)
				
				Return
			EndIf
			
			doObjCollision(obj, DIRECTION_DOWN, Self.thisDownHighPointX, Self.thisDownHighPointY, Self.thisDownHighPointX, Self.objDownHighPointY)
			obj.doObjCollision(Self, DIRECTION_UP, Self.thisDownHighPointX, Self.objDownHighPointY, Self.thisDownHighPointX, Self.thisDownHighPointY)
		End
		
		Method doCheckCollisionX:Void(obj:ACCollision, moveDistanceX:Int)
			Self.horizontalCollision = False
			
			If (getLeftX() + getWidth() >= obj.getLeftX() And getLeftX() <= obj.getLeftX() + obj.getWidth()) Then
				Local i:Int
				
				Local topY:= Max(getTopY(), obj.getTopY())
				Local bottomY:= Min(getTopY() + getHeight(), obj.getTopY() + obj.getHeight())
				
				Self.thisLeftHighPointX = ACParam.NO_COLLISION
				Self.thisRightHighPointX = ACParam.NO_COLLISION
				Self.thisLeftHighPointY = ACParam.NO_COLLISION
				Self.objLeftHighPointX = ACParam.NO_COLLISION
				Self.objRightHighPointX = ACParam.NO_COLLISION
				Self.thisRightHighPointY = ACParam.NO_COLLISION
				
				Local leftMaxDistance:= 0
				Local rightMaxDistance:= 0
				Local i2:= topY
				
				While (i2 < bottomY)
					Local thisLeftX:= getCollisionX(i2, DIRECTION_LEFT)
					Local objRightX:= obj.getCollisionX(i2, DIRECTION_RIGHT)
					Local thisRightX:= getCollisionX(i2, DIRECTION_RIGHT)
					Local objLeftX:= obj.getCollisionX(i2, DIRECTION_LEFT)
					
					If (Not (thisLeftX = ACParam.NO_COLLISION Or objRightX = ACParam.NO_COLLISION Or thisLeftX > objRightX)) Then
						i = Self.thisLeftHighPointX
						
						If (r0 = NO_COLLISION Or Abs(thisLeftX - objRightX) > leftMaxDistance) Then
							Self.thisLeftHighPointX = thisLeftX
							Self.objLeftHighPointX = objRightX
							
							leftMaxDistance = Abs(thisLeftX - objRightX)
							
							Self.thisLeftHighPointY = i2
						EndIf
					EndIf
					
					If (Not (thisRightX = ACParam.NO_COLLISION Or objLeftX = ACParam.NO_COLLISION Or thisRightX < objLeftX)) Then
						i = Self.thisRightHighPointX
						
						If (r0 = NO_COLLISION Or Abs(thisRightX - objLeftX) > rightMaxDistance) Then
							Self.thisRightHighPointX = thisRightX
							Self.objRightHighPointX = objLeftX
							
							rightMaxDistance = Abs(thisRightX - objLeftX)
							
							Self.thisRightHighPointY = i2
						EndIf
					EndIf
					
					i2 += 1 Shl Self.worldZoom
				Wend
				
				Local hasCollision:Bool = True
				Local isLeftCollision:Bool = True
				
				i = Self.thisLeftHighPointX
				
				If (r0 <> NO_COLLISION) Then
					i = Self.thisRightHighPointX
					
					If (r0 <> NO_COLLISION) Then
						If (leftMaxDistance = rightMaxDistance) Then
							If (moveDistanceX >= 0) Then
								isLeftCollision = False
							Else
								isLeftCollision = True
							EndIf
						ElseIf (leftMaxDistance < rightMaxDistance) Then
							isLeftCollision = True
						Else
							isLeftCollision = False
						EndIf
						
						If (hasCollision) Then
							Self.horizontalCollision = True
							Self.isLeftCollision = isLeftCollision
							
							If (isLeftCollision) Then
								Self.horizontalDistance = rightMaxDistance
							Else
								Self.horizontalDistance = leftMaxDistance
							EndIf
						EndIf
					EndIf
				EndIf
				
				' Not sure why this is here, but whatever.
				hasCollision = False
				
				If (hasCollision) Then
					Self.horizontalCollision = True
					Self.isLeftCollision = isLeftCollision
					
					If (isLeftCollision) Then
						Self.horizontalDistance = rightMaxDistance
					Else
						Self.horizontalDistance = leftMaxDistance
					EndIf
				EndIf
			EndIf
		End

		Method doCheckCollisionY:Void(obj:ACCollision, moveDistanceY:Int)
			Self.verticalCollision = False
			
			If (getTopY() + getHeight() >= obj.getTopY() And getTopY() <= obj.getTopY() + obj.getHeight()) Then
				Local rightX:Int
				Local leftX:Int = PickValue((getLeftX() > obj.getLeftX()), getLeftX(), obj.getLeftX())
				
				If (getLeftX() + getWidth() < obj.getLeftX() + obj.getWidth()) Then
					rightX = getLeftX() + getWidth()
				Else
					rightX = obj.getLeftX() + obj.getWidth()
				EndIf
				
				Self.thisUpHighPointY = ACParam.NO_COLLISION
				Self.objUpHighPointY = ACParam.NO_COLLISION
				Self.thisUpHighPointX = ACParam.NO_COLLISION
				Self.thisDownHighPointY = ACParam.NO_COLLISION
				Self.objDownHighPointY = ACParam.NO_COLLISION
				Self.thisDownHighPointX = ACParam.NO_COLLISION
				
				Local upMaxDistance:= 0
				Local downMaxDistance:= 0
				
				Local i:= leftX
				
				While (i < rightX)
					Local thisUpY:= getCollisionY(i, DIRECTION_UP)
					Local thisDownY:= getCollisionY(i, DIRECTION_DOWN)
					Local objUpY:= obj.getCollisionY(i, DIRECTION_UP)
					Local objDownY:= obj.getCollisionY(i, DIRECTION_DOWN)
					
					If (thisUpY <> ACParam.NO_COLLISION And objDownY <> ACParam.NO_COLLISION And thisUpY <= objDownY And (Self.thisUpHighPointY = ACParam.NO_COLLISION Or Abs(thisUpY - objDownY) > upMaxDistance)) Then
						Self.thisUpHighPointY = thisUpY
						Self.objUpHighPointY = objDownY
						
						upMaxDistance = Abs(thisUpY - objDownY)
						
						Self.thisUpHighPointX = i
					EndIf
					
					If (thisDownY <> ACParam.NO_COLLISION And objUpY <> ACParam.NO_COLLISION And thisDownY >= objUpY And (Self.thisDownHighPointY = ACParam.NO_COLLISION Or Abs(thisDownY - objUpY) > downMaxDistance)) Then
						Self.thisDownHighPointY = thisDownY
						Self.objDownHighPointY = objUpY
						
						downMaxDistance = Abs(thisDownY - objUpY)
						
						Self.thisDownHighPointX = i
					EndIf
					
					i += 1 Shl Self.worldZoom
				Wend
				
				If (Self.thisUpHighPointY <> ACParam.NO_COLLISION And Self.thisDownHighPointY <> ACParam.NO_COLLISION) Then
					Local isUpCollision:Bool
					
					If (upMaxDistance = downMaxDistance) Then
						If (moveDistanceY >= 0) Then
							isUpCollision = False
						Else
							isUpCollision = True
						EndIf
					ElseIf (upMaxDistance < downMaxDistance) Then
						isUpCollision = True
					Else
						isUpCollision = False
					EndIf
					
					Self.verticalCollision = True
					Self.isUpCollision = isUpCollision
					
					If (isUpCollision) Then
						Self.verticalDistance = upMaxDistance
					Else
						Self.verticalDistance = downMaxDistance
					EndIf
				EndIf
			EndIf
		End
End