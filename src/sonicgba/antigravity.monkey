Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
Public

' Classes:
Class AntiGravity Extends GimmickObject
	Private
		' Fields:
		Field activeAfterNoCollison:Bool
		Field enterPlayerX:Int
		Field iLeft:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.iLeft = left
			
			If (Self.iLeft = 0 And Self.iTop = 0) Then
				Self.activeAfterNoCollison = True
			EndIf
		End
	Public
		' Methods:
		Method doWhileNoCollision:Void()
			If (Self.activeAfterNoCollison And Self.used And (player.getCheckPositionX() > Self.enterPlayerX + 1000 Or player.getCheckPositionX() < Self.enterPlayerX - 1000)) Then
				player.setAntiGravity(Not player.isAntiGravity)
			EndIf
			
			Self.used = False
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future.
			If (p = player) Then
				If (Self.activeAfterNoCollison) Then
					If (Self.firstTouch) Then
						Self.enterPlayerX = p.getCheckPositionX()
						Self.used = True
					EndIf
				ElseIf (Not Self.collisionRect.collisionChk(p.getCheckPositionX(), p.getCheckPositionY())) Then
					Self.used = False
				ElseIf (Not Self.used) Then
					' Magic numbers: Not sure if these are directions or not.
					Select (Self.iLeft)
						Case 0 ' DIRECTION_UP
							If (Self.iTop <> 0) Then
								p.setAntiGravity(False)
							Else
								p.setAntiGravity(Not p.isAntiGravity)
							EndIf
						Case 1 ' DIRECTION_DOWN
							p.setAntiGravity(False)
						Case 2 ' DIRECTION_LEFT
							p.setAntiGravity(True)
					End Select
					
					Self.used = True
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x, y, Self.mWidth, Self.mHeight)
		End
End