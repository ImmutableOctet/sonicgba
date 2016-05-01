Strict

Public

' Imports:
Private
	Import lib.myapi
	Import lib.soundsystem
	Import lib.constutil
	
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
			
			' Magic number: 256
			Local pos:= (y + 256)
			
			Self.posY = pos
			Self.originalY = pos
			
			If (itemBoxImage = Null) Then
				itemBoxImage = MFImage.createImage("/item/item_box.png")
			EndIf
			
			If (itemContentImage = Null) Then
				itemContentImage = MFImage.createImage("/item/item_content.png")
				
				gridWidth = (MyAPI.zoomIn(itemContentImage.getWidth(), True) Shr 3) ' / 8
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
				
				If ((player.getCharacterID() = CHARACTER_TAILS) And player.myAnimationID = PlayerTails.TAILS_ANI_FLY_1 And direction = DIRECTION_DOWN) Then
					player.velY = -600 ' -DO_POAL_MOTION_SPEED
				EndIf
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			If (Not Self.used And Not p.piping) Then
				If (direction <> DIRECTION_NONE) Then
					Select (direction)
						Case DIRECTION_UP
							If (player.isAntiGravity And p = player And p.isAttackingItem() And Self.firstTouch And player.isAntiGravity And (Not (player.getCharacterID() = CHARACTER_KNUCKLES) Or player.animationID = PlayerObject.ANI_JUMP)) Then
								doFunction(p, direction)
							Else
								Self.poping = True
								
								Self.velY = -(PlayerObject.HINER_JUMP_LIMIT / 2) ' -512
								
								Self.mapObj.setMapPosition(Self.posX, player.getCollisionRect().y0, 0, Self.velY, Self)
							EndIf
						Case DIRECTION_DOWN
							If (p = player And p.isAttackingItem() And Self.firstTouch And Not player.isAntiGravity) Then
								doFunction(p, direction)
							EndIf
							
							If (p = player And Not player.isAntiGravity) Then
								Self.isActive = True
								
								player.IsStandOnItems = True
							EndIf
						Case DIRECTION_LEFT, DIRECTION_RIGHT
							If (p = player And p.isAttackingItem() And p.getVelX() <> 0) Then
								doFunction(p, direction)
							EndIf
					End Select
					
					If (Not (Self.used Or ((player.getCharacterID() = CHARACTER_KNUCKLES) And direction = DIRECTION_UP And Not player.isAntiGravity))) Then
						p.beStop(0, direction, Self)
					EndIf
				EndIf
				
				If (Self.used) Then
					Effect.showEffect(destroyEffectAnimation, 0, Self.posX Shr 6, (Self.posY - (Self.mHeight Shr 1)) Shr 6, 0)
				EndIf
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			If (Self.isActive) Then
				player.IsStandOnItems = False
				
				Self.isActive = False
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.used Or Self.moveCount >= 0) Then
				If (Self.objId <> 0) Then
					' Magic number: 896
					drawInMap(g, itemContentImage, Self.objId * gridWidth, 0, gridWidth, gridWidth, 0, Self.posX, (Self.posY - 896) + PickValue(Self.poping, Self.posYoffset, 0), VCENTER|HCENTER)
				ElseIf (PlayerObject.getCharacterID() = CHARACTER_SONIC) Then
					' Magic number: 896
					drawInMap(g, itemContentImage, 0, 0, gridWidth, gridWidth, 0, Self.posX, (Self.posY - 896) + PickValue(Self.poping, Self.posYoffset, 0), VCENTER|HCENTER)
				Else
					Local characterID:= ((PlayerObject.getCharacterID() - 1) * gridWidth)
					
					' Magic number: 896
					drawInMap(g, itemHeadImage, characterID, 0, gridWidth, gridWidth, 0, Self.posX, (Self.posY - 896) + PickValue(Self.poping, Self.posYoffset, 0), VCENTER|HCENTER)
				EndIf
			EndIf
			
			If (Not Self.used) Then
				drawInMap(g, itemBoxImage, BOTTOM|HCENTER)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method logic:Void()
			If (Self.used) Then
				If (Self.moveCount > 0) Then
					Self.moveCount -= 1
					
					If (Self.moveCount = (MOVE_COUNT - 1) And Self.objId >= 5 And Self.objId <= 7) Then
						PlayerObject.getTmpRing(Self.objId)
					EndIf
					
					' Magic number: 200
					Self.posY -= 200
					Self.posYoffset -= 200
				EndIf
				
				If (Self.moveCount = 0) Then
					Self.moveCount = -1 ' -= 1
					
					' Check if this is a ring monitor:
					If (Self.objId >= 5 And Self.objId <= 7) Then
						soundInstance.playSe(SoundSystem.SE_117)
					EndIf
				EndIf
			EndIf
			
			If (Self.poping) Then
				If (Self.mapObj = Null) Then
					Self.mapObj = New MapObject(Self.posX + COLLISION_WIDTH, Self.posY, 0, 0, Self, 1)
					
					Self.mapObj.setMapPosition(Self.posX, Self.posY, 0, Self.velY, Self)
					Self.mapObj.setCrashCount(1)
				EndIf
				
				Self.mapObj.logic2()
				
				checkWithPlayer(Self.posX, Self.posY, Self.mapObj.getPosX(), Self.mapObj.getPosY())
				
				Self.posX = Self.mapObj.getPosX()
				Self.posY = Self.mapObj.getPosY()
				
				refreshCollisionRect(Self.posX, Self.posY)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (Self.mWidth / 2), y - Self.mHeight, Self.mWidth, Self.mHeight) ' Shr 1
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
	Private
		' Methods:
		Method doFunction:Void(player:PlayerObject, direction:Int)
			doFunction(player, direction, True)
		End
		
		Method doFunction:Void(player:PlayerObject, direction:Int, attackPose:Bool)
			If (attackPose) Then
				player.doItemAttackPose(Self, direction)
			EndIf
			
			Self.used = True
			Self.moveCount = MOVE_COUNT
			
			player.getPreItem(Self.objId)
			
			SoundSystem.getInstance().playSe(SoundSystem.SE_138)
		End
End