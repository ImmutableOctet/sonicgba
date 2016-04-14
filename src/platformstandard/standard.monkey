Strict

Public

' Imports:
Private
	Import platformstandard.standard2
	
	Import lib.constutil
	
	Import gameengine.def
	'Import mflib.bpdef
	Import special.ssdef
	
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class Standard ' Final
	Private
		' Constant variable(s):
		Const IMG_BG:Int = 3
		Const IMG_CMCC:Int = 0
		Const IMG_CMCC_DESCREPTION_WORD_0:Int = 4
		Const IMG_CMCC_DESCREPTION_WORD_1:Int = 5
		Const IMG_CP:Int = 2
		Const IMG_ROLLING_EFFECT_0:Int = 6
		Const IMG_ROLLING_EFFECT_1:Int = 7
		Const IMG_ROLLING_EFFECT_2:Int = 8
		Const IMG_SP:Int = 1
		
		Const SPLASH_EVALUATE:Int = 1
		Const SPLASH_LOAD:Int = 0
		Const SPLASH_ROLL:Int = 3
		Const SPLASH_SOUND:Int = 2
		
		Global STAR_WIDTH:= PickValue((SCREEN_WIDTH >= ssdef.PLAYER_MOVE_HEIGHT), 25, 20) ' Const
		
		Const ROLL_FAST_DIFF:Int = 800
		Const ROLL_GRID_WIDTH:Int = 52
		
		Const ROLL_RANGE:Int = 2
		Const ROLL_RANGE_DES:Int = 5
		Const ROLL_SLOW_DIFF:Int = 200
		Const ROLL_TIME_CMCC:Int = 1000
		Const ROLL_TIME_CMCC_DES:Int = 100
		Const ROLL_TIME_CP:Int = 1500
		Const ROLL_TIME_SP:Int = 2000
		
		Const SHOW_LOGO_TIME:Int = 3000
		Const SHOW_STAR_TIME:Int = 2000
		
		' Global variable(s):
		Global lastTime:Long = 0
		Global loadCount:Int = 0
		Global nowTime:Long = 0
		Global openMoreGame:Bool = False
		Global isPaused:Bool = False
		Global playSound:Bool = False
		Global rollCmccDesPos:Int = 0
		Global rollEffectCount:Int[] = New Int[3]
		Global rollEffectFlag:Bool = False
		Global rollLogoImgIndex:Int[] = [IMG_SP, IMG_CMCC, IMG_CP]
		Global rollState:Int = 0
		Global softValue:Int[] = New Int[2]
		Global splashState:Int = SPLASH_LOAD
		Global timeCount:Int = 0
		Global timePeriod:Long = 0
	Public
		' Constant variable(s):
		Const GAME_STAR_NUM:Int = 3
		
		Const MENU_MORE_GAME:Bool = True
		
		Const MORE_GAME_LOAD:Int = 0
		Const MORE_GAME_SHOW:Int = 1
		
		Const ROLL_CMCC_DESCREPTION:Int = 0
		Const ROLL_END:Int = 2
		Const ROLL_LOGO:Int = 1
		
		Const R_MOREGAME_EXIT:Int = 0
		Const R_MOREGAME_WAIT:Int = 1
		Const R_SPLASH_END:Int = 3
		Const R_SPLASH_IS_EMU:Int = 4
		Const R_SPLASH_SOUND_DISABLE:Int = 2
		Const R_SPLASH_SOUND_ENABLE:Int = 1
		Const R_SPLASH_WAIT:Int = 0
		
		Const SPLASH_IS_EMU:Int = 4
		
		'Const SRT_MORE_GAME_URL:String = "http://go.i139.cn/gcomm1/portal/spchannel.do?url=http://gamepie.i139.cn/wap/s.do?j=3channel"
		'Const STR_MORE_GAME:String = "~u66f4~u591a~u7cbe~u5f69~u6e38~u620f|~u5c3d~u5728~u6e38~u620f~u9891~u9053Orwap.xjoys.com"
		
		' Global variable(s):
		Global moreGameState:Int = MORE_GAME_LOAD
	Protected
		' Constant variable(s):
		Const SOFT_EXIT:Int = 4
		Const SOFT_KEY_HEIGHT:Int = 17
		Const SOFT_NO:Int = 2
		Const SOFT_NULL:Int = 0
		Const SOFT_OK:Int = 3
		Const SOFT_YES:Int = 1
		
		' Global variable(s):
		Global keyCancel:Bool
		Global keyConfirm:Bool
	Public
		' Functions:
		Function pressConfirm:Void()
			keyConfirm = True
			
			Standard2.pressConfirm()
		End
		
		Function pressCancel:Void()
			keyCancel = True
			
			Standard2.pressCancel()
		End
		
		Function pause:Void()
			isPaused = True
		End
		
		Function resume:Void()
			isPaused = False
			
			nowTime = Millisecs()
			lastTime = nowTime
			
			timePeriod = 0
		End
		
		Function menuMoreGameSelected:Void()
			openMoreGame = MENU_MORE_GAME ' True
		End
		
		Function execSplash:Int()
			Return Standard2.splashLogic()
		End
		
		Function drawSplash:Void(g:MFGraphics, SCREEN_W:Int, SCREEN_H:Int)
			Standard2.splashDraw(g, SCREEN_W, SCREEN_H)
		End
		
		Function execMoreGame:Int(openWapAvailable:Bool)
			Return MORE_GAME_LOAD ' MORE_GAME_EXIT ' 0
		End
		
		Function drawMoreGame:Void(g:MFGraphics, SCREEN_W:Int, SCREEN_H:Int)
			' Empty implementation.
		End
	Private
		' Functions:
		Function drawSoft:Void(g:MFGraphics, SCREEN_W:Int, SCREEN_H:Int)
			' Empty implementation.
		End
	Protected
		' Functions:
		Function setSoftValue:Void(lValue:Int, rValue:Int)
			softValue[0] = lValue
			softValue[1] = rValue
		End
		
		Function loadBg:Void()
			' Empty implementation.
		End
		
		Function freeBg:Void()
			' Empty implementation.
		End
		
		Function releaseKey:Void()
			keyConfirm = False
			keyCancel = False
		End
		
		Function drawBg:Void(g:MFGraphics, SCREEN_W:Int, SCREEN_H:Int)
			g.setColor(0)
			g.fillRect(0, 0, SCREEN_W, SCREEN_H)
			
			drawSoft(g, SCREEN_W, SCREEN_H)
		End
		
		Function paintWrapped:Void(g:MFGraphics, content:String, SCREEN_W:Int, SCREEN_H:Int)
			g.setFont(MFGraphics.FONT_SMALL)
			g.setColor(MapManager.END_COLOR)
			
			Local ry:= 0
			
			Local x:= (SCREEN_W / 2) ' Shr 1
			Local y:= (SCREEN_H / 2) - (g.charHeight() * 3) ' Shr 1
			
			Local charH:= g.charHeight()
			
			While (content.indexOf("|") <> -1)
				Local showStr:String
				
				Local i:= content.indexOf("|")
				
				If (i = 0) Then
					showStr = ""
					content = content[1..]
				Else
					showStr = content[..i]
					content = content[(i + 1)..]
				EndIf
				
				g.drawString(showStr, x, (charH * ry) + y, SOFT_KEY_HEIGHT)
				
				ry += 1
			Wend
			
			g.drawString(content, x, (charH * ry) + y, SOFT_KEY_HEIGHT)
		End
End