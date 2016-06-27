Strict

Public

' Imports:
Private
	Import monkey.lang
	
	Import lib.arraysymbolconverter
	
	Import special.ssdef
Public

' Classes:

' This is used to convert object entries from string-based array notation to actual arrays.
Class SpecialArrayConverter Extends ArraySymbolConverter<Int, SpecialObjectSymbolConverter> ' Alias
	' Nothing so far.
End

Class SpecialOrderArrayConverter
End

Class SpecialObjectSymbolConverter Extends IntSymbolConverter
	' Functions:
	Function Value_To_Symbol:String(n:Int)
		Select (n)
			Case SSOBJ_RING_ID
				Return "SSOBJ_RING_ID"
			Case SSOBJ_TRIC_ID
				Return "SSOBJ_TRIC_ID"
			Case SSOBJ_BNBK_ID
				Return "SSOBJ_BNBK_ID"
			Case SSOBJ_BNGO_ID
				Return "SSOBJ_BNGO_ID"
			Case SSOBJ_BNLU_ID
				Return "SSOBJ_BNLU_ID"
			Case SSOBJ_BNRU_ID
				Return "SSOBJ_BNRU_ID"
			Case SSOBJ_BNLD_ID
				Return "SSOBJ_BNLD_ID"
			Case SSOBJ_BNRD_ID
				Return "SSOBJ_BNRD_ID"
			Case SSOBJ_CHAO_ID
				Return "SSOBJ_CHAO_ID"
			Case SSOBJ_BOMB_ID
				Return "SSOBJ_BOMB_ID"
			Case SSOBJ_CHECKPT
				Return "SSOBJ_CHECKPT"
			Case SSOBJ_GOAL
				Return "SSOBJ_GOAL"
			Case SSOBJ_NUM
				Return "SSOBJ_NUM"
		End Select
		
		Return IntSymbolConverter.Value_To_Symbol(n)
	End
	
	Function Symbol_To_Value:Int(s:String)
		Select (s)
			Case "SSOBJ_RING_ID"
				Return SSOBJ_RING_ID
			Case "SSOBJ_TRIC_ID"
				Return SSOBJ_TRIC_ID
			Case "SSOBJ_BNBK_ID"
				Return SSOBJ_BNBK_ID
			Case "SSOBJ_BNGO_ID"
				Return SSOBJ_BNGO_ID
			Case "SSOBJ_BNLU_ID"
				Return SSOBJ_BNLU_ID
			Case "SSOBJ_BNRU_ID"
				Return SSOBJ_BNRU_ID
			Case "SSOBJ_BNLD_ID"
				Return SSOBJ_BNLD_ID
			Case "SSOBJ_BNRD_ID"
				Return SSOBJ_BNRD_ID
			Case "SSOBJ_CHAO_ID"
				Return SSOBJ_CHAO_ID
			Case "SSOBJ_BOMB_ID"
				Return SSOBJ_BOMB_ID
			Case "SSOBJ_CHECKPT"
				Return SSOBJ_CHECKPT
			Case "SSOBJ_GOAL"
				Return SSOBJ_GOAL
			Case "SSOBJ_NUM"
				Return SSOBJ_NUM
		End Select
		
		Return IntSymbolConverter.Symbol_To_Value(s)
	End
End