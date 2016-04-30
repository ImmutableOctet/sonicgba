Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.bossf2

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.enemyobject
Public

' Classes:
Class BossF2Drill Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1728
		Const COLLISION_HEIGHT:Int = 1344
		
		' Global variable(s):
		Global drillAni:Animation
		
		' Fields:
		Field drillDrawer:AnimationDrawer
		Field isPlayerHurt:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.isPlayerHurt = False
			
			' There doesn't seem to be a clean way to release this animation (Yet):
			If (drillAni = Null) Then
				drillAni = New Animation("/animation/bossf2_drill")
			EndIf
			
			Self.drillDrawer = drillAni.getDrawer(0, True, 0)
			Self.isPlayerHurt = False
		End
	Public
		' Methods:
		Method logic:Void()
			' Empty implementation.
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method logic:Void(x:Int, y:Int, isTrans:Bool)
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Self.posX = x
				Self.posY = y
				
				' Magic numbers: Likely states.
				If (isTrans) Then
					Self.drillDrawer.setTrans(2)
				Else
					Self.drillDrawer.setTrans(0)
				EndIf
				
				refreshCollisionRect(Self.posX, Self.posY)
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Not Self.dead And p = player) Then
				p.beHurt()
				
				Self.isPlayerHurt = True
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.isPlayerHurt = False
		End
		
		Method setEnd:Void()
			Self.dead = True
		End
		
		Method getPlayerHurt:Bool() ' Property
			Return Self.isPlayerHurt
		End
		
		Method resetPlayerHurt:Void()
			Self.isPlayerHurt = False
		End
		
		Method draw:Void(graphics:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(graphics, Self.drillDrawer)
				drawCollisionRect(graphics)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End