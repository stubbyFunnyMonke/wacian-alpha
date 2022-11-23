extends Label


func _physics_process(delta):
	text = "Final Score: " + str(playerstats.score)
