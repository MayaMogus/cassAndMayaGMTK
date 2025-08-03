extends Control

@onready var base_node: Control = $".."
var source_button: Button

func _ready() -> void:
	base_node.SetControl(false)
	get_node("SettingsPanelMargins/SettingsPanel/SettingsTabs/" + \
		"General/SettingsMargins/Settings/ShowTimer/CheckBox").grab_focus()

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

#==============================================================================#

func _on_show_stage_timer_toggled(toggled_on: bool) -> void:
	Settings.displayStageTimer = toggled_on

func _on_show_game_timer_toggled(toggled_on: bool) -> void:
	Settings.displayGameTimer = toggled_on

#------------------------------------------------------------------------------#

func _on_show_decimals_toggled(toggled_on: bool) -> void:
	Settings.displayDecimals = toggled_on

func _on_auto_next_stage_toggled(toggled_on: bool) -> void:
	Settings.autoNextStage = toggled_on

#==============================================================================#

func _on_fx_volume_toggled(toggled_on: bool) -> void:
	Settings.SoundFXEnabled = toggled_on

func _on_fx_volume_drag_ended(value_changed: bool) -> void:
	Settings.SoundFXLevel = value_changed

#------------------------------------------------------------------------------#

func _on_music_volume_toggled(toggled_on: bool) -> void:
	Settings.MusicEnabled = toggled_on

func _on_music_volume_drag_ended(value_changed: bool) -> void:
	Settings.MusicLevel = value_changed

#==============================================================================#
