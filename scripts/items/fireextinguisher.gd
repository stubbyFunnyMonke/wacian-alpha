extends Node

var soundNode

func use(playerNode):
	#murder the furniture
	var fireTiles = global.get_scene_node().get_node("YSort/Fire")
	
	var mouse_pos = playerNode.get_global_mouse_position()
	var selectedTile = fireTiles.world_to_map(mouse_pos)
	
	if fireTiles.get_cellv(selectedTile) != -1:
		if playerNode.position.distance_to(playgroundHandler.currentPlaygroundNode.map_to_world(selectedTile)) < 32 * playerstats.furnitureRange:
			var extinguishParticles = preload("res://scenes/particles/extinguishParticles.tscn")
			var extinguishing = extinguishParticles.instance()
			extinguishing.position = fireTiles.get_node(str(selectedTile)).position + Vector2(16, 16)
			extinguishing.emitting = true
			global.get_scene_node().get_node("YSort").add_child(extinguishing)
			
			soundNode = AudioStreamPlayer2D.new()
			soundNode.stream = load("res://assets/sounds/disasters/fire_extinguish.wav")
			playgroundHandler.currentPlaygroundNode.add_child(soundNode)
			soundNode.position = fireTiles.map_to_world(selectedTile) + Vector2(16, 16)
			soundNode.bus = "sfx"
			soundNode.play()
			soundNode.connect("finished", self, "sound1Finished")
			
			fireTiles.set_cellv(selectedTile, -1)

func equipped(selectedTile, currentFloorData, getPlaceIndicator, absorptionBar, durabilityBar):
	var playerNode = global.get_scene_node().get_node("YSort/Player")
	
	var success = false
	if "key" in inventory.get_selected():
		if inventory.get_selected().key == "fireextinguisher" && currentFloorData && str(selectedTile) in currentFloorData:
			
			if playerNode.position.distance_to(playgroundHandler.currentPlaygroundNode.map_to_world(selectedTile)) < 32 * playerstats.furnitureRange:
				getPlaceIndicator.set_cellv(selectedTile, 0)
			else:
				getPlaceIndicator.set_cellv(selectedTile, 1)
			
			var feIcon = load("res://assets/images/cursors/fireextinguishercursor.png") #change this to sledgehammer
			Input.set_custom_mouse_cursor(feIcon)
			
			success = true
		else:
			success = false
	else:
		success = false
	return false

func sound1Finished():
	if soundNode:
		soundNode.queue_free()
		soundNode = null
