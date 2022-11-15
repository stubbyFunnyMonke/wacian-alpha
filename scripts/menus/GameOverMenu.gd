extends Control

#TODO: load rank + scores and then animate them

func _on_QuitBtn_pressed():
	global.quit_game()

func _on_PlayBtn_pressed():
	global.reset_game()
