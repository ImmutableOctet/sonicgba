Strict

Public

' Imports:
Private
	Import regal.typetool
	Import regal.util.bufferview
Public

' Classes:
Class MapView Extends GenericMapView<ShortArrayView>
	Public
		' Constructor(s):
		Method New(width:UInt, height:UInt, __direct:Bool=False)
			Super.New(width, height, __direct)
		End
		
		Method New(data:DataBuffer, width:UInt, height:UInt, offsetInBytes:UInt=0)
			Super.New(data, width, height, offsetInBytes)
		End
		
		Method New(view:GenericMapView<ShortArrayView>, extraOffset:UInt=0)
			Super.New(view, extraOffset)
		End
End

Class GenericMapView<ViewType> Extends ViewType Abstract
	Protected
		' Fields:
		Field width:UInt, height:UInt
	Public
		' Constructor(s):
		Method New(width:UInt, height:UInt, __direct:Bool=False)
			Super.New((width * height), __direct)
			
			SetDimensions(width, height)
		End
		
		Method New(data:DataBuffer, width:UInt, height:UInt, offsetInBytes:UInt=0)
			Super.New(data, offsetInBytes, (width * height))
			
			SetDimensions(width, height)
		End
		
		Method New(view:GenericMapView, extraOffset:UInt=0)
			Super.New(view, view.Length, extraOffset)
			
			SetDimensions(view.Width, view.Height)
		End
	Protected
		' Constructor(s):
		Method SetDimensions:Void(width:UInt, height:UInt) Final
			Self.width = width
			Self.height = height
		End
	Public
		' Methods:
		Method IndexAt:UInt(x:UInt, y:UInt, width:UInt, height:UInt=0) ' Int
			Return ((y * width) + x)
		End
		
		Method IndexAt:UInt(x:UInt, y:UInt)
			Return IndexAt(x, y, Self.width, 0)
		End
		
		Method GetAt:Long(x:UInt, y:UInt) ' Int
			Return GetAt(x, y, Self.width, 0)
		End
		
		Method GetAt:Long(x:UInt, y:UInt, width:UInt, height:UInt=0) ' Int
			Return Get(IndexAt(x, y, width, height))
		End
		
		Method SetAt:Void(x:UInt, y:UInt, value:Long) ' Int
			SetAt(x, y, Self.width, 0, value)
		End
		
		Method SetAt:Void(x:UInt, y:UInt, width:UInt, height:UInt, value:Long) ' Int
			Set(IndexAt(x, y, width, height), value)
		End
		
		' Properties:
		Method Width:UInt() Property Final
			Return Self.width
		End
		
		Method Height:UInt() Property Final
			Return Self.height
		End
End