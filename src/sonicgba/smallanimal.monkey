Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	
	Import sonicgba.gameobject
	Import sonicgba.mapbehavior
	Import sonicgba.mapobject
	Import sonicgba.patrolanimal
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	'Import com.sega.engine.action.acparam
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import monkey.stack
Public

' Classes:
Class SmallAnimal Extends GameObject Implements MapBehavior
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1024
		Const COLLISION_HEIGHT:Int = 1024
		
		Const ANIMAL_INIT_VEL_Y:Int = -1000
		Const ANIMAL_NUM:Int = 12
		
		Global ANIMAL_ID:Int[][] = [[1, 3, 4, 6, 11], [0, 2, 7, 8, 10], [5, 9]] ' Const
		Global ANIMAL_TYPE_INFO:Int[] = [1, 0, 1, 0, 0, 2, 0, 1, 1, 2, 1, 0, 1, 1, 0] ' Const
		Global STAGE_TO_ANIMAL_ID:Int[][] = [[6, 1, 10], [4, 8, 9], [3, 2, 5], [6, 14, 13], [11, 3, 0], [4, 7, 12]] ' Const
		Global STAGE_TO_CAGE_ANIMAL_ID:Int[][] = [[0, 10], [0, 8], [2, 7], [12, 13], [8, 10]] ' Const
		
		' Global variable(s):
		Global animalAnimation:Animation
		
		Global animalVec:Stack<SmallAnimal> = New Stack<SmallAnimal>()
		
		Global animationIndex:Int
		Global initalVelY:Int = ANIMAL_INIT_VEL_Y
		
		Global changeLayer:Bool
		
		' Fields:
		Field sourceLayer:Int
		Field startPosX:Int
		Field startPosY:Int
	Protected
		' Fields:
		Field type:Int
		
		Field drawer:AnimationDrawer
		Field mObj:MapObject
	Public
		' Constant variable(s):
		Const FLY_VELOCITY_X:Int = -1000
		Const FLY_VELOCITY_Y:Int = -300
		
		Const TYPE_STAY:Int = 0
		Const TYPE_MOVE:Int = 1
		Const TYPE_FLY:Int = 2
		
		' Functions:
		Function setInitVelY:Void(velY:Int)
			initalVelY = velY
		End
		
		Function addAnimal:Void(x:Int, y:Int, layer:Int)
			addAnimal(x, y, layer, False)
		End
		
		Function addAnimal:Void(x:Int, y:Int, layer:Int, isTransLayer:Bool)
			Local stageId:= (StageManager.getCurrentZoneId() - 1)
			
			changeLayer = isTransLayer
			
			addAnimalByID(STAGE_TO_ANIMAL_ID[stageId][animationIndex], x, y, PickValue(changeLayer, (-layer) + 1, layer))
			
			animationIndex += 1
			animationIndex Mod= STAGE_TO_ANIMAL_ID[stageId].Length
			
			initalVelY = ANIMAL_INIT_VEL_Y
		End
		
		Function addPatrolAnimal:Void(x:Int, y:Int, layer:Int, left:Int, right:Int)
			addPatrolAnimal(MyRandom.nextInt(TYPE_MOVE, TYPE_FLY), x, y, layer, left, right)
		End
		
		Function addAnimal:Void(type:Int, x:Int, y:Int, layer:Int)
			If (animalAnimation = Null) Then
				animalAnimation = New Animation("/animation/animal")
			EndIf
			
			Local animalIdArray:= ANIMAL_ID[type]
			
			Local obj:= New SmallAnimal(type, animalIdArray[MyRandom.nextInt(animalIdArray.Length)], x, y, layer)
			
			obj.refreshCollisionRect(x, y)
			
			animalVec.Push(obj)
		End
		
		Function addAnimalByID:Void(animalID:Int, x:Int, y:Int, layer:Int)
			If (animalAnimation = Null) Then
				animalAnimation = New Animation("/animation/animal")
			EndIf
			
			Local obj:= New SmallAnimal(ANIMAL_TYPE_INFO[animalID], animalID, x, y, layer)
			
			obj.refreshCollisionRect(x, y)
			
			animalVec.Push(obj)
		End
		
		Function addPatrolAnimal:Void(type:Int, x:Int, y:Int, layer:Int, left:Int, right:Int)
			Local animalIdArray:Int[]
			
			If (animalAnimation = Null) Then
				animalAnimation = New Animation("/animation/animal")
			EndIf
			
			Select (type)
				Case TYPE_FLY
					animalIdArray = ANIMAL_ID[type]
				Default
					animalIdArray = STAGE_TO_CAGE_ANIMAL_ID[StageManager.getCurrentZoneId() - 1]
			End Select
			
			Local obj:= New PatrolAnimal(type, animalIdArray[MyRandom.nextInt(animalIdArray.Length)], x, y, layer, left, right)
			
			obj.refreshCollisionRect(x, y)
			
			animalVec.Push(obj)
		End
		
		Function animalLogic:Void()
			Local i:= 0
			
			While (i < animalVec.Length)
				Local tmpAnimal:= animalVec.Get(i)
				
				tmpAnimal.logic()
				
				If (tmpAnimal.checkDestroy()) Then
					tmpAnimal.close()
					
					animalVec.Remove(i)
					
					i -= 1
				EndIf
				
				i += 1
			Wend
		End
		
		Function animalDraw:Void(g:MFGraphics)
			For Local animal:= EachIn animalVec
				animal.draw(g)
			Next
		End
		
		Function animalClose:Void()
			For Local animal:= EachIn animalVec
				animal.close()
			Next
			
			animalVec.Clear()
		End
		
		Function animalInit:Void()
			animalClose()
			
			If (animalAnimation = Null) Then
				animalAnimation = New Animation("/animation/animal")
			EndIf
			
			animationIndex = 0
		End
		
		Function releaseAllResource:Void()
			Animation.closeAnimation(animalAnimation)
			
			animalAnimation = Null
		End
		
		' Constructor(s):
		Method New(type:Int, animalId:Int, x:Int, y:Int, layer:Int)
			Self.posX = x
			Self.posY = y
			
			Self.startPosX = x
			Self.startPosY = y
			
			Self.sourceLayer = layer
			
			Self.type = type
			
			Self.drawer = animalAnimation.getDrawer(animalId, True, 0)
			
			If (type <> TYPE_FLY) Then
				Self.mObj = New MapObject(x, y, 0, initalVelY, Self, layer)
				
				Self.mObj.setBehavior(Self)
			EndIf
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
		End
		
		Method logic:Void()
			If (Self.type = TYPE_FLY) Then
				Self.posX += ANIMAL_INIT_VEL_Y
				Self.posY += FLY_VELOCITY_Y
			ElseIf (Self.mObj <> Null) Then
				Self.mObj.logic()
				Self.posX = Self.mObj.getPosX()
				Self.posY = Self.mObj.getPosY()
				
				If (changeLayer And Self.posY > Self.startPosY And Self.posY < Self.startPosY + (COLLISION_HEIGHT / 2)) Then
					Self.sourceLayer = ((-Self.sourceLayer) + 1)
					Self.mObj.setLayer(Self.sourceLayer)
					
					changeLayer = False
				EndIf
			EndIf
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method checkDestroy:Bool()
			Return Not isInCamera()
		End
		
		Method doWhileTouchGround:Void(vx:Int, vy:Int)
			If (Self.type = TYPE_STAY) Then
				Self.mObj.doStop()
			ElseIf (Self.type = TYPE_MOVE) Then
				Self.mObj.doJump(FLY_VELOCITY_Y, ANIMAL_INIT_VEL_Y)
			EndIf
		End
		
		Method close:Void()
			Self.mObj = Null
			Self.drawer = Null
		End
		
		Method hasSideCollision:Bool()
			Return False
		End
		
		Method hasTopCollision:Bool()
			Return False
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
		
		Method hasDownCollision:Bool()
			Return True
		End
		
		Method doWhileToucRoof:Void(vx:Int, vy:Int)
			' Empty implementation.
		End
		
		Method getGravity:Int()
			Return GRAVITY
		End
End