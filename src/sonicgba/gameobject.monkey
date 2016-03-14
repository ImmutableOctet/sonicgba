Strict

Public

#Rem
	This file contains shared behavior, storage, and entry points for game logic.
	In addition to this, the basic behavior of most objects is declared and/or defined here.
#End

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
		
		' Loader steps:
		Const LOAD_CONTENT:=			1
		Const LOAD_END:=				2
		Const LOAD_OPEN_FILE:=			0
		
		Const LOAD_NUM_IN_ONE_LOOP:=	20
		
		' Loadable object types:
		Const LOAD_INDEX_GIMMICK:=		0
		Const LOAD_INDEX_RING:=			1
		Const LOAD_INDEX_ENEMY:=		2
		Const LOAD_INDEX_ITEM:=			3
		
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
		
		' This may or may not be for time-attack mode.
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
		
		' This is used to count updates for game logic.
		' Think of it as a sort of frame counter.
		Global systemClock:Int ' Long
		
		' Animations:
		Global destroyEffectAnimation:Animation
		Global iceBreakAnimation:Animation
		Global platformBreakAnimation:Animation
		
		' From what I understand, this is used to draw all rings.
		' Since it's set up this way, there's the limitation
		' of having all rings rotate at the same time.
		' It's not a big deal, but it's an interesting
		' visual quirk that's different between games.
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
		
		' This manages containers that are piped to 'mainObjectLogicVec' for game logic.
		Global allGameObject:Stack<GameObject>[][]
		
		' This is a container that's used to pass entries from 'allGameObject'
		' to the main update routine. There's no allocation needed for sub-containers.
		Global mainObjectLogicVec:= New Stack<Stack<GameObject>>()
		
		' These two containers are undocumented for now:
		Global bossObjVec:= New Stack<BossObject>() ' GameObject
		Global playerCheckVec:= New Stack<PlayerObject>() ' GameObject
		
		' This acts as our layer container. In other words,
		' this is used to draw our objects later on. This may be a major point
		' of optimization later on, but for now, it's being left alone.
		' The number of array elements corresponds to the number of layers defined above.
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
			
			' Allocate our layers:
			If (paintVec.Length > 0 And paintVec[0] <> Null) Then
				For Local I:= 0 Until 4
					paintVec[I].Clear()
				Next
			Else
				For Local I:= 0 Until 4
					paintVec[I] = New Stack<GameObject>()
				Next
			Endif
			
			' Make sure we have our default/generic animations:
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
			
			' Make sure to establish a handle to our sound-system:
			If (soundInstance = Null) Then
				soundInstance = SoundSystem.getInstance()
			EndIf
			
			' Initialize object behavior:
			RingObject.ringInit()
			GimmickObject.gimmickInit()
			EnemyObject.enemyInit()
			
			' Make sure we don't think we're fighting a boss.
			bossFighting = False
		End
		
		Function ObjectClear:Void()
			GimmickObject.gimmickInit()
			
			bossObjVec.Clear()
		End
		
		' This seems to be the main update routine for most 'GameObjects'.
		Function logicObjects:Void()
			If (IsGamePause) Then
				Return
			EndIf
			
			' Update our game's "clock":
			If (systemClock < INT_MAX) Then
				systemClock += 1
			Else
				systemClock = 0
			Endif
			
			'systemClock = Millisecs()
			
			' Clear the layers' contents.
			For Local I:= 0 Until PAINT_LAYER_NUM
				paintVec[I].Clear()
			Next
			
			' Update specialized object behavior:
			GimmickObject.gimmickStaticLogic()
			EnemyObject.enemyStaticLogic()
			RingObject.ringLogic()
			
			' Update this specific rocket effect. I'm not sure why
			' this needs to be done here, but whatever, we'll keep it.
			RocketSeparateEffect.getInstance().logic()
			
			' Update the main player object(s):
			
			' NOTE: If multiplayer ever gets added to this, this is where
			' you'd need to change the value of 'player', preferably in a loop.
			player.logic()
			
			' Check if the layer has control of the character:
			If (player.outOfControl) Then
				' They don't, let the map manager control the camera.
				MapManager.cameraLogic() ' <-- Used for automated sections and grinding.
			EndIf
			
			' Handle collision and other related behavior for 'player'.
			' This may still work if done before the camera-logic, but
			' for the sake of safety, I'm not going to change it.
			checkObjWhileMoving(player)
			
			' Update our objects:
			Local currentObj:GameObject
			
			Local objIndex:= 0
			Local vecIndex:= 0
			
			getGameObjectVecArray(player, mainObjectLogicVec)
			
			' This isn't exactly readable, but I haven't had the time to use enumerators yet:
			While (vecIndex < mainObjectLogicVec.Length)
				Local currentVec:= mainObjectLogicVec.Get(vecIndex)
				
				' Check if we're still within the bounds of the current container:
				If (objIndex < currentVec.Length()) Then
					currentObj = currentVec.Get(objIndex)
					
					If (Not player.isControlObject(currentObj)) Then
						' Update the current object.
						currentObj.logic()
						
						' Check the destruction status of the object:
						If (currentObj.objectChkDestroy()) Then
							' Formally close the object.
							currentObj.close()
							
							' Remove the entry at this index, then move back one index.
							' Doing this ensures we don't miss the newly placed entry:
							currentVec.Remove(objIndex)
							
							objIndex -= 1
						ElseIf (currentObj.checkInit()) Then
							' Remove the entry at this index, and try the index again:
							currentVec.Remove(objIndex)
							objIndex -= 1
						EndIf
					Endif
					
					' Check if we need to render this object:
					If (checkPaintNecessary(currentObj)) Then
						' Get the object's preferred layer, and add to it.
						paintVec[currentObj.getPaintLayer()].Push(currentObj)
					EndIf
				Else
					' Go to the next container:
					objIndex = 0
					vecIndex += 1
				EndIf
			Wend
			
			' Check if we have boss objects to work with:
			If (bossObjVec <> Null) Then
				' Update all boss objects:
				For Local boss:= EachIn bossObjVec
					' Update the boss-object.
					boss.logic()
					
					' Check if we should be rendering this boss.
					If (Not boss.isFarAwayCamera()) Then
						' Add this boss-object to its preferred layer.
						paint[boss.getPaintLayer()].Push(boss)
					EndIf
				Next
			EndIf
			
			' Update other specialized objects:
			
			' Any remaining bullets will now be updated.
			BulletObject.bulletLogicAll()
			
			' Update any animals, especially the ones from this last update.
			SmallAnimal.animalLogic()
			
			' This may or may not be necessary, considering we already did it:
			if (player.outOfControl) Then
				MapManager.cameraLogic()
			EndIf
		End
		
		' From what I know, this likely disables the player's input.
		Function setNoInput:Void()
			If (player <> Null) Then
				player.setNoKey()
			Endif
		End
		
		Function drawPlayer:Void(graphics:MFGraphics)
			camera = MapManager.getCamera()
			
			player.draw(graphics)
		End
		
		Function drawObjectBeforeSonic:Void(graphics:MFGraphics)
			Local backRow:= paintVec[DRAW_BEFORE_BEFORE_SONIC]
			
			' Draw everything two layers behind "Sonic":
			For Local I:= 0 Until backRow.Length
				backRow[I].draw(graphics)
			Next
			
			Local middleRow:= paintVec[DRAW_BEFORE_SONIC]
			
			' Draw everything one layer behind "Sonic":
			For Local I:= 0 Until middleRow.Length
				middleRow[I].draw(graphics)
			Next
			
			' Everything from here onward is before the character, but above the back two layers:
			
			' Draw animals at this layer if the capsule hasn't been broken:
			If (Not isUnlockCage) Then
				SmallAnimal.animalDraw(graphics)
			EndIf
		End
		
		Method drawObjectAfterEveryThing:Void(graphics:MFGraphics)
			camera = MapManager.getCamera()
			
			Local layer:= paintVec[DRAW_AFTER_MAP]
			
			For Local I:= 0 Until layer.Length
				layer[I].draw(graphics)
			Next
			
			' Everything from here onward is drawn above the actual game world:
			
			' Draw the world's rings. (Not sure if this should stay at this layer)
			RingObject.ringDraw(graphics)
		End
		
		Method drawObjects:Void(graphics:MFGraphics)
			' Removing the pause-check here may actually be interesting.
			If (Not (ringDrawer = Null Or IsGamePause)) Then
				' From what I understand, this is updating the rings' shared animation object.
				ringDrawer.moveOn()
			EndIf
			
			camera = MapManager.getCamera()
			
			Local layer:= paintVec[DRAW_AFTER_SONIC]
			
			For Local I:= 0 Until layer.Length
				layer[I].draw(graphics)
			Next
			
			' Draw animals here if the capsule has been broken:
			If (isUnlockCage) Then
				SmallAnimal.animalDraw(graphics)
			EndIf
		End
		
		Function addGameObject:Void(object:GameObject, x:Int, y:Int)
			If (object <> Null) Then
				Local roomX:= ((x Shr 6) / ROOM_WIDTH)
				
				If (roomX >= objVecWidth) Then
					roomX = (objVecWidth - 1)
				EndIf
				
				Local roomY:= ((y Shr 6) / ROOM_WIDTH) ' ROOM_HEIGHT
				
				If (roomY >= objVecHeight) Then
					roomY = (objVecHeight - 1)
				EndIf
				
				If (roomX > -1) Then
					allGameObject[roomX][roomY].Push(object)
				EndIf
				
				' Let the object know we need it to update its collision.
				object.refreshCollisionRect(object.posX, object.posY)
			EndIf
		End
		
		Function addGameObject:Void(o:GameObject)
			addGameObject(o, o.posX, o.posY)
		End
		
		Function loadObjectStep:Bool(fileName:String, loadId:Int)
			Local nextStep:Bool = True
			
			'Local ds:Stream = Null
			
			Select loadStep
				Case LOAD_OPEN_FILE
					ds = FileStream.Open(fileName, "r")
					
					If (ds = Null) Then
						Exit
					EndIf
					
					loadNum = ds.ReadShort()
					currentLoadIndex = 0
				Case LOAD_CONTENT
					If (ds = Null) Then
						Exit
					EndIf
					
					Try
						For Local I:= 0 Until loadNum
							Select loadId
								Case LOAD_INDEX_GIMMICK
									loadGimmickByStream(ds)
								Case LOAD_INDEX_RING
									loadRingByStream(ds)
								Case LOAD_INDEX_ENEMY
									loadEnemyByStream(ds)
								Case LOAD_INDEX_ITEM
									loadItemByStream(ds)
								Default
									' Nothing so far.
							End Select
							
							currentLoadIndex += 1
						Next
						
						If (currentLoadIndex < loadNum) Then
							nextStep = False
							
							Exit
						EndIf
					Catch err:StreamError
						Exit
					End Try
				Case LOAD_END
					Try
						ds.Close(); ds = Null
						
						loadStep = LOAD_OPEN_FILE
					Catch err:StreamError
						'Return False
					End Try
					
					Return True
			End Select
			
			If (nextStep) Then
				loadStep += 1
			EndIf
			
			Return False
		End
		
		Method loadGimmickByStream:Void(ds:Stream)
			Try
				
			Catch err:StreamError
				' Nothing so far.
			End Try
		End
		
		Method loadRingByStream:Void(ds:Stream)
			Try
				
			Catch err:StreamError
				' Nothing so far.
			End Try
		End
		
		Method loadEnemyByStream:Void(ds:Stream)
			Try
				
			Catch err:StreamError
				' Nothing so far.
			End Try
		End
		
		Method loadItemByStream:Void(ds:Stream)
			Try
				
			Catch err:StreamError
				' Nothing so far.
			End Try
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
		Method doWhileCollision:Void(p:PlayerObject, value:Int) Abstract
		
		' This is very likely the main update routine.
		Method logic:Void() Abstract
		
		' This is definitely the main render routine.
		Method draw:Void(graphics:MFGraphics) Abstract
		
		' This is used to update the collision bounds of a 'GameObject'.
		' The two arguments are very likely the X and Y coordinates of the object.
		Method refreshCollisionRect:Void(x:Int, y:Int) Abstract
		
		' Methods (Implemented):
		Method getObjectId:Int()
			Return objId
		End
End