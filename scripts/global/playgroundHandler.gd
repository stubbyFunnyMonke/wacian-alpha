extends Node

var storedItem = -1

var floorItemData = {} 
var floorPlaygroundData = {} 
var currentItemsNode
var currentPlaygroundNode 
var currentFloor = 0

var furnituredata
var tilemapdata

var tile11data = {}

var tileDurabilityData = {}
var currentBackgroundNode

#on ready/on new floor, check for new unchecked tiles

func _ready():
	furnituredata = globalItemHandler.read_from_JSON("res://assets/json/furnituredata.json")
	for key in furnituredata.keys():
		furnituredata[key]["key"] = key
	
	tilemapdata = globalItemHandler.read_from_JSON("res://assets/json/tilemapdata.json")
	for key in tilemapdata.keys():
		tilemapdata[key]["key"] = key
	
	changefloor.connect("on_changed_floor", self, "_on_changed_floor")

func newFloor(itemsnode, playgroundnode, backgroundnode):
	currentItemsNode = itemsnode
	currentPlaygroundNode = playgroundnode
	containerhandler.initializeContainers()
	
	currentBackgroundNode = backgroundnode
	for cell in currentBackgroundNode.get_used_cells():
		if backgroundnode.get_cellv(cell) != 9:
			init_tile_durability(cell)

func saveItems():
	#save items and their positions
	var itemsArray = []
	
	for ite in currentItemsNode.get_children():
		var newItem = {
			"itemData": ite.item,
			"position": ite.position
		} 
		itemsArray.append(newItem)
	floorItemData[changefloor.floors[currentFloor]] = itemsArray

func savePlayground():
	#save items and their positions
	var cellsArray = []
	
	for cell in currentPlaygroundNode.get_used_cells():
		var newItem = {
			"cellid": currentPlaygroundNode.get_cellv(cell),
			"position": cell
		} 
		cellsArray.append(newItem)
	floorPlaygroundData[changefloor.floors[currentFloor]] = cellsArray

func getFurnitureData(tileID):
	var foundfurniture
	
	for furn in furnituredata:
		if furnituredata[furn].maintile == tileID:
			foundfurniture = furnituredata[furn]
			break
		if tileID in furnituredata[furn].tiles:
			foundfurniture = furnituredata[furn]
			break
	
	return foundfurniture

func _on_changed_floor(floorname):
	#load items and their positions
	if floorname in floorItemData:
		if floorItemData[floorname].size() > 0:
			for ite in floorItemData[floorname]:
				var dropitem = preload("res://scenes/entities/droppeditem.tscn")
				var dropitem1 = dropitem.instance()
				dropitem1.setItem(ite.itemData)
				dropitem1.setPos(ite.position)
				if get_tree().get_current_scene().get_node("YSort/Items"):
					get_tree().get_current_scene().get_node("YSort/Items").add_child(dropitem1)
	
	#load furniture and their positions
	if floorname in floorPlaygroundData:
		if floorPlaygroundData[floorname].size() > 0:
			if get_tree().get_current_scene().get_node("YSort/Playground"):
				get_tree().get_current_scene().get_node("YSort/Playground").clear()
				for cellinst in floorPlaygroundData[floorname]:
					get_tree().get_current_scene().get_node("YSort/Playground").set_cellv(cellinst.position, cellinst.cellid)
	
	currentFloor = changefloor.currentfloor

### tile durability stuff

func init_tile_durability(tile_pos):
	if !str(currentFloor) in tileDurabilityData:
		tileDurabilityData[str(currentFloor)] = {}
	if str(tile_pos) in tileDurabilityData[str(currentFloor)]:
		print("checked")
	else:
		var newData = {
			"maxDurability": 100,
			"currentDurability": 150
		}
		tileDurabilityData[str(currentFloor)][str(tile_pos)] = newData


