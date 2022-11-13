extends Control

onready var QuitContainer = get_node("/root/MainMenuBG/mainMenu/QuitContainer")

func _on_PlayBtn_pressed():
	global.reset_game()

func _on_QuitBtn_pressed():
	self.visible = false
	QuitContainer.visible = true

func _on_BackBtn2_pressed():
	self.visible = true
	QuitContainer.visible = false

func _on_ConfirmQuitBtn2_pressed():
	get_tree().quit()
