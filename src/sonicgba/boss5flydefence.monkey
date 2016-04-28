Strict

Public

' Imports:
Private
	'Import sonicgba.sonicdef
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss5FlyDefence Extends EnemyObject
	Private
		' Global variable(s):
		Global Hurt:Bool = False
		Global IsAvailable:Bool = False
		
		' Fields:
		Field COLLISION_WIDTH:Int
		Field COLLISION_HEIGHT:Int
		
		Field AttackDirection:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			restoreCollisionSize()
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			Hurt = False
		End
		
		' Methods:
		
		' Extensions:
		Method restoreCollisionSize:Void()
			Self.COLLISION_WIDTH = 1920
			Self.COLLISION_HEIGHT = 1472
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Not IsAvailable) Then
				Hurt = False
			ElseIf (p <> player) Then
				' Nothing so far.
			Else
				Hurt = player.isAttackingEnemy()
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method draw:Void(g:MFGraphics)
			drawCollisionRect(g)
		End
		
		Method logic:Void(posx:Int, posy:Int, AttackDir:Int)
			Self.posX = posx
			Self.posY = posy
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Self.AttackDirection = AttackDir
			
			If (IsAvailable) Then
				restoreCollisionSize()
			Else
				Self.COLLISION_WIDTH = 0
				Self.COLLISION_HEIGHT = 0
			EndIf
			
			refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method getHurtState:Bool()
			Return Hurt
		End
		
		Method setHurtState:Void(state:Bool)
			Hurt = state
		End
		
		Method setCollAvailable:Void(state:Bool)
			IsAvailable = state
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.AttackDirection > 0) Then ' DIRECTION_UP
				' Magic number: 448
				Self.collisionRect.setRect(x - 448, y - Self.COLLISION_HEIGHT, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT)
			Else
				' Magic number: 1408
				Self.collisionRect.setRect(x - 1408, y - Self.COLLISION_HEIGHT, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT)
			EndIf
		End
End