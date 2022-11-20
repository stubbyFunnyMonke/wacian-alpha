extends Control

onready var QuitContainer = get_node("/root/MainMenuBG/mainMenu/QuitContainer")
onready var introAnims = get_node("/root/MainMenuBG/IntroAnims1")
onready var mainmenumusic = get_node("/root/MainMenuBG/mainMenu/AudioStreamPlayer")
onready var clickSFX = get_node("/root/MainMenuBG/mainMenu/clickSFX")

func _ready():
	for i in get_all_children(get_node("/root/MainMenuBG/mainMenu")):
		if i.get_class() == "Button":
			i.connect("pressed", self, "clickSFX")
	rect_size = Vector2(1024, 600)

func get_all_children(in_node,arr:=[]):
	arr.push_back(in_node)
	for child in in_node.get_children():
		arr = get_all_children(child,arr)
	return arr

func _on_PlayBtn_pressed():
	introAnims.play("startgame")
	mainmenumusic.stop()

func _on_QuitBtn_pressed():
	self.visible = false
	QuitContainer.visible = true

func _on_BackBtn2_pressed():
	self.visible = true
	QuitContainer.visible = false

func _on_ConfirmQuitBtn2_pressed():
	get_tree().quit()

func _on_IntroAnims1_animation_finished(anim_name):
	if anim_name == "startgame":
		global.reset_game()

func clickSFX():
	clickSFX.play()
