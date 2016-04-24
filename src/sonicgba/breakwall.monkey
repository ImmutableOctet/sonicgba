Strict

Public

#Rem
	TODO:
		* Test uses of fake multi-dimensional array(s).
		* Test performance of data-buffers vs. arrays.
		* Test 'logic' for unknown behavior.
#End

' Imports:
Private
	Import lib.soundsystem
	Import lib.constutil
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	Import sonicgba.stagemanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	Import com.sega.mobile.framework.device.mfimage
	
	'Import brl.databuffer
	'Import regal.sizeof
Public

' Classes:
Class BreakWall Extends GimmickObject
	Private
		' Constant variable(s):
		Const BREAK_NUM_WIDTH:Int = 4
		Const BREAK_NUM_HEIGHT:Int = 9
		
		Const BREAK_WIDTH:Int = 448
		
		Const COLLISION_WIDTH:Int = 2048
		Const COLLISION_HEIGHT:Int = 4096
		
		Const DRAW_BREAK_WIDTH:Int = 7
		
		' Global variable(s):
		Global image:MFImage
		
		' Fields:
		Field breakOver:Bool
		Field breaking:Bool
		
		Field positiveDirection:Bool
		
		Field breakCount:Int
		Field breakLimitLine:Int
		
		Field breakPosition:Int[] ' DataBuffer ' Int[][][]
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.breaking = False
			Self.breakOver = False
			
			Self.posX -= PickValue((Self.iLeft = 0), 0, COLLISION_WIDTH)
			
			Self.breakPosition = New Int[BREAK_NUM_WIDTH*BREAK_NUM_HEIGHT*3]
			
			For Local w:= 0 Until BREAK_NUM_WIDTH
				For Local h:= 0 Until BREAK_NUM_HEIGHT
					Local offset:= getBreakOffset(w, h)
					
					Self.breakPosition[offset] = Self.posX + (w * BREAK_WIDTH) ' + 0
					Self.breakPosition[offset+1] = Self.posY + (h * BREAK_WIDTH)
					Self.breakPosition[offset+2] = -GRAVITY
				Next
			Next
			
			Self.breakLimitLine = (Self.posY + COLLISION_HEIGHT) + COLLISION_WIDTH
			
			If (image = Null) Then
				image = MFImage.createImage("/gimmick/breakWall_" + StageManager.getCurrentZoneId() + ".png")
			EndIf
		End
		
		' Methods:
		
		' Extensions:
		Method getBreakOffset:Int(x:Int, y:Int)
			Return (y * BREAK_NUM_WIDTH) + x
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			image = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (player.isAttackingEnemy()) Then
				doWhileBeAttack(player, direction, 0)
			ElseIf (Not Self.breaking) Then
				player.beStop(0, direction, Self)
			EndIf
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			'Self.breakCount = 0
			
			Self.breaking = True
			Self.breakOver = False
			
			If (direction = DIRECTION_RIGHT) Then
				Self.positiveDirection = True
			ElseIf (direction = DIRECTION_LEFT) Then
				Self.positiveDirection = False
			EndIf
		End
		
		' This method wasn't decompiled properly, and had to be ported using partial source code.
		' This will probably need to be rewritten at a later date:
		Method logic:Void()
			If (Self.breaking And Not Self.breakOver) Then
				Self.breakOver = True
				
				If (Not IsGamePause) Then
					Local i:Int
					
					Local x:Int = PickValue(Self.positiveDirection, 0, (BREAK_NUM_WIDTH - 1))
					
					Local running:Bool = True
					
					Repeat
						If (Self.positiveDirection) Then
							If (x >= 4) Then
								Exit
							EndIf
						ElseIf (x < 0) Then
							Exit
						EndIf
						
						For Local y:= (BREAK_NUM_HEIGHT - 1) To 0 Step -1
							Local offset:= getBreakOffset(w, h)
							
							Local currentGrav:= Self.breakPosition[offset+2]
							
							Self.breakPosition[offset] += PickValue(Self.positiveDirection, 50, -50) ' + 0
							Self.breakPosition[offset+1] += currentGrav
							Self.breakPosition[offset+2] += GRAVITY
							
							If (Self.breakPosition[offset+1] < Self.breakLimitLine) Then
								Self.breakOver = false
							EndIf
							
							i += 1
							
							If (Self.breakCount = 0) Then
								SoundSystem.getInstance().playSe(SoundSystem.SE_173)
							EndIf
							
							If (i >= Self.breakCount) Then
								Self.breakCount += 1
								
								running = False
								
								Exit
							EndIf
						Next
						
						If (Not running) Then
							Exit
						EndIf
						
						x += DSgn(Self.positiveDirection)
					Forever
				EndIf
				
				If (Self.breakCount < (BREAK_NUM_WIDTH * BREAK_NUM_HEIGHT) And Self.breakOver) Then
					Self.breakOver = False
				EndIf
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			drawCollisionRect(g)
			
			If (Not Self.breakOver) Then
				If (Self.breaking) Then
					For Local w:= 0 Until BREAK_NUM_WIDTH
						For Local h:= 0 Until BREAK_NUM_HEIGHT
							Local offset:= getBreakOffset(w, h)
							
							drawInMap(g, image, (w * DRAW_BREAK_WIDTH), (h * DRAW_BREAK_WIDTH), DRAW_BREAK_WIDTH, DRAW_BREAK_WIDTH, 0, Self.breakPosition[offset], Self.breakPosition[offset+1], TOP|LEFT)
						Next
					Next
				Else
					drawInMap(g, image, TOP|LEFT)
				EndIf
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.breakPosition = [] ' Null
		End
		
		Method doInitWhileInCamera:Void()
			Self.breaking = False
			Self.breakOver = False
			
			Self.breakCount = 0
			
			For Local w:= 0 Until BREAK_NUM_WIDTH
				For Local h:= 0 Until BREAK_NUM_HEIGHT
					Local offset:= getBreakOffset(w, h)
					
					Self.breakPosition[offset] = (Self.posX + (w * BREAK_WIDTH)) ' + 0
					Self.breakPosition[offset+1] = (Self.posY + (h * BREAK_WIDTH))
					Self.breakPosition[offset+2] = -GRAVITY
				Next
			Next
		End
End