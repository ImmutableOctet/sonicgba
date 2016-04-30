Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.bossf1

' Imports:
Private
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.enemyobject
Public

' Classes:
Class BossF1Ball Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_HEIGHT:Int = 2048
		Const COLLISION_WIDTH:Int = 2048
		
		' Fields:
		Field isPlayerHurt:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.isPlayerHurt = False
			
			Self.posX = 0
			Self.posY = 0
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Not Self.dead And p = player) Then
				p.beHurt() ' player
				
				Self.isPlayerHurt = True
			End
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method doWhileNoCollision:Void()
			Self.isPlayerHurt = False
		End
		
		Method setEnd:Void()
			Self.dead = True
		End
		
		Method getPlayerHurt:Bool()
			Return Self.isPlayerHurt
		End
		
		Method resetPlayerHurt:Void()
			Self.isPlayerHurt = False
		End
	
		Method logic:Void(x:Int, y:Int)
			Self.posX = x
			Self.posY = y
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			refreshCollisionRect(Self.posX, Self.posY)
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
	
		Method draw:Void(graphics:MFGraphics)
			drawCollisionRect(graphics)
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
	
		Method logic:Void()
			' Empty implementation.
		End
End