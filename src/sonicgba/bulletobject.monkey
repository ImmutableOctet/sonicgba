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
Public

' Classes:
Class BulletObject Extends MoveObject Abstract
	Protected
		' Constant variable(s):
		Const BULLET_ANIMAL:= 0
		Const BULLET_BAT:= 9
		Const BULLET_BEE:= 1
		Const BULLET_BOSS5:= 16
		Const BULLET_BOSS6:= 19
		Const BULLET_BOSSF3BOMB:= 20
		Const BULLET_BOSSF3RAY:= 21
		Const BULLET_BOSS_EXTRA_LASER:= 23
		Const BULLET_BOSS_EXTRA_PACMAN:= 22
		Const BULLET_BOSS_STONE:= 24
		Const BULLET_BOSS_STONE_SMALL:= 25
		Const BULLET_CATERPILLAR:= 13
		Const BULLET_CHAMELEON:= 11
		Const BULLET_CLOWN:= 10
		Const BULLET_CRAB:= 2
		Const BULLET_FROG:= 4
		Const BULLET_HERIKO:= 14
		Const BULLET_LADYBUG:= 6
		Const BULLET_LIZARD:= 8
		Const BULLET_MAGMA:= 7
		Const BULLET_MIRA:= 12
		Const BULLET_MOLE:= 15
		Const BULLET_MONKEY:= 0
		Const BULLET_MOTOR:= 3
		Const BULLET_NATURE:= 1
		Const BULLET_PENGUIN:= 18
		Const BULLET_RABBIT_FISH:= 5
		Const BULLET_ROBOT:= 17
		
		' Global variable(s):
		Global batbulletAnimation:Animation
		Global beebulletAnimation:Animation
		Global boomAnimation:Animation
		Global boss6bulletAnimation:Animation
		Global bossf3bombAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
	Private
		' Global variable(s):
		Global bulletVec:= New Stack<BulletObject>()
		
		' Fields:
		
		' This is used to toggle destruction upon hitting something.
		Field hitAndDestroy:Bool
		
		' Presumably, this is used to detect when the bullet hit something.
		Field hitted:Bool ' <-- Yes, that's what it's named.
		
		Field inCamera:Bool
	Public
		' Methods (Abstract):
		Method bulletLogic:Void() Abstract
		
		' Methods (Implemented):
		' Nothing so far.
End