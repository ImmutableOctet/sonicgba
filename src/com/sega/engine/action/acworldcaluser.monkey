Strict

Public

' Imports:
Private
	Import com.sega.engine.action.acmovecaluser
Public

' Interfaces:
Interface ACWorldCalUser Extends ACMoveCalUser
	' Methods:
	Method doWhileLand:Void(i:Int)
	Method doWhileLeaveGround:Void()
	Method doWhileTouchWorld:Void(i:Int, i2:Int)
	Method getBodyDegree:Int()
	Method getBodyOffset:Int()
	Method getFootOffset:Int()
	Method getFootX:Int()
	Method getFootY:Int()
	Method getMinDegreeToLeaveGround:Int()
	Method getPressToGround:Int()
End