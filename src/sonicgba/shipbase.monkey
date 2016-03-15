Strict

Public

' Imports:
Private
	Import sonicgba.platformobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class ShipBase Extends PlatformObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 1280
		Const COLLISION_HEIGHT:= 1280
		
		' Global variable(s):
		Global shipBaseImage:MFImage
	Protected
		' Constructor(s):
		
		' These two arguments are likely X and Y coordinates.
		Method New(x:Int, y:Int)
			Super.New(x, y)
			
			If (shipBaseImage = Null) Then
				shipBaseImage = MFImage.createImage("/gimmick/ship_base.png")
			Endif
			
			refreshCollisionRect(posX, posY)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			shipBaseImage = Null
		End
		
		' Methods:
		Method close:Void()
			' Empty implementation.
		End
		
		Method draw:Void(graphics:MFGraphics)
			If (shipBaseImage <> Null) Then
				' Magic number: 3.
				drawInMap(graphics, shipBaseImage, 3)
				
				drawCollisionRect(graphics)
			EndIf
			
			Return
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			collisionRect.setRect((x - (COLLISION_WIDTH/2)), (y - (COLLISION_HEIGHT/2)), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End