Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.soundsystem
	
	Import sonicgba.sonicdef
	Import sonicgba.barhorbinv
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BarHorbinH Extends BarHorbinV
	Private
		' Fields:
		Field functionDirection:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (barImage = Null) Then
				barImage = MFImage.createImage("/gimmick/bar.png")
			EndIf
			
			Self.functionDirection = 1
			
			If (Self.iLeft = 0) Then
				Self.functionDirection = 0
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			barImage = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (Self.iLeft = 0) Then
				drawInMap(g, barImage, 0, 0, MyAPI.zoomIn(barImage.getWidth()), MyAPI.zoomIn(barImage.getHeight()), 3, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), VCENTER|HCENTER)
			Else
				drawInMap(g, barImage, 0, 0, MyAPI.zoomIn(barImage.getWidth()), MyAPI.zoomIn(barImage.getHeight()), 0, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), VCENTER|HCENTER)
			EndIf
			
			' I'm not sure why this is in 'draw', but whatever.
			Self.hobinCal.logic()
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), (y + COLLISION_OFFSET) - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (p = player) Then
				p.beStop(0, direction, Self)
				
				soundInstance.playSe(SoundSystem.SE_132)
				
				Select (direction)
					Case DIRECTION_UP, DIRECTION_DOWN
						If (Self.iLeft <> 0 And direction = DIRECTION_UP) Then
							Return
						EndIf
						
						If (Self.iLeft <> 0 Or direction <> DIRECTION_DOWN) Then
							If (p.getCheckPositionX() <= Self.collisionRect.getCenterX()) Then
								p.bePop(HOBIN_POWER, DIRECTION_RIGHT)
								
								If (Self.functionDirection = DIRECTION_DOWN) Then
									Self.hobinCal.startHobin(0, 45, 10)
								Else
									Self.hobinCal.startHobin(0, -45, 10)
								EndIf
							Else
								p.bePop(HOBIN_POWER, DIRECTION_LEFT)
								
								If (Self.functionDirection = 1) Then
									Self.hobinCal.startHobin(0, 135, 10)
								Else
									Self.hobinCal.startHobin(0, 225, 10)
								EndIf
							EndIf
							
							p.bePop(HOBIN_POWER, direction)
						EndIf
					Case DIRECTION_LEFT
						p.bePop(HOBIN_POWER, direction)
						p.bePop(HOBIN_POWER, Self.functionDirection)
						
						If (Self.functionDirection = DIRECTION_DOWN) Then
							Self.hobinCal.startHobin(0, 135, 10)
						Else
							Self.hobinCal.startHobin(0, 225, 10)
						EndIf
					Case DIRECTION_RIGHT
						p.bePop(HOBIN_POWER, direction)
						p.bePop(HOBIN_POWER, Self.functionDirection)
						
						If (Self.functionDirection = DIRECTION_DOWN) Then
							Self.hobinCal.startHobin(0, 45, 10)
						Else
							Self.hobinCal.startHobin(0, -45, 10)
						EndIf
				End Select
			EndIf
		End
End