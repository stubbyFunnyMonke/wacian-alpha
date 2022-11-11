extends Node2D

#inventory shit
onready var hotbar = $UI/Hotbar
onready var containermenu = $UI/ContainerMenu
onready var drag_preview = $UI/DragPreview
onready var tooltip = $UI/Tooltip

func _unhandled_input(event):
	if event.is_action_pressed("drop"):
		if inventory.get_selected().size() != 0:
			drop_item(inventory.remove_item(inventory.selected))
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var dragged_item = drag_preview.dragged_item
			if dragged_item:
				drop_item(drag_preview.dragged_item)
				drag_preview.dragged_item = {}
	if event.is_action_pressed("ui_cancel"):
		if containermenu.visible:
			containermenu.visible = false
			containerhandler.close_container()
	if event.is_action_pressed("useitem"):
		if inventory.get_selected():
			var scriptname = inventory.get_selected().key + ".gd"
			var actions = load("res://scripts/items/%s" % scriptname)
			if actions:
				var loadActions = actions.new()
				if loadActions.has_method("use"):
					loadActions.use(get_node("YSort/Player"))

func _ready():
	#send sandbox area node to the global script
	var sandboxarea = get_node("SandboxArea")
	var player = get_node("YSort/Player")
	changefloor.changeSandboxInstance(sandboxarea)
	changefloor.initializePlayer(player)
	playgroundHandler.newFloor(get_node("YSort/Items"), get_node("YSort/Playground"), get_node("Background"))

func _on_ItemSlot_gui_input(event, index, slotowner):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			drag_item(index, slotowner)
		elif event.button_index == BUTTON_RIGHT and event.pressed:
			split_item(index, slotowner)

func drop_item(item):
	var dropitem = preload("res://scenes/entities/droppeditem.tscn")
	var player = $YSort/Player
	
	var dropitem1 = dropitem.instance()
	dropitem1.setItem(item)
	dropitem1.setPos(player.position)
	get_node("YSort/Items").add_child(dropitem1)

func drag_item(index, slotowner):
	if slotowner.name == "ContainerMenu":
		var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
		var containers = containerhandler.containers
		var container_item = containers[currentfloor][str(containerhandler.currentopened)][index]
		var dragged_item = drag_preview.dragged_item
		# pick item
		if  container_item and !dragged_item:
			drag_preview.dragged_item = containerhandler.remove_item(containerhandler.currentopened, index)
		# drop item
		elif !container_item and dragged_item:
			drag_preview.dragged_item = containerhandler.set_item(containerhandler.currentopened, index, dragged_item)
		# swap items
		elif container_item and dragged_item:
			# stack item
			if container_item.key == dragged_item.key and container_item.stackable:
				containerhandler.set_item_quantity(containerhandler.currentopened, index, dragged_item.quantity)
				drag_preview.dragged_item = {}
			# swap items
			else:
				drag_preview.dragged_item = containerhandler.set_item(containerhandler.currentopened, index, dragged_item)
	else:
		var inventory_item = inventory.items[index]
		var dragged_item = drag_preview.dragged_item
		# pick item
		if inventory_item and !dragged_item:
			drag_preview.dragged_item = inventory.remove_item(index)
		# drop item
		elif !inventory_item and dragged_item:
			drag_preview.dragged_item = inventory.set_item(index, dragged_item)
		# swap items
		elif inventory_item and dragged_item:
			# stack item
			if inventory_item.key == dragged_item.key and inventory_item.stackable:
				inventory.set_item_quantity(index, dragged_item.quantity)
				drag_preview.dragged_item = {}
			# swap items
			else:
				drag_preview.dragged_item = inventory.set_item(index, dragged_item)

func split_item(index, slotowner):
	if slotowner.name == "ContainerMenu":
		var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
		var containers = containerhandler.containers
		var container_item = containers[currentfloor][str(containerhandler.currentopened)][index]
		var dragged_item = drag_preview.dragged_item
		if !container_item or !container_item.stackable: return
		var split_amount = ceil(container_item.quantity / 2.0)
		if dragged_item and container_item.key == dragged_item.key:
			drag_preview.dragged_item.quantity += split_amount
			containerhandler.set_item_quantity(containerhandler.currentopened, index, -split_amount)
		if !dragged_item:
			var item = container_item.duplicate()
			item.quantity = split_amount
			drag_preview.dragged_item = item
			containerhandler.set_item_quantity(containerhandler.currentopened, index, -split_amount)
	else:
		var inventory_item = inventory.items[index]
		var dragged_item = drag_preview.dragged_item
		if !inventory_item or !inventory_item.stackable: return
		var split_amount = ceil(inventory_item.quantity / 2.0)
		if dragged_item and inventory_item.key == dragged_item.key:
			drag_preview.dragged_item.quantity += split_amount
			inventory.set_item_quantity(index, -split_amount)
		if !dragged_item:
			var item = inventory_item.duplicate()
			item.quantity = split_amount
			drag_preview.dragged_item = item
			inventory.set_item_quantity(index, -split_amount)

func show_tooltip(index, slotowner):
	if slotowner.name == "ContainerMenu":
		var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
		var containers = containerhandler.containers
		var container_item = containers[currentfloor][str(containerhandler.currentopened)][index]
		if container_item and !drag_preview.dragged_item:
			tooltip.display_info(container_item)
			tooltip.show()
		else:
			tooltip.hide()
	else:
		var inventory_item = inventory.items[index]
		if inventory_item and !drag_preview.dragged_item:
			tooltip.display_info(inventory_item)
			tooltip.show()
		else:
			tooltip.hide()

func hide_tooltip():
	tooltip.hide()
