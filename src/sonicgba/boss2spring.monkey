Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.boss2

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss2Spring Extends EnemyObject
	Private
		' Constant variable(s):
		Const SPRING_FLYING:Int = 0
		Const SPRING_WAITING:Int = 1
		Const SPRING_DAMPING:Int = 2
		
		' Global variable(s):
		Global springAni:Animation
		
		' Fields:
		Field IsAttack:Bool
		Field IsBossBroken:Bool
		Field IsEnd:Bool
		Field IsHurt:Bool
		
		Field springdrawer:AnimationDrawer
		
		Field COLLISION_HEIGHT:Int
		Field COLLISION_WIDTH:Int
		
		Field state:Int
		Field velocity:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.COLLISION_WIDTH = 2048 ' PlayerObject.DETECT_HEIGHT
			Self.COLLISION_HEIGHT = 2240
			
			Self.IsAttack = False
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			refreshCollisionRect(Self.posX Shr 6, Self.posY Shr 6)
			
			If (springAni = Null) Then
				springAni = New Animation("/animation/boss2_spring")
			EndIf
			
			Self.springdrawer = springAni.getDrawer(0, True, 0)
			Self.IsEnd = False
			Self.IsBossBroken = False
			Self.IsAttack = False
		End
	Private
		' Methods:
		Method logic:Void()
			' Empty implementation.
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(springAni)
			
			springAni = Null
		End
		
		' Methods:
		Method setAttackable:Void(state:Bool)
			Self.IsAttack = state
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Not Self.dead And p = player And direction <> SPRING_WAITING And Not Self.IsHurt And Self.IsAttack And Not Self.IsBossBroken) Then
				p.beHurt()
			EndIf
		End
		
		Method doWhileBeAttack:Void(object:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method setSpringAni:Void(state:Int, isloop:Bool)
			changeAniState(Self.springdrawer, state, isloop)
			
			Self.IsEnd = False
		End
		
		Method changeAniState:Void(AniDrawer:AnimationDrawer, state:Int, isloop:Bool)
			AniDrawer.setActionId(state)
			
			If (Self.velocity > 0) Then
				AniDrawer.setTrans(TRANS_MIRROR)
			Else
				AniDrawer.setTrans(TRANS_NONE)
			EndIf
			
			AniDrawer.setLoop(isloop)
		End
		
		Method getEndState:Bool()
			Return Self.IsEnd
		End
		
		Method setBossBrokenState:Void(isBossBroekn:Bool)
			Self.IsBossBroken = isBossBroekn
		End
		
		Method spring_logic:Void(posx:Int, posy:Int, state:Int, vel:Int)
			Self.posX = posx
			Self.posY = posy
			
			If (Not Self.dead) Then
				Self.COLLISION_HEIGHT = getSpringHeight()
				
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (state)
					Case SPRING_DAMPING
						If (Self.springdrawer.checkEnd()) Then
							Self.IsEnd = True
						EndIf
				End Select
				
				checkWithPlayer(preX, preY, Self.posX, Self.posY)
			EndIf
		End
		
		Method getIsHurt:Void(bosshurt:Bool)
			Self.IsHurt = bosshurt
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.springdrawer)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method getSpringHeight:Int()
			If (springAni <> Null) Then
				Return (Self.springdrawer.getCurrentFrameHeight() Shl 6)
			EndIf
			
			Return 0
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (Self.COLLISION_WIDTH / 2), y - Self.COLLISION_HEIGHT, Self.COLLISION_WIDTH, Self.COLLISION_HEIGHT) ' Shr 1
		End
		
		Method close:Void()
			Self.springdrawer = Null
		End
End