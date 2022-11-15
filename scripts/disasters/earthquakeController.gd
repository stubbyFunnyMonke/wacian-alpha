extends Node2D

onready var sandboxMap = get_node("/root/Node2D/SandboxArea")
onready var ysort = get_node("/root/Node2D/YSort")
onready var debris = $debris

export (PackedScene) var fallingFurniture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var intensity = disasterHandler.earthquakeIntensity + disasterHandler.intensity
	if disasterHandler.disasterData["earthquake"].active == true:
		if debris.emitting == false:
			debris.emitting = true
			debris.amount = 1024 - int(float(1024)/float(intensity)/float(4.5))
		
		var playerNode = global.get_scene_node().get_node("YSort/Player")
		var cameraNode = playerNode.get_node("Camera2D")
		cameraNode.shake(0.1, 10 * (intensity * 0.1), 6 * (intensity * 0.1))
		
		if playerstats.crouching == false:
			var chances = 1000
			if playerstats.sprinting == true:
				chances = 600
			var stunRng = (randi() % chances/intensity) + 1
			if stunRng == 1:
				playerstats.stunPlayer(0.5 * (intensity/2))
		
		for tile_pos in sandboxMap.get_used_cells():
			if sandboxMap.get_cellv(tile_pos) == 1:
				var rng = (randi() % 10000/intensity) + 1
				if rng == 1:
					var newObstacle = fallingFurniture.instance()
					ysort.add_child(newObstacle)
					var checkvector = sandboxMap.map_to_world(tile_pos) 
					
					var xPos = 32
					var yPos = 32
					
					if int(newObstacle.furnitureID) != -1:
						var tilesize = playgroundHandler.tilemapdata[newObstacle.furnitureID].tilesize
						xPos = tilesize[0] * 32
						yPos = tilesize[1] * 32
					
					newObstacle.position = Vector2(checkvector.x + xPos/2, checkvector.y + yPos/2)
	else:
		debris.emitting = false

