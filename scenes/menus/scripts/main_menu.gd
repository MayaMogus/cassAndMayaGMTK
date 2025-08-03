extends Control

var buttons: Array[Node]

func _ready() -> void:
	buttons = $ButtonsMargins/Buttons.get_children()
	
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

func SetControl(enable: bool, select_button: Button = null) -> void:
	if enable:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_ALL
		if select_button:
			select_button.grab_focus()
	else:
		for button: Button in buttons:
			button.focus_mode = Control.FOCUS_NONE
