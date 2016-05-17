Strict

Public

' Friends:
Friend sonicgba.bulletobject
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.bossextra

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.myrandom
	Import lib.constutil
	
	Import sonicgba.bulletobject
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.engine.action.acmovecaluser
	Import com.sega.engine.action.acmovecalculator
	
	'Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class BossExtraStone Extends BulletObject Implements ACMoveCalUser
	Private
		' Constant variable(s):
		Global VELOCITY_LIST:Int[][] = [[24, 5], [96, 5], [168, 5], [240, 15], [312, 15], [384, 15], [456, 15], [528, 15], [600, 10]] ' Const
		
		' Fields:
		Field dead:Bool
		
		Field type:Int
		
		Field degree:Int
		Field degreeSpeed:Int
		
		Field moveCal:ACMoveCalculator
		
		Field rect:Byte[]
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(x, y, 0, 0, False)
			
			Self.dead = False
			
			Local random:= MyRandom.nextInt(100)
			
			Local probability:= 0
			Local velocity:= 0
			
			For Local i:= 0 Until VELOCITY_LIST.Length
				probability += VELOCITY_LIST[i][1]
				
				If (random < probability) Then
					velocity = VELOCITY_LIST[i][0]
					
					Exit
				EndIf
			Next
			
			Local degree:Int
			
			If (MyRandom.nextInt(100) < 85) Then
				degree = MyRandom.nextInt(225, 270)
			Else
				degree = MyRandom.nextInt(270, 315)
			EndIf
			
			Self.velX = ((MyAPI.dCos(degree) * velocity) / 100)
			Self.velY = ((MyAPI.dSin(degree) * velocity) / 100)
			
			Self.type = MyRandom.nextInt(5)
			
			Self.moveCal = New ACMoveCalculator(Self, Self)
			
			If (stoneAnimation = Null) Then
				stoneAnimation = New Animation("/animation/boss_extra_stone")
			EndIf
			
			Self.drawer = stoneAnimation.getDrawer(Self.type, False, PickValue((MyRandom.nextInt(2) = 0), 0, 2))
			
			Self.rect = Self.drawer.getARect()
			
			Self.degreeSpeed = MyRandom.nextInt(-20, 20)
		End
	Public
		' Methods:
		Method bulletLogic:Void()
			Self.velY += (GRAVITY Shr 4)
			
			Self.moveCal.actionLogic(Self.velX, Self.velY)
			
			Self.degree += Self.degreeSpeed
			
			While (Self.degree < 0)
				Self.degree += 360
			Wend
			
			Self.degree Mod= 360
			
			' Magic number: 19200
			If (Self.posY > 19200) Then
				Self.dead = True
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			Local context:= g.getSystemGraphics()
			
			context.PushMatrix()
			
			context.Translate(Float((Self.posX Shr 6) - camera.x), Float((Self.posY Shr 6) - camera.y))
			
			context.Rotate(Float(Self.degree))
			
			Self.drawer.draw(g, 0, 0)
			
			context.PopMatrix()
		End
		
		Method chkDestroy:Bool()
			Return Self.dead
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.rect.Length > 0) Then
				Self.collisionRect.setRect((Self.rect[0] Shl 6) + x, (Self.rect[1] Shl 6) + y, Self.rect[2] Shl 6, Self.rect[3] Shl 6)
			EndIf
		End
		
		Method didAfterEveryMove:Void(arg0:Int, arg1:Int)
			refreshCollisionRect(Self.posX, Self.posY)
			
			doWhileCollisionWrapWithPlayer()
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (player.isAttackingEnemy()) Then
				Self.dead = True
				
				explode()
			Else
				player.beHurt()
			EndIf
		End
	Private
		' Methods:
		Method explode:Void()
			Local i:= 0
			
			Repeat
				' Magic numbers: 4, 2, 3
				If (i < PickValue((Self.type = 4), 2, 3)) Then
					GameObject.addGameObject(New StonePiece(stoneAnimation.getDrawer(5, True, 0), Self.posX, Self.posY, MyRandom.nextInt(-200, 200), MyRandom.nextInt((-GRAVITY) * 2, -GRAVITY)))
					
					i += 1
				Else
					Exit
				EndIf
			Forever
		End
End

Class StonePiece Extends GimmickObject
	Private
		' Fields:
		Field degree:Int
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method New(drawer:AnimationDrawer, posX:Int, posY:Int, vx:Int, vy:Int)
			Super.New(0, posX, posY, 0, 0, 0, 0)
			
			Self.drawer = drawer
			
			Self.velX = vx
			Self.velY = vy
			
			Self.degree = 0
		End
	Public
		' Methods:
		Method logic:Void()
			Self.velY += (GRAVITY / 4) ' Shr 2
			
			Self.posX += Self.velX
			Self.posY += Self.velY
			
			Self.degree += 20
			Self.degree Mod= 360
		End
		
		Method draw:Void(g:MFGraphics)
			g.saveCanvas()
			
			g.translateCanvas((Self.posX Shr 6) - camera.x, (Self.posY Shr 6) - camera.y)
			g.rotateCanvas(Float(Self.degree))
			
			Self.drawer.draw(g, 0, 0)
			
			g.restoreCanvas()
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method chkDestroy:Bool()
			' Magic number: 40
			Return ((Self.posY Shr 6) > (camera.y + SCREEN_HEIGHT) + 40)
		End
End