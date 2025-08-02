extends Control


func _on_button_pressed() -> void:
	StageLoader.loadNextStage()


func _on_settings_button_pressed() -> void:
	$settingsMenu.visible = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('pause'):
		$settingsMenu.visible = false
