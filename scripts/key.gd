@tool
extends Node2D

enum keyTypes {Yellow, Blue, Red, Green}
@export var keyIndex : keyTypes

var keyColors : Dictionary = {
	keyTypes.Yellow : Color(.95, .8, 0.18),
	keyTypes.Blue : Color(.2, .6, 0.8),
	keyTypes.Red : Color(.7, .1, 0.15),
	keyTypes.Green : Color(.2, .6, 0.12),
}

func _enter_tree():
	if Engine.is_editor_hint():
		set_process(true)

func _process(_delta):
	# Optionally live update in editor
	
	if Engine.is_editor_hint():
	
		updateKey()


func _ready():
	updateKey()


func updateKey():
	$Sprite2D.self_modulate = keyColors[keyIndex]

func collectKey():
	var gateController = get_parent().get_parent().get_node('Gates')
	for child in gateController.get_children():
		if child.gateIndex == keyIndex:
			child.queue_free()
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	if body is Player:
		collectKey()
