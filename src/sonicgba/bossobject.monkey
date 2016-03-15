Strict

Public

#Rem
	NOTES:
		* Follow the expected argument pattern for its constructor.
		
		* The 'HP' field and the like probably does represent the number of hits it can take.
			With the HP knowledge in mind, we can assume 'isEasyMode'
			makes bosses take 6 hits compared to the traditional 8.
#End

' Imports:
Private
	Import sonicgba.enemyobject
	Import sonicgba.globalresource
Public

' Classes:

' Presumed base-class for bosses.
Class BossObject Extends EnemyObject Abstract
	Private
		Const DEFAULT_HP:= 8
		Const EASY_HP:= 6
	Protected
		' Fields:
		Field HP:Int
		
		' Constructor(s):
		Method New(id:Int, x:Int, y:Int, left:Int, top:Int, width:Int, height:Int)
			Super.New(id, x, y, left, top, width, height)
		End
	Public
		' Methods:
		Method setBossHP:Void()
			If (GlobalResource.isEasyMode() And (stageModeState = STATE_NORMAL_MODE)) Then
				HP = EASY_HP
			Else
				HP = DEFAULT_HP
			EndIf
		End
End