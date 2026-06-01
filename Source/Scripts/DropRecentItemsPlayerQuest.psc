Scriptname DropRecentItemsPlayerQuest extends ReferenceAlias  

Form[] RecentItems
Int Property DropKey = 45 Auto

String Function GetFormName(Form akForm)
	If !akForm
		Return "Empty"
	EndIf

	Return akForm.GetName()
EndFunction

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
	RecentItems[2] = RecentItems[1]
	RecentItems[1] = RecentItems[0]
	RecentItems[0] = akBaseItem

	Debug.Trace("AFTER ADDED: " + GetFormName(RecentItems[0]) + " - " + GetFormName(RecentItems[1]) + " - " + GetFormName(RecentItems[2]))
	Debug.Notification("AFTER ADDED: " + GetFormName(RecentItems[0]) + " - " + GetFormName(RecentItems[1]) + " - " + GetFormName(RecentItems[2]))
EndEvent

Event OnKeyDown(Int KeyCode)
	If !Utility.IsInMenuMode() && KeyCode == DropKey
		If RecentItems[0] == None
			Debug.Trace("No recent items found")
			Debug.Notification("No recent items found")
			Return
		EndIf

		Game.GetPlayer().DropObject(RecentItems[0], 1)
		RecentItems[0] = RecentItems[1]
		RecentItems[1] = RecentItems[2]
		RecentItems[2] = None

		Debug.Trace("AFTER DROPPED: " + GetFormName(RecentItems[0]) + " - " + GetFormName(RecentItems[1]) + " - " + GetFormName(RecentItems[2]))
		Debug.Notification("AFTER DROPPED: " + GetFormName(RecentItems[0]) + " - " + GetFormName(RecentItems[1]) + " - " + GetFormName(RecentItems[2]))

	EndIf
EndEvent