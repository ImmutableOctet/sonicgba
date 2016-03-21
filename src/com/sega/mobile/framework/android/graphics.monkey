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
		Field mCanvas:Canvas
		Field mFont:Font
		Field mMatrix:Matrix
		Field mPaint:Paint
		Field mPath:Path
	Public
		' Functions:
		Function createBitmapGraphics:Graphics(bitmap:Bitmap)
			Local g:= New Graphics()
			
			g.mCanvas = New Canvas(bitmap)
			
			Return g
		End
		
		' Constructor(s):
		Method New()
			Self.mPath = New Path()
			Self.mPaint = New Paint()
			Self.mFont = Font.getFont(TRANS_NONE, TRANS_NONE, RIGHT) ' 0, 0, 8
			Self.mMatrix = New Matrix()
			
			Self.mPaint.setAntiAlias(True)
			Self.mPaint.setFilterBitmap(True)
			Self.mPaint.setTextSize(Float(Self.mFont.getHeight()))
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
		End
	
		Method getAlpha:Int()
			'Return Self.mPaint.getAlpha()
		End
		
		Method drawScreen:Void(img:Image, orgRect:Rect, targetRect:Rect)
			'Self.mCanvas.drawBitmap(img.getBitmap(), orgRect, targetRect, Self.mPaint)
		End
	
		Method setCanvas:Void(canvas:Canvas)
			Self.mCanvas = canvas
		End
	
		Method getCanvas:Canvas()
			Return Self.mCanvas
		End
	
		Method save:Void()
			'Self.mCanvas.save()
		End
	
		Method restore:Void()
			'Self.mCanvas.restore()
		End
	
		Method clipRect:Void(left:Int, top:Int, right:Int, bottom:Int)
			'Self.mCanvas.clipRect(left, top, right, bottom)
		End
	
		Method rotate:Void(degrees:Float)
			'Self.mCanvas.rotate(degrees)
		End
	
		Method rotate:Void(degrees:Float, px:Float, py:Float)
			'Self.mCanvas.rotate(degrees, px, py)
		End
	
		Method scale:Void(sx:Float, sy:Float)
			'Self.mCanvas.scale(sx, sy)
		End
	
		Method scale:Void(sx:Float, sy:Float, px:Float, py:Float)
			'Self.mCanvas.scale(sx, sy, px, py)
		End
	
		Method translate:Void(dx:Float, dy:Float)
			'Self.mCanvas.translate(dx, dy)
		End
	
		Method setColor:Void(color:Int)
			'Self.mPaint.setColor(-16777216 | color)
		End
	
		Method setColor:Void(r:Int, g:Int, b:Int)
			'Self.mPaint.setColor(((r Shl TOP) + (g Shl RIGHT)) + b)
		End

		Method fillRect:Void(x:Int, y:Int, w:Int, h:Int)
			#Rem
			Self.mPaint.setStyle(Style.FILL)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRect(Float(x), Float(y), Float(x + w), Float(y + h), Self.mPaint)
			EndIf
			#End
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
		End
		
		Method drawLine:Void(x1:Int, y1:Int, x2:Int, y2:Int)
			#Rem
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawLine((Float) x1, (Float) y1, (Float) x2, (Float) y2, Self.mPaint)
			EndIf
			#End
		End
		
		Method setFont:Void(font:Font)
			Self.mFont = font
			'Self.mPaint.setTextSize((Float) font.getHeight())
		End
		
		Method getFont:Font()
			Return Self.mFont
		End
		
		Method drawString:Void(str:String, x:Int, y:Int, anchor:Int)
			#Rem
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
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawText(str, (Float) x, (Float) (y - Self.mFont.getFontAscent()), Self.mPaint)
			EndIf
			#End
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
		End
		
		Method drawRGB:Void(rgbData:Int[], offset:Int, scanlength:Int, x:Int, y:Int, width:Int, height:Int, processAlpha:Bool)
			'Self.mCanvas.drawBitmap(rgbData, offset, scanlength, x, y, width, height, processAlpha, Self.mPaint)
		End
		
		Method getColor:Int()
			'Return Self.mPaint.getColor()
		End

		Method drawRect:Void(x:Int, y:Int, w:Int, h:Int)
			#Rem
			Self.mPaint.setStyle(Style.STROKE)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRect((Float) x, (Float) y, (Float) (x + w), (Float) (y + h), Self.mPaint)
			EndIf
			#End
		End
		
		Method drawArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int)
			#Rem
			Self.mPaint.setStyle(Style.STROKE)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawArc(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) startAngle, (Float) arcAngle, False, Self.mPaint)
			EndIf
			#End
		End
	
		Method fillArc:Void(x:Int, y:Int, width:Int, height:Int, startAngle:Int, arcAngle:Int)
			#Rem
			Self.mPaint.setStyle(Style.FILL)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawArc(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) startAngle, (Float) arcAngle, False, Self.mPaint)
			EndIf
			#End
		End
	
		Method drawRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int)
			#Rem
			Self.mPaint.setStyle(Style.STROKE)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRoundRect(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) arcWidth, (Float) arcHeight, Self.mPaint)
			EndIf
			#End
		End
	
		Method fillRoundRect:Void(x:Int, y:Int, width:Int, height:Int, arcWidth:Int, arcHeight:Int)
			#Rem
			Self.mPaint.setStyle(Style.FILL)
			
			If (Self.mCanvas <> Null) Then
				Self.mCanvas.drawRoundRect(New RectF((Float) x, (Float) y, (Float) (x + width), (Float) (y + height)), (Float) arcWidth, (Float) arcHeight, Self.mPaint)
			EndIf
			#End
		End
		
		Method drawRegion:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, transform:Int, x_dest:Int, y_dest:Int, anchor:Int)
			#Rem
			Self.mMatrix.reset()
			
			Local drawWidth:= width
			Local drawHeight:= height
			
			Local xOffset:= TRANS_NONE
			Local yOffset:= TRANS_NONE
			
			Select (transform)
				Case TRANS_NONE
					xOffset = -x_src
					yOffset = -y_src
				Case TRANS_MIRROR_ROT180
					Self.mMatrix.preScale(-1.0, 1.0)
					Self.mMatrix.preRotate(-180.0)
					
					xOffset = -x_src
					yOffset = drawHeight + y_src
				Case TRANS_MIRROR
					Self.mMatrix.preScale(-1.0, 1.0)
					
					xOffset = drawWidth + x_src
					yOffset = -y_src
				Case TRANS_ROT180
					Self.mMatrix.preRotate(180.0)
					
					xOffset = drawWidth + x_src
					yOffset = drawHeight + y_src
				Case TRANS_MIRROR_ROT270
					Self.mMatrix.preScale(-1.0, 1.0)
					Self.mMatrix.preRotate(-270.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = -y_src
					yOffset = -x_src
				Case TRANS_ROT90
					Self.mMatrix.preRotate(90.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = drawWidth + y_src
					yOffset = -x_src
				Case TRANS_ROT270
					Self.mMatrix.preRotate(270.0)
					
					drawWidth = height
					drawHeight = width
					
					xOffset = -y_src
					yOffset = drawHeight + x_src
				Case TRANS_MIRROR_ROT90
					Self.mMatrix.preScale(-1.0, 1.0)
					Self.mMatrix.preRotate(-90.0)
					
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
				x_dest -= drawWidth >>> TRANS_MIRROR_ROT180
			EndIf
			
			Self.mCanvas.save()
			
			Self.mCanvas.clipRect(x_dest, y_dest, x_dest + drawWidth, y_dest + drawHeight)
			Self.mCanvas.translate((Float) (x_dest + xOffset), (Float) (y_dest + yOffset))
			
			Local alpha:= Self.mPaint.getAlpha()
			
			If (image.getAlpha() <> -1) Then
				Self.mPaint.setAlpha(image.getAlpha())
			EndIf
			
			Self.mCanvas.drawBitmap(image.getBitmap(), Self.mMatrix, Self.mPaint)
			Self.mPaint.setAlpha(alpha)
			
			Self.mCanvas.restore()
			#End
		End

		Method drawRegion:Void(image:Image, x_src:Int, y_src:Int, width:Int, height:Int, rotate_x:Int, rotate_y:Int, degree:Int, scale_x:Int, scale_y:Int, x_dest:Int, y_dest:Int, anchor:Int)
			#Rem
			Self.mMatrix.reset()
			
			Self.mCanvas.save()
			
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
			
			Self.mCanvas.translate((Float) (x_dest - x_src), (Float) (y_dest - y_src))
			Self.mCanvas.rotate((Float) degree, (Float) (rotate_x + x_src), (Float) (rotate_y + y_src))
			Self.mCanvas.scale((Float) scale_x, (Float) scale_y, (Float) ((width / VCENTER) + x_src), (Float) ((height / VCENTER) + y_src))
			Self.mCanvas.clipRect(x_src, y_src, x_src + width, y_src + height)
			
			Local alpha:= Self.mPaint.getAlpha()
			
			If (image.getAlpha() <> -1) Then
				Self.mPaint.setAlpha(image.getAlpha())
			EndIf
			
			Self.mCanvas.drawBitmap(image.getBitmap(), Self.mMatrix, Self.mPaint)
			Self.mPaint.setAlpha(alpha)
			
			Self.mCanvas.restore()
			#End
		End
End