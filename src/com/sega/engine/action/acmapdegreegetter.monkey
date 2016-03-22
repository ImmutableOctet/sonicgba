Strict

Public

' Imports:
Private
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acworld
	
	Import com.sega.engine.lib.crlfp32
Public

' Classes:
Class ACMapDegreeGetter Extends ACDegreeGetter Implements ACParam
	Private
		' Fields:
		Field worldInstance:ACWorld
		Field searchRange:Int
		Field zoom:Int
	Public
		' Constructor(s):
		Method New(worldInstance:ACWorld, searchRange:Int)
			Self.worldInstance = worldInstance
			Self.searchRange = searchRange
			Self.zoom = worldInstance.getZoom()
		End
		
		' Methods:
		Method getDegreeFromWorldByPosition:Void(re:DegreeReturner, currentDegree:Int, x:Int, y:Int, z:Int)
			Local groundDirection:= getDirectionByDegree(currentDegree)
			Local upDownFirst:Bool = (groundDirection = 0 Or groundDirection = 2)
			
			If (upDownFirst) Then
				getDegreeByPositionY(re, Null, currentDegree, x, y, z)
				
				If (re.degreeCalSuccess) Then
					Return
				EndIf
			EndIf
			
			getDegreeByPositionX(re, Null, currentDegree, x, y, z)
			
			If (Not re.degreeCalSuccess And Not upDownFirst) Then
				getDegreeByPositionY(re, Null, currentDegree, x, y, z)
				
				If (Not re.degreeCalSuccess) Then
					' Nothing so far.
				EndIf
			EndIf
		End

		Method getDegreeFromCollisionByPosition:Void(re:DegreeReturner, obj:ACCollision, currentDegree:Int, x:Int, y:Int, z:Int)
			Local groundDirection:= getDirectionByDegree(currentDegree)
			Local upDownFirst:Bool = (groundDirection = 0 Or groundDirection = 2)
			
			If (upDownFirst) Then
				getDegreeByPositionY(re, obj, currentDegree, x, y, z)
				
				If (re.degreeCalSuccess) Then
					Return
				EndIf
			EndIf
			
			getDegreeByPositionX(re, obj, currentDegree, x, y, z)
			
			If (Not re.degreeCalSuccess And Not upDownFirst) Then
				getDegreeByPositionY(re, obj, currentDegree, x, y, z)
				
				If (Not re.degreeCalSuccess) Then
					' Nothing so far.
				EndIf
			EndIf
		End
	Private
		' Methods:	
		Method getDirectionByDegree:Int(degree:Int)
			While (degree < 0)
				degree += 360
			Wend
			
			degree Mod= 360
			
			If (degree >= 315 Or degree <= 45) Then
				Return DIRECTION_UP
			EndIf
			
			If (degree > 225 And degree < 315) Then
				Return DIRECTION_LEFT
			EndIf
			
			If (degree < 135 Or degree > 225) Then
				Return DIRECTION_RIGHT
			EndIf
			
			Return DIRECTION_DOWN
		End
		
		Method getDegreeByTwoPoint:Int(px1:Int, py1:Int, px2:Int, py2:Int, degree:Int)
			If (px1 = px2 And py1 = py2) Then
				Return degree
			EndIf
			
			Local re:= CrlFP32.actTanDegree(py2 - py1, px2 - px1)
			Local degreeDiff:= Abs(degree - re)
			
			If (degreeDiff > 180) Then
				degreeDiff = (360 - degreeDiff)
			EndIf
			
			If (degreeDiff > 90) Then
				re = ((re + 180) Mod 360)
			EndIf
			
			Return re
		End
		
		Method getDegreeDiff:Int(degree1:Int, degree2:Int)
			Local degreeDiff:= Abs(degree1 - degree2)
			
			If (degreeDiff > 180) Then
				Return (360 - degreeDiff)
			EndIf
			
			Return degreeDiff
		End
		
		Method getDegreeByPositionY:Void(re:DegreeReturner, obj:ACCollision, currentDegree:Int, x:Int, y:Int, z:Int)
			Local groundDirection:= DIRECTION_UP
			
			If (currentDegree > 90 And currentDegree < 270) Then
				groundDirection = DIRECTION_DOWN
			EndIf
			
			getDegreeByPositionAndDirection(re, obj, currentDegree, x, y, z, groundDirection)
		End
		
		Method getDegreeByPositionX:Void(re:DegreeReturner, obj:ACCollision, currentDegree:Int, x:Int, y:Int, z:Int)
			Local groundDirection:= DIRECTION_LEFT
			
			If (currentDegree > 0 And currentDegree < 180) Then
				groundDirection = DIRECTION_RIGHT
			EndIf
			
			getDegreeByPositionAndDirection(re, obj, currentDegree, x, y, z, groundDirection)
		End
		
		Method getDegreeByPositionAndDirection:Void(re:DegreeReturner, obj:ACCollision, currentDegree:Int, x:Int, y:Int, z:Int, direction:Int)
			re.reset(x, y, currentDegree)
			
			Local searchLeftY:Int
			Local findSearchPointLeft:Bool
			Local searchLeftX:Int
			Local i:Int
			Local calOffset:Int
			Local searchRightY:Int
			Local findSearchPointRight:Bool
			Local searchRightX:Int
			
			Select (direction)
				Case DIRECTION_UP, DIRECTION_DOWN
					Local directionV:Int
					
					If (direction = 0) Then
						directionV = 1
					Else
						directionV = -1
					EndIf
					
					Local newY:= getNewY(x, y, z, direction, obj)
					
					If (newY <> NO_COLLISION) Then
						Local searchRightLimitY:Int
						
						y = newY
						searchLeftY = y + (Self.searchRange * directionV)
						findSearchPointLeft = False
						searchLeftX = x - Self.searchRange
						
						While (searchLeftX < x)
							i = Self.searchRange
							
							calOffset = (r0 * (x - searchLeftX)) / Self.searchRange
							searchLeftY = y + (directionV * calOffset)
							
							Local searchLeftLimitY:= (y - (directionV * calOffset))
							
							newY = getNewY(searchLeftX, searchLeftY, z, direction, obj)
							
							If (newY = NO_COLLISION Or ((direction <> DIRECTION_UP Or newY < searchLeftLimitY) And (direction <> DIRECTION_DOWN Or newY > searchLeftLimitY))) Then
								searchLeftX += 1 Shl Self.zoom
							Else
								findSearchPointLeft = True
								
								searchLeftY = newY
								searchRightY = y + (Self.searchRange * directionV)
								
								findSearchPointRight = False
								
								searchRightX = x + Self.searchRange
								
								While (searchRightX > x)
									i = Self.searchRange
									
									calOffset = (r0 * (searchRightX - x)) / Self.searchRange
									
									searchRightY = y + (directionV * calOffset)
									searchRightLimitY = y - (directionV * calOffset)
									
									newY = getNewY(searchRightX, searchRightY, z, direction, obj)
									
									If (newY <> NO_COLLISION Or ((direction <> DIRECTION_UP Or newY < searchRightLimitY) And (direction <> DIRECTION_DOWN Or newY > searchRightLimitY))) Then
										searchRightX -= 1 Shl Self.zoom
									Else
										findSearchPointRight = True
										searchRightY = newY
										
										If (Not findSearchPointLeft Or findSearchPointRight) Then
											re.degreeCalSuccess = True
											re.newX = x
											re.newY = y
											re.degree = calDegreeByAllPoints(searchLeftX, searchLeftY, searchRightX, searchRightY, x, y, findSearchPointLeft, findSearchPointRight, currentDegree)
										EndIf
										
										Return
									EndIf
								Wend
								
								If (findSearchPointLeft) Then
									' Nothing so far.
								EndIf
								
								re.degreeCalSuccess = True
								
								re.newX = x
								re.newY = y
								
								re.degree = calDegreeByAllPoints(searchLeftX, searchLeftY, searchRightX, searchRightY, x, y, findSearchPointLeft, findSearchPointRight, currentDegree)
							EndIf
						Wend
						
						searchRightY = y + (Self.searchRange * directionV)
						
						findSearchPointRight = False
						
						searchRightX = x + Self.searchRange
						
						While (searchRightX > x)
							i = Self.searchRange
							
							calOffset = (r0 * (searchRightX - x)) / Self.searchRange
							
							searchRightY = y + (directionV * calOffset)
							searchRightLimitY = y - (directionV * calOffset)
							
							newY = getNewY(searchRightX, searchRightY, z, direction, obj)
							
							If (newY <> NO_COLLISION) Then
								Exit
							EndIf
							
							searchRightX -= 1 Shl Self.zoom
						Wend
						
						If (findSearchPointLeft) Then
							' Nothing so far.
						EndIf
						
						re.degreeCalSuccess = True
						
						re.newX = x
						re.newY = y
						
						re.degree = calDegreeByAllPoints(searchLeftX, searchLeftY, searchRightX, searchRightY, x, y, findSearchPointLeft, findSearchPointRight, currentDegree)
					EndIf
				Case DIRECTION_LEFT, DIRECTION_RIGHT
					Local directionH:Int
					
					If (direction = DIRECTION_LEFT) Then
						directionH = 1
					Else
						directionH = -1
					EndIf
					
					Local newX:= getNewX(x, y, z, direction, obj)
					
					If (newX <> NO_COLLISION) Then
						Local searchRightLimitX:Int
						
						x = newX
						
						searchLeftX = 0
						findSearchPointLeft = False
						
						searchLeftY = (y - Self.searchRange)
						
						While (searchLeftY < y)
							i = Self.searchRange
							
							calOffset = (r0 * (y - searchLeftY)) / Self.searchRange
							searchLeftX = x + (directionH * calOffset)
							
							Local searchLeftLimitX:= (x - (directionH * calOffset))
							
							newX = getNewX(searchLeftX, searchLeftY, z, direction, obj)
							
							If (newX = NO_COLLISION Or ((direction <> DIRECTION_LEFT Or newX < searchLeftLimitX) And (direction <> DIRECTION_RIGHT Or newX > searchLeftLimitX))) Then
								searchLeftY += 1 Shl Self.zoom
							Else
								findSearchPointLeft = True
								
								searchLeftX = newX
								searchRightX = 0
								
								findSearchPointRight = False
								
								searchRightY = y + Self.searchRange
								
								While (searchRightY > y)
									i = Self.searchRange
									
									calOffset = (r0 * (searchRightY - y)) / Self.searchRange
									
									searchRightX = x + (directionH * calOffset)
									searchRightLimitX = x - (directionH * calOffset)
									
									newX = getNewX(searchRightX, searchRightY, z, direction, obj)
									
									If (newX <> NO_COLLISION Or ((direction <> DIRECTION_LEFT Or newX < searchRightLimitX) And (direction <> DIRECTION_RIGHT Or newX > searchRightLimitX))) Then
										searchRightY -= 1 Shl Self.zoom
									Else
										findSearchPointRight = True
										searchRightX = newX
										
										If (Not findSearchPointLeft Or findSearchPointRight) Then
											re.degreeCalSuccess = True
											
											re.newX = x
											re.newY = y
											
											re.degree = calDegreeByAllPoints(searchLeftX, searchLeftY, searchRightX, searchRightY, x, y, findSearchPointLeft, findSearchPointRight, currentDegree)
										EndIf
										
										Return
									EndIf
								EndIf
								
								If (findSearchPointLeft) Then
									' Nothing so far.
								EndIf
								
								re.degreeCalSuccess = True
								
								re.newX = x
								re.newY = y
								
								re.degree = calDegreeByAllPoints(searchLeftX, searchLeftY, searchRightX, searchRightY, x, y, findSearchPointLeft, findSearchPointRight, currentDegree)
							EndIf
						EndIf
						
						searchRightX = 0
						
						findSearchPointRight = False
						
						searchRightY = y + Self.searchRange
						
						While (searchRightY > y)
							i = Self.searchRange
							
							calOffset = (r0 * (searchRightY - y)) / Self.searchRange
							
							searchRightX = x + (directionH * calOffset)
							searchRightLimitX = x - (directionH * calOffset)
							
							newX = getNewX(searchRightX, searchRightY, z, direction, obj)
							
							If (newX <> NO_COLLISION) Then
								Exit
							EndIf
							
							searchRightY -= 1 Shl Self.zoom
						Wend
						
						If (findSearchPointLeft) Then
							' Nothing so far.
						EndIf
						
						re.degreeCalSuccess = True
						
						re.newX = x
						re.newY = y
						
						re.degree = calDegreeByAllPoints(searchLeftX, searchLeftY, searchRightX, searchRightY, x, y, findSearchPointLeft, findSearchPointRight, currentDegree)
					EndIf
			End Select
		End
		
		Method calDegreeByAllPoints:Int(searchLeftX:Int, searchLeftY:Int, searchRightX:Int, searchRightY:Int, x:Int, y:Int, findSearchPointLeft:Bool, findSearchPointRight:Bool, currentDegree:Int)
			Local re:= currentDegree
			
			Local leftDegree:= currentDegree
			
			If (findSearchPointLeft) Then
				leftDegree = getDegreeByTwoPoint(searchLeftX, searchLeftY, x, y, currentDegree)
			EndIf
			
			Local rightDegree:= currentDegree
			
			If (findSearchPointRight) Then
				rightDegree = getDegreeByTwoPoint(searchRightX, searchRightY, x, y, currentDegree)
			EndIf
			
			If (findSearchPointLeft And findSearchPointRight) Then
				If (getDegreeDiff(leftDegree, currentDegree) <= getDegreeDiff(rightDegree, currentDegree)) Then
					re = leftDegree
				Else
					re = rightDegree
				EndIf
			ElseIf (findSearchPointLeft) Then
				re = leftDegree
			ElseIf (findSearchPointRight) Then
				re = rightDegree
			EndIf
			
			While (re < 0)
				re += 360
			Wend
			
			Return (re Mod 360)
		End
	
		Method getNewX:Int(x:Int, y:Int, z:Int, direction:Int, obj:ACCollision)
			If (obj <> Null) Then
				Return obj.getCollisionX(x, direction)
			EndIf
			
			Return Self.worldInstance.getWorldX(x, y, z, direction)
		End
		
		Method getNewY:Int(x:Int, y:Int, z:Int, direction:Int, obj:ACCollision)
			If (obj <> Null) Then
				Return obj.getCollisionY(x, direction)
			EndIf
			
			Return Self.worldInstance.getWorldY(x, y, z, direction)
		End
End