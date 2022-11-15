extends Node

var ingame = false

func _ready():
	LoadingScreenNoBar.visible = false
	PauseMenu.get_node("Container").visible = false

func reset_game():
	ingame = false
	
	inventory.reset()
	playerstats.reset()
	disasterHandler.reset()
	containerhandler.reset()
	playgroundHandler.reset()
	changefloor.reset()
	
	LoadingScreenNoBar.visible = true
	LoadingScreenNoBar.get_node("AnimationPlayer").play("loop")
	
	for floorlevel in changefloor.floors:
		get_tree().change_scene("res://scenes/levels/" + floorlevel)
		yield(get_tree().current_scene, "tree_exited")
		yield(get_tree(), "idle_frame")
		changefloor.currentfloor = changefloor.currentfloor + 1
	
	changefloor.currentfloor = 0
	get_tree().change_scene("res://scenes/levels/gfloor.tscn")
	
	yield(get_tree(), "idle_frame")
	LoadingScreenNoBar.get_node("AnimationPlayer").play("fadeout")
	
	WaveSystem.reset()
	
	ingame = true

func game_over():
	#TODO: implement death messages + sfx + music + the scene
	
	ingame = false
	
	bgmusic.reset()
	
	get_tree().change_scene("res://scenes/menus/GameOverScreen.tscn")
	pass

func quit_game():
	ingame = false
	
	bgmusic.reset()
	
	LoadingScreenNoBar.visible = true
	LoadingScreenNoBar.get_node("AnimationPlayer").play("loop")
	
	get_tree().change_scene("res://scenes/menus/mainMenu.tscn")
	yield(get_tree().current_scene, "tree_exited")
	yield(get_tree(), "idle_frame")
	
	LoadingScreenNoBar.get_node("AnimationPlayer").play("fadeout")

func get_scene_node():
	return get_tree().get_current_scene()

func wait(duration):
	var t = Timer.new()
	t.set_wait_time(duration)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
