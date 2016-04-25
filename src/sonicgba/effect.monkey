Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	Import sonicgba.mapmanager
	
	Import com.sega.mobile.framework.device.mfgraphics
Public

' Classes:
Class Effect
	Public
		' Constant variable(s):
		Const EFFECT_LAYER_TOP:Int = 0
		Const EFFECT_LAYER_PLAYER:Int = 1
		Const EFFECT_LAYER_NUM:Int = 2
		
		Const EFFECT_NUM:Int = 10
		
		' Global variable(s):
		Global effectArray:Effect[][] = GenerateEffectArray()
	Private
		' Functions:
		Function GenerateEffectArray:Effect[][]()
			Local effectArray:= New Effect[EFFECT_LAYER_NUM][]
			
			For Local l:= EFFECT_LAYER_TOP Until EFFECT_LAYER_NUM
				For Local i:= EFFECT_LAYER_TOP Until EFFECT_NUM
					effectArray[l][i] = New Effect(Null, 0, 0, 0, 0)
				Next
			Next
			
			Return effectArray
		End
		
		' Fields:
		Field drawer:AnimationDrawer
		Field mPosX:Int
		Field mPosY:Int
	Public
		' Functions:
		Function showEffect:Void(animation:Animation, id:Int, x:Int, y:Int, trans:Int, layer:Int)
			If (layer >= 0 And layer < EFFECT_LAYER_NUM) Then
				For Local i:= EFFECT_LAYER_TOP Until EFFECT_NUM
					If (effectArray[layer][i].drawer = Null) Then
						effectArray[layer][i].setDrawer(animation, id, x, y, trans)
						
						Exit
					EndIf
				Next
			EndIf
		End
		
		Function showEffect:Void(animation:Animation, id:Int, x:Int, y:Int, trans:Int)
			showEffect(animation, id, x, y, trans, EFFECT_LAYER_TOP)
		End
		
		Function showEffectPlayer:Void(animation:Animation, id:Int, x:Int, y:Int, trans:Int)
			showEffect(animation, id, x, y, trans, EFFECT_LAYER_PLAYER)
		End
		
		Function draw:Void(g:MFGraphics, layer:Int)
			If (layer >= 0 And layer < EFFECT_LAYER_NUM) Then
				For Local i:= EFFECT_LAYER_TOP Until EFFECT_NUM
					effectArray[layer][i].mDraw(g)
				Next
			EndIf
		End
	Private ' Protected
		' Constructor(s):
		Method New(animation:Animation, id:Int, x:Int, y:Int, trans:Int)
			Self.drawer = Null
			
			If (animation <> Null) Then
				Self.drawer = animation.getDrawer(id, False, trans)
				Self.mPosX = x
				Self.mPosY = y
			EndIf
		End
		
		' Methods:
		Method setDrawer:Void(animation:Animation, id:Int, x:Int, y:Int, trans:Int)
			If (animation <> Null) Then
				Self.drawer = animation.getDrawer(id, False, trans)
				
				Self.mPosX = x
				Self.mPosY = y
			EndIf
		End
		
		Method mDraw:Bool(g:MFGraphics)
			If (Self.drawer = Null) Then
				Return True
			EndIf
			
			Self.drawer.draw(g, (Self.mPosX - MapManager.getCamera().x), (Self.mPosY - MapManager.getCamera().y))
			
			If (Not Self.drawer.checkEnd()) Then
				Return False
			EndIf
			
			Self.drawer = Null
			
			Return True
		End
End