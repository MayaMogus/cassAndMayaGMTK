extends Node2D

var tutorialEnd : bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player.lockedControls = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not tutorialEnd:
		$Player/blackFade.self_modulate.a = lerp($Player/blackFade.self_modulate.a, 0.0, delta  )
		if $Player.global_position.y > 320:
			$Player.paused = true
			$Player.freeze = true
			$Player.saved_velocity_paused = $Player.linear_velocity
		
			if Input.is_action_just_pressed("attach_rope"):
				print('WEEE')
				$Player.unPause()
				$Player.CreateRope(500)
				$Player.lockedControls = false
				tutorialEnd = true
			
