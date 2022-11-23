extends Label


func _physics_process(delta):
	text = "Waves Survived: " + str(WaveSystem.waveNumber - 1)
