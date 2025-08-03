extends Node

var stages: Dictionary[String, PackedScene] = {
	"Intro": preload("res://scenes/stage_intro.tscn"),
	"Stalactite": preload("res://scenes/stage_stalactite.tscn"),
	"DoubleBoost": preload("res://scenes/stage_double_boost.tscn"),
	"FourLoops": preload("res://scenes/stage_fourloops.tscn"),
	"Maze": preload("res://scenes/stage_maze.tscn"),
	"Needle": preload("res://scenes/stage_needle.tscn"),
}

var stage_names: Array[String] = [
	"Intro",
	"Stalactite",
	"DoubleBoost",
	"FourLoops",
	"Maze",
	"Needle",
]

var last_stage: String
