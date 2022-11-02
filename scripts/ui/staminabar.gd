extends ProgressBar

var currentstate = "normal"

onready var animPlayer = $AnimationPlayer

func _physics_process(_delta):
	self.value = playerstats.currentStamina
	self.max_value = playerstats.maxStamina
	
	if playerstats.sprintlockout == true && currentstate == "normal":
		animPlayer.play("low")
		currentstate = "low"
	elif currentstate == "low" && playerstats.sprintlockout == false:
		animPlayer.play("normal")
		currentstate = "normal"
