Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.sonicdef
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss3Pipe Extends EnemyObject ' Implements SonicDef...?
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 3584
		Const COLLISION_HEIGHT:Int = 2048
		
		' Global variable(s):
		Global pipeAni:Animation
		
		' Fields:
		Field IsNeedCollision:Bool
		Field IsNeedDraw:Bool
		
		Field drawLayer:Int
		
		Field pipedrawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, isCollision:Bool, direction:Int, layer:Int)
			Super.New(id, x, y, 0, 0, 0, 0)
			
			Self.IsNeedCollision = False
			Self.IsNeedDraw = True
			
			Self.drawLayer = DRAW_BEFORE_SONIC
			
			Self.IsNeedCollision = isCollision
			Self.drawLayer = layer
			
			If (pipeAni = Null) Then
				pipeAni = New Animation("/animation/boss3_pipe")
			EndIf
			
			Self.pipedrawer = pipeAni.getDrawer()
			
			Select (direction)
				Case DIRECTION_UP
					Self.pipedrawer.setTrans(TRANS_MIRROR_ROT180)
				Case DIRECTION_DOWN
					Self.pipedrawer.setTrans(TRANS_NONE)
				Case DIRECTION_LEFT
					Self.pipedrawer.setTrans(TRANS_MIRROR_ROT90)
				Case DIRECTION_RIGHT
					Self.pipedrawer.setTrans(TRANS_ROT270)
				Default
			EndIf
		End
	Public
		' Methods:
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.IsNeedCollision And p = player) Then
				p.beStop(0, direction, Self)
			EndIf
		End
		
		Method doWhileBeAttack:Void(p:PlayerObject, direction:Int, animationID:Int)
			Select (direction)
				Case DIRECTION_LEFT, DIRECTION_RIGHT
					p.isCrashPipe = True
				Default
					p.isCrashPipe = False
			EndIf
		End
		
		Method setisDraw:Void(state:Bool)
			Self.IsNeedDraw = state
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return Self.drawLayer
		End
		
		Method logic:Void(posx:Int, posy:Int)
			Local preX:= Self.posX
			Local preY:= Self.posY
			
			Self.posX = posx
			Self.posY = posy
			
			refreshCollisionRect(Self.posX, Self.posY)
			
			checkWithPlayer(preX, preY, Self.posX, Self.posY)
		End
		
		Method draw:Void(g:MFGraphics)
			' Not sure if this is actually necessary, but we're doing it anyway.
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (Self.IsNeedDraw) Then
				drawInMap(g, Self.pipedrawer, Self.posX, Self.posY)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End