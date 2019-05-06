Strict

Public

' Imports:
Private
	Import sonicgba.gameobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import cerberus.math
	
	Import regal.typetool
Public

' Classes:
Class WaveInvertEffect Final
	Private
		' Constant variable(s):
		Global SIN_TABLE:Int[] = [] ' Const
		
		' Global variable(s):
		Global time:Long
		Global timeTick:Long
		
		' Functions:
		Function sin:Int(degrees:Long)
			Return Int(Sinr(((Double((degrees Mod 360) * 2)) * math.PI) / 360.0) * 1024.0)
		End
	Public
		' Functions:
		Function drawImage:Void(g:MFGraphics, img:MFImage, x_dest:Int, y_dest:Int, aX:Int, bX:Int, aY:Int, bY:Int, speed:Int)
			Local height:= img.getHeight()
			Local width:= img.getWidth()
			
			If (Not GameObject.IsGamePause) Then
				If (timeTick < Long(speed)) Then
					timeTick += 1
				Else
					time += 1
					timeTick = 0
				EndIf
			EndIf
			
			For speed = 0 Until height
				Local offsetX:= ((sin(Long((speed * bX) Shr 2)) * aX) Shr 14)
				Local offsetY:= ((sin(((Long(speed) + time) * bY) Shr 2) * aY) Shr 14)
				
				Local j:= Long(bY)
				
				If (speed + offsetY < 0) Then
					offsetY = -speed
				ElseIf (speed + offsetY >= height) Then
					offsetY = ((height - speed) - 1)
				EndIf
				
				g.setClip(x_dest, y_dest + speed, width, 1)
				g.drawImage(img, (offsetX + x_dest) - (aX Shr 4), y_dest - offsetY, 20)
			Next
		End
End