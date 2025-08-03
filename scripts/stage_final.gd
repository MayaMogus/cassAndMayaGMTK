extends Node2D




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Player.global_position.y < 7808:
		$Player/Sprite2D2.modulate.a = lerp($Player/Sprite2D2.modulate.a, 1.0, delta * 20)
	if $Player/Sprite2D2.modulate.a < 0.9:
		get_tree().change_scene_to_packed(preload("res://scenes/victory_scene.tscn"))
