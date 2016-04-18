Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.myrandom
	Import lib.constutil
	
	Import sonicgba.mapobject
	Import sonicgba.smallanimal
	
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class PatrolAnimal Extends SmallAnimal
	Private
		' Constant variable(s):
		Const FLY_HEIGHT:Int = 6400
		Const FLY_RANGE:Int = 640
		
		' Fields:
		Field flyDegree:Int
		Field flyLimit:Int
		
		Field leftLimit:Int
		Field rightLimit:Int
		
		Field direction:Bool
	Public
		' Constructor(s):
		Method New(type:Int, animalId:Int, x:Int, y:Int, layer:Int, left:Int, right:Int)
			Super.New(type, animalId, x, y, layer)
			
			Self.direction = (MyRandom.nextInt(2) = 0)
			
			Self.leftLimit = left
			Self.rightLimit = right
			
			If (Self.mObj <> Null) Then
				Self.mObj.setPosition(Self.posX, Self.posY, DSgn(Self.direction) * MyRandom.nextInt(-FLY_VELOCITY_Y), 0, Self)
			EndIf
			
			Self.flyLimit = (y - FLY_HEIGHT)
		End
		
		' Methods:
		Method logic:Void()
			If (Self.type = TYPE_FLY) Then
				If (Self.direction) Then
					If (Self.posX > Self.rightLimit) Then
						Self.direction = Not Self.direction
					EndIf
				ElseIf (Self.posX < Self.leftLimit) Then
					Self.direction = Not Self.direction
				EndIf
				
				Self.posX += (DSgn(Not Self.direction) * -250)
				
				Self.posY += FLY_VELOCITY_Y
				
				If (Self.posY < Self.flyLimit) Then
					Self.posY = Self.flyLimit
				EndIf
				
				Self.flyDegree += 30
				Self.flyDegree Mod= 360
			ElseIf (Self.mObj <> Null) Then
				Self.mObj.logic()
				
				Self.posX = Self.mObj.getPosX()
				Self.posY = Self.mObj.getPosY()
			EndIf
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method doWhileTouchGround:Void(vx:Int, vy:Int)
			If (Self.type = TYPE_MOVE) Then
				If (Self.direction) Then
					If (Self.mObj.getPosX() > Self.rightLimit) Then
						Self.direction = (Not Self.direction)
					EndIf
				ElseIf (Self.mObj.getPosX() < Self.leftLimit) Then
					Self.direction = (Not Self.direction)
				EndIf
				
				Self.mObj.doJump(DSgn(Not Self.direction) * FLY_VELOCITY_Y, FLY_VELOCITY_X)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Self.direction) Then
				Self.drawer.setTrans(TRANS_MIRROR)
			Else
				Self.drawer.setTrans(TRANS_NONE)
			EndIf
			
			If (Self.type = TYPE_MOVE) Then
				drawInMap(g, Self.drawer)
			Else
				drawInMap(g, Self.drawer, Self.posX, Self.posY + ((MyAPI.dSin(Self.flyDegree) * FLY_RANGE) / 100))
			EndIf
		End
End