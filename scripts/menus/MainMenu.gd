extends Control

func _on_PlayBtn_pressed():
	global.reset_game()


func _on_QuitBtn_pressed():
	get_tree().quit()
