Strict

Public

' Friends:
Friend lib.animation
Friend lib.animationframe
Friend lib.animationimageinfo

' Imports:
Private
	Import lib.myapi
	
	Import lib.animation
	Import lib.animationframe
	Import lib.animationimageinfo
	Import lib.constutil
	
	Import com.sega.mobile.framework.device.mfdevice
	'Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import brl.stream
	
	Import regal.typetool
Public

' Classes:
Class Action
	Private
		' Constant variable(s):
		Const FRAME_DATA_SIZE:= 2
		
		' Fields:
		Field m_CurFrame:Short
		
		'Field img_clip:MFImage
		
		' This may be replaced with a 'DataBuffer' at a later date.
		Field m_FrameInfo:Byte[][]
		
		Field m_Timer:Short
		Field m_nFrames:Short
		
		Field m_OldFrame:Byte
		
		Field m_bLoop:Bool
		Field m_bPause:Bool
		
		' Methods:
		Method InitializeFrameInfo:Byte[][](nFrames:Int) ' Void
			Self.m_FrameInfo = New Byte[nFrames][]
			
			For Local i:= 0 Until Self.m_nFrames ' Self.m_FrameInfo.Length
				Self.m_FrameInfo[i] = New Byte[FRAME_DATA_SIZE]
			Next
			
			Return Self.m_FrameInfo
		End
	Protected
		' Fields:
		Field m_Ani:Animation
	Public
		' Constructor(s):
		Method New(ani:Animation)
			Self.m_Ani = ani
			
			Self.m_Timer = 0
			Self.m_CurFrame = 0
			Self.m_OldFrame = 0
			
			Self.m_bLoop = True
		End
		
		' Methods:
		Method SetLoop:Void(loop:Bool)
			Self.m_bLoop = loop
		End
		
		Method GetLoop:Bool()
			Return Self.m_bLoop
		End
		
		Method GetTempFrame:Int()
			Local tmpFrame:= Self.m_FrameInfo[Self.m_CurFrame][0]
			
			If (tmpFrame < 0) Then
				tmpFrame += UOCTET_MAX_POSITIVE_NUMBERS
			EndIf
			
			Return tmpFrame
		End
		
		Method GetARect:Byte[]()
			If (Self.m_nFrames = 0) Then
				Return []
			EndIf
			
			Return Self.m_Ani.m_Frames[GetTempFrame()].GetARect()
		End
		
		Method GetCRect:Byte[]()
			If (Self.m_nFrames = 0) Then
				Return []
			EndIf
			
			Return Self.m_Ani.m_Frames[GetTempFrame()].GetCRect()
		End
		
		Method JumpFrame:Void(frame:Byte)
			If (frame < Self.m_nFrames) Then
				Self.m_Timer = 0
				Self.m_CurFrame = frame
			EndIf
		End
		
		Method GetFrameNo:Short()
			Return Self.m_CurFrame
		End
		
		Method LoadAction:Void(in:Stream)
			Self.m_nFrames = in.ReadByte()
			
			If (Self.m_nFrames < 0) Then
				Self.m_nFrames = (Self.m_nFrames + UOCTET_MAX_POSITIVE_NUMBERS)
			EndIf
			
			InitializeFrameInfo(Self.m_nFrames)
			
			For Local i:= 0 Until Self.m_nFrames
				For Local j:= 0 Until FRAME_DATA_SIZE
					Self.m_FrameInfo[i][j] = in.ReadByte()
				Next
			Next
		End
		
		Method loadActionG2:Void(ds:Stream)
			Self.m_nFrames = ds.ReadByte()
			
			If (Self.m_nFrames < 0) Then
				Self.m_nFrames = (Self.m_nFrames + UOCTET_MAX_POSITIVE_NUMBERS)
			EndIf
			
			InitializeFrameInfo(Self.m_nFrames)
			
			For Local i:= 0 Until Self.m_nFrames
				For Local j:= 0 Until FRAME_DATA_SIZE
					Self.m_FrameInfo[i][j] = ds.ReadByte()
				Next
				
				ds.ReadShort()
				ds.ReadShort()
			Next
		End
		
		Method LoadAction:Void()
			Self.m_nFrames = 1
			
			InitializeFrameInfo(Self.m_nFrames)
			
			For Local i:= 0 Until Self.m_nFrames
				Self.m_FrameInfo[i][0] = 0
				Self.m_FrameInfo[i][1] = 100
			Next
		End
		
		Method IsEnd:Bool()
			If (Self.m_bLoop) Then
				Return False
			EndIf
			
			If (Self.m_Timer < Self.m_FrameInfo[Self.m_CurFrame][1] Or Self.m_CurFrame <> Self.m_nFrames - 1) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method SetFrames:Void(frames:Frame[])
			Self.m_Ani.m_Frames = frames
		End
	
		Method SetPause:Void(pause:Bool)
			Self.m_bPause = pause
		End
		
		Method Draw:Void(g:MFGraphics, x:Int, y:Int, attr:Short)
			If (Self.m_nFrames <> 0) Then
				Local tmpFrame:= Self.m_FrameInfo[Self.m_CurFrame][0]
				
				If (tmpFrame < 0) Then
					tmpFrame += UOCTET_MAX_POSITIVE_NUMBERS
				EndIf
				
				Self.m_Ani.m_Frames[tmpFrame].Draw(g, x, y, attr)
				
				If (Not Self.m_bPause) Then
					Self.m_Timer = Short(Self.m_Timer + 1)
					
					If (Self.m_Timer >= Self.m_FrameInfo[Self.m_CurFrame][1]) Then
						Self.m_CurFrame = Short(Self.m_CurFrame + 1)
						
						If (Self.m_CurFrame < Self.m_nFrames) Then
							Self.m_Timer = 0
						ElseIf (Self.m_bLoop) Then
							Self.m_Timer = 0
							Self.m_CurFrame = 0
						Else
							Self.m_CurFrame = (Self.m_nFrames - 1)
						EndIf
					EndIf
				EndIf
			EndIf
		End
		
		Method Draw:Void(g:MFGraphics, frame:Short, x:Int, y:Int, attr:Short)
			If (frame < Self.m_nFrames) Then
				Self.m_CurFrame = frame
				
				Local tmpFrame:= Self.m_FrameInfo[frame][0]
				
				If (tmpFrame < 0) Then
					tmpFrame += UOCTET_MAX_POSITIVE_NUMBERS
				EndIf
				
				Self.m_Ani.m_Frames[tmpFrame].Draw(g, x, y, attr)
			EndIf
		End
		
		Method SetFrame:Void(frame:Short)
			If (frame < Self.m_nFrames) Then
				Self.m_CurFrame = frame
			EndIf
		End
		
		Method getFrameNum:Int()
			Return Self.m_nFrames
		End
		
		Method isTimeOver:Bool(time:Int)
			If (Self.m_nFrames = 0) Then
				Return True
			EndIf
			
			Return (time >= Self.m_FrameInfo[Self.m_CurFrame][1])
		End
End