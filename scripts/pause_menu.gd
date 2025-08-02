extends Control


func _ready() -> void:
	$settingsMenu/VBoxContainer/SoundFX/SoundFXSlider.value = Settings.SoundFXLevel
	$settingsMenu/VBoxContainer/Music/MusicSlider.value = Settings.MusicLevel
	$settingsMenu.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$settingsMenu/VBoxContainer/SoundFX/SoundFXValue.text = str(Settings.SoundFXLevel)
	$settingsMenu/VBoxContainer/Music/MusicValue.text = str(Settings.MusicLevel)

func _on_settings_button_pressed() -> void:
	$settingsMenu.visible = true
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('pause'):
		if visible:
			if $settingsMenu.visible == true:
				$settingsMenu.visible = false
			else:
				print('???')
				$"..".call_deferred('unPause')
				


func _on_sound_fx_slider_value_changed(value: float) -> void:
	Settings.SoundFXLevel = value


func _on_music_slider_value_changed(value: float) -> void:
	Settings.MusicLevel = value
