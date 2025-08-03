extends Control

@onready var base_node: Control = $".."
var source_button: Button

func _ready() -> void:
	base_node.SetControl(false)
	get_node("ControlsPanelMargins/ControlsPanel/ControlsTabs/" + \
		"Controller/MarginContainer/ScrollContainer/List/Up").grab_focus()

func SetSourceButton(button: Button) -> void:
	source_button = button

func _on_close_button_pressed() -> void:
	ExitMenu()

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_back"):
		ExitMenu()

func ExitMenu():
	base_node.SetControl(true, source_button)
	queue_free()

#------------------------------------------------------------------------------#
