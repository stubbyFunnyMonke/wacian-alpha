extends Node

func use(playerNode):
	#murder the furniture
	
	var mouse_pos = global.get_scene_node().get_global_mouse_position()
	var tile_pos = playgroundHandler.currentPlaygroundNode.world_to_map(mouse_pos)
	var tile_cell_at_mouse_pos = playgroundHandler.currentPlaygroundNode.get_cellv(tile_pos)
	
	if tile_cell_at_mouse_pos != -1 && playerNode.position.distance_to(playgroundHandler.currentPlaygroundNode.map_to_world(tile_pos)) < 32 * playerstats.furnitureRange:
		if tile_cell_at_mouse_pos != 11:
			#tile is NOT an id 11 tile
			
			#store container data and clear empty spaces
			var cellData = playgroundHandler.getFurnitureData(tile_cell_at_mouse_pos)
			var containerData = containerhandler.get_container_data(cellData)
			
			containerhandler.clearEmpty()
			
			var stringStored = str(tile_cell_at_mouse_pos)
			var tilesize = playgroundHandler.tilemapdata[stringStored].tilesize
			
			for x in range(tilesize[0]):
					for y in range(tilesize[1]):
						var checkvector = Vector2(tile_pos.x + x, tile_pos.y + y)
						playgroundHandler.currentPlaygroundNode.set_cellv(checkvector, -1)
		else:
			#tile IS an id 11 tile
			for pos11 in playgroundHandler.tile11data:
				if tile_pos in playgroundHandler.tile11data[pos11].cells:
					var getVector = str2var("Vector2" + pos11)
					var stringStored = str(playgroundHandler.currentPlaygroundNode.get_cellv(getVector))
					var tilesize = playgroundHandler.tilemapdata[stringStored].tilesize
					
					for x in range(tilesize[0]):
							for y in range(tilesize[1]):
								var checkvector = Vector2(getVector.x + x, getVector.y + y)
								playgroundHandler.currentPlaygroundNode.set_cellv(checkvector, -1)
					break
		
		for n in range((randi() % 2) + 1):
			var dropPos = playgroundHandler.currentPlaygroundNode.map_to_world(tile_pos)
			dropPos = Vector2(dropPos.x + randi() % 32, dropPos.y + randi() % 32)
			
			var dropitem = preload("res://scenes/entities/droppeditem.tscn")
			
			var dropitem1 = dropitem.instance()
			dropitem1.setItem(globalItemHandler.get_item_by_key("scrap"))
			dropitem1.setPos(dropPos)
			global.get_scene_node().get_node("YSort/Items").add_child(dropitem1)
			
			var rng = (randi() % 4) + 1
			if rng <= 2:
				var dropPos2 = playgroundHandler.currentPlaygroundNode.map_to_world(tile_pos)
				
				var dropitem2 = preload("res://scenes/entities/droppeditem.tscn")
				
				var dropitem2_2 = dropitem2.instance()
				dropitem2_2.setItem(globalItemHandler.get_item_by_key("nail"))
				dropitem2_2.setPos(dropPos2)
				global.get_scene_node().get_node("YSort/Items").add_child(dropitem2_2)

