extends Node

signal player_stats_changed
signal hit_player

#max possible values
const maxHp = 100
const maxSpeed = 100
const maxStamina = 100
const maxHunger = 50
const maxThirst = 50

#default values (no buffs or debuffs and whatnot)
const defaultHp = 100
const defaultSpeed = 16
const defaultStamina = 100
const defaultHunger = 50
const defaultThirst = 50
const furnitureRange = 3

#current values
var currentHp = 100
var currentSpeed = 16
var currentStamina = 100
var currentHunger = 50
var currentThirst = 50

#multiplier system??
var speedMultipliers = {}

#switches
var sprinting = false
var sprintlockout = false

var crouching = false
var unCrouchBuffer = false

var stunned = false
var stunTimer = 0

var intangible = false
var intangibleTimer = 0

var onfire = false
var onfireTimer = 0
#debug global

func _ready():
	#player_buff("speed", 9, "test_lol")
	reset()

func reset():
	currentHp = 100
	currentSpeed = 16
	currentStamina = 100
	currentHunger = 50
	currentThirst = 50
	
	speedMultipliers = {}
	
	sprinting = false
	sprintlockout = false
	
	crouching = false
	unCrouchBuffer = false
	
	stunned = false
	stunTimer = 0
	
	intangible = false
	intangibleTimer = 0
	
	onfire = false
	onfireTimer = 0

#outsourced funcs

func player_get_speed():
	var speedmultiplier = float(currentSpeed)/float(16) #16 default speed
	return speedmultiplier

func player_buff(stat, multiplier, buffname):
	if stat == "speed":
		speedMultipliers[buffname] = multiplier

func changeHp(amount):
	var newamount = currentHp + amount
	
	if newamount >= maxHp:
		currentHp = maxHp
	else:
		currentHp = newamount
	emit_signal("player_stats_changed")

func changeHunger(amount):
	var newamount = currentHunger + amount
	
	if newamount >= maxHunger:
		currentHunger = maxHunger
	elif newamount > 0:
		currentHunger = newamount
	else:
		currentHunger = 0
	emit_signal("player_stats_changed")

func changeThirst(amount):
	var newamount = currentThirst + amount
	
	if newamount >= maxThirst:
		currentThirst = maxThirst
	elif newamount > 0:
		currentThirst = newamount
	else:
		currentThirst = 0
	emit_signal("player_stats_changed")

func changeStamina(amount):
	var newamount = currentStamina + amount
	
	if newamount >= maxStamina:
		currentStamina = maxStamina
	elif newamount > 0:
		currentStamina = newamount
	else:
		currentStamina = 0
	emit_signal("player_stats_changed")

func player_eat(hunger_value):
	if currentHunger >= maxHunger:
		return false
	changeHunger(hunger_value)
	emit_signal("player_stats_changed")
	return true

func player_drink(thirst_value):
	if currentThirst >= maxThirst:
		return false
	changeThirst(thirst_value)
	emit_signal("player_stats_changed")
	return true

func stunPlayer(stunTime):
	stunned = true
	stunTimer = stunTime
	
	var soundNode = AudioStreamPlayer2D.new()
	soundNode.stream = load("res://assets/sounds/stunned.wav")
	playgroundHandler.currentPlaygroundNode.add_child(soundNode)
	var playerNode = global.get_scene_node().get_node("YSort/Player")
	soundNode.position = playerNode.position
	soundNode.bus = "sfx"
	soundNode.play()
	soundNode.connect("finished", self, "sound1Finished", [soundNode])

func player_set_intangible(intangibleDuration):
	intangibleTimer = intangibleDuration
	intangible = true

func player_set_on_fire(fireDuration):
	onfireTimer = fireDuration
	onfire = true

func hurtPlayer(dmg, source, intangibleDuration):
	if intangible == false:
		var playerNode = global.get_scene_node().get_node("YSort/Player")
		
		var hitEffect = preload("res://scenes/effects/hitEffect.tscn")
		var newHitEffect = hitEffect.instance()
		newHitEffect.position = playerNode.position
		newHitEffect.get_node("AnimationPlayer").play("play")
		global.get_scene_node().get_node("YSort").add_child(newHitEffect)
		changeHp(-dmg)
		
		var soundNode = AudioStreamPlayer2D.new()
		if dmg >= maxHp/2:
			soundNode.stream = load("res://assets/sounds/hit/hugedamage.wav")
		else:
			soundNode.stream = load("res://assets/sounds/hit/smalldamage.wav")
		soundNode.position = playerNode.position
		soundNode.bus = "sfx"
		soundNode.play()
		soundNode.connect("finished", self, "sound1Finished", [soundNode])
		playgroundHandler.currentPlaygroundNode.add_child(soundNode)
		
		emit_signal("hit_player")
		
		player_set_intangible(intangibleDuration)

func sound1Finished(soundNode):
	if soundNode:
		soundNode.queue_free()

#active funcs

func _unhandled_input(event):
	if event.is_action_pressed("sprint"):
		sprinting = true
		crouching = false
	elif event.is_action_released("sprint"):
		sprinting = false
	if event.is_action_pressed("crouch"):
		sprinting = false
		crouching = true
		unCrouchBuffer = false
	elif event.is_action_released("crouch"):
		unCrouchBuffer = true

#regen every 4 frames i guess
var regenTick = 0

func _physics_process(delta):
	if global.ingame == true:
		#regen hunger -delta, hp + 3delta
		var player = global.get_scene_node().get_node("YSort/Player")
		
		if regenTick > 4:
			regenTick = 0
			if currentHp < maxHp:
				if currentHunger > 0 && currentThirst > 0:
					changeHp(3*delta)
					changeHunger(-delta)
					changeThirst(-delta/3)
		regenTick += 1
		
		#check if the player is moving
		var input_vector = Vector2.ZERO
		input_vector.x = Input.get_action_strength("walkright") - Input.get_action_strength("walkleft") 
		input_vector.y = Input.get_action_strength("walkdown") - Input.get_action_strength("walkup") 
		
		#anything related to speed
		var maxSpeedMultiplier = 1
		
		for key in speedMultipliers:
			maxSpeedMultiplier = maxSpeedMultiplier * speedMultipliers[key]
		
		currentSpeed = defaultSpeed * maxSpeedMultiplier
		
		#sprinting
		if input_vector != Vector2.ZERO && sprinting == true && sprintlockout == false:
			if currentStamina > 0.1:
				changeStamina(-10*delta)
				player_buff("speed", 1.5, "sprinting")
			else:
				sprintlockout = true
		elif sprintlockout == true:
			player_buff("speed", 0.6875, "sprinting")
		else:
			player_buff("speed", 1, "sprinting")
		
		#crouching
		if input_vector != Vector2.ZERO && crouching == true:
			player_buff("speed", 0.4, "crouching")
		else:
			player_buff("speed", 1, "crouching")
		
		if currentStamina < maxStamina && currentHunger > 0 && currentThirst > 0:
			changeStamina(3*delta)
			changeHunger(-delta/30)
			changeThirst(-delta/30)
		if currentStamina > maxStamina/4:
			sprintlockout = false
		
		#buffer crouch if under table
		var playerTile = playgroundHandler.currentPlaygroundNode.world_to_map(player.position)
		if playgroundHandler.currentPlaygroundNode.get_cellv(playerTile) == -1 && unCrouchBuffer == true:
				crouching = false
		
		#muffle the sound based on hp
		if global.ingame == true:
			var hpPercentage = float(currentHp)/float(maxHp)
			
			var newcutoff = 20000 * sin(hpPercentage)
			
			var lowPass = AudioServer.get_bus_effect(1, 0)
			lowPass.set_cutoff(newcutoff)
		else:
			var lowPass = AudioServer.get_bus_effect(1, 0)
			lowPass.set_cutoff(20000)
		
		#controls the player stunning
		if stunTimer > 0:
			stunTimer = stunTimer - delta
		else:
			stunned = false
		
		if intangibleTimer > 0:
			intangibleTimer = intangibleTimer - delta
		else:
			intangible = false
		
		#burn the player lol
		if onfireTimer > 0:
			onfireTimer = onfireTimer - delta
		else:
			onfire = false
		
		if onfire == true:
			hurtPlayer(1, "fire", 0.5)
		
		#trigger game over
		if currentHp <= 0:
			global.game_over()
