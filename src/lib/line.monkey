Strict

Public

' Imports:
Import lib.direction
Import lib.crlfp32

' Classes:
Class Line
	Private
		' Constant variable(s):
		Global DIVISOR:Int[] = [2, 3, 5, 7, 11, 13, 17, 19, 23] ' Const
		
		' Global variable(s):
		Global line1:Line = New Line()
		Global line2:Line = New Line()
	Public
		' Functions:
		Function getCrossPoint:Void(re:CrossPoint, x0:Int, y0:Int, x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int)
			re.reset()
			
			line1.setProperty(x0, y0, x1, y1)
			line2.setProperty(x2, y2, x3, y3)
			
			line1.getCrossPoint(re, line2)
			
			If (Not re.hasPoint) Then
				Return
			EndIf
			
			If (re.x < Min(x0, x1) Or re.x > Max(x0, x1) Or re.x < Min(x2, x3) Or re.x > Max(x2, x3) Or re.y < Min(y0, y1) Or re.y > Max(y0, y1) Or re.y < Min(y2, y3) Or re.y > Max(y2, y3)) Then
				re.hasPoint = False
			EndIf
		End
		
		' Fields:
		Field A:Int
		Field B:Int
		Field C:Int
		
		' Constructor(s):
		Method New(x0:Int, y0:Int, x1:Int, y1:Int)
			setProperty(x0, y0, x1, y1)
		End
		
		Method New(A:Int, B:Int, C:Int)
			Self.A = A
			Self.B = B
			Self.C = C
		End
		
		' Methods:
		Method setProperty:Void(x0:Int, y0:Int, x1:Int, y1:Int)
			Self.A = y1 - y0
			Self.B = x0 - x1
			Self.C = (Self.A * x0) + (Self.B * y0)
			dealDivisor()
		End
		
		Method getX:Int(y:Int)
			If (isHorizontal()) Then
				Return 0
			EndIf
			
			Return (Self.C - (Self.B * y)) / Self.A
		End
		
		Method getY:Int(x:Int)
			If (isVertical()) Then
				Return 0
			EndIf
			
			Return (Self.C - (Self.A * x)) / Self.B
		End
		
		Method isHorizontal:Bool()
			If (Self.A = 0) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method isVertical:Bool()
			If (Self.B = 0) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method isLegal:Bool()
			If (isHorizontal() And isVertical()) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method getPlumbLine:Line()
			Return New Line(-Self.B, Self.A, 0)
		End
		
		Method getCrossPoint:Void(re:CrossPoint, x0:Int, y0:Int, x1:Int, y1:Int)
			re.reset()
			
			line2.setProperty(x0, y0, x1, y1)
			getCrossPoint(re, line2)
			
			If (Not re.hasPoint) Then
				Return
			EndIf
			
			If (re.x < Min(x0, x1) Or re.x > Max(x0, x1) Or re.y < Min(y0, y1) Or re.y > Max(y0, y1)) Then
				re.hasPoint = False
			EndIf
		End
		
		Method getCrossPoint:Void(re:CrossPoint, l:Line)
			re.reset()
			
			If (l <> Null And l.isLegal()) Then
				If (Not isHorizontal() Or Not l.isHorizontal()) Then
					If ((Not isVertical() Or Not l.isVertical()) And (Self.A * l.B) - (Self.B * l.A) <> 0) Then
						Local x:= ((Self.C * l.B) - (l.C * Self.B)) / ((Self.A * l.B) - (Self.B * l.A))
						Local y:= ((l.C * Self.A) - (Self.C * l.A)) / ((Self.A * l.B) - (Self.B * l.A))
						
						re.hasPoint = True
						
						re.x = x
						re.y = y
					EndIf
				EndIf
			EndIf
		End
		
		Method cos:Int(length:Int)
			Return Abs(((Self.B * length) Shl 3) / CrlFP32.sqrt((Self.A * Self.A) + (Self.B * Self.B)))
		End
		
		Method sin:Int(length:Int)
			Return Abs(((Self.A * length) Shl 3) / CrlFP32.sqrt((Self.A * Self.A) + (Self.B * Self.B)))
		End
		
		Method directRatio:Bool()
			Return ((Self.B * Self.A) < 0)
		End
		
		Method getOneDirection:Direction()
			If (isHorizontal()) Then
				Return New Direction(-1, 0)
			EndIf
			
			If (isVertical()) Then
				Return New Direction(0, -1)
			EndIf
			
			If (directRatio()) Then
				Return New Direction(1, 1)
			EndIf
			
			If (directRatio()) Then
				Return New Direction(0, 0)
			EndIf
			
			Return New Direction(-1, 1)
		End
	Private
		' Methods:
		Method dealDivisor:Void()
			If (Self.A <> 0 Or Self.B <> 0) Then
				For Local d:= EachIn DIVISOR
					While ((Self.A Mod d) = 0 And (Self.B Mod d) = 0 And (Self.C Mod d) = 0)
						Self.A /= d
						Self.B /= d
						Self.C /= d
					Wend
				Next
			EndIf
		End
End

Class CrossPoint
	' Fields:
	Field x:Int
	Field y:Int
	
	Field hasPoint:Bool
	
	' Methods:
	Method reset:Void()
		Self.hasPoint = False
	End
End