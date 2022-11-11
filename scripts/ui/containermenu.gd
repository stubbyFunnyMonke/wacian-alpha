extends SlotContainer

onready var colorrect = get_owner()

func _ready():
	containerhandler.connect("open_container", self, "_on_container_open")
	container_handler_ready()
	colorrect.hide()

func _on_container_open(cols, rows, items):
	PauseMenu.get_node("Container").uiOpen = true
	colorrect.visible = true
	display_item_slots(cols, rows, items)
	yield(get_tree(), "idle_frame")
	rect_position.x = (get_viewport_rect().size.x - (rect_size.x) * rect_scale.x) / 2
	rect_position.y = (get_viewport_rect().size.y - (rect_size.y) * rect_scale.y) / 2

