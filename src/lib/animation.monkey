Strict

Public

' Friends:
Friend lib.animationdrawer
Friend lib.animationaction
Friend lib.animationframe
Friend lib.animationimageinfo

' Imports:
Private
	Import lib.myapi
	
	Import lib.animationdrawer
	
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
	Import lib.animationaction

' Classes:
Class Animation
	Private
		' Constant variable(s):
		Const SEPERATE_PNG:Bool = False
		Const TRANS_OFFSET:Int = 0
		
		' An array containing paths to atlases that are twice their normal size.
		Global DOUBLE_ANIMATION_NAME:String[] = ["chr_sonic", "chr_tails_01", "chr_tails_02", "chr_knuckles_01", "chr_knuckles_02", "chr_amy_01", "chr_amy_02"] ' Const
		
		' Global variable(s):
		Global animationInstance:Animation[]
		Global imageIdArray:Int[] = New Int[10]
		
		Global tmpPath:String = ""
		
		' Fields:
		Field m_Actions:Action[]
		Field m_CurAni:Int
		Field m_Frames:Frame[]
		Field m_OldAni:Int
		Field m_nActions:Int
		Field m_nFrames:Int
		Field qiAnimationArray:Animation[]
		Field imageInfo:ImageInfo[]
		Field isAnimationQi:Bool
	Protected
		' Fields:
		Field fileName:String
		Field refCount:Int
	Public
		' Global variable(s):
		Global isFrameWanted:Bool
		Global isImageWanted:Bool
		
		' Fields:
		Field isDoubleScale:Bool
	Private
		' Constructor(s):
		Method New()
			Self.isDoubleScale = False
			Self.isAnimationQi = False
			
			Self.m_CurAni = 0
			Self.m_OldAni = 0
			Self.refCount = 0
		End
	Public
		' Constructor(s):
		Method New(fileName:String)
			Self.isDoubleScale = False
			Self.isAnimationQi = False
			
			For Local name:= EachIn DOUBLE_ANIMATION_NAME
				If (fileName.EndsWith(name)) Then
					Self.isDoubleScale = True
					
					Exit
				EndIf
			Next
			
			Self.m_CurAni = 0
			Self.m_OldAni = 0
			Self.fileName = fileName
			
			SetClipImg(fileName + ".png")
			LoadAnimation(fileName + ".dat")
		End
		
		Method New(image:MFImage, fileName:String)
			Self.isDoubleScale = False
			Self.isAnimationQi = False
			
			For Local name:= EachIn DOUBLE_ANIMATION_NAME
				If (fileName.EndsWith(name)) Then
					Self.isDoubleScale = True
					
					Exit
				EndIf
			Next
			
			Self.m_CurAni = 0
			Self.m_OldAni = 0
			
			Self.fileName = fileName
			
			Self.imageInfo = New ImageInfo[1]
			Self.imageInfo[0] = New ImageInfo(Null)
			
			LoadAnimation(fileName + ".dat")
		End
	Protected
		' Methods / Destructor(s):
		Method close:Void()
			If (imageInfo.Length > 0) Then
				For Local I:= 0 Until imageInfo.Length
					If (imageInfo[I] <> Null) Then
						imageInfo[I].close()
						
						Self.imageInfo[I] = Null
					EndIf
				Next
			EndIf
			
			Self.imageInfo = []
		End
	Public
		' Methods:
		Method setImage:Void(image:MFImage, id:Int)
			Self.imageInfo[id].img_clip = image
		End
		
		Method SetCurAni:Void(no:Int)
			If (no >= Self.m_nActions) Then
				no = 0
			EndIf
			
			Self.m_CurAni = no
			
			If (Self.m_OldAni <> Self.m_CurAni) Then
				Self.m_OldAni = Self.m_CurAni
				
				Self.m_Actions[Self.m_CurAni].JumpFrame(0)
				Self.m_Actions[Self.m_CurAni].SetPause(False)
			EndIf
		End

		Method SetCurFrame:Void(frameId:Short)
			Self.m_Actions[Self.m_CurAni].SetFrame(frameId)
		End

		Method GetCurAni:Int()
			Return Self.m_CurAni
		End
	
		Method JumpFrame:Void(no:Byte)
			Self.m_Actions[Self.m_CurAni].JumpFrame(no)
		End
	
		Method GetFrameNo:Short()
			Return Self.m_Actions[Self.m_CurAni].GetFrameNo()
		End
	
		Method GetARect:Byte[]()
			Return Self.m_Actions[Self.m_CurAni].GetARect()
		End
	
		Method GetCRect:Byte[]()
			Return Self.m_Actions[Self.m_CurAni].GetCRect()
		End
	
		Method IsEnd:Bool()
			Return Self.m_Actions[Self.m_CurAni].IsEnd()
		End
	
		Method SetLoop:Void(loop:Bool)
			Self.m_Actions[Self.m_CurAni].SetLoop(loop)
		End
	
		Method SetPause:Void(pause:Bool)
			Self.m_Actions[Self.m_CurAni].SetPause(pause)
		End
		
		Method SetClipImg:Void(fn:String)
			Self.imageInfo = New ImageInfo[1]
			Self.imageInfo[0] = New ImageInfo(Null)
		End
		
		Method SetClipImg:Void(img:MFImage)
			Self.imageInfo = New ImageInfo[1]
			Self.imageInfo[0] = New ImageInfo(Null)
		End
		
		Method LoadAnimation:Void(fileName:String)
			Local in:= MFDevice.getResourceAsStream(fileName)
			
			LoadAnimation(in)
			
			If (in <> Null) Then
				in.Close()
			EndIf
		End
		
		Method LoadAnimation:Void(in:Stream)
			If (in <> Null) Then
				Self.imageInfo[0].loadInfo(in, True)
				
				Self.m_nFrames = in.ReadByte()
				
				If (Self.m_nFrames < 0) Then
					Self.m_nFrames += UOCTET_MAX_POSITIVE_NUMBERS
				EndIf
				
				Self.m_Frames = New Frame[Self.m_nFrames]
				
				For Local i:= 0 Until Self.m_nFrames
					Local frame:= New Frame(Self)
					
					frame.LoadFrame(in)
					frame.SetClips(Self.imageInfo[0].m_Clips)
					
					Self.m_Frames[i] = frame
				Next
				
				Self.m_nActions = in.ReadByte()
				
				If (Self.m_nActions < 0) Then
					Self.m_nActions += UOCTET_MAX_POSITIVE_NUMBERS
				EndIf
				
				Self.m_Actions = New Action[Self.m_nActions]
				
				For Local i:= 0 Until Self.m_nActions
					Self.m_Actions[i] = New Action(Self)
					Self.m_Actions[i].LoadAction(in)
					Self.m_Actions[i].SetFrames(Self.m_Frames)
				Next
				
				If (Self.isDoubleScale) Then
					Self.imageInfo[0].doubleParam()
				EndIf
				
				Return
			EndIf
			
			Self.m_nFrames = 1
			Self.m_Frames = New Frame[Self.m_nFrames]
			
			For Local i:= 0 Until Self.m_nFrames
				Self.m_Frames[i] = New Frame(Self)
				
				Self.m_Frames[i].LoadFrame(in)
				Self.m_Frames[i].SetClips(Self.imageInfo[0].m_Clips)
			Next
			
			Self.m_nActions = 1
			Self.m_Actions = New Action[Self.m_nActions]
			
			For Local i:= 0 Until Self.m_nActions
				Local action:= New Action(Self)
				
				action.LoadAction() ' ds
				action.SetFrames(Self.m_Frames)
				
				Self.m_Actions[i] = action
			Next
		End
	Private
		' Methods:
		Method LoadAnimationG2:Void(ds:Stream)
			Self.isAnimationQi = True
			
			Try
				Local __unknown:= ds.ReadInt()
				
				Self.m_nFrames = ds.ReadByte()
				
				If (Self.m_nFrames < 0) Then
					Self.m_nFrames += UOCTET_MAX_POSITIVE_NUMBERS
				EndIf
				
				Self.m_Frames = New Frame[Self.m_nFrames]
				
				For Local i:= 0 Until Self.m_nFrames
					Self.m_Frames[i] = New Frame(Self)
					Self.m_Frames[i].loadFrameG2(ds)
					
					Local rectarrays:= (ds.ReadByte() & 255)
					
					For Local k:= 0 Until rectarrays
						Local rectsNum:= (ds.ReadByte() & 255)
						
						For Local l:= 0 Until rectsNum
							Local __0:= ds.ReadShort()
							Local __1:= ds.ReadShort()
							Local __2:= ds.ReadShort()
							Local __3:= ds.ReadShort()
						Next
					Next
					
					Local crossarrays:= (ds.ReadByte() & 255)
					
					For Local k:= 0 Until crossarrays
						Local crossesNum:= (ds.ReadByte() & 255)
						
						For Local l:= 0 Until crossesNum
							Local __0:= ds.ReadShort()
							Local __1:= ds.ReadShort()
						Next
					Next
				Next
				
				Self.m_nActions = ds.ReadByte()
				
				If (Self.m_nActions < 0) Then
					Self.m_nActions += UOCTET_MAX_POSITIVE_NUMBERS
				EndIf
				
				'If (Self.m_nActions > 0) Then
				Self.m_Actions = New Action[Self.m_nActions]
				
				For Local i:= 0 Until Self.m_nActions
					Local action:= New Action(Self)
					
					action.loadActionG2(ds)
					action.SetFrames(Self.m_Frames)
					
					Self.m_Actions[i] = action
				Next
				'EndIf
			Catch E:Throwable ' StreamError
				'DebugStop()
				
				' Nothing so far.
			End Try
		End
	Public
		' Functions:
		Function getInstanceFromQi:Animation[](fileName:String)
			tmpPath = MyAPI.getPath(fileName)
			
			isFrameWanted = False
			
			Local ds:Stream = Null
			
			Try
				Local ds2:= MFDevice.getResourceAsStream(fileName)
				
				ds = ds2
				
				Local animationNum:= ((ds2.ReadByte()) & 255) ' ds2.ReadByte()
				
				animationInstance = New Animation[animationNum]
				
				For Local i:= 0 Until animationNum
					Local a:= New Animation()
					
					animationInstance[i] = a
					
					a.LoadAnimationG2(ds2) ' animationInstance[i]
				Next
				
				Local imageNum:= ds2.ReadByte()
				
				Local imageInfo:= New ImageInfo[imageNum]
				
				If (imageNum > 0) Then
					isImageWanted = True
				EndIf
				
				For Local i:= 0 Until imageNum
					Local img:= New ImageInfo()
					
					img.loadInfo(ds2, False) ' True
					
					imageInfo[i] = img
				Next
				
				For Local i:= 0 Until animationNum
					Local inst:= animationInstance[i]
					
					inst.imageInfo = imageInfo
					inst.qiAnimationArray = animationInstance
				Next
				
				'imageInfo = []
				
				If (ds2 <> Null) Then
					ds2.Close()
				EndIf
			Catch E:StreamError ' Throwable
				'DebugStop()
				
				If (ds <> Null) Then
					ds.Close()
				EndIf
			End Try
			
			Return animationInstance
		End

		Function getInstanceFromQi:Animation[](fileName:String, index:Bool[])
			For Local i:= 0 Until imageIdArray.Length
				imageIdArray[i] = -1
			Next
			
			Local fb_ds:Stream = Null
			
			Try
				Local ds:= MFDevice.getResourceAsStream(fileName)
				
				fb_ds = ds
				
				Local animationNum:= ds.ReadByte()
				
				animationInstance = New Animation[animationNum]
				
				For Local i:= 0 Until animationNum
					isFrameWanted = index[i]
					
					Local anim:= New Animation()
					
					anim.LoadAnimationG2(ds)
					
					animationInstance[i] = anim
				Next
				
				Local imageNum:= ds.ReadByte()
				
				Local imageInfo:= New ImageInfo[imageNum]
				
				For Local i:= 0 Until imageNum
					isImageWanted = False
					
					For Local j:= 0 Until imageIdArray.Length
						If (imageIdArray[j] <> i) Then
							If (imageIdArray[j] = -1) Then
								Exit
							EndIf
						Else
							isImageWanted = True
							
							Exit
						EndIf
					Next
					
					Local info:= New ImageInfo()
					
					info.loadInfo(ds, False)
					
					imageInfo[i] = info
				Next
				
				For Local i:= 0 Until animationNum
					Local inst:= animationInstance[i]
					
					inst.imageInfo = imageInfo
					inst.qiAnimationArray = animationInstance
				Next
				
				'imageInfo = []
				
				If (ds <> Null) Then
					ds.Close()
				EndIf
			Catch E:Throwable
				fb_ds.Close()
			End Try
			
			Return animationInstance
		End
		
		Function closeAnimation:Void(animation:Animation)
			If (animation <> Null) Then
				animation.close()
			EndIf
		End
		
		Function closeAnimationArray:Void(animation:Animation[])
			For Local i:= 0 Until animation.Length
				closeAnimation(animation[i])
				
				animation[i] = Null
			Next
		End
		
		Function closeAnimationDrawer:Void(drawer:AnimationDrawer)
			If (drawer <> Null) Then
				drawer.close()
			EndIf
		End
	
		Function closeAnimationDrawerArray:Void(drawer:AnimationDrawer[])
			For Local i:= 0 Until drawer.Length
				closeAnimationDrawer(drawer[i])
				
				drawer[i] = Null
			Next
			
			'drawer = []
		End
		
		' Methods:
		Method DrawAni:Void(g:MFGraphics, x:Int, y:Int, attr:Short)
			Self.m_Actions[Self.m_CurAni].Draw(g, x, y, attr)
		End
		
		Method DrawAni:Void(g:MFGraphics, no:Short, x:Int, y:Int, loop:Bool, attr:Short)
			SetCurAni(no)
			SetLoop(loop)
			
			DrawAni(g, x, y, attr)
		End
		
		Method DrawAni:Void(g:MFGraphics, frame:Byte, x:Int, y:Int, attr:Short)
			Self.m_Actions[Self.m_CurAni].Draw(g, frame, x, y, attr)
		End
		
		Method DrawAni:Void(g:MFGraphics, ani:Short, frame:Short, x:Int, y:Int, attr:Short)
			Self.m_Actions[ani].Draw(g, frame, x, y, attr)
		End

		Method getDrawer:AnimationDrawer(actionId:Int, loop:Bool, trans:Int)
			Self.refCount += 1
			
			Return New AnimationDrawer(Self, actionId, loop, trans)
		End
		
		Method getDrawer:AnimationDrawer()
			Self.refCount += 1
			
			Return New AnimationDrawer(Self)
		End
		
		Method getActionNum:Int()
			Return Self.m_nActions
		End
	
		Method getFrameNum:Int()
			Return Self.m_Actions[Self.m_CurAni].getFrameNum()
		End
	
		Method getFrameNum:Int(actionId:Int)
			Return Self.m_Actions[actionId].getFrameNum()
		End
	
		Method isTimeOver:Bool(time:Int)
			Return Self.m_Actions[Self.m_CurAni].isTimeOver(time)
		End
	
		Method isTimeOver:Bool(actionId:Int, frameId:Int, time:Int)
			Return Self.m_Actions[Self.m_CurAni].isTimeOver(time)
		End
	
		Method getWidthWithFrameId:Int(actionId:Int, currentFrame:Int)
			Return Self.m_Frames[Self.m_Actions[actionId].m_FrameInfo[currentFrame][0]].getWidth()
		End
	
		Method getHeightWithFrameId:Int(actionId:Int, currentFrame:Int)
			Return Self.m_Frames[Self.m_Actions[actionId].m_FrameInfo[currentFrame][0]].getHeight()
		End
End