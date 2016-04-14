Strict

Public

' Imports:
Private
	Import lib.coordinate
	Import lib.line
	'Import lib.line.crosspoint
	Import lib.myapi
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import monkey.math
Public

' Classes:
Class CollisionRect
	Private
		' Global variable(s):
		Global point:CrossPoint = New CrossPoint()
	Public
		' Fields:
		Field centerX:Int
		Field centerY:Int
		
		Field degree:Int
		
		Field rX:Int[]
		Field rY:Int[]
		
		Field x0:Int
		Field x1:Int
		Field y0:Int
		Field y1:Int
	Protected
		' Constructor(s):
		Method Construct_CollisionRect:Void()
			Self.rX = New Int[4]
			Self.rY = New Int[4]
		End
	Public
		' Constructor(s):
		Method New()
			Construct_CollisionRect()
		End
		
		Method New(x0:Int, y0:Int, x1:Int, y1:Int)
			Construct_CollisionRect()
			
			setTwoPosition(x0, y0, x1, y1)
		End
		
		Method New(x:Int, y:Int, width:Int, height:Int, a:Bool)
			Construct_CollisionRect()
			
			setRect(x, y, width, height)
		End
		
		' Methods:
		Method setTwoPosition:Void(x0:Int, y0:Int, x1:Int, y1:Int)
			Self.x0 = Min(x0, x1)
			Self.x1 = Max(x0, x1)
			Self.y0 = Min(y0, y1)
			Self.y1 = Max(y0, y1)
			
			setRotate(Self.degree, 0, 0)
		End
		
		Method setRect:Void(x:Int, y:Int, width:Int, height:Int)
			If (width < 0) Then
				Self.x0 = (x + width)
				Self.x1 = x
			Else
				Self.x0 = x
				Self.x1 = (x + width)
			EndIf
			
			If (height < 0) Then
				Self.y0 = (y + height)
				Self.y1 = y
			Else
				Self.y0 = y
				Self.y1 = (y + height)
			EndIf
			
			setRotate(Self.degree, 0, 0)
		End
		
		Method collisionChk:Bool(rect:CollisionRect)
			If (Self.degree <> 0 Or rect.degree <> 0) Then
				Return collisionChkWithDegree(rect)
			EndIf
			
			If (Self.y1 <= rect.y0 Or Self.y0 > rect.y1) Then
				Return False
			EndIf
			
			If (Self.x1 <= rect.x0 Or Self.x0 > rect.x1) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method collisionChkWidth:Bool(rect:CollisionRect)
			If (Self.degree <> 0 Or rect.degree <> 0) Then
				Return collisionChkWithDegree(rect)
			EndIf
			
			If (Self.x1 <= rect.x0 Or Self.x0 > rect.x1) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method collisionChk:Bool(x:Int, y:Int)
			If (Self.y1 <= y Or Self.y0 > y) Then
				Return False
			EndIf
			
			If (Self.x1 <= x Or Self.x0 > x) Then
				Return False
			EndIf
			
			Return True
		End
		
		Method addVelocity:Void(vx:Int, vy:Int)
			If (vx < 0) Then
				Self.x0 += vx
			ElseIf (vx > 0) Then
				Self.x1 += vx
			EndIf
			
			If (vy < 0) Then
				Self.y0 += vy
			ElseIf (vy > 0) Then
				Self.y1 += vy
			EndIf
		End
		
		Method getClone:CollisionRect(xOffset:Int, yOffset:Int)
			Return New CollisionRect(Self.x0 + xOffset, Self.y0 + yOffset, Self.x1 + xOffset, Self.y1 + yOffset)
		End
		
		Method isLeftOf:Bool(collisionRect:CollisionRect)
			Return isLeftOf(collisionRect, 0)
		End
		
		Method isRightOf:Bool(collisionRect:CollisionRect)
			Return isRightOf(collisionRect, 0)
		End
		
		Method isUpOf:Bool(collisionRect:CollisionRect)
			Return isUpOf(collisionRect, 0)
		End
		
		Method isDownOf:Bool(collisionRect:CollisionRect)
			Return isDownOf(collisionRect, 0)
		End
		
		Method isLeftOf:Bool(collisionRect:CollisionRect, offset:Int)
			If (Self.x1 <= collisionRect.x0 + offset) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method isRightOf:Bool(collisionRect:CollisionRect, offset:Int)
			If (Self.x0 >= collisionRect.x1 - offset) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method isUpOf:Bool(collisionRect:CollisionRect, offset:Int)
			If (Self.y1 <= collisionRect.y0 + offset) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method isDownOf:Bool(collisionRect:CollisionRect, offset:Int)
			If (Self.y0 >= collisionRect.y1 - offset) Then
				Return True
			EndIf
			
			Return False
		End
		
		Method draw:Void(g:MFGraphics, camera:Coordinate)
			g.setColor(16711680)
			
			g.drawRect(Self.x0 - camera.x, Self.y0 - camera.y, Self.x1 - Self.x0, Self.y1 - Self.y0)
		End
		
		Method getWidth:Int()
			Return (Self.x1 - Self.x0)
		End
		
		Method getHeight:Int()
			Return (Self.y1 - Self.y0)
		End
		
		Method getCenterX:Int()
			Return ((Self.x0 + Self.x1) Shr 1) ' / 2
		End
		
		Method getCenterY:Int()
			Return ((Self.y0 + Self.y1) Shr 1) ' / 2
		End
		
		Method toString:String() ' ToString:String
			Return "x0:" + Self.x0 + "|x1:" + Self.x1 + "|y0:" + Self.y0 + "|y1:" + Self.y1
		End
		
		Method setRotate:Void(degree:Int, centerX:Int, centerY:Int)
			Self.degree = degree
			
			If (degree = 0) Then
				Self.rX[0] = Self.x0
				Self.rY[0] = Self.y0
				Self.rX[1] = Self.x1
				Self.rY[1] = Self.y0
				Self.rX[2] = Self.x1
				Self.rY[2] = Self.y1
				Self.rX[3] = Self.x0
				Self.rY[3] = Self.y1
			EndIf
			
			Local realCenterX:= (Self.x0 + centerX)
			Local realCenterY:= (Self.y0 + centerY)
			
			Self.rX[0] = MyAPI.getRelativePointX(realCenterX, -centerX, -centerY, degree)
			Self.rY[0] = MyAPI.getRelativePointY(realCenterY, -centerX, -centerY, degree)
			Self.rX[1] = MyAPI.getRelativePointX(realCenterX, (Self.x1 - Self.x0) - centerX, -centerY, degree)
			Self.rY[1] = MyAPI.getRelativePointY(realCenterY, (Self.x1 - Self.x0) - centerX, -centerY, degree)
			Self.rX[2] = MyAPI.getRelativePointX(realCenterX, (Self.x1 - Self.x0) - centerX, (Self.y1 - Self.y0) - centerY, degree)
			Self.rY[2] = MyAPI.getRelativePointY(realCenterY, (Self.x1 - Self.x0) - centerX, (Self.y1 - Self.y0) - centerY, degree)
			Self.rX[3] = MyAPI.getRelativePointX(realCenterX, -centerX, (Self.y1 - Self.y0) - centerY, degree)
			Self.rY[3] = MyAPI.getRelativePointY(realCenterY, -centerX, (Self.y1 - Self.y0) - centerY, degree)
		End
		
		Method collisionChkWithDegree:Bool(rect:CollisionRect)
			For Local i:= 0 Until 4
				For Local j:= 0 Until 4
					Local nextIndex:= ((i + 1) Mod 4)
					Local nextSecondIndex:= ((j + 1) Mod 4)
					
					Line.getCrossPoint(point, Self.rX[i], Self.rY[i], Self.rX[nextIndex], Self.rY[nextIndex], rect.rX[j], rect.rY[j], rect.rX[nextSecondIndex], rect.rY[nextSecondIndex])
					
					If (point.hasPoint) Then
						Return True
					EndIf
				Next
			Next
			
			Return False
		End
End