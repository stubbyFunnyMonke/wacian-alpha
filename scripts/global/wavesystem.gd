extends Node

signal wave_state_changed

var state = CALM
var waveNumber = 1

enum {
	CALM,
	CONTROL,
	ANTICIPATION,
	ACTIVE,
}

func reset():
	waveNumber = 1
	change_state(CALM)
	
	waveLoop()

func change_state(newState):
	state = newState
	emit_signal("wave_state_changed")

func _physics_process(delta):
	if global.ingame == true:
		match state:
			CALM: pass
			CONTROL: pass
			ANTICIPATION: pass
			ACTIVE: pass

func waveLoop():
	change_state(ANTICIPATION)
	yield(global.wait(5), "completed")
	change_state(ACTIVE)
	yield(global.wait(15), "completed")
	
	var durations = []
	
	for disaster in disasterHandler.disasterData:
		var dis = disasterHandler.disasterData[disaster]
		if dis.start <= waveNumber:
			dis.active = true
			durations.append(dis.duration)
	
	yield(global.wait(getMax(durations)), "completed")
	
	for disaster in disasterHandler.disasterData:
		disasterHandler.disasterData[disaster].active = false
	
	waveNumber += 1
	waveLoop()

func getMax(array):
	var maxVal = array[0]
	for i in array:
		maxVal = max(i, maxVal)
	return maxVal

