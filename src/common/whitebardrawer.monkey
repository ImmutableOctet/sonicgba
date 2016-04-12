Strict

Public

' Imports:
Private
	Import gameengine.def
	
	Import lib.myapi
	
	Import common.barword
	
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class WhiteBarDrawer Implements Def
	Public
		' Constant variable(s):
		Const TIPS_BAR_X_IN:Int = 0
		Const TIPS_BAR_Y_IN:Int = 1
		Const TIPS_STAY:Int = 2
		Const TIPS_MOVE_OUT:Int = 3
		Const TIPS_OVER:Int = 4
	Private
		' Constant variable(s):
		Const STAY_TIME:Int = 60
		
		Const WHITE_BAR_HEIGHT:Int = 20
		Const WHITE_BAR_VEL_X:Int = -96
		Const WHITE_BAR_VEL_Y:Int = -36
		
		Const WORDS_INIT_X:Int = 14
		Const WORDS_VEL_X:Int = -8
		
		Global WHITE_BAR_WIDTH:Int = SCREEN_WIDTH ' Const
		Global WHITE_BAR_Y_DES:Int = ((SCREEN_HEIGHT / 2) - STAY_TIME) ' Const
		
		' Global variable(s):
		Global instance:WhiteBarDrawer
		
		' Fields:
		Field isPause:Bool
		Field pauseFlag:Bool
		
		Field tipsCount:Int
		Field tipsState:Int
		Field whiteBarX:Int
		Field whiteBarY:Int
		Field wordDrawer:BarWord
		Field wordID:Int
		Field wordX:Int
	Public
		' Constructor(s):
		Method New()
			Self.tipsState = TIPS_OVER
			Self.isPause = False
		End
		
		' Functions:
		Function getInstance:WhiteBarDrawer()
			If (instance = Null) Then
				instance = New WhiteBarDrawer()
			EndIf
			
			Return instance
		End
		
		' Methods:
		Method initBar:Void(wordDrawer:BarWord, wordID:Int)
			Self.whiteBarX = (SCREEN_WIDTH - 26) ' + ((WHITE_BAR_VEL_Y / 2) + WORDS_VEL_X))
			Self.whiteBarY = ((SCREEN_HEIGHT / 2) + 48) ' - (WHITE_BAR_VEL_X / 2))
			
			Self.tipsState = TIPS_BAR_X_IN
			Self.tipsCount = 0
			
			Self.wordX = WORDS_INIT_X
			Self.wordDrawer = wordDrawer
			Self.wordID = wordID
			
			Self.pauseFlag = False
		End
		
		Method drawBar:Void(g:MFGraphics)
			If (Not Self.isPause) Then
				Select (Self.tipsState)
					Case TIPS_BAR_X_IN
						Self.whiteBarX += WHITE_BAR_VEL_X
						
						If (Self.whiteBarX <= 0) Then
							Self.whiteBarX = 0
							Self.tipsCount += 1
						EndIf
						
						If (Self.tipsCount = TIPS_STAY) Then
							Self.tipsCount = 0
							Self.tipsState = TIPS_BAR_Y_IN
						EndIf
					Case TIPS_BAR_Y_IN
						Self.whiteBarY += WHITE_BAR_VEL_Y
						
						If (Self.whiteBarY <= 0) Then
							Self.whiteBarY = 0
							'Self.tipsCount += 1
							
							Self.tipsState = TIPS_STAY
							Self.tipsCount = 0
						EndIf
					Case TIPS_STAY
						If (Not Self.pauseFlag) Then
							Self.tipsCount += 1
						EndIf
						
						If (Self.tipsCount > STAY_TIME) Then
							Self.tipsState = TIPS_MOVE_OUT
							Self.tipsCount = 0
						EndIf
					Case TIPS_MOVE_OUT
						Self.whiteBarX += WHITE_BAR_VEL_X
						
						If (Self.whiteBarX <= (-WHITE_BAR_WIDTH)) Then
							Self.whiteBarX = -WHITE_BAR_WIDTH
							
							Self.tipsState = TIPS_OVER
							Self.tipsCount += 1
						EndIf
				End Select
			EndIf
			
			g.setColor(MapManager.END_COLOR)
			
			MyAPI.fillRect(g, Self.whiteBarX, Self.whiteBarY - 2, WHITE_BAR_WIDTH, WHITE_BAR_HEIGHT)
			
			If (Not Self.isPause) Then
				Self.wordX += WORDS_VEL_X
			EndIf
			
			Local wordDistance:= Self.wordDrawer.getWordLength(Self.wordID)
			
			If (wordDistance > 0) Then
				If (Self.wordX < (-wordDistance)) Then
					Self.wordX += wordDistance
				EndIf
				
				MyAPI.setClip(g, Self.whiteBarX, Self.whiteBarY - 2, WHITE_BAR_WIDTH, WHITE_BAR_HEIGHT)
				
				Local i:= Self.wordX
				
				'For Local i:= Self.wordX Until SCREEN_WIDTH Step wordDistance
				While (i < SCREEN_WIDTH)
					Self.wordDrawer.drawWord(g, Self.wordID, Self.whiteBarX + i, Self.whiteBarY)
					
					i += wordDistance
				Wend
				'Next
				
				MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
			EndIf
		End
		
		Method getState:Int()
			Return Self.tipsState
		End
		
		Method getCount:Int()
			Return Self.tipsCount
		End
		
		Method setPauseCount:Void(pause:Bool)
			Self.isPause = pause
		End
		
		Method setPause:Void(flag:Bool)
			Self.pauseFlag = flag
			
			If (Self.tipsState = TIPS_STAY And Not Self.pauseFlag) Then
				Self.tipsCount = STAY_TIME
			EndIf
		End
		
		Method getBarX:Int()
			Return Self.whiteBarX
		End
End