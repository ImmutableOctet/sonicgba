Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.record
	
	Import com.sega.mobile.framework.device.mfdevice
	
	Import brl.stream
	'Import brl.filestream
	
	Import regal.ioutil.publicdatastream
Public

Class GlobalResource
	Public
		' Constant variable(s):
		Const DEFAULT_SOUND_VOL:Int = 9
		
		' Global variable(s):
		Global difficultyConfig:Int = 1
		Global languageConfig:Int = 0
		Global seConfig:Int = 1
		Global sensorConfig:Int = 1
		Global soundConfig:Int = DEFAULT_SOUND_VOL
		Global soundSwitchConfig:Int = 1
		Global spsetConfig:Int = 0
		Global statusAnimation:Animation
		Global timeLimit:Int = 0
		Global vibrationConfig:Int = 1 ' 0
		
		' Functions:
		Function initSystemConfig:Void()
			seConfig = 1
			soundSwitchConfig = 1
			
			If (soundConfig = 0) Then
				soundConfig = 0
			Else
				soundConfig = DEFAULT_SOUND_VOL
			EndIf
			
			difficultyConfig = 1
			timeLimit = 0
			vibrationConfig = 1
			spsetConfig = 0
			languageConfig = 0
			sensorConfig = 1
		End
		
		Function loadSystemConfig:Void()
			Local ds:= Record.loadRecordStream(Record.SYSTEM_RECORD)
			
			Try
				If (ds = Null) Then
					Throw New FileNotFoundException(ds)
				EndIf
				
				soundConfig = ds.ReadByte()
				difficultyConfig = ds.ReadByte()
				timeLimit = ds.ReadByte()
				seConfig = ds.ReadByte()
				vibrationConfig = ds.ReadByte()
				spsetConfig = ds.ReadByte()
				languageConfig = ds.ReadByte()
				sensorConfig = ds.ReadByte()
			Catch E:StreamError
				saveSystemConfig()
			End Try
			
			If (ds <> Null) Then
				ds.Close()
			EndIf
		End
		
		Function saveSystemConfig:Void()
			' Constant variable(s):
			Const DEFAULT_FILE_SIZE:= 128 ' Bytes.
			
			' Local variable(s):
			Local dos:= new PublicDataStream(DEFAULT_FILE_SIZE)
			
			Try
				If (dos = Null) Then
					Throw New FileNotFoundException(dos)
				EndIf
				
				dos.WriteByte(soundConfig)
				dos.WriteByte(difficultyConfig)
				dos.WriteByte(timeLimit)
				dos.WriteByte(seConfig)
				dos.WriteByte(vibrationConfig)
				dos.WriteByte(spsetConfig)
				dos.WriteByte(languageConfig)
				dos.WriteByte(sensorConfig)
				
				Record.saveRecordStream(Record.SYSTEM_RECORD, dos)
			Catch E:StreamError
				' Nothing so far.
			End Try
			
			If (dos <> Null) Then
				dos.Close()
			EndIf
		End
		
		Function isEasyMode:Bool()
			Return (difficultyConfig = 0)
		End
	
		Function timeIsLimit:Bool()
			Return (timeLimit = 0)
		End
End