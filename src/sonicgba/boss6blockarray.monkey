Strict

Public

' Friends:
Friend sonicgba.gimmickobject
Friend sonicgba.bossobject
Friend sonicgba.enemyobject
'Friend sonicgba.boss6block
Friend sonicgba.boss6

' Imports:
Private
	Import sonicgba.boss6block
	
	Import sonicgba.effect
	
	Import sonicgba.gimmickobject
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Boss6BlockArray Extends GimmickObject
	Private
		' Constant variable(s):
		Const BLOCK_NUM:Int = 9
		
		Const BLOCK_SIZE:Int = 2048
		
		Const COLLISION_WIDTH:Int = 18432
		Const COLLISION_HEIGHT:Int = 1536
		
		Const DEEP_STANDARD_OFFSET:Int = 8 ' (BLOCK_NUM - 1)
		
		Const TYPE_NORMAL:Int = 0
		Const TYPE_DEEP:Int = 1
		
		' Fields:
		Field collisionFlag:Bool
		
		Field block:Boss6Block[]
		Field blockOffsetY:Int[]
		
		Field type:Int
		Field preblockID:Int
		
		Field deep_cn:Int
		Field normal_cn:Int
		
		Field blockOrgPosY:Int
		Field blockStartX:Int
		
		Field playerPosY:Int
	Protected
		' Constructor(s):
		Method New(x:Int, y:Int)
			Super.New(GIMMICK_BOSS6_BLOCK_ARRAY, x, y, 0, 0, 0, 0)
			
			' Magic number: -1
			Self.preblockID = -1
			
			' Magic number: 1024
			Self.posX += (BLOCK_SIZE / 2) ' 1024
			
			' Magic number: 8192
			Self.blockStartX = (Self.posX - (BLOCK_SIZE * 4)) ' 8192
			
			Self.blockOrgPosY = Self.posY
			
			' Magic number: 1024
			Self.playerPosY = (Self.posY - (BLOCK_SIZE / 2)) ' 1024
			
			Self.block = New Boss6Block[BLOCK_NUM]
			
			Self.blockOffsetY = New Int[BLOCK_NUM]
			
			For Local i:= 0 Until BLOCK_NUM
				Self.block[i] = New Boss6Block(Self.blockStartX + (i * BLOCK_SIZE), Self.blockOrgPosY)
			Next
			
			Self.collisionFlag = False
			
			Self.deep_cn = 0
			Self.normal_cn = 0
		End
	Private
		' Methods:
		
		' This method will likely be reimplemented at some point.
		Method logicShake:Void()
			Local blockID:= (((player.getFootPositionX() - Self.blockStartX) + (BLOCK_SIZE / 2)) / BLOCK_SIZE)
			
			If (Self.collisionFlag And Self.type = TYPE_DEEP) Then
				' Bounce-effect logic:
				Select (Self.deep_cn)
					Case 0
						If (blockID = 1) Then
							Self.blockOffsetY[0] = 256 ' (BLOCK_SIZE / 8)
							
							For Local i:= 1 Until BLOCK_NUM
								Self.blockOffsetY[i] = ((BLOCK_NUM - i) * 2) Shl 6
							Next
						ElseIf (blockID = 7) Then
							Self.blockOffsetY[(BLOCK_NUM - 1)] = 256 ' (BLOCK_SIZE / 8)
							
							For Local i:= 0 Until (BLOCK_NUM - 1) ' DEEP_STANDARD_OFFSET
								Self.blockOffsetY[i] = ((i + 1) * 2) Shl 6
							Next
						ElseIf (blockID = 0) Then
							Self.blockOffsetY[0] = 256
							
							Self.blockOffsetY[1] = 384
							Self.blockOffsetY[2] = 384
							Self.blockOffsetY[3] = 256
							Self.blockOffsetY[4] = 256
							Self.blockOffsetY[5] = 256
							Self.blockOffsetY[6] = 128
							Self.blockOffsetY[7] = 128
							Self.blockOffsetY[8] = 128
						ElseIf (blockID = 8) Then
							Self.blockOffsetY[0] = 128
							Self.blockOffsetY[1] = 128
							Self.blockOffsetY[2] = 128
							Self.blockOffsetY[3] = 256
							Self.blockOffsetY[4] = 256
							Self.blockOffsetY[5] = 256
							Self.blockOffsetY[6] = 384
							Self.blockOffsetY[7] = 384
							
							Self.blockOffsetY[8] = 256
						Else
							For Local i:= 0 Until BLOCK_NUM
								If (i = (blockID - 4) Or i = (blockID + 4)) Then
									Self.blockOffsetY[i] = 128
								ElseIf (i = (blockID - 3) Or i = (blockID + 3)) Then
									Self.blockOffsetY[i] = 256
								ElseIf (i = (blockID - 2) Or i = (blockID + 2)) Then
									Self.blockOffsetY[i] = 640
								ElseIf (i = (blockID - 1) Or i = (blockID + 1)) Then
									Self.blockOffsetY[i] = 896
								ElseIf (i = blockID) Then
									Self.blockOffsetY[i] = 1024 ' (BLOCK_SIZE / 2)
								Else
									Self.blockOffsetY[i] = 128
								EndIf
							Next
						EndIf
						
						If (Self.blockOffsetY[0] >= 256) Then
							Self.blockOffsetY[0] = 256
						EndIf
						
						If (Self.blockOffsetY[8] >= 256) Then
							Self.blockOffsetY[8] = 256
						EndIf
						
						Self.deep_cn += 1
					Case 1
						If (blockID = 1) Then
							Self.blockOffsetY[0] = 256
							
							For Local i:= 1 Until BLOCK_NUM
								Self.blockOffsetY[i] = (BLOCK_NUM - i) Shl 6
							Next
						ElseIf (blockID = 7) Then
							Self.blockOffsetY[8] = 256
							
							For Local i:= 0 Until (BLOCK_NUM - 1)
								Self.blockOffsetY[i] = ((i + 1) Shl 6)
							Next
						ElseIf (blockID = 0) Then
							Self.blockOffsetY[0] = 256
							
							Self.blockOffsetY[1] = 192
							Self.blockOffsetY[2] = 192
							Self.blockOffsetY[3] = 128
							Self.blockOffsetY[4] = 128
							Self.blockOffsetY[5] = 128
							Self.blockOffsetY[6] = 64
							Self.blockOffsetY[7] = 64
							Self.blockOffsetY[8] = 64
						ElseIf (blockID = (BLOCK_NUM - 1)) Then
							Self.blockOffsetY[0] = 64
							Self.blockOffsetY[1] = 64
							Self.blockOffsetY[2] = 64
							Self.blockOffsetY[3] = 128
							Self.blockOffsetY[4] = 128
							Self.blockOffsetY[5] = 128
							Self.blockOffsetY[6] = 192
							Self.blockOffsetY[7] = 192
							
							Self.blockOffsetY[8] = 256
						Else
							For Local i:= 0 Until BLOCK_NUM
								If (i = (blockID - 4) Or i = (blockID - 4)) Then
									Self.blockOffsetY[i] = 64
								ElseIf (i = (blockID - 3) Or i = (blockID + 3)) Then
									Self.blockOffsetY[i] = 128
								ElseIf (i = (blockID - 2) Or i = (blockID + 2)) Then
									Self.blockOffsetY[i] = 320
								ElseIf (i = (blockID - 1) Or i = (blockID + 1)) Then
									Self.blockOffsetY[i] = 448
								ElseIf (i = blockID) Then
									Self.blockOffsetY[i] = 512
								Else
									Self.blockOffsetY[i] = 64
								EndIf
							Next
						EndIf
						
						If (Self.blockOffsetY[0] >= 256) Then
							Self.blockOffsetY[0] = 256
						EndIf
						
						If (Self.blockOffsetY[8] >= 256) Then
							Self.blockOffsetY[8] = 256
						EndIf
						
						Self.deep_cn += 1
					Case 2
						For Local i:= 0 Until BLOCK_NUM
							Self.blockOffsetY[i] = 0
						Next
						
						Self.deep_cn += 1
					Case 3
						If (blockID = 1) Then
							Self.blockOffsetY[0] = 0
							
							For Local i:= 1 Until BLOCK_NUM
								Self.blockOffsetY[i] = (-(BLOCK_NUM - i)) Shl 6
							Next
						ElseIf (blockID = 7) Then
							Self.blockOffsetY[8] = 0
							
							For Local i:= 0 Until (BLOCK_NUM - 1)
								Self.blockOffsetY[i] = (-(i + 1)) Shl 6
							Next
						ElseIf (blockID = 0) Then
							Self.blockOffsetY[0] = 0
							
							Self.blockOffsetY[1] = -192
							Self.blockOffsetY[2] = -192
							Self.blockOffsetY[3] = -128
							Self.blockOffsetY[4] = -128
							Self.blockOffsetY[5] = -128
							Self.blockOffsetY[6] = -64
							Self.blockOffsetY[7] = -64
							Self.blockOffsetY[8] = -64
						ElseIf (blockID = (BLOCK_NUM - 1)) Then
							Self.blockOffsetY[0] = -64
							Self.blockOffsetY[1] = -64
							Self.blockOffsetY[2] = -64
							Self.blockOffsetY[3] = -128
							Self.blockOffsetY[4] = -128
							Self.blockOffsetY[5] = -128
							Self.blockOffsetY[6] = -192
							Self.blockOffsetY[7] = -192
							
							Self.blockOffsetY[8] = 0
						Else
							For Local i:= 0 Until BLOCK_NUM
								If (i = (blockID - 4) Or i = (blockID + 4)) Then
									Self.blockOffsetY[i] = -64
								ElseIf (i = (blockID - 3) Or i = (blockID + 3)) Then
									Self.blockOffsetY[i] = -128
								ElseIf (i = (blockID - 2) Or i = (blockID + 2)) Then
									Self.blockOffsetY[i] = -320
								ElseIf (i = (blockID - 1) Or i = (blockID + 1)) Then
									Self.blockOffsetY[i] = -448
								ElseIf (i = blockID) Then
									Self.blockOffsetY[i] = -512
								Else
									Self.blockOffsetY[i] = -64
								EndIf
							Next
						EndIf
						
						If (Self.blockOffsetY[0] <= 0) Then
							Self.blockOffsetY[0] = 0
						EndIf
						
						If (Self.blockOffsetY[8] <= 0) Then
							Self.blockOffsetY[8] = 0
						EndIf
						
						Self.deep_cn += 1
					Case 4
						For Local i:= 0 Until BLOCK_NUM
							Self.blockOffsetY[i] = 0
						Next
						
						Self.deep_cn += 1
					Case 5
						Self.type = TYPE_NORMAL
						
						Self.normal_cn = 0
				End Select
			EndIf
			
			If (Self.collisionFlag And Self.type = TYPE_NORMAL) Then
				If (Self.preblockID <> blockID) Then
					Self.normal_cn = 0
				EndIf
				
				Self.preblockID = blockID
				
				Self.deep_cn = 0
				
				If (blockID = 1) Then
					Self.blockOffsetY[0] = 256
					
					For Local i:= 1 Until BLOCK_NUM
						Self.blockOffsetY[i] = (BLOCK_NUM - i) Shl 6
					Next
				ElseIf (blockID = 7) Then
					Self.blockOffsetY[8] = 256
					
					For Local i:= 0 Until (BLOCK_NUM - 1)
						Self.blockOffsetY[i] = (i + 1) Shl 6
					Next
				ElseIf (blockID = 0) Then
					Self.blockOffsetY[0] = 256
					
					Self.blockOffsetY[1] = 192
					Self.blockOffsetY[2] = 192
					Self.blockOffsetY[3] = 128
					Self.blockOffsetY[4] = 128
					Self.blockOffsetY[5] = 128
					Self.blockOffsetY[6] = 64
					Self.blockOffsetY[7] = 64
					Self.blockOffsetY[8] = 64
				ElseIf (blockID = (BLOCK_NUM - 1)) Then
					Self.blockOffsetY[0] = 64
					Self.blockOffsetY[1] = 64
					Self.blockOffsetY[2] = 64
					Self.blockOffsetY[3] = 128
					Self.blockOffsetY[4] = 128
					Self.blockOffsetY[5] = 128
					Self.blockOffsetY[6] = 192
					Self.blockOffsetY[7] = 192
					
					Self.blockOffsetY[8] = 256
				Else
					For Local i:= 0 Until BLOCK_NUM
						If (i = (blockID - 4) Or i = (blockID + 4)) Then
							Self.blockOffsetY[i] = 64
						ElseIf (i = (blockID - 3) Or i = (blockID + 3)) Then
							Self.blockOffsetY[i] = 128
						ElseIf (i = (blockID - 2) Or i = (blockID + 2)) Then
							Self.blockOffsetY[i] = 320
						ElseIf (i = (blockID - 1) Or i = (blockID + 1)) Then
							Self.blockOffsetY[i] = 448
						ElseIf (i = blockID) Then
							Self.blockOffsetY[i] = 512
						Else
							Self.blockOffsetY[i] = 64
						EndIf
					Next
				EndIf
				
				If (Self.blockOffsetY[0] >= 256) Then
					Self.blockOffsetY[0] = 256
				EndIf
				
				If (Self.blockOffsetY[8] >= 256) Then
					Self.blockOffsetY[8] = 256
				EndIf
			EndIf
		End
	Public
		' Methods:
		Method draw:Void(g:MFGraphics)
			For Local i:= 0 Until BLOCK_NUM
				Self.block[i].draw(g)
			Next
			
			drawCollisionRect(g)
		End
		
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			Self.collisionFlag = True
			
			' Magic number: 1000
			If (player.getVelY() > 1000) Then ' Alternatively: (BLOCK_SIZE / 2)
				Self.type = TYPE_DEEP
				Self.deep_cn = 0
			ElseIf (player.getVelY() >= 0 And Self.deep_cn = 5) Then
				Self.type = TYPE_NORMAL
				Self.deep_cn = 0
			EndIf
		End
		
		Method doWhileNoCollision:Void()
			Self.collisionFlag = False
			
			Self.deep_cn = 0
		End
		
		Method getBossY:Int(bossPosX:Int)
			Return (Self.blockOrgPosY + Self.blockOffsetY[((bossPosX - Self.blockStartX) + (BLOCK_SIZE / 2)) / BLOCK_SIZE])
		End
		
		Method logic:Void()
			refreshCollisionRect(Self.posX, Self.posY)
			
			If (collisionChkWithObject(player)) Then
				doWhileCollisionWrap(player)
			ElseIf (Self.deep_cn = 0) Then
				doWhileNoCollision()
			EndIf
			
			If (player.collisionState = PlayerObject.COLLISION_STATE_JUMP) Then
				For Local i:= 0 Until BLOCK_NUM
					Self.blockOffsetY[i] = 0
				Next
			EndIf
			
			logicShake()
			
			For Local i:= 0 Until BLOCK_NUM
				Self.block[i].logic(Self.blockStartX + (i * BLOCK_SIZE), Self.blockOrgPosY + Self.blockOffsetY[i])
			Next
		End
		
		' This triggers the floor to break:
		Method setDisplayState:Void()
			For Local i:= 0 Until BLOCK_NUM
				Self.block[i].setDisplayState(False)
				
				' Magic number: 10
				Effect.showEffect(destroyEffectAnimation, 0, (Self.blockStartX + (i * BLOCK_SIZE)) Shr 6, (Self.posY Shr 6) - 10, 0)
			Next
			
			player.collisionState = PlayerObject.COLLISION_STATE_JUMP
			
			player.setAnimationId(PlayerObject.ANI_FALLING)
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x - (COLLISION_WIDTH / 2), y - (COLLISION_HEIGHT / 2), COLLISION_WIDTH, COLLISION_HEIGHT)
		End
End