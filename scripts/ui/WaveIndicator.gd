extends Control

onready var animationPlayer = $AnimationPlayer
onready var WaveText = $WaveText

var old_wave_state = WaveSystem.state

func _ready():
	WaveSystem.connect("wave_state_changed", self, "_on_wave_state_changed")
	match WaveSystem.state:
		WaveSystem.CALM: transition_to_calm()
		WaveSystem.CONTROL: transition_to_control()
		WaveSystem.ANTICIPATION: transition_to_anticipation()
		WaveSystem.ACTIVE: animationPlayer.play("assault")

func _on_wave_state_changed():
	if old_wave_state == WaveSystem.ACTIVE:
		animationPlayer.play("assault end")
	else:
		match WaveSystem.state:
			WaveSystem.CALM: transition_to_calm()
			WaveSystem.CONTROL: transition_to_control()
			WaveSystem.ANTICIPATION: transition_to_anticipation()
			WaveSystem.ACTIVE: transition_to_active()
	old_wave_state = WaveSystem.state

func transition_to_calm():
	animationPlayer.play("normal")

func transition_to_control():
	animationPlayer.play("control")

func transition_to_anticipation():
	animationPlayer.play("anticipation")

func transition_to_active():
	animationPlayer.play("assault intro")

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "assault intro":
		animationPlayer.play("assault")
	if anim_name == "assault end":
		match WaveSystem.state:
			WaveSystem.CALM: transition_to_calm()
			WaveSystem.CONTROL: transition_to_control()
			WaveSystem.ANTICIPATION: transition_to_anticipation()
			WaveSystem.ACTIVE: transition_to_active()

func _physics_process(delta):
	WaveText.text = "Wave "+str(WaveSystem.waveNumber)
