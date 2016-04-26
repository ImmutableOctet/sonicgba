Strict

Public

' Imports:
Private
	Import lib.constutil
	
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
		
		Public Function toString:String(i:Int)
			Bool flag = False
			
			If (i < 0) Then
				flag = True
				i = -i
			EndIf
			
			Int j = i Shr _fbits
			String s = Integer.toString((_dmul * (_fmask & i)) Shr _fbits)
			While (s.Length < _digits) {
				s = "0" + s
			EndIf
			
			Return New StringBuilder(String.valueOf(flag ? "-" : "")).append(Integer.toString(j)).append(".").append(s).toString()
		End
		
		Public Function toString:String(i:Int, j:Int)
			
			If (j > _digits) Then
				j = _digits
			EndIf
			
			String s = toString(round(i, j))
			Return s[..((s.Length - _digits) + j)]
		}
		
		Public Function max:Int(i:Int, j:Int)
			Return i >= j ? i : j
		}
		
		Public Function min:Int(i:Int, j:Int)
			Return j >= i ? i : j
		}
		
		Public Function round:Int(i:Int, j:Int)
			Int k = 10
			For (Int l = 0; l < j; l += 1)
				k *= 10
			EndIf
			k = div(toFP(5), toFP(k))
			
			If (i < 0) Then
				k = -k
			EndIf
			
			Return i + k
		}
		
		Public Function mul:Int(i:Int, j:Int)
			Bool flag = False
			Int k = _fbits
			Int l = _fmask
			
			If ((i & l) = 0) Then
				Return (i Shr k) * j
			EndIf
			
			If ((j & l) = 0) Then
				Return (j Shr k) * i
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
			
			While (max(i, j) >= (1 Shl (31 - k))) {
				i Shr= 1
				j Shr= 1
				l Shr= 1
				k -= 1
			EndIf
			Int i1 = (((((i Shr k) * (j Shr k)) Shl k) + ((((i & l) * (j & l)) Shr k) + ((((l ~ -1) & i) * (j & l)) Shr k))) + (((i & l) * ((l ~ -1) & j)) Shr k)) Shl (_fbits - k)
			
			If (i1 >= 0) Then
				Return flag ? -i1 : i1
			Else
				throw New ArithmeticException("Overflow")
			EndIf
			
		}
		
		Public Function div:Int(i:Int, j:Int)
			Bool flag = False
			Int k = _fbits
			
			If (j = _one) Then
				Return i
			EndIf
			
			If ((_fmask & j) = 0) Then
				Return i / (j Shr k)
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
			
			While (max(i, j) >= (1 Shl (31 - k))) {
				i Shr= 1
				j Shr= 1
				k -= 1
			EndIf
			Int l = ((i Shl k) / j) Shl (_fbits - k)
			
			If (flag) Then
				Return -l
			EndIf
			
			Return l
		}
		
		Public Function add:Int(i:Int, j:Int)
			Return i + j
		}
		
		Public Function sub:Int(i:Int, j:Int)
			Return i - j
		}
		
		Public Function abs:Int(i:Int)
			
			If (i < 0) Then
				Return -i
			EndIf
			
			Return i
		}
		
		Public Function sqrt:Int(i:Int, j:Int)
			
			If (i < 0) Then
				throw New ArithmeticException("Bad Input")
			ElseIf (i = 0) Then
				Return 0
			Else
				Int k = (_one + i) Shr 1
				For (Int l = 0; l < j; l += 1)
					k = (div(i, k) + k) Shr 1
				EndIf
				If (k >= 0) Then
					Return k
				EndIf
				
				throw New ArithmeticException("Overflow")
			EndIf
			
		}
		
		Public Function sqrt:Int(i:Int)
			Return sqrt(i, 16)
		}
		
		Public Function sin:Int(i:Int)
			Int j = mul(i, div(toFP((Int) 180), PI)) Mod toFP((Int) MDPhone.SCREEN_WIDTH)
			
			If (j < 0) Then
				j += toFP((Int) MDPhone.SCREEN_WIDTH)
			EndIf
			
			Int k = j
			
			If (j >= toFP(90) And j < toFP(270)) Then
				k = toFP((Int) 180) - j
			ElseIf (j >= toFP(270) And j < toFP((Int) MDPhone.SCREEN_WIDTH)) Then
				k = -(toFP((Int) MDPhone.SCREEN_WIDTH) - j)
			EndIf
			
			Int l = k / 90
			Int i1 = mul(l, l)
			Return mul(mul(mul(mul(-18 Shr _flt, i1) + (326 Shr _flt), i1) - (2646 Shr _flt), i1) + (6434 Shr _flt), l)
		}
		
		Public Function asin:Int(i:Int)
			
			If (abs(i) > _one) Then
				throw New ArithmeticException("Bad Input")
			EndIf
			
			Bool flag = i < 0
			
			If (i < 0) Then
				i = -i
			EndIf
			
			Int k = (PI / 2) - mul(sqrt(_one - i), mul(mul(mul(mul(35 Shr _flt, i) - (StringIndex.STR_RESET_RECORD Shr _flt), i) + (347 Shr _flt), i) - (877 Shr _flt), i) + (6434 Shr _flt))
			Return flag ? -k : k
		}
		
		Public Function cos:Int(i:Int)
			Return sin((PI / 2) - i)
		}
		
		Public Function acos:Int(i:Int)
			Return (PI / 2) - asin(i)
		}
		
		Public Function tan:Int(i:Int)
			Return div(sin(i), cos(i))
		}
		
		Public Function cot:Int(i:Int)
			Return div(cos(i), sin(i))
		}
		
		Public Function atan:Int(i:Int)
			Return asin(div(i, sqrt(_one + mul(i, i))))
		}
		
		/* JADX WARNING: inconsistent code. */
		/* Code decompiled incorrectly, please refer to instructions dump. */
		Public Function exp:Int(r10:Int)
			/*
			
			If (r10 <> 0) goto L_0x0005
		L_0x0002:
			r8 = _one
		L_0x0004:
			Return r8
		L_0x0005:
			
			If (r10 >= 0) goto L_0x0045
		L_0x0007:
			r8 = 1
			r0 = r8
		L_0x0009:
			r10 = abs(r10)
			r8 = _fbits
			r2 = r10 Shr r8
			r4 = _one
			r6 = 0
		L_0x0014:
			r8 = r2 / 4
			
			If (r6 < r8) goto L_0x0048
		L_0x0018:
			r8 = r2 Mod 4
			
			If (r8 <= 0) goto L_0x0029
		L_0x001c:
			r8 = f12e
			r9 = r2 Mod 4
			r8 = r8[r9]
			r9 = _flt
			r8 = r8 Shr r9
			r4 = mul(r4, r8)
		L_0x0029:
			r8 = _fmask
			r10 = r10 & r8
			
			If (r10 <= 0) goto L_0x003b
		L_0x002e:
			r1 = _one
			r3 = 0
			r5 = 1
			r7 = 0
		L_0x0033:
			r8 = 16
			
			If (r7 < r8) goto L_0x0057
		L_0x0037:
			r4 = mul(r4, r3)
		L_0x003b:
			
			If (r0 = 0) goto L_0x0043
		L_0x003d:
			r8 = _one
			r4 = div(r8, r4)
		L_0x0043:
			r8 = r4
			goto L_0x0004
		L_0x0045:
			r8 = 0
			r0 = r8
			goto L_0x0009
		L_0x0048:
			r8 = f12e
			r9 = 4
			r8 = r8[r9]
			r9 = _flt
			r8 = r8 Shr r9
			r4 = mul(r4, r8)
			r6 = r6 + 1
			goto L_0x0014
		L_0x0057:
			r8 = r1 / r5
			r3 = r3 + r8
			r1 = mul(r1, r10)
			r8 = r7 + 1
			r5 = r5 * r8
			
			If (r5 > r1) goto L_0x0037
		L_0x0063:
			
			If (r1 <= 0) goto L_0x0037
		L_0x0065:
			
			If (r5 <= 0) goto L_0x0037
		L_0x0067:
			r7 = r7 + 1
			goto L_0x0033
			*/
			throw New UnsupportedOperationException("Method not decompiled: com.sega.mobile.framework.utility.MFMath.exp(Int):Int")
		}
		
		Public Function log:Int(i:Int)
			
			If (i <= 0) Then
				throw New ArithmeticException("Bad Input")
			EndIf
			
			Int j = 0
			Int l = 0
			While (i >= (_one Shl 1)) {
				i Shr= 1
				l += 1
			EndIf
			Int i1 = l * (2839 Shr _flt)
			Int j1 = 0
			
			If (i < _one) Then
				Return -log(div(_one, i))
			EndIf
			
			i -= _one
			For (Int k1 = 1; k1 < 20; k1 += 1)
				Int k
				
				If (j = 0) Then
					k = i
				Else
					k = mul(j, i)
				EndIf
				
				If (k = 0) Then
					break
				EndIf
				
				j1 += ((k1 Mod 2 <> 0 ? 1 : -1) * k) / k1
				j = k
			EndIf
			Return i1 + j1
		}
		
		Public Function pow:Int(i:Int, j:Int)
			Bool flag = j < 0
			Int k = _one
			j = abs(j)
			Int l = j Shr _fbits
			While (True) {
				Int l2 = l - 1
				
				If (l <= 0) Then
					break
				EndIf
				
				k = mul(k, i)
				l = l2
			EndIf
			If (k < 0) Then
				throw New ArithmeticException("Overflow")
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
		}
		
		Public Function atan2:Int(y:Int, x:Int)
			
			If (y = 0 And x = 0) Then
				Return 0
			EndIf
			
			If (x > 0) Then
				Return atan(div(y, x))
			EndIf
			
			If (x >= 0) Then
				Return y >= 0 ? PI / 2 : (-PI) / 2
			Else
				
				If (y < 0) Then
					Return (-PI) + atan(div(y, x))
				EndIf
				
				Return PI - atan(abs(div(y, x)))
			EndIf
			
		End
End
