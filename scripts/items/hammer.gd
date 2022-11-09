extends Node

func use(playerNode):
	var mouse_pos = playerNode.get_global_mouse_position()
	var selectedTile = playgroundHandler.currentBackgroundNode.world_to_map(mouse_pos)
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	
	playgroundHandler.deteriorate_tile(selectedTile, 50)
