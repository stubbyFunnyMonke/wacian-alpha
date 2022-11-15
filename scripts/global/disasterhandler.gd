extends Node

#general disaster vars
var intensity = 9

#earthquake vars
var earthquakeIntensity = 4
var earthquakeActive = false
var earthquakeLoop = preload("res://assets/sounds/disasters/earthquake/rumble_loop.wav")
var earthquakeRumble = AudioStreamPlayer.new()

func _ready():
	#initialize earthquake Rumble
	earthquakeRumble.stream = earthquakeLoop
	GlobalSFX.add_child(earthquakeRumble)
	earthquakeRumble.bus = "ambience"

func reset():
	#intensity = 1
	
	earthquakeActive = false

func _unhandled_input(event):
	if event.is_action_pressed("debug_earthquake_switch"):
		earthquakeActive = !earthquakeActive

func _physics_process(delta):
	if global.ingame == true:
		#earthquake shit
		if earthquakeActive == true:
			var calculatedEarthquakeIntensity = earthquakeIntensity + intensity
			if earthquakeRumble.is_playing() == false:
				earthquakeRumble.play()
			for floorlevel in playgroundHandler.tileDurabilityData:
				for tile in playgroundHandler.tileDurabilityData[floorlevel]:
					var rng = (randi() % 10000/calculatedEarthquakeIntensity) + 1
					if rng == 1:
						playgroundHandler.silent_deteriorate_tile(tile, floorlevel, 3  *  (1 + (calculatedEarthquakeIntensity/9)))
		elif earthquakeActive == false:
			if earthquakeRumble.is_playing() == true:
				earthquakeRumble.stop()
