Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	Import regal.typetool
Public

' Classes:
Class LightFont Extends GimmickObject
	Private
		' Constant variable(s):
		Const CLOSE_FRAME:Int = 72
		
		Const COLLISION_WIDTH:Int = 1408
		Const COLLISION_HEIGHT:Int = 1792
		
		Const FONT_S:Int = 0
		Const FONT_O:Int = 1
		Const FONT_N:Int = 2
		Const FONT_I:Int = 3
		Const FONT_C:Int = 4
		Const FONT_E:Int = 5
		Const FONT_G:Int = 6
		Const FONT_A:Int = 7
		
		Const FONT_NUM:Int = 8
		
		Const OPENING_FRAME:Int = 50
		
		' Global variable(s):
		Global lightFontAnimation:Animation[]
		
		' Fields:
		Field logicDelay:Int
	Public
		' Fields:
		Field drawer:AnimationDrawer
		
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimationArray(lightFontAnimation)
			
			lightFontAnimation = []
		End
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (lightFontAnimation = Null) Then
				lightFontAnimation = New Animation[FONT_NUM]
			EndIf
			
			If (lightFontAnimation[left] = Null) Then
				lightFontAnimation[left] = New Animation(MFImage.createImage("/animation/light_font_" + left + ".png"), "/animation/light_font")
			EndIf
			
			Self.drawer = lightFontAnimation[left].getDrawer(1, False, 0) ' FONT_O ' FONT_S
			Self.drawer.setPause(True)
			
			Self.logicDelay = width
		End
	Public
		' Methods:
		Method logic:Void()
			Self.drawer.moveOn()
			
			If (Self.drawer.checkEnd()) Then
				If (Self.drawer.getActionId() = FONT_S) Then ' 0
					Self.drawer.setActionId(FONT_O)
				ElseIf (Self.drawer.getActionId() = FONT_N) Then
					Self.drawer.setActionId(FONT_I)
				EndIf
			EndIf
			
			' Magic numbers: 50, 72, 122
			Local timetemp:= ((((systemClock + 50) + 72) - Long(Self.logicDelay)) Mod 122)
			
			If ((((systemClock + 50) + 72) - Long(Self.logicDelay)) Mod 122 < 72) Then
				If (Self.drawer.getActionId() = FONT_O) Then
					Self.drawer.setActionId(FONT_N)
				EndIf
			ElseIf (Self.drawer.getActionId() = FONT_I) Then
				Self.drawer.setActionId(FONT_S)
			EndIf
			
			refreshCollisionRect(Self.posX, Self.posY)
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
		
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			
			drawCollisionRect(g)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.drawer.getActionId() = FONT_I) Then
				player.cancelFootObject(Self)
			Else
				player.beStop(Self.collisionRect.x0, direction, Self)
			EndIf
		End
		
		Method close:Void()
			Self.drawer = Null
		End
End