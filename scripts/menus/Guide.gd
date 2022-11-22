extends CanvasLayer

signal finished

const mouseButtonList = {
	1: "Left Mouse Button",
	2: "Right Mouse Button",
	3: "Middle Mouse Button",
	8: "Mouse Button 4",
	9: "Mouse Button 5"
}

const textSequence = {
	0: "Welcome to Wacian! In this game, you must try to survive neverending waves of natural disasters!",
	1: "How, exactly?", 
	2: "By using your environment.",
	3: "You can pick up and place furniture with the %s button in order to move them around.",
	4: "You can find chests around your apartment and open them with the %s button in order to get items.",
	5: "To use these items, press %s while they're selected on your hotbar.",
	6: "You can press %s to sprint in order to dodge things like falling hazards...",
	7: "...and press %s to crouch under tables and to keep your stability during an earthquake.",
	8: "However, your own survival is not the only thing you should worry about.",
	9: "If you leave your apartment alone, it will eventually sustain too much damage and collapse.",
	10: "You can see how much more your apartment can handle with this bar here.",
	11: "This is why The Hammer is a crucial tool as it can repair the apartment. ",
	12: "In order to use it, make sure you have at least 1 scrap and 1 nail in your inventory and have the hammer selected.",
	13: "Then with your cursor, hover over the area you want to repair and press %s to repair it.",
	14: "Running out of nails and scrap?",
	15: "If you find a sledgehammer in one of your chests, you can use it to destroy furniture and turn them into scrap in order to repair the building.",
	16: "...and I think that's all the important things you need to know!",
	17: "Good Luck!"
}

const controlsSequence = {
	3: "furniture_move",
	4: "furniture_interact",
	5: "useitem",
	6: "sprint",
	7: "crouch",
	13: "useitem"
}

var current = 0

onready var textLabel = get_node("Control/SideBar/VBoxContainer/Label")
onready var imagesContainers = get_node("Control/ImagesContainers")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control.visible = false

func reset():
	current = 0
	$Control.visible = true

func display_new_guide():
	for child in imagesContainers.get_children():
		if child.name != str(current):
			child.visible = false
		else:
			child.visible = true
	
	if !(current in textSequence):
		$Control.visible = false
		emit_signal("finished")
		return
	
	if current in controlsSequence:
		var getProfile = InputMapper.get_selected_profile()
		var control = ""
		
		if getProfile[controlsSequence[current]][1] == "InputEventKey":
			control = OS.get_scancode_string(getProfile[controlsSequence[current]][0])
		elif getProfile[controlsSequence[current]][1]  == "InputEventMouseButton":
			if getProfile[controlsSequence[current]][0] in mouseButtonList:
				control = str(mouseButtonList[getProfile[controlsSequence[current]][0]])
		
		textLabel.text = textSequence[current] % control
	else:
		textLabel.text = textSequence[current]

func _process(delta):
	display_new_guide()
	if Input.is_action_just_pressed("ui_accept") and global.ingame == true && $Control.visible == true:
		current += 1
