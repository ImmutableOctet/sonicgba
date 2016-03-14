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
		Const LOAD_OPEN_FILE:=			0
		Const LOAD_CONTENT:=			1
		Const LOAD_END:=				2
		
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
		Global bossObjVec:= New Stack<GameObject>() ' BossObject
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
			Local currentObject:GameObject
			
			Local objIndex:= 0
			Local vecIndex:= 0
			
			getGameObjectVecArray(player, mainObjectLogicVec)
			
			' This isn't exactly readable, but I haven't had the time to use enumerators yet:
			While (vecIndex < mainObjectLogicVec.Length)
				Local currentVec:= mainObjectLogicVec.Get(vecIndex)
				
				' Check if we're still within the bounds of the current container:
				If (objIndex < currentVec.Length()) Then
					currentObject = currentVec.Get(objIndex)
					
					If (Not player.isControlObject(currentObject)) Then
						' Update the current object.
						currentObject.logic()
						
						' Check the destruction status of the object:
						If (currentObject.objectChkDestroy()) Then
							' Formally close the object.
							currentObject.close()
							
							' Remove the entry at this index, then move back one index.
							' Doing this ensures we don't miss the newly placed entry:
							currentVec.Remove(objIndex)
							
							objIndex -= 1
						ElseIf (currentObject.checkInit()) Then
							' Remove the entry at this index, and try the index again:
							currentVec.Remove(objIndex)
							objIndex -= 1
						EndIf
					Endif
					
					' Check if we need to render this object:
					If (checkPaintNecessary(currentObject)) Then
						' Get the object's preferred layer, and add to it.
						paintVec[currentObject.getPaintLayer()].Push(currentObject)
					EndIf
					
					objIndex += 1
				Else
					' Go to the next container:
					objIndex = 0
					vecIndex += 1
				EndIf
			Wend
			
			' Check if we have boss objects to work with:
			If (bossObjVec <> Null) Then
				' Update all boss objects:
				For currentObject = EachIn bossObjVec
					' Update the currentObject-object.
					currentObject.logic()
					
					' Check if we should be rendering this currentObject.
					If (Not currentObject.isFarAwayCamera()) Then
						' Add this currentObject-object to its preferred layer.
						paint[currentObject.getPaintLayer()].Push(currentObject)
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
		
		Function loadGimmickByStream:Void(ds:Stream)
			Try
				Local x:= ds.ReadShort()
				Local y:= ds.ReadShort()
				
				Local id:= ds.ReadByte()
				
				Local width:= ds.ReadByte()
				Local height:= ds.ReadByte()
				
				Local left:= ds.ReadByte()
				Local top:= ds.ReadByte()
				
				If (x < 0) Then
					x += ROOM_WIDTH
				EndIf
				
				If (y < 0) Then
					y += ROOM_HEIGHT ' ROOM_WIDTH
				EndIf
				
				If (width < 0) Then
					width += ROOM_WIDTH
				EndIf
				
				If (height < 0) Then
					height += ROOM_HEIGHT ' ROOM_WIDTH
				EndIf
				
				Local gimmick:= GimmickObject.getNewInstance(id, x, y, left, top, width, height)
				
				If (gimmick <> Null) Then
					addGameObject(gimmick)
				EndIf
			Catch err:StreamError
				' Nothing so far.
			End Try
		End
		
		Function loadRingByStream:Void(ds:Stream)
			Try
				addGameObject(RingObject.getNewInstance(ds.ReadShort(), ds.ReadShort()))
			Catch err:StreamError
				' Nothing so far.
			End Try
		End
		
		Function loadEnemyByStream:Void(ds:Stream)
			Try
				' Basically the same thing as the 'GimmickObject' version:
				Local x:= ds.ReadShort()
				Local y:= ds.ReadShort()
				
				Local id:= ds.ReadByte()
				
				Local width:= ds.ReadByte()
				Local height:= ds.ReadByte()
				
				Local left:= ds.ReadByte()
				Local top:= ds.ReadByte()
				
				If (x < 0) Then
					x += ROOM_WIDTH
				EndIf
				
				If (y < 0) Then
					y += ROOM_HEIGHT ' ROOM_WIDTH
				EndIf
				
				If (width < 0) Then
					width += ROOM_WIDTH
				EndIf
				
				If (height < 0) Then
					height += ROOM_HEIGHT ' ROOM_WIDTH
				EndIf
				
				Local enemy:= EnemyObject.getNewInstance(id, x, y, left, top, width, height)
				
				If (enemy <> Null) Then
					addGameObject(enemy)
				EndIf
			Catch err:StreamError
				' Nothing so far.
			End Try
		End
		
		Function loadItemByStream:Void(ds:Stream)
			Try
				addGameObject(ItemObject.getNewInstance(ds.ReadByte(), ds.ReadShort(), ds.ReadShort()))
			Catch err:StreamError
				' Nothing so far.
			End Try
		End
		
		Function addGameObject:Void(object:GameObject, x:Int, y:Int)
			If (object <> Null) Then
				Local roomX:= ((x Shr 6) / ROOM_WIDTH)
				
				If (roomX >= objVecWidth) Then
					roomX = (objVecWidth - 1)
				EndIf
				
				Local roomY:= ((y Shr 6) / ROOM_HEIGHT) ' ROOM_WIDTH
				
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
		
		' This handles the game's collision, including calls to 'collisionChkWithObject'.
		Function collisionChkWithAllGameObject:Void(player:PlayerObject)
			Local I:Int
			Local ring:RingObject
			Local attackFlag:Bool = False
			
			If (player.attackRectVec.Length > 0) Then
				attackFlag = True
			EndIf
			
			Local objIndex:= 0
			Local vecIndex:= 0
			
			getGameObjectVecArray(player, mainObjectLogicVec)
			
			' This isn't exactly readable, but I haven't had the time to use enumerators yet:
			While (vecIndex < mainObjectLogicVec.Length)
				Local currentVec:= mainObjectLogicVec.Get(vecIndex)
				
				' Check if we're still within the bounds of the current container:
				If (objIndex < currentVec.Length()) Then
					Local currentObject:= currentVec.Get(objIndex)
					
					CollisionChkWithAllGameObject_HandleObject(player, currentObject, attackFlag)
					
					objIndex += 1
				Else
					' Go to the next container:
					objIndex = 0
					vecIndex += 1
				EndIf
			Wend
			
			' Check if we have boss objects to work with:
			If (bossObjVec <> Null) Then
				' Update all boss objects:
				For Local O:= EachIn bossObjVec
					CollisionChkWithAllGameObject_HandleObject(player, O, attackFlag)
				Next
			EndIf
			
			BulletObject.checkWithAllBullet(player)
		End
		
		' Extensions:
		
		' This is a custom routine used to reduce boilerplate.
		Function CollisionChkWithAllGameObject_HandleObject:Void(player:PlayerObject, currentObject:GameObject, attackFlag:Bool)
			If (attackFlag) Then
				For Local animRect:= EachIn player.attackRectVec
					animRect.collisionChkWithObject(currentObject)
				Next
			EndIf
			
			' Detect if this is a 'RingObject':
			ring = RingObject(currentObject)
			
			' Check if the player is attracting rings (Electric shield, etc):
			If (ring <> Null And player.isAttracting()) Then
				' Check this ring is within our collection radius ('attractRing'):
				If (player.attractRing.collisionChk(ring.getCollisionRect())) Then
					' Tell the ring to come toward us.
					ring.beAttract()
				Endif
			EndIf
			
			If (currentObject.collisionChkWithObject(player)) Then
				currentObject.doWhileCollisionWrap(player)
				currentObject.firstTouch = False
			Else
				currentObject.doWhileNoCollision()
				currentObject.firstTouch = True
			EndIf
		End
		
		Function closeObject:Void()
			If (player <> Null) Then
				player.close()
			EndIf
			
			If (allGameObject <> Null) Then
				' Close every object handle:
				For Local W:= 0 Until objVecWidth
					For Local H:= 0 Until objVecHeight
						Local current:= allGameObject[W][H]
						
						For Local O:= EachIn current
							O.close()
						Next
						
						current.Clear()
					Next
				Next
				
				' For now, we'll keep the behavior like this.
				allGameObject = Null
			EndIf
			
			For Local I:= 0 Until paintVec.Length
				paintVec[I].Clear()
			Next
			
			ReleaseSpecialObjects()
		End
		
		Method closeObject:Void(sameStage:Bool)
			closeObject()
			
			ReleaseStageSpecificResources(sameStage)
		End
		
		Function closeObjectStep:Bool(sameStage:Bool)
			Local nextStep:Bool = True
			
			Select closeStep
				Case 0 ' LOAD_OPEN_FILE (Release player)
					If (player <> Null) Then
						player.close()
					EndIf
					
					currentX = 0
					currentY = 0
				Case 1 ' LOAD_CONTENT (Release content)
					If (allGameObject <> Null) Then
						nextStep = False
						
						For Local J:= 0 Until SEARCH_RANGE
							Local current:= allGameobject[currentX][currentY]
							
							For Local O:= EachIn current
								O.close()
							Next
							
							current.Clear()
							
							currentY += 1
							
							If (currentY >= objVecHeight) Then ' objVecWidth
								currentY = 0
								currentX += 1
								
								If (currentX >= objVecWidth) Then
									nextStep = True
									
									' Not the best strategy, but I'm keeping things accurate.
									allGameObject = Null
									
									Exit
								EndIf
							EndIf
						Next
					EndIf
				Case 2 ' LOAD_END (Clear draw-layers)
					For Local I:= 0 Until paintVec.Length
						paintVec[I].Clear()
					Next
				Case 3 ' <-- Release special objects. (Animals, bullets, etc)
					ReleaseSpecialObjects()
				Case 4 ' <-- Release resources.
					ReleaseStageSpecificResources(sameStage)
				Case 5 ' <-- Memory cleanup.
					' INSERT GC CLEANUP CALL HERE.
				Case 6 ' <-- Final.
					closeStep = 0 ' LOAD_OPEN_FILE
					
					Return True
			End Select
			
			If (nextStep) Then
				closeStep += 1
			EndIf
			
			Return False
		End
		
		' Extensions:
		Function ReleaseStageSpecificResources:Void(sameStage:Bool)
			If (Not sameStage) Then
				EnemyObject.releaseAllEnemyResource()
				GimmickObject.releaseAllGimmickResource()
			EndIf
		End
		
		Function ReleaseSpecialObjects:Void()
			SmallAnimal.animalClose()
			BulletObject.bulletClose()
		End
		
		Function quitGameState:Void()
			closeObject(False)
			
			ItemObject.closeItem()
			SmallAnimal.releaseAllResource()
			PlayerObject.doWhileQuitGame()
		End
		
		Function checkPaintNecessary:Bool(obj:GameObject)
			Return obj.isInCamera()
		End
		
		Function setNewParam:Void(newParam:Int[])
			PlayerObject.setNewParam(newParam)
			
			GRAVITY = newParam[10] ' SEARCH_RANGE
		End
		
		Function checkObjWhileMoving_X:Void()
			
		End
		
		' UNFINISHED FUNCTION:
		Function checkObjWhileMoving:Void(currentObject:GameObject)
			Local centerX:Int = ((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH/2)) / 256)
			Local centerY:Int = ((MapManager.getCamera().y + (MapManager.CAMERA_HEIGHT/2)) / 256)
			
			If (preCenterX = -1 And preCenterY = -1) Then
				Local xo:= centerX - 1
				
				' From what I understand, this is initializing objects that come into view.
				' In this case, the loop is accessing the neighboring segments of the map.
				For Local xo:= (centerX - 1) To (currentX+1)
					If (xo >= 0 And xo < objVecWidth) Then 
						For Local yo:= (centerY - 1) To (centerY+1)
							If (yo >= 0 And yo < objVecHeight) Then 
								For Local obj:= EachIn allGameObject[xo][yo]
									obj.doInitWhileInCamera()
								Next
							EndIf
						Next
					EndIf
				Next
				
				preCenterX = centerX
				preCenterY = centerY
			ElseIf (preCenterX <> centerX Or preCenterY <> centerY) Then
				Local xOffset:= (centerX - preCenterX)
				Local yOffset:= (centerY - preCenterY)
				
				realignObjects(False, xOffset, centerX, centerY, objVecWidth, objVecHeight, -2, 2)
				realignObjects(False, xOffset, centerX, centerY, objVecWidth, objVecHeight, -1, 1, False)
				
				realignObjects(True, (centerY - preCenterY), centerY, centerX, objVecHeight, objVecWidth, -2, 2)
				realignObjects(True, (centerY - preCenterY), centerY, centerX, objVecHeight, objVecWidth, -1, 1, False)
				
				preCenterX = centerX
				preCenterY = centerY
			EndIf
		End
	Private
		' Extensions:
		Function realignObjects:Void(arrangement:Bool, position:Int, posOffset:Int, seekOffset:Int, bounds:Int, seekBounds:Int, Low:Int=-2, High:Int=2, offsetOnAccess:Bool=True)
			If (position <> 0) Then
				If (position > 0) Then
					position = Low
				Else
					position = High
				EndIf
				
				position += posOffset
				
				If (position >= 0 And (position < bounds)) Then
					For Local opOffset:= -2 To 2
						Local opPos:= (seekOffset + opOffset)
						
						If ((opPos >= 0 And opPos < seekBounds)) Then
							Local current:Stack<GameObject>
							
							Local accessOffset:Int
							
							If (offsetOnAccess) Then
								accessOffset = seekOffset
							Else
								accessOffset = 0
							Endif
							
							If (Not arrangement) Then
								current = allGameObject[position][accessOffset + opOffset]
							Else
								current = allGameObject[accessOffset + opOffset][position]
							Endif
							
							For Local I:= 0 Until current.Length
								Local obj:= current.Get(I)
								
								Local objBlockX:= ((obj.getCheckPositionX() Shr 6) / ROOM_WIDTH)
								Local objBlockY:= ((obj.getCheckPositionY() Shr 6) / ROOM_HEIGHT) ' ROOM_WIDTH
								
								Local blockCheck:Bool
								
								If (Not arrangement) Then
									blockCheck = (Not (objBlockX = position And objBlockY = (seekOffset + opOffset)))
								Else
									blockCheck = (Not (objBlockX = (seekOffset + opOffset) And objBlockY = position))
								Endif
								
								If (objBlockX >= 0 And objBlockX < objVecWidth And objBlockX >= 0 And objBlockX < objVecHeight And blockCheck) Then
									current.Remove(I)
									
									I -= 1
									
									allGameObject[objBlockX][objBlockY].Push(obj)
								EndIf
							Next
						EndIf
					Next
				Endif
			EndIf
		End
		
		Function initGetAvailableObject:Void(currentObject:GameObject)
			objectCursor = 0
			
			Local centerX:= ((currentObject.getCheckPositionX() Shr 6) / ROOM_WIDTH)
			Local centerY:= ((currentObject.getCheckPositionY() Shr 6) / ROOM_HEIGHT) ' ROOM_WIDTH
			
			If (centerX < 0 Or centerX >= objVecWidth Or centerY < 0 Or centerY >= objVecHeight) Then
				Return
			EndIf
			
			startX = centerX - STATE_RACE_MODE
			startY = centerY - STATE_RACE_MODE
			endX = centerX + STATE_RACE_MODE
			endY = centerY + STATE_RACE_MODE
			
			If (startX < 0) Then
				startX = 0
			EndIf
			
			If (startY < 0) Then
				startY = 0
			EndIf
			
			If (endX >= objVecWidth) Then
				endX = (objVecWidth - 1)
			EndIf
			
			If (endY >= objVecHeight) Then
				endY = (objVecHeight - 1)
			EndIf
			
			cursorX = startX
			cursorY = startY
			
			gettingObject = True
			
			If (preCenterX = -1 And preCenterY = -1) Then
				preCenterX = centerX
				preCenterY = centerY
			ElseIf (Not (preCenterX = centerX And preCenterY = centerY)) Then
				realignObjects(False, (centerX - preCenterX), centerX, centerY, objVecWidth, objVecHeight, -2, 2)
				realignObjects(True, (centerY - preCenterY), centerY, centerX, objVecHeight, objVecWidth, -2, 2)
				
				preCenterX = centerX
				preCenterY = centerY
			EndIf
			
			nextCursor()
		End
		
		Function nextCursor:Void()
			While (gettingObject And objectCursor >= allGameObject[cursorX][cursorY].Length)
				objectCursor = 0
				cursorX += 1
				
				If (cursorX > endX) Then
					cursorX = startX
					
					cursorY += 1
					
					If (cursorY > endY) Then
						gettingObject = False
					EndIf
				EndIf
			Wend
		End
		
		Function getAvailableObject:GameObject()
			If (Not gettingObject) Then
				Return Null
			Endif
			
			Local re:= allGameObject[cursorX][cursorY].Get(objectCursor)
			
			objectCursor += 1
			nextCursor()
			
			Return re
		End
	Public
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
		
		Method getCollisionRect:CollisionRect()
			Return Self.collisionRect
		End
		
		Method getCheckPositionX:Int()
			Return Self.posX
		End
		
		Method getCheckPositionY:Int()
			Return Self.posY
		End
		
		Method getMoveDistance:Coordinate()
			Return Self.moveDistance
		End
		
		Method getGroundY:Int(x:Int, y:Int, layer:Int)
			For Local I:= 0 Until SEARCH_RANGE ' PlayerObject.TERMINAL_COUNT
				y += worldInstance.getTileHeight() ' * 1
				
				Local re:= worldInstance.getWorldY(x, y, layer, 1)
				
				If (re <> ACParam.NO_COLLISION) Then
					Return re
				EndIf
			Next
			
			' When in doubt, use our existing Y coordinate.
			Return y
		End
		
		Method getGroundY:Int(x:Int, y:Int)
			Local responseA:= getGroundY(x, y, 0)
			Local responseB:= getGroundY(x, y, 1)
			
			' If we're not touching anything, we're obviously still at 'y'.
			If (responseA = ACParam.NO_COLLISION And responseB = ACParam.NO_COLLISION) Then
				Return y
			Endif
			
			' If no collision occurred, give the opposite response:
			If (responseA = ACParam.NO_COLLISION) Then
				Return responseB
			EndIf
			
			If (responseB = ACParam.NO_COLLISION) Then
				Return responseA
			Endif
			
			' We've got both responses, check which is lower:
			If (responseA < responseB) Then
				Return responseA
			EndIf
			
			Return responseB
		End
		
		Method collisionChkWithObject:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			rectH.setRect(objectRect.x0, objectRect.y0 + CHECK_OFFSET, objectRect.getWidth(), objectRect.getHeight() - PlayerSonic.BACK_JUMP_SPEED_X)
			rectV.setRect(objectRect.x0 + CHECK_OFFSET, objectRect.y0, objectRect.getWidth() - PlayerSonic.BACK_JUMP_SPEED_Y, objectRect.getHeight()) ' BACK_JUMP_SPEED_X
			
			return (thisRect.collisionChk(rectH) Or thisRect.collisionChk(rectV));
		End
		
		Method onObjectChk:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			rectH.setRect(objectRect.x0, objectRect.y0 + CHECK_OFFSET, objectRect.getWidth(), objectRect.getHeight() - PlayerSonic.BACK_JUMP_SPEED_X)
			rectV.setRect(objectRect.x0 + CHECK_OFFSET, objectRect.y0, objectRect.getWidth() - PlayerSonic.BACK_JUMP_SPEED_X, objectRect.getHeight())
			
			Return thisRect.collisionChk(rectV)
		End
End