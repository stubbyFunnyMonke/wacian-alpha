extends ScrollContainer

onready var particles = $VBoxContainer/Particles/ParticlesButton

func _physics_process(delta):
	particles.pressed = global.particles

func _on_CheckButton_toggled(button_pressed):
	global.particles = button_pressed
