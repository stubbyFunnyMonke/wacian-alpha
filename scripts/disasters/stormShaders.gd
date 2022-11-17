extends CanvasModulate

const NORMAL_COLOR = Color("#ffffff")
const POWER_OUT_COLOR = Color("#383c4d")
const LIGHTNING_COLOR = Color("#555e83")

func _physics_process(delta):
	var intensity = disasterHandler.earthquakeIntensity + disasterHandler.intensity
	if disasterHandler.disasterData["storm"].active == true:
		var rng = (randi() % 1000/intensity) + 1
		if rng == 1:
			self.color = LIGHTNING_COLOR
		else:
			self.color = lerp(self.color, POWER_OUT_COLOR, delta)
	else:
		self.color = lerp(self.color, NORMAL_COLOR, delta)
