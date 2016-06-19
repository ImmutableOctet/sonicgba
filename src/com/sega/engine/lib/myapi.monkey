Strict

Public

' Imports:
' Nothing so far.

' Classes:
Class MyAPI
	' Constant variable(s):
	Const FIXED_TWO_BASE:Int = 7
	
	Global sinData2:Int[] = [0,224,446,669,893,1116,1337,1560,1781,2001,2222,2442,2661,2878,3096,3312,3527,3742,3955,4167,4377,4587,4794,5000,5205,5409,5611,5811,6009,6205,6400,6592,6782,6970,7157,7342,7523,7703,7879,8055,8227,8396,8564,8729,8890,9050,9207,9360,9511,9660,9804,9946,10086,10222,10355,10484,10611,10735,10854,10972,11084,11194,11301,11404,11504,11600,11692,11782,11868,11950,12028,12102,12172,12240,12304,12363,12419,12472,12519,12564,12605,12642,12675,12704,12729,12751,12769,12782,12792,12797,12800] ' Const
	
	' Functions:
	Function dSin:Int(value:Int)
		'Return Int(Sin(Float(value)) * 100.0)
		
		While (value < 0)
			value += 360
		Wend
		
		Local var1:= (value Mod 360)
		
		If (var1 >= 0 And var1 <= 90) Then
			Return (sinData2[var1] Shr FIXED_TWO_BASE) ' >>> FIXED_TWO_BASE
		ElseIf (var1 > 90 And var1 <= 180) Then
			Return (sinData2[90 - (var1 - 90)] Shr FIXED_TWO_BASE) ' >>> FIXED_TWO_BASE
		ElseIf (var1 > 180 And var1 <= 270) Then
			Return -(sinData2[var1 - 180] Shr FIXED_TWO_BASE) ' >>> FIXED_TWO_BASE
		ElseIf (var1 > 270 And var1 <= 359) Then
			Return -(sinData2[90 - (var1 - 270)] Shr FIXED_TWO_BASE) ' >>> FIXED_TWO_BASE
		EndIf
		
		Return 0
	End
	
	Function dCos:Int(tDeg:Int)
		'Return Int(Cos(Float(tDeg)) * 100.0)
		Return dSin(90 - tDeg)
	End
	
	#Rem
		Function dSin:Int(tDeg:Int)
			While (tDeg < 0)
				tDeg += 360
			Wend
			
			Local tsh:= tDeg Mod 360
			
			If (tsh >= 0 And tsh <= 90) Then
				Return sinData2[tsh] Shr FIXED_TWO_BASE ' >>>
			EndIf
			
			If (tsh > 90 And tsh <= 180) Then
				Return sinData2[90 - (tsh - 90)] Shr FIXED_TWO_BASE ' >>>
			EndIf
			
			If (tsh > 180 And tsh <= 270) Then
				Return (sinData2[tsh - 180] Shr FIXED_TWO_BASE) * -1 ' >>>
			EndIf
			
			If (tsh <= 270 Or tsh > 359) Then
				Return 0
			EndIf
			
			Return (sinData2[90 - (tsh - 270)] Shr FIXED_TWO_BASE) * -1 ' >>>
		End
		
		Function dCos:Int(tDeg:Int)
			Return dSin(90 - tDeg)
		End
	#End
End