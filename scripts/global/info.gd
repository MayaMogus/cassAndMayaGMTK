extends Node

var stages: Array[PackedScene] = [
	preload("res://scenes/stage_intro.tscn"),
	preload("res://scenes/stage_stalactite.tscn"),
	preload("res://scenes/stage_double_boost.tscn"),
	preload("res://scenes/stage_fourloops.tscn"),
	preload("res://scenes/stage_maze.tscn"),
	preload("res://scenes/stage_needle.tscn"),
]

var stage_names: Array[String] = [
	"Intro",
	"Stalactite",
	"DoubleBoost",
	"FourLoops",
	"Maze",
	"Needle",
]

var _default_stage_info: Array[Dictionary] = [
	{"unlocked": true, "fastest_time": INF, "current_time": null, "current_deaths": 0},
	{"unlocked": false, "fastest_time": INF, "current_time": null, "current_deaths": 0},
	{"unlocked": false, "fastest_time": INF, "current_time": null, "current_deaths": 0},
	{"unlocked": false, "fastest_time": INF, "current_time": null, "current_deaths": 0},
	{"unlocked": false, "fastest_time": INF, "current_time": null, "current_deaths": 0},
	{"unlocked": false, "fastest_time": INF, "current_time": null, "current_deaths": 0},
]

var stage_info: Array[Dictionary] = _default_stage_info.duplicate(true)

var current_stage := 0

func LoadNextStage() -> void:
	current_stage += 1
	if current_stage == stages.size():
		return # TODO: win condition
	UnlockStage(current_stage)
	get_tree().change_scene_to_packed(stages[current_stage])
	
func LoadStageByIndex(stage_index: int) -> void:
	get_tree().change_scene_to_packed(stages[stage_index])
	
func GetStageIndexByName(stage_name: String) -> int:
	return stage_names.find(stage_name)


func UnlockStage(stage_index: int) -> void:
	stage_info[stage_index].unlocked = true

func SetStageInfo(stage_index: int, time: float, deaths: int) -> void:
	stage_info[stage_index].current_time = time
	stage_info[stage_index].current_deaths = deaths
	if stage_info[stage_index].current_time < stage_info[stage_index].fastest_time:
		stage_info[stage_index].fastest_time = stage_info[stage_index].current_time

func ClearStageInfo(stage_index: int) -> void:
	stage_info[stage_index] = _default_stage_info[stage_index].duplicate()

func ClearAllStageInfo() -> void:
	stage_info = _default_stage_info.duplicate(true)
