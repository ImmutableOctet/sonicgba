Strict

Public

' Imports:
Import sonicgba.gameobject

' Classes:
Class MoveObject Extends GameObject
	Protected
		' Fields:
		Field totalVelocity:Int
	Public
		' Methods:
		
		' Property potential:
		Method getValX:Int()
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