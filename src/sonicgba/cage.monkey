Strict

Public

' Friends:
Friend sonicgba.gimmickobject

Friend sonicgba.boss1
Friend sonicgba.boss2
Friend sonicgba.boss3
Friend sonicgba.boss4
Friend sonicgba.boss5
Friend sonicgba.boss6

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.cagebutton
	Import sonicgba.gimmickobject
	Import sonicgba.mapbehavior
	Import sonicgba.mapmanager
	Import sonicgba.mapobject
	Import sonicgba.playerobject
	Import sonicgba.smallanimal
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class Cage Extends GimmickObject Implements MapBehavior
	Private
		' Constant variable(s):
		Const ANIMAL_CREATE_COUNT:Int = 7
		
		Const BUTTON_OFFSET_Y:Int = -3904
		
		Const COLLISION_WIDTH:Int = 3712
		Const COLLISION_HEIGHT:Int = 3392
		
		Const DOOR_SPEED_X:Int = 300
		
		Const DRAW_WIDTH:Int = 72
		Const DRAW_HEIGHT:Int = 72
		
		' States:
		Const STATE_FALL:Int = 0
		Const STATE_STAY:Int = 1
		Const STATE_EXPLOSION:Int = 2
		
		' Global variable(s):
		Global cageExplosiveImage:MFImage = Null
		Global cageImage:MFImage = Null
		
		' Fields:
		Field button:CageButton
		Field mapObj:MapObject
		
		Field state:Int
		
		Field animalCount:Int
		Field count:Int
		Field doorPosX:Int
		Field doorPosX2:Int
		Field doorPosY:Int
		Field doorVelocityY:Int
		
		Field attacking:Bool
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			If (cageImage = Null) Then
				cageImage = MFImage.createImage("/gimmick/cage.png")
			EndIf
			
			If (cageExplosiveImage = Null) Then
				cageExplosiveImage = MFImage.createImage("/gimmick/cage_door.png")
			EndIf
			
			Self.button = New CageButton(Self.posX, Self.posY + BUTTON_OFFSET_Y)
			
			GameObject.addGameObject(Self.button, Self.posX, Self.posY)
			
			Self.mapObj = New MapObject(Self.posX, Self.posY, 0, 0, Self, 1)
			
			Self.mapObj.setBehavior(Self)
			
			Self.state = STATE_FALL
			
			Self.attacking = True
			
			MapManager.setCameraLeftLimit(MapManager.getCamera().x)
			MapManager.setCameraRightLimit(MapManager.getCamera().x + MapManager.CAMERA_WIDTH)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			cageImage = Null
			cageExplosiveImage = Null
		End
		
		' Methods:
		Method logic:Void()
			Select (Self.state)
				Case STATE_FALL
					Self.mapObj.logic()
					
					checkWithPlayer(Self.posX, Self.posY, Self.mapObj.getPosX(), Self.mapObj.getPosY())
					
					Self.posX = Self.mapObj.getPosX()
					Self.posY = Self.mapObj.getPosY()
					
					If (Not Self.button.used) Then
						Self.button.posX = Self.posX
						Self.button.posY = (Self.posY + BUTTON_OFFSET_Y)
					EndIf
				Case STATE_STAY
					Self.attacking = False
					
					If (Self.button.used) Then
						Self.state = STATE_EXPLOSION
						
						soundInstance.playSe(SoundSystem.SE_137)
						
						Self.doorPosX = Self.posX
						Self.doorPosX2 = Self.posX
						Self.doorPosY = Self.posY
						
						Self.doorVelocityY = -(DOOR_SPEED_X * 2)
						
						Self.animalCount = ANIMAL_CREATE_COUNT
						
						Self.count = 0
					EndIf
				Case STATE_EXPLOSION
					Self.doorPosX -= DOOR_SPEED_X
					Self.doorPosX2 += DOOR_SPEED_X
					
					Self.doorVelocityY += GRAVITY
					
					Self.doorPosY += Self.doorVelocityY
					
					If (Self.count > 0) Then
						Self.count -= 1
					EndIf
					
					If (Self.count = 0 And Self.animalCount > 0) Then
						' Magic numbers: 2, 1, 640
						SmallAnimal.addPatrolAnimal(2, Self.posX, Self.posY - 640, 1, Self.posX - 3200, Self.posX + 3200) ' 3200 / 5
						SmallAnimal.addPatrolAnimal(1, Self.posX, Self.posY - 640, 1, Self.posX - 3200, Self.posX + 3200)
						
						Self.count = 4
						
						Self.animalCount -= 1
					EndIf
			End Select
		End
		
		Method draw:Void(g:MFGraphics)
			Select (Self.state)
				Case STATE_EXPLOSION
					drawInMap(g, cageImage, DRAW_WIDTH, 0, DRAW_WIDTH, DRAW_HEIGHT, 0, Self.posX, Self.posY, 33)
					
					Self.button.drawButton(g)
					
					drawInMap(g, cageExplosiveImage, Self.doorPosX, Self.doorPosY, 40)
					drawInMap(g, cageExplosiveImage, 0, 0, MyAPI.zoomIn(cageExplosiveImage.getWidth()), MyAPI.zoomIn(cageExplosiveImage.getHeight()), 2, Self.doorPosX2, Self.doorPosY, 36)
				Default
					drawInMap(g, cageImage, 0, 0, DRAW_WIDTH, DRAW_HEIGHT, 0, Self.posX, Self.posY, 33)
					
					Self.button.drawButton(g)
			End Select
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.attacking) Then
				player.beHurtByCage()
			Else
				player.beStop(0, direction, Self)
			EndIf
		End
		
		Method doWhileTouchGround:Void(vx:Int, vy:Int)
			Self.state = STATE_STAY
			
			soundInstance.playSe(SoundSystem.SE_136)
			
			MapManager.setShake(8)
		End
		
		Method close:Void()
			Self.mapObj = Null
			Self.button = Null
		End
		
		Method hasSideCollision:Bool()
			Return False
		End
		
		Method hasTopCollision:Bool()
			Return False
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method hasDownCollision:Bool()
			Return True
		End
		
		Method doWhileTouchRoof:Void(vx:Int, vy:Int)
			' Empty implementation.
		End
		
		Method getGravity:Int()
			Return GRAVITY
		End
End