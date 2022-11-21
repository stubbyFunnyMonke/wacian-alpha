extends Node

signal profile_changed(new_profile, is_customizable)

var current_profile_id = 0
var profiles = {
	0: 'profile_normal',
	1: 'profile_alternate',
	2: 'profile_custom',
}
var profile_normal = {
	'walkup': [KEY_W, "InputEventKey"],
	'walkdown': [KEY_S, "InputEventKey"],
	'walkleft': [KEY_A, "InputEventKey"],
	'walkright': [KEY_D, "InputEventKey"],
	"furniture_move": [KEY_E, "InputEventKey"],
	"furniture_interact": [BUTTON_RIGHT, "InputEventMouseButton"],
	"drop": [KEY_Q, "InputEventKey"],
	"rotate": [KEY_R, "InputEventKey"],
	"useitem": [BUTTON_LEFT, "InputEventMouseButton"],
	"sprint": [KEY_SHIFT, "InputEventKey"],
	"crouch": [KEY_CONTROL, "InputEventKey"],
}

var profile_alternate = {
	'walkup': [KEY_UP, "InputEventKey"],
	'walkdown': [KEY_DOWN, "InputEventKey"],
	'walkleft': [KEY_LEFT, "InputEventKey"],
	'walkright': [KEY_RIGHT, "InputEventKey"],
	"furniture_move": [KEY_E, "InputEventKey"],
	"furniture_interact": [BUTTON_RIGHT, "InputEventMouseButton"],
	"drop": [KEY_Q, "InputEventKey"],
	"rotate": [KEY_R, "InputEventKey"],
	"useitem": [BUTTON_LEFT, "InputEventMouseButton"],
	"sprint": [KEY_SHIFT, "InputEventKey"],
	"crouch": [KEY_CONTROL, "InputEventKey"],
}

var profile_custom = {
	'walkup': [KEY_W, "InputEventKey"],
	'walkdown': [KEY_S, "InputEventKey"],
	'walkleft': [KEY_A, "InputEventKey"],
	'walkright': [KEY_D, "InputEventKey"],
	"furniture_move": [KEY_E, "InputEventKey"],
	"furniture_interact": [BUTTON_RIGHT, "InputEventMouseButton"],
	"drop": [KEY_Q, "InputEventKey"],
	"rotate": [KEY_R, "InputEventKey"],
	"useitem": [BUTTON_LEFT, "InputEventMouseButton"],
	"sprint": [KEY_SHIFT, "InputEventKey"],
	"crouch": [KEY_CONTROL, "InputEventKey"],
}

func change_profile(id):
	current_profile_id = id
	var profile = get(profiles[id])
	var is_customizable = true if id == 2 else false
	
	for action_name in profile.keys():
		if profile[action_name][1] == "InputEventKey":
			change_action_key(action_name, profile[action_name][0])
		elif profile[action_name][1] == "InputEventMouseButton":
			change_action_mouse(action_name, profile[action_name][0])
	emit_signal('profile_changed', profile, is_customizable)
	return profile

func change_action_key(action_name, key_scancode):
	erase_action_events(action_name)

	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	get_selected_profile()[action_name] = [key_scancode, "InputEventKey"]

func change_action_mouse(action_name, button_mask):
	erase_action_events(action_name)
	
	var new_event = InputEventMouseButton.new()
	new_event.set_button_index(button_mask)
	InputMap.action_add_event(action_name, new_event)
	get_selected_profile()[action_name] = [button_mask, "InputEventMouseButton"]

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func get_selected_profile():
	return get(profiles[current_profile_id])
