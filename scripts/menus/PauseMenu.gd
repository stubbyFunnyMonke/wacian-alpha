extends Control

var is_paused = false setget set_is_paused
var uiOpen = false

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if uiOpen == true or global.ingame == false:
			return
		self.is_paused = !is_paused
		if is_paused == true:
			Input.set_custom_mouse_cursor(null)

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused

func _on_ResumeBtn_pressed():
	self.is_paused = false

func _on_QuitBtn_pressed():
	global.quit_game()
	self.is_paused = false
	get_tree().paused = false
