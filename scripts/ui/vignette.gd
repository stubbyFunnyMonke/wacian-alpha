extends ColorRect

var shader_value = material.get_shader_param("color")

func _physics_process(delta):
	var hppercentage = float(playerstats.currentHp)/float(playerstats.maxHp)
	material.set_shader_param("color", Color(1 - hppercentage, 0, 0, 1))
