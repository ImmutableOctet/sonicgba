Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import gameengine.key
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
Public

' Classes:
Class IronBar Extends GimmickObject
	Private
		' Constant variable(s):
		Const BAR_VELOCITY:Int = 500
		
		' Fields:
		Field touching:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.touching = False
		End
	Public
		' Methods:
		Method logic:Void()
			If (Self.touching) Then
				Local preX:= player.getFootPositionX()
				Local preY:= player.getFootPositionY()
				
				player.doPullBarMotion(Self.posY)
				
				' Magic number: 28 (Sound-effect ID)
				If (Key.repeated(Key.gLeft)) Then
					player.setFootPositionX(preX - BAR_VELOCITY)
					player.setAnimationId(28)
					player.faceDirection = False
				ElseIf (Key.repeated(Key.gRight)) Then
					player.setFootPositionX(preX + BAR_VELOCITY)
					player.setAnimationId(28)
					player.faceDirection = True
				EndIf
				
				If (player.getCollisionRect().x1 < Self.collisionRect.x0 Or player.getCollisionRect().x0 > Self.collisionRect.x1 Or Key.press(Key.gUp|Key.B_HIGH_JUMP)) Then
					player.outOfControl = False
					player.setAnimationId(10)
					
					Self.touching = False
					player.leavingBar = True
					
					Print("do leave bar")
				EndIf
				
				player.checkWithObject(preX, preY, player.getFootPositionX(), player.getFootPositionY())
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.touching And Not player.leavingBar And Not player.outOfControl And player.getVelY() >= 0) Then
				Self.touching = True
				
				player.setOutOfControl(Self)
				player.doPullBarMotion(Self.posY)
				
				player.degreeForDraw = player.faceDegree
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic number: 2 (Height); not sure if this really needs its own variable.
			Self.collisionRect.setRect(Self.posX + ((Self.iLeft * 8) Shl 6), Self.posY, Self.mWidth, 2)
		End
End