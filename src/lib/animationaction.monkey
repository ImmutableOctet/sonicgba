Strict

Public

' Friends:
Friend lib.animation
Friend lib.animationframe
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
	'Import lib.animationframe
	
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
		' Fields:
		Field img_clip:MFImage
		Field m_CurFrame:Short
		Field m_FrameInfo:Byte[][]
		Field m_OldFrame:Byte
		Field m_Timer:Short
		Field m_bLoop:Bool
		Field m_bPause:Bool
		Field m_nFrames:Short
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
				tmpFrame += 256
			EndIf
			
			Return tmpFrame
		End
		
		Method GetARect:Byte[]()
			If (Self.m_nFrames = 0) Then
				Return Null
			EndIf
			
			Return m_Ani.m_Frames[GetTempFrame()].GetARect()
		End
		
		Method GetCRect:Byte[]()
			If (Self.m_nFrames = 0) Then
				Return Null
			EndIf
			
			Return m_Ani.m_Frames[GetTempFrame()].GetCRect()
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
			Self.m_FrameInfo = (Byte[][]) Array.newInstance(Byte.TYPE, New Int[]{Self.m_nFrames, 2})
			
			For (Short i = (Short) 0; i < Self.m_nFrames; i += 1)
				For (Int j = 0; j < 2; j += 1)
					Self.m_FrameInfo[i][j] = in.ReadByte()
				Next
			EndIf
		End
	
	Public Method loadActionG2:Void(ds:Stream)
		Self.m_nFrames = ds.ReadByte()
		
		If (Self.m_nFrames < (Short) 0) Then
			Self.m_nFrames = (Short) (Self.m_nFrames + 256)
		EndIf
		
		Self.m_FrameInfo = (Byte[][]) Array.newInstance(Byte.TYPE, New Int[]{Self.m_nFrames, 2})
		For (Short i = (Short) 0; i < Self.m_nFrames; i += 1)
			For (Int j = 0; j < 2; j += 1)
				Self.m_FrameInfo[i][j] = ds.ReadByte()
			Next
			ds.ReadShort()
			ds.ReadShort()
		EndIf
	End
	
	Public Method LoadAction:Void()
		Self.m_nFrames = (Short) 1
		Self.m_FrameInfo = (Byte[][]) Array.newInstance(Byte.TYPE, New Int[]{Self.m_nFrames, 2})
		For (Short i = (Short) 0; i < Self.m_nFrames; i += 1)
			Self.m_FrameInfo[i][0] = (Byte) 0
			Self.m_FrameInfo[i][1] = GimmickObject.GIMMICK_DASH_PANEL_HIGH
		EndIf
	End
	
	Public Method IsEnd:Bool()
		
		If (Self.m_bLoop) Then
			Return False
		EndIf
		
		If (Self.m_Timer < Self.m_FrameInfo[Self.m_CurFrame][1] Or Self.m_CurFrame <> Self.m_nFrames - 1) Then
			Return False
		EndIf
		
		Return True
	End
	
	Public Method SetFrames:Void(frames:Frame[])
		Animation.Self.m_Frames = frames
	End
	
	Public Method SetPause:Void(pause:Bool)
		Self.m_bPause = pause
	End
	
	Public Method Draw:Void(g:MFGraphics, x:Int, y:Int, attr:Short)
		
		If (Self.m_nFrames <> (Short) 0) Then
			Int tmpFrame = Self.m_FrameInfo[Self.m_CurFrame][0]
			
			If (tmpFrame < 0) Then
				tmpFrame += 256
			EndIf
			
			Animation.Self.m_Frames[tmpFrame].Draw(g, x, y, attr)
			
			If (Not Self.m_bPause) Then
				Self.m_Timer = (Short) (Self.m_Timer + 1)
				
				If (Self.m_Timer >= Self.m_FrameInfo[Self.m_CurFrame][1]) Then
					Self.m_CurFrame = (Short) (Self.m_CurFrame + 1)
					
					If (Self.m_CurFrame < Self.m_nFrames) Then
						Self.m_Timer = (Short) 0
					ElseIf (Self.m_bLoop) Then
						Self.m_Timer = (Short) 0
						Self.m_CurFrame = (Short) 0
					} Else {
						Self.m_CurFrame = (Byte) (Self.m_nFrames - 1)
					EndIf
				EndIf
			EndIf
		EndIf
		
	End
	
	Public Method Draw:Void(g:MFGraphics, frame:Short, x:Int, y:Int, attr:Short)
		try {
			
			If (frame < Self.m_nFrames) Then
				Self.m_CurFrame = frame
				Int tmpFrame = Self.m_FrameInfo[frame][0]
				
				If (tmpFrame < 0) Then
					tmpFrame += 256
				EndIf
				
				Animation.Self.m_Frames[tmpFrame].Draw(g, x, y, attr)
			EndIf
			
		} catch (Exception e) {
			Print("frame:" + frame)
			Print("m_FrameInfo.Length:" + Self.m_FrameInfo.Length)
			Print("m_FrameInfo[frame][0]:" + Self.m_FrameInfo[frame][0])
			Print("m_Frames.Length:" + Animation.Self.m_Frames.Length)
		EndIf
	End
	
	Public Method SetFrame:Void(frame:Short)
		
		If (frame < Self.m_nFrames) Then
			Self.m_CurFrame = frame
		EndIf
		
	End
	
	Public Method getFrameNum:Int()
		Return Self.m_nFrames
	End
	
	Public Method isTimeOver:Bool(time:Int)
		
		If (Self.m_nFrames = (Short) 0) Then
			Return True
		EndIf
		
		Return time >= Self.m_FrameInfo[Self.m_CurFrame][1]
	End
End