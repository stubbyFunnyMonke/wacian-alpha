extends Node2D

onready var sprite = get_node("Sprite")

func _physics_process(_delta):
	var storedItem = str(playgroundHandler.storedItem) 
	if playgroundHandler.storedItem == -1:
		sprite.visible = false
	elif playgroundHandler.storedItem != -1:
		var cancel = false
		
		if storedItem in playgroundHandler.tilemapdata:
			if "valid" in playgroundHandler.tilemapdata[storedItem]:
				if playgroundHandler.tilemapdata[storedItem].valid == false:
					cancel = true
		
		if cancel == false:
			sprite.visible = true
			sprite.texture = load("res://assets/images/furniture/%s" % playgroundHandler.tilemapdata[storedItem].spritesheet)
			sprite.vframes = playgroundHandler.tilemapdata[storedItem].vframes
			sprite.hframes = playgroundHandler.tilemapdata[storedItem].hframes
			sprite.frame = playgroundHandler.tilemapdata[storedItem].frame
			
			var spritetilesize = playgroundHandler.tilemapdata[storedItem].tilesize
			sprite.offset.y = playgroundHandler.tilemapdata[storedItem].heldoffset

