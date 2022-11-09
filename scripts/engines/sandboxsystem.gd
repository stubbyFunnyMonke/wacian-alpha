extends TileMap

export (PackedScene) var placeFurniture

onready var sandboxMap = get_node("/root/Node2D/SandboxArea")
onready var placeIndicator = get_node("/root/Node2D/PlaceIndicator")

onready var containermenu = get_node("/root/Node2D/UI/ContainerMenu")

onready var playerNode = get_node("/root/Node2D/YSort/Player")

onready var place = $place

func _ready():
	#load in tile id 11 (prevent placing other stuff there)
	var allRoomCells = get_used_cells()
	
	for cellpos in allRoomCells:
		var tile_cell_at_pos = self.get_cellv(cellpos)
		var tile_cell_as_str = str(tile_cell_at_pos)
		if tile_cell_as_str in playgroundHandler.tilemapdata:
			var tilesize = playgroundHandler.tilemapdata[tile_cell_as_str].tilesize
			if tilesize:
				for x in range(tilesize[0]):
						for y in range(tilesize[1]):
							var checkvector = Vector2(cellpos.x + x, cellpos.y + y)
							if checkvector != cellpos:
								set_cellv(checkvector, 11)
								
								var foundtilecell = false
								
								for pos11 in playgroundHandler.tile11data:
									if pos11 == str(cellpos):
										foundtilecell = true
										break
								
								if foundtilecell == false:
									var newtile11data = {
										"name": cellpos,
										"cells": []
									}
									playgroundHandler.tile11data[str(cellpos)] = newtile11data
								
								playgroundHandler.tile11data[str(cellpos)].cells.append(checkvector)

func _physics_process(_delta):
	placeIndicator.clear()
	if playgroundHandler.storedItem != -1:
		var mouse_pos = get_global_mouse_position()
		var tile_pos = world_to_map(mouse_pos)
		
		var stringStored = str(playgroundHandler.storedItem)
		var tilesize = playgroundHandler.tilemapdata[stringStored].tilesize
		for x in range(tilesize[0]):
			for y in range(tilesize[1]):
				var checkvector = Vector2(tile_pos.x + x, tile_pos.y + y)
				if get_cellv(checkvector) == -1 && sandboxMap.get_cellv(checkvector) == 1 && playerNode.position.distance_to(map_to_world(tile_pos)) < 32 * playerstats.furnitureRange:
					placeIndicator.set_cellv(checkvector, 0)
				else:
					placeIndicator.set_cellv(checkvector, 1)

func _unhandled_input(event: InputEvent) -> void:
	var mouse_pos = get_global_mouse_position()
	var tile_pos = world_to_map(mouse_pos)
	var tile_cell_at_mouse_pos = self.get_cellv(tile_pos)
	var valid_cell_at_mouse_pos = sandboxMap.get_cellv(tile_pos)
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	
	if containermenu.visible:
		return
	
	if event.is_action_pressed("lclick"):
		if tile_cell_at_mouse_pos != -1:
			#check if the tile has some furniture
			
			if playgroundHandler.storedItem == -1 && valid_cell_at_mouse_pos == 1 && playerNode.position.distance_to(map_to_world(tile_pos)) < 32 * playerstats.furnitureRange:
				#check if the player has stored furniture in inventory and prevents if it they do
				
				#time for some crazy data stuff
				
				if tile_cell_at_mouse_pos != 11:
					#tile is NOT an id 11 tile
					
					#store container data and clear empty spaces
					var cellData = playgroundHandler.getFurnitureData(tile_cell_at_mouse_pos)
					var containerData = containerhandler.get_container_data(cellData)
					if containerData:
						containerhandler.carriedcontaineritems = containerhandler.containers[currentfloor][str(tile_pos)]
					
					containerhandler.clearEmpty()
					
					var stringStored = str(tile_cell_at_mouse_pos)
					var tilesize = playgroundHandler.tilemapdata[stringStored].tilesize
					
					for x in range(tilesize[0]):
							for y in range(tilesize[1]):
								var checkvector = Vector2(tile_pos.x + x, tile_pos.y + y)
								set_cellv(checkvector, -1)
					
					playgroundHandler.storedItem = tile_cell_at_mouse_pos
				else:
					#tile IS an id 11 tile
					for pos11 in playgroundHandler.tile11data:
						if tile_pos in playgroundHandler.tile11data[pos11].cells:
							var getVector = str2var("Vector2" + pos11)
							var stringStored = str(get_cellv(getVector))
							var tilesize = playgroundHandler.tilemapdata[stringStored].tilesize
							
							playgroundHandler.storedItem = get_cellv(getVector)
							
							for x in range(tilesize[0]):
									for y in range(tilesize[1]):
										var checkvector = Vector2(getVector.x + x, getVector.y + y)
										set_cellv(checkvector, -1)
							break
		else:
			#the tile has no furniture, put down if have something in inventory
			if playgroundHandler.storedItem != -1 && valid_cell_at_mouse_pos == 1 && playerNode.position.distance_to(map_to_world(tile_pos)) < 32 * playerstats.furnitureRange:
				
				#check if adjacent blocks are taken/can be put on
				var stringStored = str(playgroundHandler.storedItem)
				var tilesize = playgroundHandler.tilemapdata[stringStored].tilesize
				
				var cancel = false
				
				for x in range(tilesize[0]):
					for y in range(tilesize[1]):
						var checkvector = Vector2(tile_pos.x + x, tile_pos.y + y)
						
						if get_cellv(checkvector) != -1:
							#slot taken
							cancel = true
						if sandboxMap.get_cellv(checkvector) != 1:
							#not a valid spot
							cancel = true
				
				if cancel == false:
					for x in range(tilesize[0]):
						for y in range(tilesize[1]):
							var checkvector = Vector2(tile_pos.x + x, tile_pos.y + y)
							if checkvector != tile_pos:
								set_cellv(checkvector, 11)
								
								var foundtilecell = false
								
								for pos11 in playgroundHandler.tile11data:
									if pos11 == str(tile_pos):
										foundtilecell = true
										break
								
								if foundtilecell == false:
									var newtile11data = {
										"name": tile_pos,
										"cells": []
									}
									playgroundHandler.tile11data[str(tile_pos)] = newtile11data
								
								playgroundHandler.tile11data[str(tile_pos)].cells.append(checkvector)
								
					#set container data
					var cellData = playgroundHandler.getFurnitureData(playgroundHandler.storedItem)
					var containerData = containerhandler.get_container_data(cellData)
					if containerData:
						containerhandler.addNew(tile_pos)
					
					var thudparticles = placeFurniture.instance()
					thudparticles.position.x = map_to_world(tile_pos).x + (16 * tilesize[0])
					thudparticles.position.y = map_to_world(tile_pos).y + 32
					thudparticles.process_material.emission_box_extents = Vector3(135 * tilesize[0], 1, 1)
					add_child(thudparticles)
					
					set_cell(tile_pos.x, tile_pos.y, playgroundHandler.storedItem)
					place.position = mouse_pos
					place.play()
					playgroundHandler.storedItem = -1
	
	if event.is_action_pressed("rotate"):
		if playgroundHandler.storedItem != -1:
			
			var foundfurniture
			
			for furn in playgroundHandler.furnituredata:
				if playgroundHandler.furnituredata[furn].maintile == playgroundHandler.storedItem:
					foundfurniture = playgroundHandler.furnituredata[furn]
					break
				if playgroundHandler.storedItem in playgroundHandler.furnituredata[furn].tiles:
					foundfurniture = playgroundHandler.furnituredata[furn]
					break
			
			if foundfurniture.rotatable == true:
				#fancy math stuff for rotating the furniture
				var index = foundfurniture.tiles.find(playgroundHandler.storedItem, 0)
				
				if (index + 1) >= foundfurniture.tiles.size():
					playgroundHandler.storedItem = foundfurniture.tiles[0]
				else:
					playgroundHandler.storedItem = foundfurniture.tiles[index + 1]
	
	if event.is_action_pressed("rclick"):
		if tile_cell_at_mouse_pos != -1:
			#tile has furniture
			if playgroundHandler.storedItem == -1:
				if tile_cell_at_mouse_pos != 11:
					var cellData = playgroundHandler.getFurnitureData(tile_cell_at_mouse_pos)
					if cellData.actionable == true:
						var scriptname = cellData.furniture_name + ".gd"
						var actions = load("res://scripts/furniture/%s" % scriptname).new()
						actions.use(tile_pos)
