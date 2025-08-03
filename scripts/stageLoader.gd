extends Node

var currentStage = 0

var stages = [
	preload("res://scenes/stage_intro.tscn"),
	preload("res://scenes/stage_stalactite.tscn"),
	preload("res://scenes/stage_double_boost.tscn"),
	preload("res://scenes/stage_fourloops.tscn"),
	preload("res://scenes/stage_maze.tscn"),
	preload("res://scenes/stage_needle.tscn"),
	
]

func loadNextStage():
	
	get_tree().call_deferred("change_scene_to_packed", stages[currentStage])
	currentStage += 1
	KeyGlobalController.savedKeys.clear()

var stageSplits : Dictionary = {
	0:{'name':'Intro', 'time':'-:--', 'deaths' : 0},
	1:{'name':'Stalactite', 'time':'-:--', 'deaths' : 0},
	2:{'name':'Double Boost', 'time':'-:--', 'deaths' : 0},
	3:{'name':'Catapult', 'time':'-:--', 'deaths' : 0},
	4:{'name':'Cavern', 'time':'-:--', 'deaths' : 0},
	5:{'name':'Needle', 'time':'-:--', 'deaths' : 0},
}
