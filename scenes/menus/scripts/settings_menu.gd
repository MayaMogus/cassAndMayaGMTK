extends Control

@onready var base_node: Control = $".."
var source_button: Button

func _ready() -> void:
	base_node.SetControl(false)
	get_node("SettingsPanelMargins/SettingsPanel/SettingsTabs/" + \
		"General/SettingsMargins/Settings/ShowTimer/OptionButton").grab_focus()

func SetSourceButton(button: Button) -> void:
	source_button = button

func _on_close_button_pressed() -> void:
	ExitMenu()

func _input(event: InputEvent) -> void:
	if event.is_action("ui_back"):
		ExitMenu()

func ExitMenu():
	base_node.SetControl(true, source_button)
	queue_free()

#------------------------------------------------------------------------------#

func _on_show_timer_toggled(toggled_on: bool) -> void:
	Settings.displayTimer = toggled_on

#------------------------------------------------------------------------------#

func _on_fx_volume_toggled(toggled_on: bool) -> void:
	Settings.SoundFXEnabled = toggled_on

func _on_fx_volume_drag_ended(value_changed: bool) -> void:
	Settings.SoundFXLevel = value_changed

#------------------------------------------------------------------------------#

func _on_music_volume_toggled(toggled_on: bool) -> void:
	Settings.MusicEnabled = toggled_on

func _on_music_volume_drag_ended(value_changed: bool) -> void:
	Settings.MusicLevel = value_changed


func _on_option_button_item_selected(index: int) -> void:
	if index == 0:
		Settings.displayRunTimer = true
		Settings.displaySplits = false
		Settings.displayStageTimer = false
	elif index == 1:
		Settings.displayStageTimer = true
		Settings.displaySplits = false
		Settings.displayRunTimer = false
	elif index == 2:
		Settings.displaySplits = true
		Settings.displayRunTimer = false
		Settings.displayStageTimer = false
	elif index == 3:
		Settings.displaySplits = false
		Settings.displayRunTimer = false
		Settings.displayStageTimer = false
