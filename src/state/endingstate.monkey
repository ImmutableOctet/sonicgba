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
				Case EMERALD_STATE_NONENTER ' 0
					PlayerObject.resetGameParam()
					
					Self.normalEndingInstance = New NormalEnding()
					Self.normalEndingInstance.init(0, PlayerObject.getCharacterID())
				Case EMERALD_STATE_SUCCESS ' 1
					PlayerObject.resetGameParam()
					
					Self.SuperSonicEndingInstance = New SuperSonicEnding()
				Case EMERALD_STATE_FAILD ' 2
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
				Case EMERALD_STATE_NONENTER
					Self.normalEndingInstance.draw(g)
				Case EMERALD_STATE_SUCCESS
					Self.SuperSonicEndingInstance.draw(g)
				Case EMERALD_STATE_FAILD
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
				Case EMERALD_STATE_NONENTER
					Self.normalEndingInstance.logic()
				Case EMERALD_STATE_SUCCESS
					Self.SuperSonicEndingInstance.logic()
				Case EMERALD_STATE_FAILD
					Self.specialEndingInstance.logic()
				Default
					' Nothing so far.
			End Select
		End
		
		Method pause:Void()
			Select (Self.endingState)
				Case EMERALD_STATE_NONENTER
					Self.normalEndingInstance.pause()
				Case EMERALD_STATE_SUCCESS
					Self.SuperSonicEndingInstance.pause()
				Case EMERALD_STATE_FAILD
					Self.specialEndingInstance.pause()
				Default
					' Nothing so far.
			End Select
		End
End