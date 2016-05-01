Strict

Public

' Friends:
Friend lib.animation

' Imports:
Private
	Import lib.animation
	Import lib.constutil
	Import lib.myapi
	
	Import pyxeditor.pyxanimation
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import regal.typetool
Public

' Classes:
Class AnimationDrawer
	Private
		' Constant variable(s):
		Global STANDARD_FRAME_SPEED:Int = (1 Shl ZOOM) ' Const
		
		' Global variable(s):
		Global ZOOM:Int = PyxAnimation.ZOOM
		Global allPause:Bool = False
		
		' Fields:
		Field endChk:Bool
		Field endTrigger:Bool
		Field loop:Bool
		Field m_bPause:Bool
		
		Field ani:Animation
		
		Field actionId:Short
		Field attr:Short
		Field m_CurFrame:Short
		
		Field m_Timer:Int
		Field mustKeepTime:Int
		Field speedDivide:Int
		Field speedMulti:Int
		
		Field reARect:Byte[]
		Field reCRect:Byte[]
		
		Field transId:Byte
		
		Field lostFrameTime:Long
		
		Field actualTime:Int
	Public
		' Fields:
		Field startTime:Long
		
		' Functions:
		Function setAllPause:Void(pause:Bool)
			allPause = pause
			
			PyxAnimation.setPause(pause)
		End
		
		Function isAllPause:Bool()
			Return allPause
		End
		
		' Constructor(s):
		Method New(ani:Animation)
			Self.speedMulti = 1
			Self.speedDivide = 1
			
			Self.mustKeepTime = -1
			
			Self.ani = ani
			
			Self.actionId = 0
			
			Self.attr = ConstUtil.TRANS[0]
			Self.transId = 0
			
			Self.loop = True
		End
		
		Method New(ani:Animation, actionId:Int, loop:Bool, transId:Int)
			Self.speedMulti = 1
			Self.speedDivide = 1
			
			Self.mustKeepTime = -1
			
			Self.ani = ani
			
			Self.actionId = Short(actionId)
			
			Self.attr = ConstUtil.TRANS[transId]
			Self.transId = Byte(transId)
			
			Self.loop = loop
		End
	Protected
		' Methods:
		Method close:Void()
			If (Self.ani <> Null) Then
				Local animation:= Self.ani
				
				animation.refCount -= 1
				
				If (Self.ani.refCount <= 0) Then
					Self.ani.close()
				EndIf
			EndIf
			
			Self.ani = Null
		End
	Private
		' Methods:
		Method getRect:Void(getter:Byte[], source:Byte[])
			If (source.Length > 0 And getter.Length > 0) Then
				Select (Self.transId)
					Case TRANS_MIRROR
						getter[0] = Byte((-source[0]) - source[2])
						getter[1] = source[1]
						getter[2] = source[2]
						getter[3] = source[3]
					Default
						getter[0] = source[0]
						getter[1] = source[1]
						getter[2] = source[2]
						getter[3] = source[3]
				End Select
			EndIf
		End
	Public
		' Methods:
		Method mustKeepFrameTime:Void(keepTime:Int)
			Self.mustKeepTime = keepTime
		End
		
		Method setActionId:Void(actionId:Int)
			If (Self.actionId <> Short(actionId)) Then
				restart()
			EndIf
			
			Self.actionId = Short(actionId)
		End
		
		Method getActionId:Int()
			Return Self.actionId
		End
		
		Method getTransId:Int()
			Return Self.transId
		End
		
		Method getLoop:Bool()
			Return Self.loop
		End
		
		Method setLoop:Void(loop:Bool)
			Self.loop = loop
		End
		
		Method setTrans:Void(transId:Int)
			Self.attr = ConstUtil.TRANS[transId]
			Self.transId = Byte(transId)
		End
		
		Method draw:Void(g:MFGraphics, actionId:Int, x:Int, y:Int, loop:Bool, transId:Int, zoomEnable:Bool)
			If (Self.actionId <> Short(actionId)) Then
				restart()
			EndIf
			
			Self.actionId = Short(actionId)
			Self.attr = ConstUtil.TRANS[transId]
			Self.transId = Byte(transId) ' transId
			
			Self.loop = loop
			
			draw(g, x, y, zoomEnable)
		End
		
		Method draw:Void(g:MFGraphics, x:Int, y:Int, transId:Int, zoomEnable:Bool)
			Self.attr = ConstUtil.TRANS[transId]
			
			Self.transId = Byte(transId)
			
			draw(g, x, y, zoomEnable)
		End
		
		Method draw:Void(g:MFGraphics, x:Int, y:Int)
			draw(g, x, y, True)
		End
		
		Method drawWithoutZoom:Void(g:MFGraphics, x:Int, y:Int)
			draw(g, x, y, False)
		End
		
		Method draw:Void(g:MFGraphics, actionId:Int, x:Int, y:Int, loop:Bool, transId:Int)
			draw(g, actionId, x, y, loop, transId, True)
		End
		
		Method drawWithoutZoom:Void(g:MFGraphics, actionId:Int, x:Int, y:Int, loop:Bool, transId:Int)
			draw(g, actionId, x, y, loop, transId, False)
		End
		
		Method draw:Void(g:MFGraphics, x:Int, y:Int, transId:Int)
			draw(g, x, y, transId, True)
		End
		
		Method drawWithoutZoom:Void(g:MFGraphics, x:Int, y:Int, transId:Int)
			draw(g, x, y, transId, False)
		End
		
		Method moveOn:Void()
			Self.actualTime += ((STANDARD_FRAME_SPEED * Self.speedMulti) / Self.speedDivide)
			
			Self.m_Timer = Byte(Self.actualTime Shr ZOOM)
			
			Self.endTrigger = False
			
			Self.ani.SetCurAni(Self.actionId)
			Self.ani.SetCurFrame(Self.m_CurFrame)
			
			If (Self.ani.isTimeOver(Self.m_Timer)) Then
				Local trigger:Bool = False
				
				If (Self.m_CurFrame < Self.ani.getFrameNum(Self.actionId) And Not Self.endChk) Then
					trigger = True
				EndIf
				
				If (Self.mustKeepTime = -1) Then
					Self.m_CurFrame = Short(Self.m_CurFrame + 1)
				ElseIf (Self.lostFrameTime < Long(-Self.mustKeepTime)) Then
					Self.lostFrameTime += Long(Self.mustKeepTime)
				Else
					If (Self.lostFrameTime > Long(Self.mustKeepTime)) Then
						Self.m_CurFrame = Short(Self.m_CurFrame + 1)
						
						Self.lostFrameTime -= Long(Self.mustKeepTime)
					EndIf
					
					Self.m_CurFrame = Short(Self.m_CurFrame + 1)
				EndIf
				
				If (Self.m_CurFrame < Self.ani.getFrameNum(Self.actionId)) Then
					Self.m_Timer = 0
					
					Self.actualTime Mod= STANDARD_FRAME_SPEED
				ElseIf (Self.loop) Then
					Self.m_Timer = 0
					Self.m_CurFrame = 0
					
					Self.actualTime Mod= STANDARD_FRAME_SPEED
				Else
					Self.m_CurFrame = Byte(Self.ani.getFrameNum(Self.actionId) - 1)
					
					Self.endChk = True
					
					If (trigger) Then
						Self.endTrigger = True
					EndIf
				EndIf
			EndIf
		End
		
		Method draw:Void(g:MFGraphics, x:Int, y:Int, zoomEnable:Bool)
			Self.ani.SetCurAni(Self.actionId)
			Self.ani.SetLoop(Self.loop)
			
			If (zoomEnable) Then
				Self.ani.DrawAni(g, Self.actionId, Self.m_CurFrame, MyAPI.zoomOut(x), MyAPI.zoomOut(y), Self.attr)
			Else
				Self.ani.DrawAni(g, Self.actionId, Self.m_CurFrame, x, y, Self.attr)
			EndIf
			
			If (Self.mustKeepTime <> -1) Then
				Local nowTime:= Long(Millisecs())
				
				If (Self.startTime = 0) Then
					Self.startTime = nowTime - Long(Self.mustKeepTime)
				EndIf
				
				Self.lostFrameTime += (nowTime - Self.startTime) - Long(Self.mustKeepTime)
				
				Self.startTime = nowTime
			EndIf
			
			If (Self.m_bPause Or allPause) Then
				Self.lostFrameTime = 0
			Else
				moveOn()
			EndIf
		End
		
		Method setPause:Void(pause:Bool)
			Self.m_bPause = pause
		End
		
		Method checkEnd:Bool()
			Return Self.endChk
		End
		
		Method checkEndTrigger:Bool()
			Return Self.endTrigger
		End
		
		Method restart:Void()
			Self.startTime = 0
			
			Self.endChk = False
			
			Self.m_CurFrame = 0
			Self.actualTime = 0
		End
		
		Method getCurrentFrameWidth:Int()
			Return MyAPI.zoomIn(Self.ani.getWidthWithFrameId(Self.actionId, Self.m_CurFrame))
		End
		
		Method getCurrentFrameHeight:Int()
			Return MyAPI.zoomIn(Self.ani.getHeightWithFrameId(Self.actionId, Self.m_CurFrame))
		End
		
		Method getCurrentFrame:Int()
			Return Self.m_CurFrame
		End
		
		Method getAnimation:Animation()
			Return Self.ani
		End
		
		Method setEnd:Void()
			Self.endChk = True
		End
		
		Method getARect:Byte[]()
			If (Self.reARect.Length = 0) Then
				Self.reARect = New Byte[4]
			EndIf
			
			Self.ani.SetCurAni(Self.actionId)
			Self.ani.SetCurFrame(Self.m_CurFrame)
			
			Local animationrect:= Self.ani.GetARect()
			
			If (animationrect.Length = 0) Then
				Return []
			EndIf
			
			getRect(Self.reARect, animationrect)
			
			Return Self.reARect
		End
		
		Method getCRect:Byte[]()
			If (Self.reCRect.Length = 0) Then
				Self.reCRect = New Byte[4]
			EndIf
			
			Self.ani.SetCurAni(Self.actionId)
			Self.ani.SetCurFrame(Self.m_CurFrame)
			
			Local animationrect:= Self.ani.GetCRect()
			
			If (animationrect.Length = 0) Then
				Return []
			EndIf
			
			getRect(Self.reCRect, animationrect)
			
			Return Self.reCRect
		End
		
		Method setSpeedReset:Void()
			Self.speedMulti = 1
			Self.speedDivide = 1
		End
		
		Method setSpeed:Void(multi:Int, divide:Int)
			Self.speedMulti = multi
			Self.speedDivide = divide
			
			If (Self.speedDivide = 0) Then
				Self.speedDivide = 1
			EndIf
			
			If (Self.speedMulti = 0) Then
				Self.speedMulti = 1
			EndIf
		End
End