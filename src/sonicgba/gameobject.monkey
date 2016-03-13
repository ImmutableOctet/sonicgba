Strict

Public

' Imports:
Import lib.animation
Import lib.animationdrawer
Import lib.myapi
Import lib.soundsystem

Import sonicgba.bulletobject
Import sonicgba.collisionmap
Import sonicgba.collisionrect
Import sonicgba.enemyobject
Import sonicgba.gimmickobject
Import sonicgba.bossobject
Import sonicgba.itemobject
Import sonicgba.mapmanager
Import sonicgba.playeranimationcollisionrect
Import sonicgba.playerobject
Import sonicgba.ringobject
Import sonicgba.rocketseparateeffect
Import sonicgba.smallanimal
Import sonicgba.sonicdebug
Import sonicgba.sonicdef

Import com.sega.engine.action.acblock
Import com.sega.engine.action.acobject
Import com.sega.mobile.framework.device.mfgraphics
Import com.sega.mobile.framework.device.mfimage

Import regal.typetool

Import monkey.stack

' Classes:
Class GameObject Extends ACObject Implements SonicDef Abstract
	' Constant variable(s):
	Public
		Const CHECK_OFFSET:= 192
		
		' Directions:
		Const DIRECTION_UP:=		0
		Const DIRECTION_DOWN:=		1
		Const DIRECTION_LEFT:=		2
		Const DIRECTION_RIGHT:=		3
		Const DIRECTION_NONE:=		4
		
		' Layers:
		Const DRAW_BEFORE_SONIC:= 0
		Const DRAW_AFTER_SONIC:= 1
		Const DRAW_AFTER_MAP:= 2
		Const DRAW_BEFORE_BEFORE_SONIC:= 3
		
		Const INIT_DISTANCE:= 14720
		
		' Load:
		Const LOAD_CONTENT:=					1
		Const LOAD_END:=						2
		Const LOAD_INDEX_ENEMY:=				2
		Const LOAD_INDEX_GIMMICK:=				0
		Const LOAD_INDEX_ITEM:=					3
		Const LOAD_INDEX_RING:=					1
		Const LOAD_NUM_IN_ONE_LOOP:=			20
		Const LOAD_OPEN_FILE:=					0
		
		' Reactions:
		Const REACTION_STOP:=		0
		Const REACTION_ATTACK:=		1
		
		' Room:
		Const ROOM_WIDTH:= 256
		Const ROOM_HEIGHT:= 256
		
		' Search:
		Const SEARCH_COUNT:= 3
		Const SEARCH_RANGE:= 10
		
		' State:
		Const STATE_NORMAL_MODE:= 0
		Const STATE_RACE_MODE:= 1
		
		' Velocity:
		Const VELOCITY_DIVIDE:= 512
	Private
		Const AVAILABLE_RANGE:= 1
		Const CLOSE_NUM_IN_ONE_LOOP:= 10
		Const DESTORY_RANGE:= 2
		
		Const PAINT_LAYER_NUM:= 4
	Protected
	
	' Global variable(s):
	Public
		' Global player reference; last resort. (Terrible, but it works)
		Global player:GameObject
		
		Global systemClock:Long ' Int ' Millisecs()
		
		' Animations:
		Global destroyEffectAnimation:Animation
		Global iceBreakAnimation:Animation
		Global platformBreakAnimation:Animation
		
		Global ringDrawer:AnimationDrawer
		
		' Flags:
		Global IsGamePause:Bool
		
		Global bossFighting:Bool
		Global isBossHalf:Bool
		Global isDamageSandActive:Bool
		Global isFirstTouchedSandSlip:Bool
		Global isFirstTouchedWind:Bool
		Global isGotRings:Bool
		Global isUnlockCage:Bool
		
		' Object collections:
		Global allGameObject:Stack<GameObject>[][]
		
		Global mainObjectLogicVec:= New Stack<GameObject>()
		Global bossObjVec:= New Stack<BossObject>() ' GameObject
		Global playerCheckVec:= New Stack<PlayerObject>() ' GameObject
		
		Global paintVec:Stack<GameObject>[] = New Stack<GameObject>[4]
		
		' Rectangles:
		Global screenRect:= New CollisionRect()
		
		Global rectH:= New CollisionRect()
		Global rectV:= New CollisionRect()
		
		Global bossID:Int
		Global camera:Coordinate
		
		' State:
		Global stageModeState:Int
		Global currentLoadIndex:Int
		Global loadNum:Int
		Global loadStep:Int
		
		Global ds:Stream ' "DataInputStream"
		
		' Fields:
		Field moveDistance:Coordinate
		Field preCollisionRect:CollisionRect
		Field collisionRect:CollisionRect
	Private
		' Flags:
		Global gettingObject:Bool
		
		' Meta:
		Global objVecWidth:Int
		Global objVecHeight:Int
		Global closeStep:Int
		Global objectCursor:Int
		
		' Coordinates:
		Global startX:Int
		Global startY:Int
		
		Global currentX:Int
		Global currentY:Int

		Global cursorX:Int
		Global cursorY:Int
		
		Global preCenterX:Int = -1
		Global preCenterY:Int = -1
		
		Global endX:Int
		Global endY:Int
		
		Global groundBlock:ACBlock
		
		' Rectangles:
		Global resetRect:= New CollisionRect()
		
		' Fields:
		Field needInit:Bool
	Protected
		Global GRAVITY:Int = 172
		
		' Animations:
		Global rockBreakAnimation:Animation
		
		' Sound:
		Global soundInstance:SoundSystem
		
		' Fields:
		Field objId:Int
		Field currentLayer:Int
		
		Field mHeight:Int
		Field mWidth:Int
		
		Field firstTouch:Bool
	Public
		' Functions:
		Function initObject:Void(mapPixelWidth:Int, mapPixelHeight:Int, sameStage:Bool)
			If (groundblock = Null) Then
				groundblock = CollisionMap.getInstance().getNewCollisionBlock()
			Endif
			
			' Deinitialize the active context.
			closeObject(sameStage)
			
			' Get a handle of the current player.
			player = PlayerObject.getPlayer()
			
			' Clear the boss-object container.
			bossObjVec.Clear()
			
			' Calculate the size of 'allGameObject':
			objVecWidth = (((mapPixelWidth + ROOM_WIDTH) - 1) / ROOM_WIDTH)
			objVecHeight = (((mapPixelHeight + ROOM_HEIGHT) - 1) / ROOM_HEIGHT)
			
			' Handle the storage semantics of our containers:
			
			' Initialize/reinitialize 'allGameObject' as needed:
			If (allGameObject.Length > 0) Then
				For Local I:= 0 Until allGameObject.Length
					For Local J:= 0 Until allGameObject[I].Length
						allGameObject[I][J].Clear()
					Next
				Next
			Else
				For Local X:= 0 Until objVecWidth
					Local xArray:= New Stack<GameObject>[]
					
					For Local Y:= 0 Until objVecHeight
						xArray[Y] = New Stack<GameObject>()
					Next
					
					allGameObject[X] = xArray
				Next
			Endif
			
			If (paintVec.Length > 0) Then
				For Local I:= 0 Until 4
					paintVec[I].Clear()
				Next
			Else
				For Local I:= 0 Until 4
					paintVec[I] = New Stack<GameObject>()
				Next
			Endif
			
			If (destroyEffectAnimation = Null) Then
				destroyEffectAnimation = New Animation("/animation/destroy_effect")
			EndIf
			
			If (rockBreakAnimation = Null) Then
				rockBreakAnimation = New Animation("/animation/iwa_patch")
			EndIf
			
			If (iceBreakAnimation = Null) Then
				iceBreakAnimation = New Animation("/animation/ice_patch")
			EndIf
			
			If (platformBreakAnimation = Null) Then
				platformBreakAnimation = new Animation("/animation/subehahen_5")
			EndIf
			
			' I'm unsure of what these are for, at the moment.
			preCenterX = -1
			preCenterY = -1
			
			' Make sure the game isn't paused.
			IsGamePause = False
			
			If (soundInstance = Null) Then
				soundInstance = SoundSystem.getInstance()
			EndIf
			
			RingObject.ringInit()
			GimmickObject.gimmickInit()
			EnemyObject.enemyInit()
			
			' Make sure we don't think we're fighting a boss.
			bossFighting = False
			
			Return
		End
		
		Function ObjectClear:Void()
			GimmickObject.gimmickInit()
			
			bossObjVec.Clear()
		End
		
		Function addGameObject:Void(o:GameObject, x:Int, y:Int)
			If (IsGamePause) Then
				Return
			EndIf
			
			
		End
		
		Function addGameObject:Void(o:GameObject)
			addGameObject(o, o.posX, o.posY)
		End
		
		' Constructor(s):
		Method New()
			Super.New(CollisionMap.getInstance())
			
			Self.firstTouch = True
			Self.preCollisionRect = New CollisionRect()
			Self.collisionRect = New CollisionRect()
			Self.moveDistance = new Coordinate()
		End
		
		' Methods (Abstract):
		
		' This acts as the primary destructor for a 'GameObject'.
		Method close:Void() Abstract
		
		' From what I understand, the second argument is the collision-type.
		Method doWhileCollision:Void(p:PlayerObject, var2:Int) Abstract
		
		' This is very likely the main update routine.
		Method logic:Void() Abstract
		
		' This is definitely the main render routine.
		Method draw:Void(graphics:MFGraphics) Abstract
		
		' This is used to update the collision bounds of a 'GameObject'.
		' The two arguments are very likely the X and Y coordinates of the object.
		Method refreshCollisionRect:Void(var1:Int, var2:Int) Abstract
		
		' Methods (Implemented):
		Method getObjectId:Int()
			Return objId
		End
End