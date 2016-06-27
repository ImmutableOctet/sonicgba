Strict

Public

' Imports:
Private
	Import monkey.lang
	
	'Import regal.stringutil
Public

' Classes:

' This converts string representations of arrays to their native form.
Class ArraySymbolConverter<ValueType, Converter>
	' Constant variable(s):
	Const BeginSymbol:= Converter.BeginSymbol
	Const EndSymbol:= Converter.EndSymbol
	Const SeparatorSymbol:= Converter.SeparatorSymbol
	
	' Functions:
	Function Decode:ValueType[](data:String)
		Const STRING_INVALID_LOCATION:= -1
		
		Local first:= (data.Find(BeginSymbol) + 1)
		Local last:= data.Find(EndSymbol, first)
		
		If (last = STRING_INVALID_LOCATION) Then
			last = data.Length
		Endif
		
		If (first = 0 And last = 0) Then
			Return []
		EndIf
		
		Local csv:= data[first..last]
		Local entries:= csv.Split(SeparatorSymbol)
		
		Local output:= New ValueType[entries.Length]
		
		For Local I:= 0 Until output.Length
			output[I] = Converter.Symbol_To_Value(entries[I])
		Next
		
		Return output
	End
	
	Function Encode:String(data:ValueType[], padding:Bool=True)
		If (data.Length = 0) Then
			Return (BeginSymbol + EndSymbol)
		EndIf
		
		Local output:String
		
		Local lastIndex:= (data.Length - 1)
		
		For Local I:= 0 Until lastIndex
			output += Converter.Value_To_Symbol(data[I]) + SeparatorSymbol
			
			If (padding) Then
				output += Space
			EndIf
		Next
		
		output += Converter.Value_To_Symbol(data[lastIndex])
		
		Return (BeginSymbol + output + EndSymbol)
	End
End

Class SymbolConverter Abstract
	' Constant variable(s):
	Const BeginSymbol:String = "["
	Const EndSymbol:String = "]"
	
	Const SeparatorSymbol:String = ","
End

Class IntSymbolConverter Extends SymbolConverter Abstract
	' Functions:
	Function Value_To_Symbol:String(n:Int)
		Return String(n)
	End
	
	Function Symbol_To_Value:Int(s:String)
		Return Int(s)
	End
End

Class FloatSymbolConverter Extends SymbolConverter Abstract
	Function Value_To_Symbol:String(f:Float)
		Return String(f)
	End
	
	Function Symbol_To_Value:Float(s:String)
		Return Float(s)
	End
End