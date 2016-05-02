Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myrandom
	
	Import sonicgba.gimmickobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class UpBubble Extends GimmickObject
	Private
		' Global variable(s):
		Global bubbleAnimation:Animation
		
		' Fields:
		Field LIFE_RANGE:Int ' Final
		
		Field direct:Int
		
		Field posOriginalY:Int
		
		Field velx:Int
		Field vely:Int
		
		Field drawer:AnimationDrawer
		
		Field group:Int[]
		
		Field initFlag:Bool
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(bubbleAnimation)
			
			bubbleAnimation = Null
		End
	Protected
		' Constructor(s):
		Method Construct_UpBubble:Void()
			Self.velx = 0
			Self.vely = -120
			
			Self.direct = 0
			
			' Magic number: 6400
			Self.LIFE_RANGE = 6400
			
			Local iArr:= New Int[12]
			
			iArr[1] = 1
			iArr[2] = 2
			iArr[4] = 1
			iArr[5] = 2
			iArr[7] = 1
			iArr[8] = 2
			iArr[10] = 1
			iArr[11] = 2
			
			Self.group = iArr
		End
		
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Construct_UpBubble()
		End
	Public
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(0, x, y, 0, 0, 0, 0)
			
			Construct_UpBubble()
			
			If (bubbleAnimation = Null) Then
				bubbleAnimation = New Animation("/animation/bubble_up")
			EndIf
			
			If (bubbleAnimation <> Null) Then
				Self.drawer = bubbleAnimation.getDrawer(Self.group[MyRandom.nextInt(Self.group.Length)], True, 0)
				
				Self.direct = MyRandom.nextInt(-1, 1)
			EndIf
			
			Self.posOriginalY = Self.posY
			
			Self.initFlag = False
		End
	Public
		' Methods:
		Method getPaintLayer:Int()
			Return DRAW_AFTER_SONIC
		End
		
		Method logic:Void()
			If (Not Self.initFlag) Then
				If (Self.direct >= 0) Then
					Self.velx = MyRandom.nextInt(0, 20)
				Else
					Self.velx = MyRandom.nextInt(-20, 0)
				EndIf
				
				Self.posX += Self.velx
				Self.posY += Self.vely
				
				refreshCollisionRect(Self.posX, Self.posY)
				
				If (Self.posY <= (StageManager.getWaterLevel() Shl 6)) Then
					Self.initFlag = True
				EndIf
			EndIf
		End
		
		Method IsDie:Bool()
			Return Self.initFlag
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.initFlag) Then
				drawInMap(g, Self.drawer, Self.posX, Self.posY)
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			' Magic numbers: 5, 10
			Self.collisionRect.setRect(x - 5, y - 5, 10, 10)
		End
		
		Method objectChkDestroy:Bool()
			Return Self.initFlag
		End
End