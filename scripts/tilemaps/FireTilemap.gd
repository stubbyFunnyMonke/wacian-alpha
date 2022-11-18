extends TileMap

signal fire_tiles_changed

onready var fireSpreadable = get_node("FireSpreadable")

var tiles = []

func _ready():
	for tile in get_used_cells():
		tiles.append(str(tile))
	emit_signal("fire_tiles_changed")

func _physics_process(delta):
	#handle fire tiles
	for tile in get_used_cells():
		if not (str(tile) in tiles):
			tiles.append(str(tile))
			emit_signal("fire_tiles_changed")
		else:
			#fire decay
			var decayRNG = (randi() % 2500/disasterHandler.intensity) + 1
			if decayRNG == 1:
				#decay for non flammable surfaces
				if fireSpreadable.get_cellv(tile) == -1:
					set_cellv(tile, -1)
				else:
					#decay for flammable surfaces
					var decayRNG2 = (randi() % 10000/disasterHandler.intensity) + 1
					if decayRNG2 == 1:
						set_cellv(tile, -1)
		
		#spread fire
		var rng = (randi() % 100/disasterHandler.intensity) + 1
		if rng == 1:
			var spreadPos = Vector2(tile.x + (randi() % 3) - 1, tile.y + (randi() % 3) - 1)
			if fireSpreadable.get_cellv(spreadPos) != -1:
				set_cellv(spreadPos, 0)
	
	#burn player
	var playerNode = global.get_scene_node().get_node("YSort/Player")
	if get_cellv(world_to_map(playerNode.position)) != -1 && playerstats.onfire == false:
		playerstats.player_set_on_fire(4)
	
	#remove old tiles
	for old_tile in tiles:
		if not str2var("Vector2" + old_tile) in get_used_cells():
			tiles.erase(old_tile)
			emit_signal("fire_tiles_changed")

func _on_Fire_fire_tiles_changed():
	for tile in get_used_cells():
		if self.has_node(str(tile)) == false:
			var newLight = Light2D.new()
			newLight.texture = preload("res://assets/images/shadows/light.png")
			newLight.texture_scale = 0.4
			newLight.energy = 0.4
			newLight.name = str(tile)
			
			var pos = Vector2(map_to_world(tile).x, map_to_world(tile).y)
			newLight.position = pos
			self.add_child(newLight)
			
			var fireStream = preload("res://assets/sounds/disasters/fire.wav")
			var fireSound = AudioStreamPlayer2D.new()
			fireSound.stream = fireStream
			newLight.add_child(fireSound)
			fireSound.bus = "sfx"
			fireSound.play()
			
			var smokeParticles = preload("res://scenes/particles/smokeParticles.tscn")
			var smoke = smokeParticles.instance()
			newLight.add_child(smoke)
	
	for light in get_children():
		if light is Light2D:
			if not (light.name in tiles):
				light.queue_free()
	yield(get_tree(), "idle_frame")
