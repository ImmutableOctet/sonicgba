Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.myapi
	Import lib.crlfp32
	Import lib.constutil
	Import lib.soundsystem
	
	Import sonicgba.effect
	Import sonicgba.gameobject
	Import sonicgba.moveringobject
	Import sonicgba.playerobject
	
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import monkey.stack
Public

' Classes:
Class RingObject Extends GameObject
	Private
		' Constant variable(s):
		Const DEGREE_CAL_START:Int = 270
		Const DEGREE_SPACE:Int = 20
		Const DEGREE_START:Int = 20
		
		Const MAX_RING_POP:Int = 50
		Const MAX_VELOCITY:Int = 4200
		
		Const VELOCITY_ADD:Int = 300
		Const VELOCITY_CHANGE:Int = 300
		Const VELOCITY_START:Int = 800
		
		Global VELOCITY_OFFSET_Y:Int = (GRAVITY * -3) ' Const
		Global VELOCITY_OFFSET_Y2:Int = (GRAVITY * -4) ' Const
		
		' Global variable(s):
		Global moveRingVec:Stack<RingObject> = New Stack<RingObject>()
		
		Global ringAnimation:Animation = Null
		
		' Fields:
		Field velocity:Int
		
		Field used:Bool
		Field beAttractive:Bool
	Public
		' Functions:
		Function getNewInstance:RingObject(x:Int, y:Int)
			Local reElement:= New RingObject(x Shl 6, y Shl 6)
			
			reElement.refreshCollisionRect(reElement.posX, reElement.posY)
			
			Return reElement
		End
		
		Function hurtRingExplosion:Void(ringNum:Int, x:Int, y:Int, layer:Int, antiGrivity:Bool)
			If (ringNum > MAX_RING_POP) Then
				ringNum = MAX_RING_POP
			EndIf
			
			If (antiGrivity) Then
				' Magic number: 3072
				y += 3072
			EndIf
			
			Local var5:Int
			
			If (antiGrivity) Then
				var5 = -VELOCITY_START
			Else
				var5 = VELOCITY_START
			EndIf
			
			If (ringNum = 1) Then
				Local var37:= (DSgn(Not var4) * VELOCITY_START)
				Local var38:= (((DEGREE_START / 2) + DEGREE_CAL_START Mod 170) Mod 360) ' 10
				Local var39:= ((-var37) * MyAPI.dCos(var38) / 100)
				Local var40:= (var37 * MyAPI.dSin(var38) / 100 + VELOCITY_OFFSET_Y2)
				
				addGameObject(new MoveRingObject(x, y, var39, var40, layer, systemClock))
			Else
				Local ringCount:= 0
				Local ringCount2:= velocity
				
				Local degree:Int
				
				While (ringCount < (ringNum / 2))
					degree = ringCount * DEGREE_START
					
					Local velocity3:= ((degree / 170) * VELOCITY_CHANGE) + (DSgn(Not antiGrivity) * VELOCITY_START)
					
					ringCount2 = (degree Mod 170)
					
					Local degree2:= (((ringCount2 + DEGREE_CAL_START) + 10) Mod 360)
					
					GameObject.addGameObject(New MoveRingObject(x, y, (MyAPI.dCos(degree2) * velocity3) / 100, ((MyAPI.dSin(degree2) * velocity3) / 100) + VELOCITY_OFFSET_Y, layer, systemClock))
					
					ringCount2 = (((DEGREE_CAL_START - ringCount2) - 10) Mod 360)
					
					GameObject.addGameObject(New MoveRingObject(x, y, (MyAPI.dCos(ringCount2) * velocity3) / 100, ((MyAPI.dSin(ringCount2) * velocity3) / 100) + VELOCITY_OFFSET_Y, layer, systemClock))
					
					ringCount += 1
					
					degree = ringCount2
					
					ringCount2 = velocity3
				Wend
				
				If ((ringNum Mod 2) = 1) Then
					ringNum = (((((ringCount * DEGREE_START) Mod 170) + DEGREE_CAL_START) + 10) Mod 360)
					
					GameObject.addGameObject(New MoveRingObject(x, y, (MyAPI.dCos(ringNum) * ringCount2) / 100, (MyAPI.dSin(ringNum) * ringCount2) / 100, layer, systemClock))
					
					x = ringCount
					y = ringCount2
				Else
					x = ringCount
					y = ringCount2
					
					ringNum = degree
				EndIf
			EndIf
			
			soundInstance.playSe(SoundSystem.SE_118)
		End
		
		Function ringInit:Void()
			moveRingVec.Clear()
		End
		
		Function ringLogic:Void()
			Local i:= 0
			
			While (i < moveRingVec.Length)
				Local ring:= moveRingVec.Get(i)
				
				ring.ringMoveLogic()
				
				If (ring.objectChkDestroy()) Then
					moveRingVec.Remove(i)
					
					i -= 1
				EndIf
				
				i += 1
			Wend
		End
		
		Function ringDraw:Void(g:MFGraphics)
			For Local ring:= EachIn moveRingVec
				ring.draw(g)
			Next
		End
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Self.velocity = 0
			
			Self.posX = x
			Self.posY = y
			
			If (ringDrawer = Null) Then
				ringAnimation = New Animation("/animation/ring")
				
				ringDrawer = ringAnimation.getDrawer()
				ringDrawer.setPause(True)
			EndIf
			
			Self.used = False
			Self.beAttractive = False
			
			Self.mWidth = 1024
			Self.mHeight = 1024
		End
	Public
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Not Self.used And Not player.hurtNoControl And Not player.isSharked) Then
				Self.used = True
				
				Effect.showEffect(ringAnimation, 1, (Self.posX Shr 6), (Self.posY Shr 6), 0)
				
				PlayerObject.getRing(1)
				
				soundInstance.playSe(SoundSystem.SE_117)
				
				isGotRings = True
			EndIf
		End
		
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			doWhileCollision(player, direction)
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.used) Then
				drawInMap(g, ringDrawer)
			EndIf
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method ringMoveLogic:Void()
			If (Self.beAttractive) Then
				Self.velocity += VELOCITY_CHANGE
				
				If (Self.velocity > MAX_VELOCITY) Then
					Self.velocity = MAX_VELOCITY
				EndIf
				
				Local distanceX:= (player.getCheckPositionX() - Self.posX)
				Local distanceY:= (player.getCheckPositionY() - Self.posY)
				
				If (distanceX = 0 And distanceY = 0) Then
					doWhileCollision(player, DIRECTION_NONE)
					
					Return
				EndIf
				
				Local degree:= ((crlFP32.actTanDegree(distanceY, distanceX) + 360) Mod 360)
				
				Local powerX:= ((Self.velocity * MyAPI.dCos(degree)) / 100)
				Local powerY:= ((Self.velocity * MyAPI.dSin(degree)) / 100)
				
				If (Abs(powerX) > Abs(distanceX)) Then
					powerX = distanceX
				EndIf
				
				If (Abs(powerY) > Abs(distanceY)) Then
					powerY = distanceY
				EndIf
				
				Self.posX += powerX
				Self.posY += powerY
				
				refreshCollisionRect(Self.posX, Self.posY)
				
				If (collisionChkWithObject(player)) Then
					doWhileCollision(player, DIRECTION_NONE)
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic number: 128
			Self.collisionRect.setRect(x - (Self.mWidth / 2), y - Self.mHeight, Self.mWidth, Self.mHeight + 128) ' Shr 1
		End
		
		Method close:Void()
			' Empty implementation.
		End
		
		Method beAttract:Void()
			If (Not Self.beAttractive) Then
				Self.beAttractive = True
				
				moveRingVec.Push(Self)
			EndIf
		End
		
		Method objectChkDestroy:Bool()
			Return Self.used
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
		
		Method onCollision:Void(aCObject:ACObject, aCCollision:ACCollision, direction:Int, touchX:Int, touchY:Int, objTouchX:Int, objTouchY:Int)
			' Empty implementation.
		End
End