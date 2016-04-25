Strict

Public

' Imports:
Private
	Import sonicgba.backmanagerstage1
	Import sonicgba.backmanagerstage2
	Import sonicgba.backmanagerstage3
	Import sonicgba.backmanagerstage4
	Import sonicgba.backmanagerstage5
	Import sonicgba.backmanagerstage61
	Import sonicgba.backmanagerstage62
	Import sonicgba.backmanagerstageextra
	Import sonicgba.backmanagerstagefinal
	Import sonicgba.frontmanagerstage2_1
	
	Import sonicgba.mapmanager
	Import sonicgba.snowstage4
	Import sonicgba.sonicdef
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class BackGroundManager Abstract ' Implements SonicDef
	Public
		' Constant variable(s):
		Const MAP_FILE_PATH:String = "/map"
		
		Global DRAW_WIDTH:Int = MapManager.CAMERA_WIDTH ' Const
		Global DRAW_HEIGHT:Int = MapManager.CAMERA_HEIGHT ' Const
		
		Global DRAW_X:Int = MapManager.CAMERA_OFFSET_X ' Const
		Global DRAW_Y:Int = MapManager.CAMERA_OFFSET_Y ' Const
		
		' Global variable(s):
		Global frame:Int
		Global stageId:Int
	Private
		' Global variable(s):
		Global frontNatural:BackGroundManager
		Global instance:BackGroundManager
	Public
		' Functions:
		Function init:Void(id:Int)
			If (stageId <> id) Then
				If (instance <> Null) Then
					instance.close()
					
					instance = Null
				EndIf
				
				If (frontNatural <> Null) Then
					frontNatural.close()
					
					frontNatural = Null
				EndIf
			EndIf
			
			stageId = id
			
			Select (stageId) ' id
				Case 0, 1
					instance = New BackManagerStage1()
				Case 2, 3
					instance = New BackManagerStage2()
					
					If (stageId = 2) Then
						frontNatural = New FrontManagerStage2_1()
					EndIf
				Case 4, 5
					instance = New BackManagerStage3()
				Case 6, 7
					frontNatural = New SnowStage4()
					
					instance = New BackManagerStage4(stageId - 6)
				Case 8, 9
					instance = New BackManagerStage5()
				Case 10
					instance = New BackManagerStage61()
				Case 11
					instance = New BackManagerStage62()
				Case 12
					instance = New BackManagerStageFinal()
				Case 13
					instance = New BackManagerStageExtra()
			End Select
		End
		
		Function nextStates:Void()
			If (instance <> Null) Then
				instance.nextState()
			EndIf
			
			If (frontNatural <> Null) Then
				frontNatural.nextState()
			EndIf
		End
		
		Function drawBackGround:Void(g:MFGraphics)
			If (instance <> Null) Then
				instance.draw(g)
			EndIf
		End
		
		Function drawFrontNatural:Void(g:MFGraphics)
			If (frontNatural <> Null) Then
				frontNatural.draw(g)
			EndIf
		End
		
		' Methods (Abstract):
		Method close:Void() Abstract
		Method draw:Void(mFGraphics:MFGraphics) Abstract
		
		' Methods (Implemented):
		Method nextState:Void()
			' Empty implementation.
		End
End