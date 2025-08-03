extends Node2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/menus/level_complete_menu.tscn"))
