Strict

Public

' Imports:
Private
	Import regal.typetool
Public

' Classes:
Class CrlFP32 ' Final
	Private
		' Constant variable(s):
		Const DIGITS:Int = 4
		Const DIGIT_MULTIPLIER:Int = 10000
		
		Const FIXED_MASK:Int = 63
		
		Const MBOOSTER_MAX_INSTANCES:Int = 0
	Public
		' Constant variable(s):
		Const ERROR_NONE:Int = 0
		Const ERROR_BAD_INPUT:Int = 1
		Const ERROR_OVERFLOW:Int = 2
		
		Const FIXED_1:Int = 64
		
		Const FIXED_POINT_PRECISION:Int = 6
		
		Const MAX_VALUE:Int = INT_MAX
		
		Global PI:Int = div(20096, 6400) ' Const
		Const SHIFT_SCALE:Int = 18
		
		' Global variable(s):
		Global DIGIT_0Dot28d:Int = div(1792, 6400)
		Global errorCode:Int = PI
		Global objCount:Int
		
		' Functions:
		Function toInt:Int(l:Int) ' Final
			Return (round(l) Shr FIXED_POINT_PRECISION)
		End
	
		Function round:Int(i:Int)
			Local k:Int
			
			If (i < 0) Then
				k = -32
			Else
				k = 32
			EndIf
			
			Return (i + k)
		End
		
		Function toFP:Int(i:Int) ' Final
			Return (i Shl FIXED_POINT_PRECISION)
		End
		
		Function mul:Int(i:Int, j:Int) ' Final
			Local i2:= PI
			
			If ((i & FIXED_MASK) = 0) Then
				Return (i Shr FIXED_POINT_PRECISION) * j
			EndIf
			
			If ((j & FIXED_MASK) = 0) Then
				Return (j Shr FIXED_POINT_PRECISION) * i
			EndIf
			
			Local i3:Int ' Float
			
			If (i < 0) Then
				i3 = ERROR_BAD_INPUT
			Else
				i3 = PI
			EndIf
			
			If (j < 0) Then
				i2 = ERROR_BAD_INPUT
			EndIf
			
			Local flag:= Bool(i3 ~ i2)
			
			If (i < 0) Then
				i = -i
			EndIf
			
			If (j < 0) Then
				j = -j
			EndIf
			
			Local k:= FIXED_POINT_PRECISION
			Local l:= FIXED_MASK
			
			While (True)
				If (i >= j) Then
					i3 = i
				Else
					i3 = j
				EndIf
				
				If (i3 < (1 Shl (31 - k))) Then
					Exit
				EndIf
				
				i Shr= 1
				j Shr= 1
				l Shr= 1
				
				k -= 1
			Wend
			
			Local i1:= (((((i Shr k) * (j Shr k)) Shl k) + ((((i & l) * (j & l)) Shr k) + ((((l ~ -1) & i) * (j & l)) Shr k))) + (((i & l) * ((l ~ -1) & j)) Shr k)) Shl (FIXED_POINT_PRECISION - k)
			
			If (i1 < 0) Then
				errorCode = ERROR_OVERFLOW
			EndIf
			
			If (flag) Then
				Return -i1
			EndIf
			
			Return i1
		End
	
		Function abs:Int(i:Int)
			If (i < 0) Then
				Return -i
			EndIf
			
			Return i
		End
	
		Function div:Int(i:Int, j:Int) ' Final
			Local i2:= PI
			
			If (j = FIXED_1) Then
				Return i
			EndIf
			
			If ((j & FIXED_MASK) = 0) Then
				Return i / (j Shr FIXED_POINT_PRECISION)
			EndIf
			
			Local i3:Int
			
			If (i < 0) Then
				i3 = ERROR_BAD_INPUT
			Else
				i3 = PI
			EndIf
			
			If (j < 0) Then
				i2 = ERROR_BAD_INPUT
			EndIf
			
			Local flag:= Bool(i3 ~ i2)
			
			If (i < 0) Then
				i = -i
			EndIf
			
			If (j < 0) Then
				j = -j
			EndIf
			
			Local k:= FIXED_POINT_PRECISION
			
			While (True)
				If (i > j) Then
					i3 = i
				Else
					i3 = j
				EndIf
				
				If (i3 < (1 Shl (31 - k))) Then
					Exit
				EndIf
				
				i Shr= 1
				j Shr= 1
				
				k -= 1
			Wend
			
			Local l:= ((i Shl k) / j) Shl (FIXED_POINT_PRECISION - k)
			
			If (flag) Then
				Return -l
			EndIf
			
			Return l
		End
		
		Function sqrt:Int(r5:Int) ' Final
			If (var0 < 0) Then
				errorCode = 1
			Endif
			
			If (var0 = 0) Then
				Return 0
			EndIf
			
			Local var1:Int
			
			If (var0 > 630400) Then
				var1 = 4096 + mul(var0, 15)
			ElseIf (var0 > 128000) Then
				var1 = 1856 + mul(var0, 32)
			Else
				var1 = 1152 + mul(var0, 55)
			EndIf
		
			Local var2:= 0
			Local var3:= 6
			
			While (True)
				var1 += div(var0, var1) Shr 1
				
				If (var1 = var2 Or var3 = 0) Then
					Exit
				EndIf
				
				var2 = var1
				var3 -= 1
			Wend
			
			If (var1 < 0) Then
				errorCode = 2
			EndIf
			
			return var1
		End
	
		Function actTan:Int(radian:Int)
			If (Abs(radian) <= FIXED_1) Then
				Return div(radian, mul(DIGIT_0Dot28d, sqr(radian)) + FIXED_1)
			EndIf
			
			Local retval:= div(-radian, sqr(radian) + DIGIT_0Dot28d)
			
			If (radian < -1) Then
				Return retval - (PI / ERROR_OVERFLOW)
			EndIf
			
			Return retval + (PI / ERROR_OVERFLOW)
		End
	
		Function sqr:Int(x:Int)
			Return mul(x, x)
		End
		
		Function actTan:Int(y:Int, x:Int)
			If (y = 0 And x = 0) Then
				Return PI
			EndIf
			
			If (x > 0) Then
				Return actTan(div(y, x))
			EndIf
			
			If (x >= 0) Then
				If (y >= 0) Then
					Return (PI / ERROR_OVERFLOW)
				EndIf
				
				Return ((-PI) / ERROR_OVERFLOW)
			EndIf
			
			If (y < 0) Then
				Return -(PI - actTan(div(y, x)))
			EndIf
			
			Return PI - actTan(div(-y, x))
		End
	
		Function actTanDegree:Int(y:Int, x:Int)
			Local re:= ((actTan(y, x) * 180) / PI)
			
			While (re < 0)
				re += 360
			Wend
			
			Return (re Mod 360)
		End
End