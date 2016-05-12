Strict

Public

' Imports:
Private
	Import gameengine.key
	
	Import lib.myapi
	Import lib.record
	
	Import sonicgba.gameobject
	Import sonicgba.playerobject
	Import sonicgba.sonicdef
	
	' Imported for 'END_COLOR'.
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import brl.stream
	Import brl.datastream
	
	Import regal.sizeof
	
	Import regal.ioutil.endianstream
	Import regal.ioutil.publicdatastream
Public

' Classes:

' This seems to be some sort of debugging class.
Class ParamSetting ' Implements SonicDef
	Private
		' Constant variable(s):
		Global PARAM_RESET:Int[] = [PlayerObject.MOVE_POWER, PlayerObject.MOVE_POWER_REVERSE, PlayerObject.MAX_VELOCITY, PlayerObject.MOVE_POWER_REVERSE_BALL, PlayerObject.SPIN_START_SPEED_1, PlayerObject.SPIN_START_SPEED_2, PlayerObject.JUMP_START_VELOCITY, PlayerObject.HURT_POWER_X, PlayerObject.HURT_POWER_Y, PlayerObject.JUMP_RUSH_SPEED_PLUS, PlayerObject.GRAVITY, PlayerObject.JUMP_REVERSE_POWER, PlayerObject.FAKE_GRAVITY_ON_WALK, PlayerObject.FAKE_GRAVITY_ON_BALL] ' Const
		
		' Presumably, these are debug names for 'PARAM_RESET':
		'Global PARAM_STR:String[] = ["平地x方向加速度:", "平地x方向反向加速度:", "平地自主跑动最大速度:", "spin x方向反向加速度:", "spin 加速_01 x初速度", "spin 加速_02 x初速度", "大跳速度:", "受伤弹开X:", "受伤弹开Y:", "空中冲刺加速值:", "重力:", "空中横向阻力为速度的XX分之一:", "斜面上伪重力（站立）:", "斜面上伪重力（球）:"] ' Const
		Global PARAM_STR:String[] = ["Flat x-direction acceleration:", "Ground acceleration in the x direction reverse:", "Autonomous ground running maximum speed:", "spin x reversing the direction of acceleration:", "spin speed acceleration beginning _01 x", "spin speed acceleration beginning _02 x", "Fauna speed:", "X bounce injured:", "Injured bounce Y:", "Air sprint acceleration value:", "Gravity:", "Lateral resistance of the air speed one-XX:", "Pseudo-gravity on the inclined surface (standing):", "Bevel pseudo gravity (ball):"] ' Const
		
		' Global variable(s):
		Global paramArray:Int[] = New Int[PARAM_RESET.Length]
		
		Global DRAW_LINE:Int = 10
		
		Global cursol:Int = 0
		Global drawStart:Int = 0
	Public
		' Functions:
		Function init:Void()
			cursol = 0
			
			For Local i:= 0 Until PARAM_RESET.Length
				paramArray[i] = PARAM_RESET[i]
			Next
			
			Local record:= Record.loadRecord(Record.PARAM_RECORD)
			
			If (record <> Null) Then
				Local ds:= New EndianStreamManager<DataStream>(New DataStream(record), True) ' False
				
				For Local i:= 0 Until paramArray.Length
					paramArray[i] = ds.ReadInt()
				Next
				
				ds.Close()
			EndIf
			
			GameObject.setNewParam(paramArray)
		End
		
		Function logic:Bool()
			If (Key.press(Key.B_UP)) Then
				cursol -= 1
				
				cursol += PARAM_STR.Length
				cursol Mod= PARAM_STR.Length
			EndIf
			
			If (Key.press(Key.B_DOWN)) Then
				cursol += 1
				
				cursol += PARAM_STR.Length
				cursol Mod= PARAM_STR.Length
			EndIf
			
			If (Key.repeated(Key.B_LEFT)) Then
				paramArray[cursol] -= 1
			EndIf
			
			If (Key.repeated(Key.B_RIGHT)) Then
				paramArray[cursol] += 1
			EndIf
			
			If (Key.press(Key.B_S1)) Then
				paramArray[cursol] = PARAM_RESET[cursol]
			EndIf
			
			If (Key.press(Key.B_BACK)) Then
				setOver()
				
				Return True
			EndIf
			
			Return False
		End
		
		Function draw:Void(g:MFGraphics)
			g.setColor(MapManager.END_COLOR)
			
			' Magic numbers: 240, 320 (Screen size):
			
			MyAPI.fillRect(g, 0, 0, 240, 320)
			
			g.setColor(0)
			
			drawStart = ((cursol - DRAW_LINE) + 1)
			
			If (drawStart < 0) Then
				drawStart = 0
			EndIf
			
			Local i:= drawStart
			
			While (i < drawStart + DRAW_LINE And i < PARAM_STR.Length)
				MyAPI.drawString(g, (PARAM_STR[i] + ":" + paramArray[i]), 40, (i - drawStart) * 24, 0)
				
				i += 1
			Wend
			
			g.setColor(16711680)
			
			MyAPI.drawRect(g, 20, ((cursol - drawStart) * 24) - 2, 200, 22)
			
			g.setColor(0)
			
			MyAPI.drawString(g, "Reset", 0, 320, 36) "复位"
			MyAPI.drawString(g, "Drop out", 240, 320, 40) ' "退出" ' "Quit"
		End
		
		Function setOver:Void()
			GameObject.setNewParam(paramArray)
			
			Local ds:PublicDataStream ' Stream
			
			Try
				ds = New PublicDataStream(paramArray.Length * SizeOf_Integer, True) ' False
				
				For Local i:= 0 Until paramArray.Length)
					ds.WriteInt(paramArray[i])
				Next
			Catch E:StreamError
				' Nothing so far.
			End Try
			
			Record.saveRecordStream(Record.PARAM_RECORD, ds)
			
			If (ds <> Null) Then
				ds.Close()
			EndIf
		End
End