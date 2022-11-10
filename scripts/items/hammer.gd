extends Node

var soundNode

func use(playerNode):
	var scrapIndex
	var nailIndex
	
	var mouse_pos = playerNode.get_global_mouse_position()
	var selectedTile = playgroundHandler.currentBackgroundNode.world_to_map(mouse_pos)
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	
	for item in inventory.items.size():
		if "name" in inventory.items[item]:
			if inventory.items[item].key == "scrap":
				scrapIndex = item
			elif inventory.items[item].key == "nail":
				nailIndex = item
	
	if playerNode.position.distance_to(playgroundHandler.currentPlaygroundNode.map_to_world(selectedTile)) < 32 * playerstats.furnitureRange:
		if scrapIndex != null && nailIndex != null:
			if str(selectedTile) in currentFloorData:
				if currentFloorData[str(selectedTile)].currentDurability < currentFloorData[str(selectedTile)].maxDurability:
					inventory.set_item_quantity(scrapIndex, -1)
					inventory.set_item_quantity(nailIndex, -1)
				
				playgroundHandler.repair_tile(selectedTile, 50)
				
				soundNode = AudioStreamPlayer2D.new()
				soundNode.stream = load("res://assets/sounds/repair.wav")
				playgroundHandler.currentPlaygroundNode.add_child(soundNode)
				soundNode.position = playerNode.position
				soundNode.bus = "sfx"
				soundNode.play()
				soundNode.connect("finished", self, "sound1Finished")
				
				var cameraNode = playerNode.get_node("Camera2D")
				cameraNode.shake(0.1, 6, 5)
		else:
			var sceneNode = global.get_scene_node()
			var interactionErrorList = sceneNode.get_node("UI/interactionErrorList")
			if interactionErrorList:
				if scrapIndex == null: interactionErrorList.error_msg("you need 1 scrap")
				if nailIndex == null: interactionErrorList.error_msg("you need 1 nail")

func equipped(selectedTile, currentFloorData, getPlaceIndicator, absorptionBar, durabilityBar):
	var playerNode = global.get_scene_node().get_node("YSort/Player")
	
	var success = false
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
	
	return success

func sound1Finished():
	if soundNode:
		soundNode.queue_free()
		soundNode = null
