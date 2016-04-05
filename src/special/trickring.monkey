Strict

Public

' Imports:
Private
	Import lib.soundsystem
	
	Import special.ssfollowring
	Import special.specialobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class TrickRing Extends SpecialObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 60
		Const COLLISION_HEIGHT:Int = 60
		
		' These are the positions of 'SSFollowRing' objects, which generated when a collision occurs.
		Global RING_GEN_PARAM:Int[][] = [[60, 0], [50, -50], [0, -60], [-50, -50], [-60, 0], [-50, 50], [0, 60], [50, 50], [100, 0], [0, -100], [-100, 0], [0, 100]] ' Const
		
		' Fields:
		Field used:Bool
	Public
		' Constructor(s):
		Method New(x:Int, y:Int, z:Int)
			Super.New(SSOBJ_TRIC_ID, x, y, z)
			
			Self.drawer = objAnimation.getDrawer(0, True, 0)
			
			Self.used = False
		End
		
		' Methods:
		Method close:Void()
			Self.drawer = Null
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			If (Not Self.used) Then
				For Local param:= EachIn RING_GEN_PARAM
					Local tmpObj:= New SSFollowRing(Self.posX + param[0], Self.posY + param[1], Self.posZ Shl 3, False)
					
					SpecialObject.addExtraObject(tmpObj)
					decideObjects.Push(tmpObj)
				Next
				
				player.setTrikCount()
				
				SoundSystem.getInstance().playSe(SoundSystem.SE_150)
				
				Self.drawer.setActionId(1)
				Self.drawer.setLoop(False)
				
				Self.used = True
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			SpecialObject.calDrawPosition(Self.posX, Self.posY, Self.posZ)
			drawObj(g, Self.drawer, 0, 0)
		End
		
		Method logic:Void()
			' Empty implementation.
		End
		
		Method refreshCollision:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End