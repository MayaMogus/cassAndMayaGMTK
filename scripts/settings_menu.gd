extends Control

func _process(delta: float) -> void:
	$VBoxContainer/SoundFX/SoundFXValue.text = str(Settings.SoundFXLevel * 100)
	$VBoxContainer/Music/MusicValue.text = str(Settings.MusicLevel * 100)
	$VBoxContainer/SoundFX/SoundFXSlider.value = (Settings.SoundFXLevel * 100)
	$VBoxContainer/Music/MusicSlider.value = (Settings.MusicLevel * 100)
	$VBoxContainer/Control/CheckBox.button_pressed = Settings.displayTimer


func _on_sound_fx_slider_value_changed(value: float) -> void:
	Settings.SoundFXLevel = value / 100


func _on_music_slider_value_changed(value: float) -> void:
	Settings.MusicLevel = value / 100


func _on_check_box_toggled(toggled_on: bool) -> void:
	print(toggled_on)
	


func _on_check_box_pressed() -> void:
	print(Settings.displayTimer)
	if Settings.displayTimer == false:
		Settings.displayTimer = true
		$VBoxContainer/Control/CheckBox.button_pressed = true
	else:
		Settings.displayTimer = false
		$VBoxContainer/Control/CheckBox.button_pressed = false
	print(Settings.displayTimer)


func _on_back_button_pressed() -> void:
	visible = false
