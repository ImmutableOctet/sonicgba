Strict

' Imports:
Private
	Import lib.constutil
	
	Import sonicgba.sonicdef
	Import sonicgba.collisionmap
	
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.acworld
	
	Import brl.databuffer
	
	Import regal.typetool
Public

' Classes:
Class CollisionBlock Extends ACBlock ' Implements SonicDef
	Private
		' Constant variable(s):
		Global BLANK_COLLISION_INFO:DataBuffer = New DataBuffer(8) ' Const
		
		' Fields:
		Field collisionInfo:DataBuffer
		Field collisionInfoOffset:Int
		
		Field degree:Int
		
		Field FLIP_X:Bool
		Field FLIP_Y:Bool
	Public
		' Fields:
		Field ExtendsDegree:Bool
		Field throughable:Bool
		
		' Constructor(s):
		Method new(world:ACWorld)
			Super.New(world)
			
			Self.collisionInfo = BLANK_COLLISION_INFO
		End
		
		' Methods:
		Method setProperty:Void(collisionInfo:DataBuffer, collisionOffset:Int, FLIP_X:Bool, FLIP_Y:Bool, degree:Int, attr:Bool)
			Self.collisionInfo = collisionInfo
			Self.collisionInfoOffset = collisionOffset
			
			Self.FLIP_X = FLIP_X
			Self.FLIP_Y = FLIP_Y
			
			Self.degree = PickValue((degree < 0), (degree + 256), degree)
			
			Self.ExtendsDegree = (Self.degree = 255))
			
			Local allEight:Bool = True
			
			For Local i:= collisionInfoOffset Until (collisionInfoOffset + CollisionMap.COLLISION_INFO_STRIDE)
				Local value:= collisionInfo.PeekByte(i)
				
				If (((value & 240) Shr 4) <> 8 Or ((value & 15)) <> 8) Then ' Shr 0
					allEight = False
					
					Exit
				EndIf
			Next
			
			If (allEight And (degree = 0 Or degree = 180)) Then
				Self.ExtendsDegree = True
			EndIf
			
			Self.throughable = attr
		End
		
		Method setProperty:Void(anotherBlock:CollisionBlock)
			setProperty(anotherBlock.collisionInfo, anotherBlock.collisionInfoOffset, anotherBlock.FLIP_X, anotherBlock.FLIP_Y, anotherBlock.degree, anotherBlock.throughable)
		End
		
		Public Method getCollisionY:Int(x:Int)
			While (x < 0) {
				x += 8
			EndIf
			x Mod= 8
			
			If (Self.FLIP_X) Then
				x = 7 - x
			EndIf
			
			Int colInfo = (Self.collisionInfo[x] & SSdef.PLAYER_MOVE_HEIGHT) Shr 4
			Int re = 0
			
			If (colInfo = 8) Then
				Return 0
			EndIf
			
			If (colInfo = 0) Then
				Return -1
			EndIf
			
			If (colInfo < 8) Then
				re = colInfo
			ElseIf (colInfo > 8) Then
				re = 15 - colInfo
			EndIf
			
			If (Self.FLIP_Y) Then
				re = 7 - re
			EndIf
			
			Return re
		End
		
		Public Method getCollisionX:Int(y:Int)
			While (y < 0) {
				y += 8
			EndIf
			y Mod= 8
			
			If (Self.FLIP_Y) Then
				y = 7 - y
			EndIf
			
			Int colInfo = (Self.collisionInfo[y] & 15) Shr 0
			Int re = 0
			
			If (colInfo = 8) Then
				Return 0
			EndIf
			
			If (colInfo = 0) Then
				Return -1
			EndIf
			
			If (colInfo < 8) Then
				re = colInfo
			ElseIf (colInfo > 8) Then
				re = 15 - colInfo
			EndIf
			
			If (Self.FLIP_X) Then
				re = 7 - re
			EndIf
			
			Return re
		End
		
		Public Method getActualX:Int(y:Int)
			While (y < 0) {
				y += 8
			EndIf
			y Mod= 8
			
			If (Self.FLIP_Y) Then
				y = 7 - y
			EndIf
			
			Int re = (Self.collisionInfo[y] & 15) Shr 0
			
			If (re = 8 Or re = 0) Then
				Return re
			EndIf
			
			If (Self.FLIP_X) Then
				re = 7 - re
			EndIf
			
			Return re
		End
		
		Public Method getActualY:Int(x:Int)
			While (x < 0) {
				x += 8
			EndIf
			x Mod= 8
			
			If (Self.FLIP_X) Then
				x = 7 - x
			EndIf
			
			Int re = (Self.collisionInfo[x] & SSdef.PLAYER_MOVE_HEIGHT) Shr 4
			
			If (re = 8 Or re = 0) Then
				Return re
			EndIf
			
			If (Self.FLIP_Y) Then
				re = 7 - re
			EndIf
			
			Return re
		End
		
		Public Method getDegree:Int()
			Int re = (Self.degree * MDPhone.SCREEN_WIDTH) / 256
			
			If (re = 0) Then
				Return re
			EndIf
			
			If (Self.FLIP_X) Then
				re = -re
			EndIf
			
			If (Self.FLIP_Y) Then
				re = -re
			EndIf
			
			Return (re + MDPhone.SCREEN_WIDTH) Mod MDPhone.SCREEN_WIDTH
		End
		
		Public Method getDegreeNearby:Int(degree:Int)
			
			If (Self.ExtendsDegree) Then
				Return degree
			EndIf
			
			Int re = getDegree()
			Int degreeDiff = Abs(degree - re)
			
			If (degreeDiff > 180) Then
				degreeDiff = MDPhone.SCREEN_WIDTH - degreeDiff
			EndIf
			
			If (degreeDiff > 90) Then
				re = (re + 180) Mod MDPhone.SCREEN_WIDTH
			EndIf
			
			Return re
		End
		
		Public Method getReverseX:Bool(y:Int, degree:Int)
			Bool reverse = False
			While (y < 0) {
				y += 8
			EndIf
			y Mod= 8
			
			If (Self.FLIP_Y) Then
				y = 7 - y
			EndIf
			
			Int colInfo = (Self.collisionInfo[y] & 15) Shr 0
			
			If (colInfo > 8) Then
				If (Null <> Null) Then
					reverse = False
				Else
					reverse = True
				EndIf
				
			ElseIf (colInfo = 8 Or colInfo = 0) Then
				Bool allEight = True
				For (Int i = 0; i < 8; i += 1)
					colInfo = (Self.collisionInfo[(y + i) Mod 8] & 15) Shr 0
					
					If (colInfo > 0) Then
						If (colInfo > 8) Then
							If (Null <> Null) Then
								reverse = False
							Else
								reverse = True
							EndIf
							
							allEight = False
						ElseIf (colInfo < 8) Then
							allEight = False
							break
						EndIf
					EndIf
				EndIf
				If (allEight) Then
					If (degree > 45 And degree < StringIndex.FONT_COLON_RED) Then
						Return True
					EndIf
					
					If (degree > 225 And degree < 315) Then
						Return False
					EndIf
				EndIf
			EndIf
			
			If (Self.FLIP_X) Then
				If (reverse) Then
					reverse = False
				Else
					reverse = True
				EndIf
			EndIf
			
			Return reverse
		End
		
		Public Method getReverseY:Bool(x:Int, degree:Int)
			Bool reverse = False
			While (x < 0) {
				x += 8
			EndIf
			x Mod= 8
			
			If (Self.FLIP_X) Then
				x = 7 - x
			EndIf
			
			Int colInfo = (Self.collisionInfo[x] & SSdef.PLAYER_MOVE_HEIGHT) Shr 4
			
			If (colInfo > 8) Then
				If (Null <> Null) Then
					reverse = False
				Else
					reverse = True
				EndIf
				
			ElseIf (colInfo = 8) Then
				Bool allEight = True
				For (Int i = 0; i < 8; i += 1)
					colInfo = (Self.collisionInfo[(x + i) Mod 8] & SSdef.PLAYER_MOVE_HEIGHT) Shr 4
					
					If (colInfo >= 0) Then
						If (colInfo > 8) Then
							If (Null <> Null) Then
								reverse = False
							Else
								reverse = True
							EndIf
							
							allEight = False
						ElseIf (colInfo < 8) Then
							allEight = False
							break
						EndIf
					EndIf
				EndIf
				If (allEight) Then
					If (degree > StringIndex.FONT_COLON_RED And degree < 225) Then
						Return True
					EndIf
					
					If (degree < 45 Or degree > 315) Then
						Return False
					EndIf
				EndIf
			EndIf
			
			If (Self.FLIP_Y) Then
				If (reverse) Then
					reverse = False
				Else
					reverse = True
				EndIf
			EndIf
			
			Return reverse
		End
		
		Public Method needJudgeX:Bool(y:Int)
			
			If (Self.degree <> 0 And Not Self.ExtendsDegree) Then
				Return False
			EndIf
			
			Bool needJudge = True
			
			If (((Self.collisionInfo[y Mod 8] & 15) Shr 0) <> 8) Then
				needJudge = False
			EndIf
			
			Return needJudge
		End
		
		Public Method needJudgeY:Bool(x:Int)
			
			If (Self.degree <> 0 And Not Self.ExtendsDegree) Then
				Return False
			EndIf
			
			Bool needJudge = True
			For (Byte b : Self.collisionInfo)
				
				If (((b & SSdef.PLAYER_MOVE_HEIGHT) Shr 4) <> 8) Then
					needJudge = False
					break
				EndIf
			EndIf
			Return needJudge
		End
		
		Public Method getCollisionYFromDown:Int(x:Int)
			
			If (Self.throughable) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			While (x < 0) {
				x += getWidth()
			EndIf
			x = (x Mod getWidth()) Shr 6
			
			If (Self.FLIP_X) Then
				x = 7 - x
			EndIf
			
			Int colInfo = (Self.collisionInfo[x] & SSdef.PLAYER_MOVE_HEIGHT) Shr 4
			
			If (colInfo = 8) Then
				Return downSide
			EndIf
			
			If (colInfo = 0) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			If ((colInfo > 8 And Self.FLIP_Y) Or (colInfo < 8 And Not Self.FLIP_Y)) Then
				Return downSide
			EndIf
			
			If (colInfo > 8) Then
				colInfo = 15 - colInfo
			EndIf
			
			If (Self.FLIP_Y) Then
				colInfo = 7 - colInfo
			EndIf
			
			Return ((colInfo + 1) Shl 6) - 1
		End
		
		Public Method getCollisionYFromUp:Int(x:Int)
			While (x < 0) {
				x += getWidth()
			EndIf
			x = (x Mod getWidth()) Shr 6
			
			If (Self.FLIP_X) Then
				x = 7 - x
			EndIf
			
			Int colInfo = (Self.collisionInfo[x] & SSdef.PLAYER_MOVE_HEIGHT) Shr 4
			
			If (colInfo = 8) Then
				Return 0
			EndIf
			
			If (colInfo = 0) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			If ((colInfo > 8 And Not Self.FLIP_Y) Or (colInfo < 8 And Self.FLIP_Y)) Then
				Return 0
			EndIf
			
			If (colInfo > 8) Then
				colInfo = 15 - colInfo
			EndIf
			
			If (Self.FLIP_Y) Then
				colInfo = 7 - colInfo
			EndIf
			
			Return colInfo Shl 6
		End
		
		Public Method getCollisionXFromLeft:Int(y:Int)
			
			If (Self.throughable) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			While (y < 0) {
				y += getHeight()
			EndIf
			y = (y Mod getHeight()) Shr 6
			
			If (Self.FLIP_Y) Then
				y = 7 - y
			EndIf
			
			Int colInfo = (Self.collisionInfo[y] & 15) Shr 0
			
			If (colInfo = 8) Then
				Return 0
			EndIf
			
			If (colInfo = 0) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			If ((colInfo > 8 And Not Self.FLIP_X) Or (colInfo < 8 And Self.FLIP_X)) Then
				Return 0
			EndIf
			
			If (colInfo > 8) Then
				colInfo = 15 - colInfo
			EndIf
			
			If (Self.FLIP_X) Then
				colInfo = 7 - colInfo
			EndIf
			
			Return colInfo Shl 6
		End
		
		Public Method getCollisionXFromRight:Int(y:Int)
			
			If (Self.throughable) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			While (y < 0) {
				y += getHeight()
			EndIf
			y = (y Mod getHeight()) Shr 6
			
			If (Self.FLIP_Y) Then
				y = 7 - y
			EndIf
			
			Int colInfo = (Self.collisionInfo[y] & 15) Shr 0
			
			If (colInfo = 8) Then
				Return rightSide
			EndIf
			
			If (colInfo = 0) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			If ((colInfo > 8 And Self.FLIP_X) Or (colInfo < 8 And Not Self.FLIP_X)) Then
				Return rightSide
			EndIf
			
			If (colInfo > 8) Then
				colInfo = 15 - colInfo
			EndIf
			
			If (Self.FLIP_X) Then
				colInfo = 7 - colInfo
			EndIf
			
			Return ((colInfo + 1) Shl 6) - 1
		End
		
		Public Method getDegree:Int(degree:Int, direction:Int)
			
			If (Self.ExtendsDegree) Then
				Return degree
			EndIf
			
			Int re = getDegree()
			
			If (re = 90 Or re = 270) Then
				If (direction = 0) Then
					re = 0
				ElseIf (direction = 2) Then
					re = 180
				EndIf
			EndIf
			
			If (re = 180 Or re = 0) Then
				If (direction = 1) Then
					re = 90
				ElseIf (direction = 3) Then
					re = 270
				EndIf
			EndIf
			
			Int degreeDiff = Abs(degree - re)
			
			If (degreeDiff > 180) Then
				degreeDiff = MDPhone.SCREEN_WIDTH - degreeDiff
			EndIf
			
			If (degreeDiff > 90) Then
				re = (re + 180) Mod MDPhone.SCREEN_WIDTH
			EndIf
			
			Return re
		End
		
		Public Method doBeforeCollisionCheck:Void()
		End
End