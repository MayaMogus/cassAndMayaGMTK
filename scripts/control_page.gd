extends Control




func _on_back_button_pressed() -> void:
	visible = false
	playSound()

func playSound():
	$AudioStreamPlayer.volume_linear = Settings.MusicLevel
	$AudioStreamPlayer.play()
