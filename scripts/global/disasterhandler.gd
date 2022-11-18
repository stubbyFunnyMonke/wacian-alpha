extends Node

#general disaster vars
var intensity = 9
var disasterData = {
	"earthquake": {
		"start": 2,
		"duration": 90,
		"active": false
	},
	"storm": {
		"start": 1,
		"duration": 90,
		"active": false
	}
}

#earthquake vars
var earthquakeIntensity = 4
var earthquakeLoop = preload("res://assets/sounds/disasters/earthquake/rumble_loop.wav")
var earthquakeRumble = AudioStreamPlayer.new()

#storm vars
var rainLoop = preload("res://assets/sounds/disasters/storm/rain_loop.wav")
var raining = AudioStreamPlayer.new()

func _ready():
	#initialize earthquake Rumble
	earthquakeRumble.stream = earthquakeLoop
	GlobalSFX.add_child(earthquakeRumble)
	earthquakeRumble.bus = "ambience"
	
	#initialize rain sounds
	raining.stream = rainLoop
	GlobalSFX.add_child(raining)
	raining.bus = "ambience"

func reset():
	#intensity = 1
	
	for disaster in disasterData:
		disasterData[disaster].active = false

func _physics_process(delta):
	if global.ingame == true:
		intensity = WaveSystem.waveNumber
		
		#earthquake shit
		if disasterData["earthquake"].active == true:
			var calculatedEarthquakeIntensity = earthquakeIntensity + intensity
			if earthquakeRumble.is_playing() == false:
				earthquakeRumble.play()
			for floorlevel in playgroundHandler.tileDurabilityData:
				for tile in playgroundHandler.tileDurabilityData[floorlevel]:
					var rng = (randi() % 10000/calculatedEarthquakeIntensity) + 1
					if rng == 1:
						playgroundHandler.silent_deteriorate_tile(tile, floorlevel, 3  *  (1 + (calculatedEarthquakeIntensity/9)))
		elif disasterData["earthquake"].active == false:
			if earthquakeRumble.is_playing() == true:
				earthquakeRumble.stop()
		
		#storm stuff
		if disasterData["storm"].active == true:
			if raining.is_playing() == false:
				raining.play()
		elif disasterData["storm"].active == false:
			if raining.is_playing() == true:
				raining.stop()
				
	else:
		
		#stop all sounds
		if raining.is_playing() == true:
			raining.stop()
		if earthquakeRumble.is_playing() == true:
			earthquakeRumble.stop()
