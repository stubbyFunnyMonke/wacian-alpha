extends Node

func use(playerNode):
	var scrapIndex
	var nailIndex
	
	for item in inventory.items.size():
		if "name" in inventory.items[item]:
			if inventory.items[item].key == "scrap":
				scrapIndex = item
			elif inventory.items[item].key == "nail":
				nailIndex = item
	
	if scrapIndex != null && nailIndex != null:
		var mouse_pos = playerNode.get_global_mouse_position()
		var selectedTile = playgroundHandler.currentBackgroundNode.world_to_map(mouse_pos)
		var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
		
		playgroundHandler.repair_tile(selectedTile, 50)
		
		inventory.set_item_quantity(scrapIndex, -1)
		inventory.set_item_quantity(nailIndex, -1)
	else:
		var sceneNode = global.get_scene_node()
		var interactionErrorList = sceneNode.get_node("UI/interactionErrorList")
		if interactionErrorList:
			if scrapIndex == null: interactionErrorList.error_msg("you need 1 scrap")
			if nailIndex == null: interactionErrorList.error_msg("you need 1 nail")
