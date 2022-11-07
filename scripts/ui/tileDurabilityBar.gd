extends ColorRect

onready var durabilityBar = $tileDurabilityBar

func _ready():
	rect_size = durabilityBar.rect_size

func _process(_delta):
	rect_position = get_global_mouse_position() + Vector2.ONE * 4
	
	var mouse_pos = get_tree().get_current_scene().get_global_mouse_position()
	var selectedTile = playgroundHandler.currentBackgroundNode.world_to_map(mouse_pos)
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	if "key" in inventory.get_selected():
		if inventory.get_selected().key == "hammer" && currentFloorData && str(selectedTile) in currentFloorData:
			var tileData = currentFloorData[str(selectedTile)]
			if tileData: durabilityBar.value = (tileData.currentDurability / tileData.maxDurability) * 100
			visible = true
		else:
			visible = false
	else:
		visible = false
