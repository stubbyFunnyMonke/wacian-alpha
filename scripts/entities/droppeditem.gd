extends ItemEntity

onready var sprite = $Sprite
onready var quantity = $Sprite/Quantity
onready var animationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var pickup = $pickup_sound

func _ready():
	display_item()
	animationPlayer.play("item bop")
	timer.start(1)

func display_item():
	if "icon" in item:
		sprite.texture = load("res://assets/images/items/%s" % item.icon)
		if !item.has('quantity'):
			quantity.text = ""
		else:
			if item.quantity == 1:
				quantity.text = ""
			else:
				quantity.text = str(item.quantity)

func get_item():
	var doneAdding
	if !item.has('quantity'):
		doneAdding = inventory.add_item(item, 1)
	else:
		doneAdding = inventory.add_item(item, item.quantity)
		
	if doneAdding:
		visible = false
		pickup.play()

func _on_ItemDrop_body_entered(_body):
	pickable = true
	if timer.is_stopped() && visible == true:
		get_item()

func _on_Timer_timeout():
	if pickable == true:
		get_item()


func _on_pickup_sound_finished():
	queue_free()

func _on_ItemDrop_body_exited(body):
	pickable = false
