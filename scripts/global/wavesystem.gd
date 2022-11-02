extends Node

signal wave_state_changed

var state = CALM

enum {
	CALM,
	CONTROL,
	ANTICIPATION,
	ACTIVE,
}

func _physics_process(delta): #renderstepped :flushed:
	match state:
		CALM: pass
		CONTROL: pass
		ANTICIPATION: pass
		ACTIVE: pass

func change_state(newState):
	state = newState
	emit_signal("wave_state_changed")

#debug purposes
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_wave_state_active"):
		state = ACTIVE
		emit_signal("wave_state_changed")
	elif event.is_action_pressed("debug_wave_state_calm"):
		state = CALM
		emit_signal("wave_state_changed")
	elif event.is_action_pressed("debug_wave_state_control"):
		state = CONTROL
		emit_signal("wave_state_changed")
	elif event.is_action_pressed("debug_wave_state_anticipate"):
		state = ANTICIPATION
		emit_signal("wave_state_changed")
