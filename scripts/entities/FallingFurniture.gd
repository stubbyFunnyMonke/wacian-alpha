extends Area2D

var furnitureID = -1
var containerItems = []

var maxDamage = 20
var minDamage = 5

onready var animPlayer = $AnimationPlayer
onready var sprite = $FurnitureSprite
onready var hurtbox = $Hurtbox
onready var shadow = $ShadowContainer
onready var furnitureCrash = $furnitureCrashParticles
onready var sandboxMap = get_node("/root/Node2D/SandboxArea")

func _ready():
	if furnitureID != -1:
		var cellData = playgroundHandler.getFurnitureData(float(furnitureID))
		var containerData = containerhandler.get_container_data(cellData)
		if containerData:
			var maxItemCount = containerData.cols * containerData.rows
			for n in range(maxItemCount):
				containerItems.append({})
		
		furnitureID = str(furnitureID)
		
		var hitTile = playgroundHandler.currentPlaygroundNode.world_to_map(position)
		var tilesize = playgroundHandler.tilemapdata[furnitureID].tilesize
		
		var cancel = false
		
		for x in range(tilesize[0]):
			for y in range(tilesize[1]):
				var checkvector = Vector2(hitTile.x + x, hitTile.y + y)
				
				if playgroundHandler.currentPlaygroundNode.get_cellv(checkvector) != -1:
					#slot taken
					cancel = true
				if sandboxMap.get_cellv(checkvector) != 1:
					#not a valid spot
					cancel = true
		
		if cancel == false:
			animPlayer.play("fallNoCrash")
		else:
			animPlayer.play("fall")
			
		sprite.texture = load("res://assets/images/furniture/%s" % playgroundHandler.tilemapdata[furnitureID].spritesheet)
		sprite.vframes = playgroundHandler.tilemapdata[furnitureID].vframes
		sprite.hframes = playgroundHandler.tilemapdata[furnitureID].hframes
		sprite.frame = playgroundHandler.tilemapdata[furnitureID].frame
		
		hurtbox.scale = Vector2(tilesize[0], tilesize[1])
		shadow.scale = Vector2(tilesize[0], tilesize[1])
		
		furnitureCrash.process_material.emission_box_extents = Vector3(60 * tilesize[0], 1, 1)
	else:
		sprite.texture = load("res://assets/images/furniture/debris.png")
		sprite.vframes = 1
		sprite.hframes = 6
		sprite.frame = randi() % 3 
		
		animPlayer.play("fall")

func _on_FallingFurniture_body_entered(body):
	if body.get_class() == "KinematicBody2D":
		if body.name == "Player":
			var calculateDmg = maxDamage
			if body.position.distance_to(self.position) <= 32:
				calculateDmg = body.position.distance_to(self.position)/32
				calculateDmg = 1 - calculateDmg
				calculateDmg = calculateDmg * (maxDamage - minDamage)
				calculateDmg = calculateDmg + minDamage
			
			var hitTile = playgroundHandler.currentPlaygroundNode.world_to_map(position)
			
			if playgroundHandler.currentPlaygroundNode.get_cellv(hitTile) == -1 or playerstats.crouching == false:
				playerstats.changeHp(-calculateDmg)


func _on_AnimationPlayer_animation_finished(anim_name):
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	
	if anim_name == "fall" or anim_name == "fallNoCrash":
		get_node("Timer").start()
		
		var playerNode = global.get_scene_node().get_node("YSort/Player")
		var cameraNode = playerNode.get_node("Camera2D")
		if playerNode.position.distance_to(self.position) <= 256:
			var cameraShakeMultiplier = playerNode.position.distance_to(self.position)/256
			cameraShakeMultiplier = 1 - cameraShakeMultiplier
			cameraNode.shake(0.1, (15 * cameraShakeMultiplier), (8 * cameraShakeMultiplier))
		
		var hitTile = playgroundHandler.currentPlaygroundNode.world_to_map(position)
		#check if adjacent blocks are taken/can be put on
		
		if furnitureID != -1:
			var tilesize = playgroundHandler.tilemapdata[furnitureID].tilesize
			
			hitTile = Vector2(hitTile.x - tilesize[0] + 1, hitTile.y - tilesize[1] + 1)
			
			var cancel = false
			
			for x in range(tilesize[0]):
				for y in range(tilesize[1]):
					var checkvector = Vector2(hitTile.x + x, hitTile.y + y)
					
					if playgroundHandler.currentPlaygroundNode.get_cellv(checkvector) != -1:
						#slot taken
						cancel = true
					if sandboxMap.get_cellv(checkvector) != 1:
						#not a valid spot
						cancel = true
			
			if cancel == false:
				for x in range(tilesize[0]):
					for y in range(tilesize[1]):
						
						var checkvector = Vector2(hitTile.x + x, hitTile.y + y)
						
						if playgroundHandler.currentPlaygroundNode.get_cellv(checkvector) == -1:
							playgroundHandler.deteriorate_tile(checkvector, 1)
						
						if checkvector != hitTile:
							playgroundHandler.currentPlaygroundNode.set_cellv(checkvector, 11)
							
							var foundtilecell = false
							
							for pos11 in playgroundHandler.tile11data:
								if pos11 == str(hitTile):
									foundtilecell = true
									break
							
							if foundtilecell == false:
								var newtile11data = {
									"name": hitTile,
									"cells": []
								}
								playgroundHandler.tile11data[str(hitTile)] = newtile11data
							
							playgroundHandler.tile11data[str(hitTile)].cells.append(checkvector)
							
				#set container data
				var cellData = playgroundHandler.getFurnitureData(float(furnitureID))
				var containerData = containerhandler.get_container_data(cellData)
				if containerData:
					containerhandler.containers[currentfloor][str(hitTile)] = containerItems
				containerhandler.clearEmpty()
				
				playgroundHandler.currentPlaygroundNode.set_cell(hitTile.x, hitTile.y, float(furnitureID))
		else:
			if playgroundHandler.currentPlaygroundNode.get_cellv(hitTile) == -1:
				playgroundHandler.deteriorate_tile(hitTile, 1)

func _on_Timer_timeout():
	queue_free()
