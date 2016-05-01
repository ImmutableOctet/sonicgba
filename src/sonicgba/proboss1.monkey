Strict

Public

' Friends:
Friend sonicgba.enemyobject
Friend sonicgba.bossobject
Friend sonicgba.bossbroken

' Imports:
Private
	Import gameengine.def
	
	Import lib.animation
	Import lib.animationdrawer
	Import lib.soundsystem
	
	Import sonicgba.enemyobject
	Import sonicgba.mapmanager
	Import sonicgba.playerobject
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class ProBoss1 Extends EnemyObject
	Private
		' Constant variable(s):
		Const COLLISION_WIDTH:Int = 1792
		Const COLLISION_HEIGHT:Int = 64
		
		Const SIDE:Int = 671232
		Const SIDE_DOWN_MIDDLE:Int = 720
		
		' States:
		Const STATE_WAIT:Int = 0
		Const STATE_FIND:Int = 1
		Const STATE_ANGRY:Int = 2
		Const STATE_TURN1:Int = 3
		Const STATE_TURN2:Int = 4
		Const STATE_GO:Int = 5
		
		' Global variable(s):
		Global boatAni:Animation
		Global faceAni:Animation
		
		' Fields:
		Field boatdrawer:AnimationDrawer
		Field facedrawer:AnimationDrawer
		
		Field StartX:Int
		
		Field state:Int
		Field velocity:Int
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			Self.velocity = 576
			
			Self.posX -= (Self.iLeft * 8)
			Self.posY -= (Self.iTop * 8)
			
			Self.posY += 1280
			
			Self.StartX = Self.posX
			
			refreshCollisionRect((Self.posX Shr 6), (Self.posY Shr 6))
			
			If (boatAni = Null) Then
				boatAni = New Animation("/animation/pod_boat")
			EndIf
			
			Self.boatdrawer = boatAni.getDrawer(0, True, 0)
			
			If (faceAni = Null) Then
				faceAni = New Animation("/animation/pod_face")
			EndIf
			
			Self.facedrawer = faceAni.getDrawer(0, True, 0)
		End
	Public
		' Functions:
		Function releaseAllResource:Void()
			Animation.closeAnimation(boatAni)
			Animation.closeAnimation(faceAni)
			
			boatAni = Null
			faceAni = Null
		End
		
		' Methods:
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			#Rem
				If (Not Self.dead) Then
					' Nothing so far.
				EndIf
			#End
		End
		
		Method doWhileBeAttack:Void(player:PlayerObject, direction:Int, animationID:Int)
			' Empty implementation.
		End
		
		Method logic:Void()
			If (Not Self.dead) Then
				If (Self.state > 0) Then
					isBossEnter = True
				EndIf
				
				Select (Self.state)
					Case STATE_WAIT
						If (player.getFootPositionX() >= SIDE) Then
							If (Not Self.IsPlayBossBattleBGM) Then
								bossFighting = True
								
								bossID = ENEMY_PROBOSS1
								
								SoundSystem.getInstance().playBgm(SoundSystem.BGM_BOSS_02, True)
								
								Self.IsPlayBossBattleBGM = True
								
								Local side_down:= ((MapManager.CAMERA_HEIGHT / 4) + SIDE_DOWN_MIDDLE)
								
								MapManager.setCameraDownLimit(side_down)
								MapManager.setCameraUpLimit(side_down - SCREEN_HEIGHT)
								MapManager.setCameraLeftLimit(MapManager.getCamera().x)
							EndIf
							
							Self.state = STATE_FIND
							
							player.setMeetingBoss(False)
							
							Self.facedrawer.setActionId(1)
							Self.facedrawer.setLoop(False)
						EndIf
					Case STATE_FIND
						If (Self.facedrawer.checkEnd()) Then
							Self.state = STATE_ANGRY
							
							Self.facedrawer.setActionId(2)
							Self.facedrawer.setLoop(False)
						EndIf
					Case STATE_ANGRY
						If (Self.facedrawer.checkEnd()) Then
							Self.state = STATE_TURN1
							
							Self.facedrawer.setActionId(0)
							Self.facedrawer.setLoop(True)
							
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setLoop(False)
						EndIf
					Case STATE_TURN1
						If (Self.boatdrawer.checkEnd()) Then
							Self.state = STATE_TURN2
							
							Self.facedrawer.setActionId(0)
							Self.facedrawer.setTrans(TRANS_MIRROR)
							Self.facedrawer.setLoop(True)
							
							Self.boatdrawer.setActionId(1)
							Self.boatdrawer.setTrans(TRANS_MIRROR)
							Self.boatdrawer.setLoop(False)
						EndIf
					Case STATE_TURN2
						If (Self.boatdrawer.checkEnd()) Then
							Self.state = STATE_GO
							
							Self.boatdrawer.setActionId(0)
							Self.boatdrawer.setTrans(TRANS_MIRROR)
							Self.boatdrawer.setLoop(True)
						EndIf
					Case STATE_GO
						Self.posX += Self.velocity
						
						' Magic number: 200
						If (((Self.posX - Self.StartX) Shr 6) >= 200) Then
							player.setMeetingBoss(True)
							
							MapManager.lockCamera(False)
						EndIf
				End Select
			EndIf
		End
		
		Method draw:Void(g:MFGraphics)
			If (Not Self.dead) Then
				drawInMap(g, Self.boatdrawer)
				
				' Magic number: 1664
				drawInMap(g, Self.facedrawer, Self.posX, Self.posY - 1664)
			EndIf
		End
		
		Method refreshCollisionRect:Void(x:Int, y:Int)
			Self.collisionRect.setRect(x, y, COLLISION_WIDTH, COLLISION_HEIGHT)
		End
		
		Method close:Void()
			Self.boatdrawer = Null
			Self.facedrawer = Null
			
			Super.close()
		End
End