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


#debug purposes
func dir(class_instance):
	var output = {}
	var methods = []
	for method in class_instance.get_method_list():
		methods.append(method.name)
	
	output["METHODS"] = methods
	
	var properties = []
	for prop in class_instance.get_property_list():
		if prop.type == 3:
			properties.append(prop.name)
	output["PROPERTIES"] = properties

	return output

func _on_ChangeButton_pressed():
	emit_signal('change_button_pressed')
