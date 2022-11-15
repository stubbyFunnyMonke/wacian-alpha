extends Node

#wave states:
#0: calm
#1: control
#2: anticipation
#3: active

onready var loopNode = $loop
onready var introNode = $intro
onready var outroNode = $end
onready var tween = $Tween

var old_wave_state = WaveSystem.CALM

func _ready():
	WaveSystem.connect("wave_state_changed", self, "_on_wave_state_changed")
	introNode.connect("finished", self, "_intro_ended")
	loopNode.connect("finished", self, "_loop_ended")

func reset():
	introNode.stop()
	loopNode.stop()

func _on_wave_state_changed():
	match WaveSystem.state:
		WaveSystem.CALM: transition_to_calm()
		WaveSystem.CONTROL: transition_to_control()
		WaveSystem.ANTICIPATION: transition_to_anticipation()
		WaveSystem.ACTIVE: transition_to_active()
	old_wave_state = WaveSystem.state

func _intro_ended():
	if global.ingame == true:
		match WaveSystem.state:
			WaveSystem.CALM: pass
			WaveSystem.CONTROL: transition_to_control_2()
			WaveSystem.ANTICIPATION: transition_to_anticipation_2()
			WaveSystem.ACTIVE: transition_to_active_2()

func _loop_ended():
	if global.ingame == true:
		loopNode.play()

func transition_to_calm():
	if old_wave_state == WaveSystem.ACTIVE:
		outroNode.stop()
		outroNode.stream = preload("res://assets/music/welcome to ohio/assault end.wav")
		outroNode.play()
	loopNode.stop()
	loopNode.stream = preload("res://assets/music/welcome to ohio/stealth loop.wav")
	loopNode.play()

func transition_to_control():
	if old_wave_state == WaveSystem.ACTIVE:
		outroNode.stop()
		outroNode.stream = preload("res://assets/music/welcome to ohio/assault end.wav")
		outroNode.play()
		transition_to_control_2()
	else:
		introNode.stop()
		introNode.stream = preload("res://assets/music/welcome to ohio/control intro.wav")
		introNode.play()

func transition_to_control_2():
	loopNode.stop()
	loopNode.stream = preload("res://assets/music/welcome to ohio/control loop.wav")
	loopNode.play()

func transition_to_anticipation():
	if old_wave_state == WaveSystem.ACTIVE:
		outroNode.stop()
		outroNode.stream = preload("res://assets/music/welcome to ohio/assault end.wav")
		outroNode.play()
		transition_to_anticipation_2()
	else:
		introNode.stop()
		introNode.stream = preload("res://assets/music/welcome to ohio/anticipation intro.wav")
		introNode.play()

func transition_to_anticipation_2():
	loopNode.stop()
	loopNode.stream = preload("res://assets/music/welcome to ohio/anticipation.wav")
	loopNode.play()
	loopNode.connect("finished", self, "start_anticipation_loop")

func start_anticipation_loop():
	loopNode.disconnect("finished", self, "start_anticipation_loop")
	loopNode.stop()
	loopNode.stream = preload("res://assets/music/welcome to ohio/anticipation loop.wav")
	loopNode.play()

func transition_to_active():
	introNode.stop()
	introNode.stream = preload("res://assets/music/welcome to ohio/assault intro.wav")
	introNode.play()
	
	var eqEffect = AudioServer.get_bus_effect(3, 0)
	tween.interpolate_property(eqEffect, "band_db/10000_hz",
	0, -60, introNode.stream.get_length() * 1,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(eqEffect, "band_db/3200_hz",
	0, -60, introNode.stream.get_length() * 1,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(eqEffect, "band_db/1000_hz",
	0, -60, introNode.stream.get_length() * 1,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(eqEffect, "band_db/320_hz",
	0, -60, introNode.stream.get_length() * 1.2,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(eqEffect, "band_db/100_hz",
	0, -60, introNode.stream.get_length() * 1.4,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(eqEffect, "band_db/32_hz",
	0, -60, introNode.stream.get_length() * 1.6,
	Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

func transition_to_active_2():
	tween.stop_all()
	
	var eqEffect = AudioServer.get_bus_effect(3, 0)
	eqEffect.set_band_gain_db(5, 0)
	eqEffect.set_band_gain_db(4, 0)
	eqEffect.set_band_gain_db(3, 0)
	eqEffect.set_band_gain_db(2, 0)
	eqEffect.set_band_gain_db(1, 0)
	
	loopNode.stop()
	loopNode.stream = preload("res://assets/music/welcome to ohio/assault loop.wav")
	loopNode.play()

