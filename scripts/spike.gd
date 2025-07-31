@tool
extends GridContainer
var spike_scene : PackedScene = preload("res://scenes/spike.tscn")
@export_range(32, 2048, 32) var spike_width: float = 32

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
	var spikeAmount = spike_width/32
	columns = spikeAmount
	for i in spikeAmount:
		
		var spike = spike_scene.instantiate()
		add_child(spike)
		#spike.global_position.x = global_position.x + (32 * i)
