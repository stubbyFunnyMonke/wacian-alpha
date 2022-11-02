extends Node

var soundNode

func use(playerNode):
	var drink = playerstats.player_drink(10)
	
	playerstats.changeHp(50)
	
	if drink == true:
		inventory.set_item_quantity(inventory.selected, -1)

		soundNode = AudioStreamPlayer2D.new()
		soundNode.stream = load("res://assets/sounds/drink.wav")
		playgroundHandler.currentPlaygroundNode.add_child(soundNode)
		soundNode.position = playerNode.position
		soundNode.bus = "sfx"
		soundNode.play()
		soundNode.connect("finished", self, "sound1Finished")

func sound1Finished():
	if soundNode:
		soundNode.queue_free()
		soundNode = null
