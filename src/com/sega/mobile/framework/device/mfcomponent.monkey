Strict

Public

' Imports:
' Nothing so far.

' Interfaces:
Interface MFComponent
	' Methods:
	Method getPointerID:Int() ' Property
	Method getPointerX:Int() ' Property
	Method getPointerY:Int() ' Property
	
	Method pointerDragged:Void(id:Int, x:Int, y:Int)
	Method pointerPressed:Void(id:Int, x:Int, y:Int)
	Method pointerReleased:Void(id:Int, x:Int, y:Int)
	
	Method reset:Void()
	Method tick:Void()
End