Strict

Public

#Rem
	From what I understand, this is probably some sort of event-listener
	that handles details like collision for 'SeabedVolcanoBase' objects.
	
	I'm still not quite sure what 'SeabedVolcanoPlatform' is about, though.
	It's most likely just a hazard, though.
	
	Not completely sure, but the point is, it hurts the
	player when they collide with the collision-rect.
#End

' Imports:
Import monkey.math

Import sonicgba.gimmickobject
Import sonicgba.playerobject
Import sonicgba.seabedvolcanobase
Import sonicgba.seabedvolcanoplatform

' Classes:
Class SeabedVolcanoHurt Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 3072
		Const COLLISION_HEIGHT:= 1152
		
		' Fields:
		Field sb:SeabedVolcanoBase
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, sb:SeabedVolcanoBase)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Self.sb = sb
		End
		
		' Methods:
		Method close:Void()
			Self.sb = Null
		End
		
		Method doWhileCollision:Void(player:PlayerObject, value:Int)
			If (collisionRect.getHeight() <> 0 And Not player.isFootOnObject(sb.sp))
				player.beHurt()
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Local height:= SeabedVolcanoPlatform.sPosY
			
			If (height > 0) Then
				height = 0
			EndIf
			
			If (height < -COLLISION_HEIGHT) Then
				height = -COLLISION_HEIGHT
			EndIf
			
			' This probably takes in something akin to: X, Y, W, H
			collisionRect.setRect((x - (COLLISION_WIDTH/2)), (height + y), COLLISION_WIDTH, Abs(height)) ' posX ' posY
		End
End