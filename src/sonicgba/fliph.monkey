Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	'Import gameengine.def
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.line
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class FlipH Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 2880
		Const COLLISION_HEIGHT:Int = 1536
		
		Const FLIP_POWER:Int = 2450
		
		Const FLIP_POWER_MIN:Int = 2163
		Const FLIP_POWER_MAX:Int = 2858
		
		Const FLIP_POWER_RANGE:Int = 659
		
		Const FLIP_POWER_X:Int = 200
		
		' Global variable(s):
		Global flipAnimation:Animation
		
		' Fields:
		Field isUp:Bool
		Field justPop:Bool
		Field noTouch:Bool
		
		Field collisionLine:Line
		
		Field drawer:AnimationDrawer
		
		Field leftBorder:Int
		Field rightBorder:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.noTouch = True
			Self.justPop = False
			
			If (flipAnimation = Null) Then
				flipAnimation = New Animation("/animation/flip")
			EndIf
			
			Self.drawer = flipAnimation.getDrawer(2, True, PickValue((Self.iLeft = 0), TRANS_MIRROR, TRANS_NONE))
			
			' Magic number: 2432
			If (Self.iLeft = 0) Then
				Self.rightBorder = Self.posX
				Self.leftBorder = (Self.posX - 2432)
			Else
				Self.leftBorder = Self.posX
				Self.rightBorder = (Self.posX + 2432)
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(flipAnimation)
			
			flipAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			If (Self.drawer.checkEnd()) Then
				Self.drawer.setActionId(2)
				
				Self.drawer.setLoop(True)
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic numbers: 512
			If (Self.iLeft = 0) Then
				Self.collisionRect.setTwoPosition(x + 512, (y - 512) + 1, (x + 512) - COLLISION_WIDTH, ((y - 512) + 1) + COLLISION_HEIGHT)
			Else
				Self.collisionRect.setRect(x - 512, (y - 512) + 1, COLLISION_WIDTH, COLLISION_HEIGHT)
			EndIf
			
			If (Self.collisionLine = Null) Then
				Self.collisionLine = New Line()
			EndIf
			
			' Magic numbers: 2432, 704
			If (Self.iLeft = 0) Then
				Self.collisionLine.setProperty(x, y - 512, x - 2432, y + 704)
			Else
				Self.collisionLine.setProperty(x, y - 512, x + 2432, y + 704)
			EndIf
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player) Then
				If (Self.noTouch And Not Self.justPop) Then
					If (direction = DIRECTION_DOWN Or direction = DIRECTION_LEFT Or direction = DIRECTION_RIGHT) Then
						Self.isUp = True
						Self.noTouch = False
						
						If (Self.firstTouch) Then
							If (p.getFootPositionX() < Self.leftBorder) Then
								p.setFootPositionX(Self.leftBorder)
							ElseIf (p.getFootPositionX() > Self.rightBorder) Then
								p.setFootPositionX(Self.rightBorder)
							EndIf
							
							If (Not (p.getCharacterID() = CHARACTER_AMY) And Self.firstTouch) Then
								soundInstance.playSe(SoundSystem.SE_109)
							EndIf
						EndIf
					ElseIf (direction = DIRECTION_UP) Then
						Self.isUp = False
						Self.noTouch = False
					EndIf
				EndIf
				
				If (Not Self.noTouch) Then
					Local lineY:= Self.collisionLine.getY(p.getFootPositionX())
					Local playerY:= p.getFootPositionY()
					
					If (Self.isUp And playerY >= lineY And p.getMoveDistance().y >= 0) Then
						p.setNoKey()
						
						p.beStop(lineY, DIRECTION_DOWN, Self)
						
						p.setFootPositionY(lineY)
						
						p.setVelX(PickValue((Self.iLeft = 0), -128, 128))
						
						p.setAnimationId(PlayerObject.ANI_JUMP)
					EndIf
				EndIf
				
				If (direction = DIRECTION_UP) Then
					p.beStop(0, DIRECTION_UP, Self)
				EndIf
			EndIf
		End
		
		Method logic:Void()
			If (Self.justPop) Then
				Self.justPop = False
			EndIf
			
			If (Not Self.noTouch And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
				Self.drawer.setActionId(3)
				
				Self.drawer.setLoop(False)
				
				Local power:= (((Abs(player.getFootPositionX() - Self.posX) * FLIP_POWER_RANGE) / COLLISION_WIDTH) + FLIP_POWER_MIN)
				
				player.bePop(power, DIRECTION_DOWN)
				player.setAnimationId(PlayerObject.ANI_JUMP)
				
				player.setVelX(PickValue((Self.iLeft = 0), ((-power) / 10), (power / 10)))
				
				Self.noTouch = True
				Self.justPop = True
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_183)
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.noTouch = True
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End