extends TileMap

onready var playgroundNode = get_tree().get_current_scene().get_node("YSort/Playground")

func _physics_process(delta):
	clear()
	for tile in playgroundNode.get_used_cells():
		set_cellv(tile, playgroundNode.get_cellv(tile))
