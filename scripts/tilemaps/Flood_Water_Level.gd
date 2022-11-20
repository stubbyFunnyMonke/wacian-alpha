extends TileMap

signal playground_tiles_changed

onready var playground = get_node("/root/Node2D/YSort/Playground")
onready var flood_background = get_node("Background")
onready var border_bg = get_node("BorderBG")
onready var border = get_node("Border")

var waterLevelPercentage

var playground_tiles = []

func _physics_process(delta):
	waterLevelPercentage = float(disasterHandler.waterLevel) / float(disasterHandler.maxWaterLevel)
	
	if waterLevelPercentage > 0.25:
		flood_background.visible = true
	else:
		flood_background.visible = false
	
	for tile in playground.get_used_cells():
		#update tiles n stuff
		if not (str(tile) in playground_tiles):
			playground_tiles.append(str(tile))
			emit_signal("playground_tiles_changed")
		
		if waterLevelPercentage <= 0.25:
			set_cellv(tile, -1)
		elif waterLevelPercentage <= 0.5:
			set_cellv(tile, 2)
		elif waterLevelPercentage <= 0.75:
			set_cellv(tile, 1)
		elif waterLevelPercentage <= 0.85:
			set_cellv(tile, 3)
		elif waterLevelPercentage <= 1:
			set_cellv(tile, 0)
	
	#remove old tiles
	for old_tile in playground_tiles:
		if not str2var("Vector2" + old_tile) in playground.get_used_cells():
			playground_tiles.erase(old_tile)
			set_cellv(str2var("Vector2" + old_tile), -1)
			emit_signal("playground_tiles_changed")
	
	for tile in border_bg.get_used_cells():
		if waterLevelPercentage <= 0.25:
			border_bg.visible = false
		else:
			border_bg.visible = true

		if waterLevelPercentage <= 0.5:
			border_bg.set_cellv(tile, 2)
		elif waterLevelPercentage <= 0.75:
			border_bg.set_cellv(tile, 1)
		elif waterLevelPercentage <= 0.85:
			border_bg.set_cellv(tile, 3)
		elif waterLevelPercentage <= 1:
			border_bg.set_cellv(tile, 0)
	
	for tile in border.get_used_cells():
		if waterLevelPercentage <= 0.25:
			border.visible = false
		else:
			border.visible = true

		if waterLevelPercentage <= 0.5:
			border.set_cellv(tile, 2)
		elif waterLevelPercentage <= 0.75:
			border.set_cellv(tile, 1)
		elif waterLevelPercentage <= 0.85:
			border.set_cellv(tile, 3)
		elif waterLevelPercentage <= 1:
			border.set_cellv(tile, 0)

func _on_WaterLevel_playground_tiles_changed():
	for tile in playground_tiles:
		tile = str2var("Vector2" + tile)
		if waterLevelPercentage <= 0.25:
			set_cellv(tile, -1)
		elif waterLevelPercentage <= 0.5:
			set_cellv(tile, 2)
		elif waterLevelPercentage <= 0.75:
			set_cellv(tile, 1)
		elif waterLevelPercentage <= 0.85:
			set_cellv(tile, 3)
		elif waterLevelPercentage <= 1:
			set_cellv(tile, 0)
