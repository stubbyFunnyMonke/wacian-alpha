extends Node

var soundNode
var soundNode2

func use(vector2d):
	containerhandler.currentopened = vector2d
	
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	var containers = containerhandler.containers
	var cellID = playgroundHandler.currentPlaygroundNode.get_cellv(vector2d)
	if cellID != 11:
		var cellData = playgroundHandler.getFurnitureData(cellID)
		var containerData = containerhandler.get_container_data(cellData)
		if containerData:
			containerhandler.open_container(containers[currentfloor][str(vector2d)], containerData)
			
			playgroundHandler.currentPlaygroundNode.set_cellv(vector2d, 12)
			
			soundNode = AudioStreamPlayer2D.new()
			soundNode.stream = load("res://assets/sounds/chest_open.wav")
			playgroundHandler.currentPlaygroundNode.add_child(soundNode)
			soundNode.position = playgroundHandler.currentPlaygroundNode.map_to_world(vector2d)
			soundNode.bus = "sfx"
			soundNode.play()
			soundNode.connect("finished", self, "sound1Finished")
	containerhandler.connect("close_container", self, "_on_Container_Close")

func sound1Finished():
	if soundNode:
		soundNode.queue_free()
		soundNode = null

func sound2Finished():
	if soundNode2:
		soundNode2.queue_free()
		soundNode2 = null

func _on_Container_Close(_v):
	containerhandler.disconnect("close_container", self, "_on_Container_Close")
	playgroundHandler.currentPlaygroundNode.set_cellv(containerhandler.currentopened, 2)
	soundNode2 = AudioStreamPlayer2D.new()
	soundNode2.stream = load("res://assets/sounds/chest_close.wav")
	playgroundHandler.currentPlaygroundNode.add_child(soundNode2)
	soundNode2.position = playgroundHandler.currentPlaygroundNode.map_to_world(containerhandler.currentopened)
	soundNode2.bus = "sfx"
	soundNode2.play()
	soundNode2.connect("finished", self, "sound2Finished")
