Strict

Public

' Friends:
Friend lib.animation
Friend lib.animationaction
Friend lib.animationframe

' Imports:
Private
	Import lib.myapi
	
	Import lib.animation
	Import lib.animationaction
	Import lib.animationframe
	Import lib.constutil
	
	Import com.sega.mobile.framework.device.mfdevice
	'Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import brl.stream
	Import brl.datastream
	
	Import regal.typetool
Public

' Classes:
Class ImageInfo
	Private
		' Constant variable(s):
		Const CLIP_DATA_SIZE:= 4
		
		' Fields:
		Field imageSeperate:MFImage[]
		Field m_Clips:Short[][]
		Field m_nClips:Short
	Protected
		' Fields:
		Field img_clip:MFImage
	Private
		' Constructor(s):
		Method New()
			' Nothing so far.
		End
		
		Method New(image:MFImage)
			Self.img_clip = image
		End
		
		Method New(imageFileName:String)
			Self.img_clip = MFImage.createImage(imageFileName)
		End
		
		' Methods:
		Method InitializeClips:Short[][](nSize:Int)
			Self.m_Clips = New Short[nSize][]
			
			For Local i:= 0 Until nSize
				Self.m_Clips[i] = New Short[CLIP_DATA_SIZE]
			Next
		End
	Public
		' Methods:
		Method close:Void()
			Self.img_clip = Null
			
			If (Self.imageSeperate <> Null) Then
				For Local i:= 0 Until Self.imageSeperate.Length
					Self.imageSeperate[i] = Null
				Next
			EndIf
			
			Self.imageSeperate = Null
		End

		Method loadInfo:Void(ds:Stream)
			Self.m_nClips = ds.ReadByte()
			
			If (Self.m_nClips < 0) Then
				Self.m_nClips = Short(Self.m_nClips + UOCTET_MAX_POSITIVE_NUMBERS)
			EndIf
			
			InitializeClips(Self.m_nClips)
			
			For Local i:= 0 Until Self.m_nClips
				For Local j:= 0 Until CLIP_DATA_SIZE
					Self.m_Clips[i][j] = ds.ReadShort()
				Next
			Next
			
			Local fileNameLen:= ds.ReadShort()
			Local fileName:= ds.ReadString(fileNameLen, "utf8")
			
			If (Animation.isImageWanted) Then
				Local tmpFileName:= MyAPI.getFileName(fileName)
				
				Self.img_clip = MFImage.createImage(Animation.tmpPath + tmpFileName)
				
				Print("image fileName:" + tmpFileName)
			EndIf
		End
		
		Method loadInfo:Void(ds:DataStream)
			If (ds = Null) Then
				Self.m_nClips = 1
				
				InitializeClips(Self.m_nClips)
				
				For Local i:= 0 Until Self.m_nClips
					Self.m_Clips[i][0] = 0
					Self.m_Clips[i][1] = 0
					Self.m_Clips[i][2] = Short(Self.img_clip.getWidth() & USHORT_MAX)
					Self.m_Clips[i][3] = Short(Self.img_clip.getHeight() & USHORT_MAX)
				Next
				
				Return
			EndIf
			
			Self.m_nClips = ds.ReadByte()
			
			If (Self.m_nClips < 0) Then
				Self.m_nClips = Short(Self.m_nClips + UOCTET_MAX_POSITIVE_NUMBERS)
			EndIf
			
			InitializeClips(Self.m_nClips)
			
			For Local i:= 0 Until Self.m_nClips
				For Local j:= 0 Until CLIP_DATA_SIZE
					Self.m_Clips[i][j] = ds.ReadShort()
				Next
			Next
		End
		
		Method getImage:MFImage()
			Return Self.img_clip
		End
	
		Method getClips:Short[][]()
			Return Self.m_Clips
		End

		Method doubleParam:Void()
			For Local i:= 0 Until Self.m_nClips
				For Local j:= 0 Until CLIP_DATA_SIZE
					Self.m_Clips[i][j] = Short(Self.m_Clips[i][j] Shl 1) ' * 2
				Next
			Next
		End
		
		Method separateImage:Void()
			Self.imageSeperate = New MFImage[Self.m_nClips]
			
			For Local i:= 0 Until Self.m_nClips
				Self.imageSeperate[i] = MFImage.createImage(Self.img_clip, Self.m_Clips[i][0], Self.m_Clips[i][1], Self.m_Clips[i][2], Self.m_Clips[i][3], 0)
				
				Self.m_Clips[i][0] = 0
				Self.m_Clips[i][1] = 0
			Next
			
			Self.img_clip = Null
		End
		
		Method getSeparateImage:MFImage(id:Int)
			Return Self.imageSeperate[id]
		End
End