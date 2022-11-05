extends Node

signal on_changed_floor(newfloor)

var floors = ["gfloor.tscn", "floor2.tscn"]
var currentfloor = 0
var sandboxArea
var player
var landedcell = -1

func changeSandboxInstance(sandbox):
	sandboxArea = sandbox

func initializePlayer(playerEntity):
	player = playerEntity
	
	if landedcell != -1:
		var landingcell = getcellwithid(landedcell)
		if landingcell:
			player.position = sandboxArea.map_to_world(landingcell)
			landedcell = -1
			
	emit_signal("on_changed_floor", floors[currentfloor])

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