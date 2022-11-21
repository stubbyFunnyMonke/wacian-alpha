extends Control

onready var _action_list = get_node("VBoxContainer/ScrollContainer/ActionList")

func _ready():
	InputMapper.connect('profile_changed', self, 'rebuild')
	$VBoxContainer/ProfilesMenuContainer/ProfilesMenu.initialize(InputMapper)
	InputMapper.change_profile($VBoxContainer/ProfilesMenuContainer/ProfilesMenu.selected)


func rebuild(input_profile, is_customizable=false):
	_action_list.clear()
	for input_action in input_profile.keys():
		var line = _action_list.add_input_line(input_action, \
			input_profile[input_action], is_customizable)
		if is_customizable:
			line.connect('change_button_pressed', self, \
				'_on_InputLine_change_button_pressed', [input_action, line])

func _on_InputLine_change_button_pressed(action_name, line):
	set_process_input(false)
	
	$KeySelectMenu.open()
	var input = yield($KeySelectMenu, "key_selected")
	if input[1] == "InputEventKey":
		InputMapper.change_action_key(action_name, input[0])
	elif input[1] == "InputEventMouseButton":
		InputMapper.change_action_mouse(action_name, input[0])
	line.update_key(input[0], input[1])
	
	set_process_input(true)
