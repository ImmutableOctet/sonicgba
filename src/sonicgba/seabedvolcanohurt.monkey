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
		
		' The 'var1' and 'var2' arguments are likely X and Y coordinates.
		' The 'var3' argument is held internally as 'sb'.
		Method New(var1:Int, var2:Int, var3:SeabedVolcanoBase)
			Super.New(0, var1, var2, 0, 0, 0, 0)
			
			Self.sb = var3
		End
		
		' Methods:
		Method close:Void()
			Self.sb = Null
		End
		
		Method doWhileCollision:Void(var1:PlayerObject, var2:Int)
			If (collisionRect.getHeight() <> 0 And Not var1.isFootOnObject(sb.sp))
				var1.beHurt()
			EndIf
		End
		
		' As mentioned in other files, these two arguments are very likely X and Y coordinates.
		Method refreshCollisionRect:Void(var1:Int, var2:Int)
			Local var3:= SeabedVolcanoPlatform.sPosY
			
			If (var3 > 0) Then
				var3 = 0
			EndIf
			
			If (var3 < -COLLISION_HEIGHT) Then
				var3 = -COLLISION_HEIGHT
			EndIf
			
			' This probably takes in something akin to: X, Y, W, H
			collisionRect.setRect((posX - (COLLISION_WIDTH/2)), (var3 + posY), COLLISION_WIDTH, Abs(var3))
		End
End