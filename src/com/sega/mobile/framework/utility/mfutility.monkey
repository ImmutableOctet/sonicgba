Strict

Public

' Imports:
Private
	Import lib.myrandom
	
	Import cerberus.random
	Import cerberus.stack
	
	Import regal.typetool
Public

' Classes:
Class MFUtility
	Public
		' Functions:
		Function getRandomNumber:Int()
			Return MyRandom.nextInt()
		End
		
		Function getRandomNumber:Int(maxValue:Int)
			Return MyRandom.nextInt(maxValue)
		End
		
		Function getRandomNumberSequence:Int[](maxValue:Int)
			Local ret:= New Int[maxValue]
			
			For Local i:= 0 Until maxValue
				ret[i] = i
			Next
			
			For Local i:= 0 Until maxValue
				Local pos:= getRandomNumber(maxValue)
				Local tmp:= ret[i]
				
				ret[i] = ret[pos]
				ret[pos] = tmp
			Next
			
			Return ret
		End
		
		Function getRandomNumber:Int(firstValue:Int, secondValue:Int)
			Return MyRandom.nextInt(firstValue, secondValue)
		End
		
		Function getRandomNumberSequence:Int[](firstValue:Int, secondValue:Int)
			Local ret:= getRandomNumberSequence(Abs(firstValue - secondValue))
			
			Local minValue:= Min(firstValue, secondValue)
			
			For Local i:= 0 Until ret.Length
				ret[i] += minValue
			Next
			
			Return ret
		End
		
		Function getRandomArrayNumber:Int(data:Int[])
			Return data[getRandomNumber(data.Length)]
		End
		
		#Rem
			Function getRandomArrayNumber:Short(data:Short[])
				Return data[getRandomNumber(data.Length)]
			End
			
			Function getRandomArrayNumber:Byte(data:Byte[])
				Return data[getRandomNumber(data.Length)]
			End
		#End
		
		Function getRandomObject:Object(data:Object[])
			Return data[getRandomNumber(data.Length)]
		End
		
		Function shuffleArray:Int[](data:Int[]) ' Short[] ' Byte[]
			Local tmp:= getRandomNumberSequence(data.Length)
			
			Local ret:= New Int[data.Length]
			
			For Local i:= 0 Until data.Length
				ret[i] = data[tmp[i]]
			Next
			
			Return ret
		End
		
		Function shuffleArray:Object[](data:Object[])
			Local tmp:= getRandomNumberSequence(data.Length)
			
			Local ret:= New Object[data.Length]
			
			For Local i:= 0 Until data.Length ' ret.Length
				ret[i] = data[tmp[i]]
			Next
			
			For Local i:= 0 Until data.Length ' ret.Length
				data[i] = ret[i]
			Next
			
			Return data
		End
		
		Function shuffleVector:Stack<Object>(vector:Stack<Object>)
			Local tmp:= getRandomNumberSequence(vector.Length)
			
			Local ret:= New Object[vector.Length]
			
			For Local i:= 0 Until vector.Length
				ret[i] = vector.Get(tmp[i])
			Next
			
			vector.Clear()
			
			For Local element:= EachIn ret
				vector.Puhs(element)
			Next
			
			Return vector
		End
		
		Function getValueInRange:Int(value:Int, min:Int, max:Int)
			Return Clamp(value, min, max)
		End
		
		Function pointInRegion:Bool(x:Int, y:Int, regionX:Int, regionY:Int, regionW:Int, regionH:Int) ' ' Final
			Return (x > regionX And y > regionY And x < (regionX + regionW) And y < (regionY + regionH))
		End
		
		Function revertArray:Void(data:Int[]) ' Short[] ' Byte[] ' Final
			For Local i:= 0 Until (data.Length / 2)
				Local tmp:= data[i]
				
				data[i] = data[(data.Length - 1) - i]
				
				data[(data.Length - 1) - i] = tmp
			Next
		End
		
		Function revertArray:Void(data:Object[]) ' Final
			For Local i:= 0 Until (data.Length / 2)
				Local tmp:= data[i]
				
				data[i] = data[(data.Length - 1) - i]
				
				data[(data.Length - 1) - i] = tmp
			Next
		End
End