Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.boss3

' Imports:
Private
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.enemyobject
	
	Import sonicgba.boss3
Public

' Classes:
Class Boss3Shadow Extends EnemyObject
	Public
		' Fields:
		Field IsInPipeCollision:Bool
		Field IsOver:Bool
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3200
		Const COLLISION_HEIGHT:Int = 3200
		
		Const FACE_NORMAL:= Boss3.FACE_NORMAL
		Const FACE_SMILE:= Boss3.FACE_SMILE
		Const FACE_HURT:= Boss3.FACE_HURT
		
		' Fields:
		Field face_state:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.IsInPipeCollision = False
			Self.IsOver = False
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.IsOver And Not Self.IsInPipeCollision And p = player) Then
				p.beHurt() ' player
				
				Self.face_state = FACE_SMILE
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method logic:Void(posx:Int, posy:Int)
			Self.posX = posx
			Self.posY = posy
			
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
	
		Method getShadowHurt:Int()
			Return Self.face_state
		End
	
		Method setShadowHurt:Void(state:Int)
			Self.face_state = state
		End
	
		Method draw:Void(graphics:MFGraphics)
			' Empty implementation.
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH/2), y - (COLLISION_HEIGHT/2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End