Strict

Public

' Friends:
Friend sonicgba.enemyobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	'Import regal.typetool
Public

' Classes:
Class BreakingParts Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 64
		Const COLLISION_HEIGHT:Int = 64
		
		' Global variable(s):
		Global PartsAni:Animation
		
		Global frame:Int
		
		' Fields:
		Field Vix:Int[]
		Field Viy:Int[]
		
		Field pos:Int[][]
		
		Field partsdrawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.Viy = [-1200, -1050, -900, -750, -600]
			Self.Vix = [750, -300, -150, 150, 450, -750, 600, 300, -450]
			
			If (PartsAni = Null) Then
				PartsAni = New Animation("/animation/parts")
			EndIf
			
			Self.partsdrawer = PartsAni.getDrawer(0, False, 0)
			
			Self.pos = New Int[3][]
			
			For Local i:= 0 Until Self.pos.Length
				Self.pos[i] = New Int[5]
			Next
			
			Self.posX = x
			Self.posY = y
			
			For Local i:= 0 Until Self.pos.Length
				Self.pos[i][0] = Self.posX
				Self.pos[i][1] = Self.posY
				Self.pos[i][2] = Self.Vix[MyRandom.nextInt(Self.Vix.Length)]
				Self.pos[i][3] = Self.Viy[MyRandom.nextInt(Self.Viy.Length)]
				Self.pos[i][4] = MyRandom.nextInt(5)
			Next
			
			frame = 0
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(PartsAni)
			
			PartsAni = Null
		End
		
		' Methods:
		Method logic:Void()
			If (Not IsGamePause) Then
				frame += 1
				
				For Local i:= 0 Until Self.pos.Length
					Local iArr:= Self.pos[i]
					
					iArr[0] += Self.pos[i][2]
					iArr[3] += (GRAVITY / 2) ' Shr 1
					iArr[1] += Self.pos[i][3]
				Next
				
				If (frame >= 50) Then
					Self.dead = True
				EndIf
			EndIf
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				For Local i:= 0 Until Self.pos.Length
					Self.partsdrawer.setActionId(Self.pos[i][4])
					
					drawInMap(g, Self.partsdrawer, Self.pos[i][0], Self.pos[i][1])
				Next
			EndIf
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method close:Void()
			Self.partsdrawer = Null
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End