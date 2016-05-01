Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.caterpillar

' Imports:
Private
	Import sonicgba.caterpillar
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class CaterpillarBody Extends EnemyObject
	Private
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		' Fields:
		Field controller:Caterpillar
		
		Field isHead:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int, IsHead:Bool, controller:Caterpillar)
			Super.New(id, x, y, left, top, width, height)
			
			Self.isHead = IsHead
			
			Self.controller = controller
		End
		
		' Methods:
		
		' Extensions:
		Method setDead:Void()
			Self.dead = True
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.dead) Then
				If (Self.controller.isDead()) Then
					setDead()
				ElseIf (p <> player) Then
					' Nothing so far; this behavior may change in the future.
				Else
					If (Not Self.isHead) Then
						p.beHurt()
					ElseIf (p.isAttackingEnemy()) Then
						p.doAttackPose(Self, direction)
						
						beAttack()
						
						Self.controller.setDead()
						
						setDead()
					Else
						p.beHurt()
					EndIf
				EndIf
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			If (Not Self.dead) Then
				If (Self.controller.dead) Then
					setDead()
				ElseIf (p <> player) Then
					' Nothing so far; this behavior may change in the future.
				Else
					If (Self.isHead) Then
						p.doAttackPose(Self, direction)
						
						beAttack()
						
						Self.controller.setDead()
						setDead()
						
						Return
					EndIf
					
					p.beHurt()
				EndIf
			EndIf
		End
		
		Method logic:Void()
			' Nothing so far.
		End
		
		Method logic:Void(x:Int, y:Int)
			If (Not Self.dead) Then
				If (Self.controller.dead) Then
					setDead()
				EndIf
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Self.posX = x
				Self.posY = y
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Not Self.dead) Then
				Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
		End
End