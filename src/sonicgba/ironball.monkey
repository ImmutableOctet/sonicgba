Strict

Public

' Imports:
Private
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.movecalculator
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class IronBall Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1920
		Const COLLISION_HEIGHT:Int = 1920
		
		' Global variable(s):
		Global image:MFImage
		
		' Fields:
		Field initPos:Int
		Field offset_distance:Int
		
		Field moveCal:MoveCalculator
		
		Field isH:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.moveCal = Null
			
			Local moveDirection:Bool
			
			If (Self.mWidth >= Self.mHeight) Then
				Self.isH = True
				
				If (Self.iLeft = 0) Then
					moveDirection = False
				Else
					moveDirection = True
				EndIf
			Else
				Self.isH = False
				
				If (Self.iTop = 0) Then
					moveDirection = False
				Else
					moveDirection = True
				EndIf
			EndIf
			
			Self.initPos = PickValue(Self.isH, Self.posX, Self.posY)
			
			If (Self.moveCal = Null) Then
				Self.moveCal = New MoveCalculator(Self.initPos, PickValue(Self.isH, Self.mWidth, Self.mHeight), moveDirection)
			EndIf
			
			If (image = Null) Then
				If (StageManager.getCurrentZoneId() = 6) Then
					image = MFImage.createImage("/gimmick/iron_ball6.png")
				Else
					image = MFImage.createImage("/gimmick/iron_ball.png")
				EndIf
			EndIf
		End
	Public
		' Functions:
		Function staticLogic:Void()
			' Empty implementation.
		End
		
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method logic:Void()
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.isH) Then
				If (Self.iLeft = 0) Then
					Self.posX = Self.moveCal.getPosition()
				Else
					Self.offset_distance = Self.initPos - Self.moveCal.getPosition()
					Self.posX = Self.initPos + Self.offset_distance
				EndIf
				
			ElseIf (Self.iTop = 0) Then
				Self.posY = Self.moveCal.getPosition()
			Else
				Self.offset_distance = Self.initPos - Self.moveCal.getPosition()
				Self.posY = Self.initPos + Self.offset_distance
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, image, VCENTER|HCENTER)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			p.beHurt()
		End
		
		Method close:Void()
			' Empty implementation.
		End
End