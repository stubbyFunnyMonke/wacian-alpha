extends Timer

const defaultTime = 0.2

func _physics_process(delta):
	wait_time = defaultTime/playerstats.player_get_speed()
