Strict

Public

#Rem
	Terrifying names aside, this seems to be the standard bumper object.
	Although, that does make me wonder what the heck a "hobin/horbin" is...
#End

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.soundsystem
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.playeramy
	Import sonicgba.playerknuckles
Public

' Classes:
Class Banper Extends GimmickObject ' Class Bumper Extends GimmickObject
	Private
		' Fields:
		Field isActived:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.isActived = False
		End
	Public
		' Methods:
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			Super.doWhileBeAttack(player, direction, animationID)
			
			' Optimization potential; this dynamic cast could be avoided with some extra work.
			If (PlayerAmy(player) And Not Self.isActived) Then
				Self.isActived = True
			End
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Local playerColRect:= player.getCollisionRect()
			
			' Magic number: 512 (Height, most likely)
			If ((playerColRect.y0 >= Self.collisionRect.y0 And playerColRect.y1 <= Self.collisionRect.y1 + 512) Or Self.iHeight > Self.iWidth) Then
				' Magic number: Collision state.
				player.setCollisionState(1)
				
				' Magic number: Animation ID.
				player.setAnimationId(4)
				
				Local knuckles:= PlayerKnuckles(player)
				
				If (knuckles <> Null And knuckles.flying) Then
					knuckles.flying = False
				EndIf
				
				Local preVelX:= player.getVelX()
				Local preVelY:= player.getVelY()
				
				' Magic numbers: These look to be related to the collision direction.
				' Although, they don't seem to match with 'ACParam' or 'SonicDef'.
				If ((Self.iLeft = 2 Or Self.iLeft = 4)) Then
					player.setVelX(-1200)
				Else
					player.setVelX(1200)
				EndIf
				
				If ((Self.iLeft = 1 Or Self.iLeft = 2)) Then
					player.setVelY(-1536)
				Else
					player.setVelY(1536)
				EndIf
				
				Local sePlayed:Bool = False
				
				' Magic number: 55 (Sound-effect ID)
				' Bump the player if they're moving toward this objData:
				If ((player.getVelX() * preVelX) <= 0) Then
					player.getCal().stopMoveX()
					
					SoundSystem.getInstance().playSe(55)
					
					sePlayed = True
				EndIf
				
				If ((player.getVelY() * preVelY) <= 0) Then
					player.getCal().stopMoveY()
					
					If (Not sePlayed) Then
						SoundSystem.getInstance().playSe(55)
					EndIf
				EndIf
				
				Self.isActived = True
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.isActived = False
		End
End