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
Class Rect ' Final
	Public
		' Functions:
		Function intersects:Bool(a:Rect, b:Rect)
			Return (a.left < b.right And b.left < a.right And a.top < b.bottom And b.top < a.bottom)
		End
		
		' Fields:
		Field left:Int
		Field top:Int
		Field right:Int
		Field bottom:Int
		
		' Constructor(s):
		Method New()
			' Nothing so far.
		End
		
		Method New(left:Int, top:Int, right:Int, bottom:Int)
			Set(left, top, right, bottom)
		End
		
		Method New(rect:Rect)
			set(rect)
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
		
		Method ToString:String()
			Const separator:String = ", "
			
			Return "Rect(" + String(left) + separator + String(top) + separator + String(right) + separator + String(bottom) + ")"
		End
		
		Method isEmpty:Bool()
			Return (left >= right Or top >= bottom)
		End
		
		Method width:Int()
			Return (right - left)
		End
		
		Method height:Int()
			Return (bottom-top)
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
		
		Method setEmpty:Void()
			set(0, 0, 0, 0)
		End
		
		Method set:Void(left:Int, top:Int, right:Int, bottom:Int)
			Self.left = left
			Self.top = top
			Self.right = right
			Self.bottom = bottom
		End
		
		Method set:Void(src:Rect)
			If (src = Null) Then
				set(0, 0, 0, 0)
				
				Return
			EndIf
			
			set(src.left, src.top, src.right, src.bottom)
		End
		
		Method offset:Void(dx:Int, dy:Int)
			left += dx
			top += dy
			right += dx
			bottom += dy
		End
		
		Method offsetTo:Void(newLeft:Int, newTop:Int)
			right += (newLeft - left)
			bottom += (newTop - top)
			
			left = newLeft
			top = newTop
		End
		
		Method inset:Void(dx:Int, dy:Int)
			left += dx
			top += dy
			right -= dx
			bottom -= dy
		End
		
		Method contains:Bool(x:Int, y:Int)
			Return (left < right And top < bottom And x >= left And x < right And y >= top And y < bottom)
		End
		
		Method contains:Bool(left:Int, top:Int, right:Int, bottom:Int)
			Return (Self.left < Self.right And Self.top < Self.bottom And Self.left <= left And Self.top <= top And Self.right >= right And Self.bottom >= bottom)
		End
		
		Method contains:Bool(r:Rect)
			Return contains(r.left, r.top, r.right, r.bottom)
		End
		
		Method intersect:Bool(left:Int, top:Int, right:Int, bottom:Int)
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
		
		Method intersect:Bool(r:Rect)
			Return intersect(r.left, r.top, r.right, r.bottom)
		End
		
		Method setIntersect:Bool(a:Rect, b:Rect)
			If (a.left < b.right And b.left < a.right And a.top < b.bottom And b.top < a.bottom) Then
				left = Max(a.left, b.left)
				top = Max(a.top, b.top)
				right = Min(a.right, b.right)
				bottom = Min(a.bottom, b.bottom)
				
				Return True
			EndIf
			
			Return False
		End
		
		Method intersects:Bool(left:Int, top:Int, right:Int, bottom:Int)
			Return (Self.left < right And left < Self.right And Self.top < bottom And top < Self.bottom)
		End
		
		Method union:Void(left:Int, top:Int, right:Int, bottom:Int)
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
		
		Method union:Void(r:Rect)
			union(r.left, r.top, r.right, r.bottom)
		End
		
		Method union:Void(x:Int, y:Int)
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
			left = Int(Float(left) * scalar + 0.5)
			top = Int(Float(top) * scalar + 0.5)
			right = Int(Float(right) * scalar + 0.5)
			bottom = Int(Float(bottom) * scalar + 0.5)
		End
		
		Method scaleRoundIn:Void(scalar:Float)
			left = Int(Ceil(Float(left) * scalar))
			top = Int(Ceil(Float(top) * scalar))
			right = Int(Ceil(Float(right) * scalar))
			bottom = Int(Ceil(Float(bottom) * scalar))
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