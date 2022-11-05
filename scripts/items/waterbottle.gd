extends Node

var soundNode

func use(playerNode):
	var drink = playerstats.player_drink(20)
	
	if drink == true:
		inventory.set_item_quantity(inventory.selected, -1)

		soundNode = AudioStreamPlayer2D.new()
		soundNode.stream = load("res://assets/sounds/drink.wav")
		playgroundHandler.currentPlaygroundNode.add_child(soundNode)
		soundNode.position = playerNode.position
		soundNode.bus = "sfx"
		soundNode.play()
		soundNode.connect("finished", self, "sound1Finished")
		
		var successful = inventory.add_item(globalItemHandler.get_item_by_key("bottle"), 1)
		if successful == false:
			var dropitem = preload("res://scenes/entities/droppeditem.tscn")
			var player = global.get_tree().get_current_scene().get_node("YSort/Player")
			
			var dropitem1 = dropitem.instance()
			dropitem1.setItem(globalItemHandler.get_item_by_key("bottle"))
			dropitem1.setPos(player.position)
			global.get_tree().get_current_scene().get_node("YSort/Items").add_child(dropitem1)

func sound1Finished():
	if soundNode:
		soundNode.queue_free()
		soundNode = null
