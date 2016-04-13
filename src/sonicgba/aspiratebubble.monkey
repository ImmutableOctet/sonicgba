Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.constutil
	
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class AspirateBubble Extends EnemyObject
	Private
		' Constant variable(s):
		Const BUBBLE_SHAKE_SPEED:Int = 16
		Const BUBBLE_UP_SPEED:Int = 120
		
		Const COLLISION_WIDTH:Int = 512
		Const COLLISION_HEIGHT:Int = 512
		
		' Global variable(s):
		Global BubbleAnimation:Animation = Null
		
		' Fields:
		Field bubbledrawer:AnimationDrawer
		
		Field frame:Int
		Field velx:Int
		Field waterLevel:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (BubbleAnimation = Null) Then
				BubbleAnimation = New Animation("/animation/aspirate")
			EndIf
			
			Self.bubbledrawer = BubbleAnimation.getDrawer(0, True, 0)
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
				If (Not isInCamera() Or Self.posY - (COLLISION_HEIGHT / 2) < (StageManager.getWaterLevel() Shl 6)) Then
					Self.dead = True
				EndIf
				
				Self.frame += 1
				Self.frame Mod= 96
				
				Self.posY -= BUBBLE_UP_SPEED
				
				Self.velx = PickValue((Self.frame <= 48), BUBBLE_SHAKE_SPEED, -BUBBLE_SHAKE_SPEED)
				
				Self.posX += Self.velx
				
				refreshCollisionRect(Self.posX, Self.posY)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_SONIC
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.bubbledrawer)
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