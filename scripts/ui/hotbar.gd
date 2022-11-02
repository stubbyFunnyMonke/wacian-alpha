extends SlotContainer

var tick = 0

func _ready():
	display_item_slots(inventory.cols, 1, inventory.items)
	hotbar_handler_ready()
	yield(get_tree(), "idle_frame")
	rect_position.x = (get_viewport_rect().size.x - (rect_size.x) * rect_scale.x) / 2
	rect_position.y = get_viewport_rect().size.y - (rect_size.y) * rect_scale.y - 8

func _input(event) -> void:
	if event is InputEventMouseButton:
		if OS.get_ticks_msec() - tick <= 8: return
		tick = OS.get_ticks_msec()
		if event.button_index == BUTTON_WHEEL_DOWN:
			var new_selected = (inventory.selected + 1) % inventory.cols
			inventory.set_selected(new_selected)
		elif event.button_index == BUTTON_WHEEL_UP:
			var new_selected = inventory.selected - 1 if not inventory.selected == 0 else inventory.cols - 1
			inventory.set_selected(new_selected)
	if event is InputEventKey:
		if [KEY_1, KEY_2, KEY_3, KEY_4, KEY_5, KEY_6, KEY_7, KEY_8, KEY_9].has(event.scancode) and event.is_pressed():
			inventory.set_selected(event.scancode - 49)
