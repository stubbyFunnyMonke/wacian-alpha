extends CanvasModulate

signal thunder
signal stop_thunder
signal strong_thunder

var switch = false

const NORMAL_COLOR = Color("#ffffff")
const POWER_OUT_COLOR = Color("#383c4d")
const LIGHTNING_COLOR = Color("#555e83")
const INDOOR_STRIKE_COLOR = Color("#ffffff")

func _physics_process(delta):
	var intensity = disasterHandler.earthquakeIntensity + disasterHandler.intensity
	if disasterHandler.disasterData["storm"].active == true:
		switch = true
		var rng = (randi() % 1000/intensity) + 1
		if rng == 1:
			#perform random rng again to decide whether or not to set fire
			var strikeRNG = (randi() % 9) + 1
			if strikeRNG == 1 && changefloor.floors[changefloor.currentfloor] != "rooftop.tscn":
				self.color = INDOOR_STRIKE_COLOR
				emit_signal("strong_thunder")
			else:
				self.color = LIGHTNING_COLOR
				emit_signal("thunder")
		else:
			self.color = lerp(self.color, POWER_OUT_COLOR, delta)
	else:
		self.color = lerp(self.color, NORMAL_COLOR, delta)
		if switch == true:
			#makes it so the signal only emits once
			switch = false
			emit_signal("stop_thunder")

func _on_gameLighting_thunder():
	var thunderStream = preload("res://assets/sounds/disasters/storm/thunder_rumble.wav")
	var thunderSound = AudioStreamPlayer.new()
	thunderSound.stream = thunderStream
	GlobalSFX.add_child(thunderSound)
	thunderSound.bus = "ambience"
	thunderSound.play()
	thunderSound.name = "thunder"
	yield(thunderSound, "finished")
	thunderSound.queue_free()

func _on_gameLighting_strong_thunder():
	var thunderStream = preload("res://assets/sounds/disasters/storm/lightning_strike.wav")
	var thunderSound = AudioStreamPlayer.new()
	thunderSound.stream = thunderStream
	GlobalSFX.add_child(thunderSound)
	thunderSound.bus = "ambience"
	thunderSound.play()
	thunderSound.name = "thunder"
	
	for cell in global.get_scene_node().get_node("YSort/Fire/FireSpreadable").get_used_cells():
		var strikeRNG = (randi() % 9) + 1
		if strikeRNG == 1:
			playgroundHandler.currentFireTilemap.set_cellv(cell, 0)
			break
	
	yield(thunderSound, "finished")
	thunderSound.queue_free()
