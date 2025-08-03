extends Control

func _ready() -> void:
	$AnimatedSprite2D.play("default")
func _on_button_pressed() -> void:
	startCutscene()

func _on_settings_button_pressed() -> void:
	$settingsMenu.visible = true
	playSound()
	
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed('pause'):
		$settingsMenu.visible = false
		$ControlPage.visible = false
		
func _on_control_button_pressed() -> void:
	$ControlPage.visible = true
	playSound()
	
func _process(delta: float) -> void:
	$AudioStreamPlayer.volume_linear = Settings.MusicLevel
	if $ControlPage.visible == true or $settingsMenu.visible == true:
		$Buttons/settingsButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
		$Buttons/controlButton.mouse_filter = Control.MOUSE_FILTER_IGNORE
	else:
		$Buttons/settingsButton.mouse_filter = Control.MOUSE_FILTER_STOP
		$Buttons/controlButton.mouse_filter = Control.MOUSE_FILTER_STOP
	
	if $FallingTony.visible == true:
		
		$FallingTony.global_position.y += delta * 500
	if $FallingTony.global_position.y > 1200:
		$blackFade.self_modulate.a = lerp($blackFade.self_modulate.a, 1.0, delta * 5)
		
	if $blackFade.self_modulate.a >= .8:
		goToIntro()
		
func playSound():
	$AudioStreamPlayer2.volume_linear = Settings.SoundFXLevel
	$AudioStreamPlayer2.play()
	
func startCutscene():
	
	$settingsButton.visible = false
	$controlButton.visible = false
	$Button.visible = false
	$Label.visible = false
	await get_tree().create_timer(2).timeout
	$AnimatedSprite2D.visible = false
	$background.material.set_shader_parameter("speedY", 0.5)
	$FallingTony.visible = true
	$fallingSound.play()
func goToIntro():
	await get_tree().create_timer(2).timeout
	StageLoader.loadNextStage()
	MusicController.musicTimer = $AudioStreamPlayer.get_playback_position()
