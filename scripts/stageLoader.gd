extends Node

var currentStage = 0

var stages = [
	preload("res://scenes/stage_intro.tscn"),
	preload("res://scenes/stage_double_boost.tscn"),
	preload("res://scenes/stage_needle.tscn"),
	
]

func loadNextStage():
	get_tree().call_deferred("change_scene_to_packed", stages[currentStage])
	currentStage += 1
	KeyGlobalController.savedKeys.clear()
