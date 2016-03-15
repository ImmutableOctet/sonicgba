Strict

Public

' Imports:
Private
	Import sonicgba.gameobject
Public

' Classes:

' Presumed base class for objects with some form of motion.
' May be for specialized objects hierarchy unknown.
Class MoveObject Extends GameObject Abstract
	Protected
		' Fields:
		Field totalVelocity:Int
	Public
		' Methods:
		
		' Property potential:
		Method getVelX:Int()
			Return velX
		End
		
		Method getVelY:Int()
			Return velY
		End
		
		Method setVelX:Void(value:Int)
			velX = value
			
			Return 
		End
		
		Method setVelY:Void(value:Int)
			velY = value
			
			Return 
		End
End