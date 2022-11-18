extends CanvasModulate

signal thunder
signal stop_thunder

var switch = false

const NORMAL_COLOR = Color("#ffffff")
const POWER_OUT_COLOR = Color("#383c4d")
const LIGHTNING_COLOR = Color("#555e83")

func _physics_process(delta):
	var intensity = disasterHandler.earthquakeIntensity + disasterHandler.intensity
	if disasterHandler.disasterData["storm"].active == true:
		switch = true
		var rng = (randi() % 1000/intensity) + 1
		if rng == 1:
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
