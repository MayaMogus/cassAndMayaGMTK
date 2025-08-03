extends Node2D

var timer :float=0.5
var playing : bool = false
func _ready() -> void:
	$Animation.frame = 17
func shake(reverse:bool):
	
	$AudioStreamPlayer.play()
	$AudioStreamPlayer.volume_linear = Settings.SoundFXLevel * 0.5
	playing = true
	if reverse:
		$Animation.play_backwards("default")
	else:
			$Animation.play("default")
			
func _process(delta: float) -> void:
	if playing:
		timer -= delta
		if timer < 0:
			if $Animation.frame == 17:
				$Animation.stop()
				$Animation.frame = 17
				timer = .5
				playing = false
