Scriptname DropRecentItemsPlayerQuest extends ReferenceAlias  

Form[] RecentItems
Int Property DropKey = 45 Auto

Event OnInit()
	UnregisterForAllKeys()
	RegisterForKey(DropKey)
	RecentItems = new Form[3]
EndEvent

Event OnPlayerLoadGame()
	UnregisterForAllKeys()
	RegisterForKey(DropKey)
	RecentItems = new Form[3]
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	If RecentItems == None
		Return
	EndIf

	RecentItems[2] = RecentItems[1]
	RecentItems[1] = RecentItems[0]
	RecentItems[0] = akBaseItem

	Debug.Notification("0: " + RecentItems[0].GetName() + " | " + "1: " + RecentItems[1].GetName() + " | " + "2: " + RecentItems[2].GetName())
EndEvent

Event OnKeyDown(Int KeyCode)
	If KeyCode == 45
		If RecentItems[0] == None
			Debug.Notification("No recent items found")
			Return
		EndIf

		Game.GetPlayer().DropObject(RecentItems[0], 1)
		RecentItems[0] = RecentItems[1]
		RecentItems[1] = RecentItems[2]
		RecentItems[2] = None

		Debug.Notification("0: " + RecentItems[0].GetName() + " | " + "1: " + RecentItems[1].GetName() + " | " + "2: " + RecentItems[2].GetName())
	EndIf
EndEvent