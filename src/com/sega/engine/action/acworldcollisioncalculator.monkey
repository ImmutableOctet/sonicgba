Strict

Public

' Imports:
Private
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.accollisiondata
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acmovecalculator
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworld
	Import com.sega.engine.action.acworldcaluser
	Import com.sega.engine.action.acworldcollisionlimit
	
	Import com.sega.engine.lib.crlfp32
	Import com.sega.engine.lib.MyAPI
	
	Import regal.typetool
Public

' Classes:
Class ACWorldCollisionCalculator Extends ACMoveCalculator Implements ACParam
	Private
		' Constant variable(s):
		Const BLOCK_CHECK_RANGE:Int = 1
		Const DIRECTION_OFFSET_DOWN:Int= 0
		Const DIRECTION_OFFSET_LEFT:Int = 1
		Const DIRECTION_OFFSET_RIGHT:Int = 3
		Const DIRECTION_OFFSET_UP:Int = 2
		Const DOWN_SEARCH_BLOCK:Int = 8
		
		' Fields:
		Field degreeRe:DegreeReturner
		
		Field footCollisionPointOffsetX:Int[]
		Field footCollisionPointOffsetY:Int
		
		Field footCollisionPointResaultX:Int[]
		Field footCollisionPointResaultY:Int[]
		
		Field footOffsetX:Int
		Field footOffsetY:Int
		
		Field footX:Int
		Field footY:Int
		
		Field headCollisionPointOffsetX:Int[]
		Field headCollisionPointOffsetY:Int
		
		Field isMoved:Bool
		
		Field lastMoveDistanceX:Int
		Field lastMoveDistanceY:Int
		Field limit:ACWorldCollisionLimit
		
		Field movePassiveX:Int
		Field movePassiveY:Int
		
		Field preBodyOffset:Int
		Field preFootOffset:Int
		Field preHeight:Int
		Field preWidth:Int
		
		Field priorityChkId:Int
		Field totalDistance:Int
		
		Field user:ACWorldCalUser
	Public
		' Constant variable(s):
		Const JUMP_ACTION_STATE:Byte = 1
		Const WALK_ACTION_STATE:Byte = 0
		
		' Fields:
		Field actionState:Byte
		Field footDegree:Int
	Private
		' Fields:
		Field bodyCollisionPointOffsetX:Int
		Field bodyCollisionPointOffsetY:Int[]
		
		Field checkArrayForShowX:Int[]
		Field checkArrayForShowY:Int[]
		
		Field chkOffsetX:Int
		Field chkOffsetY:Int
		
		Field chkPointDegree:Int
		Field chkPointId:Int
		
		Field chkPointX:Int
		Field chkPointY:Int
		
		Field collisionData:ACCollisionData
	Protected
		' Fields:
		Field degreeGetter:ACDegreeGetter
		Field getBlock:ACBlock
	Public
		' Constructor(s):
		Method New(acObj:ACObject, user:ACWorldCalUser)
			Super.New(acObj, user)
			
			Self.lastMoveDistanceX = -9999
			Self.lastMoveDistanceY = -9999
			
			Self.preWidth = -1
			Self.preHeight = -1
			
			Self.preFootOffset = -1
			Self.preBodyOffset = -1
			
			Self.degreeRe = New DegreeReturner()
			
			Self.user = user
			Self.degreeGetter = Self.worldInstance.getDegreeGetterForObject()
			Self.actionState = JUMP_ACTION_STATE
			
			calPosition(acObj.getObjWidth(), acObj.getObjHeight(), user.getFootOffset(), user.getBodyOffset())
			
			If (Self.getBlock = Null) Then
				Self.getBlock = Self.worldInstance.getNewCollisionBlock()
			EndIf
			
			Self.collisionData = New ACCollisionData()
		End
		
		' Methods:
		Method setLimit:Void(limit:ACWorldCollisionLimit)
			Self.limit = limit
		End
	Private
		' Methods:
		Method calPosition:Void(collisionWidth:Int, collisionHeight:Int, footOffset:Int, bodyOffset:Int)
			Self.footCollisionPointOffsetX = New Int[DIRECTION_OFFSET_RIGHT] ' 3
			Self.footCollisionPointResaultX = New Int[DIRECTION_OFFSET_RIGHT] ' 3
			Self.footCollisionPointResaultY = New Int[DIRECTION_OFFSET_RIGHT] ' 3
			
			Self.footCollisionPointOffsetX[DIRECTION_OFFSET_DOWN] = -((collisionWidth - (footOffset * 2)) Shr 1)
			Self.footCollisionPointOffsetX[DIRECTION_OFFSET_RIGHT - DIRECTION_OFFSET_LEFT] = (collisionWidth - (footOffset * 2)) Shr 1
			Self.priorityChkId = DIRECTION_OFFSET_LEFT ' 1
			
			If (DIRECTION_OFFSET_RIGHT > DIRECTION_OFFSET_UP) Then
				Local x:= ((collisionWidth - footOffset * 2) / (DIRECTION_OFFSET_RIGHT - DIRECTION_OFFSET_LEFT))
				
				For Local i:= DIRECTION_OFFSET_LEFT Until (DIRECTION_OFFSET_RIGHT - DIRECTION_OFFSET_LEFT)
					Self.footCollisionPointOffsetX[i] = (x + Self.footCollisionPointOffsetX[i - DIRECTION_OFFSET_LEFT])
				Next
			EndIf
			
			Self.footCollisionPointOffsetY = 0
			
			Self.headCollisionPointOffsetX = Self.footCollisionPointOffsetX
			Self.headCollisionPointOffsetY = -collisionHeight
			
			Self.bodyCollisionPointOffsetX = (collisionWidth Shr 1)
			
			Local len:= (DIRECTION_OFFSET_UP + (collisionHeight - bodyOffset * DIRECTION_OFFSET_UP - DIRECTION_OFFSET_LEFT) / Self.worldInstance.getTileHeight())
			
			Self.bodyCollisionPointOffsetY = new Int[len]
			Self.bodyCollisionPointOffsetY[DIRECTION_OFFSET_DOWN] = -bodyOffset
			Self.bodyCollisionPointOffsetY[len - 1] = bodyOffset + -collisionHeight
			
			If (len > DIRECTION_OFFSET_UP) Then
				Local y:= (collisionHeight - bodyOffset * 2) / (len - DIRECTION_OFFSET_LEFT)
				
				For Local i:= DIRECTION_OFFSET_LEFT Until (len - DIRECTION_OFFSET_LEFT)
					Self.bodyCollisionPointOffsetY[i] = (Self.bodyCollisionPointOffsetY[i - DIRECTION_OFFSET_LEFT] - y)
				Next
			EndIf
		End
		
	Public Method changeSize:Void(collisionWidth:Int, collisionHeight:Int, footOffset:Int, bodyOffset:Int)
		
		If (bodyOffset < Self.worldInstance.getTileHeight()) Then
			bodyOffset = Self.worldInstance.getTileHeight()
		EndIf
		
		If (collisionWidth <> Self.preWidth Or collisionHeight <> Self.preHeight Or footOffset <> Self.preFootOffset Or bodyOffset <> Self.preBodyOffset) Then
			calPosition(collisionWidth, collisionHeight, footOffset, bodyOffset)
			Self.preWidth = collisionWidth
			Self.preHeight = collisionHeight
			Self.preFootOffset = footOffset
			Self.preBodyOffset = bodyOffset
		EndIf
	EndIf
	

	Public Method actionLogic:Void(moveDistanceX:Int, moveDistanceY:Int)
		actionLogic(moveDistanceX, moveDistanceY, ((Cos(Self.footDegree) * moveDistanceX) + (Sin(Self.footDegree) * moveDistanceY)) / 100)
	EndIf

	Public Method actionLogic:Void(moveDistanceX:Int, moveDistanceY:Int, totalVelocity:Int)
		changeSize(Self.acObj.getObjWidth(), Self.acObj.getObjHeight(), Self.user.getFootOffset(), Self.user.getBodyOffset())
		
		Self.footX = Self.user.getFootX()
		Self.footY = Self.user.getFootY()
		
		Self.moveDistanceX = moveDistanceX
		Self.moveDistanceY = moveDistanceY
		
		Select (Self.actionState)
			Case DIRECTION_OFFSET_DOWN
				Self.totalDistance = totalVelocity
		End Select
		
		checkInMap()
	EndIf

	Public Method setMovedState:Void(state:Bool)
		Self.isMoved = state
	End

	Public Method getMovedState:Bool()
		Return Self.isMoved
	End

	Private Method checkInMap:Void()
		If (Self.moveDistanceX = 0 And Self.moveDistanceY = 0 And Not Self.isMoved) Then
			findTheFootPoint()
			Self.user.didAfterEveryMove(DIRECTION_OFFSET_DOWN, DIRECTION_OFFSET_DOWN)
		EndIf
		
		Repeat
			If (Self.moveDistanceX <> 0 Or Self.moveDistanceY <> 0 Or Self.isMoved) Then
				Self.footX = Self.user.getFootX()
				Self.footY = Self.user.getFootY()
				Self.footOffsetX = Self.footX - Self.acObj.posX
				Self.footOffsetY = Self.footY - Self.acObj.posY
				findTheFootPoint()
				Int preFootX = Self.footX
				Int preFootY = Self.footY
				Select (Self.actionState)
					Case DIRECTION_OFFSET_DOWN
						checkInGround()
						break
					Case DIRECTION_OFFSET_LEFT
						checkInSky()
						break
				End Select
				Self.acObj.posX = Self.footX - Self.footOffsetX
				Self.acObj.posY = Self.footY - Self.footOffsetY
				Self.user.didAfterEveryMove(Self.footX - preFootX, Self.footY - preFootY)
			Else
				Return
			EndIf
		Until (Not Self.isMoved)
	End

	Private Method checkInGround:Void()
		moveToNextPosition()
	End

	Private Method checkInSky:Void()
		Int newX
		Int degree
		Int plumbDegree
		Int landDegree = DIRECTION_OFFSET_DOWN
		Bool xFirst = Abs(Self.moveDistanceX) > Abs(Self.moveDistanceY)
		Int startPointX = Self.chkPointX
		Int startPointY = Self.chkPointY
		
		If (xFirst) Then
			If (Abs(Self.moveDistanceX) > Self.worldInstance.getTileWidth() - (DIRECTION_OFFSET_LEFT Shl Self.worldInstance.getZoom())) Then
				Self.chkPointX += (Self.moveDistanceX > 0 ? DIRECTION_OFFSET_LEFT : -1) * (Self.worldInstance.getTileWidth() - (DIRECTION_OFFSET_LEFT Shl Self.worldInstance.getZoom()))
				Self.chkPointY += (Self.moveDistanceY * (Self.worldInstance.getTileWidth() - (DIRECTION_OFFSET_LEFT Shl Self.worldInstance.getZoom()))) / Abs(Self.moveDistanceX)
			Else
				Self.chkPointX += Self.moveDistanceX
				Self.chkPointY += Self.moveDistanceY
			EndIf
			
		Else
			
			If (Abs(Self.moveDistanceY) > Self.worldInstance.getTileHeight() - (DIRECTION_OFFSET_LEFT Shl Self.worldInstance.getZoom())) Then
				Self.chkPointY += (Self.moveDistanceY > 0 ? DIRECTION_OFFSET_LEFT : -1) * (Self.worldInstance.getTileHeight() - (DIRECTION_OFFSET_LEFT Shl Self.worldInstance.getZoom()))
				Self.chkPointX += (Self.moveDistanceX * (Self.worldInstance.getTileHeight() - (DIRECTION_OFFSET_LEFT Shl Self.worldInstance.getZoom()))) / Abs(Self.moveDistanceY)
			Else
				Self.chkPointX += Self.moveDistanceX
				Self.chkPointY += Self.moveDistanceY
			EndIf
		EndIf
		
		calObjPositionFromFoot()
		Bool sideCollision = False
		Int sideOffset = DIRECTION_OFFSET_DOWN
		Int sideCollisionDirection = DIRECTION_OFFSET_LEFT
		Int sideCollisionDegree = DIRECTION_OFFSET_DOWN
		Int sideNewX = DIRECTION_OFFSET_DOWN
		Bool headCollision = False
		Int bodyOffset = DIRECTION_OFFSET_DOWN
		Int bodyNewY = DIRECTION_OFFSET_DOWN
		Int collisionDegree = DIRECTION_OFFSET_DOWN
		Int footChkPointID = DIRECTION_OFFSET_DOWN
		Int footChkDegree = DIRECTION_OFFSET_DOWN
		Bool footCollision = False
		Int skyDirection = getDirectionByDegree(Self.footDegree)
		Bool isVertical = skyDirection = DIRECTION_OFFSET_LEFT Or skyDirection = DIRECTION_OFFSET_RIGHT
		rightSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
		
		If (isVertical) Then
			newX = Self.collisionData.newPosY
		Else
			newX = Self.collisionData.newPosX
		EndIf
		
		If (newX <> NO_COLLISION) Then
			If (isVertical) Then
				sideOffset = Abs(newX - Self.footY)
			Else
				sideOffset = Abs(newX - Self.footX)
			EndIf
			
			sideCollision = True
			sideCollisionDirection = DIRECTION_OFFSET_LEFT
			sideCollisionDegree = getDegreeFromWorld((Self.footDegree + 270) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
			sideNewX = newX
		EndIf
		
		leftSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
		
		If (isVertical) Then
			newX = Self.collisionData.newPosY
		Else
			newX = Self.collisionData.newPosX
		EndIf
		
		If (newX <> NO_COLLISION) Then
			If (sideCollision) Then
				Int sideOffset2
				
				If (isVertical) Then
					sideOffset2 = Abs(newX - Self.footY)
				Else
					sideOffset2 = Abs(newX - Self.footX)
				EndIf
				
				Int totalVelocity = ACUtilities.getTotalFromDegree(Self.acObj.velX, Self.acObj.velY, Self.footDegree + 180)
				
				If (totalVelocity > 0 Or (totalVelocity = 0 And sideOffset2 < sideOffset)) Then
					sideOffset = sideOffset2
					sideCollisionDirection = DIRECTION_OFFSET_RIGHT
					sideCollisionDegree = getDegreeFromWorld((Self.footDegree + 90) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					sideNewX = newX
				EndIf
				
			Else
				
				If (isVertical) Then
					sideOffset = Abs(newX - Self.footY)
				Else
					sideOffset = Abs(newX - Self.footX)
				EndIf
				
				sideCollision = True
				sideCollisionDirection = DIRECTION_OFFSET_RIGHT
				sideCollisionDegree = getDegreeFromWorld((Self.footDegree + 90) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				sideNewX = newX
			EndIf
		EndIf
		
		upSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
		
		If (Not Self.collisionData.isNoCollision()) Then
			degree = getDegreeFromWorld((Self.footDegree + 180) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
			plumbDegree = (degree + 90) Mod MDPhone.SCREEN_WIDTH
			
			If (((Self.moveDistanceX * Cos(plumbDegree)) + (Self.moveDistanceY * Sin(plumbDegree))) / 100 > 0) Then
				If (sideCollision) Then
					If (isVertical) Then
						bodyOffset = Abs(Self.collisionData.newPosX - Self.footX)
						bodyNewY = Self.collisionData.newPosX
					Else
						bodyOffset = Abs(Self.collisionData.newPosY - Self.footY)
						bodyNewY = Self.collisionData.newPosY
					EndIf
					
					collisionDegree = degree
					headCollision = True
				Else
					
					If (isVertical) Then
						Self.footX = Self.collisionData.newPosX
					Else
						Self.footY = Self.collisionData.newPosY
					EndIf
					
					calChkPointFromPos()
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_DOWN, degree)
					Int tangentDistance = ((Self.moveDistanceX * Cos(degree)) + (Self.moveDistanceY * Sin(degree))) / 100
					Self.moveDistanceX = (Cos(degree) * tangentDistance) / 100
					Self.moveDistanceY = (Sin(degree) * tangentDistance) / 100
					Int tangentVel = ((Self.acObj.velX * Cos(degree)) + (Self.acObj.velY * Sin(degree))) / 100
					Self.acObj.velX = (Cos(degree) * tangentVel) / 100
					Self.acObj.velY = (Sin(degree) * tangentVel) / 100
				EndIf
			EndIf
		EndIf
		
		downSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
		
		If (Not Self.collisionData.isNoCollision()) Then
			degree = getDegreeFromWorld(Self.footDegree, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
			plumbDegree = (degree + 90) Mod MDPhone.SCREEN_WIDTH
			
			If (((Self.moveDistanceX * Cos(plumbDegree)) + (Self.moveDistanceY * Sin(plumbDegree))) / 100 > 0) Then
				If (sideCollision) Then
					If (isVertical) Then
						bodyOffset = Abs(Self.collisionData.newPosX - Self.footX)
						bodyNewY = Self.collisionData.newPosX
					Else
						bodyOffset = Abs(Self.collisionData.newPosY - Self.footY)
						bodyNewY = Self.collisionData.newPosY
					EndIf
					
					collisionDegree = degree
					footCollision = True
					footChkPointID = Self.collisionData.chkPointID
					footChkDegree = degree
				Else
					Self.actionState = (Byte) 0
					Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
					Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
					calChkPointFromPos()
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_UP, degree)
					landDegree = degree
				EndIf
			EndIf
		EndIf
		
		If ((footCollision Or headCollision) And sideCollision) Then
			If (sideOffset < bodyOffset) Then
				Self.user.doWhileTouchWorld(sideCollisionDirection, sideCollisionDegree)
				
				If (isVertical) Then
					Self.footY = sideNewX
					calChkPointFromPos()
					Self.moveDistanceY = DIRECTION_OFFSET_DOWN
					Self.acObj.velY = DIRECTION_OFFSET_DOWN
				ElseIf (canBeSideStop(sideCollisionDirection)) Then
					Self.footX = sideNewX
					calChkPointFromPos()
					Self.moveDistanceX = DIRECTION_OFFSET_DOWN
					Self.acObj.velX = DIRECTION_OFFSET_DOWN
				EndIf
				
				upSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
				
				If (Not Self.collisionData.isNoCollision()) Then
					degree = getDegreeFromWorld(Self.footDegree + 180, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					plumbDegree = (degree + 90) Mod MDPhone.SCREEN_WIDTH
					
					If (((Self.moveDistanceX * Cos(plumbDegree)) + (Self.moveDistanceY * Sin(plumbDegree))) / 100 > 0) Then
						If (isVertical) Then
							Self.footX = Self.collisionData.newPosX
						Else
							Self.footY = Self.collisionData.newPosY
						EndIf
						
						calChkPointFromPos()
						Self.user.doWhileTouchWorld(DIRECTION_OFFSET_DOWN, degree)
						tangentDistance = ((Self.moveDistanceX * Cos(degree)) + (Self.moveDistanceY * Sin(degree))) / 100
						Self.moveDistanceX = (Cos(degree) * tangentDistance) / 100
						Self.moveDistanceY = (Sin(degree) * tangentDistance) / 100
						tangentVel = ((Self.acObj.velX * Cos(degree)) + (Self.acObj.velY * Sin(degree))) / 100
						Self.acObj.velX = (Cos(degree) * tangentVel) / 100
						Self.acObj.velY = (Sin(degree) * tangentVel) / 100
					EndIf
				EndIf
				
				downSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
				
				If (Not Self.collisionData.isNoCollision()) Then
					degree = getDegreeFromWorld(Self.footDegree, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
					plumbDegree = (degree + 90) Mod MDPhone.SCREEN_WIDTH
					
					If (((Self.moveDistanceX * Cos(plumbDegree)) + (Self.moveDistanceY * Sin(plumbDegree))) / 100 > 0) Then
						Self.actionState = (Byte) 0
						Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
						Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
						calChkPointFromPos()
						Self.user.doWhileTouchWorld(DIRECTION_OFFSET_UP, degree)
						landDegree = degree
					EndIf
				EndIf
				
			Else
				
				If (footCollision) Then
					Self.actionState = (Byte) 0
					Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[footChkPointID], -Self.footCollisionPointOffsetY, footChkDegree)
					Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[footChkPointID], -Self.footCollisionPointOffsetY, footChkDegree)
					calChkPointFromPos()
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_UP, footChkDegree)
					landDegree = footChkDegree
				Else
					
					If (isVertical) Then
						Self.footX = bodyNewY
					Else
						Self.footY = bodyNewY
					EndIf
					
					calChkPointFromPos()
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_DOWN, collisionDegree)
					tangentDistance = ((Self.moveDistanceX * Cos(collisionDegree)) + (Self.moveDistanceY * Sin(collisionDegree))) / 100
					Self.moveDistanceX = (Cos(collisionDegree) * tangentDistance) / 100
					Self.moveDistanceY = (Sin(collisionDegree) * tangentDistance) / 100
					tangentVel = ((Self.acObj.velX * Cos(collisionDegree)) + (Self.acObj.velY * Sin(collisionDegree))) / 100
					Self.acObj.velX = (Cos(collisionDegree) * tangentVel) / 100
					Self.acObj.velY = (Sin(collisionDegree) * tangentVel) / 100
				EndIf
				
				rightSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
				
				If (isVertical) Then
					newX = Self.collisionData.newPosY
				Else
					newX = Self.collisionData.newPosX
				EndIf
				
				If (newX <> NO_COLLISION) Then
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_LEFT, getDegreeFromWorld((Self.footDegree + 270) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
					
					If (isVertical) Then
						Self.footY = newX
						Self.moveDistanceY = DIRECTION_OFFSET_DOWN
						Self.acObj.velY = DIRECTION_OFFSET_DOWN
					ElseIf (canBeSideStop(sideCollisionDirection)) Then
						Self.footX = newX
						Self.moveDistanceX = DIRECTION_OFFSET_DOWN
						Self.acObj.velX = DIRECTION_OFFSET_DOWN
					EndIf
					
					calChkPointFromPos()
				EndIf
				
				leftSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
				
				If (isVertical) Then
					newX = Self.collisionData.newPosY
				Else
					newX = Self.collisionData.newPosX
				EndIf
				
				If (newX <> NO_COLLISION) Then
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_RIGHT, getDegreeFromWorld((Self.footDegree + 90) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
					
					If (isVertical) Then
						Self.footY = newX
						Self.moveDistanceY = DIRECTION_OFFSET_DOWN
						Self.acObj.velY = DIRECTION_OFFSET_DOWN
					ElseIf (canBeSideStop(sideCollisionDirection)) Then
						Self.footX = newX
						Self.moveDistanceX = DIRECTION_OFFSET_DOWN
						Self.acObj.velX = DIRECTION_OFFSET_DOWN
					EndIf
					
					calChkPointFromPos()
				EndIf
			EndIf
			
		ElseIf (sideCollision) Then
			Self.user.doWhileTouchWorld(sideCollisionDirection, sideCollisionDegree)
			
			If (isVertical) Then
				Self.footY = sideNewX
				Self.moveDistanceY = DIRECTION_OFFSET_DOWN
				Self.acObj.velY = DIRECTION_OFFSET_DOWN
			ElseIf (canBeSideStop(sideCollisionDirection)) Then
				Self.footX = sideNewX
				Self.moveDistanceX = DIRECTION_OFFSET_DOWN
				Self.acObj.velX = DIRECTION_OFFSET_DOWN
			EndIf
			
			calChkPointFromPos()
			upSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
			
			If (Not Self.collisionData.isNoCollision()) Then
				degree = getDegreeFromWorld(Self.footDegree + 180, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				plumbDegree = (degree + 90) Mod MDPhone.SCREEN_WIDTH
				
				If (((Self.moveDistanceX * Cos(plumbDegree)) + (Self.moveDistanceY * Sin(plumbDegree))) / 100 > 0) Then
					If (isVertical) Then
						Self.footX = Self.collisionData.newPosX
					Else
						Self.footY = Self.collisionData.newPosY
					EndIf
					
					calChkPointFromPos()
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_DOWN, degree)
					tangentDistance = ((Self.moveDistanceX * Cos(degree)) + (Self.moveDistanceY * Sin(degree))) / 100
					Self.moveDistanceX = (Cos(degree) * tangentDistance) / 100
					Self.moveDistanceY = (Sin(degree) * tangentDistance) / 100
					tangentVel = ((Self.acObj.velX * Cos(degree)) + (Self.acObj.velY * Sin(degree))) / 100
					Self.acObj.velX = (Cos(degree) * tangentVel) / 100
					Self.acObj.velY = (Sin(degree) * tangentVel) / 100
				EndIf
			EndIf
			
			downSideCollisionChk(Self.footX, Self.footY, skyDirection, Self.collisionData)
			
			If (Not Self.collisionData.isNoCollision()) Then
				degree = getDegreeFromWorld(Self.footDegree, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				plumbDegree = (degree + 90) Mod MDPhone.SCREEN_WIDTH
				
				If (((Self.moveDistanceX * Cos(plumbDegree)) + (Self.moveDistanceY * Sin(plumbDegree))) / 100 > 0) Then
					Self.actionState = (Byte) 0
					Self.footX = ACUtilities.getRelativePointX(Self.collisionData.collisionX, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
					Self.footY = ACUtilities.getRelativePointY(Self.collisionData.collisionY, -Self.footCollisionPointOffsetX[Self.collisionData.chkPointID], -Self.footCollisionPointOffsetY, degree)
					calChkPointFromPos()
					Self.user.doWhileTouchWorld(DIRECTION_OFFSET_UP, degree)
					landDegree = degree
				EndIf
			EndIf
		EndIf
		
		Int preMoveDistanceX = Self.moveDistanceX
		Int preMoveDistanceY = Self.moveDistanceY
		
		If (Self.lastMoveDistanceX = 0) Then
			If (Self.chkPointX - startPointX = 0 And Self.lastMoveDistanceY = 0) Then
				If (Self.chkPointY - startPointY = 0) Then
					Self.lastMoveDistanceX = -9999
					Self.lastMoveDistanceY = -9999
					Self.moveDistanceX = DIRECTION_OFFSET_DOWN
					Self.moveDistanceY = DIRECTION_OFFSET_DOWN
					
					If (Self.moveDistanceX * preMoveDistanceX <= 0) Then
						Self.moveDistanceX = DIRECTION_OFFSET_DOWN
					EndIf
					
					If (Self.moveDistanceY * preMoveDistanceY <= 0) Then
						Self.moveDistanceY = DIRECTION_OFFSET_DOWN
					EndIf
					
					If (Self.actionState = Null) Then
						Self.totalDistance = ACUtilities.getTotalFromDegree(Self.moveDistanceX, Self.moveDistanceY, landDegree)
						Self.footDegree = landDegree
						Self.user.doWhileLand(Self.footDegree)
					EndIf
					
					calObjPositionFromFoot()
				EndIf
			EndIf
		EndIf
		
		Self.lastMoveDistanceX = Self.chkPointX - startPointX
		Self.lastMoveDistanceY = Self.chkPointY - startPointY
		Self.moveDistanceX -= Self.chkPointX - startPointX
		Self.moveDistanceY -= Self.chkPointY - startPointY
		
		If (Self.moveDistanceX * preMoveDistanceX <= 0) Then
			Self.moveDistanceX = DIRECTION_OFFSET_DOWN
		EndIf
		
		If (Self.moveDistanceY * preMoveDistanceY <= 0) Then
			Self.moveDistanceY = DIRECTION_OFFSET_DOWN
		EndIf
		
		If (Self.actionState = Null) Then
			Self.totalDistance = ACUtilities.getTotalFromDegree(Self.moveDistanceX, Self.moveDistanceY, landDegree)
			Self.footDegree = landDegree
			Self.user.doWhileLand(Self.footDegree)
		EndIf
		
		calObjPositionFromFoot()
	End

	/* JADX WARNING: inconsistent code. */
	/* Code decompiled incorrectly, please refer to instructions dump. */
	Private Method findTheFootPoint:Void()
		/*
		r21 = Self
		r0 = r21
		r0 = r0.actionState
		r15 = r0
		r16 = 1
		r0 = r15
		r1 = r16
		
		If (r0 <> r1) goto L_0x0094
	L_0x000c:
		r0 = r21
		r0 = r0.footX
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r21
		r0 = r0.footDegree
		r18 = r0
		r15 = com.sega.engine.action.ACUtilities.getRelativePointX(r15, r16, r17, r18)
		r0 = r15
		r1 = r21
		r1.chkPointX = r0
		r0 = r21
		r0 = r0.footY
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r21
		r0 = r0.footDegree
		r18 = r0
		r15 = com.sega.engine.action.ACUtilities.getRelativePointY(r15, r16, r17, r18)
		r0 = r15
		r1 = r21
		r1.chkPointY = r0
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointId = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointDegree = r0
		r0 = r21
		r0 = r0.chkPointX
		r15 = r0
		r0 = r21
		r0 = r0.chkPointY
		r16 = r0
		r0 = r21
		r0 = r0.chkPointId
		r17 = r0
		r0 = r21
		r0 = r0.chkPointDegree
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r0.calChkOffset(r1, r2, r3, r4)
	L_0x0093:
		Return
	L_0x0094:
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r21
		r1 = r15
		r7 = r0.getDirectionByDegree(r1)
		r11 = -1
		r5 = 0
		Select(r7)
			Case 0 goto L_0x00a6
			Case 1 goto L_0x036f
			Case 2 goto L_0x00a6
			Case 3 goto L_0x036f
			Default goto L_0x00a5
		EndIf
		
	L_0x00a5:
		goto L_0x0093
	L_0x00a6:
		r0 = r21
		r0 = r0.footDegree
		r5 = r0
		r10 = NO_COLLISION; // 0xfffffffffffffc18 Float:NaN double:NaN
		r11 = -1
		r8 = 0
	L_0x00af:
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r15 = r0
		r15 = r15.length
		
		If (r8 < r15) goto L_0x022a
	L_0x00b7:
		r15 = -1
		
		If (r11 = r15) goto L_0x02d8
	L_0x00ba:
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r15 = r0
		r15 = r15[r11]
		r0 = r15
		r1 = r21
		r1.chkPointX = r0
		r0 = r10
		r1 = r21
		r1.chkPointY = r0
		r0 = r11
		r1 = r21
		r1.chkPointId = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointDegree = r0
		r0 = r21
		r0 = r0.chkPointX
		r15 = r0
		r0 = r21
		r0 = r0.chkPointY
		r16 = r0
		r0 = r21
		r0 = r0.chkPointId
		r17 = r0
		r0 = r21
		r0 = r0.chkPointDegree
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r0.calChkOffset(r1, r2, r3, r4)
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r21
		r0 = r0.chkPointX
		r16 = r0
		r0 = r21
		r0 = r0.chkPointY
		r17 = r0
		r0 = r21
		r0 = r0.acObj
		r18 = r0
		r0 = r18
		r0 = r0.posZ
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r15 = r0.getDegreeFromWorld(r1, r2, r3, r4)
		r0 = r15
		r1 = r21
		r1.footDegree = r0
		r15 = 0
		r0 = r15
		r1 = r21
		r1.actionState = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r15 = r15 + 90
		r12 = r15 Mod 360
		r0 = r21
		r0 = r0.moveDistanceX
		r15 = r0
		r16 = com.sega.engine.lib.Cos(r12)
		r15 = r15 * r16
		r0 = r21
		r0 = r0.moveDistanceY
		r16 = r0
		r17 = com.sega.engine.lib.Sin(r12)
		r16 = r16 * r17
		r15 = r15 + r16
		r15 = r15 / 100
		r0 = r21
		r0 = r0.user
		r16 = r0
		r16 = r16.getPressToGround()
		r13 = r15 + r16
		r0 = r21
		r0 = r0.acObj
		r15 = r0
		r15 = r15.velY
		r0 = r21
		r0 = r0.acObj
		r16 = r0
		r0 = r16
		r0 = r0.velX
		r16 = r0
		r14 = com.sega.engine.lib.CrlFP32.actTanDegree(r15, r16)
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r21
		r1 = r15
		r2 = r14
		r6 = r0.getDegreeDiff(r1, r2)
		
		If (r13 >= 0) goto L_0x0093
	L_0x0188:
		r0 = r21
		r0 = r0.user
		r15 = r0
		r15 = r15.getMinDegreeToLeaveGround()
		
		If (r6 <= r15) goto L_0x0093
	L_0x0193:
		r0 = r21
		r0 = r0.user
		r15 = r0
		r15.doWhileLeaveGround()
		r0 = r21
		r0 = r0.footX
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointX(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointX = r0
		r0 = r21
		r0 = r0.footY
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointY(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointY = r0
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointId = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointDegree = r0
		r0 = r21
		r0 = r0.chkPointX
		r15 = r0
		r0 = r21
		r0 = r0.chkPointY
		r16 = r0
		r0 = r21
		r0 = r0.chkPointId
		r17 = r0
		r0 = r21
		r0 = r0.chkPointDegree
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r0.calChkOffset(r1, r2, r3, r4)
		r15 = 1
		r0 = r15
		r1 = r21
		r1.actionState = r0
		goto L_0x0093
	L_0x022a:
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r15 = r0
		r0 = r21
		r0 = r0.footX
		r16 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r17 = r0
		r17 = r17[r8]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r18 = r0
		r0 = r16
		r1 = r17
		r2 = r18
		r3 = r5
		r16 = com.sega.engine.action.ACUtilities.getRelativePointX(r0, r1, r2, r3)
		r15[r8] = r16
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r16 = r0
		r16 = r16[r8]
		r0 = r21
		r0 = r0.footY
		r17 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r18 = r0
		r18 = r18[r8]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r19 = r0
		r0 = r21
		r0 = r0.user
		r20 = r0
		r20 = r20.getPressToGround()
		r19 = r19 + r20
		r0 = r17
		r1 = r18
		r2 = r19
		r3 = r5
		r17 = com.sega.engine.action.ACUtilities.getRelativePointY(r0, r1, r2, r3)
		r0 = r21
		r1 = r16
		r2 = r17
		r3 = r7
		r16 = r0.getWorldY(r1, r2, r3)
		r15[r8] = r16
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r15 = r0
		r15 = r15[r8]
		r16 = NO_COLLISION; // 0xfffffffffffffc18 Float:NaN double:NaN
		r0 = r15
		r1 = r16
		
		If (r0 = r1) goto L_0x02d4
	L_0x02a3:
		r15 = NO_COLLISION; // 0xfffffffffffffc18 Float:NaN double:NaN
		
		If (r10 = r15) goto L_0x02c5
	L_0x02a7:
		
		If (r7 <> 0) goto L_0x02b2
	L_0x02a9:
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r15 = r0
		r15 = r15[r8]
		
		If (r15 < r10) goto L_0x02c5
	L_0x02b2:
		r15 = 2
		
		If (r7 <> r15) goto L_0x02be
	L_0x02b5:
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r15 = r0
		r15 = r15[r8]
		
		If (r15 > r10) goto L_0x02c5
	L_0x02be:
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		
		If (r8 <> r15) goto L_0x02d4
	L_0x02c5:
		r11 = r8
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r15 = r0
		r10 = r15[r8]
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		
		If (r8 = r15) goto L_0x00b7
	L_0x02d4:
		r8 = r8 + 1
		goto L_0x00af
	L_0x02d8:
		r0 = r21
		r0 = r0.user
		r15 = r0
		r15.doWhileLeaveGround()
		r0 = r21
		r0 = r0.footX
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointX(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointX = r0
		r0 = r21
		r0 = r0.footY
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointY(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointY = r0
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointId = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointDegree = r0
		r0 = r21
		r0 = r0.chkPointX
		r15 = r0
		r0 = r21
		r0 = r0.chkPointY
		r16 = r0
		r0 = r21
		r0 = r0.chkPointId
		r17 = r0
		r0 = r21
		r0 = r0.chkPointDegree
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r0.calChkOffset(r1, r2, r3, r4)
		r15 = 1
		r0 = r15
		r1 = r21
		r1.actionState = r0
		goto L_0x0093
	L_0x036f:
		r9 = NO_COLLISION; // 0xfffffffffffffc18 Float:NaN double:NaN
		r0 = r21
		r0 = r0.footDegree
		r5 = r0
		r11 = -1
		r0 = r21
		r0 = r0.checkArrayForShowX
		r15 = r0
		
		If (r15 <> 0) goto L_0x0398
	L_0x037e:
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r15 = r0
		r15 = r15.length
		r15 = New Int[r15]
		r0 = r15
		r1 = r21
		r1.checkArrayForShowX = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r15 = r0
		r15 = r15.length
		r15 = New Int[r15]
		r0 = r15
		r1 = r21
		r1.checkArrayForShowY = r0
	L_0x0398:
		r8 = 0
	L_0x0399:
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r15 = r0
		r15 = r15.length
		
		If (r8 < r15) goto L_0x050c
	L_0x03a1:
		r15 = -1
		
		If (r11 = r15) goto L_0x05fc
	L_0x03a4:
		r0 = r9
		r1 = r21
		r1.chkPointX = r0
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r15 = r0
		r15 = r15[r11]
		r0 = r15
		r1 = r21
		r1.chkPointY = r0
		r0 = r11
		r1 = r21
		r1.chkPointId = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointDegree = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r21
		r0 = r0.chkPointX
		r16 = r0
		r0 = r21
		r0 = r0.chkPointY
		r17 = r0
		r0 = r21
		r0 = r0.acObj
		r18 = r0
		r0 = r18
		r0 = r0.posZ
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r15 = r0.getDegreeFromWorld(r1, r2, r3, r4)
		r0 = r15
		r1 = r21
		r1.footDegree = r0
		r0 = r21
		r0 = r0.chkPointX
		r15 = r0
		r0 = r21
		r0 = r0.chkPointY
		r16 = r0
		r0 = r21
		r0 = r0.chkPointId
		r17 = r0
		r0 = r21
		r0 = r0.chkPointDegree
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r0.calChkOffset(r1, r2, r3, r4)
		r15 = 0
		r0 = r15
		r1 = r21
		r1.actionState = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r15 = r15 + 90
		r12 = r15 Mod 360
		r0 = r21
		r0 = r0.moveDistanceX
		r15 = r0
		r16 = com.sega.engine.lib.Cos(r12)
		r15 = r15 * r16
		r0 = r21
		r0 = r0.moveDistanceY
		r16 = r0
		r17 = com.sega.engine.lib.Sin(r12)
		r16 = r16 * r17
		r15 = r15 + r16
		r15 = r15 / 100
		r0 = r21
		r0 = r0.user
		r16 = r0
		r16 = r16.getPressToGround()
		r13 = r15 + r16
		r0 = r21
		r0 = r0.moveDistanceY
		r15 = r0
		r0 = r21
		r0 = r0.moveDistanceX
		r16 = r0
		r14 = com.sega.engine.lib.CrlFP32.actTanDegree(r15, r16)
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r21
		r1 = r15
		r2 = r14
		r6 = r0.getDegreeDiff(r1, r2)
		
		If (r13 >= 0) goto L_0x0093
	L_0x046a:
		r0 = r21
		r0 = r0.user
		r15 = r0
		r15 = r15.getMinDegreeToLeaveGround()
		
		If (r6 <= r15) goto L_0x0093
	L_0x0475:
		r0 = r21
		r0 = r0.user
		r15 = r0
		r15.doWhileLeaveGround()
		r0 = r21
		r0 = r0.footX
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointX(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointX = r0
		r0 = r21
		r0 = r0.footY
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointY(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointY = r0
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointId = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointDegree = r0
		r0 = r21
		r0 = r0.chkPointX
		r15 = r0
		r0 = r21
		r0 = r0.chkPointY
		r16 = r0
		r0 = r21
		r0 = r0.chkPointId
		r17 = r0
		r0 = r21
		r0 = r0.chkPointDegree
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r0.calChkOffset(r1, r2, r3, r4)
		r15 = 1
		r0 = r15
		r1 = r21
		r1.actionState = r0
		goto L_0x0093
	L_0x050c:
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r15 = r0
		r0 = r21
		r0 = r0.footY
		r16 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r17 = r0
		r17 = r17[r8]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r18 = r0
		r0 = r16
		r1 = r17
		r2 = r18
		r3 = r5
		r16 = com.sega.engine.action.ACUtilities.getRelativePointY(r0, r1, r2, r3)
		r15[r8] = r16
		r0 = r21
		r0 = r0.checkArrayForShowX
		r15 = r0
		r0 = r21
		r0 = r0.footX
		r16 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r17 = r0
		r17 = r17[r8]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r18 = r0
		r0 = r21
		r0 = r0.user
		r19 = r0
		r19 = r19.getPressToGround()
		r18 = r18 + r19
		r0 = r16
		r1 = r17
		r2 = r18
		r3 = r5
		r16 = com.sega.engine.action.ACUtilities.getRelativePointX(r0, r1, r2, r3)
		r15[r8] = r16
		r0 = r21
		r0 = r0.checkArrayForShowY
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r16 = r0
		r16 = r16[r8]
		r15[r8] = r16
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r15 = r0
		r0 = r21
		r0 = r0.footX
		r16 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r17 = r0
		r17 = r17[r8]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r18 = r0
		r0 = r21
		r0 = r0.user
		r19 = r0
		r19 = r19.getPressToGround()
		r18 = r18 + r19
		r0 = r16
		r1 = r17
		r2 = r18
		r3 = r5
		r16 = com.sega.engine.action.ACUtilities.getRelativePointX(r0, r1, r2, r3)
		r0 = r21
		r0 = r0.footCollisionPointResaultY
		r17 = r0
		r17 = r17[r8]
		r0 = r21
		r1 = r16
		r2 = r17
		r3 = r7
		r16 = r0.getWorldX(r1, r2, r3)
		r15[r8] = r16
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r15 = r0
		r15 = r15[r8]
		r16 = NO_COLLISION; // 0xfffffffffffffc18 Float:NaN double:NaN
		r0 = r15
		r1 = r16
		
		If (r0 = r1) goto L_0x05f8
	L_0x05c6:
		r15 = NO_COLLISION; // 0xfffffffffffffc18 Float:NaN double:NaN
		
		If (r9 = r15) goto L_0x05e9
	L_0x05ca:
		r15 = 1
		
		If (r7 <> r15) goto L_0x05d6
	L_0x05cd:
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r15 = r0
		r15 = r15[r8]
		
		If (r15 > r9) goto L_0x05e9
	L_0x05d6:
		r15 = 3
		
		If (r7 <> r15) goto L_0x05e2
	L_0x05d9:
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r15 = r0
		r15 = r15[r8]
		
		If (r15 < r9) goto L_0x05e9
	L_0x05e2:
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		
		If (r8 <> r15) goto L_0x05f8
	L_0x05e9:
		r11 = r8
		r0 = r21
		r0 = r0.footCollisionPointResaultX
		r15 = r0
		r9 = r15[r8]
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		
		If (r8 = r15) goto L_0x03a1
	L_0x05f8:
		r8 = r8 + 1
		goto L_0x0399
	L_0x05fc:
		r0 = r21
		r0 = r0.user
		r15 = r0
		r15.doWhileLeaveGround()
		r0 = r21
		r0 = r0.footX
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointX(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointX = r0
		r0 = r21
		r0 = r0.footY
		r15 = r0
		r0 = r21
		r0 = r0.footCollisionPointOffsetX
		r16 = r0
		r0 = r21
		r0 = r0.priorityChkId
		r17 = r0
		r16 = r16[r17]
		r0 = r21
		r0 = r0.footCollisionPointOffsetY
		r17 = r0
		r0 = r15
		r1 = r16
		r2 = r17
		r3 = r5
		r15 = com.sega.engine.action.ACUtilities.getRelativePointY(r0, r1, r2, r3)
		r0 = r15
		r1 = r21
		r1.chkPointY = r0
		r0 = r21
		r0 = r0.priorityChkId
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointId = r0
		r0 = r21
		r0 = r0.footDegree
		r15 = r0
		r0 = r15
		r1 = r21
		r1.chkPointDegree = r0
		r0 = r21
		r0 = r0.chkPointX
		r15 = r0
		r0 = r21
		r0 = r0.chkPointY
		r16 = r0
		r0 = r21
		r0 = r0.chkPointId
		r17 = r0
		r0 = r21
		r0 = r0.chkPointDegree
		r18 = r0
		r0 = r21
		r1 = r15
		r2 = r16
		r3 = r17
		r4 = r18
		r0.calChkOffset(r1, r2, r3, r4)
		r15 = 1
		r0 = r15
		r1 = r21
		r1.actionState = r0
		goto L_0x0093
		*/
		throw New UnsupportedOperationException("Method not decompiled: com.sega.engine.action.ACWorldCollisionCalculator.findTheFootPoint():Void")
	End

	Private Method moveToNextPosition:Void()
		Int newY
		Int newX
		Int currentBlockX = ACUtilities.getQuaParam(Self.chkPointX, Self.worldInstance.getTileWidth())
		Int currentBlockY = ACUtilities.getQuaParam(Self.chkPointY, Self.worldInstance.getTileHeight())
		Self.worldInstance.getCollisionBlock(Self.getBlock, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
		Int preDegree = Self.user.getBodyDegree()
		Int startPointX = Self.chkPointX
		Int startPointY = Self.chkPointY
		Self.moveDistanceX = (Self.totalDistance * Cos(Self.user.getBodyDegree())) / 100
		Self.moveDistanceY = (Self.totalDistance * Sin(Self.user.getBodyDegree())) / 100
		Int direction = getDirectionByDegree(Self.user.getBodyDegree())
		Int preFootDegree
		
		If (direction = 0 Or direction = DIRECTION_OFFSET_UP) Then
			If (direction = DIRECTION_OFFSET_UP) Then
				Bool moveReverse = True
			Else
				Object obj = DIRECTION_OFFSET_DOWN
			EndIf
			
			Int preCheckX = Self.chkPointX
			
			If (Self.moveDistanceX = 0) Then
				Self.moveDistanceY = DIRECTION_OFFSET_DOWN
			ElseIf (Self.moveDistanceX > 0) Then
				If (Self.chkPointX + Self.moveDistanceX >= getBlockLeftSide(currentBlockX + DIRECTION_OFFSET_LEFT, currentBlockY)) Then
					Self.chkPointX = getBlockLeftSide(currentBlockX + DIRECTION_OFFSET_LEFT, currentBlockY)
				Else
					Self.chkPointX += Self.moveDistanceX
				EndIf
				
			Else
				
				If (Self.chkPointX + Self.moveDistanceX <= getBlockRightSide(currentBlockX - DIRECTION_OFFSET_LEFT, currentBlockY)) Then
					Self.chkPointX = getBlockRightSide(currentBlockX - 1, currentBlockY)
				Else
					Self.chkPointX += Self.moveDistanceX
				EndIf
			EndIf
			
			calObjPositionFromFoot()
			doSideCheckInGround(direction)
			calChkPointFromPos()
			preFootDegree = Self.footDegree
			newY = getWorldY(Self.chkPointX, Self.chkPointY + ((direction = 0 ? DIRECTION_OFFSET_LEFT : -1) * (Abs(Self.chkPointX - startPointX) + Self.user.getPressToGround())), direction)
			
			If (newY <> NO_COLLISION) Then
				Self.chkPointY = newY
				Self.footDegree = getDegreeFromWorld(Self.footDegree, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
			EndIf
			
			calObjPositionFromFoot()
			
			If (direction = getDirectionByDegree(Self.footDegree)) Then
				doSideCheckInGround(direction)
				calChkPointFromPos()
			EndIf
			
			Self.footDegree = preFootDegree
			newY = getWorldY(Self.chkPointX, Self.chkPointY + ((direction = 0 ? DIRECTION_OFFSET_LEFT : -1) * (Abs(Self.chkPointX - startPointX) + Self.user.getPressToGround())), direction)
			
			If (newY <> NO_COLLISION) Then
				Self.chkPointY = newY
			EndIf
			
		Else
			
			If (Self.moveDistanceY = 0) Then
				Self.moveDistanceX = DIRECTION_OFFSET_DOWN
			ElseIf (Self.moveDistanceY > 0) Then
				If (Self.chkPointY + Self.moveDistanceY >= getBlockUpSide(currentBlockX, currentBlockY + DIRECTION_OFFSET_LEFT)) Then
					Self.chkPointY = getBlockUpSide(currentBlockX, currentBlockY + DIRECTION_OFFSET_LEFT)
				Else
					Self.chkPointY += Self.moveDistanceY
				EndIf
				
			Else
				
				If (Self.chkPointY + Self.moveDistanceY <= getBlockDownSide(currentBlockX, currentBlockY - DIRECTION_OFFSET_LEFT)) Then
					Self.chkPointY = getBlockDownSide(currentBlockX, currentBlockY - 1)
				Else
					Self.chkPointY += Self.moveDistanceY
				EndIf
			EndIf
			
			preFootDegree = Self.footDegree
			newX = getWorldX(Self.chkPointX + ((direction = DIRECTION_OFFSET_RIGHT ? DIRECTION_OFFSET_LEFT : -1) * (Abs(Self.chkPointY - startPointY) + Self.user.getPressToGround())), Self.chkPointY, direction)
			
			If (newX <> NO_COLLISION) Then
				Self.chkPointX = newX
				Self.footDegree = getDegreeFromWorld(Self.footDegree, Self.chkPointX, Self.chkPointY, Self.acObj.posZ)
			EndIf
			
			calObjPositionFromFoot()
			
			If (direction = getDirectionByDegree(Self.footDegree)) Then
				If (Self.moveDistanceY > 0) Then
					If (direction = DIRECTION_OFFSET_LEFT) Then
						rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
						newY = Self.collisionData.newPosY
					Else
						leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
						newY = Self.collisionData.newPosY
					EndIf
					
					If (newY <> NO_COLLISION) Then
						Self.footY = newY
						calChkPointFromPos()
						Self.user.doWhileTouchWorld(direction = DIRECTION_OFFSET_LEFT ? DIRECTION_OFFSET_LEFT : DIRECTION_OFFSET_RIGHT, getDegreeFromWorld((Self.footDegree + (direction = DIRECTION_OFFSET_LEFT ? 270 : 90)) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
						Self.moveDistanceY = DIRECTION_OFFSET_DOWN
						Self.acObj.velY = DIRECTION_OFFSET_DOWN
					EndIf
					
				ElseIf (Self.moveDistanceY < 0) Then
					If (direction = DIRECTION_OFFSET_LEFT) Then
						leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
						newY = Self.collisionData.newPosY
					Else
						rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
						newY = Self.collisionData.newPosY
					EndIf
					
					If (newY <> NO_COLLISION) Then
						Self.footY = newY
						calChkPointFromPos()
						Self.user.doWhileTouchWorld(direction = DIRECTION_OFFSET_LEFT ? DIRECTION_OFFSET_RIGHT : DIRECTION_OFFSET_LEFT, getDegreeFromWorld((Self.footDegree + (direction = DIRECTION_OFFSET_LEFT ? 90 : 270)) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ))
						Self.moveDistanceY = DIRECTION_OFFSET_DOWN
						Self.acObj.velY = DIRECTION_OFFSET_DOWN
					EndIf
				EndIf
			EndIf
			
			Self.footDegree = preFootDegree
			newX = getWorldX(Self.chkPointX + ((direction = DIRECTION_OFFSET_RIGHT ? DIRECTION_OFFSET_LEFT : -1) * (Abs(Self.chkPointY - startPointY) + Self.user.getPressToGround())), Self.chkPointY, direction)
			
			If (newX <> NO_COLLISION) Then
				Self.chkPointX = newX
			EndIf
		EndIf
		
		calObjPositionFromFoot()
		Select (getDirectionByDegree(Self.footDegree))
			Case DIRECTION_OFFSET_DOWN
				newY = getWorldY(Self.footX, Self.footY + Self.worldInstance.getTileHeight(), DIRECTION_OFFSET_DOWN)
				
				If (newY <> NO_COLLISION) Then
					Self.footY = newY
					break
				EndIf
				
				break
			Case DIRECTION_OFFSET_LEFT
				newX = getWorldX(Self.footX - Self.worldInstance.getTileHeight(), Self.footY, DIRECTION_OFFSET_LEFT)
				
				If (newX <> NO_COLLISION) Then
					Self.footX = newX
					break
				EndIf
				
				break
			Case DIRECTION_OFFSET_UP
				newY = getWorldY(Self.footX, Self.footY - Self.worldInstance.getTileHeight(), DIRECTION_OFFSET_UP)
				
				If (newY <> NO_COLLISION) Then
					Self.footY = newY
					break
				EndIf
				
				break
			Case DIRECTION_OFFSET_RIGHT
				newX = getWorldX(Self.footX + Self.worldInstance.getTileHeight(), Self.footY, DIRECTION_OFFSET_RIGHT)
				
				If (newX <> NO_COLLISION) Then
					Self.footX = newX
					break
				EndIf
				
				break
		EndIf
		Int preMoveDistanceX = Self.moveDistanceX
		Int preMoveDistanceY = Self.moveDistanceY
		Self.moveDistanceX -= Self.chkPointX - startPointX
		Self.moveDistanceY -= Self.chkPointY - startPointY
		
		If (Self.totalDistance * (((Self.moveDistanceX * Cos(Self.user.getBodyDegree())) + (Self.moveDistanceY * Sin(Self.user.getBodyDegree()))) / 100) <= 0) Then
			Self.moveDistanceX = DIRECTION_OFFSET_DOWN
			Self.moveDistanceY = DIRECTION_OFFSET_DOWN
		EndIf
		
		Self.totalDistance = ((Self.moveDistanceX * Cos(Self.user.getBodyDegree())) + (Self.moveDistanceY * Sin(Self.user.getBodyDegree()))) / 100
	End

	Public Method getDirectionByDegree:Int(degree:Int)
		While (degree < 0) {
			degree += MDPhone.SCREEN_WIDTH
		EndIf
		degree Mod= MDPhone.SCREEN_WIDTH
		
		If (degree > 315 Or degree < 45) Then
			Return DIRECTION_OFFSET_DOWN
		EndIf
		
		If (degree >= 225 And degree <= 315) Then
			Return DIRECTION_OFFSET_RIGHT
		EndIf
		
		If (degree <= StringIndex.FONT_COLON_RED Or degree >= 225) Then
			Return DIRECTION_OFFSET_LEFT
		EndIf
		
		Return DIRECTION_OFFSET_UP
	End

	Private Method getWorldY:Int(x:Int, y:Int, direction:Int)
		Return Self.worldInstance.getWorldY(x, y, Self.acObj.posZ, direction)
	End

	Private Method getWorldX:Int(x:Int, y:Int, direction:Int)
		Return Self.worldInstance.getWorldX(x, y, Self.acObj.posZ, direction)
	End

	Private Method rightSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
		Int collisionPointId
		Int maxDiff
		Int i
		Int objX
		Int objY
		Int diff
		collisionData.reset()
		
		If (Self.limit <> Null) Then
			If (Self.limit.noSideCollision()) Then
				Return
			EndIf
		EndIf
		
		Select (direction)
			Case DIRECTION_OFFSET_DOWN
			Case DIRECTION_OFFSET_UP
				Int maxBlockPixX = ACParam.NO_COLLISION
				collisionPointId = -1
				maxDiff = -1
				i = DIRECTION_OFFSET_DOWN
				While (True) {
					
					If (i >= Self.bodyCollisionPointOffsetY.length) Then
						If (maxBlockPixX <> ACParam.NO_COLLISION) Then
							collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, -Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
							Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
							collisionData.reBlock = Self.getBlock
							break
						EndIf
					EndIf
					
					objX = ACUtilities.getRelativePointX(x, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					objY = ACUtilities.getRelativePointY(y, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					Int blockPixX = getWorldX(objX, objY, (direction + DIRECTION_OFFSET_RIGHT) Mod 4)
					
					If (blockPixX <> ACParam.NO_COLLISION) Then
						diff = Abs(blockPixX - objX)
						
						If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff) Then
							maxBlockPixX = blockPixX
							collisionPointId = i
							maxDiff = diff
							collisionData.collisionX = maxBlockPixX
							collisionData.collisionY = objY
							collisionData.newPosY = y
						EndIf
					EndIf
					
					i += DIRECTION_OFFSET_LEFT
				EndIf
				break
		EndIf
		Int maxBlockPixY = ACParam.NO_COLLISION
		collisionPointId = -1
		maxDiff = -1
		i = DIRECTION_OFFSET_DOWN
		While (True) {
			
			If (i < Self.bodyCollisionPointOffsetY.length) Then
				objX = ACUtilities.getRelativePointX(x, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
				objY = ACUtilities.getRelativePointY(y, Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
				Int blockPixY = getWorldY(objX, objY, (direction + DIRECTION_OFFSET_RIGHT) Mod 4)
				
				If (blockPixY <> ACParam.NO_COLLISION) Then
					diff = Abs(blockPixY - objY)
					
					If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff) Then
						maxBlockPixY = blockPixY
						collisionPointId = i
						maxDiff = diff
						collisionData.collisionX = maxBlockPixY
						collisionData.collisionY = objX
						collisionData.newPosX = x
					EndIf
				EndIf
				
				i += DIRECTION_OFFSET_LEFT
			ElseIf (maxBlockPixY <> ACParam.NO_COLLISION) Then
				collisionData.newPosY = ACUtilities.getRelativePointY(maxBlockPixY, -Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
				Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
				collisionData.reBlock = Self.getBlock
				Return
			Else
				Return
			EndIf
		EndIf
	End

	Private Method leftSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
		Int collisionPointId
		Int maxDiff
		Int i
		Int objX
		Int objY
		Int diff
		collisionData.reset()
		
		If (Self.limit <> Null) Then
			If (Self.limit.noSideCollision()) Then
				Return
			EndIf
		EndIf
		
		Select (direction)
			Case DIRECTION_OFFSET_DOWN
			Case DIRECTION_OFFSET_UP
				Int maxBlockPixX = ACParam.NO_COLLISION
				collisionPointId = -1
				maxDiff = -1
				i = DIRECTION_OFFSET_DOWN
				While (True) {
					
					If (i >= Self.bodyCollisionPointOffsetY.length) Then
						If (maxBlockPixX <> ACParam.NO_COLLISION) Then
							collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
							Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
							collisionData.reBlock = Self.getBlock
							break
						EndIf
					EndIf
					
					objX = ACUtilities.getRelativePointX(x, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					objY = ACUtilities.getRelativePointY(y, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
					Int blockPixX = getWorldX(objX, objY, (direction + DIRECTION_OFFSET_LEFT) Mod 4)
					
					If (blockPixX <> ACParam.NO_COLLISION) Then
						diff = Abs(blockPixX - objX)
						
						If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff) Then
							maxBlockPixX = blockPixX
							collisionPointId = i
							maxDiff = diff
							collisionData.collisionX = maxBlockPixX
							collisionData.collisionY = objY
							collisionData.newPosY = y
						EndIf
					EndIf
					
					i += DIRECTION_OFFSET_LEFT
				EndIf
				break
		EndIf
		Int maxBlockPixY = ACParam.NO_COLLISION
		collisionPointId = -1
		maxDiff = -1
		i = DIRECTION_OFFSET_DOWN
		While (True) {
			
			If (i < Self.bodyCollisionPointOffsetY.length) Then
				objX = ACUtilities.getRelativePointX(x, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
				objY = ACUtilities.getRelativePointY(y, -Self.bodyCollisionPointOffsetX, Self.bodyCollisionPointOffsetY[i], Self.user.getBodyDegree())
				Int blockPixY = getWorldY(objX, objY, (direction + DIRECTION_OFFSET_LEFT) Mod 4)
				
				If (blockPixY <> ACParam.NO_COLLISION) Then
					diff = Abs(blockPixY - objY)
					
					If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff) Then
						maxBlockPixY = blockPixY
						collisionPointId = i
						maxDiff -= diff
						collisionData.collisionX = objX
						collisionData.collisionY = maxBlockPixY
						collisionData.newPosX = x
					EndIf
				EndIf
				
				i += DIRECTION_OFFSET_LEFT
			ElseIf (maxBlockPixY <> ACParam.NO_COLLISION) Then
				collisionData.newPosX = ACUtilities.getRelativePointY(maxBlockPixY, Self.bodyCollisionPointOffsetX, -Self.bodyCollisionPointOffsetY[collisionPointId], Self.user.getBodyDegree())
				Self.worldInstance.getCollisionBlock(Self.getBlock, collisionData.collisionX, collisionData.collisionY, Self.acObj.posZ)
				collisionData.reBlock = Self.getBlock
				Return
			Else
				Return
			EndIf
		EndIf
	End

	Private Method upSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
		collisionData.reset()
		
		If (Self.limit <> Null) Then
			If (Self.limit.noTopCollision()) Then
				Return
			EndIf
		EndIf
		
		Int maxDiff
		Int collisionPointId
		Int i
		Int objX
		Int objY
		Int diff
		Select (direction)
			Case DIRECTION_OFFSET_DOWN
			Case DIRECTION_OFFSET_UP
				Int maxBlockPixY = ACParam.NO_COLLISION
				maxDiff = -1
				collisionPointId = -1
				i = DIRECTION_OFFSET_DOWN
				While (True) {
					
					If (i < Self.headCollisionPointOffsetX.length) Then
						objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree)
						objY = ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree)
						Int blockPixY = getWorldY(objX, objY, (direction + DIRECTION_OFFSET_UP) Mod 4)
						
						If (blockPixY <> ACParam.NO_COLLISION) Then
							diff = Abs(objY - blockPixY)
							
							If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff) Then
								maxBlockPixY = blockPixY
								collisionPointId = i
								maxDiff = diff
							EndIf
						EndIf
						
						i += DIRECTION_OFFSET_LEFT
					ElseIf (maxBlockPixY <> ACParam.NO_COLLISION) Then
						objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
						objY = ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
						Self.worldInstance.getCollisionBlock(Self.getBlock, objX, maxBlockPixY, Self.acObj.posZ)
						collisionData.collisionX = objX
						collisionData.collisionY = maxBlockPixY
						collisionData.newPosX = x
						collisionData.newPosY = ACUtilities.getRelativePointY(maxBlockPixY, -Self.headCollisionPointOffsetX[collisionPointId], -Self.headCollisionPointOffsetY, Self.footDegree)
						collisionData.reBlock = Self.getBlock
						Return
					Else
						Return
					EndIf
				EndIf
				break
			Default
				Int maxBlockPixX = ACParam.NO_COLLISION
				maxDiff = -1
				collisionPointId = -1
				i = DIRECTION_OFFSET_DOWN
				While (True) {
					
					If (i < Self.headCollisionPointOffsetX.length) Then
						objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree)
						Int blockPixX = getWorldX(objX, ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[i], Self.headCollisionPointOffsetY, Self.footDegree), (direction + DIRECTION_OFFSET_UP) Mod 4)
						
						If (blockPixX <> ACParam.NO_COLLISION) Then
							diff = Abs(objX - blockPixX)
							
							If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff) Then
								maxBlockPixX = blockPixX
								collisionPointId = i
								maxDiff = diff
							EndIf
						EndIf
						
						i += DIRECTION_OFFSET_LEFT
					ElseIf (maxBlockPixX <> ACParam.NO_COLLISION) Then
						objX = ACUtilities.getRelativePointX(x, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
						objY = ACUtilities.getRelativePointY(y, Self.headCollisionPointOffsetX[collisionPointId], Self.headCollisionPointOffsetY, Self.footDegree)
						Self.worldInstance.getCollisionBlock(Self.getBlock, maxBlockPixX, objY, Self.acObj.posZ)
						collisionData.collisionX = maxBlockPixX
						collisionData.collisionY = objY
						collisionData.newPosY = y
						collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, -Self.headCollisionPointOffsetX[collisionPointId], -Self.headCollisionPointOffsetY, Self.footDegree)
						collisionData.reBlock = Self.getBlock
						Return
					Else
						Return
					EndIf
				EndIf
				break
		EndIf
	End

	Private Method downSideCollisionChk:Void(x:Int, y:Int, direction:Int, collisionData:ACCollisionData)
		collisionData.reset()
		
		If (Self.limit <> Null) Then
			If (Self.limit.noDownCollision()) Then
				Return
			EndIf
		EndIf
		
		Int collisionPointId = -1
		Int maxDiff = -1
		Int i
		Int objX
		Int objY
		Int diff
		Select (direction)
			Case DIRECTION_OFFSET_DOWN
			Case DIRECTION_OFFSET_UP
				Int maxBlockPixY = ACParam.NO_COLLISION
				i = DIRECTION_OFFSET_DOWN
				While (True) {
					
					If (i < Self.footCollisionPointOffsetX.length) Then
						objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree)
						objY = ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree)
						Int blockPixY = getWorldY(objX, objY, (direction + DIRECTION_OFFSET_DOWN) Mod 4)
						
						If (blockPixY <> ACParam.NO_COLLISION) Then
							diff = Abs(objY - blockPixY)
							
							If (maxBlockPixY = ACParam.NO_COLLISION Or diff > maxDiff Or i = Self.priorityChkId) Then
								maxBlockPixY = blockPixY
								collisionPointId = i
								maxDiff = diff
								
								If (i <> Self.priorityChkId) Then
								EndIf
							EndIf
						EndIf
						
						i += DIRECTION_OFFSET_LEFT
					EndIf
					
					If (maxBlockPixY <> ACParam.NO_COLLISION) Then
						objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
						objY = ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
						Self.worldInstance.getCollisionBlock(Self.getBlock, objX, maxBlockPixY, Self.acObj.posZ)
						collisionData.collisionX = objX
						collisionData.collisionY = maxBlockPixY
						collisionData.newPosX = x
						collisionData.newPosY = ACUtilities.getRelativePointY(maxBlockPixY, -Self.footCollisionPointOffsetX[collisionPointId], -Self.footCollisionPointOffsetY, Self.footDegree)
						collisionData.reBlock = Self.getBlock
						collisionData.chkPointID = collisionPointId
						Return
					EndIf
					
					Return
				EndIf
			Default
				Int maxBlockPixX = ACParam.NO_COLLISION
				i = DIRECTION_OFFSET_DOWN
				While (True) {
					
					If (i < Self.footCollisionPointOffsetX.length) Then
						objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree)
						Int blockPixX = getWorldX(objX, ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[i], Self.footCollisionPointOffsetY, Self.footDegree), (direction + DIRECTION_OFFSET_DOWN) Mod 4)
						
						If (blockPixX <> ACParam.NO_COLLISION) Then
							diff = Abs(objX - blockPixX)
							
							If (maxBlockPixX = ACParam.NO_COLLISION Or diff > maxDiff Or i = Self.priorityChkId) Then
								maxBlockPixX = blockPixX
								collisionPointId = i
								maxDiff = diff
								
								If (i <> Self.priorityChkId) Then
								EndIf
							EndIf
						EndIf
						
						i += DIRECTION_OFFSET_LEFT
					EndIf
					
					If (maxBlockPixX <> ACParam.NO_COLLISION) Then
						objX = ACUtilities.getRelativePointX(x, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
						objY = ACUtilities.getRelativePointY(y, Self.footCollisionPointOffsetX[collisionPointId], Self.footCollisionPointOffsetY, Self.footDegree)
						Self.worldInstance.getCollisionBlock(Self.getBlock, maxBlockPixX, objY, Self.acObj.posZ)
						collisionData.collisionX = maxBlockPixX
						collisionData.collisionY = objY
						collisionData.newPosY = y
						collisionData.newPosX = ACUtilities.getRelativePointX(maxBlockPixX, -Self.footCollisionPointOffsetX[collisionPointId], -Self.footCollisionPointOffsetY, Self.footDegree)
						collisionData.reBlock = Self.getBlock
						collisionData.chkPointID = collisionPointId
						Return
					EndIf
					
					Return
				EndIf
		EndIf
	End

	Private Method getBlockLeftSide:Int(blockX:Int, blockY:Int)
		Return (blockX + DIRECTION_OFFSET_DOWN) * Self.worldInstance.getTileWidth()
	End

	Private Method getBlockRightSide:Int(blockX:Int, blockY:Int)
		Return ((blockX + DIRECTION_OFFSET_LEFT) * Self.worldInstance.getTileWidth()) - DIRECTION_OFFSET_LEFT
	End

	Private Method getBlockUpSide:Int(blockX:Int, blockY:Int)
		Return (blockY + DIRECTION_OFFSET_DOWN) * Self.worldInstance.getTileHeight()
	End

	Private Method getBlockDownSide:Int(blockX:Int, blockY:Int)
		Return ((blockY + DIRECTION_OFFSET_LEFT) * Self.worldInstance.getTileHeight()) - DIRECTION_OFFSET_LEFT
	End

	Private Method calObjPositionFromFoot:Void()
		Self.footX = Self.chkPointX - Self.chkOffsetX
		Self.footY = Self.chkPointY - Self.chkOffsetY
	End

	Private Method calChkPointFromPos:Void()
		Self.chkPointX = Self.footX + Self.chkOffsetX
		Self.chkPointY = Self.footY + Self.chkOffsetY
	End

	Private Method calChkOffset:Void(chkPointX:Int, chkPointY:Int, chkPointId:Int, degree:Int)
		Int footX = ACUtilities.getRelativePointX(chkPointX, -Self.footCollisionPointOffsetX[chkPointId], -Self.footCollisionPointOffsetY, degree)
		Int footY = ACUtilities.getRelativePointY(chkPointY, -Self.footCollisionPointOffsetX[chkPointId], -Self.footCollisionPointOffsetY, degree)
		Self.chkOffsetX = chkPointX - footX
		Self.chkOffsetY = chkPointY - footY
	End

	Public Method getActionState:Byte()
		Return Self.actionState
	End

	Private Method getDegreeFromWorld:Int(currentDegree:Int, x:Int, y:Int, z:Int)
		While (currentDegree < 0) {
			currentDegree += MDPhone.SCREEN_WIDTH
		EndIf
		currentDegree Mod= MDPhone.SCREEN_WIDTH
		
		If (Self.degreeGetter = Null) Then
			Return currentDegree
		EndIf
		
		Self.degreeGetter.getDegreeFromWorldByPosition(Self.degreeRe, currentDegree, x, y, z)
		Return Self.degreeRe.degree
	End

	Public Method getDegreeDiff:Int(degree1:Int, degree2:Int)
		Int re = Abs(degree1 - degree2)
		
		If (re > 180) Then
			re = MDPhone.SCREEN_WIDTH - re
		EndIf
		
		If (re > 90) Then
			Return 180 - re
		EndIf
		
		Return re
	End

	Private Method doSideCheckInGround:Void(direction:Int)
		Int newX
		Int i
		Int degree
		ACWorldCalUser aCWorldCalUser
		
		If (Self.moveDistanceX > 0) Then
			If (direction = 0) Then
				rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
				newX = Self.collisionData.newPosX
			Else
				leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
				newX = Self.collisionData.newPosX
			EndIf
			
			If (newX <> ACParam.NO_COLLISION) Then
				Self.footX = newX
				calChkPointFromPos()
				Int i2 = Self.footDegree
				
				If (direction = 0) Then
					i = 270
				Else
					i = 90
				EndIf
				
				degree = getDegreeFromWorld((i2 + i) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				aCWorldCalUser = Self.user
				
				If (direction = 0) Then
					i = DIRECTION_OFFSET_LEFT
				Else
					i = DIRECTION_OFFSET_RIGHT
				EndIf
				
				aCWorldCalUser.doWhileTouchWorld(i, degree)
				Self.moveDistanceX = DIRECTION_OFFSET_DOWN
				Self.acObj.velX = DIRECTION_OFFSET_DOWN
			EndIf
			
		ElseIf (Self.moveDistanceX < 0) Then
			If (direction = 0) Then
				leftSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
				newX = Self.collisionData.newPosX
			Else
				rightSideCollisionChk(Self.footX, Self.footY, direction, Self.collisionData)
				newX = Self.collisionData.newPosX
			EndIf
			
			If (newX <> ACParam.NO_COLLISION) Then
				Self.footX = newX
				calChkPointFromPos()
				degree = getDegreeFromWorld((Self.footDegree + (direction = 0 ? 90 : 270)) Mod MDPhone.SCREEN_WIDTH, Self.collisionData.collisionX, Self.collisionData.collisionY, Self.acObj.posZ)
				aCWorldCalUser = Self.user
				
				If (direction = 0) Then
					i = DIRECTION_OFFSET_RIGHT
				Else
					i = DIRECTION_OFFSET_LEFT
				EndIf
				
				aCWorldCalUser.doWhileTouchWorld(i, degree)
				Self.moveDistanceX = DIRECTION_OFFSET_DOWN
				Self.acObj.velX = DIRECTION_OFFSET_DOWN
			EndIf
		EndIf
		
	End

	Public Method stopMoveX:Void()
		Super.stopMoveX()
		
		If (Self.actionState = Null) Then
			Int tmpMoveDistanceX = (Self.totalDistance * Cos(Self.user.getBodyDegree())) / 100
			Self.totalDistance = ACUtilities.getTotalFromDegree(DIRECTION_OFFSET_DOWN, (Self.totalDistance * Sin(Self.user.getBodyDegree())) / 100, Self.user.getBodyDegree())
		EndIf
		
	End

	Public Method stopMoveY:Void()
		Super.stopMoveY()
		
		If (Self.actionState = Null) Then
			Int dSin = (Self.totalDistance * Sin(Self.user.getBodyDegree())) / 100
			Self.totalDistance = ACUtilities.getTotalFromDegree((Self.totalDistance * Cos(Self.user.getBodyDegree())) / 100, DIRECTION_OFFSET_DOWN, Self.user.getBodyDegree())
		EndIf
		
	End

	Private Method canBeSideStop:Bool(direction:Int)
		Bool re = False
		
		If (direction = DIRECTION_OFFSET_RIGHT And ((getDirectionByDegree(Self.footDegree) = 0 And (Self.moveDistanceX <= 0 Or Self.acObj.velX <= 0)) Or (getDirectionByDegree(Self.footDegree) = DIRECTION_OFFSET_UP And (Self.moveDistanceX >= 0 Or Self.acObj.velX >= 0)))) Then
			re = True
		EndIf
		
		If (direction <> DIRECTION_OFFSET_LEFT) Then
			Return re
		EndIf
		
		If (getDirectionByDegree(Self.footDegree) <> 0 Or (Self.moveDistanceX < 0 And Self.acObj.velX < 0)) Then
			If (getDirectionByDegree(Self.footDegree) <> DIRECTION_OFFSET_UP) Then
				Return re
			EndIf
			
			If (Self.moveDistanceX > 0 And Self.acObj.velX > 0) Then
				Return re
			EndIf
		EndIf
		
		Return True
	End
End