Strict

Public

#Rem
	Sensor virtualization will be implemented at a later date.
#End

' Imports:
Private
	'Import android.hardware.sensor
	'Import android.hardware.sensorevent
	'Import android.hardware.sensoreventlistener
	'Import android.hardware.sensormanager
	
	'Import com.sega.mobile.framework.mfmain
	
	Import mojo.input
Public

' Classes:
Class MFSensor
	Private
		' Global variable(s):
		'Global listener:SensorEventListener
		'Global mManager:SensorManager
		
		'Global f8x:Float
		'Global f9y:Float
		'Global f10z:Float
	Public
		' Functions:
		Function getAccX:Float()
			Return AccelX()
		End
		
		Function getAccY:Float()
			Return AccelY()
		End
		
		Function getAccZ:Float()
			Return AccelZ()
		End
		
		Function init:Void()
			#Rem
				mManager = (SensorManager) MFMain.getInstance().getSystemService("sensor")
				
				Local sensors:= mManager.getSensorList(1)
				
				If (sensors.size() > 0) Then
					mManager.registerListener(listener, (Sensor) sensors.get(0), 0)
				EndIf
			#End
		End
End