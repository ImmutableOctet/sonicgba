Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	'Import special.ssdef
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.enemyobject
Public

' Classes:
Class Bonus100pts Extends EnemyObject
	Private
		' Global variable(s):
		Global BonusAnimation:Animation = Null
		
		' Constant variable(s):
		Const COLLISION_HEIGHT:Int = 64
		Const COLLISION_WIDTH:Int = 64
		
		' Fields:
		Field bonusdrawer:AnimationDrawer
		
		Field frame:Int
		Field movement:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			' Magic number: I'm unsure if this actually has a corresponding variable.
			Self.movement = 240 ' ssdef.PLAYER_MOVE_HEIGHT
			
			If (BonusAnimation = Null) Then
				BonusAnimation = New Animation("/animation/100pts")
			EndIf
			
			Self.bonusdrawer = BonusAnimation.getDrawer(0, False, 0)
			Self.frame = 0
			Self.posX = x
			Self.posY = y
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(BonusAnimation)
			
			BonusAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				If (Self.frame > 24) Then
					Self.dead = True
				EndIf
				
				Self.frame += 1
				
				If (Self.frame < 16) Then
					Self.posY -= Self.movement
				EndIf
				
				refreshCollisionRect(Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(graphics:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(graphics, Self.bonusdrawer, Self.posX, Self.posY)
			End
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method close:Void()
			Self.bonusdrawer = Null
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End