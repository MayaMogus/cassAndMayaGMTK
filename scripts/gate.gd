@tool
extends Node2D
class_name Gate

enum gateTypes {Yellow, Blue, Red, Green}
@export var gateIndex : gateTypes

@export_range(32, 1024, 32) var width: float = 32
@export_range(32, 1024, 32) var height: float = 32

var gateColors : Dictionary = {
	gateTypes.Yellow : Color(.95, .8, 0.18),
	gateTypes.Blue : Color(.2, .6, 0.8),
	gateTypes.Red : Color(.7, .1, 0.15),
	gateTypes.Green : Color(.2, .6, 0.12),
}


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
	var target_size = Vector2(width, height)
	var base_size =  Vector2(16, 16)
	scale = target_size / base_size
	$Sprite2D.self_modulate = gateColors[gateIndex]

func disappear():
	$StaticBody2D/CollisionShape2D.disabled = true
	$Sprite2D.visible = false
	$Shader.visible = false


func reappear():
	$StaticBody2D/CollisionShape2D.disabled = false
	$Sprite2D.visible = true
	$Shader.visible = true
