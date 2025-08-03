extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var splitsText : String
	var index := 0
	for stageInfo in Info.stage_info:
		splitsText += str(Info.stage_names[index], ' : ', stageInfo.current_time, ' - DEATHS : ', stageInfo.current_deaths, '\n')
		index += 1
	$ScrollContainer/Splits.text = splitsText
	$Time.text = GameTimer.GetGameTime()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$FadeWhite.modulate.a = lerp($FadeWhite.modulate.a, 0.0, delta)
	


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(preload("res://scenes/menus/main_menu.tscn"))
	Info.current_stage = 0
