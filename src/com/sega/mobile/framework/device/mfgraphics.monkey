Strict

Public

' Friends:
Friend com.sega.mobile.framework.device.mfdevice
Friend com.sega.mobile.framework.device.mfimage

' Imports:
Private
	Import com.sega.mobile.framework.device.mfimage
	
	'Import sonicgba.mapmanager
	'Import com.sega.mobile.framework.android.font
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.utility.mfutility
	
	Import com.sega.mobile.framework.device.mfdevice
	
	Import lib.constutil
	
	Import regal.util
	
	'Import mojo.graphics
Public
	Import com.sega.mobile.framework.android.graphicsmacros

' Classes:
Class MFGraphics
	Public
		' Constant variable(s):
		Const FONT_LARGE:Int = -3
		Const FONT_MEDIUM:Int = -2
		Const FONT_SMALL:Int = -1
	Private
		' Global variable(s):
		Global currentFont:Font
		Global drawLineD:Int
		Global drawLineDX:Int
		Global drawLineDY:Int
		Global drawLineIncrE:Int
		Global drawLineIncrNE:Int
		Global drawLineMFlag:Bool
		Global drawLineStepX:Int
		Global drawLineStepY:Int
		Global drawLineX:Int
		Global drawLineY:Int
		Global font_large:Font
		Global font_medium:Font
		Global font_small:Font
		Global font_type:Int
		Global xOff:Int = TRANS_NONE
		Global yOff:Int = TRANS_NONE
		
		' Fields:
		Field alphaValue:Int
		Field blueValue:Int
		Field clipHeight:Int
		Field clipWidth:Int
		Field clipX:Int
		Field clipY:Int
		
		Field drawEffectRGB:Int[]
		Field effectFlag:Bool
		Field enableExceed:Bool
		Field fillRectRGB:Int[]
		Field pixelInt:Int[]
		
		Field grayValue:Int
		Field greenValue:Int
		Field redValue:Int
		Field transX:Int
		Field transY:Int
	Protected
		' Fields:
		Field context:Graphics
	Private
		' Constructor(s):
		Method New()
			Self.enableExceed = False
			Self.fillRectRGB = New Int[100]
		End
	Public
		' Functions:
		Function init:Void() ' Final
			#Rem
			If (font_small = Null) Then
				font_small = Font.getFont(TRANS_NONE, TRANS_NONE, RIGHT)
				font_medium = Font.getFont(TRANS_NONE, TRANS_NONE, TRANS_NONE)
				font_large = Font.getFont(TRANS_NONE, TRANS_NONE, TOP)
				
				font_type = RIGHT
				currentFont = font_small
			EndIf
			#End
		End
		
		Function createMFGraphics:MFGraphics(graphics:Graphics, width:Int, height:Int) ' Final
			If (MFDevice.preScaleZoomOutFlag) Then
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
			EndIf
			
			Print(String(width) + "x" + String(height))
			
			Local ret:= New MFGraphics()
			
			ret.setGraphics(graphics, width, height)
			ret.disableEffect()
			
			Return ret
		End
		
		Function charHeight:Int(_var:Int)
			Local var:= _var
			
			Select var
				Case FONT_SMALL, FONT_MEDIUM, FONT_LARGE
					' Magic number: 30
					var = 30
			End Select
			
			If (MFDevice.preScaleZoomOutFlag) Then
				var Shl= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				var Shr= MFDevice.preScaleShift
			EndIf
			
			Return var
		End
		
		Function stringWidth:Int(font:Int, str:String) ' Final
			If (MFDevice.preScaleZoomOutFlag) Then
				If (font_type = font) Then
					Return (currentFont.stringWidth(str) Shl MFDevice.preScaleShift)
				EndIf
				
				Return (getFont(font).stringWidth(str) Shl MFDevice.preScaleShift)
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				If (font_type = font) Then
					Return (currentFont.stringWidth(str) Shr MFDevice.preScaleShift)
				EndIf
				
				Return (getFont(font).stringWidth(str) Shr MFDevice.preScaleShift)
			ElseIf (font_type = font) Then
				Return currentFont.stringWidth(str)
			EndIf
			
			Return getFont(font).stringWidth(str)
		End
	
		' Methods:
		
		' Extensions:
		Method clear:Void()
			Self.context.clear()
		End
		
		Method flush:Void()
			Self.context.flush()
		End
		
		Method saveCanvas:Void()
			Self.context.save()
		End
	
		Method restoreCanvas:Void()
			Self.context.restore()
		End
		
		Method clipCanvas:Void(left:Int, top:Int, right:Int, bottom:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				left Shr= MFDevice.preScaleShift
				top Shr= MFDevice.preScaleShift
				right Shr= MFDevice.preScaleShift
				bottom Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				left Shl= MFDevice.preScaleShift
				top Shl= MFDevice.preScaleShift
				right Shl= MFDevice.preScaleShift
				bottom Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.clipRect(left, top, right, bottom)
		End
		
		Method rotateCanvas:Void(degrees:Float)
			Self.context.rotate(degrees)
		End
		
		Method rotateCanvas:Void(degrees:Float, px:Int, py:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				px Shr= MFDevice.preScaleShift
				py Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				px Shl= MFDevice.preScaleShift
				py Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.rotate(degrees, Float(px), Float(py))
		End
		
		Method scaleCanvas:Void(sx:Float, sy:Float)
			Self.context.scale(sx, sy)
		End
		
		Method scaleCanvas:Void(sx:Float, sy:Float, px:Int, py:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				px Shr= MFDevice.preScaleShift
				py Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				px Shl= MFDevice.preScaleShift
				py Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.scale(sx, sy, Float(px), Float(py))
		End
		
		Method translateCanvas:Void(dx:Int, dy:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				dx Shr= MFDevice.preScaleShift
				dy Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				dx Shl= MFDevice.preScaleShift
				dy Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.translate(Float(dx), Float(dy))
		End
		
		Method getSystemGraphics:Graphics() Final
			Return Self.context
		End
	
		Method setGraphics:Void(graphics:Graphics) Final
			Self.context = graphics
			
			'Self.context.setFont(Font.getFont(TRANS_NONE, TRANS_NONE, RIGHT))
		End
		
		' This method may behave differently in the future.
		Method setGraphics:Void(graphics:Graphics, width:Int, height:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
			EndIf
			
			reset()
			
			setGraphics(graphics)
		End
	
		Method reset:Void() Final
			Local screenWidth:= MFDevice.getScreenWidth()
			Local screenHeight:= MFDevice.getScreenHeight()
			
			If (MFDevice.preScaleZoomOutFlag) Then
				screenWidth Shr= MFDevice.preScaleShift
				screenHeight Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				screenWidth Shl= MFDevice.preScaleShift
				screenHeight Shl= MFDevice.preScaleShift
			EndIf
			
			Self.transX = TRANS_NONE
			Self.transY = TRANS_NONE
			
			Self.clipX = TRANS_NONE
			Self.clipY = TRANS_NONE
			
			Self.clipWidth = screenWidth
			Self.clipHeight = screenHeight
		End
		
		Method translate:Void(x:Int, y:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
			EndIf
			
			Self.transX += x
			Self.transY += y
			
			Self.clipX += x
			Self.clipY += y
		End
		
		Method setTranslate:Void(x:Int, y:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
			EndIf
			
			translate(x - Self.transX, y - Self.transY)
		End
		
		Method getTranslateX:Int() Final
			If (MFDevice.preScaleZoomOutFlag) Then
				Return (Self.transX Shl MFDevice.preScaleShift)
			EndIf
			
			If (MFDevice.preScaleZoomInFlag) Then
				Return (Self.transX Shr MFDevice.preScaleShift)
			EndIf
			
			Return Self.transX
		End
		
		Method getTranslateY:Int() Final
			If (MFDevice.preScaleZoomOutFlag) Then
				Return (Self.transY Shl MFDevice.preScaleShift)
			EndIf
			
			If (MFDevice.preScaleZoomInFlag) Then
				Return (Self.transY Shr MFDevice.preScaleShift)
			EndIf
			
			Return Self.transY
		End
	
		Method setClip:Void(x:Int, y:Int, width:Int, height:Int) Final
			Local screenWidth:= MFDevice.getScreenWidth()
			Local screenHeight:= MFDevice.getScreenHeight()
			
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
				
				screenWidth Shr= MFDevice.preScaleShift
				screenHeight Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
				
				screenWidth Shl= MFDevice.preScaleShift
				screenHeight Shl= MFDevice.preScaleShift
			EndIf
			
			Self.clipX = (Self.transX + x)
			Self.clipY = (Self.transY + y)
			
			Self.clipWidth = width
			Self.clipHeight = height
			
			If (Self.enableExceed) Then
				Self.context.setClip(Self.clipX, Self.clipY, Self.clipWidth, Self.clipHeight)
				
				Return
			EndIf
			
			Local tx:Int
			Local ty:Int
			
			Local cx:= PickValue((Self.clipX < 0), TRANS_NONE, Self.clipX)
			Local cy:= PickValue((Self.clipY < 0), TRANS_NONE, Self.clipY)
			
			If (Self.clipX + width > screenWidth) Then
				tx = screenWidth
			Else
				tx = Self.clipX + width
			EndIf
			
			If (Self.clipY + height > screenHeight) Then
				ty = screenHeight
			Else
				ty = Self.clipY + height
			EndIf
			
			Self.context.setClip(cx, cy, tx - cx, ty - cy)
		End
		
		Method getClipX:Int() Final
			If (MFDevice.preScaleZoomOutFlag) Then
				Return ((Self.clipX - Self.transX) Shl MFDevice.preScaleShift)
			EndIf
			
			If (MFDevice.preScaleZoomInFlag) Then
				Return ((Self.clipX - Self.transX) Shr MFDevice.preScaleShift)
			EndIf
			
			Return (Self.clipX - Self.transX)
		End
	
		Method getClipY:Int() Final
			If (MFDevice.preScaleZoomOutFlag) Then
				Return ((Self.clipY - Self.transY) Shl MFDevice.preScaleShift)
			EndIf
			
			If (MFDevice.preScaleZoomInFlag) Then
				Return ((Self.clipY - Self.transY) Shr MFDevice.preScaleShift)
			EndIf
			
			Return (Self.clipY - Self.transY)
		End
		
		Method getClipWidth:Int() Final
			If (MFDevice.preScaleZoomOutFlag) Then
				Return (Self.clipWidth Shl MFDevice.preScaleShift)
			EndIf
			
			If (MFDevice.preScaleZoomInFlag) Then
				Return (Self.clipWidth Shr MFDevice.preScaleShift)
			EndIf
			
			Return Self.clipWidth
		End
		
		Method getClipHeight:Int() Final
			If (MFDevice.preScaleZoomOutFlag) Then
				Return (Self.clipHeight Shl MFDevice.preScaleShift)
			EndIf
			
			If (MFDevice.preScaleZoomInFlag) Then
				Return (Self.clipHeight Shr MFDevice.preScaleShift)
			EndIf
			
			Return Self.clipHeight
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int, anchor:Int) Final
			Local imageWidth:= image.getWidth()
			Local imageHeight:= image.getHeight()
			
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				imageWidth Shr= MFDevice.preScaleShift
				imageHeight Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				imageWidth Shl= MFDevice.preScaleShift
				imageHeight Shl= MFDevice.preScaleShift
			EndIf
			
			caculateAnchorOffset(imageWidth, imageHeight, anchor)
			
			drawImageImpl(image, xOff + x, yOff + y)
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int) Final
			drawImage(image, x, y, (TOP|RIGHT))
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int, flipMode:Int, anchor:Int) Final
			drawRegion(image, TRANS_NONE, TRANS_NONE, image.getWidth(), image.getHeight(), flipMode, x, y, anchor)
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int, regionX:Int, regionY:Int, regionW:Int, regionH:Int) Final
			drawRegion(image, regionX, regionY, regionW, regionH, TRANS_NONE, x, y, (TOP|RIGHT))
		End
		
		Method drawRegion:Void(image:MFImage, regionX:Int, regionY:Int, regionW:Int, regionH:Int, flipMode:Int, x:Int, y:Int, anchor:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				regionX Shr= MFDevice.preScaleShift
				regionY Shr= MFDevice.preScaleShift
				
				regionW Shr= MFDevice.preScaleShift
				regionH Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				regionX Shl= MFDevice.preScaleShift
				regionY Shl= MFDevice.preScaleShift
				
				regionW Shl= MFDevice.preScaleShift
				regionH Shl= MFDevice.preScaleShift
			EndIf
			
			If (flipMode <= TRANS_ROT180) Then
				caculateAnchorOffset(regionW, regionH, anchor)
			Else
				caculateAnchorOffset(regionH, regionW, anchor)
			EndIf
			
			drawRegionImpl(image, regionX, regionY, regionW, regionH, flipMode, x + xOff, y + yOff)
		End
	Private
		' Functions:
		Function getFont:Font(type:Int) ' Final
			Select (type)
				Case FONT_LARGE
					Return font_large
				Case FONT_MEDIUM
					Return font_medium
				Case FONT_SMALL
					Return font_small
			End Select
			
			Return Font.getFont(type)
		End
		
		' Methods:
		Method caculateAnchorOffset:Void(width:Int, height:Int, anchor:Int) Final
			xOff = TRANS_NONE
			yOff = TRANS_NONE
			
			If ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				xOff -= (width Shr 1)
			ElseIf ((anchor & RIGHT) <> 0) Then
				xOff -= width
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				yOff -= height Shr 1
			ElseIf ((anchor & BOTTOM) <> 0) Then
				yOff -= height
			EndIf
		End
		
		' This method may be removed at a later date.
		Method drawRGBImpl:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int, processAlpha:Bool)
			Self.context.drawRGB(rgbData, offset, scanlength, x, y, width, height, processAlpha)
		End
		
		Method drawPixelImpl:Void(x:Int, y:Int) Final
			If (Self.effectFlag) Then
				Self.pixelInt[0] = Self.context.getColor() | -16777216
				
				If (Not (Self.alphaValue = 0 Or (Self.redValue = 0 And Self.greenValue = 0 And Self.blueValue = 0))) Then
					Self.pixelInt[0] = caculateColorValue(Self.pixelInt[0])
				EndIf
				
				If (Not (Self.alphaValue = 0 Or Self.grayValue = 0)) Then
					Self.pixelInt[0] = caculateGray(Self.pixelInt[0])
				EndIf
				
				If (Not (Self.alphaValue = 255 Or Self.alphaValue = 0)) Then
					Self.pixelInt[0] = caculateAlpha(Self.pixelInt[0])
				EndIf
				
				If (Self.alphaValue <> 0) Then
					Self.context.drawRGB(Self.pixelInt, TRANS_NONE, TRANS_MIRROR_ROT180, x, y, TRANS_MIRROR_ROT180, TRANS_MIRROR_ROT180, True)
					
					Return
				EndIf
				
				Return
			EndIf
			
			Self.context.drawLine(x, y, x, y)
		End
		
		Method drawLinePerPixel:Void(x1:Int, y1:Int, x2:Int, y2:Int) Final
			drawLineStepX = DSgn(x1 < x2)
			drawLineStepY = -drawLineStepX ' DSgn((y1 >= y2))
			
			drawLineDX = Abs(x2 - x1)
			drawLineDY = Abs(y2 - y1)
			
			drawLineMFlag = ((drawLineDX - drawLineDY) > 0)
			
			If (drawLineMFlag) Then
				drawLineD = drawLineDX - (drawLineDY Shl 1)
				drawLineIncrE = -(drawLineDY Shl 1)
				drawLineIncrNE = ((drawLineDX - drawLineDY) Shl 1)
			Else
				drawLineD = drawLineDY - (drawLineDX Shl 1)
				drawLineIncrE = -(drawLineDX Shl 1)
				drawLineIncrNE = ((drawLineDY - drawLineDX) Shl 1)
			EndIf
			
			drawLineX = x1
			drawLineY = y1
			
			drawPixelImpl(drawLineX, drawLineY)
			
			If (drawLineMFlag) Then
				While (drawLineX <> x2)
					If (drawLineD > 0) Then
						drawLineD += drawLineIncrE
						drawLineX += drawLineStepX
					Else
						drawLineD += drawLineIncrNE
						drawLineX += drawLineStepX
						drawLineY += drawLineStepY
					EndIf
					
					drawPixelImpl(drawLineX, drawLineY)
				Wend
				
				Return
			EndIf
			
			While (drawLineY <> y2)
				If (drawLineD > 0) Then
					drawLineD += drawLineIncrE
					drawLineY += drawLineStepY
				Else
					drawLineD += drawLineIncrNE
					drawLineX += drawLineStepX
					drawLineY += drawLineStepY
				EndIf
				
				drawPixelImpl(drawLineX, drawLineY)
			Wend
		End
	Public
		' This is only really used for fade effects, so it can be replaced
		' pretty easily. Therefore, this method may be removed at a later date.
		Method drawRGB:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int, processAlpha:Bool)
			If (Self.effectFlag) Then
				If (Self.alphaValue <> 0) Then
					If (Not (Self.redValue = 0 And Self.greenValue = 0 And Self.blueValue = 0)) Then
						For Local i:= 0 Until rgbData.Length
							rgbData[i] = caculateColorValue(rgbData[i])
						Next
					EndIf
					
					If (Self.grayValue <> 0) Then
						For Local i:= 0 Until rgbData.Length
							rgbData[i] = caculateGray(rgbData[i])
						Next
					EndIf
					
					If (Self.alphaValue <> 255) Then
						For Local i:= 0 Until rgbData.Length
							rgbData[i] = caculateAlpha(rgbData[i])
						Next
					EndIf
				Else
					Return
				EndIf
			EndIf
			
			Local drawRGB:= rgbData
			
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
				
				drawRGB = New Int[(width * height)]
				
				For Local i:= 0 Until width
					For Local j:= 0 Until height
						drawRGB[(j * width) + i] = rgbData[(i Shl MFDevice.preScaleShift) + ((j Shl MFDevice.preScaleShift) * (width Shl MFDevice.preScaleShift))]
					Next
				Next
				
				offset = TRANS_NONE
				scanlength = width
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
				
				drawRGB = New Int[(width * height)]
				
				For Local i:= 0 Until width
					For Local j:= 0 Until height
						drawRGB[(j * width) + i] = rgbData[(i Shr MFDevice.preScaleShift) + ((j Shr MFDevice.preScaleShift) * (width Shr MFDevice.preScaleShift))]
					Next
				Next
				
				offset = TRANS_NONE
				scanlength = width
			EndIf
			
			If (Self.effectFlag) Then
				drawRGBFlip(drawRGB, x + Self.transX, y + Self.transY, width, height, TRANS_NONE)
				
				Return
			EndIf
			
			drawRGBImpl(drawRGB, offset, scanlength, x + Self.transX, y + Self.transY, width, height, processAlpha)
		End
		
		Method setColor:Void(color:Int)
			Self.context.setColor(color)
		End
	
		Method getColor:Int()
			Return Self.context.getColor()
		End
	
		Method setColor:Void(red:Int, green:Int, blue:Int)
			Self.context.setColor(((red Shl TOP) | (green Shl RIGHT)) | blue)
		End
	
		Method drawPixel:Void(x:Int, y:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
			EndIf
			
			drawPixelImpl(Self.transX + x, Self.transY + y)
		End
		
		Method drawLine:Void(x1:Int, y1:Int, x2:Int, y2:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x1 Shr= MFDevice.preScaleShift
				y1 Shr= MFDevice.preScaleShift
				
				x2 Shr= MFDevice.preScaleShift
				y2 Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x1 Shl= MFDevice.preScaleShift
				y1 Shl= MFDevice.preScaleShift
				
				x2 Shl= MFDevice.preScaleShift
				y2 Shl= MFDevice.preScaleShift
			EndIf
			
			If (Self.effectFlag) Then
				drawLinePerPixel(Self.transX + x1, Self.transY + y1, Self.transX + x2, Self.transY + y2)
			Else
				Self.context.drawLine(Self.transX + x1, Self.transY + y1, Self.transX + x2, Self.transY + y2)
			EndIf
		End
		
		Method drawTriangle:Void(x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int) Final
			drawLine(x1, y1, x2, y2)
			drawLine(x1, y1, x3, y3)
			drawLine(x2, y2, x3, y3)
		End
		
		Method fillTriangle:Void(x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x1 Shr= MFDevice.preScaleShift
				y1 Shr= MFDevice.preScaleShift
				
				x2 Shr= MFDevice.preScaleShift
				y2 Shr= MFDevice.preScaleShift
				
				x3 Shr= MFDevice.preScaleShift
				y3 Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x1 Shl= MFDevice.preScaleShift
				y1 Shl= MFDevice.preScaleShift
				
				x2 Shl= MFDevice.preScaleShift
				y2 Shl= MFDevice.preScaleShift
				
				x3 Shl= MFDevice.preScaleShift
				y3 Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.fillTriangle(Self.transX + x1, Self.transY + y1, Self.transX + x2, Self.transY + y2, Self.transX + x3, Self.transY + y3)
		End
		
		Method drawRect:Void(x:Int, y:Int, w:Int, h:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				w Shr= MFDevice.preScaleShift
				h Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				w Shl= MFDevice.preScaleShift
				h Shl= MFDevice.preScaleShift
			EndIf
			
			If (w >= 0 And h >= 0) Then
				If (Self.effectFlag) Then
					fillRect(x, y, w, TRANS_MIRROR_ROT180)
					fillRect(x, y, TRANS_MIRROR_ROT180, h)
					fillRect(x + w, y, TRANS_MIRROR_ROT180, h)
					fillRect(x, y + h, w, TRANS_MIRROR_ROT180)
					
					Return
				EndIf
				
				Self.context.drawRect(Self.transX + x, Self.transY + y, w, h)
			EndIf
		End

		Method fillRect:Void(x:Int, y:Int, w:Int, h:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				w Shr= MFDevice.preScaleShift
				h Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				w Shl= MFDevice.preScaleShift
				h Shl= MFDevice.preScaleShift
			EndIf
			
			If (Self.effectFlag) Then
				Self.fillRectRGB[0] = Self.context.getColor() | -16777216
				
				If (Not (Self.alphaValue = 0 Or (Self.redValue = 0 And Self.greenValue = 0 And Self.blueValue = 0))) Then
					Self.fillRectRGB[0] = caculateColorValue(Self.fillRectRGB[0])
				EndIf
				
				If (Not (Self.alphaValue = 0 Or Self.grayValue = 0)) Then
					Self.fillRectRGB[0] = caculateGray(Self.fillRectRGB[0])
				EndIf
				
				If (Not (Self.alphaValue = 255 Or Self.alphaValue = 0)) Then
					Self.fillRectRGB[0] = caculateAlpha(Self.fillRectRGB[0])
				EndIf
				
				If (Self.alphaValue <> 0) Then
					Local i:Int
					
					Local x1:Int
					Local y1:Int
					
					Local i2:Int = 0
					
					For Local i2:= 0 Until Self.fillRectRGB.Length
						Self.fillRectRGB[i2] = Self.fillRectRGB[0]
					Next
					
					If (Self.transX + x < Self.clipX) Then
						i = Self.clipX
					Else
						x1 = Self.transX + x
					EndIf
					
					If (Self.transY + y < Self.clipY) Then
						i = Self.clipY
					Else
						y1 = Self.transY + y
					EndIf
					
					Local x2:= ((Self.transX + x) + w)
					Local y2:= ((Self.transY + y) + h)
					
					Self.context.setClip(x1, y1, x2 - x1, y2 - y1)
					
					For Local i2:= 0 Until ((w / 10) + 1)
						For Local j:= 0 Until ((h / 10) + 1)
							Self.context.drawRGB(Self.fillRectRGB, TRANS_NONE, 10, (Self.transX + x) + (i2 * 10), (Self.transY + y) + (j * 10), 10, 10, True)
						Next
					Next
					
					Self.context.setClip(Self.clipX, Self.clipY, Self.clipWidth, Self.clipHeight)
					
					Return
				EndIf
				
				Return
			EndIf
			
			Self.context.fillRect(Self.transX + x, Self.transY + y, w, h)
		End
		
		Method drawArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.drawArc(Self.transX + x, Self.transY + y, width, height, startAngle, arcAngle)
		End
		
		Method fillArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.fillArc(Self.transX + x, Self.transY + y, width, height, startAngle, arcAngle)
		End
		
		Method drawRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.drawRoundRect(Self.transX + x, Self.transY + y, width, height, arcWidth, arcWidth)
		End
		
		Method fillRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
				
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
				
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.fillRoundRect(Self.transX + x, Self.transY + y, width, height, arcWidth, arcWidth)
		End

		Method setFont:Void(font:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				font Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				font Shl= MFDevice.preScaleShift
			EndIf
			
			If (font_type <> font) Then
				currentFont = getFont(font)
				
				If (currentFont <> Null) Then
					font_type = font
				EndIf
			EndIf
			
			Self.context.setFont(currentFont)
		End
		
		Method getFont:Int() Final
			If (MFDevice.preScaleZoomOutFlag) Then
				Return font_type Shl MFDevice.preScaleShift
			EndIf
			
			If (MFDevice.preScaleZoomInFlag) Then
				Return font_type Shr MFDevice.preScaleShift
			EndIf
			
			Return font_type
		End
		
		Method drawString:Void(str:String, x:Int, y:Int, anchor:Int) Final
			Local stringWidth:= stringWidth(str)
			Local charHeight:= charHeight()
			
			If (MFDevice.preScaleZoomOutFlag) Then
				stringWidth Shr= MFDevice.preScaleShift
				charHeight Shr= MFDevice.preScaleShift
				
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				stringWidth Shl= MFDevice.preScaleShift
				charHeight Shl= MFDevice.preScaleShift
				
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
			EndIf
			
			caculateAnchorOffset(stringWidth, charHeight, anchor)
			
			Self.context.drawString(str, (xOff + x) + Self.transX, (yOff + y) + Self.transY, (TOP|RIGHT))
		End

		Method drawSubstring:Void(str:String, offset:Int, len:Int, x:Int, y:Int, anchor:Int) Final
			drawString(str.substring(offset, len), x, y, anchor)
		End
		
		Method charHeight:Int() Final
			Return charHeight(font_type)
		End
		
		Method stringWidth:Int(str:String) Final
			Return stringWidth(font_type, str)
		End
		
		Method enableEffect:Void() Final
			Self.pixelInt = New Int[TRANS_MIRROR_ROT180]
			
			Self.redValue = 0
			Self.greenValue = 0
			Self.blueValue = 0
			Self.alphaValue = 255
			Self.grayValue = 0
			
			Self.effectFlag = True
		End

		Method disableEffect:Void() Final
			Self.effectFlag = False
		End
		
		Method enableExceedBoundary:Void() Final
			Self.enableExceed = True
			
			Self.context.setClip(-MFDevice.horizontalOffset, -MFDevice.verticvalOffset, MFDevice.bufferWidth, MFDevice.bufferHeight)
		End
		
		Method getExceedBoundaryFlag:Bool() Final
			Return Self.enableExceed
		End
		
		Method getEffectFlag:Bool() Final
			Return Self.effectFlag
		End
	
		Method getNativeCanvasLeft:Int() Final
			Return -MFDevice.horizontalOffset
		End
	
		Method getNativeCanvasTop:Int() Final
			Return -MFDevice.verticvalOffset
		End
	
		Method getNativeCanvasRight:Int() Final
			Return (MFDevice.bufferWidth - MFDevice.horizontalOffset)
		End
	
		Method getNativeCanvasBottom:Int() Final
			Return (MFDevice.bufferHeight - MFDevice.verticvalOffset)
		End
	
		Method getNativeCanvasWidth:Int() Final
			Return MFDevice.bufferWidth
		End
	
		Method getNativeCanvasHeight:Int() Final
			Return MFDevice.bufferHeight
		End

		Method disableExceedBoundary:Void() Final
			Self.enableExceed = False
			
			If (MFDevice.preScaleZoomOutFlag) Then
				Self.context.setClip(TRANS_NONE, TRANS_NONE, (MFDevice.bufferWidth - (MFDevice.horizontalOffset Shl 1)) Shl MFDevice.preScaleShift, (MFDevice.bufferHeight - (MFDevice.verticvalOffset Shl 1)) Shl MFDevice.preScaleShift)
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				Self.context.setClip(TRANS_NONE, TRANS_NONE, (MFDevice.bufferWidth - (MFDevice.horizontalOffset Shl 1)) Shr MFDevice.preScaleShift, (MFDevice.bufferHeight - (MFDevice.verticvalOffset Shl 1)) Shr MFDevice.preScaleShift)
			EndIf
			
			Self.context.setClip(TRANS_NONE, TRANS_NONE, MFDevice.bufferWidth - (MFDevice.horizontalOffset Shl 1), MFDevice.bufferHeight - (MFDevice.verticvalOffset Shl 1))
		End

		Method clearScreen:Void(color:Int) Final
			Self.context.setColor(color)
			
			enableExceedBoundary()
			
			Self.context.fillRect(-MFDevice.horizontalOffset, -MFDevice.verticvalOffset, MFDevice.bufferWidth, MFDevice.bufferHeight)
			
			disableExceedBoundary()
		End
		
		Method setHue:Void(rValue:Int, gValue:Int, bValue:Int) Final
			Self.redValue = caculateValue(rValue)
			Self.greenValue = caculateValue(gValue)
			Self.blueValue = caculateValue(bValue)
		End
		
		Method setAlpha:Void(alpha:Int) Final
			Self.alphaValue = alpha
			
			If (Self.alphaValue = 1) Then
				Self.alphaValue = 255
			EndIf
			
			If (Self.alphaValue < 0) Then
				Self.alphaValue = 0
			EndIf
			
			If (Self.alphaValue > 255) Then
				Self.alphaValue = 255
			EndIf
			
			Self.context.setAlpha(Self.alphaValue)
		End
		
		Method getAlpha:Int() Final
			Return Self.context.getAlpha()
		End
		
		Method setGray:Void(gValue:Int) Final
			Self.grayValue = gValue
			
			If (Self.grayValue < 0) Then
				Self.grayValue = 0
			EndIf
			
			If (Self.grayValue > 255) Then
				Self.grayValue = 255
			EndIf
		End
		
		Method drawRegion:Void(img:MFImage, x_src:Int, y_src:Int, width:Int, height:Int, rotate_x:Int, rotate_y:Int, degree:Int, scale_x:Int, scale_y:Int, x_dest:Int, y_dest:Int, anchor:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				x_src Shr= MFDevice.preScaleShift
				y_src Shr= MFDevice.preScaleShift
				
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
				
				rotate_x Shr= MFDevice.preScaleShift
				rotate_y Shr= MFDevice.preScaleShift
				
				scale_x Shr= MFDevice.preScaleShift
				scale_y Shr= MFDevice.preScaleShift
				
				x_dest Shr= MFDevice.preScaleShift
				y_dest Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x_src Shl= MFDevice.preScaleShift
				y_src Shl= MFDevice.preScaleShift
				
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
				
				rotate_x Shl= MFDevice.preScaleShift
				rotate_y Shl= MFDevice.preScaleShift
				
				scale_x Shl= MFDevice.preScaleShift
				scale_y Shl= MFDevice.preScaleShift
				
				x_dest Shl= MFDevice.preScaleShift
				y_dest Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.drawRegion(img.image, x_src, y_src, width, height, rotate_x, rotate_y, degree, scale_x, scale_y, x_dest, y_dest, anchor)
		End
	Private
		' Methods:
		Method caculateValue:Int(value:Int) Final
			If (value < 0) Then
				If (value > -255) Then
					Return value
				EndIf
				
				Return -255
			ElseIf (value = 0) Then
				Return TRANS_NONE
			Else
				If (value > 255) Then
					Return value
				EndIf
				
				Return ((65536 / (256 - value)) - 256)
			EndIf
		End
		
		Method drawImageImpl:Void(image:MFImage, x:Int, y:Int) Final
			If (Self.effectFlag) Then
				Self.drawEffectRGB = New Int[(image.getWidth() * image.getHeight())]
				
				image.getRGB(Self.drawEffectRGB, TRANS_NONE, image.getWidth(), TRANS_NONE, TRANS_NONE, image.getWidth(), image.getHeight()) ' 0, 0, 0
				
				If (Not (Self.alphaValue = 0 Or (Self.redValue = 0 And Self.greenValue = 0 And Self.blueValue = 0))) Then
					For Local i:= 0 Until Self.drawEffectRGB.Length
						Self.drawEffectRGB[i] = caculateColorValue(Self.drawEffectRGB[i])
					Next
				EndIf
				
				If (Not (Self.alphaValue = 0 Or Self.grayValue = 0)) Then
					For Local i:= 0 Until Self.drawEffectRGB.Length
						Self.drawEffectRGB[i] = caculateGray(Self.drawEffectRGB[i])
					Next
				EndIf
				
				If (Not (Self.alphaValue = 255 Or Self.alphaValue = 0)) Then
					For Local i:= 0 Until Self.drawEffectRGB.Length
						Self.drawEffectRGB[i] = caculateAlpha(Self.drawEffectRGB[i])
					Next
				EndIf
				
				If (Self.alphaValue <> 0) Then
					drawRGBFlip(Self.drawEffectRGB, x + Self.transX, y + Self.transY, image.getWidth(), image.getHeight(), TRANS_NONE) ' 0
					
					Return
				EndIf
				
				Return
			EndIf
			
			Self.context.drawImage(image.image, Self.transX + x, Self.transY + y, (TOP|RIGHT))
		End
		
		Method drawRegionImpl:Void(image:MFImage, regionX:Int, regionY:Int, regionW:Int, regionH:Int, flipMode:Int, x:Int, y:Int) Final
			If (Not Self.effectFlag) Then
				Self.context.drawRegion(image.image, regionX, regionY, regionW, regionH, flipMode, x + Self.transX, y + Self.transY, (TOP|RIGHT))
			ElseIf (Self.alphaValue <> 0) Then
				Self.drawEffectRGB = New Int[(regionW * regionH)]
				
				image.getRGB(Self.drawEffectRGB, TRANS_NONE, regionW, regionX, regionY, regionW, regionH) ' 0
				
				If (Not (Self.redValue = 0 And Self.greenValue = 0 And Self.blueValue = 0)) Then
					For Local i:= 0 Until Self.drawEffectRGB.Length
						Self.drawEffectRGB[i] = caculateColorValue(Self.drawEffectRGB[i])
					Next
				EndIf
				
				If (Self.grayValue <> 0) Then
					For Local i:= 0 Until Self.drawEffectRGB.Length
						Self.drawEffectRGB[i] = caculateGray(Self.drawEffectRGB[i])
					Next
				EndIf
				
				If (Self.alphaValue <> 255) Then
					For Local i:= 0 Until Self.drawEffectRGB.Length
						Self.drawEffectRGB[i] = caculateAlpha(Self.drawEffectRGB[i])
					Next
				EndIf
				
				drawRGBFlip(Self.drawEffectRGB, x + Self.transX, y + Self.transY, regionW, regionH, flipMode)
				
				Self.drawEffectRGB = []
			EndIf
		End
		
		Method drawRGBFlip:Void(argb:Int[], x:Int, y:Int, width:Int, height:Int, flipMode:Int) Final
			Local rgbData:= New Int[width]
			
			Select (flipMode)
				Case TRANS_NONE
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						Self.context.drawRGB(rgbData, 0, width, x, y + i, width, 1, True)
					Next
				Case TRANS_MIRROR_ROT180
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						Self.context.drawRGB(rgbData, 0, width, x, ((y + height) - 1) - i, width, 1, True)
					Next
				Case TRANS_MIRROR
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						MFUtility.revertArray(rgbData)
						
						Self.context.drawRGB(rgbData, 0, width, x, y + i, width, 1, True)
					Next
				Case TRANS_ROT180
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						MFUtility.revertArray(rgbData)
						
						Self.context.drawRGB(rgbData, 0, width, x, ((y + height) - 1) - i, width, 1, True)
					Next
				Case TRANS_MIRROR_ROT270
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						Self.context.drawRGB(rgbData, 0, 1, x + i, y, 1, width, True)
					Next
				Case TRANS_ROT90
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						Self.context.drawRGB(rgbData, 0, 1, ((x + height) - 1) - i, y, 1, width, True)
					Next
				Case TRANS_ROT270
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						MFUtility.revertArray(rgbData)
						
						Self.context.drawRGB(rgbData, 0, 1, x + i, y, 1, width, True)
					Next
				Case TRANS_MIRROR_ROT90
					For Local i:= 0 Until height
						GenericUtilities<Int>.CopyArray(argb, rgbData, (i * width), 0, width)
						
						MFUtility.revertArray(rgbData)
						
						Self.context.drawRGB(rgbData, 0, 1, ((x + height) - 1) - i, y, 1, width, True)
					Next
				Default
			End Select
		End
		
		Method caculateColorValue:Int(argb:Int) Final
			Return (((-16777216 & argb) | (caculatePerColor((16711680 & argb) Shr 16, Self.redValue) Shl 16)) | (caculatePerColor((65280 & argb) Shr 8, Self.greenValue) Shl 8)) | caculatePerColor(argb & 255, Self.blueValue)
			'Return (((-16777216 & argb) | (caculatePerColor((16711680 & argb) >>> 16, Self.redValue) Shl 16)) | (caculatePerColor((65280 & argb) >>> 8, Self.greenValue) Shl 8)) | caculatePerColor(argb & 255, Self.blueValue)
		End
		
		Method caculatePerColor:Int(color:Int, value:Int) Final
			If (value = 0) Then
				Return color
			EndIf
			
			color += ((color + 1) * value) Shr 8
			
			If (color > 255) Then
				Return 255
			EndIf
			
			If (color < 0) Then
				Return 0
			EndIf
			
			Return color
		End
		
		Method caculateGray:Int(argb:Int) Final
			Local color:Int
			Local r:= (16711680 & argb) Shr 16 ' >>> 16
			Local g:= (65280 & argb) Shr 8 ' >>> 8
			Local b:= (argb & 255)
			
			If (r > g) Then
				color = r
			Else
				color = g
			EndIf
			
			If (color <= b) Then
				color = b
			EndIf
			
			color = ((Self.grayValue * color) Shr RIGHT)
			
			If (color > 255) Then
				color = 255
			ElseIf (color < 0) Then
				color = 0
			EndIf
			
			Return (color | (((-16777216 & argb) | (color Shl 16)) | (color Shl 8)))
		End
		
		Method caculateAlpha:Int(argb:Int) Final
			Return (16777215 & argb) | (((((-16777216 & argb) Shr 24) * Self.alphaValue) Shr 8) Shl 24) ' MapManager.END_COLOR ' >>>
		End
End