Scriptname DropRecentItemsPlayerQuest extends ReferenceAlias  

int Property DropKey = 45 Auto
int Property MaxRecentItems = 3 Auto
Form[] RecentItems
int[] ItemCounts

string Function GetRecentItemsList(Form[] akForms, int[] aiItemCounts)
	string recentItemsList = ""
	int index = 0
	While index < akForms.Length
		If akForms[index]
			recentItemsList += "- " + akForms[index].GetName() + " (" + aiItemCounts[index] + ")" + "\n"
		Else
			recentItemsList += "- None" + "\n"
		EndIf
	index += 1
	EndWhile
	return recentItemsList
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
	int index = RecentItems.Length - 1
	While index > 0
		RecentItems[index] = RecentItems[index - 1]
		ItemCounts[index] = ItemCounts[index - 1]
		index -= 1
	EndWhile
	RecentItems[0] = akBaseItem
	ItemCounts[0] = aiItemCount
	Debug.Trace("RECENT ITEMS LIST" + "\n" + GetRecentItemsList(RecentItems, ItemCounts))
	Debug.MessageBox("RECENT ITEMS LIST" + "\n" + GetRecentItemsList(RecentItems, ItemCounts))
EndEvent

Event OnKeyDown(int KeyCode)
	If KeyCode == DropKey && !Utility.IsInMenuMode() && !UI.IsMenuOpen("Dialogue Menu")
		If RecentItems[0] == None
			Debug.Trace("No recent items found")
			Debug.MessageBox("No recent items found")
			return
		EndIf
		Game.GetPlayer().DropObject(RecentItems[0], ItemCounts[0])
		int index = 0
		int lastIndex = RecentItems.Length - 1
		While index < lastIndex
			RecentItems[index] = RecentItems[index + 1]
			ItemCounts[index] = ItemCounts[index + 1]
			index += 1
		EndWhile
		RecentItems[lastIndex] = None
		ItemCounts[lastIndex] = 0
		Debug.Trace("RECENT ITEMS LIST" + "\n" + GetRecentItemsList(RecentItems, ItemCounts))
		Debug.MessageBox("RECENT ITEMS LIST" + "\n" + GetRecentItemsList(RecentItems, ItemCounts))
	EndIf
EndEvent