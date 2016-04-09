Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	
	Import com.sega.mobile.define.mdphone
	Import com.sega.mobile.framework.android.graphics
	Import com.sega.mobile.framework.device.mfdevice
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import brl.stream
	'Import brl.databuffer
	
	Import monkey.stack
Public

' Classes:
Class PyxAnimation
	Public
		' Constant variable(s):
		Const ZOOM:Int = 6
	Private
		' Global variable(s):
		Global pauseFlag:Bool = False
		
		' Fields:
		Field actionArray:Action[]
		Field animationArray:Animation[]
		Field changeStratKeyArray:KeyFrame[]
		Field nodeArray:Node[]
		Field nodeStack:Stack<Node>
		
		Field currentAction:Int
		Field rootNodeID:Int
		Field speed:Int
		
		Field loop:Bool
	Public
		' Functions:
		Function setPause:Void(flag:Bool)
			pauseFlag = flag
		End
		
		' Constructor(s):
		Method New(fileName:String, animation:Animation[])
			Self.loop = False
			
			Self.speed = 64
			
			Self.animationArray = animation
			Self.currentAction = -1
			
			Self.nodeStack = New Stack<Node>()
			
			loadFile(fileName)
			
			calBeforeDraw()
		End
	Private
		' Methods:
		Method loadFile:Void(fileName:String)
			Local ds:= MFDevice.getResourceAsStream(fileName)
			
			Local nodeNum:= ds.ReadByte()
			
			Self.nodeArray = New Node[nodeNum]
			Self.changeStratKeyArray = New KeyFrame[nodeNum]
			
			For Local i:= 0 Until nodeNum
				Self.nodeArray[i] = New Node(Self, ds)
				Self.changeStratKeyArray[i] = New KeyFrame()
			Next
			
			For Local i:= 0 Until nodeNum
				Self.nodeArray[i].linkByID()
			Next
			
			Self.rootNodeID = ds.ReadByte()
			
			Local rootPointId:= ds.ReadByte()
			
			If (Self.rootNodeID >= 0) Then
				Self.nodeArray[Self.rootNodeID].setRootConnectPoint(rootPointId)
			Next
			
			Local actionNum:= ds.ReadByte()
			
			Self.actionArray = New Action[actionNum]
			
			For Local i:= 0 Until actionNum
				Self.actionArray[i] = New Action(Self, ds)
			Next
		End
		
		Method calBeforeDraw:Void()
			For Local resetForDraw:= EachIn Self.nodeArray
				resetForDraw.resetForDraw()
			EndIf
			
			Self.nodeStack.Clear()
			
			Local currentNode:= Self.nodeArray[Self.rootNodeID]
			
			currentNode.doCalBeforeDraw()
			
			While (True)
				If (currentNode <> Null) Then
					Local node:= currentNode
					
					currentNode = currentNode.getSubNode()
					
					If (currentNode <> Null) Then
						Self.nodeStack.Push(node)
						
						currentNode.doCalBeforeDraw()
					EndIf
				ElseIf (Not Self.nodeStack.empty()) Then
					currentNode = Self.nodeStack.Pop()
				Else
					Exit
				EndIf
			Wend
		End
	Public
		' Methods:
		Method close:Void()
			For Local node:= EachIn Self.nodeArray
				node.close()
			Next
			
			Self.nodeArray = []
			
			For Local action:= EachIn Self.actionArray
				action.close()
			Next
			
			Self.actionArray = []
		End
		
		Method drawAction:Void(g:MFGraphics, actionID:Int, x:Int, y:Int)
			If (Self.currentAction <> actionID) Then
				Self.actionArray[actionID].reset()
				
				Self.currentAction = actionID
			EndIf
			
			calBeforeDraw()
			
			For Local draw:= EachIn Self.nodeArray
				draw.draw(g, x, y)
			Next
			
			If (Not pauseFlag) Then
				Self.actionArray[Self.currentAction].moveOn()
			EndIf
		End
		
		Method drawAction:Void(g:MFGraphics, x:Int, y:Int)
			If (Self.currentAction >= 0) Then
				calBeforeDraw()
				
				For Local draw:= EachIn Self.nodeArray
					draw.draw(g, x, y)
				Next
				
				If (Not pauseFlag) Then
					Self.actionArray[Self.currentAction].moveOn()
				EndIf
			EndIf
		End
		
		Method setAction:Void(actionID:Int)
			Self.actionArray[actionID].reset()
			
			Self.currentAction = actionID
		End
		
		Method changeToAction:Void(actionID:Int, duration:Int)
			Self.actionArray[Self.currentAction].saveKeyFrame(Self.changeStratKeyArray)
			
			For Local kFrame:= EachIn Self.changeStratKeyArray
				kFrame.framePosition = -duration
			Next
			
			Self.actionArray[actionID].reset(-duration)
			
			Self.currentAction = actionID
		End
		
		Method chkEnd:Bool()
			If (Self.currentAction >= 0) Then
				Return Self.actionArray[Self.currentAction].chkEnd()
			EndIf
			
			Return False
		End
		
		Method setLoop:Void(loop:Bool)
			Self.loop = loop
		End
		
		Method getNodeXByAnimationNamed:Int(name:String, xOffset:Int, yOffset:Int)
			For Local i:= 0 Until Self.nodeArray.Length
				If (Self.nodeArray[i].label.equals(name)) Then
					Return (MyAPI.getRelativePointX(Self.nodeArray[i].centerPoint.showX, ((Self.nodeArray[i].animationX - Self.nodeArray[i].centerPoint.f21x) + xOffset) Shl ZOOM, ((Self.nodeArray[i].animationY - Self.nodeArray[i].centerPoint.f22y) + yOffset) Shl ZOOM, Self.nodeArray[i].calDegree) Shr ZOOM)
				EndIf
			Next
			
			Return 0
		End
		
		Method getNodeYByAnimationNamed:Int(name:String, xOffset:Int, yOffset:Int)
			For Local i:= 0 Until Self.nodeArray.Length
				If (Self.nodeArray[i].label.equals(name)) Then
					Return (MyAPI.getRelativePointY(Self.nodeArray[i].centerPoint.showY, ((Self.nodeArray[i].animationX - Self.nodeArray[i].centerPoint.f21x) + xOffset) Shl ZOOM, ((Self.nodeArray[i].animationY - Self.nodeArray[i].centerPoint.f22y) + yOffset) Shl ZOOM, Self.nodeArray[i].calDegree) Shr ZOOM)
				EndIf
			Next
			
			Return 0
		End
		
		Method setSpeed:Void(speed:Int)
			If (speed > 0) Then
				Self.speed = speed
			EndIf
		End
		
		Method getNodeByName:Node(nodeName:String)
			For Local i:= 0 Until Self.nodeArray.Length
				If (Self.nodeArray[i].label.equals(nodeName)) Then
					Return Self.nodeArray[i]
				EndIf
			Next
			
			Return Null
		End
		
		Method changeAnimation:Void(nodeName:String, animationID:Int, actionID:Int)
			Local node:= getNodeByName(nodeName)
			
			If (node <> Null) Then
				node.setAnimation(animationID, actionID)
			EndIf
		End
		
		Method getNodeInfo:Void(info:NodeInfo, nodeName:String)
			info.reset()
			
			Local node:= getNodeByName(nodeName)
			
			If (node <> Null) Then
				info.got = True
				
				info.drawer = node.drawer
				
				info.animationX = node.getAnimationPosX()
				info.animationY = node.getAnimationPosY()
				
				info.rotateX = 0
				info.rotateY = 0
				
				If (node.centerPoint <> Null) Then
					info.rotateX = (node.centerPoint.showX Shr ZOOM)
					info.rotateY = (node.centerPoint.showY Shr ZOOM)
				EndIf
				
				info.degree = node.calDegree
			EndIf
		End
End

Class Action
	Private
		' Fields:
		Field parent:PyxAnimation
		
		Field frame:Int
		Field timeLimit:Int
		
		Field label:String
		
		Field trackArray:ActionTrack[]
	Public
		' Constructor(s):
		Method New(parent:PyxAnimation, ds:Stream)
			Self.parent = parent
			
			loadStream(ds)
		End
	Private
		' Methods:
		Method loadStream:Void(ds:Stream)
			Local trackNum:= ds.ReadByte()
			
			Self.trackArray = New ActionTrack[trackNum]
			
			For Local i:= 0 Until trackNum ' Self.trackArray.Length
				Self.trackArray[i] = New ActionTrack(ds)
			Next
			
			Local strLen:= ds.ReadShort()
			
			Self.label = ds.ReadString(strLen, "utf8")
			
			Self.timeLimit = ds.ReadShort()
		End
	Public
		' Methods:
		Method close:Void()
			For Local t:= EachIn Self.trackArray
				t.close()
			Next
			
			Self.trackArray = []
			Self.label = ""
		End
		
		Method reset:Void()
			Self.frame = 0
			
			setNodeProperty()
		End
		
		Method reset:Void(frame:Int)
			Self.frame = (frame Shl PyxAnimation.ZOOM)
			
			setNodeProperty()
		End
		
		Method moveOn:Void()
			Self.frame += Self.parent.speed
			
			If (Self.frame >= (Self.timeLimit Shl PyxAnimation.ZOOM)) Then
				If (Self.parent.loop) Then
					Self.frame -= (Self.timeLimit Shl PyxAnimation.ZOOM)
				Else
					Self.frame = (Self.timeLimit Shl PyxAnimation.ZOOM) - 1
				EndIf
			EndIf
			
			setNodeProperty()
		End
		
		Method setNodeProperty:Void()
			For Local nodeProperty:= EachIn Self.trackArray
				nodeProperty.setNodeProperty(Self.frame)
			Next
		End
		
		Method saveKeyFrame:Void(frameArray:KeyFrame[])
			For Local i:= 0 Until Self.trackArray.Length
				Self.trackArray[i].setNodePropertyToKeyFrame(frameArray[i], Self.frame)
			Next
		End
		
		Method chkEnd:Bool()
			Return (Not Self.parent.loop And (Self.frame = (Self.timeLimit Shl PyxAnimation.ZOOM) - 1))
		End
End

Class ActionTrack
	Private
		' Fields:
		Field parent:PyxAnimation
		
		Field keyFrameArray:KeyFrame[]
		
		Field nodeID:Int
	Public
		' Constructor(s):
		Method New(parent:PyxAnimation, ds:Stream)
			Self.parent = parent
			
			loadStream(ds)
		End
	Private
		' Methods:
		Method loadStream:Void(ds:Stream)
			Self.nodeID = ds.ReadByte()
			
			Local frameNum:= ds.ReadByte()
			
			Self.keyFrameArray = New KeyFrame[frameNum]
			
			For Local i:= 0 Until frameNum
				Self.keyFrameArray[i] = New KeyFrame(ds) ' (Self.parent, ds)
			Next
		End
	Public
		' Methods:
		Method close:Void()
			Self.keyFrameArray = Null
		End
		
		Method setNodeProperty:Void(frame:Int)
			Self.parent.nodeArray[Self.nodeID].degree = getDegree(frame)
		End
		
		Method setNodePropertyToKeyFrame:Void(frameObj:KeyFrame, frame:Int)
			frameObj.degree = getDegree(frame)
		End
		
		Method getDegree:Int(frame:Int)
			frame Shr= PyxAnimation.ZOOM
			
			Local frameBefore:KeyFrame = Null
			Local frameBehind:KeyFrame = Null
			
			If (frame >= 0) Then
				For Local i:= 0 Until Self.keyFrameArray.Length
					If (Self.keyFrameArray[i].framePosition > frame) Then
						frameBehind = Self.keyFrameArray[i]
						
						Exit
					EndIf
					
					frameBefore = Self.keyFrameArray[i]
				Next
			Else
				frameBefore = Self.parent.changeStratKeyArray[Self.nodeID]
				frameBehind = Self.keyFrameArray[0]
			EndIf
			
			If (frameBehind = Null) Then
				Return frameBefore.degree
			EndIf
			
			Local duration:= (frameBehind.framePosition - frameBefore.framePosition)
			Local degreeDiff:= (frameBehind.degree - frameBefore.degree)
			
			If (degreeDiff > 180) Then
				degreeDiff -= 360
			EndIf
			
			If (degreeDiff < -180) Then
				degreeDiff += 360
			EndIf
			
			Return (frameBefore.degree + (((frame - frameBefore.framePosition) * degreeDiff) / duration))
		End
End

Class ConnectPoint
	Private
		' Fields:
		Field linkPoint:ConnectPoint
		
		Field showX:Int
		Field showY:Int
	Public
		' Fields:
		Field node:Node
		
		Field linkNodeId:Int
		Field linkPointId:Int
		
		Field f21x:Int
		Field f22y:Int
		
		' Constructor(s):
		Method New(node:Node, ds:Stream)
			Self.node = node
			Self.linkPoint = Null
			
			loadStream(ds)
		End
	Private
		' Methods:
		Method loadStream:Void(ds:Stream)
			Self.f21x = ds.ReadShort()
			Self.f22y = ds.ReadShort()
			
			Self.linkNodeId = ds.ReadByte()
			Self.linkPointId = ds.ReadByte()
		End
	Public
		' Methods:
		Method linkByID:Void()
			If (Self.linkNodeId >= 0 And Self.linkPointId >= 0) Then
				Self.linkPoint = Self.parent.nodeArray[Self.linkNodeId].connectPointArray[Self.linkPointId]
			EndIf
		End
		
		Method close:Void()
			Self.linkPoint = Null
			Self.node = Null
		End
		
		Method getLinkNode:Node()
			If (Self.linkPoint = Null) Then
				Return Null
			EndIf
			
			Return Self.linkPoint.node
		End
		
		Method getLinkConnectPoint:ConnectPoint()
			Return Self.linkPoint
		End
		
		Method setLinkPointPosition:Void()
			If (Self.linkPoint <> Null) Then
				Self.linkPoint.showX = Self.showX
				Self.linkPoint.showY = Self.showY
			EndIf
		End
End
		
Class KeyFrame
	Private
		' Fields:
		Field degree:Int
		Field framePosition:Int
	Public
		' Constructor(s):
		Method New()
			Self.framePosition = 0
		End
		
		Method New(ds:Stream)
			loadStream(ds)
		End
	Private
		' Methods:
		Method loadStream:Void(ds:Stream)
			Self.framePosition = ds.ReadShort()
			Self.degree = ds.ReadShort()
		End
End

Class Node
	Private
		' Fields:
		Field animationID:Int
		Field animationX:Int
		Field animationY:Int
		
		Field calDegree:Int
		Field degree:Int
		Field returnId:Int
		
		Field label:String
		
		Field connectPointArray:ConnectPoint[]
		
		Field drawer:AnimationDrawer
		
		Field pyx:PyxAnimation ' parent:PyxAnimation
		
		Field node:Node
	Public
		' Fields:
		Field centerPoint:ConnectPoint
		
		' Constructor(s):
		Method New(pyx:PyxAnimation, ds:Stream)
			Self.pyx = pyx
			
			loadStream(ds)
		End
	Private
		' Methods:
		Method loadStream:Void(ds:Stream)
			' Skip the initial values:
			#Rem
				ds.ReadShort()
				ds.ReadShort()
				ds.ReadShort()
				ds.ReadShort()
			#End
			
			ds.Seek(ds.Position + 8) ' (SizeOf_Short * 4)
			
			Local connectNum:= ds.ReadByte()
			
			Self.connectPointArray = New ConnectPoint[connectNum]
			
			For Local i:= 0 Until connectNum
				Self.connectPointArray[i] = New ConnectPoint(Self, ds)
			Next
			
			Local strLen:= ds.ReadShort()
			
			Self.label = ds.ReadString(strLen, "utf8")
			
			Self.animationID = ds.ReadByte()
			
			Local actionID:= ds.ReadByte()
			
			Self.animationX = ds.ReadByte()
			Self.animationY = ds.ReadByte()
			
			Self.drawer = Self.parent.animationArray[Self.animationID].getDrawer(actionID, True, 0)
		End
	Public
		' Methods:
		Method linkByID:Void()
			For Local point:= EachIn Self.connectPointArray
				point.linkByID()
			Next
		End
		
		Method setRootConnectPoint:Void(rootPoint:Int)
			Self.centerPoint = Self.connectPointArray[rootPoint]
		End
		
		Method close:Void()
			For Local point:= EachIn Self.connectPointArray
				point.close()
			Next
			
			Self.connectPointArray = []
			
			Self.label = Null
			Self.drawer = Null
		End
		
		Method resetForDraw:Void()
			Self.returnId = 0
			
			Self.node = Null
		End
		
		Method doCalBeforeDraw:Void()
			If (Self.centerPoint <> Null) Then
				Self.calDegree = getDrawDegree()
				
				For Local element:= EachIn Self.connectPointArray
					If (element <> Self.centerPoint) Then
						Local offsetX:= ((element.f21x - Self.centerPoint.f21x) Shl PyxAnimation.ZOOM)
						Local offsetY:= ((element.f22y - Self.centerPoint.f22y) Shl PyxAnimation.ZOOM)
						
						element.showX = MyAPI.getRelativePointX(Self.centerPoint.showX, offsetX, offsetY, Self.calDegree)
						element.showY = MyAPI.getRelativePointY(Self.centerPoint.showY, offsetX, offsetY, Self.calDegree)
						
						element.setLinkPointPosition()
					EndIf
				Next
			EndIf
		End
		
		Method getSubNode:Node()
			Local node:Node = Null
			Local point:ConnectPoint = Null
			
			While ((node = Null Or node = Self.superNode) And Self.returnId < Self.connectPointArray.Length)
				node = Self.connectPointArray[Self.returnId].getLinkNode()
				point = Self.connectPointArray[Self.returnId].getLinkConnectPoint()
				
				Self.returnId += 1
			Wend
			
			If (node <> Null And node <> Self.superNode) Then
				node.setSuperNode(Self)
				node.setCenterPoint(point)
				
				return node
			EndIf
			
			Return Null
		End
		
		Method setSuperNode:Void(node:Node)
			Self.node = node
		End
		
		Method setCenterPoint:Void(centerPoint:ConnectPoint)
			Self.centerPoint = centerPoint
		End
		
		Method getDrawDegree:Int()
			Local re:= Self.degree
			
			If (Self.node <> Null) Then
				re += Self.node.getDrawDegree()
			EndIf
			
			While (re < 0)
				re += 360
			Wend
			
			Return (re Mod 360)
		End
		
		Method draw:Void(g:MFGraphics, x:Int, y:Int)
			x Shl= PyxAnimation.ZOOM
			y Shl= PyxAnimation.ZOOM
			
			Local g2:= g.getSystemGraphics()
			
			g2.save()
			
			g2.translate(Float((Self.centerPoint.showX + x) Shr PyxAnimation.ZOOM), Float((Self.centerPoint.showY + y) Shr PyxAnimation.ZOOM))
			g2.rotate(Float(Self.calDegree))
			g2.translate(Float(-Self.centerPoint.f21x), Float(-Self.centerPoint.f22y))
			
			If (Self.drawer <> Null) Then
				Self.drawer.draw(g, Self.animationX, Self.animationY)
			EndIf
			
			g2.restore()
		End
		
		Method setAnimation:Void(animationID:Int, actionID:Int)
			If (animationID >= 0 And animationID < Self.parent.animationArray.Length) Then
				If (Self.animationID <> animationID) Then
					Self.drawer = Self.parent.animationArray[animationID].getDrawer(0, False, 0)
					
					Self.animationID = animationID
				EndIf
				
				Self.drawer.setActionId(actionID)
			EndIf
		End
		
		Method getAnimationPosX:Int()
			Local centerX:= 0
			
			Local offsetX:= Self.animationX
			Local offsetY:= Self.animationY
			
			If (Self.centerPoint <> Null) Then
				Local centerY:= Self.centerPoint.showY
				
				centerX = Self.centerPoint.showX
				
				offsetX -= Self.centerPoint.f21x
				offsetY -= Self.centerPoint.f22y
			EndIf
			
			Return (MyAPI.getRelativePointX(centerX, (offsetX Shl PyxAnimation.ZOOM), (offsetY Shl PyxAnimation.ZOOM), Self.calDegree) Shr PyxAnimation.ZOOM)
		End
		
		Method getAnimationPosY:Int()
			Local centerY:= 0
			Local offsetX:= Self.animationX
			Local offsetY:= Self.animationY
			
			If (Self.centerPoint <> Null) Then
				Local centerX:= Self.centerPoint.showX
				
				centerY = Self.centerPoint.showY
				
				offsetX -= Self.centerPoint.f21x
				offsetY -= Self.centerPoint.f22y
			EndIf
			
			Return (MyAPI.getRelativePointY(centerY, (offsetX Shl PyxAnimation.ZOOM), (offsetY Shl PyxAnimation.ZOOM), Self.calDegree) Shr PyxAnimation.ZOOM)
		End
End
		
Class NodeInfo
	Public
		' Fields:
		Field drawer:AnimationDrawer
		
		Field animationX:Int
		Field animationY:Int
		
		Field degree:Int
		
		Field rotateX:Int
		Field rotateY:Int
	Private
		' Fields:
		Field got:Bool
	Public
		' Methods:
		Method reset:Void()
			Self.got = False
		End
		
		Method hasNode:Bool()
			Return Self.got
		End
End