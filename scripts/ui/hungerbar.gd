extends ProgressBar

var currentstate = "normal"

onready var animPlayer = $AnimationPlayer

func _ready():
	playerstats.connect("player_stats_changed", self, "_on_stats_changed")
	_on_stats_changed()

func _physics_process(_delta):
	self.value = playerstats.currentHunger
	self.max_value = playerstats.maxHunger

func _on_stats_changed():
	if float(playerstats.currentHunger)/float(playerstats.maxHunger) <= 0.1 && currentstate == "normal":
		animPlayer.play("low")
		currentstate = "low"
	elif currentstate == "low" && float(playerstats.currentHunger)/float(playerstats.maxHunger) > 0.1:
		animPlayer.play("normal")
		currentstate = "normal"
