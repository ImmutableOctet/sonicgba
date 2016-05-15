Strict

Public

' Imports:
Private
	Import com.sega.mobile.framework.device.mfdevice
	
	Import brl.databuffer
	Import brl.stream
	Import brl.datastream
	'Import brl.filestream
	
	Import regal.ioutil.endianstream
	Import regal.ioutil.publicdatastream
Public

' Classes:
Class Record
	Public
		' Constant variable(s):
		Const BP_RECORD:String = "SONIC_BP_RECORD"
		Const EMERALD_RECORD:String = "EMERALD_RECORD"
		Const HIGHSCORE_RECORD:String = "SONIC_HIGHSCORE_RECORD"
		Const PARAM_RECORD:String = "SONIC_PARAM_RECORD"
		Const STAGE_RECORD:String = "SONIC_STAGE_RECORD"
		Const SYSTEM_RECORD:String = "SONIC_SYSTEM_RECORD"
	Private
		' Constant variable(s):
		Const ONE_RECORD:Bool = True
		Const TOTAL_RECORD_NAME:String = "SONIC_RECORD"
	Public
		' Functions:
		Function initRecord:Void()
			' Nothing so far.
		End
		
		Function saveRecord:Void(recordId:String, content:DataBuffer)
			If (content <> Null) Then
				MFDevice.saveRecord(recordId, content)
			EndIf
		End
		
		Function loadRecord:DataBuffer(recordId:String)
			Return MFDevice.loadRecord(recordId)
		End
		
		Function loadRecordStream:Stream(recordId:String, bigEndian:Bool=True) ' DataStream ' False
			Local data:= loadRecord(recordId)
			
			If (data = Null) Then
				Throw New FileNotFoundException(Null, recordId)
				
				Return Null
			EndIf
			
			Return New EndianStreamManager<DataStream>(New DataStream(data), bigEndian) ' False
		End
		
		' This routine is considered "'Null' safe".
		Function saveRecordStream:Void(recordId:String, ds:PublicDataStream)
			If (ds <> Null) Then
				saveRecord(recordId, ds.ToDataBuffer())
			EndIf
		End
End