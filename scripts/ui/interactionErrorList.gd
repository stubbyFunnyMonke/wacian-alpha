extends GridContainer

export (PackedScene) var interactionError

onready var errSound = $AudioStreamPlayer

func error_msg(txt):
	var newErr = interactionError.instance()
	newErr.text = txt
	
	var timer = newErr.get_node("Timer")
	
	if timer:
		timer.connect("timeout", self, "_on_timer_end", [newErr])
	
	errSound.play()
	
	add_child(newErr)

func _on_timer_end(errNode):
	var animationPlayer = errNode.get_node("AnimationPlayer")
	animationPlayer.play("fadeout")
	
	var timer = animationPlayer.get_node("Timer")
	if timer:
		timer.start()
		timer.connect("timeout", self, "_delete_self", [errNode])

func _delete_self(errNode):
	remove_child(errNode)
	errNode.queue_free()
