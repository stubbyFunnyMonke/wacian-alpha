extends HBoxContainer

signal change_button_pressed

const mouseButtonList = {
	1: "Left Mouse Button",
	2: "Right Mouse Button",
	3: "Middle Mouse Button",
	8: "Mouse Button 4",
	9: "Mouse Button 5"
}

func initialize(action_name, key, can_change):
	$Action.text = action_name.capitalize()
	
	if key[1] == "InputEventKey":
		$Key.text = OS.get_scancode_string(key[0])
	elif key[1] == "InputEventMouseButton":
		if key[0] in mouseButtonList:
			$Key.text = str(mouseButtonList[key[0]])
	
	$ChangeButton.disabled = not can_change

func update_key(scancode, inputType):
	if inputType == "InputEventKey":
		$Key.text = OS.get_scancode_string(scancode)
	elif inputType == "InputEventMouseButton":
		if scancode in mouseButtonList:
			$Key.text = str(mouseButtonList[scancode])

func _on_keybinds_changed(action_name, line):
	if weakref(line).get_ref():
		line.update_key(InputMapper.get_selected_profile()[action_name][0], InputMapper.get_selected_profile()[action_name][1])

func _on_ChangeButton_pressed():
	emit_signal('change_button_pressed')
