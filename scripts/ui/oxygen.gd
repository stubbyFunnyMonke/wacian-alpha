extends ProgressBar

var currentstate = "normal"

func _ready():
	playerstats.connect("player_stats_changed", self, "_on_stats_changed")

func _physics_process(_delta):
	self.value = playerstats.currentOxygen
	self.max_value = playerstats.maxOxygen
	
	if playerstats.currentOxygen >= playerstats.maxOxygen:
		self.visible = false
	else:
		self.visible = true
