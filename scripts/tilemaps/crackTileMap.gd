extends TileMap

func _ready():
	pass # Replace with function body.

func update_tile(tile_pos):
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	
	if str(tile_pos) in currentFloorData:
		var tileInfo = currentFloorData[str(tile_pos)]
		var currentDur = tileInfo.currentDurability
		var maxDur = tileInfo.maxDurability
		
		if currentDur < maxDur/4:
			set_cellv(tile_pos, 2)
		elif currentDur < maxDur/2:
			set_cellv(tile_pos, 3)
		elif currentDur < 3*maxDur/4:
			set_cellv(tile_pos, 1)
		elif currentDur < maxDur - 5:
			set_cellv(tile_pos, 0)
		elif currentDur >= maxDur - 5:
			set_cellv(tile_pos, -1)
		
		update_bitmask_area(tile_pos)

func _physics_process(delta):
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	for tile in currentFloorData:
		update_tile(str2var("Vector2" + tile))
