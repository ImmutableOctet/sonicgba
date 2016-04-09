Strict

Public

' Imports:
Private
	Import lib.def
	Import lib.bitmapfont
	Import lib.coordinate
	Import lib.animationdrawer
	
	Import sonicgba.globalresource
	
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import brl.stream
	
	Import monkey.stack
	
	Import regal.typetool
Public

' Classes:
Class MyAPI Implements Def
	Private
		' Constant variable(s):
		Const ROTATE_90:Int = 1
		Const FLIP_X:Int = 2
		Const FLIP_Y:Int = 4
		
		Const PAGE_WAIT:Int = 5
		
		Const RAY_HEIGHT:Int = 3
		Const RAY_WIDTH:Int = 288
		
		Global ARROW:Int[] = [1, 3, 5, 7, 7] ' Const
		Global GRAY_PALETTE_PARAM:Int[] = [16711935, 15263976, 15263976, 14211288] ' Const
		Global GREEN_PALETTE_PARAM:Int[] = [16777215, 776448, 65280, 0] ' Const
		Global OFFSET:Int[][] = [[-1, 0], [0, 1], [1, 0], [0, -1]] ' Const
		Global OFFSET2:Int[][] = [[-1, 0], [0, 1], [1, 0], [0, -1], [-1, 1], [1, 1], [1, -1], [-1, -1]] ' Const
		
		Global Symbol_CH:String = "~u3002~uff0c~uff01:~uff1b" ' [$3002, $ff0c, $ff01, $003a, $ff1b] ' Char[] ' Const
		Global Symbol_EN:String = ".,!:;" ' Char[] ' Const
		Global Symbol:String = Symbol_CH ' Symbol_EN ' Char[] ' Const
		
		Global TRANMODIF:Short[] = [0, 90, 8192, 16474, 16384, 16654, 180, 270] ' Const
		Global TRANMODIF_2:Byte[] = [0, 4, 2, 6, 3, 7, 1, 5] ' Const
		Global YELLOW_PALETTE_PARAM:Int[] = [16777215, 16763904, 16776960, 0] ' Const
		
		' Global variable(s):
		Global currentBmFont:BitmapFont
		
		' This may be removed at a later date.
		Global rayRGB:Int[] = New Int[RAY_WIDTH*RAY_HEIGHT]
	Public
		' Constant variable(s):
		Const BMF_COLOR_GRAY:Int = 3
		Const BMF_COLOR_GREEN:Int = 2
		Const BMF_COLOR_WHITE:Int = 0
		Const BMF_COLOR_YELLOW:Int = 1
		Const FIXED_TWO_BASE:Int = 7
		Const ZOOM_OUT_MOVE:Int = 0
		
		Const NOKIA_DRAW:Bool = False
		Const RGB_DRAW:Bool = False
		
		Global sinData2:Int[] = [0, 224, 446, 669, 893, 1116, 1337, 1560, 1781, 2001, 2222, 2442, 2661, 2878, 3096, 3312, 3527, 3742, 3955, 4167, 4377, 4587, 4794, 5000, 5205, 5409, 5611, 5811, 6009, 6205, 6400, 6592, 6782, 6970, 7157, 7342, 7523, 7703, 7879, 8055, 8227, 8396, 8564, 8729, 8890, 9050, 9207, 9360, 9511, 9660, 9804, 9946, 10086, 10222, 10355, 10484, 10611, 10735, 10854, 10972, 11084, 11194, 11301, 11404, 11504, 11600, 11692, 11782, 11868, 11950, 12028, 12102, 12172, 12240, 12304, 12363, 12419, 12472, 12519, 12564, 12605, 12642, 12675, 12704, 12729, 12751, 12769, 12782, 12792, 12797, 12800] ' Const
		
		' Global variable(s):
		Global anchor:String
		Global backColor:Int = BMF_COLOR_WHITE
		Global bmFont:BitmapFont
		Global bmFontGray:BitmapFont
		Global bmFontGreen:BitmapFont
		Global bmFontYellow:BitmapFont
		Global borderColor:Int = BMF_COLOR_WHITE
		Global downPermit:Bool
		Global scrollPageWait:Int
		Global stringCursol:Int = 0
		Global upPermit:Bool
	Private
		' Functions:
		Function drawRegionPrivate:Void(g2:MFGraphics, img:MFImage, sx:Int, sy:Int, sw:Int, sh:Int, trans:Int, dx:Int, dy:Int, anchor:Int)
			g2.drawRegion(img, sx, sy, sw, sh, trans, dx, dy, anchor)
		End
		
		Function getRoteCoordinate:Coordinate(x:Int, y:Int, trans:Int)
			Select (trans)
				Case (ROTATE_90|FLIP_X)
					Return Coordinate.returnCoordinate(-x, -y)
				Case (ROTATE_90|FLIP_Y)
					Return Coordinate.returnCoordinate(y, -x)
				Case (FLIP_X|FLIP_Y)
					Return Coordinate.returnCoordinate(-y, x)
				Default
					Return Coordinate.returnCoordinate(x, y)
			End Select
		End
	Public
		' Functions:		
		Function drawRegion:Void(g2:MFGraphics, img:MFImage, sx:Int, sy:Int, sw:Int, sh:Int, trans:Int, dx:Int, dy:Int, anchor:Int)
			drawImage(g2, img, sx, sy, sw, sh, trans, dx, dy, anchor)
		End
		
		Function drawImage:Void(g2:MFGraphics, img:MFImage, sx:Int, sy:Int, sw:Int, sh:Int, trans:Int, dx:Int, dy:Int, anchor:Int)
			drawRegionPrivate(g2, img, zoomOut(sx), zoomOut(sy), zoomOut(sw), zoomOut(sh), trans, zoomOut(dx), zoomOut(dy), anchor)
		End
		
		Function drawImageWithoutZoom:Void(g2:MFGraphics, img:MFImage, sx:Int, sy:Int, sw:Int, sh:Int, trans:Int, dx:Int, dy:Int, anchor:Int)
			drawRegionPrivate(g2, img, sx, sy, sw, sh, trans, dx, dy, anchor)
		End
		
		Function drawImageWithoutZoom:Void(g2:MFGraphics, img:MFImage, x:Int, y:Int, anchor:Int)
			g2.drawImage(img, x, y, anchor)
		End
		
		Function drawImage:Void(g2:MFGraphics, img:MFImage, x:Int, y:Int, anchor:Int)
			g2.drawImage(img, zoomOut(x), zoomOut(y), anchor)
		End
		
		Function getStringToDraw:String(str:String)
			Local stringToDraw:String = ""
			
			Local startPos:= str.indexOf("<")
			Local endPos:= str.indexOf(">")
			
			If (startPos = -1 Or endPos = -1) Then
				Return str
			EndIf
			
			anchor = str[(startPos + 2)..endPos]
			
			Return str[(endPos + 1)..]
		End
		
		Function fillRectBold:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int)
			g2.setColor(backColor)
			
			g2.fillRect(x, y, w, h)
			
			g2.setColor(borderColor)
			
			g2.drawRect(x, y, w, h)
			g2.drawRect(x - 1, y - 1, w + 2, h + 2)
		End
		
		Function fillRoundRectBold:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int, color1:Int, color2:Int)
			x = zoomOut(x)
			y = zoomOut(y)
			w = zoomOut(w)
			h = zoomOut(h)
			
			g2.setColor(color1)
			
			g2.fillRoundRect(x, y, w, h, 10, 10)
			
			g2.setColor(color2)
			
			g2.drawRoundRect(x, y, w - 1, h, 10, 10)
		End
		
		Function drawRectBold:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int)
			g2.setColor(backColor)
			
			g2.drawRect(x, y, w, h)
			g2.drawRect(x - 1, y - 1, w + 2, h + 2)
			g2.drawRect(x + 1, y + 1, w - 2, h - 2)
			
			g2.setColor(borderColor)
			
			g2.drawRect(x - 2, y - 2, w + 4, h + 4)
			g2.drawRect(x + 2, y + 2, w - 4, h - 4)
		End
		
		Function drawRect:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int)
			g2.drawRect(zoomOut(x), zoomOut(y), zoomOut(w), zoomOut(h))
		End
		
		Function fillRect:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int)
			g2.fillRect(zoomOut(x), zoomOut(y), zoomOut(w), zoomOut(h))
		End
		
		Function drawString:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int)
			g2.drawString(a, zoomOut(x), zoomOut(y), anchor)
		End
		
		Function drawSubstring:Void(g2:MFGraphics, a:String, start:Int, end:Int, x:Int, y:Int, anchor:Int)
			x = zoomOut(x)
			y = zoomOut(y)
		End
		
		Function fillArc:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int, start:Int, thita:Int)
			g2.fillArc(zoomOut(x), zoomOut(y), zoomOut(w), zoomOut(h), start, thita)
		End
		
		Function drawArc:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int, start:Int, thita:Int)
			g2.fillArc(zoomOut(x), zoomOut(y), zoomOut(w), zoomOut(h), start, thita)
		End
		
		Function setClip:Void(g2:MFGraphics, x:Int, y:Int, w:Int, h:Int)
			g2.setClip(zoomOut(x), zoomOut(y), zoomOut(w), zoomOut(h))
		End
		
		Function drawLine:Void(g2:MFGraphics, x:Int, y:Int, x2:Int, y2:Int)
			g2.drawLine(zoomOut(x), zoomOut(y), zoomOut(x2), zoomOut(y2))
		End
		
		Function setBackColor:Void(color:Int)
			backColor = color
		End
		
		Function setBorderColor:Void(color:Int)
			borderColor = color
		End
		
		Function drawSelectBox:Void(g2:MFGraphics, selector:Object[], x:Int, y:Int, w:Int, maxLine:Int, cursol:Int)
			fillRectBold(g2, x, y, w, (LINE_SPACE * maxLine))
			
			If (selector.Length = 0) Then
				g2.drawString("No options.", x + (w / 2), y + ((LINE_SPACE * maxLine) / 2), 17) ' "~u65e0~u53ef~u9009~u9879"
			ElseIf (selector.Length <= maxLine) Then
				For Local w:= 0 Until selector.Length
					If (cursol = w) Then
						g2.setColor(16711680)
					Else
						g2.setColor(16777215)
					EndIf
					
					g2.drawString(selector[w].toString(), x + 8, (LINE_SPACE * w) + y, 20)
				Next
			Else
				Local scrollBarHeight:= (((LINE_SPACE * maxLine) * maxLine) / selector.Length)
				
				Local startFrom:Int
				
				If (cursol < maxLine / 2) Then
					startFrom = 0
				ElseIf (((maxLine / 2) + cursol) < selector.Length) Then
					startFrom = (cursol - (maxLine / 2))
				Else
					startFrom = (selector.Length - maxLine)
				EndIf
				
				For Local i:= 0 Until maxLine
					If (cursol = (i + startFrom)) Then
						g2.setColor(16711680)
					Else
						g2.setColor(16777215)
					EndIf
					
					g2.drawString(selector[i + startFrom].toString(), x + 8, (LINE_SPACE * i) + y, 20)
				Next
				
				g2.setColor(16777215)
				g2.fillRect(w - 8, y, 8, LINE_SPACE * maxLine)
				
				g2.setColor(8421504)
				g2.fillRect(w - FIXED_TWO_BASE, (((LINE_SPACE * maxLine) * startFrom) / selector.Length) + y, 6, scrollBarHeight)
				
				g2.setColor(16777215)
				g2.drawRect(w - 8, y, FIXED_TWO_BASE, (LINE_SPACE * maxLine) - 1)
			EndIf
		End
		
		Public Function getStrings:String[](s:String, lineLength:Int)
			lineLength = zoomOut(lineLength)
			
			If (lineLength > 8) Then
				lineLength -= 8
			EndIf
			
			Vector strings = New Vector()
			String answerWord = ""
			Bool function = RGB_DRAW
			Int currentPosition = 0
			Int endOfCurrentWord = 0
			Int ConcealEnterPosition = 0
			Int startOfLine = 0
			Bool isSpace = RGB_DRAW
			While (endOfCurrentWord >= 0 And endOfCurrentWord < s.Length()) {
				endOfCurrentWord += 1
				String nextWord = s.substring(currentPosition, endOfCurrentWord)
				
				If (nextWord.equals("~")) Then
					ConcealEnterPosition = currentPosition - startOfLine
					isSpace = RGB_DRAW
				ElseIf (nextWord.equals("|") Or nextWord.equals("\n")) Then
					ConcealEnterPosition = 0
					Int startOfLine2 = endOfCurrentWord
					strings.addElement(answerWord)
					answerWord = ""
					startOfLine = startOfLine2
					function = RGB_DRAW
				Else
					answerWord = New StringBuilder(String.valueOf(answerWord)).append(nextWord).toString()
					
					If (nextWord.equals("<")) Then
						function = True
						currentPosition = endOfCurrentWord
					Else
						currentPosition = 0
						While (currentPosition < Symbol.Length) {
							
							If (nextWord.charAt(BMF_COLOR_WHITE) = Symbol[currentPosition]) Then
								currentPosition = endOfCurrentWord
								
								If (endOfCurrentWord = s.Length()) Then
									strings.addElement(answerWord)
								EndIf
								
							Else
								currentPosition += 1
							EndIf
							
						}
					EndIf
				EndIf
				
				currentPosition = getStringWidth(14, answerWord)
				
				If (function) Then
					currentPosition -= getStringWidth(14, "<H>")
				EndIf
				
				If (currentPosition >= lineLength And endOfCurrentWord < s.Length()) Then
					If (ConcealEnterPosition = 0) Then
						try {
							strings.addElement(answerWord.substring(BMF_COLOR_WHITE, answerWord.Length() - 1))
							answerWord = answerWord.substring(answerWord.Length() - 1)
							startOfLine2 = endOfCurrentWord - 1
						} catch (Exception e) {
							SystemOut("answerWord" + answerWord)
							startOfLine2 = startOfLine
						}
					Else
						try {
							strings.addElement(answerWord.substring(BMF_COLOR_WHITE, ConcealEnterPosition))
							answerWord = answerWord.substring((isSpace ? ROTATE_90 : BMF_COLOR_WHITE) + ConcealEnterPosition)
							currentPosition = (ConcealEnterPosition + (isSpace ? ROTATE_90 : BMF_COLOR_WHITE)) + startOfLine
						} catch (Exception e2) {
							SystemOut("answerWord" + answerWord)
							SystemOut("ConcealEnterPosition" + ConcealEnterPosition)
							currentPosition = startOfLine
						}
						ConcealEnterPosition = 0
						startOfLine2 = currentPosition
					EndIf
					
					startOfLine = startOfLine2
					function = RGB_DRAW
				ElseIf (endOfCurrentWord = s.Length()) Then
					strings.addElement(answerWord)
				EndIf
				
				currentPosition = endOfCurrentWord
			EndIf
			s = New String[strings.size()]
			strings.copyInto(s)
			Return s
		}
		
		Public Function getStrings:String[](s:String, fontid:Int, lineLength:Int)
			lineLength = zoomOut(lineLength)
			
			If (lineLength > 8) Then
				lineLength -= 8
			EndIf
			
			Vector strings = New Vector()
			String answerWord = ""
			Bool function = RGB_DRAW
			Int currentPosition = 0
			Int endOfCurrentWord = 0
			Int ConcealEnterPosition = 0
			Int startOfLine = 0
			Bool isSpace = RGB_DRAW
			While (endOfCurrentWord >= 0 And endOfCurrentWord < s.Length()) {
				endOfCurrentWord += 1
				String nextWord = s.substring(currentPosition, endOfCurrentWord)
				
				If (nextWord.equals("~")) Then
					ConcealEnterPosition = currentPosition - startOfLine
					isSpace = RGB_DRAW
				ElseIf (nextWord.equals("|") Or nextWord.equals("\n")) Then
					ConcealEnterPosition = 0
					Int startOfLine2 = endOfCurrentWord
					strings.addElement(answerWord)
					answerWord = ""
					startOfLine = startOfLine2
					function = RGB_DRAW
				Else
					answerWord = New StringBuilder(String.valueOf(answerWord)).append(nextWord).toString()
					
					If (nextWord.equals("<")) Then
						function = True
						currentPosition = endOfCurrentWord
					Else
						currentPosition = 0
						While (currentPosition < Symbol.Length) {
							
							If (nextWord.charAt(BMF_COLOR_WHITE) = Symbol[currentPosition]) Then
								currentPosition = endOfCurrentWord
								
								If (endOfCurrentWord = s.Length()) Then
									strings.addElement(answerWord)
								EndIf
								
							Else
								currentPosition += 1
							EndIf
							
						}
					EndIf
				EndIf
				
				currentPosition = getStringWidth(fontid, answerWord)
				
				If (function) Then
					currentPosition -= getStringWidth(fontid, "<H>")
				EndIf
				
				If (currentPosition >= lineLength And endOfCurrentWord < s.Length()) Then
					If (ConcealEnterPosition = 0) Then
						try {
							strings.addElement(answerWord.substring(BMF_COLOR_WHITE, answerWord.Length() - 1))
							answerWord = answerWord.substring(answerWord.Length() - 1)
							startOfLine2 = endOfCurrentWord - 1
						} catch (Exception e) {
							SystemOut("answerWord" + answerWord)
							startOfLine2 = startOfLine
						}
					Else
						try {
							strings.addElement(answerWord.substring(BMF_COLOR_WHITE, ConcealEnterPosition))
							answerWord = answerWord.substring((isSpace ? ROTATE_90 : BMF_COLOR_WHITE) + ConcealEnterPosition)
							currentPosition = (ConcealEnterPosition + (isSpace ? ROTATE_90 : BMF_COLOR_WHITE)) + startOfLine
						} catch (Exception e2) {
							SystemOut("answerWord" + answerWord)
							SystemOut("ConcealEnterPosition" + ConcealEnterPosition)
							currentPosition = startOfLine
						}
						ConcealEnterPosition = 0
						startOfLine2 = currentPosition
					EndIf
					
					startOfLine = startOfLine2
					function = RGB_DRAW
				ElseIf (endOfCurrentWord = s.Length()) Then
					strings.addElement(answerWord)
				EndIf
				
				currentPosition = endOfCurrentWord
			EndIf
			s = New String[strings.size()]
			strings.copyInto(s)
			Return s
		}
		
		Public Function getEnStrings:String[](s:String, lineLength:Int)
			Vector strings = New Vector()
			String answerWord = ""
			Int currentPosition = 0
			Int endOfCurrentWord = 0
			Int startOfLine = 0
			While (endOfCurrentWord >= 0 And endOfCurrentWord < s.Length()) {
				endOfCurrentWord += 1
				String nextWord = s.substring(currentPosition, endOfCurrentWord)
				
				If (nextWord.equals("~") Or nextWord.equals(" ")) Then
					Int ConcealEnterPosition = currentPosition - startOfLine
				ElseIf (nextWord.equals("|") Or nextWord.equals("\n")) Then
					startOfLine = endOfCurrentWord
					strings.addElement(answerWord)
					answerWord = ""
				Else
					answerWord = New StringBuilder(String.valueOf(answerWord)).append(nextWord).toString()
					
					If (Not nextWord.equals("<")) Then
						Int i = 0
						While (i < Symbol.Length) {
							
							If (nextWord.charAt(BMF_COLOR_WHITE) = Symbol[i]) Then
								currentPosition = endOfCurrentWord
								
								If (endOfCurrentWord = s.Length()) Then
									strings.addElement(answerWord)
								EndIf
								
							Else
								i += 1
							EndIf
							
						}
					EndIf
				EndIf
			EndIf
			String[] stringsToDraw = New String[strings.size()]
			strings.copyInto(stringsToDraw)
			Return stringsToDraw
		}
		
		Public Function getStringWidth:Int(fontID:Int, answerWord:String)
			Return MFGraphics.stringWidth(fontID, answerWord)
		}
		
		Public Function getArray:Object[](vec:Vector)
			
			If (vec.size() = 0) Then
				Return Null
			EndIf
			
			Object[] re = New Object[vec.size()]
			vec.copyInto(re)
			Return re
		}
		
		Public Function SystemOut:Void(a:String)
		}
		
		Public Function FillQua:Void(g2:MFGraphics, x0:Int, y0:Int, x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int)
			g2.fillTriangle(x0, y0, x1, y1, x2, y2)
			g2.fillTriangle(x0, y0, x2, y2, x3, y3)
			g2.fillTriangle(x0, y0, x1, y1, x3, y3)
		}
		
		Public Function dSin:Int(tDeg:Int)
			While (tDeg < 0) {
				tDeg += MDPhone.SCREEN_WIDTH
			EndIf
			Int tsh = tDeg Mod MDPhone.SCREEN_WIDTH
			
			If (tsh >= 0 And tsh <= 90) Then
				Return sinData2[tsh] >>> FIXED_TWO_BASE
			EndIf
			
			If (tsh > 90 And tsh <= 180) Then
				Return sinData2[90 - (tsh - 90)] >>> FIXED_TWO_BASE
			EndIf
			
			If (tsh > 180 And tsh <= 270) Then
				Return (sinData2[tsh - 180] >>> FIXED_TWO_BASE) * -1
			EndIf
			
			If (tsh <= 270 Or tsh > 359) Then
				Return BMF_COLOR_WHITE
			EndIf
			
			Return (sinData2[90 - (tsh - 270)] >>> FIXED_TWO_BASE) * -1
		}
		
		Public Function dCos:Int(tDeg:Int)
			Return dSin(90 - tDeg)
		}
		
		Public Function getTypeName:String(fileName:String, type:String)
			String re = ""
			
			If (fileName.indexOf(".") <> -1) Then
				Return fileName.substring(BMF_COLOR_WHITE, fileName.indexOf(".")) + type
			EndIf
			
			Return New StringBuilder(String.valueOf(fileName)).append(type).toString()
		}
		
		Public Function loadString:String[](filename:String)
			Throwable th
			DataInputStream in = Null
			String[] outdata = Null
			try {
				DataInputStream in2 = New DataInputStream(MFDevice.getResourceAsStream(filename))
				try {
					outdata = New String[in2.readInt()]
					For (Int i = 0; i < outdata.Length; i += 1)
						outdata[i] = in2.readUTF()
					EndIf
					If (in2 <> Null) Then
						try {
							in2.close()
						} catch (Exception e) {
						}
					EndIf
					
				} catch (Exception e2) {
					in = in2
				} catch (Throwable th2) {
					th = th2
					in = in2
				EndIf
			} catch (Exception e3) {
				
				If (in <> Null) Then
					try {
						in.close()
					} catch (Exception e4) {
					EndIf
				EndIf
				
				Return outdata
			} catch (Throwable th3) {
				th = th3
				
				If (in <> Null) Then
					try {
						in.close()
					} catch (Exception e5) {
					EndIf
				EndIf
				
				throw th
			EndIf
			Return outdata
		}
		
		Public Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			
			If (drawString <> Null) Then
				Int x2 = x
				String stringToDraw = ""
				downPermit = RGB_DRAW
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = RGB_DRAW
				EndIf
				
				Int i = beginPosition
				While (i < drawString.Length) {
					
					If ((((i - stringCursol) - beginPosition) * LINE_SPACE) + FONT_H > height) Then
						downPermit = True
						Return
					EndIf
					
					If (drawString[i].indexOf("<") = -1 Or drawString[i].indexOf(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i].substring(drawString[i].indexOf("<") + 1, drawString[i].indexOf(">"))
						stringToDraw = drawString[i].substring(drawString[i].indexOf(">") + 1)
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.indexOf("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
						ElseIf (anchor.indexOf("L") <> -1) Then
							x2 = x
						ElseIf (anchor.indexOf("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString2(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * LINE_SPACE), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * LINE_SPACE) + y, 20)
						EndIf
					EndIf
					
					i += 1
				EndIf
			EndIf
			
		}
		
		Public Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int, font:Int)
			
			If (drawString <> Null) Then
				Int x2 = x
				String stringToDraw = ""
				downPermit = RGB_DRAW
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = RGB_DRAW
				EndIf
				
				Int i = beginPosition
				While (i < drawString.Length) {
					
					If ((((i - stringCursol) - beginPosition) * LINE_SPACE) + FONT_H > height) Then
						downPermit = True
						Return
					EndIf
					
					If (drawString[i].indexOf("<") = -1 Or drawString[i].indexOf(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i].substring(drawString[i].indexOf("<") + 1, drawString[i].indexOf(">"))
						stringToDraw = drawString[i].substring(drawString[i].indexOf(">") + 1)
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.indexOf("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(font, stringToDraw))) / 2)
						ElseIf (anchor.indexOf("L") <> -1) Then
							x2 = x
						ElseIf (anchor.indexOf("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(font, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString2(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * LINE_SPACE), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * LINE_SPACE) + y, 20)
						EndIf
					EndIf
					
					i += 1
				EndIf
			EndIf
			
		}
		
		Public Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, fontH:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			
			If (drawString <> Null) Then
				Int x2 = x
				String stringToDraw = ""
				downPermit = RGB_DRAW
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = RGB_DRAW
				EndIf
				
				Int i = beginPosition
				While (i < drawString.Length) {
					
					If ((((i - stringCursol) - beginPosition) * LINE_SPACE) + FONT_H > height) Then
						downPermit = True
						Return
					EndIf
					
					If (drawString[i].indexOf("<") = -1 Or drawString[i].indexOf(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i].substring(drawString[i].indexOf("<") + 1, drawString[i].indexOf(">"))
						stringToDraw = drawString[i].substring(drawString[i].indexOf(">") + 1)
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.indexOf("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
						ElseIf (anchor.indexOf("L") <> -1) Then
							x2 = x
						ElseIf (anchor.indexOf("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString2(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * fontH), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * fontH) + y, 20)
						EndIf
					EndIf
					
					i += 1
				EndIf
			EndIf
			
		}
		
		Public Function drawStringsContinue:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			
			If (drawString <> Null) Then
				Int x2 = x
				String stringToDraw = ""
				downPermit = RGB_DRAW
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = RGB_DRAW
				EndIf
				
				height = beginPosition
				While (height < drawString.Length) {
					
					If (drawString[height].indexOf("<") = -1 Or drawString[height].indexOf(">") = -1) Then
						stringToDraw = drawString[height]
					Else
						anchor = drawString[height].substring(drawString[height].indexOf("<") + 1, drawString[height].indexOf(">"))
						stringToDraw = drawString[height].substring(drawString[height].indexOf(">") + 1)
					EndIf
					
					If (anchor.indexOf("H") <> -1) Then
						x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
					ElseIf (anchor.indexOf("L") <> -1) Then
						x2 = x
					ElseIf (anchor.indexOf("R") <> -1) Then
						x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
					EndIf
					
					If (bold) Then
						drawBoldString(g2, stringToDraw, x2, y + (((height - stringCursol) - beginPosition) * LINE_SPACE), 20, color1, color2, color3)
					Else
						drawString(g2, stringToDraw, x2, (((height - stringCursol) - beginPosition) * LINE_SPACE) + y, 20)
					EndIf
					
					height += 1
				EndIf
			EndIf
			
		}
		
		Public Function drawStringsNarrow:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, interval:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			
			If (drawString <> Null) Then
				Int x2 = x
				String stringToDraw = ""
				downPermit = RGB_DRAW
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = RGB_DRAW
				EndIf
				
				Int i = beginPosition
				While (i < drawString.Length) {
					
					If ((((i - stringCursol) - beginPosition) * interval) + FONT_H > height) Then
						downPermit = True
						Return
					EndIf
					
					If (drawString[i].indexOf("<") = -1 Or drawString[i].indexOf(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i].substring(drawString[i].indexOf("<") + 1, drawString[i].indexOf(">"))
						stringToDraw = drawString[i].substring(drawString[i].indexOf(">") + 1)
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.indexOf("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
						ElseIf (anchor.indexOf("L") <> -1) Then
							x2 = x
						ElseIf (anchor.indexOf("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * interval), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * interval) + y, 20)
						EndIf
					EndIf
					
					i += 1
				EndIf
			EndIf
			
		}
		
		Public Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int)
			drawStrings(g2, drawString, x, y, width, height, BMF_COLOR_WHITE, RGB_DRAW, BMF_COLOR_WHITE, BMF_COLOR_WHITE, BMF_COLOR_WHITE)
		}
		
		Public Function drawBoldStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, color1:Int, color2:Int, color3:Int)
			drawStrings(g2, drawString, x, y, width, height, BMF_COLOR_WHITE, True, color1, color2, color3)
		}
		
		Public Function drawBoldStringsNarrow:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, interval:Int, color1:Int, color2:Int, color3:Int)
			drawStringsNarrow(g2, drawString, x, y, width, height, interval, BMF_COLOR_WHITE, True, color1, color2, color3)
		}
		
		Public Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, fontH:Int, color1:Int, color2:Int, color3:Int)
			drawStrings(g2, drawString, x, y, width, height, fontH, (Int) BMF_COLOR_WHITE, True, color1, color2, color3)
		}
		
		Public Function logicString:Void(keyDown:Bool, keyUp:Bool)
			
			If (keyDown) Then
				If (downPermit And (scrollPageWait = PAGE_WAIT Or scrollPageWait = 0)) Then
					stringCursol += 1
				EndIf
				
				If (scrollPageWait > 0) Then
					scrollPageWait -= 1
				EndIf
				
			ElseIf (keyUp) Then
				If (upPermit And (scrollPageWait = PAGE_WAIT Or scrollPageWait = 0)) Then
					stringCursol -= 1
				EndIf
				
				If (scrollPageWait > 0) Then
					scrollPageWait -= 1
				EndIf
				
			Else
				scrollPageWait = PAGE_WAIT
			EndIf
			
		}
		
		Public Function initString:Void()
			stringCursol = 0
			anchor = ""
		}
		
		Public Function drawTxtArrows:Void(g:MFGraphics, x:Int, y:Int)
			
			If (downPermit) Then
				drawArrow(g, x + 10, y, RGB_DRAW, RGB_DRAW)
			EndIf
			
			If (stringCursol > 0) Then
				drawArrow(g, x - 10, y, True, RGB_DRAW)
			EndIf
			
		}
		
		Public Function drawArrow:Void(g:MFGraphics, x:Int, y:Int, isLeft:Bool, isHorizontal:Bool)
			x = zoomOut(x)
			y = zoomOut(y)
			For (Int i = 0; i < ARROW.Length; i += 1)
				Int arrowHeight
				
				If (isLeft) Then
					arrowHeight = ARROW[i]
				Else
					arrowHeight = ARROW[(ARROW.Length - i) - 1]
				EndIf
				
				If (isHorizontal) Then
					g.drawLine((x - (ARROW.Length / 2)) + i, (y - (arrowHeight / 2)) - 1, (x - (ARROW.Length / 2)) + i, ((y - (arrowHeight / 2)) - 1) + arrowHeight)
				Else
					g.drawLine((x - (arrowHeight / 2)) - 1, (y - (ARROW.Length / 2)) + i, ((x - (arrowHeight / 2)) - 1) + arrowHeight, (y - (ARROW.Length / 2)) + i)
				EndIf
			EndIf
		}
		
		Public Function drawBoldString:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color:Int)
			drawBoldString(g2, a, x, y, anchor, color, BMF_COLOR_WHITE, color)
		}
		
		Public Function drawBoldString:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color1:Int, color2:Int)
			drawBoldString(g2, a, x, y, anchor, color1, color2, color1)
		}
		
		Public Function setBmfColor:Void(colorID:Int)
			Select (colorID)
				Case BMF_COLOR_WHITE
					currentBmFont = bmFont
				Case ROTATE_90
					currentBmFont = bmFontYellow
				Case FLIP_X
					currentBmFont = bmFontGreen
				Case RAY_HEIGHT
					currentBmFont = bmFontGray
				Default
			EndIf
		}
		
		Public Function drawBoldString:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color:Int, color2:Int, color3:Int)
			
			If (a <> Null) Then
				x = zoomOut(x)
				y = zoomOut(y)
				g2.setColor(color2)
				For (Int i = 0; i < OFFSET.Length; i += 1)
					g2.drawString(a, OFFSET[i][BMF_COLOR_WHITE] + x, OFFSET[i][1] + y, anchor)
				EndIf
				g2.setColor(color)
				g2.drawString(a, x, y, anchor)
			EndIf
			
		}
		
		Public Function drawBoldString2:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color:Int, color2:Int, color3:Int)
			
			If (a <> Null) Then
				x = zoomOut(x)
				y = zoomOut(y)
				g2.setColor(color2)
				For (Int i = 0; i < OFFSET2.Length; i += 1)
					g2.drawString(a, OFFSET2[i][BMF_COLOR_WHITE] + x, OFFSET2[i][1] + y, anchor)
				EndIf
				g2.setColor(color)
				g2.drawString(a, x, y, anchor)
			EndIf
			
		}
		
		Public Function zoomOut:Int(x:Int)
			Return x Shr BMF_COLOR_WHITE
		}
		
		Public Function zoomIn:Int(x:Int)
			Return x Shl BMF_COLOR_WHITE
		}
		
		Public Function zoomIn:Int(x:Int, bFlag:Bool)
			
			If (bFlag) Then
				Return x Shl BMF_COLOR_WHITE
			EndIf
			
			Return zoomIn(x)
		}
		
		Public Function drawRegionNokia:Void(g:MFGraphics, image:MFImage, sx:Int, sy:Int, cx:Int, cy:Int, attr:Int, dx:Int, dy:Int)
		}
		
		Public Function drawImageSetClip:Void(g:MFGraphics, image:MFImage, sx:Int, sy:Int, sw:Int, sh:Int, dx:Int, dy:Int, anchor:Int)
			
			If ((anchor & ROTATE_90) <> 0) Then
				dx -= sw / 2
			ElseIf ((anchor & 8) <> 0) Then
				dx -= sw
			EndIf
			
			If ((anchor & 32) <> 0) Then
				dy -= sh
			ElseIf ((anchor & FLIP_X) <> 0) Then
				dy -= sh / 2
			EndIf
			
			g.setClip(Max(dx, BMF_COLOR_WHITE), Max(dy, BMF_COLOR_WHITE), Min(sw + dx, BMF_COLOR_WHITE + SSDef.PLAYER_MOVE_HEIGHT) - Max(dx, BMF_COLOR_WHITE), Min(sh + dy, BMF_COLOR_WHITE + 320) - Max(dy, BMF_COLOR_WHITE))
			g.drawImage(image, dx - sx, dy - sy, BMF_COLOR_WHITE)
			g.setClip(BMF_COLOR_WHITE, BMF_COLOR_WHITE, SSDef.PLAYER_MOVE_HEIGHT, 320)
		}
		
		Public Function drawRegionDebug:Void(g:MFGraphics, img:MFImage, sx:Int, sy:Int, w:Int, he:Int, rot:Int, x:Int, y:Int, anchor:Int)
			
			If ((anchor & ROTATE_90) <> 0) Then
				x -= w / 2
			ElseIf ((anchor & 8) <> 0) Then
				x -= w
			EndIf
			
			If ((anchor & 32) <> 0) Then
				y -= he
			ElseIf ((anchor & FLIP_X) <> 0) Then
				y -= he / 2
			EndIf
			
			If (rot = 0) Then
				g.drawRegion(img, sx, sy, w, he, rot, x, y, 20)
				Return
			EndIf
			
			Int[] RGB = New Int[(w * he)]
			Int[] mRGB = New Int[(w * he)]
			img.getRGB(RGB, BMF_COLOR_WHITE, w, sx, sy, w, he)
			Int i
			
			If (rot = FLIP_X) Then
				For (i = 0; i < w; i += 1)
					For (sy = 0; sy < he; sy += 1)
						mRGB[((w - i) - 1) + (sy * w)] = RGB[(sy * w) + i]
					EndIf
				EndIf
			ElseIf (rot = PAGE_WAIT) Then
				For (i = 0; i < w; i += 1)
					For (sy = 0; sy < he; sy += 1)
						mRGB[((he - sy) - 1) + (i * he)] = RGB[(sy * w) + i]
					EndIf
				EndIf
			ElseIf (rot = RAY_HEIGHT) Then
				For (i = 0; i < w; i += 1)
					For (sy = 0; sy < he; sy += 1)
						mRGB[((w - i) - 1) + (((he - sy) - 1) * w)] = RGB[(sy * w) + i]
					EndIf
				EndIf
			ElseIf (rot = 6) Then
				For (i = 0; i < w; i += 1)
					For (sy = 0; sy < he; sy += 1)
						mRGB[sy + (((w - i) - 1) * he)] = RGB[(sy * w) + i]
					EndIf
				EndIf
			ElseIf (rot = FIXED_TWO_BASE) Then
				For (i = 0; i < w; i += 1)
					For (sy = 0; sy < he; sy += 1)
						mRGB[((he - sy) - 1) + (((w - i) - 1) * he)] = RGB[(sy * w) + i]
					EndIf
				EndIf
			ElseIf (rot = ROTATE_90) Then
				For (i = 0; i < w; i += 1)
					For (sy = 0; sy < he; sy += 1)
						mRGB[i + (((he - sy) - 1) * w)] = RGB[(sy * w) + i]
					EndIf
				EndIf
			ElseIf (rot = FLIP_Y) Then
				For (i = 0; i < w; i += 1)
					For (sy = 0; sy < he; sy += 1)
						mRGB[sy + (i * he)] = RGB[(sy * w) + i]
					EndIf
				EndIf
			EndIf
			
			Select (rot)
				Case FLIP_Y
				Case PAGE_WAIT
				Case SSDef.SSOBJ_BNLD_ID
				Case FIXED_TWO_BASE
					g.drawRGB(mRGB, BMF_COLOR_WHITE, he, x, y, he, w, True)
				Default
					g.drawRGB(mRGB, BMF_COLOR_WHITE, w, x, y, w, he, True)
			EndIf
		}
		
		Public Function loadText:String[](fileName:String) Final
			try {
				Return divideText(New String(getResource(fileName), "UTF-8"))
			} catch (Exception e) {
				e.printStackTrace()
				Return Null
			EndIf
		}
		
		Private Function getResource:Byte[](fileName:String)
			InputStream is = Null
			Byte[] re = Null
			try {
				is = MFDevice.getResourceAsStream(fileName)
				
				If (is <> Null) Then
					ByteArrayOutputStream bs = New ByteArrayOutputStream()
					DataOutputStream ds = New DataOutputStream(bs)
					For (Int readByte = is.read(); readByte >= 0; readByte = is.read())
						ds.writeByte(readByte)
					EndIf
					re = bs.toByteArray()
					bs.close()
				EndIf
				
				If (is <> Null) Then
					try {
						is.close()
					} catch (Exception e) {
						e.printStackTrace()
					EndIf
				EndIf
				
			} catch (Exception e2) {
				e2.printStackTrace()
				
				If (is <> Null) Then
					try {
						is.close()
					} catch (Exception e3) {
						e3.printStackTrace()
					EndIf
				EndIf
				
			} catch (Throwable th) {
				
				If (is <> Null) Then
					try {
						is.close()
					} catch (Exception e32) {
						e32.printStackTrace()
					EndIf
				EndIf
			EndIf
			Return re
		}
		
		Private Function getTextLineNum:Int(org:String)
			Int ret = 0
			Int j = 0
			While (True) {
				Int x = org.indexOf("\n", j)
				
				If (x = -1) Then
					Return ret
				EndIf
				
				j = x + 1
				ret += 1
			EndIf
		}
		
		Private Function divideText:String[](string:String)
			
			If (string = Null) Then
				Return Null
			EndIf
			
			String[] re = (String[]) BMF_COLOR_WHITE
			re = New String[getTextLineNum(string)]
			Int k = 0
			Int j = 0
			While (True) {
				Int x = string.indexOf(13, j)
				
				If (x = -1) Then
					break
				EndIf
				
				Int k2 = k + 1
				re[k] = string.substring(j, x)
				j = x + 2
				k = k2
			EndIf
			If (re[BMF_COLOR_WHITE] <> Null And re[BMF_COLOR_WHITE].Length() > 0) Then
				StringBuffer b = New StringBuffer(New String(re[BMF_COLOR_WHITE].toCharArray()))
				Integer ascii = New Integer(b.charAt(BMF_COLOR_WHITE))
				
				If (ascii.hashCode() = 63 Or ascii.hashCode() = 65279 Or ascii.hashCode() = -257) Then
					b.deleteCharAt(BMF_COLOR_WHITE)
				EndIf
				
				re[BMF_COLOR_WHITE] = b.toString()
			EndIf
			
			Return re
		}
		
		Public Function calNextPositionD:double(current:double, destiny:double, velocity1:Int, velocity2:Int)
			Return (double) calNextPosition(current, destiny, velocity1, velocity2, 1.0)
		}
		
		Public Function calNextPositionF:Float(current:double, destiny:double, velocity1:Int, velocity2:Int, deviation:double)
			Return (Float) calNextPositionD(current, destiny, velocity1, velocity2, deviation)
		}
		
		Public Function calNextPosition:Int(current:double, destiny:double, velocity1:Int, velocity2:Int)
			Return calNextPosition(current, destiny, velocity1, velocity2, 1.0)
		}
		
		Public Function calNextPosition:Int(current:double, destiny:double, velocity1:Int, velocity2:Int, deviation:double)
			Return (Int) calNextPositionD(current, destiny, velocity1, velocity2, deviation)
		}
		
		Public Function calNextPositionD:double(current:double, destiny:double, velocity1:Int, velocity2:Int, deviation:double)
			double re = current
			
			If (velocity2 <= velocity1) Then
				Return re
			EndIf
			
			double distance = (((destiny - current) * 100.0) * ((double) velocity1)) / ((double) velocity2)
			current += distance / 100.0
			
			If (distance = 0.0) Then
				deviation = 0.0
			ElseIf (distance <= 0.0) Then
				deviation = -deviation
			EndIf
			
			current += deviation
			
			If (((Long) distance) * ((((Long) destiny) * 100) - (((Long) current) * 100)) <= 0) Then
				current = destiny
			EndIf
			
			Return current
		}
		
		Public Function calNextPositionReverse:Int(current:Int, start:Int, destiny:Int, velocity1:Int, velocity2:Int)
			Return calNextPositionReverse(current, start, destiny, velocity1, velocity2, ROTATE_90)
		}
		
		Public Function calNextPositionReverse:Int(current:Int, start:Int, destiny:Int, velocity1:Int, velocity2:Int, deviation:Int)
			Int re = current
			
			If (velocity2 <= velocity1) Then
				Return re
			EndIf
			
			If (current = destiny) Then
				Return re
			EndIf
			
			Int moveChange = ((Abs(current - start) * velocity2) / (velocity2 - velocity1)) Shr ROTATE_90
			
			If (moveChange = 0) Then
				moveChange = deviation
			EndIf
			
			If (re < destiny) Then
				re += moveChange
				
				If (re > destiny) Then
					re = destiny
				EndIf
				
			Else
				re -= moveChange
				
				If (re < destiny) Then
					re = destiny
				EndIf
			EndIf
			
			Return re
		}
		
		Public Function drawFadeRange:Void(g:MFGraphics, fadevalue:Int, x:Int, y:Int, type:Int)
			Int i
			For (i = 0; i < 864; i += 1)
				rayRGB[i] = 16777215
			EndIf
			For (Int w = 0; w < RAY_WIDTH; w += 1)
				For (i = 0; i < RAY_HEIGHT; i += 1)
					rayRGB[(i * RAY_WIDTH) + w] = ((fadevalue Shl 24) & -16777216) | (rayRGB[(i * RAY_WIDTH) + w] & 16777215)
				EndIf
			EndIf
			Select (type)
				Case BMF_COLOR_WHITE
				Case FIXED_TWO_BASE
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
				Case ROTATE_90
				Case SSDef.SSOBJ_BNLD_ID
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y - RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y + RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
				Case FLIP_X
				Case PAGE_WAIT
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y - RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y + RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y - 6, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y + 6, RAY_WIDTH, RAY_HEIGHT, True)
				Case RAY_HEIGHT
				Case FLIP_Y
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y - RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y + RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y - 6, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y + 6, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y - 9, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, BMF_COLOR_WHITE, RAY_WIDTH, x, y + 9, RAY_WIDTH, RAY_HEIGHT, True)
				Default
			EndIf
		}
		
		Public Function getRelativePointX:Int(originalX:Int, offsetX:Int, offsetY:Int, degree:Int)
			Return (((dCos(degree) * offsetX) / 100) + originalX) - ((dSin(degree) * offsetY) / 100)
		}
		
		Public Function getRelativePointY:Int(originalY:Int, offsetX:Int, offsetY:Int, degree:Int)
			Return (((dSin(degree) * offsetX) / 100) + originalY) + ((dCos(degree) * offsetY) / 100)
		}
		
		Public Function getPath:String(path:String)
			String path2 = ""
			While (path.indexOf("/") <> -1) {
				path2 = New StringBuilder(String.valueOf(path2)).append(path.substring(BMF_COLOR_WHITE, path.indexOf("/") + 1)).toString()
				path = path.substring(path.indexOf("/") + 1)
			EndIf
			Return path2
		}
		
		Public Function getFileName:String(path:String)
			String path2 = ""
			While (path.indexOf("/") <> -1) {
				path2 = New StringBuilder(String.valueOf(path2)).append(path.substring(BMF_COLOR_WHITE, path.indexOf("/") + 1)).toString()
				path = path.substring(path.indexOf("/") + 1)
			EndIf
			Return path
		}
		
		Public Function vibrate:Void()
			
			If (GlobalResource.vibrationConfig = ROTATE_90) Then
				MFDevice.vibrateByTime(100)
			EndIf
			
		}
		
		Public Function drawScaleAni:Void(g:MFGraphics, drawer:AnimationDrawer, id:Int, x:Int, y:Int, scalex:Float, scaley:Float, pointx:Float, pointy:Float)
			drawer.setActionId(id)
			Graphics g2 = (Graphics) g.getSystemGraphics()
			g2.save()
			g2.translate((Float) x, (Float) y)
			g2.scale(scalex, scaley, pointx, pointy)
			drawer.draw(g, BMF_COLOR_WHITE, BMF_COLOR_WHITE)
			g2.scale(1.0 / scalex, 1.0 / scaley)
			g2.translate((Float) (-x), (Float) (-y))
			g2.restore()
		}
End