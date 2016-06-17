Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Accelerate Extends GimmickObject
	Private
		' Constant variable(s):
		Const ACCELERATE_POWER:Int = 3072 ' (COLLISION_WIDTH * 2)
		
		Const COLLISION_WIDTH:Int = 1536
		Const COLLISION_HEIGHT:Int = 640
		
		' Global variable(s):
		Global accelerate2Animation:Animation
		Global accelerateAnimation:Animation
		
		' Fields:
		Field drawer:AnimationDrawer
		Field touching:Bool
		Field transMirror:Bool
	Protected
		' Consturctor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.touching = False
			
			Self.transMirror = (Self.iTop <> 0)
			
			If (Self.objId = GIMMICK_DASH_PANEL_HIGH) Then
				If (accelerate2Animation = Null) Then
					accelerate2Animation = New Animation("/animation/accelerate2")
				EndIf
				
				Self.drawer = accelerate2Animation.getDrawer(0, True, PickValue(Self.transMirror, 2, 0))
				
				' Magic number: 512
				Self.posY += 512 ' (8 Shl 6)
			ElseIf (Self.objId = GIMMICK_DASH_PANEL_TATE) Then
				If (accelerateAnimation = Null) Then
					accelerateAnimation = New Animation("/animation/accelerate")
				EndIf
				
				Self.drawer = accelerateAnimation.getDrawer(0, True, PickValue(Self.transMirror, 7, 6))
			Else
				If (accelerateAnimation = Null) Then
					accelerateAnimation = New Animation("/animation/accelerate")
				EndIf
				
				Self.drawer = accelerateAnimation.getDrawer((Self.objId - GIMMICK_ACCELERATOR_FORWARD), True, PickValue(Self.transMirror, 2, 0))
			EndIf
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(accelerateAnimation)
			Animation.closeAnimation(accelerate2Animation)
			
			accelerateAnimation = Null
			accelerate2Animation = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			drawInMap(g, Self.drawer)
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(p:PlayerObject, direction:Int)
			' This behavior may change in the future:
			If (Self.touching Or p <> player) Then
				Return
			EndIf
			
			If (Self.objId <> GIMMICK_DASH_PANEL_TATE) Then
				If (p.beAccelerate(DSgn(Not Self.transMirror) * ACCELERATE_POWER, True, Self)) Then
					Self.touching = True
					
					soundInstance.playSe(SoundSystem.SE_172)
				EndIf
			Else
				If (p.beAccelerate(DSgn(Not Self.transMirror) * ACCELERATE_POWER, False, Self)) Then
					Self.touching = True
					
					soundInstance.playSe(SoundSystem.SE_172)
				EndIf
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.touching = False
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - COLLISION_HEIGHT, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.drawer = Null
		End
		
		Method getPaintLayer:Int()
			Return DRAW_BEFORE_SONIC
		End
End