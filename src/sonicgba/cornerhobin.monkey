Strict

Public

' Imports:
Private
	Import lib.line
	Import lib.myapi
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.collisionrect
	Import sonicgba.gimmickobject
	Import sonicgba.hobincal
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class CornerHobin Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2816
		Const COLLISION_HEIGHT:Int = 2816
		
		Const POP_POWER:Int = 1152
		
		' Global variable(s):
		Global barCornerImage:MFImage
		
		' Fields:
		Field checkLine:Line
		Field hobinCal:HobinCal
		
		Field funcDirectionH:Int
		Field funcDirectionV:Int
		Field hobinDegree:Int
		Field trans:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (barCornerImage = Null) Then
				barCornerImage = MFImage.createImage("/gimmick/barCorner.png")
			EndIf
			
			Self.hobinDegree = -45
			
			Self.trans = 0 ' TRANS_NONE
			
			Self.funcDirectionH = DIRECTION_LEFT
			
			If (Self.iLeft = 0) Then
				Self.funcDirectionH = DIRECTION_RIGHT
				
				Self.trans |= VCENTER
				
				Self.hobinDegree = (180 - Self.hobinDegree)
			EndIf
			
			Self.funcDirectionV = DIRECTION_DOWN
			
			If (Self.iTop = 0) Then
				Self.funcDirectionV = DIRECTION_UP
				
				Self.trans |= HCENTER
				
				Self.hobinDegree = -Self.hobinDegree
			EndIf
			
			Self.hobinCal = New HobinCal()
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			barCornerImage = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			Local width:= MyAPI.zoomIn(barCornerImage.getWidth())
			Local height:= MyAPI.zoomIn(barCornerImage.getHeight())
			
			Local directionTrans:= (PickValue((Self.funcDirectionH = DIRECTION_LEFT), LEFT, RIGHT) | PickValue((Self.funcDirectionV = DIRECTION_DOWN), BOTTOM, TOP))
			
			drawInMap(g, barCornerImage, 0, 0, width, height, Self.trans, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), directionTrans)
			
			' This probably shouldn't be here.
			Self.hobinCal.logic()
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Local collisionRect:= Self.collisionRect
			
			collisionRect.setRect(x - PickValue((Self.funcDirectionH = DIRECTION_RIGHT), COLLISION_WIDTH, 0), y - PickValue((Self.funcDirectionV = DIRECTION_DOWN), COLLISION_HEIGHT, 0), COLLISION_WIDTH, COLLISION_HEIGHT)
			
			If (Self.checkLine = Null) Then
				Self.checkLine = New Line()
			EndIf
			
			If ((Self.funcDirectionH = DIRECTION_LEFT And Self.funcDirectionV = DIRECTION_DOWN) Or (Self.funcDirectionH = DIRECTION_RIGHT And Self.funcDirectionV = DIRECTION_UP)) Then
				Self.checkLine.setProperty(Self.collisionRect.x0, Self.collisionRect.y0, Self.collisionRect.x1, Self.collisionRect.y1)
			Else
				Self.checkLine.setProperty(Self.collisionRect.x0, Self.collisionRect.y1, Self.collisionRect.x1, Self.collisionRect.y0)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (direction = DIRECTION_NONE And p = player) Then
				Local touched:Bool = False
				
				If (Self.funcDirectionV = DIRECTION_DOWN) Then
					If (Self.checkLine.getY(p.getFootPositionX()) < p.getFootPositionY()) Then
						p.setFootPositionY(Self.checkLine.getY(p.getFootPositionX()))
						
						touched = True
					EndIf
				ElseIf (Self.checkLine.getY(p.getFootPositionX()) > p.getHeadPositionY()) Then
					p.setHeadPositionY(Self.checkLine.getY(p.getFootPositionX()))
					
					touched = True
				EndIf
				
				If (touched) Then
					p.bePop(POP_POWER, Self.funcDirectionV)
					p.bePop(POP_POWER, Self.funcDirectionH)
					
					p.dashRolling = False
					
					Self.hobinCal.startHobin(0, Self.hobinDegree + 180, 10)
					
					soundInstance.playSe(SoundSystem.SE_132)
				EndIf
			EndIf
		End
		
		Method close:Void()
			Self.checkLine = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End