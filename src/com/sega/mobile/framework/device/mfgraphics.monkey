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
			
			Return var
		End
		
		' Unimplemented feature: Font IDs
		Function stringWidth:Int(font:Int, str:String) ' Final
			Return (16 * str.Length) ' Self.context.Font.TextWidth(str)
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
		
		Method rotateCanvas:Void(degrees:Float)
			Self.context.Rotate(degrees)
		End
		
		Method rotateCanvas:Void(degrees:Float, px:Int, py:Int)
			Self.context.TranslateRotate(px, py, degrees)
		End
		
		Method scaleCanvas:Void(sx:Float, sy:Float)
			Self.context.Scale(sx, sy)
		End
		
		Method scaleCanvas:Void(sx:Float, sy:Float, px:Int, py:Int)
			Self.context.TranslateScale(Float(px), Float(py), sx, sy)
		End
		
		Method translateCanvas:Void(dx:Int, dy:Int)
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
			reset()
			
			setGraphics(graphics)
		End
		
		Method reset:Void() Final
			Local screenWidth:= MFDevice.getScreenWidth()
			Local screenHeight:= MFDevice.getScreenHeight()
			
			Self.transX = 0
			Self.transY = 0
			
			Self.clipX = 0
			Self.clipY = 0
			
			Self.clipWidth = screenWidth
			Self.clipHeight = screenHeight
			
			If (Self.context <> Null) Then
				Self.context.SetProjection2d(0, screenWidth, 0, screenHeight) ' MFDevice.canvasWidth ' MFDevice.canvasHeight
				'Self.context.SetScissor(Self.clipX, Self.clipY, Self.clipWidth, Self.clipHeight)
			EndIf
		End
		
		Method translate:Void(x:Int, y:Int) Final
			Self.transX += x
			Self.transY += y
			
			Self.clipX += x
			Self.clipY += y
		End
		
		Method setTranslate:Void(x:Int, y:Int) Final
			translate(x - Self.transX, y - Self.transY)
		End
		
		Method getTranslateX:Int() Final
			Return Self.transX
		End
		
		Method getTranslateY:Int() Final
			Return Self.transY
		End
		
		Method setClip:Void(x:Int, y:Int, width:Int, height:Int) Final
			Local screenWidth:= MFDevice.getScreenWidth()
			Local screenHeight:= MFDevice.getScreenHeight()
			
			Self.clipX = (Self.transX + x)
			Self.clipY = (Self.transY + y)
			
			Self.clipWidth = width
			Self.clipHeight = height
			
			If (Self.enableExceed) Then
				'Self.context.SetScissor(Self.clipX, Self.clipY, Self.clipWidth, Self.clipHeight)
				
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
			
			'Print("cx: " + cx + ", cy: " + cy + ", tx - cx: " + (tx - cx) + ", ty - cy: " + (ty - cy))
			
			'Self.context.SetScissor(cx, cy, tx, ty) ' SetViewport
			'Self.context.SetScissor(cx, cy, width - (tx - cx), height - (ty - cy)) ' SetViewport
			
			'''Self.context.SetProjection2d(cx, tx, cy, ty)
			'''Self.context.SetScissor(cx, cy, tx - cx, ty - cy)
			
			'Self.transX = (width - (tx - cx))
			'Self.transY = (height - (ty - cy))
		End
		
		Method getClipX:Int() Final
			Return (Self.clipX - Self.transX)
		End
		
		Method getClipY:Int() Final
			Return (Self.clipY - Self.transY)
		End
		
		Method getClipWidth:Int() Final
			Return Self.clipWidth
		End
		
		Method getClipHeight:Int() Final
			Return Self.clipHeight
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int, anchor:Int) Final
			Local imageWidth:= image.getWidth()
			Local imageHeight:= image.getHeight()
			
			drawImageImpl(image, x, y, anchor)
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int) Final
			drawImage(image, x, y, (TOP|LEFT))
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int, flipMode:Int, anchor:Int) Final
			drawRegion(image, 0, 0, image.getWidth(), image.getHeight(), flipMode, x, y, anchor)
		End
		
		Method drawImage:Void(image:MFImage, x:Int, y:Int, regionX:Int, regionY:Int, regionW:Int, regionH:Int) Final
			drawRegion(image, regionX, regionY, regionW, regionH, 0, x, y, (TOP|LEFT))
		End
		
		Method drawRegion:Void(img:MFImage, regionX:Int, regionY:Int, regionW:Int, regionH:Int, flipMode:Int, x:Int, y:Int, anchor:Int) Final
			drawRegionImpl(img.image, regionX, regionY, regionW, regionH, flipMode, x, y, anchor)
		End
	Private
		' Methods:
		Method caculateAnchorOffset:Void(width:Int, height:Int, anchor:Int) Final
			xOff = 0
			yOff = 0
			
			If ((anchor & HCENTER) <> 0) Then
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
			
			Print("Unimplemented method: drawRGB")
		End
		
		Method setColor:Void(color:Int)
			'Print("Color: " + color)
			
			'Print("R: " + getRf(color) + ", G: " + getGf(color) + ", B: " + getBf(color))
			
			'''Self.context.SetColor(getRf(color), getGf(color), getBf(color)) ' getAf(color)
		End
		
		Method getColor:Int()
			Return toColor(Self.context.Color)
		End
		
		Method setColor:Void(red:Int, green:Int, blue:Int)
			'Local color:= (((red Shl 16) | (green Shl 8)) | blue)
			
			'Self.context.SetColor(getRf(color), getGf(color), getBf(color))
			
			'''Self.context.SetColor(colorToFloat(red), colorToFloat(green), colorToFloat(blue))
		End
		
		Method drawPixel:Void(x:Int, y:Int) Final
			Self.context.DrawPoint(Float(Self.transX + x), Float(Self.transY + y))
		End
		
		Method drawLine:Void(x1:Int, y1:Int, x2:Int, y2:Int) Final
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
			Self.context.DrawRect(Float(Self.transX + x), Float(Self.transY + y), Float(w), Float(h))
		End
		
		Method drawArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int) Final
			'Self.context.drawArc(Self.transX + x, Self.transY + y, width, height, startAngle, arcAngle)
			
			' Unimplemented method.
			
			Print("Unimplemented method: drawArc")
		End
		
		Method fillArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int) Final
			'Self.context.fillArc(Self.transX + x, Self.transY + y, width, height, startAngle, arcAngle)
			
			' Unimplemented method.
			Print("Unimplemented method: fillArc")
		End
		
		Method drawRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int) Final
			'Self.context.drawRoundRect(Self.transX + x, Self.transY + y, width, height, arcWidth, arcWidth)
			
			' This behavior may change in the future.
			drawRect(x, y, width, height)
		End
		
		Method fillRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int) Final
			'Self.context.fillRoundRect(Self.transX + x, Self.transY + y, width, height, arcWidth, arcWidth)
			
			' This behavior may change in the future.
			fillRect(x, y, width, height)
		End
		
		Method setFont:Void(font:Int) Final
			' Unimplemented method.
		End
		
		Method getFont:Int() Final
			' Unimplemented method.
			Return 0
		End
		
		Method drawString:Void(str:String, x:Int, y:Int, anchor:Int) Final
			Local stringWidth:= stringWidth(str)
			Local charHeight:= charHeight()
			
			caculateAnchorOffset(stringWidth, charHeight, anchor)
			
			anchor = (TOP|LEFT)
			
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
			' Magic number: 0 (Font ID; unimplemented)
			Return charHeight(0)
		End
		
		Method stringWidth:Int(str:String) Final
			' Magic number: 0 (Font ID; unimplemented)
			Return stringWidth(0, str)
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
			
			Print("enableExceedBoundary:")
			Print("MFDevice.bufferWidth: " + MFDevice.bufferWidth)
			Print("MFDevice.bufferHeight: " + MFDevice.bufferHeight)
			
			'Self.context.SetViewport(-MFDevice.horizontalOffset, -MFDevice.verticvalOffset, MFDevice.bufferWidth, MFDevice.bufferHeight)
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
			
			Print("disableExceedBoundary:")
			
			Print("MFDevice.bufferWidth: " + MFDevice.bufferWidth)
			Print("MFDevice.bufferHeight: " + MFDevice.bufferHeight)
			Print("MFDevice.horizontalOffset: " + MFDevice.horizontalOffset)
			Print("MFDevice.verticvalOffset: " + MFDevice.verticvalOffset)
			
			'If (MFDevice.preScaleZoomOutFlag) Then
				'Self.context.SetScissor(0, 0, (MFDevice.bufferWidth - (MFDevice.horizontalOffset * 2)) Shl MFDevice.preScaleShift, (MFDevice.bufferHeight - (MFDevice.verticvalOffset * 2)) Shl MFDevice.preScaleShift) ' Shl 1
			'ElseIf (MFDevice.preScaleZoomInFlag) Then
				'Self.context.SetScissor(0, 0, (MFDevice.bufferWidth - (MFDevice.horizontalOffset * 2)) Shr MFDevice.preScaleShift, (MFDevice.bufferHeight - (MFDevice.verticvalOffset * 2)) Shr MFDevice.preScaleShift) ' Shl 1
			'EndIf
			
			'Self.context.SetScissor(0, 0, MFDevice.bufferWidth - (MFDevice.horizontalOffset * 2), MFDevice.bufferHeight - (MFDevice.verticvalOffset * 2)) ' Shl 1
		End
		
		Method clearScreen:Void(color:Int) Final
			'clear()
			
			setColor(color)
			
			enableExceedBoundary()
			
			Self.context.DrawRect(-MFDevice.horizontalOffset, -MFDevice.verticvalOffset, MFDevice.bufferWidth, MFDevice.bufferHeight)
			
			disableExceedBoundary()
		End
	Private
		' Methods:
		Method drawRegionImpl:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, transform:Int, x_dest:Int, y_dest:Int, anchor:Int=(TOP|LEFT)) Final
			If (transform <> TRANS_NONE) Then ' TRANS_MIRROR_ROT180
				'transform = TRANS_NONE
				
				'restoreCanvas()
				
				'Return
			EndIf
			
			Local drawWidth:= width
			Local drawHeight:= height
			
			'DebugStop()
			
			'Self.context.DrawImage(image, 0, 0)
			'Self.context.SetColor(0.5, 0.2, 1.0)
			
			Self.context.SetAlpha(0.5)
			Self.context.DrawRect(0.0, 0.0, drawWidth, drawHeight, image, x_src, y_src, width, height)
			Self.context.SetAlpha(1.0)
			
			'Self.context.SetColor(1.0, 1.0, 1.0)
			
			#Rem
				If (Not Self.effectFlag) Then
					Return
				EndIf
			#End
			
			If (Self.transX <> 0 Or Self.transY <> 0) Then
				Print("Self.trans: " + Self.transX + ", " + Self.transY)
			EndIf
			
			x_dest += Self.transX
			y_dest += Self.transY
			
			saveCanvas()
			
			Local xOffset:= 0
			Local yOffset:= 0
			
			Select (transform)
				Case TRANS_NONE
					'xOffset = -x_src
					'yOffset = -y_src
				Case TRANS_MIRROR_ROT180
					xOffset = (drawWidth)
					yOffset = (drawHeight)
				Case TRANS_MIRROR
					xOffset = (drawWidth)
					'yOffset = -y_src
				Case TRANS_ROT180
					'xOffset = -x_src
					yOffset = (drawHeight)
				Case TRANS_MIRROR_ROT270
					drawWidth = height
					drawHeight = width
					
					xOffset = -y_src
					yOffset = (drawHeight) ' + x_src
				Case TRANS_ROT90
					drawWidth = height
					drawHeight = width
					
					xOffset = (drawWidth)
					yOffset = (drawHeight)
				Case TRANS_ROT270
					drawWidth = height
					drawHeight = width
					
					'xOffset = -y_src
					'yOffset = -x_src
				Case TRANS_MIRROR_ROT90
					drawWidth = height
					drawHeight = width
					
					xOffset = (drawWidth)
					'yOffset = -x_src
			End Select
			
			Self.context.Translate((x_dest), (y_dest))
			
			Local handleX:Int, handleY:Int
			
			If (anchor = 0) Then
				anchor = (TOP|LEFT)
			EndIf
			
			If ((anchor & BOTTOM) <> 0) Then
				handleY = drawHeight
			ElseIf ((anchor & VCENTER) <> 0) Then
				handleY = (drawHeight / 2)
			EndIf
			
			If ((anchor & RIGHT) <> 0) Then
				handleX = drawWidth
			ElseIf ((anchor & HCENTER) <> 0) Then
				handleX = (drawWidth / 2)
			EndIf
			
			'x_dest -= handleX
			'y_dest -= handleY
			
			Select (transform)
				Case TRANS_NONE
					' Nothing so far.
				Case TRANS_MIRROR_ROT180
					Self.context.Rotate(-180.0)
					Self.context.Scale(-1.0, 1.0)
				Case TRANS_MIRROR
					Self.context.Scale(-1.0, 1.0)
				Case TRANS_ROT180
					Self.context.Rotate(180.0)
				Case TRANS_MIRROR_ROT270
					Self.context.Rotate(-270.0)
					Self.context.Scale(-1.0, 1.0)
				Case TRANS_ROT90
					Self.context.Rotate(90.0)
				Case TRANS_ROT270
					Self.context.Rotate(270.0)
				Case TRANS_MIRROR_ROT90
					Self.context.Rotate(-90.0)
					Self.context.Scale(-1.0, 1.0)
			End Select
			
			Self.context.Translate(-handleX, -handleY)
			Self.context.Translate((-xOffset), (-yOffset))
			
			'Self.context.Translate(x_dest, y_dest)
			
			Self.context.DrawRect(0.0, 0.0, drawWidth, drawHeight, image, x_src, y_src, width, height)
			
			restoreCanvas()
		End
		
		Method drawImageImpl:Void(MFImg:MFImage, x:Int, y:Int, anchor:Int=(TOP|LEFT)) Final
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