Strict

Public

#Rem
	Implementation notes:
		* This file has not been completely ported.
		
		Work still needs to be done on replacing incorrect
		variables and literal values into proper constants.
		
		For now, this structure will remain, but later
		down the road this will need to be resolved.
		
		* In addition to the previous issue, there's
		no imports to the referenced "gimmick classes".
		
		This will need to change before this is considered ready for use.
#End

' Imports:
Private
	Import gameengine.def
	
	Import lib.animation
	Import lib.line
	Import lib.soundsystem
	Import lib.crlfp32
	
	Import mflib.mainstate
	
	Import special.ssdef
	Import special.specialmap
	Import special.specialobject
	
	Import state.state
	Import state.stringindex
	Import state.titlestate
	
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acworldcollisioncalculator
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	' Gimmicks:
	' Nothing so far.
Public

' Classes:
Class GimmickObject Extends GameObject
	Private
		' Constant variable(s):
		Const WIND_ACCELERATE:Int = -516 ' ((-GRAVITY) * 3)
		Const WIND_VELOCITY:Int = -472 ' (SmallAnimal.FLY_VELOCITY_Y - GRAVITY)
		
		' Global variable(s):
		Global framecnt:Int
		
		Global damageEnable:Bool = False
		Global furikoEnable:Bool = False
		Global ironBallEnable:Bool = False
		Global rollHobinEnable:Bool = False
		Global rollPlatformEnable:Bool = False
		Global seabedvolcanoEnable:Bool = False
		Global steamEnable:Bool = False
		Global torchFireEnable:Bool = False
		Global waterFallEnable:Bool = False
		Global waterSlipEnable:Bool = False
	Public
		' Constant variable(s):
		
		' I'm guessing this is the number of gimmicks.
		Const GIMMICK_NUM:Int = 110
		
		Const PLATFORM_OFFSET_Y:Int = -256
		
		' Gimmick IDs:
		Const GIMMICK_ACCELERATOR_FORWARD:= 31
		Const GIMMICK_ACCELERATOR_FORWARD_DOWN:= 33
		Const GIMMICK_ACCELERATOR_FORWARD_UP:= 32
		Const GIMMICK_ADD_DOUBLE_MAX_SPEED:= 36
		Const GIMMICK_AIR_ROOT:= 112
		Const GIMMICK_ARM:= 80
		Const GIMMICK_AROUND_ENTRANCE:= 34
		Const GIMMICK_AROUND_EXIT:= 35
		Const GIMMICK_BALLOON:= 59
		Const GIMMICK_BALL_HOBIN:= 49
		Const GIMMICK_BANE_ISLAND:= 81
		Const GIMMICK_BANPER:= 71
		Const GIMMICK_BAR_H:= 51
		Const GIMMICK_BAR_V:= 52
		Const GIMMICK_BELT:= 69
		Const GIMMICK_BIG_FLOATING_ISLAND:= 55
		Const GIMMICK_BLOCK:= 99
		Const GIMMICK_BOSS4_ICE:= 121
		Const GIMMICK_BOSS6_BLOCK:= 122
		Const GIMMICK_BOSS6_BLOCK_ARRAY:= 123
		Const GIMMICK_BREAK_ISLAND:= 24
		Const GIMMICK_BUBBLE:= 94
		Const GIMMICK_CAPER_BED:= 23
		Const GIMMICK_CAPER_BLOCK:= 25
		Const GIMMICK_CHANGE_LAYER_A:= 17
		Const GIMMICK_CHANGE_LAYER_B:= 18
		Const GIMMICK_CHANGE_RECT_REGION:= 124
		Const GIMMICK_CORNER_BAR:= 53
		Const GIMMICK_DAMAGE:= 105
		Const GIMMICK_DASH_PANEL_HIGH:= 100
		Const GIMMICK_DASH_PANEL_LOW:= 101
		Const GIMMICK_DASH_PANEL_TATE:= 47
		Const GIMMICK_DEGREE_CHANGE_180:= 38
		Const GIMMICK_DOOR_H:= 64
		Const GIMMICK_DOOR_V:= 63
		Const GIMMICK_DOWN_SHIMA:= 85
		Const GIMMICK_DUCT_ROTATE:= 39
		Const GIMMICK_FALL:= 66
		Const GIMMICK_FALLING_ISLAND:= 22
		Const GIMMICK_FAN:= 103
		Const GIMMICK_FIRE_MT:= 98
		Const GIMMICK_FLIPPER:= 54
		Const GIMMICK_FLIPPER_V:= 56
		Const GIMMICK_FLOATING_ISLAND:= 21
		Const GIMMICK_FREE_FALL:= 74
		Const GIMMICK_FURIKO:= 76
		Const GIMMICK_F_SHIMA_FALL:= 104
		Const GIMMICK_GOAL:= 0
		Const GIMMICK_GRAPHIC_PATCH:= 116
		Const GIMMICK_GRAVITY:= 109
		Const GIMMICK_HARI_DOWN:= 2
		Const GIMMICK_HARI_ISLAND:= 61
		Const GIMMICK_HARI_LEFT:= 3
		Const GIMMICK_HARI_MOVE_DOWN:= 6
		Const GIMMICK_HARI_MOVE_UP:= 5
		Const GIMMICK_HARI_RIGHT:= 4
		Const GIMMICK_HARI_UP:= 1
		Const GIMMICK_HEX_HOBIN:= 48
		Const GIMMICK_HOBBY_FAIR:= 41
		Const GIMMICK_ICE:= 95
		Const GIMMICK_INVISIBLE_CAPER:= 26
		Const GIMMICK_IRON_BALL:= 82
		Const GIMMICK_IRON_BAR:= 83
		Const GIMMICK_KASSHA:= 75
		Const GIMMICK_LEAF:= 30
		Const GIMMICK_MARKER:= 7
		Const GIMMICK_MINUS_DOUBLE_MAX_SPEED:= 37
		Const GIMMICK_MOVE:= 65
		Const GIMMICK_NEJI:= 78
		Const GIMMICK_NET_ITEM:= 115
		Const GIMMICK_NOTHING:= 119
		Const GIMMICK_NO_KEY:= 113
		Const GIMMICK_PIPE:= 106
		Const GIMMICK_PIPE_IN:= 110
		Const GIMMICK_PIPE_OUT:= 111
		Const GIMMICK_POAL:= 42
		Const GIMMICK_POAL_LEFT:= 44
		Const GIMMICK_POAL_RIGHT:= 45
		Const GIMMICK_RAIL_FLIPPER:= 73
		Const GIMMICK_RAIL_IN:= 67
		Const GIMMICK_RAIL_OUT:= 68
		Const GIMMICK_ROLL_ASHIBA:= 86
		Const GIMMICK_ROLL_HOBIN:= 50
		Const GIMMICK_ROLL_SHIMA:= 91
		Const GIMMICK_ROPE_END:= 117
		Const GIMMICK_ROPE_TURN:= 118
		Const GIMMICK_SEE:= 70
		Const GIMMICK_SHATTER:= 77
		Const GIMMICK_SHIP:= 60
		Const GIMMICK_SLIP_END:= 20
		Const GIMMICK_SLIP_START:= 19
		Const GIMMICK_SPIN:= 96
		Const GIMMICK_SPLIT:= 107
		Const GIMMICK_SPRING_DOWN:= 9
		Const GIMMICK_SPRING_ISLAND:= 57
		Const GIMMICK_SPRING_LEFT:= 10
		Const GIMMICK_SPRING_LEFT_UP:= 12
		Const GIMMICK_SPRING_LEFT_UP_BURY:= 14
		Const GIMMICK_SPRING_RIGHT:= 11
		Const GIMMICK_SPRING_RIGHT_UP:= 13
		Const GIMMICK_SPRING_RIGHT_UP_BURY:= 15
		Const GIMMICK_SPRING_UP:= 8
		Const GIMMICK_SP_BANE:= 102
		Const GIMMICK_STEAM:= 79
		Const GIMMICK_STONE:= 16
		Const GIMMICK_STONE_BALL:= 92
		Const GIMMICK_SUBEYUKA:= 84
		Const GIMMICK_TAIMATU:= 87
		Const GIMMICK_TEA_CUP:= 62
		Const GIMMICK_TOGE_SHIMA:= 93
		Const GIMMICK_TUTORIAL:= 120
		Const GIMMICK_UG_BANE:= 108
		Const GIMMICK_UP_ARM:= 88
		Const GIMMICK_UP_SHIMA:= 89
		Const GIMMICK_VIEW_LIGHTS:= 58
		Const GIMMICK_WALL:= 114
		Const GIMMICK_WALL_WALKER_ENTRANCE_LEFT:= 28
		Const GIMMICK_WALL_WALKER_ENTRANCE_RIGHT:= 29
		Const GIMMICK_WARP:= 72
		Const GIMMICK_WATER_FALL:= 27
		Const GIMMICK_WATER_PILLAR:= 40
		Const GIMMICK_WATER_PILLAR_2:= 43
		Const GIMMICK_WATER_SLIP:= 46
		Const GIMMICK_WIND:= 90
		Const GIMMICK_WIND_PARTS:= 97
		
		' Global variable(s):
		Global doorAnimation:Animation
		
		Global hookImage:MFImage
		Global platformImage:MFImage
		Global rolllinkImage:MFImage
		Global shipRingImage:MFImage
	Protected
		' Constant variable(s):
		Const GIMMICK_RES_PATH:String = "/gimmick"
		
		' Global variable(s):
		Global firemtAnimation:Animation
		
		' Fields:
		Field iHeight:Int
		Field iLeft:Int
		Field iTop:Int
		Field iWidth:Int
		
		Field used:Bool
	Public
		Function getNewInstance:GameObject(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Local reElement:GameObject = Null
			
			x Shl= 6
			y Shl= 6
			
			Select (id)
				Case TitleState.STAGE_SELECT_KEY_RECORD_1
					reElement = New Terminal(id, x, y, left, top, width, height)
				Case TitleState.STAGE_SELECT_KEY_RECORD_2, TitleState.STAGE_SELECT_KEY_DIRECT_PLAY, SpecialObject.Z_ZOOM, TitleState.CHARACTER_RECORD_BG_SPEED, SSDef.SSOBJ_BNRU_ID, SSDef.SSOBJ_BNLD_ID
					reElement = New Hari(id, x, y, left, top, width, height)
				Case SSDef.SSOBJ_BNRD_ID
					reElement = New Marker(id, x, y, left, top, width, height)
				Case SpecialObject.COLLISION_RANGE_Z, SSDef.SSOBJ_BOMB_ID, SSDef.SSOBJ_CHECKPT, SSDef.SSOBJ_GOAL, SSDef.SSOBJ_NUM, PlayerTails.TAILS_ANI_FLY_2, PlayerTails.TAILS_ANI_FLY_3, PlayerTails.TAILS_ANI_HURT_1
					reElement = New Spring(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_HURT_2
					reElement = New Stone(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_PUSH_WALL
					reElement = New SlipStart(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_SPRING_2
					reElement = New Platform(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_SPRING_3
					reElement = New FallingPlatform(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_SPRING_4
					reElement = New CaperBed(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_SPRING_5
					reElement = New BreakPlatform(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_CLIFF_1
					reElement = New CaperBlock(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_BANK_1, PlayerTails.TAILS_ANI_BANK_2, PlayerTails.TAILS_ANI_BANK_3, State.COMFIRM_FRAME_ID
					reElement = New Accelerate(id, x, y, left, top, width, height)
				Case PlayerTails.TAILS_ANI_BAR_MOVE, PlayerTails.TAILS_ANI_RAIL_BODY, PlayerTails.TAILS_ANI_RAIL_TAIL
					reElement = New Poal(id, x, y, left, top, width, height)
				Case 69
					reElement = New Belt(id, x, y, left, top, width, height)
				Case 71
					reElement = New Banper(id, x, y, left, top, width, height)
				Case 75
					reElement = New RopeStart(id, x, y, left, top, width, height)
				Case 76
					reElement = New Furiko(id, x, y, left, top, width, height)
					furikoEnable = True
				Case 77
					reElement = New Shatter(id, x, y, left, top, width, height)
				Case 78
					reElement = New Neji(id, x, y, left, top, width, height)
				Case State.BACKGROUND_WIDTH
					reElement = New Arm(id, x, y, left, top, width, height)
				Case RollPlatformSpeedB.DEGREE_VELOCITY
					If (stageModeState = 1) Then
						reElement = Null
					EndIf
					
					reElement = New SpSpring(id, x, y, left, top, width, height)
				Case 105
					reElement = New DamageArea(id, x, y, left, top, width, height)
					damageEnable = True
				Case 106
					reElement = New PipeSet(id, x, y, left, top, width, height)
				Case GIMMICK_NUM
					reElement = New PipeIn(id, x, y, left, top, width, height)
				Case 111
					reElement = New PipeOut(id, x, y, left, top, width, height)
				Case 116
					reElement = New GraphicPatch(id, x, y, left, top, width, height)
				Case 117
					reElement = New RopeEnd(id, x, y, left, top, width, height)
				Case StringIndex.WHITE_BACKGROUND_ID
					reElement = New RopeTurn(id, x, y, left, top, width, height)
				Case 120
					reElement = New TutorialPoint(id, x, y, left, top, width, height)
				Case 124
					reElement = New ChangeRectRegion(id, x, y, left, top, width, height)
				default:
					Select (id)
						Case PlayerTails.TAILS_ANI_CELEBRATE_1
							reElement = New WaterFall(id, x, y, left, top, width, height)
							
							waterFallEnable = True
						Case PlayerTails.TAILS_ANI_CELEBRATE_2, PlayerTails.TAILS_ANI_CELEBRATE_3
							reElement = New Bank(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_ROLL_H_2
							reElement = New Fountain(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_WIND
							reElement = New FallFlush(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_BRAKE
							reElement = New WaterSlip(id, x, y, left, top, width, height)
							waterSlipEnable = True
						Case TitleState.CHARACTER_RECORD_BG_HEIGHT
							reElement = New HexHobin(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_SWIM_2
							reElement = New BallHobin(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_VS_KNUCKLE
							reElement = New RollHobin(id, x, y, left, top, width, height)
							
							rollHobinEnable = True
						Case PlayerTails.TAILS_ANI_ENTER_SP
							reElement = New BarHorbinH(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_BREATHE
							reElement = New BarHorbinV(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_WAITING_1
							reElement = New CornerHobin(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_WAITING_2
							reElement = New FlipH(id, x, y, left, top, width, height)
						Case PlayerSonic.SONIC_ANI_WAITING_2
							reElement = New FlipV(id, x, y, left, top, width, height)
						Case PlayerSonic.SONIC_ANI_CAUGHT
							reElement = New SpringPlatform(id, x, y, left, top, width, height)
						Case PlayerKnuckles.KNUCKLES_ANI_ENTER_SP
							reElement = New LightFont(id, x, y, left, top, width, height)
						Case PlayerKnuckles.KNUCKLES_ANI_SWIM_EFFECT
							reElement = New Balloon(id, x, y, left, top, width, height)
						Case PlayerKnuckles.KNUCKLES_ANI_CAUGHT
							reElement = New ShipSystem(id, x, y, left, top, width, height)
						Case PlayerKnuckles.KNUCKLES_ANI_WAITING_2
							reElement = New TeaCup(id, x, y, left, top, width, height)
						Case MainState.FRAME_SKIP, crlFP32.FIXED_1
							reElement = New Door(id, x, y, left, top, width, height)
						Case 67
							reElement = New RailIn(id, x, y, left, top, width, height)
						Case 68
							reElement = New RailOut(id, x, y, left, top, width, height)
						Case PlayerObject.NUM_DISTANCE_BIG
							reElement = New TransPoint(id, x, y, left, top, width, height)
						Case 73
							reElement = New RailFlipper(id, x, y, left, top, width, height)
						Case 74
							reElement = New FreeFallSystem(id, x, y, left, top, width, height)
						Case 79
							reElement = New SteamBase(id, x, y, left, top, width, height)
							
							steamEnable = True
						Case MDPhone.KEY_CODE_MENU
							reElement = New IronBall(id, x, y, left, top, width, height)
							
							ironBallEnable = True
						Case 83
							reElement = New IronBar(id, x, y, left, top, width, height)
						Case StringIndex.STR_STAGE_NAME_2
							reElement = New TorchFire(id, x, y, left, top, width, height)
							
							torchFireEnable = True
						Case StringIndex.FONT_HEAD
							If (top = 5) Then
								reElement = New RollPlatformSpeedA(id, x, y, left, top, width, height)
							ElseIf (top = 2) Then
								reElement = New RollPlatformSpeedB(id, x, y, left, top, width, height)
							ElseIf (top = 4) Then
								reElement = New RollPlatformSpeedC(id, x, y, left, top, width, height)
							EndIf
							
							rollPlatformEnable = True
						Case 107
							reElement = New Split(id, x, y, left, top, width, height)
						Case 114
							reElement = New BreakWall(id, x, y, left, top, width, height)
					End
					
					Select (id)
						Case PlayerTails.TAILS_ANI_CELEBRATE_4
							reElement = New Leaf(id, x, y, left, top, width, height)
						Case PlayerTails.TAILS_ANI_CAUGHT
							reElement = New Accelerate(id, x, y, left, top, width, height)
						Case PlayerSonic.SONIC_ANI_WAITING_1
							reElement = New DekaPlatform(id, x, y, left, top, width, height)
						Case PlayerKnuckles.KNUCKLES_ANI_WAITING_1
							reElement = New HariIsland(id, x, y, left, top, width, height)
						Case 81
							reElement = New SpringIsland(id, x, y, left, top, width, height)
						Case 84
							reElement = New Subeyuka(id, x, y, left, top, width, height)
						Case 85
							reElement = New DownIsland(id, x, y, left, top, width, height)
						Case StringIndex.STR_STAGE_NAME_1
							reElement = New RollIsland(id, x, y, left, top, width, height)
						Case StringIndex.STR_STAGE_NAME_3
							reElement = New UpArm(id, x, y, left, top, width, height)
						Case StringIndex.STR_STAGE_NAME_4
							reElement = New UpPlatform(id, x, y, left, top, width, height)
						Case 92
							reElement = New StoneBall(id, x, y, left, top, width, height)
						Case 93
							reElement = New TogeShima(id, x, y, left, top, width, height)
						Case StringIndex.FONT_PAUSE
							reElement = New Bubble(id, x, y, left, top, width, height)
						Case 95
							reElement = New Ice(id, x, y, left, top, width, height)
						Case 97
							reElement = New WindParts(id, x, y, left, top, width, height)
						Case 98
							If (left = GIMMICK_AROUND_EXIT Or left = 9 Or left = -21) Then
								reElement = New SeabedVolcanoAsynBase(id, x, y, left, top, width, height)
							Else
								reElement = New SeabedVolcanoBase(id, x, y, left, top, width, height)
							EndIf
							
							seabedvolcanoEnable = True
						Case 99
							reElement = New Block(id, x, y, left, top, width, height)
						Case StringIndex.BLUE_BACKGROUND_ID
							reElement = New Fan(id, x, y, left, top, width, height)
						Case Def.TOUCH_ROTATE_MAIN_MENU_ITEM_WIDTH
							reElement = New FinalShima(id, x, y, left, top, width, height)
						Case Def.TOUCH_SEL_1_W
							reElement = New UnseenSpring(id, x, y, left, top, width, height)
						Case 109
							reElement = New AntiGravity(id, x, y, left, top, width, height)
						Case Def.TOUCH_OPTION_ITEMS_TOUCH_WIDTH_1
							reElement = New AirRoot(id, x, y, left, top, width, height)
					End Select
					
					If (reElement = Null) Then
						If (id = GIMMICK_WIND) Then
							isFirstTouchedWind = False
						EndIf
						
						reElement = New GimmickObject(id, x, y, left, top, width, height)
					EndIf
			End Select
			
			If (reElement <> Null) Then
				reElement.refreshCollisionRectWrap()
			EndIf
			
			Return reElement
		End
		
		Function gimmickInit:Void()
			furikoEnable = False
			ironBallEnable = False
			torchFireEnable = False
			rollPlatformEnable = False
			steamEnable = False
			waterFallEnable = False
			waterSlipEnable = False
			rollHobinEnable = False
			damageEnable = False
			seabedvolcanoEnable = False
		End
		
		Function gimmickStaticLogic:Void()
			If (furikoEnable) Then
				Furiko.staticLogic()
			EndIf
			
			If (damageEnable) Then
				DamageArea.staticLogic()
			EndIf
			
			MoveCalculator.staticLogic()
			
			If (waterFallEnable) Then
				WaterFall.staticLogic()
			EndIf
			
			If (waterSlipEnable) Then
				WaterSlip.staticLogic()
			EndIf
			
			If (torchFireEnable) Then
				TorchFire.staticLogic()
			EndIf
			
			If (steamEnable) Then
				SteamBase.staticLogic()
			EndIf
			
			If (ironBallEnable) Then
				IronBall.staticLogic()
			EndIf
			
			If (rollHobinEnable) Then
				RollHobin.staticLogic()
			EndIf
			
			If (rollPlatformEnable) Then
				RollPlatformSpeedA.staticLogic()
				RollPlatformSpeedB.staticLogic()
				RollPlatformSpeedC.staticLogic()
			EndIf
			
			If (seabedvolcanoEnable) Then
				SeabedVolcanoBase.staticLogic()
				SeabedVolcanoAsynBase.staticLogic()
			EndIf
		End
	
		Function releaseGimmickResource:Void()
			doorAnimation = Null
			shipRingImage = Null
			platformImage = Null
			hookImage = Null
			Hari.releaseAllResource()
			Spring.releaseAllResource()
			Stone.releaseAllResource()
			Marker.releaseAllResource()
			BreakPlatform.releaseAllResource()
			CaperBed.releaseAllResource()
			CaperBlock.releaseAllResource()
			Accelerate.releaseAllResource()
			Poal.releaseAllResource()
			Furiko.releaseAllResource()
			Shatter.releaseAllResource()
			Neji.releaseAllResource()
			Arm.releaseAllResource()
			PipeIn.releaseAllResource()
			Terminal.releaseAllResource()
			Belt.releaseAllResource()
			DamageArea.releaseAllResource()
			GraphicPatch.releaseAllResource()
			TutorialPoint.releaseAllResource()
			RopeStart.releaseAllResource()
			Cage.releaseAllResource()
			FallFlush.releaseAllResource()
			WaterSlip.releaseAllResource()
			TorchFire.releaseAllResource()
			SteamBase.releaseAllResource()
			SteamPlatform.releaseAllResource()
			CageButton.releaseAllResource()
			IronBall.releaseAllResource()
			RailFlipper.releaseAllResource()
			LightFont.releaseAllResource()
			HexHobin.releaseAllResource()
			BallHobin.releaseAllResource()
			RollHobin.releaseAllResource()
			CornerHobin.releaseAllResource()
			BarHorbinV.releaseAllResource()
			BarHorbinH.releaseAllResource()
			Balloon.releaseAllResource()
			ShipSystem.releaseAllResource()
			Ship.releaseAllResource()
			ShipBase.releaseAllResource()
			FlipH.releaseAllResource()
			FlipV.releaseAllResource()
			TeaCup.releaseAllResource()
			Door.releaseAllResource()
			FreeFallSystem.releaseAllResource()
			FreeFallBar.releaseAllResource()
			FreeFallPlatform.releaseAllResource()
			BreakWall.releaseAllResource()
			SpringPlatform.releaseAllResource()
			RailIn.releaseAllResource()
			DekaPlatform.releaseAllResource()
			Subeyuka.releaseAllResource()
			HariIsland.releaseAllResource()
			SpringIsland.releaseAllResource()
			WindParts.releaseAllResource()
			StoneBall.releaseAllResource()
			DownIsland.releaseAllResource()
			RollIsland.releaseAllResource()
			TogeShima.releaseAllResource()
			Bubble.releaseAllResource()
			Ice.releaseAllResource()
			SeabedVolcanoBase.releaseAllResource()
			SeabedVolcanoAsynBase.releaseAllResource()
			Accelerate.releaseAllResource()
			Fan.releaseAllResource()
			FinalShima.releaseAllResource()
			AirRoot.releaseAllResource()
			SpSpring.releaseAllResource()
			Boss4Ice.releaseAllResource()
			Boss6Block.releaseAllResource()
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Self.objId = id
			Self.posX = x
			Self.posY = y
			Self.iLeft = left
			Self.iTop = top
			Self.iWidth = width
			Self.iHeight = height
			Self.mWidth = width * BarHorbinV.COLLISION_OFFSET
			Self.mHeight = height * BarHorbinV.COLLISION_OFFSET
			Self.collisionRect.setRect(Self.posX, Self.posY, Self.mWidth, Self.mHeight)
		End
	Public
		' Methods:
		Method draw:Void(graphics:MFGraphics)
			drawCollisionRect(graphics)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future.
			If (p = player) Then
				Select (Self.objId)
					Case PlayerTails.TAILS_ANI_DEAD_1
						If (Not Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
							Self.used = False
						End ElseIf (Not Self.used) Then
							player.setCollisionLayer(0)
							Self.used = True
						End
					Case PlayerTails.TAILS_ANI_DEAD_2
						If (Not Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
							Self.used = False
						End ElseIf (Not Self.used) Then
							player.setCollisionLayer(1)
							Self.used = True
						End
					Case PlayerTails.TAILS_ANI_SPRING_1
						If (player instanceof PlayerSonic) Then
							player.slipEnd()
						End ElseIf (player instanceof PlayerAmy) Then
							player.slipEnd()
						End
					Case PlayerTails.TAILS_ANI_CLIFF_2
						If (Not Self.used And player.beUnseenPop()) Then
							Self.used = True
						End
					Case PlayerTails.TAILS_ANI_UP_ARM
						If (Not Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
							Self.used = False
						End ElseIf (Not Self.used) Then
							player.ductIn()
							Self.used = True
							If (Not (player instanceof PlayerAmy) And player.getAnimationId() <> 4) Then
								soundInstance.playSe(4)
							End
						End
					Case PlayerTails.TAILS_ANI_POLE_V
						If (Not Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
							Self.used = False
						End ElseIf (Not Self.used) Then
							player.velX = 0
							player.ductOut()
							Self.used = True
						End
					Case PlayerTails.TAILS_ANI_POLE_H
						If (player.isOnGound() And Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
							player.setVelX(PlayerObject.HUGE_POWER_SPEED)
						End
					Case PlayerTails.TAILS_ANI_ROLL_V_1
						If (player.isOnGound()) Then
							player.setVelX(-1900)
						End
					Case PlayerTails.TAILS_ANI_ROLL_V_2
					Case GIMMICK_MOVE
						If (Not Self.used And player.setRailLine(New Line(Self.posX, Self.posY, Self.posX + Self.iLeft, Self.posY + Self.iTop), Self.posX, Self.posY, Self.iLeft, Self.iTop, Self.iWidth, Self.iHeight, Self)) Then
							Self.used = True
							soundInstance.playSe(37)
						End
					Case 66
						If (Self.firstTouch And StageManager.getCurrentZoneId() <> 3) Then
							player.setFall(Self.posX - RollPlatformSpeedC.COLLISION_OFFSET_Y, Self.posY, Self.iLeft, Self.iTop)
							player.stopMove()
						End
					Case GIMMICK_SEE
						If (Not Self.used And Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
							Bool z
							PlayerObject playerObject = player
							If (Self.iLeft = 0) Then
								z = True
							Else
								z = False
							End
							playerObject.changeVisible(z)
							Self.used = True
						End
					Case GIMMICK_WIND
						framecnt += 1
						If (Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
							If (StageManager.getStageID() = 11) Then
								player.collisionState = GIMMICK_HARI_UP
								player.isInGravityCircle = True
							End
							If (player.collisionState = GIMMICK_HARI_UP) Then
								player.collisionState = GIMMICK_HARI_UP
								If (StageManager.getStageID() = 11) Then
									player.worldCal.stopMoveY()
									ACWorldCollisionCalculator aCWorldCollisionCalculator = player.worldCal
									ACWorldCollisionCalculator aCWorldCollisionCalculator2 = player.worldCal
									aCWorldCollisionCalculator.actionState = GIMMICK_HARI_UP
								End
								If (player.getVelY() > WIND_VELOCITY) Then
									player.setVelY(player.getVelY() + WIND_ACCELERATE)
								Else
									player.setVelY(WIND_VELOCITY)
								End
								If (StageManager.getStageID() = 11) Then
									player.setAnimationId(9)
									Return
								Else
									player.setAnimationId(29)
									Return
								End
							End
							soundInstance.stopLoopSe()
							framecnt = 0
							isFirstTouchedWind = False
							player.isInGravityCircle = False
						End
					Case Def.TOUCH_START_GAME_WIDTH
						If (Not Self.used) Then
							player.setAnimationId(4)
							SoundSystem soundSystem = soundInstance
							SoundSystem soundSystem2 = soundInstance
							soundSystem.playSe(37)
							Self.used = True
						End
					Default
						' Nothing so far.
				End Select
			EndIf
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Select (Self.objId)
				Case PlayerTails.TAILS_ANI_SPRING_1
					Self.collisionRect.setRect(((Self.mWidth Shr 1) + x) - MDPhone.SCREEN_HEIGHT, y, 1280, Self.mHeight)
				Case 66
					Self.collisionRect.setRect(x - SpecialMap.MAP_LENGTH, y, PlayerObject.HEIGHT, 64)
				Case GIMMICK_SEE
					Self.collisionRect.setRect(x, y, Self.mWidth, Self.mHeight)
				Case 73
					Self.collisionRect.setRect(Self.posX, Self.posY - BarHorbinV.COLLISION_OFFSET, BarHorbinV.COLLISION_OFFSET, BarHorbinV.COLLISION_OFFSET)
				default:
			End
		End
	
		Method doWhileRail:Void(object:PlayerObject, direction:Int)
			Select (Self.objId)
				Case GIMMICK_MOVE
					If (Not Self.used And player.setRailLine(New Line(Self.posX, Self.posY, Self.posX + Self.iLeft, Self.posY + Self.iTop), Self.posX, Self.posY, Self.iLeft, Self.iTop, Self.iWidth, Self.iHeight, Self)) Then
						Self.used = True
						soundInstance.playSe(37)
					End
				Case 66
					If (Self.firstTouch) Then
						player.setFall(Self.posX - RollPlatformSpeedC.COLLISION_OFFSET_Y, Self.posY, Self.iLeft, Self.iTop)
					End
				Case GIMMICK_SEE
					If (Not Self.used And Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
						player.changeVisible(Self.iLeft = 0)
						Self.used = True
					End
				Case 73
					If (Self.firstTouch) Then
						player.setRailFlip()
					End
				Case Def.TOUCH_START_GAME_WIDTH
					If (Not Self.used) Then
						player.setAnimationId(4)
						SoundSystem soundSystem = soundInstance
						SoundSystem soundSystem2 = soundInstance
						soundSystem.playSe(37)
						Self.used = True
					End
				Default
					' Nothing so far.
			End
		End
	
		Method doWhileNoCollision:Void()
			Select (Self.objId)
				Case GIMMICK_CHANGE_LAYER_A, GIMMICK_CHANGE_LAYER_B, GIMMICK_SLIP_START, GIMMICK_SLIP_END, GIMMICK_INVISIBLE_CAPER, GIMMICK_AROUND_ENTRANCE, GIMMICK_AROUND_EXIT, GIMMICK_SPIN, GIMMICK_MOVE
					Self.used = False
				Case GIMMICK_SEE
					If (Self.used) Then
						Self.used = False
						
						If (Self.iLeft = 0) Then
							player.setFallOver()
						EndIf
					EndIf
				Case GIMMICK_WIND
					If (player.isInGravityCircle) Then
						player.isInGravityCircle = False
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method close:Void()
			' Empty implementation.
		End
	
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
	
		Method doWhileCollision:Void(arg0:ACObject, arg1:ACCollision, arg2:Int, arg3:Int, arg4:Int, arg5:Int, arg6:Int)
			' Empty implementation.
		End
End