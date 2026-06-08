Scriptname DropRecentItemsPlayerScript extends ReferenceAlias  

import PO3_SKSEFunctions

FormList Property DropRecentItemsExclusionList Auto
int Property DropKeyCode = 45 Auto
int Property MaxRecentItems = 3 Auto
Form[] RecentItems
int[] ItemCounts


string Function GetRecentItemsList(Form[] akForms, int[] aiItemCounts)
	string recentItemsList = "RECENT ITEMS LIST" + "\n"
	int index = 0
	While index < akForms.Length
		If akForms[index]
			recentItemsList += (index + 1) + ". " + akForms[index].GetName() + " (" + aiItemCounts[index] + ")" + "\n"
		Else
			recentItemsList += (index + 1) + ". None" + "\n"
		EndIf
	index += 1
	EndWhile
	return recentItemsList
EndFunction

Event OnInit()
	UnregisterForAllKeys()
	RegisterForKey(DropKeyCode)
	RecentItems = Utility.CreateFormArray(MaxRecentItems)
	ItemCounts = Utility.CreateIntArray(MaxRecentItems)
EndEvent

Event OnPlayerLoadGame()
	UnregisterForAllKeys()
	RegisterForKey(DropKeyCode)
	RecentItems = Utility.CreateFormArray(MaxRecentItems)
	ItemCounts = Utility.CreateIntArray(MaxRecentItems)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	If DropRecentItemsExclusionList.HasForm(akBaseItem) || (akItemReference && IsQuestItem(akItemReference)) || akBaseItem.getName() == "" 
		Debug.Trace("This item is excluded from recent items")
		Debug.Notification("This item is excluded from recent items")
		return
	EndIf
	int index = RecentItems.Length - 1
	While index > 0
		RecentItems[index] = RecentItems[index - 1]
		ItemCounts[index] = ItemCounts[index - 1]
		index -= 1
	EndWhile
	RecentItems[0] = akBaseItem
	ItemCounts[0] = aiItemCount
	Debug.Trace(GetRecentItemsList(RecentItems, ItemCounts))
	MiscUtil.PrintConsole(GetRecentItemsList(RecentItems, ItemCounts))
EndEvent

Event OnKeyDown(int KeyCode)
	If KeyCode == DropKeyCode && !Utility.IsInMenuMode() && !UI.IsMenuOpen("Dialogue Menu")
		If RecentItems[0] == None
			Debug.Trace("There are no recent items")
			Debug.Notification("There are no recent items")
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
		Debug.Trace(GetRecentItemsList(RecentItems, ItemCounts))
		MiscUtil.PrintConsole(GetRecentItemsList(RecentItems, ItemCounts))
	EndIf
EndEvent