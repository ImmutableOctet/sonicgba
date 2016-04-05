Strict

Public

' Imports:
Private
	Import special.specialobject
	Import special.ssdef
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SSGoal Extends SpecialObject Implements SSDef
	Private
		' Fields:
		Field used:Bool
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int)
			Super.New(SSOBJ_GOAL, x, y, z)
			
			Self.used = False
		End
		
		' Methods:
		Method close:Void()
			' Empty implementation.
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			If (Not Self.used) Then
				player.setGoal()
				
				Self.used = True
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			' Empty implementation.
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method refreshCollision:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (SSDef.PLAYER_MOVE_WIDTH / 2), y - (SSDef.PLAYER_MOVE_HEIGHT / 2), SSDef.PLAYER_MOVE_WIDTH, SSDef.PLAYER_MOVE_HEIGHT)
		End
End