Strict

Public

#Rem
	This file contains shared behavior, storage, and entry points for game logic.
	In addition to this, the basic behavior of most objects is declared and/or defined here.
#End

' Friends:
Friend state.gamestate

' Imports:
Public
	Import sonicgba.sonicdebug
	Import sonicgba.sonicdef
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	Import lib.soundsystem
	Import lib.coordinate
	Import lib.constutil
	
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
	
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acparam
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
	
	Import brl.stream
	'Import brl.filestream
	
	Import monkey.stack
Public

' Classes:
Class GameObject Extends ACObject Abstract ' Implements SonicDef
	' Constant variable(s):
	Public
		Const CHECK_OFFSET:= 192
		
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
		
		' Loadable objData types:
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
		Const DESTORY_RANGE:= 2
		
		Const CLOSE_NUM_IN_ONE_LOOP:= 10
		
		Const PAINT_LAYER_NUM:= 4
	Protected
	
	' Global variable(s):
	Public
		' Global player reference; last resort. (Terrible, but it works)
		Global player:PlayerObject ' GameObject
		
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
		Global paintVec:Stack<GameObject>[] = New Stack<GameObject>[PAINT_LAYER_NUM]
		
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
		
		Global groundBlock:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		
		' Rectangles:
		Global resetRect:= New CollisionRect()
		
		' Fields:
		Field needInit:Bool
	Protected
		Global GRAVITY:Int = 172 ' / 2
		
		' Animations:
		Global rockBreakAnimation:Animation
		
		' Sound:
		Global soundInstance:SoundSystem
		
		' Fields:
		
		' From what I know, this is different for every 'GameObject' type.
		' Essentially, objData identifiers represent literal classes.
		' They're mainly used for "meta" behavior like deserialization.
		Field objId:Int
		
		Field currentLayer:Int
		
		Field mHeight:Int
		Field mWidth:Int
		
		Field firstTouch:Bool
	Public
		' Functions:
		Function initObject:Void(mapPixelWidth:Int, mapPixelHeight:Int, sameStage:Bool)
			' Deinitialize the active context.
			closeObject(sameStage)
			
			' Get a handle of the current player.
			player = PlayerObject.getPlayer()
			
			' Clear the boss-objData container.
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
				allGameObject = New Stack<GameObject>[objVecWidth][]
				
				For Local X:= 0 Until objVecWidth
					Local xArray:= New Stack<GameObject>[objVecHeight]
					
					For Local Y:= 0 Until objVecHeight
						xArray[Y] = New Stack<GameObject>()
					Next
					
					allGameObject[X] = xArray
				Next
			EndIf
			
			' Allocate our layers:
			If (paintVec.Length > 0 And paintVec[0] <> Null) Then
				For Local I:= 0 Until paintVec.Length ' 4
					paintVec[I].Clear()
				Next
			Else
				For Local I:= 0 Until paintVec.Length ' 4
					paintVec[I] = New Stack<GameObject>()
				Next
			EndIf
			
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
				platformBreakAnimation = New Animation("/animation/subehahen_5")
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
			
			' Initialize objData behavior:
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
			EndIf
			
			'systemClock = Millisecs()
			
			' Clear the layers' contents.
			For Local I:= 0 Until paintVec.Length ' PAINT_LAYER_NUM
				paintVec[I].Clear()
			Next
			
			' Update specialized objData behavior:
			GimmickObject.gimmickStaticLogic()
			EnemyObject.enemyStaticLogic()
			RingObject.ringLogic()
			
			' Update this specific rocket effect. I'm not sure why
			' this needs to be done here, but whatever, we'll keep it.
			RocketSeparateEffect.getInstance().logic()
			
			' Update the main player objData(s):
			
			' NOTE: If multiplayer ever gets added to this, this is where
			' you'd need to change the value of 'player', preferably in a loop.
			player.logic()
			
			' Check if the layer has control of the character:
			If (Not player.outOfControl) Then
				' They don't, let the map manager control the camera.
				MapManager.cameraLogic() ' <-- Used for automated sections and grinding.
			EndIf
			
			' Update the semantics of the objects around 'player'.
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
						' Update the current objData.
						currentObject.logic()
						
						' Check the destruction status of the objData:
						If (currentObject.objectChkDestroy()) Then
							' Formally close the objData.
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
					EndIf
					
					' Check if we need to render this objData:
					If (checkPaintNecessary(currentObject)) Then
						' Get the objData's preferred layer, and add to it.
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
					' Update the currentObject-objData.
					currentObject.logic()
					
					' Check if we should be rendering this currentObject.
					If (Not currentObject.isFarAwayCamera()) Then
						' Add this currentObject-objData to its preferred layer.
						paintVec[currentObject.getPaintLayer()].Push(currentObject)
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
			EndIf
		End
		
		Function drawPlayer:Void(graphics:MFGraphics)
			camera = MapManager.getCamera()
			
			player.draw(graphics)
		End
		
		Function drawObjectBeforeSonic:Void(graphics:MFGraphics)
			Local backRow:= paintVec[DRAW_BEFORE_BEFORE_SONIC]
			
			' Draw everything two layers behind "Sonic":
			For Local obj:= EachIn backRow
				obj.draw(graphics)
			Next
			
			Local middleRow:= paintVec[DRAW_BEFORE_SONIC]
			
			' Draw everything one layer behind "Sonic":
			For Local obj:= EachIn middleRow
				obj.draw(graphics)
			Next
			
			' Everything from here onward is before the character, but above the back two layers:
			
			' Draw animals at this layer if the capsule hasn't been broken:
			If (Not isUnlockCage) Then
				SmallAnimal.animalDraw(graphics)
			EndIf
		End
		
		Function drawObjectAfterEveryThing:Void(graphics:MFGraphics)
			camera = MapManager.getCamera()
			
			Local layer:= paintVec[DRAW_AFTER_MAP]
			
			For Local obj:= EachIn layer
				obj.draw(graphics)
			Next
			
			' Everything from here onward is drawn above the actual game world:
			
			' Draw the world's rings. (Not sure if this should stay at this layer)
			RingObject.ringDraw(graphics)
		End
		
		Function drawObjects:Void(graphics:MFGraphics)
			' Removing the pause-check here may actually be interesting.
			If (Not (ringDrawer = Null Or IsGamePause)) Then
				' From what I understand, this is updating the rings' shared animation objData.
				ringDrawer.moveOn()
			EndIf
			
			camera = MapManager.getCamera()
			
			Local layer:= paintVec[DRAW_AFTER_SONIC]
			
			For Local obj:= EachIn layer
				obj.draw(graphics)
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
					ds = MFDevice.getResourceAsStream(fileName)
					
					If (ds <> Null) Then
						loadNum = ds.ReadShort()
						
						currentLoadIndex = 0
					EndIf
				Case LOAD_CONTENT
					If (ds <> Null) Then
						Try
							For Local I:= 0 Until loadNum
								Select loadId
									Case LOAD_INDEX_GIMMICK
										#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_INDICES
											Print("Loading gimmick.")
										#End
										
										loadGimmickByStream(ds)
									Case LOAD_INDEX_RING
										#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_INDICES
											Print("Loading ring.")
										#End
										
										loadRingByStream(ds)
									Case LOAD_INDEX_ENEMY
										#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_INDICES
											Print("Loading enemy.")
										#End
										
										loadEnemyByStream(ds)
									Case LOAD_INDEX_ITEM
										#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_INDICES
											Print("Loading item.")
										#End
										
										loadItemByStream(ds)
									Default
										' Nothing so far.
								End Select
								
								currentLoadIndex += 1
							Next
							
							If (currentLoadIndex < loadNum) Then
								nextStep = False
							EndIf
						Catch err:StreamError
							' Nothing so far.
						End Try
					EndIf
				Case LOAD_END
					Try
						ds.Close()
						
						ds = Null
						
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
				
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOADED_INFO
					Print("ID: " + id)
					Print("Position: " + x + ", " + y)
					Print("Size: " + width + ", " + height)
					Print("Left: " + left + ", Top: " + top)
				#End
				
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
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_EXCEPTIONS
					Print("An exception was thrown while loading a gimmick:")
					Print(err.ToString())
				#End
			End Try
		End
		
		Function loadRingByStream:Void(ds:Stream)
			Try
				Local x:= ds.ReadShort()
				Local y:= ds.ReadShort()
				
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOADED_INFO
					Print("Position: " + x + ", " + y)
				#End
				
				addGameObject(RingObject.getNewInstance(x, y))
			Catch err:StreamError
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_EXCEPTIONS
					Print("An exception was thrown while loading a ring:")
					Print(err.ToString())
				#End
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
				
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOADED_INFO
					Print("ID: " + id)
					Print("Position: " + x + ", " + y)
					Print("Size: " + width + ", " + height)
					Print("Left: " + left + ", Top: " + top)
				#End
				
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
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_EXCEPTIONS
					Print("An exception was thrown while loading an enemy:")
					Print(err.ToString())
				#End
			End Try
		End
		
		Function loadItemByStream:Void(ds:Stream)
			Try
				Local x:= ds.ReadShort()
				Local y:= ds.ReadShort()
				
				Local id:= ds.ReadByte()
				
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOADED_INFO
					Print("ID: " + id)
					Print("Position: " + x + ", " + y)
				#End
				
				addGameObject(ItemObject.getNewInstance(id, x, y))
			Catch err:StreamError
				#If SONICGBA_GAMEOBJECT_ANNOUNCE_LOAD_EXCEPTIONS
					Print("An exception was thrown while loading an item:")
					Print(err.ToString())
				#End
			End Try
		End
		
		Function addGameObject:Void(obj:GameObject, x:Int, y:Int)
			If (obj <> Null) Then
				Local roomX:= ((x Shr 6) / ROOM_WIDTH)
				
				If (roomX >= objVecWidth) Then
					roomX = (objVecWidth - 1)
				EndIf
				
				Local roomY:= ((y Shr 6) / ROOM_HEIGHT) ' ROOM_WIDTH
				
				If (roomY >= objVecHeight) Then
					roomY = (objVecHeight - 1)
				EndIf
				
				If (roomX > -1) Then
					allGameObject[roomX][roomY].Push(obj)
				EndIf
				
				' Let the obj know we need it to update its collision.
				obj.refreshCollisionRect(obj.posX, obj.posY)
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
					
					collisionChkWithAllGameObject_HandleObject(player, currentObject, attackFlag)
					
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
					collisionChkWithAllGameObject_HandleObject(player, O, attackFlag)
				Next
			EndIf
			
			BulletObject.checkWithAllBullet(player)
		End
		
		' Extensions:
		Function releaseStageSpecificResources:Void(sameStage:Bool)
			If (Not sameStage) Then
				EnemyObject.releaseAllEnemyResource()
				GimmickObject.releaseGimmickResource()
			EndIf
		End
		
		Function releaseSpecialObjects:Void()
			SmallAnimal.animalClose()
			BulletObject.bulletClose()
		End
		
		' This is a custom routine used to reduce boilerplate.
		' This method will likely be modified later for performance reasons.
		Function collisionChkWithAllGameObject_HandleObject:Void(player:PlayerObject, currentObject:GameObject, attackFlag:Bool)
			If (attackFlag) Then
				For Local animRect:= EachIn player.attackRectVec
					animRect.collisionChkWithObject(currentObject)
				Next
			EndIf
			
			' Detect if this is a 'RingObject':
			
			' Optimization potential; dynamic cast.
			Local ring:= RingObject(currentObject)
			
			' Check if the player is attracting rings (Electric shield, etc):
			If (ring <> Null And player.isAttracting()) Then
				' Check this ring is within our collection radius ('attractRect'):
				If (player.attractRect.collisionChk(ring.getCollisionRect())) Then
					' Tell the ring to come toward us.
					ring.beAttract()
				EndIf
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
			
			If (allGameObject.Length > 0) Then
				' Close every objData handle:
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
				allGameObject = []
			EndIf
			
			If (paintVec.Length > 0 And paintVec[0] <> Null) Then
				For Local I:= 0 Until paintVec.Length
					paintVec[I].Clear()
				Next
			EndIf
			
			releaseSpecialObjects()
		End
		
		Function closeObject:Void(sameStage:Bool)
			closeObject()
			
			releaseStageSpecificResources(sameStage)
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
					If (allGameObject.Length <> 0) Then
						nextStep = False
						
						For Local J:= 0 Until SEARCH_RANGE
							Local current:= allGameObject[currentX][currentY]
							
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
									allGameObject = []
									
									Exit
								EndIf
							EndIf
						Next
					EndIf
				Case 2 ' LOAD_END (Clear draw-layers)
					If (paintVec.Length > 0 And paintVec[0] <> Null) Then
						For Local I:= 0 Until paintVec.Length
							paintVec[I].Clear()
						Next
					EndIf
				Case 3 ' <-- Release special objects. (Animals, bullets, etc)
					releaseSpecialObjects()
				Case 4 ' <-- Release resources.
					releaseStageSpecificResources(sameStage)
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
		
		Function quitGameState:Void()
			closeObject(False)
			
			ItemObject.closeItem()
			SmallAnimal.releaseAllResource()
			PlayerObject.doWhileQuitGame()
		End
		
		Function setPlayerPosition:Void(x:Int, y:Int)
			Local playerObject:= player
			
			If (playerObject <> Null) Then
				playerObject.posX = (x Shl 6)
				playerObject.posY = (y Shr 6)
			EndIf
		End
		
		Function checkPaintNecessary:Bool(obj:GameObject)
			Return obj.isInCamera()
		End
		
		Function setNewParam:Void(newParam:Int[])
			PlayerObject.setNewParam(newParam)
			
			GRAVITY = newParam[10] ' SEARCH_RANGE
		End
		
		' This handles the room placement and camera-related behavior of objects near 'currentObject'.
		' This is normally how objects move between "rooms"; the segments of the
		' level that are used to cull irrelevant (Far away) objects.
		Function checkObjWhileMoving:Void(currentObject:GameObject)
			Local centerX:Int = ((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH / 2)) / ROOM_WIDTH)
			Local centerY:Int = ((MapManager.getCamera().y + (MapManager.CAMERA_HEIGHT / 2)) / ROOM_HEIGHT)
			
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
				Local xDelta:= (centerX - preCenterX)
				Local yDelta:= (centerY - preCenterY)
				
				If (xDelta <> 0) Then
					updateObjectRoomsX((centerX + PickValue((xDelta > 0), -2, 2)), centerY, -2, 2)
					
					updateObjectRoomsX((centerX + PickValue((xDelta > 0), 1, -1)), centerY, -1, 1)
				EndIf
	
				If (yDelta <> 0) Then
					updateObjectRoomsY((centerY + PickValue((yDelta > 0), -2, 2)), centerX, -2, 2)
					
					updateObjectRoomsY((centerY + PickValue((yDelta > 0), 1, -1)), centerX, -1, 1)
				EndIf
				
				preCenterX = centerX
				preCenterY = centerY
			EndIf
		End
	Private
		' Extensions:
		Function updateObjectRoomsX:Void(x:Int, centerY:Int, y_min:Int, y_max:Int)
			If (x >= 0 And x < objVecWidth) Then
				For Local y:= (centerY + y_min) To (centerY + y_max)
					If (y >= 0 And y < objVecHeight) Then
						updateRoom(x, y)
					EndIf
				Next
			EndIf
		End
		
		Function updateObjectRoomsY:Void(y:Int, centerX:Int, x_min:Int, x_max:Int)
			If (y >= 0 And y < objVecHeight) Then
				For Local x:= (centerX + x_min) To (centerX + x_max)
					If (x >= 0 And x < objVecWidth) Then
						updateRoom(x, y)
					EndIf
				Next
			EndIf
		End
		
		' This updates the contents of the room at the position specified.
		' Basically, it checks if the objects that are normally in the room are outside of it.
		' If an object escapes the room, this will move it to the appropriate room.
		Function updateRoom:Void(x:Int, y:Int)
			Local room:= allGameObject[x][y]
			
			For Local entryIndex:= 0 Until room.Length
				Local obj:= room.Get(entryIndex)
				
				Local objX:= checkPositionToRoomX(obj)
				Local objY:= checkPositionToRoomY(obj)
				
				If (objX >= 0 And objX < objVecWidth And objY >= 0 And objY < objVecHeight And (objX <> x Or objY <> y)) Then
					room.Remove(entryIndex)
					
					entryIndex -= 1
					
					Local nextRoom:= allGameObject[objX][objY]
					
					nextRoom.Push(obj)
				EndIf
			Next
		End
		
		' These two functions convert object coordinates to "room" coordinates:
		Function checkPositionToRoomX:Int(obj:GameObject)
			Return ((obj.getCheckPositionX() Shr 6) / ROOM_WIDTH)
		End
		
		Function checkPositionToRoomY:Int(obj:GameObject)
			Return ((obj.getCheckPositionY() Shr 6) / ROOM_HEIGHT)
		End
		
		' From what I remember, this is actually unused.
		Function initGetAvailableObject:Void(currentObject:GameObject)
			objectCursor = 0
			
			Local centerX:= checkPositionToRoomX(currentObject)
			Local centerY:= checkPositionToRoomY(currentObject)
			
			If (centerX < 0 Or centerX >= objVecWidth Or centerY < 0 Or centerY >= objVecHeight) Then
				Return
			EndIf
			
			startX = centerX - 1
			startY = centerY - 1
			endX = centerX + 1
			endY = centerY + 1
			
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
				Local xDelta:= (centerX - preCenterX)
				Local yDelta:= (centerY - preCenterY)
				
				If (xDelta <> 0) Then
					updateObjectRoomsX((centerX + PickValue((xDelta > 0), -2, 2)), centerY, -2, 2)
				EndIf
	
				If (yDelta <> 0) Then
					updateObjectRoomsY((centerY + PickValue((yDelta > 0), -2, 2)), centerX, -2, 2)
				EndIf
				
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
			EndIf
			
			Local re:= allGameObject[cursorX][cursorY].Get(objectCursor)
			
			objectCursor += 1
			nextCursor()
			
			Return re
		End
		
		' This locates the map segment 'currentObject' is in, then outputs the area's contents into 'objVec'.
		Function getGameObjectVecArray:Void(currentObject:GameObject, objVec:Stack<Stack<GameObject>>)
			objVec.Clear()
			
			Local centerX:Int = ((MapManager.getCamera().x + (MapManager.CAMERA_WIDTH / 2)) / ROOM_WIDTH)
			Local centerY:Int = ((MapManager.getCamera().y + (MapManager.CAMERA_HEIGHT / 2)) / ROOM_HEIGHT)
			
			If (centerX >= 0 And centerX < objVecWidth And centerY >= 0 And centerY < objVecHeight) Then
				Local startX:= Max(centerX - 1, 0)
				Local startY:= Max(centerY - 1, 0)
				Local endX:= Min(centerX + 1, objVecWidth-1)
				Local endY:= Min(centerY + 1, objVecHeight-1)
				
				If (allGameObject.Length > 0) Then
					For Local x:= startX To endX
						For Local y:= startY To endY
							objVec.Push(allGameObject[x][y])
						Next
					Next
				EndIf
			EndIf
		End
	Public
		' Constructor(s):
		Method New()
			Super.New(CollisionMap.getInstance())
			
			Self.firstTouch = True
			Self.preCollisionRect = New CollisionRect()
			Self.collisionRect = New CollisionRect()
			Self.moveDistance = New Coordinate()
		End
		
		' Methods (Abstract):
		
		' This acts as the primary destructor for a 'GameObject'.
		Method close:Void() Abstract
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int) Abstract
		
		' This is very likely the main update routine.
		Method logic:Void() Abstract
		
		' This is the main draw routine.
		Method draw:Void(graphics:MFGraphics) Abstract
		
		' This is used to update the collision bounds of a 'GameObject'.
		' The two arguments are very likely the X and Y coordinates of the objData.
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
		
		Method isInCamera:Bool() ' Property
			Return isInCamera(PlayerObject.BACKGROUND_WIDTH)
		End
		
		Method isInCameraSmaller:Bool()
			Return isInCamera(0)
		End
		
		Method isFarAwayCamera:Bool()
			Return (Not isInCamera(ROOM_WIDTH))
		End
		
		Method isInCamera:Bool(offset:Int)
			Local camera:= MapManager.getCamera()
			
			updateScreenRect(camera)
			
			Local screen:= screenRect
			
			Local convOffset:= (offset Shl 6)
			
			screen.x0 -= convOffset
			screen.x1 += convOffset
			screen.y0 -= convOffset
			screen.y1 += convOffset
			
			Return Self.collisionRect.collisionChk(screenRect)
		End
		
		Method isInCamera:Bool(width:Int, height:Int)
			Local camera:= MapManager.getCamera()
			
			updateScreenRect(camera)
			
			Local screen:= screenRect
			
			Local convWidth:= ((width / 2) Shl 6)
			Local convHeight:= ((height / 2) Shl 6)
			
			screen.x0 -= convWidth
			screen.x1 += convWidth
			screen.y0 -= convHeight
			screen.y1 += convHeight
			
			return Self.collisionRect.collisionChk(screenRect)
		End
		
		Method isInCameraOnlyWidth:Bool(width:Int)
			isInCamera(width, STATE_NORMAL_MODE)
			
			Return Self.collisionRect.collisionChkWidth(screenRect)
		End
		
		Method isInCameraOnlyHeight:Bool(height:Int)
			isInCamera(STATE_NORMAL_MODE, height)
			
			Return Self.collisionRect.collisionChkWidth(screenRect)
		End
		
		Method isAwayFromCameraInWidth:Bool()
			Return (Not isInCameraOnlyWidth(MapManager.CAMERA_WIDTH / 2))
		End
		
		Method doWhileNoCollision:Void()
			' Empty implementation.
		End
		
		' This is used to tell the main update routine to destroy this objData.
		Method objectChkDestroy:Bool()
			Return False
		End
		
		Method doInitWhileInCamera:Void()
			' Empty implementation.
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method canBeInit:Bool()
			Return True
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_SONIC
		End
		
		Method releaseWhileBeHurt:Bool()
			Return False
		End
		
		Method refreshCollisionRectWrap:Void()
			refreshCollisionRect(Self.posX, Self.posY)
			
			Self.preCollisionRect.setTwoPosition(Self.collisionRect.x0, Self.collisionRect.y0, Self.collisionRect.x1, Self.collisionRect.y1)
		End
		
		Method transportTo:Void(x:Int, y:Int)
			Self.posX = x
			Self.posY = y
			
			refreshCollisionRectWrap()
		End
		
		Method checkInit:Bool()
			Local camera:= MapManager.getCamera()
			
			updateResetRect(camera)
			
			If (Self.needInit) Then
				If (Not resetRect.collisionChk(Self.collisionRect) And canBeInit()) Then
					doInitWhileInCamera()
					
					refreshCollisionRect(Self.posX, Self.posY)
					
					addGameObject(Self)
					
					Self.needInit = False
					
					Return True
				EndIf
			ElseIf (resetRect.collisionChk(Self.collisionRect)) Then
				Self.needInit = True
			EndIf
			
			Return False
		End
		
		Method getGroundY:Int(x:Int, y:Int, layer:Int)
			For Local I:= 0 Until SEARCH_RANGE
				y += worldInstance.getTileHeight() * AVAILABLE_RANGE ' 1
				
				Local re:= worldInstance.getWorldY(x, y, layer, ACParam.DIRECTION_UP) ' 0 ' 1
				
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
			EndIf
			
			' If no collision occurred, give the opposite response:
			If (responseA = ACParam.NO_COLLISION) Then
				Return responseB
			EndIf
			
			If (responseB = ACParam.NO_COLLISION) Then
				Return responseA
			EndIf
			
			' We've got both responses, check which is lower:
			If (responseA < responseB) Then
				Return responseA
			EndIf
			
			Return responseB
		End
		
		Method collisionChkWithObject:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			rectH.setRect(objectRect.x0, objectRect.y0 + CHECK_OFFSET, objectRect.getWidth(), objectRect.getHeight() - (PlayerObject.BODY_OFFSET / 2))
			rectV.setRect(objectRect.x0 + CHECK_OFFSET, objectRect.y0, objectRect.getWidth() - (PlayerObject.BODY_OFFSET / 2), objectRect.getHeight()) ' BACK_JUMP_SPEED_X
			
			Return (thisRect.collisionChk(rectH) Or thisRect.collisionChk(rectV))
		End
		
		Method onObjectChk:Bool(player:PlayerObject)
			Local objectRect:= player.getCollisionRect()
			Local thisRect:= getCollisionRect()
			
			rectH.setRect(objectRect.x0, objectRect.y0 + CHECK_OFFSET, objectRect.getWidth(), objectRect.getHeight() - (PlayerObject.BODY_OFFSET / 2))
			rectV.setRect(objectRect.x0 + CHECK_OFFSET, objectRect.y0, objectRect.getWidth() - (PlayerObject.BODY_OFFSET / 2), objectRect.getHeight())
			
			Return thisRect.collisionChk(rectV)
		End
		
		Method doWhileCollisionWrap:Void(player:PlayerObject)
			Local direction:= updateDirection(player)
			
			If (player.inRailState()) Then
				doWhileRail(player, direction)
			Else
				doWhileCollision(player, direction)
			EndIf
		End
		
		Method doWhileCollisionWrapWithPlayer:Void() ' player:PlayerObject
			If (player = Null Or player.isDead) Then
				Return
			EndIf
			
			Local moveDistanceX:= player.getMoveDistance().x
			'Local moveDistanceY:= player.getMoveDistance().y
			
			player.refreshCollisionRectWrap()
			
			Local direction:= updateDirection(player)
			
			If (player.isFootOnObject(Self)) Then
				Local y:Int
				
				If (player.isAntiGravity) Then
					y = Self.collisionRect.y1
				Else
					y = Self.collisionRect.y0
				EndIf
				
				player.moveOnObject(player.footPointX + moveDistanceX, y)
			ElseIf (collisionChkWithObject(player)) Then
				If (player.railing) Then
					doWhileRail(player, direction)
				Else
					doWhileCollision(player, direction)
				EndIf
			EndIf
			
			Self.preCollisionRect.setTwoPosition(Self.collisionRect.x0, Self.collisionRect.y0, Self.collisionRect.x1, Self.collisionRect.y1)
		End
		
		Method checkWithMap:Void(preX:Int, preY:Int, posX:Int, posY:Int)
			Local moveDistanceX:= (posX - preX)
			Local moveDistanceY:= (posY - preY)
			
			Local moveDistanceX2:= moveDistanceX
			Local moveDistanceY2:= moveDistanceY
			
			Local quaNumX:= (((Abs(moveDistanceX2) + VELOCITY_DIVIDE) - 1) / VELOCITY_DIVIDE)
			Local quaNumY:= (((Abs(moveDistanceY2) + VELOCITY_DIVIDE) - 1) / VELOCITY_DIVIDE)
			
			Local xFirst:Bool = (quaNumX > quaNumY)
			
			Local startPointX:= preX
			Local startPointY:= preY
			
			If (moveDistanceY2 <= 0) Then
				Return
			EndIf
			
			Local testVal:Int
			
			If (xFirst) Then
				testVal = quaNumX
			Else
				testVal = quaNumY
			EndIf
			
			For Local I:= 0 To testVal
				Local positionX:Int
				Local positionY:Int
				
				If (xFirst) Then
					positionX = startPointX
					
					If (moveDistanceX2 >= 0) Then
						positionX += (VELOCITY_DIVIDE * I)
					Else
						positionX += (-VELOCITY_DIVIDE * I)
					EndIf
					
					positionY = (((startPointY * quaNumX) + (moveDistanceY2 * I)) / quaNumX)
					
					' Not the most optimal, but it works:
					If (moveDistanceX2 > 0) Then
						If (positionX > startPointX + moveDistanceX2) Then
							positionX = (startPointX + moveDistanceX2)
							positionY = (startPointY + moveDistanceY2)
						EndIf
					ElseIf (moveDistanceX2 >= 0) Then
						positionX = startPointX
					ElseIf (positionX < startPointX + moveDistanceX2) Then
						positionX = (startPointX + moveDistanceX2)
						positionY = (startPointY + moveDistanceY2)
					EndIf
				Else
					positionY = startPointY
					
					If (moveDistanceY2 >= 0) Then
						positionY += (VELOCITY_DIVIDE * I)
					Else
						positionY += (-VELOCITY_DIVIDE * I)
					EndIf
					
					positionX = (((startPointX * quaNumY) + (moveDistanceX2 * I)) / quaNumY)
					
					If (positionY > (startPointY + moveDistanceY2)) Then
						positionX = (startPointX + moveDistanceX2)
						positionY = (startPointY + moveDistanceY2)
					EndIf
				EndIf
				
				Local checkY:= getDownCheckPointY(positionX, positionY)
				Local checkOffset:= (checkY - positionY)
				Local newPositionY:= downSideCollisionChk(positionX, checkY)
				
				If (newPositionY >= 0) Then
					Self.posY = (newPositionY - checkOffset)
					Self.posX = positionX
					
					Return ' Exit
				EndIf
			Next
		End
		
		Method checkWithPlayer:Void(preX:Int, preY:Int, currentX:Int, currentY:Int)
			Local moveDistanceX:= (currentX - preX)
			Local moveDistanceY:= (currentY - preY)
			
			If (moveDistanceX = 0 And moveDistanceY = 0) Then
				refreshCollisionRect(currentX, currentY)
				
				doWhileCollisionWrapWithPlayer()
				
				Return
			EndIf
			
			Local moveDistance:Int
			
			Local mdXAbs:= Abs(moveDistanceX)
			Local mdYAbs:= Abs(moveDistanceY)
			
			If (mdXAbs >= mdYAbs) Then
				moveDistance = mdXAbs
			Else
				moveDistance = mdYAbs
			EndIf
			
			Local preCheckX:= preX
			Local preCheckY:= preY
			
			Local i:= 0
			
			While (i < moveDistance)
				i += VELOCITY_DIVIDE
				
				If (i > moveDistance) Then ' >=
					i = moveDistance
				EndIf
				
				Local tmpCurrentX:= (preX + ((moveDistanceX * i) / moveDistance))
				Local tmpCurrentY:= (preY + ((moveDistanceY * i) / moveDistance))
				
				refreshCollisionRect(tmpCurrentX, tmpCurrentY)
				
				doWhileCollisionWrapWithPlayer()
				
				preCheckX = tmpCurrentX
				preCheckY = tmpCurrentY
			Wend
		End
		
		Method getBlockLeftSide:Int(blockX:Int, blockY:Int)
			Return ((blockX Shl SEARCH_COUNT) Shl 6)
		End
		
		Method getBlockRightSide:Int(blockX:Int, blockY:Int)
			Return ((((blockX + 1) Shl SEARCH_COUNT) - 1) Shl 6)
		End
		
		Method getBlockUpSide:Int(blockX:Int, blockY:Int)
			Return ((blockY Shl SEARCH_COUNT) Shl 6)
		End
		
		Method getBlockDownSide:Int(blockX:Int, blockY:Int)
			Return ((((blockY + 1) Shl SEARCH_COUNT) - 1) Shl 6)
		End
		
		Method getQuaParam:Int(x:Int, divide:Int)
			If (x > 0) Then
				Return (x / divide)
			EndIf
			
			Return ((x - (divide - 1)) / divide)
		End
		
		Method drawCollisionRect:Void(g:MFGraphics)
			If (SonicDebug.showCollisionRect) Then
				g.setColor(16711680)
				
				g.drawRect((Self.collisionRect.x0 Shr 6) - camera.x, (Self.collisionRect.y0 Shr 6) - camera.y, Self.collisionRect.getWidth() Shr 6, Self.collisionRect.getHeight() Shr 6)
				g.drawRect(((Self.collisionRect.x0 Shr 6) - camera.x) + 1, ((Self.collisionRect.y0 Shr 6) - camera.y) + 1, (Self.collisionRect.getWidth() Shr 6) - 2, (Self.collisionRect.getHeight() Shr 6) - 2)
			EndIf
		End
		
		Method drawInMap:Void(graphics:MFGraphics, drawer:AnimationDrawer, x:Int, y:Int)
			drawer.draw(graphics, (x Shr 6) - camera.x, (y Shr 6) - camera.y)
		End
		
		Method drawInMap:Void(graphics:MFGraphics, drawer:AnimationDrawer)
			drawInMap(graphics, drawer, Self.posX, Self.posY)
		End
		
		Method drawInMap:Void(graphics:MFGraphics, image:MFImage, x:Int, y:Int, anchor:Int)
			MyAPI.drawImage(graphics, image, (x Shr 6) - camera.x, (y Shr 6) - camera.y, anchor)
		End
		
		Method drawInMap:Void(graphics:MFGraphics, image:MFImage, anchor:Int)
			drawInMap(graphics, image, Self.posX, Self.posY, anchor)
		End
		
		Method drawInMap:Void(graphics:MFGraphics, image:MFImage, srcX:Int, srcY:Int, width:Int, height:Int, trans:Int, x:Int, y:Int, anchor:Int)
			MyAPI.drawRegion(graphics, image, srcX, srcY, width, height, trans, (x Shr 6) - camera.x, (y Shr 6) - camera.y, anchor)
		End
		
		Method drawInMap:Void(graphics:MFGraphics, image:MFImage, srcX:Int, srcY:Int, width:Int, height:Int, trans:Int, anchor:Int)
			drawInMap(graphics, image, srcX, srcY, width, height, trans, Self.posX, Self.posY, anchor)
		End
	Private
		' Methods:
		Method getDownCheckPointY:Int(x:Int, y:Int)
			refreshCollisionRect(x, y)
			
			return Self.collisionRect.y1
		End
		
		Method getUpCheckPointY:Int(x:Int, y:Int)
			refreshCollisionRect(x, y)
			
			Return Self.collisionRect.y0
		End
		
		Method downSideCollisionChk:Int(bodyPositionX:Int, bodyPositionY:Int)
			Return -1
		End
	Protected
		' Extensions:
		Method draw:Void(g:MFGraphics, visible:Bool)
			If (visible) Then
				draw(g)
			EndIf
		End
		
		Method logic:Void(x:Int, y:Int)
			logic()
		End
		
		Method updateScreenRect:Void(camera:Coordinate)
			screenRect.setRect((camera.x + MapManager.CAMERA_OFFSET_X) Shl 6, (camera.y + MapManager.CAMERA_OFFSET_Y) Shl 6, MapManager.CAMERA_WIDTH Shl 6, MapManager.CAMERA_HEIGHT Shl 6)
		End
		
		Method updateResetRect:Void(camera:Coordinate)
			resetRect.setRect(((camera.x + (MapManager.CAMERA_WIDTH / 2)) Shl 6) - INIT_DISTANCE, ((camera.y + (MapManager.CAMERA_HEIGHT / 2)) Shl 6) - INIT_DISTANCE, 29440, 29440)
		End
		
		Method checkWithMap:Void()
			' Empty implementation.
		End
		
		Method updateDirection:Int(player:PlayerObject)
			Local xFirst:Bool
			
			Local colRect:= player.getCollisionRect()
			Local prevColRect:= player.preCollisionRect
			
			xFirst = (Abs(colRect.x0 - prevColRect.x0) >= Abs(colRect.y0 - prevColRect.y0))
			
			rectH.setRect(colRect.x0, colRect.y0 + CHECK_OFFSET, colRect.getWidth(), colRect.getHeight() - (CHECK_OFFSET * 1)) ' AVAILABLE_RANGE
			rectV.setRect(colRect.x0 + CHECK_OFFSET, colRect.y0, colRect.getWidth() - (CHECK_OFFSET * 2), colRect.getHeight()) ' (AVAILABLE_RANGE * 2)
			
			Local thisRect:= Self.collisionRect ' getCollisionRect()
			
			Local rectH_and_thisRect:Bool = rectH.collisionChk(thisRect)
			Local rectV_and_thisRect:Bool = rectV.collisionChk(thisRect)
			
			If (xFirst And rectH_and_thisRect) Then
				If ((((colRect.x1 - prevColRect.x1 > 0) And prevColRect.isLeftOf(thisRect, CHECK_OFFSET)) Or (Not rectV_and_thisRect And colRect.x0 < thisRect.x0 And player.getVelX() >= -CHECK_OFFSET))) Then
					Return DIRECTION_RIGHT
				ElseIf ((colRect.x0 - prevColRect.x0 < 0 And prevColRect.isRightOf(thisRect, CHECK_OFFSET)) Or (Not rectV_and_thisRect And colRect.x1 > thisRect.x1 And player.getVelX() <= CHECK_OFFSET)) Then
					Return DIRECTION_LEFT
				EndIf
			EndIf
			
			If (rectV_and_thisRect) Then
				If (colRect.y1 - prevColRect.y1 > 0 And prevColRect.isUpOf(thisRect, CHECK_OFFSET + 5)) Then
					Return DIRECTION_DOWN
				ElseIf (colRect.y0 - prevColRect.y0 < 0 And prevColRect.isDownOf(thisRect, CHECK_OFFSET)) Then
					Return DIRECTION_UP
				EndIf
			EndIf
			
			If (rectH_and_thisRect) Then
				If ((colRect.x1 - prevColRect.x1 > 0 And prevColRect.isLeftOf(thisRect, CHECK_OFFSET)) Or (Not rectV_and_thisRect And colRect.x0 < thisRect.x0 And player.getVelX() >= -CHECK_OFFSET)) Then
					Return DIRECTION_RIGHT
				ElseIf ((colRect.x0 - prevColRect.x0 < 0 And prevColRect.isRightOf(thisRect, CHECK_OFFSET)) Or (Not rectV_and_thisRect And colRect.x1 > thisRect.x1 And player.getVelX() <= CHECK_OFFSET)) Then
					Return DIRECTION_LEFT
				EndIf
			EndIf
			
			Return DIRECTION_NONE
		End
End