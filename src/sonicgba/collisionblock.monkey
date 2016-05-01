Strict

' Friends:
Friend sonicgba.collisionmap

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
	Protected
		' Constant variable(s):
		Global BLANK_COLLISION_INFO:DataBuffer = New DataBuffer(8) ' Const
	Private
		' Fields:
		Field collisionInfo:DataBuffer
		Field collisionInfoOffset:Int
		
		Field degree:Int
		
		Field FLIP_X:Bool
		Field FLIP_Y:Bool
	Protected
		' Methods:
		
		' Extensions:
		Method getCollisionInfo:Byte(index:Int)
			Return Self.collisionInfo.PeekByte(index + Self.collisionInfo)
		End
	Public
		' Constant variable(s):
		Const COLLISION_INFO_STRIDE:= CollisionMap.COLLISION_INFO_STRIDE
		Const COLLISION_INFO_LAST_INDEX:= (COLLISION_INFO_STRIDE - 1)
		
		' Fields:
		Field ExtendsDegree:Bool
		Field throughable:Bool
		
		' Constructor(s):
		Method New(world:ACWorld)
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
			
			Self.ExtendsDegree = (Self.degree = 255)
			
			Local allEight:Bool = True
			
			For Local i:= collisionInfoOffset Until (collisionInfoOffset + COLLISION_INFO_STRIDE)
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
		
		Method getCollisionY:Int(value:Int)
			While (value < 0)
				value += 8
			Wend
			
			value Mod= 8
			
			If (Self.FLIP_X) Then
				value = (7 - value)
			EndIf
			
			' Magic number: 240 (Screen related?)
			Local colInfo:= ((getCollisionInfo(value) & 240) Shr 4)
			
			Local re:= 0
			
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
				re = 7 - re ' COLLISION_INFO_LAST_INDEX
			EndIf
			
			Return re
		End
		
		Method getCollisionX:Int(y:Int)
			While (y < 0)
				y += 8
			Wend
			
			y Mod= 8
			
			If (Self.FLIP_Y) Then
				y = (7 - y)
			EndIf
			
			Local colInfo:= (getCollisionInfo(y) & 15) ' Shr 0
			Local re:= 0
			
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
				re = (7 - re) ' COLLISION_INFO_LAST_INDEX
			EndIf
			
			Return re
		End
		
		Method getActualX:Int(y:Int)
			While (y < 0)
				y += 8
			Wend
			
			y Mod= 8
			
			If (Self.FLIP_Y) Then
				y = (7 - y)
			EndIf
			
			Local re:= (Self.collisionInfo[y] & 15) ' Shr 0
			
			If (re = 8 Or re = 0) Then
				Return re
			EndIf
			
			If (Self.FLIP_X) Then
				re = 7 - re ' COLLISION_INFO_LAST_INDEX
			EndIf
			
			Return re
		End
		
		Method getActualY:Int(x:Int)
			While (x < 0)
				x += 8
			Wend
			
			x Mod= 8
			
			If (Self.FLIP_X) Then
				x = (7 - x)
			EndIf
			
			Local re:= ((Self.collisionInfo[x] & 240) Shr 4)
			
			If (re = 8 Or re = 0) Then
				Return re
			EndIf
			
			If (Self.FLIP_Y) Then
				re = 7 - re ' COLLISION_INFO_LAST_INDEX
			EndIf
			
			Return re
		End
		
		Method getDegree:Int()
			Local re:= ((Self.degree * 360) / 256)
			
			If (re = 0) Then
				Return re
			EndIf
			
			If (Self.FLIP_X Or Self.FLIP_Y) Then
				re = -re
			EndIf
			
			Return (re + 360) Mod 360
		End
		
		Method getDegreeNearby:Int(degree:Int)
			If (Self.ExtendsDegree) Then
				Return degree
			EndIf
			
			Local re:= getDegree()
			Local degreeDiff:= Abs(degree - re)
			
			If (degreeDiff > 180) Then
				degreeDiff = (360 - degreeDiff)
			EndIf
			
			If (degreeDiff > 90) Then
				re = ((re + 180) Mod 360)
			EndIf
			
			Return re
		End
		
		Method getReverseX:Bool(y:Int, degree:Int)
			Local reverse:Bool = False
			
			While (y < 0)
				y += 8
			Wend
			
			y Mod= 8
			
			If (Self.FLIP_Y) Then
				y = (7 - y)
			EndIf
			
			Local colInfo:= (Self.collisionInfo[y] & 15) ' Shr 0
			
			If (colInfo > 8) Then
				reverse = True
			ElseIf (colInfo = 8 Or colInfo = 0) Then
				Local allEight:Bool = True
				
				For Local i:= 0 Until COLLISION_INFO_STRIDE
					colInfo = (getCollisionInfo(((y + i) Mod 8)) & 15) ' Shr 0
					
					If (colInfo > 0) Then
						If (colInfo > COLLISION_INFO_STRIDE) Then
							reverse = True
							
							allEight = False
						ElseIf (colInfo < 8) Then
							allEight = False
							
							Exit
						EndIf
					EndIf
				Next
				
				If (allEight) Then
					If (degree > 45 And degree < 135) Then
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
		
		Method getReverseY:Bool(x:Int, degree:Int)
			Local reverse:Bool = False
			
			While (x < 0)
				x += 8
			Wend
			
			x Mod= 8
			
			If (Self.FLIP_X) Then
				x = (7 - x)
			EndIf
			
			Local colInfo:= ((getCollisionInfo(x) & 240) Shr 4)
			
			If (colInfo > 8) Then
				If (Null <> Null) Then
					reverse = False
				Else
					reverse = True
				EndIf
				
			ElseIf (colInfo = 8) Then
				Local allEight:Bool = True
				
				For Local i:= 0 Until COLLISION_INFO_STRIDE
					colInfo = (getCollisionInfo(((x + i) Mod 8)) & 240) Shr 4
					
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
							
							Exit
						EndIf
					EndIf
				Next
				
				If (allEight) Then
					If (degree > 135 And degree < 225) Then
						Return True
					EndIf
					
					If (degree < 45 Or degree > 315) Then
						Return False
					EndIf
				EndIf
			EndIf
			
			If (Self.FLIP_Y) Then
				reverse = Not reverse
			EndIf
			
			Return reverse
		End
		
		Method needJudgeX:Bool(y:Int)
			If (Self.degree <> 0 And Not Self.ExtendsDegree) Then
				Return False
			EndIf
			
			Local needJudge:Bool = True
			
			If (((getCollisionInfo(y Mod 8) & 15) Shr 0) <> 8) Then
				needJudge = False
			EndIf
			
			Return needJudge
		End
		
		Method needJudgeY:Bool(x:Int)
			If (Self.degree <> 0 And Not Self.ExtendsDegree) Then
				Return False
			EndIf
			
			Local needJudge:Bool = True
			
			For Local i:= Self.collisionInfoOffset Until (Self.collisionInfoOffset + COLLISION_INFO_STRIDE)
				If (((Self.collisionInfo.PeekByte(i) & 240) Shr 4) <> 8) Then
					needJudge = False
					
					Exit
				EndIf
			Next
			
			Return needJudge
		End
		
		Method getCollisionYFromDown:Int(x:Int)
			If (Self.throughable) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			While (x < 0)
				x += getWidth()
			Wend
			
			x = ((x Mod getWidth()) Shr 6)
			
			If (Self.FLIP_X) Then
				x = (7 - x)
			EndIf
			
			Local colInfo:= ((getCollisionInfo(x) & 240) Shr 4)
			
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
				colInfo = (7 - colInfo)
			EndIf
			
			Return ((colInfo + 1) Shl 6) - 1
		End
		
		Method getCollisionYFromUp:Int(x:Int)
			While (x < 0)
				x += getWidth()
			Wend
			
			x = ((x Mod getWidth()) Shr 6)
			
			If (Self.FLIP_X) Then
				x = (7 - x)
			EndIf
			
			Local colInfo:= ((Self.collisionInfo[x] & 240) Shr 4)
			
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
				colInfo = (15 - colInfo)
			EndIf
			
			If (Self.FLIP_Y) Then
				colInfo = (7 - colInfo)
			EndIf
			
			Return (colInfo Shl 6)
		End
		
		Method getCollisionXFromLeft:Int(y:Int)
			If (Self.throughable) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			While (y < 0)
				y += getHeight()
			Wend
			
			y = ((y Mod getHeight()) Shr 6)
			
			If (Self.FLIP_Y) Then
				y = 7 - y
			EndIf
			
			Local colInfo:= (Self.collisionInfo[y] & 15) ' Shr 0
			
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
				colInfo = (15 - colInfo)
			EndIf
			
			If (Self.FLIP_X) Then
				colInfo = (7 - colInfo)
			EndIf
			
			Return (colInfo Shl 6)
		End
		
		Method getCollisionXFromRight:Int(y:Int)
			If (Self.throughable) Then
				Return ACParam.NO_COLLISION
			EndIf
			
			While (y < 0)
				y += getHeight()
			Wend
			
			y = ((y Mod getHeight()) Shr 6)
			
			If (Self.FLIP_Y) Then
				y = (7 - y)
			EndIf
			
			Local colInfo:= (Self.collisionInfo[y] & 15) ' Shr 0
			
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
				colInfo = (15 - colInfo)
			EndIf
			
			If (Self.FLIP_X) Then
				colInfo = (7 - colInfo)
			EndIf
			
			Return (((colInfo + 1) Shl 6) - 1)
		End
		
		Method getDegree:Int(degree:Int, direction:Int)
			If (Self.ExtendsDegree) Then
				Return degree
			EndIf
			
			Local re:= getDegree()
			
			If (re = 90 Or re = 270) Then
				If (direction = DIRECTION_UP) Then
					re = 0
				ElseIf (direction = DIRECTION_LEFT) Then
					re = 180
				EndIf
			EndIf
			
			If (re = 180 Or re = 0) Then
				If (direction = DIRECTION_DOWN) Then
					re = 90
				ElseIf (direction = DIRECTION_RIGHT) Then
					re = 270
				EndIf
			EndIf
			
			Local degreeDiff:= Abs(degree - re)
			
			If (degreeDiff > 180) Then
				degreeDiff = (360 - degreeDiff)
			EndIf
			
			If (degreeDiff > 90) Then
				re = ((re + 180) Mod 360)
			EndIf
			
			Return re
		End
		
		Method doBeforeCollisionCheck:Void()
			' Empty implementation.
		End
End