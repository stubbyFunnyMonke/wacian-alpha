extends AnimatedSprite

func _physics_process(delta):
	if playerstats.onfire == true:
		visible = true
	else:
		visible = false
