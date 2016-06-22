Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.ropeend

' Imports:
Private
	Import lib.myapi
	Import lib.soundsystem
	Import lib.crlfp32 ' com.sega.engine.lib.crlfp32
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class RopeStart Extends GimmickObject
	Public
		' Constant variable(s):
		Const COLLISION_WIDTH:= 1024
		Const COLLISION_HEIGHT:= 2560 ' 1024
		
		' Fields:
		Field degree:Int
	Private
		' Constant variable(s):
	    Const DRAW_HEIGHT:= 24
	    Const DRAW_WIDTH:= 16
	    Const MAX_VELOCITY:= 1800
		
		' Global variable(s):
	    Global hookImage2:MFImage
		
		' This variable should be considered constant.
		Global DEGREE:Int = CrlFP32.actTanDegree(1, 2) ' ATan2(1, 2)
		
		' Fields:
    	Field controlling:Bool
    	Field initFlag:Bool
    	
		Field posOriginalX:Int
    	Field posOriginalY:Int
		
    	Field velocity:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.initFlag = False
			
			If (StageManager.getCurrentZoneId() = 4) Then
				If (hookImage2 = Null) Then
					hookImage2 = MFImage.createImage("/gimmick/hook_4.png")
				EndIf
			ElseIf (hookImage = Null) Then
				hookImage = MFImage.createImage("/gimmick/hook.png")
			EndIf
			
			Self.used = False
			Self.controlling = False
			
			If (Self.iLeft = 0) Then
				Self.degree = (10 - DEGREE) ' GameState.DEGREE_VELOCITY - DEGREE
			Else
				Self.degree = DEGREE
			EndIf
			
			Self.posOriginalX = Self.posX
			Self.posOriginalY = Self.posY
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			hookImage2 = Null
		End
		
		' Methods:
		Method getPaintLayer:Int()
			Return DEGREE
		End
		
		Method draw:Void(graphics:MFGraphics)
			If (Not initFlag) Then
				If (StageManager.getCurrentZoneId() = 4) Then
					drawInMap(graphics, hookImage2, DEGREE, DEGREE, DRAW_WIDTH, DRAW_HEIGHT, DEGREE, posX, posY, 17)
					
					Return
				EndIf
				
				drawInMap(graphics, hookImage, DEGREE, DEGREE, DRAW_WIDTH, DRAW_HEIGHT, DEGREE, posX, posY, 17)
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not initFlag) Then
				If (Not used) Then
					velocity = Abs(player.getVelX())
					
					isGotRings = False
					used = True
					controlling = True
					
					player.setOutOfControl(Self)
					player.railing = True
					player.setCollisionState(1)
					player.faceDirection = True
					
					' Magic number: Not sure what this is.
					player.doPullMotion(Self.posX, Self.posY + 1408)
				EndIf
			EndIf
		End
		
		Method logic:Void()
			If (Self.initFlag) Then
				refreshCollisionRect(Self.posX, Self.posY)
			
				If (Not screenRect.collisionChk(Self.collisionRect)) Then
					Self.initFlag = False
				EndIf
			Else
				Local sDegree:= MyAPI.dSin(Self.degree)
			
				If (player.outOfControl And player.outOfControlObject = Self) Then
					Self.velocity += ((GRAVITY * sDegree) / 100)
			
					If (Self.velocity > 0) Then
						' Magic number: Not sure if this value exists somewhere else.
						Self.velocity -= 30
			
						If (Self.velocity < 0) Then
							Self.velocity = DEGREE
						EndIf
					EndIf
			
					If (Self.velocity < 0) Then
						Self.velocity += 30
			
						If (Self.velocity > 0) Then
							Self.velocity = DEGREE
						EndIf
					EndIf
			
					Local cDegree:= MyAPI.dCos(Self.degree)
			
					Local newVelX:= ((Self.velocity * cDegree) / 100)
					Local newVelY:= ((Self.velocity * sDegree) / 100)
			
					Self.posX += newVelX
					Self.posY += newVelY
			
					refreshCollisionRect(Self.posX, Self.posY)
			
					If (player.outOfControl) Then
						Local preX:= player.getFootPositionX()
						Local preY:= player.getFootPositionY()
			
						' Magic number: Not sure what this is.
						player.doPullMotion(Self.posX, Self.posY + 1408)
			
						player.setVelX(newVelX)
						player.setVelY(newVelY)
			
						player.checkWithObject(preX, preY, player.getFootPositionX(), player.getFootPositionY())
			
						If (Not isGotRings) Then
							' Magic number: Not sure what this is. (Likely the sound identifier)
							SoundSystem.getInstance().playSequenceSe(50)
						EndIf
					EndIf
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			collisionRect.setRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method turn:Void()
			Self.degree = (180 - Self.degree)
			Self.velocity = -Self.velocity
			
			If (Abs(Self.velocity) <= MAX_VELOCITY) Then
				Return
			EndIf
			
			If (Self.velocity < 0) Then
				Self.velocity = -MAX_VELOCITY
			Else
				Self.velocity = MAX_VELOCITY
			EndIf
		End
		
		Method doInitWhileInCamera:Void()
			Self.posX = Self.posOriginalX
			Self.posY = Self.posOriginalY
			
			Self.used = False
			Self.controlling = False
			
			If (Self.iLeft = 0) Then
				Self.degree = (10 - DEGREE) ' GameState.DEGREE_VELOCITY
			Else
				Self.degree = DEGREE
			EndIf
		End
End