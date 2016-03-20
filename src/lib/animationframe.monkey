Strict

Public

' Friends:
Friend lib.animation
Friend lib.animationaction
Friend lib.animationimageinfo

' Imports:
Private
	#Rem
		Import mflib.bpdef
		Import sonicgba.gimmickobject
		Import special.ssdef
		Import special.specialobject
		Import state.titlestate
	#End
	
	Import lib.myapi
	
	Import lib.animation
	Import lib.animationaction
	
	Import com.sega.mobile.framework.device.mfdevice
	'Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import brl.stream
	
	Import regal.typetool
Public

' Classes:
private Class Frame
	private Int color
	private Short frameHeight
	private Short frameWidth
	private Int[] functionID
	private Animation m_Ani
	private Short[][] m_ClipInfo
	private Short m_img_cx
	private Short m_img_cy
	private Byte m_nClips
	private Byte[] rect1
	private Byte[] rect2
	private Byte[] tmp_rect1
	private Byte[] tmp_rect2

	Public Method Frame:public(ani:Animation)
		Self.m_Ani = ani
		Self.rect1 = New Byte[4]
		Self.rect2 = New Byte[4]
		Self.tmp_rect1 = New Byte[4]
		Self.tmp_rect2 = New Byte[4]
		Self.frameWidth = (Short) -1
		Self.frameHeight = (Short) -1
	End

	Public Method GetARect:Byte[]()
		
		If (Self.rect1[0] = Null And Self.rect1[1] = Null And Self.rect1[2] = (Byte) 1 And Self.rect1[3] = (Byte) 1) Then
			Return Null
		EndIf
		
		For (Int i = 0; i < 4; i += 1)
			Self.tmp_rect1[i] = Self.rect1[i]
		EndIf
		Return Self.tmp_rect1
	End

	Public Method GetCRect:Byte[]()
		
		If (Self.rect2[0] = Null And Self.rect2[1] = Null And Self.rect2[2] = (Byte) 1 And Self.rect2[3] = (Byte) 1) Then
			Return Null
		EndIf
		
		For (Int i = 0; i < 4; i += 1)
			Self.tmp_rect2[i] = Self.rect2[i]
		EndIf
		Return Self.tmp_rect2
	End

	Public Method LoadFrame:Void(in:InputStream)
		
		If (in <> Null) Then
			try {
				in.read(Self.rect1, 0, 4)
				in.read(Self.rect2, 0, 4)
				Self.m_nClips = in.ReadByte()
				Self.m_ClipInfo = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{Self.m_nClips, 5})
				Self.functionID = New Int[Self.m_nClips]
				Byte i = (Byte) 0
				While (i < Self.m_nClips) {
					Short[] sArr
					Int j = 0
					While (j < 4) {
						Self.m_ClipInfo[i][j] = in.ReadByte()
						
						If (j > 1 And Self.m_ClipInfo[i][j] < (Short) 0) Then
							sArr = Self.m_ClipInfo[i]
							sArr[j] = (Short) (sArr[j] + 256)
						EndIf
						
						j += 1
					EndIf
					Self.m_ClipInfo[i][4] = (Short) 0
					Int tmp_attr = (Short) (Self.m_ClipInfo[i][3] Shl 8)
					
					If (tmp_attr = MFGamePad.KEY_NUM_7 Or tmp_attr = 28672) Then
						sArr = Self.m_ClipInfo[i]
						sArr[0] = (Short) (sArr[0] - 1)
					ElseIf (tmp_attr = MFGamePad.KEY_NUM_8 Or tmp_attr = MFGamePad.KEY_NUM_6) Then
						sArr = Self.m_ClipInfo[i]
						sArr[1] = (Short) (sArr[1] - 1)
					ElseIf (tmp_attr = 24576) Then
						sArr = Self.m_ClipInfo[i]
						sArr[0] = (Short) (sArr[0] - 1)
						sArr = Self.m_ClipInfo[i]
						sArr[1] = (Short) (sArr[1] - 1)
					ElseIf (tmp_attr = 12288 Or tmp_attr = 12288) Then
						sArr = Self.m_ClipInfo[i]
						sArr[0] = (Short) (sArr[0] - 1)
						sArr = Self.m_ClipInfo[i]
						sArr[1] = (Short) (sArr[1] - 1)
					EndIf
					
					If (Animation.Self.isDoubleScale) Then
						Self.m_ClipInfo[i][0] = (Short) (Self.m_ClipInfo[i][0] Shl 1)
						Self.m_ClipInfo[i][1] = (Short) (Self.m_ClipInfo[i][1] Shl 1)
					} Else {
						Self.m_ClipInfo[i][0] = Self.m_ClipInfo[i][0]
						Self.m_ClipInfo[i][1] = Self.m_ClipInfo[i][1]
					EndIf
					
					i += 1
				EndIf
				Return
			} catch (Exception e) {
				e.printStackTrace()
				Return
			EndIf
		EndIf
		
		Self.m_nClips = (Byte) 1
		Self.m_ClipInfo = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{1, 4})
		Self.m_ClipInfo[0][0] = (Short) 0
		Self.m_ClipInfo[0][1] = (Short) 0
		Self.m_ClipInfo[0][2] = (Short) 0
		Self.m_ClipInfo[0][3] = (Short) 0
	End

	Public Method loadFrameG2:Void(ds:Stream)
		Self.m_nClips = ds.ReadByte()
		Self.m_ClipInfo = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{Self.m_nClips, 5})
		Self.functionID = New Int[Self.m_nClips]
		For (Byte i = (Byte) 0; i < Self.m_nClips; i += 1)
			Self.functionID[i] = ds.ReadByte()
			Short[] sArr
			Select (Self.functionID[i])
				Case TitleState.STAGE_SELECT_KEY_RECORD_1
					Self.m_ClipInfo[i][4] = ds.ReadByte()
					Self.m_ClipInfo[i][2] = ds.ReadByte()
					Self.m_ClipInfo[i][3] = ds.ReadByte()
					Self.m_ClipInfo[i][3] = (Short) (Self.m_ClipInfo[i][3] Shl 4)
					
					If (Self.m_ClipInfo[i][4] < (Short) 0) Then
						sArr = Self.m_ClipInfo[i]
						sArr[4] = (Short) (sArr[4] + 256)
					EndIf
					
					If (Self.m_ClipInfo[i][2] < (Short) 0) Then
						sArr = Self.m_ClipInfo[i]
						sArr[2] = (Short) (sArr[2] + 256)
					EndIf
					
					Self.m_ClipInfo[i][0] = ds.ReadShort()
					Self.m_ClipInfo[i][1] = ds.ReadShort()
					
					If (Not Animation.isFrameWanted) Then
						break
					EndIf
					
					Int j = 0
					While (j < Animation.imageIdArray.Length) {
						
						If (Animation.imageIdArray[j] <> -1) Then
							If (Animation.imageIdArray[j] = Self.m_ClipInfo[i][4]) Then
								break
							EndIf
							
							j += 1
						} Else {
							Animation.imageIdArray[j] = Self.m_ClipInfo[i][4]
							break
						EndIf
					EndIf
					break
				Case TitleState.STAGE_SELECT_KEY_RECORD_2
					Self.m_ClipInfo[i][2] = ds.ReadShort()
					Self.m_ClipInfo[i][3] = ds.ReadShort()
					Self.color = 0
					Self.color |= (ds.ReadByte() Shl 16) & 16711680
					Self.color |= (ds.ReadByte() Shl 8) & 65280
					Self.color |= (ds.ReadByte() Shl 0) & 255
					Self.m_ClipInfo[i][0] = ds.ReadShort()
					Self.m_ClipInfo[i][1] = ds.ReadShort()
					break
				Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
					Self.m_ClipInfo[i][2] = ds.ReadShort()
					Self.m_ClipInfo[i][3] = ds.ReadShort()
					Self.color = 0
					Self.color |= (ds.ReadByte() Shl 16) & 16711680
					Self.color |= (ds.ReadByte() Shl 8) & 65280
					Self.color |= (ds.ReadByte() Shl 0) & 255
					Self.m_ClipInfo[i][0] = ds.ReadShort()
					Self.m_ClipInfo[i][1] = ds.ReadShort()
					break
				Case SSDef.SSOBJ_BNLD_ID
					Self.m_ClipInfo[i][2] = ds.ReadByte()
					Self.m_ClipInfo[i][3] = ds.ReadByte()
					
					If (Self.m_ClipInfo[i][3] < (Short) 0) Then
						sArr = Self.m_ClipInfo[i]
						sArr[3] = (Short) (sArr[3] + 256)
					EndIf
					
					Self.m_ClipInfo[i][0] = ds.ReadShort()
					Self.m_ClipInfo[i][1] = ds.ReadShort()
					break
				Default
					break
			EndIf
		EndIf
	End

	Public Method getWidth:Int()
		
		If (Self.m_nClips <= Null) Then
			Return 0
		EndIf
		
		Int xLeft = crlFP32.MAX_VALUE
		Int xRight = Integer.MIN_VALUE
		For (Byte i = (Byte) 0; i < Self.m_nClips; i += 1)
			
			If (Self.m_ClipInfo[i][0] < xLeft) Then
				xLeft = Self.m_ClipInfo[i][0]
			EndIf
			
			Short[][] clipArray = Animation.Self.imageInfo[Self.m_ClipInfo[i][4]].getClips()
			Int widthId = 2
			
			If ((((Short) (Self.m_ClipInfo[i][3] Shl 8)) & MFGamePad.KEY_NUM_6) <> 0) Then
				widthId = 3
			EndIf
			
			If (clipArray[Self.m_ClipInfo[i][2]][widthId] + Self.m_ClipInfo[i][0] > xRight) Then
				xRight = clipArray[Self.m_ClipInfo[i][2]][widthId] + Self.m_ClipInfo[i][0]
			EndIf
		EndIf
		Self.frameWidth = (Short) Abs(xRight - xLeft)
		
		If (Animation.Self.isDoubleScale) Then
			Self.frameWidth = (Short) (Self.frameWidth Shl 1)
		EndIf
		
		Return Self.frameWidth
	End

	Public Method getHeight:Int()
		
		If (Self.m_nClips <= Null) Then
			Return 0
		EndIf
		
		Int yTop = crlFP32.MAX_VALUE
		Int yBottom = Integer.MIN_VALUE
		For (Byte i = (Byte) 0; i < Self.m_nClips; i += 1)
			
			If (Self.m_ClipInfo[i][1] < yTop) Then
				yTop = Self.m_ClipInfo[i][1]
			EndIf
			
			Short[][] clipArray = Animation.Self.imageInfo[Self.m_ClipInfo[i][4]].getClips()
			Int heightId = 3
			
			If ((((Short) (Self.m_ClipInfo[i][3] Shl 8)) & MFGamePad.KEY_NUM_6) <> 0) Then
				heightId = 2
			EndIf
			
			If (clipArray[Self.m_ClipInfo[i][2]][heightId] + Self.m_ClipInfo[i][1] > yBottom) Then
				yBottom = clipArray[Self.m_ClipInfo[i][2]][heightId] + Self.m_ClipInfo[i][1]
			EndIf
		EndIf
		Self.frameHeight = (Short) Abs(yBottom - yTop)
		
		If (Animation.Self.isDoubleScale) Then
			Self.frameHeight = (Short) (Self.frameHeight Shl 1)
		EndIf
		
		Return Self.frameHeight
	End

	Public Method SetClips:Void(clip:Short[][])
	End

	Public Method Draw:Void(g:MFGraphics, x:Int, y:Int, attr:Short)
		
		If (Self.m_nClips <> Null) Then
			For (Byte i = (Byte) 0; i < Self.m_nClips; i += 1)
				Select (Self.functionID[i])
					Case TitleState.STAGE_SELECT_KEY_RECORD_1
						
						If (Not Animation.Self.isDoubleScale) Then
							DrawImage(g, i, x, y, attr)
							break
						EndIf
						
						g.saveCanvas()
						g.translateCanvas(x, y)
						g.scaleCanvas(0.5f, 0.5f)
						DrawImage(g, i, 0, 0, attr)
						g.restoreCanvas()
						break
					Case TitleState.STAGE_SELECT_KEY_RECORD_2
						fillRect(g, i, x, y, attr)
						break
					Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
						drawRect(g, i, x, y, attr)
						break
					Case SSDef.SSOBJ_BNLD_ID
						try {
							Int tmp_x = Self.m_ClipInfo[i][0]
							Int tmp_y = Self.m_ClipInfo[i][1]
							
							If (Not Animation.Self.isDoubleScale) Then
								Animation.Self.qiAnimationArray[Self.m_ClipInfo[i][2]].m_Frames[Self.m_ClipInfo[i][3]].Draw(g, x + tmp_x, y + tmp_y, attr)
								break
							EndIf
							
							g.saveCanvas()
							g.translateCanvas(x + tmp_x, y + tmp_y)
							g.scaleCanvas(0.5f, 0.5f)
							Animation.Self.qiAnimationArray[Self.m_ClipInfo[i][2]].m_Frames[Self.m_ClipInfo[i][3]].Draw(g, 0, 0, attr)
							g.restoreCanvas()
							break
						} catch (Exception e) {
							Print(New StringBuilder(String.valueOf(Self.m_ClipInfo[i][3])).append("is out of bounds").toString())
							break
						EndIf
					Default
						break
				EndIf
			EndIf
		EndIf
		
	End

	Public Method DrawImage:Void(g:MFGraphics, i:Int, x:Int, y:Int, attr:Short)
		
		If (Self.m_nClips <> Null) Then
			MFImage image = Animation.Self.imageInfo[Self.m_ClipInfo[i][4]].getImage()
			Short[] m_Clips_2 = Animation.Self.imageInfo[Self.m_ClipInfo[i][4]].getClips()[Self.m_ClipInfo[i][2]]
			Short draw_attr = attr
			Int tmp_attr = (Short) (Self.m_ClipInfo[i][3] Shl 8)
			Int tmp_x = Self.m_ClipInfo[i][0]
			Int tmp_y = Self.m_ClipInfo[i][1]
			Int tmp
			Select (getMIDPTransId(attr))
				Case TitleState.STAGE_SELECT_KEY_RECORD_2
					tmp_y = (-tmp_y) - m_Clips_2[3]
					break
				Case TitleState.STAGE_SELECT_KEY_DIRECT_PLAY
					tmp_x = (-tmp_x) - m_Clips_2[2]
					break
				Case SpecialObject.Z_ZOOM
					tmp_x = (-tmp_x) - m_Clips_2[2]
					tmp_y = (-tmp_y) - m_Clips_2[3]
					break
				Case TitleState.CHARACTER_RECORD_BG_SPEED
					tmp = tmp_x
					tmp_x = tmp_y
					tmp_y = tmp
					break
				Case SSDef.SSOBJ_BNRU_ID
					tmp = tmp_x
					tmp_x = (-tmp_y) - m_Clips_2[3]
					tmp_y = tmp
					break
				Case SSDef.SSOBJ_BNLD_ID
					tmp = tmp_x
					tmp_x = tmp_y
					tmp_y = (-tmp) - m_Clips_2[2]
					break
				Case SSDef.SSOBJ_BNRD_ID
					tmp = tmp_x
					tmp_x = (-tmp_y) - m_Clips_2[3]
					tmp_y = (-tmp) - m_Clips_2[2]
					break
			EndIf
			Int original_attr = tmp_attr
			tmp_attr ~= draw_attr
			
			If ((tmp_attr & MFGamePad.KEY_NUM_6) <> 0) Then
				If ((((original_attr & MFGamePad.KEY_NUM_7) <> 0 ? 1 : 0) ~ ((original_attr & MFGamePad.KEY_NUM_8) <> 0 ? 1 : 0)) <> 0) Then
					tmp_attr ~= 24576
				EndIf
				
			ElseIf (Not ((original_attr & MFGamePad.KEY_NUM_6) = 0 Or (draw_attr & MFGamePad.KEY_NUM_6) = 0)) Then
				tmp_attr ~= 24576
			EndIf
			
			Const.DrawImage(g, tmp_x + x, tmp_y + y, image, m_Clips_2[0], m_Clips_2[1], m_Clips_2[2], m_Clips_2[3], tmp_attr)
		EndIf
		
	End

	Private Method fillRect:Void(g:MFGraphics, i:Int, iX:Int, iY:Int, attr:Int)
		Int x = Self.m_ClipInfo[i][0]
		Int y = Self.m_ClipInfo[i][1]
		
		If ((attr & MFGamePad.KEY_NUM_7) > 0) Then
			x = ((-x) - Self.m_ClipInfo[i][2]) + 1
		EndIf
		
		If ((attr & MFGamePad.KEY_NUM_8) > 0) Then
			y = ((-y) - Self.m_ClipInfo[i][3]) + 1
		EndIf
		
		Int colorBack = g.getColor()
		g.setColor(Self.color)
		g.fillRect(iX + x, iY + y, Self.m_ClipInfo[i][2], Self.m_ClipInfo[i][3])
		g.setColor(colorBack)
	End

	Private Method drawRect:Void(g:MFGraphics, i:Int, iX:Int, iY:Int, attr:Int)
		Int x = Self.m_ClipInfo[i][0]
		Int y = Self.m_ClipInfo[i][1]
		
		If ((attr & MFGamePad.KEY_NUM_7) > 0) Then
			x = ((-x) - Self.m_ClipInfo[i][2]) + 1
		EndIf
		
		If ((attr & MFGamePad.KEY_NUM_8) > 0) Then
			y = ((-y) - Self.m_ClipInfo[i][3]) + 1
		EndIf
		
		Int colorBack = g.getColor()
		g.setColor(Self.color)
		g.fillRect(iX + x, iY + y, Self.m_ClipInfo[i][2], Self.m_ClipInfo[i][3])
		g.setColor(colorBack)
	End

	Private Method getMIDPTransId:Int(tmp_attr:Int)
		Int attr = 0
		
		If ((tmp_attr & MFGamePad.KEY_NUM_6) <> 0) Then
			attr = 0 | 6
			
			If ((tmp_attr & MFGamePad.KEY_NUM_7) <> 0) Then
				attr ~= 1
			EndIf
			
			If ((tmp_attr & MFGamePad.KEY_NUM_8) <> 0) Then
				Return attr ~ 2
			EndIf
			
			Return attr
		EndIf
		
		If ((tmp_attr & MFGamePad.KEY_NUM_7) <> 0) Then
			attr = 0 | 2
		EndIf
		
		If ((tmp_attr & MFGamePad.KEY_NUM_8) <> 0) Then
			Return attr | 1
		EndIf
		
		Return attr
	End
End