Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.gimmickobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class TorchFire Extends GimmickObject
	Private
		' Global variable(s):
		Global drawer:AnimationDrawer
		Global drawer2:AnimationDrawer
	Protected
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (drawer = Null) Then
				If (StageManager.getCurrentZoneId() <> 6) Then
					drawer = (New Animation("/animation/torch_fire")).getDrawer(0, True, 0)
				Else
					Local light:= New Animation("/animation/light")
					
					drawer = light.getDrawer(0, True, 0)
					drawer2 = light.getDrawer(1, True, 0)
					
					drawer2.setPause(True)
				EndIf
				
				drawer.setPause(True)
			EndIf
			
			Self.posX += RollPlatformSpeedC.COLLISION_OFFSET_Y
			Self.posY += SpecialMap.MAP_LENGTH
		End
	Public
		' Functions:
		Function staticLogic:Void()
			drawer.moveOn()
			
			' Magic number: Unsure of which zone this is,
			' or where the related variable is defined.
			If (StageManager.getCurrentZoneId() = 6) Then
				drawer2.moveOn()
			End
		End
		
		Function releaseAllResource:Void()
			Animation.closeAnimationDrawer(drawer)
			Animation.closeAnimationDrawer(drawer2)
			
			drawer2 = Null
			drawer = Null
		End
		
		' Methods:
		Method draw:Void(graphics:MFGraphics)
			' Magic numbers: Not entirely sure about these coordinates...
			If (StageManager.getCurrentZoneId() <> 6) Then
				drawInMap(graphics, drawer)
			ElseIf (Self.iLeft = 0) Then
				drawInMap(graphics, drawer, Self.posX + GimmickObject.PLATFORM_OFFSET_Y, Self.posY - 1280) ' -256
			Else
				drawInMap(graphics, drawer2, Self.posX + GimmickObject.PLATFORM_OFFSET_Y, Self.posY - 1280) ' -256
			EndIf
		End
	
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End