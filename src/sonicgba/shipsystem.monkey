Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import sonicgba.sonicdef
	Import sonicgba.gameobject
	Import sonicgba.gimmickobject
	
	Import sonicgba.ship
	Import sonicgba.shipbase
Public

' NOTE:
' Uses of division and multiplication may or
' may not need to be replaced with bitwise shifting.

' Classes:
Class ShipSystem Extends GimmickObject
	Private
		' Constant variable(s):
		Const DEGREE_VELOCITY:= 180
		Const RADIUS:= 5632
		Const RING_NUM:= 6
		
		' Fields:
		Field degree:Int
		Field lineVelocity:Int
		
		Field ship:Ship ' GimmickObject
	Protected
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.lineVelocity = 0
			
			' Magic number: 11520 (No idea where this would be defined, if anywhere)
			Self.degree = 11520 ' (RADIUS+128)*2
			
			Self.ship = New Ship(id, x, y, Self)
			
			GameObject.addGameObject(Self.ship, Self.posX, Self.posY)
			GameObject.addGameObject(New ShipBase(x, y), Self.posX, Self.posY)
			
			If (shipRingImage = Null) Then
				shipRingImage = MFImage.createImage("/gimmick/ship_ring.png")
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			' Empty implementation.
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			For Local i:= 0 Until RING_NUM
				drawInMap(g, shipRingImage, Self.posX + ((((i * RADIUS) / (RING_NUM-1)) * Cos(Self.degree / RING_NUM)) / 100), Self.posY + ((((i * RADIUS) / (RING_NUM-1)) * Sin(Self.degree / RING_NUM)) / 100), 3)
			End
		End
		
		Method getNewShipPosition:Void(ship:Ship)
			Self.lineVelocity += (((GRAVITY * 2) * Sin((Self.degree / RING_NUM) - (DEGREE_VELOCITY/2))) / 100) / 3
			Self.degree -= ((((Self.lineVelocity * RING_NUM) / RADIUS) * RING_NUM) * DEGREE_VELOCITY) / SonicDef.PI
			
			Local preX:= ship.posX
			Local preY:= ship.posY
			
			ship.posX = Self.posX + ((Cos(Self.degree / RING_NUM) * RADIUS) / 100)
			ship.posY = Self.posY + ((Sin(Self.degree / RING_NUM) * RADIUS) / 100)
			
			ship.checkWithPlayer(preX, preY, ship.posX, ship.posY)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - RADIUS, y, (RADIUS*2), RADIUS)
		End
		
		Method close:Void()
			Self.ship = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End