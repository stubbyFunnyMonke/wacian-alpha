extends Node

signal wave_state_changed

var state = CALM

enum {
	CALM,
	CONTROL,
	ANTICIPATION,
	ACTIVE,
}

func reset():
	change_state(CALM)

func change_state(newState):
	state = newState
	emit_signal("wave_state_changed")

func _physics_process(delta):
	match state:
		CALM: pass
		CONTROL: pass
		ANTICIPATION: pass
		ACTIVE: pass
