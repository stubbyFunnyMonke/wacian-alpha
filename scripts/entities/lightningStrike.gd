extends Area2D

var maxDamage = 90
var minDamage = 5

onready var animPlayer = $AnimationPlayer
onready var sprite = $FurnitureSprite
onready var hurtbox = $Hurtbox
onready var furnitureCrash = $furnitureCrashParticles
onready var sandboxMap = get_node("/root/Node2D/SandboxArea")
onready var ysort = get_node("/root/Node2D/YSort")
onready var firetiles = ysort.get_node("Fire")

var soundNode

func _ready():
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
				playerstats.hurtPlayer(calculateDmg, self, 1)


func _on_AnimationPlayer_animation_finished(anim_name):
	var currentfloor = changefloor.floors[playgroundHandler.currentFloor]
	
	soundNode = AudioStreamPlayer2D.new()
	soundNode.stream = load("res://assets/sounds/disasters/storm/lightning_strike.wav")
	playgroundHandler.currentPlaygroundNode.add_child(soundNode)
	soundNode.position = position
	soundNode.bus = "ambience"
	soundNode.play()
	soundNode.connect("finished", self, "sound1Finished")
	
	if anim_name == "fall" or anim_name == "fallNoCrash":
		get_node("Timer").start()
		
		var playerNode = global.get_scene_node().get_node("YSort/Player")
		var cameraNode = playerNode.get_node("Camera2D")
		if playerNode.position.distance_to(self.position) <= 256:
			var cameraShakeMultiplier = playerNode.position.distance_to(self.position)/256
			cameraShakeMultiplier = 1 - cameraShakeMultiplier
			cameraNode.shake(0.1, (15 * cameraShakeMultiplier) * (disasterHandler.intensity * 0.1), (8 * cameraShakeMultiplier) * (disasterHandler.intensity * 0.1))
		
		var hitTile = playgroundHandler.currentPlaygroundNode.world_to_map(position)
		#check if adjacent blocks are taken/can be put on
		
		if playgroundHandler.currentPlaygroundNode.get_cellv(hitTile) == -1:
			playgroundHandler.deteriorate_tile(hitTile, 10)
		
		playgroundHandler.demolish_furniture_tile(hitTile)
		
		firetiles.set_cellv(hitTile, 0)

func _on_Timer_timeout():
	queue_free()

func sound1Finished():
	if soundNode:
		soundNode.queue_free()
		soundNode = null
