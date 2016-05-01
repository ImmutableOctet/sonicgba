Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.myapi
	Import lib.crlfp32
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.hexhobin
	Import sonicgba.playerobject
	Import sonicgba.playerknuckles
	Import sonicgba.playertails
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class BallHobin Extends HexHobin
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1536
		Const COLLISION_HEIGHT:Int = 1536
		
		Const HOBIN_POWER:Int = 1100
		
		' Global variable(s):
		Global ballHobinImage:MFImage = Null
		
		' Fields:
		Field CanAddScore:Bool
		Field isH__bhobin:Bool
		
		Field initPos:Int
		Field offset_distance:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.CanAddScore = True
			
			If (ballHobinImage = Null) Then
				ballHobinImage = MFImage.createImage("/gimmick/ball_hobin.png")
			EndIf
			
			Self.isH__bhobin = (Self.mWidth >= Self.mHeight)
			
			Self.initPos = PickValue(Self.isH__bhobin, Self.posX, Self.posY)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			ballHobinImage = Null
		End
		
		' Methods:
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method logic:Void()
			Self.moveCal.logic()
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.isH__bhobin) Then
				If (Self.iLeft = 0) Then
					Self.posX = Self.moveCal.getPosition()
				Else
					Self.offset_distance = (Self.initPos - Self.moveCal.getPosition())
					Self.posX = (Self.initPos + Self.offset_distance)
				EndIf
			ElseIf (Self.iTop = 0) Then
				Self.posY = Self.moveCal.getPosition()
			Else
				Self.offset_distance = (Self.initPos - Self.moveCal.getPosition())
				Self.posY = (Self.initPos + Self.offset_distance)
			EndIf
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, ballHobinImage, Self.posX + Self.hobinCal.getPosOffsetX(), Self.posY + Self.hobinCal.getPosOffsetY(), VCENTER|HCENTER)
			
			Self.hobinCal.logic()
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.firstTouch) Then
				player.pipeOut()
				
				If (player.collisionState = PlayerObject.COLLISION_STATE_JUMP And player.animationID <> PlayerObject.ANI_JUMP) Then
					player.beStop(Self.collisionRect.y0, direction, Self)
				EndIf
				
				doWhileCollision_jumpBehavior(player, direction)
				
				Local distanceX:= (player.getCheckPositionX() - Self.collisionRect.getCenterX())
				Local distanceY:= (player.getCheckPositionY() - Self.collisionRect.getCenterY())
				
				If (distanceX <> 0 Or distanceY <> 0) Then
					Local degree:= ((CrlFP32.actTanDegree(distanceY, distanceX) + 360) Mod 360)
					
					Self.hobinCal.startHobin(0, (degree + 180), 10)
					
					If (Self.CanAddScore) Then
						player.getBallHobinScore()
						
						Self.CanAddScore = False
					EndIf
					
					Local powerY:= ((MyAPI.dSin(degree) * HOBIN_POWER) / 100)
					Local powerX:= ((MyAPI.dCos(degree) * HOBIN_POWER) / 100)
					
					player.setVelX(powerX)
					player.setVelY(powerY)
					
					If (player.animationID <> PlayerObject.ANI_JUMP) Then
						player.doWalkPoseInAir()
					EndIf
					
					soundInstance.playSe(SoundSystem.SE_183)
				EndIf
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.CanAddScore = True
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End