extends Node

var ingame = false

#GRAPHICS SETTINGS
var particles = true

func _ready():
	LoadingScreenNoBar.visible = false
	PauseMenu.get_node("Container").visible = false
	
	#debug
	#reset_game()

func reset_game():
	ingame = false
	
	yield(get_tree(), "idle_frame")
	
	LoadingScreenNoBar.visible = true
	LoadingScreenNoBar.get_node("AnimationPlayer").play("loop")
	
	inventory.reset()
	playerstats.reset()
	disasterHandler.reset()
	containerhandler.reset()
	playgroundHandler.reset()
	changefloor.reset()
	Guide.reset()
	
	for floorlevel in changefloor.floors:
		get_tree().change_scene("res://scenes/levels/" + floorlevel)
		yield(get_tree().current_scene, "tree_exited")
		yield(get_tree(), "idle_frame")
		changefloor.currentfloor = changefloor.currentfloor + 1
	
	changefloor.currentfloor = 0
	get_tree().change_scene("res://scenes/levels/gfloor.tscn")
	
	yield(get_tree(), "idle_frame")
	LoadingScreenNoBar.get_node("AnimationPlayer").play("fadeout")
	
	ingame = true
	WaveSystem.reset()


func game_over():
	#TODO: implement death messages + sfx + music + the scene
	
	ingame = false
	
	#wait
	var t = Timer.new()
	t.set_wait_time(0.5)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	WaveSystem.end()
	Input.set_custom_mouse_cursor(null)
	bgmusic.reset()
	
	Textbox.change_state(Textbox.State.READY)
	Textbox.hide_textbox()
	
	get_tree().change_scene("res://scenes/menus/GameOverScreen.tscn")
	pass

func quit_game():
	ingame = false
	
	WaveSystem.end()
	Input.set_custom_mouse_cursor(null)
	bgmusic.reset()
	
	Textbox.change_state(Textbox.State.READY)
	Textbox.hide_textbox()
	
	LoadingScreenNoBar.visible = true
	LoadingScreenNoBar.get_node("AnimationPlayer").play("loop")
	
	get_tree().change_scene("res://scenes/menus/mainMenu.tscn")
	yield(get_tree().current_scene, "tree_exited")
	yield(get_tree(), "idle_frame")
	
	LoadingScreenNoBar.get_node("AnimationPlayer").play("fadeout")

func get_scene_node():
	return get_tree().get_current_scene()

#for generating waveIDs and other ID related stuff if ever
var ascii_letters_and_digits = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
func gen_unique_string(length: int) -> String:
	var result = ""
	for i in range(length):
		result += ascii_letters_and_digits[randi() % ascii_letters_and_digits.length()]
	return result


