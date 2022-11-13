extends Control

onready var QuitContainer = get_node("/root/MainMenuBG/mainMenu/QuitContainer")
onready var introAnims = get_node("/root/MainMenuBG/IntroAnims1")
onready var mainmenumusic = get_node("/root/MainMenuBG/mainMenu/AudioStreamPlayer")

func _on_PlayBtn_pressed():
	introAnims.play("startgame")
	mainmenumusic.stop()

func _on_QuitBtn_pressed():
	self.visible = false
	QuitContainer.visible = true

func _on_BackBtn2_pressed():
	self.visible = true
	QuitContainer.visible = false

func _on_ConfirmQuitBtn2_pressed():
	get_tree().quit()

func _on_IntroAnims1_animation_finished(anim_name):
	if anim_name == "startgame":
		global.reset_game()
