@tool
extends Node2D


@export_range(32, 2048, 32) var collider_width: float = 32
@export_range(32, 2048, 32) var collider_height: float = 32


func _ready():
	_update_collider()

func _enter_tree():
	if Engine.is_editor_hint():
		set_process(true)

func _process(_delta):
	# Optionally live update in editor
	
	if Engine.is_editor_hint():
	
		_update_collider()

func _update_collider():
	var target_size = Vector2(collider_width, collider_height)
	var base_size =  Vector2(50, 50)
	scale = target_size / base_size
	
	
