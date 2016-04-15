Strict

' Imports:
Private
	Import sonicgba.collisionblock
	Import sonicgba.mapmanager
	Import sonicgba.mydegreegetter
	Import sonicgba.sonicdef
	
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acutilities
	Import com.sega.engine.action.acworld
	
	'Import com.sega.mobile.framework.device.mfdevice
	'Import com.sega.mobile.framework.device.mfgamepad
	
	Import brl.databuffer
	Import brl.stream
Public

' Classes:
Class CollisionMap Extends ACWorld ' Implements SonicDef
	Private
		' Constant variable(s):
		Global BLANK_BLOCK:Byte[] = New Int[8] ' Const
		Global FULL_BLOCK:Byte[] = [-120, -120, -120, -120, -120, -120, -120, -120] ' Const
		
		Const GRID_NUM_PER_MODEL:Int = 12
		
		Const LOAD_OPEN_FILE:Int = 0
		Const LOAD_MODEL_INFO:Int = 1
		Const LOAD_COLLISION_INFO:Int = 2
		Const LOAD_OVER:Int = 3
		
		' Global variable(s):
		Global instance:CollisionMap
		
		Global loadStep:Int = LOAD_OPEN_FILE
		
		' Fields:
		Field ds:Stream
		
		Field directionInfo:Byte[]
		Field collisionInfo:Byte[][]
		
		Field modelInfo:DataBuffer[] ' Short[][][]
		
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
		
		Method getTileId:Int(mapArray:DataBuffer, x:Int, y:Int)
			Local chunk:= Self.modelInfo[MapManager.getTileAt(mapArray, (x / GRID_NUM_PER_MODEL), (y / GRID_NUM_PER_MODEL))]
			
			Return MapManager.getTileAt(chunk, (x Mod GRID_NUM_PER_MODEL), (y Mod GRID_NUM_PER_MODEL))
		End
	Public
		' Constant variable(s):
		Const COLLISION_FILE_NAME:String = ".co"
		Const MODEL_FILE_NAME:String = ".ci"
		
		' Functions:
		Function getInstance:CollisionMap()
			If (instance = Null) Then
				instance = New CollisionMap()
			EndIf
			
			Return instance
		End
		
		' Methods:
		Public Method loadCollisionInfoStep:Bool(stageName:String)
			Int i
			Select (loadStep)
				Case LOAD_OPEN_FILE
					Self.ds = New DataInputStream(MFDevice.getResourceAsStream("/map/" + stageName + MODEL_FILE_NAME))
					break
				Case LOAD_MODEL_INFO
					Self.modelInfo = (Short[][][]) Array.newInstance(Short.TYPE, New Int[]{MapManager.mapModel.Length, GRID_NUM_PER_MODEL, GRID_NUM_PER_MODEL})
					i = 0
					While (i < Self.modelInfo.Length) {
						try {
							For (Int y = 0; y < GRID_NUM_PER_MODEL; y += 1)
								For (Int x = 0; x < GRID_NUM_PER_MODEL; x += 1)
									Self.modelInfo[i][x][y] = (Short) (Self.ds.readShort() & 65535)
								Next
							Next
							i += 1
						} catch (Exception e) {
							
							If (Self.ds <> Null) Then
								try {
									Self.ds.close()
									break
								} catch (IOException e2) {
									e2.printStackTrace()
									break
								}
							EndIf
							
						} catch (Throwable th) {
							
							If (Self.ds <> Null) Then
								try {
									Self.ds.close()
								} catch (IOException e3) {
									e3.printStackTrace()
								}
							EndIf
							
						}
					}
					
					If (Self.ds <> Null) Then
						try {
							Self.ds.close()
							break
						} catch (IOException e22) {
							e22.printStackTrace()
							break
						}
					EndIf
					
					break
				Case LOAD_COLLISION_INFO
					Self.ds = New DataInputStream(MFDevice.getResourceAsStream("/map/" + stageName + COLLISION_FILE_NAME))
					try {
						Int collisionKindNum = Self.ds.readShort()
						Self.collisionInfo = (Byte[][]) Array.newInstance(Byte.TYPE, New Int[]{collisionKindNum, 8})
						Self.directionInfo = New Byte[collisionKindNum]
						For (i = 0; i < collisionKindNum; i += 1)
							For (Int n = 0; n < 8; n += 1)
								Self.collisionInfo[i][n] = Self.ds.readByte()
							EndIf
							Self.directionInfo[i] = Self.ds.readByte()
						Next
						
						If (Self.ds <> Null) Then
							try {
								Self.ds.close()
								break
							} catch (IOException e222) {
								e222.printStackTrace()
								break
							EndIf
						EndIf
						
					} catch (Exception e4) {
						
						If (Self.ds <> Null) Then
							try {
								Self.ds.close()
								break
							} catch (IOException e2222) {
								e2222.printStackTrace()
								break
							Next
						EndIf
						
					} catch (Throwable th2) {
						
						If (Self.ds <> Null) Then
							try {
								Self.ds.close()
							} catch (IOException e32) {
								e32.printStackTrace()
							}
						EndIf
					EndIf
					break
				Case LOAD_OVER
					loadStep = 0
					Return True
			End Select
			
			If (True) Then
				loadStep += 1
			EndIf
			
			Return False
		End
		
		Method getCollisionInfoWithBlock:Void(blockX:Int, blockY:Int, currentLayer:Int, block:ACBlock)
			getCollisionBlock(block, (getTileWidth() * blockX), (getTileHeight() * blockY), currentLayer)
		End
		
		Method closeMap:Void()
			Self.collisionInfo = []
			Self.directionInfo = []
			
			For Local i:= 0 Until Self.modelInfo.Length
				'Self.modelInfo[i].Discard()
				
				Self.modelInfo[i] = Null
			Next
			
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
					myBlock.setProperty(BLANK_BLOCK, False, False, 64, False)
				ElseIf (blockY < 0 Or blockY >= (MapManager.mapHeight * GRID_NUM_PER_MODEL)) Then
					myBlock.setProperty(BLANK_BLOCK, False, False, 0, False)
				Else
					Local tileId:= getBlockIndexWithBlock((MapManager.getConvertX(blockX / GRID_NUM_PER_MODEL) * GRID_NUM_PER_MODEL) + (blockX Mod GRID_NUM_PER_MODEL), blockY, layer)
					
					' Magic numbers: 8191 (Bit mask)
					Local cell_id:= (tileId & 8191)
					
					' Magic numbers: 16384, 32768, 8192 (Flags?)
					myBlock.setProperty(Self.collisionInfo[cell_id], ((tileId & 16384) <> 0), ((32768 & tileId) <> 0), Self.directionInfo[cell_id], ((tileId & 8192) <> 0))
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