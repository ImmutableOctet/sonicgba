Strict

Public

' Friends:
Friend sonicgba.gameobject
Friend sonicgba.enemyobject
Friend sonicgba.gimmickobject
Friend sonicgba.itemobject
Friend sonicgba.stagemanager
Friend sonicgba.rocketseparateeffect

Friend sonicgba.playersonic
Friend sonicgba.playertails
Friend sonicgba.playerknuckles
Friend sonicgba.playeramy
Friend sonicgba.playersupersonic

Friend sonicgba.playeranimationcollisionrect
Friend sonicgba.cage
Friend sonicgba.cagebutton
Friend sonicgba.seabedvolcanoplatform
Friend sonicgba.seabedvolcanoasynplatform
Friend sonicgba.hexhobin
Friend sonicgba.ballhobin
Friend sonicgba.cornerhobin
Friend sonicgba.belt
Friend sonicgba.spring
Friend sonicgba.unseenspring
Friend sonicgba.rollisland
Friend sonicgba.springisland
Friend sonicgba.caperbed
Friend sonicgba.caperblock
Friend sonicgba.changerectregion
Friend sonicgba.slipstart
Friend sonicgba.ironbar
Friend sonicgba.marker
Friend sonicgba.poal
Friend sonicgba.neji
Friend sonicgba.arm
Friend sonicgba.ice

Friend sonicgba.pipein
Friend sonicgba.pipeout
Friend sonicgba.pipeset

Friend sonicgba.bossf3arm

Friend state.gamestate

' Imports:
Private
	Import common.numberdrawer
	
	Import gameengine.def
	Import gameengine.key
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.coordinate
	Import lib.direction
	Import lib.line
	Import lib.myapi
	Import lib.myrandom
	Import lib.soundsystem
	Import lib.constutil
	Import lib.crlfp32
	
	Import sonicgba.accelerate
	Import sonicgba.aspiratebubble
	Import sonicgba.collisionmap
	Import sonicgba.collisionrect
	Import sonicgba.dekaplatform
	Import sonicgba.drownbubble
	Import sonicgba.effect
	Import sonicgba.enemyobject
	Import sonicgba.focusable
	Import sonicgba.gameobject
	Import sonicgba.gimmickobject
	Import sonicgba.globalresource
	Import sonicgba.hari
	Import sonicgba.itemobject
	Import sonicgba.mapmanager
	Import sonicgba.moveobject
	Import sonicgba.playeramy
	Import sonicgba.playerknuckles
	Import sonicgba.playersonic
	Import sonicgba.playersupersonic
	Import sonicgba.playertails
	Import sonicgba.ringobject
	Import sonicgba.rocketseparateeffect
	Import sonicgba.spring
	Import sonicgba.stagemanager
	Import sonicgba.playeranimationcollisionrect
	
	Import state.gamestate
	Import state.state
	'Import state.stringindex
	'Import state.titlestate
	
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.accollision
	Import com.sega.engine.action.acobject
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworldcaluser
	Import com.sega.engine.action.acworldcollisioncalculator
	
	'Import com.sega.mobile.define.mdphone
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	Import com.sega.mobile.framework.utility.mfmath
	
	'Import brl.stream
	
	Import regal.typetool
Public

' Classes:
Class PlayerObject Extends MoveObject Implements Focusable, ACWorldCalUser Abstract
	Private
		' Constant variable(s):
		Const ANIMATION_PATH:String = "/animation"
		
		Const ASPIRATE_INTERVAL:Int = 3
		
		Const ATTRACT_EFFECT_HEIGHT:Int = 9600
		Const ATTRACT_EFFECT_WIDTH:Int = 9600
		
		Const BAR_COLOR:Int = 2
		
		Const BACKGROUND_WIDTH:Int = 80
		Const BG_NUM:Int = (((SCREEN_WIDTH + BACKGROUND_WIDTH) - 1) / BACKGROUND_WIDTH)
		
		Const BREATHE_IMAGE_HEIGHT:Int = 16
		Const BREATHE_IMAGE_WIDTH:Int = 16
		Const BREATHE_TIME_COUNT:Int = 21000
		Const BREATHE_TO_DIE_PER_COUNT:Int = 1760
		
		Const B_1:Int = 5760
		Const B_2:Int = 11264
		
		Const CAMERA_MAX_DISTANCE:Int = 20
		
		Const CENTER_X:Int = 660480
		Const CENTER_Y:Int = 63488
		
		Const COUNT_INDEX:Int = 1
		
		Const DEBUG_WUDI:Bool = False
		Const DIE_DRIP_STATE_JUMP_V0:Int = -800
		Const DO_POAL_MOTION_SPEED:Int = 600
		Const ENLARGE_NUM:Int = 1920
		
		' Not sure about these two:
		Const f23A:Int = 3072
		Const f24C:Int = 3072
		
		Const FADE_FILL_HEIGHT:Int = 40
		Const FADE_FILL_WIDTH:Int = 40
		
		Global FOCUS_MAX_OFFSET:Int = (MapManager.CAMERA_HEIGHT / 2) - 16 ' Const
		
		Const FOCUS_MOVE_SPEED:Int = 15
		Const FOCUS_MOVING_NONE:Int = 0
		
		Const FONT_NUM:Int = 7
		
		Const FOOT_OFFSET:Int = 256
		
		Const HINER_JUMP_LIMIT:Int = 1024
		Const HINER_JUMP_MAX:Int = 4352
		Const HINER_JUMP_X_ADD:Int = 1024
		Const HINER_JUMP_Y:Int = 2048
		
		Const ICE_SLIP_FLUSH_OFFSET_Y:Int = 512
		Const INVINCIBLE_COUNT:Int = 320
		
		Const IN_WATER_WALK_SPEED_SCALE1:Float = 5.0
		Const IN_WATER_WALK_SPEED_SCALE2:Float = 9.0
		
		Const ITEM_INDEX:Int = 0
		
		Const JUMP_EFFECT_WIDTH:Int = 1920
		Const JUMP_EFFECT_HEIGHT:Int = 1920
		Const JUMP_EFFECT_OFFSET_Y:Int = 256
		
		Const LEFT_FOOT_OFFSET_X:Int = -256
		Const LEFT_WALK_COLLISION_CHECK_OFFSET_X:Int = -512
		Const LEFT_WALK_COLLISION_CHECK_OFFSET_Y:Int = -512
		
		Const LOOK_COUNT:Int = 32
		
		Const MAX_ITEM:Int = 5
		Const MAX_ITEM_SHOW_NUM:Int = 4
		
		Const MOON_STAR_FRAMES_1:Int = 207
		Const MOON_STAR_FRAMES_2:Int = 120
		Const MOON_STAR_ORI_X_1:Int = 360
		Const MOON_STAR_ORI_Y_1:Int = 18
		Const MOON_STAR_DES_X_1:Int = (MOON_STAR_ORI_X_1 - 22)
		Const MOON_STAR_DES_Y_1:Int = 26
		
		Global NUM_DISTANCE:Int = PickValue(((NUM_SPACE[0] * 8) > 60), NUM_SPACE[0] * 7, 60)
		
		' Sizes of numbers found in "number.png":
		Const NUM_PIC_WIDTH:Int = 7
		Const NUM_PIC_HEIGHT:Int = 13
		Const NUM_PIC_SPACE_WIDTH:= (NUM_PIC_WIDTH+1)
		
		Const PIPE_SET_POWER:Int = 2880
		
		Const RAIL_FLIPPER_V0:Int = -3380
		Const RAIL_OUT_SPEED_VY0:Int = -1200
		
		Const RIGHT_FOOT_OFFSET_X:Int = 256
		Const RIGHT_WALK_COLLISION_CHECK_OFFSET_X:Int = 512
		Const RIGHT_WALK_COLLISION_CHECK_OFFSET_Y:Int = -512
		
		Const SIDE_COLLISION_NUM:Int = -2
		Const SIDE_FOOT_FROM_CENTER:Int = 256
		
		Const SMALL_JUMP_COUNT:Int = 4
		
		Const SONIC_DRAW_HEIGHT:Int = 1920
		
		Const SPIN_KEY_COUNT:Int = 20
		Const SPIN_LV2_COUNT:Int = 12
		Const SPIN_LV2_COUNT_CONF:Int = 36
		
		Const STAGE_PASS_STR_SPACE:Int = 182
		Const STAGE_PASS_STR_SPACE_FONT:Int = MyAPI.zoomIn(MFGraphics.stringWidth(14, "索尼克完成行行")) + 20 ' "Sonic Completed the Level"
		
		Const SUPER_SONIC_CHANGING_CENTER_Y:Int = 25280
		Const SUPER_SONIC_STAND_POS_X:Int = 235136
		
		Const TERMINAL_COUNT:Int = 10
		
		Const WALK_COLLISION_CHECK_OFFSET_X:Int = 0
		Const WALK_COLLISION_CHECK_OFFSET_Y:Int = 0
		
		Const WHITE_BACKGROUND_ID:Int = 118
		
		Const ANI_BIG_ZERO:Int = 67
		Const ANI_SMALL_ZERO:Int = 27
		Const ANI_SMALL_ZERO_Y:Int = 37
		
		' Immutable Arrays (Constant):
		Global DEGREE_DIVIDE:Int[] = [44, 75, 105, 136, 224, 255, 285, 316, 360]
		Global EFFECT_LOOP:Bool[] = [True, True]
		Global FOOT_OFFSET_X:Int[] = [LEFT_FOOT_OFFSET_X, RIGHT_FOOT_OFFSET_X]
		
		Global NUM_ANI_ID:Int[] = [27, 37, 67, 125, 37]
		Global NUM_SPACE_ANIMATION:Int[] = [8, 8, 16, 8, 8]
		Global NUM_SPACE:Int[] = NUM_SPACE_ANIMATION
		Global NUM_SPACE_FONT:Int[] = [FONT_WIDTH_NUM, FONT_WIDTH_NUM, FONT_WIDTH_NUM, FONT_WIDTH_NUM, FONT_WIDTH_NUM]
		Global NUM_SPACE_IMAGE:Int[] = [NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH, NUM_PIC_SPACE_WIDTH]
		
		Global PAUSE_MENU_NORMAL_NOSHOP:Int[] = [12, 81, 5, 6]
		Global PAUSE_MENU_NORMAL_SHOP:Int[] = [12, 81, 52, 5, 6]
		Global PAUSE_MENU_RACE_ITEM:Int[] = [12, 82, 11, 81, 5, 6]
		Global RANDOM_RING_NUM:Int[] = [1, 5, 5, 5, 5, 10, 20, 30, 40]
		
		' Global variable(s):
		Global bariaDrawer:AnimationDrawer
		Global breatheCountImage:MFImage
		
		Global characterID:Int = CHARACTER_SONIC
		
		Global clipendw:Int
		Global cliph:Int
		Global clipspeed:Int = 5
		Global clipstartw:Int
		Global clipx:Int
		Global clipy:Int
		
		Global collisionBlockGround:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		Global collisionBlockGroundTmp:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		Global collisionBlockSky:ACBlock = CollisionMap.getInstance().getNewCollisionBlock()
		
		Global currentPauseMenuItem:Int[]
		
		Global fadeAlpha:Int = FADE_FILL_WIDTH ' 40
		Global fadeFromValue:Int
		Global fadeRGB:Int[] = New Int[1600]
		Global fadeToValue:Int
		
		Global fastRunDrawer:AnimationDrawer
		Global gBariaDrawer:AnimationDrawer
		Global getLifeDrawer:AnimationDrawer
		Global headDrawer:AnimationDrawer
		
		Global invincibleAnimation:Animation
		Global invincibleCount:Int
		Global invincibleDrawer:AnimationDrawer
		
		Global isStartStageEndFlag:Bool = False
		
		Global itemOffsetX:Int
		
		Global itemVec:Int[][] = [[0,0], [0,0], [0,0], [0,0], [0,0]]
		
		Global lifeDrawerX:Int = 0
		
		Global moonStarDrawer:AnimationDrawer
		
		Global movespeedx:Int = 96
		Global movespeedy:Int = 28
		
		Global newRecordCount:Int
		
		Global numDrawer:AnimationDrawer
		
		Global offsetx:Int
		Global offsety:Int
		
		' Magic number: Not sure where these IDs are held yet.
		Global passStageActionID:Int = 0
		
		Global PAUSE_MENU_NORMAL_ITEM:Int[]
		
		Global preFadeAlpha:Int
		Global preLifeNum:Int
		Global preScoreNum:Int
		Global preTimeCount:Int = 0
		
		Global ringRandomNum:Int
		
		Global score1:Int = 49700
		Global score2:Int = 12700
		
		Global shieldType:Int
		
		Global stageEndFrameCnt:Int
		Global stagePassResultOutOffsetX:Int
		
		Global totalPlusscore:Int
		
		Global uiDrawer:AnimationDrawer
		Global uiRingImage:MFImage
		Global uiSonicHeadImage:MFImage
		
		Global waterSprayDrawer:AnimationDrawer
	Protected
		' Constant variable(s):
		Const EFFECT_NONE:Int = -1
		Const EFFECT_SAND_1:Int = 0
		Const EFFECT_SAND_2:Int = 1
		
		Const FOCUS_MOVING_DOWN:Int = 2
		Const FOCUS_MOVING_UP:Int = 1
		
		Const PLAYER_ANIMATION_PATH:String = "/animation/player"
		
		Const ROTATE_MODE_NEVER_MIND:Int = 0
		Const ROTATE_MODE_POSITIVE:Int = 1
		Const ROTATE_MODE_NEGATIVE:Int = 2
		
		' Immutable Arrays (Constant):
		Global TRANS:Int[] = [0, 5, 3, 6]
		
		' Global variable(s):
		Global ringNum:Int
		Global ringTmpNum:Int
		Global speedCount:Int
		Global terminalState:Byte
		Global terminalType:Int
		Global timeStopped:Bool = False
	Public
		' Constant variable(s):
		Const WIDTH:Int = 1024
		Const HEIGHT:Int = 1536
		
		Const BODY_OFFSET:Int = 768
		
		Const STATE_PIPE_IN:= 0
		Const STATE_PIPE_OVER:= 2
		Const STATE_PIPING:= 1
		
		Const TER_STATE_RUN:= 0
		Const TER_STATE_BRAKE:= 1
		Const TER_STATE_LOOK_MOON:= 2
		Const TER_STATE_LOOK_MOON_WAIT:= 3
		Const TER_STATE_CHANGE_1:= 4
		Const TER_STATE_CHANGE_2:= 5
		Const TER_STATE_GO_AWAY:= 6
		Const TER_STATE_SHINING_2:= 7
		
		Const ANI_ATTACK_1:Int = 18
		Const ANI_ATTACK_2:Int = 19
		Const ANI_ATTACK_3:Int = 20
		Const ANI_BANK_1:Int = 32
		Const ANI_BANK_2:Int = 33
		Const ANI_BANK_3:Int = 34
		Const ANI_BAR_ROLL_1:Int = 22
		Const ANI_BAR_ROLL_2:Int = 23
		Const ANI_BRAKE:Int = 17
		Const ANI_BREATHE:Int = 49
		Const ANI_CAUGHT:Int = 52
		Const ANI_CELEBRATE_1:Int = 35
		Const ANI_CELEBRATE_2:Int = 36
		Const ANI_CELEBRATE_3:Int = 37
		Const ANI_CLIFF_1:Int = 47
		Const ANI_CLIFF_2:Int = 48
		Const ANI_DEAD:Int = 41
		Const ANI_DEAD_PRE:Int = 45
		Const ANI_FALLING:Int = 10
		Const ANI_HURT:Int = 12
		Const ANI_HURT_PRE:Int = 44
		Const ANI_JUMP:Int = 4
		Const ANI_JUMP_ROLL:Int = 15
		Const ANI_JUMP_RUSH:Int = 16
		Const ANI_LOOK_UP_1:Int = 38
		Const ANI_LOOK_UP_2:Int = 39
		Const ANI_LOOK_UP_OVER:Int = 40
		Const ANI_NONE:Int = -1
		Const ANI_POAL_PULL:Int = 13
		Const ANI_POAL_PULL_2:Int = 31
		Const ANI_POP_JUMP_DOWN_SLOW:Int = 43
		Const ANI_POP_JUMP_UP:Int = 14
		Const ANI_POP_JUMP_UP_SLOW:Int = 42
		Const ANI_PULL:Int = 24
		Const ANI_PULL_BAR_MOVE:Int = 28
		Const ANI_PULL_BAR_STAY:Int = 27
		Const ANI_PUSH_WALL:Int = 8
		Const ANI_RAIL_ROLL:Int = 21
		Const ANI_ROPE_ROLL_1:Int = 25
		Const ANI_ROPE_ROLL_2:Int = 26
		Const ANI_ROTATE_JUMP:Int = 9
		Const ANI_RUN_1:Int = 1
		Const ANI_RUN_2:Int = 2
		Const ANI_RUN_3:Int = 3
		Const ANI_SLIP:Int = 11
		Const ANI_SPIN_LV1:Int = 6
		Const ANI_SPIN_LV2:Int = 7
		Const ANI_SQUAT:Int = 5
		Const ANI_SQUAT_PROCESS:Int = 46
		Const ANI_STAND:Int = 0
		Const ANI_VS_FAKE_KNUCKLE:Int = 53
		Const ANI_WAITING_1:Int = 50
		Const ANI_WAITING_2:Int = 51
		Const ANI_WIND_JUMP:Int = 29
		Const ANI_YELL:Int = 30
		
		Global ATTACK_POP_POWER:Int = (774 + GRAVITY) ' Const
		
		Const BALL_HEIGHT_OFFSET:Int = 1024
		Const BANKING_MIN_SPEED:Int = 500
		
		Const BIG_NUM:Int = 2
		
		Const CAN_BE_SQUEEZE:Bool = True
		
		Const DETECT_HEIGHT:Int = 2048
		
		Const FALL_IN_SAND_SLIP_NONE:Int = 0
		Const FALL_IN_SAND_SLIP_RIGHT:Int = 1
		Const FALL_IN_SAND_SLIP_LEFT:Int = 2
		
		Const HUGE_POWER_SPEED:Int = 1900
		Const HURT_COUNT:Int = 48
		
		Const IN_BLOCK_CHECK:Bool = False
		
		Const ITEM_INVINCIBLE:Int = 3
		Const ITEM_LIFE:Int = 0
		Const ITEM_RING_10:Int = 7
		Const ITEM_RING_5:Int = 6
		Const ITEM_RING_RANDOM:Int = 5
		Const ITEM_SHIELD:Int = 1
		Const ITEM_SHIELD_2:Int = 2
		Const ITEM_SPEED:Int = 4
		
		Const LIFE_NUM_RESET:Int = 2
		Const MIN_ATTACK_JUMP:Int = -900
		Const NEED_RESET_DEDREE:Bool = False
		
		Const NumberSideX:Int = 81
		
		Const NUM_CENTER:Int = 0
		Const NUM_DISTANCE_BIG:Int = 72
		Const NUM_LEFT:Int = 1
		Const NUM_RIGHT:Int = 2
		
		Const PAUSE_FRAME_HEIGHT:Int =  (MENU_SPACE * 5) + 20
		
		Global PAUSE_FRAME_OFFSET_X:Int = ((-PAUSE_FRAME_WIDTH) / 2) ' Const
		
		Const PAUSE_FRAME_OFFSET_Y:Int = ((-PAUSE_FRAME_HEIGHT) / 2)
		
		Const RED_NUM:Int = 3
		Const SHOOT_POWER:Int = -1800
		
		Const SMALL_NUM:Int = 0
		Const SMALL_NUM_Y:Int = 1
		
		Const SONIC_ATTACK_LEVEL_1_V0:Int = 488
		Const SONIC_ATTACK_LEVEL_2_V0:Int = 672
		Const SONIC_ATTACK_LEVEL_3_V0:Int = 1200
		
		Const TERMINAL_RUN_TO_RIGHT:Int = 0
		Const TERMINAL_NO_MOVE:Int = 1
		Const TERMINAL_RUN_TO_RIGHT_2:Int = 2
		Const TERMINAL_SUPER_SONIC:Int = 3
		
		Const YELLOW_NUM:Int = 4
		
		Const COLLISION_STATE_NUM:= 4
		
		Const COLLISION_STATE_WALK:= 0
		Const COLLISION_STATE_JUMP:= 1
		Const COLLISION_STATE_ON_OBJECT:= 2
		Const COLLISION_STATE_IN_SAND:= 3
		Const COLLISION_STATE_NONE:= 4 ' COLLISION_STATE_NUM
		
		' Immutable Arrays (Constant):
		Global CHARACTER_LIST:Int[] = [CHARACTER_SONIC, CHARACTER_TAILS, CHARACTER_KNUCKLES, CHARACTER_AMY]
		
		' Global variable(s):
		Global BANK_BRAKE_SPEED_LIMIT:Int = 1100
		
		Global currentMarkId:Int
		Global cursor:Int
		Global cursorIndex:Int
		Global cursorMax:Int = 5
		Global FAKE_GRAVITY_ON_BALL:Int = 224
		Global FAKE_GRAVITY_ON_WALK:Int = 72 ' NUM_DISTANCE_BIG
		Global HURT_POWER_X:Int = 384
		Global HURT_POWER_Y:Int = -992
		Global isbarOut:Bool = False
		Global isDeadLineEffect:Bool = False
		Global IsDisplayRaceModeNewRecord:Bool = False
		Global isNeedPlayWaterSE:Bool = False
		Global isOnlyBarOut:Bool = False
		Global IsStarttoCnt:Bool = False
		Global isTerminal:Bool = False
		
		Global JUMP_INWATER_START_VELOCITY:Int = (-1304 - GRAVITY)
		Global JUMP_PROTECT:Int = (-GRAVITY - GRAVITY) ' ((-GRAVITY) * 2)
		Global JUMP_REVERSE_POWER:Int = 32
		Global JUMP_RUSH_SPEED_PLUS:Int = 480
		Global JUMP_START_VELOCITY:Int = (-1208 - GRAVITY)
		
		Global lastTimeCount:Int
		Global lifeNum:Int = 2 ' 3 (Zero counts)
		
		Global MAX_VELOCITY:Int = 1280
		
		Global MOVE_POWER:Int = 28
		Global MOVE_POWER_IN_AIR:Int = 92
		Global MOVE_POWER_REVERSE:Int = 336
		Global MOVE_POWER_REVERSE_BALL:Int = 96
		
		Global numImage:MFImage
		Global onlyBarOutCnt:Int = 0
		Global onlyBarOutCntMax:Int = BACKGROUND_WIDTH ' 80
		Global overTime:Int
		Global PAUSE_FRAME_WIDTH:Int = (FONT_WIDTH * 7) + 4
		Global raceScoreNum:Int
		Global RingBonus:Int = 0
		Global RUN_BRAKE_SPEED_LIMIT:Int = 480
		Global scoreNum:Int
		Global slidingFrame:Int
		
		Global SPEED_FLOAT_DEVICE:Int = 40
		Global SPEED_LIMIT_LEVEL_1:Int = 500
		Global SPEED_LIMIT_LEVEL_2:Int = 1120
		
		Global SPIN_INWATER_START_SPEED_1:Int = 2160
		Global SPIN_INWATER_START_SPEED_2:Int = 3600
		Global SPIN_START_SPEED_1:Int = 1440
		Global SPIN_START_SPEED_2:Int = 2400
		
		Global TimeBonus:Int = 0
		Global timeCount:Int
		Global uiOffsetX:Int = 0
	Private
		' Fields:
		Field footOffsetX:Int
		
		Field effectDrawer:AnimationDrawer
		Field waterFallDrawer:AnimationDrawer
		Field waterFlushDrawer:AnimationDrawer
		
		Field checkedObject:Bool
		Field ducting:Bool
		Field enteringSP:Bool
		Field freeMoveDebug:Bool
		Field isTouchSandSlip:Bool
		Field noKeyFlag:Bool
		Field onGround:Bool
		Field onObjectContinue:Bool
		Field orgGravity:Bool
		Field pushOnce:Bool
		Field railFlipping:Bool
		Field sandStanding:Bool
		Field setNoMoving:Bool
		Field slipFlag:Bool
		Field squeezeFlag:Bool
		Field transing:Bool
		Field visible:Bool
		Field waterFalling:Bool
		Field waterSprayFlag:Bool
		Field xFirst:Bool
		
		Field aaaAttackRect:CollisionRect
		Field jumpAttackRect:CollisionRect
		
		Field attackAnimationID:Int
		Field attackCount:Int
		Field attackLevel:Int
		Field breatheNumCount:Int
		Field breatheNumY:Int
		Field collisionLayer:Int
		Field deadPosX:Int
		Field deadPosY:Int
		Field drownCnt:Int
		Field ductingCount:Int
		Field focusOffsetY:Int
		Field frame:Int
		Field frameCnt:Int
		Field justLeaveCount:Int
		Field justLeaveDegree:Int
		Field lookCount:Int
		Field moonStarFrame1:Int
		Field moonStarFrame2:Int
		Field movePower:Int
		Field movePowerInAir:Int
		Field movePowerReserseBall:Int
		Field movePowerReserseBallInSand:Int
		Field movePowerReverse:Int
		Field movePowerReverseInSand:Int
		Field nextVelX:Int
		Field nextVelY:Int
		Field noMovingPosition:Int
		Field pipeDesX:Int
		Field pipeDesY:Int
		Field preBreatheNumCount:Int
		Field preFocusX:Int
		Field preFocusY:Int
		Field preposY:Int
		Field sandFrame:Int
		Field sBlockX:Int
		Field sBlockY:Int
		Field smallJumpCount:Int
		Field spinCount:Int
		Field spinDownWaitCount:Int
		Field spinKeyCount:Int
		Field sXPosition:Int
		Field sYPosition:Int
		Field waitingCount:Int
		Field waitingLevel:Int
		Field waterSprayX:Int
		Field count:Long
	Protected
		' Fields:
		Field worldCal:ACWorldCollisionCalculator
		
		Field dustEffectAnimation:Animation
		
		Field drawer:AnimationDrawer
		
		Field railLine:Line
		
		Field dashRolling:Bool
		Field doJumpForwardly:Bool
		Field fading:Bool
		Field isInWater:Bool
		
		Field pipeState:Byte
		
		Field animationID:Int
		Field breatheCount:Int
		Field breatheFrame:Int
		Field checkPositionX:Int
		Field checkPositionY:Int
		Field degreeForDraw:Int
		Field degreeRotateMode:Int
		Field effectID:Int
		Field faceDegree:Int
		Field focusMovingState:Int
		Field maxVelocity:Int
		Field myAnimationID:Int
	Public
		' Fields:
		Field bankwalking:Bool
		Field beAttackByHari:Bool
		Field canAttackByHari:Bool
		Field changeRectHeight:Bool
		Field collisionChkBreak:Bool
		Field controlObjectLogic:Bool
		Field extraAttackFlag:Bool
		Field faceDirection:Bool
		Field finishDeadStuff:Bool
		Field footObjectLogic:Bool
		Field hurtNoControl:Bool
		Field ignoreFirstTouch:Bool
		Field isAfterSpinDash:Bool
		Field isAntiGravity:Bool
		Field isAttackBoss4:Bool
		Field isAttacking:Bool
		Field isCelebrate:Bool
		Field isCrashFallingSand:Bool
		Field isCrashPipe:Bool
		Field isDead:Bool
		Field isDirectioninSkyChange:Bool
		Field isInGravityCircle:Bool
		Field isInSnow:Bool
		Field isOnBlock:Bool
		Field isOnlyJump:Bool
		Field isPowerShoot:Bool
		Field isResetWaitAni:Bool
		Field isSharked:Bool
		Field IsStandOnItems:Bool
		Field isStopByObject:Bool
		Field isUpPipeIn:Bool
		Field justLeaveLand:Bool
		Field leavingBar:Bool
		Field leftStopped:Bool
		Field noMoving:Bool
		Field noVelMinus:Bool
		Field onBank:Bool
		Field outOfControl:Bool
		Field piping:Bool
		Field prefaceDirection:Bool
		Field railing:Bool
		Field railIsOut:Bool
		Field rightStopped:Bool
		Field showWaterFlush:Bool
		Field slideSoundStart:Bool
		Field slipping:Bool
		Field speedLock:Bool
		
		Field collisionState:Byte
		
		Field attractRect:CollisionRect
		
		Field attackRectVec:Stack<PlayerAnimationCollisionRect>
		
		Field footOnObject:GameObject
		Field outOfControlObject:GameObject
		
		Field bePushedFootX:Int
		Field degreeStable:Int
		Field fallinSandSlipState:Int
		Field fallTime:Int
		Field footPointX:Int
		Field footPointY:Int
		Field hurtCount:Int
		Field isSidePushed:Int
		Field movedSpeedX:Int
		Field movedSpeedY:Int
		Field moveLimit:Int
		Field terminalCount:Int
		Field terminalOffset:Int
	Public
		' Methods (Abstract):
		Method closeImpl:Void() Abstract
		
		' Functions:
		Function setNewParam:Void(newParam:Int[])
			MOVE_POWER = newParam[0]
			MOVE_POWER_IN_AIR = (MOVE_POWER * 2)
			MOVE_POWER_REVERSE = newParam[1]
			MAX_VELOCITY = newParam[2]
			MOVE_POWER_REVERSE_BALL = newParam[3]
			SPIN_START_SPEED_1 = newParam[4]
			SPIN_START_SPEED_2 = newParam[5]
			JUMP_START_VELOCITY = newParam[6]
			HURT_POWER_X = newParam[7]
			HURT_POWER_Y = newParam[8]
			JUMP_RUSH_SPEED_PLUS = newParam[9]
			JUMP_REVERSE_POWER = newParam[10]
			FAKE_GRAVITY_ON_WALK = newParam[11]
			FAKE_GRAVITY_ON_BALL = newParam[12]
		End
		
		Function characterSelectLogic:Bool()
			If (Key.press(Key.gSelect)) Then
				Return True
			EndIf
			
			If (Key.press(Key.gLeft)) Then
				characterID -= 1
				characterID Mod= CHARACTER_LIST.Length
			ElseIf (Key.press(Key.gRight)) Then
				characterID += 1
				characterID Mod= CHARACTER_LIST.Length
			EndIf
			
			Return False
		End
	
		Function setCharacter:Void(ID:Int)
			characterID = ID
		End
	
		Function getCharacterID:Int()
			Return characterID
		End
	
		Function getPlayer:PlayerObject()
			Local re:PlayerObject = Null
			
			Select (characterID)
				Case CHARACTER_SONIC
					' Magic number: 8 (Zone ID)
					' Presumably, this is a check for the Super Sonic fight:
					If (StageManager.getCurrentZoneId() <> 8) Then
						re = New PlayerSonic()
					Else
						re = New PlayerSuperSonic()
					EndIf
				Case CHARACTER_TAILS
					re = New PlayerTails()
				Case CHARACTER_KNUCKLES
					re = New PlayerKnuckles()
				Case CHARACTER_AMY
					re = New PlayerAmy()
				Default
					re = New PlayerSonic()
			End Select
			
			terminalState = TER_STATE_RUN
			terminalType = TERMINAL_RUN_TO_RIGHT ' 0
			
			Return re
		End
		
		' Methods (Implemented):
		Method setMeetingBoss:Void(state:Bool)
			Self.setNoMoving = state
			Self.noMovingPosition = Self.footPointX
			Self.worldCal.stopMoveX()
			Self.collisionChkBreak = True
		End
	
		Method changeRectUpCheck:Bool()
			Local tileHeight:= worldInstance.getTileHeight()
			
			For Local i:= (DETECT_HEIGHT / tileHeight) To 0 Step -1
				If (Self.worldInstance.getWorldY(Self.collisionRect.x0 + RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.collisionRect.y0 - (tileHeight * i), Self.currentLayer, 0) <> ACParam.NO_COLLISION) Then
					Return True
				EndIf
			Next
			
			Return False
		End
	
		Method changeRectDownCheck:Bool()
			Local tileHeight:= worldInstance.getTileHeight()
			
			For Local i:= (DETECT_HEIGHT / tileHeight) To 0 Step -1
				If (Self.worldInstance.getWorldY(Self.collisionRect.x0 + RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.collisionRect.y0 + (tileHeight * i), Self.currentLayer, 2) <> ACParam.NO_COLLISION) Then
					Return True
				EndIf
			Next
			
			Return False
		End
	
		Method needChangeRect:Bool()
			' Kind of bad that we're checking the animation and collision state, but whatever.
			Return ((Self.animationID = ANI_JUMP) And Self.collisionState = COLLISION_STATE_JUMP And ((Not Self.isAntiGravity And changeRectUpCheck()) Or (Self.isAntiGravity And changeRectDownCheck())))
		End
	
		Method getObjHeight:Int()
			If (needChangeRect()) Then
				Return Self.collisionRect.getHeight()
			EndIf
			
			Return HEIGHT
		End
		
		' Constructor(s):
		Method New()
			Self.degreeStable = 0
			Self.faceDegree = 0
			Self.faceDirection = True
			Self.prefaceDirection = True
			Self.extraAttackFlag = False
			Self.footPointX = 0
			Self.onGround = False
			Self.spinCount = 0
			
			Self.movePower = MOVE_POWER
			Self.movePowerInAir = MOVE_POWER_IN_AIR
			Self.movePowerReverse = MOVE_POWER_REVERSE
			Self.movePowerReserseBall = MOVE_POWER_REVERSE_BALL
			Self.movePowerReverseInSand = (MOVE_POWER_REVERSE * 2)
			Self.movePowerReserseBallInSand = (MOVE_POWER_REVERSE * 2)
			
			Self.maxVelocity = MAX_VELOCITY
			
			Self.effectID = EFFECT_NONE
			Self.collisionLayer = 0
			Self.dashRolling = False
			Self.hurtCount = 0
			Self.hurtNoControl = False
			Self.visible = True
			Self.outOfControl = False
			Self.controlObjectLogic = False
			Self.leavingBar = False
			Self.footObjectLogic = False
			Self.outOfControlObject = Null
			
			Self.attackRectVec = New Stack<PlayerAnimationCollisionRect>()
			
			Self.jumpAttackRect = New CollisionRect()
			Self.attractRect = New CollisionRect()
			Self.aaaAttackRect = New CollisionRect()
			
			Self.fallinSandSlipState = 0
			Self.isAttacking = False
			Self.canAttackByHari = False
			Self.beAttackByHari = False
			Self.setNoMoving = False
			Self.leftStopped = False
			Self.rightStopped = False
			Self.focusMovingState = 0
			Self.lookCount = LOOK_COUNT
			Self.footOffsetX = 0
			Self.justLeaveLand = False
			Self.justLeaveCount = 2
			Self.IsStandOnItems = False
			Self.degreeRotateMode = 0
			Self.slipping = False
			Self.doJumpForwardly = False
			
			Self.preCollisionRect = New CollisionRect()
			
			Self.ignoreFirstTouch = False
			Self.waterFallDrawer = Null
			Self.waterFlushDrawer = Null
			Self.railFlipping = False
			Self.isPowerShoot = False
			Self.isDead = False
			Self.isSharked = False
			Self.finishDeadStuff = False
			Self.deadPosX = 0
			Self.deadPosY = 0
			Self.noKeyFlag = False
			Self.bankwalking = False
			Self.transing = False
			Self.ducting = False
			Self.ductingCount = 0
			Self.pushOnce = False
			Self.squeezeFlag = True
			Self.orgGravity = False
			Self.footPointX = RIGHT_WALK_COLLISION_CHECK_OFFSET_X
			Self.footPointY = 0
			
			MapManager.setFocusObj(Self)
			MapManager.focusQuickLocation()
			
			Self.dustEffectAnimation = New Animation("/animation/effect_dust")
			Self.effectDrawer = Self.dustEffectAnimation.getDrawer()
			
			Self.animationID = ANI_RUN_1
			Self.collisionState = COLLISION_STATE_JUMP ' COLLISION_STATE_WALK
			Self.currentLayer = 1 ' DRAW_AFTER_SONIC
			
			If (bariaDrawer = Null) Then
				bariaDrawer = New Animation("/animation/baria").getDrawer(0, True, 0)
			EndIf
			
			If (gBariaDrawer = Null) Then
				gBariaDrawer = New Animation("/animation/g_baria").getDrawer(0, True, 0)
			EndIf
			
			If (invincibleAnimation = Null) Then
				invincibleAnimation = New Animation("/animation/muteki")
			EndIf
			
			If (invincibleDrawer = Null) Then
				invincibleDrawer = invincibleAnimation.getDrawer(0, True, 0)
			EndIf
			
			If (breatheCountImage = Null) Then
				breatheCountImage = MFImage.createImage("/animation/player/breathe_count.png")
			EndIf
			
			' Magic number: 4 (Zone ID)
			If (waterSprayDrawer = Null And StageManager.getCurrentZoneId() = 4) Then
				waterSprayDrawer = New Animation("/animation/stage6_water_spray").getDrawer()
			EndIf
			
			If (moonStarDrawer = Null And StageManager.isGoingToExtraStage()) Then
				moonStarDrawer = New Animation("/animation/moon_star").getDrawer()
			EndIf
			
			Self.width = WIDTH
			Self.height = HEIGHT
			
			Self.worldCal = New ACWorldCollisionCalculator(Self, Self)
			
			initUIResource()
		End
	Private
		' Methods:
		Method initUIResource:Void()
			' Empty implementation.
		End
	Public
		' Methods
		Method logic:Void()
			Local i:Int
			
			For Local i2:= 0 Until MAX_ITEM
				If (itemVec[i2][0] >= 0) Then
					If (itemVec[i2][1] > 0) Then
						Local iArr:= itemVec[i2]
						
						iArr[1] = iArr[1] - 1
					EndIf
					
					If (itemVec[i2][1] = 0) Then
						getItem(itemVec[i2][0])
						
						itemVec[i2][0] = -1
					EndIf
				EndIf
			Next
			
			If (Self.isAntiGravity) Then
				i = 180
			Else
				i = 0
			EndIf
			
			Self.degreeStable = i
			Self.leftStopped = False
			Self.rightStopped = False
			
			If (Self.enteringSP) Then
				If ((Self.posY Shr 6) < camera.y) Then
					GameState.enterSpStage(ringNum, currentMarkId, timeCount)
					
					Self.enteringSP = False
				EndIf
			EndIf
			
			If (Self.hurtCount > 0) Then
				Self.hurtCount -= 1
			EndIf
			
			If (invincibleCount > 0) Then
				invincibleCount -= 1
				
				If (invincibleCount = 0) Then
					i = SoundSystem.getInstance().getPlayingBGMIndex()
					
					If (i = ANI_HURT_PRE) Then
						SoundSystem.getInstance().stopBgm(False)
						
						If (Not isTerminal) Then
							SoundSystem.getInstance().playBgm(StageManager.getBgmId())
						EndIf
					EndIf
					
					i = SoundSystem.getInstance().getPlayingBGMIndex()
					
					If (i = ANI_POP_JUMP_DOWN_SLOW) Then
						SoundSystem.getInstance().playNextBgm(StageManager.getBgmId())
					EndIf
				EndIf
			EndIf
			
			Self.preFocusX = getNewPointX(Self.footPointX, 0, -BODY_OFFSET, Self.faceDegree) Shr 6
			Self.preFocusY = getNewPointY(Self.footPointY, 0, -BODY_OFFSET, Self.faceDegree) Shr 6
			
			If (Self.setNoMoving) Then
				If (Self.collisionState = COLLISION_STATE_WALK) Then
					Self.footPointX = Self.noMovingPosition
					
					setVelX(0)
					setVelY(0)
					
					Self.animationID = ANI_STAND
					
					Return
				ElseIf (Self.collisionState = COLLISION_STATE_JUMP) Then
					Self.footPointX = Self.noMovingPosition
					
					Self.velX = 0
					
					setNoKey()
				EndIf
			EndIf
			
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Self.deadPosX = Self.footPointX
				Self.deadPosY = Self.footPointY
			EndIf
			
			If (characterID = CHARACTER_TAILS) Then
				If (Not (Self.myAnimationID = ANI_HURT Or Self.myAnimationID = ANI_CLIFF_2 Or Self.myAnimationID = ANI_BREATHE)) Then
					If (soundInstance.getPlayingLoopSeIndex() = 15) Then
						soundInstance.stopLoopSe()
					EndIf
					
					resetFlyCount()
				EndIf
				
				If (Self.collisionState = COLLISION_STATE_WALK) Then
					If (soundInstance.getPlayingLoopSeIndex() = 15) Then
						soundInstance.stopLoopSe()
					EndIf
					
					resetFlyCount()
				EndIf
			EndIf
			
			If (Self.isDead) Then
				If (Self.isInWater And Self.breatheNumCount >= 6) Then
					Self.drownCnt += 1
					
					If ((Self.drownCnt Mod 2) = 0) Then
						' Add a bubble effect to represent that the player is drowning.
						GameObject.addGameObject(New DrownBubble(EnemyObject.ENEMY_DROWN_BUBBLE, Self.footPointX, Self.footPointY - HEIGHT, 0, 0, 0, 0)) ' ANI_DEAD ' 41
					EndIf
				EndIf
				
				Local deadOver:Bool = False
				
				If (Self.isAntiGravity) Then
					If (Self.footPointY < (MapManager.getCamera().y Shl 6) - f24C) Then
						Self.footPointY = (MapManager.getCamera().y Shl 6) - f24C
						
						deadOver = True
					EndIf
				ElseIf (Self.velY > 0 And Self.footPointY > ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C) Then
					Self.footPointY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C
					
					deadOver = True
				EndIf
				
				If (deadOver And Not Self.finishDeadStuff) Then
					If (stageModeState = STATE_RACE_MODE) Then
						StageManager.setStageRestart()
					ElseIf (Not (timeCount = overTime And GlobalResource.timeIsLimit())) Then
						If (lifeNum > 0) Then
							lifeNum -= 1
							StageManager.setStageRestart()
						Else
							StageManager.setStageGameover()
						EndIf
					EndIf
					
					Self.finishDeadStuff = True
				EndIf
				
				Return
			EndIf
			
			Self.focusMovingState = 0
			Self.controlObjectLogic = False
			
			If (Not Self.outOfControl) Then
				Local waterLevel:= StageManager.getWaterLevel()
				
				If (waterLevel > 0) Then
					If (characterID = CHARACTER_KNUCKLES) Then
						PlayerKnuckles(player).setPreWaterFlag(Self.isInWater)
					EndIf
					
					If (Not Self.isInWater) Then
						Self.breatheCount = 0
						Self.breatheNumCount = -1
						Self.preBreatheNumCount = -1
						
						If (getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree) - SIDE_FOOT_FROM_CENTER >= (waterLevel Shl 6)) Then
							Self.isInWater = True
							
							If (isNeedPlayWaterSE) Then
								SoundSystem.getInstance().playSe(58)
							EndIf
							
							Self.waterSprayFlag = True
							Self.waterSprayX = Self.posX
							waterSprayDrawer.restart()
						EndIf
					ElseIf (Not IsGamePause) Then
						Self.breatheCount += 63
						Self.breatheNumCount = -1
						
						If (characterID = CHARACTER_KNUCKLES And Self.collisionState = COLLISION_STATE_NONE) Then
							If (getNewPointY(Self.posY, 0, -Self.collisionRect.getHeight(), Self.faceDegree) + SIDE_FOOT_FROM_CENTER < (waterLevel Shl 6)) Then
								Self.breatheCount = 0
								
								i = SoundSystem.getInstance().getPlayingBGMIndex()
								
								If (i = ANI_RAIL_ROLL) Then
									SoundSystem.getInstance().stopBgm(False)
									
									If (IsInvincibility()) Then
										SoundSystem.getInstance().playBgm(ANI_HURT_PRE)
									ElseIf (Self.isAttackBoss4) Then
										SoundSystem.getInstance().playBgm(ANI_BAR_ROLL_1)
									Else
										SoundSystem.getInstance().playBgm(StageManager.getBgmId())
									EndIf
								EndIf
							EndIf
						EndIf
						
						If (Self.breatheCount > BREATHE_TIME_COUNT) Then
							Self.breatheNumCount = (Self.breatheCount - BREATHE_TIME_COUNT) / BREATHE_TO_DIE_PER_COUNT
							
							If (Self.breatheCount = 0) Then
								i = SoundSystem.getInstance().getPlayingBGMIndex()
								SoundSystem.getInstance()
								
								If (i <> ANI_RAIL_ROLL) Then
									If (Self.isAttackBoss4) Then
										soundInstance.playBgm(ANI_RAIL_ROLL)
									Else
										soundInstance.playBgm(ANI_RAIL_ROLL)
									EndIf
									
									If (Self.breatheNumCount < 6 And canBeHurt()) Then
										setDie(True)
										
										Return
									ElseIf (Self.breatheNumCount <> Self.preBreatheNumCount) Then
										Self.breatheNumY = ((Self.posY Shr 6) - camera.y) - ANI_YELL
									EndIf
								EndIf
							EndIf
							
							i = SoundSystem.getInstance().getPlayingBGMIndex()
							
							If (i <> ANI_RAIL_ROLL) Then
								Local startTime:= Long(((Self.breatheCount - BREATHE_TIME_COUNT) * 10000) / 10560)
								
								If (Self.isAttackBoss4) Then
									soundInstance.playBgmFromTime(startTime, ANI_RAIL_ROLL)
								Else
									soundInstance.playBgmFromTime(startTime, ANI_RAIL_ROLL)
								EndIf
							EndIf
							
							If (Self.breatheNumCount < 6) Then
								' Nothing so far.
							EndIf
							
							If (Self.breatheNumCount <> Self.preBreatheNumCount) Then
								' Magic number: 30
								Self.breatheNumY = ((Self.posY Shr 6) - camera.y) - 30
							EndIf
						EndIf
						
						Self.preBreatheNumCount = Self.breatheNumCount
						
						Local bodyCenterY:= getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
						
						If (characterID = CHARACTER_AMY) Then
							' Magic number: 128
							bodyCenterY = getNewPointY(Self.posY, 0, (((-Self.collisionRect.getHeight()) * 3) / 4) - 128, Self.faceDegree)
						EndIf
						
						If (bodyCenterY + SIDE_FOOT_FROM_CENTER <= (waterLevel Shl 6)) Then
							Self.isInWater = False
							
							If (Self.breatheNumCount >= 0 And SoundSystem.getInstance().getPlayingBGMIndex() = ANI_RAIL_ROLL) Then
								SoundSystem.getInstance().stopBgm(False)
								
								If (IsInvincibility()) Then
									SoundSystem.getInstance().playBgm(ANI_HURT_PRE)
								ElseIf (Self.isAttackBoss4) Then
									SoundSystem.getInstance().playBgm(ANI_BAR_ROLL_1)
								Else
									SoundSystem.getInstance().playBgm(StageManager.getBgmId())
								EndIf
							EndIf
							
							If (isNeedPlayWaterSE) Then
								SoundSystem.getInstance().playSe(58)
							EndIf
							
							Self.waterSprayFlag = True
							Self.waterSprayX = Self.posX
							waterSprayDrawer.restart()
						EndIf
						
						Self.breatheFrame += 1
						Self.breatheFrame Mod= ANI_WAITING_2 ' 51 ' 50
						
						If (Self.breatheFrame = MyRandom.nextInt(1, 8) * 6) Then
							Local xOff:Int
							
							If (Self.faceDirection) Then
								xOff = HURT_POWER_X
							Else
								xOff = -HURT_POWER_X
							EndIf
							
							GameObject.addGameObject(New AspirateBubble(EnemyObject.ENEMY_ASPIRATE_BUBBLE, player.getFootPositionX() + xOff, player.getFootPositionY() - HEIGHT, 0, 0, 0, 0))
						EndIf
					EndIf
				EndIf
				
				If (speedCount > 0) Then
					speedCount -= 1
					
					Self.movePower = (MOVE_POWER * 2)
					Self.movePowerInAir = (MOVE_POWER_IN_AIR * 2)
					Self.movePowerReverse = (MOVE_POWER_REVERSE * 2)
					Self.movePowerReserseBall = (MOVE_POWER_REVERSE_BALL * 2)
					Self.maxVelocity = (MAX_VELOCITY * 2)
					
					If (Not (speedCount <> 0 Or SoundSystem.getInstance().getPlayingBGMIndex() = ANI_POP_JUMP_UP_SLOW Or SoundSystem.getInstance().getPlayingBGMIndex() = ANI_DEAD Or SoundSystem.getInstance().getPlayingBGMIndex() = MOON_STAR_DES_Y_1)) Then
						SoundSystem.getInstance().setSoundSpeed(1.0)
						
						If (SoundSystem.getInstance().getPlayingBGMIndex() <> ANI_POP_JUMP_DOWN_SLOW) Then
							SoundSystem.getInstance().restartBgm()
						EndIf
					EndIf
				Else
					Self.movePower = MOVE_POWER
					Self.movePowerInAir = MOVE_POWER_IN_AIR
					Self.movePowerReverse = MOVE_POWER_REVERSE
					Self.movePowerReserseBall = MOVE_POWER_REVERSE_BALL
					Self.maxVelocity = MAX_VELOCITY
				EndIf
				
				If (Self.isAntiGravity) Then
					If (Not Self.isDead And Self.footPointY > (MapManager.getPixelHeight() Shl 6)) Then
						Self.footPointY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6)
						
						If (getVelY() < 0) Then
							setVelY(0)
						EndIf
					EndIf
				ElseIf (Not Self.isDead And Self.footPointY > (MapManager.getPixelHeight() Shl 6)) Then
					Self.footPointY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C
					
					setDie(False, -1600)
				EndIf
				
				Self.ignoreFirstTouch = False
				
				If (Self.dashRolling) Then
					dashRollingLogic()
					
					If (Self.dashRolling) Then
						collisionChk()
						
						Return
					EndIf
				ElseIf (Self.effectID = 0 Or Self.effectID = 1) Then
					Self.effectID = -1
				EndIf
				
				If (Self.railing) Then
					setNoKey()
					
					If (Self.railLine = Null) Then
						Self.velY += getGravity()
						
						checkWithObject(Self.footPointX, Self.footPointY, Self.footPointX + Self.velX, Self.footPointY + Self.velY)
					Else
						Local preFootPointX:= Self.footPointX
						Local preFootPointY:= Self.footPointY
						Local velocityChange:= Self.railLine.sin(getGravity())
						
						If (Not Self.railLine.directRatio()) Then
							velocityChange = -velocityChange
						EndIf
						
						If (velocityChange <> 0) Then
							Local direction:= Self.railLine.getOneDirection()
							
							Self.totalVelocity += velocityChange
							
							checkWithObject(Self.footPointX, Self.footPointY, Self.footPointX + direction.getValueX(Self.railLine.cos(Self.totalVelocity)), Self.footPointY + direction.getValueY(Self.railLine.sin(Self.totalVelocity)))
						Else
							Local directionScalar:Int
							
							If (Self.totalVelocity < 0) Then
								directionScalar = -1
							Else
								directionScalar = 1
							EndIf
							
							checkWithObject(Self.footPointX, Self.footPointY, Self.footPointX + (directionScalar * Self.railLine.cos(Self.totalVelocity)), Self.footPointY + directionScalar * Self.railLine.sin(Self.totalVelocity))
						EndIf
						
						If (Not (Self.railIsOut Or Self.railLine = Null)) Then
							Self.velX = Self.footPointX - preFootPointX
							Self.velY = Self.footPointY - preFootPointY
						EndIf
					EndIf
					
					If (Self.railIsOut And Self.velY = getGravity() + RAIL_OUT_SPEED_VY0) Then
						If (characterID = CHARACTER_AMY) Then
							soundInstance.playSe(ANI_ROPE_ROLL_1)
						Else
							soundInstance.playSe(ANI_SMALL_ZERO_Y)
						EndIf
					EndIf
					
					If (Self.railIsOut And Self.velY > 0) Then
						Self.railIsOut = False
						Self.railing = False
						Self.collisionState = COLLISION_STATE_JUMP
					EndIf
				ElseIf (Self.piping) Then
					Local preX:= Self.footPointX
					Local preY:= Self.footPointY
					
					pipeLogic()
					
					checkWithObject(preX, preY, Self.footPointX, Self.footPointY)
					
					Self.animationID = ANI_JUMP
				Else
					bankLogic()
					
					If (Not Self.onBank) Then
						If (isTerminal) Then
							If (Self.terminalCount > 0) Then
								Self.terminalCount -= 1
							EndIf
							
							If (Self.animationID = ANI_JUMP) Then
								Self.totalVelocity -= MOVE_POWER_REVERSE_BALL
								
								If (Self.totalVelocity < 0) Then
									Self.totalVelocity = 0
								EndIf
								
							ElseIf (Self.totalVelocity > MAX_VELOCITY) Then
								Self.totalVelocity -= MOVE_POWER_REVERSE_BALL
								
								If (Self.totalVelocity <= MAX_VELOCITY) Then
									Self.totalVelocity = MAX_VELOCITY
								EndIf
							EndIf
							
							Self.noKeyFlag = True
						EndIf
						
						If (Self.isCelebrate) Then
							If (Self.collisionState = COLLISION_STATE_WALK) Then
								setVelX(0)
							EndIf
							
							Self.noKeyFlag = True
						EndIf
						
						' Magic number: 11 (Stage ID)
						If (StageManager.getStageID() <> 11) Then
							If (Not isFirstTouchedWind And Self.animationID = ANI_WIND_JUMP) Then
								' Magic number: 68 (Sound-effect ID)
								soundInstance.playSe(68)
								
								isFirstTouchedWind = True
								Self.frameCnt = 0
							EndIf
							
							If (isFirstTouchedWind) Then
								' Magic number: 69 (Sound-effect ID):
								If (Self.animationID = ANI_WIND_JUMP) Then
									Self.frameCnt += 1
									
									If (Self.frameCnt > 4 And Not IsGamePause) Then
										soundInstance.playLoopSe(69)
									EndIf
								Else
									If (soundInstance.getPlayingLoopSeIndex() = 69) Then
										soundInstance.stopLoopSe()
									EndIf
									
									isFirstTouchedWind = False
								EndIf
							EndIf
						EndIf
						
						' Magic number: 5 (Zone ID)
						If (StageManager.getCurrentZoneId() = 5) Then
							If (Not isFirstTouchedSandSlip And Self.animationID = ANI_YELL) Then
								isFirstTouchedSandSlip = True
								
								Self.frameCnt = 0
							EndIf
							
							If (isFirstTouchedSandSlip) Then
								If (Self.animationID = ANI_YELL And Self.collisionState = COLLISION_STATE_WALK) Then
									Self.frameCnt += 1
									
									If (Self.frameCnt > 2 And Not IsGamePause) Then
										soundInstance.playLoopSe(71)
									EndIf
								Else
									If (soundInstance.getPlayingLoopSeIndex() = 71) Then
										soundInstance.stopLoopSe()
									EndIf
									
									isFirstTouchedSandSlip = False
								EndIf
							EndIf
						EndIf
						
						If (Self.ducting) Then
							Self.ductingCount += 1
							Self.noKeyFlag = True
							Self.animationID = ANI_JUMP
							Self.attackAnimationID = Self.animationID
							Self.attackCount = 0
							Self.attackLevel = 0
						EndIf
						
						If (Self.noKeyFlag) Then
							Key.setKeyFunction(False)
						EndIf
						
						If (Not (Not Self.hurtNoControl Or Self.animationID = ANI_HURT Or Self.animationID = ANI_HURT_PRE)) Then
							Self.hurtNoControl = False
						EndIf
						
						Select (Self.collisionState)
							Case COLLISION_STATE_WALK
								inputLogicWalk()
							Case COLLISION_STATE_JUMP
								inputLogicJump()
								
								If (Self.transing) Then
									Self.velX = 0
									Self.velY = 0
									
									If (MapManager.isCameraStop()) Then
										Self.transing = False
									EndIf
								EndIf
							Case COLLISION_STATE_ON_OBJECT
								inputLogicOnObject()
							Case COLLISION_STATE_IN_SAND
								inputLogicSand()
							Default
								extraInputLogic()
						End Select
						
						If (Self.noKeyFlag) Then
							Key.setKeyFunction(True)
							
							Self.noKeyFlag = False
						EndIf
						
						If (Self.slipFlag) Then
							If (Self.collisionState = COLLISION_STATE_WALK) Then
								Self.animationID = ANI_YELL
							EndIf
							
							Self.slipFlag = False
						EndIf
						
						calPreCollisionRect()
						collisionChk()
						
						If (Self.animationID = ANI_BRAKE) Then
							Effect.showEffect(Self.dustEffectAnimation, 2, (Self.posX Shr 6), (Self.posY Shr 6), 0)
						EndIf
						
						Select (Self.collisionState)
							Case COLLISION_STATE_WALK
								fallChk()
								
								Self.degreeForDraw = Self.faceDegree
								
								If (noRotateDraw()) Then
									Self.degreeForDraw = Self.degreeStable
								EndIf
								
								If (isTerminal) Then
									MapManager.setCameraDownLimit((Self.posY Shr 6) + 24)
								EndIf
								
								If (Not isTerminal Or Self.terminalCount <> 0 Or Self.totalVelocity < MAX_VELOCITY) Then
									Select (terminalType)
										Case TERMINAL_SUPER_SONIC
											terminalLogic()
										Default
											' Nothing so far.
									End Select
								Else
									Select (terminalType)
										Case TERMINAL_RUN_TO_RIGHT
											If (Self.animationID = ANI_CELEBRATE_1) Then
												If (Self.drawer.checkEnd()) Then
													Self.animationID = ANI_CELEBRATE_2
												EndIf
											EndIf
											
											If (Self.animationID <> ANI_JUMP And Self.animationID <> ANI_CELEBRATE_1 And Self.animationID <> ANI_CELEBRATE_2) Then
												Self.animationID = ANI_CELEBRATE_1
											EndIf
										Case TERMINAL_RUN_TO_RIGHT_2
											If (StageManager.getCurrentZoneId() <> 6) Then
												If (Self.fading And fadeChangeOver()) Then
													StageManager.setStagePass()
												Else
													setFadeColor(MapManager.END_COLOR)
													fadeInit(0, 255)
													
													Self.fading = True
												EndIf
											Else
												StageManager.setStagePass()
											EndIf
										Case TERMINAL_SUPER_SONIC
											terminalLogic()
									End Select
								EndIf
								
								If (Self.isCelebrate) Then
									Self.animationID = ANI_SMALL_ZERO_Y
								EndIf
							Case COLLISION_STATE_JUMP
								If (noRotateDraw()) Then
									Self.degreeForDraw = Self.degreeStable
								EndIf
								
								terminalLogic()
								
								If (isTerminal And Self.terminalCount = 0 And terminalType = TERMINAL_NO_MOVE) Then
									StageManager.setStagePass()
								Else
									Self.degreeForDraw = Self.faceDegree
								EndIf
							Case COLLISION_STATE_ON_OBJECT, COLLISION_STATE_IN_SAND
								Self.degreeForDraw = Self.faceDegree
							Case COLLISION_STATE_NONE
								terminalLogic()
						End Select
						
						If (Self.footPointX - RIGHT_WALK_COLLISION_CHECK_OFFSET_X < (MapManager.actualLeftCameraLimit Shl 6)) Then
							Self.footPointX = (MapManager.actualLeftCameraLimit Shl 6) + RIGHT_WALK_COLLISION_CHECK_OFFSET_X
							
							If (getVelX() < 0) Then
								setVelX(0)
							EndIf
						EndIf
						
						If (MapManager.actualRightCameraLimit <> MapManager.getPixelWidth()) Then
							If (Self.footPointX + RIGHT_WALK_COLLISION_CHECK_OFFSET_X > (MapManager.actualRightCameraLimit Shl 6)) Then
								Self.footPointX = (MapManager.actualRightCameraLimit Shl 6) - RIGHT_WALK_COLLISION_CHECK_OFFSET_X
								
								If (getVelX() > 0) Then
									setVelX(0)
								EndIf
							EndIf
						EndIf
						
						If (EnemyObject.isBossEnter) Then
							If ((Self.footPointY - HEIGHT) + WIDTH < (MapManager.actualUpCameraLimit Shl 6)) Then
								Self.footPointY = ((MapManager.actualUpCameraLimit Shl 6) + HEIGHT) - WIDTH
								
								If (getVelY() < 0) Then
									setVelY(0)
								EndIf
							EndIf
						Else
							If (Self.footPointY - HEIGHT < (MapManager.actualUpCameraLimit Shl 6)) Then
								Self.footPointY = (MapManager.actualUpCameraLimit Shl 6) + HEIGHT
								
								If (getVelY() < 0) Then
									setVelY(0)
								EndIf
							EndIf
						EndIf
						
						If (isDeadLineEffect And Not Self.isDead And Self.footPointY > (MapManager.actualDownCameraLimit Shl 6)) Then
							Self.footPointY = ((MapManager.getCamera().y + MapManager.CAMERA_HEIGHT) Shl 6) + f24C
							setDie(False, -1600)
						EndIf
						
						If (Self.leftStopped And Self.rightStopped) Then
							setDie(False)
						EndIf
					EndIf
				EndIf
			ElseIf (Self.outOfControlObject <> Null) Then
				Self.outOfControlObject.logic()
				Self.controlObjectLogic = True
			EndIf
		End
		
		' Extensions:
		Method slipEnd:Void()
			' Empty implementation.
		End
		
		Method updateFootPoint:Void()
			Self.footPointX += Self.velX
			Self.footPointY += Self.velY
		End
		
		Method pipeLogic:Void()
			Select (Self.pipeState)
				Case STATE_PIPE_IN
					If (Self.footPointX < Self.pipeDesX) Then
						Self.footPointX += (SPEED_LIMIT_LEVEL_1/2)
						
						If (Self.footPointX >= Self.pipeDesX) Then
							Self.footPointX = Self.pipeDesX
						EndIf
					ElseIf (Self.footPointX > Self.pipeDesX) Then
						Self.footPointX -= (SPEED_LIMIT_LEVEL_1/2)
						
						If (Self.footPointX <= Self.pipeDesX) Then
							Self.footPointX = Self.pipeDesX
						EndIf
					EndIf
					
					If (Self.footPointY < Self.pipeDesY) Then
						Self.footPointY += (SPEED_LIMIT_LEVEL_1/2)
						
						If (Self.footPointY >= Self.pipeDesY) Then
							Self.footPointY = Self.pipeDesY
						EndIf
						
					ElseIf (Self.footPointY > Self.pipeDesY) Then
						Self.footPointY -= (SPEED_LIMIT_LEVEL_1/2)
						
						If (Self.footPointY <= Self.pipeDesY) Then
							Self.footPointY = Self.pipeDesY
						EndIf
					EndIf
					
					If (Self.footPointX = Self.pipeDesX And Self.footPointY = Self.pipeDesY) Then
						Self.pipeState = STATE_PIPING
						Self.velX = Self.nextVelX
						Self.velY = Self.nextVelY
					Else
						updateFootPoint()
					EndIf
				Case STATE_PIPING
					updateFootPoint()
				Case STATE_PIPE_OVER
					updateFootPoint()
					
					If (Self.velX <> 0) Then
						If (Self.velX > 0 And Self.footPointX > Self.pipeDesX) Then
							Self.footPointX = Self.pipeDesX
						ElseIf (Self.velX < 0 And Self.footPointX < Self.pipeDesX) Then
							Self.footPointX = Self.pipeDesX
						EndIf
					EndIf
					
					If (Self.velY <> 0) Then
						If (Self.velY > 0 And Self.footPointY > Self.pipeDesY) Then
							Self.footPointY = Self.pipeDesY
						ElseIf (Self.velY < 0 And Self.footPointY < Self.pipeDesY) Then
							Self.footPointY = Self.pipeDesY
						EndIf
					EndIf
					
					If ((Self.velX = 0 Or Self.footPointX = Self.pipeDesX Or Self.nextVelX <> 0) And (Self.velY = 0 Or Self.footPointY = Self.pipeDesY Or Self.nextVelY <> 0)) Then
						Self.velX = Self.nextVelX
						Self.velY = Self.nextVelY
						Self.pipeState = STATE_PIPING
					EndIf
			End Select
		End
		
		' Extensions:
		Method terminalLogic_SS_Run:Void()
			If (Self.posX > SUPER_SONIC_STAND_POS_X) Then
				terminalState = TER_STATE_BRAKE
			EndIf
		End
		
		Method terminalLogic_SS_Brake:Void()
			If (Self.totalVelocity = 0 And Self.animationID = ANI_STAND) Then
				terminalState = TER_STATE_LOOK_MOON
				
				Self.terminalCount = TERMINAL_COUNT
			EndIf
		End
		
		Method terminalLogic_SS_Look_Moon:Void()
			If (Self.terminalCount = 0) Then
				StageManager.setOnlyScoreCal()
				StageManager.setStagePass()
				
				terminalState = TER_STATE_LOOK_MOON_WAIT
			EndIf
		End
		
		Method terminalLogic_SS_Moon_Wait:Void()
			If (Self.terminalCount = 0 And StageManager.isScoreBarOut()) Then
				terminalState = TER_STATE_CHANGE_1
				Self.collisionState = COLLISION_STATE_NONE
				
				If (Self.isInWater) Then
					Self.velY = JUMP_INWATER_START_VELOCITY
				Else
					Self.velY = JUMP_START_VELOCITY
				EndIf
				
				Self.velX = 0
				Self.worldCal.actionState = 1
				MapManager.setCameraUpLimit(MapManager.getCamera().y)
			EndIf
		End
		
		Method terminalLogic_SS_Change_1:Void()
			Self.velY += getGravity()
			
			Self.collisionState = COLLISION_STATE_NONE
			
			If (Self.posY <= SUPER_SONIC_CHANGING_CENTER_Y) Then
				Self.velY = -100
				
				terminalState = TER_STATE_CHANGE_2
				
				Self.terminalCount = 60
			EndIf
		End
		
		Method terminalLogic_SS_Change_2:Void()
			Self.collisionState = COLLISION_STATE_NONE
			
			If (Self.posY <= SUPER_SONIC_CHANGING_CENTER_Y) Then
				Self.velY += ANI_YELL
			Else
				Self.velY -= ANI_YELL
			EndIf
			
			If (Self.terminalCount = 0) Then
				Self.velY = 0
				Self.velX = 0
				
				MapManager.setCameraRightLimit(MapManager.getPixelWidth())
				MapManager.setFocusObj(Null)
				
				Self.terminalCount = ANI_YELL
				
				terminalState = TER_STATE_GO_AWAY
				
				' Magic number: 2112
				Self.posY -= 2112
				
				Self.footPointY = Self.posY
			EndIf
		End
		
		Method terminalLogic_SS_Go_Away:Void()
			Self.collisionState = COLLISION_STATE_NONE
			Self.terminalOffset += 1600
			
			If (Self.terminalCount = 0) Then
				Self.terminalCount = 100
				terminalState = TER_STATE_SHINING_2
			EndIf
		End
		
		Method terminalLogic_SS_Shining_2:Void()
			If (Self.terminalCount = 0) Then
				StageManager.setStraightlyPass()
			EndIf
		End
		
		Method terminalLogic:Void()
			If (terminalType = TERMINAL_SUPER_SONIC) Then
				Local tState:= terminalState 
				
				Select tState
					Case TER_STATE_RUN
						terminalLogic_SS_Run()
					Case TER_STATE_BRAKE
						terminalLogic_SS_Brake()
					Case TER_STATE_LOOK_MOON
						terminalLogic_SS_Look_Moon()
					Case TER_STATE_LOOK_MOON_WAIT
						terminalLogic_SS_Moon_Wait()
					Case TER_STATE_CHANGE_1
						terminalLogic_SS_Change_1()
					Case TER_STATE_CHANGE_2
						terminalLogic_SS_Change_2()
					Case TER_STATE_GO_AWAY
						terminalLogic_SS_Go_Away()
					Case TER_STATE_SHINING_2
						terminalLogic_SS_Shining_2()
				End Select
			EndIf
		End
		
		Method drawCharacter:Void(graphics:MFGraphics)
			' Empty implementation.
		End
		
		Method draw2:Void(g:MFGraphics)
			draw(g, (drawAtFront() And Self.visible))
			drawCollisionRect(g)
			
			' Magic number: 4 (Zone ID)
			If (Self.waterSprayFlag And StageManager.getCurrentZoneId() = 4 And waterSprayDrawer <> Null) Then
				waterSprayDrawer.draw(g, 0, (Self.waterSprayX Shr 6) - camera.x, StageManager.getWaterLevel() - camera.y, False, 0)
				
				If (waterSprayDrawer.checkEnd()) Then
					Self.waterSprayFlag = False
					
					waterSprayDrawer.restart()
				EndIf
			EndIf
			
			If (Not IsGamePause) Then
				If (Self.isDead) Then
					If (Self.isAntiGravity) Then
						Self.velY -= getGravity()
					Else
						Self.velY += getGravity()
					EndIf
					
					updateFootPoint()
				EndIf
				
				If (Self.isInWater And Self.breatheNumCount >= 0 And Self.breatheNumCount < 6) Then
					Local i:Int
					Local i2:= Self.breatheNumCount * 16
					Local i3:= (Self.posX Shr 6) - camera.x
					
					Local mFImage:= breatheCountImage
					
					If (Self.breatheNumY > 16) Then
						i = Self.breatheNumY
					Else
						i = 16
					EndIf
					
					MyAPI.drawRegion(g, mFImage, i2, 0, 16, 16, 0, i3, i, 33)
					Self.breatheNumY -= 1
				EndIf
			EndIf
			
			If (Self.fading) Then
				drawFadeBase(g, SPIN_LV2_COUNT)
			EndIf
			
			If (terminalType = TERMINAL_SUPER_SONIC) Then
				If (terminalState < 2 Or terminalState >= 6) Then
					Self.moonStarFrame1 = 0
				Else
					moonStarDrawer.draw(g, 0, (((MOON_STAR_DES_X_1 - MOON_STAR_ORI_X_1) * Self.moonStarFrame1) / MOON_STAR_FRAMES_1) + MOON_STAR_ORI_X_1, ((Self.moonStarFrame1 * ANI_PUSH_WALL) / MOON_STAR_FRAMES_1) + MOON_STAR_ORI_Y_1, True, 0)
					Self.moonStarFrame1 += 1
				EndIf
				
				If (terminalState = TER_STATE_SHINING_2) Then
					moonStarDrawer.draw(g, 1, (((MOON_STAR_DES_X_1 - MOON_STAR_ORI_X_1) * Self.moonStarFrame2) / MOON_STAR_FRAMES_2) + MOON_STAR_ORI_X_1, ((Self.moonStarFrame2 * ANI_PUSH_WALL) / MOON_STAR_FRAMES_2) + MOON_STAR_ORI_Y_1, True, 0)
					Self.moonStarFrame2 += 1
					
					Return
				EndIf
				
				Self.moonStarFrame2 = 0
			EndIf
		End
	
		Method drawAtFront:Bool()
			Return (Self.slipping Or Self.isDead)
		End
	
		Method collisionChk:Void()
			If (Not Self.noMoving) Then
				Select (Self.collisionState)
					Case COLLISION_STATE_WALK
						calDivideVelocity(Self.faceDegree)
				End Select
				
				Self.posZ = Self.currentLayer
				
				Self.worldCal.footDegree = Self.faceDegree
				
				Self.posX = Self.footPointX
				Self.posY = Self.footPointY
				
				If (Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
					collisionLogicOnObject()
				ElseIf (Self.isInWater) Then
					Self.worldCal.actionLogic(Self.velX / 2, Self.velY / 2, Int((Float(Self.totalVelocity) * IN_WATER_WALK_SPEED_SCALE1) / IN_WATER_WALK_SPEED_SCALE2))
				ElseIf (Self.movedSpeedX <> 0) Then
					Self.worldCal.actionLogic(Self.movedSpeedX, Self.velY)
				Else
					Self.worldCal.actionLogic(Self.velX, Self.velY, Self.totalVelocity)
				EndIf
				
				Self.footPointX = Self.posX
				Self.footPointY = Self.posY
				
				Self.faceDegree = Self.worldCal.footDegree
			EndIf
		End
	
		Method setFaceDegree:Void(degree:Int)
			Self.worldCal.footDegree = degree
			Self.faceDegree = degree
		End
		
		Method draw:Void(graphics:MFGraphics)
			draw(graphics, Not (drawAtFront() Or Not Self.visible))
		End
	
		Method draw:Void(g:MFGraphics, visible:Bool)
			If (visible) Then
				Select (Self.collisionState)
					Case COLLISION_STATE_WALK
						If (noRotateDraw()) Then
							Self.degreeForDraw = Self.degreeStable
						EndIf
				End Select
				
				If (Self.isInWater) Then
					Self.drawer.setSpeed(1, 2)
				Else
					Self.drawer.setSpeed(1, 1)
				EndIf
				
				If (Self.animationID = ANI_RUN_1) Then
					If (Self.isInSnow) Then
						Self.drawer.setSpeed(1, 2)
					Else
						Self.drawer.setSpeed(1, 1)
					EndIf
				EndIf
				
				drawCharacter(g)
				
				' Don't ask me why we're playing sound-effects in the
				' render routine, I won't have an answer for you:
				If (characterID = CHARACTER_AMY) Then
					' Magic number: 25 (Sound-effect ID):
					If (Self.animationID = ANI_JUMP And Not IsGamePause) Then
						If (Not Self.ducting) Then
							soundInstance.playLoopSe(25)
						ElseIf ((Self.ductingCount Mod 2) = 0) Then
							soundInstance.stopLoopSe()
							soundInstance.playLoopSe(25)
						EndIf
					EndIf
					
					If ((Self.animationID <> ANI_JUMP Or IsGamePause) And soundInstance.getPlayingLoopSeIndex() = 25) Then
						soundInstance.stopLoopSe()
					EndIf
				EndIf
				
				If (Self.effectID > -1) Then
					Self.effectDrawer.draw(g, Self.effectID, (Self.footPointX Shr 6) - camera.x, (Self.footPointY Shr 6) - camera.y, EFFECT_LOOP[Self.effectID], getTrans())
					
					If (Self.effectDrawer.checkEnd()) Then
						Self.effectDrawer.restart()
						Self.effectID = -1
					EndIf
				EndIf
				
				waterFallDraw(g, camera)
				waterFlushDraw(g)
				
				If (Self.drawer.checkEnd()) Then
					Select (Self.animationID)
						Case ANI_ROTATE_JUMP
							If (Self.isInGravityCircle) Then
								Self.animationID = ANI_ROTATE_JUMP
								
								Self.drawer.restart()
								
								Return
							EndIf
							
							Self.animationID = TERMINAL_COUNT
						Case ANI_JUMP_ROLL
							Self.animationID = ANI_JUMP_RUSH
						Case ANI_BAR_ROLL_1
							' Switch to the other animation on this frame.
							Self.animationID = ANI_BAR_ROLL_2
						Case ANI_BAR_ROLL_2
							' Switch to the first animation for this frame.
							Self.animationID = ANI_BAR_ROLL_1
						Case ANI_ROPE_ROLL_1
							' Switch to the other animation on this frame.
							Self.animationID = ANI_ROPE_ROLL_2
						Case ANI_ROPE_ROLL_2
							' Switch to the first animation for this frame.
							Self.animationID = ANI_ROPE_ROLL_1
						Case ANI_POAL_PULL_2
							Self.animationID = ANI_RUN_1
						Case ANI_CELEBRATE_1, ANI_SMALL_ZERO_Y
							StageManager.setStagePass()
						Case ANI_POP_JUMP_UP_SLOW
							Self.animationID = ANI_POP_JUMP_DOWN_SLOW
						Case ANI_POP_JUMP_DOWN_SLOW
							Self.animationID = TERMINAL_COUNT
						Case ANI_HURT_PRE
							Self.animationID = ANI_HURT
						Case ANI_DEAD_PRE
							Self.animationID = ANI_DEAD
						Case ANI_SQUAT_PROCESS
							If (Key.repeated(Key.gDown)) Then
								Self.animationID = ANI_SQUAT
							Else
								Self.animationID = ANI_STAND
							EndIf
						Case ANI_BREATHE
							Self.animationID = ANI_RUN_1
						Case ANI_VS_FAKE_KNUCKLE
							Self.animationID = ANI_STAND
					End Select
				EndIf
			EndIf
		End
		
		Method drawSheild1:Void(graphics:MFGraphics)
			If (Not drawAtFront()) Then
				drawSheildPrivate(graphics)
			EndIf
		End
		
		Method drawSheild2:Void(graphics:MFGraphics)
			If (drawAtFront()) Then
				drawSheildPrivate(graphics)
			EndIf
		End
	Private
		' Methods:
		Method drawSheildPrivate:Void(g:MFGraphics)
			Local offset_x:Int
			Local offset_y:Int
			Local drawDegree:= Self.faceDegree
			Local offset:= ((-(getCollisionRectHeight() + FOOT_OFFSET + (FOOT_OFFSET/2))) / 2)
			
			If (characterID = CHARACTER_KNUCKLES And Self.myAnimationID >= ANI_ATTACK_2 And Self.myAnimationID <= ANI_BAR_ROLL_1) Then
				offset = -384 ' LEFT_FOOT_OFFSET_X-(FOOT_OFFSET/2) ' (HEIGHT/4)
			ElseIf (Self.animationID = ANI_SLIP And getAnimationOffset() = 1) Then
				drawDegree = 0
				offset = -1408
			ElseIf (Self.animationID = ANI_JUMP Or Self.animationID = ANI_SQUAT Or Self.animationID = ANI_SQUAT_PROCESS Or Self.animationID = ANI_SPIN_LV1 Or Self.animationID = ANI_SPIN_LV2 Or Self.animationID = ANI_ATTACK_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = ANI_ATTACK_3) Then
				offset = -640
			ElseIf (Self.animationID = ANI_ROPE_ROLL_1 Or Self.animationID = MOON_STAR_DES_Y_1) Then
				offset = 0
			EndIf
			
			If (characterID = CHARACTER_SONIC And Self.myAnimationID = ANI_ROPE_ROLL_1) Then
				offset_x = (LEFT_FOOT_OFFSET_X/2) ' -128
				offset_y = 0
			ElseIf (characterID = CHARACTER_AMY And Self.myAnimationID = ANI_LOOK_UP_1) Then
				offset_x = (LEFT_FOOT_OFFSET_X/2) ' -128
				offset_y = (FOOT_OFFSET/2) ' 128
			ElseIf (characterID = CHARACTER_AMY And Self.myAnimationID = ANI_SMALL_ZERO_Y) Then
				offset_x = (LEFT_FOOT_OFFSET_X/2) ' -128
				offset_y = SIDE_FOOT_FROM_CENTER
			ElseIf (characterID <> CHARACTER_KNUCKLES Or Self.myAnimationID < ANI_WIND_JUMP Or Self.myAnimationID > LOOK_COUNT) Then
				offset_x = 0
				offset_y = 0
			ElseIf (player.isAntiGravity) Then
				If (Self.faceDirection) Then
					offset_x = SIDE_FOOT_FROM_CENTER
					offset_y = LEFT_FOOT_OFFSET_X
				Else
					offset_x = LEFT_FOOT_OFFSET_X
					offset_y = LEFT_FOOT_OFFSET_X
				EndIf
				
			ElseIf (Self.faceDirection) Then
				offset_x = LEFT_FOOT_OFFSET_X
				offset_y = SIDE_FOOT_FROM_CENTER
			Else
				offset_x = SIDE_FOOT_FROM_CENTER
				offset_y = SIDE_FOOT_FROM_CENTER
			EndIf
			
			Local bodyCenterX:= getNewPointX(Self.footPointX, 0, offset, drawDegree)
			Local bodyCenterY:= getNewPointY(Self.footPointY, 0, offset, drawDegree)
			
			If (invincibleCount > 0) Then
				If (invincibleDrawer <> Null) Then
					drawInMap(g, invincibleDrawer, bodyCenterX + offset_x, bodyCenterY + offset_y)
				EndIf
				
				If (systemClock Mod 2 = 0) Then
					Effect.showEffect(invincibleAnimation, 1, (bodyCenterX Shr 6) + MyRandom.nextInt(-3, 3), (bodyCenterY Shr 6) + MyRandom.nextInt(-3, 3), 0)
				EndIf
			ElseIf (shieldType <= 0) Then
				' Nothing so far.
			Else
				If (shieldType = 1) Then
					drawInMap(g, bariaDrawer, bodyCenterX + offset_x, bodyCenterY + offset_y)
				ElseIf (isAttracting()) Then
					drawInMap(g, gBariaDrawer, bodyCenterX + offset_x, bodyCenterY + offset_y)
				EndIf
			EndIf
		End
	Protected
		Method getAnimationOffset:Int()
			Return getAnimationOffset(Self.faceDegree)
		End
		
		Method getAnimationOffset:Int(degree:Int)
			For Local result:= 0 Until DEGREE_DIVIDE.Length
				If (degree < DEGREE_DIVIDE[result]) Then
					Return (result Mod 2)
				EndIf
			Next
			
			Return 0
		End
	
		Method getTransId:Int(degree:Int)
			Local result:= 0
			
			While (result < DEGREE_DIVIDE.Length)
				If (degree < DEGREE_DIVIDE[result]) Then
					result Mod= (DEGREE_DIVIDE.Length-1)
					
					Exit
				EndIf
				
				result += 1
			Wend
			
			Return (((result + 1) / 2) Mod 4)
		End
		
		Method getTrans:Int(degree:Int)
			Local re:= TRANS[getTransId(degree)]
			Local offset:= getAnimationOffset(degree)
			
			If (Self.faceDirection) Then
				Return re
			EndIf
			
			If (offset <> 0) Then
				Select (re)
					Case 0
						re = 4
					Case 3
						re = 7
					Case 5
						re = 2
					Case 6
						re = 1
					Default
						' Nothing os far.
				End Select
			EndIf
			
			Select (re)
				Case 0, 3, 5, 6
					re ~= 2
			End Select
			
			Return re
		End
		
		Method getTrans:Int()
			Return getTrans(Self.faceDegree)
		End
		
		#Rem
			Method getNewPointX:Int(oriX:Int, xOffset:Int, yOffset:Int, degree:Int)
				Return (((MyAPI.dCos(degree) * xOffset) / 100) + oriX) - ((MyAPI.dSin(degree) * yOffset) / 100)
			End
			
			Method getNewPointY:Int(oriY:Int, xOffset:Int, yOffset:Int, degree:Int)
				Return (((MyAPI.dSin(degree) * xOffset) / 100) + oriY) + ((MyAPI.dCos(degree) * yOffset) / 100)
			End
		#End
		
		Method getNewPointX:Int(x:Int, var2:Int, var3:Int, degree:Int)
			Return x + var2 * MyAPI.dCos(degree) / 100 - var3 * MyAPI.dSin(degree) / 100
		End
		
		Method getNewPointY:Int(y:Int, var2:Int, var3:Int, var4:Int)
			Return y + var2 * MyAPI.dSin(var4) / 100 + var3 * MyAPI.dCos(var4) / 100
		End
	Public
		' Methods:
		Method getFocusX:Int()
			Return getNewPointX(Self.footPointX, 0, -BODY_OFFSET, Self.faceDegree) Shr 6
		End
	
		Method getFocusY:Int()
			If (FOCUS_MAX_OFFSET > TERMINAL_COUNT) Then
				If (Self.focusMovingState = 0) Then
					Self.lookCount = LOOK_COUNT
				EndIf
				
				If (Self.lookCount = 0) Then
					Select (Self.focusMovingState)
						Case FOCUS_MOVING_UP
							If (Self.focusOffsetY < FOCUS_MAX_OFFSET) Then
								Self.focusOffsetY += FOCUS_MOVE_SPEED
								
								If (Self.focusOffsetY > FOCUS_MAX_OFFSET) Then
									Self.focusOffsetY = FOCUS_MAX_OFFSET
								EndIf
							EndIf
						Case FOCUS_MOVING_DOWN
							If (Self.focusOffsetY > (-FOCUS_MAX_OFFSET)) Then
								Self.focusOffsetY -= FOCUS_MOVE_SPEED
								
								If (Self.focusOffsetY < (-FOCUS_MAX_OFFSET)) Then
									Self.focusOffsetY = -FOCUS_MAX_OFFSET
								EndIf
							EndIf
					End Select
				EndIf
				
				Self.lookCount -= 1
				
				If (Self.focusOffsetY > 0) Then
					Self.focusOffsetY -= FOCUS_MOVE_SPEED
					
					If (Self.focusOffsetY < 0) Then
						Self.focusOffsetY = 0
					EndIf
				EndIf
				
				If (Self.focusOffsetY < 0) Then
					Self.focusOffsetY += FOCUS_MOVE_SPEED
					
					If (Self.focusOffsetY > 0) Then
						Self.focusOffsetY = 0
					EndIf
				EndIf
			EndIf
			
			Return (getNewPointY(Self.footPointY, 0, -BODY_OFFSET, Self.faceDegree) Shr 6) + (DSgn(Self.isAntiGravity) * Self.focusOffsetY)
		End
		
		Method collisionLogicOnObject:Void()
			Self.onObjectContinue = False
			Self.checkedObject = False
			Self.footObjectLogic = False
			
			Self.worldCal.actionState = 1
			
			If (Self.isInWater) Then
				Self.worldCal.actionLogic(Self.velX / 2, Self.velY)
			Else
				Self.worldCal.actionLogic(Self.velX, Self.velY)
			EndIf
			
			If (Self.worldCal.actionState = 0) Then
				Self.onObjectContinue = False
			ElseIf (Not (Self.checkedObject Or Self.footOnObject = Null Or Not Self.footOnObject.onObjectChk(Self))) Then
				Self.footOnObject.doWhileCollisionWrap(Self)
				Self.onObjectContinue = True
			EndIf
			
			If (Not Self.onObjectContinue) Then
				Self.footOnObject = Null
				
				calTotalVelocity()
				
				If (Self.collisionState = TER_STATE_LOOK_MOON) Then
					Self.collisionState = COLLISION_STATE_JUMP
					Self.worldCal.actionState = 1
				EndIf
			ElseIf (Self.collisionState = TER_STATE_LOOK_MOON And Not Self.piping) Then
				Self.velY = 0
			EndIf
		End
		
		Method calDivideVelocity:Void()
			calDivideVelocity(Self.faceDegree)
		End
		
		Method calDivideVelocity:Void(degree:Int)
			Self.velX = (Self.totalVelocity * MyAPI.dCos(degree)) / 100
			Self.velY = (Self.totalVelocity * MyAPI.dSin(degree)) / 100
		End
		
		Method calTotalVelocity:Void()
			calTotalVelocity(Self.faceDegree)
		End
		
		Method calTotalVelocity:Void(degree:Int)
			Self.totalVelocity = ((Self.velX * MyAPI.dCos(degree)) + (Self.velY * MyAPI.dSin(degree))) / 100
		End
	Private
		Method faceDirectionChk:Bool()
			If (Self.totalVelocity > 0) Then
				Return True
			EndIf
			
			If (Self.totalVelocity < 0) Then
				Return False
			EndIf
			
			If (Key.press(Key.gLeft) Or Key.repeated(Key.gLeft)) Then
				Return False
			EndIf
			
			If (Key.press(Key.gRight) Or Key.repeated(Key.gRight)) Then
				Return True
			EndIf
			
			Return True
		End
		
		Method faceSlopeChk:Void()
			'Local slopeVelocity:= (MyAPI.dSin(Self.faceDegree) * (getGravity() * DSgn(Not Self.isAntiGravity))) / 100
		End
		
		Method decelerate:Void()
			Local preTotalVelocity:= Self.totalVelocity
			Local resistance:= getRetPower()
			
			If (Self.totalVelocity > 0) Then
				Self.totalVelocity -= resistance
				
				If (Self.totalVelocity < 0) Then
					Self.totalVelocity = 0
				EndIf
			ElseIf (Self.totalVelocity < 0) Then
				Self.totalVelocity += resistance
				
				If (Self.totalVelocity > 0) Then
					Self.totalVelocity = 0
				EndIf
			EndIf
			
			If (Self.totalVelocity * preTotalVelocity <= 0 And Self.animationID = ANI_JUMP) Then
				Self.animationID = ANI_STAND
			EndIf
		End
		
		Method inputLogicWalk:Void()
			Local preTotalVelocity:Int
			
			Self.leavingBar = False
			Self.doJumpForwardly = False
			Self.degreeRotateMode = 0
			
			If (Self.slipFlag Or Self.totalVelocity <> 0) Then
				Local fakeGravity:= Int(getSlopeGravity() * DSgn(Not Self.isAntiGravity))
				
				If (Self.slipFlag) Then
					fakeGravity *= 3
				EndIf
				
				Local velChange:= ((MyAPI.dSin(Self.faceDegree) * fakeGravity) / 100)
				
				preTotalVelocity = Self.totalVelocity
				
				If (Self.slipFlag And Abs(velChange) < 100) Then
					velChange = PickValue((velChange < 0), -100, 100)
				EndIf
				
				If (Self.animationID = ANI_JUMP) Then
					If (Self.totalVelocity >= 0) Then
						If (velChange < 0) Then
							velChange Shr= 2
						EndIf
						
					ElseIf (velChange > 0) Then
						velChange Shr= 2
					EndIf
				EndIf
				
				Self.totalVelocity += velChange
				
				If ((Self.totalVelocity * preTotalVelocity) <= 0 And Self.animationID = ANI_JUMP) Then
					Self.animationID = ANI_STAND
					
					Self.faceDirection = (preTotalVelocity > 0)
				EndIf
			EndIf
			
			If (Not (Self.attackLevel <> 0 Or Key.repeated(Key.gDown) Or Self.animationID = ANI_NONE Or Self.animationID = ANI_YELL)) Then
				Local reversePower:Int
				
				If ((Not Self.isAntiGravity And Key.repeated(Key.gLeft)) Or ((Self.isAntiGravity And Key.repeated(Key.gRight)) Or doBrake())) Then
					If (Self.animationID = ANI_SQUAT) Then
						Self.animationID = ANI_STAND
					EndIf
					
					If (Not ((Self.animationID = ANI_JUMP And Self.collisionState = COLLISION_STATE_WALK) Or doBrake())) Then
						Self.faceDirection = False
					EndIf
					
					If (Self.fallTime = 0) Then
						If (Self.totalVelocity > 0 Or doBrake()) Then
							If (Self.animationID = ANI_JUMP) Then
								reversePower = Self.movePowerReserseBall
							Else
								reversePower = Self.movePowerReverse
							EndIf
							
							Self.totalVelocity -= reversePower
							
							If (Self.totalVelocity < 0) Then
								If (Self.onBank) Then
									Self.totalVelocity = 0
									Self.onBank = False
									Self.bankwalking = False
								Else
									Self.totalVelocity = (0 - reversePower) Shr 2
								EndIf
							EndIf
							
							If (Not (Abs(Self.totalVelocity) <= BANK_BRAKE_SPEED_LIMIT Or Self.animationID = ANI_JUMP Or Self.animationID = ANI_BRAKE)) Then
								' Magic number: 10 (Sound-effect ID)
								soundInstance.playSe(10)
								
								If (Self.onBank) Then
									Self.onBank = False
									Self.bankwalking = False
								EndIf
							EndIf
							
						ElseIf (Self.animationID <> ANI_JUMP) Then
							Self.totalVelocity -= Self.movePower
							
							If (Self.totalVelocity < (-Self.maxVelocity)) Then
								Self.totalVelocity += Self.movePower
								
								If (Self.totalVelocity > (-Self.maxVelocity)) Then
									Self.totalVelocity = -Self.maxVelocity
								EndIf
							EndIf
						EndIf
					EndIf
				ElseIf ((Not Self.isAntiGravity And Key.repeated(Key.gRight)) Or ((Self.isAntiGravity And Key.repeated(Key.gLeft)) Or isTerminalRunRight())) Then
					If (Self.animationID = ANI_SQUAT) Then
						Self.animationID = ANI_STAND
					EndIf
					
					If (Not (Self.animationID = ANI_JUMP And Self.collisionState = COLLISION_STATE_WALK)) Then
						Self.faceDirection = True
					EndIf
					
					If (Self.fallTime = 0) Then
						If (Self.totalVelocity < 0 Or doBrake()) Then
							If (Self.animationID = ANI_JUMP) Then
								reversePower = Self.movePowerReserseBall
							Else
								reversePower = Self.movePowerReverse
							EndIf
							
							Self.totalVelocity += reversePower
							
							If (Self.totalVelocity > -1) Then
								If (Self.onBank) Then
									Self.totalVelocity = 0
									Self.onBank = False
									Self.bankwalking = False
								Else
									Self.totalVelocity = (reversePower Shr 2)
								EndIf
							EndIf
							
							If (Not (Abs(Self.totalVelocity) <= BANK_BRAKE_SPEED_LIMIT Or Self.animationID = ANI_JUMP Or Self.animationID = ANI_BRAKE)) Then
								' Magic number: 10 (Sound-effect ID)
								soundInstance.playSe(10)
								
								If (Self.onBank) Then
									Self.onBank = False
									Self.bankwalking = False
								EndIf
							EndIf
						ElseIf (Self.animationID <> ANI_JUMP) Then
							Self.totalVelocity += Self.movePower
							
							If (Self.totalVelocity > Self.maxVelocity) Then
								Self.totalVelocity -= Self.movePower
								
								If (Self.totalVelocity < Self.maxVelocity) Then
									Self.totalVelocity = Self.maxVelocity
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			If (Self.animationID <> ANI_NONE) Then
				If (Abs(Self.totalVelocity) <= 0) Then
					If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID = ANI_LOOK_UP_OVER Or Self.animationID = ANI_SQUAT Or Self.collisionState = COLLISION_STATE_JUMP)) Then
						Self.animationID = ANI_STAND
						Self.bankwalking = False
						
						checkCliffAnimation()
					EndIf
				ElseIf (Not (Self.animationID = ANI_JUMP Or Self.animationID = ANI_CELEBRATE_1 Or Self.animationID = ANI_CELEBRATE_2 Or Self.animationID = ANI_SQUAT Or Self.animationID = ANI_POAL_PULL_2)) Then
					If (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_1) Then
						Self.animationID = ANI_RUN_1
					ElseIf (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_2) Then
						Self.animationID = ANI_RUN_2
					ElseIf (Not Self.slipping) Then
						Self.animationID = ANI_RUN_3
					EndIf
				EndIf
			EndIf
			
			waitingChk()
			
			Local slopeVelocity:= (MyAPI.dSin(Self.faceDegree) * (getGravity() * DSgn(Not Self.isAntiGravity))) / 100
			
			faceSlopeChk()
			
			If (Self.animationID <> ANI_NONE And Self.attackLevel = 0 And Self.animationID <> ANI_JUMP And Abs(Self.totalVelocity) > Abs(slopeVelocity) And Self.fallTime = 0) Then
				If (Not (Key.repeated(Key.gLeft) And Key.repeated(Key.gRight)) And ((((Not Self.isAntiGravity And Key.repeated(Key.gLeft)) Or (Self.isAntiGravity And Key.repeated(Key.gRight))) And Self.totalVelocity > RUN_BRAKE_SPEED_LIMIT) Or (((Not Self.isAntiGravity And Key.repeated(Key.gRight)) Or (Self.isAntiGravity And Key.repeated(Key.gLeft))) And Self.totalVelocity < (-RUN_BRAKE_SPEED_LIMIT)))) Then
					Self.animationID = ANI_BRAKE
					
					' Magic number: 10 (Sound-effect ID)
					soundInstance.playSe(10)
					
					Self.faceDirection = (Self.totalVelocity > 0)
				ElseIf (Self.totalVelocity <> 0 And doBrake()) Then
					Self.animationID = ANI_BRAKE
					
					' Magic number: 10 (Sound-effect ID)
					soundInstance.playSe(10)
					
					Self.faceDirection = (Self.totalVelocity > 0)
				EndIf
			EndIf
			
			If (Self.ducting And Abs(Self.totalVelocity) < (MAX_VELOCITY / 2)) Then
				If (Self.totalVelocity > 0 And Self.pushOnce) Then
					Self.totalVelocity += (MAX_VELOCITY / 2)
					Self.pushOnce = False
				EndIf
				
				If (Self.totalVelocity < 0 And Self.pushOnce) Then
					Self.totalVelocity -= (MAX_VELOCITY / 2)
					Self.pushOnce = False
				EndIf
			EndIf
			
			If (Not spinLogic()) Then
				If (canDoJump() And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
					If ((characterID <> CHARACTER_AMY Or PlayerAmy.isCanJump) And Not (characterID = CHARACTER_AMY And (getCharacterAnimationID() = ANI_ATTACK_1 Or getCharacterAnimationID() = ANI_ATTACK_2))) Then
						doJump()
					EndIf
				ElseIf (Key.repeated(Key.gUp | Key.B_LOOK)) Then
					If (Self.animationID = ANI_LOOK_UP_1 And Self.drawer.checkEnd()) Then
						Self.animationID = ANI_LOOK_UP_2
					EndIf
					
					If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or (Self.animationID <> ANI_STAND And Self.animationID <> ANI_WAITING_1 And Self.animationID <> ANI_WAITING_2))) Then
						Self.animationID = ANI_LOOK_UP_1
					EndIf
					
					If (Self.animationID = ANI_LOOK_UP_2) Then
						Self.focusMovingState = 1
					EndIf
				Else
					If (Self.animationID = ANI_LOOK_UP_OVER And Self.drawer.checkEnd()) Then
						Self.animationID = ANI_STAND
					EndIf
					
					If (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2) Then
						Self.animationID = ANI_LOOK_UP_OVER
					EndIf
				EndIf
			EndIf
			
			extraLogicWalk()
			
			Local newPointX:Int
			
			' Magic numbers: 4864, etc.
			If (((Not Self.isAntiGravity And Self.faceDegree >= 90 And Self.faceDegree <= 270) Or (Self.isAntiGravity And (Self.faceDegree <= 90 Or Self.faceDegree >= 270))) And ((Abs((FAKE_GRAVITY_ON_WALK * MyAPI.dCos(Self.faceDegree)) / 100) >= (Self.totalVelocity * Self.totalVelocity) / 4864 And Not Self.ducting) Or Self.animationID = ANI_BRAKE)) Then
				calDivideVelocity()
				
				Local bodyCenterX:= getNewPointX(Self.posX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
				Local bodyCenterY:= getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
				
				newPointX = getNewPointX(bodyCenterX, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
				
				Self.footPointX = newPointX
				Self.posX = newPointX
				
				newPointX = getNewPointY(bodyCenterY, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
				
				Self.footPointY = newPointX
				Self.posY = newPointX
				
				Self.collisionState = COLLISION_STATE_JUMP
				
				' Magic number: 1 ("Action state")
				Self.worldCal.actionState = 1
			ElseIf (Not Self.ducting) Then
				If (needRetPower() And Self.collisionState = COLLISION_STATE_WALK) Then
					preTotalVelocity = Self.totalVelocity
					
					Local resistance:= getRetPower()
					
					If (Self.totalVelocity > 0) Then
						Self.totalVelocity -= resistance
						
						If (Self.totalVelocity < 0) Then
							Self.totalVelocity = 0
						EndIf
					ElseIf (Self.totalVelocity < 0) Then
						Self.totalVelocity += resistance
						
						If (Self.totalVelocity > 0) Then
							Self.totalVelocity = 0
						EndIf
					EndIf
					
					If (Self.totalVelocity * preTotalVelocity <= 0 And Self.animationID = ANI_JUMP) Then
						Self.animationID = ANI_STAND
						
						Self.faceDirection = (preTotalVelocity > 0)
					EndIf
				EndIf
				
				'Print("")
				
				If (Self.collisionState = COLLISION_STATE_JUMP) Then
					newPointX = Self.velY
					
					Self.velY = (newPointX + (DSgn(Not Self.isAntiGravity) * getGravity()))
				EndIf
			EndIf
		End
		
		Method inputLogicOnObject:Void()
			Local i:Int
			
			Self.leavingBar = False
			Self.doJumpForwardly = False
			Self.degreeRotateMode = 0
			
			Local tmpPower:= Self.movePower
			Local tmpMaxVel:= Self.maxVelocity
			
			If (Self.animationID <> ANI_SQUAT) Then
				Local reversePower:Int
				
				If (((Key.repeated(Key.gLeft) And (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = ANI_CLIFF_2 Or Self.animationID = ANI_RUN_1 Or Self.animationID = ANI_RUN_2 Or Self.animationID = ANI_RUN_3)) Or (Self.isCelebrate And Not Self.faceDirection)) And Not isOnSlip0()) Then
					If (Self.animationID = ANI_SQUAT) Then
						Self.animationID = ANI_STAND
					EndIf
					
					Self.faceDirection = (Self.isAntiGravity)
					
					If (Self.velX > 0) Then
						If (Self.animationID = ANI_JUMP) Then
							reversePower = Self.movePowerReserseBall
						Else
							reversePower = Self.movePowerReverse
						EndIf
						
						Self.velX -= reversePower
						
						If (Self.velX < 0) Then
							Self.velX = (-reversePower) Shr 2
						Else
							Self.faceDirection = True
						EndIf
					ElseIf (Self.animationID <> ANI_JUMP) Then
						Self.velX -= tmpPower
						
						If (Self.velX < (-tmpMaxVel)) Then
							Self.velX += tmpPower
							
							If (Self.velX > (-tmpMaxVel)) Then
								Self.velX = -tmpMaxVel
							EndIf
						EndIf
					EndIf
				ElseIf ((Key.repeated(Key.gRight) And (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = ANI_CLIFF_2 Or Self.animationID = ANI_RUN_1 Or Self.animationID = ANI_RUN_2 Or Self.animationID = ANI_RUN_3)) Or (Self.isCelebrate And Self.faceDirection)) Then
					If (Self.animationID = ANI_SQUAT) Then
						Self.animationID = ANI_STAND
					EndIf
					
					Self.faceDirection = Not Self.isAntiGravity
					
					If (Self.velX < 0) Then
						If (Self.animationID = ANI_JUMP) Then
							reversePower = Self.movePowerReserseBall
						Else
							reversePower = Self.movePowerReverse
						EndIf
						
						Self.velX += reversePower
						
						If (Self.velX > -1) Then
							Self.velX = (reversePower Shr 2)
						Else
							Self.faceDirection = False
						EndIf
					ElseIf (Self.animationID <> ANI_JUMP) Then
						Self.velX += tmpPower
						
						If (Self.velX > tmpMaxVel) Then
							Self.velX -= tmpPower
							
							If (Self.velX < tmpMaxVel) Then
								Self.velX = tmpMaxVel
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
			
			If (Self.animationID <> ANI_NONE) Then
				If (Abs(Self.velX) <= 0) Then
					If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID = ANI_LOOK_UP_OVER Or Self.animationID = ANI_SQUAT)) Then
						Self.animationID = ANI_STAND
						checkCliffAnimation()
					EndIf
					
				ElseIf (Self.animationID <> ANI_JUMP) Then
					If (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
						Self.animationID = ANI_RUN_1
					ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
						Self.animationID = ANI_RUN_2
					Else
						Self.animationID = ANI_RUN_3
					EndIf
				EndIf
			EndIf
			
			extraLogicOnObject()
			
			Self.attackAnimationID = Self.animationID
			
			If (Not spinLogic()) Then
				If (canDoJump() And Not Self.dashRolling And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
					If (characterID <> CHARACTER_AMY Or PlayerAmy.isCanJump) Then
						doJump()
					EndIf
				ElseIf (Key.repeated(Key.gUp | Key.B_LOOK)) Then
					If (Self.animationID = ANI_LOOK_UP_1 And Self.drawer.checkEnd()) Then
						Self.animationID = ANI_LOOK_UP_2
					EndIf
					
					If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID <> ANI_STAND)) Then
						Self.animationID = ANI_LOOK_UP_1
					EndIf
					
					If (Self.animationID = ANI_LOOK_UP_2) Then
						Self.focusMovingState = FOCUS_MOVING_UP
					EndIf
				Else
					If (Self.animationID = ANI_LOOK_UP_OVER And Self.drawer.checkEnd()) Then
						Self.animationID = ANI_STAND
					EndIf
					
					If (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2) Then
						Self.animationID = ANI_LOOK_UP_OVER
					EndIf
				EndIf
			EndIf
			
			If (needRetPower() And Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
				Local resistance:= getRetPower()
				
				If (Self.velX > 0) Then
					Self.velX -= resistance
					
					If (Self.velX < 0) Then
						Self.velX = 0
					EndIf
				ElseIf (Self.velX < 0) Then
					Self.velX += resistance
					
					If (Self.velX > 0) Then
						Self.velX = 0
					EndIf
				EndIf
			EndIf
			
			Self.velY += (getGravity() * DSgn(Not Self.isAntiGravity))
			
			waitingChk()
		End
		
		Method inputLogicJump:Void()
			Local newPointX:Int
			Local i:Int
			
			If (Self.faceDegree <> Self.degreeStable) Then
				Local bodyCenterX:= getNewPointX(Self.posX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
				Local bodyCenterY:= getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
				
				Self.faceDegree = Self.degreeStable
				
				newPointX = getNewPointX(bodyCenterX, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
				
				Self.footPointX = newPointX
				Self.posX = newPointX
				
				newPointX = getNewPointY(bodyCenterY, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
				
				Self.footPointY = newPointX
				Self.posY = newPointX
			EndIf
			
			If (Self.degreeForDraw <> Self.faceDegree) Then
				Local degreeDiff:= (Self.faceDegree - Self.degreeForDraw)
				Local degreeDes:= Self.faceDegree
				
				' Not sure if there's constants for these:
				Select (Self.degreeRotateMode)
					Case 0
						If (Abs(degreeDiff) > 180) Then
							If (degreeDes > Self.degreeForDraw) Then
								degreeDes -= 360
							Else
								degreeDes += 360
							EndIf
						EndIf
						
						Self.degreeForDraw = MyAPI.calNextPosition(Double(Self.degreeForDraw), Double(degreeDes), 1, 3)
					Case 1
						Self.degreeForDraw += 24
					Case 2
						Self.degreeForDraw -= 24
				End Select
				
				While (Self.degreeForDraw < 0)
					Self.degreeForDraw += 360
				End
				
				Self.degreeForDraw Mod= 360
			EndIf
			
			If (Self.animationID = ANI_PUSH_WALL) Then
				doWalkPoseInAir()
			EndIf
			
			' Magic numbers: 5, 7 (Animations IDs)
			If (Not (Self.hurtNoControl Or Self.animationID = ANI_YELL Or (characterID = CHARACTER_AMY And Self.myAnimationID >= 5 And Self.myAnimationID <= 7))) Then
				If ((Key.repeated(Key.gLeft) Or (Self.isCelebrate And Not Self.faceDirection)) And Not Self.ducting) Then
					If (Self.velX > (-Self.maxVelocity)) Then
						Self.velX -= Self.movePowerInAir
						
						If (Self.velX < (-Self.maxVelocity)) Then
							Self.velX = -Self.maxVelocity
						EndIf
					EndIf
					
					If (Self.degreeRotateMode = 0) Then
						Self.faceDirection = Self.isAntiGravity
					EndIf
				ElseIf ((Key.repeated(Key.gRight) Or isTerminal Or (Self.isCelebrate And Self.faceDirection)) And Not Self.ducting) Then
					If (Self.velX < Self.maxVelocity) Then
						Self.velX += Self.movePowerInAir
						
						If (Self.velX > Self.maxVelocity) Then
							Self.velX = Self.maxVelocity
						EndIf
					EndIf
					
					If (Self.degreeRotateMode = 0) Then
						Self.faceDirection = Not Self.isAntiGravity
					EndIf
				EndIf
			EndIf
			
			If (Not Self.isOnlyJump) Then
				extraLogicJump()
			EndIf
			
			If (Self.velY >= (-BODY_OFFSET - getGravity())) Then
				Local velX2:= (Self.velX Shl 5)
				Local resistance:= ((velX2 * 3) / JUMP_REVERSE_POWER)
				
				If (velX2 > 0) Then
					velX2 -= resistance
					
					If (velX2 < 0) Then
						velX2 = 0
					EndIf
				ElseIf (velX2 < 0) Then
					velX2 -= resistance
					
					If (velX2 > 0) Then
						velX2 = 0
					EndIf
				EndIf
				
				Self.velX = (velX2 Shr 5)
			EndIf
			
			If (Self.smallJumpCount > 0) Then
				Self.smallJumpCount -= 1
				
				If (Not (Self.noVelMinus Or Key.repeated(Key.gUp | Key.B_HIGH_JUMP))) Then
					newPointX = Self.velY
					
					Self.velY = newPointX + ((DSgn(Not Self.isAntiGravity)) * (getGravity() / 2))
					newPointX = Self.velY
					
					Self.velY = newPointX + ((DSgn(Not Self.isAntiGravity)) * (getGravity() / 4))
				EndIf
			EndIf
			
			newPointX = Self.velY
			
			If (Self.isAntiGravity) Then
				i = -1
			Else
				i = 1
			EndIf
			
			Self.velY = newPointX + (i * getGravity())
			
			If (Self.animationID <> ANI_POP_JUMP_UP) Then
				Return
			EndIf
			
			' Magic numbers: 200, -200 (Velocity; Y)
			If ((Self.velY > -200 And Not Self.isAntiGravity) Or (Self.velY < 200 And Self.isAntiGravity)) Then
				Self.animationID = ANI_POP_JUMP_UP_SLOW
			EndIf
		End
	
		Method inputLogicSand:Void()
			Self.leavingBar = False
			Self.doJumpForwardly = False
			Self.degreeRotateMode = 0
			
			If (Self.velY > 0 And Not Self.sandStanding) Then
				Self.sandStanding = True
			EndIf
			
			Self.sandFrame += 1
			
			' Magic numbers: 70, 71 (Sound-effect IDs):
			If (Self.velX = 0) Then
				Self.sandFrame = 0
			ElseIf (Self.sandFrame = 1) Then
				soundInstance.playSe(70)
			ElseIf (Self.sandFrame > 2) Then
				soundInstance.playSequenceSe(71)
			EndIf
			
			If (Self.sandStanding) Then
				Local reversePower:Int
				Local tmpPower:= (Self.movePower / 2)
				Local tmpMaxVel:= (Self.maxVelocity / 2)
				
				If (Key.repeated(Key.gLeft)) Then
					Self.faceDirection = False
					
					If (Self.velX > 0) Then
						If (Self.animationID = ANI_JUMP) Then
							reversePower = Self.movePowerReserseBallInSand
						Else
							reversePower = Self.movePowerReverseInSand
						EndIf
						
						Self.velX -= reversePower
						
						If (Self.velX < 0) Then
							Self.velX = ((-reversePower) Shr 2)
						Else
							Self.faceDirection = True
						EndIf
					ElseIf (Self.animationID <> ANI_JUMP) Then
						Self.velX -= tmpPower
						
						If (Self.velX < (-tmpMaxVel)) Then
							Self.velX += tmpPower
							
							If (Self.velX > (-tmpMaxVel)) Then
								Self.velX = -tmpMaxVel
							EndIf
						EndIf
					EndIf
				ElseIf (Key.repeated(Key.gRight)) Then
					Self.faceDirection = True
					
					If (Self.velX < 0) Then
						If (Self.animationID = ANI_JUMP) Then
							reversePower = Self.movePowerReserseBallInSand
						Else
							reversePower = Self.movePowerReverseInSand
						EndIf
						
						Self.velX += reversePower
						
						If (Self.velX > -1) Then
							Self.velX = (reversePower Shr 2)
						Else
							Self.faceDirection = False
						EndIf
					ElseIf (Self.animationID <> ANI_JUMP) Then
						Self.velX += tmpPower
						
						If (Self.velX > tmpMaxVel) Then
							Self.velX -= tmpPower
							
							If (Self.velX < tmpMaxVel) Then
								Self.velX = tmpMaxVel
							EndIf
						EndIf
					EndIf
				Else
					Self.velX = 0
				EndIf
				
				' Magic number: 64 (Velocity; X)
				If (Abs(Self.velX) <= 64) Then
					If (Not (((characterID = CHARACTER_AMY) And getCharacterAnimationID() = ANI_POAL_PULL And getVelY() < 0) Or Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID = ANI_LOOK_UP_OVER)) Then
						Self.animationID = ANI_STAND
					EndIf
				ElseIf (characterID <> CHARACTER_TAILS Or PlayerTails(player).flyCount <= 0) Then ' <-- Not safe, but it works.
					If ((Not ((characterID = CHARACTER_AMY)) Or (getCharacterAnimationID() <> ANI_JUMP And (getCharacterAnimationID() <> ANI_SQUAT Or Self.drawer.getCurrentFrame() >= ANI_RUN_2))) And Not ((characterID = CHARACTER_AMY) And getCharacterAnimationID() = ANI_POAL_PULL And getVelY() < 0)) Then
						If (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
							Self.animationID = ANI_RUN_1
						ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
							Self.animationID = ANI_RUN_2
						Else
							Self.animationID = ANI_RUN_3
						EndIf
					EndIf
				ElseIf (Not (Self.myAnimationID = ANI_HURT Or Self.myAnimationID = ANI_CLIFF_2 Or Self.myAnimationID = ANI_BREATHE)) Then
					' Optimization potential; dynamic cast.
					Local tails:= PlayerTails(Self)
					
					If (tails <> Null) Then
						tails.flyCount = 0
					EndIf
				EndIf
				
				'Local amy:= PlayerAmy(Self)
				
				'If (Not (amy <> Null And getCharacterAnimationID() = ANI_POAL_PULL And getVelY() < 0)) Then
				If (Not ((characterID = CHARACTER_AMY) And getCharacterAnimationID() = ANI_POAL_PULL And getVelY() < 0)) Then
					' Magic number: 100 (Velocity; Y)
					Self.velY = 100
				EndIf
				
				If (characterID = CHARACTER_SONIC) Then
					Local sandDash:= (SPEED_LIMIT_LEVEL_1 Shr 2)
					
					If (Key.press(Key.gSelect)) Then
						' Magic number: 4 (Sound-effect ID)
						soundInstance.playSe(4)
						
						If (Self.faceDirection) Then
							If (Self.velX < 0) Then
								If (Self.animationID = ANI_JUMP) Then
									reversePower = Self.movePowerReserseBallInSand
								Else
									reversePower = Self.movePowerReverseInSand
								EndIf
								
								Self.velX += reversePower
								
								If (Self.velX > -1) Then
									Self.velX = (reversePower Shr 2)
								Else
									Self.faceDirection = False
								EndIf
							ElseIf (Self.animationID <> ANI_JUMP) Then
								Self.velX += sandDash
								
								If (Self.velX > tmpMaxVel) Then
									Self.velX -= sandDash
									
									If (Self.velX < tmpMaxVel) Then
										Self.velX = tmpMaxVel
									EndIf
								EndIf
							EndIf
						ElseIf (Self.velX > 0) Then
							If (Self.animationID = ANI_JUMP) Then
								reversePower = Self.movePowerReserseBallInSand
							Else
								reversePower = Self.movePowerReverseInSand
							EndIf
							
							Self.velX -= reversePower
							
							If (Self.velX < 0) Then
								Self.velX = ((-reversePower) Shr 2)
							Else
								Self.faceDirection = True
							EndIf
						ElseIf (Self.animationID <> ANI_JUMP) Then
							Self.velX -= sandDash
							
							If (Self.velX < (-tmpMaxVel)) Then
								Self.velX += sandDash
								
								If (Self.velX > (-tmpMaxVel)) Then
									Self.velX = -tmpMaxVel
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				
				If (Not spinLogic()) Then
					If (Not (Key.repeated(Key.gLeft) Or Key.repeated(Key.gRight) Or isTerminalRunRight() Or Self.animationID = ANI_NONE)) Then
						If (Key.repeated(Key.gDown)) Then
							' Magic number: 64
							If (Abs(Self.velX) > 64) Then
								Self.velX = 0
							ElseIf (Self.animationID <> ANI_SQUAT) Then
								Self.animationID = ANI_SQUAT_PROCESS
							EndIf
						ElseIf (Self.animationID = ANI_SQUAT) Then
							Self.animationID = ANI_SQUAT_PROCESS
						EndIf
					EndIf
					
					If (Self.animationID <> ANI_SQUAT And Key.press(Key.gUp | Key.B_HIGH_JUMP)) Then
						' Optimization potential; dynamic cast.
						Local tails:= PlayerTails(player)
						
						If (tails <> Null And tails.flyCount > 0) Then
							tails.flyCount = 0
						EndIf
						
						doJump()
						
						Self.velY -= getGravity()
						
						Self.sandStanding = False
					EndIf
				EndIf
				
				If (Not Key.repeated(Key.gLeft | Key.gRight) And Self.sandStanding) Then
					Local resistance:Int
					
					If (Self.animationID <> ANI_JUMP) Then
						resistance = tmpPower
					Else
						resistance = (tmpPower / 2)
					EndIf
					
					If (Self.velX > 0) Then
						Self.velX -= resistance
						
						If (Self.velX < 0) Then
							Self.velX = 0
						EndIf
						
					ElseIf (Self.velX < 0) Then
						Self.velX += resistance
						
						If (Self.velX > 0) Then
							Self.velX = 0
						EndIf
					EndIf
				EndIf
			Else
				inputLogicJump()
			EndIf
			
			Self.collisionState = COLLISION_STATE_JUMP
		End
		
		Method faceDegreeChk:Int()
			Return Self.faceDegree
		End
		
		Method jumpDirectionX:Int()
			Return DSgn(Not (Self.faceDegree <= 90 Or Self.faceDegree >= 270))
		End
	Public
		' Methods:
		Method slipJumpOut:Void()
			' Empty implementation.
		End
		
		Method resetFlyCount:Void()
			' Empty implementation.
		End
		
		Method doJump:Void()
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			Local jumpVel:Int
			
			If (Self.isInWater) Then
				jumpVel = JUMP_INWATER_START_VELOCITY
			Else
				jumpVel = JUMP_START_VELOCITY
			EndIf
			
			Local velY:= Self.velY + ((jumpVel * MyAPI.dCos(faceDegreeChk())) / 100)
			Self.velX += ((jumpVel * (-MyAPI.dSin(faceDegreeChk()))) / 100)
			
			If (Self.faceDegree >= 0 And Self.faceDegree <= 90) Then
				If (Self.isAntiGravity) Then
					velY = Max(velY, -JUMP_PROTECT)
				Else
					Self.velY = Min(Self.velY, JUMP_PROTECT)
				EndIf
			EndIf
			
			doJumpV(velY)
			
			If (StageManager.getWaterLevel() > 0 And characterID = CHARACTER_KNUCKLES) Then
				' Unsafe, but it works.
				Local knuckles:= PlayerKnuckles(player)
				
				knuckles.Floatchk()
			EndIf
		End
		
		Method doJump:Void(vel:Int)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			Self.velX += ((-MyAPI.dSin(faceDegreeChk())) * vel) / 100
			
			Local velY:= Self.velY + (MyAPI.dCos(faceDegreeChk()) * vel) / 100
			
			doJumpV(velY)
			
			If (Self.isAntiGravity) Then
				Self.velY = Max(Self.velY, -JUMP_PROTECT)
			Else
				Self.velY = Min(Self.velY, JUMP_PROTECT)
			EndIf
		End
		
		Method doJumpV:Void()
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			setVelX(0)
			
			doJumpV(PickValue(Self.isInWater, JUMP_INWATER_START_VELOCITY, JUMP_START_VELOCITY))
			
			slipJumpOut()
		End
		
		Method doJumpV:Void(vel:Int)
			Self.collisionState = COLLISION_STATE_JUMP
			Self.worldCal.actionState = 1
			
			setVelY(vel)
			
			Self.animationID = ANI_JUMP
			
			' Magic number: 11 (Sound-effect ID)
			soundInstance.playSe(11)
			
			' Magic number: 4
			Self.smallJumpCount = 4
			
			Self.attackAnimationID = ANI_STAND
			Self.attackCount = 0
			Self.attackLevel = 0
			
			Self.onBank = False
			Self.noVelMinus = False
			Self.doJumpForwardly = True
		End
		
		Method setFurikoOutVelX:Void(degree:Int)
			Self.velX = ((-JUMP_PROTECT) * MyAPI.dCos(degree)) / 100
		End
		
		Method getCheckPositionX:Int()
			Return (Self.collisionRect.x0 + Self.collisionRect.x1) / 2
		End
		
		Method getCheckPositionY:Int()
			Return (Self.collisionRect.y0 + Self.collisionRect.y1) / 2
		End
		
		Method getFootPositionX:Int()
			Return Self.footPointX
		End
		
		Method getFootPositionY:Int()
			Return Self.footPointY
		End
		
		Method getHeadPositionY:Int()
			Return getNewPointY(Self.footPointY, 0, -1536, Self.faceDegree)
		End
		
		Method setHeadPositionY:Void(y:Int)
			Self.footPointY = getNewPointY(y, 0, HEIGHT, Self.faceDegree)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			' Empty implementation.
		End
		
		Method setCollisionLayer:Void(layer:Int)
			If (layer >= 0 And layer <= 1) Then
				Self.currentLayer = layer
			EndIf
		End
	Private
		Method land:Void()
			calTotalVelocity()
			
			Local playingLoopSeIndex:= soundInstance.getPlayingLoopSeIndex()
			Local soundSystem:= soundInstance
			
			' Magic number: 18 (Sound-effect ID)
			If (playingLoopSeIndex = 18) Then
				soundInstance.stopLoopSe()
			EndIf
			
			If (Self.animationID <> ANI_DEAD_PRE) Then
				If (Abs(Self.totalVelocity) = 0) Then
					Self.animationID = ANI_STAND
				ElseIf (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_1) Then
					Self.animationID = ANI_RUN_1
				ElseIf (Abs(Self.totalVelocity) < SPEED_LIMIT_LEVEL_2) Then
					Self.animationID = ANI_RUN_2
				ElseIf (Not Self.slipping) Then
					Self.animationID = ANI_RUN_3
				EndIf
			EndIf
			
			If (Self.ducting) Then
				If (Self.totalVelocity > 0 And Self.totalVelocity < (MAX_VELOCITY / 2) And Self.pushOnce) Then
					Self.totalVelocity += (MAX_VELOCITY / 2)
					Self.pushOnce = False
				EndIf
				
				If (Self.totalVelocity < 0 And Self.totalVelocity > -(MAX_VELOCITY / 2) And Self.pushOnce) Then
					Self.totalVelocity -= (MAX_VELOCITY / 2)
					Self.pushOnce = False
				EndIf
			EndIf
		End
	Public
		Method collisionCheckWithGameObject:Void(footX:Int, footY:Int)
			Self.collisionChkBreak = False
			
			refreshCollisionRectWrap()
			
			If (isAttracting()) Then
				Self.attractRect.setRect(footX - (ATTRACT_EFFECT_WIDTH / 2), (footY - (ATTRACT_EFFECT_HEIGHT / 2)) - BODY_OFFSET, ATTRACT_EFFECT_WIDTH, ATTRACT_EFFECT_WIDTH)
			EndIf
			
			GameObject.collisionChkWithAllGameObject(Self)
			
			calPreCollisionRect()
		End
		
		Method getCurrentHeight:Int()
			Return getCollisionRectHeight()
		End
		
		Method calPreCollisionRect:Void()
			Local RECT_HEIGHT:= getCollisionRectHeight()
			
			Self.checkPositionX = getNewPointX(Self.footPointX, 0, (-RECT_HEIGHT) / 2, Self.faceDegree)
			Self.checkPositionY = getNewPointY(Self.footPointY, 0, (-RECT_HEIGHT) / 2, Self.faceDegree)
			
			Self.preCollisionRect.setTwoPosition(Self.checkPositionX + LEFT_WALK_COLLISION_CHECK_OFFSET_X, Self.checkPositionY - (RECT_HEIGHT / 2), Self.checkPositionX + RIGHT_WALK_COLLISION_CHECK_OFFSET_X, Self.checkPositionY + (RECT_HEIGHT / 2))
		End
		
		Method collisionCheckWithGameObject:Void()
			collisionCheckWithGameObject(Self.footPointX, Self.footPointY)
		End
		
		Method moveOnObject:Void(newX:Int, newY:Int)
			moveOnObject(newX, newY, False)
		End
		
		Method moveOnObject:Void(newX:Int, newY:Int, fountain:Bool)
			Local moveDistanceX:= (newX - Self.footPointX)
			Local moveDistanceY:= (newY - Self.footPointY)
			
			Self.posZ = Self.currentLayer
			Self.worldCal.footDegree = Self.faceDegree
			Self.posX = Self.footPointX
			Self.posY = Self.footPointY
			
			Local preVelX:= Self.velX
			Local preVelY:= Self.velY
			
			Self.worldCal.actionLogic(moveDistanceX, moveDistanceY)
			
			If (getAnimationId() <> ANI_HURT And getAnimationId() <> ANI_HURT_PRE) Then
				Self.footPointX = Self.posX
				Self.footPointY = Self.posY
				
				Self.velX = preVelX
				Self.velY = preVelY
				
				Self.faceDegree = Self.worldCal.footDegree
			EndIf
		End
		
		Method prepareForCollision:Void()
			refreshCollisionRectWrap()
		End
		
		Method setSlideAni:Void()
			' Empty implementation.
		End
	
		Method beSlide0:Void(obj:GameObject)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			Self.degreeRotateMode = 0
			
			' Magic number: 1 (Collision state)
			If (Not Self.hurtNoControl Or Self.collisionState <> COLLISION_STATE_JUMP Or ((Self.velY >= 0 Or Self.isAntiGravity) And (Self.velY <= 0 Or Not Self.isAntiGravity))) Then
				If (Self.collisionState <> TER_STATE_LOOK_MOON) Then
					calTotalVelocity()
				EndIf
				
				setSlideAni()
				
				If (Self.isAntiGravity) Then
					Self.footPointY = obj.getCollisionRect().y1
				Else
					Self.footPointY = obj.getCollisionRect().y0
				EndIf
				
				If (isFootOnObject(obj)) Then
					Self.checkedObject = True
				EndIf
				
				setVelY(0)
				
				Self.worldCal.stopMoveY()
				
				If (Not (Self.collisionState = TER_STATE_LOOK_MOON And isFootOnObject(obj))) Then
					Self.footOnObject = obj
					Self.collisionState = TER_STATE_LOOK_MOON
					Self.collisionChkBreak = True
				EndIf
			ElseIf (Self.isAntiGravity) Then
				Self.footPointY = obj.getCollisionRect().y1
			Else
				Self.footPointY = obj.getCollisionRect().y0
			EndIf
			
			Self.onObjectContinue = True
			
			Self.posX = Self.footPointX
			Self.posY = Self.footPointY
			
			setPosition(Self.posX, Self.posY)
		End
		
		' Extensions:
		Method beStop_Up:Bool(newPosition:Int, obj:GameObject)
			If (Not Self.isAntiGravity And Self.velY < 0) Then
				setVelY(0)
				
				Self.worldCal.stopMoveY()
			EndIf
			
			If (Self.isAntiGravity And Self.velY > 0) Then
				setVelY(0)
				
				Self.worldCal.stopMoveY()
			EndIf
			
			If (Self.isAntiGravity) Then
				Self.footPointY = obj.getCollisionRect().y0 - Self.collisionRect.getHeight()
			Else
				Self.footPointY = obj.getCollisionRect().y1 + Self.collisionRect.getHeight()
			EndIf
			
			If ((Self.collisionState = COLLISION_STATE_WALK Or Self.collisionState = COLLISION_STATE_ON_OBJECT) And Self.faceDegree = 0 And ItemObject(obj) = Null) Then
				setDie(False)
				
				Return False
			EndIf
			
			Return True
		End
		
		Method beStop_Down:Void(newPosition:Int, obj:GameObject, isDirectionDown:Bool, alt:Bool=False)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			Self.degreeRotateMode = 0
			
			Local prey:= Self.footPointY
			
			If (Not Self.hurtNoControl Or Self.collisionState <> COLLISION_STATE_JUMP Or ((Self.velY >= 0 Or Self.isAntiGravity) And (Self.velY <= 0 Or Not Self.isAntiGravity))) Then
				If (Not (Self.collisionState = COLLISION_STATE_ON_OBJECT Or Spring(obj) <> Null)) Then
					land()
				EndIf
				
				If (Self.isAntiGravity) Then
					Self.footPointY = obj.getCollisionRect().y1
				Else
					Self.footPointY = obj.getCollisionRect().y0
				EndIf
				
				If (isFootOnObject(obj)) Then
					Self.checkedObject = True
				EndIf
				
				If (Not alt) Then
					setVelY(0)
					
					Self.worldCal.stopMoveY()
				EndIf
				
				If (Not (Self.collisionState = COLLISION_STATE_ON_OBJECT And isFootOnObject(obj))) Then
					Self.footOnObject = obj
					Self.collisionState = TER_STATE_LOOK_MOON
					Self.collisionChkBreak = True
				EndIf
				
				If (Not alt) Then
					If (Not (Self.isSidePushed = DIRECTION_NONE And isDirectionDown)) Then
						If (Self.isSidePushed = DIRECTION_RIGHT) Then
							Self.footPointX = Self.bePushedFootX
							
							Print("~~~~RIGHT footPointX:" + Self.footPointX)
							
							If (getVelX() > 0) Then
								setVelX(0)
								
								Self.worldCal.stopMoveX()
							EndIf
						ElseIf (Self.isSidePushed = DIRECTION_LEFT) Then
							Self.footPointX = Self.bePushedFootX
							
							Print("~~~~LEFT footPointX:" + Self.footPointX)
							
							If (getVelX() < 0) Then
								setVelX(0)
								
								Self.worldCal.stopMoveX()
							EndIf
						EndIf
					EndIf
				EndIf
			ElseIf (Self.isAntiGravity) Then
				Self.footPointY = obj.getCollisionRect().y1
			Else
				Self.footPointY = obj.getCollisionRect().y0
			EndIf
			
			If (Not alt) Then
				Self.movedSpeedY = Self.footPointY - prey
			EndIf
			
			Self.onObjectContinue = True
		End
		
		Method beStop_Left_Right:Void(newPosition:Int, direction:Int, obj:GameObject, isDirectionDown:Bool, alt:Bool=False)
			Local prex:Int
			
			Local isSomethingElse:Bool = False
			
			If (direction = DIRECTION_RIGHT) Then
				prex = Self.footPointX
				
				Self.footPointX = (obj.getCollisionRect().x0 - (Self.collisionRect.getWidth() / 2)) + 1
				Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
				
				If (Not alt) Then
					Self.bePushedFootX = (Self.footPointX - RIGHT_WALK_COLLISION_CHECK_OFFSET_X)
				EndIf
				
				Self.movedSpeedX = (Self.footPointX - prex)
				
				' Optimization potential; dynamic cast.
				'If (DekaPlatform(obj) = Null) Then
				If (obj.getObjectId() <> GimmickObject.GIMMICK_BIG_FLOATING_ISLAND) Then
					Self.movedSpeedX = 0
					
					isSomethingElse = True
				EndIf
				
				If (Key.repeated(Key.gRight) And ((Self.collisionState = COLLISION_STATE_WALK Or Self.collisionState = COLLISION_STATE_ON_OBJECT Or Self.collisionState = COLLISION_STATE_IN_SAND) And Not Self.isAttacking)) Then
					Self.animationID = ANI_PUSH_WALL
				EndIf
				
				' Magic number: 3
				If (getVelX() > 0) Then ' If ((Not ((Not isSomethingElse And Hari(obj) <> Null) And obj.objId = 3 And canBeHurt())) And getVelX() > 0) Then
					setVelX(0)
					
					Self.worldCal.stopMoveX()
				EndIf
				
				Self.rightStopped = True
				
				If (alt) Then
					Self.faceDirection = Not Self.isAntiGravity
				EndIf
			Else ' If (direction = DIRECTION_LEFT) Then
				prex = Self.footPointX
				
				Self.footPointX = (obj.getCollisionRect().x1 + (Self.collisionRect.getWidth() / 2)) - 1
				Self.footPointX = getNewPointX(Self.footPointX, 0, getCurrentHeight() / 2, Self.faceDegree)
				
				If (alt) Then
					Self.bePushedFootX = Self.footPointX
				EndIf
				
				Self.movedSpeedX = (Self.footPointX - prex)
				
				' Optimization potential; dynamic cast.
				'If (DekaPlatform(obj) = Null) Then
				If (obj.getObjectId() <> GimmickObject.GIMMICK_BIG_FLOATING_ISLAND) Then
					Self.movedSpeedX = 0
					
					isSomethingElse = True
				EndIf
				
				If (Key.repeated(Key.gLeft) And ((Self.collisionState = COLLISION_STATE_WALK Or Self.collisionState = COLLISION_STATE_ON_OBJECT Or Self.collisionState = COLLISION_STATE_IN_SAND) And Not Self.isAttacking)) Then
					Self.animationID = ANI_PUSH_WALL
				EndIf
				
				' Magic number: 4
				If (getVelX() < 0) Then ' If ((Not ((Not isSomethingElse And Hari(obj) <> Null) And obj.objId = 4 And canBeHurt())) And getVelX() < 0) Then
					setVelX(0)
					
					Self.worldCal.stopMoveX()
				EndIf
				
				Self.leftStopped = True
				
				If (alt) Then
					Self.faceDirection = Self.isAntiGravity
				EndIf
			EndIf
			
			' Optimization potential; dynamic cast.
			If (Self.collisionState = COLLISION_STATE_WALK And Self.animationID = ANI_JUMP And Not isSomethingElse And Hari(obj) <> Null) Then
				Self.animationID = ANI_STAND
				
				isSomethingElse = True
			EndIf
			
			Select (Self.collisionState)
				Case COLLISION_STATE_JUMP
					Self.xFirst = False
			End Select
			
			' Optimization potential; dynamic cast.
			Self.isStopByObject = (Not isSomethingElse And (GimmickObject(obj) <> Null))
		End
		
		Method resolveDirection:Int(direction:Int)
			If (Self.isAntiGravity) Then
				If (direction = DIRECTION_DOWN) Then
					Return DIRECTION_UP
				ElseIf (direction = DIRECTION_UP) Then
					Return DIRECTION_DOWN
				EndIf
			EndIf
			
			Return direction
		End
		
		Method beStop:Void(newPosition:Int, direction:Int, obj:GameObject, isDirectionDown:Bool)
			direction = resolveDirection(direction)
			
			Select (direction)
				Case DIRECTION_UP
					beStop_Up(newPosition, obj)
				Case DIRECTION_DOWN
					beStop_Down(newPosition, obj, isDirectionDown) ' True
				Case DIRECTION_LEFT, DIRECTION_RIGHT
					beStop_Left_Right(newPosition, direction, obj, isDirectionDown)
			End Select
			
			Self.posX = Self.footPointX
			Self.posY = Self.footPointY
		End
		
		Method beStopbyDoor:Void(newPosition:Int, direction:Int, obj:GameObject)
			direction = resolveDirection(direction)
			
			Select (direction)
				Case DIRECTION_UP
					beStop_Up(newPosition, obj)
				Case DIRECTION_DOWN
					beStop_Down(newPosition, obj, True, True) ' True
				Case DIRECTION_LEFT, DIRECTION_RIGHT
					beStop_Left_Right(newPosition, direction, obj, False) ' True...?
			End Select
			
			Self.posX = Self.footPointX
			Self.posY = Self.footPointY
		End
		
		Method beStop:Void(newPosition:Int, direction:Int, obj:GameObject)
			beStop(newPosition, direction, obj, (direction = DIRECTION_DOWN))
		End
		
		Method isAttackingEnemy:Bool()
			If ((characterID = CHARACTER_AMY) And getCharacterAnimationID() = ANI_LOOK_UP_2) Then
				Return False
			EndIf
			
			If ((characterID = CHARACTER_AMY) And (getCharacterAnimationID() = ANI_ATTACK_1 Or getCharacterAnimationID() = ANI_ATTACK_2 Or getCharacterAnimationID() = ANI_ATTACK_3 Or getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1 Or getCharacterAnimationID() = ANI_SPIN_LV2)) Then
				Return True
			EndIf
			
			If ((characterID = CHARACTER_SONIC) And (getCharacterAnimationID() = ANI_POAL_PULL Or getCharacterAnimationID() = ANI_POP_JUMP_UP Or getCharacterAnimationID() = ANI_JUMP_ROLL Or getCharacterAnimationID() = ANI_JUMP)) Then
				Return True
			EndIf
			
			If ((characterID = CHARACTER_TAILS) And getCharacterAnimationID() = ANI_SLIP) Then
				Return True
			EndIf
			
			If ((characterID = CHARACTER_KNUCKLES) And (getCharacterAnimationID() = ANI_SLIP Or getCharacterAnimationID() = SPIN_LV2_COUNT Or getCharacterAnimationID() = ANI_POAL_PULL Or getCharacterAnimationID() = ANI_ATTACK_2 Or getCharacterAnimationID() = ANI_ATTACK_3 Or getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1)) Then
				Return True
			EndIf
			
			Return (Self.animationID = ANI_ATTACK_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = ANI_ATTACK_3 Or Self.animationID = ANI_JUMP Or Self.animationID = ANI_SPIN_LV1 Or Self.animationID = ANI_SPIN_LV2 Or invincibleCount > 0)
		End
		
		Method isAttackingItem:Bool(pFirstTouch:Bool)
			If (Self.ignoreFirstTouch Or pFirstTouch) Then
				Return isAttackingItem()
			EndIf
			
			Return False
		End
		
		Method isAttackingItem:Bool()
			If ((characterID = CHARACTER_AMY) And (getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1)) Then
				' Magic number: 325
				player.setVelY(player.getVelY() - 325)
				
				Return True
			ElseIf ((characterID = CHARACTER_AMY) And getCharacterAnimationID() = ANI_LOOK_UP_2) Then
				Return False
			EndIf
			
			If ((characterID = CHARACTER_AMY) And getCharacterAnimationID() = ANI_BRAKE) Then
				Return False
			EndIf
			
			Return (Self.animationID = ANI_ATTACK_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = ANI_ATTACK_3 Or Self.animationID = ANI_JUMP)
		End
		
		Method getVelX:Int()
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Return ((Self.totalVelocity * MyAPI.dCos(Self.faceDegree)) / 100)
			EndIf
			
			Return Self.velX
		End
		
		Method getVelY:Int()
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Return ((Self.totalVelocity * MyAPI.dSin(Self.faceDegree)) / 100)
			EndIf
			
			Return Self.velY
		End
		
		Method setVelX:Void(mVelX:Int)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Local tmpVelX:= ((Self.totalVelocity * MyAPI.dCos(Self.faceDegree)) / 100)
				
				tmpVelX = mVelX
				
				Self.totalVelocity = (((MyAPI.dCos(Self.faceDegree) * tmpVelX) + (MyAPI.dSin(Self.faceDegree) * ((Self.totalVelocity * MyAPI.dSin(Self.faceDegree)) / 100))) / 100)
				
				Return
			EndIf
			
			Super.setVelX(mVelX)
		End
		
		Method setVelY:Void(mVelY:Int)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Local dSin:= ((Self.totalVelocity * MyAPI.dSin(Self.faceDegree)) / 100)
				
				Self.totalVelocity = (((MyAPI.dCos(Self.faceDegree) * ((Self.totalVelocity * MyAPI.dCos(Self.faceDegree)) / 100)) + (MyAPI.dSin(Self.faceDegree) * mVelY)) / 100)
				
				Return
			EndIf
			
			Super.setVelY(mVelY)
		End
		
		Method setVelXPercent:Void(percentage:Int)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Local tmpVelX:= ((Self.totalVelocity * MyAPI.dCos(Self.faceDegree)) / 100)
				
				tmpVelX = ((Self.totalVelocity * percentage) / 100)
				
				Self.totalVelocity = (((MyAPI.dCos(Self.faceDegree) * tmpVelX) + (MyAPI.dSin(Self.faceDegree) * ((Self.totalVelocity * MyAPI.dSin(Self.faceDegree)) / 100))) / 100)
				
				Return
			EndIf
			
			Super.setVelX((Self.totalVelocity * percentage) / 100)
		End
		
		Method setVelYPercent:Void(percentage:Int)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Local tmpVelY:= ((Self.totalVelocity * MyAPI.dSin(Self.faceDegree)) / 100)
				
				Self.totalVelocity = (((MyAPI.dCos(Self.faceDegree) * ((Self.totalVelocity * MyAPI.dCos(Self.faceDegree)) / 100)) + (MyAPI.dSin(Self.faceDegree) * ((Self.totalVelocity * percentage) / 100))) / 100)
				
				Return
			EndIf
			
			Super.setVelY((Self.totalVelocity * percentage) / 100)
		End
		
		Method beSpring:Void(springPower:Int, direction:Int)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			If (Self.isInWater) Then
				' Magic number: 185
				springPower = ((springPower * 185) / 100)
			EndIf
			
			' This behavior may change in the future:
			Select (direction)
				Case DIRECTION_UP
					Self.velY = springPower
					Self.worldCal.stopMoveY()
				Case DIRECTION_DOWN
					Self.velY = -springPower
					Self.worldCal.stopMoveY()
				Case DIRECTION_LEFT
					Self.velX = springPower
					Self.worldCal.stopMoveX()
				Case DIRECTION_RIGHT
					Self.velX = -springPower
					Self.worldCal.stopMoveX()
			End Select
			
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calTotalVelocity()
			EndIf
			
			If ((Not Self.isAntiGravity And direction = DIRECTION_DOWN) Or (Self.isAntiGravity And direction = DIRECTION_UP)) Then
				Self.faceDegree = Self.degreeStable
				Self.degreeForDraw = Self.degreeStable
				
				Self.animationID = ANI_ROTATE_JUMP
				Self.collisionState = COLLISION_STATE_JUMP
				
				' Magic number: 1 (Action-state)
				Self.worldCal.actionState = 1
				
				Self.collisionChkBreak = True
				
				Self.drawer.restart()
			EndIf
			
			If (characterID = CHARACTER_TAILS) Then
				' Not safe, but it works:
				Local tails:= PlayerTails(player)
				
				tails.resetFlyCount()
			EndIf
		End
		
		' Presumably, this is for the balloons.
		Method bePop:Void(springPower:Int, direction:Int)
			beSpring(springPower, direction)
			
			If ((Not Self.isAntiGravity And direction = DIRECTION_DOWN) Or (Self.isAntiGravity And direction = DIRECTION_UP)) Then
				Self.animationID = ANI_POP_JUMP_UP
				Self.collisionState = COLLISION_STATE_JUMP
				
				' Magic number: 1 (Action-state)
				Self.worldCal.actionState = 1
			EndIf
		End
		
		Method beHurt:Void()
			Local sType:= shieldType
			
			If (beHurtNoRingLose()) Then ' player.canBeHurt()
				If (sType <> 0) Then
					'sType = 0
					
					If (Not Self.beAttackByHari) Then
						' Magic number: 14 (Sound-effect ID)
						' If it wasn't obvious, this is probably the "hurt sound".
						soundInstance.playSe(14)
					EndIf
					
					If (Self.beAttackByHari) Then
						Self.beAttackByHari = False
					EndIf
				ElseIf (ringNum + ringTmpNum > 0) Then
					' This behavior may change in the future.
					RingObject.hurtRingExplosion(ringNum + ringTmpNum, getBodyPositionX(), getBodyPositionY(), Self.currentLayer, Self.isAntiGravity)
					
					ringNum = 0
					ringTmpNum = 0
				ElseIf (ringNum = 0 And ringTmpNum = 0) Then
					setDie(False)
				EndIf
			EndIf
		End
		
		Method beHurtNoRingLose:Bool()
			If (canBeHurt()) Then ' player.canBeHurt()
				doHurt()
				
				Local bodyCenterX:= getNewPointX(Self.footPointX, 0, -BODY_OFFSET, Self.faceDegree)
				Local bodyCenterY:= getNewPointY(Self.footPointY, 0, -BODY_OFFSET, Self.faceDegree)
				
				Self.faceDegree = Self.degreeStable
				
				Self.footPointX = getNewPointX(bodyCenterX, 0, BODY_OFFSET, Self.faceDegree)
				Self.footPointY = getNewPointY(bodyCenterY, 0, BODY_OFFSET, Self.faceDegree)
				
				If (shieldType <> 0) Then
					shieldType = 0
				EndIf
				
				Return True
			EndIf
			
			Return False
		End
		
		Method beHurtByCage:Void()
			If (Self.hurtCount = 0) Then
				doHurt()
				
				Self.velX = ((Self.velX * 3) / 2)
				Self.velY = ((Self.velY * 3) / 2)
			EndIf
		End
		
		Method doHurt:Void()
			Self.animationID = ANI_HURT_PRE
			
			If (Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
				' Magic number: 128
				Self.footPointY -= 128
				
				prepareForCollision()
			EndIf
			
			If (Self.outOfControl And Self.outOfControlObject <> Null And Self.outOfControlObject.releaseWhileBeHurt()) Then
				Self.outOfControl = False
				
				Self.outOfControlObject = Null
			EndIf
			
			Self.hurtCount = HURT_COUNT
			
			If (Self.velX = 0) Then
				Self.velX = DSgn(Not Self.faceDirection) * HURT_POWER_X
			ElseIf (Self.velX > 0) Then
				Self.velX = -HURT_POWER_X
			Else
				Self.velX = HURT_POWER_X
			EndIf
			
			If (Self.isAntiGravity) Then
				Self.velX = -Self.velX
			EndIf
			
			Self.velY = (DSgn(Not Self.isAntiGravity) * HURT_POWER_Y)
			
			Self.collisionState = COLLISION_STATE_JUMP
			
			' Magic number: 1 (Action-state)
			Self.worldCal.actionState = 1
			
			Self.collisionChkBreak = True
			
			Self.worldCal.stopMove()
			
			Self.onObjectContinue = False
			Self.footOnObject = Null
			
			Self.hurtNoControl = True
			
			Self.attackAnimationID = ANI_STAND
			Self.attackCount = 0
			Self.attackLevel = 0
			
			Self.dashRolling = False
			
			MyAPI.vibrate()
			
			Self.degreeRotateMode = 0
		End
		
		Method canBeHurt:Bool()
			If (Self.hurtCount > 0 Or invincibleCount > 0 Or Self.isDead) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method isFootOnObject:Bool(obj:GameObject)
			If (Self.outOfControl) Then
				Return False
			EndIf
			
			If (Self.collisionState <> COLLISION_STATE_ON_OBJECT) Then
				Return False
			EndIf
			
			Return Self.footOnObject = obj
		End
		
		Method isFootObjectAndLogic:Bool(obj:GameObject)
			Return (Self.footObjectLogic And Self.footOnObject = obj And Self.collisionState = COLLISION_STATE_ON_OBJECT)
		End
		
		Method setFootPositionX:Void(x:Int)
			Self.footPointX = x
			Self.posX = x
		End
		
		Method setFootPositionY:Void(y:Int)
			Self.footPointY = y
			Self.posY = y
		End
		
		Method setBodyPositionX:Void(x:Int)
			setFootPositionX(x)
		End
		
		Method setBodyPositionY:Void(y:Int)
			setFootPositionY(y + BODY_OFFSET)
		End
		
		Method getBodyPositionX:Int()
			Return getFootPositionX()
		End
		
		Method getBodyPositionY:Int()
			Return getFootPositionY() + (BODY_OFFSET * DSgn(Self.isAntiGravity))
		End
		
		Method spinLv2Calc:Int()
			Return (((PickValue(Self.isInWater, SPIN_INWATER_START_SPEED_2, SPIN_START_SPEED_2) * (SONIC_ATTACK_LEVEL_3_V0 - (Self.spinDownWaitCount * SPIN_LV2_COUNT_CONF))) / SPIN_LV2_COUNT) / 100)
		End
		
		Method dashRollingLogic:Void()
			Self.animationID = ANI_SPIN_LV1
			
			If (Self.spinCount > ANI_ROTATE_JUMP) Then
				Self.animationID = ANI_SPIN_LV2
			Else
				If (Key.press(Key.B_HIGH_JUMP | Key.gUp)) Then
					Self.spinDownWaitCount = 0
					Self.spinCount = SPIN_LV2_COUNT
					Self.animationID = ANI_SPIN_LV2
					
					Self.spinKeyCount = SPIN_KEY_COUNT
					
					Self.drawer.restart()
					
					If (characterID <> CHARACTER_AMY) Then
						soundInstance.playSe(4)
					EndIf
					
				ElseIf (Key.repeated((Key.B_SPIN2 | Key.B_7) | Key.B_9) And Self.spinKeyCount = 0) Then
					Self.spinCount = SPIN_LV2_COUNT
					Self.animationID = ANI_SPIN_LV2
					
					Self.spinKeyCount = SPIN_KEY_COUNT
					
					Self.drawer.restart()
					
					If (characterID <> CHARACTER_AMY) Then
						soundInstance.playSe(4)
					EndIf
				EndIf
				
				If (Self.spinCount = 0 And Self.spinKeyCount > 0) Then
					Self.spinKeyCount -= 1
				EndIf
			EndIf
			
			If (Self.spinCount > 0) Then
				If (Self.spinDownWaitCount < SPIN_LV2_COUNT) Then
					Self.spinDownWaitCount += 1
				Else
					Self.spinDownWaitCount = SPIN_LV2_COUNT
				EndIf
			EndIf
			
			If (Self.spinCount > 0) Then
				Self.spinCount -= 1
				Self.effectID = 1
			Else
				Self.effectID = 0
			EndIf
			
			Select (Self.collisionState)
				Case COLLISION_STATE_WALK
					Self.totalVelocity = 0
				Default
					Self.velX = 0
			End Select
			
			If (Not Key.repeated(((Key.gDown | Key.B_7) | Key.B_9) | Key.B_SPIN2)) Then
				Self.effectID = -1
				
				Select (Self.collisionState)
					Case COLLISION_STATE_WALK
						Self.totalVelocity = SPIN_START_SPEED_1
						
						If (Self.isInWater) Then
							Self.totalVelocity = SPIN_INWATER_START_SPEED_1
						EndIf
						
						If (Self.spinCount > 0) Then
							Self.totalVelocity = spinLv2Calc()
						EndIf
						
						' Magic number: 5 (Sound-effect ID)
						SoundSystem.getInstance().playSe(5)
						
						If (Not Self.faceDirection) Then
							Self.totalVelocity = -Self.totalVelocity
						EndIf
					Default
						Self.velX = SPIN_START_SPEED_1
						
						If (Self.isInWater) Then
							Self.totalVelocity = SPIN_INWATER_START_SPEED_1
						EndIf
						
						If (Self.spinCount > 0) Then
							Self.velX = spinLv2Calc()
						EndIf
						
						' Magic number: 5 (Sound-effect ID)
						SoundSystem.getInstance().playSe(5)
						
						If (Not Self.faceDirection) Then
							Self.velX = DSgn(Self.isAntiGravity) * Self.velX
						Else
							Self.velX = DSgn(Not Self.isAntiGravity) * Self.velX
						EndIf
				End Select
				
				Self.spinCount = 0
				
				Self.animationID = ANI_JUMP
				
				Self.dashRolling = False
				Self.ignoreFirstTouch = True
				Self.isAfterSpinDash = True
			EndIf
			
			' This behavior may change in the future:
			If (Self.collisionState = COLLISION_STATE_WALK Or Self.collisionState = COLLISION_STATE_IN_SAND) Then
				Self.velY = 100
			EndIf
			
			Self.velY += (DSgn(Not Self.isAntiGravity) * getGravity())
		End
		
		Method beWaterFall:Void()
			Self.waterFalling = True
			
			Self.velY += (GRAVITY / 10)
		End
		
		Method getWaterFallState:Bool()
			Return Self.waterFalling
		End
		
		Method initWaterFall:Void()
			If (Self.waterFallDrawer = Null) Then
				Local image:MFImage = Null
				
				' Magic number: 5 (Zone ID)
				If (StageManager.getCurrentZoneId() = 5) Then
					image = MFImage.createImage("/animation/water_fall_5.png")
				EndIf
				
				If (image = Null) Then
					Self.waterFallDrawer = New Animation("/animation/water_fall").getDrawer(0, True, 0)
				Else
					Self.waterFallDrawer = New Animation(image, "/animation/water_fall").getDrawer(0, True, 0)
				EndIf
			EndIf
		End
		
		Method waterFallDraw:Void(g:MFGraphics, camera:Coordinate)
			If (Self.waterFalling) Then
				' Magic numbers: 320, -320 (Offset; Y)
				Local offset_y:= PickValue((characterID = CHARACTER_KNUCKLES And Self.myAnimationID = ANI_BAR_ROLL_1), 320, -320)
				
				drawInMap(g, Self.waterFallDrawer, (Self.collisionRect.x0 + Self.collisionRect.x1) / 2, Self.collisionRect.y0 + offset_y)
				
				Self.waterFalling = False
			EndIf
		End
		
		Method initWaterFlush:Void()
			If (Self.waterFlushDrawer = Null) Then
				Local image:MFImage = Null
				
				' Magic number: 5 (Zone ID)
				If (StageManager.getCurrentZoneId() = 5) Then
					image = MFImage.createImage("/animation/water_flush_5.png")
				EndIf
				
				If (image = Null) Then
					Self.waterFlushDrawer = New Animation("/animation/water_flush").getDrawer(0, True, 0)
				Else
					Self.waterFlushDrawer = New Animation(image, "/animation/water_flush").getDrawer(0, True, 0)
				EndIf
			EndIf
			
		End
	Private
		' Methods:
		Method waterFlushDraw:Void(g:MFGraphics)
			If (Self.showWaterFlush) Then
				initWaterFlush()
				
				Local animationDrawer:= Self.waterFlushDrawer
				Local x:Int = Self.footPointX
				Local y:Int
				
				' Magic numbers: 4, 5 (Zone IDs)
				If (StageManager.getCurrentZoneId() = 4 Or StageManager.getCurrentZoneId() = 5) Then
					y = (Self.collisionRect.y1 - RIGHT_WALK_COLLISION_CHECK_OFFSET_X)
				Else
					y = Self.collisionRect.y1
				EndIf
				
				drawInMap(g, animationDrawer, x, y)
				
				Self.showWaterFlush = False
			EndIf
		End
	Public
		' Methods:
		Method beAccelerate:Bool(power:Int, IsX:Bool, sender:GameObject)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Self.totalVelocity = power
				Self.faceDirection = (Self.totalVelocity > 0)
				
				Return True
			ElseIf (Self.collisionState <> COLLISION_STATE_ON_OBJECT Or (Accelerate(sender) <> Null)) Then
				Return False
			Else
				If (IsX) Then
					Self.velX = power
				Else
					Self.velY = power
				EndIf
				
				Return True
			EndIf
		End
		
		Method isOnGound:Bool() ' Property
			Return (Self.collisionState = COLLISION_STATE_WALK)
		End
		
		Method doPoalMotion:Bool(x:Int, y:Int, isLeft:Bool)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Self.collisionState = COLLISION_STATE_JUMP
			EndIf
			
			If (Self.collisionState <> COLLISION_STATE_JUMP) Then
				Return False
			EndIf
			
			Self.animationID = ANI_POAL_PULL
			Self.faceDirection = (Not isLeft)
			
			Self.footPointX = x
			Self.footPointY = y + DETECT_HEIGHT
			
			Self.velX = 0
			Self.velY = 0
			
			Return True
		End
		
		Method doPoalMotion2:Bool(x:Int, y:Int, direction:Bool)
			If (Self.collisionState <> COLLISION_STATE_WALK Or ((Not Self.faceDirection Or Not direction Or Self.totalVelocity < DO_POAL_MOTION_SPEED) And (Self.faceDirection Or direction Or Self.totalVelocity > -DO_POAL_MOTION_SPEED))) Then
				Return False
			EndIf
			
			Self.animationID = ANI_POAL_PULL_2
			Self.faceDirection = direction
			
			Self.footPointX = ((DSgn(Not Self.faceDirection) * WIDTH) + x)
			
			setNoKey()
			
			Self.totalVelocity = DSgn(Not Self.faceDirection) * (DO_POAL_MOTION_SPEED / 2)
			
			Self.worldCal.stopMoveX()
			
			Return True
		End
		
		Method doPullMotion:Void(x:Int, y:Int)
			Self.animationID = ANI_PULL
			
			Self.footPointX = x
			Self.footPointY = (y + DETECT_HEIGHT)
			
			Self.velX = 0
			Self.velY = 0
			
			If (Self.faceDirection) Then
				Self.footPointX -= SIDE_FOOT_FROM_CENTER
			Else
				Self.footPointX += SIDE_FOOT_FROM_CENTER
			EndIf
		End
		
		Method doPullBarMotion:Void(y:Int)
			Self.animationID = ANI_SMALL_ZERO
			
			' Magic number: 1792
			Self.footPointY = y + 1792
			
			Self.velX = 0
			Self.velY = 0
		End
		
		Method doWalkPoseInAir:Void()
			If (Self.collisionState <> COLLISION_STATE_JUMP) Then
				Return
			EndIf
			
			If (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
				Self.animationID = ANI_RUN_1
			ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
				Self.animationID = ANI_RUN_2
			Else
				Self.animationID = ANI_RUN_3
			EndIf
		End
		
		Method doDripInAir:Void()
			If (Self.collisionState = COLLISION_STATE_JUMP) Then
				If (Self.animationID = ANI_JUMP) Then
					Self.animationID = ANI_JUMP
				ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_1) Then
					Self.animationID = ANI_RUN_1
				ElseIf (Abs(Self.velX) < SPEED_LIMIT_LEVEL_2) Then
					Self.animationID = ANI_RUN_2
				Else
					Self.animationID = ANI_RUN_3
				EndIf
			EndIf
			
			Self.bankwalking = False
		End
		
		Method setAnimationId:Void(id:Int)
			Self.animationID = id
		End
		
		Method restartAniDrawer:Void()
			Self.drawer.restart()
		End
		
		Method getAnimationId:Int()
			Return Self.animationID
		End
		
		Method refreshCollisionRectWrap:Void()
			Local RECT_HEIGHT:= getCollisionRectHeight()
			Local RECT_WIDTH:= getCollisionRectWidth()
			
			Local switchDegree:= Self.faceDegree
			Local yOffset:= 0
			
			' Magic numbers: -960, -320
			If (Self.animationID = ANI_SLIP) Then
				If (getAnimationOffset() = 1) Then
					yOffset = -960
				Else
					yOffset = -320
				EndIf
				
				switchDegree = 0
			EndIf
			
			Self.checkPositionX = getNewPointX(Self.footPointX, 0, (-RECT_HEIGHT) / 2, switchDegree) + 0
			Self.checkPositionY = getNewPointY(Self.footPointY, 0, (-RECT_HEIGHT) / 2, switchDegree) + yOffset
			
			Self.collisionRect.setTwoPosition(Self.checkPositionX - (RECT_WIDTH / 2), Self.checkPositionY - (RECT_HEIGHT / 2), Self.checkPositionX + (RECT_WIDTH / 2), Self.checkPositionY + (RECT_HEIGHT / 2))
		End
		
		Method getCollisionRectWidth:Int()
			If (Self.animationID = ANI_RAIL_ROLL) Then
				Return HEIGHT
			EndIf
			
			Return WIDTH
		End
		
		Method getCollisionRectHeight:Int()
			If (Self.animationID = ANI_JUMP Or Self.animationID = ANI_SQUAT Or Self.animationID = ANI_SQUAT_PROCESS Or Self.animationID = ANI_SPIN_LV1 Or Self.animationID = ANI_SPIN_LV2 Or Self.animationID = ANI_ATTACK_1 Or Self.animationID = ANI_ATTACK_2 Or Self.animationID = ANI_ATTACK_3) Then
				Return WIDTH ' 1152
			EndIf
			
			Return HEIGHT
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Empty implementation.
		End
		
		Method fallChk:Void()
			If (Self.fallTime > 0) Then
				Self.fallTime -= 1
				
				If (Self.animationID = ANI_STAND) Then
					Self.animationID = ANI_RUN_1
				EndIf
				
				Return
			EndIf
			
			If (Self.isAntiGravity Or Self.faceDegree < 45 Or Self.faceDegree > 315) Then
				If (Not Self.isAntiGravity) Then
					Return
				EndIf
				
				If (Self.faceDegree > 135 And Self.faceDegree < 225) Then
					Return
				EndIf
			EndIf
			
			' Magic number: 474
			If (Abs(Self.totalVelocity) < 474) Then
				If (Self.totalVelocity = 0) Then
					calDivideVelocity()
					
					Self.velY += getGravity()
					
					calTotalVelocity()
				EndIf
				
				' Magic number: 7
				Self.fallTime = 7
			EndIf
		End
	
		Method railIn:Void(x:Int, y:Int)
			Self.railLine = Null
			
			Self.velY = 0
			Self.velX = 0
			
			Self.worldCal.stopMoveX()
			
			setFootPositionX(x)
			
			Self.collisionChkBreak = True
			Self.railing = True
			Self.railIsOut = False
			
			Self.animationID = ANI_RAIL_ROLL
			
			setNoKey()
			
			' Magic numbers: 25, 37 (Sound-effect IDs):
			If (characterID = CHARACTER_AMY) Then
				soundInstance.playSe(25)
			Else
				soundInstance.playSe(SoundSystem.SE_148)
			EndIf
		End
		
		Method railOut:Void(x:Int, y:Int)
			If (Self.railing) Then
				Self.railIsOut = True
				Self.railLine = Null
				
				Self.velY = RAIL_OUT_SPEED_VY0
				Self.velX = 0
				
				setVelX(0)
				
				setFootPositionX(x)
				setFootPositionY(y)
				
				Self.collisionChkBreak = True
				
				Self.animationID = ANI_JUMP
			EndIf
		End
	
		Method pipeIn:Void(x:Int, y:Int, vx:Int, vy:Int)
			Self.piping = True
			
			Self.pipeState = TER_STATE_RUN
			Self.pipeDesX = x
			Self.pipeDesY = y + BODY_OFFSET
			
			Self.velX = 250
			Self.velY = 250
			
			Self.nextVelX = (vx Shl 6)
			Self.nextVelY = (vy Shl 6)
			
			Self.collisionChkBreak = True
		End
		
		Method pipeSet:Void(x:Int, y:Int, vx:Int, vy:Int)
			If (Self.piping) Then
				Self.pipeDesX = x
				Self.pipeDesY = (y + BODY_OFFSET)
				
				'Local degree:= ATan2(vy, vx)
				'Local sourceSpeed:= (MFMath.sqrt((vy * vy) + (vx * vx)) Shr 6)
				
				Self.nextVelX = vx
				Self.nextVelY = vy
				
				Self.pipeState = STATE_PIPE_OVER
				
				If (Self.velX > 0 And Self.footPointX > Self.pipeDesX) Then
					Self.footPointX = Self.pipeDesX
				EndIf
				
				If (Self.velX < 0 And Self.footPointX < Self.pipeDesX) Then
					Self.footPointX = Self.pipeDesX
				EndIf
				
				If (Self.velY > 0 And Self.footPointY > Self.pipeDesY) Then
					Self.footPointY = Self.pipeDesY
				EndIf
				
				If (Self.velY < 0 And Self.footPointY < Self.pipeDesY) Then
					Self.footPointY = Self.pipeDesY
				EndIf
				
				Self.collisionChkBreak = True
				
			Else
				Self.footPointX = x
				Self.footPointY = y
				
				'Local degree:= ATan2(vy, vx)
				'Local sourceSpeed:= (MFMath.sqrt((vy * vy) + (vx * vx)) Shr 6)
				
				Self.nextVelX = vx
				Self.nextVelY = vy
				
				Self.velX = vx
				Self.velY = vy
				
				Self.pipeState = STATE_PIPING
				
				Self.piping = True
				
				Self.collisionChkBreak = True
				
				Self.worldCal.stopMove()
			EndIf
		End
		
		Method pipeOut:Void()
			If (Self.piping) Then
				Self.piping = False
				
				Self.collisionState = COLLISION_STATE_JUMP
				
				' Magic number: 1 (Action-state)
				Self.worldCal.actionState = 1
			EndIf
		End
		
		Method setFall:Void(x:Int, y:Int, left:Int, top:Int)
			If (characterID = CHARACTER_TAILS) Then
				' Not exactly safe, but it works:
				Local tails:= PlayerTails(Self)
				
				tails.stopFly()
			EndIf
			
			Self.railing = True
			
			setFootPositionX(x)
			
			Self.velX = 0
			Self.velY = 0
			
			Self.railLine = Null
			
			Self.collisionChkBreak = True
		End
		
		Method setFallOver:Void()
			Self.railing = False
		End
		
		Method setRailFlip:Void()
			Self.velX = 0
			Self.velY = RAIL_FLIPPER_V0
			
			Self.railLine = Null
			
			Self.collisionChkBreak = True
			Self.railFlipping = True
			
			' Magic number: 54 (Sound-effect ID)
			SoundSystem.getInstance().playSe(54)
		End
		
		Method setRailLine:Bool(line:Line, startX:Int, startY:Int, railDivX:Int, railDivY:Int, railDevX:Int, railDevY:Int, obj:GameObject)
			If (Not obj.getCollisionRect().collisionChk(Self.footPointX, Self.footPointY)) Then
				Return False
			EndIf
			
			If (Not Self.railing Or Self.velY < 0) Then
				Return False
			EndIf
			
			If (Self.railLine = Null) Then
				Self.totalVelocity = 0
			EndIf
			
			Self.railLine = line
			
			calDivideVelocity()
			
			Self.posX = startX
			Self.posY = startY
			
			If (Abs(railDivY) <= 1) Then
				Self.velX = ((railDivX * SONIC_DRAW_HEIGHT) / railDevX)
				Self.velY = 0
				
				If (Self.railFlipping) Then
					Self.railFlipping = False
					
					setFootPositionY(Self.railLine.getY(Self.footPointX) + BODY_OFFSET)
				Else
					setFootPositionY((Self.railLine.getY(Self.footPointX) - RIGHT_WALK_COLLISION_CHECK_OFFSET_X) + BODY_OFFSET)
				EndIf
				
			Else
				Self.velX = ((railDivX * SONIC_DRAW_HEIGHT) / railDevX)
				Self.velY = ((railDivY * SONIC_DRAW_HEIGHT) / railDevY)
				
				setFootPositionY(Self.railLine.getY(Self.footPointX) + BODY_OFFSET)
			EndIf
			
			calTotalVelocity()
			
			Print("~~velX: " + Self.velX + " | velY: " + Self.velY)
			
			Self.collisionChkBreak = True
			
			Return True
		End
		
		Method checkWithObject:Void(preX:Int, preY:Int, currentX:Int, currentY:Int)
			Local moveDistanceX:= (currentX - preX)
			Local moveDistanceY:= (currentY - preY)
			
			If (moveDistanceX = 0 And moveDistanceY = 0) Then
				Self.footPointX = currentX
				Self.footPointY = currentY
				
				Return
			EndIf
			
			Local moveDistance:Int
			
			If (Abs(moveDistanceX) >= Abs(moveDistanceY)) Then
				moveDistance = Abs(moveDistanceX)
			Else
				moveDistance = Abs(moveDistanceY)
			EndIf
			
			Local preCheckX:= preX
			Local preCheckY:= preY
			
			Local I:= WALK_COLLISION_CHECK_OFFSET_Y
			
			While (I < moveDistance)
				I += RIGHT_WALK_COLLISION_CHECK_OFFSET_X
				
				If (I > moveDistance) Then ' >=
					I = moveDistance
				EndIf
				
				Local tmpCurrentX:= (preX + ((moveDistanceX * I) / moveDistance))
				Local tmpCurrentY:= (preY + ((moveDistanceY * I) / moveDistance))
				
				player.moveDistance.x = (tmpCurrentX Shr 6) - (preCheckX Shr 6)
				player.moveDistance.y = (tmpCurrentY Shr 6) - (preCheckY Shr 6)
				
				Self.footPointX = tmpCurrentX
				Self.footPointY = tmpCurrentY
				
				collisionCheckWithGameObject(tmpCurrentX, tmpCurrentY)
				
				If (Not Self.collisionChkBreak) Then
					preCheckX = tmpCurrentX
					preCheckY = tmpCurrentY
				Else
					Exit
				EndIf
			Wend
		End
		
		Method cancelFootObject:Void(obj:GameObject)
			If (Self.collisionState = COLLISION_STATE_ON_OBJECT And isFootOnObject(obj)) Then
				Self.collisionState = COLLISION_STATE_JUMP
				
				Self.footOnObject = Null
				
				Self.onObjectContinue = False
			EndIf
		End
		
		Method cancelFootObject:Void()
			If (Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
				Self.footOnObject = Null
				Self.onObjectContinue = False
			EndIf
		End
		
		Method doItemAttackPose:Void(obj:GameObject, direction:Int)
			If (Not Self.extraAttackFlag) Then
				Local gravMultiplier:= DSgn(Self.isAntiGravity)
				
				Local maxPower:= PickValue(Self.isPowerShoot, SHOOT_POWER, MIN_ATTACK_JUMP)
				
				Local newVelY:= gravMultiplier * getVelY()
				
				If (newVelY > 0) Then
					newVelY = -newVelY
				ElseIf (newVelY > maxPower) Then
					newVelY = maxPower
				EndIf
				
				If (Self.doJumpForwardly) Then
					newVelY = maxPower
				EndIf
				
				If (characterID <> CHARACTER_KNUCKLES Or Self.myAnimationID < ANI_ATTACK_2 Or Self.myAnimationID > ANI_BAR_ROLL_1) Then
					setVelY(-gravMultiplier * newVelY)
				EndIf
				
				If (characterID <> CHARACTER_AMY) Then
					Select (direction)
						Case DIRECTION_DOWN
							cancelFootObject(Self)
							
							Self.collisionState = COLLISION_STATE_JUMP
							Self.animationID = ANI_JUMP
					End Select
				EndIf
				
				If (Self.isPowerShoot) Then
					Self.isPowerShoot = False
				EndIf
			EndIf
		End
		
		Method doAttackPose:Void(obj:GameObject, direction:Int)
			If (Not Self.extraAttackFlag) Then
				Local gravMultiplier:= DSgn(Not Self.isAntiGravity)
				
				Local newVelY:= gravMultiplier * getVelY()
				
				If (newVelY > 0) Then
					newVelY = -newVelY
				ElseIf (newVelY > MIN_ATTACK_JUMP) Then
					newVelY = MIN_ATTACK_JUMP
				EndIf
				
				If (Self.doJumpForwardly) Then
					newVelY = MIN_ATTACK_JUMP
				EndIf
				
				If ((characterID <> CHARACTER_AMY) Or (Not IsInvincibility() Or Self.myAnimationID < ANI_POP_JUMP_UP Or Self.myAnimationID > ANI_BRAKE)) Then
					setVelY((-gravMultiplier) * newVelY)
				EndIf
				
				If (characterID <> CHARACTER_AMY) Then
					Select (direction)
						Case DIRECTION_DOWN
							cancelFootObject(Self)
							
							Self.collisionState = COLLISION_STATE_JUMP
					End Select
				EndIf
			EndIf
		End
		
		Method doBossAttackPose:Void(obj:GameObject, direction:Int)
			If (Self.collisionState = COLLISION_STATE_JUMP) Then
				If (characterID <> CHARACTER_AMY) Then
					setVelX(-Self.velX)
				EndIf
				
				If ((-Self.velY) < (-ATTACK_POP_POWER)) Then
					setVelY(-ATTACK_POP_POWER)
				ElseIf (characterID <> CHARACTER_KNUCKLES) Then
					setVelY(-Self.velY)
				ElseIf (getCharacterAnimationID() = ANI_ATTACK_2 Or getCharacterAnimationID() = ANI_ATTACK_3 Or getCharacterAnimationID() = ANI_RAIL_ROLL Or getCharacterAnimationID() = ANI_BAR_ROLL_1) Then
					' Magic number: 325
					setVelY((-Self.velY) - 325)
				Else
					setVelY(-Self.velY)
				EndIf
			EndIf
		End
		
		Method inRailState:Bool()
			Return (Self.railing Or Self.railIsOut)
		End
		
		Method changeVisible:Void(mVisible:Bool)
			Self.visible = mVisible
		End
		
		Method setOutOfControl:Void(obj:GameObject)
			Self.outOfControl = True
			Self.outOfControlObject = obj
			
			Self.piping = False
		End
		
		Method setOutOfControlInPipe:Void(obj:GameObject)
			Self.outOfControl = True
			Self.outOfControlObject = obj
		End
		
		Method releaseOutOfControl:Void()
			Self.outOfControl = False
			Self.outOfControlObject = Null
		End
		
		Method isControlObject:Bool(obj:GameObject)
			Return (Self.controlObjectLogic And obj = Self.outOfControlObject)
		End
		
		Method setDieInit:Void(isDrowning:Bool, vel:Int)
			Self.velX = 0
			
			' Magic number: 6
			If (Not isDrowning Or Self.breatheNumCount < 6) Then
				Self.velY = vel
			Else
				Self.velY = 0
			EndIf
			
			If (Self.isAntiGravity) Then
				Self.velY = -Self.velY
			EndIf
			
			Self.faceDegree = Self.degreeStable
			Self.degreeForDraw = Self.degreeStable
			
			Self.collisionState = COLLISION_STATE_JUMP
			
			MapManager.setFocusObj(Null)
			
			Self.isDead = True
			Self.finishDeadStuff = False
			
			Self.animationID = ANI_DEAD_PRE
			
			Self.drawer.restart()
			
			timeStopped = True
			
			Self.worldCal.stopMove()
			
			Self.collisionChkBreak = True
			Self.hurtCount = 0
			Self.dashRolling = False
			
			If (Self.effectID = EFFECT_SAND_1 Or Self.effectID = EFFECT_SAND_2) Then
				Self.effectID = EFFECT_NONE
			EndIf
			
			Self.drownCnt = 0
			
			' Magic numbers: 1, 10 (State, ID):
			If (stageModeState = STATE_RACE_MODE And StageManager.getStageID() = 10) Then
				RocketSeparateEffect.clearInstance()
			EndIf
			
			GameState.isThroughGame = True
			
			shieldType = 0
			invincibleCount = 0
			speedCount = 0
			
			If (Self.currentLayer = 0) Then
				Self.currentLayer = 1
			ElseIf (Self.currentLayer = 1) Then
				Self.currentLayer = 0
			EndIf
			
			resetFlyCount()
		End
		
		Method setDie:Void(isDrowning:Bool, vel:Int)
			setDieInit(isDrowning, vel)
		End
		
		Method setDieWithoutSE:Void()
			setDieInit(False, DIE_DRIP_STATE_JUMP_V0)
		End
		
		Method setDie:Void(isDrowning:Bool)
			setDie(isDrowning, DIE_DRIP_STATE_JUMP_V0)
		End
		
		Method setNoKey:Void()
			Self.noKeyFlag = True
		End
	
		Method setCollisionState:Void(state:Byte)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			Select (state)
				Case COLLISION_STATE_JUMP
					Self.faceDegree = Self.degreeStable
					
					' Magic number: 1 (Action-state)
					Self.worldCal.actionState = 1
			End Select
			
			Self.collisionState = state
		End
		
		Method setSlip:Void()
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				Self.slipFlag = True
				Self.showWaterFlush = True
				
				Self.animationID = ANI_YELL
				
				setNoKey()
			EndIf
		End
		
		Method beUnseenPop:Bool()
			If (Self.collisionState <> COLLISION_STATE_WALK Or Abs(getVelX()) <= WIDTH) Then
				Return False
			EndIf
			
			beSpring(getGravity() + DETECT_HEIGHT, 1)
			
			Local nextVelX:= DETECT_HEIGHT
			
			If (DETECT_HEIGHT > HINER_JUMP_MAX) Then
				nextVelX = HINER_JUMP_MAX
			EndIf
			
			If (getVelX() > 0) Then
				beSpring(nextVelX, 2)
			Else
				beSpring(nextVelX, 3)
			EndIf
			
			' Magic number: 37 (Sound-effect ID)
			SoundSystem.getInstance().playSequenceSe(37)
			
			Return True
		End
		
		Method setBank:Void()
			Self.onBank = Not Self.onBank
			
			If (Self.onBank And Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
		End
		
		Method bankLogic:Void()
			If (Self.onBank) Then
				Self.faceDegree = 0
				
				inputLogicWalk()
				
				If (Self.onBank) Then
					calDivideVelocity()
					
					Self.velY = 0
					
					Local preX:= Self.getFootPositionX()
					Local preY:= Self.getFootPositionY()
					
					Self.footPointX += Self.velX
					
					Local yLimit:= (CENTER_Y - (((MyAPI.dCos((((Self.footPointX - CENTER_X) * B_1) / B_2) Shr 6) * f24C) / 100) + f24C))
					
					decelerate()
					
					Local velX:= Self.getVelX()
					
					' Magic numbers: 400, 200, 1 (Action-state):
					If (Abs(velX) > BANKING_MIN_SPEED) Then
						Self.setFootPositionY(Max(yLimit, Self.getFootPositionY() - ((Abs(velX) * 400) / BANKING_MIN_SPEED)))
					Else
						Self.setFootPositionY(Min(CENTER_Y, Self.getFootPositionY() + 200))
						
						If (Self.footPointY >= CENTER_Y) Then
							Self.onBank = False
							Self.collisionState = COLLISION_STATE_JUMP
							
							Self.worldCal.actionState = 1
							Self.bankwalking = False
						EndIf
					EndIf
					
					If (Self.animationID <> ANI_JUMP) Then
						If (Abs(velX) <= BANKING_MIN_SPEED) Then
							Self.onBank = False
							Self.collisionState = COLLISION_STATE_JUMP
							Self.worldCal.actionState = 1
							
							doDripInAir()
						ElseIf (Self.footPointY < 61184) Then ' BANK_BRAKE_SPEED_LIMIT
							Self.animationID = ANI_BANK_3
						ElseIf (Self.footPointY < 61952) Then ' BANK_BRAKE_SPEED_LIMIT
							Self.animationID = ANI_BANK_2
						ElseIf (Self.footPointY < 62720) Then ' BANK_BRAKE_SPEED_LIMIT
							Self.animationID = ANI_BANK_1
						EndIf
					EndIf
					
					checkWithObject(preX, preY, Self.footPointX, Self.footPointY)
				EndIf
			EndIf
		End
		
		Method setTerminal:Void(type:Int)
			terminalType = type
			
			Self.terminalOffset = 0
			Self.terminalCount = TERMINAL_COUNT
			
			isTerminal = True
			timeStopped = True
			
			Select (terminalType)
				Case TERMINAL_RUN_TO_RIGHT, TERMINAL_RUN_TO_RIGHT_2
					If (Self.collisionState = COLLISION_STATE_WALK) Then
						If (Self.animationID = ANI_JUMP) Then
							land()
						EndIf
						
						If (Self.totalVelocity > MAX_VELOCITY) Then
							Self.totalVelocity = MAX_VELOCITY
						EndIf
					EndIf
					
					changeVisible(False)
					
					Self.noMoving = True
					
					terminalState = TER_STATE_RUN
				Case TERMINAL_NO_MOVE
					changeVisible(False)
					
					Self.noMoving = True
					
					terminalState = TER_STATE_RUN
				Case TERMINAL_SUPER_SONIC
					terminalState = TER_STATE_RUN
				Default
					' Nothing so far.
			End Select
		End
		
		Method setTerminalSingle:Void(type:Int)
			terminalType = type
			
			Self.terminalCount = TERMINAL_COUNT
			
			isTerminal = True
			timeStopped = True
		End
		
		Method isTerminalRunRight:Bool()
			Return (isTerminal And (terminalType = TERMINAL_RUN_TO_RIGHT Or terminalType = TERMINAL_RUN_TO_RIGHT_2 Or (terminalType = TERMINAL_SUPER_SONIC And terminalState = TER_STATE_RUN And Self.posX < SUPER_SONIC_STAND_POS_X)))
		End
		
		Method doBrake:Bool()
			Return (isTerminal And terminalType = TERMINAL_SUPER_SONIC And terminalState = TER_STATE_BRAKE And Self.posX > SUPER_SONIC_STAND_POS_X And Self.totalVelocity > 0)
		End
		
		Method beTrans:Void(desX:Int, desY:Int)
			Self.animationID = ANI_JUMP
			Self.collisionState = COLLISION_STATE_JUMP
			
			Self.transing = True
			
			setBodyPositionX(desX)
			setBodyPositionY(desY)
			
			MapManager.setCameraMoving()
			
			calPreCollisionRect()
		End
		
		Method setCelebrate:Void()
			Self.isCelebrate = True
			
			timeStopped = True
			
			MapManager.setCameraLeftLimit(MapManager.getCamera().x)
			MapManager.setCameraRightLimit(MapManager.getCamera().x + MapManager.CAMERA_WIDTH)
			
			' Magic number: 3840
			If (Self.faceDirection) Then
				Self.moveLimit = Self.posX + 3840
			Else
				Self.moveLimit = Self.posX - 3840
			EndIf
		End
	
		Method getPreItem:Void(itemId:Int)
			For Local i:= 0 Until itemVec.Length
				If (itemVec[i][0] = -1) Then
					itemVec[i][0] = itemId
					itemVec[i][1] = 20 ' SPIN_KEY_COUNT
					
					Return
				EndIf
			Next
		End
		
		Method getItem:Void(itemId:Int)
			Select (itemId)
				Case 0
					addLife()
					playerLifeUpBGM()
				Case 1
					shieldType = 1
					soundInstance.playSe(ANI_DEAD)
				Case 2
					shieldType = 2
					soundInstance.playSe(ANI_DEAD)
				Case 3
					invincibleCount = INVINCIBLE_COUNT
					SoundSystem.getInstance().stopBgm(False)
					SoundSystem.getInstance().playBgm(ANI_HURT_PRE)
				Case 4
					speedCount = INVINCIBLE_COUNT
					SoundSystem.getInstance().setSoundSpeed(2.0)
					
					If (SoundSystem.getInstance().getPlayingBGMIndex() <> ANI_POP_JUMP_DOWN_SLOW) Then
						SoundSystem.getInstance().restartBgm()
					EndIf
				Case 5
					If (Self.hurtCount = 0) Then
						getRing(ringRandomNum)
					EndIf
				Case 6
					If (Self.hurtCount = 0) Then
						getRing(5)
					EndIf
				Case 7
					If (Self.hurtCount = 0) Then
						getRing(TERMINAL_COUNT)
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		' Functions:
		Function getTmpRing:Void(itemId:Int)
			Select (itemId)
				Case 5
					ringTmpNum = RANDOM_RING_NUM[MyRandom.nextInt(RANDOM_RING_NUM.Length)]
					ringRandomNum = ringTmpNum
				Case 6
					ringTmpNum = 5
				Case 7
					ringTmpNum = TERMINAL_COUNT
			End Select
		End
		
		Function getRing:Void(num:Int)
			Local preRingNum:= ringNum
			
			ringNum += num
			
			' Magic numbers: 1, 8 (Stage-mode-state, Zone ID):
			If (stageModeState <> STATE_RACE_MODE And StageManager.getCurrentZoneId() <> 8) Then
				If (preRingNum / 100 <> ringNum / 100) Then
					addLife()
					playerLifeUpBGM()
				EndIf
				
				If (ringTmpNum <> 0) Then
					ringTmpNum = 0
				EndIf
			EndIf
		End
		
		' Methods:
		Method isAttracting:Bool()
			Return (shieldType = 2)
		End
		
		Method getEnemyScore:Void()
			scoreNum += 100
			raceScoreNum += 100
		End
		
		Method getBossScore:Void()
			scoreNum += 1000
			raceScoreNum += 1000
		End
	
		Method getBallHobinScore:Void()
			scoreNum += 10
			raceScoreNum += 10
		End
	
		Method ductIn:Void()
			Self.ducting = True
			Self.pushOnce = True
			
			Self.ductingCount = 0
		End
		
		Method ductOut:Void()
			Self.ducting = False
			Self.pushOnce = False
			
			Self.ductingCount = 0
		End
		
		Method setSqueezeEnable:Void(enable:Bool)
			Self.squeezeFlag = enable
		End
	Protected
		' Methods:
		Method isHeadCollision:Bool()
			Local collision:Bool = False
			
			Local headBlockY:= Self.worldInstance.getWorldY(Self.footPointX, Self.footPointY - HEIGHT, 1, 2)
			Local headBlockY2:= Self.worldInstance.getWorldY(Self.footPointX + WIDTH, Self.footPointY - HEIGHT, 1, 2)
			
			If (headBlockY >= 0) Then
				collision = True
			EndIf
			
			If (headBlockY2 >= 0) Then
				Return True
			EndIf
			
			Return collision
		End
		
		Method resetPlayer:Void()
			Self.footPointX = Self.deadPosX
			Self.footPointY = Self.deadPosY
			
			Self.worldCal.stopMove()
			
			StageManager.resetStageGameover()
			
			Self.velX = 0
			Self.velY = 0
			
			setVelX(Self.velX)
			setVelY(Self.velY)
			
			Self.totalVelocity = 0
			Self.collisionState = COLLISION_STATE_WALK
			
			MapManager.setFocusObj(Self)
			MapManager.focusQuickLocation()
			
			Self.isDead = False
			Self.animationID = ANI_STAND
			
			timeStopped = False
			
			invincibleCount = 240 ' INVINCIBLE_COUNT
			
			preScoreNum = scoreNum
			preLifeNum = lifeNum
			
			timeCount = 0
			lastTimeCount = timeCount
		End
		
		Method headInit:Void()
			If (GameState.guiAnimation = Null) Then
				GameState.guiAnimation = New Animation("/animation/gui")
			EndIf
			
			headDrawer = GameState.guiAnimation.getDrawer(characterID, False, 0)
			
			Self.isAttackBoss4 = False
		End
		
		Method close:Void()
			Animation.closeAnimationDrawer(Self.waterFallDrawer)
			Self.waterFallDrawer = Null
			
			Animation.closeAnimationDrawer(Self.waterFlushDrawer)
			Self.waterFlushDrawer = Null
			
			Animation.closeAnimationDrawer(Self.drawer)
			Self.drawer = Null
			
			Animation.closeAnimationDrawer(Self.effectDrawer)
			Self.effectDrawer = Null
			
			Animation.closeAnimation(Self.dustEffectAnimation)
			Self.dustEffectAnimation = Null
			
			closeImpl()
		End
	Public
		' Functions:
		Function addLife:Void()
			lifeNum += 1
		End
		
		Function minusLife:Void()
			lifeNum -= 1
		End
		
		Function getLife:Int()
			Return lifeNum
		End
		
		Function setLife:Void(num:Int)
			lifeNum = num
		End
		
		Function setScore:Void(num:Int)
			scoreNum = num
		End
		
		Function getScore:Int()
			Return scoreNum
		End
		
		Function resetGameParam:Void()
			scoreNum = 0
			lifeNum = 2
		End
		
		Function doInitInNewStage:Void()
			currentMarkId = 0
		End
		
		Function initStageParam:Void()
			ringNum = 0
			invincibleCount = 0
			speedCount = 0
			
			SoundSystem.getInstance().setSoundSpeed(1.0)
			
			shieldType = 0
			timeCount = 0
			
			lastTimeCount = timeCount
			
			timeStopped = False
			
			raceScoreNum = 0
			
			preScoreNum = scoreNum
			preLifeNum = lifeNum
			
			For Local I:= 0 Until itemVec.Length
				itemVec[I][0] = -1
			Next
			
			setOverCount(sonicdef.OVER_TIME)
		End
		
		Function initSpParam:Void(param_ringNum:Int, checkPointID:Int, param_timeCount:Int)
			If (player <> Null) Then
				currentMarkId = checkPointID
			EndIf
			
			ringNum = param_ringNum
			
			timeCount = param_timeCount
			lastTimeCount = timeCount
		End
		
		Function doPauseLeaveGame:Void()
			scoreNum = preScoreNum
			lifeNum = preLifeNum
		End
		
		Function drawGameUI:Void(g:MFGraphics)
			If (Not isTerminal Or terminalType <> TERMINAL_SUPER_SONIC Or terminalState <= TER_STATE_LOOK_MOON_WAIT) Then
				' Magic number: 5
				GameState.guiAniDrawer.draw(g, 5, uiOffsetX + 0, 0, False, 0)
				
				' Rings.
				drawNum(g, ringNum, (uiOffsetX + 12), 15, 0, PickValue((ringNum = 0 And (timeCount / 240) Mod 2 = 0), 3, 0))
				
				' Score.
				drawNum(g, PickValue((stageModeState = STATE_RACE_MODE), raceScoreNum, scoreNum), NumberSideX + uiOffsetX, 8, 2, 0)
				
				' Time.
				timeDraw(g, NumberSideX + uiOffsetX, ANI_BAR_ROLL_1)
				
				If (stageModeState <> STATE_RACE_MODE) Then
					' Magic number: 8 (Zone ID)
					If (StageManager.getCurrentZoneId() = 8) Then
						If (player.isDead) Then
							headDrawer.setActionId(0)
						Else
							headDrawer.setActionId(4)
						EndIf
					EndIf
					
					' Life icon.
					headDrawer.draw(g, SCREEN_WIDTH, 0)
					
					' Life count.
					drawNum(g, PickValue((lifeNum >= ANI_ROTATE_JUMP), ANI_ROTATE_JUMP, lifeNum), SCREEN_WIDTH - ANI_ROTATE_JUMP, 4, SPIN_LV2_COUNT, 0)
				EndIf
			EndIf
		End
	
		Function drawNum:Void(g:MFGraphics, num:Int, x:Int, y:Int, anchor:Int, type:Int)
			Local divideNum:= 10
			Local blockNum:= 1
			Local i:= 0
			
			While ((num / divideNum) <> 0)
				blockNum += 1
				divideNum *= 10
				
				i += 1
			Wend
			
			divideNum /= 10
			
			Local localanchor:= 0
			
			Select (anchor)
				Case 0
					localanchor = 34
				Case 1
					localanchor = 33
				Case 2
					localanchor = 36
			End Select
			
			Local localtype:= 0
			
			Select (type)
				Case 0
					localtype = 0
				Case 1
					localtype = 1
				Case 2
					localtype = 3
				Case 3
					localtype = 2
				Case 4
					localtype = 1
			End Select
			
			NumberDrawer.drawNum(g, localtype, num, x, y, localanchor)
		End
		
		Function drawNum:Void(g:MFGraphics, num:Int, x:Int, y:Int, anchor:Int, type:Int, blockNum:Int)
			If (numDrawer = Null) Then
				numDrawer = GlobalResource.statusAnimation.getDrawer(0, False, 0)
			EndIf
			
			Local divideNum:= 1
			
			For Local I:= 1 Until blockNum
				divideNum *= 10
			Next
			
			Local leftPosition:= 0
			
			Select (anchor)
				Case 0
					leftPosition = x - ((NUM_SPACE[type] * (blockNum - 1)) / 2)
				Case 1
					leftPosition = x
				Case 2
					leftPosition = x - (NUM_SPACE[type] * (blockNum - 1))
			End Select
			
			For Local I:= 0 Until blockNum
				Local tmpNum:= (Abs(num / divideNum) Mod 10)
				
				divideNum /= 10
				
				' Magic numbers: 3, 0
				If (type = 3 And tmpNum = 0) Then
					' Magic number: 26 (Action ID)
					numDrawer.setActionId(26)
				Else
					numDrawer.setActionId(NUM_ANI_ID[type] + tmpNum)
				EndIf
				
				numDrawer.draw(g, (NUM_SPACE[type] * I) + leftPosition, y)
			Next
		End
		
		Function timeLogic:Void()
			If (Not timeStopped) Then
				If (overTime > timeCount) Then
					timeCount += 60
					
					If (timeCount > overTime) Then
						timeCount = overTime
					EndIf
					
					If (GlobalResource.timeIsLimit()) Then
						If (overTime - timeCount <= BREATHE_TIME_COUNT) Then
							Local t:= (timeCount / 1000)
							
							If (t <> preTimeCount) Then
								SoundSystem.getInstance().playSe(ANI_YELL)
							EndIf
							
							preTimeCount = t
						EndIf
						
						If (timeCount = overTime And player <> Null) Then
							If (stageModeState = STATE_RACE_MODE) Then
								player.setDie(False)
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
							ElseIf (lifeNum > 0) Then
								player.setDie(False)
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
								minusLife()
							Else
								player.setDie(False)
								StageManager.setStageGameover()
							EndIf
						EndIf
					ElseIf (stageModeState = STATE_RACE_MODE) Then
						If (overTime - timeCount <= BREATHE_TIME_COUNT) Then
							If (timeCount / 1000 <> preTimeCount) Then
								' Magic number: 30 (Sound-effect ID)
								SoundSystem.getInstance().playSe(30)
							EndIf
							
							preTimeCount = timeCount / 1000
						EndIf
						
						If (timeCount = overTime And player <> Null) Then
							If (stageModeState = STATE_RACE_MODE) Then
								player.setDie(False)
								
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
							ElseIf (lifeNum > 0) Then
								player.setDie(False)
								
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
								
								minusLife()
							Else
								player.setDie(False)
								
								StageManager.setStageGameover()
							EndIf
						EndIf
					EndIf
					
				ElseIf (overTime < timeCount) Then
					timeCount -= 60
					
					If (timeCount < overTime) Then
						timeCount = overTime
					EndIf
					
					If (GlobalResource.timeIsLimit()) Then
						If (timeCount <= BREATHE_TIME_COUNT) Then
							If (timeCount / 1000 <> preTimeCount) Then
								' Magic number: 30 (Sound-effect ID)
								SoundSystem.getInstance().playSe(30)
							EndIf
							
							preTimeCount = timeCount / 1000
						EndIf
						
						If (timeCount = overTime And player <> Null) Then
							If (stageModeState = STATE_RACE_MODE) Then
								player.setDie(False)
								
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
							ElseIf (lifeNum > 0) Then
								player.setDie(False)
								
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
								
								minusLife()
							Else
								player.setDie(False)
								
								StageManager.setStageGameover()
							EndIf
						EndIf
					ElseIf (stageModeState = STATE_RACE_MODE) Then
						If (timeCount <= BREATHE_TIME_COUNT) Then
							Local t:= (timeCount / 1000)
							
							If (t <> preTimeCount) Then
								' Magic number: 30 (Sound-effect ID)
								SoundSystem.getInstance().playSe(30)
							EndIf
							
							preTimeCount = t
						EndIf
						
						If (timeCount = overTime And player <> Null) Then
							If (stageModeState = STATE_RACE_MODE) Then
								player.setDie(False)
								
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
							ElseIf (lifeNum > 0) Then
								player.setDie(False)
								
								StageManager.setStageTimeover()
								StageManager.checkPointTime = 0
								
								minusLife()
							Else
								player.setDie(False)
								StageManager.setStageGameover()
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		End
		
		Function setTimeCount:Void(min:Int, sec:Int, msec:Int)
			timeCount = (((min * 60) * 1000) + (sec * 1000)) + msec
			lastTimeCount = timeCount
		End
		
		Function setTimeCount:Void(count:Int)
			timeCount = count
			lastTimeCount = timeCount
		End
		
		Function setOverCount:Void(min:Int, sec:Int, msec:Int)
			overTime = (((min * 60) * 1000) + (sec * 1000)) + msec
		End
		
		Function setOverCount:Void(count:Int)
			overTime = count
		End
		
		Function getTimeCount:Int()
			Return timeCount
		End
		
		Function timeDraw:Void(g:MFGraphics, x:Int, y:Int)
			Local min:= (timeCount / 60000)
			Local sec:= (timeCount Mod 60000) / 1000
			Local msec:= ((timeCount Mod 60000) Mod 1000) / 10
			
			Local numType:= 0
			
			If ((GlobalResource.timeIsLimit() Or stageModeState = STATE_RACE_MODE) And (((overTime > timeCount And timeCount > 540000) Or (overTime < timeCount And timeCount < 60000)) And (timeCount / 240) Mod 2 = 0)) Then
				numType = 3
			EndIf
			
			If (msec < 10) Then
				drawNum(g, 0, x - NUM_SPACE[numType], y, 2, numType)
			EndIf
			
			drawNum(g, msec, x, y, 2, numType)
			NumberDrawer.drawColon(g, PickValue((numType = 3), 2, 0), (x - (NUM_SPACE[numType] * 2)) - (NUM_SPACE[numType] / 2), y, 34)
			
			If (sec < 10) Then
				drawNum(g, 0, x - (NUM_SPACE[numType] * 4), y, 2, numType)
			EndIf
			
			drawNum(g, sec, x - (NUM_SPACE[numType] * 3), y, 2, numType)
			NumberDrawer.drawColon(g, PickValue((numType = 3), 2, 0), (x - (NUM_SPACE[numType] * 5)) - (NUM_SPACE[numType] / 2), y, 34)
			drawNum(g, min, x - (NUM_SPACE[numType] * 6), y, 2, numType)
		End
		
		Function drawRecordTime:Void(g:MFGraphics, timeCount:Int, x:Int, y:Int, numType:Int, anchor:Int)
			Local min:= timeCount / 60000
			Local sec:= (timeCount Mod 60000) / 1000
			
			timeCount = ((timeCount Mod 60000) Mod 1000) / 100
			
			Select (anchor)
				Case 0
					x += (NUM_SPACE[numType] * 7) / 2
				Case 1
					x += NUM_SPACE[numType] * 7
			End Select
			
			If (timeCount < 10) Then
				drawNum(g, 0, x - NUM_SPACE[numType], y, 2, numType)
			EndIf
			
			drawNum(g, timeCount, x, y, 2, numType)
			NumberDrawer.drawColon(g, 3, (x - (NUM_SPACE[numType] * 2)) - (NUM_SPACE[numType] / 2), y, 34)
			
			If (sec < 10) Then
				drawNum(g, 0, x - (NUM_SPACE[numType] * 4), y, 2, numType)
			EndIf
			
			drawNum(g, sec, x - (NUM_SPACE[numType] * 3), y, 2, numType)
			NumberDrawer.drawColon(g, 3, (x - (NUM_SPACE[numType] * 5)) - (NUM_SPACE[numType] / 2), y, 34)
			drawNum(g, min, x - (NUM_SPACE[numType] * 6), y, 2, numType)
		End
	
		Function drawRecordTimeTotalYellow:Void(g:MFGraphics, timeCount:Int, x:Int, y:Int, numType:Int, anchor:Int)
			Local min:= timeCount / 60000
			Local sec:= (timeCount Mod 60000) / 1000
			
			timeCount = ((timeCount Mod 60000) Mod 1000) / 10
			
			Select (anchor)
				Case 0
					x += (NUM_SPACE[numType] * 7) / 2
				Case 1
					x += NUM_SPACE[numType] * 7
			End Select
			
			If (timeCount < 10) Then
				drawNum(g, 0, x - NUM_SPACE[numType], y, 2, numType)
			EndIf
			
			drawNum(g, timeCount, x, y, 2, numType)
			NumberDrawer.drawColon(g, 0, (x - (NUM_SPACE[numType] * 2)) - (NUM_SPACE[numType] / 2), y, 34)
			
			If (sec < 10) Then
				drawNum(g, 0, x - (NUM_SPACE[numType] * 4), y, 2, numType)
			EndIf
			
			drawNum(g, sec, x - (NUM_SPACE[numType] * 3), y, 2, numType)
			NumberDrawer.drawColon(g, 0, (x - (NUM_SPACE[numType] * 5)) - (NUM_SPACE[numType] / 2), y, 34)
			drawNum(g, min, x - (NUM_SPACE[numType] * 6), y, 2, numType)
		End
		
		Function drawRecordTimeLeft:Void(g:MFGraphics, timeCount:Int, x:Int, y:Int)
			drawRecordTimeTotalYellow(g, timeCount, x, y, 0, 1)
			
			MyAPI.setBmfColor(0)
		End
		
		Function initMovingBar:Void()
			offsetx = SCREEN_WIDTH
			offsety = (SCREEN_HEIGHT / 2) + HURT_COUNT
			
			' Magic number: 12, 36, 34, 35
			If (StageManager.getStageID() >= 12) Then
				passStageActionID = (StageManager.getStageID() - 12) + 36
			ElseIf (StageManager.getStageID() Mod 2 = 0) Then
				passStageActionID = 34
			ElseIf (StageManager.getStageID() Mod 2 = 1) Then
				passStageActionID = 35
			EndIf
		End
	Private
		' Functions:
		Function drawStaticAni:Void(g:MFGraphics, aniId:Int, x:Int, y:Int)
			numDrawer.setActionId(aniId)
			
			numDrawer.draw(g, x, y)
		End
	
		Function drawStagePassInfoScroll:Void(g:MFGraphics, y:Int, speed:Int, space:Int)
			State.drawBar(g, 2, y)
			
			itemOffsetX -= speed
			itemOffsetX Mod= space
			
			' Magic number: 294
			Local x1:= (itemOffsetX - 294)
			
			While (x1 < (SCREEN_WIDTH * 2))
				GameState.stageInfoAniDrawer.draw(g, getCharacterID() + 29, x1, (y - 10) + 2, False, 0)
				GameState.stageInfoAniDrawer.draw(g, 34, x1, (y - 10) + 2, False, 0)
				GameState.stageInfoAniDrawer.draw(g, passStageActionID, x1, (y - 10) + 2, False, 0)
				
				x1 += space
			Wend
		End
		
		Function drawStagePassInfoScroll:Void(g:MFGraphics, offset_x:Int, y:Int, speed:Int, space:Int)
			If (isbarOut) Then
				State.drawBar(g, 2, offset_x, y)
				State.drawBar(g, 2, SCREEN_WIDTH + offset_x, y)
				State.drawBar(g, 2, (SCREEN_WIDTH * 2) + offset_x, y)
			Else
				State.drawBar(g, 2, y)
			EndIf
			
			If (offset_x = 0) Then
				itemOffsetX -= speed
				itemOffsetX Mod= space
			EndIf
			
			Local x1:= (itemOffsetX - 294)
			
			While (x1 < (SCREEN_WIDTH * 2))
				GameState.stageInfoAniDrawer.draw(g, getCharacterID() + ANI_WIND_JUMP, x1 + offset_x, (y - 10) + 2, False, 0)
				GameState.stageInfoAniDrawer.draw(g, 34, x1 + offset_x, (y - 10) + 2, False, 0)
				GameState.stageInfoAniDrawer.draw(g, passStageActionID, x1 + offset_x, (y - 10) + 2, False, 0)
				
				x1 += space
			Wend
		End
		
		Function drawMovingbar:Void(g:MFGraphics, space:Int)
			State.drawBar(g, 2, offsetx - BACKGROUND_WIDTH, offsety)
			State.drawBar(g, 2, (offsetx - BACKGROUND_WIDTH) + SCREEN_WIDTH, offsety)
			
			Local drawNum:= (((SCREEN_WIDTH + space) - 1) / space) + 2
			
			For Local I:= 0 Until drawNum
				Local x2:= (offsetx + (I * space))
				
				GameState.stageInfoAniDrawer.draw(g, getCharacterID() + ANI_WIND_JUMP, x2, (offsety - 10) + 2, False, 0)
				GameState.stageInfoAniDrawer.draw(g, 33, x2, (offsety - 10) + 2, False, 0)
				GameState.stageInfoAniDrawer.draw(g, passStageActionID, x2, (offsety - 10) + 2, False, 0)
			Next
		End
		
		Function isRaceModeNewRecord:Bool()
			Return (timeCount < StageManager.getTimeModeScore(characterID))
		End
		
		Function playerLifeUpBGM:Void()
			SoundSystem.getInstance().stopBgm(False)
			
			' Magic numbers: 43, 44
			If (invincibleCount > 0) Then
				SoundSystem.getInstance().playBgmSequence(43, 44)
			Else
				SoundSystem.getInstance().playBgmSequence(43, StageManager.getBgmId())
			EndIf
		End
		
		' Methods:
		Method checkCliffAnimation:Void()
			Local footLeftX:= ACUtilities.getRelativePointX(Self.posX, LEFT_FOOT_OFFSET_X, 0, Self.faceDegree)
			Local footLeftY:= ACUtilities.getRelativePointY(Self.posY, LEFT_FOOT_OFFSET_X, Self.worldInstance.getTileHeight(), Self.faceDegree)
			
			Local footCenterX:= ACUtilities.getRelativePointX(Self.posX, 0, 0, Self.faceDegree)
			Local footCenterY:= ACUtilities.getRelativePointY(Self.posY, 0, Self.worldInstance.getTileHeight(), Self.faceDegree)
			
			Local footRightX:= ACUtilities.getRelativePointX(Self.posX, SIDE_FOOT_FROM_CENTER, 0, Self.faceDegree)
			Local footRightY:= ACUtilities.getRelativePointY(Self.posY, SIDE_FOOT_FROM_CENTER, Self.worldInstance.getTileHeight(), Self.faceDegree)
			
			Select (Self.collisionState)
				Case COLLISION_STATE_WALK
					If (Self.worldInstance.getWorldY(footCenterX, footCenterY, Self.currentLayer, Self.worldCal.getDirectionByDegree(Self.faceDegree)) = ACParam.NO_COLLISION) Then
						If (Self.worldInstance.getWorldY(footLeftX, footLeftY, Self.currentLayer, Self.worldCal.getDirectionByDegree(Self.faceDegree)) <> ACParam.NO_COLLISION) Then
							If (Self.faceDirection) Then
								Self.animationID = ANI_CLIFF_1
							Else
								Self.animationID = ANI_CLIFF_2
							EndIf
						ElseIf (Self.worldInstance.getWorldY(footRightX, footRightY, Self.currentLayer, Self.worldCal.getDirectionByDegree(Self.faceDegree)) = ACParam.NO_COLLISION) Then
							' Nothing so far.
						Else
							If (Self.faceDirection) Then
								Self.animationID = ANI_CLIFF_2
							Else
								Self.animationID = ANI_CLIFF_1
							EndIf
						EndIf
					EndIf
				Case COLLISION_STATE_ON_OBJECT
					If (Self.footOnObject = Null) Then
						Return
					EndIf
					
					If (footCenterX < Self.footOnObject.collisionRect.x0) Then
						If (Self.faceDirection) Then
							Self.animationID = ANI_CLIFF_2
						Else
							Self.animationID = ANI_CLIFF_1
						EndIf
					ElseIf (footCenterX <= Self.footOnObject.collisionRect.x1) Then
						' Nothing so far.
					Else
						
						If (Self.faceDirection) Then
							Self.animationID = ANI_CLIFF_1
						Else
							Self.animationID = ANI_CLIFF_2
						EndIf
					EndIf
				Default
					' Nothing so far.
			End Select
		End
		
		Method aspirating:Void()
			'Local i:= (Self.breatheCount Mod 3)
		End
	Public
		' Functions:
		Function stagePassLogic:Void()
			#Rem
				Select (stageModeState)
					' Nothing so far.
				End Select
			#End
		End
		
		Function isHadRaceRecord:Bool()
			Return (StageManager.getTimeModeScore(characterID) < sonicdef.OVER_TIME)
		End
	
		Function movingBar:Bool()
			If (offsetx <= 0) Then
				offsetx = 0
			Else
				offsetx -= movespeedx
				
				' Magic numbers:
				If (offsetx = SCREEN_WIDTH - movespeedx) Then
					If (stageModeState = STATE_RACE_MODE) Then
						If (isRaceModeNewRecord()) Then
							SoundSystem.getInstance().playBgm(41, False)
						Else
							SoundSystem.getInstance().playBgm(42, False)
						EndIf
					ElseIf (StageManager.getStageID() = 13) Then
						SoundSystem.getInstance().playBgm(28, False)
					ElseIf (StageManager.getStageID() = 13) Then
						SoundSystem.getInstance().playBgm(29, False)
					Else
						If (StageManager.getStageID() Mod 2 = 0) Then
							SoundSystem.getInstance().playBgm(26, False)
						EndIf
						
						If (StageManager.getStageID() Mod 2 = 1) Then
							SoundSystem.getInstance().playBgm(27, False)
						EndIf
					EndIf
				EndIf
			EndIf
			
			If (offsetx <> 0) Then
				Return False
			EndIf
			
			If (offsety <= (SCREEN_HEIGHT / 2) - 36) Then
				offsety = (SCREEN_HEIGHT / 2) - 36
				
				Return True
			EndIf
			
			offsety -= movespeedy
			
			Return False
		End
	
		Function clipMoveInit:Void(startx:Int, starty:Int, startw:Int, endw:Int, height:Int)
			clipx = startx
			clipy = starty
			clipstartw = startw
			clipendw = endw
			cliph = height
		End
		
		Function clipMoveLogic:Bool()
			If (clipstartw < clipendw) Then
				clipstartw += clipspeed
				
				Return False
			EndIf
			
			clipstartw = clipendw
			
			Return True
		End
		
		Function clipMoveShadow:Void(g:MFGraphics)
			MyAPI.setClip(g, clipx, 0, clipstartw, SCREEN_HEIGHT)
		End
		
		Function calculateScore:Void()
			' Magic number: 10 (Stage ID)
			If (StageManager.getStageID() = 10) Then
				Print("timeCount=" + timeCount)
				
				If (timeCount > 192000) Then
					score1 = 1000
				ElseIf (timeCount > 192000 Or timeCount <= 132000) Then
					score1 = 0
				Else
					score1 = BANKING_MIN_SPEED
				EndIf
				
				score2 = ringNum * 100
				
				Return
			EndIf
			
			If (timeCount < 50000) Then
				score1 = 50000
			ElseIf (timeCount >= 50000 And timeCount < 60000) Then
				score1 = 10000
			ElseIf (timeCount >= 60000 And timeCount < 90000) Then
				score1 = 5000
			ElseIf (timeCount >= 90000 And timeCount < 120000) Then
				score1 = 4000
			ElseIf (timeCount >= 120000 And timeCount < 180000) Then
				score1 = 3000
			ElseIf (timeCount >= 180000 And timeCount < 240000) Then
				score1 = 2000
			ElseIf (timeCount >= 240000 And timeCount < 300000) Then
				score1 = 1000
			ElseIf (timeCount < 300000 Or timeCount >= 360000) Then
				score1 = 0
			Else
				score1 = 500
			EndIf
			
			score2 = ringNum * 100
		End
		
		Function stagePassDraw:Void(g:MFGraphics)
			If (Not StageManager.isOnlyStagePass) Then
				Select (stageModeState)
					Case STATE_NORMAL_MODE
						If (movingBar()) Then
							drawStagePassInfoScroll(g, stagePassResultOutOffsetX, (SCREEN_HEIGHT / 2) - SPIN_LV2_COUNT_CONF, ANI_PUSH_WALL, SIDE_FOOT_FROM_CENTER)
							
							If (Not clipMoveLogic()) Then
								clipMoveShadow(g)
								
								GameState.guiAniDrawer.draw(g, 6, (SCREEN_WIDTH / 2) - 70, (SCREEN_HEIGHT / 2) - 6, False, 0)
								GameState.guiAniDrawer.draw(g, 7, (SCREEN_WIDTH / 2) - 70, ((SCREEN_HEIGHT / 2) + MENU_SPACE) - 6, False, 0)
								
								drawNum(g, score1, (SCREEN_WIDTH / 2) + NUM_DISTANCE, SCREEN_HEIGHT / 2, 2, 0)
								drawNum(g, score2, (SCREEN_WIDTH / 2) + NUM_DISTANCE, (SCREEN_HEIGHT / 2) + MENU_SPACE, 2, 0)
								
								MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
								totalPlusscore = (score1 + score2) + scoreNum
							EndIf
						Else
							drawMovingbar(g, STAGE_PASS_STR_SPACE)
							
							stagePassResultOutOffsetX = 0
							isStartStageEndFlag = False
							stageEndFrameCnt = 0
							isOnlyBarOut = False
						EndIf
						
						If (clipMoveLogic()) Then
							GameState.guiAniDrawer.draw(g, 6, stagePassResultOutOffsetX + ((SCREEN_WIDTH / 2) - 70), (SCREEN_HEIGHT / 2) - 6, False, 0)
							GameState.guiAniDrawer.draw(g, 7, stagePassResultOutOffsetX + ((SCREEN_WIDTH / 2) - 70), ((SCREEN_HEIGHT / 2) + MENU_SPACE) - 6, False, 0)
							
							If (stageModeState = STATE_RACE_MODE) Then
								raceScoreNum = MyAPI.calNextPosition(Double(raceScoreNum), Double(totalPlusscore), 1, 5)
							Else
								scoreNum = MyAPI.calNextPosition(Double(scoreNum), Double(totalPlusscore), 1, 5)
							EndIf
							
							score1 = MyAPI.calNextPosition(Double(score1), 0.0, 1, 5)
							score2 = MyAPI.calNextPosition(Double(score2), 0.0, 1, 5)
							
							drawNum(g, score1, ((SCREEN_WIDTH / 2) + NUM_DISTANCE) + stagePassResultOutOffsetX, SCREEN_HEIGHT / 2, 2, 0)
							drawNum(g, score2, ((SCREEN_WIDTH / 2) + NUM_DISTANCE) + stagePassResultOutOffsetX, (SCREEN_HEIGHT / 2) + MENU_SPACE, 2, 0)
							
							If (scoreNum = totalPlusscore) Then
								IsStarttoCnt = True
								
								If (StageManager.isOnlyScoreCal) Then
									isOnlyBarOut = True
								Else
									isStartStageEndFlag = True
								EndIf
							Else
								SoundSystem.getInstance().playSe(31)
							EndIf
						EndIf
						
						If (isStartStageEndFlag) Then
							stageEndFrameCnt += 1
							
							If (stageEndFrameCnt = 2) Then
								SoundSystem.getInstance().playSe(32)
							EndIf
						EndIf
						
						If (isOnlyBarOut) Then
							onlyBarOutCnt += 1
							
							If (onlyBarOutCnt = 2) Then
								SoundSystem.getInstance().playSe(32)
							EndIf
							
							If (onlyBarOutCnt > onlyBarOutCntMax) Then
								stagePassResultOutOffsetX -= 96
							EndIf
							
							If (stagePassResultOutOffsetX < ACParam.NO_COLLISION) Then
								StageManager.isScoreBarOutOfScreen = True
							EndIf
						EndIf
					Case STATE_RACE_MODE
						If (movingBar()) Then
							drawStagePassInfoScroll(g, (SCREEN_HEIGHT / 2) - SPIN_LV2_COUNT_CONF, ANI_PUSH_WALL, SIDE_FOOT_FROM_CENTER)
							
							If (clipMoveLogic()) Then
								IsStarttoCnt = True
							EndIf
							
							clipMoveShadow(g)
							GameState.guiAniDrawer.draw(g, ANI_PUSH_WALL, (SCREEN_WIDTH / 2) - BACKGROUND_WIDTH, SCREEN_HEIGHT / 2, False, 0)
							drawRecordTime(g, timeCount, (SCREEN_WIDTH / 2) + NUM_DISTANCE_BIG, (SCREEN_HEIGHT / 2) + 7, 2, 2)
							
							MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
							
							If (isRaceModeNewRecord() And IsStarttoCnt And Not StageManager.isSaveTimeModeScore) Then
								IsDisplayRaceModeNewRecord = True
							EndIf
							
							If (IsDisplayRaceModeNewRecord) Then
								GameState.guiAniDrawer.draw(g, ANI_ROTATE_JUMP, SCREEN_WIDTH / 2, (SCREEN_HEIGHT / 2) + ANI_BANK_2, False, 0)
							EndIf
							
							If (Not StageManager.isSaveTimeModeScore And IsStarttoCnt) Then
								StageManager.setTimeModeScore(characterID, timeCount)
								StageManager.isSaveTimeModeScore = True
							EndIf
						Else
							drawMovingbar(g, STAGE_PASS_STR_SPACE) ' 182
						EndIf
				End Select
			EndIf
		End
		
		Function gamepauseInit:Void()
			cursor = 0
			cursorIndex = 0
			
			Key.touchkeygameboardClose()
		End
		
		Function gamepauseDraw:Void(g:MFGraphics)
			PAUSE_MENU_NORMAL_ITEM = PAUSE_MENU_NORMAL_NOSHOP
			
			State.fillMenuRect(g, (SCREEN_WIDTH / 2) + PAUSE_FRAME_OFFSET_X, (SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y, PAUSE_FRAME_WIDTH, PAUSE_FRAME_HEIGHT)
			State.drawMenuFontById(g, BACKGROUND_WIDTH, SCREEN_WIDTH / 2, (((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2)) + 10)
			
			If (stageModeState = STATE_NORMAL_MODE) Then
				currentPauseMenuItem = PAUSE_MENU_NORMAL_ITEM
			Else
				currentPauseMenuItem = PAUSE_MENU_RACE_ITEM
			EndIf
			
			If (currentPauseMenuItem.Length <= 4) Then
				cursorIndex = 0
			ElseIf (cursorIndex > cursor) Then
				cursorIndex = cursor
			ElseIf ((cursorIndex + 4) - 1 < cursor) Then
				cursorIndex = (cursor - 4) + 1
			EndIf
			
			State.drawMenuFontById(g, 119, SCREEN_WIDTH / 2, (((((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + 10) + (MENU_SPACE / 2)) + MENU_SPACE) + (MENU_SPACE * (cursor - cursorIndex)))
			State.drawMenuFontById(g, 113, ((SCREEN_WIDTH / 2) - 56) - 0, (((((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + 10) + (MENU_SPACE / 2)) + MENU_SPACE) + (MENU_SPACE * (cursor - cursorIndex)))
			
			For Local I:= cursorIndex Until (cursorIndex + 4) ' currentPauseMenuItem.Length
				State.drawMenuFontById(g, currentPauseMenuItem[I], SCREEN_WIDTH / 2, (((((SCREEN_HEIGHT / 2) + PAUSE_FRAME_OFFSET_Y) + 10) + (MENU_SPACE / 2)) + MENU_SPACE) + (MENU_SPACE * (I - cursorIndex)))
			Next
			
			If (currentPauseMenuItem.Length > 4) Then
				If (cursorIndex = 0) Then
					State.drawMenuFontById(g, 96, SCREEN_WIDTH / 2, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
					
					GameState.IsSingleUp = False
					GameState.IsSingleDown = True
				ElseIf (cursorIndex = currentPauseMenuItem.Length - 4) Then
					State.drawMenuFontById(g, 95, SCREEN_WIDTH / 2, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
					
					GameState.IsSingleUp = True
					GameState.IsSingleDown = False
				Else
					State.drawMenuFontById(g, 95, (SCREEN_WIDTH / 2) - ANI_BAR_ROLL_2, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
					State.drawMenuFontById(g, 96, (SCREEN_WIDTH / 2) + ANI_BAR_ROLL_1, ((SCREEN_HEIGHT / 2) - PAUSE_FRAME_OFFSET_Y) + (MENU_SPACE / 2))
					
					GameState.IsSingleUp = False
					GameState.IsSingleDown = False
				EndIf
			EndIf
			
			State.drawSoftKey(g, True, True)
		End
		
		Function doWhileQuitGame:Void()
			bariaDrawer = Null
			gBariaDrawer = Null
			invincibleAnimation = Null
			invincibleDrawer = Null
		End
		
		Function IsInvincibility:Bool()
			If (invincibleCount > 0) Then
				Return True
			EndIf
			
			Return False
		End
		
		' This was not a typo on my part...
		Function IsUnderSheild:Bool()
			If (shieldType = 2) Then
				Return True
			EndIf
			
			Return False
		End
		
		Function IsSpeedUp:Bool()
			If (speedCount > 0) Then
				Return True
			EndIf
			
			Return False
		End
		
		' Methods:
		Method setAntiGravity:Void()
			Self.isAntiGravity = Not Self.isAntiGravity
			
			' Magic number: 1 (Action-state)
			Self.worldCal.actionState = 1
			
			Self.collisionState = COLLISION_STATE_JUMP
			
			Self.faceDirection = Not Self.faceDirection
			
			Local bodyCenterX:= getNewPointX(Self.posX, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
			Local bodyCenterY:= getNewPointY(Self.posY, 0, (-Self.collisionRect.getHeight()) / 2, Self.faceDegree)
			
			Self.faceDegree = PickValue(Self.isAntiGravity, 180, 0)
			
			Local x:= getNewPointX(bodyCenterX, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
			
			Self.footPointX = x
			Self.posX = x
			
			Local y:= getNewPointY(bodyCenterY, 0, Self.collisionRect.getHeight() / 2, Self.faceDegree)
			
			Self.footPointY = y
			Self.posY = y
		End
		
		Method setAntiGravity:Void(GraFlag:Bool)
			Self.orgGravity = Self.isAntiGravity
			Self.isAntiGravity = GraFlag
			
			If (Self.orgGravity <> Self.isAntiGravity) Then
				' Magic number: 1 (Action-state)
				Self.worldCal.actionState = 1
				
				Self.collisionState = COLLISION_STATE_JUMP
				Self.faceDirection = Not Self.faceDirection
				
				Self.faceDegree = PickValue(Self.isAntiGravity, 180, 0)
			EndIf
		End
		
		Method doWhileTouchWorld:Void(direction:Int, degree:Int)
			' Magic numbers: 1, 0, ... ("Action states")
			If (Self.worldCal.getActionState() = 1) Then
				Select (direction)
					Case DIRECTION_UP
						If (Self.collisionState = COLLISION_STATE_ON_OBJECT And Self.movedSpeedY < 0) Then
							setDie(False)
						EndIf
					Case DIRECTION_DOWN
						If (Self.isAntiGravity) Then
							Self.leftStopped = True
						Else
							Self.rightStopped = True
						EndIf
						
						If (Self.leftStopped And Self.rightStopped) Then
							setDie(False)
							
							Return
						EndIf
					Case DIRECTION_RIGHT
						If (Self.isAntiGravity) Then
							Self.rightStopped = True
						Else
							Self.leftStopped = True
						EndIf
						
						If (Self.leftStopped And Self.rightStopped) Then
							setDie(False)
							
							Return
						EndIf
				End Select
			EndIf
			
			If (Self.worldCal.getActionState() = 0 Or Self.collisionState = COLLISION_STATE_ON_OBJECT) Then
				Select (direction)
					Case DIRECTION_UP
						If (Self.collisionState = TER_STATE_LOOK_MOON And Self.movedSpeedY < 0) Then
							setDie(False)
							
							Return
						EndIf
					Case DIRECTION_DOWN
						If (Not Self.speedLock) Then
							Self.totalVelocity = 0
						EndIf
						
						If (Self.isAntiGravity) Then
							Self.leftStopped = True
						Else
							Self.rightStopped = True
						EndIf
						
						If (Self.leftStopped And Self.rightStopped) Then
							setDie(False)
							
							Return
						ElseIf ((Key.repeated(Key.gRight) And Not Self.isAntiGravity) Or (Key.repeated(Key.gLeft) And Self.isAntiGravity)) Then
							If (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = ANI_CLIFF_2 Or Self.animationID = ANI_RUN_1 Or Self.animationID = ANI_RUN_2 Or Self.animationID = ANI_RUN_3) Then
								Self.animationID = ANI_PUSH_WALL
							EndIf
						EndIf
					Case DIRECTION_RIGHT
						If (Not Self.speedLock) Then
							Self.totalVelocity = 0
						EndIf
						
						If (Self.isAntiGravity) Then
							Self.rightStopped = True
						Else
							Self.leftStopped = True
						EndIf
						
						If (Self.leftStopped And Self.rightStopped) Then
							setDie(False)
							
							Return
						ElseIf ((Key.repeated(Key.gLeft) And Not Self.isAntiGravity) Or (Key.repeated(Key.gRight) And Self.isAntiGravity)) Then
							If (Self.animationID = ANI_STAND Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = ANI_CLIFF_2 Or Self.animationID = ANI_RUN_1 Or Self.animationID = ANI_RUN_2 Or Self.animationID = ANI_RUN_3) Then
								Self.animationID = ANI_PUSH_WALL
							EndIf
						EndIf
				End Select
			EndIf
		End
		
		Method getBodyDegree:Int()
			Return Self.worldCal.footDegree
		End
		
		Method getBodyOffset:Int()
			Return BODY_OFFSET
		End
		
		Method getFootOffset:Int()
			Return SIDE_FOOT_FROM_CENTER
		End
		
		Method getFootX:Int()
			Return Self.posX
		End
		
		Method getFootY:Int()
			Return Self.posY
		End
		
		Method getPressToGround:Int()
			Return (GRAVITY * 2)
		End
		
		Method didAfterEveryMove:Void(x:Int, y:Int)
			player.moveDistance.x = x
			player.moveDistance.y = y
			
			Self.footPointX = Self.posX
			Self.footPointY = Self.posY
			
			collisionCheckWithGameObject()
			
			Self.posZ = Self.currentLayer
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
		
		Method doWhileLeaveGround:Void()
			calDivideVelocity()
			
			Self.collisionState = COLLISION_STATE_JUMP
			
			If (isTerminal And terminalState >= TER_STATE_CHANGE_1) Then
				Self.collisionState = COLLISION_STATE_NONE
			EndIf
		End
		
		Method doWhileLand:Void(degree:Int)
			Self.faceDegree = degree
			
			land()
			
			If (Self.footOnObject <> Null) Then
				Self.worldCal.stopMove()
				
				Self.footOnObject = Null
			EndIf
			
			Self.collisionState = TER_STATE_RUN
			Self.isSidePushed = 4
			
			'''Print("~~~~velx:" + (Self.velX Shr 6))
		End
		
		Method getMinDegreeToLeaveGround:Int()
			Return ANI_DEAD_PRE
		End
		
		Method stopMove:Void()
			Self.worldCal.stopMove()
		End
		
		Method getCal:ACWorldCollisionCalculator()
			Return Self.worldCal
		End
		
		Method getDegreeDiff:Int(degree1:Int, degree2:Int)
			Local re:= Abs(degree1 - degree2)
			
			If (re > 180) Then
				re = 360 - re
			EndIf
			
			If (re > 90) Then
				Return 180 - re
			EndIf
			
			Return re
		End
	Protected
		' Methods:
		Method extraLogicJump:Void()
			' Empty implementation.
		End
		
		Method extraLogicWalk:Void()
			' Empty implementation.
		End
		
		Method extraLogicOnObject:Void()
			' Empty implementation.
		End
		
		Method extraInputLogic:Void()
			' Empty implementation.
		End
		
		Method spinLogic:Bool()
			If (Not (Key.repeated(Key.gLeft) Or Key.repeated(Key.gRight) Or isTerminal Or Self.animationID = ANI_NONE Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = ANI_CLIFF_2)) Then
				If (Key.repeated(Key.gDown)) Then
					' Magic number: 64 (Velocity; X)
					If (Abs(getVelX()) > 64 Or getDegreeDiff(Self.faceDegree, Self.degreeStable) > ANI_DEAD_PRE) Then
						If (Not (Self.animationID = ANI_JUMP Or characterID = CHARACTER_AMY Or Self.isCrashFallingSand)) Then
							soundInstance.playSe(4)
						EndIf
						
						Self.animationID = ANI_JUMP
					Else
						If (Self.animationID <> ANI_SQUAT) Then
							Self.animationID = ANI_SQUAT_PROCESS
						EndIf
						
						If (Self.collisionState = COLLISION_STATE_IN_SAND) Then
							If (characterID = CHARACTER_AMY) Then
								Self.dashRolling = True
								Self.spinDownWaitCount = 0
								
								If (characterID <> CHARACTER_AMY) Then
									soundInstance.playSe(4)
								EndIf
							EndIf
						ElseIf (Key.press(Key.B_HIGH_JUMP | Key.gUp)) Then
							Self.dashRolling = True
							Self.spinDownWaitCount = 0
							
							If (characterID <> CHARACTER_AMY) Then
								' Magic number: 4 (Sound-effect ID)
								soundInstance.playSe(4)
							EndIf
						EndIf
						
						If (Not Self.dashRolling) Then
							Self.focusMovingState = FOCUS_MOVING_DOWN
						EndIf
					EndIf
				ElseIf (Self.animationID = ANI_SQUAT) Then
					Self.animationID = ANI_SQUAT_PROCESS
				EndIf
			EndIf
			
			If (Self.animationID = ANI_STAND And getDegreeDiff(Self.faceDegree, Self.degreeStable) <= ANI_DEAD_PRE) Then
				If (Key.press(Key.B_SPIN2)) Then
					Self.dashRolling = True
					
					If (characterID <> CHARACTER_AMY) Then
						' Magic number: 4 (Sound-effect ID)
						soundInstance.playSe(4)
					EndIf
					
					Self.spinCount = SPIN_LV2_COUNT
					Self.spinKeyCount = SPIN_KEY_COUNT
				ElseIf (Key.press(Key.B_7)) Then
					Self.faceDirection = False
					Self.dashRolling = True
					
					Self.spinKeyCount = SPIN_KEY_COUNT
					
					If (characterID <> CHARACTER_AMY) Then
						' Magic number: 4 (Sound-effect ID)
						soundInstance.playSe(4)
					EndIf
					
					Self.spinCount = SPIN_LV2_COUNT
				ElseIf (Key.press(Key.B_9)) Then
					Self.faceDirection = True
					Self.dashRolling = True
					
					Self.spinKeyCount = SPIN_KEY_COUNT
					
					If (characterID <> CHARACTER_AMY) Then
						' Magic number: 4 (Sound-effect ID)
						soundInstance.playSe(4)
					EndIf
					
					Self.spinCount = SPIN_LV2_COUNT
				EndIf
			EndIf
			
			Return Self.dashRolling
		End
		
		Method spinLogic2:Bool()
			If (Not (Key.repeated(Key.gLeft) Or Key.repeated(Key.gRight) Or isTerminal Or Self.animationID = ANI_NONE Or Self.animationID = ANI_CLIFF_1 Or Self.animationID = ANI_CLIFF_2)) Then
				If (Key.repeated(Key.gDown)) Then
					If (getDegreeDiff(Self.faceDegree, Self.degreeStable) <= ANI_DEAD_PRE And Self.animationID <> ANI_SQUAT) Then
						Self.animationID = ANI_SQUAT_PROCESS
					EndIf
				ElseIf (Self.animationID = ANI_SQUAT) Then
					Self.animationID = ANI_SQUAT_PROCESS
				EndIf
			EndIf
			
			Return Self.dashRolling
		End
	Public
		' Functions:
		Function getRingNum:Int()
			Return ringNum
		End
		
		Function setRingNum:Void(rNum:Int)
			ringNum = rNum
		End
		
		Function setFadeColor:Void(color:Int)
			For Local i:= 0 Until fadeRGB.Length
				fadeRGB[i] = color
			Next
		End
		
		Function fadeInit:Void(from:Int, dest:Int)
			fadeFromValue = from
			fadeAlpha = fadeFromValue
			fadeToValue = dest
			
			preFadeAlpha = -1
		End
		
		' This needs to be reimplemented.
		Function drawFadeBase:Void(g:MFGraphics, vel2:Int)
			fadeAlpha = MyAPI.calNextPosition(Double(fadeAlpha), Double(fadeToValue), 1, vel2, 3.0)
			
			If (fadeAlpha <> 0) Then
				Local w:Int, h:Int
				
				If (preFadeAlpha <> fadeAlpha) Then
					For Local w:= 0 Until FADE_FILL_WIDTH
						For Local h:= 0 Until FADE_FILL_WIDTH
							fadeRGB[(h * FADE_FILL_WIDTH) + w] = ((fadeAlpha Shl ANI_PULL) & -16777216) | (fadeRGB[(h * FADE_FILL_WIDTH) + w] & MapManager.END_COLOR)
						Next
					Next
					
					preFadeAlpha = fadeAlpha
				EndIf
				
				For Local w:= 0 Until MyAPI.zoomOut(SCREEN_WIDTH) Step FADE_FILL_WIDTH
					For Local h:= 0 Until MyAPI.zoomOut(SCREEN_HEIGHT) Step FADE_FILL_WIDTH
						g.drawRGB(fadeRGB, 0, FADE_FILL_WIDTH, w, h, FADE_FILL_WIDTH, FADE_FILL_WIDTH, True)
					Next
				Next
			EndIf
		End
		
		Function fadeChangeOver:Bool()
			Return (fadeAlpha = fadeToValue)
		End
		
		' Methods:
		Method setCliffAnimation:Void()
			If (Self.faceDirection) Then
				Self.animationID = ANI_CLIFF_2
			Else
				Self.animationID = ANI_CLIFF_1
			EndIf
			
			Self.drawer.restart()
		End
		
		Method dashRollingLogicCheck:Void()
			If (Self.dashRolling) Then
				dashRollingLogic()
			ElseIf (Self.effectID = EFFECT_SAND_1 Or Self.effectID = EFFECT_SAND_2) Then
				Self.effectID = EFFECT_NONE
			EndIf
		End
		
		Method getCharacterAnimationID:Int()
			Return Self.myAnimationID
		End
		
		Method setCharacterAnimationID:Void(aniID:Int)
			Self.myAnimationID = aniID
		End
		
		Method getGravity:Int()
			If (Self.isInWater) Then
				Return ((GRAVITY * 3) / 5)
			EndIf
			
			Return GRAVITY
		End
		
		Method doBreatheBubble:Bool()
			If (Self.collisionState <> COLLISION_STATE_JUMP) Then
				Return False
			EndIf
			
			resetBreatheCount()
			
			Self.animationID = ANI_BREATHE
			
			If (characterID = CHARACTER_TAILS) Then
				' Optimization potential; dynamic cast.
				' Unsafe, but it works:
				Local tails:= PlayerTails(player)
				
				tails.flyCount = 0
			EndIf
			
			Self.velX = 0
			Self.velY = 0
			
			Return True
		End
	
		Method resetBreatheCount:Void()
			Self.breatheCount = 0
			Self.breatheNumCount = -1
			Self.preBreatheNumCount = -1
		End
		
		Method checkBreatheReset:Void()
			If (getNewPointY(Self.posY, 0, -Self.collisionRect.getHeight(), Self.faceDegree) + SIDE_FOOT_FROM_CENTER < (StageManager.getWaterLevel() Shl 6)) Then
				resetBreatheCount()
			EndIf
		End
		
		Method waitingChk:Void()
			If (Key.repeated(((((Key.gSelect | Key.gLeft) | Key.gRight) | Key.gDown) | Key.gUp) | Key.B_HIGH_JUMP) Or Not (Self.animationID = ANI_STAND Or Self.animationID = ANI_WAITING_1 Or Self.animationID = ANI_WAITING_2)) Then
				Self.waitingCount = 0
				Self.waitingLevel = 0
				
				Self.isResetWaitAni = True
				
				Return
			EndIf
			
			Self.waitingCount += 1
			
			' Magic number: 96
			If (Self.waitingCount > 96) Then
				If (Self.waitingLevel = 0) Then
					Self.animationID = ANI_WAITING_1
				EndIf
				
				If ((Self.drawer.checkEnd() And Self.waitingLevel = 0) Or Self.waitingLevel = 1) Then
					Self.waitingLevel = 1
					
					Self.animationID = ANI_WAITING_2
				EndIf
			EndIf
		End
		
		Method drawDrawerByDegree:Void(g:MFGraphics, drawer:AnimationDrawer, aniID:Int, x:Int, y:Int, loop:Bool, degree:Int, mirror:Bool)
			g.saveCanvas()
			
			g.translateCanvas(x, y)
			
			g.rotateCanvas(Float(degree))
			
			drawer.draw(g, aniID, 0, 0, loop, PickValue((Not mirror), 0, 2))
			
			g.restoreCanvas()
		End
		
		Method loseRing:Void(rNum:Int)
			RingObject.hurtRingExplosion(rNum, getBodyPositionX(), getBodyPositionY(), Self.currentLayer, Self.isAntiGravity)
		End
		
		Method beSpSpring:Void(springPower:Int, direction:Int)
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calDivideVelocity()
			EndIf
			
			Self.velY = -springPower
			
			Self.worldCal.stopMoveY()
			
			If (Self.collisionState = COLLISION_STATE_WALK) Then
				calTotalVelocity()
			EndIf
			
			Self.faceDegree = Self.degreeStable
			Self.degreeForDraw = Self.degreeStable
			
			Self.animationID = ANI_ROTATE_JUMP
			
			Self.collisionState = COLLISION_STATE_JUMP
			
			' Magic number: 1 ("Action state")
			Self.worldCal.actionState = 1
			
			Self.collisionChkBreak = True
			
			Self.drawer.restart()
			MapManager.setFocusObj(Null)
			setMeetingBoss(False)
			
			Self.animationID = ANI_POP_JUMP_UP
			Self.enteringSP = True
			
			' Magic number: 37 (Sound-effect ID)
			soundInstance.playSe(SoundSystem.SE_148)
		End
		
		Method setStagePassRunOutofScreen:Void()
			MapManager.setFocusObj(Null)
			
			Self.animationID = ANI_RUN_3
		End
		
		Method stagePassRunOutofScreenLogic:Bool()
			' Magic number: 800
			If ((StageManager.isOnlyScoreCal Or Self.footPointX + RIGHT_WALK_COLLISION_CHECK_OFFSET_X <= (((camera.x + SCREEN_WIDTH) + 800) Shl 6)) And (Not isStartStageEndFlag Or stageEndFrameCnt <= BACKGROUND_WIDTH)) Then
				Return False
			EndIf
			
			' Magic number: 96
			stagePassResultOutOffsetX -= 96
			
			Return (stagePassResultOutOffsetX < ACParam.NO_COLLISION)
		End
		
		Method needRetPower:Bool()
			Return ((Not Key.repeated(Key.gLeft | Key.gRight) And Not isTerminalRunRight() And Not Self.isCelebrate) Or Self.animationID = ANI_JUMP Or Self.slipFlag)
		End
		
		Method getRetPower:Int()
			If (Self.animationID = ANI_JUMP) Then
				Return (Self.movePower / 2)
			EndIf
			
			Return Self.movePower
		End
		
		Method getSlopeGravity:Int()
			If (Self.animationID = ANI_JUMP) Then
				Return FAKE_GRAVITY_ON_BALL
			EndIf
			
			Return FAKE_GRAVITY_ON_WALK
		End
		
		Method noRotateDraw:Bool()
			Return (Self.animationID = ANI_STAND Or Self.animationID = ANI_SQUAT Or Self.animationID = ANI_SQUAT_PROCESS Or Self.animationID = ANI_WAITING_1 Or Self.animationID = ANI_WAITING_2 Or Self.animationID = ANI_SPIN_LV1 Or Self.animationID = ANI_SPIN_LV2 Or Self.animationID = ANI_YELL Or Self.animationID = ANI_PUSH_WALL)
		End
		
		Method canDoJump:Bool()
			' This behavior may change in the future. (Currently related to spin-dashing)
			Return (Self.animationID <> ANI_SQUAT)
		End

		Method isBodyCenterOutOfWater:Bool()
			Return (getNewPointY(Self.posY, 0, -Self.collisionRect.getHeight(), Self.faceDegree) < (StageManager.getWaterLevel() Shl 6))
		End
		
		Method dripDownUnderWater:Void()
			' Empty implementation.
		End
		
		Method resetPlayerDegree:Void()
			Self.faceDegree = Self.degreeStable
			Self.degreeForDraw = Self.degreeStable
		End
		
		Method isOnSlip0:Bool()
			Return False
		End
		
		Method setSlip0:Void()
			' Empty implementation.
		End
		
		Method lookUpCheck:Void()
			If (Key.repeated(Key.gUp | Key.B_LOOK)) Then
				If (Self.animationID = ANI_LOOK_UP_1 And Self.drawer.checkEnd()) Then
					Self.animationID = ANI_LOOK_UP_2
				EndIf
				
				If (Not (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2 Or Self.animationID <> ANI_STAND)) Then
					Self.animationID = ANI_LOOK_UP_1
				EndIf
				
				If (Self.animationID = ANI_LOOK_UP_2) Then
					Self.focusMovingState = FOCUS_MOVING_UP
					
					Return
				EndIf
				
				Return
			EndIf
			
			If (Self.animationID = ANI_LOOK_UP_OVER And Self.drawer.checkEnd()) Then
				Self.animationID = ANI_STAND
			EndIf
			
			If (Self.animationID = ANI_LOOK_UP_1 Or Self.animationID = ANI_LOOK_UP_2) Then
				Self.animationID = ANI_LOOK_UP_OVER
			EndIf
		End
End