Strict

Public

#Rem
	This module contains a reimplementation of most of the Android API's 'Rect' class. ('android.graphics.Rect')
	This is not in any way related to external modules such as 'regal', and does not guarantee full compatibility.
#End

' Imports:
Private
	Import monkey.math
	
	Import brl.stream
Public

' Classes:
Class RectBase<T> Abstract
	Public
		' Functions:
		Function intersects:Bool(a:RectBase, b:RectBase)
			Return (a.left < b.right And b.left < a.right And a.top < b.bottom And b.top < a.bottom)
		End
		
		' Fields:
		Field left:T
		Field top:T
		Field right:T
		Field bottom:T
		
		' Constructor(s):
		Method New()
			' Nothing so far.
		End
		
		Method New(left:T, top:T, right:T, bottom:T)
			set(left, top, right, bottom)
		End
		
		Method New(rect:RectBase)
			set(rect)
		End
		
		' Methods (Abstract):
		'Method hashCode:T() Abstract
		
		Method centerX:T() Abstract
		Method centerY:T() Abstract
		
		' Extensions:
		
		' I/O Routines:
		Method read:Void(in:Stream) Abstract
		Method write:Void(out:Stream) Abstract
		
		' Methods (Implemented):
		Method ToString:String()
			Const separator:String = ", "
			
			Return "RectBase(" + String(left) + separator + String(top) + separator + String(right) + separator + String(bottom) + ")"
		End
		
		Method isEmpty:Bool()
			Return (left >= right Or top >= bottom)
		End
		
		Method width:T()
			Return (right - left)
		End
		
		Method height:T()
			Return (bottom-top)
		End
		
		Method setEmpty:Void()
			set(0, 0, 0, 0)
		End
		
		Method set:Void(left:T, top:T, right:T, bottom:T)
			Self.left = left
			Self.top = top
			Self.right = right
			Self.bottom = bottom
		End
		
		Method set:Void(src:RectBase)
			If (src = Null) Then
				set(0, 0, 0, 0)
				
				Return
			EndIf
			
			set(src.left, src.top, src.right, src.bottom)
		End
		
		Method offset:Void(dx:T, dy:T)
			left += dx
			top += dy
			right += dx
			bottom += dy
		End
		
		Method offsetTo:Void(newLeft:T, newTop:T)
			right += (newLeft - left)
			bottom += (newTop - top)
			
			left = newLeft
			top = newTop
		End
		
		Method inset:Void(dx:T, dy:T)
			left += dx
			top += dy
			right -= dx
			bottom -= dy
		End
		
		Method contains:Bool(x:T, y:T)
			Return (left < right And top < bottom And x >= left And x < right And y >= top And y < bottom)
		End
		
		Method contains:Bool(left:T, top:T, right:T, bottom:T)
			Return (Self.left < Self.right And Self.top < Self.bottom And Self.left <= left And Self.top <= top And Self.right >= right And Self.bottom >= bottom)
		End
		
		Method contains:Bool(r:RectBase)
			Return contains(r.left, r.top, r.right, r.bottom)
		End
		
		Method intersect:Bool(left:T, top:T, right:T, bottom:T)
			If (Self.left < right And left < Self.right And Self.top < bottom And top < Self.bottom) Then
				If (Self.left < left) Then
					Self.left = left
				EndIf
				
				If (Self.top < top) Then
					Self.top = top
				EndIf
				
				If (Self.right > right) Then
					Self.right = right
				EndIf
				
				If (Self.bottom > bottom) Then
					Self.bottom = bottom
				EndIf
				
				Return True
			EndIf
			
			Return False
		End
		
		Method intersect:Bool(r:RectBase)
			Return intersect(r.left, r.top, r.right, r.bottom)
		End
		
		Method setIntersect:Bool(a:RectBase, b:RectBase)
			If (a.left < b.right And b.left < a.right And a.top < b.bottom And b.top < a.bottom) Then
				left = Max(a.left, b.left)
				top = Max(a.top, b.top)
				right = Min(a.right, b.right)
				bottom = Min(a.bottom, b.bottom)
				
				Return True
			EndIf
			
			Return False
		End
		
		Method intersects:Bool(left:T, top:T, right:T, bottom:T)
			Return (Self.left < right And left < Self.right And Self.top < bottom And top < Self.bottom)
		End
		
		Method union:Void(left:T, top:T, right:T, bottom:T)
			If ((left < right) And (top < bottom)) Then
				If ((Self.left < Self.right) And (Self.top < Self.bottom)) Then
					If (Self.left > left) Then
						Self.left = left
					EndIf
					
					If (Self.top > top) Then
						Self.top = top
					EndIf
					
					If (Self.right < right) Then
						Self.right = right
					EndIf
					
					If (Self.bottom < bottom) Then
						Self.bottom = bottom
					EndIf
				Else
					Self.left = left;
					Self.top = top;
					Self.right = right;
					Self.bottom = bottom;
				EndIf
			EndIf
		End
		
		Method union:Void(r:RectBase)
			union(r.left, r.top, r.right, r.bottom)
		End
		
		Method union:Void(x:T, y:T)
			If (x < left) Then
				left = x
			ElseIf (x > right) Then
				right = x
			EndIf
			
			If (y < top) Then
				top = y
			ElseIf (y > bottom) Then
				bottom = y
			EndIf
		End
		
		Method sort:Void()
			If (left > right) Then
				Local temp:= left
				
				left = right
				right = temp
			EndIf
			
			If (top > bottom) Then
				Local temp:= top
				
				top = bottom
				bottom = temp
			EndIf
		End
		
		Method scale:Void(scalar:Float)
			left = T(Float(left) * scalar + 0.5)
			top = T(Float(top) * scalar + 0.5)
			right = T(Float(right) * scalar + 0.5)
			bottom = T(Float(bottom) * scalar + 0.5)
		End
		
		Method scaleRoundIn:Void(scalar:Float)
			left = T(Ceil(Float(left) * scalar))
			top = T(Ceil(Float(top) * scalar))
			right = T(Ceil(Float(right) * scalar))
			bottom = T(Ceil(Float(bottom) * scalar))
		End
End

Class RectF Extends RectBase<Float> ' Final
	Public
		' Constructor(s):
		Method New()
			' Nothing so far.
		End
		
		Method New(left:Float, top:Float, right:Float, bottom:Float)
			Super.New(left, top, right, bottom)
		End
		
		Method New(rect:RectF)
			Super.New(rect)
		End
		
		' Methods:
		#Rem
			Method equals:Bool(r:RectF)
				If (Self = r) Then
					Return True
				ElseIf (r = Null) Then
					Return False
				EndIf
				
				Return ((left = r.left) And (top = r.top) And (right = r.right) And (bottom = r.bottom))
			End
		#End
		
		#Rem
			Method hashCode:Int()
				Local result:= left
				
				result = (31 * result + top)
				result = (31 * result + right)
				result = (31 * result + bottom)
				
				Return result
			End
		#End
		
		Method CenterX:Float()
			Return ((left + right) * 0.5)
		End
		
		Method CenterY:Float()
			Return ((top + bottom) * 0.5)
		End
		
		' Extensions:
		
		' I/O Routines:
		Method read:Void(in:Stream)
			left = in.ReadFloat()
			top = in.ReadFloat()
			right = in.ReadFloat()
			bottom = in.ReadFloat()
		End
		
		Method write:Void(out:Stream)
			out.WriteFloat(left)
			out.WriteFloat(top)
			out.WriteFloat(right)
			out.WriteFloat(bottom)
		End
End

Class Rect Extends RectBase<Int> ' Final
	Public
		' Constructor(s):
		Method New()
			' Nothing so far.
		End
		
		Method New(left:Int, top:Int, right:Int, bottom:Int)
			Super.New(left, top, right, bottom)
		End
		
		Method New(rect:Rect)
			Super.New(rect)
		End
		
		' Methods:
		Method equals:Bool(r:Rect)
			If (Self = r) Then
				Return True
			ElseIf (r = Null) Then
				Return False
			EndIf
			
			Return ((left = r.left) And (top = r.top) And (right = r.right) And (bottom = r.bottom))
		End
		
		Method hashCode:Int()
			Local result:= left
			
			result = (31 * result + top)
			result = (31 * result + right)
			result = (31 * result + bottom)
			
			Return result
		End
		
		Method centerX:Int()
			Return ((left + right) Shr 1)
		End
		
		Method centerY:Int()
			Return ((top + bottom) Shr 1)
		End
		
		Method exactCenterX:Float()
			Return (Float(left + right) * 0.5)
		End
		
		Method exactCenterY:Float()
			Return (Float(top + bottom) * 0.5)
		End
		
		' Extensions:
		
		' I/O Routines:
		Method read:Void(in:Stream)
			left = in.ReadInt()
			top = in.ReadInt()
			right = in.ReadInt()
			bottom = in.ReadInt()
		End
		
		Method write:Void(out:Stream)
			out.WriteInt(left)
			out.WriteInt(top)
			out.WriteInt(right)
			out.WriteInt(bottom)
		End
End