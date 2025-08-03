extends Control




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$TimerContainer/GameTimerContainer/Label.text = GameTimer.GetGameTime()
	$TimerContainer/StageTimerContainer/Label.text = GameTimer.GetStageTime()
	
	var splitsText :String=''
	var index := 0
	for stageInfo in Info.stage_info:
		splitsText += str(Info.stage_names[index], ':', stageInfo.current_time, '\n')
		index += 1
	$"../Splits/SplitsContainer/Label".text
