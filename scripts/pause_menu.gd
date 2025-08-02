extends Control


func _ready() -> void:

	$settingsMenu.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.


func _on_settings_button_pressed() -> void:
	$settingsMenu.visible = true
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('pause'):
		if visible:
			if $settingsMenu.visible == true:
				$settingsMenu.visible = false
			if $ControlPage.visible == true:
				$ControlPage.visible = false
			else:
				print('???')
				$"..".call_deferred('unPause')
				


func _on_control_button_pressed() -> void:
	$ControlPage.visible = true

func _process(delta: float) -> void:
	if visible:
		if $ControlPage.visible == true or $settingsMenu.visible == true:
			$settingsButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
			$controlButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		else:
			$settingsButton.mouse_filter = Control.MOUSE_FILTER_STOP
			$controlButton.mouse_filter = Control.MOUSE_FILTER_STOP
