extends Panel

signal key_selected(input, inputclass)

func _ready():
	set_process_input(false)

func _input(event):
	if not event.is_pressed():
		return
	if event.is_class("InputEventKey"):
		emit_signal("key_selected", event.scancode, "InputEventKey")
	elif event.is_class("InputEventMouseButton"):
		emit_signal("key_selected", event.button_index, "InputEventMouseButton")
	close()

func open():
	show()
	set_process_input(true)

func close():
	hide()
	set_process_input(false)

