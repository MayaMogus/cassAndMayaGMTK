extends Node

var currentStage = 0

var stages = [
	preload("res://scenes/introStage.tscn"),
	preload("res://scenes/stage_1.tscn"),
	preload("res://scenes/stage_2.tscn"),
	
]

func loadNextStage():
	get_tree().call_deferred("change_scene_to_packed", stages[currentStage])
	currentStage += 1
	KeyGlobalController.savedKeys.clear()
