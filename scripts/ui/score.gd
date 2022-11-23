extends Label


func _physics_process(delta):
	text = "Score: " + str(playerstats.score)
