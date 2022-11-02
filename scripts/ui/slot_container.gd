extends GridContainer

class_name SlotContainer

export (PackedScene) var ItemSlot

var slots

func display_item_slots(cols, rows, table):
	columns = cols
	slots = cols * rows
	for index in range(slots):
		var item_slot = ItemSlot.instance()
		add_child(item_slot)
		item_slot.display_item(table[index])
		
		var mainnode = get_tree().get_current_scene()
		item_slot.connect("gui_input", mainnode, "_on_ItemSlot_gui_input", [index, get_owner()])
		item_slot.connect("mouse_entered", mainnode, "show_tooltip", [index, get_owner()])
		item_slot.connect("mouse_exited", mainnode, "hide_tooltip")

func hotbar_handler_ready():
	inventory.connect("items_changed", self, "_on_Inventory_items_changed")

func container_handler_ready():
	containerhandler.connect("container_items_changed", self, "_on_Container_items_changed")
	containerhandler.connect("close_container", self, "_clearContainerSlots")

func _on_Inventory_items_changed(indexes):
	if(self.name == "Hotbar"):
		for index in indexes:
			if index < slots:
				var item_slot = get_child(index)
				item_slot.display_item(inventory.items[index])

func _on_Container_items_changed(indexes, slots2):
	if(self.name == "ContainerMenu"):
		var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
		var containers = containerhandler.containers
		for index in indexes:
			if index < slots2:
				var item_slot = get_child(index)
				item_slot.display_item(containers[currentfloor][str(containerhandler.currentopened)][index])

func _clearContainerSlots(slots2):
	if(self.name == "ContainerMenu"):
		var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
		var containers = containerhandler.containers
		for index in range(containers[currentfloor][str(containerhandler.currentopened)].size()):
			if index < slots2:
				var item_slot = get_child(index)
				item_slot.selfdestruct()
