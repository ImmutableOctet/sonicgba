Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.sonicdef
	
	Import state.state
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
Public

' Classes:
Class SpecialEnding Extends State Implements SonicDef
	Private
		' Constant variable(s):
		Global ANIMATION_LOOP:Bool[] = [True, False, True, False, True, True, False, True] ' Const
		Global CHARACTER_ANIMATION_NAME:String[] = ["/sonic_ed", "/tails_ed", "/knuckles_ed", "/amy_ed"] ' Const
		Global CHARACTER_SP_ANIMATION_NAME:String[] = ["/sonic_sp_ed", "/tails_sp_ed", "/knuckles_sp_ed", "/amy_sp_ed"] ' Const
		Global CLOUD_VELOCITY:Int[] = [5, 4, 3] ' Const
		Global PALETTE_IMAGE_NAME:String[] = ["/sonic_", "/tails_", "/knuckles_", "/amy_"] ' Const
		Global PLAYER_TO_ANIMATION:Int[][][] = [ [[0, 0, 0], [1, 0, 1], [1, 0, 1], [1, 1, 0]], [[1, 2, 0], [0, 1, 1], [1, 0, 1], [1, 1, 0]], [[0, 0, 0], [0, 1, 1], [1, 0, 1], [1, 1, 0]], [[1, 2, 0], [1, 3, 1], [1, 0, 1], [1, 1, 0]] ] ' Const
		Global SP_ANIMATION_LOOP:Bool[] = [False, True, False, False] ' Const
		
		Const CLOUD_NUM:Int = 10
		Const CLOUD_TYPE:Int = 0
		Const CLOUD_X:Int = 1
		Const CLOUD_Y:Int = 2
		
		Const ENDING_ANIMATION_PATH:String = "/animation/ending"
		
		Const NORMAL_ANIMATION:Int = 0
		
		Const LOOP:Int = 0
		Const NO_LOOP:Int = 1
		
		Const PILOT_SONIC:Int = 0
		Const PILOT_TAILS:Int = 2
		
		Const PLANE_ACC_POWER:Int = 3
		Global PLANE_STABLE_Y:Int = ((SCREEN_HEIGHT / 2) + 30) ' Const
		Const PLANE_START_TO_TOUCH_X:Int = (PLAYER_OFFSET_TO_PLANE_X + TOUCH_POINT_X + 21)
		Global PLANE_START_X:Int = (SCREEN_WIDTH + 70) ' Const
		Const PLANE_TOUCH_VELOCITY:Int = 10
		Const PLANE_VELOCITY:Int = -3
		
		Const PLAYER_EMERALD:Int = 3
		Const PLAYER_EMERALD_INTRO:Int = 2
		Const PLAYER_FALLING:Int = 0
		Const PLAYER_OFFSET_TO_PLANE_X:Int = 11
		Const PLAYER_OFFSET_TO_PLANE_Y:Int = 34
		Const PLAYER_START_Y:Int = -10
		Const PLAYER_TOUCHING:Int = 1
		
		Const SP_ANIMATION:Int = 1
		
		Const TOUCH_FRAME:Int = 7
		
		' States:
		Const STATE_INIT:Int = 0
		Const STATE_PLANE_IN:Int = 1
		Const STATE_PLAYER_IN:Int = 2
		Const STATE_TOUCH:Int = 3
		Const STATE_SHOW_EMERALD:Int = 4
		Const STATE_INTERRUPT:Int = 5
		
		Global TOUCH_POINT_X:Int = ((SCREEN_WIDTH Shr 1) + 40) ' Const
		Global TOUCH_POINT_Y:Int ((PLANE_STABLE_Y - PLAYER_OFFSET_TO_PLANE_Y) + PLANE_TOUCH_VELOCITY) ' Const
		
		' Fields:
		Field dusting:Bool
		Field planeShocking:Bool
		Field isOverFromInterrupt:Bool
		Field pilotSmile:Bool
		
		Field characterID:Int
		
		Field state:Int
		
		Field count:Int
		Field cloudCount:Int
		
		Field pilotHeadID:Int
		
		Field planeVelY:Int
		
		Field planeX:Int
		Field planeY:Int
		
		Field playerActionID:Int
		
		Field playerX:Int
		Field playerY:Int
		
		Field endingBackGround:MFImage
		
		Field characterDrawer:AnimationDrawer
		Field characterSpDrawer:AnimationDrawer
		
		Field cloudDrawer:AnimationDrawer
		
		Field dustDrawer:AnimationDrawer
		
		Field planeDrawer:AnimationDrawer
		Field planeHeadDrawer:AnimationDrawer
		
		Field cloudInfo:Int[][]
	Public
		' Constructor(s):
		Method New(characterID:Int, emeraldID:Int)
			Self.dusting = False
			
			' Allocate clouds:
			Self.cloudInfo = New Int[CLOUD_NUM][]
			
			For Local i:= 0 Until CLOUD_NUM ' Self.cloudInfo.Length
				Self.cloudInfo[i] = New Int[3]
			Next
			
			Self.cloudCount = 0
			
			Self.characterID = characterID
			
			Self.characterDrawer = New Animation(ENDING_ANIMATION_PATH + CHARACTER_ANIMATION_NAME[characterID]).getDrawer()
			
			If (emeraldID > 0) Then
				Self.characterSpDrawer = New Animation(MFImage.createPaletteImage(ENDING_ANIMATION_PATH + PALETTE_IMAGE_NAME[characterID] + String(emeraldID + 1) + ".pal"), ENDING_ANIMATION_PATH + CHARACTER_SP_ANIMATION_NAME[characterID]).getDrawer()
			Else
				Self.characterSpDrawer = New Animation(ENDING_ANIMATION_PATH + CHARACTER_SP_ANIMATION_NAME[characterID]).getDrawer()
			EndIf
			
			Self.endingBackGround = MFImage.createImage("/animation/ending/ending_bg.png")
			
			Self.planeDrawer = New Animation("/animation/ending/ending_plane").getDrawer()
			Self.cloudDrawer = New Animation("/animation/ending/ending_cloud").getDrawer()
			Self.planeHeadDrawer = New Animation("/animation/ending/plane_head").getDrawer()
			Self.dustDrawer = New Animation("/animation/ending/effect_dust").getDrawer(STATE_TOUCH, False, 0)
			
			Self.planeX = PLANE_START_X
			Self.planeY = PLANE_STABLE_Y
			
			Self.pilotHeadID = PickValue((characterID = 0), 2, 0)
			
			Self.isOverFromInterrupt = False
		End
		
		' Methods:
		Public Method logic:Void()
			Self.count += STATE_PLANE_IN
			
			If (Self.planeShocking) Then
				Self.planeVelY -= STATE_TOUCH
				Self.planeY += Self.planeVelY
				
				If (Self.planeVelY < 0 And Self.planeY <= PLANE_STABLE_Y) Then
					Self.planeShocking = False
					Self.planeY = PLANE_STABLE_Y
				EndIf
			EndIf
			
			Select (Self.state)
				Case STATE_INIT
					Self.playerX = TOUCH_POINT_X
					Self.playerY = PLAYER_START_Y
					Self.playerActionID = 0
					Self.state = STATE_PLANE_IN
				Case STATE_PLANE_IN
					Self.planeX += PLANE_VELOCITY
					
					If (Self.planeX <= PLANE_START_TO_TOUCH_X) Then
						Self.playerX += Self.planeX - PLANE_START_TO_TOUCH_X
						Self.state = STATE_PLAYER_IN
						Self.count = 0
					EndIf
					
				Case STATE_PLAYER_IN
					Self.planeX += PLANE_VELOCITY
					Self.playerY = ((Self.count * (TOUCH_POINT_Y - PLAYER_START_Y)) / TOUCH_FRAME) + PLAYER_START_Y
					
					If (Self.count >= TOUCH_FRAME) Then
						Self.state = STATE_TOUCH
						Self.dusting = True
						Self.playerActionID = STATE_PLANE_IN
						Self.planeVelY = PLANE_TOUCH_VELOCITY
						Self.planeShocking = True
						SoundSystem.getInstance().playBgm(38, False)
					EndIf
					
				Case STATE_TOUCH
					Self.planeX += PLANE_VELOCITY
					Self.playerX = Self.planeX - PLAYER_OFFSET_TO_PLANE_X
					Self.playerY = Self.planeY - PLAYER_OFFSET_TO_PLANE_Y
				Case STATE_SHOW_EMERALD
					Self.planeX += PLANE_VELOCITY
					Self.playerX = Self.planeX - PLAYER_OFFSET_TO_PLANE_X
					Self.playerY = Self.planeY - PLAYER_OFFSET_TO_PLANE_Y
				Default
			EndIf
		End
		
		Public Method isOver:Bool()
			Return Self.playerX < -110 Or Self.isOverFromInterrupt
		End
		
		Public Method draw:Void(g:MFGraphics)
			g.drawImage(Self.endingBackGround, 0, -135, 0)
			cloudLogic()
			cloudDraw(g)
			drawPlane(g)
		End
		
		Private Method drawPlane:Void(g:MFGraphics)
			Int i
			Bool z = True
			Self.planeDrawer.draw(g, Self.planeX, Self.planeY)
			AnimationDrawer animationDrawer = Self.planeHeadDrawer
			
			If (Self.pilotSmile) Then
				i = STATE_PLANE_IN
			Else
				i = 0
			EndIf
			
			animationDrawer.draw(g, Self.pilotHeadID + i, Self.planeX + STATE_TOUCH, Self.planeY - 22, True, 0)
			animationDrawer = PLAYER_TO_ANIMATION[Self.characterID][Self.playerActionID][0] = 0 ? Self.characterDrawer : Self.characterSpDrawer
			Int i2 = PLAYER_TO_ANIMATION[Self.characterID][Self.playerActionID][STATE_PLANE_IN]
			Int i3 = Self.playerX
			Int i4 = Self.playerY
			
			If (PLAYER_TO_ANIMATION[Self.characterID][Self.playerActionID][STATE_PLAYER_IN] <> 0) Then
				z = False
			EndIf
			
			animationDrawer.draw(g, i2, i3, i4, z, 0)
			
			If (animationDrawer.checkEnd()) Then
				Select (Self.playerActionID)
					Case STATE_PLANE_IN
						Self.state = STATE_SHOW_EMERALD
						Self.playerActionID = STATE_PLAYER_IN
						break
					Case STATE_PLAYER_IN
						Self.playerActionID = STATE_TOUCH
						break
				EndIf
			EndIf
			
			If (Self.dusting) Then
				Self.dustDrawer.draw(g, Self.playerX, Self.playerY)
				
				If (Self.dustDrawer.checkEnd()) Then
					Self.dusting = False
				EndIf
			EndIf
			
		End
		
		Private Method cloudLogic:Void()
			
			If (Self.cloudCount > 0) Then
				Self.cloudCount -= STATE_PLANE_IN
			EndIf
			
			For (Int i = 0; i < PLANE_TOUCH_VELOCITY; i += STATE_PLANE_IN)
				
				If (Self.cloudInfo[i][0] <> 0) Then
					Int[] iArr = Self.cloudInfo[i]
					iArr[STATE_PLANE_IN] = iArr[STATE_PLANE_IN] + CLOUD_VELOCITY[Self.cloudInfo[i][0] - STATE_PLANE_IN]
					
					If (Self.cloudInfo[i][STATE_PLANE_IN] >= SCREEN_WIDTH + 75) Then
						Self.cloudInfo[i][0] = 0
					EndIf
				EndIf
				
				If (Self.cloudInfo[i][0] = 0 And Self.cloudCount = 0) Then
					Self.cloudInfo[i][0] = MyRandom.nextInt(STATE_PLANE_IN, STATE_TOUCH)
					Self.cloudInfo[i][STATE_PLANE_IN] = -60
					Self.cloudInfo[i][STATE_PLAYER_IN] = MyRandom.nextInt(20, SCREEN_HEIGHT - 40)
					Self.cloudCount = MyRandom.nextInt(8, 20)
				EndIf
			EndIf
		End
		
		Private Method cloudDraw:Void(g:MFGraphics)
			For (Int i = 0; i < PLANE_TOUCH_VELOCITY; i += STATE_PLANE_IN)
				
				If (Self.cloudInfo[i][0] <> 0) Then
					Self.cloudDrawer.setActionId(Self.cloudInfo[i][0] - STATE_PLANE_IN)
					Self.cloudDrawer.draw(g, Self.cloudInfo[i][STATE_PLANE_IN], Self.cloudInfo[i][STATE_PLAYER_IN])
				EndIf
			EndIf
		End
		
		Public Method close:Void()
			Self.endingBackGround = Null
			Animation.closeAnimationDrawer(Self.characterDrawer)
			Self.characterDrawer = Null
			Animation.closeAnimationDrawer(Self.characterSpDrawer)
			Self.characterSpDrawer = Null
			Animation.closeAnimationDrawer(Self.dustDrawer)
			Self.dustDrawer = Null
			Animation.closeAnimationDrawer(Self.planeDrawer)
			Self.planeDrawer = Null
			Animation.closeAnimationDrawer(Self.cloudDrawer)
			Self.cloudDrawer = Null
			Animation.closeAnimationDrawer(Self.planeHeadDrawer)
			Self.planeHeadDrawer = Null
			'System.gc()
			try {
				Thread.sleep(100)
			} catch (Exception e) {
				e.printStackTrace()
			EndIf
		End
		
		Public Method init:Void()
		End
		
		Public Method pause:Void()
			Self.state = STATE_INTERRUPT
		End
		
		Public Method setOverFromInterrupt:Void()
			Self.isOverFromInterrupt = True
		End
End