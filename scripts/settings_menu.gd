extends Control

func _process(delta: float) -> void:
	$VBoxContainer/SoundFX/SoundFXValue.text = str(Settings.SoundFXLevel * 100)
	$VBoxContainer/Music/MusicValue.text = str(Settings.MusicLevel * 100)
	$VBoxContainer/SoundFX/SoundFXSlider.value = (Settings.SoundFXLevel * 100)
	$VBoxContainer/Music/MusicSlider.value = (Settings.MusicLevel * 100)



func _on_sound_fx_slider_value_changed(value: float) -> void:
	Settings.SoundFXLevel = value / 100
	playSound()

func _on_music_slider_value_changed(value: float) -> void:
	Settings.MusicLevel = value / 100
	

func _on_check_box_toggled(toggled_on: bool) -> void:
	playSound()


func _on_check_box_pressed() -> void:
	if Settings.displayTimer == false:
		Settings.displayTimer = true
		$VBoxContainer/Control/CheckBox.button_pressed = true
	else:
		Settings.displayTimer = false
		$VBoxContainer/Control/CheckBox.button_pressed = false
	playSound()

func _on_back_button_pressed() -> void:
	visible = false
	playSound()
	
func playSound():
	$AudioStreamPlayer.volume_linear = Settings.SoundFXLevel
	$AudioStreamPlayer.play()
