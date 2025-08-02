extends Node2D


func _on_button_pressed() -> void:
	StageLoader.loadNextStage()
	MusicController.musicTimer = $AudioStreamPlayer.get_playback_position()

func _on_settings_button_pressed() -> void:
	$settingsMenu.visible = true

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('pause'):
		$settingsMenu.visible = false
		$ControlPage.visible = false
		
func _on_control_button_pressed() -> void:
	$ControlPage.visible = true
	
func _process(delta: float) -> void:
	$AudioStreamPlayer.volume_linear = Settings.MusicLevel
	if $ControlPage.visible == true or $settingsMenu.visible == true:
		$settingsButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$controlButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		$settingsButton.mouse_filter = Control.MOUSE_FILTER_STOP
		$controlButton.mouse_filter = Control.MOUSE_FILTER_STOP
