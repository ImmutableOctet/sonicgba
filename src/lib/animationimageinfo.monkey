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
	Import regal.byteorder
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
		
		Method New(image:MFImage, copy:Bool=False)
			setImage(image, copy)
		End
		
		Method New(imageFileName:String)
			Self.img_clip = MFImage.createImage(imageFileName) ' setImage(...)
		End
		
		' Methods:
		Method InitializeClips:Short[][](nSize:Int) ' Void
			Self.m_Clips = New Short[nSize][]
			
			For Local i:= 0 Until nSize
				Self.m_Clips[i] = New Short[CLIP_DATA_SIZE]
			Next
			
			Return Self.m_Clips
		End
		
		' Extensions:
		
		' This method is unsafe if 'img_clip' already exists.
		' Please call 'releaseImage' before using this, or call 'setImage_safe'.
		Method setImage:Void(image:MFImage, copy:Bool=False)
			If (copy) Then
				Self.img_clip = MFImage.cloneImage(image)
			Else
				Self.img_clip = image
			EndIf
		End
		
		Method releaseImage:Bool()
			If (MFImage.releaseImage(Self.img_clip)) Then
				Self.img_clip = Null ' setImage(...)
				
				Return True
			EndIf
			
			Return False
		End
		
		Method releaseSeparatedImages:Void(clearArray:Bool=True) ' False
			Local len:= Self.imageSeperate.Length
			
			If (len > 0) Then
				For Local i:= 0 Until len
					If (MFImage.releaseImage(Self.imageSeperate[i])) Then
						If (clearArray) Then
							Self.imageSeperate[i] = Null
						EndIf
					EndIf
				Next
				
				Self.imageSeperate = []
			EndIf
		End
	Protected
		' Methods:
		
		' Extensions:
		Method setImage_safe:Bool(image:MFImage, copy:Bool=False)
			If (Self.img_clip = Null Or releaseImage()) Then
				setImage(image, copy)
				
				Return True
			EndIf
			
			Return False
		End
	Public
		' Methods:
		
		' Extensions:
		Method loadInfo_loadClips:Void(ds:Stream, regular_byteorder:Bool)
			Self.m_nClips = ds.ReadByte()
			
			If (Self.m_nClips < 0) Then
				Self.m_nClips = Short(Self.m_nClips + UOCTET_MAX_POSITIVE_NUMBERS)
			EndIf
			
			InitializeClips(Self.m_nClips)
			
			For Local i:= 0 Until Self.m_nClips
				For Local j:= 0 Until CLIP_DATA_SIZE
					Local coord:= ds.ReadShort()
					
					If (Not regular_byteorder) Then
						coord = NToHS_S(coord)
					EndIf
					
					If (coord < 0) Then
						coord += USHORT_MAX_POSITIVE_NUMBERS
					EndIf
					
					Self.m_Clips[i][j] = coord
				Next
			Next
		End
		
		Method close:Void()
			releaseImage()
			releaseSeparatedImages()
		End

		Method loadInfo:Void(ds:Stream, allow_img:Bool)
			If (ds = Null) Then
				Self.m_nClips = 1
				
				InitializeClips(Self.m_nClips)
				
				For Local i:= 0 Until Self.m_nClips ' 1
					Local clip:= Self.m_Clips[i]
					
					clip[0] = 0
					clip[1] = 0
					
					clip[2] = Short(Self.img_clip.getWidth() & USHORT_MAX)
					clip[3] = Short(Self.img_clip.getHeight() & USHORT_MAX)
				Next
				
				Return
			EndIf
			
			loadInfo_loadClips(ds, Not allow_img)
			
			If (Not allow_img) Then
				Local fileNameLen:= ds.ReadShort()
				
				Local fileName:= ds.ReadString(fileNameLen, "utf8")
				
				If (Animation.isImageWanted) Then
					Local tmpFileName:= MyAPI.getFileName(fileName)
					
					Local img:= MFImage.createImage(Animation.tmpPath + tmpFileName)
					 
					setImage_safe(img, False)
					
					Print("image fileName:" + tmpFileName)
				EndIf
			EndIf
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
			
			releaseImage()
		End
		
		Method getSeparateImage:MFImage(id:Int)
			Return Self.imageSeperate[id]
		End
End