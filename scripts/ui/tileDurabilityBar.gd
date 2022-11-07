extends ColorRect

onready var durabilityBar = $tileDurabilityBar

func _process(_delta):
	rect_position = get_global_mouse_position() + Vector2.ONE * 4

func display_info(item):
	rect_size = durabilityBar.rect_size
	yield(get_tree(), "idle_frame")
