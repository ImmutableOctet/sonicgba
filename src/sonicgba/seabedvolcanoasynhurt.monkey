Strict

Public

#Rem
	This is one of those times you really wonder what the original developers were thinking.
	I guess they didn't have templates (Likely), because this is nearly identical to 'SeabedVolcanoHurt'.
	
	This is definitely an area where templates could do wonders.
#End

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.seabedvolcanoasynbase
Friend sonicgba.seabedvolcanoasynplatform

' Imports:
Private
	Import monkey.math
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.seabedvolcanoasynbase
	Import sonicgba.seabedvolcanoasynplatform
Public

' Classes:
Class SeabedVolcanoAsynHurt Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 3072
		Const COLLISION_HEIGHT:= 1152
		
		' Fields:
		Field sb:SeabedVolcanoAsynBase
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, sb:SeabedVolcanoAsynBase)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Self.sb = sb
		End
		
		' Methods:
		Method close:Void()
			Self.sb = Null
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (collisionRect.getHeight() <> 0 And Not player.isFootOnObject(sb.sp))
				player.beHurt()
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Local height:= SeabedVolcanoAsynPlatform.sPosY
			
			If (height > 0) Then
				height = 0
			EndIf
			
			If (height < -COLLISION_HEIGHT) Then
				height = -COLLISION_HEIGHT
			EndIf
			
			collisionRect.setRect((x - (COLLISION_WIDTH/2)), (height + y), COLLISION_WIDTH, Abs(height)) ' posX ' posY
		End
End