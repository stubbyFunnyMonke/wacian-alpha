extends Particles2D

func _physics_process(delta):
	visible = global.particles
	var playerNode = global.get_scene_node().get_node("YSort/Player")
	if playerNode.position.distance_to(get_parent().position) <= 96:
		self.emitting = true
	else:
		self.emitting = false
