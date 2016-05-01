Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.caterpillarbody

' Imports:
Private
	Import lib.animation
	Import lib.myapi
	
	Import sonicgba.gameobject
	Import sonicgba.enemyobject
	Import sonicgba.playerobject
	
	Import sonicgba.caterpillarbody
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Caterpillar Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		Const STATE_MOVE:Int = 0
		
		' Global variable(s):
		Global caterpillarAnimation:Animation
		
		' Fields:
		Field body:CaterpillarBody[]
		Field pos:Int[][]
		
		Field state:Int
		
		Field circleCenterX:Int
		Field circleCenterY:Int
		
		Field dg:Int
		
		Field leftx:Int
		Field lefty:Int
		
		Field rightx:Int
		Field righty:Int
		
		Field plus:Int
		Field plus_cnt:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.dg = 10
			
			Self.plus_cnt = 0
			Self.plus = 1
			
			Self.posY += 2560 ' Int(Float(COLLISION_HEIGHT) * 2.5)
			
			Self.circleCenterX = Self.posX + (Self.mWidth Shr 1) ' / 2
			Self.circleCenterY = Self.posY
			
			Self.plus_cnt = 0
			
			If (caterpillarAnimation = Null) Then
				caterpillarAnimation = New Animation("/animation/caterpillar")
			EndIf
			
			Self.drawer = caterpillarAnimation.getDrawer(0, False, 2)
			
			makePositions()
			
			Self.body = New CaterpillarBody[5]
			
			Self.body[0] = New CaterpillarBody(id, x, y, left, top, width, height, True, Self)
			
			For Local i:= 1 Until Self.body.Length
				Self.body[i] = New CaterpillarBody(id, x, y, left, top, width, height, False, Self)
				
				GameObject.addGameObject(Self.body[i], x, y)
			Next
		End
		
		Method makePositions:Void()
			Self.pos = New Int[5][]
			
			For Local i:= 0 Until Self.pos.Length ' 5
				Self.pos[i] = New Int[2]
			Next
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(caterpillarAnimation)
			
			caterpillarAnimation = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			#Rem
				If (Not Self.dead) Then
					' Nothing so far.
				EndIf
			#End
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				Local preX:= Self.posX
				Local preY:= Self.posY
				
				Select (Self.state)
					Case STATE_MOVE
						Self.plus_cnt += Self.plus
						
						For Local i:= 0 Until Self.pos.Length
							Self.pos[i][0] = Self.circleCenterX - (((Self.mWidth Shr 1) * MyAPI.dCos(Self.dg * (Self.plus_cnt - (i * 3)))) / 100) ' / 2
							Self.pos[i][1] = Self.circleCenterY + (((Self.mWidth Shr 1) * MyAPI.dSin(Self.dg * (Self.plus_cnt - (i * 3)))) / 200) ' / 2
						Next
						
						Self.posX = Self.pos[0][0]
						Self.posY = Self.pos[0][1]
						
						For Local i:= 0 Until Self.body.Length
							Self.body[i].logic(Self.pos[i][0], Self.pos[i][1])
						Next
						
						checkWithPlayer(preX, preY, Self.posX, Self.posY)
				End Select
				
				For Local i:= 1 Until Self.body.Length
					Self.body[i].dead = Self.body[0].dead
				Next
				
				Self.dead = Self.body[0].dead
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				For Local i:= (Self.pos.Length - 1) To 0 Step -1
					Select (i)
						Case 0
							Self.drawer.setActionId(0)
						Case 1, 2
							Self.drawer.setActionId(1)
						Case 3, 4
							Self.drawer.setActionId(2)
					End Select
					
					If (Self.pos[i][0] = (Self.circleCenterX - (Self.mWidth Shr 1))) Then ' / 2
						Self.drawer.setTrans(2)
					ElseIf (Self.pos[i][0] = (Self.circleCenterX + (Self.mWidth Shr 1))) Then ' / 2
						Self.drawer.setTrans(0)
					EndIf
					
					drawInMap(g, Self.drawer, Self.pos[i][0], Self.pos[i][1])
				Next
				
				For Local b:= EachIn Self.body
					b.draw(g)
				Next
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' This behavior may change in the future.
			If (Self.pos.Length = 0) Then
				makePositions()
			EndIf
			
			Self.leftx = Self.pos[0][0] - (COLLISION_WIDTH / 2)
			Self.lefty = Self.pos[0][1] - (COLLISION_HEIGHT / 2)
			
			Self.rightx = Self.pos[0][0] + (COLLISION_WIDTH / 2)
			Self.righty = Self.pos[0][1] + (COLLISION_HEIGHT / 2)
			
			For Local i:= 1 Until Self.pos.Length
				If (Self.pos[i][0] - (COLLISION_WIDTH / 2) < Self.leftx) Then
					Self.leftx = Self.pos[i][0] - (COLLISION_WIDTH / 2)
				EndIf
				
				If (Self.pos[i][1] - (COLLISION_HEIGHT / 2) < Self.lefty) Then
					Self.lefty = Self.pos[i][1] - (COLLISION_HEIGHT / 2)
				EndIf
				
				If (Self.pos[i][0] + (COLLISION_WIDTH / 2) > Self.rightx) Then
					Self.rightx = Self.pos[i][0] + (COLLISION_WIDTH / 2)
				EndIf
				
				If (Self.pos[i][1] + (COLLISION_HEIGHT / 2) > Self.righty) Then
					Self.righty = Self.pos[i][1] + (COLLISION_HEIGHT / 2)
				EndIf
			Next
			
			Self.collisionRect.setRect(Self.leftx, Self.lefty, Self.rightx - Self.leftx, Self.righty - Self.lefty)
		End
		
		Method close:Void()
			Self.pos = []
			
			If (Self.body.Length > 0) Then
				For Local i:= 0 Until Self.body.Length
					Self.body[i] = Null
				Next
			EndIf
			
			Self.body = []
			
			Super.close()
		End
		
		Method setDead:Void()
			For Local body:= EachIn Self.body
				body.dead = True
			Next
			
			Self.dead = True
		End
End