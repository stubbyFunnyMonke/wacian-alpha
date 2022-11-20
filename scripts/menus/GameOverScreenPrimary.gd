extends Node2D

const introSequence = [
	"on_ready",
	"play_music",
	"introduce_menu",
]

onready var animPlayer1 = get_node("CutsceneController")

func _ready():
	animPlayer1.play("on_ready")

func _on_CutsceneController_animation_finished(anim_name):
	if anim_name != "fade_out":
		play_next_anim(anim_name)

func play_next_anim(anim_name):
	var currentIndex = introSequence.find(anim_name)
	animPlayer1.stop()
	if range(introSequence.size()).has(currentIndex + 1):
		animPlayer1.play("RESET")
		yield(get_tree(), "idle_frame")
		animPlayer1.play(introSequence[currentIndex + 1])
