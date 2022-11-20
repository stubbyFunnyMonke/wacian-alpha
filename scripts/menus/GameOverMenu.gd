extends Control

#TODO: load rank + scores and then animate them

onready var animPlayer1 = get_node("/root/GameOver/CutsceneController")

func _on_QuitBtn_pressed():
	animPlayer1.play("fade_out")
	yield(animPlayer1, "animation_finished")
	global.quit_game()

func _on_PlayBtn_pressed():
	animPlayer1.play("fade_out")
	yield(animPlayer1, "animation_finished")
	global.reset_game()
