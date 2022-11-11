extends Node

signal container_items_changed(index, containersize)
signal open_container(cols, rows, items)
signal close_container(containersize)

var currentcontainer = null
var containertypes
var containers = {}
var currentopened
var carriedcontaineritems = []

func _ready():
	containertypes = globalItemHandler.read_from_JSON("res://assets/json/containertypes.json")
	for key in containertypes.keys():
		containertypes[key]["key"] = key
	
	reset()

func reset():
	for floorname in changefloor.floors:
		containers[floorname] = {}
	
	carriedcontaineritems = []

#this will do for testing
func initializeContainers():
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	var allcells = playgroundHandler.currentPlaygroundNode.get_used_cells()
	
	if allcells:
		for cellpos in allcells:
			var cellID = playgroundHandler.currentPlaygroundNode.get_cellv(cellpos)
			if cellID != 11:
				var cellData = playgroundHandler.getFurnitureData(cellID)
				var containerData = get_container_data(cellData)
				if containerData && not str(cellpos) in containers[currentfloor]:
					var slots = containerData.cols * containerData.rows
					var containeritems = []
					for _i in range(slots):
						containeritems.append({})
					
					for i in range(containeritems.size()):
						containeritems[i] = globalItemHandler.get_item_by_key(globalItemHandler.items.keys()[randi() % globalItemHandler.items.keys().size()])
					
					containers[currentfloor][str(cellpos)] = containeritems

func clearEmpty():
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	var allcells = playgroundHandler.currentPlaygroundNode.get_used_cells()
	
	if allcells:
		for cellpos in allcells:
			if str(cellpos) in containers[currentfloor]:
				if playgroundHandler.currentPlaygroundNode.get_cellv(cellpos) == -1:
					containers[currentfloor][str(cellpos)] = []

func addNew(vector2d):
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	containers[currentfloor][str(vector2d)] = carriedcontaineritems
	carriedcontaineritems = []

func get_container_data(celldata):
	var containertype
	
	for container in containertypes:
		if containertypes[container].container_name == celldata.furniture_name:
			containertype = containertypes[container]
			break
	
	return containertype

func open_container(items, containerdata):
	emit_signal("open_container", containerdata.cols, containerdata.rows, items)

func close_container():
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	emit_signal("close_container", containers[currentfloor][str(currentopened)].size())
	currentopened = null

#the container is a vector2d
func set_item(container, index, item):
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	var previous_item = containers[currentfloor][str(container)][index].duplicate()
	containers[currentfloor][str(container)][index] = item
	emit_signal("container_items_changed", [index], containers[currentfloor][str(container)].size())
	return previous_item

func remove_item(container, index):
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	var previous_item = containers[currentfloor][str(container)][index].duplicate()
	containers[currentfloor][str(container)][index].clear()
	emit_signal("container_items_changed", [index], containers[currentfloor][str(container)].size())
	return previous_item

func set_item_quantity(container, index, amount):
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	containers[currentfloor][str(container)][index].quantity += amount
	if containers[currentfloor][str(container)][index].quantity <= 0:
		remove_item(container, index)
	else:
		emit_signal("container_items_changed", [index], containers[currentfloor][str(container)].size())

