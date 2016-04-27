Strict

Public

' Imports:
Private
	Import lib.constutil
	
	Import sonicgba.collisionrect
	Import sonicgba.gameobject
	Import sonicgba.playerobject
	Import sonicgba.sonicdef
Public

' Classes:
Class PlayerAnimationCollisionRect ' Implements SonicDef
	Private
		' Global variable(s):
		Global rectH:CollisionRect = New CollisionRect()
		Global rectV:CollisionRect = New CollisionRect()
		
		' Fields:
		Field initFlag:Bool
		
		Field animationID:Int
		
		Field player:PlayerObject
	Public
		' Constant variable(s):
		Const CHECK_OFFSET:Int = 192
		
		' Fields:
		Field collisionRect:CollisionRect
		Field preCollisionRect:CollisionRect
		
		' Constructor(s):
		Method New(player:PlayerObject)
			Self.player = player
			
			Self.collisionRect = New CollisionRect()
			Self.preCollisionRect = New CollisionRect()
			
			Self.initFlag = True
		End
		
		' Methods:
		Method initCollision:Void(xOffset:Int, yOffset:Int, width:Int, height:Int, animationID:Int)
			Local anti_adjust_y:= PickValue(Self.player.isAntiGravity, (-yOffset) - height, yOffset)
			
			Local xPos:= (Self.player.posX + xOffset)
			Local yPos:= (Self.player.posY + anti_adjust_y)
			
			Self.collisionRect.setRect(xPos, yPos, width, height)
			
			If (Self.initFlag) Then
				Local collisionRect:= Self.preCollisionRect
				
				collisionRect.setRect(xPos, yPos, width, height)
				
				Self.initFlag = False
			EndIf
			
			Self.animationID = animationID
		End
		
		Method reset:Void()
			Self.initFlag = True
		End
		
		Method calPreCollision:Void()
			Self.preCollisionRect.setTwoPosition(Self.collisionRect.x0, Self.collisionRect.y0, Self.collisionRect.x1, Self.collisionRect.y1)
		End
		
		Method collisionChkWithObject:Void(obj:GameObject)
			Local objectRect:= obj.getCollisionRect()
			Local thisRect:= Self.collisionRect
			
			rectH.setRect(thisRect.x0, thisRect.y0 + CHECK_OFFSET, thisRect.getWidth(), thisRect.getHeight() - (CHECK_OFFSET * 2))
			rectV.setRect(thisRect.x0 + CHECK_OFFSET, thisRect.y0, thisRect.getWidth() - (CHECK_OFFSET * 2), thisRect.getHeight())
			
			If (objectRect.collisionChk(rectH) Or objectRect.collisionChk(rectV)) Then
				doWhileCollisionWrap(obj)
			EndIf
		End
		
		Method doWhileCollisionWrap:Void(obj:GameObject)
			Local direction:= DIRECTION_NONE
			
			Local moveDistanceX:= obj.getMoveDistance().x
			Local moveDistanceY:= obj.getMoveDistance().y
			
			Local collisionRectCurrent:= Self.collisionRect
			Local collisionRectBefore:= Self.preCollisionRect
			
			Local objCollisionRect:= obj.getCollisionRect()
			
			Local xFirst:Bool
			
			If (Abs(collisionRectCurrent.x0 - collisionRectBefore.x0) >= Abs(collisionRectCurrent.y0 - collisionRectBefore.y0)) Then
				xFirst = True
			Else
				xFirst = False
			EndIf
			
			rectH.setRect(collisionRectCurrent.x0, collisionRectCurrent.y0 + CHECK_OFFSET, collisionRectCurrent.getWidth(), collisionRectCurrent.getHeight() - (CHECK_OFFSET * 2))
			rectV.setRect(collisionRectCurrent.x0 + CHECK_OFFSET, collisionRectCurrent.y0, collisionRectCurrent.getWidth() - (CHECK_OFFSET * 2), collisionRectCurrent.getHeight())
			
			If (xFirst And rectH.collisionChk(objCollisionRect)) Then
				If ((collisionRectCurrent.x1 - collisionRectBefore.x1 > 0 And collisionRectBefore.isLeftOf(objCollisionRect, CHECK_OFFSET)) Or (Not rectV.collisionChk(objCollisionRect) And collisionRectCurrent.x0 < objCollisionRect.x0 And Self.player.getVelX() >= -CHECK_OFFSET)) Then
					direction = DIRECTION_RIGHT
				ElseIf ((collisionRectCurrent.x0 - collisionRectBefore.x0 < 0 And collisionRectBefore.isRightOf(objCollisionRect, CHECK_OFFSET)) Or (Not rectV.collisionChk(objCollisionRect) And collisionRectCurrent.x1 > objCollisionRect.x1 And Self.player.getVelX() <= CHECK_OFFSET)) Then
					direction = DIRECTION_LEFT
				EndIf
			EndIf
			
			If (direction = DIRECTION_NONE And rectV.collisionChk(objCollisionRect)) Then
				' Magic number: 5
				If (collisionRectCurrent.y1 - collisionRectBefore.y1 > 0 And collisionRectBefore.isUpOf(objCollisionRect, CHECK_OFFSET + 5)) Then
					direction = DIRECTION_DOWN
				ElseIf (collisionRectCurrent.y0 - collisionRectBefore.y0 < 0 And collisionRectBefore.isDownOf(objCollisionRect, CHECK_OFFSET)) Then
					direction = DIRECTION_UP
				EndIf
			EndIf
			
			If (direction = DIRECTION_NONE And rectH.collisionChk(objCollisionRect)) Then
				If ((collisionRectCurrent.x1 - collisionRectBefore.x1 > 0 And collisionRectBefore.isLeftOf(objCollisionRect, CHECK_OFFSET)) Or (Not rectV.collisionChk(objCollisionRect) And collisionRectCurrent.x0 < objCollisionRect.x0 And Self.player.getVelX() >= -CHECK_OFFSET)) Then
					direction = DIRECTION_RIGHT
				ElseIf ((collisionRectCurrent.x0 - collisionRectBefore.x0 < 0 And collisionRectBefore.isRightOf(Self.collisionRect, CHECK_OFFSET)) Or (Not rectV.collisionChk(objCollisionRect) And collisionRectCurrent.x1 > Self.collisionRect.x1 And Self.player.getVelX() <= CHECK_OFFSET)) Then
					direction = DIRECTION_LEFT
				EndIf
			EndIf
			
			obj.doWhileBeAttack(Self.player, direction, Self.animationID)
			
			calPreCollision()
		End
End