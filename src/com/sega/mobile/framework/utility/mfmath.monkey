Strict

Public

#Rem
	This file and/or uses of it will likely be replaced with proper floating-point operations.
	
	Until then, we're stuck with some pretty terrifying software.
#End

' Imports:
Private
	Import lib.constutil
	
	Import monkey.math
	
	Import regal.typetool
Public

' Classes:
Class MFMath
	Public
		' Constant variable(s):
		Const MAX_VALUE:Int = INT_MAX_POSITIVE_NUMBERS
		Const MIN_VALUE:Int = -INT_MAX_POSITIVE_NUMBERS
		
		' Global variable(s):
		Global f11E:Int = f12e[1] ' 11134
		
		Global PI:Int
	Private
		' Constant variable(s):
		Const ASCII_MINUS:= 45 ' '-'
		Const ASCII_DOT:= 46 ' '.'
		
		Const SYMBOL_DOT:= "."
		Const SYMBOL_ZERO:= "0"
		Const SYMBOL_MINUS:= "-"
		
		' Global variable(s):
		Global _fbits:Int = 12
		Global _digits:Int = 4
		Global _dmul:Int = 10000
		Global _flt:Int = 0
		Global _fmask:Int = 4095
		Global _one:Int = 4096
		Global _pi:Int = 12868
		
		Global f12e:Int[] = [4096, 11134, 30266, 82270, 223636] ' _one
	Public
		' Functions:
		Function setPrecision:Int(i:Int)
			If (i > 12 Or i < 0) Then
				Return _digits
			EndIf
			
			_fbits = i
			_one = (1 Shl i)
			_flt = (12 - i)
			_digits = 0
			_dmul = 1
			_fmask = (_one - 1)
			
			PI = (_pi Shr _flt)
			
			f11E = (f12e[1] Shr _flt)
			
			Local j:= _one
			
			While (j <> 0)
				j /= 10
				
				_digits += 1
				_dmul *= 10
			Wend
			
			Return _digits
		End
		
		Function getPrecision:Int()
			Return _fbits
		End
		
		Function toInt:Int(i:Int)
			Return (round(i, 0) Shr _fbits)
		End
		
		Function toFP:Int(i:Int)
			Return (i Shl _fbits)
		End
		
		Function convert:Int(i:Int, j:Int)
			Local Byte0:= Byte(DSgn(i >= 0))
			
			If (abs(j) >= 13) Then
				Return i
			EndIf
			
			If (_fbits < j) Then
				Return (((1 Shl ((j - _fbits) Shr 1)) * Byte0) + i) Shr (j - _fbits) ' / 2
			EndIf
			
			Return i Shl (_fbits - j)
		End
		
		Function toFP:Int(s:String)
			' Local variable(s):
			Local i:= 0
			
			If (s[0] = ASCII_MINUS) Then
				i = 1
			EndIf
			
			Local s1:String = "-1"
			
			Local j:= s.Find(SYMBOL_DOT)
			
			If (j >= 0) Then
				s1 = s[(j + 1)..(s.Length)]
				
				While (s1.Length < _digits)
					s1 += SYMBOL_ZERO
				Wend
				
				If (s1.Length > _digits) Then
					s1 = s1[..(_digits)]
				EndIf
			Else
				j = s.Length
			EndIf
			
			Local k:= 0
			
			If (i <> j) Then
				k = Int(s[i..j])
			EndIf
			
			Local i1:= (k Shl _fbits) + (((Int(s1) + 1) Shl _fbits) / _dmul)
			
			If (i = 1) Then
				Return -i1
			EndIf
			
			Return i1
		End
		
		Function toString:String(i:Int)
			Local flag:Bool = False
			
			If (i < 0) Then
				flag = True
				
				i = -i
			EndIf
			
			Local j = (i Shr _fbits)
			
			Local s:= String((_dmul * (_fmask & i)) Shr _fbits)
			
			While (s.Length < _digits) {
				s = "0" + s
			EndIf
			
			Local output:String = (String(j) + SYMBOL_DOT + s)
			
			If (flag) Then
				Return SYMBOL_MINUS + output
			EndIf
			
			Return output
		End
		
		Function toString:String(i:Int, j:Int)
			If (j > _digits) Then
				j = _digits
			EndIf
			
			Local s:= toString(round(i, j))
			
			Return s[..((s.Length - _digits) + j)]
		End
		
		Function max:Int(i:Int, j:Int)
			Return math.Max(i, j) ' PickValue((i >= j), i, j)
		End
		
		Function min:Int(i:Int, j:Int)
			Return math.Min(i, j) ' PickValue((j >= i), i, j)
		End
		
		Function round:Int(i:Int, j:Int)
			Local k:= 10
			
			For Local l:= 0 Until j
				k *= 10
			Next
			
			k = div(toFP(5), toFP(k))
			
			If (i < 0) Then
				k = -k
			EndIf
			
			Return (i + k)
		End
		
		Function mul:Int(i:Int, j:Int)
			Local flag:Bool = False
			
			Local k:= _fbits
			Local l:= _fmask
			
			If ((i & l) = 0) Then
				Return ((i Shr k) * j)
			EndIf
			
			If ((j & l) = 0) Then
				Return ((j Shr k) * i)
			EndIf
			
			If ((i < 0 And j > 0) Or (i > 0 And j < 0)) Then
				flag = True
			EndIf
			
			If (i < 0) Then
				i = -i
			EndIf
			
			If (j < 0) Then
				j = -j
			EndIf
			
			While (max(i, j) >= (1 Shl (31 - k)))
				i Shr= 1
				j Shr= 1
				l Shr= 1
				
				k -= 1
			Wend
			
			Local i1:= (((((i Shr k) * (j Shr k)) Shl k) + ((((i & l) * (j & l)) Shr k) + ((((l ~ -1) & i) * (j & l)) Shr k))) + (((i & l) * ((l ~ -1) & j)) Shr k)) Shl (_fbits - k)
			
			If (i1 >= 0) Then
				Return PickValue((flag), -i1, i1)
			Else
				Throw New ArithmeticException("Overflow")
			EndIf
			
			Return 0
		End
		
		Function div:Int(i:Int, j:Int)
			Local flag:Bool = False
			
			Local k:= _fbits
			
			If (j = _one) Then
				Return i
			EndIf
			
			If ((_fmask & j) = 0) Then
				Return (i / (j Shr k))
			EndIf
			
			If ((i < 0 And j > 0) Or (i > 0 And j < 0)) Then
				flag = True
			EndIf
			
			If (i < 0) Then
				i = -i
			EndIf
			
			If (j < 0) Then
				j = -j
			EndIf
			
			While (max(i, j) >= (1 Shl (31 - k)))
				i Shr= 1
				j Shr= 1
				
				k -= 1
			Wend
			
			Local l:= ((i Shl k) / j) Shl (_fbits - k)
			
			If (flag) Then
				Return -l
			EndIf
			
			Return l
		End
		
		Function add:Int(i:Int, j:Int)
			Return (i + j)
		End
		
		Function sub:Int(i:Int, j:Int)
			Return (i - j)
		End
		
		Function abs:Int(i:Int)
			If (i < 0) Then
				Return -i
			EndIf
			
			Return i ' Abs(i)
		End
		
		Function sqrt:Int(i:Int, j:Int)
			If (i < 0) Then
				Throw New ArithmeticException("Bad Input")
			ElseIf (i = 0) Then
				Return 0
			EndIf
			
			Local k:= ((_one + i) Shr 1) ' / 2
			
			For Local l:= 0 Until j
				k = ((div(i, k) + k) Shr 1) ' / 2
			Next
			
			If (k >= 0) Then
				Return k
			Else
				Throw New ArithmeticException("Overflow")
			EndIf
			
			Return 0
		End
		
		Function sqrt:Int(i:Int)
			Return sqrt(i, 16)
		End
		
		Function sin:Int(i:Int)
			Local j:= (mul(i, div(toFP(180), PI)) Mod toFP(360))
			
			If (j < 0) Then
				j += toFP(360)
			EndIf
			
			Local k:= j
			
			If (j >= toFP(90) And j < toFP(270)) Then
				k = (toFP(180) - j)
			ElseIf (j >= toFP(270) And j < toFP(360)) Then
				k = -(toFP(360) - j)
			EndIf
			
			Local l:= (k / 90)
			
			Local i1:= mul(l, l)
			
			Return mul(mul(mul(mul(-18 Shr _flt, i1) + (326 Shr _flt), i1) - (2646 Shr _flt), i1) + (6434 Shr _flt), l)
		End
		
		Function asin:Int(i:Int)
			If (abs(i) > _one) Then
				Throw New ArithmeticException("Bad Input")
			EndIf
			
			Local flag:Bool = (i < 0)
			
			If (i < 0) Then
				i = -i
			EndIf
			
			Local k:= (PI / 2) - mul(sqrt(_one - i), mul(mul(mul(mul(35 Shr _flt, i) - (StringIndex.STR_RESET_RECORD Shr _flt), i) + (347 Shr _flt), i) - (877 Shr _flt), i) + (6434 Shr _flt))
			
			Return PickValue(flag, -k, k)
		End
		
		Function cos:Int(i:Int)
			Return sin((PI / 2) - i)
		End
		
		Function acos:Int(i:Int)
			Return (PI / 2) - asin(i)
		End
		
		Function tan:Int(i:Int)
			Return div(sin(i), cos(i))
		End
		
		Function cot:Int(i:Int)
			Return div(cos(i), sin(i))
		End
		
		Function atan:Int(i:Int)
			Return asin(div(i, sqrt(_one + mul(i, i))))
		End
		
		Function exp:Int(r10:Int)
			' UNIMPLEMENTED FUNCTION.
		End
		
		Function log:Int(i:Int)
			If (i <= 0) Then
				Throw New ArithmeticException("Bad Input")
			EndIf
			
			Local j:= 0
			Local l:= 0
			
			While (i >= (_one Shl 1))
				i Shr= 1
				
				l += 1
			Wend
			
			Local i1 = (l * (2839 Shr _flt))
			Local j1 = 0
			
			If (i < _one) Then
				Return -log(div(_one, i))
			EndIf
			
			i -= _one
			
			For Local k1:= 1 Until 20
				Local k:Int
				
				If (j = 0) Then
					k = i
				Else
					k = mul(j, i)
				EndIf
				
				If (k = 0) Then
					Exit
				EndIf
				
				j1 += ((DSgn((k1 Mod 2) <> 0) * k) / k1)
				
				j = k
			EndIf
			
			Return (i1 + j1)
		End
		
		Function pow:Int(i:Int, j:Int)
			Local flag:Bool = (j < 0)
			
			Local k:= _one
			
			j = abs(j)
			
			Local l:= (j Shr _fbits)
			
			While (True)
				Local l2:= (l - 1)
				
				If (l <= 0) Then
					Exit
				EndIf
				
				k = mul(k, i)
				l = l2
			Wend
			
			If (k < 0) Then
				Throw New ArithmeticException("Overflow")
			EndIf
			
			If (i <> 0) Then
				k = mul(k, exp(mul(log(i), _fmask & j)))
			Else
				k = 0
			EndIf
			
			If (flag) Then
				Return div(_one, k)
			EndIf
			
			Return k
		End
		
		Function atan2:Int(y:Int, x:Int)
			If (y = 0 And x = 0) Then
				Return 0
			EndIf
			
			If (x > 0) Then
				Return atan(div(y, x))
			EndIf
			
			If (x >= 0) Then
				Return (PickValue((y >= 0), PI / 2, -PI) / 2)
			EndIf
			
			If (y < 0) Then
				Return (-PI) + atan(div(y, x))
			EndIf
			
			Return (PI - atan(abs(div(y, x))))
		End
End

' Exceptions:
Class ArithmeticException Extends Throwable
	Public
		' Constructor(s):
		Method New(message:String)
			Self.message = message
		End
		
		' Methods:
		Method ToString:String() ' Property
			Return Self.message
		End
	Protected
		' Fields:
		Field message:String
End