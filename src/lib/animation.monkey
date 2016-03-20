Strict

Public

' Friends:
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
	
	Import lib.animationframe
	
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgamepad
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
		
		Global tmpPath:String = BPDef.gameID
		
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
			Self.fileName = Null
			Self.isAnimationQi = False
			
			Self.m_CurAni = 0
			Self.m_OldAni = 0
			Self.refCount = 0
		End
	Public
		' Constructor(s):
		Method New(fileName:String)
			Self.isDoubleScale = False
			Self.fileName = Null
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
			Self.fileName = Null
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
			If (imageInfo <> Null) Then
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
		
		Method LoadAnimation:Void(in:InputStream)
			If (in <> Null) Then
				Self.imageInfo[0].loadInfo(in)
				Self.m_nFrames = in.ReadByte()
				
				If (Self.m_nFrames < 0) Then
					Self.m_nFrames += 256
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
					Self.m_nActions += 256
				EndIf
				
				Self.m_Actions = New Action[Self.m_nActions]
				
				For Local i:= 0 Until Self.m_nActions
					Self.m_Actions[i] = New Action(Self)
					Self.m_Actions[i].LoadAction(in)
					Self.m_Actions[i].SetFrames(Self.m_Frames)
				Next
				
				If (Self.isDoubleScale) Then
					Self.imageInfo[0].doubleParam()
					
					Return
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
			
			Local __unknown:= ds.ReadInt()
			
			Self.m_nFrames = ds.ReadByte()
			
			If (Self.m_nFrames < 0) Then
				Self.m_nFrames += 256
			EndIf
			
			Self.m_Frames = New Frame[Self.m_nFrames]
			
			For Local I:= 0 Until Self.m_nFrames
				Self.m_Frames[i] = New Frame(Self)
				Self.m_Frames[i].loadFrameG2(ds)
				
				Local rectarrays:= (ds.ReadByte() & 255)
				
				For (k = 0; k < rectarrays; k += 1)
					Local rectsNum:= (ds.ReadByte() & 255)
					
					For Local l:= 0 Until rectsNum
						Local __0:= ds.ReadShort()
						Local __1:= ds.ReadShort()
						Local __2:= ds.ReadShort()
						Local __3:= ds.ReadShort()
					EndIf
				Next
				
				Local crossarrays:= (ds.ReadByte() & 255)
				
				For Local k:= 0 Until crossarrays
					Local crossesNum:= (ds.ReadByte() & 255)
					
					For Local l:= 0 Until crossesNum
						Local __0:= ds.ReadShort()
						Local __2:= ds.ReadShort()
					End Select
				Next
			Next
			
			Self.m_nActions = ds.ReadByte()
			
			If (Self.m_nActions < 0) Then
				Self.m_nActions += 256
			EndIf
			
			Self.m_Actions = New Action[Self.m_nActions]
			
			For Local i:= 0 Until Self.m_nActions
				Local action:= New Action(Self)
				
				action.loadActionG2(ds)
				action.SetFrames(Self.m_Frames)
				
				Self.m_Actions[i] = action
			Next
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
				
				Local animationNum:= ds2.ReadByte() ' & 255
				
				animationInstance = New Animation[animationNum]
				
				For Local i:= 0 Until animationNum
					a = New Animation()
					a.LoadAnimationG2(ds2)
					
					animationInstance[i] = a
				Next
				
				Local imageNum:= ds2.ReadByte()
				
				Local imageInfo:= New ImageInfo[imageNum]
				
				If (imageNum > 0) Then
					isImageWanted = True
				EndIf
				
				For Local i:= 0 Until imageNum
					Local img:= New ImageInfo()
					
					img.loadInfo(ds2)
					
					imageInfo[i] = img
				Next
				
				For Local i:= 0 Until animationNum
					Local inst:= animationInstance[i]
					
					inst.imageInfo = imageInfo
					inst.qiAnimationArray = animationInstance
				Next
				
				imageInfo = Null
				
				If (ds2 <> Null) Then
					ds2.Close()
					
					Return animationInstance
				EndIf
			Catch E:Throwable
				If (ds <> Null) Then
					ds.Close()
				EndIf
			End Try
			
			Return animationInstance
		End

		Function getInstanceFromQi:Animation[](fileName:String, index:Bool[])
			For Local i:= 0 Until imageIdArray.Length
				imageIdArray[i] = -1
			EndIf
			
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
				EndIf
				
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
					
					info.loadInfo(ds)
					
					imageInfo[i] = info
				Next
				
				For Local i:= 0 Until animationNum
					Local inst:= animationInstance[i]
					
					inst.imageInfo = imageInfo
					inst.qiAnimationArray = animationInstance
				Next
				
				imageInfo = Null
				
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
			If (animation <> Null) Then
				For Local i:= 0 Until animation.Length
					closeAnimation(animation[i])
					
					animation[i] = Null
				EndIf
			EndIf
		End
		
		Function closeAnimationDrawer:Void(drawer:AnimationDrawer)
			If (drawer <> Null) Then
				drawer.close()
			EndIf
		End
	
		Function closeAnimationDrawerArray:Void(drawer:AnimationDrawer[])
			If (drawer <> Null) Then
				For Local i:= 0 Until drawer.Length
					closeAnimationDrawer(drawer[i])
					
					drawer[i] = Null
				EndIf
			EndIf
			
			drawer = []
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

static Class ImageInfo
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

	Public Method loadInfo:Void(ds:InputStream)
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