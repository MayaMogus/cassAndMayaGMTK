extends Control

var buttons: Array[Node]

func _ready() -> void:
	buttons = $ButtonsMargins/Buttons.get_children()
	$Animations/AnimatedSprite2D.play('default')
	
	# automatically set neighbors for all buttons, as well as their base_node property if it exists
	for i in range(buttons.size()):
		var current_button: Button = buttons[i]
		var previous_button_path := buttons[i-1].get_path()
		var next_button_path := buttons[(i+1) % buttons.size()].get_path()
		
		current_button.focus_neighbor_bottom = next_button_path
		current_button.focus_next = next_button_path
		
		current_button.focus_neighbor_top = previous_button_path
		current_button.focus_previous = previous_button_path
		
		if current_button.has_method("SetBaseNode"):
			current_button.SetBaseNode(self)
	
	# focus on the first button
	buttons[0].grab_focus()


func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_back"):
		$ButtonsMargins/Buttons/QuitButton._pressed()

func SetControl(enable: bool, select_button: Button = null) -> void:
	if enable:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_ALL
		if select_button:
			select_button.grab_focus()
	else:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_NONE
	
func startCutscene():
	$ButtonsMargins.visible = false
	$TitleMargins/Title.visible = false
	await get_tree().create_timer(2).timeout
	$Animations/AnimatedSprite2D.visible = false
	$Background.material.set_shader_parameter("speedY", 0.5)
	$Animations/FallingTony.visible = true
	$fallingSound.volume_linear = Settings.SoundFXLevel
	$fallingSound.play()
	
func goToIntro():
	await get_tree().create_timer(2).timeout
	StageLoader.loadNextStage()
	MusicController.musicTimer = $Music.get_playback_position()
	
func _process(delta: float) -> void:
	$Music.volume_linear = Settings.MusicLevel

	if $Animations/FallingTony.visible == true:
		
		$Animations/FallingTony.global_position.y += delta * 500
	if $Animations/FallingTony.global_position.y > 1200:
		$BlackFade.self_modulate.a = lerp($BlackFade.self_modulate.a, 1.0, delta * 5)
		
	if $BlackFade.self_modulate.a >= .8:
		
		goToIntro()


func _on_play_button_pressed() -> void:
	if Info.current_stage == 0:
		startCutscene()
	else:
		Info.LoadNextStage()
