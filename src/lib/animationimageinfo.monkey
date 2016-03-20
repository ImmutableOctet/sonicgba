Strict

Public

' Friends:
Friend lib.animation
Friend lib.animationaction
Friend lib.animationframe

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
Class ImageInfo
	private MFImage[] imageSeperate
	protected MFImage img_clip
	private Short[][] m_Clips
	private Short m_nClips

	Private Method ImageInfo:private()
	End

	Private Method ImageInfo:private(image:MFImage)
		Self.img_clip = image
	End

	Private Method ImageInfo:private(imageFileName:String)
		try {
			Self.img_clip = MFImage.createImage(imageFileName)
		} catch (Throwable th) {
			th.printStackTrace()
		EndIf
	End

	Public Method close:Void()
		Self.img_clip = Null
		
		If (Self.imageSeperate <> Null) Then
			For (Int i = 0; i < Self.imageSeperate.Length; i += 1)
				Self.imageSeperate[i] = Null
			EndIf
		EndIf
		
		Self.imageSeperate = Null
	End

	Public Method loadInfo:Void(ds:Stream)
		Self.m_nClips = ds.ReadByte()
		
		If (Self.m_nClips < (Short) 0) Then
			Self.m_nClips = (Short) (Self.m_nClips + 256)
		EndIf
		
		Self.m_Clips = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{Self.m_nClips, 4})
		For (Short i = (Short) 0; i < Self.m_nClips; i += 1)
			For (Int j = 0; j < 4; j += 1)
				Self.m_Clips[i][j] = ds.ReadShort()
			EndIf
		EndIf
		String fileName = ds.readUTF()
		
		If (Animation.isImageWanted) Then
			String tmpFileName = MyAPI.getFileName(fileName)
			Self.img_clip = MFImage.createImage(Animation.tmpPath + tmpFileName)
			Print("image fileName:" + tmpFileName)
		EndIf
		
	End

	Public Method loadInfo:Void(ds:Stream)
		Short i
		
		If (ds = Null) Then
			Self.m_nClips = (Short) 1
			Self.m_Clips = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{Self.m_nClips, 4})
			For (i = (Short) 0; i < Self.m_nClips; i += 1)
				Self.m_Clips[i][0] = (Short) 0
				Self.m_Clips[i][1] = (Short) 0
				Self.m_Clips[i][2] = (Short) (Self.img_clip.getWidth() & 65535)
				Self.m_Clips[i][3] = (Short) (Self.img_clip.getHeight() & 65535)
			EndIf
			Return
		EndIf
		
		Self.m_nClips = (Byte) ds.ReadByte()
		
		If (Self.m_nClips < (Short) 0) Then
			Self.m_nClips = (Short) (Self.m_nClips + 256)
		EndIf
		
		Self.m_Clips = (Short[][]) Array.newInstance(Short.TYPE, New Int[]{Self.m_nClips, 4})
		For (i = (Short) 0; i < Self.m_nClips; i += 1)
			For (Int j = 0; j < 4; j += 1)
				Self.m_Clips[i][j] = Const.ReadShort(ds)
			EndIf
		EndIf
	End

	Public Method getImage:MFImage()
		Return Self.img_clip
	End

	Public Method getClips:Short[][]()
		Return Self.m_Clips
	End

	Public Method doubleParam:Void()
		For (Short i = (Short) 0; i < Self.m_nClips; i += 1)
			For (Int j = 0; j < 4; j += 1)
				Self.m_Clips[i][j] = (Short) (Self.m_Clips[i][j] Shl 1)
			EndIf
		EndIf
	End

	Public Method separateImage:Void()
		Self.imageSeperate = New MFImage[Self.m_nClips]
		For (Short i = (Short) 0; i < Self.m_nClips; i += 1)
			Self.imageSeperate[i] = MFImage.createImage(Self.img_clip, Self.m_Clips[i][0], Self.m_Clips[i][1], Self.m_Clips[i][2], Self.m_Clips[i][3], 0)
			Self.m_Clips[i][0] = (Short) 0
			Self.m_Clips[i][1] = (Short) 0
		EndIf
		Self.img_clip = Null
	End

	Public Method getSeparateImage:MFImage(id:Int)
		Return Self.imageSeperate[id]
	End
End