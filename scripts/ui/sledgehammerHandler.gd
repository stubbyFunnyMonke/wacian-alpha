extends ColorRect

onready var playerNode = get_tree().get_current_scene().get_node("YSort/Player")

func _process(_delta):
	var mouse_pos = get_tree().get_current_scene().get_global_mouse_position()
	var selectedTile = playgroundHandler.currentBackgroundNode.world_to_map(mouse_pos)
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	var getPlaceIndicator = get_tree().get_current_scene().get_node("PlaceIndicator")
	
	var success = false
	
	if getPlaceIndicator:
		if "key" in inventory.get_selected():
			if inventory.get_selected().key == "sledgehammer" && currentFloorData && str(selectedTile) in currentFloorData:
				
				if playerNode.position.distance_to(playgroundHandler.currentPlaygroundNode.map_to_world(selectedTile)) < 32 * playerstats.furnitureRange:
					getPlaceIndicator.set_cellv(selectedTile, 0)
				else:
					getPlaceIndicator.set_cellv(selectedTile, 1)
				
				var hammerIcon = load("res://assets/images/cursors/hammercursor.png") #change this to sledgehammer
				Input.set_custom_mouse_cursor(hammerIcon)
				
				success = true
			else:
				success = false
		else:
			success = false
