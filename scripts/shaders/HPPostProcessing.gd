extends WorldEnvironment

func _physics_process(delta):
	var hppercentage = float(playerstats.currentHp)/float(playerstats.maxHp)
	environment.set_dof_blur_near_amount(0.15 - (0.15 * hppercentage) - 0.02)
	
	var sustenencepercentage = (float(playerstats.currentHunger) + float(playerstats.currentThirst))/(float(playerstats.maxHunger) + float(playerstats.maxThirst))
	environment.set_adjustment_saturation(sustenencepercentage)
