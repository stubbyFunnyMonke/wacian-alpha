extends Node

#general disaster vars
var intensity = 9
var disasterData = {
	"earthquake": {
		"start": 1,
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
var waterLevel = 0
const maxWaterLevel = 1000

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
	
	waterLevel = 1000

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
			
			var totalMaxDurability = 0
			var totalCurrentDurability = 0
			
			for tile in playgroundHandler.tileDurabilityData[str(0)]:
				totalMaxDurability = totalMaxDurability + playgroundHandler.tileDurabilityData[str(0)][tile].maxDurability
				totalCurrentDurability = totalCurrentDurability + playgroundHandler.tileDurabilityData[str(0)][tile].currentDurability
			
			var durabilityPercentage = totalCurrentDurability/totalMaxDurability
			if durabilityPercentage > 1: durabilityPercentage = 1
			
			if waterLevel <= maxWaterLevel:
				waterLevel = waterLevel + (delta * (1 - durabilityPercentage) * intensity) 
			print(waterLevel)
		elif disasterData["storm"].active == false:
			if raining.is_playing() == true:
				raining.stop()
			
			if waterLevel > 0:
				waterLevel = waterLevel - (delta * 5)
	else:
		
		#stop all sounds
		if raining.is_playing() == true:
			raining.stop()
		if earthquakeRumble.is_playing() == true:
			earthquakeRumble.stop()
