extends Control

@onready var base_node: Control = $".."
var source_button: Button

func _ready() -> void:
	base_node.SetControl(false)
	$QuitPanelMargins/QuitPanel/MarginContainer/VBoxContainer/HBoxContainer/Confirm.grab_focus()

func SetSourceButton(button: Button) -> void:
	source_button = button

func _on_confirm_pressed() -> void:
	get_tree().quit()
	# TODO: make a save/load function

func _on_cancel_pressed() -> void:
	ExitMenu()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_back"):
		ExitMenu()

func ExitMenu():
	base_node.SetControl(true, source_button)
	queue_free()

#------------------------------------------------------------------------------#
