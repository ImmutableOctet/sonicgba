Strict

Public

' Imports:
Private
	Import lib.animation
	Import lib.animationdrawer
	
	'Import special.specialmap
	
	Import com.sega.mobile.framework.device.mfgraphics
	
	Import sonicgba.gimmickobject
Public

' Classes:
Class DamageArea Extends GimmickObject
	Private
		' Global variable(s):
		Global magmaDrawer:AnimationDrawer
		
		' Fields:
		Field drawer:AnimationDrawer
		Field isActived:Bool
	Protected
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
			
			If (StageManager.getCurrentZoneId() = 2) Then
				If (magmaDrawer = Null) Then
					magmaDrawer = New Animation("/animation/magma_bg").getDrawer(0, True, 0)
					
					magmaDrawer.setPause(True)
				EndIf
				
				Self.drawer = magmaDrawer
			EndIf
			
			Self.isActived = False
		End
	Public
		' Methods:
		Method draw:Void(graphics:MFGraphics)
			' Magic numbers: Not sure what these are related to.
			If (Self.drawer <> Null) Then
				drawInMap(graphics, magmaDrawer, Self.posX, Self.posY - 1024)
				
				If (Self.mWidth > 6144) Then
					drawInMap(graphics, magmaDrawer, Self.posX + 6144, Self.posY - 1024)
				EndIf
			EndIf
		End
	
		Method doWhileCollision:Void(player:PlayerObject, direction:Int)
			If (Self.iLeft = 0) Then
				player.beHurt()
				
				Return
			EndIf
			
			Self.isDamageSandActive = True
			Self.isActived = True
			
			player.setDie(False)
		End
	
		Method doWhileNoCollision:Void()
			If (Self.isActived) Then
				Self.isDamageSandActive = False
				Self.isActived = False
			EndIf
		End
	
		Method close:Void()
			Self.drawer = Null
		End
		
		' Functions:
		Function staticLogic:Void()
			If (magmaDrawer <> Null) Then
				magmaDrawer.moveOn()
			EndIf
		End
	
		Function releaseAllResource:Void()
			Animation.closeAnimationDrawer(magmaDrawer)
			
			magmaDrawer = Null
		End
End