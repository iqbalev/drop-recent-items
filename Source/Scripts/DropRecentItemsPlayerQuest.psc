Scriptname DropRecentItemsPlayerQuest extends ReferenceAlias  

Form[] RecentItems
Int[] ItemCounts
Int Property DropKey = 45 Auto
Int Property MaxRecentItems = 3 Auto

String Function GetItemNameAndCount(Form akForm, Int count)
	If !akForm
		Return "Empty"
	EndIf

	Return akForm.GetName() + " (" + count + ")"
EndFunction

Event OnInit()
	UnregisterForAllKeys()
	RegisterForKey(DropKey)
	RecentItems = Utility.CreateFormArray(MaxRecentItems)
	ItemCounts = Utility.CreateIntArray(MaxRecentItems)
EndEvent

Event OnPlayerLoadGame()
	UnregisterForAllKeys()
	RegisterForKey(DropKey)
	RecentItems = Utility.CreateFormArray(MaxRecentItems)
	ItemCounts = Utility.CreateIntArray(MaxRecentItems)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	RecentItems[2] = RecentItems[1]
	ItemCounts[2] = ItemCounts[1]

	RecentItems[1] = RecentItems[0]
	ItemCounts[1] = ItemCounts[0]
	
	RecentItems[0] = akBaseItem
	ItemCounts[0] = aiItemCount

	Debug.Notification("ADDED: " + GetItemNameAndCount(RecentItems[0], ItemCounts[0]) + " - " + GetItemNameAndCount(RecentItems[1], ItemCounts[1]) + " - " + GetItemNameAndCount(RecentItems[2], ItemCounts[2]))
	Debug.Trace("ADDED: " + GetItemNameAndCount(RecentItems[0], ItemCounts[0]) + " - " + GetItemNameAndCount(RecentItems[1], ItemCounts[1]) + " - " + GetItemNameAndCount(RecentItems[2], ItemCounts[2]))
EndEvent

Event OnKeyDown(Int KeyCode)
	If !Utility.IsInMenuMode() && KeyCode == DropKey
		If RecentItems[0] == None
			Debug.Trace("No recent items found")
			Debug.Notification("No recent items found")
			Return
		EndIf

		Game.GetPlayer().DropObject(RecentItems[0], ItemCounts[0])

		RecentItems[0] = RecentItems[1]
		ItemCounts[0] = ItemCounts[1]

		RecentItems[1] = RecentItems[2]
		ItemCounts[1] = ItemCounts[2]
		
		RecentItems[2] = None
		ItemCounts[2] = 0

		Debug.Notification("DROPPED: " + GetItemNameAndCount(RecentItems[0], ItemCounts[0]) + " - " + GetItemNameAndCount(RecentItems[1], ItemCounts[1]) + " - " + GetItemNameAndCount(RecentItems[2], ItemCounts[2]))
		Debug.Trace("DROPPED: " + GetItemNameAndCount(RecentItems[0], ItemCounts[0]) + " - " + GetItemNameAndCount(RecentItems[1], ItemCounts[1]) + " - " + GetItemNameAndCount(RecentItems[2], ItemCounts[2]))
	EndIf
EndEvent