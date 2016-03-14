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
		Method New(x:Int, y:Int, sb:SteamBase)
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
			' Unknown magic number: 768 (May be related to 'COLLISION_OFFSET_Y' or similar variables)
			Local height:= 768 + SteamPlatform.sPosY
			
			If (height > 0) Then
				height = 0
			EndIf
			
			If (height < -COLLISION_HEIGHT) Then
				height = -COLLISION_HEIGHT
			EndIf
			
			' This is probably something like: X, Y, W, H
			collisionRect.setRect((x - (COLLISION_WIDTH/2)), (height + COLLISION_OFFSET_Y + y), COLLISION_WIDTH, Abs(height)) ' posX ' posY
		End
End