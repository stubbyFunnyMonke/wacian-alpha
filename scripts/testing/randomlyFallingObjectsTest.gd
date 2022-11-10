extends Node2D

onready var sandboxMap = get_node("/root/Node2D/SandboxArea")
onready var ysort = get_node("/root/Node2D/YSort")

export (PackedScene) var fallingFurniture

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	for tile_pos in sandboxMap.get_used_cells():
		if sandboxMap.get_cellv(tile_pos) == 1:
			var rng = (randi() % 1000) + 1
			if rng == 1:
				var newObstacle = fallingFurniture.instance()
				ysort.add_child(newObstacle)
				var checkvector = sandboxMap.map_to_world(tile_pos) 
				
				var xPos = 32
				var yPos = 32
				
				if newObstacle.furnitureID != -1:
					var tilesize = playgroundHandler.tilemapdata[newObstacle.furnitureID].tilesize
					xPos = tilesize[0] * 32
					yPos = tilesize[1] * 32
				
				newObstacle.position = Vector2(checkvector.x + xPos/2, checkvector.y + yPos/2)

