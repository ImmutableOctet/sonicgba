Strict

Public

' Imports:
Private
	Import com.sega.engine.action.acblock
	Import com.sega.engine.action.acdegreegetter
	Import com.sega.engine.action.acparam
	Import com.sega.engine.action.acutilities
	
	Import lib.constutil
Public

' Classes:
Class ACWorld Implements ACParam Abstract
	Private
		' Constant variable(s):
		Const MAX_SEARCH_BLOCK:Int = 20
		
		' Fields:
		Field getBlock:ACBlock
		Field nextBlock:ACBlock
	Public
		' Methods (Abstract):
		Method getCollisionBlock:Void(ACBlock aCBlock, Int i, Int i2, Int i3) Abstract
		Method getDegreeGetterForObject:ACDegreeGetter() Abstract
		Method getNewCollisionBlock:ACBlock() Abstract
		Method getTileWidth:Int() Abstract
		Method getTileHeight:Int() Abstract
		
		Method getWorldWidth:Int() Abstract
		Method getWorldHeight:Int() Abstract
		
		Method getZoom:Int() Abstract
		
		' Methods (Implemented):
		Method getWorldY:Int(x:Int, y:Int, z:Int, direction:Int)
			If (direction = DIRECTION_RIGHT Or direction = DIRECTION_LEFT) Then
				Return NO_COLLISION
			EndIf
			
			If (Self.getBlock = Null) Then
				Self.getBlock = getNewCollisionBlock()
			EndIf
			
			If (Self.nextBlock = Null) Then
				Self.nextBlock = getNewCollisionBlock()
			EndIf
			
			Local fullCollisionParam:= (ACUtilities.getQuaParam(y, getTileHeight()) * getTileHeight()) + PickValue((direction = DIRECTION_UP), 0, ACBlock.downSide)
			
			Local originalY:= y
			
			getCollisionBlock(Self.getBlock, x, y, z)
			
			Local blockPixOppositeY:= Self.getBlock.getCollisionY(y, (direction + DIRECTION_OPPOSITE_OFFSET) Mod DIRECTION_NUM)
			
			If (blockPixOppositeY <> NO_COLLISION And ((direction = DIRECTION_UP And blockPixOppositeY < originalY) Or (direction = DIRECTION_DOWN And blockPixOppositeY > originalY))) Then
				Return NO_COLLISION
			EndIf
			
			Local blockPixY:= Self.getBlock.getCollisionY(x, direction)
			Local nextBlockPixY:= blockPixY
			Local searchCount:= 0
			
			fullCollisionParam = (ACUtilities.getQuaParam(y, getTileHeight()) * getTileHeight()) + PickValue((direction = DIRECTION_UP), 0, ACBlock.downSide)
			
			While (nextBlockPixY <> NO_COLLISION And searchCount < MAX_SEARCH_BLOCK)
				y += DSgn(direction = DIRECTION_UP) * getTileHeight()
				
				getCollisionBlock(Self.getBlock, x, y, z)
				
				blockPixY = Self.getBlock.getCollisionY(x, direction)
				searchCount += 1
				
				fullCollisionParam = (ACUtilities.getQuaParam(y, getTileHeight()) * getTileHeight()) + PickValue((direction = 0), 0, ACBlock.downSide)
				
				getCollisionBlock(Self.nextBlock, x, (DSgn(direction <> DIRECTION_UP) * getTileHeight()) + y, z)
				
				nextBlockPixY = Self.nextBlock.getCollisionY(x, direction)
			Wend
			
			If (blockPixY = NO_COLLISION) Then
				For Local i:= 0 Until 1
					y -= DSgn(direction = DIRECTION_UP) * getTileHeight()
					
					getCollisionBlock(Self.getBlock, x, y, z)
					
					blockPixY = Self.getBlock.getCollisionY(x, direction)
					
					If (blockPixY <> NO_COLLISION) Then
						Exit
					EndIf
				Next
			EndIf
			
			If (blockPixY <> NO_COLLISION) Then
				Local reY:= blockPixY
				
				If ((direction = DIRECTION_UP And reY <= originalY) Or (direction = DIRECTION_DOWN And reY >= originalY)) Then
					Return reY
				EndIf
			EndIf
			
			Return NO_COLLISION
		End
		
		Method getWorldX:Int(x:Int, y:Int, z:Int, direction:Int)
			' Don't bother with vertical directions:
			If (direction = DIRECTION_UP Or direction = DIRECTION_DOWN) Then
				Return NO_COLLISION
			EndIf
			
			If (Self.getBlock = Null) Then
				Self.getBlock = getNewCollisionBlock()
			EndIf
			
			If (Self.nextBlock = Null) Then
				Self.nextBlock = getNewCollisionBlock()
			EndIf
			
			Local fullCollisionParam:= (ACUtilities.getQuaParam(x, getTileWidth()) * getTileWidth()) + PickValue((direction = DIRECTION_LEFT), 0, ACBlock.rightSide)
			Local originalX:= x
			
			getCollisionBlock(Self.getBlock, x, y, z)
			
			Local blockPixOppositeX:= Self.getBlock.getCollisionX(y, (direction + DIRECTION_OPPOSITE_OFFSET) Mod DIRECTION_NUM)
			
			If (blockPixOppositeX <> NO_COLLISION And ((direction = DIRECTION_LEFT And blockPixOppositeX < originalX) Or (direction = DIRECTION_RIGHT And blockPixOppositeX > originalX))) Then
				Return NO_COLLISION
			EndIf
			
			Local blockPixX:= Self.getBlock.getCollisionX(y, direction)
			Local nextBlockPixX:= blockPixX
			Local searchCount:= 0
			
			fullCollisionParam = (ACUtilities.getQuaParam(x, getTileWidth()) * getTileWidth()) + PickValue((direction = DIRECTION_LEFT), 0, ACBlock.rightSide)
			
			While (nextBlockPixX <> NO_COLLISION And searchCount < MAX_SEARCH_BLOCK)
				x += DSgn(direction <> DIRECTION_LEFT) * getTileWidth()
				
				getCollisionBlock(Self.getBlock, x, y, z)
				blockPixX = Self.getBlock.getCollisionX(y, direction)
				
				searchCount += 1
				
				fullCollisionParam = (ACUtilities.getQuaParam(x, getTileWidth()) * getTileWidth()) + PickValue((direction = DIRECTION_LEFT), 0, ACBlock.rightSide)
				getCollisionBlock(Self.nextBlock, (DSgn(direction <> DIRECTION_LEFT) * getTileWidth()) + x, y, z)
				
				nextBlockPixX = Self.nextBlock.getCollisionX(y, direction)
			Wend
			
			If (blockPixX = NO_COLLISION) Then
				For Local i:= 0 Until 1
					x -= DSgn(direction <> DIRECTION_LEFT) * getTileWidth()
					
					getCollisionBlock(Self.getBlock, x, y, z)
					blockPixX = Self.getBlock.getCollisionX(y, direction)
					
					If (blockPixX <> NO_COLLISION) Then
						Exit
					EndIf
				Next
			EndIf
			
			If (blockPixX <> NO_COLLISION) Then
				Local reX:= blockPixX
				
				If ((direction = DIRECTION_LEFT And reX <= originalX) Or (direction = DIRECTION_RIGHT And reX >= originalX)) Then
					Return reX
				EndIf
			EndIf
			
			Return NO_COLLISION
		End
End