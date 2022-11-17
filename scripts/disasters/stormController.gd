extends Node2D

onready var sandboxMap = get_node("/root/Node2D/SandboxArea")
onready var ysort = get_node("/root/Node2D/YSort")
onready var debris = $debris

export (PackedScene) var lightning
export (PackedScene) var rainDrop

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	var intensity = disasterHandler.intensity
	if disasterHandler.disasterData["storm"].active == true:
		if debris.emitting == false && changefloor.floors[changefloor.currentfloor] == "rooftop.tscn":
			debris.emitting = true
			debris.amount = 1024 - int(float(1024)/float(intensity)/float(4.5))
		
		if changefloor.floors[changefloor.currentfloor] == "rooftop.tscn":
			var rainDropSpeed = 5
			for i in rainDropSpeed:
				var newRainDropParticle = rainDrop.instance()
				ysort.add_child(newRainDropParticle)
				
				var playerNode = ysort.get_node("Player")
				var plrPos = playerNode.position
				var spreadPos = Vector2(plrPos.x + (randi() % 501) - 250, plrPos.y + (randi() % 501) - 250)
				newRainDropParticle.position = spreadPos
			
			for tile_pos in sandboxMap.get_used_cells():
				if sandboxMap.get_cellv(tile_pos) == 1:
					var rng = (randi() % 10000/intensity) + 1
					if rng == 1:
						var newObstacle = lightning.instance()
						ysort.add_child(newObstacle)
						var checkvector = sandboxMap.map_to_world(tile_pos) 
						var xPos = 32
						var yPos = 32
						newObstacle.position = Vector2(checkvector.x + xPos/2, checkvector.y + yPos/2)
	else:
		debris.emitting = false

