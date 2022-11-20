extends ScrollContainer

var master_bus = AudioServer.get_bus_index("Master")

var sfx_bus_1 = AudioServer.get_bus_index("sfx")
var sfx_bus_2 = AudioServer.get_bus_index("menu sfx")

var music_bus_1 = AudioServer.get_bus_index("music")
var music_bus_2 = AudioServer.get_bus_index("music transitions")
var music_bus_3 = AudioServer.get_bus_index("menu music")

onready var MasterVSlider = get_node("VBoxContainer/MasterVolume/MasterVSlider")
onready var SFXVSlider = get_node("VBoxContainer/SFXVolume/SFXVSlider")
onready var MusicVSlider = get_node("VBoxContainer/MusicVolume/MusicVSlider")

func _ready():
	MasterVSlider.value = AudioServer.get_bus_volume_db(master_bus)
	SFXVSlider.value = AudioServer.get_bus_volume_db(sfx_bus_1)
	MusicVSlider.value = AudioServer.get_bus_volume_db(music_bus_1)

func _on_MusicVSlider_value_changed(value):
	AudioServer.set_bus_volume_db(music_bus_1, value)
	AudioServer.set_bus_volume_db(music_bus_2, value)
	AudioServer.set_bus_volume_db(music_bus_3, value)

func _on_SFXVSlider_value_changed(value):
	AudioServer.set_bus_volume_db(sfx_bus_1, value)
	AudioServer.set_bus_volume_db(sfx_bus_2, value)

func _on_MasterVSlider_value_changed(value):
	AudioServer.set_bus_volume_db(master_bus, value)
