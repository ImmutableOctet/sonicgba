Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.myapi
	
	'Import sonicgba.sonicdef
	Import sonicgba.gimmickobject
	Import sonicgba.hobincal
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BarHorbinV Extends GimmickObject
	Private
		' Fields:
		Field functionDirection:Int
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2560
		Const COLLISION_HEIGHT:Int = 704
		
		Const COLLISION_OFFSET:Int = 512
		
		Const HOBIN_POWER:Int = 1152
		
		' Global variable(s):
		Global barImage:MFImage
		
		' Fields:
		Field hobinCal:HobinCal
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (barImage = Null) Then
				barImage = MFImage.createImage("/gimmick/bar.png")
			EndIf
			
			Self.functionDirection = DIRECTION_LEFT
			
			If (Self.iLeft = 0) Then
				Self.functionDirection = DIRECTION_RIGHT
			EndIf
			
			Self.hobinCal = New HobinCal()
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			barImage = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Self.iLeft = 0) Then
				drawInMap(g, barImage, 0, 0, MyAPI.zoomIn(barImage.getWidth()), MyAPI.zoomIn(barImage.getHeight()), 6, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), VCENTER|HCENTER)
			Else
				drawInMap(g, barImage, 0, 0, MyAPI.zoomIn(barImage.getWidth()), MyAPI.zoomIn(barImage.getHeight()), 5, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), VCENTER|HCENTER)
			EndIf
			
			' This really shouldn't be here.
			Self.hobinCal.logic()
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - COLLISION_OFFSET, y - (COLLISION_WIDTH / 2), COLLISION_HEIGHT, COLLISION_WIDTH)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (p = player) Then
				p.beStop(0, direction, Self)
				
				soundInstance.playSe(SoundSystem.SE_132)
				
				Select (direction)
					Case DIRECTION_UP
						p.bePop(HOBIN_POWER, direction)
						p.bePop(HOBIN_POWER, Self.functionDirection)
						
						If (Self.functionDirection = DIRECTION_LEFT) Then
							Self.hobinCal.startHobin(0, 225, 10)
						Else
							Self.hobinCal.startHobin(0, -45, 10)
						EndIf
					Case DIRECTION_DOWN
						p.bePop(HOBIN_POWER, direction)
						p.bePop(HOBIN_POWER, Self.functionDirection)
						
						If (Self.functionDirection = DIRECTION_LEFT) Then
							Self.hobinCal.startHobin(0, 135, 10)
						Else
							Self.hobinCal.startHobin(0, 45, 10)
						EndIf
					Case DIRECTION_LEFT, DIRECTION_RIGHT
						If (Self.iLeft <> 0 And direction = DIRECTION_RIGHT) Then
							Return
						EndIf
						
						If (Self.iLeft <> 0 Or direction <> DIRECTION_LEFT) Then
							If (p.getCheckPositionY() <= Self.collisionRect.getCenterY()) Then
								p.bePop(HOBIN_POWER, DIRECTION_DOWN)
								
								' Magic number: 135, 45
								If (Self.functionDirection = DIRECTION_LEFT) Then
									Self.hobinCal.startHobin(0, 135, 10)
								Else
									Self.hobinCal.startHobin(0, 45, 10)
								EndIf
							Else
								p.bePop(HOBIN_POWER, DIRECTION_UP)
								
								' Magic number: 225, -45
								If (Self.functionDirection = DIRECTION_LEFT) Then
									Self.hobinCal.startHobin(0, 225, 10)
								Else
									Self.hobinCal.startHobin(0, -45, 10)
								EndIf
							EndIf
							
							p.bePop(HOBIN_POWER, direction)
						EndIf
				End Select
			EndIf
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End