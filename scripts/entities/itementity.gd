extends Area2D

class_name ItemEntity

export (PackedScene) var ItemDrop

var item
var pickable = false

func setItem(newItem):
	if !item:
		item = newItem

func setPos(vec2):
	self.position = vec2
