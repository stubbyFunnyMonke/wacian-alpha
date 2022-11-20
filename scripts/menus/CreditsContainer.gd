extends Control

onready var mainContainer = get_node("/root/MainMenuBG/mainMenu/Container")

func _ready():
	visible = false

func _on_BackBtn2_pressed():
	visible = false
	mainContainer.visible = true
