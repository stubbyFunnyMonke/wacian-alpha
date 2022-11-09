extends ColorRect

onready var durabilityBar = $tileDurabilityBar
onready var absorptionBar = $tileDurabilityBar/absorptionBar
onready var playerNode = get_tree().get_current_scene().get_node("YSort/Player")

func _ready():
	rect_size = durabilityBar.rect_size

func _process(_delta):
	rect_position = get_global_mouse_position() + Vector2.ONE * 4
	
	var mouse_pos = get_tree().get_current_scene().get_global_mouse_position()
	var selectedTile = playgroundHandler.currentBackgroundNode.world_to_map(mouse_pos)
	var currentFloorData = playgroundHandler.tileDurabilityData[str(playgroundHandler.currentFloor)]
	var getPlaceIndicator = get_tree().get_current_scene().get_node("PlaceIndicator")
	
	var success = false
	
	if getPlaceIndicator:
		if "customcursor" in inventory.get_selected():
			var scriptname = inventory.get_selected().key + ".gd"
			var actions = load("res://scripts/items/%s" % scriptname)
			if actions:
				var loadActions = actions.new()
				if loadActions.has_method("equipped"):
					success = loadActions.equipped(selectedTile, currentFloorData, getPlaceIndicator, absorptionBar, durabilityBar)
	
	visible = success
	if not "customcursor" in inventory.get_selected():
		Input.set_custom_mouse_cursor(null)
