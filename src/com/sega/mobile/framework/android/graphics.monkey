Strict

Public

' Friends:
Friend com.sega.mobile.framework.device.mfdevice
Friend com.sega.mobile.framework.device.mfgraphics
Friend com.sega.mobile.framework.device.mfimage

' Imports:
Private
	#Rem
		Import android.graphics.bitmap
		Import android.graphics.canvas
		Import android.graphics.matrix
		Import android.graphics.paint
		Import android.graphics.paint.style
		Import android.graphics.path
		'Import android.graphics.rect
		'Import android.graphics.rectf
		Import android.graphics.region.op
	#End
	
	Import lib.rect
	
	Import regal.typetool
	'Import regal.matrix2d
	
	' Debugging related:
	Import mojo.input
	
	Import mojo.app
Public
	Import mojo2.graphics
	
	Import com.sega.mobile.framework.android.graphicsmacros

' Classes:
Class Graphics ' _Graphics
	Protected
		' Constant variable(s):
		
		' Extensions:
		Const NATIVE_COLOR_COUNT:= 4 ' 3
		Const NATIVE_CLIP_COUNT:= 4
		
		' Fields:
		Field mCanvas:Canvas ' DrawList
		'Field mFont:Font
		'Field mMatrix:Matrix2D
		'Field mPaint:Paint
		'Field mPath:Path
		
		' Extensions:
		Field clipVec:Stack<Int> = New Stack<Int>()
		Field colors:Stack<Float> = New Stack<Float>()
	Private
		' Functions:
		
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
	Public
		' Functions:
		Function createBitmapGraphics:Graphics(output:Object=Null)
			Return New Graphics(output)
		End
		
		' Constructor(s):
		Method New(target:Object=Null)
			Self.mCanvas = New Canvas(target)
			
			'Self.mMatrix = New Matrix2D()
			
			#Rem
				Self.mPath = New Path()
				Self.mPaint = New Paint()
				Self.NativeFont = Font.getFont(TRANS_NONE, TRANS_NONE, RIGHT) ' 0, 0, 8
				
				Self.mPaint.setAntiAlias(True)
				Self.mPaint.setFilterBitmap(True)
				Self.mPaint.setTextSize(Float(FontHeight()))
			#End
		End
		
		' Properties (Extensions):
		Method NativeFont:Font() Property
			Return mCanvas.Font
		End
		
		Method NativeFont:Void(font:Font) Property
			mCanvas.SetFont(font)
		End
		
		' Methods:
		
		' Extensions:
		Method FontHeight:Int()
			Return NativeFont.TextHeight(" ") ' "A"
		End
		
		Method clear:Void()
			mCanvas.Clear()
		End
		
		Method flush:Void()
			mCanvas.Flush()
		End
		
		' Mojo 2 argument order is used here.
		Method setInitialClip:Void(left:Int, right:Int, top:Int, bottom:Int)
			mCanvas.SetProjection2d(Float(left), Float(right), Float(top), Float(bottom))
			'mCanvas.SetScissor(0, 0, DeviceWidth(), DeviceHeight())
		End
		
		Method setFilterBitmap:Void(b:Bool)
			'Self.mPaint.setFilterBitmap(b)
		End
		
		Method setAntiAlias:Void(b:Bool)
			'Self.mPaint.setAntiAlias(b)
		End
		
		Method setAlpha:Void(alpha:Int)
			'Self.mPaint.setAlpha(alpha)
			
			''mCanvas.SetAlpha(Float(alpha) / 255.0)
		End
		
		Method getAlpha:Int()
			'Return Self.mPaint.getAlpha()
			
			Return (mCanvas.Alpha / 255)
		End
		
		Method setCanvas:Void(canvas:Canvas)
			Self.mCanvas = canvas
		End
		
		Method getCanvas:Canvas()
			Return Self.mCanvas
		End
		
		Method save:Void()
			'Print("SAVE")
			
			'Self.mCanvas.save()
			
			mCanvas.PushMatrix()
			
			#Rem
			Local color:= mCanvas.Color
			
			For Local i:= 0 Until NATIVE_COLOR_COUNT
				colors.Push(color[i])
			Next
			
			Local clip:= mCanvas.Scissor
			
			For Local i:= 0 Until NATIVE_CLIP_COUNT
				'Print("clip["+i+"]: " + clip[i])
				
				clipVec.Push(clip[i])
			Next
			#End
		End
		
		Method restore:Void()
			'Print("RESTORE")
			
			'Self.mCanvas.restore()
			
			#Rem
			Local a:= colors.Pop()
			Local b:= colors.Pop()
			Local g:= colors.Pop()
			Local r:= colors.Pop()
			
			mCanvas.SetColor(r, g, b, a)
			
			Local height:= clipVec.Pop()
			Local width:= clipVec.Pop()
			Local y:= clipVec.Pop()
			Local x:= clipVec.Pop()
			
			If (KeyDown(KEY_Z)) Then
				Print("scissor: " + x + ", " + y + " {" + width + ", " + height + "}")
			EndIf
			
			mCanvas.SetScissor(x, y, width, height)
			#End
			
			mCanvas.PopMatrix()
		End
	
		Method rotate:Void(degrees:Float)
			mCanvas.Rotate(degrees)
		End
		
		Method rotate:Void(degrees:Float, px:Float, py:Float)
			mCanvas.TranslateRotate(px, py, degrees)
		End
	
		Method scale:Void(sx:Float, sy:Float)
			mCanvas.Scale(sx, sy)
		End
		
		Method scale:Void(sx:Float, sy:Float, px:Float, py:Float)
			mCanvas.TranslateScale(px, py, sx, sy)
		End
		
		Method translate:Void(dx:Float, dy:Float)
			mCanvas.Translate(dx, dy)
		End
		
		Method setColor:Void(color:Int)
			'Self.mPaint.setColor(-16777216 | color)
			
			''mCanvas.SetColor(getRf(color), getGf(color), getBf(color))
		End
		
		Method setColor:Void(r:Int, g:Int, b:Int)
			'Self.mPaint.setColor(((r Shl TOP) + (g Shl RIGHT)) + b)
			
			''mCanvas.SetColor(colorToFloat(r), colorToFloat(g), colorToFloat(b))
		End
		
		Method fillRect:Void(x:Int, y:Int, w:Int, h:Int)
			mCanvas.DrawRect(Float(x), Float(y), Float(w), Float(h))
		End
		
		Method fillTriangle:Void(x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int)
			Local fx1:= Float(x1)
			Local fy1:= Float(y1)
			Local fx2:= Float(x2)
			Local fy2:= Float(y2)
			Local fx3:= Float(x3)
			Local fy3:= Float(y3)
			
			mCanvas.DrawLine(fx1, fy1, fx2, fy2) ' drawLine(..)
			mCanvas.DrawLine(fx2, fy2, fx3, fy3) ' drawLine(..)
			mCanvas.DrawLine(fx3, fy3, fx1, fy1) ' drawLine(..)
		End
		
		Method drawLine:Void(x1:Int, y1:Int, x2:Int, y2:Int)
			mCanvas.DrawLine(Float(x1), Float(y1), Float(x2), Float(y2))
		End
		
		Method setFont:Void(font:Font)
			Self.NativeFont = font
			
			'Self.mPaint.setTextSize((Float) font.getHeight())
			
			mCanvas.SetFont(font)
		End
		
		Method getFont:Font()
			Return Self.NativeFont
		End
		
		Method drawString:Void(str:String, x:Int, y:Int, anchor:Int)
			#Rem
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawText(str, (Float) x, (Float) (y - Self.NativeFont.getFontAscent()), Self.mPaint)
			EndIf
			#End
			
			If ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x -= Self.NativeFont.TextWidth(str) / 2 ' VCENTER
			ElseIf ((anchor & RIGHT) <> 0) Then
				x -= Self.NativeFont.TextWidth(str)
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				y -= FontHeight() / 2 ' VCENTER
			ElseIf ((anchor & BOTTOM) <> 0) Then
				y -= FontHeight()
			EndIf
			
			mCanvas.DrawText(str, Float(x), Float(y))
		End
		
		Method drawImage:Void(image:Image, x:Int, y:Int, anchor:Int)
			If ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x -= image.Width() / 2 ' VCENTER ' Width
			ElseIf ((anchor & RIGHT) <> 0) Then
				x -= image.Width() ' Width
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				y -= image.Height() / 2 ' VCENTER ' Height
			ElseIf ((anchor & BOTTOM) <> 0) Then
				y -= image.Height() ' Height
			EndIf
			
			mCanvas.DrawImage(image, Float(x), Float(y))
		End
		
		Method setClip:Void(x:Int, y:Int, w:Int, h:Int)
			''mCanvas.SetScissor(x, y, w, h)
			'mCanvas.SetScissor(x Shl 6, y Shl 6, w Shl 6, h Shl 6)
		End
		
		Method clipRect:Void(left:Int, top:Int, right:Int, bottom:Int)
			'setClip(left, top, right, bottom)
		End
		
		Method drawRGB:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int, processAlpha:Bool)
			'Self.mCanvas.drawBitmap(rgbData, offset, scanlength, x, y, width, height, processAlpha, Self.mPaint)
			
			' Unimplemented method.
			Print("[drawRGB]")
			
			DebugStop()
		End
		
		Method getColor:Int()
			'Return Self.mPaint.getColor()
			
			Return toColor(mCanvas.Color)
		End
		
		Method drawRect:Void(x:Int, y:Int, w:Int, h:Int)
			' This behavior may change in the future.
			'mCanvas.DrawRect(Float(x), Float(y), Float(w), Float(h))
			
			Local fx:= Float(x)
			Local fy:= Float(y)
			
			Local fw:= Float(w)
			Local fh:= Float(h)
			
			Local fullX:= (fx + fw)
			Local fullY:= (fy + fh)
			
			mCanvas.DrawLine(fx, fy, fullX, fy) ' drawLine(..)
			mCanvas.DrawLine(fx, fy, fx, fullY) ' drawLine(..)
			mCanvas.DrawLine(fullX, fy, fullX, fullY) ' drawLine(..)
			mCanvas.DrawLine(fx, fullY, fullX, fullY) ' drawLine(..)
		End
		
		Method drawArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int)
			#Rem
			Self.mPaint.setStyle(Style.STROKE)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawArc(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) startAngle, (Float) arcAngle, False, Self.mPaint)
			EndIf
			#End
			
			' Unimplemented method.
			Print("[drawArc]")
		End
	
		Method fillArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int)
			#Rem
			Self.mPaint.setStyle(Style.FILL)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawArc(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) startAngle, (Float) arcAngle, False, Self.mPaint)
			EndIf
			#End
			
			' Unimplemented method.
			Print("[fillArc]")
		End
	
		Method drawRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int)
			#Rem
			Self.mPaint.setStyle(Style.STROKE)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRoundRect(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) arcWidth, (Float) arcHeight, Self.mPaint)
			EndIf
			#End
			
			' This behavior may change in the future.
			drawRect(x, y, width, height)
		End
	
		Method fillRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int)
			#Rem
			Self.mPaint.setStyle(Style.FILL)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRoundRect(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) arcWidth, (Float) arcHeight, Self.mPaint)
			EndIf
			#End
			
			' This behavior may change in the future.
			fillRect(x, y, width, height)
		End
		
		Method drawRegion:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, transform:Int, x_dest:Int, y_dest:Int, anchor:Int)
			save()
			
			Local drawWidth:= width
			Local drawHeight:= height
			
			Local xOffset:= 0
			Local yOffset:= 0
			
			Select (transform)
				Case TRANS_NONE
					xOffset = -x_src
					yOffset = -y_src
				Case TRANS_MIRROR_ROT180
					mCanvas.Scale(-1.0, 1.0)
					mCanvas.Rotate(-180.0)
					
					xOffset = -x_src
					yOffset = drawHeight + y_src
				Case TRANS_MIRROR
					mCanvas.Scale(-1.0, 1.0)
					
					xOffset = drawWidth + x_src
					yOffset = -y_src
				Case TRANS_ROT180
					mCanvas.Rotate(180.0)
					
					xOffset = drawWidth + x_src
					yOffset = drawHeight + y_src
				Case TRANS_MIRROR_ROT270
					mCanvas.Scale(-1.0, 1.0)
					mCanvas.Rotate(-270.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = -y_src
					yOffset = -x_src
				Case TRANS_ROT90
					mCanvas.Rotate(90.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = drawWidth + y_src
					yOffset = -x_src
				Case TRANS_ROT270
					mCanvas.Rotate(270.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = -y_src
					yOffset = drawHeight + x_src
				Case TRANS_MIRROR_ROT90
					mCanvas.Scale(-1.0, 1.0)
					mCanvas.Rotate(-90.0)
					
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
				y_dest -= drawHeight Shr 1 ' >>> 1
			EndIf
			
			If ((anchor & RIGHT) <> 0) Then
				x_dest -= drawWidth
			ElseIf ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x_dest -= drawWidth Shr 1 ' >>> 1
			EndIf
			
			If (KeyDown(KEY_X)) Then
				DebugStop()
			EndIf
			
			mCanvas.Translate(Float(x_dest + xOffset), Float(y_dest + yOffset))
			
			mCanvas.DrawRect(0.0, 0.0, drawWidth, drawHeight, image, x_src, y_src, width, height)
			
			restore()
		End

		Method drawRegion:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, rotate_x:Int, rotate_y:Int, degree:Int, scale_x:Int, scale_y:Int, x_dest:Int, y_dest:Int, anchor:Int)
			Print("Unimplemented overload of 'drawRegion'.")
			
			DebugStop()
			
			Return
			
			save()
			
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
			
			mCanvas.DrawRect(0.0, 0.0, width, height, image)
			
			restore()
		End
End