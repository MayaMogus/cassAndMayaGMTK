@tool
extends Node2D
@export var spike_scene : PackedScene
@export_range(32, 512, 32) var spike_width: float = 32

func _ready():
	_update_spikes()

func _enter_tree():
	if Engine.is_editor_hint():
		
		set_process(true)

func _process(_delta):
	# Optionally live update in editor
	
	if Engine.is_editor_hint():
		
		_update_spikes()

func _update_spikes():
	for child in get_children():
		child.queue_free()
	for i in spike_width/32:
		
		var spike = spike_scene.instantiate()
		add_child(spike)
		spike.position.x = global_position.x + (32 * i)
