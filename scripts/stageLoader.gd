extends Node

var currentStage = 0

var stages = [
	preload("res://scenes/stage_1.tscn"),
	
	
]

func loadNextStage():
	get_tree().change_scene_to_packed(stages[currentStage])
	currentStage += 1
