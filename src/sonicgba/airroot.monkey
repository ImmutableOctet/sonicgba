Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class AirRoot Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1792
		Const COLLISION_HEIGHT:Int = 320
		
		Const IMAGE_WIDTH:Int = 1792
		Const IMAGE_HEIGHT:Int = 1792
		
		Const CORNER_LEFT_TOP:Int = 0
		Const CORNER_RIGHT_TOP:Int = 1
		Const CORNER_LEFT_BOTTOM:Int = 2
		Const CORNER_RIGHT_BOTTOM:Int = 3
		
		' Global variable(s):
		Global image:MFImage
		
		' Fields:
		Field imageWidth:Int
		Field imageHeight:Int
		
		Field type:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.imageHeight = 0 ' CORNER_LEFT_TOP
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/airroot.png")
			EndIf
			
			If (image <> Null) Then
				Self.imageWidth = MyAPI.zoomIn(image.getWidth())
				Self.imageHeight = MyAPI.zoomIn(image.getHeight())
			EndIf
			
			Self.type = left
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not player.piping) Then
				If (player.getBodyPositionY() < Self.collisionRect.y0) Then
					' Magic number: 64
					player.setFootPositionY(Self.collisionRect.y0 - 64)
					
					direction = DIRECTION_DOWN
				EndIf
				
				If (direction = DIRECTION_DOWN) Then
					player.beStop(Self.collisionRect.x0, direction, Self)
				EndIf
			EndIf
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method draw:Void(g:MFGraphics)
			Local trans:= TRANS_NONE
			
			Select (Self.type)
				Case CORNER_LEFT_TOP
					'trans = TRANS_NONE
				Case CORNER_RIGHT_TOP
					trans = TRANS_ROT90
				Case CORNER_LEFT_BOTTOM
					trans = TRANS_ROT270
				Case CORNER_RIGHT_BOTTOM
					trans = TRANS_ROT180
			End Select
			
			drawInMap(g, image, 0, 0, Self.imageWidth, Self.imageHeight, trans, Self.posX - (IMAGE_WIDTH / 2), Self.posY - (IMAGE_HEIGHT / 2), 0)
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic numbers: 192, 1472
			If (Self.type = CORNER_LEFT_TOP Or Self.type = CORNER_RIGHT_TOP) Then
				Self.collisionRect.setRect(x - (IMAGE_WIDTH / 2), (y - (IMAGE_HEIGHT / 2)) + 192, IMAGE_WIDTH, COLLISION_HEIGHT)
			ElseIf (Self.type = CORNER_LEFT_BOTTOM Or Self.type = CORNER_RIGHT_BOTTOM) Then
				Self.collisionRect.setRect(x - (IMAGE_WIDTH / 2), (y - (IMAGE_HEIGHT / 2)) + 1472, IMAGE_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
End