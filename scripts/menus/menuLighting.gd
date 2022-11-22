extends CanvasModulate


const NORMAL_COLOR = Color("#ffffff")
const POWER_OUT_COLOR = Color("#676f8d")
const LIGHTNING_COLOR = Color("#929ece")
const INDOOR_STRIKE_COLOR = Color("#ffffff")

func _physics_process(delta):
	var rng = (randi() % 100) + 1
	if rng == 1:
		#perform random rng again to decide whether or not to set fire
		var strikeRNG = (randi() % 9) + 1
		if strikeRNG == 1:
			lightning_strike()
			self.color = INDOOR_STRIKE_COLOR
		else:
			self.color = LIGHTNING_COLOR
	else:
		self.color = lerp(self.color, POWER_OUT_COLOR, delta)

func lightning_strike():
	var chooseLightningStrike = (randi() % 3) + 1
	get_tree().current_scene.get_node("lightningstrike_set_%s" % chooseLightningStrike).visible = true
	
	var t = Timer.new()
	t.set_wait_time(0.2)
	t.set_one_shot(true)
	self.add_child(t)
	t.start()
	yield(t, "timeout")
	t.queue_free()
	
	get_tree().current_scene.get_node("lightningstrike_set_%s" % chooseLightningStrike).visible = false
