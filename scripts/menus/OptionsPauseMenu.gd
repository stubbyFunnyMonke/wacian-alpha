extends Control

onready var mainContainer = get_node("/root/PauseMenu/Container")

onready var volumeSettings = get_node("VolumeSettingsContainer")
onready var controlSettings = get_node("ControlSettingsContainer")

func _ready():
	visible = false

func _on_BackBtn_pressed():
	visible = false
	mainContainer.visible = true
	mainContainer.uiOpen = false

func _on_VolumeBtn_pressed():
	volumeSettings.visible = true
	controlSettings.visible = false

func _on_ControlBtn_pressed():
	volumeSettings.visible = false
	controlSettings.visible = true
