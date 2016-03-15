Strict

Public

' Imports:
Private
	Import com.sega.mobile.define.mdphone
	
	Import sonicgba.sonicdef
	Import sonicgba.playerobject
Public

' Classes:
Class HobinCal Implements SonicDef
	Private
		' Constant variable(s):
		Const MAX_DISTANCE:= 512
		Const MAX_POWER:= 800
		
		' Fields:
		Field degree:Int
		Field distance:Int
		Field power:Int
		Field timeCount:Int
	Public
		Method startHobin:Int(power:Int, degree:Int, time:Int)
			Self.power = 1200
			
			While (degree < 0)
				degree += MDPhone.SCREEN_WIDTH
			Wend
			
			Self.degree = (degree Mod MDPhone.SCREEN_HEIGHT)
			Self.timeCount = 10
		End
		
		Method logic:Void()
			If (Self.timeCount > 0) Then
				Self.timeCount -= 1
			Endif
			
			If (Self.timeCount > 0) Then
				if (Self.timeCount = 9) Then
					Self.distance = Self.power
				Else
					Self.distance = ((-Self.distance) Shr 1) ' / 2
				Endif
				
				If (Self.timeCount = 1) Then
					Self.distance = 0
					Self.power = 0
				Endif
			Endif
		End
		
		Method getPosOffsetX:Int()
			Return ((Self.distance * Cos(Self.degree)) / 100)
		End
		
		Method getPosOffsetY:Int()
			Return ((Self.distance * Sin(Self.degree)) / 100)
		End
		
		Method isStop:Bool()
			Return (Self.timeCount = 0)
		End
End