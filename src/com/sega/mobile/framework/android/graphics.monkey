Strict

Public

' Imports:
Private
	#Rem
		Import android.graphics.bitmap
		Import android.graphics.canvas
		Import android.graphics.matrix
		Import android.graphics.paint
		Import android.graphics.paint.style
		Import android.graphics.path
		Import android.graphics.rect
		Import android.graphics.rectf
		Import android.graphics.region.op
	#End
	
	Import regal.typetool
	'Import regal.matrix2d
	
	Import mojo2.graphics
Public

' Interfaces:
Interface GRAPHICS_MACROS
	' Constant variable(s):
	Const HCENTER:Int = 1
	Const LEFT:Int = 4
	Const RIGHT:Int = 8
	Const TOP:Int = 16
	Const BOTTOM:Int = 32
	
	Const VCENTER:Int = 2
	
	Const TRANS_NONE:Int = 0
	Const TRANS_MIRROR_ROT180:Int = 1
	Const TRANS_MIRROR:Int = 2
	Const TRANS_ROT180:Int = 3
	Const TRANS_MIRROR_ROT270:Int = 4
	Const TRANS_ROT90:Int = 5
	Const TRANS_ROT270:Int = 6
	Const TRANS_MIRROR_ROT90:Int = 7
End

' Classes:
Class Graphics Implements GRAPHICS_MACROS
	Private
		' Fields:
		Field mCanvas:Canvas ' DrawList
		'Field mFont:Font
		'Field mMatrix:Matrix2D
		'Field mPaint:Paint
		'Field mPath:Path
		
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
				Self.mFont = Font.getFont(TRANS_NONE, TRANS_NONE, RIGHT) ' 0, 0, 8
				
				Self.mPaint.setAntiAlias(True)
				Self.mPaint.setFilterBitmap(True)
				Self.mPaint.setTextSize(Float(Self.mFont.getHeight()))
			#End
		End
		
		' Methods:
		Method setFilterBitmap:Void(b:Bool)
			'Self.mPaint.setFilterBitmap(b)
		End
	
		Method setAntiAlias:Void(b:Bool)
			'Self.mPaint.setAntiAlias(b)
		End
		
		Method setAlpha:Void(alpha:Int)
			'Self.mPaint.setAlpha(alpha)
			
			mCanvas.SetAlpha(alpha / 255)
		End
	
		Method getAlpha:Int()
			'Return Self.mPaint.getAlpha()
			
			Return (mCanvas.Alpha / 255)
		End
		
		Method drawScreen:Void(img:Image, orgRect:Rect, targetRect:Rect)
			'Self.mCanvas.drawBitmap(img.getBitmap(), orgRect, targetRect, Self.mPaint)
			
			Local x:= targetRect.left
			Local y:= targetRect.top
			
			Local width:= targetRect.right
			Local height:= targetRect.bottom
			
			If (orgRect <> Null) Then
				mCanvas.DrawRect(x, y, width, height, img, orgRect.left, orgRect.top, orgRect.right, orgRect.bottom)
			Else
				mCanvas.DrawRect(x, y, width, height, img)
			EndIf
		End
	
		Method setCanvas:Void(canvas:Canvas)
			Self.mCanvas = canvas
		End
	
		Method getCanvas:Canvas()
			Return Self.mCanvas
		End
	
		Method save:Void()
			'Self.mCanvas.save()
			
			mCanvas.PushMatrix()
		End
	
		Method restore:Void()
			'Self.mCanvas.restore()
			
			mCanvas.PopMatrix()
		End
	
		Method clipRect:Void(left:Int, top:Int, right:Int, bottom:Int)
			'Self.mCanvas.clipRect(left, top, right, bottom)
			
			mCanvas.SetScissor(left, top, right, bottom)
		End
	
		Method rotate:Void(degrees:Float)
			'Self.mCanvas.rotate(degrees)
			
			mCanvas.Rotate(degrees)
		End
	
		Method rotate:Void(degrees:Float, px:Float, py:Float)
			'Self.mCanvas.rotate(degrees, px, py)
			
			mCanvas.TranslateRotate(px, py, degrees)
		End
	
		Method scale:Void(sx:Float, sy:Float)
			'Self.mCanvas.scale(sx, sy)
			
			mCanvas.Scale(sx, sy)
		End
		
		Method scale:Void(sx:Float, sy:Float, px:Float, py:Float)
			'Self.mCanvas.scale(sx, sy, px, py)
			
			mCanvas.TranslateScale(px, py, sx, sy)
		End
		
		Method translate:Void(dx:Float, dy:Float)
			'Self.mCanvas.translate(dx, dy)
			
			mCanvas.Translate(dx, dy)
		End
		
		Method setColor:Void(color:Int)
			'Self.mPaint.setColor(-16777216 | color)
			
			mCanvas.SetColor(getRf(color), getGf(color), getBf(color))
		End
		
		Method setColor:Void(r:Int, g:Int, b:Int)
			'Self.mPaint.setColor(((r Shl TOP) + (g Shl RIGHT)) + b)
			
			mCanvas.SetColor(colorToFloat(r), colorToFloat(g), colorToFloat(b))
		End
		
		Method fillRect:Void(x:Int, y:Int, w:Int, h:Int)
			#Rem
			Self.mPaint.setStyle(Style.FILL)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRect(Float(x), Float(y), Float(x + w), Float(y + h), Self.mPaint)
			EndIf
			#End
			
			mCanvas.DrawRect(Float(x), Float(y), Float(w), Float(h))
		End
		
		Method fillTriangle:Void(x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int)
			#Rem
			Self.mPath.reset()
			Self.mPath.moveTo((Float) x3, (Float) y3)
			Self.mPath.lineTo((Float) x1, (Float) y1)
			Self.mPath.lineTo((Float) x2, (Float) y2)
			Self.mPath.lineTo((Float) x3, (Float) y3)
			Self.mPaint.setStyle(Style.FILL)
			Self.mCanvas.drawPath(Self.mPath, Self.mPaint)
			#End
			
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
			#Rem
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawLine((Float) x1, (Float) y1, (Float) x2, (Float) y2, Self.mPaint)
			EndIf
			#End
			
			mCanvas.DrawLine(Float(x1), Float(y1), Float(x2), Float(y2))
		End
		
		Method setFont:Void(font:Font)
			'Self.mFont = font
			
			'Self.mPaint.setTextSize((Float) font.getHeight())
			
			mCanvas.SetFont(font)
		End
		
		Method getFont:Font()
			'Return Self.mFont
			
			Return mCanvas.Font
		End
		
		Method drawString:Void(str:String, x:Int, y:Int, anchor:Int)
			#Rem
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawText(str, (Float) x, (Float) (y - Self.mFont.getFontAscent()), Self.mPaint)
			EndIf
			#End
			
			If ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x -= Self.mFont.stringWidth(str) / 2 ' VCENTER
			ElseIf ((anchor & RIGHT) <> 0) Then
				x -= Self.mFont.stringWidth(str)
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				y -= Self.mFont.getHeight() / 2 ' VCENTER
			ElseIf ((anchor & BOTTOM) <> 0) Then
				y -= Self.mFont.getHeight()
			EndIf
			
			mCanvas.DrawText(str, Float(x), Float(y))
		End
		
		Method drawImage:Void(image:Image, x:Int, y:Int, anchor:Int)
			If ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x -= image.getWidth() / 2 ' VCENTER
			ElseIf ((anchor & RIGHT) <> 0) Then
				x -= image.getWidth()
			EndIf
			
			If ((anchor & VCENTER) <> 0) Then
				y -= image.getHeight() / 2 ' VCENTER
			ElseIf ((anchor & BOTTOM) <> 0) Then
				y -= image.getHeight()
			EndIf
			
			'Local alpha:= mCanvas.Alpha
			
			#Rem
			Local ia:= image.getAlpha()
			
			If (ia <> -1) Then
				setAlpha(ia)
			EndIf
			#End
			
			mCanvas.DrawImage(image, Float(x), Float(y))
			
			'mCanvas.SetAlpha(alpha)
			
			#Rem
			If (Self.mCanvas <> Null) Then
				Local alpha:= Self.mPaint.getAlpha()
				
				If (image.getAlpha() <> -1) Then
					Self.mPaint.setAlpha(image.getAlpha())
				EndIf
				
				Self.mCanvas.drawBitmap(image.getBitmap(), (Float) x, (Float) y, Self.mPaint)
				Self.mPaint.setAlpha(alpha)
			EndIf
			#End
		End
		
		Method setClip:Void(x:Int, y:Int, w:Int, h:Int)
			#Rem
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.clipRect((Float) x, (Float) y, (Float) (x + w), (Float) (y + h), Op.REPLACE)
			EndIf
			#End
			
			clipRect(x, y, w, h)
		End
		
		Method drawRGB:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int, processAlpha:Bool)
			'Self.mCanvas.drawBitmap(rgbData, offset, scanlength, x, y, width, height, processAlpha, Self.mPaint)
			
			' Unimplemented method.
		End
		
		Method getColor:Int()
			'Return Self.mPaint.getColor()
			
			Return toColor(mCanvas.Color)
		End

		Method drawRect:Void(x:Int, y:Int, w:Int, h:Int)
			#Rem
			Self.mPaint.setStyle(Style.STROKE)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRect((Float) x, (Float) y, (Float) (x + w), (Float) (y + h), Self.mPaint)
			EndIf
			#End
			
			' This behavior may change in the future.
			mCanvas.DrawRect(Float(x), Float(y), Float(w), Float(h))
		End
		
		Method drawArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int)
			#Rem
			Self.mPaint.setStyle(Style.STROKE)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawArc(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) startAngle, (Float) arcAngle, False, Self.mPaint)
			EndIf
			#End
			
			' Unimplemented method.
		End
	
		Method fillArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int)
			#Rem
			Self.mPaint.setStyle(Style.FILL)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawArc(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) startAngle, (Float) arcAngle, False, Self.mPaint)
			EndIf
			#End
			
			' Unimplemented method.
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
			drawRect(x, y, width, height)
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
			
			#Rem
			Self.mCanvas.clipRect(x_dest, y_dest, x_dest + drawWidth, y_dest + drawHeight)
			Self.mCanvas.translate((Float) (x_dest + xOffset), (Float) (y_dest + yOffset))
			
			Local alpha:= Self.mPaint.getAlpha()
			
			If (image.getAlpha() <> -1) Then
				Self.mPaint.setAlpha(image.getAlpha())
			EndIf
			
			Self.mCanvas.drawBitmap(image.getBitmap(), Self.mMatrix, Self.mPaint)
			Self.mPaint.setAlpha(alpha)
			#End
			
			mCanvas.DrawRect(Float(x_dest + xOffset), Float(y_dest + yOffset), width, height, image)
			
			restore()
		End

		Method drawRegion:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, rotate_x:Int, rotate_y:Int, degree:Int, scale_x:Int, scale_y:Int, x_dest:Int, y_dest:Int, anchor:Int)
			save()
			
			If ((anchor & BOTTOM) <> 0) Then
				y_dest -= height
			ElseIf ((anchor & VCENTER) <> 0) Then
				y_dest -= height Shr 1
			EndIf
			
			If ((anchor & RIGHT) <> 0) Then
				x_dest -= width
			ElseIf ((anchor & TRANS_MIRROR_ROT180) <> 0) Then
				x_dest -= width Shr 1
			EndIf
			
			#Rem
			Self.mCanvas.translate((Float) (x_dest - x_src), (Float) (y_dest - y_src))
			Self.mCanvas.rotate((Float) degree, (Float) (rotate_x + x_src), (Float) (rotate_y + y_src))
			Self.mCanvas.scale((Float) scale_x, (Float) scale_y, (Float) ((width / VCENTER) + x_src), (Float) ((height / VCENTER) + y_src))
			Self.mCanvas.clipRect(x_src, y_src, x_src + width, y_src + height)
			#End
			
			translate((x_dest - x_src), (y_dest - y_src))
			rotate(degree, (rotate_x + x_src), (rotate_y + y_src))
			scale(Float(scale_x), Float(scale_y), Float((width / 2) + x_src), Float((height / 2) + y_src))
			'clipRect(x_src, y_src, x_src + width, y_src + height)
			
			#Rem
			Local alpha:= Self.mPaint.getAlpha()
			
			If (image.getAlpha() <> -1) Then
				Self.mPaint.setAlpha(image.getAlpha())
			EndIf
			
			Self.mCanvas.drawBitmap(image.getBitmap(), Self.mMatrix, Self.mPaint)
			Self.mPaint.setAlpha(alpha)
			#End
			
			mCanvas.DrawRect(0.0, 0.0, width, height, image)
			
			restore()
		End
End