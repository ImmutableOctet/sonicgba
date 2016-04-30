Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class Poal Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1600
		Const COLLISION_HEIGHT:Int = 640
		
		Global PULL_OFFSET:Int[] = [0, 256, 320] ' Const
		
		Const STATE_STAY:Byte = 0
		Const STATE_PULL:Byte = 1
		Const STATE_POP:Byte = 2
		
		' Global variable(s):
		Global poalAnimation:Animation
		
		' Fields:
		Field isH:Bool
		
		Field state:Byte
		
		Field drawer:AnimationDrawer
		
		Field drawIdStart:Int
		
		Field offsetCount:Int
		Field restCount:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (poalAnimation = Null) Then
				poalAnimation = New Animation("/animation/poal_" + StageManager.getCurrentZoneId())
			EndIf
			
			Self.isH = False
			
			Select (Self.objId)
				Case GIMMICK_POAL
					If (Self.iTop >= 0) Then
						Self.drawer = poalAnimation.getDrawer(3, False, TRANS_NONE)
					Else
						Self.drawer = poalAnimation.getDrawer(3, False, TRANS_MIRROR)
					EndIf
					
					Self.drawIdStart = 3
					
					' Magic number: 320
					Self.collisionRect.setRect(Self.posX - 320, Self.posY - COLLISION_WIDTH, COLLISION_HEIGHT, COLLISION_WIDTH) ' PULL_OFFSET[2]
					
					Self.isH = True
				Case GIMMICK_POAL_LEFT
					Self.drawer = poalAnimation.getDrawer(0, False, TRANS_NONE)
					
					Self.collisionRect.setRect(Self.posX, Self.posY, COLLISION_WIDTH, COLLISION_HEIGHT)
					
					Self.drawIdStart = 0
				Case GIMMICK_POAL_RIGHT
					Self.drawer = poalAnimation.getDrawer(0, False, TRANS_MIRROR)
					
					Self.collisionRect.setRect(Self.posX - COLLISION_WIDTH, Self.posY, COLLISION_WIDTH, COLLISION_HEIGHT)
					
					Self.drawIdStart = 0
			End Select
			
			Self.state = STATE_STAY
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(poalAnimation)
			
			poalAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			Self.drawer.setActionId(Self.drawIdStart + Self.state)
			
			drawInMap(g, Self.drawer)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.state = STATE_STAY And p = player) Then
				Select (Self.objId)
					Case GIMMICK_POAL
						Self.offsetCount = 0
						
						If (p.doPoalMotion2(Self.posX, Self.posY, (Self.iTop >= 0))) Then
							Self.state = STATE_PULL
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_175)
						EndIf
					Default
						Self.offsetCount = 0
						
						If (p.doPoalMotion((Self.collisionRect.x0 + (COLLISION_WIDTH / 2)), (Self.collisionRect.y0 + PULL_OFFSET[Self.offsetCount]), (Self.objId = GIMMICK_POAL_LEFT))) Then ' 800
							Self.state = STATE_PULL
							
							SoundSystem.getInstance().playSe(SoundSystem.SE_175)
							
							p.setFaceDegree(0)
							
							p.degreeForDraw = p.faceDegree
						EndIf
				End Select
			EndIf
		End
		
		Method logic:Void()
			Select (Self.state)
				Case STATE_PULL
					If (Self.drawer.getActionId() = (Self.drawIdStart + 1) And Self.drawer.checkEnd()) Then
						' Magic number: 10
						Self.restCount = 10
						
						Self.state = STATE_POP
						
						Local direction:= PickValue(Self.isH, PickValue((Self.iTop >= 0), DIRECTION_LEFT, DIRECTION_RIGHT), DIRECTION_DOWN)
						
						player.bePop(2400, direction)
					ElseIf (Self.isH) Then
						player.doPoalMotion2(Self.posX, Self.posY, (Self.iTop >= 0))
					Else
						player.doPoalMotion((Self.collisionRect.x0 + (COLLISION_WIDTH / 2)), (Self.collisionRect.y0 + PULL_OFFSET[Self.offsetCount]), (Self.objId = GIMMICK_POAL_LEFT))
						
						Self.offsetCount += 1
						
						If (Self.offsetCount >= PULL_OFFSET.Length) Then
							Self.offsetCount = (PULL_OFFSET.Length - 1)
						EndIf
					EndIf
				Case STATE_POP
					If (Self.restCount > 0) Then
						Self.restCount -= 1
					EndIf
					
					If (Self.restCount = 0 And Self.drawer.checkEnd()) Then
						Self.state = STATE_STAY
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End