Strict

Public

' Friends:
Friend com.sega.mobile.framework.device.mfdevice
Friend com.sega.mobile.framework.device.mfimage

' Imports:
Private
	'Import com.sega.mobile.framework.android.font
	'Import com.sega.mobile.framework.android.graphics
	
	Import com.sega.mobile.framework.utility.mfutility
	
	Import com.sega.mobile.framework.device.mfimage
	Import com.sega.mobile.framework.device.mfdevice
	
	Import lib.rect
	Import lib.constutil
	
	Import regal.typetool
	Import regal.util
	
	' Debugging related:
	Import mojo.app
	Import mojo.input
Public
	Import com.sega.mobile.framework.android.graphicsmacros
	
	Import mojo2.graphics

' Classes:
Class MFGraphics
	Private
		' Global variable(s):
		'Global currentFont:Font
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
		
		Global xOff:Int = 0
		Global yOff:Int = 0
		
		' Fields:
		Field clipX:Int
		Field clipY:Int
		Field clipWidth:Int
		Field clipHeight:Int
		
		'Field redValue:Int
		'Field greenValue:Int
		'Field blueValue:Int
		'Field alphaValue:Int
		'Field grayValue:Int
		
		Field transX:Int
		Field transY:Int
		
		Field effectFlag:Bool
		Field enableExceed:Bool
	Protected
		' Fields:
		Field context:Canvas ' DrawList
	Private
		' Constructor(s):
		Method New()
			' Nothing so far.
		End
	Public
		' Functions:
		Function init:Void() ' Final
			' Nothing so far.
		End
		
		Function createMFGraphics:MFGraphics(graphics:Canvas, width:Int, height:Int) ' Final
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
		
		Function createMFGraphics:MFGraphics(surface:MFImage, width:Int, height:Int)
			Return createMFGraphics(New Canvas(surface.image), width, height)
		End
		
		Function charHeight:Int(var:Int)
			'var = 30
			
			If (MFDevice.preScaleZoomOutFlag) Then
				var Shl= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				var Shr= MFDevice.preScaleShift
			EndIf
			
			Return var
		End
		
		' Unimplemented feature: Font IDs
		Function stringWidth:Int(font:Int, str:String) ' Final
			Return Self.context.Font.TextWidth(str)
		End
		
		' Extensions:
		
		' These retrieve the color values from an encoded RGBA/ARGB integer.
		Function getA:Int(color:Int)
			Return ((color Shr 24) & UOCTET_MAX)
		End
		
		Function getR:Int(color:Int)
			Return ((color Shr 16) & UOCTET_MAX)
		End
		
		Function getG:Int(color:Int)
			Return ((color Shr 8) & UOCTET_MAX)
		End
		
		Function getB:Int(color:Int)
			Return (color & UOCTET_MAX)
		End
		
		' This converts intgeral color channels to floating-point. (0.0-1.0)
		Function colorToFloat:Float(colorChannel:Int)
			Return (Float(colorChannel) / Float(UOCTET_MAX))
		End
		
		' This converts floating-point color channels to integer (0-255).
		Function floatToColor:Int(colorChannel:Float)
			Return Int(colorChannel * Float(UOCTET_MAX))
		End
		
		' This converts floating-point color data to an RGB(A) integer.
		Function toColor:Int(colors:Float[], offset:Int=0, alpha:Bool=True, default_alpha:Int=0) ' 255
			Local r:= floatToColor(colors[offset])
			Local g:= floatToColor(colors[offset+1])
			Local b:= floatToColor(colors[offset+2])
			
			Local a:= default_alpha
			
			If (alpha And (colors.Length-offset) > 3) Then
				a = floatToColor(colors[offset+3])
			Endif
			
			Local out_a:= ((a Shl 24) & 16777215)
			Local out_r:= ((r Shl 16) & 65535)
			Local out_g:= ((g Shl 8) & 255)
			Local out_b:= ((b))
			
			Return (out_r|out_g|out_b|out_a)
		End
		
		' These automatically retrieve and convert color data
		' from 'color' for their designated channels:
		Function getAf:Float(color:Int)
			Return colorToFloat(getA(color))
		End
		
		Function getRf:Float(color:Int)
			Return colorToFloat(getR(color))
		End
		
		Function getGf:Float(color:Int)
			Return colorToFloat(getG(color))
		End
		
		Function getBf:Float(color:Int)
			Return colorToFloat(getB(color))
		End
		
		' Methods:
		
		' Extensions:
		Method FontHeight:Int()
			Return Self.context.Font.TextHeight(" ") ' "A"
		End
		
		Method clear:Void()
			Self.context.Clear()
		End
		
		Method flush:Void()
			Self.context.Flush()
		End
		
		Method saveCanvas:Void()
			Self.context.PushMatrix()
			'Self.context.save()
		End
		
		Method restoreCanvas:Void()
			'Self.context.restore()
			Self.context.PopMatrix()
		End
		
		' This method may be removed in the future.
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
			
			Self.context.SetScissor(left, top, right-left, bottom-top)
			'Self.context.SetScissor(left, top, right, bottom)
		End
		
		Method rotateCanvas:Void(degrees:Float)
			Self.context.Rotate(degrees)
		End
		
		Method rotateCanvas:Void(degrees:Float, px:Int, py:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				px Shr= MFDevice.preScaleShift
				py Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				px Shl= MFDevice.preScaleShift
				py Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.TranslateRotate(px, py, degrees)
		End
		
		Method scaleCanvas:Void(sx:Float, sy:Float)
			Self.context.Scale(sx, sy)
		End
		
		Method scaleCanvas:Void(sx:Float, sy:Float, px:Int, py:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				px Shr= MFDevice.preScaleShift
				py Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				px Shl= MFDevice.preScaleShift
				py Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.TranslateScale(Float(px), Float(py), sx, sy)
		End
		
		Method translateCanvas:Void(dx:Int, dy:Int)
			If (MFDevice.preScaleZoomOutFlag) Then
				dx Shr= MFDevice.preScaleShift
				dy Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				dx Shl= MFDevice.preScaleShift
				dy Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.Translate(Float(dx), Float(dy))
		End
		
		Method getSystemGraphics:Canvas() Final
			Return Self.context
		End
		
		Method getGraphics:Canvas() Final
			Return getSystemGraphics()
		End
		
		Method setGraphics:Void(graphics:Canvas) Final
			Self.context = graphics
		End
		
		' This method may behave differently in the future.
		Method setGraphics:Void(graphics:Canvas, width:Int, height:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				width Shr= MFDevice.preScaleShift
				height Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				width Shl= MFDevice.preScaleShift
				height Shl= MFDevice.preScaleShift
			EndIf
			
			reset()
			
			setGraphics(graphics)
			
			'graphics.SetProjection2d(0, MFDevice.canvasWidth, 0, MFDevice.canvasHeight) ' clipCanvas(...)
			graphics.SetProjection2d(0, width, 0, height) ' clipCanvas(...)
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
			
			Self.transX = 0
			Self.transY = 0
			
			Self.clipX = 0
			Self.clipY = 0
			
			Self.clipWidth = screenWidth
			Self.clipHeight = screenHeight
			
			Self.context.SetViewport(Self.clipX, Self.clipY, clipWidth, clipHeight)
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
				Self.context.SetViewport(Self.clipX, Self.clipY, Self.clipWidth, Self.clipHeight)
				
				Return
			EndIf
			
			Local tx:Int
			Local ty:Int
			
			Local cx:= PickValue((Self.clipX < 0), 0, Self.clipX)
			Local cy:= PickValue((Self.clipY < 0), 0, Self.clipY)
			
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
			
			Self.context.SetViewport(cx, cy, tx - cx, ty - cy)
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
			drawRegion(image, 0, 0, image.getWidth(), image.getHeight(), flipMode, x, y, anchor)
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int, regionX:Int, regionY:Int, regionW:Int, regionH:Int) Final
			drawRegion(image, regionX, regionY, regionW, regionH, 0, x, y, (TOP|RIGHT))
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
		' Methods:
		Method caculateAnchorOffset:Void(width:Int, height:Int, anchor:Int) Final
			xOff = 0
			yOff = 0
			
			If ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				xOff -= (width / 2) ' Shr 1
			ElseIf ((anchor & RIGHT) <> 0) Then
				xOff -= width
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				yOff -= (height / 2) ' Shr 1
			ElseIf ((anchor & BOTTOM) <> 0) Then
				yOff -= height
			EndIf
		End
	Public
		' This is only really used for fade effects, so it can be replaced
		' pretty easily. Therefore, this method may be removed at a later date.
		Method drawRGB:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int, processAlpha:Bool)
			' Unimplemented method.
			
			Return
		End
		
		Method setColor:Void(color:Int)
			Self.context.setColor(color)
		End
		
		Method getColor:Int()
			Return toColor(Self.context.Color)
		End
		
		Method setColor:Void(red:Int, green:Int, blue:Int)
			'Local color:= (((red Shl 16) | (green Shl 8)) | blue)
			
			'Self.context.SetColor(getRf(color), getGf(color), getBf(color))
			
			Self.context.SetColor(colorToFloat(red), colorToFloat(green), colorToFloat(blue))
		End
		
		Method drawPixel:Void(x:Int, y:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				x Shr= MFDevice.preScaleShift
				y Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				x Shl= MFDevice.preScaleShift
				y Shl= MFDevice.preScaleShift
			EndIf
			
			Self.context.DrawPoint(Float(x), Float(y))
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
			
			#Rem
				If (Self.effectFlag) Then
					'drawLinePerPixel(Self.transX + x1, Self.transY + y1, Self.transX + x2, Self.transY + y2)
					
					Return
				EndIf
			#End
			
			Self.context.DrawLine(Float(Self.transX + x1), Float(Self.transY + y1), Float(Self.transX + x2), Float(Self.transY + y2))
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
			
			Local fx1:= Float(Self.transX + x1)
			Local fy1:= Float(Self.transY + y1)
			Local fx2:= Float(Self.transX + x2)
			Local fy2:= Float(Self.transY + y2)
			Local fx3:= Float(Self.transX + x3)
			Local fy3:= Float(Self.transY + y3)
			
			Self.context.DrawLine(fx1, fy1, fx2, fy2) ' drawLine(..)
			Self.context.DrawLine(fx2, fy2, fx3, fy3) ' drawLine(..)
			Self.context.DrawLine(fx3, fy3, fx1, fy1) ' drawLine(..)
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
					fillRect(x, y, w, 1)
					fillRect(x, y, 1, h)
					fillRect(x + w, y, 1, h)
					fillRect(x, y + h, w, 1)
					
					Return
				EndIf
				
				' This behavior may change in the future:
				'Self.context.DrawRect(Float(x), Float(y), Float(w), Float(h))
				
				Local fx:= Float(Self.transX + x)
				Local fy:= Float(Self.transY + y)
				
				Local fw:= Float(w)
				Local fh:= Float(h)
				
				Local fullX:= (fx + fw)
				Local fullY:= (fy + fh)
				
				Self.context.DrawLine(fx, fy, fullX, fy) ' drawLine(..)
				Self.context.DrawLine(fx, fy, fx, fullY) ' drawLine(..)
				Self.context.DrawLine(fullX, fy, fullX, fullY) ' drawLine(..)
				Self.context.DrawLine(fx, fullY, fullX, fullY) ' drawLine(..)
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
			
			#Rem
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
						
						Self.context.SetViewport(x1, y1, x2 - x1, y2 - y1)
						
						For Local i2:= 0 Until ((w / 10) + 1)
							For Local j:= 0 Until ((h / 10) + 1)
								Self.context.drawRGB(Self.fillRectRGB, 0, 10, (Self.transX + x) + (i2 * 10), (Self.transY + y) + (j * 10), 10, 10, True)
							Next
						Next
						
						Self.context.SetViewport(Self.clipX, Self.clipY, Self.clipWidth, Self.clipHeight)
						
						Return
					EndIf
					
					Return
				EndIf
			#End
			
			Self.context.DrawRect(Float(Self.transX + x), Float(Self.transY + y), Float(w), Float(h))
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
			
			'Self.context.drawArc(Self.transX + x, Self.transY + y, width, height, startAngle, arcAngle)
			
			' Unimplemented method.
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
			
			'Self.context.fillArc(Self.transX + x, Self.transY + y, width, height, startAngle, arcAngle)
			
			' Unimplemented method.
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
			
			'Self.context.drawRoundRect(Self.transX + x, Self.transY + y, width, height, arcWidth, arcWidth)
			
			' This behavior may change in the future.
			drawRect(x, y, width, height)
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
			
			'Self.context.fillRoundRect(Self.transX + x, Self.transY + y, width, height, arcWidth, arcWidth)
			
			' This behavior may change in the future.
			fillRect(x, y, width, height)
		End
		
		Method setFont:Void(font:Int) Final
			If (MFDevice.preScaleZoomOutFlag) Then
				font Shr= MFDevice.preScaleShift
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				font Shl= MFDevice.preScaleShift
			EndIf
			
			' Unimplemented method.
		End
		
		Method getFont:Int() Final
			' Unimplemented method.
			Return 0
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
			
			anchor = (TOP|RIGHT)
			
			x = ((xOff + x) + Self.transX)
			y = ((yOff + y) + Self.transY)
			
			If ((anchor & HCENTER) <> 0) Then
				x -= (Self.context.Font.TextWidth(str) / 2) ' VCENTER
			ElseIf ((anchor & RIGHT) <> 0) Then
				x -= Self.context.Font.TextWidth(str)
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				y -= FontHeight() / 2 ' VCENTER
			ElseIf ((anchor & BOTTOM) <> 0) Then
				y -= FontHeight()
			EndIf
			
			Self.context.DrawText(str, Float(x), Float(y))
		End
		
		Method drawSubstring:Void(str:String, offset:Int, len:Int, x:Int, y:Int, anchor:Int) Final
			drawString(str[offset..len], x, y, anchor)
		End
		
		Method charHeight:Int() Final
			Return charHeight(font_type)
		End
		
		Method stringWidth:Int(str:String) Final
			Return stringWidth(font_type, str)
		End
		
		Method enableEffect:Void() Final
			#Rem
				Self.pixelInt = New Int[1]
				
				Self.redValue = 0
				Self.greenValue = 0
				Self.blueValue = 0
				Self.alphaValue = 255
				Self.grayValue = 0
			#End
			
			Self.effectFlag = True
		End
		
		Method disableEffect:Void() Final
			Self.effectFlag = False
		End
		
		Method enableExceedBoundary:Void() Final
			Self.enableExceed = True
			
			Self.context.SetViewport(-MFDevice.horizontalOffset, -MFDevice.verticvalOffset, MFDevice.bufferWidth, MFDevice.bufferHeight)
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
				Self.context.SetViewport(0, 0, (MFDevice.bufferWidth - (MFDevice.horizontalOffset * 2)) Shl MFDevice.preScaleShift, (MFDevice.bufferHeight - (MFDevice.verticvalOffset * 2)) Shl MFDevice.preScaleShift) ' Shl 1
			ElseIf (MFDevice.preScaleZoomInFlag) Then
				Self.context.SetViewport(0, 0, (MFDevice.bufferWidth - (MFDevice.horizontalOffset * 2)) Shr MFDevice.preScaleShift, (MFDevice.bufferHeight - (MFDevice.verticvalOffset * 2)) Shr MFDevice.preScaleShift) ' Shl 1
			EndIf
			
			Self.context.SetViewport(0, 0, MFDevice.bufferWidth - (MFDevice.horizontalOffset * 2), MFDevice.bufferHeight - (MFDevice.verticvalOffset * 2)) ' Shl 1
		End
		
		Method clearScreen:Void(color:Int) Final
			'clear()
			
			setColor(color)
			
			enableExceedBoundary()
			
			Self.context.DrawRect(-MFDevice.horizontalOffset, -MFDevice.verticvalOffset, MFDevice.bufferWidth, MFDevice.bufferHeight)
			
			disableExceedBoundary()
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
			
			drawRegionImpl(img.image, x_src, y_src, width, height, rotate_x, rotate_y, degree, scale_x, scale_y, x_dest, y_dest, anchor)
		End
	Private
		' Methods:
		Method drawRegionImpl:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, rotate_x:Int, rotate_y:Int, degree:Int, scale_x:Int, scale_y:Int, x_dest:Int, y_dest:Int, anchor:Int)
			saveCanvas()
			
			If ((anchor & BOTTOM) <> 0) Then
				y_dest -= height
			ElseIf ((anchor & VCENTER) <> 0) Then
				y_dest -= (height / 2) ' Shr 1
			EndIf
			
			If ((anchor & RIGHT) <> 0) Then
				x_dest -= width
			ElseIf ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x_dest -= (width / 2) ' Shr 1
			EndIf
			
			Self.context.Translate(Float(x_dest - x_src), Float(y_dest - y_src))
			Self.context.TranslateRotate(Float(degree), Float(rotate_x + x_src), Float(rotate_y + y_src))
			Self.context.TranslateScale(Float(scale_x), Float(scale_y), Float((width / 2) + x_src), Float((height / 2) + y_src))
			
			Self.context.DrawRect(0.0, 0.0, Float(width), Float(height), img.image, x_src, y_src, width, height)
			
			restoreCanvas()
		End
		
		Method drawRegionImpl:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, transform:Int, x_dest:Int, y_dest:Int, anchor:Int=(TOP|RIGHT)) Final
			#Rem
				If (Not Self.effectFlag) Then
					Return
				EndIf
			#End
			
			x_dest += Self.transX
			y_dest += Self.transY
			
			saveCanvas()
			
			Local drawWidth:= width
			Local drawHeight:= height
			
			Local xOffset:= 0
			Local yOffset:= 0
			
			Select (transform)
				Case TRANS_NONE
					xOffset = -x_src
					yOffset = -y_src
				Case TRANS_MIRROR_ROT180
					Self.context.Scale(-1.0, 1.0)
					Self.context.Rotate(-180.0)
					
					xOffset = -x_src
					yOffset = drawHeight + y_src
				Case TRANS_MIRROR
					Self.context.Scale(-1.0, 1.0)
					
					xOffset = drawWidth + x_src
					yOffset = -y_src
				Case TRANS_ROT180
					Self.context.Rotate(180.0)
					
					xOffset = drawWidth + x_src
					yOffset = drawHeight + y_src
				Case TRANS_MIRROR_ROT270
					Self.context.Scale(-1.0, 1.0)
					Self.context.Rotate(-270.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = -y_src
					yOffset = -x_src
				Case TRANS_ROT90
					Self.context.Rotate(90.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = drawWidth + y_src
					yOffset = -x_src
				Case TRANS_ROT270
					Self.context.Rotate(270.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = -y_src
					yOffset = drawHeight + x_src
				Case TRANS_MIRROR_ROT90
					Self.context.Scale(-1.0, 1.0)
					Self.context.Rotate(-90.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = drawWidth + y_src
					yOffset = drawHeight + x_src
			End Select
			
			If (anchor = 0) Then
				anchor = (TOP|RIGHT)
			EndIf
			
			If ((anchor & BOTTOM) <> 0) Then
				y_dest -= drawHeight
			ElseIf ((anchor & VCENTER) <> 0) Then
				y_dest -= drawHeight Shr 1 ' >>> 1 ' / 2
			EndIf
			
			If ((anchor & RIGHT) <> 0) Then
				x_dest -= drawWidth
			ElseIf ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x_dest -= drawWidth Shr 1 ' >>> 1 ' / 2
			EndIf
			
			If (KeyDown(KEY_X)) Then
				DebugStop()
			EndIf
			
			Self.context.DrawRect(Float(x_dest + xOffset), Float(y_dest + yOffset), drawWidth, drawHeight, image, x_src, y_src, width, height)
			
			restoreCanvas()
		End
		
		Method drawImageImpl:Void(MFImg:MFImage, x:Int, y:Int, anchor:Int=(TOP|RIGHT)) Final
			#Rem
				If (Self.effectFlag) Then
					Return
				EndIf
			#End
			
			Local image:= MFImg.image
			
			x += Self.transX
			y += Self.transY
			
			If ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x -= image.Width() / 2 ' Width
			ElseIf ((anchor & RIGHT) <> 0) Then
				x -= image.Width() ' Width
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				y -= image.Height() / 2 ' Height
			ElseIf ((anchor & BOTTOM) <> 0) Then
				y -= image.Height() ' Height
			EndIf
			
			Self.context.DrawImage(image, Float(x), Float(y))
		End
		
		#Rem
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
						' Nothing so far.
				End Select
			End
		#End
		
		#Rem
			' Hue correction?
			Method caculateValue:Int(value:Int) Final
				If (value < 0) Then
					If (value > -255) Then
						Return value
					EndIf
					
					Return -255
				ElseIf (value = 0) Then
					Return 0
				Else
					If (value > 255) Then
						Return value
					EndIf
					
					Return ((65536 / (256 - value)) - 256)
				EndIf
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
		#End
End