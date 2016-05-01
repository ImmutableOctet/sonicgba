Strict

Public

' Friends:
Friend sonicgba.ringobject
Friend sonicgba.gimmickobject
Friend sonicgba.playerobject

' Imports:
Private
	Import sonicgba.collisionrect
	Import sonicgba.mapbehavior
	Import sonicgba.mapobject
	Import sonicgba.playerobject
	Import sonicgba.ringobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class MoveRingObject Extends RingObject Implements MapBehavior
	Private
		' Constant variable(s):
		Const LIFE_COUNT:Int = 90
		
		' Extensions:
		Const BASE_VELOCITY:= 500 ' (VELOCITY_START - VELOCITY_CHANGE)
		
		' Fields:
		Field isAntiGravity:Bool ' Final
		
		Field poping:Bool
		
		Field appearTime:Long
		
		Field popVelX:Int
		Field popVelY:Int
		
		Field reserveVelX:Int
		
		Field unTouchCount:Int
		
		Field mapObj:MapObject
	Protected
		' Constructor(s):
		Method Construct_MoveRingObject:Void(x:Int, y:Int, vx:Int, vy:Int, layer:Int, appearTime:Long)
			Self.mapObj = New MapObject(x, y, vx, vy, Self, layer)
			Self.mapObj.setBehavior(Self)
			
			Self.reserveVelX = vx
			Self.appearTime = appearTime
			
			Self.isAntiGravity = player.isAntiGravity
			Self.mapObj.setAntiGravity(Self.isAntiGravity)
			
			Self.unTouchCount = 0
		End
		
		Method New(x:Int, y:Int, vx:Int, vy:Int, layer:Int, appearTime:Long, unTouchCount:Int)
			Super.New(x, y)
			
			Construct_MoveRingObject(x, y, vx, vy, layer, appearTime)
			
			Self.unTouchCount = unTouchCount
		End
		
		Method New(x:Int, y:Int, vx:Int, vy:Int, layer:Int, appearTime:Long)
			Super.New(x, y)
			
			Construct_MoveRingObject(x, y, vx, vy, layer, appearTime)
		End
	Public
		' Methods:
		Method logic:Void()
			If (Self.poping) Then
				Self.mapObj.doJump(Self.popVelX, Self.popVelY, True)
				
				Self.poping = False
			EndIf
			
			Self.mapObj.logic()
			
			checkWithPlayer(Self.posX, Self.posY, Self.mapObj.getPosX(), Self.mapObj.getPosY())
			
			Self.posX = Self.mapObj.getPosX()
			Self.posY = Self.mapObj.getPosY()
			
			If (Self.unTouchCount > 0) Then
				Self.unTouchCount -= 1
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If ((systemClock - Self.appearTime <= 60) Or (systemClock Mod 2) = 0) Then
				Super.draw(g)
			EndIf
		End
		
		Method getCollisionRect:CollisionRect()
			Return Self.collisionRect
		End
		
		Method doWhileTouchGround:Void(vx:Int, vy:Int)
			If (Abs(vy) < BASE_VELOCITY) Then
				vy = BASE_VELOCITY
			EndIf
			
			Self.reserveVelX = ((Self.reserveVelX * 9) / 10)
			Self.mapObj.doJump(Self.reserveVelX, ((-vy) * 9) / 10)
		End
		
		Method objectChkDestroy:Bool()
			Return (Super.objectChkDestroy() Or (systemClock - Self.appearTime > LIFE_COUNT) Or (systemClock - Self.appearTime) < 0)
		End
		
		Method hasSideCollision:Bool()
			Return False
		End
		
		Method hasTopCollision:Bool()
			Return Self.isAntiGravity
		End
		
		Method canBeInit:Bool()
			Return False
		End
		
		Method hasDownCollision:Bool()
			Return Not Self.isAntiGravity
		End
		
		Method doWhileToucRoof:Void(vx:Int, vy:Int)
			If (Not Self.poping) Then
				Self.poping = True
				
				If (Abs(vy) < BASE_VELOCITY) Then
					vy = -BASE_VELOCITY
				EndIf
				
				Self.reserveVelX = ((Self.reserveVelX * 9) / 10)
				
				Self.popVelX = Self.reserveVelX
				Self.popVelY = (((-vy) * 9) / 10)
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.unTouchCount <= 0) Then
				Super.doWhileCollision(player, direction)
			EndIf
		End
		
		Method getGravity:Int()
			Return GRAVITY
		End
End