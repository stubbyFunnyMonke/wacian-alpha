extends Node

var storedItem = -1

var floorItemData = {} 
var floorPlaygroundData = {} 
var currentItemsNode
var currentPlaygroundNode 
var currentFireTilemap
var currentFloor = 0

var furnituredata
var tilemapdata

var tile11data = {}

var tileDurabilityData = {}
var currentBackgroundNode

var fireTiles = {}
#on ready/on new floor, check for new unchecked tiles

func _ready():
	furnituredata = globalItemHandler.read_from_JSON("res://assets/json/furnituredata.json")
	for key in furnituredata.keys():
		furnituredata[key]["key"] = key
	
	tilemapdata = globalItemHandler.read_from_JSON("res://assets/json/tilemapdata.json")
	for key in tilemapdata.keys():
		tilemapdata[key]["key"] = key
	
	changefloor.connect("on_changed_floor", self, "_on_changed_floor")

func reset():
	storedItem = -1
	
	floorItemData = {} 
	floorPlaygroundData = {} 
	currentItemsNode = null
	currentPlaygroundNode  = null
	currentFloor = 0
	
	tile11data = {}
	
	tileDurabilityData = {}
	currentBackgroundNode = null
	
	fireTiles = {}

func newFloor(itemsnode, playgroundnode, backgroundnode, firetilemap):
	currentItemsNode = itemsnode
	currentPlaygroundNode = playgroundnode
	currentFireTilemap = firetilemap
	containerhandler.initializeContainers()
	
	currentBackgroundNode = backgroundnode
	for cell in currentBackgroundNode.get_used_cells():
		var sandboxArea = global.get_scene_node().get_node("SandboxArea")
		var idfilters = [2, 3, 4, 5]
		if backgroundnode.get_cellv(cell) != 9 && backgroundnode.get_cellv(cell) != 12 && !idfilters.has(sandboxArea.get_cellv(cell)):
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

func saveFireTiles():
	#save items and their positions
	var cellsArray = []
	
	cellsArray = currentFireTilemap.get_used_cells()
	fireTiles[changefloor.floors[currentFloor]] = cellsArray

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

### furniture demolition

func demolish_furniture_tile(tile_pos):
	var tile_cell_at_tile_pos = currentPlaygroundNode.get_cellv(tile_pos)
	
	var maintile = tile_cell_at_tile_pos
	
	if tile_cell_at_tile_pos != -1:
		if tile_cell_at_tile_pos != 11:
			#tile is NOT an id 11 tile
			
			#store container data and clear empty spaces
			var cellData = getFurnitureData(tile_cell_at_tile_pos)
			var containerData = containerhandler.get_container_data(cellData)
			if containerData:
				var currentfloor = changefloor.floors[currentFloor]
				for item in containerhandler.containers[currentfloor][str(tile_pos)]:
					if (randi() % 3) + 1 > 1 && item.size() > 0: # has a random chance to just get deleted
						var dropPos2 = currentPlaygroundNode.map_to_world(tile_pos)
						dropPos2 = Vector2(dropPos2.x + randi() % 32, dropPos2.y + randi() % 32)
						
						var dropitem2 = preload("res://scenes/entities/droppeditem.tscn")
						
						var dropitem2_2 = dropitem2.instance()
						dropitem2_2.setItem(item)
						dropitem2_2.setPos(dropPos2)
						global.get_scene_node().get_node("YSort/Items").add_child(dropitem2_2)
			
			containerhandler.clearEmpty()
			
			var stringStored = str(tile_cell_at_tile_pos)
			var tilesize = tilemapdata[stringStored].tilesize
			
			for x in range(tilesize[0]):
					for y in range(tilesize[1]):
						var checkvector = Vector2(tile_pos.x + x, tile_pos.y + y)
						currentPlaygroundNode.set_cellv(checkvector, -1)
		else:
			#tile IS an id 11 tile
			for pos11 in tile11data:
				if tile_pos in tile11data[pos11].cells:
					var getVector = str2var("Vector2" + pos11)
					var stringStored = str(currentPlaygroundNode.get_cellv(getVector))
					var tilesize = tilemapdata[stringStored].tilesize
					
					maintile = currentPlaygroundNode.get_cellv(getVector)
					
					for x in range(tilesize[0]):
							for y in range(tilesize[1]):
								var checkvector = Vector2(getVector.x + x, getVector.y + y)
								currentPlaygroundNode.set_cellv(checkvector, -1)
					break
		
		for drop in getFurnitureData(maintile).smashedDrops:
			var smashedFurnitureData = getFurnitureData(maintile).smashedDrops
			for _n in range(randi() % int(smashedFurnitureData[drop].max - smashedFurnitureData[drop].min) + int(smashedFurnitureData[drop].min)):
				var dropPos = currentPlaygroundNode.map_to_world(tile_pos)
				dropPos = Vector2(dropPos.x + randi() % 32, dropPos.y + randi() % 32)
				
				var dropitem = preload("res://scenes/entities/droppeditem.tscn")
				
				var dropitem1 = dropitem.instance()
				dropitem1.setItem(globalItemHandler.get_item_by_key(drop))
				dropitem1.setPos(dropPos)
				global.get_scene_node().get_node("YSort/Items").add_child(dropitem1)

### tile durability stuff

func init_tile_durability(tile_pos):
	if !str(currentFloor) in tileDurabilityData:
		tileDurabilityData[str(currentFloor)] = {}
	if not str(tile_pos) in tileDurabilityData[str(currentFloor)]:
		var newData = {
			"maxDurability": 100,
			"currentDurability": 100 #randi() % 150
		}
		tileDurabilityData[str(currentFloor)][str(tile_pos)] = newData

func deteriorate_tile(tile_pos, dmg):
	if str(currentFloor) in tileDurabilityData:
		if str(tile_pos) in tileDurabilityData[str(currentFloor)]:
			if !(tileDurabilityData[str(currentFloor)][str(tile_pos)].currentDurability <= 0):
				tileDurabilityData[str(currentFloor)][str(tile_pos)].currentDurability = tileDurabilityData[str(currentFloor)][str(tile_pos)].currentDurability - dmg
				#TODO: sfx + vfx +  dmg visualization

func silent_deteriorate_tile(tile_pos, floorlevel, dmg):
	if str(floorlevel) == str(currentFloor):
		deteriorate_tile(tile_pos, dmg)
	elif str(floorlevel) in tileDurabilityData:
		if str(tile_pos) in tileDurabilityData[str(floorlevel)]:
			if !(tileDurabilityData[str(floorlevel)][str(tile_pos)].currentDurability <= 0):
				tileDurabilityData[str(floorlevel)][str(tile_pos)].currentDurability = tileDurabilityData[str(floorlevel)][str(tile_pos)].currentDurability - dmg
				#TODO: sfx + vfx +  dmg visualization

func repair_tile(tile_pos, heal):
	if str(currentFloor) in tileDurabilityData:
		if str(tile_pos) in tileDurabilityData[str(currentFloor)]:
			if !(tileDurabilityData[str(currentFloor)][str(tile_pos)].currentDurability >= tileDurabilityData[str(currentFloor)][str(tile_pos)].maxDurability):
				tileDurabilityData[str(currentFloor)][str(tile_pos)].currentDurability = tileDurabilityData[str(currentFloor)][str(tile_pos)].currentDurability + heal
				#TODO: sfx + vfx + hp visualization



