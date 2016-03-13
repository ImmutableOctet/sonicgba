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
Import sonicgba.enemyobject
Import sonicgba.globalresource

' Classes:

' Presumed base-class for bosses.
Class BossObject Extends EnemyObject Abstract
	Protected
		' Fields:
		Field HP:Int
		
		' Constructor(s):
		Method New(var1:Int, var2:Int, var3:Int, var4:Int, var5:Int, var6:Int, var7:Int)
			Super.New(var1, var2, var3, var4, var5, var6, var7)
		End
	Public
		' Methods:
		Method setBossHP:Void()
			If (GlobalResource.isEasyMode() And (stageModeState = 0)) Then
				HP = 6
			Else
				HP = 8
			EndIf
		End
End