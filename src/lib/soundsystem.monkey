Strict

Public

' Preprocessor related:
#SONICGBA_FORCE_DISABLE_SOUNDEFFECTS = True
#SONICGBA_FORCE_DISABLE_MUSIC = True

' Imports:
Private
	Import sonicgba.globalresource
	Import sonicgba.playerobject
	
	'Import com.sega.mobile.framework.device.mfplayer
	'Import com.sega.mobile.framework.device.mfsound
	
	Import com.sega.mobile.framework.device.mfdevice
	
	Import mojo.audio
	
	Import regal.typetool
Public

' Classes:
Class SoundSystem
	Public
		' Constant variable(s):
		Const BGM_1UP:Byte = 43
		Const BGM_ASPHYXY:Byte = 21
		Const BGM_BOSS_01:Byte = 22
		Const BGM_BOSS_02:Byte = 23
		Const BGM_BOSS_03:Byte = 24
		Const BGM_BOSS_04:Byte = 25
		Const BGM_BOSS_F1:Byte = 46
		Const BGM_BOSS_F2:Byte = 47
		Const BGM_BOSS_FINAL3:Byte = 19
		Const BGM_CLEAR_ACT1:Byte = 26
		Const BGM_CLEAR_ACT2:Byte = 27
		Const BGM_CLEAR_EX:Byte = 29
		Const BGM_CLEAR_FINAL:Byte = 28
		Const BGM_CONTINUE:Byte = 5
		Const BGM_CREDIT:Byte = 33
		Const BGM_ENDING_EX_01:Byte = 32
		Const BGM_ENDING_EX_02:Byte = 45
		Const BGM_ENDING_FINAL:Byte = 31
		Const BGM_GAMEOVER:Byte = 30
		Const BGM_INVINCIBILITY:Byte = 44
		Const BGM_NEWRECORD:Byte = 41
		Const BGM_OPENING:Byte = 0
		Const BGM_PLAYER_SELECT:Byte = 2
		Const BGM_RANKING:Byte = 4
		Const BGM_SP:Byte = 35
		Const BGM_SP_CLEAR:Byte = 37
		Const BGM_SP_EMERALD:Byte = 38
		Const BGM_SP_INTRO:Byte = 34
		Const BGM_SP_TOTAL_CLEAR:Byte = 40
		Const BGM_SP_TOTAL_MISS:Byte = 39
		Const BGM_SP_TRICK:Byte = 36
		Const BGM_ST1_1:Byte = 6
		Const BGM_ST1_2:Byte = 7
		Const BGM_ST2_1:Byte = 8
		Const BGM_ST2_2:Byte = 9
		Const BGM_ST3_1:Byte = 10
		Const BGM_ST3_2:Byte = 11
		Const BGM_ST4_1:Byte = 12
		Const BGM_ST4_2:Byte = 13
		Const BGM_ST5_1:Byte = 14
		Const BGM_ST5_2:Byte = 15
		Const BGM_ST6_1:Byte = 16
		Const BGM_ST6_2:Byte = 17
		Const BGM_ST_EX:Byte = 20
		Const BGM_ST_FINAL:Byte = 18
		Const BGM_TIMEATTACKGOAL:Byte = 42
		Const BGM_TITLE:Byte = 1
		Const BGM_ZONESELECT:Byte = 3
		
		Const OP_PATCH:Byte = 80
		Const HAS_SE:Bool = False
		Const PRE_LOAD_SE:Bool = False
		
		Const SE_103:Byte = 0
		Const SE_106:Byte = 1
		Const SE_107:Byte = 2
		Const SE_108:Byte = 3
		Const SE_109:Byte = 4
		Const SE_110:Byte = 5
		Const SE_111:Byte = 6
		Const SE_112:Byte = 7
		Const SE_113:Byte = 79
		Const SE_114_01:Byte = 8
		Const SE_114_02:Byte = 9
		Const SE_115:Byte = 10
		Const SE_116:Byte = 11
		Const SE_117:Byte = 12
		Const SE_118:Byte = 13
		Const SE_119:Byte = 14
		Const SE_120:Byte = 15
		Const SE_121:Byte = 16
		Const SE_123:Byte = 17
		Const SE_125:Byte = 18
		Const SE_126:Byte = 19
		Const SE_127:Byte = 20
		Const SE_128:Byte = 21
		Const SE_130:Byte = 22
		Const SE_131:Byte = 23
		Const SE_132:Byte = 24
		Const SE_133:Byte = 25
		Const SE_135:Byte = 26
		Const SE_136:Byte = 27
		Const SE_137:Byte = 28
		Const SE_138:Byte = 29
		Const SE_139:Byte = 30
		Const SE_140:Byte = 31
		Const SE_141:Byte = 32
		Const SE_142:Byte = 33
		Const SE_143:Byte = 34
		Const SE_144:Byte = 35
		Const SE_145:Byte = 36
		Const SE_148:Byte = 37
		Const SE_149:Byte = 38
		Const SE_150:Byte = 39
		Const SE_162:Byte = 81
		Const SE_166:Byte = 40
		Const SE_168:Byte = 41
		Const SE_169:Byte = 42
		Const SE_171:Byte = 43
		Const SE_172:Byte = 44
		Const SE_173:Byte = 45
		Const SE_174:Byte = 46
		Const SE_175:Byte = 47
		Const SE_176:Byte = 48
		Const SE_177:Byte = 82
		Const SE_178:Byte = 49
		Const SE_179:Byte = 83
		Const SE_180:Byte = 50
		Const SE_181_01:Byte = 51
		Const SE_181_02:Byte = 52
		Const SE_182:Byte = 53
		Const SE_183:Byte = 54
		Const SE_184:Byte = 55
		Const SE_185:Byte = 56
		Const SE_189:Byte = 57
		Const SE_190:Byte = 58
		Const SE_191:Byte = 59
		Const SE_192:Byte = 60
		Const SE_193:Byte = 61
		Const SE_194:Byte = 62
		Const SE_195:Byte = 63
		Const SE_198_01:Byte = 64
		Const SE_198_02:Byte = 65
		Const SE_199_01:Byte = 66
		Const SE_199_02:Byte = 67
		Const SE_200_01:Byte = 68
		Const SE_200_02:Byte = 69
		Const SE_201_01:Byte = 70
		Const SE_201_02:Byte = 71
		Const SE_206:Byte = 72
		Const SE_209:Byte = 73
		Const SE_210:Byte = 74
		Const SE_211:Byte = 75
		Const SE_212:Byte = 76
		Const SE_213:Byte = 77
		Const SE_214:Byte = 78
		
		' Extensions:
		Const SE_EX_01:Byte = 84
	Private
		' Constant variable(s):
		Const SE_PATH:String = "/se/"
		
		' Global variable(s):
		Global instance:SoundSystem
		Global volume:Int = 46 ' 50
		
		' Fields:
		Field BgmName:String[]
		Field BgmNameSpeeding:String[]
		Field INTRO_MSEC:Int[][]
		Field Path:String
		Field SE_NAME:String[]
		Field VOLUME_OPTION:Int[]
		
		Field BgmPrefix:String
		Field BgmType:String
		
		Field bgmIndex:Int
		Field currentIntroMsec:Int
		Field currentLoopMsec:Int
		'Field longSeplayer:MFPlayer
		Field mediaTime:Long
		Field nextBgmIndex:Int
		Field nextBgmLoop:Bool
		Field nextBgmWaiting:Bool
		Field preSpeed:Float
		Field seIndex:Int
		'Field seplayer:MFPlayer
		Field speed:Float
		
		Field __preload_se:Sound
	Public
		' Constructor(s):
		Method New()
			Self.BgmName = ["bgm_01_opening", "bgm_02_title", "bgm_03_player_select", "bgm_04_zoneselect", "bgm_10_ranking", "bgm_155_continue", "bgm_12_st1_1", "bgm_13_st1_2", "bgm_14_st2_1", "bgm_15_st2_2", "bgm_16_st3_1", "bgm_17_st3_2", "bgm_18_st4_1", "bgm_19_st4_2", "bgm_20_st5_1", "bgm_21_st5_2", "bgm_22_st6_1", "bgm_23_st6_2", "bgm_24_st_Final", "bgm_25_boss_Final3", "bgm_26_st_ex", "bgm_27_asphyxy", "bgm_29_boss_01", "bgm_30_boss_02", "bgm_31_boss_03", "bgm_32_boss_04", "bgm_33_clear_act1", "bgm_34_clear_act2", "bgm_35_clear_Final", "bgm_36_clear_ex", "bgm_37_gameover", "bgm_38_ending_Final", "bgm_39_ending_ex_01", "bgm_40_credit", "bgm_41_sp_intro", "bgm_42_sp", "bgm_43_sp_trick", "bgm_44_sp_clear", "bgm_45_sp_emerald", "bgm_46_sp_total_miss", "bgm_47_sp_total_clear", "bgm_305_NewRecord", "bgm_306_TimeAttackGoal", "bgm_307_1up", "bgm_28_invincibility", "bgm_39_ending_ex_02", "bgm_49_boss_f1", "bgm_50_boss_f2"]
			Self.BgmNameSpeeding = ["bgm_12_st1_1_speed", "bgm_13_st1_2_speed", "bgm_14_st2_1_speed", "bgm_15_st2_2_speed", "bgm_16_st3_1_speed", "bgm_17_st3_2_speed", "bgm_18_st4_1_speed", "bgm_19_st4_2_speed", "bgm_20_st5_1_speed", "bgm_21_st5_2_speed", "bgm_22_st6_1_speed", "bgm_23_st6_2_speed", "bgm_28_invincibility_speed"]
			
			Local r:= New Int[48][]
			
			' Magic numbers: Introduction, loop-point (Milliseconds):
			r[0] = New Int[2]
			r[1] = New Int[2]
			r[2] = [0, 32000]
			r[3] = [9433, 25433]
			r[4] = [1432, 18132]
			r[5] = New Int[2]
			r[6] = [1800, 73800]
			r[7] = [0, 78800]
			r[8] = [7066, 91566]
			r[9] = [7500, 70666]
			r[10] = [4432, 90832]
			r[11] = [0, 72000]
			r[12] = [17000, 68432]
			r[13] = [0, 64066]
			r[14] = [0, 71032]
			r[15] = [0, 71032]
			r[16] = [12600, 70200]
			r[17] = [5566, 78966]
			r[18] = [0, 88432]
			r[19] = [0, 67200]
			r[20] = [0, 78732]
			r[21] = New Int[2]
			r[22] = [3800, 48366]
			r[23] = [3132, 57500]
			r[24] = [6200, 56266]
			r[25] = [31866, 123066]
			r[26] = New Int[2]
			r[27] = New Int[2]
			r[28] = New Int[2]
			r[29] = New Int[2]
			r[30] = New Int[2]
			r[31] = New Int[2]
			r[32] = New Int[2]
			r[33] = New Int[2]
			r[34] = New Int[2]
			r[35] = [6167, 68133]
			r[36] = New Int[2]
			r[37] = New Int[2]
			r[38] = New Int[2]
			r[39] = New Int[2]
			r[40] = New Int[2]
			r[41] = New Int[2]
			r[42] = New Int[2]
			r[43] = New Int[2]
			r[44] = New Int[2]
			r[45] = New Int[2]
			r[46] = [0, 69833]
			r[47] = [17067, 51333]
			
			Self.INTRO_MSEC = r
			
			Self.BgmType = ".ogg" ' ".mid"
			Self.SE_NAME = ["se_103.ogg", "se_106.wav", "se_107.wav", "se_108.wav", "se_109.ogg", "se_110.ogg", "se_111.ogg", "se_112.ogg", "se_114_01.ogg", "se_114_02.ogg", "se_115.ogg", "se_116.ogg", "se_117.ogg", "se_118.ogg", "se_119.ogg", "se_120.ogg", "se_121.ogg", "se_123.ogg", "se_125.ogg", "se_126.ogg", "se_127.ogg", "se_128.ogg", "se_130.ogg", "se_131.ogg", "se_132.ogg", "se_133.ogg", "se_135.ogg", "se_136.ogg", "se_137.ogg", "se_138.ogg", "se_139.ogg", "se_140.ogg", "se_141.wav", "se_142.ogg", "se_143.ogg", "se_144.ogg", "se_145.ogg", "se_148.ogg", "se_149.ogg", "se_150.ogg", "se_166.ogg", "se_168.ogg", "se_169.ogg", "se_171.ogg", "se_172.ogg", "se_173.ogg", "se_174.ogg", "se_175.ogg", "se_176.ogg", "se_178.ogg", "se_180.ogg", "se_181_01.ogg", "se_181_02.ogg", "se_182.ogg", "se_183.ogg", "se_184.ogg", "se_185.ogg", "se_189.ogg", "se_190.ogg", "se_191.ogg", "se_192.ogg", "se_193.ogg", "se_194.ogg", "se_195.ogg", "se_198_01.ogg", "se_198_02.ogg", "se_199_01.ogg", "se_199_02.ogg", "se_200_01.ogg", "se_200_02.ogg", "se_201_01.ogg", "se_201_02.ogg", "se_206.ogg", "se_209.ogg", "se_210.ogg", "se_211.ogg", "se_212.ogg", "se_213.ogg", "se_214.ogg", "se_113.ogg", "op_patch.ogg", "se_162.ogg", "se_177.ogg", "se_179.ogg", "se_ex_01.ogg"]
			Self.Path = "/ogg/" ' "/mid/"
			Self.BgmPrefix = ""
			
			Self.nextBgmWaiting = False
			Self.nextBgmIndex = 0
			
			Self.speed = 1.0
			Self.preSpeed = 1.0
			
			Self.mediaTime = 0
			
			Self.VOLUME_OPTION = [0, 25, 60, 95] ' 100
		End
		
		' Functions:
		Function open:Void()
			instance = New SoundSystem()
			instance.openImpl()
		End
		
		Function getInstance:SoundSystem()
			If (instance = Null) Then
				open()
			EndIf
			
			Return instance
		End
	Private
		' Methods:
		Method getSpeedyVersionBgm:Int(bgmID:Int)
			' Magic numbers (Song IDs; see above):
			If (bgmID >= 6 And bgmID < 18) Then
				Return (bgmID - 6)
			EndIf
			
			If (bgmID = 44) Then
				Return 12
			EndIf
			
			Return -1
		End
		
		Method openImpl:Void()
			Self.nextBgmWaiting = False
		End
	Public
		' Extensions:
		Method getBgmFileName:String(index:Int)
			Return Self.Path + Self.BgmPrefix +  Self.BgmName[index] + ".ogg" ' ".mid"
		End
		
		Method getSoundEffectName:String(index:Int)
			Return SE_PATH + SE_NAME[index]
		End
		
		Method exec:Void()
			If (Self.nextBgmWaiting And Not bgmPlaying()) Then
				Self.nextBgmWaiting = False
				
				If (Not PlayerObject.isTerminal) Then ' player.isTerminal
					playBgm(Self.nextBgmIndex, Self.nextBgmLoop)
				EndIf
			EndIf
			
			If (Not Self.nextBgmWaiting And Self.currentLoopMsec > 0) Then
				#Rem
				Local currentBGM:= MFSound.getCurrentBgm()
				
				If (currentBGM <> Null And currentBGM.getState() = 3) Then
					If (PlayerObject.IsSpeedUp()) Then
						If (currentBGM.getMediaTime() >= ((Long) (Self.currentLoopMsec Shr 1))) Then ' / 2
							currentBGM.setMediaTime((Int) (((Long) (Self.currentIntroMsec Shr 1)) + (currentBGM.getMediaTime() - ((Long) (Self.currentLoopMsec Shr 1))))) ' / 2
						EndIf
					ElseIf (currentBGM.getMediaTime() >= ((Long) Self.currentLoopMsec)) Then
						currentBGM.setMediaTime((Int) (((Long) Self.currentIntroMsec) + (currentBGM.getMediaTime() - ((Long) Self.currentLoopMsec))))
					EndIf
				EndIf
				#End
			EndIf
		End
		
		Method playBgmSequence:Void(index0:Int, index1:Int)
			'playBgm(index0, False)
			
			Self.nextBgmWaiting = True
			Self.nextBgmIndex = index1
			Self.nextBgmLoop = True
		End
		
		Method playBgmFromTime:Void(startTime:Long, index0:Int)
			Self.bgmIndex = index0
			
			Local fileName:= getBgmFileName(index0)
			
			Print(fileName)
			
			'MFSound.playBgm(fileName, False)
			'MFSound.getCurrentBgm().setMediaTime((Int) startTime)
		End
		
		Method playBgmSequenceNoLoop:Void(index0:Int, index1:Int)
			playBgm(index0, False)
			
			Self.nextBgmWaiting = True
			Self.nextBgmIndex = index1
			Self.nextBgmLoop = False
		End
		
		Method playBgm:Void(index:Int)
			playBgm(index, True)
		End
	
		Method playNextBgm:Void(index:Int)
			Self.nextBgmWaiting = True
			Self.nextBgmIndex = index
			Self.nextBgmLoop = True
		End
		
		Method getPlayingBGMIndex:Int()
			Return Self.bgmIndex
		End
		
		Method getBgmName:String(index:Int)
			Return Self.BgmName[index]
		End
		
		Method setSoundSpeed:Void(speed:Float)
			Self.preSpeed = Self.speed
			Self.speed = speed
		End
		
		Method playBgm:Void(index:Int, loop:Bool)
			playBgmInSpeed(index, loop, Self.speed)
		End
		
		Method restartBgm:Void()
			#Rem
			Self.mediaTime = MFSound.getBgmMediaTime()
			
			Print("mediaTime get:" + Self.mediaTime)
			
			Self.mediaTime = Long((Float(Self.mediaTime) * Self.preSpeed) / Self.speed)
			
			MFSound.stopBgm()
			
			playBgm(Self.bgmIndex, True)
			#End
		End
		
		Method playBgmInSpeed:Void(index:Int, loop:Bool, speed:Float)
			Self.currentIntroMsec = Self.INTRO_MSEC[index][0]
			Self.currentLoopMsec = Self.INTRO_MSEC[index][1]
			
			If (Self.currentLoopMsec > 0) Then
				loop = False
			EndIf
			
			playBgmInNormalSpeed(index, loop)
			
			#Rem
				If (speed = 1.0 Or getSpeedyVersionBgm(index) < 0) Then
					playBgmInNormalSpeed(index, loop)
				Else
					playBgmInInnormalSpeed(index, loop, speed)
				EndIf
			#End
		End
	Private
		Method playBgmInNormalSpeed:Void(index:Int, loop:Bool)
			Self.bgmIndex = index
			
			Local fileName:= getBgmFileName(index)
			
			Print(fileName)
			
			Local resPath:= "monkey://" + MFDevice.FixResourcePath(fileName)
			
			#If Not SONICGBA_FORCE_DISABLE_MUSIC
				PlayMusic(resPath, Int(loop))
			#End
			
			'MFSound.playBgm(fileName, loop)
			
			Print("play bgm")
			
			If (Self.mediaTime > 0) Then
				'MFSound.getCurrentBgm().setMediaTime(Int(Self.mediaTime))
				
				Print("mediaTime:" + Self.mediaTime)
				
				Self.mediaTime = 0
			EndIf
		End
		
		Method playBgmInInnormalSpeed:Void(index:Int, loop:Bool, speed:Float)
			Self.bgmIndex = index
			
			Local fileName:= getBgmFileName(index)
			
			If (getSpeedyVersionBgm(Self.bgmIndex) >= 0) Then
				'MFPlayer a = MFPlayer.createMFPlayer(Self.Path.concat(Self.BgmPrefix).concat(New StringBuilder(String.valueOf(Self.BgmNameSpeeding[getSpeedyVersionBgm(Self.bgmIndex)])).append(".mid").toString()))
				'MFSound.setBgm(a, loop)
				
				If (Self.mediaTime > 0) Then
					'a.setMediaTime((Int) Self.mediaTime)
					
					Print("~~mediaTime:" + Self.mediaTime)
					
					Self.mediaTime = 0
				EndIf
			EndIf
		End
	Public
		' Extensions:
		Method loadSystemSound:Sound(index:Int)
			Local soundEffectName:= getSoundEffectName(index)
			Local resPath:= "monkey://" + MFDevice.FixResourcePath(soundEffectName)
			
			Print("SOUND: " + resPath)
			
			#If SONICGBA_FORCE_DISABLE_SOUNDEFFECTS
				Return Null
			#End
			
			Local sound:= LoadSound(resPath)
			
			Return sound
		End
		
		' Methods:
		Method stopBgm:Void(isDel:Bool)
			'MFSound.stopBgm()
			
			Self.nextBgmWaiting = False
		End
		
		Method resumeBgm:Void()
			'MFSound.resumeBgm()
		End
		
		Method playSe:Void(index:Int, loop:Bool)
			stopLoopSe()
			
			Local sound:= loadSystemSound(index)
			
			If (sound = Null) Then
				Return
			EndIf
			
			PlaySound(sound, 0, 0) ' Int(loop)
			
			'MFSound.playSe(getSoundEffectName(index), 1)
		End
		
		Method playSe:Void(index:Int)
			playSe(index, False)
		End
		
		Method playLongSe:Void(index:Int)
			#Rem
			If (MFSound.getSeFlag()) Then
				Self.longSeplayer = MFPlayer.createMFPlayer(getSoundEffectName(index))
				Self.longSeplayer.realize()
				Self.longSeplayer.prefetch()
				Self.longSeplayer.setLoop(False)
				
				If (volume = 0) Then
					Self.longSeplayer.setVolume(0)
				Else
					Self.longSeplayer.setVolume(100)
				EndIf
				
				Self.longSeplayer.start()
			EndIf
			#End
		End
		
		Method stopLongSe:Void()
			#Rem
				If (Self.longSeplayer <> Null) Then
					Self.longSeplayer.stop()
					Self.longSeplayer.deallocate()
					Self.longSeplayer.close()
					
					Self.longSeplayer = Null
				EndIf
			#End
		End
		
		Method playLoopSe:Void(index:Int)
			#Rem
				If (MFSound.getSeFlag() And Not isLoopSePlaying()) Then
					Self.seplayer = Null
					Self.seplayer = MFPlayer.createMFPlayer(getSoundEffectName(index))
					Self.seIndex = index
					Self.seplayer.realize()
					Self.seplayer.prefetch()
					Self.seplayer.setLoop(True)
					
					If (volume = 0) Then
						Self.seplayer.setVolume(0)
					Else
						Self.seplayer.setVolume(100)
					EndIf
					
					Self.seplayer.start()
				EndIf
			#End
		End
		
		Method playSequenceSe:Void(index:Int)
			#Rem
			If (MFSound.getSeFlag() And Not isLoopSePlaying()) Then
				If (Self.seplayer <> Null) Then
					Self.seplayer.stop()
					Self.seplayer.close()
				EndIf
				
				Self.seplayer = Null
				Self.seplayer = MFPlayer.createMFPlayer(getSoundEffectName(index))
				Self.seIndex = index
				Self.seplayer.realize()
				Self.seplayer.prefetch()
				Self.seplayer.setLoop(False)
				
				If (volume = 0) Then
					Self.seplayer.setVolume(0)
				Else
					Self.seplayer.setVolume(100)
				EndIf
				
				Self.seplayer.start()
			EndIf
			#End
		End
		
		Method preLoadSequenceSe:Void(index:Int)
			If (__preload_se <> Null) Then
				__preload_se.Discard() ' __preload_se = Null
			EndIf
			
			__preload_se = loadSystemSound(index)
			
			#Rem
			If (MFSound.getSeFlag() And Not isLoopSePlaying()) Then
				Self.seplayer = Null
				Self.seplayer = MFPlayer.createMFPlayer(getSoundEffectName(index))
				Self.seIndex = index
				Self.seplayer.realize()
				Self.seplayer.prefetch()
				Self.seplayer.setLoop(False)
				
				If (volume = 0) Then
					Self.seplayer.setVolume(0)
				Else
					Self.seplayer.setVolume(100)
				EndIf
			EndIf
			#End
		End
		
		Method playSequenceSeSingle:Void()
			#Rem
			If (MFSound.getSeFlag() And Not isLoopSePlaying()) Then
				Self.seplayer.start()
			EndIf
			#End
			
			If (__preload_se <> Null And Not isLoopSePlaying()) Then
				PlaySound(__preload_se)
			EndIf
		End
		
		Method stopLoopSe:Void()
			#Rem
			If (MFSound.getSeFlag() And isLoopSePlaying()) Then
				Self.seplayer.stop()
				Self.seplayer.deallocate()
				Self.seplayer.close()
				Self.seplayer = Null
			EndIf
			#End
		End
		
		Method resumeLoopSe:Void()
			#Rem
			If (MFSound.getSeFlag()) Then
				Self.seplayer = Null
				Self.seplayer = MFPlayer.createMFPlayer(getSoundEffectName(Self.seIndex))
				Self.seplayer.realize()
				Self.seplayer.prefetch()
				Self.seplayer.setLoop(True)
				
				If (volume = 0) Then
					Self.seplayer.setVolume(0)
				Else
					Self.seplayer.setVolume(100)
				EndIf
				
				Self.seplayer.start()
			EndIf
			#End
		End
		
		Method getPlayingLoopSeIndex:Int()
			Return Self.seIndex
		End
		
		Method isLoopSePlaying:Bool()
			#Rem
			If (Not MFSound.getSeFlag()) Then
				Return False
			EndIf
			
			If (Self.seplayer = Null) Then
				Return False
			EndIf
			
			If (Self.seplayer.getState() = 3) Then
				Return True
			EndIf
			
			Return False
			#End
			
			' This behavior may change in the future.
			Return False ' True
		End
		
		Method setVolume:Void(vol:Int)
			'MFSound.setLevel(vol)
		End
		
		Method getBgmFlag:Bool()
			'Return MFSound.getBgmFlag()
			
			' This behavior may change in the future.
			Return False
		End
		
		Method setBgmFlag:Void(flag:Bool)
			'MFSound.setBgmFlag(flag)
		End
	
		Method getSeFlag:Bool()
			'Return MFSound.getSeFlag()
			
			' This behavior may change in the future.
			Return False
		End
	
		Method setSeFlag:Void(flag:Bool)
			'MFSound.setSeFlag(flag)
		End
		
		Method bgmPlaying:Bool()
			'Return MFSound.isBgmPlaying()
			
			' This behavior may change in the future.
			Return False ' True
		End
		
		Method bgmPlaying2:Bool()
			'Return MFSound.isBgmPlaying()
			
			' This behavior may change in the future.
			Return False ' True
		End
		
		Method setVolumnState:Void(state:Int)
			' Magic numbers: 0, 15 (States/volumes)
			If (state = 0) Then
				setSeFlag(False)
			Else
				setSeFlag(True)
			EndIf
			
			If (state >= 0 And state <= 15) Then
				setBgmFlag(True)
			EndIf
			
			volume = state
		End
		
		Method updateVolumeState:Void()
			#Rem
			GlobalResource.soundConfig = MFSound.getLevel()
			
			If (GlobalResource.soundConfig = 0) Then
				GlobalResource.seConfig = 0
			EndIf
			
			getInstance().setSoundState(GlobalResource.soundConfig)
			getInstance().setSeState(GlobalResource.seConfig)
			#End
		End
		
		Method setSoundState:Void(state:Int)
			' Magic numbers: 0, 15 (States/volumes)
			If (state = 0) Then
				setSeFlag(False)
			Else
				setSeFlag(True)
			EndIf
			
			If (state >= 0 And state <= 15) Then
				setBgmFlag(True)
				setVolume(state)
			EndIf
			
			volume = state
		End
		
		Method setSeState:Void(state:Int)
			Select (state)
				Case 0
					setSeFlag(False)
				Case 1
					setSeFlag(True)
				Default
					' Nothing so far.
			End Select
		End
		
		Method preLoadAllSe:Void()
			#Rem
			MFSound.releaseAllSound()
			
			For Local append:= EachIn Self.SE_NAME
				MFSound.preloadSound(SE_PATH + append)
			Next
			#End
		End
End