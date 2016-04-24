Strict

Public

' Friends:
Friend sonicgba.pipein
Friend sonicgba.pipeout

' Imports:
Import lib.animation
Import lib.animationdrawer
Import lib.soundsystem

Import sonicgba.gimmickobject
Import sonicgba.playerobject
Import sonicgba.stagemanager

Import com.sega.mobile.framework.device.mfgraphics

' Classes:
Class BasicPipe Extends GimmickObject Abstract
	Protected
		' Constant variable(s):
		Global TRANS:Int[] = [TRANS_NONE, TRANS_ROT180, TRANS_ROT270, TRANS_ROT90, TRANS_MIRROR, TRANS_MIRROR_ROT180] ' [0, 3, 6, 5, 2, 1] ' Const
	Private
		
		' Fields:
		Field drawer:AnimationDrawer
		
		Field actionID:Int
		Field dirRect:Int
		Field direction:Int
		Field transID:Int
	Public
		' Global variable(s):
		Global pipeAnimation:Animation
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, direction_or__width:Int, __height:Int)
			Super.New(id, x, y, left, top, direction_or__width, __height)
			
			If (pipeAnimation = Null) Then
				If (StageManager.getCurrentZoneId() <> 6) Then
					pipeAnimation = New Animation("/animation/pipe_in")
				Else
					pipeAnimation = New Animation("/animation/pipe_in" + StageManager.getCurrentZoneId() + (StageManager.getStageID() - 9))
				EndIf
			EndIf
			
			Self.direction = direction_or__width
			Self.dirRect = Self.direction ' direction_or__width
			
			Select (direction_or__width)
				Case DIRECTION_UP
					Self.transID = 0
				Case DIRECTION_DOWN
					Self.transID = 5
				Case DIRECTION_LEFT
					Self.transID = 0
				Case DIRECTION_RIGHT
					Self.transID = 4
			End Select
		End
		
		' Extensions:
		Method makeDrawer:Void()
			Self.drawer = pipeAnimation.getDrawer(Self.actionID, True, TRANS[Self.transID])
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(pipeAnimation)
			
			pipeAnimation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			drawCollisionRect(g)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_AFTER_MAP
		End
End