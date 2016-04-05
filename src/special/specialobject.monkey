Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.collisionrect
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import state.titlestate
	
	Import special.ssbomb
	Import special.sscheckpoint
	Import special.ssdef
	Import special.ssgoal
	Import special.ssmapdata
	Import special.ssring
	Import special.ssspring
	Import special.specialmap
	Import special.specialplayer
	Import special.trickring
	
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfgraphics
	
	'Import java.util.vector
	
	Import monkey.stack
Public

' Classes:
Class SpecialObject Implements SSDef Abstract
	Public
		' Constant variable(s):
		Const COLLISION_RANGE_Z:Int = 8
		Const Z_ZOOM:Int = 3
		
		' Global variable(s):
		Global player:SpecialPlayer
	Private
		' Constant variable(s):
		Const OBJ_RES_NAME:String = "/sp_obj"
		
		Const SCALE_LEFT:Int = -240
		Const SCALE_PARAM_1:Float = 320.0
		Const SCALE_RIGHT:Int = 240
		
		Const SHOW_RANGE:Int = 150
		
		' Global variable(s):
		Global extraObjects:Stack<SpecialObject> = New Stack<SpecialObject>()
		Global paintObjects:Stack<SpecialObject> = New Stack<SpecialObject>()
		
		Global objectArray:SpecialObject[]
		
		Global firstObj:Int
		Global lastObj:Int
	Protected
		' Constant variable(s):
		Const CAMERA_TO_PLAYER:Int = 6
		Const f27D:Int = 30
		
		' Global variable(s):
		Global decideObjects:Stack<SpecialObject> = New Stack<SpecialObject>()
		Global drawX:Int
		Global drawY:Int
		Global objAnimation:Animation
		Global ringDrawer:AnimationDrawer
		Global scale:Float
		
		' Fields:
		Field collisionRect:CollisionRect
		
		Field drawer:AnimationDrawer
		
		Field objID:Int
		
		Field posX:Int
		Field posY:Int
		Field posZ:Int
	Public
		' Functions:
		Function initObjects:Void()
			closeObjects()
			
			If (objAnimation = Null) Then
				objAnimation = New Animation("/special_res/sp_obj")
			EndIf
			
			player = New SpecialPlayer(PlayerObject.getCharacterID())
			
			Local tmpVector:= New Stack<SpecialObject>()
			
			Local currentStage:= SSMapData.STAGE_LIST[STAGE_ID_TO_SPECIAL_ID[StageManager.getStageID()]]
			
			For Local arguments:= EachIn currentStage
				Local tmpObj:= getNewInstance(arguments[3], arguments[0], arguments[1], arguments[2])
				
				If (tmpObj <> Null) Then
					tmpVector.Push(tmpObj)
				EndIf
			Next
			
			objectArray = tmpVector.ToArray()
		End
		
		Function closeObjects:Void()
			extraObjects.Clear()
			paintObjects.Clear()
			decideObjects.Clear()
			
			If (objectArray.Length > 0) Then
				For Local i:= 0 Until objectArray.Length
					If (objectArray[i] <> Null) Then
						objectArray[i].close()
					EndIf
				Next
				
				objectArray = []
			EndIf
			
			If (player <> Null) Then
				player.close()
				
				player = Null
			EndIf
		End
		
		Function getNewInstance:SpecialObject(id:Int, x:Int, y:Int, z:Int)
			Local re:SpecialObject = Null
			
			Select (id)
				Case SSOBJ_RING_ID
					re = New SSRing(x, y, z)
				Case SSOBJ_TRIC_ID
					re = New TrickRing(x, y, z)
				Case SSOBJ_BNBK_ID, SSOBJ_BNGO_ID, SSOBJ_BNLU_ID, SSOBJ_BNRU_ID, SSOBJ_BNLD_ID, SSOBJ_BNRD_ID
					re = New SSSpring(id, x, y, z)
				Case SSOBJ_BOMB_ID
					re = New SSBomb(x, y, z)
				Case SSOBJ_CHECKPT
					re = New SSCheckPoint(x, y, z)
				Case SSOBJ_GOAL
					re = New SSGoal(x, y, z)
			End Select
			
			If (re <> Null) Then
				re.refreshCollision(re.posX, re.posY)
			EndIf
			
			Return re
		End
		
		Function objectLogic:Void()
			Local startZ:= (((player.posZ - CAMERA_TO_PLAYER) - 15) + 1)
			Local endZ:= (startZ + SHOW_RANGE)
			
			firstObj = -1
			lastObj = 0
			
			For Local i:= 0 Until objectArray.Length
				Local objZ:Int
				
				If (objectArray[i] <> Null) Then
					objZ = objectArray[i].posZ
					
					If (startZ <= objZ And endZ > objZ) Then
						firstObj = i
						lastObj = i
						
						Exit
					EndIf
				EndIf
			Next
			
			paintObjects.Clear()
			
			If (firstObj = -1) Then
				paintObjects.Push(player)
			Else
				For Local i:= firstObj Until objectArray.Length
					If (objectArray[i] <> Null) Then
						objZ = objectArray[i].posZ
						
						If (startZ <= objZ And endZ > objZ) Then
							lastObj = i
						EndIf
					EndIf
				Next
				
				Local firstAdd:Bool = False
				
				For Local i:= firstObj To lastObj
					If (objectArray[i] <> Null) Then
						objectArray[i].logic()
						
						If (Not firstAdd And player.posZ < objectArray[i].posZ) Then
							firstAdd = True
							
							paintObjects.Push(player)
						EndIf
						
						paintObjects.Push(objectArray[i])
					EndIf
				Next
				
				If (Not firstAdd) Then
					paintObjects.Push(player)
				EndIf
			EndIf
			
			Local i:= 0
			
			While (i < extraObjects.Length)
				Local obj:= extraObjects.Get(i)
				
				obj.logic()
				
				If (obj.chkDestroy()) Then
					extraObjects.Remove(i)
					
					i -= 1
				Else
					Local added:Bool = False
					
					For Local j:= 0 Until paintObjects.Length
						If (obj.posZ < (paintObjects.Get(j)).posZ) Then
							added = True
							
							paintObjects.Insert(j, obj)
							
							Exit
						EndIf
					Next
					
					If (Not added) Then
						paintObjects.Push(obj)
					EndIf
				EndIf
				
				i += 1
			Wend
			
			player.refreshCollisionWrap()
			
			For Local obj:= EachIn paintObjects
				If (obj <> player And obj.posZ >= (player.posZ - COLLISION_RANGE_Z)) Then
					If (obj.posZ <= player.posZ + COLLISION_RANGE_Z) Then
						obj.refreshCollisionWrap()
						obj.doCollisionCheckWith(player)
					Else
						Exit
					EndIf
				EndIf
			Next
		End
		
		Function drawObjects:Void(g:MFGraphics)
			If (Not (ringDrawer = Null Or AnimationDrawer.isAllPause())) Then
				ringDrawer.moveOn()
			EndIf
			
			For Local obj:= EachIn paintObjects
				obj.draw(g)
			Next
		End
		
		Function addExtraObject:Void(obj:SpecialObject)
			extraObjects.Push(obj)
		End
	Protected
		' Functions:
		Function calDrawPosition:Void(x:Int, y:Int, z:Int)
			z = -(z - (player.posZ - CAMERA_TO_PLAYER))
			y = -y
			drawX = (x * f27D) / (f27D - z)
			drawY = (y * f27D) / (f27D - z)
			scale = ((Float((7200 / (f27D - z)) - (-7200 / (f27D - z)))) / SCALE_PARAM_1)
		End
	Public
		' Methods (Abstract):
		Method close:Void() Abstract
		Method doWhileCollision:Void(specialObject:SpecialObject) Abstract
		Method draw:Void(mFGraphics:MFGraphics) Abstract
		Method logic:Void() Abstract
		Method refreshCollision:Void(x:Int, y:Int) Abstract
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, z:Int)
			Self.objID = id
			
			Self.posX = x
			Self.posY = y
			Self.posZ = (z Shr Z_ZOOM)
			
			Self.collisionRect = New CollisionRect()
		End
		
		' Methods (Implemented):
		Method chkDestroy:Bool()
			Return False
		End
		
		Method doCollisionCheckWith:Void(obj:SpecialPlayer)
			If (Self.collisionRect.collisionChk(obj.collisionRect)) Then
				doWhileCollision(obj)
			EndIf
		End
		
		Method refreshCollisionWrap:Void()
			refreshCollision(Self.posX, Self.posY)
		End
		
		Method drawObj:Void(g:MFGraphics, drawer:AnimationDrawer, xOffset:Int, yOffset:Int)
			Local nativeContext:= g.getSystemGraphics()
			
			nativeContext.save()
			
			nativeContext.translate(Float((drawX + (SCREEN_WIDTH Shr 1)) - SpecialMap.getCameraOffsetX()), Float((drawY + (SCREEN_HEIGHT Shr 1)) - SpecialMap.getCameraOffsetY()))
			nativeContext.scale(scale, scale)
			
			drawer.draw(g, xOffset, yOffset)
			
			nativeContext.restore()
		End
		
		Method drawCollisionRect:Void(g:MFGraphics)
			' Empty implementation.
		End
End