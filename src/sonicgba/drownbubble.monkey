Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import monkey.random
	
	Import sonicgba.enemyobject
Public

' Classes:
Class DrownBubble Extends EnemyObject
	Private
		' Constant variable(s):
		Const BUBBLE_UP_SPEED:Int = 64
		
		Const COLLISION_WIDTH:Int = 512
		Const COLLISION_HEIGHT:Int = 512
		
		' Global variable(s):
		Global BubbleAnimation:Animation = Null
		
		' Fields:
		Field bubbledrawer:AnimationDrawer
		Field waterLevel:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (BubbleAnimation = Null) Then
				BubbleAnimation = New Animation("/animation/bubble_up")
			EndIf
			
			Local frame:Int
			
			If (Rnd(0, 10) > 5) Then
				frame = 1
			Else
				frame = 2
			EndIf
			
			Self.bubbledrawer = BubbleAnimation.getDrawer(frame, True, 0)
			Self.waterLevel = (StageManager.getWaterLevel() Shl 6)
			
			Self.posX = x
			Self.posY = y
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(BubbleAnimation)
			
			BubbleAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.dead) Then
				If (Not isInCamera() Or Self.posY - (COLLISION_HEIGHT/2) < Self.waterLevel) Then
					Self.dead = True
				EndIf
				
				Self.posY -= BUBBLE_UP_SPEED
				
				refreshCollisionRect(Self.posX, Self.posY)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_SONIC ' DRAW_BEFORE_SONIC
		End
		
		Method draw:Void(graphics:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(graphics, Self.bubbledrawer)
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method close:Void()
			Self.bubbledrawer = Null
		End
End
