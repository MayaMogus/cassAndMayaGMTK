extends Control

@onready var game_timer := get_node("PausePanelMargins/PausePanel/InnerMargins/PanelContainer" + \
	"/TimerContainer/GameTimerContainer/GameTimer")
@onready var stage_timer := get_node("PausePanelMargins/PausePanel/InnerMargins/PanelContainer" + \
	"/TimerContainer/StageTimerContainer/StageTimer")

@onready var timer_container := get_node("PausePanelMargins/PausePanel/InnerMargins/PanelContainer" + \
	"/TimerContainer")

var buttons: Array[Node]

func _ready() -> void:
	buttons = get_node("PausePanelMargins/PausePanel/InnerMargins/PanelContainer" + \
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
	
	stage_timer.text = GameTimer.GetStageTime()

func _process(delta: float) -> void:
	# updates every frame since game timer doesn't pause
	if Settings.displayGameTimer:
		game_timer.text = GameTimer.GetGameTime()
	
	# updates every frame in case settings are changed
	if not (Settings.displayGameTimer or Settings.displayStageTimer):
		timer_container.hide()
	else:
		timer_container.show()
		
		if Settings.displayGameTimer:
			timer_container.get_node("GameTimerContainer").show()
		else:
			timer_container.get_node("GameTimerContainer").hide()
		
		if Settings.displayStageTimer:
			timer_container.get_node("StageTimerContainer").show()
		else:
			timer_container.get_node("StageTimerContainer").hide()

func _on_resume_button_pressed() -> void:
	ExitMenu()

func _on_main_menu_button_pressed() -> void:
	GameTimer.PauseGameTimer()
	
	GameTimer.ResetGameTime()
	GameTimer.ResetStageTime()
	
	KeyGlobalController.savedKeys.clear()
	
	get_tree().change_scene_to_packed(preload("res://scenes/menus/main_menu.tscn"))

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_back"):
		ExitMenu()

func ExitMenu():
	Settings.inMenu = false
	GameTimer.UnpauseStageTimer()
	$"../Player".unPause()
	queue_free()

func SetControl(enable: bool, select_button: Button = null) -> void:
	if enable:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_ALL
		if select_button:
			select_button.grab_focus()
	else:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_NONE
