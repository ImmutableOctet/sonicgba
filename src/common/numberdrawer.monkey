Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.sonicdef
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class NumberDrawer Implements SonicDef
	Public
		' Constant variable(s):
		Const ANCHOR_BOTTOM:Int = 16
		Const ANCHOR_HCENTER:Int = 2
		Const ANCHOR_LEFT:Int = 1
		Const ANCHOR_RIGHT:Int = 4
		Const ANCHOR_TOP:Int = 8
		Const ANCHOR_VCENTER:Int = 32
		
		Global NUM_DRAW_SPACE:Int[] = [ANCHOR_RIGHT|ANCHOR_HCENTER, ANCHOR_RIGHT|ANCHOR_HCENTER, ANCHOR_RIGHT|ANCHOR_HCENTER, ANCHOR_TOP|ANCHOR_RIGHT] ' = [6, 6, 6, 12] ' Const
		Global NUM_HEIGHT:Int[] = [ANCHOR_TOP|ANCHOR_RIGHT, ANCHOR_TOP|ANCHOR_RIGHT, ANCHOR_TOP|ANCHOR_RIGHT, ANCHOR_BOTTOM] ' [12, 12, 12, 16] ' Const
		Global NUM_SPACE:Int[] = [ANCHOR_TOP, ANCHOR_TOP, ANCHOR_TOP, ANCHOR_BOTTOM] ' [8, 8, 8, 16] ' Const
		
		Global TYPE_TO_ANIMATION:Int[] = [0, 11, 21, 32] ' Const
		
		Const TYPE_BIG_WHITE:Int = 3
		Const TYPE_SMALL_RED:Int = 2
		Const TYPE_SMALL_WHITE:Int = 0
		Const TYPE_SMALL_YELLOW:Int = 1
	Private
		' Global variable(s):
		Global numberDrawer:AnimationDrawer = New Animation("/animation/number").getDrawer()
	Public
		' Functions:
		Function drawNum:Int(g:MFGraphics, numType:Int, num:Int, x:Int, y:Int, anchor:Int)
			Local divideNum:= 10
			Local blockNum:= 1
			
			While ((num / divideNum) <> 0)
				blockNum += 1
				divideNum *= 10
			Wend
			
			divideNum /= 10
			
			Local offsetX:= 0
			
			If ((anchor & ANCHOR_HCENTER) <> 0) Then
				offsetX = (-((NUM_SPACE[numType] * (blockNum - 1)) Shr 1)) - (NUM_DRAW_SPACE[numType] Shr 1)
			ElseIf ((anchor & ANCHOR_RIGHT) <> 0) Then
				offsetX = (-((NUM_SPACE[numType] * (blockNum - 1)) Shr 0)) - (NUM_DRAW_SPACE[numType] Shr 0)
			EndIf
			
			Local offsetY:= 0
			
			If ((anchor & ANCHOR_VCENTER) <> 0) Then
				offsetY = (-NUM_HEIGHT[numType]) Shr 1
			ElseIf ((anchor & ANCHOR_BOTTOM) <> 0) Then
				offsetY = -(NUM_HEIGHT[numType])
			EndIf
			
			For Local i:= 0 Until blockNum
				Local tmpNum:= (Abs(num / divideNum) Mod 10)
				
				divideNum /= 10
				
				numberDrawer.setActionId(TYPE_TO_ANIMATION[numType] + tmpNum)
				numberDrawer.draw(g, offsetX + x, y + offsetY)
				
				x += NUM_SPACE[numType]
			Next
			
			Return x
		End
		
		Function drawColon:Int(g:MFGraphics, numType:Int, x:Int, y:Int, anchor:Int)
			Local offsetX:= 0
			
			If ((anchor & ANCHOR_HCENTER) <> 0) Then
				offsetX = -(NUM_DRAW_SPACE[numType] Shr 1)
			ElseIf ((anchor & ANCHOR_RIGHT) <> 0) Then
				offsetX = -(NUM_DRAW_SPACE[numType])
			EndIf
			
			Local offsetY:= 0
			
			If ((anchor & ANCHOR_VCENTER) <> 0) Then
				offsetY = ((-NUM_HEIGHT[numType]) Shr 1)
			ElseIf ((anchor & ANCHOR_BOTTOM) <> 0) Then
				offsetY = -(NUM_HEIGHT[numType])
			EndIf
			
			Local id:= 0
			
			' Select the number set we were requested to use:
			Select (numType)
				Case TYPE_SMALL_WHITE, TYPE_SMALL_YELLOW
					id = 10
				Case TYPE_SMALL_RED
					id = 31
				Case TYPE_BIG_WHITE
					id = 42
			End Select
			
			numberDrawer.setActionId(id)
			numberDrawer.draw(g, x + offsetX, y + offsetY)
			
			Return x
		End
End