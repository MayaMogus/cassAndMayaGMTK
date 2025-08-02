extends Control


func _ready() -> void:

	$settingsMenu.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_settings_button_pressed() -> void:
	$settingsMenu.visible = true
	playSound()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('pause'):
		if visible:
			if $settingsMenu.visible == true:
				$settingsMenu.visible = false
			if $ControlPage.visible == true:
				$ControlPage.visible = false
			else:
				
				$"..".call_deferred('unPause')
				


func _on_control_button_pressed() -> void:
	$ControlPage.visible = true
	playSound()
	
func _process(delta: float) -> void:
	if visible:
		if $ControlPage.visible == true or $settingsMenu.visible == true:
			$settingsButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$controlButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$backButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			$settingsButton.mouse_filter = Control.MOUSE_FILTER_STOP
			$controlButton.mouse_filter = Control.MOUSE_FILTER_STOP
			$backButton.mouse_filter = Control.MOUSE_FILTER_STOP
			
func playSound():
	$AudioStreamPlayer.volume_linear = Settings.SoundFXLevel
	$AudioStreamPlayer.play()


func _on_back_button_pressed() -> void:
	playSound()
	$"..".call_deferred('unPause')
