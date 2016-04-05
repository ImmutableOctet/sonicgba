Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.soundsystem
	
	Import special.specialobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SSRing Extends SpecialObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 40
		Const COLLISION_HEIGHT:Int = 40
		
		' Global variable(s):
		Global ringAnimation:Animation
	Protected
		' Constant variable(s):
		Const OFFSET_Y:Int = 8
		
		' Fields:
		Field used:Bool
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int)
			Super.New(SSOBJ_RING_ID, x, y, z)
			
			If (ringAnimation = Null) Then
				ringAnimation = New Animation("/animation/ring")
				
				ringDrawer = ringAnimation.getDrawer(0, True, 0)
				ringDrawer.setPause(True)
			EndIf
			
			Self.drawer = ringAnimation.getDrawer(1, False, 0)
			Self.used = False
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			SpecialObject.calDrawPosition(Self.posX, Self.posY, Self.posZ)
			
			If (Self.used) Then
				drawObj(g, Self.drawer, 0, OFFSET_Y)
			Else
				drawObj(g, ringDrawer, 0, OFFSET_Y)
			EndIf
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			If (Not Self.used) Then
				Self.used = True
				
				player.getRing(1)
				
				SoundSystem.getInstance().playSe(12)
			EndIf
		End
		
		Method logic:Void()
			' Nothing so far.
		End
		
		Method refreshCollision:Void(x:Int, y:Int)
			Self.collisionRect.setRect(Self.posX - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT) ' x - (COLLISION_WIDTH / 2)
		End
		
		Method close:Void()
			' Nothing so far.
		End
End