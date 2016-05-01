Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.constutil
	
	Import sonicgba.collisionmap
	Import sonicgba.collisionrect
	Import sonicgba.gameobject
	Import sonicgba.mapbehavior
	Import sonicgba.playerobject
	
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworldcaluser
	Import com.sega.engine.action.acworldcollisioncalculator
	Import com.sega.engine.action.acworldcollisionlimit
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class MapObject Extends GameObject Implements ACWorldCalUser, ACWorldCollisionLimit
	Private
		' Constant variable(s):
		Const STATE_GROUND:Int = 0
		Const STATE_SKY:Int = 1
		
		' Global variable(s):
		Global groundBlock:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		Global skyBlock:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		
		' Fields:
		Field collisionChkBreak:Bool
		Field isAntiGravity:Bool
		
		Field state:Int ' = STATE_GROUND
		
		Field LEFT_WALK_COLLISION_CHECK_OFFSET_X:Int
		Field LEFT_WALK_COLLISION_CHECK_OFFSET_Y:Int
		Field RIGHT_WALK_COLLISION_CHECK_OFFSET_X:Int
		Field RIGHT_WALK_COLLISION_CHECK_OFFSET_Y:Int
		
		Field obj:GameObject
		
		Field collisionBehavior:MapBehavior
		
		Field worldCal:ACWorldCollisionCalculator
		
		Field totalVelocity:Int
		
		Field centerOffsetX:Int
		Field centerOffsetY:Int
		
		Field crashCount:Int
		
		Field footX:Int
		Field footY:Int
		
		Field gravity:Int
		
		Field moveDegree:Int
		Field moveDistanceX:Int
		Field moveDistanceY:Int
	Protected
		' Constructor(s):
		Method Construct_MapObject:Void()
			Self.RIGHT_WALK_COLLISION_CHECK_OFFSET_Y = -512
			Self.LEFT_WALK_COLLISION_CHECK_OFFSET_Y = Self.RIGHT_WALK_COLLISION_CHECK_OFFSET_Y
			Self.crashCount = 1
		End
		
		Method MapObject_InitializeWorldCal:Void()
			Self.worldCal = New ACWorldCollisionCalculator(Self, Self)
			Self.worldCal.setLimit(Self)
		End
		
		Method MapObject_InitializeGravity:Void()
			Self.gravity = GameObject.GRAVITY
		End
	Public
		' Constructor(s):
		Method New(obj:GameObject, layer:Int)
			Construct_MapObject()
			
			Self.obj = obj
			Self.currentLayer = layer
			
			MapObject_InitializeWorldCal()
			MapObject_InitializeGravity()
		End
		
		Method New(x:Int, y:Int, vx:Int, vy:Int, object:GameObject, layer:Int)
			Construct_MapObject()
			
			Self.obj = object
			Self.currentLayer = layer
			
			setMapPosition(x, y, vx, vy, object)
			
			MapObject_InitializeWorldCal()
			MapObject_InitializeGravity()
		End
		
		Method New(x:Int, y:Int, vx:Int, vy:Int, obj:GameObject, layer:Int, offsetvx:Int)
			Construct_MapObject()
			
			Self.obj = obj
			Self.currentLayer = layer
			
			setMapPosition(x, y, vx, vy, obj) ' + offsetvx
			
			MapObject_InitializeWorldCal()
			MapObject_InitializeGravity()
		End
		
		' Methods:
		Method setMapPosition:Void(x:Int, y:Int, vx:Int, vy:Int, object:GameObject)
			Self.state = STATE_SKY
			
			Self.posX = x
			Self.posY = y
			
			Self.velX = vx
			Self.velY = vy
			
			Self.obj = object
			Self.obj.refreshCollisionRect(Self.posX, Self.posY)
			
			Local collisionRect:= Self.obj.getCollisionRect()
			
			Self.footX = ((collisionRect.x0 + collisionRect.x1) / 2) ' Shr 1
			Self.footY = collisionRect.y1
			
			Self.width = (collisionRect.x1 - collisionRect.x0)
			Self.height = (collisionRect.y1 - collisionRect.y0)
			
			Self.centerOffsetX = (Self.footX - Self.posX)
			Self.centerOffsetY = (Self.footY - Self.posY)
			
			Self.RIGHT_WALK_COLLISION_CHECK_OFFSET_X = (collisionRect.getWidth() / 2) ' Shr 1
			Self.LEFT_WALK_COLLISION_CHECK_OFFSET_X = -Self.RIGHT_WALK_COLLISION_CHECK_OFFSET_X
		End
		
		Method setCrashCount:Void(count:Int)
			Self.crashCount = count
		End
		
		Method getCurrentCrashCount:Int()
			Return Self.crashCount
		End
		
		Method logic:Void()
			Self.gravity = GameObject.GRAVITY
			
			If (Self.collisionBehavior <> Null) Then
				Self.gravity = Self.collisionBehavior.getGravity()
			EndIf
			
			Select (Self.state)
				Case STATE_GROUND
					If (Self.totalVelocity <> 0) Then
						Self.totalVelocity += ((Self.gravity * MyAPI.dSin(Self.moveDegree)) / 100)
					EndIf
				Case STATE_SKY
					Self.velY += PickValue(Self.isAntiGravity, -Self.gravity, Self.gravity)
			End Select
			
			checkWithMap()
		End
		
		Method logic2:Void()
			Self.gravity = GameObject.GRAVITY
			
			If (Self.collisionBehavior <> Null) Then
				Self.gravity = Self.collisionBehavior.getGravity()
			EndIf
			
			Select (Self.state)
				Case STATE_GROUND
					Self.totalVelocity = 0
				Case STATE_SKY
					Self.velY += PickValue(Self.isAntiGravity, -Self.gravity, Self.gravity)
			End Select
			
			checkWithMap()
		End
		
		Method getPosX:Int()
			Return Self.posX
		End
		
		Method getPosY:Int()
			Return Self.posY
		End
		
		Method checkWithMap:Void()
			Select (Self.state)
				Case STATE_GROUND
					Local dCos:= ((Self.totalVelocity * MyAPI.dCos(Self.moveDegree)) / 100)
					
					Self.moveDistanceX = dCos
					Self.velX = dCos
					
					dCos = ((Self.totalVelocity * MyAPI.dSin(Self.moveDegree)) / 100)
					
					Self.moveDistanceY = dCos
					Self.velY = dCos
				Case STATE_SKY
					Self.moveDistanceX = Self.velX
					Self.moveDistanceY = Self.velY
					
					Self.moveDegree = 0
			End Select
			
			Self.posZ = Self.currentLayer
			
			Self.worldCal.actionLogic(Self.moveDistanceX, Self.moveDistanceY)
		End
		
		Method setLayer:Void(layer:Int)
			Self.currentLayer = layer
		End
		
		Method getQuaParam:Int(x:Int, divide:Int)
			If (x > 0) Then
				Return (x / divide)
			EndIf
			
			Return ((x - (divide - 1)) / divide)
		End
		
		Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method draw:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Empty implementation.
		End
		
		Method calDivideVelocity:Void()
			calDivideVelocity(Self.moveDegree)
		End
		
		Method calDivideVelocity:Void(degree:Int)
			Self.velX = ((Self.totalVelocity * MyAPI.dCos(degree)) / 100)
			Self.velY = ((Self.totalVelocity * MyAPI.dSin(degree)) / 100)
		End
		
		Method getVelX:Int()
			Return Self.velX
		End
		
		Method getVelY:Int()
			Return Self.velX
		End
		
		Method setVel:Void(velx:Int, vely:Int)
			Self.velX = velx
			Self.velY = vely
			
			calTotalVelocity()
		End
		
		Method calTotalVelocity:Void()
			calTotalVelocity(Self.moveDegree)
		End
		
		Method calTotalVelocity:Void(degree:Int)
			Self.totalVelocity = (((Self.velX * MyAPI.dCos(degree)) + (Self.velY * MyAPI.dSin(degree))) / 100)
		End
		
		Method chkCrash:Bool()
			If (Self.crashCount <= 0) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method setBehavior:Void(behavior:MapBehavior)
			Self.collisionBehavior = behavior
		End
		
		Method doJump:Void(vx:Int, vy:Int, mustJump:Bool)
			Print("do jump:" + Self.state)
			
			If (Self.state = STATE_GROUND Or mustJump) Then
				Self.state = STATE_SKY
				
				Self.velX = vx
				Self.velY = vy
				
				Self.worldCal.stopMove()
				
				Self.worldCal.actionState = ACWorldCollisionCalculator.JUMP_ACTION_STATE
			EndIf
		End
		
		Method doJump:Void(vx:Int, vy:Int)
			doJump(vx, vy, False)
		End
		
		Method doStop:Void()
			Self.totalVelocity = 0
			
			Self.velX = 0
			Self.velY = 0
			
			Self.worldCal.stopMove()
			
			Self.collisionChkBreak = True
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
		
		Method doWhileLand:Void(degree:Int)
			Self.crashCount -= 1
			
			Self.state = STATE_GROUND
			
			Self.totalVelocity = ACUtilities.getTotalFromDegree(Self.velX, Self.velY, degree)
			
			If (Self.collisionBehavior <> Null) Then
				Self.collisionBehavior.doWhileTouchGround(Self.velX, Self.velY)
			EndIf
		End
		
		Method doWhileLeaveGround:Void()
			' Empty implementation.
		End
		
		Method doWhileTouchWorld:Void(direction:Int, degree:Int)
			Local realTouch:Bool = False
			
			Select (direction)
				Case DIRECTION_UP
					If (Self.collisionBehavior <> Null) Then
						Self.collisionBehavior.doWhileTouchRoof(Self.velX, Self.velY)
					EndIf
				Case DIRECTION_DOWN
					If (ACUtilities.getTotalFromDegree(Self.velX, Self.velY, 0) > 0) Then
						realTouch = True
					EndIf
				Case DIRECTION_RIGHT
					If (ACUtilities.getTotalFromDegree(Self.velX, Self.velY, 180) > 0) Then
						realTouch = True
					EndIf
			End Select
			
			If (realTouch) Then
				Self.crashCount -= 1
			EndIf
		End
		
		Method getBodyDegree:Int()
			Return Self.worldCal.footDegree
		End
		
		Method getBodyOffset:Int()
			Return (Self.height / 2) ' Shr 1
		End
		
		Method getFootOffset:Int()
			Return (Self.width / 2) ' Shr 1
		End
		
		Method getFootX:Int()
			Return (Self.posX + Self.centerOffsetX)
		End
		
		Method getFootY:Int()
			Return (Self.posY + Self.centerOffsetY)
		End
		
		Method getMinDegreeToLeaveGround:Int()
			Return 30
		End
		
		Method getPressToGround:Int()
			Return GRAVITY
		End
		
		Method didAfterEveryMove:Void(arg0:Int, arg1:Int)
			Select (Self.worldCal.actionState)
				Case ACWorldCollisionCalculator.WALK_ACTION_STATE
					Self.state = STATE_GROUND
					
					Self.moveDegree = Self.worldCal.footDegree
				Case ACWorldCollisionCalculator.JUMP_ACTION_STATE
					Self.state = STATE_SKY
			End Select
		End
		
		Method noSideCollision:Bool()
			If (Self.collisionBehavior <> Null) Then
				Return Not Self.collisionBehavior.hasSideCollision()
			EndIf
			
			Return False
		End
		
		Method noTopCollision:Bool()
			If (Self.collisionBehavior <> Null) Then
				Return Not Self.collisionBehavior.hasTopCollision()
			EndIf
			
			Return False
		End
		
		Method noDownCollision:Bool()
			If (Self.collisionBehavior <> Null) Then
				Return (Not Self.collisionBehavior.hasDownCollision())
			EndIf
			
			Return False
		End
		
		Method setAntiGravity:Void(flag:Bool)
			Self.isAntiGravity = flag
		End
		
		Method reset:Void()
			Self.worldCal.setLimit(Null)
			Self.worldCal = Null
		End
	Private
		' Methods:
		Method getNewPointX:Int(oriX:Int, xOffset:Int, yOffset:Int, degree:Int)
			Return (oriX + xOffset)
		End
		
		Method getNewPointY:Int(oriY:Int, xOffset:Int, yOffset:Int, degree:Int)
			Return (oriY + yOffset)
		End
End