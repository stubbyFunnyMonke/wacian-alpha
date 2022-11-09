extends ColorRect

onready var durabilityBar = $tileDurabilityBar
onready var absorptionBar = $tileDurabilityBar/absorptionBar
onready var playerNode = get_tree().get_current_scene().get_node("YSort/Player")

func _ready():
	rect_size = durabilityBar.rect_size

func _process(_delta):
	rect_position = get_global_mouse_position() + Vector2.ONE * 4
	
	var mouse_pos = get_tree().get_current_scene().get_global_mouse_position()
	var selectedTile = playgroundHandler.currentBackgroundNode.world_to_map(mouse_pos)
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	var getPlaceIndicator = get_tree().get_current_scene().get_node("PlaceIndicator")
	
	var success = false
	
	if getPlaceIndicator:
		if "key" in inventory.get_selected():
			if inventory.get_selected().key == "hammer" && currentFloorData && str(selectedTile) in currentFloorData:
				var tileData = currentFloorData[str(selectedTile)]
				if tileData: 
					var absorptionValue = tileData.currentDurability - tileData.maxDurability 
					absorptionBar.value = (float(absorptionValue) / float(tileData.maxDurability)) * 100
					durabilityBar.value = (float(tileData.currentDurability) / float(tileData.maxDurability)) * 100
				
				if playerNode.position.distance_to(playgroundHandler.currentPlaygroundNode.map_to_world(selectedTile)) < 32 * playerstats.furnitureRange:
					getPlaceIndicator.set_cellv(selectedTile, 0)
				else:
					getPlaceIndicator.set_cellv(selectedTile, 1)
				
				var hammerIcon = load("res://assets/images/cursors/hammercursor.png")
				Input.set_custom_mouse_cursor(hammerIcon)
				
				success = true
			else:
				success = false
		else:
			success = false
	
	visible = success
	if not "customcursor" in inventory.get_selected():
		Input.set_custom_mouse_cursor(null)
