Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	
	Import monkey.stack
	
	Import sonicgba.moveobject
	Import sonicgba.playerobject
	
	' Bullet types:
	Import sonicgba.gameobject
	Import sonicgba.beebullet
	Import sonicgba.doublegravityflashbullet
	Import sonicgba.monkeybullet
	Import sonicgba.lizardbullet
	Import sonicgba.batbullet
	Import sonicgba.mirabullet
	Import sonicgba.missilebullet
	Import sonicgba.robotbullet
	Import sonicgba.penguinbullet
	Import sonicgba.boss6bullet
	Import sonicgba.bossf3bomb
	Import sonicgba.bossf3ray
	Import sonicgba.bossextrapacman
	Import sonicgba.laserdamage
	Import sonicgba.bossextrastone
Public

' Classes:
Class BulletObject Extends MoveObject Abstract
	Public
		' Constant variable(s):
		Const BULLET_ANIMAL:= 0
		Const BULLET_MONKEY:= 0
		
		Const BULLET_NATURE:= 1
		Const BULLET_BEE:= 1
		
		Const BULLET_CRAB:= 2
		Const BULLET_MOTOR:= 3
		Const BULLET_FROG:= 4
		Const BULLET_RABBIT_FISH:= 5
		Const BULLET_LADYBUG:= 6
		Const BULLET_MAGMA:= 7
		Const BULLET_LIZARD:= 8
		Const BULLET_BAT:= 9
		Const BULLET_CLOWN:= 10
		Const BULLET_CHAMELEON:= 11
		Const BULLET_MIRA:= 12
		Const BULLET_CATERPILLAR:= 13
		Const BULLET_HERIKO:= 14
		Const BULLET_MOLE:= 15
		Const BULLET_BOSS5:= 16
		Const BULLET_ROBOT:= 17
		Const BULLET_PENGUIN:= 18
		Const BULLET_BOSS6:= 19
		Const BULLET_BOSSF3BOMB:= 20
		Const BULLET_BOSSF3RAY:= 21
		Const BULLET_BOSS_EXTRA_PACMAN:= 22
		Const BULLET_BOSS_EXTRA_LASER:= 23
		Const BULLET_BOSS_STONE:= 24
		Const BULLET_BOSS_STONE_SMALL:= 25
	Protected
		' Global variable(s):
		
		' Animations:
		Global batbulletAnimation:Animation
		Global beebulletAnimation:Animation
		Global boomAnimation:Animation
		Global boss6bulletAnimation:Animation
		Global bossf3bombAnimation:Animation
		
		' This represents the last "double-gravity flash-bullet animation".
		' Basically, this will reference an animation
		' object of type A or B, as described below:
		Global doublegravityflashbulletAnimation:Animation
		
		Global doublegravityflashbulletAnimationA:Animation
		Global doublegravityflashbulletAnimationB:Animation
		
		Global laserAnimation:Animation
		Global lizardbulletAnimation:Animation
		Global mirabulletAnimation:Animation
		Global missileAnimation:Animation
		Global monkeybulletAnimation:Animation
		Global pacmanAnimation:Animation
		Global penguinbulletAnimation:Animation
		Global robotbulletAnimation:Animation
		Global stoneAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
	Private
		' Global variable(s):
		Global bulletVec:= New Stack<BulletObject>()
		
		' Fields:
		
		' This is used to toggle destruction upon hitting something.
		Field hitAndDestroy:Bool
		
		' This reflects whether this bullet has hit something.
		Field hit:Bool
		
		' This is used to detect if this bullet has been on screen.
		' In particular, this is 'True' when on screen, meaning it can be checked
		' during update routines to determine if we should cull the bullet.
		Field hasBeenInCamera:Bool
	Public
		' Functions:
		Function addBullet:Void(Id:Int, x:Int, y:Int, velX:Int, velY:Int)
			Local element:BulletObject = Null
			
			Select Id
				Case BULLET_NATURE
					element = New BeeBullet(x, y, velX, velY)
				Case BULLET_CRAB, BULLET_LADYBUG
					element = New DoubleGravityFlashBullet(x, y, velX, velY, BULLET_MONKEY)
				Case BULLET_MAGMA
					element = New DoubleGravityFlashBullet(x, y, velX, velY, BULLET_NATURE)
				Case BULLET_MONKEY
					element = New MonkeyBullet(x, y, velX, velY)
				Case BULLET_LIZARD
					element = New LizardBullet(x, y, velX, velY)
				Case BULLET_BAT
					element = New BatBullet(x, y, velX, velY)
				Case BULLET_MIRA
					element = New MiraBullet(x, y, velX, velY)
				Case BULLET_BOSS5
					element = New MissileBullet(x, y, velX, velY)
				Case BULLET_ROBOT
					element = New RobotBullet(x, y, velX, velY)
				Case BULLET_PENGUIN
					element = New PenguinBullet(x, y, velX, velY)
				Case BULLET_BOSS6
					element = New Boss6Bullet(x, y, velX, velY)
				Case BULLET_BOSSF3BOMB
					element = New BossF3Bomb(x, y, velX, velY)
				Case BULLET_BOSSF3RAY
					element = New BossF3Ray(x, y, velX)
				Case BULLET_BOSS_EXTRA_PACMAN
					element = New BossExtraPacman(x, y)
				Case BULLET_BOSS_EXTRA_LASER
					element = New LaserDamage(x, y)
				Case BULLET_BOSS_STONE
					element = New BossExtraStone(x, y)
			End Select
			
			If (element <> Null) Then
				bulletVec.Push(element)
			EndIf
		End
		
		Function bulletLogicAll:Void()
			For Local I:= 0 Until bulletVec.Length
				Local bullet:= bulletVec.Get(I)
				
				bullet.bulletLogic()
				
				If (bullet.chkDestroy()) Then
					bulletVec.Remove(I)
					
					I -= 1
				ElseIf (GameObject.checkPaintNecessary(bullet)) Then
					paintVec[bullet.getPaintLayer()].Push(bullet)
				EndIf
			Next
		End
		
		Function checkWithAllBullet:Void(player:PlayerObject)
			For Local I:= 0 Until bulletVec.Length
				Local bullet:= bulletVec.Get(I)
				
				If (bullet.collisionChkWithObject(player)) Then
					bullet.doWhileCollisionWrap(player)
				Else
					bullet.doWhileNoCollision()
				EndIf
				
				If (bullet.chkDestroy()) Then
					bulletVec.Remove(I)
					
					I -= 1
				EndIf
			Next
		End
		
		Function bulletClose:Void()
			beebulletAnimation = Null
			monkeybulletAnimation = Null
			lizardbulletAnimation = Null
			batbulletAnimation = Null
			missileAnimation = Null
			boomAnimation = Null
			mirabulletAnimation = Null
			robotbulletAnimation = Null
			penguinbulletAnimation = Null
			boss6bulletAnimation = Null
			bossf3bombAnimation = Null
			stoneAnimation = Null
			laserAnimation = Null
			pacmanAnimation = Null
			
			doublegravityflashbulletAnimation = Null
			doublegravityflashbulletAnimationA = Null
			doublegravityflashbulletAnimationB = Null
			
			For Local bullet:= EachIn bulletVec
				bullet.close()
			Next
			
			bulletVec.Clear()
		End
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int, velX:Int, velY:Int, hitDestroy:Bool)
			Self.posX = x
			Self.posY = y
			
			Self.velX = velX
			Self.velY = velY
			
			Self.hitAndDestroy = hitAndDestroy
			
			refreshCollisionRect(Self.posX, Self.posY) ' x, y
		End
	Public
		' Methods (Abstract):
		Method bulletLogic:Void() Abstract
		
		' Methods (Implemented):
		Method IsHit:Bool() ' Property
			Return Self.hit
		End
		
		Method logic:Void()
			If (Not hasBeenInCamera And isInCamera()) Then
				hasBeenInCamera = True
			EndIf
		End
		
		Method chkDestroy:Bool()
			Return ((hasBeenInCamera And Not isInCamera()) Or isFarAwayCamera() Or (hitAndDestroy And IsHit()))
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player And p.canBeHurt()) Then
				p.beHurt()
				
				Self.hit = True
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
End