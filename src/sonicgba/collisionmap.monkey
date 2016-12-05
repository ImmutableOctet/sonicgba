Strict

' Friends:
Friend sonicgba.collisionblock

' Imports:
Private
	Import sonicgba.collisionblock
	Import sonicgba.mapmanager
	Import sonicgba.mydegreegetter
	Import sonicgba.sonicdef
	
	Import lib.constutil
	Import lib.mapview
	
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworld
	
	'Import com.sega.mobile.framework.device.mfgamepad
	Import com.sega.mobile.framework.device.mfdevice
	
	Import brl.databuffer
	Import brl.stream
	
	Import regal.typetool
	Import regal.sizeof
	Import regal.byteorder
Public

' Classes:
Class CollisionMap Extends ACWorld ' Implements SonicDef
	Protected
		' Constant variable(s):
		Global BLANK_BLOCK:DataBuffer = CollisionBlock.BLANK_COLLISION_INFO ' New DataBuffer(8) ' Byte[] = New Byte[8] ' Const
		'Global FULL_BLOCK:Byte[] = [-120, -120, -120, -120, -120, -120, -120, -120] ' Const
	Private
		' Constant variable(s):
		Const GRID_NUM_PER_MODEL:Int = 12 ' (MapManager.MODEL_WIDTH * 2)
		
		Const LOAD_OPEN_FILE:Int = 0
		Const LOAD_MODEL_INFO:Int = 1
		Const LOAD_COLLISION_INFO:Int = 2
		Const LOAD_OVER:Int = 3
		
		' Global variable(s):
		Global instance:CollisionMap
		
		Global loadStep:Int = LOAD_OPEN_FILE
		
		' Functions:
		
		' Extensions:
		Function AsModelCoord:Int(x:Int, y:Int)
			Return ((x * GRID_NUM_PER_MODEL) + (y))
		End
		
		Function GetModelTileAt:Int(data:MapView, x:Int, y:Int) ' Short[][] ' DataBuffer
			Return data.GetAt(x, y) ' data[x][y] ' data.PeekShort(AsModelCoord(x, y) * SizeOf_Short)
		End
		
		' Fields:
		Field ds:Stream
		
		Field directionInfo:DataBuffer ' Byte[]
		Field collisionInfo:DataBuffer ' DataBuffer[] ' Byte[][]
		
		Field modelInfo:MapView[] ' Short[][][] ' DataBuffer[]
		
		Field degreeGetter:MyDegreeGetter
		
		' Constructor(s):
		Method New()
			' Empty implementation; used for privacy reasons.
		End
		
		' Methods:
		Method getBlockIndexWithBlock:Int(blockX:Int, blockY:Int, currentLayer:Int)
			' Magic number: 1 (Collision layer)
			If (currentLayer = 1) Then
				Return getTileId(MapManager.mapBack, blockX, blockY)
			EndIf
			
			Return getTileId(MapManager.mapFront, blockX, blockY)
		End
		
		Method getTileId:Int(mapArray:MapView, x:Int, y:Int) ' Short[][] ' DataBuffer
			'Local chunk:= Self.modelInfo[MapManager.GetStandardTileAt(mapArray, (x / GRID_NUM_PER_MODEL), (y / GRID_NUM_PER_MODEL))] ' MapManager.GetModelTileAt
			
			'Return GetModelTileAt(chunk, (x Mod GRID_NUM_PER_MODEL), (y Mod GRID_NUM_PER_MODEL))
			
			#Rem
			Local t:= x
			
			x = y
			y = t
			#End
			
			Local mapX:= (x / GRID_NUM_PER_MODEL)
			Local mapY:= (y / GRID_NUM_PER_MODEL)
			Local modelX:= (x Mod GRID_NUM_PER_MODEL)
			Local modelY:= (y Mod GRID_NUM_PER_MODEL)
			
			Local modelIndex:= GetModelTileAt(mapArray, mapX, mapY) ' mapArray[mapX][mapY]
			
			Return GetModelTileAt(Self.modelInfo[modelIndex], modelX, modelY) ' Self.modelInfo[modelIndex][modelX][modelY]
		End
	Public
		' Constant variable(s):
		Const COLLISION_FILE_NAME:String = ".co"
		Const MODEL_FILE_NAME:String = ".ci"
		
		Const MODEL_INFO_SIZE:= ((GRID_NUM_PER_MODEL*GRID_NUM_PER_MODEL) * SizeOf_Short)
		Const COLLISION_INFO_STRIDE:= 8
		
		' Functions:
		Function getInstance:CollisionMap()
			If (instance = Null) Then
				instance = New CollisionMap()
			EndIf
			
			Return instance
		End
		
		' Extensions:
		Function ToCollisionInfoPosition:Int(index:Int)
			Return (index * COLLISION_INFO_STRIDE)
		End
		
		' Methods:
		Method loadCollisionInfoStep:Bool(stageName:String)
			Select (loadStep)
				Case LOAD_OPEN_FILE
					Self.ds = MFDevice.getResourceAsStream("/map/" + stageName + MODEL_FILE_NAME)
				Case LOAD_MODEL_INFO
					Self.modelInfo = New MapView[MapManager.mapModel.Length] ' New Short[MapManager.mapModel.Length][][] ' New DataBuffer[MapManager.mapModel.Length]
					
					For Local i:= 0 Until Self.modelInfo.Length ' MapManager.mapModel.Length
						Self.modelInfo[i] = MapManager.AllocateMap(GRID_NUM_PER_MODEL, GRID_NUM_PER_MODEL) ' New DataBuffer(MODEL_INFO_SIZE)
					Next
					
					Try
						For Local i:= 0 Until Self.modelInfo.Length
							Local model:= Self.modelInfo[i]
							
							'''ds.ReadAll(model, 0, model.Length) ' & 65535
							
							'''FlipBuffer_Shorts(model)
							
							'MapManager.ReadMap(ds, model, GRID_NUM_PER_MODEL, GRID_NUM_PER_MODEL)
							
							'#Rem
							For Local y:= 0 Until GRID_NUM_PER_MODEL
								For Local x:= 0 Until GRID_NUM_PER_MODEL
									Local value:= (Self.ds.ReadShort() & $FFFF)
									
									'model[x][y] = value
									model.SetAt(x, y, value)
								Next
							Next
							'#End
						Next
					Catch E:StreamError
						' Nothing so far.
					End Try
					
					If (Self.ds <> Null) Then
						Self.ds.Close()
					EndIf
				Case LOAD_COLLISION_INFO
					Self.ds = MFDevice.getResourceAsStream("/map/" + stageName + COLLISION_FILE_NAME)
					
					Try
						Local collisionKindNum:= Self.ds.ReadShort()
						
						Self.collisionInfo = New DataBuffer(collisionKindNum * COLLISION_INFO_STRIDE) ' * SizeOf_Byte
						Self.directionInfo = New DataBuffer(collisionKindNum) ' * SizeOf_Byte
						
						For Local i:= 0 Until collisionKindNum ' Self.directionInfo.Length
							'#Rem
							Local offset:= (i * COLLISION_INFO_STRIDE)
							
							For Local j:= 0 Until COLLISION_INFO_STRIDE
								Self.collisionInfo.PokeByte(offset+j, Self.ds.ReadByte()) ' & $FF
							Next
							'#End
							
							'Self.ds.ReadAll(Self.collisionInfo, (i * COLLISION_INFO_STRIDE), COLLISION_INFO_STRIDE)
							
							Self.directionInfo.PokeByte(i, Self.ds.ReadByte()) ' & $FF
						Next
					Catch E:StreamError
						' Nothing so far.
					End Try
					
					If (Self.ds <> Null) Then
						Self.ds.Close()
					EndIf
				Case LOAD_OVER
					loadStep = 0
					
					Return True
			End Select
			
			loadStep += 1
			
			Return False
		End
		
		Method getCollisionInfoWithBlock:Void(blockX:Int, blockY:Int, currentLayer:Int, block:ACBlock)
			getCollisionBlock(block, (getTileWidth() * blockX), (getTileHeight() * blockY), currentLayer)
		End
		
		Method closeMap:Void()
			Self.collisionInfo = Null
			Self.directionInfo = Null
			
			#Rem
			For Local i:= 0 Until Self.modelInfo.Length
				Self.modelInfo[i].Discard()
				
				Self.modelInfo[i] = Null
			Next
			#End
			
			Self.modelInfo = []
		End
		
		Method getCollisionBlock:Void(block:ACBlock, x:Int, y:Int, layer:Int)
			' Pretty terrible, but it works:
			
			' Optimization potential; dynamic cast.
			Local myBlock:= CollisionBlock(block)
			
			If (myBlock <> Null) Then
				Local blockX:= ACUtilities.getQuaParam(x - (MapManager.mapOffsetX Shl 6), getTileWidth()) ' getZoom()
				Local blockY:= ACUtilities.getQuaParam(y, getTileHeight())
				
				myBlock.setPosition((getTileWidth() * blockX) + (MapManager.mapOffsetX Shl 6), getTileHeight() * blockY) ' getZoom()
				
				If (blockX < 0) Then
					myBlock.setProperty(BLANK_BLOCK, 0, False, False, 64, False)
				ElseIf (blockY < 0 Or blockY >= (MapManager.mapHeight * GRID_NUM_PER_MODEL)) Then
					myBlock.setProperty(BLANK_BLOCK, 0, False, False, 0, False)
				Else
					Local tileId:= getBlockIndexWithBlock((MapManager.getConvertX(blockX / GRID_NUM_PER_MODEL) * GRID_NUM_PER_MODEL) + (blockX Mod GRID_NUM_PER_MODEL), blockY, layer)
					
					' Magic number: 8191 (Bit mask?)
					Local cell_id:= (tileId & 8191)
					
					' Magic numbers: 16384, 32768, 8192 (Flags?)
					Local info:= Self.collisionInfo
					Local infoOffset:= ToCollisionInfoPosition(cell_id)
					
					Local FLIP_X:= ((tileId & 16384) <> 0)
					Local FLIP_Y:= ((32768 & tileId) <> 0)
					
					Local degree:= Self.directionInfo.PeekByte(cell_id)
					Local attr:= ((tileId & 8192) <> 0)
					
					myBlock.setProperty(info, infoOffset, FLIP_X, FLIP_Y, degree, attr)
				EndIf
			EndIf
		End
		
		Method getDegreeGetterForObject:ACDegreeGetter()
			If (Self.degreeGetter = Null) Then
				Self.degreeGetter = New MyDegreeGetter(Self)
			EndIf
			
			Return Self.degreeGetter
		End
		
		Method getNewCollisionBlock:ACBlock()
			Return New CollisionBlock(Self)
		End
		
		Method getTileHeight:Int()
			Return 512
		End
		
		Method getTileWidth:Int()
			Return 512
		End
		
		Method getWorldHeight:Int()
			Return (MapManager.getPixelHeight() Shl 6) ' getZoom()
		End
		
		Method getWorldWidth:Int()
			Return (MapManager.getPixelWidth() Shl 6) ' getZoom()
		End
		
		Method getZoom:Int()
			Return 6
		End
End