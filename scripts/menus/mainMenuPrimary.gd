extends Node2D

const introSequence = [
	"intropart1",
	"intropart2",
	"end"
]

onready var animPlayer1 = get_node("IntroAnims1")
onready var mainmenumusic = $mainMenu/AudioStreamPlayer

func _unhandled_input(event):
	if event is InputEventKey and event.pressed:
		if animPlayer1.is_playing() && animPlayer1.current_animation != "startgame":
			play_next_anim(animPlayer1.current_animation)

func _on_IntroAnims1_animation_finished(anim_name):
	if anim_name != "startgame":
		play_next_anim(anim_name)

func play_next_anim(anim_name):
	var currentIndex = introSequence.find(anim_name)
	animPlayer1.stop()
	if range(introSequence.size()).has(currentIndex + 1):
		animPlayer1.play("RESET")
		yield(get_tree(), "idle_frame")
		animPlayer1.play(introSequence[currentIndex + 1])

func _on_AudioStreamPlayer_finished():
	if animPlayer1.is_playing() && animPlayer1.current_animation == "startgame":
		return
	mainmenumusic.play()
