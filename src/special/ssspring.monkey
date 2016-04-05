Strict

Public

' Imports:
Private
	Import lib.soundsystem
	
	Import special.specialobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class SSSpring Extends SpecialObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 32
		Const COLLISION_HEIGHT:Int = 32
		
		Const SPRING_POWER:Int = 5
		Const SPRING_UP_POWER:Int = 8
		Const SPRING_XY_POWER:Int = 11
		
		' Fields:
		Field actionID:Int
		Field used:Bool
	Public
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, z:Int)
			Super.New(id, x, y, z)
			
			' Check the spring-direction:
			Select (Self.objID) ' id
				Case SSOBJ_BNBK_ID ' Default
					Self.actionID = 4
				Case SSOBJ_BNGO_ID
					Self.actionID = 5
				Case SSOBJ_BNLU_ID
					Self.actionID = 6
				Case SSOBJ_BNRU_ID
					Self.actionID = 7
				Case SSOBJ_BNLD_ID
					Self.actionID = 8
				Case SSOBJ_BNRD_ID
					Self.actionID = 9
				Default
					Self.actionID = 4
			End Select
			
			Self.drawer = objAnimation.getDrawer(Self.actionID, True, 0)
			
			Self.used = False
		End
		
		' Methods:
		Method close:Void()
			Self.drawer = Null
		End
		
		Method doWhileCollision:Void(collisionObj:SpecialObject)
			If (Not Self.used) Then
				Select (Self.objID)
					Case SSOBJ_BNBK_ID
						player.beSpringX(0)
						player.beSpringY(0)
						player.beSpringZ(-SPRING_UP_POWER)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_148)
					Case SSOBJ_BNGO_ID
						player.beSpringX(0)
						player.beSpringY(0)
						player.beSpringZ(SPRING_POWER)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_148)
					Case SSOBJ_BNLU_ID
						player.beSpringX(-SPRING_XY_POWER)
						player.beSpringY(-SPRING_XY_POWER)
						player.beSpringZ(SPRING_POWER)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_148)
					Case SSOBJ_BNRU_ID
						player.beSpringX(SPRING_XY_POWER)
						player.beSpringY(-SPRING_XY_POWER)
						player.beSpringZ(SPRING_POWER)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_148)
					Case SSOBJ_BNLD_ID
						player.beSpringX(-SPRING_XY_POWER)
						player.beSpringY(SPRING_XY_POWER)
						player.beSpringZ(SPRING_POWER)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_148)
					Case SSOBJ_BNRD_ID
						player.beSpringX(SPRING_XY_POWER)
						player.beSpringY(SPRING_XY_POWER)
						player.beSpringZ(SPRING_POWER)
						
						SoundSystem.getInstance().playSe(SoundSystem.SE_148)
				End Select
				
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