Strict

Public

' Imports:
Private
	Import lib.myapi
	
	Import sonicgba.sonicdef
	'Import sonicgba.playerobject
Public

' Classes:
Class HobinCal ' Implements SonicDef
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
		' Methods:
		Method startHobin:Void(power:Int, degree:Int, time:Int)
			Self.power = 1200
			
			While (degree < 0)
				degree += 360
			Wend
			
			Self.degree = (degree Mod 360)
			Self.timeCount = 10
		End
		
		Method logic:Void()
			If (Self.timeCount > 0) Then
				Self.timeCount -= 1
			EndIf
			
			If (Self.timeCount > 0) Then
				if (Self.timeCount = 9) Then
					Self.distance = Self.power
				Else
					Self.distance = ((-Self.distance) Shr 1) ' / 2
				EndIf
				
				If (Self.timeCount = 1) Then
					Self.distance = 0
					Self.power = 0
				EndIf
			EndIf
		End
		
		Method getPosOffsetX:Int()
			Return ((Self.distance * MyAPI.dCos(Self.degree)) / 100)
		End
		
		Method getPosOffsetY:Int()
			Return ((Self.distance * MyAPI.dSin(Self.degree)) / 100)
		End
		
		Method isStop:Bool()
			Return (Self.timeCount = 0)
		End
End