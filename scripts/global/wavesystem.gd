extends Node

signal wave_state_changed

var state = CALM
var waveNumber = 1
var waveInstances = {
	
}

enum {
	CALM,
	CONTROL,
	ANTICIPATION,
	ACTIVE,
}

func reset():
	var newWaveID = global.gen_unique_string(8)
	var newWaveInstance = {
		"id": newWaveID,
		"active": true
	}
	
	waveInstances[newWaveID] = newWaveInstance
	
	waveNumber = 1
	change_state(CALM)
	
	waveLoop(newWaveInstance.id)

func end():
	for waveInstance in waveInstances:
		waveInstances[waveInstance].active = false

func change_state(newState):
	state = newState
	print(newState)
	emit_signal("wave_state_changed")

func _physics_process(delta):
	if global.ingame == true:
		match state:
			CALM: pass
			CONTROL: pass
			ANTICIPATION: pass
			ACTIVE: pass

#definitely a suboptimal way of doing this
func waveLoop(waveID):
	if waveInstances[waveID].active == true:
		change_state(ANTICIPATION)
		
		#############GAME CHECKS###############
		if waveInstances[waveID].active == false:
			return
		#############GAME CHECKS###############
		
		#wait 1
		var t = Timer.new()
		t.set_wait_time(30) #30 second prep time
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		
		#############GAME CHECKS###############
		if waveInstances[waveID].active == false:
			return
		#############GAME CHECKS###############
		
		change_state(ACTIVE)
		
		#############GAME CHECKS###############
		if waveInstances[waveID].active == false:
			return
		#############GAME CHECKS###############
		
		#wait 2
		t.set_wait_time(15) #beat drop
		t.set_one_shot(true)
		t.start()
		yield(t, "timeout")
		
		#############GAME CHECKS###############
		if waveInstances[waveID].active == false:
			return
		#############GAME CHECKS###############
		
		var durations = []
		
		for disaster in disasterHandler.disasterData:
			var dis = disasterHandler.disasterData[disaster]
			if dis.start <= waveNumber:
				print(dis)
				dis.active = true
				durations.append(dis.duration)
		
		print(getMax(durations))
		
		#############GAME CHECKS###############
		if waveInstances[waveID].active == false:
			return
		#############GAME CHECKS###############
		
		#wait 3
		t.set_wait_time(getMax(durations))
		t.set_one_shot(true)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		#############GAME CHECKS###############
		if waveInstances[waveID].active == false:
			return
		#############GAME CHECKS###############
		
		for disaster in disasterHandler.disasterData:
			disasterHandler.disasterData[disaster].active = false
		
		waveNumber += 1
		waveLoop(waveID)

func getMax(array):
	var maxVal = array[0]
	for i in array:
		maxVal = max(i, maxVal)
	return maxVal

