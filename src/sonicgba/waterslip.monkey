Strict

Public

' Friends:
Friend sonicgba.gimmickobject

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	Import lib.myapi
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class WaterSlip Extends GimmickObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 4096
		Const COLLISION_HEIGHT:Int = 2048
		
		Const DRAW_OFFSET_X:Int = -1024
		
		' Global variable(s):
		Global drawer:AnimationDrawer
		Global drawer2:AnimationDrawer
		Global drawer3:AnimationDrawer
		Global drawer4:AnimationDrawer
		
		Global frame:Int
		
		' Fields:
		Field isActive:Bool
		Field isTouchSand:Bool
		
		Field spaceX:Int
		Field spaceY:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.spaceY = 3072
			Self.spaceX = -6144
			
			Self.isTouchSand = False
			
			If (StageManager.getCurrentZoneId() = 1) Then
				If (drawer = Null) Then
					drawer = New Animation("/animation/water_fall_02").getDrawer(0, True, 0)
					
					drawer.setPause(True)
				EndIf
			ElseIf (StageManager.getCurrentZoneId() = 5) Then
				If (Self.iLeft = 1) Then
					If (drawer = Null Or drawer2 = Null) Then
						Local a:= New Animation("/animation/sand_06")
						
						drawer = a.getDrawer(1, True, 0)
						drawer.setPause(True)
						
						drawer2 = a.getDrawer(0, True, 0)
						drawer2.setPause(True)
					EndIf
					
					Self.spaceY = 3072
					Self.spaceX = -6144
				ElseIf (Self.iLeft = 0) Then
					If (drawer3 = Null Or drawer4 = Null) Then
						Local a:= New Animation("/animation/sand_04")
						
						drawer3 = a.getDrawer(0, True, 0)
						drawer3.setPause(True)
						
						drawer4 = a.getDrawer(1, True, 0)
						drawer4.setPause(True)
					EndIf
					
					Self.spaceY = COLLISION_WIDTH
					Self.spaceX = COLLISION_WIDTH
				EndIf
			EndIf
			
			Self.isTouchSand = False
			Self.isActive = False
		End
	Public
		' Functions:
		Function staticLogic:Void()
			If (drawer <> Null) Then
				drawer.moveOn()
			EndIf
			
			If (drawer2 <> Null) Then
				drawer2.moveOn()
			EndIf
			
			If (drawer3 <> Null) Then
				drawer3.moveOn()
			EndIf
			
			If (drawer4 <> Null) Then
				drawer4.moveOn()
			EndIf
		End
		
		Function releaseAllResource:Void()
			Animation.closeAnimationDrawer(drawer)
			Animation.closeAnimationDrawer(drawer2)
			Animation.closeAnimationDrawer(drawer3)
			Animation.closeAnimationDrawer(drawer4)
			
			drawer = Null
			drawer2 = Null
			drawer3 = Null
			drawer4 = Null
		End
		
		' Methods:
		Method draw:Void(g:MFGraphics)
			If (StageManager.getCurrentZoneId() = 1) Then
				drawInMap(g, drawer)
			ElseIf (StageManager.getCurrentZoneId() = 5) Then
				If (Self.iLeft = 1) Then
					Local i:= (Self.collisionRect.y0 - DRAW_OFFSET_X)
					Local j:= 0
					
					While (i < Self.collisionRect.y1 - PlayerObject.HEIGHT)
						If (i = (Self.collisionRect.y0 - DRAW_OFFSET_X) And Self.iTop = 0) Then
							drawInMap(g, drawer2, (Self.collisionRect.x1 + DRAW_OFFSET_X) + j, i)
						Else
							drawInMap(g, drawer, (Self.collisionRect.x1 + DRAW_OFFSET_X) + j, i)
						EndIf
						
						i += Self.spaceY
						j += Self.spaceX
					Wend
				Else
					MyAPI.setClip(g, (Self.collisionRect.x0 Shr 6) - camera.x, (Self.collisionRect.y0 Shr 6) - camera.y, (Self.collisionRect.getWidth() Shr 6), (Self.collisionRect.getHeight() Shr 6))
					
					Local i:= (Self.collisionRect.y0 - DRAW_OFFSET_X)
					Local j:= 0
					
					While (i < Self.collisionRect.y1)
						drawInMap(g, drawer3, (Self.collisionRect.x0 + j), i)
						
						i += Self.spaceY
						j += Self.spaceX
					Wend
					
					MyAPI.setClip(g, 0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)
				EndIf
			EndIf
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (player.collisionState = PlayerObject.COLLISION_STATE_WALK) Then
				player.setSlip()
				
				frame += 1
				
				Self.isActive = True
				
				If (Self.iLeft = 0) Then
					player.fallinSandSlipState = PlayerObject.FALL_IN_SAND_SLIP_RIGHT
				ElseIf (Self.iLeft = 1) Then
					player.fallinSandSlipState = PlayerObject.FALL_IN_SAND_SLIP_LEFT
				EndIf
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Super.doWhileNoCollision()
			
			Self.isTouchSand = False
			
			If (Self.isActive) Then
				player.fallinSandSlipState = PlayerObject.FALL_IN_SAND_SLIP_NONE
				
				Self.isActive = False
			EndIf
		End
End