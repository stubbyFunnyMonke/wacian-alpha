extends KinematicBody2D

export (PackedScene) var sprintParticles
# code time niggas

var ACCELERATION = 500
var MAX_SPEED = 100
var ROLL_SPEED = 125
export var FRICTION = 999999999

enum {
	MOVE,
	ROLL,
}

var state = MOVE
var velocity = Vector2.ZERO
var roll_vector = Vector2.DOWN

#onready var animationPlayer = $AnimationPlayer
#onready var animationTree = $AnimationTree
#onready var animationState = animationTree.get("parameters/playback")
#onready var swordHitbox = $HitboxPivot/SwordHitbox
#onready var hurtbox = $Hurtbox
onready var footstep = $footstep
onready var footstepTimer = $footstep/Timer

var containermenu

var footstepcooldown = 0.5

func _ready():
	randomize()
#	animationTree.active = true
#	swordHitbox.knockback_vector = roll_vector
	containermenu = get_tree().get_current_scene().get_node("UI/ContainerMenu")

func _physics_process(delta): #renderstepped :flushed:
	match state:
		MOVE: move_state(delta)
		ROLL: roll_state(delta)

func move_state(delta):
	var mouse_vector = Vector2.ZERO
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("walkright") - Input.get_action_strength("walkleft") 
	input_vector.y = Input.get_action_strength("walkdown") - Input.get_action_strength("walkup") 
	input_vector = input_vector.normalized()
	
	# might change this later
	# mouse pos relative to player obj
	mouse_vector = get_global_mouse_position() - self.global_position
	mouse_vector = mouse_vector.normalized()
	
	if input_vector != Vector2.ZERO && containermenu.visible == false && playerstats.stunned == false:
		roll_vector = input_vector
#		swordHitbox.knockback_vector = mouse_vector
#		animationTree.set("parameters/Idle/blend_position", mouse_vector)
#		animationTree.set("parameters/Run/blend_position", mouse_vector)
#		animationTree.set("parameters/Attack/blend_position", mouse_vector)
#		animationTree.set("parameters/Roll/blend_position", input_vector)
#		animationState.travel("Run")
		velocity = velocity.move_toward((input_vector * MAX_SPEED) * playerstats.player_get_speed(), ACCELERATION * delta)
		
		if not footstep.is_playing() && footstepTimer.is_stopped():
			footstepTimer.start()
			footstep.play()
			
			if playerstats.sprinting == true && playerstats.sprintlockout != true:
				var stepParticles = sprintParticles.instance()
				stepParticles.position.x = position.x
				stepParticles.position.y = position.y + 16
				get_tree().get_current_scene().add_child(stepParticles)
	else:
#		animationState.travel("Idle")
#		animationTree.set("parameters/Idle/blend_position", mouse_vector)
#		animationTree.set("parameters/Attack/blend_position", mouse_vector)
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
		footstep.stop()
	
	move()
	
	if playerstats.crouching == true:
		collision_layer = 2
		collision_mask = 2
	else:
		collision_layer = 1
		collision_mask = 1
	
	var stunnedAnimation = $stunEffect
	if playerstats.stunned == true:
		stunnedAnimation.playing = true
		stunnedAnimation.visible = true
	else:
		stunnedAnimation.playing = false
		stunnedAnimation.visible = false
	
#	if Input.is_action_just_pressed("roll") && input_vector != Vector2.ZERO:
#		state = ROLL

func roll_state(_delta):
	velocity = roll_vector * ROLL_SPEED
#	animationState.travel("Roll")
	move()

func move():
	velocity = move_and_slide(velocity)

func roll_animation_finished():
	# velocity = Vector2.ZERO
	state = MOVE

func attack_animation_finished():
	state = MOVE
