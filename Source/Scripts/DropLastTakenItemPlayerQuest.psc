Scriptname DropLastTakenItemPlayerQuest extends ReferenceAlias  

Form[] LastTakenItem
Int DropKey = 45

Event OnInit()
	LastTakenItem = new Form[1]
	RegisterForKey(DropKey)
EndEvent

Event OnItemAdded(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akSourceContainer)
	LastTakenItem[0] = akBaseItem
EndEvent

Event OnKeyDown(Int KeyCode)
	If KeyCode == DropKey
		If LastTakenItem && LastTakenItem[0]
			Game.GetPlayer().DropObject(LastTakenItem[0], 1)
			; --- TODO ---
			; - Drop all if the item is stacked: e.g. arrows, gold, etc.
			; - Only drop item the player picked up. 
			; - Prevent dropping un-droppable items: e.g. unfinished quest items.
			; - Prevent dropping while in menus.
			; - Prevent the quest baked into saves.
			; - Add configurable key (probably using MCM?).
		EndIf
	LastTakenItem[0] = None	
	EndIf
EndEvent

