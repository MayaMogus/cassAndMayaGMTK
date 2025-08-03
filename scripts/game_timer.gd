extends Node

var game_timer_seconds := 0.0
var stage_timer_seconds := 0.0

var game_timer_paused := true
var stage_timer_paused := true

func _process(delta: float) -> void:
	if not game_timer_paused:
		game_timer_seconds += delta
	if not stage_timer_paused:
		stage_timer_seconds += delta

func PauseGameTimer() -> void:
	game_timer_paused = true

func UnpauseGameTimer() -> void:
	game_timer_paused = false

func PauseStageTimer() -> void:
	stage_timer_paused = true

func UnpauseStageTimer() -> void:
	stage_timer_paused = false
	
func ResetGameTime() -> void:
	game_timer_seconds = 0.0
	
func ResetStageTime() -> void:
	stage_timer_seconds = 0.0

func GetGameTime() -> String:
	var minutes := floorf(game_timer_seconds / 60.0)
	var seconds := roundf(fmod(game_timer_seconds, 60.0)) if not Settings.showDecimals \
		else roundf(fmod(game_timer_seconds, 60.0) * 1000.0) / 1000.0 # round to nearest thousandth
	
	var time := str(minutes)
	# account for leading zero in numbers less than 10 (e.g. 1:05)
	time += ":" if seconds >= 10 else ":0"
	time += str(seconds)
	
	return time

func GetStageTime() -> String:
	var minutes := floorf(stage_timer_seconds / 60.0)
	var seconds := roundf(fmod(stage_timer_seconds, 60.0)) if not Settings.showDecimals \
		else roundf(fmod(stage_timer_seconds, 60.0) * 1000.0) / 1000.0 # round to nearest thousandth
	
	var time := str(minutes)
	# account for leading zero in numbers less than 10 (e.g. 1:05)
	time += ":" if seconds >= 10 else ":0"
	time += str(seconds)
	
	return time
