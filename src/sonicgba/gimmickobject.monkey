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

' Friends:
Friend sonicgba.gameobject

' Imports:
Public
	Import sonicgba.sonicdef
	Import sonicgba.gameobject
Private
	Import gameengine.def
	
	' I'm not sure if all of these are needed.
	Import lib.animation
	Import lib.line
	Import lib.soundsystem
	Import lib.crlfp32
	
	Import mflib.mainstate
	
	' Questionable imports (Probably automatic; should be removed later):
	Import special.ssdef
	Import special.specialmap
	Import special.specialobject
	
	Import state.state
	Import state.stringindex
	Import state.titlestate
	
	Import sonicgba.playerobject
	
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acworldcollisioncalculator
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	' Gimmicks:
	Import sonicgba.accelerate
	Import sonicgba.airroot
	Import sonicgba.antigravity
	Import sonicgba.arm
	Import sonicgba.ballhobin
	Import sonicgba.balloon
	Import sonicgba.bank
	Import sonicgba.banper
	Import sonicgba.barhorbinh
	Import sonicgba.barhorbinv
	Import sonicgba.belt
	Import sonicgba.block
	Import sonicgba.boss4ice
	Import sonicgba.boss6block
	Import sonicgba.breakplatform
	Import sonicgba.breakwall
	Import sonicgba.bubble
	Import sonicgba.cage
	Import sonicgba.cagebutton
	Import sonicgba.caperbed
	Import sonicgba.caperblock
	Import sonicgba.changerectregion
	Import sonicgba.cornerhobin
	Import sonicgba.damagearea
	Import sonicgba.dekaplatform
	Import sonicgba.door
	Import sonicgba.downisland
	Import sonicgba.fallflush
	Import sonicgba.fallingplatform
	Import sonicgba.fan
	Import sonicgba.finalshima
	Import sonicgba.fliph
	Import sonicgba.flipv
	Import sonicgba.fountain
	Import sonicgba.freefallbar
	Import sonicgba.freefallplatform
	Import sonicgba.freefallsystem
	Import sonicgba.furiko
	Import sonicgba.gameobject
	Import sonicgba.graphicpatch
	Import sonicgba.hari
	Import sonicgba.hariisland
	Import sonicgba.hexhobin
	Import sonicgba.ice
	Import sonicgba.ironball
	Import sonicgba.ironbar
	Import sonicgba.leaf
	Import sonicgba.lightfont
	Import sonicgba.marker
	Import sonicgba.movecalculator
	Import sonicgba.neji
	Import sonicgba.pipein
	Import sonicgba.pipeout
	Import sonicgba.pipeset
	Import sonicgba.platform
	Import sonicgba.playeramy
	Import sonicgba.playerobject
	Import sonicgba.playersonic
	Import sonicgba.poal
	Import sonicgba.railflipper
	Import sonicgba.railin
	Import sonicgba.railout
	Import sonicgba.rollhobin
	Import sonicgba.rollisland
	Import sonicgba.rollplatformspeeda
	Import sonicgba.rollplatformspeedb
	Import sonicgba.rollplatformspeedc
	Import sonicgba.ropeend
	Import sonicgba.ropestart
	Import sonicgba.ropeturn
	Import sonicgba.seabedvolcanoasynbase
	Import sonicgba.seabedvolcanobase
	Import sonicgba.shatter
	Import sonicgba.ship
	Import sonicgba.shipbase
	Import sonicgba.shipsystem
	Import sonicgba.slipstart
	Import sonicgba.spspring
	Import sonicgba.split
	Import sonicgba.spring
	Import sonicgba.springisland
	Import sonicgba.springplatform
	Import sonicgba.stagemanager
	Import sonicgba.steambase
	Import sonicgba.steamplatform
	Import sonicgba.stone
	Import sonicgba.stoneball
	Import sonicgba.subeyuka
	Import sonicgba.teacup
	Import sonicgba.terminal
	Import sonicgba.togeshima
	Import sonicgba.torchfire
	Import sonicgba.transpoint
	Import sonicgba.tutorialpoint
	Import sonicgba.unseenspring
	Import sonicgba.uparm
	Import sonicgba.upplatform
	Import sonicgba.waterfall
	Import sonicgba.waterslip
	Import sonicgba.windparts
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
		
		' I'm guessing this is the number of gimmick classes...?
		Const GIMMICK_NUM:Int = 110
		
		Const PLATFORM_OFFSET_Y:Int = -256
		
		' Gimmick IDs:
		
		' Spike configurations:
		Const GIMMICK_HARI_UP:= 1
		Const GIMMICK_HARI_DOWN:= 2
		Const GIMMICK_HARI_LEFT:= 3
		Const GIMMICK_HARI_RIGHT:= 4
		Const GIMMICK_HARI_MOVE_UP:= 5
		Const GIMMICK_HARI_MOVE_DOWN:= 6
		
		Const GIMMICK_HARI_ISLAND:= 61
		
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
		Const GIMMICK_DOOR_V:= 63
		Const GIMMICK_DOOR_H:= 64
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
		Field iWidth:Int
		Field iHeight:Int
		Field iTop:Int
		Field iLeft:Int
		
		Field used:Bool
	Public
		' Functions:
		Function getNewInstance:GameObject(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Local reElement:GameObject = Null
			
			x Shl= 6
			y Shl= 6
			
			Select (id)
				Case GIMMICK_GOAL
					reElement = New Terminal(id, x, y, left, top, width, height)
				Case GIMMICK_HARI_UP, GIMMICK_HARI_DOWN, GIMMICK_HARI_LEFT, GIMMICK_HARI_RIGHT, GIMMICK_HARI_MOVE_UP, GIMMICK_HARI_MOVE_DOWN
					reElement = New Hari(id, x, y, left, top, width, height)
				Case GIMMICK_MARKER
					reElement = New Marker(id, x, y, left, top, width, height)
				Case GIMMICK_SPRING_UP, GIMMICK_SPRING_DOWN, GIMMICK_SPRING_LEFT, GIMMICK_SPRING_RIGHT, GIMMICK_SPRING_LEFT_UP, GIMMICK_SPRING_RIGHT_UP, GIMMICK_SPRING_LEFT_UP_BURY, GIMMICK_SPRING_RIGHT_UP_BURY
					reElement = New Spring(id, x, y, left, top, width, height)
				Case GIMMICK_STONE
					reElement = New Stone(id, x, y, left, top, width, height)
				Case GIMMICK_SLIP_START
					reElement = New SlipStart(id, x, y, left, top, width, height)
				Case GIMMICK_FLOATING_ISLAND
					reElement = New Platform(id, x, y, left, top, width, height)
				Case GIMMICK_FALLING_ISLAND
					reElement = New FallingPlatform(id, x, y, left, top, width, height)
				Case GIMMICK_CAPER_BED
					reElement = New CaperBed(id, x, y, left, top, width, height)
				Case GIMMICK_BREAK_ISLAND
					reElement = New BreakPlatform(id, x, y, left, top, width, height)
				Case GIMMICK_CAPER_BLOCK
					reElement = New CaperBlock(id, x, y, left, top, width, height)
				Case GIMMICK_ACCELERATOR_FORWARD, GIMMICK_ACCELERATOR_FORWARD_UP, GIMMICK_ACCELERATOR_FORWARD_DOWN, GIMMICK_DASH_PANEL_HIGH
					reElement = New Accelerate(id, x, y, left, top, width, height)
				Case GIMMICK_POAL, GIMMICK_POAL_LEFT, GIMMICK_POAL_RIGHT
					reElement = New Poal(id, x, y, left, top, width, height)
				Case GIMMICK_BELT
					reElement = New Belt(id, x, y, left, top, width, height)
				Case GIMMICK_BANPER
					reElement = New Banper(id, x, y, left, top, width, height)
				Case GIMMICK_KASSHA
					reElement = New RopeStart(id, x, y, left, top, width, height)
				Case GIMMICK_FURIKO
					reElement = New Furiko(id, x, y, left, top, width, height)
					furikoEnable = True
				Case GIMMICK_SHATTER
					reElement = New Shatter(id, x, y, left, top, width, height)
				Case GIMMICK_NEJI
					reElement = New Neji(id, x, y, left, top, width, height)
				Case GIMMICK_ARM
					reElement = New Arm(id, x, y, left, top, width, height)
				Case GIMMICK_SP_BANE
					If (stageModeState = STATE_RACE_MODE) Then
						reElement = Null
					Else
						reElement = New SpSpring(id, x, y, left, top, width, height)
					EndIf
				Case GIMMICK_DAMAGE
					reElement = New DamageArea(id, x, y, left, top, width, height)
					
					damageEnable = True
				Case GIMMICK_PIPE
					reElement = New PipeSet(id, x, y, left, top, width, height)
				Case GIMMICK_PIPE_IN
					reElement = New PipeIn(id, x, y, left, top, width, height)
				Case GIMMICK_PIPE_OUT
					reElement = New PipeOut(id, x, y, left, top, width, height)
				Case GIMMICK_GRAPHIC_PATCH
					reElement = New GraphicPatch(id, x, y, left, top, width, height)
				Case GIMMICK_ROPE_END
					reElement = New RopeEnd(id, x, y, left, top, width, height)
				Case GIMMICK_ROPE_TURN
					reElement = New RopeTurn(id, x, y, left, top, width, height)
				Case GIMMICK_TUTORIAL
					reElement = New TutorialPoint(id, x, y, left, top, width, height)
				Case GIMMICK_CHANGE_RECT_REGION
					reElement = New ChangeRectRegion(id, x, y, left, top, width, height)
				Default
					Select (id)
						Case GIMMICK_WATER_FALL
							reElement = New WaterFall(id, x, y, left, top, width, height)
							
							waterFallEnable = True
						Case GIMMICK_WALL_WALKER_ENTRANCE_LEFT, GIMMICK_WALL_WALKER_ENTRANCE_RIGHT
							reElement = New Bank(id, x, y, left, top, width, height)
						Case GIMMICK_WATER_PILLAR
							reElement = New Fountain(id, x, y, left, top, width, height)
						Case GIMMICK_WATER_PILLAR_2
							reElement = New FallFlush(id, x, y, left, top, width, height)
						Case GIMMICK_WATER_SLIP
							reElement = New WaterSlip(id, x, y, left, top, width, height)
							
							waterSlipEnable = True
						Case GIMMICK_HEX_HOBIN
							reElement = New HexHobin(id, x, y, left, top, width, height)
						Case GIMMICK_BALL_HOBIN
							reElement = New BallHobin(id, x, y, left, top, width, height)
						Case GIMMICK_ROLL_HOBIN
							reElement = New RollHobin(id, x, y, left, top, width, height)
							
							rollHobinEnable = True
						Case GIMMICK_BAR_H
							reElement = New BarHorbinH(id, x, y, left, top, width, height)
						Case GIMMICK_BAR_V
							reElement = New BarHorbinV(id, x, y, left, top, width, height)
						Case GIMMICK_CORNER_BAR
							reElement = New CornerHobin(id, x, y, left, top, width, height)
						Case GIMMICK_FLIPPER
							reElement = New FlipH(id, x, y, left, top, width, height)
						Case GIMMICK_FLIPPER_V
							reElement = New FlipV(id, x, y, left, top, width, height)
						Case GIMMICK_SPRING_ISLAND
							reElement = New SpringPlatform(id, x, y, left, top, width, height)
						Case GIMMICK_VIEW_LIGHTS
							reElement = New LightFont(id, x, y, left, top, width, height)
						Case GIMMICK_BALLOON
							reElement = New Balloon(id, x, y, left, top, width, height)
						Case GIMMICK_SHIP
							reElement = New ShipSystem(id, x, y, left, top, width, height)
						Case GIMMICK_TEA_CUP
							reElement = New TeaCup(id, x, y, left, top, width, height)
						Case GIMMICK_DOOR_V, GIMMICK_DOOR_H
							reElement = New Door(id, x, y, left, top, width, height)
						Case GIMMICK_RAIL_IN
							reElement = New RailIn(id, x, y, left, top, width, height)
						Case GIMMICK_RAIL_OUT
							reElement = New RailOut(id, x, y, left, top, width, height)
						Case GIMMICK_WARP
							reElement = New TransPoint(id, x, y, left, top, width, height)
						Case GIMMICK_RAIL_FLIPPER
							reElement = New RailFlipper(id, x, y, left, top, width, height)
						Case GIMMICK_FREE_FALL
							reElement = New FreeFallSystem(id, x, y, left, top, width, height)
						Case GIMMICK_STEAM
							reElement = New SteamBase(id, x, y, left, top, width, height)
							
							steamEnable = True
						Case GIMMICK_IRON_BALL
							reElement = New IronBall(id, x, y, left, top, width, height)
							
							ironBallEnable = True
						Case GIMMICK_IRON_BAR
							reElement = New IronBar(id, x, y, left, top, width, height)
						Case GIMMICK_TAIMATU
							reElement = New TorchFire(id, x, y, left, top, width, height)
							
							torchFireEnable = True
						Case GIMMICK_ROLL_SHIMA
							If (top = 5) Then
								reElement = New RollPlatformSpeedA(id, x, y, left, top, width, height)
							ElseIf (top = 2) Then
								reElement = New RollPlatformSpeedB(id, x, y, left, top, width, height)
							ElseIf (top = 4) Then
								reElement = New RollPlatformSpeedC(id, x, y, left, top, width, height)
							EndIf
							
							rollPlatformEnable = True
						Case GIMMICK_SPLIT
							reElement = New Split(id, x, y, left, top, width, height)
						Case GIMMICK_WALL
							reElement = New BreakWall(id, x, y, left, top, width, height)
					End Select
					
					Select (id)
						Case GIMMICK_LEAF
							reElement = New Leaf(id, x, y, left, top, width, height)
						Case GIMMICK_DASH_PANEL_TATE
							reElement = New Accelerate(id, x, y, left, top, width, height)
						Case GIMMICK_BIG_FLOATING_ISLAND
							reElement = New DekaPlatform(id, x, y, left, top, width, height)
						Case GIMMICK_HARI_ISLAND
							reElement = New HariIsland(id, x, y, left, top, width, height)
						Case GIMMICK_BANE_ISLAND
							reElement = New SpringIsland(id, x, y, left, top, width, height)
						Case GIMMICK_SUBEYUKA
							reElement = New Subeyuka(id, x, y, left, top, width, height)
						Case GIMMICK_DOWN_SHIMA
							reElement = New DownIsland(id, x, y, left, top, width, height)
						Case GIMMICK_ROLL_ASHIBA
							reElement = New RollIsland(id, x, y, left, top, width, height)
						Case GIMMICK_UP_ARM
							reElement = New UpArm(id, x, y, left, top, width, height)
						Case GIMMICK_UP_SHIMA
							reElement = New UpPlatform(id, x, y, left, top, width, height)
						Case GIMMICK_STONE_BALL
							reElement = New StoneBall(id, x, y, left, top, width, height)
						Case GIMMICK_TOGE_SHIMA
							reElement = New TogeShima(id, x, y, left, top, width, height)
						Case GIMMICK_BUBBLE
							reElement = New Bubble(id, x, y, left, top, width, height)
						Case GIMMICK_ICE
							reElement = New Ice(id, x, y, left, top, width, height)
						Case GIMMICK_WIND_PARTS
							reElement = New WindParts(id, x, y, left, top, width, height)
						Case GIMMICK_FIRE_MT
							If (left = 35 Or left = 9 Or left = -21) Then
								reElement = New SeabedVolcanoAsynBase(id, x, y, left, top, width, height)
							Else
								reElement = New SeabedVolcanoBase(id, x, y, left, top, width, height)
							EndIf
							
							seabedvolcanoEnable = True
						Case GIMMICK_BLOCK
							reElement = New Block(id, x, y, left, top, width, height)
						Case GIMMICK_FAN
							reElement = New Fan(id, x, y, left, top, width, height)
						Case GIMMICK_F_SHIMA_FALL
							reElement = New FinalShima(id, x, y, left, top, width, height)
						Case GIMMICK_UG_BANE
							reElement = New UnseenSpring(id, x, y, left, top, width, height)
						Case GIMMICK_GRAVITY
							reElement = New AntiGravity(id, x, y, left, top, width, height)
						Case GIMMICK_AIR_ROOT
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
	
		Function releaseGimmickResource:Void() ' Function releaseAllGimmickResource:Void()
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
			'Accelerate.releaseAllResource()
			Fan.releaseAllResource()
			FinalShima.releaseAllResource()
			AirRoot.releaseAllResource()
			SpSpring.releaseAllResource()
			Boss4Ice.releaseAllResource()
			Boss6Block.releaseAllResource()
		End
		
		' Extensions:
		
		' This returns the object referenced by 'platformImage' when loading is complete.
		Function loadPlatformImage:MFImage()
			If (platformImage = Null) Then
				Try
					If (StageManager.getCurrentZoneId() <> 6) Then
						platformImage = MFImage.createImage("/gimmick/platform" + StageManager.getCurrentZoneId() + ".png")
					Else
						platformImage = MFImage.createImage("/gimmick/platform" + StageManager.getCurrentZoneId() + (StageManager.getStageID() - 9) + ".png")
					EndIf
				Catch E:Throwable
					' Nothing so far.
				End Try
				
				If (platformImage = Null) Then
					platformImage = MFImage.createImage("/gimmick/platform0.png")
				EndIf
			EndIf
			
			Return platformImage
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
			
			Self.mWidth = (width * 512)
			Self.mHeight = (height * 512)
			
			Self.collisionRect.setRect(Self.posX, Self.posY, Self.mWidth, Self.mHeight)
		End
	Public
		' Methods:
		Method draw:Void(graphics:MFGraphics)
			drawCollisionRect(graphics)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (p = player) Then
				Select (Self.objId)
					Case GIMMICK_CHANGE_LAYER_A
						If (Not Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
							Self.used = False
						ElseIf (Not Self.used) Then
							' Magic number: 0
							p.setCollisionLayer(0)
							
							Self.used = True
						EndIf
					Case GIMMICK_CHANGE_LAYER_B
						If (Not Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
							Self.used = False
						ElseIf (Not Self.used) Then
							' Magic number: 1
							p.setCollisionLayer(1)
							
							Self.used = True
						EndIf
					Case GIMMICK_SLIP_END
						Local charID:= p.getCharacterID()
						
						If (charID = CHARACTER_SONIC Or charID = CHARACTER_AMY) Then
							p.slipEnd()
						EndIf
					Case GIMMICK_INVISIBLE_CAPER
						If (Not Self.used And p.beUnseenPop()) Then
							Self.used = True
						EndIf
					Case GIMMICK_AROUND_ENTRANCE
						If (Not Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
							Self.used = False
						ElseIf (Not Self.used) Then
							p.ductIn()
							
							Self.used = True
							
							If ((p.getCharacterID() <> CHARACTER_AMY) And p.getAnimationId() <> 4) Then
								soundInstance.playSe(4)
							EndIf
						EndIf
					Case GIMMICK_AROUND_EXIT
						If (Not Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
							Self.used = False
						ElseIf (Not Self.used) Then
							p.velX = 0
							p.ductOut()
							
							Self.used = True
						EndIf
					Case GIMMICK_ADD_DOUBLE_MAX_SPEED
						If (p.isOnGound() And Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
							p.setVelX(PlayerObject.HUGE_POWER_SPEED)
						EndIf
					Case GIMMICK_MINUS_DOUBLE_MAX_SPEED
						If (p.isOnGound()) Then
							p.setVelX(-PlayerObject.HUGE_POWER_SPEED)
						EndIf
					Case GIMMICK_DEGREE_CHANGE_180, GIMMICK_MOVE
						If (Not Self.used And p.setRailLine(New Line(Self.posX, Self.posY, Self.posX + Self.iLeft, Self.posY + Self.iTop), Self.posX, Self.posY, Self.iLeft, Self.iTop, Self.iWidth, Self.iHeight, Self)) Then
							Self.used = True
							soundInstance.playSe(SoundSystem.SE_148)
						EndIf
					Case GIMMICK_FALL
						If (Self.firstTouch And StageManager.getCurrentZoneId() <> 3) Then
							p.setFall(Self.posX - 256, Self.posY, Self.iLeft, Self.iTop)
							p.stopMove()
						EndIf
					Case GIMMICK_SEE
						If (Not Self.used And Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
							Local z:Bool = (Self.iLeft = 0)
							
							p.changeVisible(z)
							
							Self.used = True
						EndIf
					Case GIMMICK_WIND
						framecnt += 1
						
						If (Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
							If (StageManager.getStageID() = 11) Then
								p.collisionState = PlayerObject.COLLISION_STATE_JUMP
								
								p.isInGravityCircle = True
							EndIf
							
							If (p.collisionState = PlayerObject.COLLISION_STATE_JUMP) Then
								p.collisionState = PlayerObject.COLLISION_STATE_JUMP
								
								If (StageManager.getStageID() = 11) Then
									Local aCWorldCollisionCalculator:= p.worldCal
									
									aCWorldCollisionCalculator.stopMoveY()
									
									aCWorldCollisionCalculator.actionState = ACWorldCollisionCalculator.JUMP_ACTION_STATE
								EndIf
								
								If (p.getVelY() > WIND_VELOCITY) Then
									p.setVelY(p.getVelY() + WIND_ACCELERATE)
								Else
									p.setVelY(WIND_VELOCITY)
								EndIf
								
								If (StageManager.getStageID() = 11) Then
									p.setAnimationId(9)
								Else
									p.setAnimationId(29)
								EndIf
							Else
								soundInstance.stopLoopSe()
								
								framecnt = 0
								
								isFirstTouchedWind = False
								
								p.isInGravityCircle = False
							EndIf
						End
					Case GIMMICK_SPIN
						If (Not Self.used) Then
							p.setAnimationId(4)
							
							soundInstance.playSe(SoundSystem.SE_148)
							
							Self.used = True
						End
					Default
						' Nothing so far.
				End Select
			EndIf
		End
	
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Select (Self.objId)
				Case GIMMICK_SLIP_END
					Self.collisionRect.setRect(((Self.mWidth Shr 1) + x) - MDPhone.SCREEN_HEIGHT, y, 1280, Self.mHeight)
				Case GIMMICK_FALL
					Self.collisionRect.setRect(x - SpecialMap.MAP_LENGTH, y, PlayerObject.HEIGHT, 64)
				Case GIMMICK_SEE
					Self.collisionRect.setRect(x, y, Self.mWidth, Self.mHeight)
				Case GIMMICK_RAIL_FLIPPER
					Self.collisionRect.setRect(Self.posX, Self.posY - 512, 512, 512)
				Default
					' Nothing so far.
			End Select
		End
	
		Method doWhileRail:Void(player:PlayerObject, direction:Int)
			Select (Self.objId)
				Case GIMMICK_MOVE
					If (Not Self.used And player.setRailLine(New Line(Self.posX, Self.posY, Self.posX + Self.iLeft, Self.posY + Self.iTop), Self.posX, Self.posY, Self.iLeft, Self.iTop, Self.iWidth, Self.iHeight, Self)) Then
						Self.used = True
						
						soundInstance.playSe(SoundSystem.SE_148)
					EndIf
				Case GIMMICK_FALL
					If (Self.firstTouch) Then
						player.setFall(Self.posX - 256, Self.posY, Self.iLeft, Self.iTop)
					EndIf
				Case GIMMICK_SEE
					If (Not Self.used And Self.collisionRect.collisionChk(player.getCheckPositionX(), player.getCheckPositionY())) Then
						player.changeVisible(Self.iLeft = 0)
						Self.used = True
					EndIf
				Case GIMMICK_RAIL_FLIPPER
					If (Self.firstTouch) Then
						player.setRailFlip()
					EndIf
				Case GIMMICK_SPIN
					If (Not Self.used) Then
						player.setAnimationId(4)
						
						soundInstance.playSe(SoundSystem.SE_148)
						
						Self.used = True
					EndIf
				Default
					' Nothing so far.
			End Select
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
		
		Method logic:Void(x:Int, y:Int)
			' Empty implementation.
		End
		
		Method close:Void()
			' Empty implementation.
		End
	
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
End