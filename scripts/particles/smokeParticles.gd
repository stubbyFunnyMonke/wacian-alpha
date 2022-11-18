extends Particles2D

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var playerNode = global.get_scene_node().get_node("YSort/Player")
	if playerNode.position.distance_to(get_parent().position) <= 64:
		self.emitting = true
	else:
		self.emitting = false
