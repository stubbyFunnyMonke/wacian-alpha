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
	print(newState)
	emit_signal("wave_state_changed")

func _physics_process(delta):
	if global.ingame == true:
		match state:
			CALM: pass
			CONTROL: pass
			ANTICIPATION: pass
			ACTIVE: pass

func waveLoop():
	if global.ingame == true:
		change_state(ANTICIPATION)
		
		#wait 1
		var t = Timer.new()
		t.set_wait_time(30)
		t.set_one_shot(true)
		self.add_child(t)
		t.start()
		yield(t, "timeout")
		
		change_state(ACTIVE)
		
		#wait 2
		t.set_wait_time(15)
		t.set_one_shot(true)
		t.start()
		yield(t, "timeout")
		
		var durations = []
		
		for disaster in disasterHandler.disasterData:
			var dis = disasterHandler.disasterData[disaster]
			if dis.start <= waveNumber:
				print(dis)
				dis.active = true
				durations.append(dis.duration)
		
		print(getMax(durations))
		
		#wait 3
		t.set_wait_time(getMax(durations))
		t.set_one_shot(true)
		t.start()
		yield(t, "timeout")
		t.queue_free()
		
		for disaster in disasterHandler.disasterData:
			disasterHandler.disasterData[disaster].active = false
		
		waveNumber += 1
		waveLoop()

func getMax(array):
	var maxVal = array[0]
	for i in array:
		maxVal = max(i, maxVal)
	return maxVal

