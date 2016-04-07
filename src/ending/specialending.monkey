Strict

Public

' Imports:
Private
	'Import ending.baseending
	Import ending.plainending
Public

' Classes:
Class SpecialEnding Extends PlainEnding
	Private
		' Constant variable(s):
		Global CHARACTER_SP_ANIMATION_NAME:String[] = ["/sonic_sp_ed", "/tails_sp_ed", "/knuckles_sp_ed", "/amy_sp_ed"] ' Const
		Global CLOUD_VELOCITY:Int[] = [5, 4, 3] ' Const
		Global PALETTE_IMAGE_NAME:String[] = ["/sonic_", "/tails_", "/knuckles_", "/amy_"] ' Const
		Global PLAYER_TO_ANIMATION:Int[][][] = [ [[0, 0, 0], [1, 0, 1], [1, 0, 1], [1, 1, 0]], [[1, 2, 0], [0, 1, 1], [1, 0, 1], [1, 1, 0]], [[0, 0, 0], [0, 1, 1], [1, 0, 1], [1, 1, 0]], [[1, 2, 0], [1, 3, 1], [1, 0, 1], [1, 1, 0]] ] ' Const
		Global SP_ANIMATION_LOOP:Bool[] = [False, True, False, False] ' Const
		
		Const NORMAL_ANIMATION:Int = 0
		
		Const CLOUD_NUM:Int = 10
		Const CLOUD_TYPE:Int = 0
		Const CLOUD_X:Int = 1
		Const CLOUD_Y:Int = 2
		
		Const LOOP:Int = 0
		Const NO_LOOP:Int = 1
		
		Const PILOT_SONIC:Int = 0
		Const PILOT_TAILS:Int = 2
		
		Const PLANE_ACC_POWER:Int = 3
		
		Global PLANE_STABLE_Y:Int = ((SCREEN_HEIGHT / 2) + 30) ' Const
		Global PLANE_START_TO_TOUCH_X:Int = (PLAYER_OFFSET_TO_PLANE_X + TOUCH_POINT_X + 21) ' Const
		Const PLANE_TOUCH_VELOCITY:Int = 10
		Const PLANE_VELOCITY:Int = -3
		
		Const PLAYER_EMERALD:Int = 3
		Const PLAYER_EMERALD_INTRO:Int = 2
		Const PLAYER_FALLING:Int = 0
		Const PLAYER_START_Y:Int = -10
		Const PLAYER_TOUCHING:Int = 1
		
		Const SP_ANIMATION:Int = 1
		
		Const TOUCH_FRAME:Int = 7
		
		' States:
		'Const STATE_INIT:Int = 0
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
		
		Field cloudCount:Int
		
		Field planeVelY:Int
		
		Field planeX:Int
		Field planeY:Int
		
		Field endingBackGround:MFImage
		
		Field characterSpDrawer:AnimationDrawer
		
		Field cloudDrawer:AnimationDrawer
		
		Field dustDrawer:AnimationDrawer
		
		Field planeDrawer:AnimationDrawer
		Field planeHeadDrawer:AnimationDrawer
		
		' Possibly stored as: Type, X, Y?
		' Not completely sure about this one.
		Field cloudInfo:Int[][]
	Public
		' Constructor(s):
		Method New(characterID:Int, emeraldID:Int)
			Self.characterID = characterID
			
			Self.dusting = False
			
			' Allocate clouds:
			Self.cloudInfo = New Int[CLOUD_NUM][]
			
			For Local i:= 0 Until CLOUD_NUM ' Self.cloudInfo.Length
				Self.cloudInfo[i] = New Int[3]
			Next
			
			Self.cloudCount = 0
			
			If (emeraldID > 0) Then
				Self.characterSpDrawer = New Animation(MFImage.createPaletteImage(ENDING_ANIMATION_PATH + PALETTE_IMAGE_NAME[characterID] + String(emeraldID + 1) + ".pal"), ENDING_ANIMATION_PATH + CHARACTER_SP_ANIMATION_NAME[characterID]).getDrawer()
			Else
				Self.characterSpDrawer = New Animation(ENDING_ANIMATION_PATH + CHARACTER_SP_ANIMATION_NAME[characterID]).getDrawer()
			EndIf
			
			Self.characterDrawer = New Animation(ENDING_ANIMATION_PATH + CHARACTER_ANIMATION_NAME[characterID]).getDrawer()
			
			Self.planeDrawer = New Animation("/animation/ending/ending_plane").getDrawer()
			Self.cloudDrawer = New Animation("/animation/ending/ending_cloud").getDrawer()
			
			Self.planeHeadDrawer = New Animation("/animation/ending/plane_head").getDrawer()
			Self.dustDrawer = New Animation("/animation/ending/effect_dust").getDrawer(STATE_TOUCH, False, 0)
			
			Self.endingBackGround = MFImage.createImage("/animation/ending/ending_bg.png")
			
			Self.planeX = PLANE_START_X
			Self.planeY = PLANE_STABLE_Y
			
			Self.pilotHeadID = PickValue((characterID = CHARACTER_SONIC), PILOT_TAILS, PILOT_SONIC)
			
			Self.isOverFromInterrupt = False
		End
		
		' Methods:
		Method logic:Void()
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
					Self.playerX = TOUCH_POINT_X ' PLAYER_START_X
					Self.playerY = PLAYER_START_Y
					
					Self.playerActionID = 0
					
					Self.state = STATE_PLANE_IN
				Case STATE_PLANE_IN
					Self.planeX += PLANE_VELOCITY
					
					If (Self.planeX <= PLANE_START_TO_TOUCH_X) Then
						Self.playerX += (Self.planeX - PLANE_START_TO_TOUCH_X)
						
						Self.state = STATE_PLAYER_IN
						
						Self.count = 0
					EndIf
				Case STATE_PLAYER_IN
					Self.planeX += PLANE_VELOCITY
					
					Self.playerY = (((Self.count * (TOUCH_POINT_Y - PLAYER_START_Y)) / TOUCH_FRAME) + PLAYER_START_Y)
					
					If (Self.count >= TOUCH_FRAME) Then
						Self.state = STATE_TOUCH
						
						Self.dusting = True
						
						Self.playerActionID = SP_ANIMATION ' 1
						
						Self.planeVelY = PLANE_TOUCH_VELOCITY
						Self.planeShocking = True
						
						SoundSystem.getInstance().playBgm(SoundSystem.BGM_SP_EMERALD, False)
					EndIf
				Case STATE_TOUCH, STATE_SHOW_EMERALD
					Self.planeX += PLANE_VELOCITY
					
					Self.playerX = (Self.planeX - PLAYER_OFFSET_TO_PLANE_X)
					Self.playerY = (Self.planeY - PLAYER_OFFSET_TO_PLANE_Y)
				Default
					' Nothing so far.
			End Select
		End
		
		Method isOver:Bool()
			' Magic number: -110 (Position; X)
			Return (Self.playerX < -110 Or Self.isOverFromInterrupt)
		End
		
		Method draw:Void(g:MFGraphics)
			' Magic number: -135
			g.drawImage(Self.endingBackGround, 0, -135, 0)
			
			' Update and draw clouds:
			cloudLogic()
			cloudDraw(g)
			
			' Draw the plane.
			drawPlane(g)
		End
		
		Method close:Void()
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
			'Thread.sleep(100)
		End
		
		Method init:Void()
			' Empty implementation.
		End
		
		Method pause:Void()
			Self.state = STATE_INTERRUPT
		End
		
		Method setOverFromInterrupt:Void()
			Self.isOverFromInterrupt = True
		End
	Private
		' Methods:
		Method drawPlane:Void(g:MFGraphics)
			Self.planeDrawer.draw(g, Self.planeX, Self.planeY)
			
			Local animationDrawer:= Self.planeHeadDrawer
			
			animationDrawer.draw(g, Self.pilotHeadID + Int(Self.pilotSmile), Self.planeX + PLANE_ACC_POWER, Self.planeY - 22, True, 0)
			
			If (PLAYER_TO_ANIMATION[Self.characterID][Self.playerActionID][0] = 0) Then
				animationDrawer = Self.characterDrawer
			Else
				animationDrawer = Self.characterSpDrawer
			EndIf
			
			Local actionID:= PLAYER_TO_ANIMATION[Self.characterID][Self.playerActionID][1]
			
			Local x:= Self.playerX
			Local y:= Self.playerY
			
			Local z:Bool = (PLAYER_TO_ANIMATION[Self.characterID][Self.playerActionID][2] <> 0)
			
			animationDrawer.draw(g, i2, x, y, z, 0)
			
			If (animationDrawer.checkEnd()) Then
				Select (Self.playerActionID)
					Case 1
						Self.state = STATE_SHOW_EMERALD
						
						Self.playerActionID = 2
					Case 2
						Self.playerActionID = 3
				End Select
			EndIf
			
			If (Self.dusting) Then
				Self.dustDrawer.draw(g, x, y)
				
				If (Self.dustDrawer.checkEnd()) Then
					Self.dusting = False
				EndIf
			EndIf
		End
		
		Method cloudLogic:Void()
			If (Self.cloudCount > 0) Then
				Self.cloudCount -= 1
			EndIf
			
			For Local cloud:= EachIn Self.cloudInfo
				If (cloud[0] <> CLOUD_TYPE) Then
					cloud[1] += CLOUD_VELOCITY[cloud[0] - 1]
					
					' Magic number: 75
					If (cloud[1] >= (SCREEN_WIDTH + 75)) Then
						cloud[0] = 0
					EndIf
				EndIf
				
				If (cloud[0] = CLOUD_TYPE And Self.cloudCount = 0) Then
					' Magic numbers: 1, 3, -60, 20, 40, 8, 20
					cloud[0] = MyRandom.nextInt(1, 3) ' PLANE_ACC_POWER
					cloud[1] = -60
					cloud[2] = MyRandom.nextInt(20, SCREEN_HEIGHT - 40)
					
					Self.cloudCount = MyRandom.nextInt(8, 20)
				EndIf
			EndIf
		End
		
		Method cloudDraw:Void(g:MFGraphics)
			For Local cloud:= EachIn Self.cloudInfo
				If (cloud[0] <> CLOUD_TYPE) Then
					Self.cloudDrawer.setActionId(cloud[0] - 1)
					Self.cloudDrawer.draw(g, cloud[1], cloud[2])
				EndIf
			Next
		End
End