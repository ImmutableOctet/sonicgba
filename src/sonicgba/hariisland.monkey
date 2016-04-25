Strict

Public

#Rem
	TODO:
		* Test the behavior of this class's constructor.
		* Compare behavior of this class with 'DekaPlatform'.
#End

' Imports:
Private
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.movecalculator
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.engine.action.acparam
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class HariIsland Extends GimmickObject
	Private
		' Global variable(s):
		Global image:MFImage
		Global image2:MFImage
		
		' Fields:
		Field isH:Bool
		
		Field collisionWidth:Int
		Field collisionHeight:Int
		
		Field damageDirection:Int
		
		Field mCalc:MoveCalculator
		Field thisImage:MFImage
	Protected
		' Constructor(s):
		
		' This implementation is based on a partially decompiled constructor.
		' Behavior may be unstable, but is intended to work.
		' This implementation may change in the future.
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (StageManager.getCurrentZoneId() = 3) Then
				If (image = Null) Then
					image = MFImage.createImage("/gimmick/hari_island_up_3.png")
				EndIf
				
				Self.damageDirection = DIRECTION_DOWN
				Self.thisImage = image
			ElseIf (StageManager.getCurrentZoneId() = 5) Then ' Else
				If (Self.iLeft = 0) Then
					If (image = Null) Then
						image = MFImage.createImage("/gimmick/hari_island_up_5.png")
					EndIf
					
					Self.damageDirection = DIRECTION_DOWN
					Self.thisImage = image
				Else
					If (image2 = Null) Then
						image2 = MFImage.createImage("/gimmick/hari_island_down_5.png")
					EndIf
					
					Self.damageDirection = DIRECTION_UP
					Self.thisImage = image2
				EndIf
			EndIf
			
			Self.collisionWidth = (MyAPI.zoomIn(image.getWidth()) Shl 6)
			Self.collisionHeight = (MyAPI.zoomIn(image.getHeight()) Shl 6)
			
			Local ratio:Bool
			
			If (Self.mWidth >= Self.mHeight) Then
				isH = True
				
				If (iLeft = 0) Then
					ratio = False
				Else
					ratio = True
					
					' Magic number: 64
					Self.mWidth += 64
				EndIf
			Else
				Self.isH = False
				
				ratio = (Self.iTop <> 0)
			EndIf
			
			mCalc = new MoveCalculator(PickValue(Self.isH, Self.posX, Self.posY), PickValue(Self.isH, Self.mWidth, Self.mHeight), ratio)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
			image2 = Null
		End
		
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (Self.collisionWidth / 2), y - (Self.collisionHeight / 2), Self.collisionWidth, Self.collisionHeight) ' Shr 1
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			player.beStop(0, direction, Self)
			
			If (direction = Self.damageDirection) Then
				player.beHurt()
			EndIf
			
			If (player.isFootOnObject(Self) And Self.worldInstance.getWorldY(player.collisionRect.x0, player.collisionRect.y0, 1, 0) <> ACParam.NO_COLLISION And Self.worldInstance.getWorldY(player.collisionRect.x1, player.collisionRect.y0, 1, 0) <> ACParam.NO_COLLISION) Then
				player.setDie(False)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.thisImage, VCENTER|HCENTER)
		End
		
		Method logic:Void()
			Self.mCalc.logic()
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.isH) Then
				Self.posX = Self.mCalc.getPosition()
			Else
				Self.posY = Self.mCalc.getPosition()
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method close:Void()
			Self.thisImage = Null
			Self.mCalc = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End