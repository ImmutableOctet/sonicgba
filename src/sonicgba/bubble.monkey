Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.breathebubble
Friend sonicgba.upbubble

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.breathebubble
	Import sonicgba.gimmickobject
	Import sonicgba.upbubble
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import mojo.app
Public

' Classes:

' Bubble generator / "base" object.
Class Bubble Extends GimmickObject
	Private
		' Constant variable(s):
		Const BREATHE_BUBBLE_TIME:Int = 2500
		Const UP_BUBBLE_TIME:Int = 1000
		
		Global createPuyo:Int[] = [70, 80, 32, 54, 32, 80, 64, 32] ' Const
		
		' Global variable(s):
		Global baseAnimation:Animation
		
		' Fields:
		Field baseDrawer:AnimationDrawer
		
		Field createPuyoCount:Int
		Field createPuyoType:Int
		
		Field breatheBubbleFlag:Bool
		Field upBubbleFlag:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.upBubbleFlag = False
			Self.breatheBubbleFlag = False
			
			Self.createPuyoType = 0
			Self.createPuyoCount = 0
			
			If (baseAnimation = Null) Then
				baseAnimation = New Animation("/animation/bubble_base")
			EndIf
			
			If (baseAnimation <> Null) Then
				Self.baseDrawer = baseAnimation.getDrawer(0, True, 0)
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(baseAnimation)
			
			baseAnimation = Null
		End
		
		' Methods:
		Method logic:Void()
			Local milliseconds:= Millisecs()
			Local seconds:= (milliseconds / 1000)
			
			If ((seconds Mod 2) = 0 And Not Self.upBubbleFlag) Then
				GameObject.addGameObject(New UpBubble(Self.posX, Self.posY), Self.posX, Self.posY)
				
				Self.upBubbleFlag = True
			ElseIf ((seconds Mod 2) <> 0) Then
				Self.upBubbleFlag = False
			EndIf
			
			Self.createPuyoCount += 1
			
			If (Self.createPuyoType >= createPuyo.Length) Then
				Self.createPuyoType = 0
			EndIf
			
			If (Self.createPuyoCount >= createPuyo[Self.createPuyoType]) Then
				Self.createPuyoCount = 0
				Self.createPuyoType += 1
				
				GameObject.addGameObject(New BreatheBubble(Self.posX, Self.posY), Self.posX, Self.posY)
				
				Self.breatheBubbleFlag = True
			ElseIf (((milliseconds / 2500) Mod 2) <> 0) Then
				Self.breatheBubbleFlag = False
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.baseDrawer)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method close:Void()
			Self.baseDrawer = Null
		End
End