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
		
		Public Function closeObjects:Void()
			extraObjects.removeAllElements()
			paintObjects.removeAllElements()
			decideObjects.removeAllElements()
			
			If (objectArray <> Null) Then
				For (Int i = 0; i < objectArray.length; i += 1)
					
					If (objectArray[i] <> Null) Then
						objectArray[i].close()
					EndIf
					
				Next
				objectArray = Null
			EndIf
			
			If (player <> Null) Then
				player.close()
				player = Null
			EndIf
			
		}
		
		Public Function getNewInstance:SpecialObject(id:Int, x:Int, y:Int, z:Int)
			SpecialObject re = Null
			Select (id)
				Case TitleState.STAGE_SELECT_KEY_RECORD_1
					re = New SSRing(x, y, z)
					break
				Case TitleState.STAGE_SELECT_KEY_RECORD_2
					re = New TrickRing(x, y, z)
					break
				Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
				Case Z_ZOOM
				Case TitleState.CHARACTER_RECORD_BG_SPEED
				Case SSDef.SSOBJ_BNRU_ID
				Case CAMERA_TO_PLAYER
				Case SSDef.SSOBJ_BNRD_ID
					re = New SSSpring(id, x, y, z)
					break
				Case SSDef.SSOBJ_BOMB_ID
					re = New SSBomb(x, y, z)
					break
				Case SSDef.SSOBJ_CHECKPT
					re = New SSCheckPoint(x, y, z)
					break
				Case SSDef.SSOBJ_GOAL
					re = New SSGoal(x, y, z)
					break
			End Select
			
			If (re <> Null) Then
				re.refreshCollision(re.posX, re.posY)
			EndIf
			
			Return re
		}
		
		Public Function objectLogic:Void()
			Int i
			Int startZ = ((player.posZ - CAMERA_TO_PLAYER) - 15) + 1
			Int endZ = startZ + SHOW_RANGE
			firstObj = -1
			lastObj = 0
			For (i = 0; i < objectArray.length; i += 1)
				Int objZ
				
				If (objectArray[i] <> Null) Then
					objZ = objectArray[i].posZ
					
					If (startZ <= objZ And endZ > objZ) Then
						firstObj = i
						lastObj = i
						break
					EndIf
				EndIf
				
			Next
			paintObjects.removeAllElements()
			
			If (firstObj = -1) Then
				paintObjects.addElement(player)
			Else
				For (i = firstObj; i < objectArray.length; i += 1)
					
					If (objectArray[i] <> Null) Then
						objZ = objectArray[i].posZ
						
						If (startZ <= objZ And endZ > objZ) Then
							lastObj = i
						EndIf
					EndIf
					
				Next
				Bool firstAdd = False
				i = firstObj
				While (i <= lastObj) {
					
					If (objectArray[i] <> Null) Then
						objectArray[i].logic()
						
						If (Not firstAdd And player.posZ < objectArray[i].posZ) Then
							firstAdd = True
							paintObjects.addElement(player)
						EndIf
						
						paintObjects.addElement(objectArray[i])
					EndIf
					
					i += 1
				}
				
				If (Not firstAdd) Then
					paintObjects.addElement(player)
				EndIf
			EndIf
			
			i = 0
			While (i < extraObjects.size()) {
				SpecialObject obj = (SpecialObject) extraObjects.elementAt(i)
				obj.logic()
				
				If (obj.chkDestroy()) Then
					extraObjects.removeElementAt(i)
					i -= 1
				Else
					Bool added = False
					For (Int j = 0; j < paintObjects.size(); j += 1)
						
						If (obj.posZ < ((SpecialObject) paintObjects.elementAt(j)).posZ) Then
							added = True
							paintObjects.insertElementAt(obj, j)
							break
						EndIf
						
					Next
					
					If (Not added) Then
						paintObjects.addElement(obj)
					EndIf
				EndIf
				
				i += 1
			}
			player.refreshCollisionWrap()
			For (i = 0; i < paintObjects.size(); i += 1)
				obj = (SpecialObject) paintObjects.elementAt(i)
				
				If (obj <> player And obj.posZ >= player.posZ - COLLISION_RANGE_Z) Then
					If (obj.posZ <= player.posZ + COLLISION_RANGE_Z) Then
						obj.refreshCollisionWrap()
						obj.doCollisionCheckWith(player)
					Else
						Return
					EndIf
				EndIf
				
			Next
		}
		
		Public Function drawObjects:Void(g:MFGraphics)
			
			If (Not (ringDrawer = Null Or AnimationDrawer.isAllPause())) Then
				ringDrawer.moveOn()
			EndIf
			
			For (Int i = paintObjects.size() - 1; i >= 0; i -= 1)
				((SpecialObject) paintObjects.elementAt(i)).draw(g)
			Next
		}
		
		Public Function addExtraObject:Void(object:SpecialObject)
			extraObjects.addElement(object)
		}
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
		
		Public Method SpecialObject:public(id:Int, x:Int, y:Int, z:Int)
			Self.objID = id
			Self.posX = x
			Self.posY = y
			Self.posZ = z Shr Z_ZOOM
			Self.collisionRect = New CollisionRect()
		End
		
		Public Method chkDestroy:Bool()
			Return False
		End
		
		Public Method doCollisionCheckWith:Void(obj:SpecialPlayer)
			
			If (Self.collisionRect.collisionChk(obj.collisionRect)) Then
				doWhileCollision(obj)
			EndIf
			
			If ((Self instanceof SSRing) And Self.collisionRect.collisionChk(obj.attackCollisionRect)) Then
				doWhileCollision(obj)
			EndIf
			
		End
		
		Public Method refreshCollisionWrap:Void()
			refreshCollision(Self.posX, Self.posY)
		End
		
		Public Method drawObj:Void(g:MFGraphics, drawer:AnimationDrawer, xOffset:Int, yOffset:Int)
			Graphics g2 = (Graphics) g.getSystemGraphics()
			g2.save()
			g2.translate((Float) ((drawX + (SCREEN_WIDTH Shr 1)) - SpecialMap.getCameraOffsetX()), (Float) ((drawY + (SCREEN_HEIGHT Shr 1)) - SpecialMap.getCameraOffsetY()))
			g2.scale(scale, scale)
			drawer.draw(g, xOffset, yOffset)
			g2.restore()
		End
		
		Public Method drawCollisionRect:Void(g:MFGraphics)
		End
End