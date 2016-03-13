Strict

Public

#Rem
	This seams to be similar to 'seabedvolcanohurt', where the class's
	purpose is basically to be a function table, and handle player damage.
#End

' Imports:
Import monkey.math

Import sonicgba.gimmickobject
Import sonicgba.playerobject
Import sonicgba.steambase
Import sonicgba.steamplatform

' Classes:
Class SteamHurt Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:= 128
		Const COLLISION_HEIGHT:= 1024
		Const COLLISION_OFFSET_Y:= -1280
		
		' Fields:
		Field sb:SteamBase
	Public
		' Constructor(s):
		
		' This constructor is supposed to be protected, but is public
		' due to understood patterns in other modules:
		
		' The 'var1' and 'var2' arguments are likely X and Y coordinates.
		' The 'var3' argument is held internally as 'sb'.
		Method New(var1:Int, var2:Int, var3:SteamBase)
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
			Endif
		End
		
		' As mentioned in other files, these two arguments are very likely X and Y coordinates.
		Method refreshCollisionRect:Void(var1:Int, var2:Int)
			' Unknown magic number: 768 (May be related to 'COLLISION_OFFSET_Y' or similar variables)
			Local var3:= 768 + SteamPlatform.sPosY
			
			If (var3 > 0) Then
				var3 = 0
			EndIf
			
			If (var3 < -COLLISION_HEIGHT) Then
				var3 = -COLLISION_HEIGHT
			EndIf
			
			' This is probably something like: X, Y, W, H
			collisionRect.setRect((posX - (COLLISION_WIDTH/2)), (var3 + COLLISION_OFFSET_Y + posY), COLLISION_WIDTH, Abs(var3))
		End
End