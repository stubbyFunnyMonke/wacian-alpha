extends Node

signal on_changed_floor(newfloor)

var floors = ["gfloor.tscn", "floor2.tscn", "rooftop.tscn"]
var currentfloor = 0
var sandboxArea
var player
var landedcell = -1

func _ready():
	reset()

func reset():
	sandboxArea = null
	player = null
	landedcell = -1
	currentfloor = 0

func changeSandboxInstance(sandbox):
	sandboxArea = sandbox

func initializePlayer(playerEntity):
	player = playerEntity
	
	if landedcell != -1:
		var landingcell = getcellwithid(landedcell)
		if landingcell:
			player.position = sandboxArea.map_to_world(landingcell) + Vector2(16, 16)
			landedcell = -1
			
	emit_signal("on_changed_floor", floors[currentfloor])
	
	#switch ambience muffling thingy
	var ambienceBusIndex = AudioServer.get_bus_index("ambience")
	
	if floors[currentfloor] != "rooftop.tscn":
		AudioServer.set_bus_effect_enabled(ambienceBusIndex, 0, true)
	else:
		AudioServer.set_bus_effect_enabled(ambienceBusIndex, 0, false)

func getcellwithid(id):
	if sandboxArea:
		var usedcells = sandboxArea.get_used_cells()
		var targetcell
		
		for cellpos in usedcells:
			var cell = sandboxArea.get_cellv(cellpos)
			if cell == id:
				targetcell = cellpos
				break
		
		if targetcell:
			return targetcell

func _physics_process(_delta):
	if global.ingame == true:
		if sandboxArea && player:
			var tile_pos = sandboxArea.world_to_map(player.position)
			var tile_cell_at_mouse_pos = sandboxArea.get_cellv(tile_pos)
			var success = false
			if tile_cell_at_mouse_pos == 2:
				if currentfloor + 1 != floors.size():
					currentfloor += 1
					get_tree().change_scene("res://scenes/levels/" + floors[currentfloor])
					
					landedcell = 5
					success = true
			elif tile_cell_at_mouse_pos == 4:
				if not currentfloor -1 < 0:
					currentfloor -= 1
					get_tree().change_scene("res://scenes/levels/" + floors[currentfloor])
					
					landedcell = 3
					success = true
			
			if success:
				playgroundHandler.saveItems()
				playgroundHandler.savePlayground()
				playgroundHandler.saveFireTiles()
				
				yield(get_tree(), "idle_frame")
				
