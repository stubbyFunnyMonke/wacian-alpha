extends Node

signal items_changed(indexes)
signal selected_changed

var cols = 5
var rows = 1
var slots = cols * rows
var items = []
var selected = 0

func _ready():
	reset()

func reset():
	items = []
	for _i in range(slots):
		items.append({})

func broadcast_signal(indexes):
	emit_signal("items_changed", indexes)
	for index in indexes:
		if index == selected:
			emit_signal("selected_changed")

func set_item(index, item):
	var previous_item = items[index]
	items[index] = item
	emit_signal("items_changed", [index])
	return previous_item

func remove_item(index):
	var previous_item = items[index].duplicate()
	items[index].clear()
	emit_signal("items_changed", [index])
	return previous_item

func set_item_quantity(index, amount):
	items[index].quantity += amount
	if items[index].quantity <= 0:
		remove_item(index)
	else:
		emit_signal("items_changed", [index])

func add_item(item, amount):
	var doneAdding = false
	
	#check if can stack
	for i in range(items.size()):
		if items[i].size() != 0:
			if items[i].key == item.key && items[i].stackable == true:
				items[i].quantity += amount
				doneAdding = true
				emit_signal("items_changed", [i])
				break
	
	#add on a new slot if available
	if !doneAdding:
		for i in range(items.size()):
			if items[i].size() == 0:
				items[i] = item
				doneAdding = true
				emit_signal("items_changed", [i])
				break
	
	return doneAdding 

func set_selected(new_selected):
	if new_selected + 1 <= cols:
		var last_selected = selected
		selected = new_selected
		broadcast_signal([selected, last_selected])

func get_selected():
	return items[selected]
