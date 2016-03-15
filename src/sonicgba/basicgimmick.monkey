Strict

Public

' Imports:
Import lib.animation
Import lib.animationdrawer

Import sonicgba.gimmickobject

Import com.sega.mobile.framework.device.mfgraphics

' Classes:
Class BasicGimmickObject Extends GimmickObject Abstract
	Protected
		' Fields:
		
		' This is used to display the graphic for this gimmick.
		Field drawer:AnimationDrawer
	Public
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
		
		' Methods:
		Method close:Void()
			Self.drawer = Null
			
			Return
		End
		
		Method draw:Void(graphics:MFGraphics)
			drawInMap(graphics, drawer)
		End
End