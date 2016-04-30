Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.shimasting

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.gameobject
	Import sonicgba.gimmickobject
	Import sonicgba.movecalculator
	Import sonicgba.playerobject
	Import sonicgba.shimasting
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class TogeShima Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3072
		Const COLLISION_HEIGHT:Int = 2048
		
		' Global variable(s):
		Global animation:Animation
		
		' Fields:
		Field dir:Bool
		
		Field frame:Int
		Field posEndY:Int
		Field posOriginalY:Int
		Field range:Int
		Field velY:Int
		
		Field ss:ShimaSting
		
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Magic number: 192
			Self.velY = 192
			
			Self.dir = False
			
			If (animation = Null) Then
				animation = New Animation("/animation/togeshima")
			EndIf
			
			If (animation <> Null) Then
				Self.drawer = animation.getDrawer(0, True, 0)
			EndIf
			
			Self.range = ((height * 8) Shl 6)
			
			Self.posOriginalY = Self.posY
			Self.posEndY = Self.posY + Self.range
			
			Self.ss = New ShimaSting(x, y)
			
			GameObject.addGameObject(Self.ss)
			
			Self.dir = False
			
			Local moveDirection:Bool = (Self.iTop <> 0)
			
			Self.moveCal = New MoveCalculator(Self.posY, Self.mHeight, moveDirection)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(animation)
			
			animation = Null
		End
		
		' Fields:
		Field moveCal:MoveCalculator
		
		' Methods:
		Method logic:Void()
			Self.frame = Self.drawer.getCurrentFrame()
			
			Self.moveCal.logic()
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			If (Self.iTop < 0) Then
				Self.posY = Self.moveCal.getPosition()
			Else
				Self.posY = Self.posOriginalY + (Self.posOriginalY - Self.moveCal.getPosition())
			EndIf
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			Self.ss.logic(Self.posX, Self.posY, Self.frame)
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer, Self.posX, Self.posY)
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (direction = DIRECTION_DOWN Or direction = DIRECTION_UP) Then
				player.beStop(0, direction, Self)
			EndIf
			
			If (direction <> DIRECTION_LEFT And direction <> DIRECTION_RIGHT) Then
				Return
			EndIf
			
			' Magic number: 64
			If (player.getFootPositionY() >= Self.collisionRect.y0 + ((Self.mHeight * 3) / 4)) Then
				player.beStop(0, direction, Self)
			ElseIf (player.getVelX() > 0 And direction = DIRECTION_RIGHT) Then
				player.setFootPositionY(Self.collisionRect.y0 - 64)
			ElseIf (player.getVelX() < 0 And direction = DIRECTION_LEFT) Then
				player.setFootPositionY(Self.collisionRect.y0 - 64)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End