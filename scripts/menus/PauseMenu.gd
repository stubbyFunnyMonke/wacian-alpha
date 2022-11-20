extends Control

var is_paused = false setget set_is_paused
var uiOpen = false

onready var clickSFX = PauseMenu.get_node("clickSFX")
onready var QuitContainer = get_node("/root/PauseMenu/QuitContainer")
onready var OptionsContainer = get_node("/root/PauseMenu/OptionsContainer")

func _ready():
	for i in get_all_children(PauseMenu):
		if i.get_class() == "Button":
			i.connect("pressed", self, "clickSFX")

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

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
	self.visible = false
	QuitContainer.visible = true

func _on_ConfirmQuitBtn_pressed():
	global.quit_game()
	self.is_paused = false
	get_tree().paused = false
	QuitContainer.visible = false

func _on_BackBtn_pressed():
	if visible == false:
		self.visible = true
		QuitContainer.visible = false

func clickSFX():
	clickSFX.play()

func _on_OptionsBtn_pressed():
	self.visible = false
	OptionsContainer.visible = true
	uiOpen = true
