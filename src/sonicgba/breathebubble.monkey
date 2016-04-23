Strict

Public

' Imports:
Private
	Import gameengine.def
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	Import sonicgba.upbubble
	
	'Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class BreatheBubble Extends UpBubble
	Private
		' Constant variable(s):
		Const BUBBLE_LIFE:Int = 8
		
		Const BUBBLE_RANGE:Int = 1280
		
		' Global variable(s):
		Global bubbleAnimation:Animation
		
		' Fields:
		Field CanBreathe:Bool
		
		Field initFlag:Bool
		Field isBeginPlayStageBGM:Bool
		Field isFirstUp:Bool
		
		Field LIFE_RANGE:Int ' Final
		
		Field breathCnt:Int
		Field direct:Int
		Field posOriginalY:Int
		Field velx:Int
		Field vely:Int
		
		Field drawer:AnimationDrawer
	Protected
		' Constructor(s):
		Method Construct_BreatheBubble:Void()
			Self.velx = 0
			Self.vely = -120
			Self.direct = 0
			Self.LIFE_RANGE = 6400
			Self.CanBreathe = False
			Self.isBeginPlayStageBGM = False
			Self.isFirstUp = True
			Self.breathCnt = 0
		End
		
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Construct_BreatheBubble()
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(bubbleAnimation)
			
			bubbleAnimation = Null
		End
		
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Construct_BreatheBubble()
			
			If (bubbleAnimation = Null) Then
				bubbleAnimation = New Animation("/animation/bubble_up")
			EndIf
			
			If (bubbleAnimation <> Null) Then
				Self.drawer = bubbleAnimation.getDrawer(3, False, 0)
				
				Self.direct = MyRandom.nextInt(-1, 1)
			EndIf
			
			Self.posOriginalY = Self.posY
			
			Self.initFlag = False
			Self.CanBreathe = False
			Self.isFirstUp = True
			
			Self.breathCnt = 0
		End
		
		' Methods:
		Method logic:Void()
			If (Not Self.used And Not Self.initFlag) Then
				If (Self.direct >= 0) Then
					Self.velx = MyRandom.nextInt(0, 20)
				Else
					Self.velx = MyRandom.nextInt(-20, 0)
				EndIf
				
				If (Self.breathCnt >= 1) Then
					Self.breathCnt += 1
				EndIf
				
				If (Self.breathCnt < BUBBLE_LIFE) Then
					Self.posX += Self.velx
					Self.posY += Self.vely
				Else
					Self.used = True
				EndIf
				
				refreshCollisionRect(Self.posX, Self.posY)
				
				If (Self.drawer <> Null And Self.drawer.getCurrentFrame() = 5) Then
					Self.CanBreathe = True
				EndIf
				
				If (Not isInCamera()) Then
					Self.used = True
					
					Self.CanBreathe = False
				EndIf
				
				If (Self.posY <= (StageManager.getWaterLevel() Shl 6) + (BUBBLE_RANGE / 2)) Then
					Self.initFlag = True
					
					Self.CanBreathe = False
				EndIf
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.used And Not Self.initFlag) Then
				If (Self.drawer.checkEnd()) Then
					Self.drawer = bubbleAnimation.getDrawer(4, True, TRANS_NONE)
				EndIf
				
				drawInMap(g, Self.drawer, Self.posX, Self.posY)
				
				drawCollisionRect(g)
			EndIf
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_SONIC
		End
		
		Public Method doWhileNoCollision:Void()
			Self.isBeginPlayStageBGM = True
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.CanBreathe) Then
				If (player.doBreatheBubble()) Then
					If (Self.isFirstUp) Then
						SoundSystem.getInstance().playSe(SoundSystem.SE_191)
						
						Self.isFirstUp = False
					EndIf
					
					Self.CanBreathe = False
					
					Self.breathCnt += 1
				EndIf
				
				If (Self.isBeginPlayStageBGM And SoundSystem.getInstance().getPlayingBGMIndex() <> StageManager.getBgmId()) Then
					If (PlayerObject.IsInvincibility()) Then
						SoundSystem.getInstance().playBgm(SoundSystem.BGM_INVINCIBILITY)
					Else
						SoundSystem.getInstance().playBgm(StageManager.getBgmId())
						
						Self.isBeginPlayStageBGM = False
					EndIf
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			If (Self.CanBreathe) Then
				Self.collisionRect.setRect(x - (BUBBLE_RANGE / 2), y - (BUBBLE_RANGE / 2), BUBBLE_RANGE, BUBBLE_RANGE)
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End