extends Particles2D

func _on_StopEmitting_timeout():
	emitting = false

func _on_Delete_timeout():
	queue_free()
