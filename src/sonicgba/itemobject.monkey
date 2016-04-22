Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.soundsystem
	
	Import sonicgba.effect
	Import sonicgba.gameobject
	Import sonicgba.mapobject
	Import sonicgba.playerknuckles
	Import sonicgba.playerobject
	Import sonicgba.playertails
	
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class ItemObject Extends GameObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2048
		Const COLLISION_HEIGHT:Int = 1728
		
		Const MOVE_COUNT:Int = 20
		
		' Global variable(s):
		Global gridWidth:Int
		
		' Fields:
		Field mapObj:MapObject
		
		Field moveCount:Int
		Field objId:Int
		Field originalY:Int
		Field posYoffset:Int
		
		Field isActive:Bool
		Field poping:Bool
		Field used:Bool
	Public
		' Global variable(s):
		Global itemBoxImage:MFImage
		Global itemContentImage:MFImage
		Global itemHeadImage:MFImage
		
		' Functions:
		Function getNewInstance:ItemObject(id:Int, x:Int, y:Int)
			x Shl= 6
			y Shl= 6
			
			If (id = 0 And stageModeState = 1) Then
				Return Null
			EndIf
			
			Local reElement:= New ItemObject(id, x, y)
			
			reElement.refreshCollisionRect(reElement.posX, reElement.posY)
			
			Return reElement
		End
		
		Function closeItem:Void()
			itemBoxImage = Null
			itemContentImage = Null
		End
	Private
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int)
			Self.poping = False
			Self.objId = id
			Self.mWidth = COLLISION_WIDTH
			Self.mHeight = COLLISION_HEIGHT
			Self.posX = x
			Self.posYoffset = 0
			Int i = y + 256
			Self.posY = i
			Self.originalY = i
			
			If (itemBoxImage = Null) Then
				try {
					itemBoxImage = MFImage.createImage("/item/item_box.png")
				} catch (Exception e) {
					e.printStackTrace()
				}
			EndIf
			
			If (itemContentImage = Null) Then
				try {
					itemContentImage = MFImage.createImage("/item/item_content.png")
				} catch (Exception e2) {
					e2.printStackTrace()
				}
				gridWidth = MyAPI.zoomIn(itemContentImage.getWidth(), True) Shr 3
			EndIf
			
			If (itemHeadImage = Null) Then
				itemHeadImage = MFImage.createImage("/item/item_head.png")
			EndIf
			
			Self.used = False
			Self.isActive = False
		End
		
		' Methods:
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			If (Not Self.used And Not player.piping) Then
				doFunction(player, direction, animationID <> PlayerObject.ANI_HURT)
				
				Effect.showEffect(destroyEffectAnimation, 0, Self.posX Shr 6, (Self.posY - (Self.mHeight Shr 1)) Shr 6, 0)
				
				If ((player instanceof PlayerTails) And player.myAnimationID = 12 And direction = 1) Then
					player.velY = -600
				EndIf
			EndIf
		End
		
		Public Method doWhileCollision:Void(object:PlayerObject, direction:Int)
			
			If (Not Self.used And Not object.piping) Then
				If (direction <> 4) Then
					Select (direction)
						Case 0
							
							If (player.isAntiGravity) Then
								If (object = player And object.isAttackingItem() And Self.firstTouch And player.isAntiGravity And (Not (player instanceof PlayerKnuckles) Or player.animationID = 4)) Then
									doFunction(object, direction)
									break
								EndIf
							EndIf
							
							Self.poping = True
							Self.velY = -512
							Self.mapObj.setPosition(Self.posX, player.getCollisionRect().y0, 0, Self.velY, Self)
							break
						Case 1
							
							If (object = player And object.isAttackingItem() And Self.firstTouch And Not player.isAntiGravity) Then
								doFunction(object, direction)
							EndIf
							
							If (object = player And Not player.isAntiGravity) Then
								Self.isActive = True
								player.IsStandOnItems = True
								break
							EndIf
							
						Case 2
						Case SpecialObject.Z_ZOOM
							
							If (object = player And object.isAttackingItem() And object.getVelX() <> 0) Then
								doFunction(object, direction)
								break
							EndIf
							
					End Select
					
					If (Not (Self.used Or ((player instanceof PlayerKnuckles) And direction = 0 And Not player.isAntiGravity))) Then
						object.beStop(0, direction, Self)
					EndIf
				EndIf
				
				If (Self.used) Then
					Effect.showEffect(destroyEffectAnimation, 0, Self.posX Shr 6, (Self.posY - (Self.mHeight Shr 1)) Shr 6, 0)
				EndIf
			EndIf
			
		End
		
		Public Method doWhileNoCollision:Void()
			
			If (Self.isActive) Then
				player.IsStandOnItems = False
				Self.isActive = False
			EndIf
			
		End
		
		Public Method draw:Void(g:MFGraphics)
			
			If (Not Self.used Or Self.moveCount >= 0) Then
				If (Self.objId <> 0) Then
					drawInMap(g, itemContentImage, Self.objId * gridWidth, 0, gridWidth, gridWidth, 0, Self.posX, (Self.posY - 896) + (Self.poping ? Self.posYoffset : 0), 3)
				ElseIf (PlayerObject.getCharacterID() = 0) Then
					r2 = itemContentImage
					r5 = gridWidth
					r6 = gridWidth
					r8 = Self.posX
					r0 = Self.posY - 896
					
					If (Self.poping) Then
						r1 = Self.posYoffset
					Else
						r1 = 0
					EndIf
					
					drawInMap(g, r2, 0, 0, r5, r6, 0, r8, r0 + r1, 3)
				Else
					r2 = itemHeadImage
					Int characterID = (PlayerObject.getCharacterID() - 1) * gridWidth
					r5 = gridWidth
					r6 = gridWidth
					r8 = Self.posX
					r0 = Self.posY - 896
					
					If (Self.poping) Then
						r1 = Self.posYoffset
					Else
						r1 = 0
					EndIf
					
					drawInMap(g, r2, characterID, 0, r5, r6, 0, r8, r0 + r1, 3)
				EndIf
			EndIf
			
			If (Not Self.used) Then
				drawInMap(g, itemBoxImage, 33)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Public Method logic:Void()
			
			If (Self.used) Then
				If (Self.moveCount > 0) Then
					Self.moveCount -= 1
					
					If (Self.moveCount = 19 And Self.objId >= 5 And Self.objId <= 7) Then
						PlayerObject.getTmpRing(Self.objId)
					EndIf
					
					Self.posY -= 200
					Self.posYoffset -= 200
				EndIf
				
				If (Self.moveCount = 0) Then
					Self.moveCount = -1
					
					If (Self.objId >= 5 And Self.objId <= 7) Then
						soundInstance.playSe(12)
					EndIf
				EndIf
			EndIf
			
			If (Self.poping) Then
				If (Self.mapObj = Null) Then
					Self.mapObj = New MapObject(Self.posX + COLLISION_WIDTH, Self.posY, 0, 0, Self, 1)
					Self.mapObj.setPosition(Self.posX, Self.posY, 0, Self.velY, Self)
					Self.mapObj.setCrashCount(1)
				EndIf
				
				Self.mapObj.logic2()
				checkWithPlayer(Self.posX, Self.posY, Self.mapObj.getPosX(), Self.mapObj.getPosY())
				Self.posX = Self.mapObj.getPosX()
				Self.posY = Self.mapObj.getPosY()
				refreshCollisionRect(Self.posX, Self.posY)
			EndIf
			
		End
		
		Public Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (Self.mWidth Shr 1), y - Self.mHeight, Self.mWidth, Self.mHeight)
		End
		
		Public Method close:Void()
		End
		
		Public Method doBeforeCollisionCheck:Void()
		End
		
		Public Method doWhileCollision:Void(arg0:ACObject, arg1:ACCollision, arg2:Int, arg3:Int, arg4:Int, arg5:Int, arg6:Int)
		End
		
		Private Method doFunction:Void(object:PlayerObject, direction:Int)
			doFunction(object, direction, True)
		End
		
		Private Method doFunction:Void(object:PlayerObject, direction:Int, attackPose:Bool)
			
			If (attackPose) Then
				object.doItemAttackPose(Self, direction)
			EndIf
			
			Self.used = True
			Self.moveCount = MOVE_COUNT
			player.getPreItem(Self.objId)
			SoundSystem.getInstance().playSe(29)
		End
		
		Public Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End