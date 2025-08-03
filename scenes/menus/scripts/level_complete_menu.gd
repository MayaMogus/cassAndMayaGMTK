extends Control

@onready var game_timer := get_node("InnerMargins/PanelContainer" + \
	"/TimerContainer/GameTimerContainer/GameTimer")
@onready var stage_timer := get_node("InnerMargins/PanelContainer" + \
	"/TimerContainer/StageTimerContainer/StageTimer")

@onready var timer_container := get_node("InnerMargins/PanelContainer" + \
	"/TimerContainer")

var buttons: Array[Node]

func _ready() -> void:
	Info.SetStageInfo(Info.current_stage, GameTimer.stage_timer_seconds, 0) # TODO: set deaths
	
	buttons = get_node("InnerMargins/PanelContainer" + \
	"/ButtonMargins/ButtonContainer").get_children()
	
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
	
	Settings.inMenu = true
	GameTimer.PauseStageTimer()
	GameTimer.PauseGameTimer()
	
	stage_timer.text = GameTimer.GetStageTime()

func _on_continue_button_pressed() -> void:
	Info.LoadNextStage()

func _on_main_menu_button_pressed() -> void:
	GameTimer.ResetGameTime()
	GameTimer.ResetStageTime()
	
	KeyGlobalController.savedKeys.clear()
	
	get_tree().change_scene_to_packed(preload("res://scenes/menus/main_menu.tscn"))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_back"):
		_on_main_menu_button_pressed()

func SetControl(enable: bool, select_button: Button = null) -> void:
	if enable:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_ALL
		if select_button:
			select_button.grab_focus()
	else:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_NONE
