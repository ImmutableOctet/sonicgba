Strict

Public

' Imports:
Private
	Import ending.normalending
	Import ending.specialending
	Import ending.supersonicending
	
	Import state ' state.state
	
	' This import may be removed in the future.
	Import state.titlestate
	
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class EndingState Extends State
	Private
		' Fields:
		Field endingState:Int
		Field normalEndingInstance:NormalEnding
		Field specialEndingInstance:SpecialEnding
		Field SuperSonicEndingInstance:SuperSonicEnding
	Public
		' Constructor(s):
		Method New(state:Int)
			Self.endingState = state
			
			Select (state)
				Case TitleState.STAGE_SELECT_KEY_RECORD_1
					PlayerObject.resetGameParam()
					
					Self.normalEndingInstance = New NormalEnding()
					Self.normalEndingInstance.init(0, PlayerObject.getCharacterID())
				Case TitleState.STAGE_SELECT_KEY_RECORD_2
					PlayerObject.resetGameParam()
					
					Self.SuperSonicEndingInstance = New SuperSonicEnding()
				Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
					Self.specialEndingInstance = New SpecialEnding(3, 5)
				Default
					' Nothing so far.
			End Select
		End
		
		' Methods:
		Method close:Void()
			' Empty implementation.
		End
		
		Method draw:Void(g:MFGraphics)
			Select (Self.endingState)
				Case TitleState.STAGE_SELECT_KEY_RECORD_1
					Self.normalEndingInstance.draw(g)
				Case TitleState.STAGE_SELECT_KEY_RECORD_2
					Self.SuperSonicEndingInstance.draw(g)
				Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
					Self.specialEndingInstance.draw(g)
				Default
					' Nothing so far.
			End Select
		End
		
		Method init:Void()
			' Empty implementation.
		End
		
		Method logic:Void()
			Select (Self.endingState)
				Case TitleState.STAGE_SELECT_KEY_RECORD_1
					Self.normalEndingInstance.logic()
				Case TitleState.STAGE_SELECT_KEY_RECORD_2
					Self.SuperSonicEndingInstance.logic()
				Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
					Self.specialEndingInstance.logic()
				Default
					' Nothing so far.
			End Select
		End
		
		Method pause:Void()
			Select (Self.endingState)
				Case TitleState.STAGE_SELECT_KEY_RECORD_1
					Self.normalEndingInstance.pause()
				Case TitleState.STAGE_SELECT_KEY_RECORD_2
					Self.SuperSonicEndingInstance.pause()
				Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
					Self.specialEndingInstance.pause()
				Default
					' Nothing so far.
			End Select
		End
End