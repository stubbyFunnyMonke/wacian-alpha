extends AnimatedSprite

var floodTiles
var floodBG
var flood_border_bg

func _physics_process(delta):
	if changefloor.floors[changefloor.currentfloor] == "gfloor.tscn":
		#expect the flood thing to be here
		
		floodTiles = get_node_or_null("/root/Node2D/YSort/WaterLevel")
		if floodTiles != null:
			floodBG = floodTiles.get_node_or_null("Background")
			flood_border_bg = floodTiles.get_node_or_null("BorderBG")
		
		var waterLevelPercentage = float(disasterHandler.waterLevel) / float(disasterHandler.maxWaterLevel)
		if floodBG != null && flood_border_bg != null:
			if floodBG.get_cellv(floodBG.world_to_map(get_parent().position)) != -1 or flood_border_bg.get_cellv(flood_border_bg.world_to_map(get_parent().position)) != -1:
				var cancel = false
				
				if flood_border_bg.get_cellv(flood_border_bg.world_to_map(get_parent().position)) != -1:
					if get_parent().position.y < (flood_border_bg.map_to_world(flood_border_bg.world_to_map(get_parent().position)).y + 16):
						cancel = true
				
				if cancel == false:
					visible = true
					if waterLevelPercentage <= 0.25:
						frame = 0
					elif waterLevelPercentage <= 0.5:
						frame = 1
					elif waterLevelPercentage <= 0.75:
						frame = 2
					elif waterLevelPercentage <= 0.85:
						frame = 3
					elif waterLevelPercentage <= 1:
						frame = 4
				else:
					visible = false
			else:
				visible = false
	else:
		visible = false
