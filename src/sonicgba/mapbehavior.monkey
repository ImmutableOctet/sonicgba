Strict

Public

' Imports:
' Nothing so far.

' Interfaces:
Interface MapBehavior
	' Methods:
	Method doWhileTouchRoof:Void(var1:Int, var2:Int)
	Method doWhileTouchGround:Void(var1:Int, var2:Int)
	
	Method getGravity:Int()
	
	Method hasDownCollision:Bool()
	Method hasSideCollision:Bool()
	Method hasTopCollision:Bool()
End