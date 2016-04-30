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
	Import com.sega.mobile.framework.android.graphicsmacros
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import brl.stream
	
	Import monkey.stack
	Import monkey.boxes
	
	Import regal.typetool
Public

' Classes:
Class MyAPI ' Implements Def
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
		'Global currentBmFont:BitmapFont
		
		' This may be removed at a later date.
		Global rayRGB:Int[] = New Int[RAY_WIDTH*RAY_HEIGHT]
	Public
		' Constant variable(s):
		Const BMF_COLOR_WHITE:Int = 0
		Const BMF_COLOR_YELLOW:Int = 1
		Const BMF_COLOR_GREEN:Int = 2
		Const BMF_COLOR_GRAY:Int = 3
		
		Const FIXED_TWO_BASE:Int = 7
		
		Const ZOOM_OUT_MOVE:Int = 0
		
		Const NOKIA_DRAW:Bool = False
		Const RGB_DRAW:Bool = False
		
		Global sinData2:Int[] = [0, 224, 446, 669, 893, 1116, 1337, 1560, 1781, 2001, 2222, 2442, 2661, 2878, 3096, 3312, 3527, 3742, 3955, 4167, 4377, 4587, 4794, 5000, 5205, 5409, 5611, 5811, 6009, 6205, 6400, 6592, 6782, 6970, 7157, 7342, 7523, 7703, 7879, 8055, 8227, 8396, 8564, 8729, 8890, 9050, 9207, 9360, 9511, 9660, 9804, 9946, 10086, 10222, 10355, 10484, 10611, 10735, 10854, 10972, 11084, 11194, 11301, 11404, 11504, 11600, 11692, 11782, 11868, 11950, 12028, 12102, 12172, 12240, 12304, 12363, 12419, 12472, 12519, 12564, 12605, 12642, 12675, 12704, 12729, 12751, 12769, 12782, 12792, 12797, 12800] ' Const
		
		' Global variable(s):
		Global anchor:String
		
		Global backColor:Int = BMF_COLOR_WHITE
		
		'Global bmFont:BitmapFont
		'Global bmFontGray:BitmapFont
		'Global bmFontGreen:BitmapFont
		'Global bmFontYellow:BitmapFont
		
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
		
		Function getResource:DataBuffer(fileName:String)
			Return DataBuffer.Load(MFDevice.FixResourcePath(fileName))
		End
		
		Function getTextLineNum:Int(org:String)
			Local ret:= 0
			Local j:= 0
			
			While (True)
				Local x:= org.Find("~n", j)
				
				If (x = -1) Then
					Exit
				EndIf
				
				j = (x + 1)
				
				ret += 1
			Wend
			
			Return ret
		End
		
		Function divideText:String[](str:String)
			If (str.Length = 0) Then
				Return []
			EndIf
			
			Local lineNum:= getTextLineNum(str)
			
			Local re:String[] = New String[lineNum]
			
			Local k:= 0
			Local j:= 0
			
			While (True)
				Local x:= str.Find("~r", j)
				
				If (x = -1) Then
					Exit
				EndIf
				
				Local k2:= (k + 1)
				
				re[k] = str[j..x]
				
				j = (x + 2)
				
				k = k2
			Wend
			
			Local firstEntry:= re[0]
			
			If (firstEntry.Length > 0) Then
				Local firstChar:= firstEntry[0]
				
				If (firstChar = $3F Or firstChar = $FEFF Or firstChar = $FFFFFFFFFFFFFEFF) Then
					re[0] = firstEntry[1..]
				EndIf
			EndIf
			
			Return re
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
			
			Local startPos:= str.Find("<")
			Local endPos:= str.Find(">")
			
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
		
		Function drawSubstring:Void(g2:MFGraphics, a:String, startPoint:Int, endPoint:Int, x:Int, y:Int, anchor:Int)
			'x = zoomOut(x)
			'y = zoomOut(y)
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
		
		#Rem
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
						
						g2.drawString(selector[w].ToString(), x + 8, (LINE_SPACE * w) + y, 20)
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
		#End
		
		Function getStrings:String[](s:String, lineLength:Int)
			lineLength = zoomOut(lineLength)
			
			If (lineLength > 8) Then
				lineLength -= 8
			EndIf
			
			Local strings:= New StringStack()
			
			Local answerWord:String
			
			Local func:Bool = False
			
			Local currentPosition:= 0
			Local endOfCurrentWord:= 0
			Local ConcealEnterPosition:= 0
			Local startOfLine:= 0
			
			Local isSpace:Bool = False
			
			While (endOfCurrentWord >= 0 And endOfCurrentWord < s.Length)
				endOfCurrentWord += 1
				
				Local nextWord:= s[currentPosition..endOfCurrentWord]
				
				If (nextWord = "\") Then ' "~~"
					ConcealEnterPosition = (currentPosition - startOfLine)
					
					isSpace = False
				ElseIf (nextWord = "|" Or nextWord = "~n") Then
					ConcealEnterPosition = 0
					
					Local startOfLine2:= endOfCurrentWord
					
					strings.Push(answerWord)
					
					answerWord = ""
					
					startOfLine = startOfLine2
					
					func = False
				Else
					answerWord = (answerWord + nextWord)
					
					If (nextWord = "<") Then
						func = True
						
						currentPosition = endOfCurrentWord
					Else
						currentPosition = 0
						
						While (currentPosition < Symbol.Length)
							If (nextWord[0] = Symbol[currentPosition]) Then
								currentPosition = endOfCurrentWord
								
								If (endOfCurrentWord = s.Length) Then
									strings.Push(answerWord)
								EndIf
							Else
								currentPosition += 1
							EndIf
						Wend
					EndIf
				EndIf
				
				currentPosition = getStringWidth(14, answerWord)
				
				If (func) Then
					currentPosition -= getStringWidth(14, "<H>")
				EndIf
				
				If (currentPosition >= lineLength And endOfCurrentWord < s.Length) Then
					Local startOfLine2:Int
					
					If (ConcealEnterPosition = 0) Then
						strings.Push(answerWord[..(answerWord.Length - 1)])
						
						answerWord = answerWord[(answerWord.Length - 1)..]
						startOfLine2 = endOfCurrentWord - 1
					Else
						strings.Push(answerWord[..ConcealEnterPosition])
						
						answerWord = answerWord[(Int(isSpace) + ConcealEnterPosition)..]
						currentPosition = (ConcealEnterPosition + Int(isSpace) + startOfLine)
						
						ConcealEnterPosition = 0
						startOfLine2 = currentPosition
					EndIf
					
					startOfLine = startOfLine2
					
					func = False
				ElseIf (endOfCurrentWord = s.Length) Then
					strings.Push(answerWord)
				EndIf
				
				currentPosition = endOfCurrentWord
			Wend
			
			Return strings.ToArray()
		End
		
		Function getStrings:String[](s:String, fontid:Int, lineLength:Int)
			lineLength = zoomOut(lineLength)
			
			If (lineLength > 8) Then
				lineLength -= 8
			EndIf
			
			Local strings:= New StringStack()
			
			Local answerWord:String
			
			Local func:Bool = False
			
			Local currentPosition:= 0
			Local endOfCurrentWord:= 0
			Local ConcealEnterPosition:= 0
			Local startOfLine:= 0
			
			Local isSpace:Bool = False
			
			While (endOfCurrentWord >= 0 And endOfCurrentWord < s.Length)
				endOfCurrentWord += 1
				
				Local nextWord:= s[(currentPosition)..(endOfCurrentWord)]
				
				If (nextWord = "^") Then
					ConcealEnterPosition = (currentPosition - startOfLine)
					
					isSpace = False
				ElseIf (nextWord = "|" Or nextWord = "~n") Then
					ConcealEnterPosition = 0
					
					Local startOfLine2:= endOfCurrentWord
					
					strings.Push(answerWord)
					
					answerWord = ""
					
					startOfLine = startOfLine2
					
					func = False
				Else
					answerWord += nextWord
					
					If (nextWord = "<") Then
						func = True
						
						currentPosition = endOfCurrentWord
					Else
						currentPosition = 0
						
						While (currentPosition < Symbol.Length)
							If (nextWord[0] = Symbol[currentPosition]) Then
								currentPosition = endOfCurrentWord
								
								If (endOfCurrentWord = s.Length) Then
									strings.Push(answerWord)
								EndIf
							Else
								currentPosition += 1
							EndIf
						Wend
					EndIf
				EndIf
				
				currentPosition = getStringWidth(fontid, answerWord)
				
				If (func) Then
					currentPosition -= getStringWidth(fontid, "<H>")
				EndIf
				
				If (currentPosition >= lineLength And endOfCurrentWord < s.Length) Then
					Local startOfLine2:Int
					
					If (ConcealEnterPosition = 0) Then
						strings.Push(answerWord[..(answerWord.Length - 1)])
						
						answerWord = answerWord[(answerWord.Length - 1)..]
						
						startOfLine2 = endOfCurrentWord - 1
					Else
						strings.Push(answerWord[..(ConcealEnterPosition)])
						
						answerWord = answerWord[(Int(isSpace) + ConcealEnterPosition)..]
						
						currentPosition = ((ConcealEnterPosition + Int(isSpace)) + startOfLine)
						
						ConcealEnterPosition = 0
						
						startOfLine2 = currentPosition
					EndIf
					
					startOfLine = startOfLine2
					
					func = False
				ElseIf (endOfCurrentWord = s.Length) Then
					strings.Push(answerWord)
				EndIf
				
				currentPosition = endOfCurrentWord
			Wend
			
			Return strings.ToArray()
		End
		
		Function getEnStrings:String[](s:String, lineLength:Int)
			Local strings:= New StringStack()
			
			Local answerWord:String
			
			Local currentPosition:= 0
			Local endOfCurrentWord:= 0
			Local startOfLine:= 0
			
			While (endOfCurrentWord >= 0 And endOfCurrentWord < s.Length)
				endOfCurrentWord += 1
				
				Local nextWord:= s[(currentPosition)..(endOfCurrentWord)]
				
				If (nextWord = "^" Or nextWord = " ") Then
					'Local ConcealEnterPosition:= (currentPosition - startOfLine)
				ElseIf (nextWord = "|" Or nextWord = "~n") Then
					startOfLine = endOfCurrentWord
					
					strings.Push(answerWord)
					
					answerWord = ""
				Else
					answerWord = answerWord + nextWord
					
					If (Not nextWord = "<") Then
						Local i:= 0
						
						While (i < Symbol.Length)
							If (nextWord[0] = Symbol[i]) Then
								currentPosition = endOfCurrentWord
								
								If (endOfCurrentWord = s.Length) Then
									strings.Push(answerWord)
								EndIf
							Else
								i += 1
							EndIf
						Wend
					EndIf
				EndIf
			Wend
			
			Return strings.ToArray()
		End
		
		Function getStringWidth:Int(fontID:Int, answerWord:String)
			Return MFGraphics.stringWidth(fontID, answerWord)
		End
		
		Function SystemOut:Void(a:String)
			#If CONFIG = "debug"
				Print(a)
			#End
		End
		
		Function FillQua:Void(g2:MFGraphics, x0:Int, y0:Int, x1:Int, y1:Int, x2:Int, y2:Int, x3:Int, y3:Int)
			g2.fillTriangle(x0, y0, x1, y1, x2, y2)
			g2.fillTriangle(x0, y0, x2, y2, x3, y3)
			g2.fillTriangle(x0, y0, x1, y1, x3, y3)
		End
		
		Function dSin:Int(tDeg:Int)
			While (tDeg < 0)
				tDeg += 360
			Wend
			
			''Return Int(Sin(Float(tDeg)))
			
			Local tsh:= (tDeg Mod 360)
			
			If (tsh >= 0 And tsh <= 90) Then
				Return sinData2[tsh] Shr FIXED_TWO_BASE ' >>>
			EndIf
			
			If (tsh > 90 And tsh <= 180) Then
				Return sinData2[90 - (tsh - 90)] Shr FIXED_TWO_BASE ' >>>
			EndIf
			
			If (tsh > 180 And tsh <= 270) Then
				Return (sinData2[tsh - 180] Shr FIXED_TWO_BASE) * -1 ' >>>
			EndIf
			
			If (tsh <= 270 Or tsh > 359) Then
				Return BMF_COLOR_WHITE
			EndIf
			
			Return (sinData2[90 - (tsh - 270)] Shr FIXED_TWO_BASE) * -1 ' >>>
		End
		
		Function dCos:Int(tDeg:Int)
			'Return Int(Cos(Float(tDeg)))
			Return dSin(90 - tDeg)
		End
		
		Function getTypeName:String(fileName:String, type:String)
			Local re:String
			
			Local sepPos:= fileName.Find(".")
			
			If (sepPos <> -1) Then
				Return fileName[..sepPos] + type
			EndIf
			
			Return fileName + type
		End
		
		Function loadString:String[](filename:String)
			Local output:String[]
			
			Try
				Local input:= MFDevice.getResourceAsStream(filename)
				
				Local outSize:= input.ReadInt()
				
				output = New String[outSize]
				
				For Local i:= 0 Until outSize
					Local strLength:= input.ReadShort()
					
					output[i] = input.ReadString(strLength, "utf8")
				Next
				
				input.Close()
			Catch E:StreamError
				' Nothing so far.
			End Try
			
			Return output
		End
		
		Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			If (drawString.Length > 0) Then
				Local x2:= x
				
				Local stringToDraw:String
				
				downPermit = False
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = False
				EndIf
				
				Local i:= beginPosition
				
				While (i < drawString.Length)
					If ((((i - stringCursol) - beginPosition) * LINE_SPACE) + FONT_H > height) Then
						downPermit = True
						
						Return
					EndIf
					
					If (drawString[i].Find("<") = -1 Or drawString[i].Find(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i][(drawString[i].Find("<") + 1)..(drawString[i].Find(">"))]
						
						stringToDraw = drawString[i][(drawString[i].Find(">") + 1)..]
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.Find("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
						ElseIf (anchor.Find("L") <> -1) Then
							x2 = x
						ElseIf (anchor.Find("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString2(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * LINE_SPACE), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * LINE_SPACE) + y, 20)
						EndIf
					EndIf
					
					i += 1
				Wend
			EndIf
		End
		
		Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int, font:Int)
			If (drawString <> Null) Then
				Local x2:= x
				
				Local stringToDraw:String
				
				downPermit = False
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = False
				EndIf
				
				Local i:= beginPosition
				
				While (i < drawString.Length)
					If ((((i - stringCursol) - beginPosition) * LINE_SPACE) + FONT_H > height) Then
						downPermit = True
						
						Exit
					EndIf
					
					If (drawString[i].Find("<") = -1 Or drawString[i].Find(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i][(drawString[i].Find("<") + 1)..(drawString[i].Find(">"))]
						stringToDraw = drawString[i][(drawString[i].Find(">") + 1)..]
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.Find("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(font, stringToDraw))) / 2)
						ElseIf (anchor.Find("L") <> -1) Then
							x2 = x
						ElseIf (anchor.Find("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(font, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString2(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * LINE_SPACE), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * LINE_SPACE) + y, 20)
						EndIf
					EndIf
					
					i += 1
				Wend
			EndIf
		End
		
		Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, fontH:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			If (drawString <> Null) Then
				Local x2:= x
				
				Local stringToDraw:String
				
				downPermit = False
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = False
				EndIf
				
				Local i:= beginPosition
				
				While (i < drawString.Length)
					If ((((i - stringCursol) - beginPosition) * LINE_SPACE) + FONT_H > height) Then
						downPermit = True
						
						Exit
					EndIf
					
					If (drawString[i].Find("<") = -1 Or drawString[i].Find(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i][(drawString[i].Find("<") + 1)..(drawString[i].Find(">"))]
						stringToDraw = drawString[i][(drawString[i].Find(">") + 1)..]
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.Find("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
						ElseIf (anchor.Find("L") <> -1) Then
							x2 = x
						ElseIf (anchor.Find("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString2(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * fontH), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * fontH) + y, 20)
						EndIf
					EndIf
					
					i += 1
				Wend
			EndIf
		End
		
		Function drawStringsContinue:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			If (drawString <> Null) Then
				Local x2:= x
				
				Local stringToDraw:String
				
				downPermit = False
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = False
				EndIf
				
				height = beginPosition
				
				While (height < drawString.Length)
					If (drawString[height].Find("<") = -1 Or drawString[height].Find(">") = -1) Then
						stringToDraw = drawString[height]
					Else
						anchor = drawString[height][(drawString[height].Find("<") + 1)..(drawString[height].Find(">"))]
						stringToDraw = drawString[height][(drawString[height].Find(">") + 1)..]
					EndIf
					
					If (anchor.Find("H") <> -1) Then
						x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
					ElseIf (anchor.Find("L") <> -1) Then
						x2 = x
					ElseIf (anchor.Find("R") <> -1) Then
						x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
					EndIf
					
					If (bold) Then
						drawBoldString(g2, stringToDraw, x2, y + (((height - stringCursol) - beginPosition) * LINE_SPACE), 20, color1, color2, color3)
					Else
						drawString(g2, stringToDraw, x2, (((height - stringCursol) - beginPosition) * LINE_SPACE) + y, 20)
					EndIf
					
					height += 1
				Wend
			EndIf
		End
		
		Function drawStringsNarrow:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, interval:Int, beginPosition:Int, bold:Bool, color1:Int, color2:Int, color3:Int)
			If (drawString <> Null) Then
				Local x2:= x
				
				Local stringToDraw:String
				
				downPermit = False
				
				If (stringCursol > 0) Then
					upPermit = True
				Else
					upPermit = False
				EndIf
				
				Local i:= beginPosition
				
				While (i < drawString.Length)
					If ((((i - stringCursol) - beginPosition) * interval) + FONT_H > height) Then
						downPermit = True
						
						Exit
					EndIf
					
					If (drawString[i].Find("<") = -1 Or drawString[i].Find(">") = -1) Then
						stringToDraw = drawString[i]
					Else
						anchor = drawString[i][(drawString[i].Find("<") + 1)..(drawString[i].Find(">"))]
						stringToDraw = drawString[i][(drawString[i].Find(">") + 1)..]
					EndIf
					
					If (i - beginPosition >= stringCursol) Then
						If (anchor.Find("H") <> -1) Then
							x2 = x + ((width - zoomIn(getStringWidth(14, stringToDraw))) / 2)
						ElseIf (anchor.Find("L") <> -1) Then
							x2 = x
						ElseIf (anchor.Find("R") <> -1) Then
							x2 = (x + width) - zoomIn(getStringWidth(14, stringToDraw))
						EndIf
						
						If (bold) Then
							drawBoldString(g2, stringToDraw, x2, y + (((i - stringCursol) - beginPosition) * interval), 20, color1, color2, color3)
						Else
							drawString(g2, stringToDraw, x2, (((i - stringCursol) - beginPosition) * interval) + y, 20)
						EndIf
					EndIf
					
					i += 1
				Wend
			EndIf
		End
		
		Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int)
			drawStrings(g2, drawString, x, y, width, height, 0, False, 0, 0, 0)
		End
		
		Function drawBoldStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, color1:Int, color2:Int, color3:Int)
			drawStrings(g2, drawString, x, y, width, height, 0, True, color1, color2, color3)
		End
		
		Function drawBoldStringsNarrow:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, interval:Int, color1:Int, color2:Int, color3:Int)
			drawStringsNarrow(g2, drawString, x, y, width, height, interval, 0, True, color1, color2, color3)
		End
		
		Function drawStrings:Void(g2:MFGraphics, drawString:String[], x:Int, y:Int, width:Int, height:Int, fontH:Int, color1:Int, color2:Int, color3:Int)
			drawStrings(g2, drawString, x, y, width, height, fontH, BMF_COLOR_WHITE, True, color1, color2, color3)
		End
		
		Function logicString:Void(keyDown:Bool, keyUp:Bool)
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
		End
		
		Function initString:Void()
			stringCursol = 0
			
			anchor = ""
		End
		
		Function drawTxtArrows:Void(g:MFGraphics, x:Int, y:Int)
			If (downPermit) Then
				drawArrow(g, x + 10, y, False, False)
			EndIf
			
			If (stringCursol > 0) Then
				drawArrow(g, x - 10, y, True, False)
			EndIf
		End
		
		Function drawArrow:Void(g:MFGraphics, x:Int, y:Int, isLeft:Bool, isHorizontal:Bool)
			x = zoomOut(x)
			y = zoomOut(y)
			
			For Local i:= 0 Until ARROW.Length
				Local arrowHeight:Int
				
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
			Next
		End
		
		Function drawBoldString:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color:Int)
			drawBoldString(g2, a, x, y, anchor, color, 0, color)
		End
		
		Function drawBoldString:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color1:Int, color2:Int)
			drawBoldString(g2, a, x, y, anchor, color1, color2, color1)
		End
		
		Function setBmfColor:Void(colorID:Int)
			Select (colorID)
				Case BMF_COLOR_WHITE
					currentBmFont = bmFont
				Case BMF_COLOR_YELLOW
					currentBmFont = bmFontYellow
				Case BMF_COLOR_GREEN
					currentBmFont = bmFontGreen
				Case BMF_COLOR_GRAY
					currentBmFont = bmFontGray
				Default
					' Nothing so far.
			End Select
		End
		
		Function drawBoldString:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color:Int, color2:Int, color3:Int)
			If (a <> Null) Then
				x = zoomOut(x)
				y = zoomOut(y)
				
				g2.setColor(color2)
				
				For Local i:= 0 Until OFFSET.Length
					g2.drawString(a, OFFSET[i][0] + x, OFFSET[i][1] + y, anchor)
				Next
				
				g2.setColor(color)
				
				g2.drawString(a, x, y, anchor)
			EndIf
		End
		
		Function drawBoldString2:Void(g2:MFGraphics, a:String, x:Int, y:Int, anchor:Int, color:Int, color2:Int, color3:Int)
			If (a <> Null) Then
				x = zoomOut(x)
				y = zoomOut(y)
				
				g2.setColor(color2)
				
				For Local i:= 0 Until OFFSET2.Length
					g2.drawString(a, OFFSET2[i][0] + x, OFFSET2[i][1] + y, anchor)
				Next
				
				g2.setColor(color)
				
				g2.drawString(a, x, y, anchor)
			EndIf
		End
		
		Function zoomOut:Int(x:Int)
			Return (x Shr ZOOM_OUT_MOVE)
		End
		
		Function zoomIn:Int(x:Int)
			Return (x Shl ZOOM_OUT_MOVE)
		End
		
		Function zoomIn:Int(x:Int, bFlag:Bool)
			If (bFlag) Then
				Return (x Shl ZOOM_OUT_MOVE)
			EndIf
			
			Return zoomIn(x)
		End
		
		Function drawRegionNokia:Void(g:MFGraphics, image:MFImage, sx:Int, sy:Int, cx:Int, cy:Int, attr:Int, dx:Int, dy:Int)
			' Empty implementation.
		End
		
		Function drawImageSetClip:Void(g:MFGraphics, image:MFImage, sx:Int, sy:Int, sw:Int, sh:Int, dx:Int, dy:Int, anchor:Int)
			If ((anchor & HCENTER) <> 0) Then
				dx -= sw / 2
			ElseIf ((anchor & RIGHT) <> 0) Then
				dx -= sw
			EndIf
			
			If ((anchor & BOTTOM) <> 0) Then
				dy -= sh
			ElseIf ((anchor & VCENTER) <> 0) Then
				dy -= sh / 2
			EndIf
			
			g.setClip(Max(dx, 0), Max(dy, 0), Min(sw + dx, 0 + ssdef.PLAYER_MOVE_HEIGHT) - Max(dx, 0), Min(sh + dy, 0 + 320) - Max(dy, 0))
			
			g.drawImage(image, dx - sx, dy - sy, 0)
			
			g.setClip(0, 0, ssdef.PLAYER_MOVE_HEIGHT, 320)
		End
		
		#Rem
			Function drawRegionDebug:Void(g:MFGraphics, img:MFImage, sx:Int, sy:Int, w:Int, he:Int, rot:Int, x:Int, y:Int, anchor:Int)
				If ((anchor & HCENTER) <> 0) Then
					x -= (w / 2)
				ElseIf ((anchor & RIGHT) <> 0) Then
					x -= w
				EndIf
				
				If ((anchor & BOTTOM) <> 0) Then
					y -= he
				ElseIf ((anchor & VCENTER) <> 0) Then
					y -= (he / 2)
				EndIf
				
				If (rot = 0) Then
					g.drawRegion(img, sx, sy, w, he, rot, x, y, 20)
					
					Return
				EndIf
				
				Local RGB:= New Int[(w * he)]
				Local mRGB:= New Int[(w * he)]
				
				img.getRGB(RGB, 0, w, sx, sy, w, he)
				
				Local i:Int
				
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
					Case ssdef.SSOBJ_BNLD_ID
					Case FIXED_TWO_BASE
						g.drawRGB(mRGB, 0, he, x, y, he, w, True)
					Default
						g.drawRGB(mRGB, 0, w, x, y, w, he, True)
				EndIf
			End
		#End
		
		Function loadText:String[](fileName:String)
			Return divideText(getResource(fileName).PeekString(0, "utf8"))
		End
		
		Function calNextPositionD:Double(current:Double, destiny:Double, velocity1:Int, velocity2:Int)
			Return Double(calNextPosition(current, destiny, velocity1, velocity2, 1.0))
		End
		
		Function calNextPositionF:Float(current:Double, destiny:Double, velocity1:Int, velocity2:Int, deviation:Double)
			Return Float(calNextPositionD(current, destiny, velocity1, velocity2, deviation))
		End
		
		Function calNextPosition:Int(current:Double, destiny:Double, velocity1:Int, velocity2:Int)
			Return calNextPosition(current, destiny, velocity1, velocity2, 1.0)
		End
		
		Function calNextPosition:Int(current:Double, destiny:Double, velocity1:Int, velocity2:Int, deviation:Double)
			Return Int(calNextPositionD(current, destiny, velocity1, velocity2, deviation))
		End
		
		Function calNextPositionD:Double(current:Double, destiny:Double, velocity1:Int, velocity2:Int, deviation:Double)
			Local re:= current
			
			If (velocity2 <= velocity1) Then
				Return re
			EndIf
			
			Local distance:Double = ((((destiny - current) * 100.0) * Double(velocity1)) / Double(velocity2))
			
			current += (distance / 100.0)
			
			If (distance = 0.0) Then
				deviation = 0.0
			ElseIf (distance <= 0.0) Then
				deviation = -deviation
			EndIf
			
			current += deviation
			
			If (Long(distance) * ((Long(destiny) * 100) - (Long(current) * 100)) <= 0) Then
				current = destiny
			EndIf
			
			Return current
		End
		
		Function calNextPositionReverse:Int(current:Int, start:Int, destiny:Int, velocity1:Int, velocity2:Int)
			Return calNextPositionReverse(current, start, destiny, velocity1, velocity2, 1)
		End
		
		Function calNextPositionReverse:Int(current:Int, start:Int, destiny:Int, velocity1:Int, velocity2:Int, deviation:Int)
			Local re:= current
			
			If (velocity2 <= velocity1) Then
				Return re
			EndIf
			
			If (current = destiny) Then
				Return re
			EndIf
			
			Local moveChange:= ((Abs(current - start) * velocity2) / (velocity2 - velocity1)) Shr 1 ' / 2
			
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
		End
		
		' This implementation will be replaced eventually. (Software fade)
		Function drawFadeRange:Void(g:MFGraphics, fadevalue:Int, x:Int, y:Int, type:Int)
			For Local i:= 0 Until rayRGB.Length ' RAY_WIDTH*RAY_HEIGHT
				rayRGB[i] = 16777215
			Next
			
			For Local w:= 0 Until RAY_WIDTH
				For Local h:= 0 Until RAY_HEIGHT
					rayRGB[(h * RAY_WIDTH) + w] = ((fadevalue Shl 24) & -16777216) | (rayRGB[(h * RAY_WIDTH) + w] & 16777215)
				Next
			Next
			
			Select (type)
				Case 0, 7
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
				Case 1, 6
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y - RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y + RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
				Case 2, 5
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y - RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y + RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y - 6, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y + 6, RAY_WIDTH, RAY_HEIGHT, True)
				Case 3, 4
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y - RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y + RAY_HEIGHT, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y - 6, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y + 6, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y - 9, RAY_WIDTH, RAY_HEIGHT, True)
					g.drawRGB(rayRGB, 0, RAY_WIDTH, x, y + 9, RAY_WIDTH, RAY_HEIGHT, True)
				Default
					' Nothing so far.
			End Select
		End
		
		Function getRelativePointX:Int(originalX:Int, offsetX:Int, offsetY:Int, degree:Int)
			Return (((dCos(degree) * offsetX) / 100) + originalX) - ((dSin(degree) * offsetY) / 100)
		End
		
		Function getRelativePointY:Int(originalY:Int, offsetX:Int, offsetY:Int, degree:Int)
			Return (((dSin(degree) * offsetX) / 100) + originalY) + ((dCos(degree) * offsetY) / 100)
		End
		
		Function getPath:String(path:String)
			Local out:String
			
			While (path.Find("/") <> -1)
				Local pos:= (path.Find("/") + 1)
				
				out += path[..pos]
				
				path = path[pos..]
			Wend
			
			Return out
		End
		
		Function getFileName:String(path:String)
			Return getPath(path)
		End
		
		Function vibrate:Void()
			If (GlobalResource.vibrationConfig = 1) Then
				MFDevice.vibrateByTime(100)
			EndIf
		End
		
		Function drawScaleAni:Void(g:MFGraphics, drawer:AnimationDrawer, id:Int, x:Int, y:Int, scalex:Float, scaley:Float, pointx:Float, pointy:Float)
			drawer.setActionId(id)
			
			Local g2:= g.getSystemGraphics()
			
			g2.save()
			
			g2.translate(Float(x), Float(y))
			g2.scale(scalex, scaley, pointx, pointy)
			
			drawer.draw(g, 0, 0)
			
			g2.scale(1.0 / scalex, 1.0 / scaley)
			g2.translate(Float(-x), Float(-y))
			
			g2.restore()
		End
End